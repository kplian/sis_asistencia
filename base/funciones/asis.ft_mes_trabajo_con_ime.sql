CREATE OR REPLACE FUNCTION asis.ft_mes_trabajo_con_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.ft_mes_trabajo_con_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.tmes_trabajo_con'
 AUTOR: 		 (miguel.mamani)
 FECHA:	        13-03-2019 13:52:11
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				13-03-2019 13:52:11								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.tmes_trabajo_con'
 #
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_mes_trabajo_con	integer;

BEGIN

    v_nombre_funcion = 'asis.ft_mes_trabajo_con_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'ASIS_MTF_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		13-03-2019 13:52:11
	***********************************/

	if(p_transaccion='ASIS_MTF_INS')then

        begin
        	--Sentencia de la insercion
        	insert into asis.tmes_trabajo_con(
			id_tipo_aplicacion,
			total_horas,
			id_centro_costo,
			calculado_resta,
			estado_reg,
			factor,
			id_mes_trabajo,
			id_usuario_ai,
			id_usuario_reg,
			fecha_reg,
			usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			v_parametros.id_tipo_aplicacion,
			v_parametros.total_horas,
			v_parametros.id_centro_costo,
			v_parametros.calculado_resta,
			'activo',
			v_parametros.factor,
			v_parametros.id_mes_trabajo,
			v_parametros._id_usuario_ai,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			null,
			null



			)RETURNING id_mes_trabajo_con into v_id_mes_trabajo_con;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Mes Trabajo Factor almacenado(a) con exito (id_mes_trabajo_con'||v_id_mes_trabajo_con||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_mes_trabajo_con',v_id_mes_trabajo_con::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_MTF_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		13-03-2019 13:52:11
	***********************************/

	elsif(p_transaccion='ASIS_MTF_MOD')then

		begin
			--Sentencia de la modificacion
			update asis.tmes_trabajo_con set
			id_tipo_aplicacion = v_parametros.id_tipo_aplicacion,
			total_horas = v_parametros.total_horas,
			id_centro_costo = v_parametros.id_centro_costo,
			calculado_resta = v_parametros.calculado_resta,
			factor = v_parametros.factor,
			id_mes_trabajo = v_parametros.id_mes_trabajo,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_mes_trabajo_con=v_parametros.id_mes_trabajo_con;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Mes Trabajo Factor modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_mes_trabajo_con',v_parametros.id_mes_trabajo_con::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_MTF_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		13-03-2019 13:52:11
	***********************************/

	elsif(p_transaccion='ASIS_MTF_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from asis.tmes_trabajo_con
            where id_mes_trabajo_con=v_parametros.id_mes_trabajo_con;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Mes Trabajo Factor eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_mes_trabajo_con',v_parametros.id_mes_trabajo_con::varchar);

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