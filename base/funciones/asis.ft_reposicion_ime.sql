CREATE OR REPLACE FUNCTION "asis"."ft_reposicion_ime" (	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$

/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.ft_reposicion_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.treposicion'
 AUTOR: 		 (admin.miguel)
 FECHA:	        15-10-2020 18:57:40
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				15-10-2020 18:57:40								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.treposicion'	
 #
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_reposicion	integer;
			    
BEGIN

    v_nombre_funcion = 'asis.ft_reposicion_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'ASIS_RPC_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		admin.miguel	
 	#FECHA:		15-10-2020 18:57:40
	***********************************/

	if(p_transaccion='ASIS_RPC_INS')then
					
        begin
        	--Sentencia de la insercion
        	insert into asis.treposicion(
			estado_reg,
			obs_dba,
			id_permiso,
			fecha_reposicion,
			id_funcionario,
			evento,
			tiempo,
			id_transacion_zkb,
			id_usuario_reg,
			fecha_reg,
			id_usuario_ai,
			usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_parametros.obs_dba,
			v_parametros.id_permiso,
			v_parametros.fecha_reposicion,
			v_parametros.id_funcionario,
			v_parametros.evento,
			v_parametros.tiempo,
			v_parametros.id_transacion_zkb,
			p_id_usuario,
			now(),
			v_parametros._id_usuario_ai,
			v_parametros._nombre_usuario_ai,
			null,
			null
							
			
			
			)RETURNING id_reposicion into v_id_reposicion;
			
			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Reposicion almacenado(a) con exito (id_reposicion'||v_id_reposicion||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_reposicion',v_id_reposicion::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************    
 	#TRANSACCION:  'ASIS_RPC_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		admin.miguel	
 	#FECHA:		15-10-2020 18:57:40
	***********************************/

	elsif(p_transaccion='ASIS_RPC_MOD')then

		begin
			--Sentencia de la modificacion
			update asis.treposicion set
			obs_dba = v_parametros.obs_dba,
			id_permiso = v_parametros.id_permiso,
			fecha_reposicion = v_parametros.fecha_reposicion,
			id_funcionario = v_parametros.id_funcionario,
			evento = v_parametros.evento,
			tiempo = v_parametros.tiempo,
			id_transacion_zkb = v_parametros.id_transacion_zkb,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_reposicion=v_parametros.id_reposicion;
               
			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Reposicion modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_reposicion',v_parametros.id_reposicion::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
		end;

	/*********************************    
 	#TRANSACCION:  'ASIS_RPC_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		admin.miguel	
 	#FECHA:		15-10-2020 18:57:40
	***********************************/

	elsif(p_transaccion='ASIS_RPC_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from asis.treposicion
            where id_reposicion=v_parametros.id_reposicion;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Reposicion eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_reposicion',v_parametros.id_reposicion::varchar);
              
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
$BODY$
LANGUAGE 'plpgsql' VOLATILE
COST 100;
ALTER FUNCTION "asis"."ft_reposicion_ime"(integer, integer, character varying, character varying) OWNER TO postgres;
