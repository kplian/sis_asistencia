CREATE OR REPLACE FUNCTION asis.ft_grupo_asig_det_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.ft_grupo_asig_det_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.tgrupo_asig_det'
 AUTOR: 		 (miguel.mamani)
 FECHA:	        20-11-2019 20:55:17
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				20-11-2019 20:55:17								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.tgrupo_asig_det'
  #23			14-08-2020 15:28:39								Refactorizacion rango horadio

 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_id_grupo_asig_det	integer;

BEGIN

    v_nombre_funcion = 'asis.ft_grupo_asig_det_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'ASIS_GRD_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		20-11-2019 20:55:17
	***********************************/

	if(p_transaccion='ASIS_GRD_INS')then

        begin
        	--Sentencia de la insercion

            if exists (select 1
                        from asis.tgrupo_asig_det grd
                        where grd.id_grupo_asig = v_parametros.id_grupo_asig
                        and grd.id_funcionario = v_parametros.id_funcionario)then
            	raise exception 'El funcionario ya fue registrado';
            end if;

        	insert into asis.tgrupo_asig_det(
			estado_reg,
			id_funcionario,
			id_grupo_asig,
			id_usuario_reg,
			usuario_ai,
			fecha_reg,
			id_usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_parametros.id_funcionario,
			v_parametros.id_grupo_asig,
			p_id_usuario,
			v_parametros._nombre_usuario_ai,
			now(),
			v_parametros._id_usuario_ai,
			null,
			null)RETURNING id_id_grupo_asig_det into v_id_id_grupo_asig_det;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','grupo detalle almacenado(a) con exito (id_id_grupo_asig_det'||v_id_id_grupo_asig_det||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_id_grupo_asig_det',v_id_id_grupo_asig_det::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_GRD_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		20-11-2019 20:55:17
	***********************************/

	elsif(p_transaccion='ASIS_GRD_MOD')then

		begin
			--Sentencia de la modificacion
			update asis.tgrupo_asig_det set
			id_funcionario = v_parametros.id_funcionario,
			id_grupo_asig = v_parametros.id_grupo_asig,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_id_grupo_asig_det=v_parametros.id_id_grupo_asig_det;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','grupo detalle modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_id_grupo_asig_det',v_parametros.id_id_grupo_asig_det::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_GRD_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		20-11-2019 20:55:17
	***********************************/

	elsif(p_transaccion='ASIS_GRD_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from asis.tgrupo_asig_det
            where id_id_grupo_asig_det=v_parametros.id_id_grupo_asig_det;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','grupo detalle eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_id_grupo_asig_det',v_parametros.id_id_grupo_asig_det::varchar);

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

ALTER FUNCTION asis.ft_grupo_asig_det_ime (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;