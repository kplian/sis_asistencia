CREATE OR REPLACE FUNCTION asis.ft_compensacion_det_com_ime (
    p_administrador integer,
    p_id_usuario integer,
    p_tabla varchar,
    p_transaccion varchar
)
    RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:        Sistema de Asistencia
 FUNCION:         asis.ft_compensacion_det_com_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.tcompensacion_det_com'
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

    v_nro_requerimiento        INTEGER;
    v_parametros               RECORD;
    v_id_requerimiento         INTEGER;
    v_resp                     VARCHAR;
    v_nombre_funcion           TEXT;
    v_mensaje_error            TEXT;
    v_id_compensacion_det_com    INTEGER;
    v_record					 RECORD;

BEGIN

    v_nombre_funcion = 'asis.ft_compensacion_det_com_ime';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
     #TRANSACCION:  'ASIS_FCN_INS'
     #DESCRIPCION:    Insercion de registros
     #AUTOR:        amamani
     #FECHA:        21-05-2021 17:01:17
    ***********************************/

    IF (p_transaccion='ASIS_FCN_INS') THEN

        BEGIN

            select d.tiempo, d.obs_dba into v_record
            from asis.tcompensacion_det d
            where d.id_compensacion_det = v_parametros.id_compensacion_det;

            --Sentencia de la insercion
            INSERT INTO asis.tcompensacion_det_com(
                estado_reg,
                fecha_comp,
                tiempo_comp,
                id_compensacion_det,
                id_usuario_reg,
                fecha_reg,
                id_usuario_ai,
                usuario_ai,
                id_usuario_mod,
                fecha_mod
            ) VALUES (
                         'activo',
                         v_parametros.fecha_comp,
                         (case
                              when v_record.obs_dba = '6'then
                                  v_record.tiempo
                              else
                                  v_parametros.tiempo_comp
                             end ),
                         v_parametros.id_compensacion_det,
                         p_id_usuario,
                         now(),
                         v_parametros._id_usuario_ai,
                         v_parametros._nombre_usuario_ai,
                         null,
                         null
                     ) RETURNING id_compensacion_det_com into v_id_compensacion_det_com;

            ---raise exception '%', v_parametros.id_compensacion_det;

            update asis.tcompensacion_det set
                                              fecha = v_parametros.fecha_comp,
                                              tiempo =  (case
                                                             when v_record.obs_dba = '6'then
                                                                 v_record.tiempo
                                                             else
                                                                 v_parametros.tiempo_comp
                                                  end )
            where id_compensacion_det = v_parametros.id_compensacion_det;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Fecha Compensación almacenado(a) con exito (id_compensacion_det_com'||v_id_compensacion_det_com||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_compensacion_det_com',v_id_compensacion_det_com::varchar);

            --Devuelve la respuesta
            RETURN v_resp;

        END;

        /*********************************
         #TRANSACCION:  'ASIS_FCN_MOD'
         #DESCRIPCION:    Modificacion de registros
         #AUTOR:        amamani
         #FECHA:        21-05-2021 17:01:17
        ***********************************/

    ELSIF (p_transaccion='ASIS_FCN_MOD') THEN

        BEGIN

            select d.tiempo, d.obs_dba into v_record
            from asis.tcompensacion_det d
            where d.id_compensacion_det = v_parametros.id_compensacion_det;

            --Sentencia de la modificacion
            UPDATE asis.tcompensacion_det_com SET
                                                  fecha_comp = v_parametros.fecha_comp,
                                                  tiempo_comp = v_record.tiempo,
                                                  id_compensacion_det = v_parametros.id_compensacion_det,
                                                  id_usuario_mod = p_id_usuario,
                                                  fecha_mod = now(),
                                                  id_usuario_ai = v_parametros._id_usuario_ai,
                                                  usuario_ai = v_parametros._nombre_usuario_ai
            WHERE id_compensacion_det_com=v_parametros.id_compensacion_det_com;


            update asis.tcompensacion_det set
                                              fecha = v_parametros.fecha_comp,
                                              tiempo =  (case
                                                             when v_record.obs_dba = '6'then
                                                                 v_record.tiempo
                                                             else
                                                                 v_parametros.tiempo_comp
                                                  end )
            where id_compensacion_det = v_parametros.id_compensacion_det;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Fecha Compensación modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_compensacion_det_com',v_parametros.id_compensacion_det_com::varchar);

            --Devuelve la respuesta
            RETURN v_resp;

        END;

        /*********************************
         #TRANSACCION:  'ASIS_FCN_ELI'
         #DESCRIPCION:    Eliminacion de registros
         #AUTOR:        amamani
         #FECHA:        21-05-2021 17:01:17
        ***********************************/

    ELSIF (p_transaccion='ASIS_FCN_ELI') THEN

        BEGIN
            --Sentencia de la eliminacion
            DELETE FROM asis.tcompensacion_det_com
            WHERE id_compensacion_det_com=v_parametros.id_compensacion_det_com;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Fecha Compensación eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_compensacion_det_com',v_parametros.id_compensacion_det_com::varchar);

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
$body$
    LANGUAGE 'plpgsql'
    VOLATILE
    CALLED ON NULL INPUT
    SECURITY INVOKER
    PARALLEL UNSAFE
    COST 100;

ALTER FUNCTION asis.ft_compensacion_det_com_ime (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
    OWNER TO postgres;