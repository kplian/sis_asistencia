CREATE OR REPLACE FUNCTION asis.ft_pares_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.ft_pares_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.tpares'
 AUTOR: 		 (mgarcia)
 FECHA:	        19-09-2019 16:00:52
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				19-09-2019 16:00:52								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.tpares'
 #
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
    v_registro				record;
    v_rango_horario			varchar[];
    v_id_pares				integer;
    v_record_pares			record;
    v_index					integer;
    v_hora					time;
    v_impar   				integer;
    v_pivot					integer;
    v_record				record;
    v_id_pares_aux			integer;


BEGIN

    v_nombre_funcion = 'asis.ft_pares_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'ASIS_PAR_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		MMV
 	#FECHA:		19-09-2019 16:00:52
	***********************************/

	if(p_transaccion='ASIS_PAR_INS')then

        begin
        	--Sentencia de la insercion
        	insert into asis.tpares(
			estado_reg,
			id_transaccion_ini,
			id_transaccion_fin,
			fecha_marcado,
			id_funcionario,
			id_licencia,
			id_vacacion,
			id_viatico,
			id_usuario_reg,
			fecha_reg,
			id_usuario_ai,
			usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_parametros.id_transaccion_ini,
			v_parametros.id_transaccion_fin,
			v_parametros.fecha_marcado,
			v_parametros.id_funcionario,
			v_parametros.id_licencia,
			v_parametros.id_vacacion,
			v_parametros.id_viatico,
			p_id_usuario,
			now(),
			v_parametros._id_usuario_ai,
			v_parametros._nombre_usuario_ai,
			null,
			null
            )RETURNING id_pares into v_id_pares;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Marcados Pares almacenado(a) con exito (id_pares'||v_id_pares||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_pares',v_id_pares::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_PAR_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		MMV
 	#FECHA:		19-09-2019 16:00:52
	***********************************/

	elsif(p_transaccion='ASIS_PAR_MOD')then

		begin
			--Sentencia de la modificacion
			update asis.tpares set
			id_transaccion_ini = v_parametros.id_transaccion_ini,
			id_transaccion_fin = v_parametros.id_transaccion_fin,
			fecha_marcado = v_parametros.fecha_marcado,
			evento = v_parametros.evento,
			id_funcionario = v_parametros.id_funcionario,
			nombre_lector = v_parametros.nombre_lector,
			id_licencia = v_parametros.id_licencia,
			id_vacacion = v_parametros.id_vacacion,
			id_viatico = v_parametros.id_viatico,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_pares=v_parametros.id_pares;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Marcados Pares modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_pares',v_parametros.id_pares::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_PAR_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		MMV
 	#FECHA:		19-09-2019 16:00:52
	***********************************/

	elsif(p_transaccion='ASIS_PAR_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from asis.tpares
            where id_pares=v_parametros.id_pares;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Marcados Pares eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_pares',v_parametros.id_pares::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

    /*********************************
 	#TRANSACCION:  'ASIS_PARS_INS'
 	#DESCRIPCION:	Armar Pares
 	#AUTOR:		MMV
 	#FECHA:		19-09-2019 16:00:52
	***********************************/

	elsif(p_transaccion='ASIS_PARS_INS')then

		begin
        ---Obtener el id funcionario
        for v_registro in (select   bio.id,
                                    bio.id_funcionario,
                                    bio.pin as codigo_funcionario,
                                    bio.area_name as nombre_area,
                                    bio.verify_mode_name as verificacion,
                                    bio.event_name evento,
                                    bio.pivot,
                                    bio.rango,
                                    EXTRACT(MONTH FROM bio.event_time::date) as periodo,
                                    bio.event_time::date as fecha_registro,
                                    to_char(bio.event_time, 'HH24:MI')::time as hora,
                                    to_char(bio.event_time, 'DD'::text)::integer as dia,
                                    asis.f_estraer_palabra(bio.reader_name,'Entrada','Salida')::varchar as accion,
                                    asis.f_estraer_palabra(bio.reader_name,'barrera')::varchar as dispocitvo,
                                    bio.reader_name
                                  from
                                    asis.ttransacc_zkb_etl bio
                                  where bio.id_funcionario = v_parametros.id_funcionario and
                                  EXTRACT(MONTH FROM bio.event_time::date)::integer = v_parametros.id_periodo
                                  and bio.reader_name not in  ('10.231.14.120-1-Entrada',
                                                              '10.231.14.120-2-Salida',
                                                              '10.231.14.170-1-Entrada',
                                                              '10.231.14.170-2-Entrada',
                                                              '10.231.14.170-3-Entrada',
                                                              '10.231.14.170-4-Entrada',
                                                              '10.231.14.171-1-Entrada',
                                                              '10.231.14.171-2-Entrada',
                                                              '10.231.14.171-3-Entrada',
                                                              '10.231.14.171-4-Entrada',
                                                              '10.231.14.171-4-Salida',
                                                              '10.231.14.172-1-Entrada',
                                                              '10.231.14.172-2-Entrada',
                                                              '10.231.14.172-3-Entrada',
                                                              '10.231.14.172-4-Entrada',
                                                              '10.231.14.173-1-Entrada',
                                                              '10.231.14.173-2-Entrada',
                                                              '10.231.14.173-3-Entrada',
                                                              '10.231.14.173-4-Entrada',
                                                              'PB_COT_INBIO460-1-Entrada',
                                                              'PB_COT_INBIO460-2-Entrada',
                                                              'PB_COT_INBIO460-3-Entrada',
                                                              'PB_COT_INBIO460-3-Salida',
                                                              'PB_COT_INBIO460-4-Entrada',
                                                              'PB_COT_INBIO460-4-Salida',
                                                              'P1_ACC1_INBIO460-1-Entrada',
                                                              'P1_ACC1_INBIO460-2-Entrada',
                                                              'P1_ACC1_INBIO460-3-Entrada',
                                                              'P1_ACC1_INBIO460-3-Salida',
                                                              'P1_ACC1_INBIO460-4-Entrada',
                                                              'P1_ACC2_INBIO260-1-Entrada',
                                                              'P2_ACC1_INBIO260-1-Entrada',
                                                              'P2_ACC1_INBIO260-2-Entrada',
                                                              'P2_ACC2_INBIO260-1-Entrada',
                                                              'PB_ACC1_INBIO260-1-Entrada',
                                                              'PB_ACC1_INBIO260-2-Entrada',
                                                              'PB_ACC2_INBIO460-1-Entrada',
                                                              'PB_ACC2_INBIO460-2-Entrada',
                                                              'PB_ACC2_INBIO460-3-Entrada',
                                                              'PB_ACC2_INBIO460-3-Salida',
                                                              'PB_ACC3_INBIO460-1-Entrada',
                                                              'PB_ACC3_INBIO460-2-Entrada',
                                                              'PB_ACC3_INBIO460-2-Salida',
                                                              'PB_ACC3_INBIO460-3-Entrada',
                                                              'PB_ACC3_INBIO460-4-Entrada',
                                                              'PB_ACC3_INBIO460-4-Salida')
                                  order by dia,hora asc)loop

                  v_rango_horario = asis.f_obtener_rango(  v_parametros.id_funcionario,
                                                              v_registro.fecha_registro,
                                                              v_registro.hora,
                                                              v_registro.reader_name);

            	update asis.ttransacc_zkb_etl set
                id_rango_horario = v_rango_horario[1]::integer,
        		fecha = v_registro.fecha_registro,
                hora = v_registro.hora,
                acceso = v_rango_horario[2]::varchar
                where id = v_registro.id;

        end loop;
        for v_record_pares in ( select  ma.dia,
                                  ma.id_rango_horario,
                                  asis.array_sort (string_to_array(pxp.list(ma.hora::text),','))  as horas
                                  from ( select  asis.f_id_transacion_bio (min(etl.hora)::time,
                                      v_parametros.id_periodo,
                                      v_parametros.id_funcionario,
                                      to_char(etl.fecha::date,'DD')::integer,
                                      'si'
                                    ) as id_transaccion_bio,
                                  to_char(etl.fecha, 'DD'::text)::integer as dia,
                                  etl.id_rango_horario,
                                  min(etl.hora) as hora,
                                  etl.acceso
                            from asis.ttransacc_zkb_etl etl
                            where etl.acceso = 'Entrada'
                            and etl.id_funcionario = v_parametros.id_funcionario
                            and EXTRACT(MONTH FROM etl.fecha::date)::integer = v_parametros.id_periodo
                            and etl.id_rango_horario is not null
                            and etl.reader_name not in  ('10.231.14.120-1-Entrada',
                                                              '10.231.14.120-2-Salida',
                                                              '10.231.14.170-1-Entrada',
                                                              '10.231.14.170-2-Entrada',
                                                              '10.231.14.170-3-Entrada',
                                                              '10.231.14.170-4-Entrada',
                                                              '10.231.14.171-1-Entrada',
                                                              '10.231.14.171-2-Entrada',
                                                              '10.231.14.171-3-Entrada',
                                                              '10.231.14.171-4-Entrada',
                                                              '10.231.14.171-4-Salida',
                                                              '10.231.14.172-1-Entrada',
                                                              '10.231.14.172-2-Entrada',
                                                              '10.231.14.172-3-Entrada',
                                                              '10.231.14.172-4-Entrada',
                                                              '10.231.14.173-1-Entrada',
                                                              '10.231.14.173-2-Entrada',
                                                              '10.231.14.173-3-Entrada',
                                                              '10.231.14.173-4-Entrada',
                                                              'PB_COT_INBIO460-1-Entrada',
                                                              'PB_COT_INBIO460-2-Entrada',
                                                              'PB_COT_INBIO460-3-Entrada',
                                                              'PB_COT_INBIO460-3-Salida',
                                                              'PB_COT_INBIO460-4-Entrada',
                                                              'PB_COT_INBIO460-4-Salida',
                                                              'P1_ACC1_INBIO460-1-Entrada',
                                                              'P1_ACC1_INBIO460-2-Entrada',
                                                              'P1_ACC1_INBIO460-3-Entrada',
                                                              'P1_ACC1_INBIO460-3-Salida',
                                                              'P1_ACC1_INBIO460-4-Entrada',
                                                              'P1_ACC2_INBIO260-1-Entrada',
                                                              'P2_ACC1_INBIO260-1-Entrada',
                                                              'P2_ACC1_INBIO260-2-Entrada',
                                                              'P2_ACC2_INBIO260-1-Entrada',
                                                              'PB_ACC1_INBIO260-1-Entrada',
                                                              'PB_ACC1_INBIO260-2-Entrada',
                                                              'PB_ACC2_INBIO460-1-Entrada',
                                                              'PB_ACC2_INBIO460-2-Entrada',
                                                              'PB_ACC2_INBIO460-3-Entrada',
                                                              'PB_ACC2_INBIO460-3-Salida',
                                                              'PB_ACC3_INBIO460-1-Entrada',
                                                              'PB_ACC3_INBIO460-2-Entrada',
                                                              'PB_ACC3_INBIO460-2-Salida',
                                                              'PB_ACC3_INBIO460-3-Entrada',
                                                              'PB_ACC3_INBIO460-4-Entrada',
                                                              'PB_ACC3_INBIO460-4-Salida')
                            group by etl.id_rango_horario, etl.fecha,etl.acceso
                            union all
                            select  asis.f_id_transacion_bio (max(etl.hora)::time,
                                                                v_parametros.id_periodo,
                                                                v_parametros.id_funcionario,
                                                                to_char(etl.fecha::date,'DD')::integer,
                                                                'si'
                                                              ) as id_transaccion_bio,
                                  to_char(etl.fecha, 'DD'::text)::integer as dia,
                                  etl.id_rango_horario,
                                  max(etl.hora) as hora,
                                  etl.acceso
                            from asis.ttransacc_zkb_etl etl
                            where etl.acceso = 'Salida'
                            and etl.id_funcionario = v_parametros.id_funcionario
                            and EXTRACT(MONTH FROM etl.fecha::date)::integer = v_parametros.id_periodo
                            and etl.id_rango_horario is not null
                             and etl.reader_name not in  ('10.231.14.120-1-Entrada',
                                                              '10.231.14.120-2-Salida',
                                                              '10.231.14.170-1-Entrada',
                                                              '10.231.14.170-2-Entrada',
                                                              '10.231.14.170-3-Entrada',
                                                              '10.231.14.170-4-Entrada',
                                                              '10.231.14.171-1-Entrada',
                                                              '10.231.14.171-2-Entrada',
                                                              '10.231.14.171-3-Entrada',
                                                              '10.231.14.171-4-Entrada',
                                                              '10.231.14.171-4-Salida',
                                                              '10.231.14.172-1-Entrada',
                                                              '10.231.14.172-2-Entrada',
                                                              '10.231.14.172-3-Entrada',
                                                              '10.231.14.172-4-Entrada',
                                                              '10.231.14.173-1-Entrada',
                                                              '10.231.14.173-2-Entrada',
                                                              '10.231.14.173-3-Entrada',
                                                              '10.231.14.173-4-Entrada',
                                                              'PB_COT_INBIO460-1-Entrada',
                                                              'PB_COT_INBIO460-2-Entrada',
                                                              'PB_COT_INBIO460-3-Entrada',
                                                              'PB_COT_INBIO460-3-Salida',
                                                              'PB_COT_INBIO460-4-Entrada',
                                                              'PB_COT_INBIO460-4-Salida',
                                                              'P1_ACC1_INBIO460-1-Entrada',
                                                              'P1_ACC1_INBIO460-2-Entrada',
                                                              'P1_ACC1_INBIO460-3-Entrada',
                                                              'P1_ACC1_INBIO460-3-Salida',
                                                              'P1_ACC1_INBIO460-4-Entrada',
                                                              'P1_ACC2_INBIO260-1-Entrada',
                                                              'P2_ACC1_INBIO260-1-Entrada',
                                                              'P2_ACC1_INBIO260-2-Entrada',
                                                              'P2_ACC2_INBIO260-1-Entrada',
                                                              'PB_ACC1_INBIO260-1-Entrada',
                                                              'PB_ACC1_INBIO260-2-Entrada',
                                                              'PB_ACC2_INBIO460-1-Entrada',
                                                              'PB_ACC2_INBIO460-2-Entrada',
                                                              'PB_ACC2_INBIO460-3-Entrada',
                                                              'PB_ACC2_INBIO460-3-Salida',
                                                              'PB_ACC3_INBIO460-1-Entrada',
                                                              'PB_ACC3_INBIO460-2-Entrada',
                                                              'PB_ACC3_INBIO460-2-Salida',
                                                              'PB_ACC3_INBIO460-3-Entrada',
                                                              'PB_ACC3_INBIO460-4-Entrada',
                                                              'PB_ACC3_INBIO460-4-Salida')
                            group by etl.id_rango_horario, etl.fecha,etl.acceso
                             union all
                            select  etl.id,
                                    to_char(etl.event_time, 'DD'::text)::integer as dia,
                                    etl.id_rango_horario,
                                    etl.hora,
                                    etl.acceso
                              from asis.ttransacc_zkb_etl etl
                              where etl.id_funcionario = v_parametros.id_funcionario
                              and EXTRACT(MONTH FROM etl.event_time::date)::integer = v_parametros.id_periodo
                              and etl.id_rango_horario is null
                              order by dia) as ma
                                          where ma.id_rango_horario is not null
                                          group by ma.dia,
                                                   ma.id_rango_horario
                                          order by dia)loop
                         foreach v_hora in array v_record_pares.horas
           				 										loop

                         v_impar =  array_length(v_record_pares.horas,1) % 2;

                         if v_impar = 0 then
                        		 if not asis.f_pares ( v_parametros.id_funcionario,
                                                       v_parametros.id_periodo,
                                                       v_record_pares.dia,
                                                       v_hora) then
                                    raise exception 'algo sali mal en los pares asignado :(';
                                end if;
                         end if;

                         if v_impar = 1 then
                         	  if not asis.f_buscar_su_par ( v_parametros.id_funcionario,
                              								v_parametros.id_periodo,
                                                            v_record_pares.dia,
                                                            v_hora,
                                                            v_record_pares.id_rango_horario)  then
                                  raise exception 'algo sali mal al buscar su par :( ';
                              end if;
                         end if;

                         end loop;
        	end loop;


           /* for v_justificar in (select   bio.id_transaccion_bio,
                                          to_char(bio.fecha_marcado,'DD')::integer as dia,
                                          bio.hora,
                                          bio.id_rango_horario,
                                          bio.event_time::date as event_time,
                                          bio.evento,
                                          bio.rango
                                    from asis.ttransaccion_bio bio
                                    where  bio.id_funcionario = v_id_funcionario
                                    and bio.id_periodo = v_parametros.id_periodo
                                    and  bio.id_rango_horario is null
                                    and bio.rango = 'no'
                                    order by dia,hora) loop
             if v_justificar.evento = 'Salida' then

               insert into asis.tpares( id_usuario_reg,
                                        id_usuario_mod,
                                        fecha_reg,
                                        fecha_mod,
                                        estado_reg,
                                        id_transaccion_ini,
                                        id_transaccion_fin,
                                        fecha_marcado,
                                        id_funcionario,
                                        id_licencia,
                                        id_vacacion,
                                        id_viatico,
                                        id_periodo,
                                        rango
                                         )values (
                                        p_id_usuario,
                                        null,
                                        now(),
                                        null,
                                        'activo',
                                        null,
                                        v_justificar.id_transaccion_bio,
                                        v_justificar.event_time,
                                        v_id_funcionario,
                                        null,
                                        null,
                                        null,
                                        v_parametros.id_periodo,
                                        'to'
                                        )RETURNING id_pares into v_id_pares;
              v_id = v_id_pares;
             end if;

             if v_justificar.evento = 'Entrada' then

             	update asis.tpares set
                id_transaccion_ini = v_justificar.id_transaccion_bio
                where id_pares = v_id;

             	v_id = null;
             end if;

            end loop;*/


            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Pares armados con exito');
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

ALTER FUNCTION asis.ft_pares_ime (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;