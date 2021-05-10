CREATE OR REPLACE FUNCTION "asis"."ft_tipo_bm_sel"(    
                p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:        Sistema de Asistencia
 FUNCION:         asis.ft_tipo_bm_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.ttipo_bm'
 AUTOR:          (admin.miguel)
 FECHA:            05-02-2021 14:41:34
 COMENTARIOS:    
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE                FECHA                AUTOR                DESCRIPCION
 #0                05-02-2021 14:41:34    admin.miguel             Creacion    
 #
 ***************************************************************************/

DECLARE

    v_consulta            VARCHAR;
    v_parametros          RECORD;
    v_nombre_funcion      TEXT;
    v_resp                VARCHAR;
                
BEGIN

    v_nombre_funcion = 'asis.ft_tipo_bm_sel';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************    
     #TRANSACCION:  'ASIS_TBA_SEL'
     #DESCRIPCION:    Consulta de datos
     #AUTOR:        admin.miguel    
     #FECHA:        05-02-2021 14:41:34
    ***********************************/

    IF (p_transaccion='ASIS_TBA_SEL') THEN
                     
        BEGIN
            --Sentencia de la consulta
            v_consulta:='SELECT
                        tba.id_tipo_bm,
                        tba.estado_reg,
                        tba.nombre,
                        tba.descripcion,
                        tba.id_usuario_reg,
                        tba.fecha_reg,
                        tba.id_usuario_ai,
                        tba.usuario_ai,
                        tba.id_usuario_mod,
                        tba.fecha_mod,
                        usu1.cuenta as usr_reg,
                        usu2.cuenta as usr_mod    
                        FROM asis.ttipo_bm tba
                        JOIN segu.tusuario usu1 ON usu1.id_usuario = tba.id_usuario_reg
                        LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = tba.id_usuario_mod
                        WHERE  ';
            
            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            --Devuelve la respuesta
            RETURN v_consulta;
                        
        END;

    /*********************************    
     #TRANSACCION:  'ASIS_TBA_CONT'
     #DESCRIPCION:    Conteo de registros
     #AUTOR:        admin.miguel    
     #FECHA:        05-02-2021 14:41:34
    ***********************************/

    ELSIF (p_transaccion='ASIS_TBA_CONT') THEN

        BEGIN
            --Sentencia de la consulta de conteo de registros
            v_consulta:='SELECT COUNT(id_tipo_bm)
                         FROM asis.ttipo_bm tba
                         JOIN segu.tusuario usu1 ON usu1.id_usuario = tba.id_usuario_reg
                         LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = tba.id_usuario_mod
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
$BODY$
LANGUAGE 'plpgsql' VOLATILE
COST 100;
ALTER FUNCTION "asis"."ft_tipo_bm_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
