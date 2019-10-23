CREATE OR REPLACE FUNCTION asis.f_id_transacion_bio (
  p_hora time,
  p_id_periodo integer,
  p_id_funcionario integer,
  p_dia integer,
  p_rango varchar
)
RETURNS integer AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.f_centro_validar
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
   v_resp                      			varchar;
   v_nombre_funcion            			text;
   v_id_transaccion						integer;
BEGIN
  	v_nombre_funcion = 'asis.f_id_transacion_bio';

    v_id_transaccion = null;

    select bio.id_transaccion_bio into v_id_transaccion
    from asis.ttransaccion_bio bio
    where bio.id_funcionario = p_id_funcionario
    and bio.id_periodo = p_id_periodo
    and to_char(bio.fecha_marcado,'DD')::integer = p_dia
    and bio.hora = p_hora
  --  and bio.rango = 'no'
    and
    case
    	when p_rango = 'no' then
        	bio.id_rango_horario is null
        when p_rango = 'si' then
        	bio.id_rango_horario is not null
    end;


    RETURN v_id_transaccion;
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
STABLE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;

ALTER FUNCTION asis.f_id_transacion_bio (p_hora time, p_id_periodo integer, p_id_funcionario integer, p_dia integer, p_rango varchar)
  OWNER TO dbaamamani;