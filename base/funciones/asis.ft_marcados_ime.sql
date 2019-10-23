CREATE OR REPLACE FUNCTION asis.ft_marcados_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.ft_marcados_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.tmarcados'
 AUTOR: 		 (mgarcia)
 FECHA:	        12-07-2019 12:56:19
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				12-07-2019 12:56:19								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.tmarcados'
 #
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_marcado	integer;

BEGIN

    v_nombre_funcion = 'asis.ft_marcados_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'ASIS_MAS_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		mgarcia
 	#FECHA:		12-07-2019 12:56:19
	***********************************/

	if(p_transaccion='ASIS_MAS_INS')then

        begin
        	--Sentencia de la insercion
        	insert into asis.tmarcados(
			estado_reg,
			hora,
			id_biometrico,
			fecha_marcado,
			observacion,
			id_funcionario,
			id_uo,
			id_uo_funcionario,
			id_usuario_reg,
			fecha_reg,
			id_usuario_ai,
			usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_parametros.hora,
			v_parametros.id_biometrico,
			v_parametros.fecha_marcado,
			v_parametros.observacion,
			v_parametros.id_funcionario,
			v_parametros.id_uo,
			v_parametros.id_uo_funcionario,
			p_id_usuario,
			now(),
			v_parametros._id_usuario_ai,
			v_parametros._nombre_usuario_ai,
			null,
			null



			)RETURNING id_marcado into v_id_marcado;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Marcados almacenado(a) con exito (id_marcado'||v_id_marcado||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_marcado',v_id_marcado::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_MAS_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		mgarcia
 	#FECHA:		12-07-2019 12:56:19
	***********************************/

	elsif(p_transaccion='ASIS_MAS_MOD')then

		begin
			--Sentencia de la modificacion
			update asis.tmarcados set
			hora = v_parametros.hora,
			id_biometrico = v_parametros.id_biometrico,
			fecha_marcado = v_parametros.fecha_marcado,
			observacion = v_parametros.observacion,
			id_funcionario = v_parametros.id_funcionario,
			id_uo = v_parametros.id_uo,
			id_uo_funcionario = v_parametros.id_uo_funcionario,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_marcado=v_parametros.id_marcado;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Marcados modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_marcado',v_parametros.id_marcado::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_MAS_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		mgarcia
 	#FECHA:		12-07-2019 12:56:19
	***********************************/

	elsif(p_transaccion='ASIS_MAS_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from asis.tmarcados
            where id_marcado=v_parametros.id_marcado;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Marcados eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_marcado',v_parametros.id_marcado::varchar);

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

ALTER FUNCTION asis.ft_marcados_ime (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;