CREATE OR REPLACE FUNCTION asis.ft_transaccion_bio_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.ft_transaccion_bio_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.ttransaccion_bio'
 AUTOR: 		 (miguel.mamani)
 FECHA:	        06-09-2019 13:08:03
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				06-09-2019 13:08:03								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.ttransaccion_bio'
 #
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_transaccion_bio	integer;
    v_record				record;
    v_codigo				varchar;
    v_fecha_ini				date;
    v_fecha_fin				date;
    v_texto					varchar;
    v_rango					varchar[];
    v_id_funcionario		integer;


BEGIN

    v_nombre_funcion = 'asis.ft_transaccion_bio_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'ASIS_BIO_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		06-09-2019 13:08:03
	***********************************/

	if(p_transaccion='ASIS_BIO_INS')then

        begin
        	--Sentencia de la insercion
        	insert into asis.ttransaccion_bio(obs,
                                              estado_reg,
                                              evento,
                                              id_periodo,
                                              hora,
                                              id_funcionario,
                                              area,
                                              tipo_verificacion,
                                              fecha_marcado,
                                              id_rango_horario,
                                              id_usuario_reg,
                                              usuario_ai,
                                              fecha_reg,
                                              id_usuario_ai,
                                              id_usuario_mod,
                                              fecha_mod
                                              ) values(
                                              v_parametros.obs,
                                              'activo',
                                              v_parametros.evento,
                                              v_parametros.id_periodo,
                                              v_parametros.hora,
                                              v_parametros.id_funcionario,
                                              v_parametros.area,
                                              v_parametros.tipo_verificacion,
                                              v_parametros.fecha_marcado,
                                              v_parametros.id_rango_horario,
                                              p_id_usuario,
                                              v_parametros._nombre_usuario_ai,
                                              now(),
                                              v_parametros._id_usuario_ai,
                                              null,
                                              null)RETURNING id_transaccion_bio into v_id_transaccion_bio;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Transaccion Bio almacenado(a) con exito (id_transaccion_bio'||v_id_transaccion_bio||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_transaccion_bio',v_id_transaccion_bio::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_BIO_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		06-09-2019 13:08:03
	***********************************/

	elsif(p_transaccion='ASIS_BIO_MOD')then

		begin
			--Sentencia de la modificacion
			update asis.ttransaccion_bio set
			obs = v_parametros.obs,
			evento = v_parametros.evento,
			id_periodo = v_parametros.id_periodo,
			hora = v_parametros.hora,
			id_funcionario = v_parametros.id_funcionario,
			area = v_parametros.area,
			tipo_verificacion = v_parametros.tipo_verificacion,
			fecha_marcado = v_parametros.fecha_marcado,
			id_rango_horario = v_parametros.id_rango_horario,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_transaccion_bio=v_parametros.id_transaccion_bio;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Transaccion Bio modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_transaccion_bio',v_parametros.id_transaccion_bio::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_BIO_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		06-09-2019 13:08:03
	***********************************/

	elsif(p_transaccion='ASIS_BIO_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from asis.ttransaccion_bio
            where id_transaccion_bio=v_parametros.id_transaccion_bio;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Transaccion Bio eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_transaccion_bio',v_parametros.id_transaccion_bio::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;
    /*********************************
 	#TRANSACCION:  'ASIS_BIO_TRA'
 	#DESCRIPCION:	Agrupar pares de marcado
 	#AUTOR:		miguel.mamani
 	#FECHA:		06-09-2019 13:08:03
	***********************************/
      elsif(p_transaccion='ASIS_BIO_TRA')then

        begin

        ---Obtener el id funcionario
        if v_parametros.id_funcionario is null then
        	raise exception 'Usted no esta registrado como funcionario';
        end if;

        ---Obtener el fechas de periodo
        select pe.fecha_ini, pe.fecha_fin
        into v_fecha_ini,v_fecha_fin
        from param.tperiodo pe
        where pe.id_periodo = v_parametros.id_periodo;

        --validar que funcionario este vigente

        if not exists ( select 1
                        from asis.ttransacc_zkb_etl tr
                        where tr.event_time::date BETWEEN v_fecha_ini and v_fecha_fin
                        and tr.id_funcionario = v_parametros.id_funcionario)then
        		raise exception 'No hay registro id:(%) en biometrico ',v_parametros.id_funcionario;
        end if;

        v_id_funcionario = v_parametros.id_funcionario;

        ---Recoremos la table de etl
        for v_record in ( select   tr.pin,
                                   tr.event_time,
                                   to_char(tr.event_time, 'HH24:MI')::time as hora,
                                   to_char(tr.event_time, 'DD'::text) as dia,
                                   tr.reader_name,
                                   tr.event_no,
                                   tr.event_name,
                                   tr.verify_mode_no,
                                   tr.verify_mode_name,
                                   tr.area_name
                                from asis.ttransacc_zkb_etl tr
                                where tr.event_time::date BETWEEN v_fecha_ini and v_fecha_fin
                                and tr.id_funcionario = v_id_funcionario
                               -- and to_char(tr.event_time, 'DD'::text)::integer = 8
                                order by event_time, hora)loop
		if not exists (select 1
                        from asis.ttransaccion_bio bio
                        where bio.id_funcionario = v_id_funcionario
                        and bio.id_periodo = v_parametros.id_periodo
                        and bio.hora = v_record.hora
                        and to_char(fecha_marcado, 'DD')::integer = v_record.dia::integer)then

        	v_rango = asis.f_obtener_rango( v_id_funcionario,
            								v_record.event_time,
            								v_record.hora::time,
                                            v_record.reader_name);

            insert into asis.ttransaccion_bio(	obs,
                                                estado_reg,
                                                evento,
                                                id_periodo,
                                                hora,
                                                id_funcionario,
                                                area,
                                                tipo_verificacion,
                                                fecha_marcado,
                                                id_rango_horario,
                                                id_usuario_reg,
                                                usuario_ai,
                                                fecha_reg,
                                                id_usuario_ai,
                                                id_usuario_mod,
                                                fecha_mod,
                                                acceso,
                                                event_time
                                                ) values(
                                                v_rango[2]::varchar,
                                                'activo',
                                                v_rango[3]::varchar,
                                                v_parametros.id_periodo,
                                                v_record.hora::time,
                                                v_id_funcionario,
                                                v_record.area_name,
                                                v_record.event_name,
                                                v_record.event_time::date,
                                                v_rango[1]::integer,
                                                p_id_usuario,
                                                v_parametros._nombre_usuario_ai,
                                                now(),
                                                v_parametros._id_usuario_ai,
                                                null,
                                                null,
                                                v_record.verify_mode_name,
                                                v_record.event_time);
         end if;
        end loop;



            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Transaccion Bio eliminado(a)');
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

ALTER FUNCTION asis.ft_transaccion_bio_ime (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;