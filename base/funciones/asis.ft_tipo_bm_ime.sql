CREATE OR REPLACE FUNCTION "asis"."ft_tipo_bm_ime" (    
                p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:        Sistema de Asistencia
 FUNCION:         asis.ft_tipo_bm_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.ttipo_bm'
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

    v_nro_requerimiento        INTEGER;
    v_parametros               RECORD;
    v_id_requerimiento         INTEGER;
    v_resp                     VARCHAR;
    v_nombre_funcion           TEXT;
    v_mensaje_error            TEXT;
    v_id_tipo_bm    INTEGER;
                
BEGIN

    v_nombre_funcion = 'asis.ft_tipo_bm_ime';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************    
     #TRANSACCION:  'ASIS_TBA_INS'
     #DESCRIPCION:    Insercion de registros
     #AUTOR:        admin.miguel    
     #FECHA:        05-02-2021 14:41:34
    ***********************************/

    IF (p_transaccion='ASIS_TBA_INS') THEN
                    
        BEGIN
            --Sentencia de la insercion
            INSERT INTO asis.ttipo_bm(
            estado_reg,
            nombre,
            descripcion,
            id_usuario_reg,
            fecha_reg,
            id_usuario_ai,
            usuario_ai,
            id_usuario_mod,
            fecha_mod
              ) VALUES (
            'activo',
            v_parametros.nombre,
            v_parametros.descripcion,
            p_id_usuario,
            now(),
            v_parametros._id_usuario_ai,
            v_parametros._nombre_usuario_ai,
            null,
            null            
            ) RETURNING id_tipo_bm into v_id_tipo_bm;
            
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo Baja medica almacenado(a) con exito (id_tipo_bm'||v_id_tipo_bm||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_bm',v_id_tipo_bm::varchar);

            --Devuelve la respuesta
            RETURN v_resp;

        END;

    /*********************************    
     #TRANSACCION:  'ASIS_TBA_MOD'
     #DESCRIPCION:    Modificacion de registros
     #AUTOR:        admin.miguel    
     #FECHA:        05-02-2021 14:41:34
    ***********************************/

    ELSIF (p_transaccion='ASIS_TBA_MOD') THEN

        BEGIN
            --Sentencia de la modificacion
            UPDATE asis.ttipo_bm SET
            nombre = v_parametros.nombre,
            descripcion = v_parametros.descripcion,
            id_usuario_mod = p_id_usuario,
            fecha_mod = now(),
            id_usuario_ai = v_parametros._id_usuario_ai,
            usuario_ai = v_parametros._nombre_usuario_ai
            WHERE id_tipo_bm=v_parametros.id_tipo_bm;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo Baja medica modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_bm',v_parametros.id_tipo_bm::varchar);
               
            --Devuelve la respuesta
            RETURN v_resp;
            
        END;

    /*********************************    
     #TRANSACCION:  'ASIS_TBA_ELI'
     #DESCRIPCION:    Eliminacion de registros
     #AUTOR:        admin.miguel    
     #FECHA:        05-02-2021 14:41:34
    ***********************************/

    ELSIF (p_transaccion='ASIS_TBA_ELI') THEN

        BEGIN
            --Sentencia de la eliminacion
            DELETE FROM asis.ttipo_bm
            WHERE id_tipo_bm=v_parametros.id_tipo_bm;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo Baja medica eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_bm',v_parametros.id_tipo_bm::varchar);
              
            --Devuelve la respuesta
            RETURN v_resp;

        END;
         
    ELSE
     
        RAISE EXCEPTION 'Transaccion inexistente: %',p_transaccion;

    END IF;

EXCEPTION
                
    WHEN OTHERS THEN
        v_resp='';
        v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
        v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
        v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
        raise exception '%',v_resp;
                        
END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE
COST 100;
ALTER FUNCTION "asis"."ft_tipo_bm_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
