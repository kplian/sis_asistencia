CREATE OR REPLACE FUNCTION "asis"."ft_programacion_sel"(    
                p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
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

    v_consulta            VARCHAR;
    v_parametros          RECORD;
    v_nombre_funcion      TEXT;
    v_resp                VARCHAR;
                
BEGIN

    v_nombre_funcion = 'asis.ft_programacion_sel';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************    
     #TRANSACCION:  'ASIS_PRN_SEL'
     #DESCRIPCION:    Consulta de datos
     #AUTOR:        admin.miguel    
     #FECHA:        14-12-2020 20:28:34
    ***********************************/

    IF (p_transaccion='ASIS_PRN_SEL') THEN
                     
        BEGIN
            --Sentencia de la consulta
            v_consulta:='SELECT
                        prn.id_programacion,
                        prn.estado_reg,
                        prn.id_periodo,
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
                        usu2.cuenta as usr_mod    
                        FROM asis.tprogramacion prn
                        JOIN segu.tusuario usu1 ON usu1.id_usuario = prn.id_usuario_reg
                        LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = prn.id_usuario_mod
                        WHERE  ';
            
            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            --Devuelve la respuesta
            RETURN v_consulta;
                        
        END;

    /*********************************    
     #TRANSACCION:  'ASIS_PRN_CONT'
     #DESCRIPCION:    Conteo de registros
     #AUTOR:        admin.miguel    
     #FECHA:        14-12-2020 20:28:34
    ***********************************/

    ELSIF (p_transaccion='ASIS_PRN_CONT') THEN

        BEGIN
            --Sentencia de la consulta de conteo de registros
            v_consulta:='SELECT COUNT(id_programacion)
                         FROM asis.tprogramacion prn
                         JOIN segu.tusuario usu1 ON usu1.id_usuario = prn.id_usuario_reg
                         LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = prn.id_usuario_mod
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
ALTER FUNCTION "asis"."ft_programacion_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
