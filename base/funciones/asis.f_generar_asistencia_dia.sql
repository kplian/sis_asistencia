CREATE OR REPLACE FUNCTION asis.f_generar_asistencia_dia (
  p_fecha date,
  p_id_funcionario integer,
  p_horas_array varchar []
)
RETURNS varchar [] AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.f_generar_asistencia_dia
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
   v_transaccion				record;
   v_resultador					varchar[];
   v_valor						varchar[];
   v_event_time					timestamp;
   v_index						integer;
BEGIN
	v_nombre_funcion = 'asis.f_generar_asistencia_dia';
    v_valor = string_to_array( ' 10.231.14.120-1-Entrada,
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
                                  PB_ACC3_INBIO460-4-Salida', ',');

		 --

         --


         -- si el arreglo no tiene valores
	 	 if p_horas_array is null then
            	return null;
          end if;

          -- si el arreglo es pares
          if array_length(p_horas_array,1) % 2 = 0 then
         	return p_horas_array;
          end if;

    	  -- si el arreglo es impar

          if array_length(p_horas_array,1) % 2 = 1 then

                v_index = array_length(p_horas_array,1);

                select  etr.id,
                      etr.id_rango_horario,
                      etr.acceso,
                      etr.fecha,
                      etr.event_time into v_transaccion
                      from asis.ttransacc_zkb_etl etr
                      where etr.id_funcionario = p_id_funcionario
                      and etr.event_time = p_horas_array[v_index]::timestamp;

              -- Busca su salida maxima
              if v_transaccion.acceso = 'Entrada' then

               v_resultador = null;

                     select max(etl.event_time) as event_time into v_event_time
                     from asis.ttransacc_zkb_etl etl
                     where etl.acceso in ('Salida','Otro',null)
                            and etl.id_funcionario = p_id_funcionario
                            and (etl.rango = 'no' or etl.rango is null)
                            and etl.fecha = p_fecha
                            and etl.reader_name != any (v_valor)
                            and etl.event_name != 'Acceso denegado'
                            and etl.id_rango_horario is null;

              	 if v_event_time is null then
                    v_resultador = array_append(v_resultador,null::varchar);
                	return array_append(v_resultador,p_horas_array[v_index]::varchar);
                else
                        v_resultador = p_horas_array;
                        v_resultador = array_append(v_resultador,v_event_time::varchar);
                	 return  asis.array_sort(v_resultador);
              	end if;

              -- Busca su Entrada minima
              elsif v_transaccion.acceso = 'Salida' then

                v_resultador = null;

                select min(etl.event_time) as event_time into v_event_time
                from asis.ttransacc_zkb_etl etl
                where etl.acceso in ('Entrada','Otro',null)
                      and etl.id_funcionario = p_id_funcionario
                      and (etl.rango = 'no' or etl.rango is null)
                      and etl.fecha = p_fecha::date
                      and etl.reader_name != any (v_valor)
                      and etl.event_name != 'Acceso denegado'
                      and etl.id_rango_horario is null;


                if v_event_time is null then
                    v_resultador = array_append(v_resultador,null::varchar);
                	return array_append(v_resultador,p_horas_array[v_index]::varchar);
                else
                        v_resultador = p_horas_array;
                        v_resultador = array_append(v_resultador,v_event_time::varchar);
                	 return  asis.array_sort(v_resultador);
              	end if;

              end if;
          end if;

    	return null;

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

ALTER FUNCTION asis.f_generar_asistencia_dia (p_fecha date, p_id_funcionario integer, p_horas_array varchar [])
  OWNER TO dbaamamani;