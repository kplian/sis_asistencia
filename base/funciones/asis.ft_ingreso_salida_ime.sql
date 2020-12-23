CREATE OR REPLACE FUNCTION asis.ft_ingreso_salida_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.ft_ingreso_salida_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.tingreso_salida'
 AUTOR: 		 (jjimenez)
 FECHA:	        14-08-2019 12:53:11
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				14-08-2019 12:53:11							Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.tingreso_salida'
 #1			23-08-2019 12:53:11		Juan 				    Archivo Nuevo Control diario de ingreso salida a la empresa Ende Transmision S.A.'
 #
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_ingreso_salida	integer;

BEGIN

    v_nombre_funcion = 'asis.ft_ingreso_salida_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'ASIS_CONDIA_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		jjimenez
 	#FECHA:		14-08-2019 12:53:11
	***********************************/

	if(p_transaccion='ASIS_CONDIA_INS')then
		--raise EXCEPTION 'error %', 	v_parametros.tipo;
        begin
        	--Sentencia de la insercion
        	insert into asis.tingreso_salida(
			id_funcionario,
			hora,
			fecha,
			tipo,
			estado_reg,
			id_usuario_ai,
			id_usuario_reg,
			fecha_reg,
			usuario_ai,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.id_funcionario,
            CURRENT_TIME,
            now(),
			v_parametros.tipo,
			'activo',
			v_parametros._id_usuario_ai,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			null,
			null



			)RETURNING id_ingreso_salida into v_id_ingreso_salida;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Control diario almacenado(a) con exito (id_ingreso_salida'||v_id_ingreso_salida||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_ingreso_salida',v_id_ingreso_salida::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_CONDIA_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		jjimenez
 	#FECHA:		14-08-2019 12:53:11
	***********************************/

	elsif(p_transaccion='ASIS_CONDIA_MOD')then

		begin
			--Sentencia de la modificacion
			update asis.tingreso_salida set
			id_funcionario = v_parametros.id_funcionario,
			hora = v_parametros.hora,
			fecha = v_parametros.fecha,
			tipo = v_parametros.tipo,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_ingreso_salida=v_parametros.id_ingreso_salida;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Control diario modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_ingreso_salida',v_parametros.id_ingreso_salida::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_CONDIA_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		jjimenez
 	#FECHA:		14-08-2019 12:53:11
	***********************************/

	elsif(p_transaccion='ASIS_CONDIA_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from asis.tingreso_salida
            where id_ingreso_salida=v_parametros.id_ingreso_salida;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Control diario eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_ingreso_salida',v_parametros.id_ingreso_salida::varchar);

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

ALTER FUNCTION asis.ft_ingreso_salida_ime (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;