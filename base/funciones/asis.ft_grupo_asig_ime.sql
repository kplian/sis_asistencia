CREATE OR REPLACE FUNCTION asis.ft_grupo_asig_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.ft_grupo_asig_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.tgrupo_asig'
 AUTOR: 		 (miguel.mamani)
 FECHA:	        20-11-2019 20:00:15
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				20-11-2019 20:00:15								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.tgrupo_asig'
 #23			14-08-2020 15:28:39								Refactorizacion rango horadio
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_grupo_asig	integer;

BEGIN

    v_nombre_funcion = 'asis.ft_grupo_asig_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'ASIS_GRU_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		20-11-2019 20:00:15
	***********************************/

	if(p_transaccion='ASIS_GRU_INS')then

        begin
        	--Sentencia de la insercion
        	insert into asis.tgrupo_asig(
			codigo,
			estado_reg,
			descripcion,
			usuario_ai,
			fecha_reg,
			id_usuario_reg,
			id_usuario_ai,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.codigo,
			'activo',
			v_parametros.descripcion,
			v_parametros._nombre_usuario_ai,
			now(),
			p_id_usuario,
			v_parametros._id_usuario_ai,
			null,
			null



			)RETURNING id_grupo_asig into v_id_grupo_asig;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Grupo almacenado(a) con exito (id_grupo_asig'||v_id_grupo_asig||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_grupo_asig',v_id_grupo_asig::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_GRU_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		20-11-2019 20:00:15
	***********************************/

	elsif(p_transaccion='ASIS_GRU_MOD')then

		begin
			--Sentencia de la modificacion
			update asis.tgrupo_asig set
			codigo = v_parametros.codigo,
			descripcion = v_parametros.descripcion,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_grupo_asig=v_parametros.id_grupo_asig;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Grupo modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_grupo_asig',v_parametros.id_grupo_asig::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_GRU_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		20-11-2019 20:00:15
	***********************************/

	elsif(p_transaccion='ASIS_GRU_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from asis.tgrupo_asig
            where id_grupo_asig=v_parametros.id_grupo_asig;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Grupo eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_grupo_asig',v_parametros.id_grupo_asig::varchar);

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

ALTER FUNCTION asis.ft_grupo_asig_ime (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;