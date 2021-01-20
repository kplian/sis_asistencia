CREATE OR REPLACE FUNCTION "asis"."ft_programacion_ime"(p_administrador integer, p_id_usuario integer,
                                                        p_tabla character varying, p_transaccion character varying)
    RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:        Sistema de Asistencia
 FUNCION:         asis.ft_programacion_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.tprogramacion'
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

    v_nro_requerimiento INTEGER;
    v_parametros        RECORD;
    v_id_requerimiento  INTEGER;
    v_resp              VARCHAR;
    v_nombre_funcion    TEXT;
    v_mensaje_error     TEXT;
    v_id_programacion   INTEGER;
    v_date              date;
BEGIN

    v_nombre_funcion = 'asis.ft_programacion_ime';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************    
     #TRANSACCION:  'ASIS_PRN_INS'
     #DESCRIPCION:    Insercion de registros
     #AUTOR:        admin.miguel    
     #FECHA:        14-12-2020 20:28:34
    ***********************************/

    IF (p_transaccion = 'ASIS_PRN_INS') THEN

        BEGIN
            --Sentencia de la insercion
            for v_date in (SELECT d.date
                           FROM GENERATE_SERIES(v_parametros.fecha_programada, v_parametros.fecha_fin,
                                                '1 day'::INTERVAL) d)
                loop
                    INSERT INTO asis.tprogramacion(estado_reg,
                                                   id_periodo,
                                                   fecha_programada,
                                                   id_funcionario,
                                                   estado,
                                                   tiempo,
                                                   valor,
                                                   id_vacacion_det,
                                                   id_usuario_reg,
                                                   fecha_reg,
                                                   id_usuario_ai,
                                                   usuario_ai,
                                                   id_usuario_mod,
                                                   fecha_mod)
                    VALUES ('activo',
                            null,
                            v_date,
                            v_parametros.id_funcionario,
                            'pendiente',
                            v_parametros.tiempo,
                            v_parametros.valor,
                            null,
                            p_id_usuario,
                            now(),
                            v_parametros._id_usuario_ai,
                            v_parametros._nombre_usuario_ai,
                            null,
                            null)
                    RETURNING id_programacion into v_id_programacion;
                end loop;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp, 'mensaje',
                                        'Programacion almacenado(a) con exito (id_programacion' || v_id_programacion ||
                                        ')');
            v_resp = pxp.f_agrega_clave(v_resp, 'id_programacion', v_id_programacion::varchar);

            --Devuelve la respuesta
            RETURN v_resp;

        END;

        /*********************************
         #TRANSACCION:  'ASIS_PRN_MOD'
         #DESCRIPCION:    Modificacion de registros
         #AUTOR:        admin.miguel
         #FECHA:        14-12-2020 20:28:34
        ***********************************/

    ELSIF (p_transaccion = 'ASIS_PRN_MOD') THEN

        BEGIN
            --Sentencia de la modificacion
            UPDATE asis.tprogramacion
            SET fecha_programada = v_parametros.fecha_programada,
                id_funcionario   = v_parametros.id_funcionario,
                tiempo           = v_parametros.tiempo,
                valor            = v_parametros.valor,
                id_usuario_mod   = p_id_usuario,
                fecha_mod        = now(),
                id_usuario_ai    = v_parametros._id_usuario_ai,
                usuario_ai       = v_parametros._nombre_usuario_ai
            WHERE id_programacion = v_parametros.id_programacion;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'Programacion modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp, 'id_programacion', v_parametros.id_programacion::varchar);

            --Devuelve la respuesta
            RETURN v_resp;

        END;
        /*********************************
         #TRANSACCION:  'ASIS_MOD_CFP'
         #DESCRIPCION:    Modificacion de registros
         #AUTOR:        admin.miguel
         #FECHA:        14-12-2020 20:28:34
        ***********************************/

    ELSIF (p_transaccion = 'ASIS_MOD_CFP') THEN

        BEGIN
            --Sentencia de la modificacion
            UPDATE asis.tprogramacion
            SET fecha_programada = v_parametros.fecha_programada
            WHERE id_programacion = v_parametros.id_programacion;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'Programacion modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp, 'id_programacion', v_parametros.id_programacion::varchar);

            --Devuelve la respuesta
            RETURN v_resp;

        END;
        /*********************************
         #TRANSACCION:  'ASIS_PRN_ELI'
         #DESCRIPCION:    Eliminacion de registros
         #AUTOR:        admin.miguel
         #FECHA:        14-12-2020 20:28:34
        ***********************************/

    ELSIF (p_transaccion = 'ASIS_PRN_ELI') THEN

        BEGIN
            --Sentencia de la eliminacion
            DELETE
            FROM asis.tprogramacion
            WHERE id_programacion = v_parametros.id_programacion;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'Programacion eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp, 'id_programacion', v_parametros.id_programacion::varchar);

            --Devuelve la respuesta
            RETURN v_resp;

        END;

    ELSE

        RAISE EXCEPTION 'Transaccion inexistente: %',p_transaccion;

    END IF;

EXCEPTION

    WHEN OTHERS THEN
        v_resp = '';
        v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', SQLERRM);
        v_resp = pxp.f_agrega_clave(v_resp, 'codigo_error', SQLSTATE);
        v_resp = pxp.f_agrega_clave(v_resp, 'procedimientos', v_nombre_funcion);
        raise exception '%',v_resp;

END;
$BODY$
    LANGUAGE 'plpgsql' VOLATILE
                       COST 100;
ALTER FUNCTION "asis"."ft_programacion_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
