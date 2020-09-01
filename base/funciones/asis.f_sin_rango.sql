CREATE OR REPLACE FUNCTION asis.f_sin_rango (
  p_fecha date,
  p_id_funcionario integer
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
   v_transaccion				record;
   v_resultador					varchar[];
   v_valor						varchar[];
   v_event_time					timestamp;
  -- v_fin_semana					integer;

BEGIN

  	v_nombre_funcion = 'asis.f_generar_asistencia';

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
                                  PB_ACC3_INBIO460-4-Salida,
                                  10.231.14.170-4-Entrada', ',');

       v_resultador = null;

     	  -- raise exception 'entra';
        if exists (select 1
                    from asis.ttransacc_zkb_etl tr
                    where tr.fecha = p_fecha
                          and tr.id_rango_horario is null
                          and tr.reader_name != any (v_valor)
                          and tr.id_funcionario = p_id_funcionario)then

        select asis.array_sort (string_to_array(pxp.list(ma.hora::text),',')) into v_resultador
                  from ( select min(etl.event_time) as hora
                            from asis.ttransacc_zkb_etl etl
                            where etl.acceso in ('Entrada','Otro',null)
                            and etl.id_funcionario = p_id_funcionario
                            and etl.id_rango_horario is null
                            and etl.fecha  = p_fecha
                            and etl.reader_name != any (v_valor)
                            and etl.rango = 'no'
                  union all
                  select max(etl.event_time) as hora
                      from asis.ttransacc_zkb_etl etl
                      where etl.acceso in ('Salida','Otro',null)
                      and etl.id_funcionario = p_id_funcionario
                      and etl.id_rango_horario is null
                      and etl.fecha  = p_fecha
                      and etl.reader_name != any (v_valor)
                      and etl.rango = 'no'
                      order by hora ) as ma;

                  return v_resultador;
        else
        	return null;
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

ALTER FUNCTION asis.f_sin_rango (p_fecha date, p_id_funcionario integer)
  OWNER TO dbaamamani;