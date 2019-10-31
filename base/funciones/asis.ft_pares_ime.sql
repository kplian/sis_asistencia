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
	v_id_pares				integer;
    v_record_pares			record;
    v_count					integer;
    v_codigo				varchar;
    v_id_funcionario		integer;
    v_marcaciones			record;
    v_count_entrada			integer;
    v_count_salida			integer;
    v_id_pares_aux			integer;
    v_pivot					integer;
    v_registro				record;
    v_hora					time;
    v_index					integer;
    v_fuera_rango			varchar[];
    v_pares					varchar[];
    v_array_hora			time;
    v_conte_hora			time;
    v_impar   				integer;
    v_record				record;
    v_justificar			record;
    v_id					integer;

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

            select trim(both 'FUNODTPR' from  fun.codigo ) as desc_codigo,fun.id_funcionario
            into v_codigo,v_id_funcionario
            from orga.vfuncionario fun
            where fun.id_funcionario = v_parametros.id_funcionario;

           /* delete from asis.tpares pa
            where pa.id_funcionario = v_id_funcionario  and pa.id_periodo = v_parametros.id_periodo;*/

			--Sentencia de la Pares
            for v_record_pares in (select  ma.dia,
                                  ma.id_rango_horario,
                                  asis.array_sort (string_to_array(pxp.list(ma.hora::text),','))  as horas
                                  from ( select   asis.f_id_transacion_bio (
                                                min( bio.hora)::time,
                                                v_parametros.id_periodo,
                                                v_id_funcionario,
                                                to_char(bio.fecha_marcado,'DD')::integer,
                                                'si'
                                              ) as id_transaccion_bio,
                                              to_char(bio.fecha_marcado,'DD')::integer as dia,
                                              bio.id_rango_horario,
                                              min( bio.hora) as hora,
                                              bio.evento
                                      from asis.ttransaccion_bio bio
                                      where bio.evento = 'Entrada'
                                      and bio.id_funcionario = v_id_funcionario
                                      and bio.id_periodo = v_parametros.id_periodo
                                      and bio.id_rango_horario is not null
                                      group by bio.id_rango_horario, bio.evento,bio.fecha_marcado
                                      union all
                                      select  asis.f_id_transacion_bio (
                                                max( bio.hora)::time,
                                                v_parametros.id_periodo,
                                                v_id_funcionario,
                                                to_char(bio.fecha_marcado,'DD')::integer,
                                                'si'
                                              ) as id_transaccion_bio,
                                              to_char(bio.fecha_marcado,'DD')::integer as dia,
                                              bio.id_rango_horario,
                                              max( bio.hora) as hora,
                                              bio.evento
                                      from asis.ttransaccion_bio bio
                                      where bio.evento = 'Salida'
                                      and bio.id_funcionario = v_id_funcionario
                                      and bio.id_periodo = v_parametros.id_periodo
                                      and bio.id_rango_horario is not null
                                      group by bio.id_rango_horario, bio.evento,bio.fecha_marcado
                                      union all
                                      select  bio.id_transaccion_bio,
                                              to_char(bio.fecha_marcado,'DD')::integer as dia,
                                              bio.id_rango_horario,
                                              bio.hora,
                                              bio.evento
                                      from asis.ttransaccion_bio bio
                                      where  bio.id_funcionario = v_id_funcionario
                                      and bio.id_periodo = v_parametros.id_periodo
                                      and bio.id_rango_horario is null
                                      order by dia) as ma
                                      where ma.id_rango_horario is not null
                                     -- and  ma.dia = 3
                                      group by ma.dia,
                                               ma.id_rango_horario
                                      order by dia)loop

                         v_index := 1;
                         foreach v_hora in array v_record_pares.horas
           				 										loop

                         v_impar =  array_length(v_record_pares.horas,1) % 2;

                         if v_impar = 0 then
                        		 if not asis.f_pares ( v_id_funcionario,
                                                       v_parametros.id_periodo,
                                                       v_record_pares.dia,
                                                       v_hora) then
                                    raise exception 'algo sali mal en los pares asignado :(';
                                end if;
                         end if;

                         if v_impar = 1 then
                         	  if not asis.f_buscar_su_par ( v_id_funcionario,
                              								v_parametros.id_periodo,
                                                            v_record_pares.dia,
                                                            v_hora,
                                                            v_record_pares.id_rango_horario)  then
                                  raise exception 'algo sali mal al buscar su par :( ';
                              end if;
                         end if;

                         v_index = v_index + 1;
                         end loop;

            end loop;
            --raise exception 'final';


            for v_registro in (select  distinct to_char(bio.fecha_marcado,'DD')::integer as dia
                                        from asis.ttransaccion_bio bio
                                        where bio.id_periodo = v_parametros.id_periodo
                                        and bio.id_funcionario = v_id_funcionario
                                        order by dia)loop

              		 v_pivot = 1;
            		for v_record in (select   bio.id_transaccion_bio,
                                              to_char(bio.fecha_marcado,'DD')::integer as dia,
                                              bio.hora,
                                              bio.id_rango_horario,
                                              bio.event_time::date as event_time,
                                              bio.evento,
                                              bio.rango
                                      from asis.ttransaccion_bio bio
                                      where  bio.id_funcionario = v_id_funcionario
                                      and bio.id_periodo = v_parametros.id_periodo
                                      and bio.rango = 'si'
                                      and to_char(bio.fecha_marcado,'DD')::integer = v_registro.dia
                                      order by dia,hora)loop

                        if v_record.evento = 'Entrada' then

                        	update asis.ttransaccion_bio set
                            pivot = v_pivot
                            where id_transaccion_bio = v_record.id_transaccion_bio;

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
                                                                v_record.id_transaccion_bio,
                                                                null,
                                                                v_record.event_time,
                                                                v_id_funcionario,
                                                                null,
                                                                null,
                                                                null,
                                                                v_parametros.id_periodo,
                                                                'si'
                                                                )RETURNING id_pares into v_id_pares;
                                      v_id_pares_aux = v_id_pares;
                          end if;

                            if v_record.evento = 'Salida' then

                            update asis.ttransaccion_bio set
                            pivot = v_pivot
                            where id_transaccion_bio = v_record.id_transaccion_bio;

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
                                                                id_pares_entrada,
                                                                id_periodo,
                                                                rango
                                                                 )values (
                                                                p_id_usuario,
                                                                null,
                                                                now(),
                                                                null,
                                                                'activo',
                                                                null,
                                                                v_record.id_transaccion_bio,
                                                                v_record.event_time,
                                                                v_id_funcionario,
                                                                null,
                                                                null,
                                                                null,
                                                                v_id_pares_aux,
                                                                v_parametros.id_periodo,
                                                                'si'
                                                                );
                                      v_id_pares_aux = null;

                          end if;
                          v_pivot = v_pivot + 1;
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