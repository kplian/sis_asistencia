CREATE OR REPLACE FUNCTION asis.f_validar_centro_costo (
  p_id_id_mes_trabajo integer
)
RETURNS boolean AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.f_validar_centro_costo
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.tmes_trabajo_con'
 AUTOR: 		 (miguel.mamani)
 FECHA:	        13-03-2019 13:52:11
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #2				30/04/2019 				kplian MMV			Validaciones y reporte
 ***************************************************************************/
DECLARE
  	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
    v_record				record;
    v_tipo_contrato			varchar;
    v_id_funcionario		integer;
   	v_respuesta				boolean;
    v_ruleta				boolean;
    v_arreglo				varchar[];
    v_contrato				varchar;
    v_tcc					varchar;
BEGIN
  	v_nombre_funcion = 'asis.f_validar_centro_costo';
    v_respuesta = true;
    v_ruleta = true;

   	select me.id_funcionario
    into
    v_id_funcionario
    from asis.tmes_trabajo me
    where me.id_mes_trabajo = p_id_id_mes_trabajo;

    select tc.nombre
            into
            v_tipo_contrato
    from orga.vfuncionario_cargo fc
    inner join orga.tcargo c on c.id_cargo = fc.id_cargo
    inner join orga.ttipo_contrato tc on tc.id_tipo_contrato = c.id_tipo_contrato
    where fc.fecha_asignacion <= now()::date
		and (fc.fecha_finalizacion is null or fc.fecha_finalizacion >= now()::date)
        and fc.id_funcionario = v_id_funcionario;

    if v_tipo_contrato = 'Planta' then
    	v_contrato= 'sueldos_planta';
    elsif v_tipo_contrato = 'Obra determinada' then
    	v_contrato= 'sueldos_obradet';
    else
    	v_contrato= 'sueldos_obradet';
    end if;

    for v_record in ( select mes.id_centro_costo
                      from asis.tmes_trabajo_det mes
                      where mes.id_mes_trabajo = p_id_id_mes_trabajo)loop

        select tcc.autorizacion,tcc.codigo
        	into v_arreglo,v_tcc
        from param.ttipo_cc tcc
        where tcc.id_tipo_cc = v_record.id_centro_costo;

              if v_contrato = ANY (v_arreglo) then
                  v_ruleta = false;
              end if;

              if not v_ruleta then
                  raise exception 'Revice el centro de costo %',v_tcc;
                  v_respuesta = false;
              end if;

   	end loop;

    RETURN v_respuesta;
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