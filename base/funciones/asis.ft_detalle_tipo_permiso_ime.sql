create or replace function asis.ft_detalle_tipo_permiso_ime(p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying) returns character varying
    language plpgsql
as
$$
/**************************************************************************
 SISTEMA:        Sistema de Asistencia
 FUNCION:         asis.ft_detalle_tipo_permiso_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.tdetalle_tipo_permiso'
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

    v_nro_requerimiento        INTEGER;
    v_parametros               RECORD;
    v_id_requerimiento         INTEGER;
    v_resp                     VARCHAR;
    v_nombre_funcion           TEXT;
    v_mensaje_error            TEXT;
    v_id_detalle_tipo_permiso    INTEGER;

BEGIN

    v_nombre_funcion = 'asis.ft_detalle_tipo_permiso_ime';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
     #TRANSACCION:  'ASIS_DTP_INS'
     #DESCRIPCION:    Insercion de registros
     #AUTOR:        admin.miguel
     #FECHA:        22-03-2021 01:35:43
    ***********************************/

    IF (p_transaccion='ASIS_DTP_INS') THEN

        BEGIN
            --Sentencia de la insercion
            INSERT INTO asis.tdetalle_tipo_permiso(
                estado_reg,
                nombre,
                descripcion,
                dias,
                id_usuario_reg,
                fecha_reg,
                id_usuario_ai,
                usuario_ai,
                id_usuario_mod,
                fecha_mod,
                id_tipo_permiso
            ) VALUES (
                         'activo',
                         v_parametros.nombre,
                         v_parametros.descripcion,
                         v_parametros.dias,
                         p_id_usuario,
                         now(),
                         v_parametros._id_usuario_ai,
                         v_parametros._nombre_usuario_ai,
                         null,
                         null,
                         v_parametros.id_tipo_permiso
                     ) RETURNING id_detalle_tipo_permiso into v_id_detalle_tipo_permiso;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','detalle tipo permiso almacenado(a) con exito (id_detalle_tipo_permiso'||v_id_detalle_tipo_permiso||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_detalle_tipo_permiso',v_id_detalle_tipo_permiso::varchar);

            --Devuelve la respuesta
            RETURN v_resp;

        END;

        /*********************************
         #TRANSACCION:  'ASIS_DTP_MOD'
         #DESCRIPCION:    Modificacion de registros
         #AUTOR:        admin.miguel
         #FECHA:        22-03-2021 01:35:43
        ***********************************/

    ELSIF (p_transaccion='ASIS_DTP_MOD') THEN

        BEGIN
            --Sentencia de la modificacion
            UPDATE asis.tdetalle_tipo_permiso SET
                                                  nombre = v_parametros.nombre,
                                                  descripcion = v_parametros.descripcion,
                                                  dias = v_parametros.dias,
                                                  id_usuario_mod = p_id_usuario,
                                                  fecha_mod = now(),
                                                  id_usuario_ai = v_parametros._id_usuario_ai,
                                                  usuario_ai = v_parametros._nombre_usuario_ai,
                                                  id_tipo_permiso = v_parametros.id_tipo_permiso
            WHERE id_detalle_tipo_permiso=v_parametros.id_detalle_tipo_permiso;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','detalle tipo permiso modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_detalle_tipo_permiso',v_parametros.id_detalle_tipo_permiso::varchar);

            --Devuelve la respuesta
            RETURN v_resp;

        END;

        /*********************************
         #TRANSACCION:  'ASIS_DTP_ELI'
         #DESCRIPCION:    Eliminacion de registros
         #AUTOR:        admin.miguel
         #FECHA:        22-03-2021 01:35:43
        ***********************************/

    ELSIF (p_transaccion='ASIS_DTP_ELI') THEN

        BEGIN
            --Sentencia de la eliminacion
            DELETE FROM asis.tdetalle_tipo_permiso
            WHERE id_detalle_tipo_permiso=v_parametros.id_detalle_tipo_permiso;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','detalle tipo permiso eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_detalle_tipo_permiso',v_parametros.id_detalle_tipo_permiso::varchar);

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
$$;

