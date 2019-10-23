CREATE OR REPLACE FUNCTION asis.ft_movimiento_vacacion_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.ft_movimiento_vacacion_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.tmovimiento_vacacion'
 AUTOR: 		 (miguel.mamani)
 FECHA:	        08-10-2019 10:39:21
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				08-10-2019 10:39:21								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.tmovimiento_vacacion'
 #
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_movimiento_vacacion	integer;

BEGIN

    v_nombre_funcion = 'asis.ft_movimiento_vacacion_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'ASIS_MVS_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		08-10-2019 10:39:21
	***********************************/

	if(p_transaccion='ASIS_MVS_INS')then

        begin
        	--Sentencia de la insercion
        	insert into asis.tmovimiento_vacacion(
			estado_reg,
			id_funcionario,
			desde,
			hasta,
			dias_asignado,
			dias_acumulado,
			dias_tomado,
			dias_actual,
			id_usuario_reg,
			fecha_reg,
			id_usuario_ai,
			usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_parametros.id_funcionario,
			v_parametros.desde,
			v_parametros.hasta,
			v_parametros.dias_asignado,
			v_parametros.dias_acumulado,
			v_parametros.dias_tomado,
			v_parametros.dias_actual,
			p_id_usuario,
			now(),
			v_parametros._id_usuario_ai,
			v_parametros._nombre_usuario_ai,
			null,
			null



			)RETURNING id_movimiento_vacacion into v_id_movimiento_vacacion;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Movimiento Vacaciones almacenado(a) con exito (id_movimiento_vacacion'||v_id_movimiento_vacacion||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_movimiento_vacacion',v_id_movimiento_vacacion::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_MVS_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		08-10-2019 10:39:21
	***********************************/

	elsif(p_transaccion='ASIS_MVS_MOD')then

		begin
			--Sentencia de la modificacion
			update asis.tmovimiento_vacacion set
			id_funcionario = v_parametros.id_funcionario,
			desde = v_parametros.desde,
			hasta = v_parametros.hasta,
			dias_asignado = v_parametros.dias_asignado,
			dias_acumulado = v_parametros.dias_acumulado,
			dias_tomado = v_parametros.dias_tomado,
			dias_actual = v_parametros.dias_actual,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_movimiento_vacacion=v_parametros.id_movimiento_vacacion;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Movimiento Vacaciones modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_movimiento_vacacion',v_parametros.id_movimiento_vacacion::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_MVS_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		08-10-2019 10:39:21
	***********************************/

	elsif(p_transaccion='ASIS_MVS_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from asis.tmovimiento_vacacion
            where id_movimiento_vacacion=v_parametros.id_movimiento_vacacion;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Movimiento Vacaciones eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_movimiento_vacacion',v_parametros.id_movimiento_vacacion::varchar);

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

ALTER FUNCTION asis.ft_movimiento_vacacion_ime (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;