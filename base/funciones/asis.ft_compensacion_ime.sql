CREATE OR REPLACE FUNCTION asis.ft_compensacion_ime (
    p_administrador integer,
    p_id_usuario integer,
    p_tabla varchar,
    p_transaccion varchar
)
    RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:        Sistema de Asistencia
 FUNCION:         asis.ft_compensacion_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.tcompensacion'
 AUTOR:          (amamani)
 FECHA:            18-05-2021 14:14:39
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE                FECHA                AUTOR                DESCRIPCION
 #0                18-05-2021 14:14:39    amamani             Creacion
 #
 ***************************************************************************/

DECLARE

    v_parametros        RECORD;
    v_resp              VARCHAR;
    v_nombre_funcion    TEXT;
    v_id_compensacion   INTEGER;
    v_lugar             VARCHAR;
    v_mensaje           VARCHAR;
    v_fecha_aux         DATE;
    v_valor_incremento  VARCHAR;
    v_id_gestion_actual INTEGER;
    v_cant_dias         NUMERIC=0;
    v_incremento_fecha  DATE;
    v_domingo           INTEGER = 0;
    v_sabado            INTEGER = 6;
    v_id_gestion        INTEGER;
    v_codigo_proceso    VARCHAR;
    v_id_macro_proceso  INTEGER;
    v_nro_tramite       VARCHAR;
    v_id_proceso_wf     INTEGER;
    v_id_estado_wf      INTEGER;
    v_codigo_estado     VARCHAR;
    v_record_det        RECORD;
    v_registro_estado   RECORD;
    v_compensacion      RECORD;
    va_id_tipo_estado   INTEGER[];
    va_codigo_estado    VARCHAR[];
    va_disparador       VARCHAR[];
    va_regla            VARCHAR[];
    va_prioridad        INTEGER[];
    v_acceso_directo    VARCHAR;
    v_clase             VARCHAR;
    v_parametros_ad     VARCHAR;
    v_tipo_noti         VARCHAR;
    v_titulo            VARCHAR;
    v_estado_record     RECORD;
    v_id_estado_maestro INTEGER;
    v_estado_maestro    VARCHAR;
    v_id_estado_actual  INTEGER;

BEGIN

    v_nombre_funcion = 'asis.ft_compensacion_ime';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
     #TRANSACCION:  'ASIS_CPM_INS'
     #DESCRIPCION:    Insercion de registros
     #AUTOR:        amamani
     #FECHA:        18-05-2021 14:14:39
    ***********************************/

    IF (p_transaccion = 'ASIS_CPM_INS') THEN

        BEGIN

            --raise exception 'engt';
            select g.id_gestion
            into
                v_id_gestion
            from param.tgestion g
            where g.gestion = EXTRACT(YEAR FROM current_date);

            --obtener el proceso
            select tp.codigo,
                   pm.id_proceso_macro
            into
                v_codigo_proceso,
                v_id_macro_proceso
            from wf.tproceso_macro pm
                     inner join wf.ttipo_proceso tp on tp.id_proceso_macro = pm.id_proceso_macro
            where pm.codigo = 'LPC'
              and tp.estado_reg = 'activo'
              and tp.inicio = 'si';

            SELECT ps_num_tramite,
                   ps_id_proceso_wf,
                   ps_id_estado_wf,
                   ps_codigo_estado
            into
                v_nro_tramite,
                v_id_proceso_wf,
                v_id_estado_wf,
                v_codigo_estado
            FROM wf.f_inicia_tramite(
                    p_id_usuario,
                    v_parametros._id_usuario_ai,
                    v_parametros._nombre_usuario_ai,
                    v_id_gestion,
                    v_codigo_proceso,
                    v_parametros.id_funcionario,
                    null,
                    'Vacaciones',
                    v_codigo_proceso);

            --Sentencia de la insercion
            INSERT INTO asis.tcompensacion(estado_reg,
                                           id_funcionario,
                                           id_responsable,
                                           desde,
                                           hasta,
                                           dias,
                                           desde_comp,
                                           hasta_comp,
                                           dias_comp,
                                           justificacion,
                                           id_usuario_reg,
                                           fecha_reg,
                                           id_usuario_ai,
                                           usuario_ai,
                                           id_usuario_mod,
                                           fecha_mod,
                                           id_procesos_wf,
                                           id_estado_wf,
                                           estado,
                                           nro_tramite)
            VALUES ('activo',
                    v_parametros.id_funcionario,
                    v_parametros.id_responsable,
                    v_parametros.desde,
                    v_parametros.hasta,
                    v_parametros.dias,
                    null, --v_parametros.desde_comp,
                    null, --v_parametros.hasta_comp,
                    0, --v_parametros.dias_comp,
                    v_parametros.justificacion,
                    p_id_usuario,
                    now(),
                    v_parametros._id_usuario_ai,
                    v_parametros._nombre_usuario_ai,
                    null,
                    null,
                    v_id_proceso_wf,
                    v_id_estado_wf,
                    v_codigo_estado,
                    v_nro_tramite)
            RETURNING id_compensacion into v_id_compensacion;


            FOR v_record_det IN (select dia::date as dia
                                 from generate_series(v_parametros.desde, v_parametros.hasta,
                                                      '1 day'::interval) dia)
                LOOP
                    IF (select extract(dow from v_record_det.dia::date) in (v_sabado, v_domingo)) THEN


                        INSERT INTO asis.tcompensacion_det(estado_reg,
                                                           fecha,
                                                           id_compensacion,
                                                           tiempo,
                                                           id_usuario_reg,
                                                           fecha_reg,
                                                           id_usuario_ai,
                                                           usuario_ai,
                                                           id_usuario_mod,
                                                           fecha_mod,
                                                           obs_dba)
                        VALUES ('activo',
                                v_record_det.dia,
                                v_id_compensacion,
                                (case
                                     when extract(dow from v_record_det.dia::date) = v_sabado then
                                         'tarde'
                                     else
                                         'completo'
                                    end ),
                                p_id_usuario,
                                now(),
                                v_parametros._id_usuario_ai,
                                v_parametros._nombre_usuario_ai,
                                null,
                                null,
                                extract(dow from v_record_det.dia::date));


                    END IF;
                END LOOP;
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp, 'mensaje',
                                        'Compensacion almacenado(a) con exito (id_compensacion' || v_id_compensacion ||
                                        ')');
            v_resp = pxp.f_agrega_clave(v_resp, 'id_compensacion', v_id_compensacion::varchar);

            --Devuelve la respuesta
            RETURN v_resp;

        END;

        /*********************************
         #TRANSACCION:  'ASIS_CPM_MOD'
         #DESCRIPCION:    Modificacion de registros
         #AUTOR:        amamani
         #FECHA:        18-05-2021 14:14:39
        ***********************************/

    ELSIF (p_transaccion = 'ASIS_CPM_MOD') THEN

        BEGIN
            --Sentencia de la modificacion
            UPDATE asis.tcompensacion
            SET id_funcionario = v_parametros.id_funcionario,
                id_responsable = v_parametros.id_responsable,
                desde          = v_parametros.desde,
                hasta          = v_parametros.hasta,
                dias           = v_parametros.dias,
                desde_comp     = v_parametros.desde_comp,
                hasta_comp     = v_parametros.hasta_comp,
                dias_comp      = v_parametros.dias_comp,
                justificacion  = v_parametros.justificacion,
                id_usuario_mod = p_id_usuario,
                fecha_mod      = now(),
                id_usuario_ai  = v_parametros._id_usuario_ai,
                usuario_ai     = v_parametros._nombre_usuario_ai
            WHERE id_compensacion = v_parametros.id_compensacion;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'Compensacion modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp, 'id_compensacion', v_parametros.id_compensacion::varchar);

            --Devuelve la respuesta
            RETURN v_resp;

        END;

        /*********************************
         #TRANSACCION:  'ASIS_CPM_ELI'
         #DESCRIPCION:    Eliminacion de registros
         #AUTOR:        amamani
         #FECHA:        18-05-2021 14:14:39
        ***********************************/

    ELSIF (p_transaccion = 'ASIS_CPM_ELI') THEN

        BEGIN
            --Sentencia de la eliminacion


            DELETE
            FROM asis.tcompensacion_det
            where id_compensacion = v_parametros.id_compensacion;


            DELETE
            FROM asis.tcompensacion
            WHERE id_compensacion = v_parametros.id_compensacion;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'Compensacion eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp, 'id_compensacion', v_parametros.id_compensacion::varchar);

            --Devuelve la respuesta
            RETURN v_resp;

        END;
        /*********************************
            #TRANSACCION:  'ASIS_CMP_DAT'
            #DESCRIPCION:	VALIDACION DE DATOS VACACIÓN.
            #AUTOR:		MMV
            #FECHA:		18-05-2021
           ***********************************/

    elsif (p_transaccion = 'ASIS_CMP_DAT') then

        begin
            select l.codigo
            into v_lugar
            from segu.tusuario us
                     join segu.tpersona p on p.id_persona = us.id_persona
                     join orga.tfuncionario f on f.id_persona = p.id_persona
                     join orga.tuo_funcionario uf on uf.id_funcionario = f.id_funcionario
                     join orga.tcargo c on c.id_cargo = uf.id_cargo
                     join param.tlugar l on l.id_lugar = c.id_lugar
            where uf.estado_reg = 'activo'
              and uf.tipo = 'oficial'
              and uf.fecha_asignacion <= now()
              and coalesce(uf.fecha_finalizacion, now()) >= now()
              and us.id_usuario = p_id_usuario;

            --Sentencia de la insercion
            IF v_parametros.fecha_inicio::DATE > v_parametros.fecha_fin::DATE THEN
                v_mensaje = 'ERROR: FECHA INICIO MAYOR A FECHA FIN.';
            END IF;

            v_fecha_aux := v_parametros.fecha_inicio;
            v_valor_incremento := '1' || ' DAY';

            SELECT g.id_gestion
            INTO
                v_id_gestion_actual
            FROM param.tgestion g
            WHERE v_fecha_aux BETWEEN g.fecha_ini and g.fecha_fin;

            IF (v_parametros.fin_semana = 'si') THEN
                WHILE (SELECT (v_fecha_aux::date) <= v_parametros.fecha_fin::date)
                    LOOP
                        IF (select extract(dow from v_fecha_aux::date) not in (v_sabado, v_domingo)) THEN
                            IF NOT EXISTS(select *
                                          from param.tferiado f
                                                   JOIN param.tlugar l on l.id_lugar = f.id_lugar
                                          WHERE l.codigo in ('BO', v_lugar)
                                            AND (EXTRACT(MONTH from f.fecha))::integer =
                                                (EXTRACT(MONTH from v_fecha_aux::date))::integer
                                            AND (EXTRACT(DAY from f.fecha))::integer = (EXTRACT(DAY from v_fecha_aux))
                                            AND f.id_gestion = v_id_gestion_actual) THEN
                                v_cant_dias = v_cant_dias + 1;
                            END IF;
                        END IF;
                        v_incremento_fecha = v_fecha_aux::date + v_valor_incremento::INTERVAL;
                        v_fecha_aux := v_incremento_fecha;
                    END LOOP;
            ELSIF(v_parametros.fin_semana = 'fin_semana') THEN
                WHILE (SELECT (v_fecha_aux::date) <= v_parametros.fecha_fin::date)
                    LOOP
                        IF (select extract(dow from v_fecha_aux::date) in (v_sabado, v_domingo)) THEN
                            if (extract(dow from v_fecha_aux::date) = v_sabado)then
                                v_cant_dias = v_cant_dias + 0.5;
                            else
                                v_cant_dias = v_cant_dias + 1;
                            end if;

                        END IF;
                        v_incremento_fecha = v_fecha_aux::date + v_valor_incremento::INTERVAL;
                        v_fecha_aux := v_incremento_fecha;
                    END LOOP;
            ELSE
                WHILE (SELECT (v_fecha_aux::date) <= v_parametros.fecha_fin::date)
                    LOOP
                        /* IF NOT EXISTS(select *
                                       from param.tferiado f
                                                JOIN param.tlugar l on l.id_lugar = f.id_lugar
                                       WHERE l.codigo in ('BO', v_lugar)
                                         AND (EXTRACT(MONTH from f.fecha))::integer =
                                             (EXTRACT(MONTH from v_fecha_aux::date))::integer
                                         AND (EXTRACT(DAY from f.fecha))::integer = (EXTRACT(DAY from v_fecha_aux))
                                         AND f.id_gestion = v_id_gestion_actual) THEN*/
                        v_cant_dias = v_cant_dias + 1;
                        /*END IF;*/
                        v_incremento_fecha = v_fecha_aux::date + v_valor_incremento::INTERVAL;
                        v_fecha_aux := v_incremento_fecha;
                    END LOOP;
            end if;


            IF v_cant_dias = 0 then -- contador de dias
                v_mensaje = 'ERROR: DIA NO PERMITIDO.';
            END IF;


            --Definicion de la respuesta

            v_resp = pxp.f_agrega_clave(v_resp, 'mensaje',
                                        'Calculo almacenado(a) con exito (ID' || v_parametros.id_funcionario::varchar ||
                                        ')');
            v_resp = pxp.f_agrega_clave(v_resp, 'v_cant_dias', '%' || v_cant_dias || '%'::varchar);

            --Devuelve la respuesta
            return v_resp;

        END;
        /****************************************************
        #TRANSACCION:     'ASIS_CPM_SEG'
        #DESCRIPCION:     Cambiar de estado
        #AUTOR:           MMV
        #FECHA:			  31-01-2020 13:53:10
        ***************************************************/

    elsif (p_transaccion = 'ASIS_CPM_SEG') then

        begin

            -- raise exception '%',v_parametros;
            -- Validar estado
            select pw.id_proceso_wf,
                   ew.id_estado_wf,
                   te.codigo,
                   pw.fecha_ini,
                   te.id_tipo_estado,
                   te.pedir_obs,
                   pw.nro_tramite
            into
                v_registro_estado
            from wf.tproceso_wf pw
                     inner join wf.testado_wf ew on ew.id_proceso_wf = pw.id_proceso_wf and ew.estado_reg = 'activo'
                     inner join wf.ttipo_estado te on ew.id_tipo_estado = te.id_tipo_estado
            where pw.id_proceso_wf = v_parametros.id_proceso_wf;

            if (v_parametros.evento = v_registro_estado.codigo) then
                raise exception 'Registro ya fue  %   por favor presione el botón actualizar',v_registro_estado.codigo;
            end if;

            select c.id_compensacion,
                   c.id_responsable,
                   c.justificacion,
                   c.id_procesos_wf,
                   c.id_estado_wf
            into
                v_compensacion
            from asis.tcompensacion c
            where c.id_procesos_wf = v_parametros.id_proceso_wf;



            select ps_id_tipo_estado,
                   ps_codigo_estado,
                   ps_disparador,
                   ps_regla,
                   ps_prioridad
            into
                va_id_tipo_estado,
                va_codigo_estado,
                va_disparador,
                va_regla,
                va_prioridad
            from wf.f_obtener_estado_wf(v_registro_estado.id_proceso_wf,
                                        null,
                                        v_registro_estado.id_tipo_estado,
                                        'siguiente',
                                        p_id_usuario);


            v_acceso_directo = '../../../sis_asistencia/vista/vacacion/VacacionVoBo.php';
            v_clase = 'VacacionVoBo';
            v_parametros_ad = '{filtro_directo:{campo:"pmo.id_proceso_wf",valor:"' ||
                              v_registro_estado.id_proceso_wf::varchar || '"}}';
            v_tipo_noti = 'notificacion';
            v_titulo = 'Visto Bueno';




            if (array_length(va_codigo_estado, 1) >= 2) then

                select tt.id_tipo_estado,
                       tt.codigo
                into
                    v_estado_record
                from wf.ttipo_estado tt
                where tt.id_tipo_estado in (select unnest(ARRAY [va_id_tipo_estado]))
                  and tt.codigo = v_parametros.evento;

                v_id_estado_maestro = v_estado_record.id_tipo_estado;
                v_estado_maestro = v_estado_record.codigo;


            else

                v_id_estado_maestro = va_id_tipo_estado[1]::integer;
                v_estado_maestro = va_codigo_estado[1]::varchar;

            end if;

            --- raise exception '% --> %',v_id_estado_maestro,v_estado_maestro;
            v_id_estado_actual = wf.f_registra_estado_wf(v_id_estado_maestro,
                                                         v_compensacion.id_responsable,--v_parametros.id_funcionario_wf,
                                                         v_registro_estado.id_estado_wf,
                                                         v_registro_estado.id_proceso_wf,
                                                         p_id_usuario,
                                                         v_parametros._id_usuario_ai,
                                                         v_parametros._nombre_usuario_ai,
                                                         null,--v_id_depto,                       --depto del estado anterior
                                                         v_compensacion.justificacion, --obt
                                                         v_acceso_directo,
                                                         v_clase,
                                                         v_parametros_ad,
                                                         v_tipo_noti,
                                                         v_titulo);
            update asis.tcompensacion
            set id_estado_wf  = v_id_estado_actual,
                estado        = v_estado_maestro,
                id_usuario_mod=p_id_usuario,
                id_usuario_ai = v_parametros._id_usuario_ai,
                usuario_ai    = v_parametros._nombre_usuario_ai,
                fecha_mod=now(),
                justificacion = v_compensacion.justificacion
            where id_procesos_wf = v_parametros.id_proceso_wf;



            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'Exito');
            v_resp = pxp.f_agrega_clave(v_resp, 'id_proceso_wf', v_parametros.id_proceso_wf::varchar);

            --Devuelve la respuesta
            return v_resp;


        end;


    ELSE

        RAISE EXCEPTION 'Transaccion inexistente: %',p_transaccion;

    END IF;

EXCEPTION

    WHEN OTHERS THEN
        v_resp = '';
        v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', SQLERRM);
        v_resp = pxp.f_agrega_clave(v_resp, 'codigo_error', SQLSTATE);
        v_resp = pxp.f_agrega_clave(v_resp, 'procedimientos', v_nombre_funcion);
        raise exception '%',v_resp;

END;
$body$
    LANGUAGE 'plpgsql'
    VOLATILE
    CALLED ON NULL INPUT
    SECURITY INVOKER
    PARALLEL UNSAFE
    COST 100;

ALTER FUNCTION asis.ft_compensacion_ime (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
    OWNER TO postgres;