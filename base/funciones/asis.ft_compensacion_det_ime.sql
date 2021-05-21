CREATE OR REPLACE FUNCTION asis.ft_compensacion_det_ime (
    p_administrador integer,
    p_id_usuario integer,
    p_tabla varchar,
    p_transaccion varchar
)
    RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:        Sistema de Asistencia
 FUNCION:         asis.ft_compensacion_det_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.tcompensacion_det'
 AUTOR:          (amamani)
 FECHA:            18-05-2021 14:14:47
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE                FECHA                AUTOR                DESCRIPCION
 #0                18-05-2021 14:14:47    amamani             Creacion
 #
 ***************************************************************************/

DECLARE

    v_parametros          RECORD;
    v_resp                VARCHAR;
    v_nombre_funcion      TEXT;
    v_id_compensacion_det INTEGER;
    v_tiempo              VARCHAR;
    v_id_compensacion        INTEGER;
    v_dias_efectivo       NUMERIC;

BEGIN

    v_nombre_funcion = 'asis.ft_compensacion_det_ime';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
     #TRANSACCION:  'ASIS_CMD_INS'
     #DESCRIPCION:    Insercion de registros
     #AUTOR:        amamani
     #FECHA:        18-05-2021 14:14:47
    ***********************************/

    IF (p_transaccion = 'ASIS_CMD_INS') THEN

        BEGIN


            SELECT c.tiempo, c.id_compensacion
            into v_tiempo,v_id_compensacion
            FROM asis.tcompensacion_det c
            WHERE c.id_compensacion_det = v_parametros.id_compensacion_det;


            if v_tiempo = 'completo' then

                update asis.tcompensacion_det
                set tiempo = 'mañana'
                where id_compensacion_det = v_parametros.id_compensacion_det;

            end if;

            if v_tiempo = 'mañana' then

                update asis.tcompensacion_det
                set tiempo = 'tarde'
                where id_compensacion_det = v_parametros.id_compensacion_det;

            end if;

            if v_tiempo = 'tarde' then
                update asis.tcompensacion_det
                set tiempo = 'completo'
                where id_compensacion_det = v_parametros.id_compensacion_det;

            end if;

            select sum(d.dias_efectico)
            into v_dias_efectivo
            from (
                     select (case
                                 when vd.tiempo = 'completo' then
                                     1
                                 when vd.tiempo = 'mañana' then
                                     0.5
                                 when vd.tiempo = 'tarde' then
                                     0.5
                                 else
                                     0
                         end ::numeric) as dias_efectico

                     from asis.tcompensacion_det vd
                     where vd.id_compensacion = v_id_compensacion) d;

            update asis.tcompensacion
            set dias = v_dias_efectivo,
                dias_comp = v_dias_efectivo
            where id_compensacion = v_id_compensacion;




            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp, 'mensaje',
                                        'Compensacion Detalle almacenado(a) con exito (id_compensacion_det' ||
                                        v_id_compensacion_det || ')');
            v_resp = pxp.f_agrega_clave(v_resp, 'id_compensacion_det', v_id_compensacion_det::varchar);

            --Devuelve la respuesta
            RETURN v_resp;

        END;

        /*********************************
         #TRANSACCION:  'ASIS_CMD_MOD'
         #DESCRIPCION:    Modificacion de registros
         #AUTOR:        amamani
         #FECHA:        18-05-2021 14:14:47
        ***********************************/

    ELSIF (p_transaccion = 'ASIS_CMD_MOD') THEN

        BEGIN
            --Sentencia de la modificacion
            UPDATE asis.tcompensacion_det
            SET fecha           = v_parametros.fecha,
                id_compensacion = v_parametros.id_compensacion,
                tiempo          = v_parametros.tiempo,
                id_usuario_mod  = p_id_usuario,
                fecha_mod       = now(),
                id_usuario_ai   = v_parametros._id_usuario_ai,
                usuario_ai      = v_parametros._nombre_usuario_ai
            WHERE id_compensacion_det = v_parametros.id_compensacion_det;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'Compensacion Detalle modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp, 'id_compensacion_det', v_parametros.id_compensacion_det::varchar);

            --Devuelve la respuesta
            RETURN v_resp;

        END;

        /*********************************
         #TRANSACCION:  'ASIS_CMD_ELI'
         #DESCRIPCION:    Eliminacion de registros
         #AUTOR:        amamani
         #FECHA:        18-05-2021 14:14:47
        ***********************************/

    ELSIF (p_transaccion = 'ASIS_CMD_ELI') THEN

        BEGIN
            --Sentencia de la eliminacion
            DELETE
            FROM asis.tcompensacion_det
            WHERE id_compensacion_det = v_parametros.id_compensacion_det;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'Compensacion Detalle eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp, 'id_compensacion_det', v_parametros.id_compensacion_det::varchar);

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
$body$
    LANGUAGE 'plpgsql'
    VOLATILE
    CALLED ON NULL INPUT
    SECURITY INVOKER
    PARALLEL UNSAFE
    COST 100;

ALTER FUNCTION asis.ft_compensacion_det_ime (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
    OWNER TO postgres;