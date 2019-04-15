CREATE OR REPLACE FUNCTION asis.ft_tipo_aplicacion_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.ft_tipo_aplicacion_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.ttipo_aplicacion'
 AUTOR: 		 (miguel.mamani)
 FECHA:	        21-02-2019 13:27:56
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				21-02-2019 13:27:56								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.ttipo_aplicacion'
 #
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_tipo_aplicacion	integer;

BEGIN

    v_nombre_funcion = 'asis.ft_tipo_aplicacion_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'ASIS_TAS_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		21-02-2019 13:27:56
	***********************************/

	if(p_transaccion='ASIS_TAS_INS')then

        begin
        	--Sentencia de la insercion
        	insert into asis.ttipo_aplicacion(
			id_tipo_columna,
			nombre,
			descripcion,
			codigo_aplicacion,
			estado_reg,
			consolidable,
			id_usuario_ai,
			fecha_reg,
			usuario_ai,
			id_usuario_reg,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.id_tipo_columna,
			v_parametros.nombre,
			v_parametros.descripcion,
			v_parametros.codigo_aplicacion,
			'activo',
			v_parametros.consolidable,
			v_parametros._id_usuario_ai,
			now(),
			v_parametros._nombre_usuario_ai,
			p_id_usuario,
			null,
			null



			)RETURNING id_tipo_aplicacion into v_id_tipo_aplicacion;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo Aplicación almacenado(a) con exito (id_tipo_aplicacion'||v_id_tipo_aplicacion||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_aplicacion',v_id_tipo_aplicacion::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_TAS_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		21-02-2019 13:27:56
	***********************************/

	elsif(p_transaccion='ASIS_TAS_MOD')then

		begin
			--Sentencia de la modificacion
			update asis.ttipo_aplicacion set
			id_tipo_columna = v_parametros.id_tipo_columna,
			nombre = v_parametros.nombre,
			descripcion = v_parametros.descripcion,
			codigo_aplicacion = v_parametros.codigo_aplicacion,
			consolidable = v_parametros.consolidable,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_tipo_aplicacion=v_parametros.id_tipo_aplicacion;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo Aplicación modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_aplicacion',v_parametros.id_tipo_aplicacion::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_TAS_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		21-02-2019 13:27:56
	***********************************/

	elsif(p_transaccion='ASIS_TAS_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from asis.ttipo_aplicacion
            where id_tipo_aplicacion=v_parametros.id_tipo_aplicacion;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tipo Aplicación eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_tipo_aplicacion',v_parametros.id_tipo_aplicacion::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	else

    	raise exception 'Transaccion inexistente: %',p_transaccion;

	end if;

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
COST 100;