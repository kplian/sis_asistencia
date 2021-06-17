CREATE
    OR REPLACE FUNCTION "asis"."ft_programacion_sel"(p_administrador integer, p_id_usuario integer,
                                                     p_tabla character varying, p_transaccion character varying)
    RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:        Sistema de Asistencia
 FUNCION:         asis.ft_programacion_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.tprogramacion'
 AUTOR:          (admin.miguel)
 FECHA:            14-12-2020 20:28:34
 COMENTARIOS:    
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE                FECHA                AUTOR                DESCRIPCION
 #0                14-12-2020 20:28:34    admin.miguel             Creacion    
 #
 ***************************************************************************/

DECLARE

    v_consulta          VARCHAR;
    v_parametros        RECORD;
    v_nombre_funcion    TEXT;
    v_resp              VARCHAR;
    v_fecha_inicio      date;
    v_fecha_fin         date;
    v_filtro            varchar;
    v_id_resposable     integer;
    v_id_uo             integer;
    v_list_funcionarios text;
BEGIN

    v_nombre_funcion = 'asis.ft_programacion_sel';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************    
     #TRANSACCION:  'ASIS_PRNCAL_SEL'
     #DESCRIPCION:    Consulta de datos
     #AUTOR:        admin.miguel    
     #FECHA:        14-12-2020 20:28:34
    ***********************************/

    IF
        (p_transaccion = 'ASIS_PRNCAL_SEL') THEN

        BEGIN
            v_filtro = '';

            if (v_parametros.nombreVista = 'Programacion' OR v_parametros.nombreVista = 'ListaProgramacion') then
                if p_administrador != 1 then
                    v_filtro = ' (prn.id_funcionario = ' ||
                               v_parametros.id_funcionario || ') AND ';
                end if;
            end if;

            if (v_parametros.nombreVista = 'ProgramacionVoBo' OR
                v_parametros.nombreVista = 'ListaProgramacionVoBo') then
                if p_administrador != 1 then


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
                      and f.id_funcionario = v_parametros.id_funcionario;


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
                    select pxp.list(fun.id_funcionario::varchar)
                    into v_list_funcionarios
                    from uo_mas_subordinados suo
                             inner join orga.tuo ou on ou.id_uo = suo.id_uo_hijo
                             inner join orga.vfuncionario_cargo fun on fun.id_uo = suo.id_uo_hijo
                             inner join orga.tnivel_organizacional ni
                                        on ni.id_nivel_organizacional = ou.id_nivel_organizacional
                    where (fun.fecha_finalizacion is null or fun.fecha_finalizacion >= now()::date)
                      and fun.id_funcionario != v_id_resposable;

                    v_filtro = ' (prn.id_funcionario in ( ' || v_list_funcionarios || ')) AND ';
                end if;
            end if;


            --Sentencia de la consulta
            v_consulta := 'SELECT prn.id_programacion,
                                   prn.fecha_programada fecha_inicio,
                                   prn.fecha_programada fecha_fin,
                                   prn.tiempo,
                                   prn.valor,
                                   fun.desc_funcionario1,
                                   fun.id_funcionario,
                                   prn.estado
                            FROM asis.tprogramacion prn
                                     inner join orga.vfuncionario fun on fun.id_funcionario = prn.id_funcionario
                        WHERE  ' || v_filtro;

            --Definicion de la respuesta
            v_consulta := v_consulta || v_parametros.filtro;
            --             v_consulta := v_consulta || ' order by ' || v_parametros.ordenacion || ' ' || v_parametros.dir_ordenacion;

            --Devuelve la respuesta
--             raise exception 'QUERY %', v_consulta;
            RETURN v_consulta;

        END;
        /*********************************
        #TRANSACCION:  'ASIS_PRN_SEL'
        #DESCRIPCION:    Conteo de registros
        #AUTOR:        admin.miguel
        #FECHA:        14-12-2020 20:28:34
       ***********************************/
    ELSIF (p_transaccion = 'ASIS_PRN_SEL') THEN

        BEGIN
            --Sentencia de la consulta
            v_filtro = '';

            if (v_parametros.nombreVista = 'Programacion' OR v_parametros.nombreVista = 'ListaProgramacion') then
                if p_administrador != 1 then
                    v_filtro = ' (prn.id_funcionario = ' ||
                               v_parametros.id_funcionario || ') AND ';
                end if;
            end if;

            if (v_parametros.nombreVista = 'ProgramacionVoBo' OR
                v_parametros.nombreVista = 'ListaProgramacionVoBo') then
                if p_administrador != 1 then
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
                      and f.id_funcionario = v_parametros.id_funcionario;


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
                    select pxp.list(fun.id_funcionario::varchar)
                    into v_list_funcionarios
                    from uo_mas_subordinados suo
                             inner join orga.tuo ou on ou.id_uo = suo.id_uo_hijo
                             inner join orga.vfuncionario_cargo fun on fun.id_uo = suo.id_uo_hijo
                             inner join orga.tnivel_organizacional ni
                                        on ni.id_nivel_organizacional = ou.id_nivel_organizacional
                    where (fun.fecha_finalizacion is null or fun.fecha_finalizacion >= now()::date)
                      and fun.id_funcionario != v_id_resposable;

                    v_filtro = ' (prn.id_funcionario in ( ' || v_list_funcionarios || ')) AND ';
                end if;
            end if;

            v_consulta := 'SELECT
                        prn.id_programacion,
                        prn.estado_reg,
                        prn.fecha_programada,
                        prn.id_funcionario,
                        prn.estado,
                        prn.tiempo,
                        prn.valor,
                        prn.id_vacacion_det,
                        prn.id_usuario_reg,
                        prn.fecha_reg,
                        prn.id_usuario_ai,
                        prn.usuario_ai,
                        prn.id_usuario_mod,
                        prn.fecha_mod,
                        usu1.cuenta as usr_reg,
                        usu2.cuenta as usr_mod,
                        fun.desc_funcionario1
                        FROM asis.tprogramacion prn
                        JOIN segu.tusuario usu1 ON usu1.id_usuario = prn.id_usuario_reg
                        LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = prn.id_usuario_mod
                        inner join orga.vfuncionario fun on fun.id_funcionario = prn.id_funcionario
                        WHERE  ' || v_filtro;

            --Definicion de la respuesta
            v_consulta := v_consulta || v_parametros.filtro;
            v_consulta := v_consulta || ' order by ' || v_parametros.ordenacion || ' ' || v_parametros.dir_ordenacion ||
                          ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            --Devuelve la respuesta

            RETURN v_consulta;

        END;

        /*********************************
         #TRANSACCION:  'ASIS_PRN_CONT'
         #DESCRIPCION:    Conteo de registros
         #AUTOR:        admin.miguel
         #FECHA:        14-12-2020 20:28:34
        ***********************************/

    ELSIF
        (p_transaccion = 'ASIS_PRN_CONT') THEN

        BEGIN
            --Sentencia de la consulta de conteo de registros
            v_consulta
                := 'SELECT COUNT(id_programacion)
                         FROM asis.tprogramacion prn
                         JOIN segu.tusuario usu1 ON usu1.id_usuario = prn.id_usuario_reg
                         LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = prn.id_usuario_mod
                         WHERE ';

            --Definicion de la respuesta
            v_consulta
                := v_consulta || v_parametros.filtro;

            --Devuelve la respuesta
            RETURN v_consulta;

        END;
    ELSE

        RAISE EXCEPTION 'Transaccion inexistente';

    END IF;

EXCEPTION

    WHEN OTHERS THEN
        v_resp = '';
        v_resp
            = pxp.f_agrega_clave(v_resp, 'mensaje', SQLERRM);
        v_resp
            = pxp.f_agrega_clave(v_resp, 'codigo_error', SQLSTATE);
        v_resp
            = pxp.f_agrega_clave(v_resp, 'procedimientos', v_nombre_funcion);
        RAISE
            EXCEPTION '%',v_resp;
END;
$BODY$
    LANGUAGE 'plpgsql' VOLATILE
                       COST 100;
ALTER FUNCTION "asis"."ft_programacion_sel"(integer, integer, character varying, character varying) OWNER TO postgres;