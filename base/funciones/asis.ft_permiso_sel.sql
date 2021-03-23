create or replace function asis.ft_permiso_sel(p_administrador integer, p_id_usuario integer, p_tabla character varying,
                               p_transaccion character varying) returns character varying
    language plpgsql
as
$$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.ft_permiso_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.tpermiso'
 AUTOR: 		 (miguel.mamani)
 FECHA:	        16-10-2019 13:14:05
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				16-10-2019 13:14:05								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.tpermiso'
 #25			14-08-2020 15:28:39		MMV						Refactorizacion permiso

 ***************************************************************************/

DECLARE

    v_consulta           varchar;
    v_parametros         record;
    v_nombre_funcion     text;
    v_resp               varchar;
    v_filtro             varchar;
    v_id_funcionario_sol integer;
    v_count              integer;


BEGIN

    v_nombre_funcion = 'asis.ft_permiso_sel';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
     #TRANSACCION:  'ASIS_PMO_SEL'
     #DESCRIPCION:	Consulta de datos
     #AUTOR:		miguel.mamani
     #FECHA:		16-10-2019 13:14:05
    ***********************************/

    if (p_transaccion = 'ASIS_PMO_SEL') then

        begin

            if v_parametros.tipo_interfaz = 'PermisoReg' then

                v_filtro = '';

                if p_administrador != 1 then


                    select fp.id_funcionario
                    into v_id_funcionario_sol
                    from segu.vusuario usu
                             inner join orga.vfuncionario_persona fp on fp.id_persona = usu.id_persona
                             inner join asis.tpermiso p on p.id_funcionario = fp.id_funcionario
                    where usu.id_usuario = p_id_usuario;

                    select count(p.id_permiso)
                    into v_count
                    from asis.tpermiso p
                    where p.id_usuario_reg = p_id_usuario;

                    if v_id_funcionario_sol is null and v_count = 0 then


                        v_filtro = '( pmo.id_usuario_reg = ' || p_id_usuario || ') and ';

                    else

                        if (v_id_funcionario_sol is null) then

                            v_filtro = '( pmo.id_usuario_reg = ' || p_id_usuario || ') and ';

                        else
                            v_filtro = '(pmo.id_funcionario = ' || v_id_funcionario_sol ||
                                       ' or pmo.id_usuario_reg = ' || p_id_usuario || ') and ';

                        end if;


                    end if;

                end if;
            end if;

            if v_parametros.tipo_interfaz = 'PermisoVoBo' then

                v_filtro = '';

                if p_administrador != 1 then

                    select f.id_funcionario
                    into v_id_funcionario_sol
                    from segu.vusuario u
                             inner join orga.vfuncionario_persona f on f.id_persona = u.id_persona
                    where u.id_usuario = p_id_usuario;

                    v_filtro = 'wet.id_funcionario =  ' || v_id_funcionario_sol || ' and ';

                end if;
            end if;

            if v_parametros.tipo_interfaz = 'PermisoRRHH' then
                v_filtro = '( pmo.id_usuario_reg = ' || p_id_usuario || ') and ';
            end if;

            if v_parametros.tipo_interfaz = 'PermisoRrhh' then
                v_filtro = '';
            end if;

            --Sentencia de la consulta
            v_consulta := 'select	pmo.id_permiso,
                                pmo.nro_tramite,
                                pmo.id_funcionario,
                                pmo.id_estado_wf,
                                pmo.fecha_solicitud,
                                pmo.id_tipo_permiso,
                                pmo.motivo,
                                pmo.estado_reg,
                                pmo.estado,
                                pmo.id_proceso_wf,
                                pmo.id_usuario_ai,
                                pmo.id_usuario_reg,
                                pmo.usuario_ai,
                                pmo.fecha_reg,
                                pmo.fecha_mod,
                                pmo.id_usuario_mod,
                                usu1.cuenta as usr_reg,
                                usu2.cuenta as usr_mod,
                                tip.nombre ||'' (''||tip.codigo||'')''::text as desc_tipo_permiso,
                                fun.desc_funcionario1::text as desc_funcionario,
                                pmo.hro_desde,
                                pmo.hro_hasta,
                                tip.reposcion as asignar_rango,
                                tip.documento,
                                pmo.reposicion,
                                pmo.fecha_reposicion,
                                pmo.hro_desde_reposicion,
                                pmo.hro_hasta_reposicion,
                                pmo.hro_total_permiso,
                                pmo.hro_total_reposicion,
                                pmo.jornada,
                                pmo.id_responsable,
                                rep.desc_funcionario1 as responsable,
                                ded.desc_funcionario1 as funcionario_sol,
                                pmo.observaciones,
                                dep.id_uo,
                                dep.nombre_unidad as departamento,
                                pmo.id_tipo_licencia,
                                pmo.fecha_inicio,
                                pmo.fecha_fin,
                                pmo.dias,
			                    dt.nombre                                     as desc_tipo_licencia
                                from asis.tpermiso pmo
                                inner join segu.tusuario usu1 on usu1.id_usuario = pmo.id_usuario_reg
                                inner join asis.ttipo_permiso tip on tip.id_tipo_permiso = pmo.id_tipo_permiso
                                inner join orga.vfuncionario_cargo fun on fun.id_funcionario = pmo.id_funcionario
                                inner join wf.testado_wf wet on wet.id_estado_wf = pmo.id_estado_wf
                                inner join orga.vfuncionario rep on rep.id_funcionario = pmo.id_responsable
                                inner join orga.tuo dep ON dep.id_uo = orga.f_get_uo_departamento(fun.id_uo, NULL::integer, NULL::date)
                                left join segu.tusuario usu2 on usu2.id_usuario = pmo.id_usuario_mod
                                left join orga.vfuncionario ded on ded.id_funcionario = pmo.id_funcionario_sol
			                    left join asis.tdetalle_tipo_permiso dt on dt.id_detalle_tipo_permiso = pmo.id_tipo_licencia
                                where fun.fecha_asignacion <= now()::date
                                and (fun.fecha_finalizacion is null or fun.fecha_finalizacion >= now()::date) and ' ||
                          v_filtro;

            --Definicion de la respuesta
            v_consulta := v_consulta || v_parametros.filtro;
            v_consulta := v_consulta || ' order by ' || v_parametros.ordenacion || ' ' || v_parametros.dir_ordenacion ||
                          ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
            --Devuelve la respuesta
            raise notice '%',v_consulta;
            return v_consulta;

        end;

        /*********************************
         #TRANSACCION:  'ASIS_PMO_CONT'
         #DESCRIPCION:	Conteo de registros
         #AUTOR:		miguel.mamani
         #FECHA:		16-10-2019 13:14:05
        ***********************************/

    elsif (p_transaccion = 'ASIS_PMO_CONT') then

        begin

            if v_parametros.tipo_interfaz = 'PermisoReg' then

                v_filtro = '';

                if p_administrador != 1 then


                    select fp.id_funcionario
                    into v_id_funcionario_sol
                    from segu.vusuario usu
                             inner join orga.vfuncionario_persona fp on fp.id_persona = usu.id_persona
                             inner join asis.tpermiso p on p.id_funcionario = fp.id_funcionario
                    where usu.id_usuario = p_id_usuario;

                    select count(p.id_permiso)
                    into v_count
                    from asis.tpermiso p
                    where p.id_usuario_reg = p_id_usuario;

                    if v_id_funcionario_sol is null and v_count = 0 then

                        v_filtro = '( pmo.id_usuario_reg = ' || p_id_usuario || ') and ';

                    else

                        if (v_id_funcionario_sol is null) then

                            v_filtro = '( pmo.id_usuario_reg = ' || p_id_usuario || ') and ';

                        else
                            v_filtro = '(pmo.id_funcionario = ' || v_id_funcionario_sol ||
                                       ' or pmo.id_usuario_reg = ' || p_id_usuario || ') and ';

                        end if;
                    end if;

                end if;
            end if;

            if v_parametros.tipo_interfaz = 'PermisoVoBo' then

                v_filtro = '';

                if p_administrador != 1 then

                    select f.id_funcionario
                    into v_id_funcionario_sol
                    from segu.vusuario u
                             inner join orga.vfuncionario_persona f on f.id_persona = u.id_persona
                    where u.id_usuario = p_id_usuario;

                    v_filtro = 'wet.id_funcionario =  ' || v_id_funcionario_sol || ' and ';

                end if;
            end if;

            if v_parametros.tipo_interfaz = 'PermisoRRHH' or v_parametros.tipo_interfaz = 'PermisoRrhh' then
                v_filtro = '';
            end if;
            --Sentencia de la consulta de conteo de registros
            v_consulta := 'select count(id_permiso)
					    from asis.tpermiso pmo
					    inner join segu.tusuario usu1 on usu1.id_usuario = pmo.id_usuario_reg
                        inner join asis.ttipo_permiso tip on tip.id_tipo_permiso = pmo.id_tipo_permiso
                        inner join orga.vfuncionario_cargo fun on fun.id_funcionario = pmo.id_funcionario
                        inner join wf.testado_wf wet on wet.id_estado_wf = pmo.id_estado_wf
                        inner join orga.vfuncionario rep on rep.id_funcionario = pmo.id_responsable
                        inner join orga.tuo dep ON dep.id_uo = orga.f_get_uo_departamento(fun.id_uo, NULL::integer, NULL::date)
                        left join segu.tusuario usu2 on usu2.id_usuario = pmo.id_usuario_mod
                        left join orga.vfuncionario ded on ded.id_funcionario = pmo.id_funcionario_sol
                        left join asis.tdetalle_tipo_permiso dt on dt.id_detalle_tipo_permiso = pmo.id_tipo_licencia
                        where fun.fecha_asignacion <= now()::date
                        and (fun.fecha_finalizacion is null or fun.fecha_finalizacion >= now()::date) and ' || v_filtro;

            --Definicion de la respuesta
            v_consulta := v_consulta || v_parametros.filtro;

            --Devuelve la respuesta
            return v_consulta;

        end;


        /*********************************
         #TRANSACCION:  'ASIS_RFL_SEL'
         #DESCRIPCION:	Conteo de registros
         #AUTOR:		miguel.mamani
         #FECHA:		16-10-2019 13:14:05
        ***********************************/

    elsif (p_transaccion = 'ASIS_RFL_SEL') then

        begin


            v_consulta := 'WITH RECURSIVE path(id_funcionario,id_uo,presupuesta,gerencia,numero_nivel) AS (
                                      SELECT uofun.id_funcionario,uo.id_uo,uo.presupuesta,uo.gerencia, no.numero_nivel
                                      from orga.tuo_funcionario uofun
                                      inner join orga.tuo uo on uo.id_uo = uofun.id_uo
                                      inner join orga.tnivel_organizacional no on no.id_nivel_organizacional = uo.id_nivel_organizacional
                                      where uofun.fecha_asignacion <= now()::date and (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >= now()::date)
                                      and uofun.estado_reg = ''activo'' and uofun.id_funcionario = ' ||
                          v_parametros.id_funcionario || '
                                  UNION
                                      SELECT uofun.id_funcionario,euo.id_uo_padre,uo.presupuesta,uo.gerencia,no.numero_nivel
                                      from orga.testructura_uo euo
                                      inner join orga.tuo uo on uo.id_uo = euo.id_uo_padre
                                      inner join orga.tnivel_organizacional no on no.id_nivel_organizacional = uo.id_nivel_organizacional
                                      inner join path hijo on hijo.id_uo = euo.id_uo_hijo
                                      left join orga.tuo_funcionario uofun on uo.id_uo = uofun.id_uo and uofun.estado_reg = ''activo'' and
                                      uofun.fecha_asignacion <= now()::date and (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >= now()::date)
                             )
                             SELECT p.id_funcionario,
                                    f.desc_funcionario1,
                                    f.codigo,
                                    p.numero_nivel
                             FROM path p
                             inner join orga.vfuncionario f on f.id_funcionario = p.id_funcionario
                             where p.numero_nivel in (1,2,4,6) and p.id_funcionario != ' ||
                          v_parametros.id_funcionario || ' and ';

            --Definicion de la respuesta
            v_consulta := v_consulta || v_parametros.filtro;
            v_consulta := v_consulta || ' order by ' || v_parametros.ordenacion || ' ' || v_parametros.dir_ordenacion ||
                          ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
            raise notice '%',v_consulta;
            --Devuelve la respuesta
            return v_consulta;
        end;


        /*********************************
         #TRANSACCION:  'ASIS_RFL_CONT'
         #DESCRIPCION:	Conteo de registros
         #AUTOR:		miguel.mamani
         #FECHA:		16-10-2019 13:14:05
        ***********************************/

    elsif (p_transaccion = 'ASIS_RFL_CONT') then

        begin

            --Sentencia de la consulta de conteo de registros
            v_consulta := ' WITH RECURSIVE path(id_funcionario,id_uo,presupuesta,gerencia,numero_nivel) AS (
                                        SELECT uofun.id_funcionario,uo.id_uo,uo.presupuesta,uo.gerencia, no.numero_nivel
                                        from orga.tuo_funcionario uofun
                                        inner join orga.tuo uo on uo.id_uo = uofun.id_uo
                                        inner join orga.tnivel_organizacional no on no.id_nivel_organizacional = uo.id_nivel_organizacional
                                        where uofun.fecha_asignacion <= now()::date and (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >= now()::date)
                                        and uofun.estado_reg = ''activo'' and uofun.id_funcionario = ' ||
                          v_parametros.id_funcionario || '
                                    UNION
                                        SELECT uofun.id_funcionario,euo.id_uo_padre,uo.presupuesta,uo.gerencia,no.numero_nivel
                                        from orga.testructura_uo euo
                                        inner join orga.tuo uo on uo.id_uo = euo.id_uo_padre
                                        inner join orga.tnivel_organizacional no on no.id_nivel_organizacional = uo.id_nivel_organizacional
                                        inner join path hijo on hijo.id_uo = euo.id_uo_hijo
                                        left join orga.tuo_funcionario uofun on uo.id_uo = uofun.id_uo and uofun.estado_reg = ''activo'' and
                                        uofun.fecha_asignacion <= now()::date and (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >= now()::date)
                               )
                               SELECT count(p.id_funcionario)
                               FROM path p
                               inner join orga.vfuncionario f on f.id_funcionario = p.id_funcionario
                               where p.numero_nivel in (1,2,4,6) and p.id_funcionario != ' ||
                          v_parametros.id_funcionario || ' and ';

            --Definicion de la respuesta
            v_consulta := v_consulta || v_parametros.filtro;
            --Devuelve la respuesta
            return v_consulta;

        end;

        /*********************************
      #TRANSACCION:  'ASIS_AOES_SEL'
      #DESCRIPCION:	Consult area list
      #AUTOR:		MMV
      #FECHA:		17-07-2019 17:41:55
      ***********************************/

    elsif (p_transaccion = 'ASIS_AOES_SEL') then

        begin
            --Sentencia de la consulta
            v_consulta := ' select ts.id_tipo_estado,
                                 ts.codigo,
                                 ts.nombre_estado,
                                 mp.codigo as codigo_macro
                          from wf.tproceso_macro mp
                          inner join wf.ttipo_proceso tp on tp.id_proceso_macro = mp.id_proceso_macro
                          inner join wf.ttipo_estado ts on ts.id_tipo_proceso = tp.id_tipo_proceso
                          where ts.estado_reg = ''activo'' and';

            --Definicion de la respuesta
            v_consulta := v_consulta || v_parametros.filtro;
            v_consulta := v_consulta || ' order by ' || v_parametros.ordenacion || ' ' || v_parametros.dir_ordenacion ||
                          ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
            --Devuelve la respuesta
            return v_consulta;

        end;

        /*********************************
        #TRANSACCION:  'ASIS_AOES_CONT'
        #DESCRIPCION:	Count area list
        #AUTOR:		MMV
        #FECHA:		17-07-2019 17:41:55
        ***********************************/

    elsif (p_transaccion = 'ASIS_AOES_CONT') then

        begin
            --Sentencia de la consulta de conteo de registros
            v_consulta := ' select count(ts.id_tipo_estado)
                          from wf.tproceso_macro mp
                          inner join wf.ttipo_proceso tp on tp.id_proceso_macro = mp.id_proceso_macro
                          inner join wf.ttipo_estado ts on ts.id_tipo_proceso = tp.id_tipo_proceso
                          where ts.estado_reg = ''activo'' and';

            --Definicion de la respuesta
            v_consulta := v_consulta || v_parametros.filtro;
            --Devuelve la respuesta
            return v_consulta;

        end;


    else


        raise exception 'Transaccion inexistente';

    end if;

EXCEPTION

    WHEN OTHERS THEN
        v_resp = '';
        v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', SQLERRM);
        v_resp = pxp.f_agrega_clave(v_resp, 'codigo_error', SQLSTATE);
        v_resp = pxp.f_agrega_clave(v_resp, 'procedimientos', v_nombre_funcion);
        raise exception '%',v_resp;
END;
$$;

