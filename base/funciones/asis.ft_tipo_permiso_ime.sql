create or replace function asis.ft_tipo_permiso_ime(p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying) returns character varying
    language plpgsql
as
$$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.ft_tipo_permiso_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.ttipo_permiso'
 AUTOR: 		 (miguel.mamani)
 FECHA:	        16-10-2019 13:14:01
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				16-10-2019 13:14:01								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.ttipo_permiso'
 #24			14-08-2020 15:28:39		MMV						Refactorizacion tipo permiso
 ***************************************************************************/

DECLARE

    v_nro_requerimiento integer;
    v_parametros        record;
    v_id_requerimiento  integer;
    v_resp              varchar;
    v_nombre_funcion    text;
    v_mensaje_error     text;
    v_id_tipo_permiso   integer;

BEGIN

    v_nombre_funcion = 'asis.ft_tipo_permiso_ime';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
     #TRANSACCION:  'ASIS_TPO_INS'
     #DESCRIPCION:	Insercion de registros
     #AUTOR:		miguel.mamani
     #FECHA:		16-10-2019 13:14:01
    ***********************************/

    if (p_transaccion = 'ASIS_TPO_INS') then

        begin

            --Sentencia de la insercion
            insert into asis.ttipo_permiso(estado_reg,
                                           codigo,
                                           nombre,
                                           tiempo,
                                           id_usuario_reg,
                                           fecha_reg,
                                           id_usuario_ai,
                                           usuario_ai,
                                           id_usuario_mod,
                                           fecha_mod,
                                           documento,
                                           reposcion,
                                           detalle
                -- rango
            )
            values ('activo',
                    v_parametros.codigo,
                    v_parametros.nombre,
                    v_parametros.tiempo,
                    p_id_usuario,
                    now(),
                    v_parametros._id_usuario_ai,
                    v_parametros._nombre_usuario_ai,
                    null,
                    null,
                    v_parametros.documento,
                    v_parametros.reposcion,
                    v_parametros.detalle
                       --v_parametros.rango
                   )
            RETURNING id_tipo_permiso into v_id_tipo_permiso;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp, 'mensaje',
                                        'Tipo Permiso almacenado(a) con exito (id_tipo_permiso' || v_id_tipo_permiso ||
                                        ')');
            v_resp = pxp.f_agrega_clave(v_resp, 'id_tipo_permiso', v_id_tipo_permiso::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

        /*********************************
         #TRANSACCION:  'ASIS_TPO_MOD'
         #DESCRIPCION:	Modificacion de registros
         #AUTOR:		miguel.mamani
         #FECHA:		16-10-2019 13:14:01
        ***********************************/

    elsif (p_transaccion = 'ASIS_TPO_MOD') then

        begin
            --Sentencia de la modificacion
            update asis.ttipo_permiso
            set codigo         = v_parametros.codigo,
                nombre         = v_parametros.nombre,
                tiempo         = v_parametros.tiempo,
                id_usuario_mod = p_id_usuario,
                fecha_mod      = now(),
                id_usuario_ai  = v_parametros._id_usuario_ai,
                usuario_ai     = v_parametros._nombre_usuario_ai,
                documento      = v_parametros.documento,
                reposcion      = v_parametros.reposcion,
                detalle        = v_parametros.detalle
                --rango = v_parametros.rango
            where id_tipo_permiso = v_parametros.id_tipo_permiso;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'Tipo Permiso modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp, 'id_tipo_permiso', v_parametros.id_tipo_permiso::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

        /*********************************
         #TRANSACCION:  'ASIS_TPO_ELI'
         #DESCRIPCION:	Eliminacion de registros
         #AUTOR:		miguel.mamani
         #FECHA:		16-10-2019 13:14:01
        ***********************************/

    elsif (p_transaccion = 'ASIS_TPO_ELI') then

        begin
            --Sentencia de la eliminacion
            delete
            from asis.ttipo_permiso
            where id_tipo_permiso = v_parametros.id_tipo_permiso;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'Tipo Permiso eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp, 'id_tipo_permiso', v_parametros.id_tipo_permiso::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

    else

        raise exception 'Transaccion inexistente: %',p_transaccion;

    end if;

EXCEPTION

    WHEN OTHERS THEN
        v_resp = '';
        v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', SQLERRM);
        v_resp = pxp.f_agrega_clave(v_resp, 'codigo_error', SQLSTATE);
        v_resp = pxp.f_agrega_clave(v_resp, 'procedimientos', v_nombre_funcion);
        raise exception '%',v_resp;

END;
$$;
