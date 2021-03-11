create or replace function asis.ft_tele_trabajo_sel(p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying) returns character varying
    language plpgsql
as
$$
/**************************************************************************
 SISTEMA:        Sistema de Asistencia
 FUNCION:         asis.ft_tele_trabajo_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.ttele_trabajo'
 AUTOR:          (admin.miguel)
 FECHA:            01-02-2021 14:53:44
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE                FECHA                AUTOR                DESCRIPCION
 #0                01-02-2021 14:53:44    admin.miguel             Creacion
 #
 ***************************************************************************/

DECLARE

v_consulta       VARCHAR;
    v_parametros     RECORD;
    v_nombre_funcion TEXT;
    v_resp           VARCHAR;
    v_filtro         varchar;
    v_id_funcionario integer;
    v_record         record;
BEGIN

    v_nombre_funcion = 'asis.ft_tele_trabajo_sel';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
     #TRANSACCION:  'ASIS_TLT_SEL'
     #DESCRIPCION:    Consulta de datos
     #AUTOR:        admin.miguel
     #FECHA:        01-02-2021 14:53:44
    ***********************************/

    IF (p_transaccion = 'ASIS_TLT_SEL') THEN

BEGIN

            v_filtro = '';

            if (v_parametros.tipo_interfaz = 'SolTeleTrabajo') then

                v_filtro = '( tlt.id_usuario_reg = ' || p_id_usuario || ') and ';

end if;

            if (v_parametros.tipo_interfaz = 'TeleTrabajoVoBo') then

                if p_administrador != 1 then

select f.id_funcionario
into v_id_funcionario
from segu.vusuario u
         inner join orga.vfuncionario_persona f on f.id_persona = u.id_persona
where u.id_usuario = p_id_usuario;

if v_id_funcionario is not null then
                        v_filtro = 'tlt.id_responsable =  ' || v_id_funcionario || ' and ';
end if;
end if;

end if;

            --Sentencia de la consulta
            v_consulta := 'select tlt.id_tele_trabajo,
                                tlt.estado_reg,
                                tlt.id_funcionario,
                                tlt.id_responsable,
                                tlt.fecha_inicio,
                                tlt.fecha_fin,
                                tlt.justificacion,
                                tlt.id_usuario_reg,
                                tlt.fecha_reg,
                                tlt.id_usuario_ai,
                                tlt.usuario_ai,
                                tlt.id_usuario_mod,
                                tlt.fecha_mod,
                                usu1.cuenta as usr_reg,
                                usu2.cuenta as usr_mod,
                                tlt.estado,
                                tlt.nro_tramite,
                                tlt.id_proceso_wf,
                                tlt.id_estado_wf,
                                fu.desc_funcionario2 as funcionario,
                                res.desc_funcionario2 as responsable,
                                dep.id_uo,
                                dep.nombre_unidad as departamento,
                                tlt.tipo_teletrabajo,
                                tlt.motivo,
                                tlt.tipo_temporal,
                                tlt.lunes,
                                tlt.martes,
                                tlt.miercoles,
                                tlt.jueves,
                                tlt.viernes
                                from asis.ttele_trabajo tlt
                                inner join segu.tusuario usu1 ON usu1.id_usuario = tlt.id_usuario_reg
                                inner join orga.vfuncionario_cargo fu on fu.id_funcionario = tlt.id_funcionario
                                inner join orga.tuo dep ON dep.id_uo = orga.f_get_uo_departamento(fu.id_uo, NULL::integer, NULL::date)
                                inner join orga.vfuncionario res on res.id_funcionario = tlt.id_responsable
                                left join segu.tusuario usu2 ON usu2.id_usuario = tlt.id_usuario_mod
                                where fu.fecha_asignacion <= now()::date
                                and (fu.fecha_finalizacion is null or fu.fecha_finalizacion >= now()::date) and  ' ||
                          v_filtro;

            --Definicion de la respuesta
            v_consulta := v_consulta || v_parametros.filtro;
            v_consulta := v_consulta || ' order by ' || v_parametros.ordenacion || ' ' || v_parametros.dir_ordenacion ||
                          ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            --Devuelve la respuesta
RETURN v_consulta;

END;

        /*********************************
         #TRANSACCION:  'ASIS_TLT_CONT'
         #DESCRIPCION:    Conteo de registros
         #AUTOR:        admin.miguel
         #FECHA:        01-02-2021 14:53:44
        ***********************************/

    ELSIF (p_transaccion = 'ASIS_TLT_CONT') THEN

BEGIN

            v_filtro = '';

            if (v_parametros.tipo_interfaz = 'SolTeleTrabajo') then

                v_filtro = '( tlt.id_usuario_reg = ' || p_id_usuario || ') and ';

end if;

            if (v_parametros.tipo_interfaz = 'TeleTrabajoVoBo') then

                if p_administrador != 1 then

select f.id_funcionario
into v_id_funcionario
from segu.vusuario u
         inner join orga.vfuncionario_persona f on f.id_persona = u.id_persona
where u.id_usuario = p_id_usuario;

if v_id_funcionario is not null then
                        v_filtro = 'tlt.id_responsable =  ' || v_id_funcionario || ' and ';
end if;
end if;

end if;
            --Sentencia de la consulta de conteo de registros
            v_consulta := 'select COUNT(id_tele_trabajo)
                        from asis.ttele_trabajo tlt
                        inner join segu.tusuario usu1 ON usu1.id_usuario = tlt.id_usuario_reg
                        inner join orga.vfuncionario_cargo fu on fu.id_funcionario = tlt.id_funcionario
                        inner join orga.tuo dep ON dep.id_uo = orga.f_get_uo_departamento(fu.id_uo, NULL::integer, NULL::date)
                        inner join orga.vfuncionario res on res.id_funcionario = tlt.id_responsable
                        left join segu.tusuario usu2 ON usu2.id_usuario = tlt.id_usuario_mod
                        where fu.fecha_asignacion <= now()::date
                        and (fu.fecha_finalizacion is null or fu.fecha_finalizacion >= now()::date) and ' || v_filtro;

            --Definicion de la respuesta
            v_consulta := v_consulta || v_parametros.filtro;

            --Devuelve la respuesta
RETURN v_consulta;

END;

        /*********************************
        #TRANSACCION:  'ASIS_TLTREP_SEL'
        #DESCRIPCION:    Reporte general Teletabajo
        #AUTOR:        admin.miguel
        #FECHA:        01-02-2021 14:53:44
       ***********************************/

    ELSIF (p_transaccion = 'ASIS_TLTREP_SEL') THEN

BEGIN

select t.id_proceso_wf,
       t.fecha_inicio,
       t.fecha_fin
into v_record
from asis.ttele_trabajo t
where t.id_proceso_wf = v_parametros.id_proceso_wf;

v_consulta := 'with rango as (select dia::date as fecha_rango,
                                          '||v_parametros.id_proceso_wf||'as id_proceso_wf
                                   from generate_series('''||v_record.fecha_inicio||'''::date, '''||v_record.fecha_fin||'''::date,
                                                        ''1 day''::interval) dia)
                    select tlt.id_tele_trabajo,
                           initcap(fu.desc_funcionario2)  as funcionario_solicitante,
                           initcap(dep.nombre_unidad)::varchar  as departamento,
                           initcap(res.desc_funcionario2) as responsable,
                           to_char(tlt.fecha_inicio,''DD/MM/YYYY'') as fecha_inicio,
                           to_char(tlt.fecha_fin,''DD/MM/YYYY'') as fecha_fin,
                           tlt.justificacion,
                           tlt.fecha_reg::date   as fecha_solictud,
                           tlt.estado,
                           tlt.nro_tramite,
                           tlt.tipo_teletrabajo,
                           tlt.motivo,
                           tlt.tipo_temporal,
                           tlt.lunes,
                           tlt.martes,
                           tlt.miercoles,
                           tlt.jueves,
                           tlt.viernes,
                           tlt.id_proceso_wf,
                           to_char(ra.fecha_rango,''DD/MM/YYYY'')  as fecha_rango,
                          (
                           case extract(dow from ra.fecha_rango::date)
                               when 1 then ''Lunes''
                               when 2 then ''Martes''
                               when 3 then ''Miercoles''
                               when 4 then ''Jueves''
                               when 5 then ''Viernes''
                               when 6 then ''Sabado''
                               when 0 then ''Domingo''
                               end
                           )::varchar as dia_literal,
                           (
                               case
                                   when exists(select 1
                                               from asis.ttele_trabajo_det dt
                                               where dt.id_tele_trabajo = tlt.id_tele_trabajo
                                                 and dt.fecha = ra.fecha_rango) then
                                       ''Teletrabajo''
                                   else
                                       ''Oficina''
                                   end )::varchar          as evento
                    from asis.ttele_trabajo tlt
                             inner join orga.vfuncionario_cargo fu on fu.id_funcionario = tlt.id_funcionario
                             inner join orga.vfuncionario res on res.id_funcionario = tlt.id_responsable
                             inner join orga.tuo dep ON dep.id_uo = orga.f_get_uo_departamento(fu.id_uo, NULL::integer, NULL::date)
                             inner join rango ra on ra.id_proceso_wf = tlt.id_proceso_wf
                    where tlt.id_proceso_wf = '||v_parametros.id_proceso_wf||'
                      and (fu.fecha_finalizacion is null or fu.fecha_finalizacion >= now()::date)
                    order by fecha_rango';

            --Devuelve la respuesta
RETURN v_consulta;

END;
ELSE

        RAISE EXCEPTION 'Transaccion inexistente';

END IF;

EXCEPTION

    WHEN OTHERS THEN
        v_resp = '';
        v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', SQLERRM);
        v_resp = pxp.f_agrega_clave(v_resp, 'codigo_error', SQLSTATE);
        v_resp = pxp.f_agrega_clave(v_resp, 'procedimientos', v_nombre_funcion);
        RAISE EXCEPTION '%',v_resp;
END;
$$;


