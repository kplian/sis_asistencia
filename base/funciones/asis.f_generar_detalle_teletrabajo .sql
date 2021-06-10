CREATE OR REPLACE FUNCTION asis.f_generar_detalle_teletrabajo (
)
    RETURNS void AS
$body$
DECLARE
    v_resp                      varchar;
    v_nombre_funcion            text;
    v_record					record;
    v_record_detalle			record;
    v_id_gestion_actual			integer;
    v_lugar						varchar;
    v_dia						varchar;
    v_condicion					boolean;
    v_fecha_aux					date;

BEGIN

    SELECT g.id_gestion
    INTO
        v_id_gestion_actual
    FROM param.tgestion g
    WHERE now() BETWEEN g.fecha_ini and g.fecha_fin;


    for v_record in (select t.id_tele_trabajo,
                            t.tipo_teletrabajo,
                            t.fecha_inicio,
                            t.fecha_fin,
                            t.lunes,
                            t.martes,
                            t.miercoles,
                            t.jueves,
                            t.viernes,
                            t.estado,
                            t.id_usuario_reg
                     from asis.ttele_trabajo t
                     where t.id_tele_trabajo in (
                                                 518,
                                                 785,
                                                 504,
                                                 672,
                                                 595,
                                                 723,
                                                 642,
                                                 435,
                                                 762,
                                                 613,
                                                 783,
                                                 420)
                       and t.estado = 'aprobado') loop

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
              and us.id_usuario = v_record.id_usuario_reg;


            v_fecha_aux = v_record.fecha_inicio;


            for v_record_detalle in (select dia::date as dia
                                     from generate_series(v_record.fecha_inicio, v_record.fecha_fin,
                                                          '1 day'::interval) dia) loop
                    v_condicion = false;

                    v_dia = '';
                    ---raise notice '------> % <-----------',v_record_detalle.dia;
                    if not exists(select *
                                  from param.tferiado f
                                           join param.tlugar l on l.id_lugar = f.id_lugar
                                  where l.codigo in ('BO', v_lugar)
                                    and (extract(MONTH from f.fecha))::integer = (extract(MONTH from v_record_detalle.dia::date))::integer
                                    and (extract(DAY from f.fecha))::integer = (extract(DAY from v_record_detalle.dia))
                                    and f.id_gestion = v_id_gestion_actual) then

                        if (extract(dow from v_record_detalle.dia::date) not in (6, 0)) then
                            v_dia = case extract(dow from v_record_detalle.dia::date)
                                        when 1 then 'lunes'
                                        when 2 then 'martes'
                                        when 3 then 'miercoles'
                                        when 4 then 'jueves'
                                        when 5 then 'viernes'
                                end;
                            raise notice '------> % <----------- id: %',v_dia,v_record.id_tele_trabajo ;
                            EXECUTE ('select 1
                                from asis.ttele_trabajo tl
                                where tl.id_tele_trabajo = ' || v_record.id_tele_trabajo || '
                                and tl.' || v_dia || ' = true') into v_condicion;

                            raise notice '------> %',v_condicion;
                            if v_condicion then

                                raise notice 'entra';

                                insert into asis.ttele_trabajo_det
                                (id_usuario_reg,
                                 id_usuario_mod,
                                 fecha_reg,
                                 fecha_mod,
                                 estado_reg,
                                 id_usuario_ai,
                                 usuario_ai,
                                 id_tele_trabajo,
                                 fecha)
                                VALUES (
                                           v_record.id_usuario_reg,
                                           null,
                                           now(),
                                           null,
                                           'activo',
                                           null,--v_parametros._id_usuario_ai,
                                           null,--v_parametros._nombre_usuario_ai,
                                           v_record.id_tele_trabajo,
                                           v_record_detalle.dia::date
                                       );

                            end if;
                        end if;
                    end if;

                end loop;
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
