CREATE OR REPLACE FUNCTION asis.f_validar_hora (
  p_hora integer
)
RETURNS boolean AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.f_validar_hora
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.f_centro_validar'
 AUTOR: 		 MMV Kplian
 FECHA:	         2019-00-03
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 ***************************************************************************/
DECLARE
   v_resp                      			varchar;
   v_nombre_funcion            			text;
   v_resultado							boolean;

BEGIN
  	v_nombre_funcion = 'asis.f_validar_hora';
    IF (p_hora < 0) Or (p_hora > 23)  THEN
    	v_resultado = false;
    ELSE
    	v_resultado = true;
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

ALTER FUNCTION asis.f_validar_hora (p_hora integer)
  OWNER TO dbaamamani;