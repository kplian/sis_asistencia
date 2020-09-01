CREATE OR REPLACE FUNCTION asis.f_completar (
  p_fecha date,
  p_id_funcionario integer,
  p_horas_array varchar [],
  p_dia_literal varchar
)
RETURNS varchar [] AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.f_generar_asistencia
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.f_centro_validar'
 AUTOR: 		 MMV Kplian
 FECHA:	        31-01-2019 16:36:51
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				31-01-2019 16:36:51								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.tmes_trabajo_det'

 ***************************************************************************/
DECLARE
   v_resp                      	varchar;
   v_nombre_funcion            	text;
   v_resultador					varchar[];
   v_valor						varchar[];
   v_filtro						varchar;
   v_consulta					varchar;
   v_jornada					integer;
   v_index						integer;
   v_transaccion				record;
   v_event_time					timestamp;
   v_calcular					numeric;
   v_nro_rango					integer;
   v_hora						timestamp;
   v_tiempo						timestamp;
   v_record						record;
   v_entrada					integer;
   v_salida						integer;


BEGIN

  	v_nombre_funcion = 'asis.f_generar_asistencia';

    v_valor = string_to_array( '  10.231.14.120-1-Entrada,
                                  10.231.14.120-2-Salida,
                                  10.231.14.170-1-Entrada,
                                  10.231.14.170-2-Entrada,
                                  10.231.14.170-3-Entrada,
                                  10.231.14.170-4-Entrada,
                                  10.231.14.171-1-Entrada,
                                  10.231.14.171-2-Entrada,
                                  10.231.14.171-3-Entrada,
                                  10.231.14.171-4-Entrada,
                                  10.231.14.171-4-Salida,
                                  10.231.14.172-1-Entrada,
                                  10.231.14.172-2-Entrada,
                                  10.231.14.172-3-Entrada,
                                  10.231.14.172-4-Entrada,
                                  10.231.14.173-1-Entrada,
                                  10.231.14.173-2-Entrada,
                                  10.231.14.173-3-Entrada,
                                  10.231.14.173-4-Entrada,
                                  PB_COT_INBIO460-1-Entrada,
                                  PB_COT_INBIO460-2-Entrada,
                                  PB_COT_INBIO460-3-Entrada,
                                  PB_COT_INBIO460-3-Salida,
                                  PB_COT_INBIO460-4-Entrada,
                                  PB_COT_INBIO460-4-Salida,
                                  P1_ACC1_INBIO460-1-Entrada,
                                  P1_ACC1_INBIO460-2-Entrada,
                                  P1_ACC1_INBIO460-3-Entrada,
                                  P1_ACC1_INBIO460-3-Salida,
                                  P1_ACC1_INBIO460-4-Entrada,
                                  P1_ACC2_INBIO260-1-Entrada,
                                  P2_ACC1_INBIO260-1-Entrada,
                                  P2_ACC1_INBIO260-2-Entrada,
                                  P2_ACC2_INBIO260-1-Entrada,
                                  PB_ACC1_INBIO260-1-Entrada,
                                  PB_ACC1_INBIO260-2-Entrada,
                                  PB_ACC2_INBIO460-1-Entrada,
                                  PB_ACC2_INBIO460-2-Entrada,
                                  PB_ACC2_INBIO460-3-Entrada,
                                  PB_ACC2_INBIO460-3-Salida,
                                  PB_ACC3_INBIO460-1-Entrada,
                                  PB_ACC3_INBIO460-2-Entrada,
                                  PB_ACC3_INBIO460-2-Salida,
                                  PB_ACC3_INBIO460-3-Entrada,
                                  PB_ACC3_INBIO460-4-Entrada,
                                  PB_ACC3_INBIO460-4-Salida,
                                  10.231.14.170-4-Entrada', ',');

       v_resultador = null;
       v_filtro = asis.f_obtener_rango_asignado_fun (p_id_funcionario,p_fecha);

       v_consulta = 'select COALESCE(sum(rh.jornada_laboral),0) as jornada_laboral
                    from asis.trango_horario rh
                    inner join asis.tasignar_rango ar on ar.id_rango_horario = rh.id_rango_horario
                    where '||v_filtro||'and rh.'||p_dia_literal||' = ''si''
                    and  '''||p_fecha||'''::date between ar.desde and ar.hasta';

       execute (v_consulta) into v_jornada;

	   if v_jornada = 0 then

       		v_consulta = 'select COALESCE(sum(rh.jornada_laboral),0) as jornada_laboral
                                from asis.trango_horario rh
                                inner join asis.tasignar_rango ar on ar.id_rango_horario = rh.id_rango_horario
                                where '||v_filtro||'and rh.'||p_dia_literal||' = ''si''
                                and  '''||p_fecha||'''::date >= ar.desde and ar.hasta is null';
                   execute (v_consulta) into v_jornada;

       end if;

         if(array_length(p_horas_array,1) % 2 = 0)then

              if(array_length(p_horas_array,1) >= 4)then

                    return p_horas_array;
              end if;

              if(array_length(p_horas_array,1) = 2)then

                select array_length (string_to_array(pxp.list(distinct tr.id_rango_horario::text),','),1)
                into v_nro_rango
                from asis.ttransacc_zkb_etl tr
                where tr.id_funcionario = p_id_funcionario
                and tr.event_time::text = ANY(p_horas_array);

                  if v_nro_rango > 1 then
                    ----

                    v_calcular =  COALESCE(round(COALESCE(asis.f_date_diff('minute', p_horas_array[1]::timestamp, p_horas_array[2]::timestamp),0)/60::numeric,1),0);
				 	v_entrada = 0;
                    v_salida = 0;
                    if (v_calcular >= v_jornada) then
                  --  raise exception 'entra --> %',v_calcular;

                         foreach v_hora in array p_horas_array loop

                                select  etr.id,
                                        etr.acceso,
                                        etr.fecha,
                                        etr.event_time into v_transaccion
                                        from asis.ttransacc_zkb_etl etr
                                        where etr.id_funcionario = p_id_funcionario
                                        and etr.event_time = v_hora;
                                if v_transaccion.acceso = 'Entrada' then
                                	v_entrada = v_entrada + 1;
                                end if;

                                if v_transaccion.acceso = 'Salida' then
                                	v_salida = v_salida + 1;
                                end if;

                         end loop;

                    	if v_entrada =  v_salida then
                    		return p_horas_array;
                        else
                        ---

                           v_resultador = p_horas_array;
                           v_tiempo = null;

                            foreach v_hora in array p_horas_array loop

                       		select  etr.id,
                                    etr.acceso,
                                    etr.fecha,
                                    etr.event_time into v_transaccion
                                    from asis.ttransacc_zkb_etl etr
                                    where etr.id_funcionario = p_id_funcionario
                                    and etr.event_time = v_hora;


                             if v_transaccion.acceso = 'Entrada' then

                             		 select max(etl.event_time) as event_time into v_event_time
                                     from asis.ttransacc_zkb_etl etl
                                     where /*etl.acceso in ('Salida','Otro',null)
                                            and*/ etl.id_funcionario = p_id_funcionario
                                            and (etl.rango = 'no' or etl.rango is null)
                                            and etl.fecha = p_fecha
                                            and etl.reader_name not in (select rn.name from asis.treader_no rn)
                                            and etl.event_name != 'Acceso denegado'
                                            and etl.id_rango_horario is null
                                            and case
                                            		when v_tiempo is not null then
                                            			etl.event_time != v_tiempo
                                            		else
                                                    	0=0
                                            	end ;

                             v_resultador =  array_append(v_resultador,v_event_time::varchar);

                               if (v_tiempo is null or v_event_time <>  v_tiempo) then
                                   v_tiempo = v_event_time;
                               end if;


                             elsif v_transaccion.acceso = 'Salida' then

                             	  select min(etl.event_time) as event_time into v_event_time
                                  from asis.ttransacc_zkb_etl etl
                                  where /*etl.acceso in ('Entrada','Otro',null)
                                        and*/ etl.id_funcionario = p_id_funcionario
                                        and (etl.rango = 'no' or etl.rango is null)
                                        and etl.fecha = p_fecha::date
                                        and etl.reader_name not in (select rn.name from asis.treader_no rn)
                                        and etl.event_name != 'Acceso denegado'
                                        and etl.id_rango_horario is null
                                        and case
                                            		when v_tiempo is not null then
                                            			etl.event_time != v_tiempo
                                            		else
                                                    	0=0
                                            	end ;


                               v_resultador =  array_append(v_resultador,v_event_time::varchar);


                               if (v_tiempo is null or v_event_time <>  v_tiempo) then
                                   v_tiempo = v_event_time;
                               end if;

                             end if;

                       end loop;

                       return asis.array_sort(v_resultador);
                        ---
                        end if;
                    else
                  	----

                  	  v_resultador = p_horas_array;
                      v_tiempo = null;

                  	   foreach v_hora in array p_horas_array loop

                       		select  etr.id,
                                    etr.acceso,
                                    etr.fecha,
                                    etr.event_time into v_transaccion
                                    from asis.ttransacc_zkb_etl etr
                                    where etr.id_funcionario = p_id_funcionario
                                    and etr.event_time = v_hora;


                             if v_transaccion.acceso = 'Entrada' then

                             		 select max(etl.event_time) as event_time into v_event_time
                                     from asis.ttransacc_zkb_etl etl
                                     where /*etl.acceso in ('Salida','Otro',null)
                                            and*/ etl.id_funcionario = p_id_funcionario
                                            and (etl.rango = 'no' or etl.rango is null)
                                            and etl.fecha = p_fecha
                                            and etl.reader_name not in (select rn.name from asis.treader_no rn)
                                            and etl.event_name != 'Acceso denegado'
                                            and etl.id_rango_horario is null
                                            and case
                                            		when v_tiempo is not null then
                                            			etl.event_time != v_tiempo
                                            		else
                                                    	0=0
                                            	end ;

                             v_resultador =  array_append(v_resultador,v_event_time::varchar);

                               if (v_tiempo is null or v_event_time <>  v_tiempo) then
                                   v_tiempo = v_event_time;
                               end if;


                             elsif v_transaccion.acceso = 'Salida' then

                             	  select min(etl.event_time) as event_time into v_event_time
                                  from asis.ttransacc_zkb_etl etl
                                  where /*etl.acceso in ('Entrada','Otro',null)
                                        and*/ etl.id_funcionario = p_id_funcionario
                                        and (etl.rango = 'no' or etl.rango is null)
                                        and etl.fecha = p_fecha::date
                                        and etl.reader_name not in (select rn.name from asis.treader_no rn)
                                        and etl.event_name != 'Acceso denegado'
                                        and etl.id_rango_horario is null
                                        and case
                                            		when v_tiempo is not null then
                                            			etl.event_time != v_tiempo
                                            		else
                                                    	0=0
                                            	end ;


                               v_resultador =  array_append(v_resultador,v_event_time::varchar);


                               if (v_tiempo is null or v_event_time <>  v_tiempo) then
                                   v_tiempo = v_event_time;
                               end if;

                             end if;

                       end loop;

                       return asis.array_sort(v_resultador);
                      end if;
                      ---
                  else
                       return p_horas_array;
                  end if;

              end if;

          end if;

          if array_length(p_horas_array,1) % 2 = 1 then

           for v_record in (select  ma.id_rango_horario,
                                    asis.array_sort (string_to_array(pxp.list(ma.hora::text),','))  as horas,
                                    string_to_array(pxp.list(ma.acceso),',') as evento,
                                    array_length(asis.array_sort (string_to_array(pxp.list(ma.hora::text),',')),1) as orden
                              from ( select  to_char(etl.fecha, 'DD')::integer as dia,
                                              etl.id_rango_horario,
                                              min(etl.event_time) as hora,
                                              etl.acceso
                                        from asis.ttransacc_zkb_etl etl
                                        where etl.acceso = 'Entrada'
                                        and etl.id_funcionario = p_id_funcionario
                                        and etl.fecha = p_fecha
                                        and etl.id_rango_horario is not null
                                        and etl.rango = 'no'
                                        group by etl.id_rango_horario, etl.fecha,etl.acceso
                              union all
                              select  to_char(etl.fecha, 'DD')::integer as dia,
                                        etl.id_rango_horario,
                                        max(etl.event_time) as hora,
                                        etl.acceso
                                  from asis.ttransacc_zkb_etl etl
                                  where etl.acceso = 'Salida'
                                  and etl.id_funcionario = p_id_funcionario
                                  and etl.fecha = p_fecha
                                  and etl.id_rango_horario is not null
                                  and etl.rango = 'no'
                                  group by etl.id_rango_horario, etl.fecha,etl.acceso
                                  order by hora ) as ma
                                  group by ma.dia,
                                           ma.id_rango_horario
                                  order by orden asc)loop

                                  if array_length(v_record.horas,1) % 2 = 0 then
                                 		foreach v_hora in array v_record.horas  loop
                                          v_resultador = array_append(v_resultador,v_hora::varchar);
                                        end loop;
                                  end if;

                                  if array_length(v_record.horas,1) % 2 = 1 then

                                      v_resultador = array_append(v_resultador,v_record.horas[1]::varchar);

                                      if v_record.evento[1] = 'Entrada' then

                                           select max(etl.event_time) as event_time into v_event_time
                                           from asis.ttransacc_zkb_etl etl
                                           where /*etl.acceso in ('Salida','Otro',null)
                                                  and*/ etl.id_funcionario = p_id_funcionario
                                                  and (etl.rango = 'no' or etl.rango is null)
                                                  and etl.fecha = p_fecha
                                                  and etl.reader_name not in (select rn.name from asis.treader_no rn)
                                                  and etl.event_name != 'Acceso denegado'
                                                  and etl.id_rango_horario is null;

                                      v_resultador = array_append(v_resultador,v_event_time::varchar);

                                      elsif v_record.evento[1] = 'Salida' then

                                            select min(etl.event_time) as event_time into v_event_time
                                            from asis.ttransacc_zkb_etl etl
                                            where /*etl.acceso in ('Entrada','Otro',null)
                                                  and*/ etl.id_funcionario = p_id_funcionario
                                                  and (etl.rango = 'no' or etl.rango is null)
                                                  and etl.fecha = p_fecha::date
                                                  and etl.reader_name not in (select rn.name from asis.treader_no rn)
                                                   --and etl.reader_name <> '10.231.14.170-4-Entrada'
                                                  and etl.event_name <> 'Acceso denegado'
                                                  and etl.id_rango_horario is null;

                                                  /*raise notice 'e %',v_valor;
                                                  raise exception 'e %',v_event_time;*/

                                      v_resultador = array_append(v_resultador,v_event_time::varchar);

                                      end if;

                                  end if;
           end loop;

           return v_resultador;

 		  end if;


       return v_resultador;

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

ALTER FUNCTION asis.f_completar (p_fecha date, p_id_funcionario integer, p_horas_array varchar [], p_dia_literal varchar)
  OWNER TO dbaamamani;