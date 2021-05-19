create or replace function asis.ft_compensacion_sel(p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying) returns character varying
    language plpgsql
as
$$
/**************************************************************************
 SISTEMA:        Sistema de Asistencia
 FUNCION:         asis.ft_compensacion_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.tcompensacion'
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

    v_consulta            VARCHAR;
    v_parametros          RECORD;
    v_nombre_funcion      TEXT;
    v_resp                VARCHAR;

BEGIN

    v_nombre_funcion = 'asis.ft_compensacion_sel';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
     #TRANSACCION:  'ASIS_CPM_SEL'
     #DESCRIPCION:    Consulta de datos
     #AUTOR:        amamani
     #FECHA:        18-05-2021 14:14:39
    ***********************************/

    IF (p_transaccion='ASIS_CPM_SEL') THEN

        BEGIN
            --Sentencia de la consulta
            v_consulta:='SELECT    cpm.id_compensacion,
                                   cpm.estado_reg,
                                   cpm.id_funcionario,
                                   cpm.id_responsable,
                                   cpm.desde,
                                   cpm.hasta,
                                   cpm.dias,
                                   cpm.desde_comp,
                                   cpm.hasta_comp,
                                   cpm.dias_comp,
                                   cpm.justificacion,
                                   cpm.id_usuario_reg,
                                   cpm.fecha_reg,
                                   cpm.id_usuario_ai,
                                   cpm.usuario_ai,
                                   cpm.id_usuario_mod,
                                   cpm.fecha_mod,
                                   usu1.cuenta as usr_reg,
                                   usu2.cuenta as usr_mod,
                                   cpm.id_procesos_wf,
                                   cpm.id_estado_wf,
                                   cpm.estado,
                                   cpm.nro_tramite,
                                   f.desc_funcionario2  as funcionario,
                                   r.desc_funcionario2 as responsable
                            FROM asis.tcompensacion cpm
                                     JOIN segu.tusuario usu1 ON usu1.id_usuario = cpm.id_usuario_reg
                                     JOIN orga.vfuncionario f on f.id_funcionario = cpm.id_funcionario
                                     JOIN orga.vfuncionario r on r.id_funcionario = cpm.id_responsable
                                     LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = cpm.id_usuario_mod
                        WHERE  ';

            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            --Devuelve la respuesta
            RETURN v_consulta;

        END;

        /*********************************
         #TRANSACCION:  'ASIS_CPM_CONT'
         #DESCRIPCION:    Conteo de registros
         #AUTOR:        amamani
         #FECHA:        18-05-2021 14:14:39
        ***********************************/

    ELSIF (p_transaccion='ASIS_CPM_CONT') THEN

        BEGIN
            --Sentencia de la consulta de conteo de registros
            v_consulta:='SELECT COUNT(id_compensacion)
                         FROM asis.tcompensacion cpm
                         JOIN segu.tusuario usu1 ON usu1.id_usuario = cpm.id_usuario_reg
                         JOIN orga.vfuncionario f on f.id_funcionario = cpm.id_funcionario
                         JOIN orga.vfuncionario r on r.id_funcionario = cpm.id_responsable
                         LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = cpm.id_usuario_mod
                         WHERE ';

            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;

            --Devuelve la respuesta
            RETURN v_consulta;

        END;

    ELSE

        RAISE EXCEPTION 'Transaccion inexistente';

    END IF;

EXCEPTION

    WHEN OTHERS THEN
        v_resp='';
        v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
        v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
        v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
        RAISE EXCEPTION '%',v_resp;
END;
$$;
