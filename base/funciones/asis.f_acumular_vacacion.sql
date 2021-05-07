CREATE OR REPLACE FUNCTION asis.f_acumular_vacacion (
    p_id_funcionario integer = NULL::integer
)
    RETURNS void AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.f_centro_validar
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.f_centro_validar'
 AUTOR: 		 MMV Kplian
 FECHA:	        31-01-2019 16:36:51
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				31-01-2019 16:36:51								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.tmes_trabajo_det'
 ***************************************************************************/
DECLARE
    v_resp                      			varchar;
    v_nombre_funcion            			text;
    v_funcionario						record;
    v_record_ultima_vacacion				record;
    v_fecha_acomulado					date;
    v_record_tiempo						record;
    v_dias_incremento_vacacion			numeric;
    v_id_gestion_actual					integer;
    v_id_movimiento						integer;


BEGIN
    v_nombre_funcion = 'asis.f_acumular_vacacion';


    SELECT g.id_gestion
    INTO
        v_id_gestion_actual
    FROM param.tgestion g
    WHERE now() BETWEEN g.fecha_ini and g.fecha_fin;

    for v_funcionario in (select f.id_funcionario,
                                 uf.fecha_asignacion,
                                 UF.fecha_finalizacion,
                                 tc.nombre,tc.codigo
                          from orga.tfuncionario f
                                   join orga.tuo_funcionario uf on uf.id_funcionario=f.id_funcionario
                                   join orga.tcargo c on c.id_cargo=uf.id_cargo
                                   join orga.ttipo_contrato tc on tc.id_tipo_contrato=c.id_tipo_contrato
                              and tc.codigo in ('PLA','EVE')
                          where uf.fecha_asignacion <= now() and coalesce(uf.fecha_finalizacion, now())>=now()
                            and uf.estado_reg = 'activo' and uf.tipo = 'oficial' and
                              (case
                                   when p_id_funcionario is not null then
                                           f.id_funcionario = p_id_funcionario
                                   else
                                           0 = 0
                                  end)
                          order by fecha_asignacion )loop

            IF EXISTS(with antiguedad AS (SELECT mv.id_funcionario,
                                                 (age(now()::date,mv.fecha_reg::date))::varchar as tiempo_transcurrido,
                                                 mv.fecha_reg
                                          FROM asis.tmovimiento_vacacion mv
                                          WHERE mv.tipo='ACUMULADA'
                                            AND mv.id_funcionario = v_funcionario.id_funcionario
                                            AND mv.estado_reg = 'activo'
                                          ORDER BY mv.fecha_reg DESC LIMIT 1 )
                      SELECT a.id_funcionario,
                             a.tiempo_transcurrido,
                             a.fecha_reg
                      from antiguedad a
                      where a.tiempo_transcurrido like '%year%' )THEN


                WITH antiguedad AS (SELECT  mv.id_funcionario,
                                            (age(now()::date,mv.fecha_reg::date))::varchar as tiempo_transcurrido,
                                            (age(now()::date,v_funcionario.fecha_asignacion::date))::varchar as tiempo_antiguedad,
                                            mv.fecha_reg,
                                            mv.id_movimiento_vacacion
                                    FROM asis.tmovimiento_vacacion mv
                                    WHERE mv.tipo='ACUMULADA'
                                      AND mv.id_funcionario = v_funcionario.id_funcionario
                                      AND mv.estado_reg = 'activo'
                                    ORDER BY mv.fecha_reg ASC LIMIT 1 )
                SELECT a.id_funcionario,
                       a.tiempo_transcurrido,
                       a.tiempo_antiguedad,
                       a.fecha_reg,
                       a.id_movimiento_vacacion
                INTO
                    v_record_ultima_vacacion
                FROM antiguedad a
                WHERE a.tiempo_transcurrido LIKE '%year%';


                SELECT mv.fecha_reg::date into v_fecha_acomulado
                FROM asis.tmovimiento_vacacion mv
                WHERE mv.tipo='ACUMULADA'
                  AND mv.id_funcionario = v_funcionario.id_funcionario
                  AND mv.estado_reg = 'activo'
                ORDER BY mv.fecha_reg DESC LIMIT 1;

                with dias as(SELECT
                                 SPLIT_PART(v_record_ultima_vacacion.tiempo_transcurrido, 'year', 1) AS anios_pasado,
                                 SPLIT_PART(v_record_ultima_vacacion.tiempo_transcurrido, 'year', 1) AS anios_antiguedad,
                                 (v_fecha_acomulado::date+'1 year'::interval)::date as nueva_fecha,
                                 (select m.dias_actual
                                  from asis.tmovimiento_vacacion m
                                  where m.id_funcionario = v_funcionario.id_funcionario
                                    and m.estado_reg = 'activo' and m.activo = 'activo')::numeric as dias_actual )
                SELECT d.anios_pasado,
                       d.anios_antiguedad,
                       d.nueva_fecha,
                       d.dias_actual
                INTO
                    v_record_tiempo
                FROM dias d;

                SELECT a.dias_asignados INTO v_dias_incremento_vacacion
                FROM param.tantiguedad a
                WHERE a.id_gestion=v_id_gestion_actual
                  AND (v_record_tiempo.anios_antiguedad::INTEGER BETWEEN a.desde_anhos AND a.hasta_anhos );

                raise notice 'si';
                INSERT INTO asis.tmovimiento_vacacion ( id_funcionario,
                                                        desde,
                                                        hasta,
                                                        dias_actual,
                                                        activo,
                                                        dias,
                                                        tipo,
                                                        id_usuario_reg,
                                                        fecha_reg,
                                                        estado_reg,
                                                        obs_dba
                )VALUES(
                           v_funcionario.id_funcionario,
                           NULL,
                           NULL,(
                                   v_record_tiempo.dias_actual+v_dias_incremento_vacacion)::NUMERIC,
                           'activo',
                           v_dias_incremento_vacacion::NUMERIC,
                           'ACUMULADA',
                           1,
                           v_record_tiempo.nueva_fecha::TIMESTAMP,
                           'activo',
                           'acumulada');

                select m.id_movimiento_vacacion into  v_id_movimiento
                from asis.tmovimiento_vacacion m
                where m.id_funcionario = v_funcionario.id_funcionario
                  and m.estado_reg = 'activo' and m.activo = 'activo';


                UPDATE asis.tmovimiento_vacacion
                SET activo = 'inactivo'
                WHERE id_movimiento_vacacion = v_id_movimiento
                  AND estado_reg = 'activo';

                -- Recalcular
                PERFORM asis.f_recalcular_vacacion(v_funcionario.id_funcionario);

            ELSE
                IF NOT EXISTS (SELECT *
                               FROM asis.tmovimiento_vacacion mv
                               where mv.id_funcionario = v_funcionario.id_funcionario
                                 and mv.estado_reg = 'activo')THEN

                    update asis.tmovimiento_vacacion set
                        activo = 'inactivo'
                    where id_funcionario = v_funcionario.id_funcionario;

                    INSERT INTO asis.tmovimiento_vacacion ( id_funcionario,
                                                            desde,
                                                            hasta,
                                                            dias_actual,
                                                            activo,
                                                            dias,
                                                            tipo,
                                                            id_usuario_reg,
                                                            fecha_reg,
                                                            estado_reg,
                                                            obs_dba )
                    VALUES (v_funcionario.id_funcionario,
                            NULL,
                            NULL,
                            0::NUMERIC,
                            'activo',
                            0::NUMERIC,
                            'ACUMULADA',
                            1,
                            v_funcionario.fecha_asignacion,
                            'activo',
                            'cero');
                END IF;

            END IF;

        end loop;

EXCEPTION
    WHEN OTHERS THEN
        v_resp='';
        v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
        v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
        v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
        raise exception '%',v_resp;
END;
$body$
    LANGUAGE 'plpgsql'
    VOLATILE
    CALLED ON NULL INPUT
    SECURITY INVOKER
    PARALLEL UNSAFE
    COST 100;

ALTER FUNCTION asis.f_acumular_vacacion (p_id_funcionario integer)
    OWNER TO postgres;