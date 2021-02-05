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
    v_valor             numeric;
    v_crear             boolean;
    v_tiempo            varchar;
    v_id_funcionario    integer;
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
            if (v_parametros.tiempo = 'C') then
                v_valor = 8;
            else
                v_valor = 4;
            end if;

            for v_date in (SELECT d.date
                           FROM GENERATE_SERIES(v_parametros.fecha_programada, v_parametros.fecha_fin,
                                                '1 day'::INTERVAL) d)
                loop
                    v_crear = true;
                    if (v_parametros.tiempo = 'C') then

                        if ((select count(pro.id_programacion)
                             from asis.tprogramacion pro
                             where pro.estado = 'pendiente'
                               AND (pro.tiempo = 'T' OR pro.tiempo = 'M')
                               and pro.fecha_programada = v_date
                               AND pro.id_funcionario = v_parametros.id_funcionario) > 0) then
                            v_crear = false;

                        end if;
                    elseif (v_parametros.tiempo = 'T' OR v_parametros.tiempo = 'M') then
                        if ((select count(pro.id_programacion)
                             from asis.tprogramacion pro
                             where pro.estado = 'pendiente'
                               AND (pro.tiempo = 'C' OR pro.tiempo = v_parametros.tiempo)
                               and pro.fecha_programada = v_date
                               AND pro.id_funcionario = v_parametros.id_funcionario) > 0) then
                            v_crear = false;
                        end if;
                    end if;

                    if not asis.f_valida_fecha(v_parametros.id_funcionario, v_date) then
                        v_crear = false;
                    end if;

                    if (v_crear) then
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
                                v_valor,
                                null,
                                p_id_usuario,
                                now(),
                                v_parametros._id_usuario_ai,
                                v_parametros._nombre_usuario_ai,
                                null,
                                null)
                        RETURNING id_programacion into v_id_programacion;
                    end if;

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

            if (not asis.f_valida_fecha(v_parametros.id_funcionario, v_parametros.fecha_programada::date)) then
                raise exception 'No es posible programar vacaciones en dias no hábiles y dias feriados';
            end if;

            if (not exists(select 1
                           from asis.tprogramacion pro
                           where pro.id_programacion = v_parametros.id_programacion
                             and pro.estado = 'pendiente')) then
                raise exception 'No es posible modificar una programación en estado programado';
            end if;

            if (v_parametros.tiempo = 'C') then

                if ((select count(pro.id_programacion)
                     from asis.tprogramacion pro
                     where pro.estado = 'pendiente'
                       AND (pro.tiempo = 'T' OR pro.tiempo = 'M')
                       and pro.fecha_programada = v_parametros.fecha_programada
                       AND pro.id_funcionario = v_parametros.id_funcionario) > 0) then
                    raise exception 'Ya existe una vacacion programada para la fecha %',v_parametros.fecha_programada;

                end if;
            elseif (v_parametros.tiempo = 'T' OR v_parametros.tiempo = 'M') then
                if ((select count(pro.id_programacion)
                     from asis.tprogramacion pro
                     where pro.estado = 'pendiente'
                       AND (pro.tiempo = 'C' OR pro.tiempo = v_parametros.tiempo)
                       and pro.fecha_programada = v_parametros.fecha_programada
                       AND pro.id_funcionario = v_parametros.id_funcionario) > 0) then
                    raise exception 'Ya existe una vacacion programada para la fecha %',v_parametros.fecha_programada;
                end if;
            end if;

            if (v_parametros.tiempo = 'C') then
                v_valor = 8;
            else
                v_valor = 4;
            end if;
            UPDATE asis.tprogramacion
            SET fecha_programada = v_parametros.fecha_programada,
                id_funcionario   = v_parametros.id_funcionario,
                tiempo           = v_parametros.tiempo,
                valor            = v_valor,
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
            select tiempo, id_funcionario
            into v_tiempo, v_id_funcionario
            from asis.tprogramacion pro
            where pro.id_programacion = v_parametros.id_programacion;

            if (not asis.f_valida_fecha(v_id_funcionario, v_parametros.fecha_programada::date)) then
                raise exception 'No es posible programar vacaciones en dias no hábiles y dias feriados';
            end if;

            if (not exists(select 1
                           from asis.tprogramacion pro
                           where pro.id_programacion = v_parametros.id_programacion
                             and pro.estado = 'pendiente')) then
                raise exception 'No es posible modificar una programación en estado programado';
            end if;
            if (v_tiempo = 'C') then

                if ((select count(pro.id_programacion)
                     from asis.tprogramacion pro
                     where pro.estado = 'pendiente'
                       AND (pro.tiempo = 'T' OR pro.tiempo = 'M')
                       and pro.fecha_programada = v_parametros.fecha_programada
                       AND pro.id_funcionario = v_id_funcionario) > 0) then
                    raise exception 'Ya existe una vacacion programada para la fecha %',v_parametros.fecha_programada;

                end if;
            elseif (v_tiempo = 'T' OR v_tiempo = 'M') then
                if ((select count(pro.id_programacion)
                     from asis.tprogramacion pro
                     where pro.estado = 'pendiente'
                       AND (pro.tiempo = 'C' OR pro.tiempo = v_tiempo)
                       and pro.fecha_programada = v_parametros.fecha_programada
                       AND pro.id_funcionario = v_id_funcionario) > 0) then
                    raise exception 'Ya existe una vacacion programada para la fecha %',v_parametros.fecha_programada;
                end if;
            end if;

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

            if (exists(select 1
                       from asis.tprogramacion pro
                       where pro.id_programacion = v_parametros.id_programacion
                         and pro.estado = 'programado')) then
                raise exception 'No es posible eliminar una programación en estado programado';
            end if;

            DELETE
            FROM asis.tprogramacion
            WHERE id_programacion = v_parametros.id_programacion;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'Programacion eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp, 'id_programacion', v_parametros.id_programacion::varchar);

            --Devuelve la respuesta
            RETURN v_resp;

        END;
        /*********************************
     #TRANSACCION:  'ASIS_GEN_SOL'
     #DESCRIPCION:    Generacion de Solicitudes de Vacacion
     #AUTOR:        vincen.alvarado
     #FECHA:        26-01-2021 14:21:00
    ***********************************/

    ELSIF (p_transaccion = 'ASIS_GEN_SOL') THEN

        BEGIN
            --Sentencia de la eliminacion
            execute asis.f_generara_solicitud_vacacion(p_id_usuario, v_parametros.fecha_inicio, v_parametros.fecha_fin);
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'Programacion eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp, 'id_programacion', 0::varchar);

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
$BODY$ LANGUAGE 'plpgsql' VOLATILE
                          COST 100;
ALTER FUNCTION "asis"."ft_programacion_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
