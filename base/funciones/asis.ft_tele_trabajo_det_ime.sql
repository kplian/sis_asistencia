CREATE
OR REPLACE FUNCTION "asis"."ft_tele_trabajo_det_ime" (
                p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:        Sistema de Asistencia
 FUNCION:         asis.ft_tele_trabajo_det_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.ttele_trabajo_det'
 AUTOR:          (admin.miguel)
 FECHA:            10-03-2021 14:50:44
 COMENTARIOS:    
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE                FECHA                AUTOR                DESCRIPCION
 #0                10-03-2021 14:50:44    admin.miguel             Creacion    
 #
 ***************************************************************************/

DECLARE

v_nro_requerimiento        INTEGER;
    v_parametros
RECORD;
    v_id_requerimiento
INTEGER;
    v_resp
VARCHAR;
    v_nombre_funcion
TEXT;
    v_mensaje_error
TEXT;
    v_id_tele_trabajo_det
INTEGER;

BEGIN

    v_nombre_funcion
= 'asis.ft_tele_trabajo_det_ime';
    v_parametros
= pxp.f_get_record(p_tabla);

    /*********************************    
     #TRANSACCION:  'ASIS_TTD_INS'
     #DESCRIPCION:    Insercion de registros
     #AUTOR:        admin.miguel    
     #FECHA:        10-03-2021 14:50:44
    ***********************************/

    IF
(p_transaccion='ASIS_TTD_INS') THEN

BEGIN
            --Sentencia de la insercion
INSERT INTO asis.ttele_trabajo_det(estado_reg,
                                   id_tele_trabajo,
                                   fecha,
                                   id_usuario_reg,
                                   fecha_reg,
                                   id_usuario_ai,
                                   usuario_ai,
                                   id_usuario_mod,
                                   fecha_mod)
VALUES ('activo',
        v_parametros.id_tele_trabajo,
        v_parametros.fecha,
        p_id_usuario,
        now(),
        v_parametros._id_usuario_ai,
        v_parametros._nombre_usuario_ai,
        null,
        null) RETURNING id_tele_trabajo_det
into v_id_tele_trabajo_det;

--Definicion de la respuesta
v_resp
= pxp.f_agrega_clave(v_resp,'mensaje','Tele Trabajo  Detalle almacenado(a) con exito (id_tele_trabajo_det'||v_id_tele_trabajo_det||')');
            v_resp
= pxp.f_agrega_clave(v_resp,'id_tele_trabajo_det',v_id_tele_trabajo_det::varchar);

            --Devuelve la respuesta
RETURN v_resp;

END;

    /*********************************    
     #TRANSACCION:  'ASIS_TTD_MOD'
     #DESCRIPCION:    Modificacion de registros
     #AUTOR:        admin.miguel    
     #FECHA:        10-03-2021 14:50:44
    ***********************************/

    ELSIF
(p_transaccion='ASIS_TTD_MOD') THEN

BEGIN
            --Sentencia de la modificacion
UPDATE asis.ttele_trabajo_det
SET id_tele_trabajo = v_parametros.id_tele_trabajo,
    fecha           = v_parametros.fecha,
    id_usuario_mod  = p_id_usuario,
    fecha_mod       = now(),
    id_usuario_ai   = v_parametros._id_usuario_ai,
    usuario_ai = v_parametros._nombre_usuario_ai
WHERE id_tele_trabajo_det=v_parametros.id_tele_trabajo_det;

--Definicion de la respuesta
v_resp
= pxp.f_agrega_clave(v_resp,'mensaje','Tele Trabajo  Detalle modificado(a)');
            v_resp
= pxp.f_agrega_clave(v_resp,'id_tele_trabajo_det',v_parametros.id_tele_trabajo_det::varchar);
               
            --Devuelve la respuesta
RETURN v_resp;

END;

    /*********************************    
     #TRANSACCION:  'ASIS_TTD_ELI'
     #DESCRIPCION:    Eliminacion de registros
     #AUTOR:        admin.miguel    
     #FECHA:        10-03-2021 14:50:44
    ***********************************/

    ELSIF
(p_transaccion='ASIS_TTD_ELI') THEN

BEGIN
            --Sentencia de la eliminacion
DELETE
FROM asis.ttele_trabajo_det
WHERE id_tele_trabajo_det = v_parametros.id_tele_trabajo_det;

--Definicion de la respuesta
v_resp
= pxp.f_agrega_clave(v_resp,'mensaje','Tele Trabajo  Detalle eliminado(a)');
            v_resp
= pxp.f_agrega_clave(v_resp,'id_tele_trabajo_det',v_parametros.id_tele_trabajo_det::varchar);
              
            --Devuelve la respuesta
RETURN v_resp;

END;

ELSE
     
        RAISE EXCEPTION 'Transaccion inexistente: %',p_transaccion;

END IF;

EXCEPTION
                
    WHEN OTHERS THEN
        v_resp='';
        v_resp
= pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
        v_resp
= pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
        v_resp
= pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
        raise
exception '%',v_resp;

END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE
COST 100;
ALTER FUNCTION "asis"."ft_tele_trabajo_det_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
