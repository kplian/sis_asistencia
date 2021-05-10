create or replace function asis.ft_detalle_tipo_permiso_sel(p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying) returns character varying
    language plpgsql
as
$$
/**************************************************************************
 SISTEMA:        Sistema de Asistencia
 FUNCION:         asis.ft_detalle_tipo_permiso_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.tdetalle_tipo_permiso'
 AUTOR:          (admin.miguel)
 FECHA:            22-03-2021 01:35:43
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE                FECHA                AUTOR                DESCRIPCION
 #0                22-03-2021 01:35:43    admin.miguel             Creacion
 #
 ***************************************************************************/

DECLARE

    v_consulta            VARCHAR;
    v_parametros          RECORD;
    v_nombre_funcion      TEXT;
    v_resp                VARCHAR;

BEGIN

    v_nombre_funcion = 'asis.ft_detalle_tipo_permiso_sel';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
     #TRANSACCION:  'ASIS_DTP_SEL'
     #DESCRIPCION:    Consulta de datos
     #AUTOR:        admin.miguel
     #FECHA:        22-03-2021 01:35:43
    ***********************************/

    IF (p_transaccion='ASIS_DTP_SEL') THEN

        BEGIN
            --Sentencia de la consulta
            v_consulta:='SELECT
                        dtp.id_detalle_tipo_permiso,
                        dtp.estado_reg,
                        dtp.nombre,
                        dtp.descripcion,
                        dtp.dias,
                        dtp.id_usuario_reg,
                        dtp.fecha_reg,
                        dtp.id_usuario_ai,
                        dtp.usuario_ai,
                        dtp.id_usuario_mod,
                        dtp.fecha_mod,
                        usu1.cuenta as usr_reg,
                        usu2.cuenta as usr_mod,
                        dtp.id_tipo_permiso
                        FROM asis.tdetalle_tipo_permiso dtp
                        JOIN segu.tusuario usu1 ON usu1.id_usuario = dtp.id_usuario_reg
                        LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = dtp.id_usuario_mod
                        WHERE  ';

            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            --Devuelve la respuesta
            RETURN v_consulta;

        END;

        /*********************************
         #TRANSACCION:  'ASIS_DTP_CONT'
         #DESCRIPCION:    Conteo de registros
         #AUTOR:        admin.miguel
         #FECHA:        22-03-2021 01:35:43
        ***********************************/

    ELSIF (p_transaccion='ASIS_DTP_CONT') THEN

        BEGIN
            --Sentencia de la consulta de conteo de registros
            v_consulta:='SELECT COUNT(id_detalle_tipo_permiso)
                         FROM asis.tdetalle_tipo_permiso dtp
                         JOIN segu.tusuario usu1 ON usu1.id_usuario = dtp.id_usuario_reg
                         LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = dtp.id_usuario_mod
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


