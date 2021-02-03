CREATE OR REPLACE FUNCTION asis.f_obtener_secretaria (
  p_id_funcionario integer
)
RETURNS varchar [] AS
$body$
DECLARE
    v_nombre_funcion 				text;
    v_resp							varchar;
    v_resp_final					varchar[];
    v_recorrer						record;

BEGIN
  	 v_nombre_funcion:='asis.f_obtener_secretaria';

	 v_resp_final = null;
     
     with secretaria as ( select distinct on (ca.id_funcionario) ca.id_funcionario,
                ca.desc_funcionario1 as funcioanrio,
                ca.nombre_cargo,
                ger.id_uo,
                ger.nombre_unidad as gerencia
                from orga.vfuncionario_cargo ca
                inner join orga.tcargo car on car.id_cargo = ca.id_cargo
                inner join orga.tuo ger on ger.id_uo = orga.f_get_uo_gerencia(ca.id_uo, NULL::integer, NULL::date)
                where ca.id_funcionario = p_id_funcionario
                and ca.fecha_asignacion <= now()::date and (ca.fecha_finalizacion is null or ca.fecha_finalizacion >= now()::date)
                order by ca.id_funcionario, ca.fecha_asignacion desc
                ) select fg.id_funcionario,
                          initcap(fg.desc_funcionario2) as funcionario, 
                         trim(both 'FUNODTPR' from fg.codigo) as codigo,
                         u.nombre_unidad into v_recorrer
                from orga.testructura_uo es
                inner join orga.tuo u on u.id_uo = es.id_uo_hijo
                inner join orga.tnivel_organizacional n on n.id_nivel_organizacional = u.id_nivel_organizacional
                inner join secretaria s on s.id_uo = es.id_uo_padre 
                inner join orga.vfuncionario_cargo fg on fg.id_uo = u.id_uo 
                and fg.fecha_asignacion <= now()::date 
                and (fg.fecha_finalizacion is null or fg.fecha_finalizacion >= now()::date)
                where n.numero_nivel = 9;
      
     v_resp_final = array_append(v_resp_final, v_recorrer.id_funcionario::varchar);
	 v_resp_final = array_append(v_resp_final, v_recorrer.funcionario::varchar);
     v_resp_final = array_append(v_resp_final, v_recorrer.codigo::varchar); 
     
     return v_resp_final;


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
PARALLEL UNSAFE
COST 100;