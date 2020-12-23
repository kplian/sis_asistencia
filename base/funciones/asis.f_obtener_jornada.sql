CREATE OR REPLACE FUNCTION asis.f_obtener_jornada (
  p_hora time
)
RETURNS varchar AS
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
   v_resultado							varchar;

BEGIN
  	v_nombre_funcion = 'asis.f_obtener_jornada';

    IF (p_hora >= TO_CHAR('00:00:00'::time, 'HH24:MI:SS')::time and
    	p_hora < TO_CHAR('12:00:00'::time, 'HH24:MI:SS')::time)THEN
        v_resultado = 'ma';
    END IF;
    IF (p_hora >= TO_CHAR('12:00:00'::time, 'HH24:MI:SS')::time and
    	p_hora < TO_CHAR('23:00:00'::time, 'HH24:MI:SS')::time)THEN
        v_resultado = 'ta';
    END IF;
RETURN v_resultado;
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

ALTER FUNCTION asis.f_obtener_jornada (p_hora time)
  OWNER TO dbaamamani;