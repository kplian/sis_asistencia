CREATE OR REPLACE FUNCTION asis.ft_asignar_rango_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.ft_asignar_rango_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.tasignar_rango'
 AUTOR: 		 (miguel.mamani)
 FECHA:	        05-09-2019 21:07:38
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				05-09-2019 21:07:38								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.tasignar_rango'
  #23			14-08-2020 15:28:39								Refactorizacion rango horadio

 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_asignar_rango	integer;

BEGIN

    v_nombre_funcion = 'asis.ft_asignar_rango_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'ASIS_ARO_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		05-09-2019 21:07:38
	***********************************/

	if(p_transaccion='ASIS_ARO_INS')then

        begin
        	--Sentencia de la insercion


        	if exists ( select 1
                        from asis.tasignar_rango ss
                        where ss.id_rango_horario = v_parametros.id_rango_horario
                        and (ss.id_uo = v_parametros.id_uo or ss.id_funcionario = v_parametros.id_funcionario)
                        and ss.hasta is null) then

            	raise exception 'Ya esta registado';

        	end if;

        	insert into asis.tasignar_rango(
			id_rango_horario,
			estado_reg,
			hasta,
			id_uo,
			id_funcionario,
			desde,
			id_usuario_reg,
			fecha_reg,
			usuario_ai,
			id_usuario_ai,
			fecha_mod,
			id_usuario_mod,
            id_grupo_asig
          	) values(
			v_parametros.id_rango_horario,
			'activo',
			v_parametros.hasta,
			v_parametros.id_uo,
			v_parametros.id_funcionario,
			v_parametros.desde,
			p_id_usuario,
			now(),
			v_parametros._nombre_usuario_ai,
			v_parametros._id_usuario_ai,
			null,
			null,
            v_parametros.id_grupo_asig
            )RETURNING asignar_rango into v_asignar_rango;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Asignar Rango almacenado(a) con exito (asignar_rango'||v_asignar_rango||')');
            v_resp = pxp.f_agrega_clave(v_resp,'asignar_rango',v_asignar_rango::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_ARO_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		05-09-2019 21:07:38
	***********************************/

	elsif(p_transaccion='ASIS_ARO_MOD')then

		begin
			--Sentencia de la modificacion
			update asis.tasignar_rango set
			id_rango_horario = v_parametros.id_rango_horario,
			hasta = v_parametros.hasta,
			id_uo = v_parametros.id_uo,
			id_funcionario = v_parametros.id_funcionario,
			desde = v_parametros.desde,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai,
            id_grupo_asig = v_parametros.id_grupo_asig
			where asignar_rango=v_parametros.asignar_rango;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Asignar Rango modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'asignar_rango',v_parametros.asignar_rango::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_ARO_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		05-09-2019 21:07:38
	***********************************/

	elsif(p_transaccion='ASIS_ARO_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from asis.tasignar_rango
            where asignar_rango=v_parametros.asignar_rango;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Asignar Rango eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'asignar_rango',v_parametros.asignar_rango::varchar);

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

ALTER FUNCTION asis.ft_asignar_rango_ime (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;