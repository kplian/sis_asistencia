CREATE OR REPLACE FUNCTION asis.f_generara_solicitud_vacacion (
    p_id_usuario integer,
    p_fecha_inicio date,
    p_fecha_fin date,
    p_id_usuario_ai integer = NULL::integer,
    p_nombre_usuario_ai varchar = NULL::character varying
)
    RETURNS void AS
$body$
DECLARE
    v_resp               varchar;
    v_nombre_funcion     text;
    v_record_pro         record;
    v_id_gestion         integer;
    v_codigo_proceso     varchar;
    v_id_macro_proceso   integer;
    v_nro_tramite        varchar;
    v_id_proceso_wf      integer;
    v_id_estado_wf       integer;
    v_codigo_estado      varchar;
    v_fecha_min          date;
    v_fecha_max          date;
    v_fecha_aux          date;
    v_valor_incremento   varchar;
    v_lugar              varchar;
    v_domingo            INTEGER = 0;
    v_sabado             INTEGER = 6;
    v_cant_dias          numeric = 0;
    v_incremento_fecha   date;
    v_id_vacacion        integer;
    v_funcionarios       record;
    v_dias_efectivo      numeric;
    v_id_resposable      integer;
    v_id_uo              integer;
    v_sub                text;
    v_id_usuario_reg     integer;
    v_descripcion_correo varchar;
    v_registro           record;
    v_id_alarma          integer;
    v_id_vacacion_det    integer;
    v_movimiento         record;
    v_saldo_resgistro    numeric;
    v_operacion_reg      numeric;
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

            if exists(select 1
                      from asis.tprogramacion p
                      where p.fecha_programada between p_fecha_inicio and p_fecha_fin
                        and p.id_funcionario = v_funcionarios.id_funcionario) then

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
                                       and  p.revisado = 'si'
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
                                                end)
                                    RETURNING id_vacacion_det into v_id_vacacion_det;
                                    update asis.tprogramacion
                                    set estado='programado',
                                        id_vacacion_det = v_id_vacacion_det
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

                select v.dias_actual
                into
                    v_movimiento
                from asis.tmovimiento_vacacion v
                where v.id_funcionario = v_funcionarios.id_funcionario
                  and v.activo = 'activo'
                  and v.estado_reg = 'activo';

                if (v_movimiento.dias_actual > 0) then

                    v_saldo_resgistro = v_movimiento.dias_actual - v_dias_efectivo;

                else

                    v_operacion_reg = 1 * - v_movimiento.dias_actual;

                    v_saldo_resgistro = -1 * (v_operacion_reg + v_dias_efectivo);

                end if;


                update asis.tvacacion
                set fecha_inicio = v_fecha_min,
                    fecha_fin    = v_fecha_max,
                    dias         = v_dias_efectivo,
                    saldo        = v_saldo_resgistro
                where id_vacacion = v_id_vacacion;

                select me.id_vacacion,
                       me.fecha_inicio,
                       me.fecha_fin,
                       me.dias,
                       me.id_funcionario,
                       me.prestado,
                       me.id_funcionario_sol,
                       me.id_estado_wf,
                       fu.desc_funcionario1,
                       to_char(me.fecha_reg::date, 'DD/MM/YYYY')                                    as fecha_solictudo,
                       to_char(me.fecha_inicio, 'DD/MM/YYYY')                                       as fecha_inicio,
                       to_char(me.fecha_fin, 'DD/MM/YYYY')                                          as fecha_fin,
                       me.descripcion,
                       me.dias,
                       me.id_usuario_reg,
                       fu.desc_funcionario2,
                       me.id_proceso_wf,
                       ('<table border="1"><TR>
   								<TH>Fecha</TH>
   								<TH>Tiempo</TH>'::text ||
                        pxp.html_rows((((('<td>'::text ||
                                          COALESCE(to_char(vd.fecha_dia::date, 'DD/MM/YYYY')::text, '-'::text)) || '</td>
             					<td>'::text) || COALESCE(vd.tiempo::text, '-'::text)) ||
                                       '</td>'::character varying::text)::character varying)::text) as detalle
                into
                    v_registro
                from asis.tvacacion me
                         inner join orga.vfuncionario fu on fu.id_funcionario = me.id_funcionario
                         inner join asis.tvacacion_det vd on vd.id_vacacion = me.id_vacacion
                where me.id_vacacion = v_id_vacacion
                group by me.id_vacacion,
                         me.fecha_inicio,
                         me.fecha_fin,
                         me.dias,
                         me.id_funcionario,
                         me.prestado,
                         me.id_funcionario_sol,
                         me.id_estado_wf,
                         fu.desc_funcionario1,
                         me.fecha_reg::date,
                         me.fecha_inicio,
                         me.fecha_fin,
                         me.descripcion,
                         me.dias,
                         me.id_usuario_reg,
                         fu.desc_funcionario2,
                         me.id_proceso_wf;

                v_descripcion_correo = '<h3><b>PROGRAMACION DE VACACIÓN</b></h3>
                                  <p style="font-size: 15px;"><b>Fecha solicitud:</b> ' || v_registro.fecha_solictudo || ' </p>
                                  <p style="font-size: 15px;"><b>Solicitud para:</b> ' ||
                                       v_registro.desc_funcionario1 || '</p>
                                  <p style="font-size: 15px;"><b>Desde:</b> ' || v_registro.fecha_inicio ||
                                       ' <b>Hasta:</b> ' || v_registro.fecha_fin || '</p>
                                  <p style="font-size: 15px;"><b>Días solicitados:</b> ' || v_registro.dias || '</p>
                                  <p style="font-size: 15px;"><b>Justificación:</b> ' || v_registro.descripcion || '</p>
                                  <br/>' || v_registro.detalle || '';

                v_id_alarma = param.f_inserta_alarma(
                        v_registro.id_funcionario,
                        v_descripcion_correo,--par_descripcion
                        '',--acceso directo
                        now()::date,--par_fecha: Indica la fecha de vencimiento de la alarma
                        'notificacion', --notificacion
                        'Programación Vacacion', --asunto
                        p_id_usuario,
                        '', --clase
                        'Programación Vacacion',--titulo
                        '',--par_parametros varchar,   parametros a mandar a la interface de acceso directo
                        v_registro.id_funcionario, --usuario a quien va dirigida la alarma
                        '',--titulo correo
                        '', --correo funcionario
                        null,--#9
                        v_registro.id_proceso_wf,
                        v_registro.id_estado_wf--#9
                    );
            end if;
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

ALTER FUNCTION asis.f_generara_solicitud_vacacion (p_id_usuario integer, p_fecha_inicio date, p_fecha_fin date, p_id_usuario_ai integer, p_nombre_usuario_ai varchar)
    OWNER TO postgres;