CREATE OR REPLACE FUNCTION asis.f_obtener_rango_asignado_fun (
  p_id_funcionario integer,
  p_fecha date
)
RETURNS varchar AS
$body$
DECLARE
    v_resp                      	varchar;
    v_nombre_funcion            	text;
    v_filtro						varchar;
    v_registro_funcionario			record;
    v_asignar_funcionario			boolean;
    v_asignar_grupo					boolean;
    
    
BEGIN
	v_filtro = null;
    
     ---obtenemos el rango al que se encuentra asignado
     
       select distinct on (uof.id_funcionario) uof.id_funcionario, 
            	ger.id_uo
            into
            v_registro_funcionario
        from orga.tuo_funcionario uof
        inner join orga.tuo ger on ger.id_uo = orga.f_get_uo_gerencia(uof.id_uo, NULL::integer, NULL::date)
        where uof.id_funcionario = p_id_funcionario and
        uof.fecha_asignacion <= p_fecha and
        (uof.fecha_finalizacion is null or uof.fecha_finalizacion >= p_fecha)
        order by uof.id_funcionario, uof.fecha_asignacion desc;
     
     --si es espericial el chango
       v_asignar_funcionario = false;
       
       if exists ( select 1
                   from asis.tasignar_rango ar
                   where ar.id_funcionario = p_id_funcionario and
                   p_fecha between ar.desde and ar.hasta)then
                   
                   v_asignar_funcionario = true;
                   v_filtro = 'ar.id_funcionario ='||p_id_funcionario;
     
       end if;
       
       v_asignar_grupo = false;
       
       if (v_asignar_funcionario = false and v_asignar_grupo = false)then
       		  if exists ( select 1
                          from asis.tasignar_rango ar
                          where ar.id_uo = v_registro_funcionario.id_uo and
                          p_fecha >= ar.desde and (ar.hasta is null or p_fecha<= ar.hasta))then
                          
                          v_filtro = 'ar.id_uo = '||v_registro_funcionario.id_uo;      
                          
               end if;
       end if;
    
    RETURN v_filtro;

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

ALTER FUNCTION asis.f_obtener_rango_asignado_fun (p_id_funcionario integer, p_fecha date)
  OWNER TO dbaamamani;