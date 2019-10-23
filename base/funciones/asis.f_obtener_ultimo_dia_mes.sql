CREATE OR REPLACE FUNCTION asis.f_obtener_ultimo_dia_mes (
)
RETURNS date AS
$body$
DECLARE
    v_resp                      varchar;
    v_nombre_funcion            text;
    v_ultimo_dia_mes			date;
BEGIN
  select  extract(day from (extract(year from now()) || '-' ||
	extract(month from now()) + 1  || '-01')::date - '1 day'::interval) ||'/'||extract(month from now()::date)||'/'||extract(year from now()::date)
    into  v_ultimo_dia_mes;

    RETURN v_ultimo_dia_mes;

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

ALTER FUNCTION asis.f_obtener_ultimo_dia_mes ()
  OWNER TO dbaamamani;