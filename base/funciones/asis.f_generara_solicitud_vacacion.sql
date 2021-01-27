CREATE OR REPLACE FUNCTION asis.f_generara_solicitud_vacacion(p_id_usuario integer,
                                                              p_fecha_inicio date,
                                                              p_fecha_fin date,
                                                              p_id_usuario_ai integer default null,
                                                              p_nombre_usuario_ai varchar default null)
    RETURNS void AS
$body$
DECLARE
    v_resp             varchar;
    v_nombre_funcion   text;
    v_record_pro       record;
    v_id_gestion       integer;
    v_codigo_proceso   varchar;
    v_id_macro_proceso integer;
    v_nro_tramite      varchar;
    v_id_proceso_wf    integer;
    v_id_estado_wf     integer;
    v_codigo_estado    varchar;
    v_fecha_min        date;
    v_fecha_max        date;
    v_fecha_aux        date;
    v_valor_incremento varchar;
    v_lugar            varchar;
    v_domingo          INTEGER = 0;
    v_sabado           INTEGER = 6;
    v_cant_dias        numeric = 0;
    v_incremento_fecha date;
    v_id_vacacion      integer;
    v_funcionarios     record;
    v_dias_efectivo    numeric;
    v_id_resposable    integer;
    v_id_uo            integer;
    v_sub              text;
    v_id_usuario_reg   integer;

BEGIN
    v_nombre_funcion = 'asis.f_generara_solicitud_vacacion';


    select f.id_funcionario, uf.id_uo
    into v_id_resposable , v_id_uo
    from segu.tusuario us
             join segu.tpersona p on p.id_persona = us.id_persona
             join orga.tfuncionario f on f.id_persona = p.id_persona
             join orga.tuo_funcionario uf on uf.id_funcionario = f.id_funcionario
    where uf.estado_reg = 'activo'
      and uf.tipo = 'oficial'
      and uf.fecha_asignacion <= now()
      and coalesce(uf.fecha_finalizacion, now()) >= now()
      and us.id_usuario = p_id_usuario;

    select g.id_gestion
    into v_id_gestion
    from param.tgestion g
    where g.gestion = EXTRACT(YEAR FROM current_date);

    select tp.codigo, pm.id_proceso_macro
    into v_codigo_proceso, v_id_macro_proceso
    from wf.tproceso_macro pm
             inner join wf.ttipo_proceso tp on tp.id_proceso_macro = pm.id_proceso_macro
    where pm.codigo = 'VAC'
      and tp.estado_reg = 'activo'
      and tp.inicio = 'si';


    for v_funcionarios in (select distinct on (ca.id_funcionario) ca.id_funcionario,
                                                                  ca.desc_funcionario1,
                                                                  trim(both 'FUNODTPR' from ca.codigo) as codigo,
                                                                  ca.nombre_cargo
                           from orga.vfuncionario_cargo ca
                                    inner join orga.tcargo car on car.id_cargo = ca.id_cargo
                                    inner join orga.ttipo_contrato tc on car.id_tipo_contrato = tc.id_tipo_contrato
                           where tc.codigo in ('PLA', 'EVE')
                             and ca.fecha_asignacion <= p_fecha_fin
                             and (ca.fecha_finalizacion is null or ca.fecha_finalizacion >= p_fecha_inicio)
                             and ca.id_funcionario in (
                               with recursive uo_mas_subordinados(id_uo_hijo, id_uo_padre) as (
                                   select euo.id_uo_hijo,--id
                                          id_uo_padre---padre
                                   from orga.testructura_uo euo
                                   where euo.id_uo_hijo = v_id_uo
                                     and euo.estado_reg = 'activo'
                                   union
                                   select e.id_uo_hijo,
                                          e.id_uo_padre
                                   from orga.testructura_uo e
                                            inner join uo_mas_subordinados s on s.id_uo_hijo = e.id_uo_padre
                                       and e.estado_reg = 'activo'
                               )
                               select fun.id_funcionario
                               from uo_mas_subordinados suo
                                        inner join orga.tuo ou on ou.id_uo = suo.id_uo_hijo
                                        inner join orga.vfuncionario_cargo fun on fun.id_uo = suo.id_uo_hijo
                                        inner join orga.tnivel_organizacional ni
                                                   on ni.id_nivel_organizacional = ou.id_nivel_organizacional
                               where (fun.fecha_finalizacion is null or fun.fecha_finalizacion >= now()::date)
                                 and fun.id_funcionario != v_id_resposable)
                           order by ca.id_funcionario, ca.fecha_asignacion desc)
        loop

            -- insertar cabezera

            select ps_num_tramite,
                   ps_id_proceso_wf,
                   ps_id_estado_wf,
                   ps_codigo_estado
            into
                v_nro_tramite,
                v_id_proceso_wf,
                v_id_estado_wf,
                v_codigo_estado
            from wf.f_inicia_tramite(
                    p_id_usuario,
                    p_id_usuario_ai,
                    p_nombre_usuario_ai,
                    v_id_gestion,
                    v_codigo_proceso,
                    v_funcionarios.id_funcionario,
                    null,
                    'Vacaciones',
                    v_codigo_proceso);

            select us.id_usuario
            into v_id_usuario_reg
            from segu.tusuario us
                     join segu.tpersona p on p.id_persona = us.id_persona
                     join orga.tfuncionario f on f.id_persona = p.id_persona
                     join orga.tuo_funcionario uf on uf.id_funcionario = f.id_funcionario
            where uf.estado_reg = 'activo'
              and uf.tipo = 'oficial'
              and uf.fecha_asignacion <= now()
              and coalesce(uf.fecha_finalizacion, now()) >= now()
              and f.id_funcionario = v_funcionarios.id_funcionario;

            insert into asis.tvacacion(estado_reg,
                                       id_funcionario,
                                       fecha_inicio,
                                       fecha_fin,
                                       dias,
                                       descripcion,
                                       id_usuario_reg,
                                       fecha_reg,
                                       id_usuario_ai,
                                       usuario_ai,
                                       id_usuario_mod,
                                       fecha_mod,
                                       id_proceso_wf, --campo wf
                                       id_estado_wf,--campo wf
                                       estado,--campo wf
                                       nro_tramite,--campo wf
                                       medio_dia,-- medio_dia
                ---dias_efectivo,
                                       id_responsable,
                                       id_funcionario_sol,
                                       saldo,
                                       programacion)
            values ('activo',
                    v_funcionarios.id_funcionario,
                    p_fecha_inicio,
                    p_fecha_fin,
                    0, --v_parametros.dias,
                    'Programacion',
                    v_id_usuario_reg,
                    now(),
                    p_id_usuario_ai,
                    p_nombre_usuario_ai,
                    null,
                    null,
                    v_id_proceso_wf,
                    v_id_estado_wf,
                    v_codigo_estado,
                    v_nro_tramite,
                    0,--v_parametros.medio_dia,
                       --v_parametros.dias_efectivo,
                    v_id_resposable, -- v_parametros.id_responsable,
                    null, -- v_id_sol_funcionario,
                    0, --v_saldo_resgistro,
                    'si')
            RETURNING id_vacacion into v_id_vacacion;

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
              and f.id_funcionario = v_funcionarios.id_funcionario;

            -- insertar detalle

            for v_record_pro in (select p.id_programacion,
                                        p.fecha_programada,
                                        p.tiempo
                                 from asis.tprogramacion p
                                 where p.id_funcionario = v_funcionarios.id_funcionario
                                   and p.estado = 'pendiente'
                                   and p.fecha_programada between p_fecha_inicio and p_fecha_fin
                                 order by fecha_programada)
                loop

                    if (select extract(dow from v_record_pro.fecha_programada) not in (v_sabado, v_domingo)) then

                        if not exists(select 1
                                      from param.tferiado f
                                               inner join param.tlugar l on l.id_lugar = f.id_lugar
                                      where l.codigo in ('BO', v_lugar)
                                        and (EXTRACT(MONTH from f.fecha))::integer =
                                            (EXTRACT(MONTH from v_record_pro.fecha_programada::date))::integer
                                        and (EXTRACT(DAY from f.fecha))::integer =
                                            (EXTRACT(DAY from v_record_pro.fecha_programada::date))
                                        and f.id_gestion = v_id_gestion) then

                            if not exists(select 1
                                          from asis.tvacacion v
                                                   inner join asis.tvacacion_det d on d.id_vacacion = v.id_vacacion
                                          where v.id_funcionario = v_funcionarios.id_funcionario
                                            and d.fecha_dia = v_record_pro.fecha_programada
                                            and v.estado in ('vobo', 'aprobado')) then


                                insert into asis.tvacacion_det(id_usuario_reg,
                                                               id_usuario_mod,
                                                               fecha_reg,
                                                               fecha_mod,
                                                               id_usuario_ai,
                                                               usuario_ai,
                                                               id_vacacion,
                                                               fecha_dia,
                                                               tiempo)
                                values (p_id_usuario,
                                        null,
                                        now(),
                                        null,
                                        p_id_usuario_ai,
                                        p_nombre_usuario_ai,
                                        v_id_vacacion,
                                        v_record_pro.fecha_programada,
                                        case
                                            when v_record_pro.tiempo = 'M' then
                                                'mañana'
                                            when v_record_pro.tiempo = 'T' then
                                                'tarde'
                                            else
                                                'completo'
                                            end);

                                update asis.tprogramacion
                                set estado='programado'
                                where id_programacion = v_record_pro.id_programacion;
                            end if;
                        end if;
                    end if;

                end loop;
            --- recalcular

            select min(d.fecha_dia)
            into v_fecha_min
            from asis.tvacacion_det d
            where d.id_vacacion = v_id_vacacion;

            select max(d.fecha_dia)
            into v_fecha_max
            from asis.tvacacion_det d
            where d.id_vacacion = v_id_vacacion;


            select sum(d.dias_efectico)
            into v_dias_efectivo
            from (
                     select (case
                                 when vd.tiempo = 'completo' then
                                     1
                                 when vd.tiempo = 'mañana' then
                                     0.5
                                 when vd.tiempo = 'tarde' then
                                     0.5
                                 else
                                     0
                         end ::numeric) as dias_efectico
                     from asis.tvacacion_det vd
                     where vd.id_vacacion = v_id_vacacion) d;

            update asis.tvacacion
            set fecha_inicio = v_fecha_min,
                fecha_fin    = v_fecha_max,
                dias         = v_dias_efectivo
            where id_vacacion = v_id_vacacion;
        end loop;


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