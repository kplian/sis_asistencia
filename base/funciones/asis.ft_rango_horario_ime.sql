CREATE OR REPLACE FUNCTION asis.ft_rango_horario_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.ft_rango_horario_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.trango_horario'
 AUTOR: 		 (mgarcia)
 FECHA:	        19-08-2019 15:28:39
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				19-08-2019 15:28:39								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.trango_horario'
 #23			14-08-2020 15:28:39								Refactorizacion rango horadio
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_rango_horario	integer;
    v_resultado			varchar;
    v_consulta			varchar;
    v_update			varchar;
    v_cambiar			varchar;
    v_comi_uno				varchar;
    v_comi_dos				varchar;

BEGIN

    v_nombre_funcion = 'asis.ft_rango_horario_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'ASIS_RHO_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		mgarcia
 	#FECHA:		19-08-2019 15:28:39
	***********************************/

	if(p_transaccion='ASIS_RHO_INS')then

        begin
        	--Sentencia de la insercion
        	insert into asis.trango_horario(
			estado_reg,
			codigo,
			descripcion,
			hora_entrada,
			hora_salida,
			rango_entrada_ini,
			rango_entrada_fin,
			rango_salida_ini,
			rango_salida_fin,
			fecha_desde,
			fecha_hasta,
			tolerancia_retardo,
			jornada_laboral,
			lunes,
			martes,
			miercoles,
			jueves,
			viernes,
			sabado,
            domingo,
			id_usuario_reg,
			fecha_reg,
			id_usuario_ai,
			usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_parametros.codigo,
			v_parametros.descripcion,
			v_parametros.hora_entrada,
			v_parametros.hora_salida,
			v_parametros.rango_entrada_ini,
			v_parametros.rango_entrada_fin,
			v_parametros.rango_salida_ini,
			v_parametros.rango_salida_fin,
            now()::date,--	v_parametros.fecha_desde,
            now()::date,--	v_parametros.fecha_hasta,
            null,
            null,
			v_parametros.lunes,
			v_parametros.martes,
			v_parametros.miercoles,
			v_parametros.jueves,
			v_parametros.viernes,
			v_parametros.sabado,
            v_parametros.domingo,
			p_id_usuario,
			now(),
			v_parametros._id_usuario_ai,
			v_parametros._nombre_usuario_ai,
			null,
			null
			)RETURNING id_rango_horario into v_id_rango_horario;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Rango de Horarios almacenado(a) con exito (id_rango_horario'||v_id_rango_horario||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_rango_horario',v_id_rango_horario::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_RHO_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		mgarcia
 	#FECHA:		19-08-2019 15:28:39
	***********************************/

	elsif(p_transaccion='ASIS_RHO_MOD')then

		begin
			--Sentencia de la modificacion
			update asis.trango_horario set
			codigo = v_parametros.codigo,
			descripcion = v_parametros.descripcion,
			hora_entrada = v_parametros.hora_entrada,
			hora_salida = v_parametros.hora_salida,
			rango_entrada_ini = v_parametros.rango_entrada_ini,
			rango_entrada_fin = v_parametros.rango_entrada_fin,
			rango_salida_ini = v_parametros.rango_salida_ini,
			rango_salida_fin = v_parametros.rango_salida_fin,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_rango_horario=v_parametros.id_rango_horario;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Rango de Horarios modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_rango_horario',v_parametros.id_rango_horario::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_RHO_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		mgarcia
 	#FECHA:		19-08-2019 15:28:39
	***********************************/

	elsif(p_transaccion='ASIS_RHO_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from asis.trango_horario
            where id_rango_horario=v_parametros.id_rango_horario;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Rango de Horarios eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_rango_horario',v_parametros.id_rango_horario::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;
    /*********************************
 	#TRANSACCION:  'ASIS_RCHE_MOD'
 	#DESCRIPCION:	Asignar dia
 	#AUTOR:		MMV
 	#FECHA:		19-08-2019 15:28:39
	***********************************/

	elsif(p_transaccion='ASIS_RCHE_MOD')then

		begin
        	v_consulta = 'select '||v_parametros.field_name||'
                            from asis.trango_horario
                            where id_rango_horario = '||v_parametros.id_rango_horario;
			EXECUTE (v_consulta) into v_resultado;
             if v_resultado = 'si' then
             	 v_cambiar = 'no';
                 v_comi_uno = ''''; v_comi_dos = '''';
             v_update = 'update asis.trango_horario set
                 			'||v_parametros.field_name||' = '||v_comi_uno||v_cambiar ||v_comi_dos||',
                            id_usuario_mod ='|| p_id_usuario||',
                            fecha_mod = now()
                            where id_rango_horario = '||v_parametros.id_rango_horario;
                 EXECUTE (v_update);
             end if;

            if v_resultado = 'no' then
              v_cambiar = 'si';
              v_comi_uno = ''''; v_comi_dos = '''';
              v_update = 'update asis.trango_horario set
                 			'||v_parametros.field_name||' = '||v_comi_uno||v_cambiar||v_comi_dos||',
                            id_usuario_mod ='|| p_id_usuario||',
                            fecha_mod = now()
                            where id_rango_horario = '||v_parametros.id_rango_horario;
                 EXECUTE (v_update);

             end if;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Rango de Horarios modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_rango_horario',v_parametros.id_rango_horario::varchar);

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

ALTER FUNCTION asis.ft_rango_horario_ime (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;