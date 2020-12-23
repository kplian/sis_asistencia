CREATE OR REPLACE FUNCTION asis.f_estraer_palabra (
  p_cadena varchar,
  p_palabra varchar,
  p_palabra_ob varchar = NULL::character varying
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
   v_cadena								varchar[];
   v_resultado							varchar;
BEGIN
  	v_nombre_funcion = 'asis.f_estraer_palabra';

    if p_palabra_ob is null then
        v_cadena = regexp_matches(p_cadena, '('||p_palabra||')');
         if v_cadena is not null then
             v_resultado = v_cadena[1];
             return v_resultado;
         end if;
         v_resultado = p_cadena;
   	 end if;
    if p_palabra_ob is not null then
    	v_cadena = regexp_matches(p_cadena, '('||p_palabra||')');
         if v_cadena is not null then
             v_resultado = v_cadena[1];
             return v_resultado;
         end if;
         if v_cadena is null then
         	 v_cadena = regexp_matches(p_cadena, '('||p_palabra_ob||')');
                 if v_cadena is not null then
                    v_resultado = v_cadena[1];
                    return v_resultado;
                 end if;
         		v_resultado = p_cadena;
         end if;
    end if;
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

ALTER FUNCTION asis.f_estraer_palabra (p_cadena varchar, p_palabra varchar, p_palabra_ob varchar)
  OWNER TO dbaamamani;