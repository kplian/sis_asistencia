CREATE OR REPLACE FUNCTION asis.f_calcular_total_hora (
  p_id_funcionario integer,
  p_fecha date
)
RETURNS integer AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.f_asignar_pro
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
   v_resp                       varchar;
   v_nombre_funcion             text;
   v_resultado					integer;
   v_horas						timestamp[];
   v_count						integer;
   v_record						record;


BEGIN
  	v_nombre_funcion = 'asis.f_calcular_total_hora';

    v_resultado = 0;



    select  asis.array_sort(string_to_array(pxp.list (case
                  when pa.hora_ini is not null then
                       pa.hora_ini
                  when pa.hora_fin is not null then
                       pa.hora_fin
                  end::text),',')) as hora into v_horas
        from asis.tpares pa
        where pa.id_funcionario = p_id_funcionario
        and pa.fecha_marcado = p_fecha
        and pa.rango = 'si';

      v_count = array_length(v_horas,1);


      if v_count % 2  = 1 then
      		v_resultado = COALESCE(round(COALESCE(asis.f_date_diff('minute', v_horas[1]::timestamp, v_horas[v_count - 1]::timestamp),0)/60::numeric,1),0);
      else

           v_resultado = COALESCE(round(COALESCE(asis.f_date_diff('minute', v_horas[1]::timestamp, v_horas[2]::timestamp),0)/60::numeric,1),0)
              +
              COALESCE(round(COALESCE(asis.f_date_diff('minute', v_horas[3]::timestamp, v_horas[v_count]::timestamp),0)/60::numeric,1),0);

      end if;


    return v_resultado;
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
LEAKPROOF
PARALLEL UNSAFE
COST 100;

ALTER FUNCTION asis.f_calcular_total_hora (p_id_funcionario integer, p_fecha date)
  OWNER TO dbaamamani;