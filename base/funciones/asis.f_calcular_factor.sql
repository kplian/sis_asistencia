CREATE OR REPLACE FUNCTION asis.f_calcular_factor (
  p_id_periodo integer
)
RETURNS void AS
$body$
DECLARE
 	v_resp                      varchar;
    v_nombre_funcion            text;
    v_insert 					record;

BEGIN

  for v_insert in (select me.id_funcionario, me.id_mes_trabajo
                  from asis.tmes_trabajo me
                  where me.id_periodo = p_id_periodo)loop

    PERFORM asis.f_porcentaje (
              v_insert.id_funcionario::integer,
              v_insert.id_mes_trabajo::integer,
              p_id_periodo::integer
		);

  end loop;


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

ALTER FUNCTION asis.f_calcular_factor (p_id_periodo integer)
  OWNER TO dbaamamani;