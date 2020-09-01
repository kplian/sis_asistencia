CREATE OR REPLACE FUNCTION asis.f_literal_periodo (
  p_periodo integer
)
RETURNS varchar AS
$body$
/**************************************************************************
 documento: 	param.f_literal_periodo
 DESCRIPCION:   Funcion que obtiene el literal de un id_periodo (mes)
 AUTOR: 	    MMV
 FECHA:	        11/12/2020
 COMENTARIOS:
***************************************************************************/
DECLARE
  v_fecha_ini DATE;
  v_fecha_fin Date;
  v_literal varchar;
  --save_tz text;
BEGIN

	--SHOW timezone into save_tz;



    IF p_periodo = 1 THEN
        v_literal := 'Enero';
    ELSIF p_periodo = 2 THEN
    	v_literal := 'Febrero';
    ELSIF p_periodo = 3 THEN
    	v_literal := 'Marzo';
    ELSIF p_periodo = 4 THEN
    	v_literal := 'Abril';
    ELSIF p_periodo = 5 THEN
    	v_literal := 'Mayo';
    ELSIF p_periodo = 6 THEN
    	v_literal := 'Junio';
	ELSIF p_periodo = 7 THEN
    	v_literal := 'Julio';
	ELSIF p_periodo = 8 THEN
    	v_literal := 'Agosto';
    ELSIF p_periodo = 9 THEN
    	v_literal := 'Septiembre';
    ELSIF p_periodo = 10 THEN
    	v_literal := 'Octubre';
    ELSIF p_periodo = 11 THEN
    	v_literal := 'Noviembre';
   ELSIF p_periodo = 12 THEN
    	v_literal := 'Diciembre';
   END IF;


   return v_literal;
END;
$body$
LANGUAGE 'plpgsql'
IMMUTABLE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;

ALTER FUNCTION asis.f_literal_periodo (p_periodo integer)
  OWNER TO dbaamamani;