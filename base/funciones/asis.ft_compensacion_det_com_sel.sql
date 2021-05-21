CREATE OR REPLACE FUNCTION asis.ft_compensacion_det_com_sel (
    p_administrador integer,
    p_id_usuario integer,
    p_tabla varchar,
    p_transaccion varchar
)
    RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:        Sistema de Asistencia
 FUNCION:         asis.ft_compensacion_det_com_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.tcompensacion_det_com'
 AUTOR:          (amamani)
 FECHA:            21-05-2021 17:01:17
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE                FECHA                AUTOR                DESCRIPCION
 #0                21-05-2021 17:01:17    amamani             Creacion
 #
 ***************************************************************************/

DECLARE

    v_consulta            VARCHAR;
    v_parametros          RECORD;
    v_nombre_funcion      TEXT;
    v_resp                VARCHAR;

BEGIN

    v_nombre_funcion = 'asis.ft_compensacion_det_com_sel';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
     #TRANSACCION:  'ASIS_FCN_SEL'
     #DESCRIPCION:    Consulta de datos
     #AUTOR:        amamani
     #FECHA:        21-05-2021 17:01:17
    ***********************************/

    IF (p_transaccion='ASIS_FCN_SEL') THEN

        BEGIN
            --Sentencia de la consulta
            v_consulta:='SELECT
                        fcn.id_compensacion_det_com,
                        fcn.estado_reg,
                        fcn.fecha_comp,
                        fcn.tiempo_comp,
                        fcn.id_compensacion_det,
                        fcn.id_usuario_reg,
                        fcn.fecha_reg,
                        fcn.id_usuario_ai,
                        fcn.usuario_ai,
                        fcn.id_usuario_mod,
                        fcn.fecha_mod,
                        usu1.cuenta as usr_reg,
                        usu2.cuenta as usr_mod
                        FROM asis.tcompensacion_det_com fcn
                        JOIN segu.tusuario usu1 ON usu1.id_usuario = fcn.id_usuario_reg
                        LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = fcn.id_usuario_mod
                        WHERE  ';

            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            --Devuelve la respuesta
            RETURN v_consulta;

        END;

        /*********************************
         #TRANSACCION:  'ASIS_FCN_CONT'
         #DESCRIPCION:    Conteo de registros
         #AUTOR:        amamani
         #FECHA:        21-05-2021 17:01:17
        ***********************************/

    ELSIF (p_transaccion='ASIS_FCN_CONT') THEN

        BEGIN
            --Sentencia de la consulta de conteo de registros
            v_consulta:='SELECT COUNT(id_compensacion_det_com)
                         FROM asis.tcompensacion_det_com fcn
                         JOIN segu.tusuario usu1 ON usu1.id_usuario = fcn.id_usuario_reg
                         LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = fcn.id_usuario_mod
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
$body$
    LANGUAGE 'plpgsql'
    VOLATILE
    CALLED ON NULL INPUT
    SECURITY INVOKER
    PARALLEL UNSAFE
    COST 100;

ALTER FUNCTION asis.ft_compensacion_det_com_sel (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
    OWNER TO postgres;