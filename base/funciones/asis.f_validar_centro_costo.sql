CREATE OR REPLACE FUNCTION asis.f_validar_centro_costo (
  p_id_id_mes_trabajo integer,
  p_id_periodo integer,
  p_id_centro_costo integer
)
RETURNS varchar AS
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
 #5				30/04/2019 				kplian MMV			Validaciones y reporte
 #10 ETR		16/07/2019				MMV					Validar fecha des contrato finalizados y listado uo
 #29	ERT			25/9/2020 				 MMV			Validar rango horas hoja de tiempo

 ***************************************************************************/
DECLARE
  	v_resp		            varchar;
	v_nombre_funcion        text;
    v_fecha_ini				date;
    v_fecha_fin				date;
    v_id_funcionario		integer;
    v_tipo_contrato			varchar;
    v_id_funcionario_tp		integer;
    v_autorizado			varchar[];
    v_contrato				varchar;
    v_respuesta				boolean;
    v_autorizado_cont		integer;
    v_mensaje 				varchar;

BEGIN
  	v_nombre_funcion = 'asis.f_validar_centro_costo'; --#10

    v_respuesta = false;
    v_mensaje = '';
    select p.fecha_ini, p.fecha_fin into v_fecha_ini, v_fecha_fin
    from param.tperiodo p
    where p.id_periodo = p_id_periodo;

    select me.id_funcionario into v_id_funcionario
    from asis.tmes_trabajo me
    where me.id_mes_trabajo = p_id_id_mes_trabajo;

    select distinct on (ca.id_funcionario) ca.id_funcionario,
       tc.nombre as tipo_contrato
       into
       v_id_funcionario_tp,
       v_tipo_contrato
    from orga.vfuncionario_cargo ca
    inner join orga.tcargo c on c.id_cargo = ca.id_cargo
    inner join orga.ttipo_contrato tc on tc.id_tipo_contrato = c.id_tipo_contrato
    where ca.fecha_asignacion <= v_fecha_fin
    and (ca.fecha_finalizacion is null or ca.fecha_finalizacion >= v_fecha_ini)
    and ca.id_funcionario = v_id_funcionario
    order by ca.id_funcionario, ca.fecha_asignacion desc;

    if v_tipo_contrato = 'Planta' then
    	v_contrato = 'sueldos_planta';
    elsif v_tipo_contrato = 'Obra determinada' then
    	v_contrato = 'sueldos_obradet';
 	elsif v_tipo_contrato = 'Consultor' then
    	v_contrato = 'sueldos_obradet';
    end if;

    ---Validar que este autorizado
    select array_length(tcc.autorizacion,1) into v_autorizado_cont
    from param.tcentro_costo cec
    inner join param.ttipo_cc tcc on tcc.id_tipo_cc = cec.id_tipo_cc
    where cec.id_centro_costo = p_id_centro_costo;
    if v_autorizado_cont is null then
    	v_mensaje = ' -> el tipo de centro de costo asociado no esta autorizado,'; -- #29
    	return  v_mensaje;
    end if;

    ---validar que este autorizado segun contrato
    if v_autorizado_cont is not null then

     	select tcc.autorizacion into v_autorizado
    	from param.tcentro_costo cec
    	inner join param.ttipo_cc tcc on tcc.id_tipo_cc = cec.id_tipo_cc
    	where cec.id_centro_costo = p_id_centro_costo;

        if v_contrato = ANY (v_autorizado) then
            v_mensaje = '';
            RETURN v_mensaje;
        else
            v_mensaje =' -> no tiene relacion con tipo de contrato autorización';
            RETURN v_mensaje;
        end if;
    end if;




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

ALTER FUNCTION asis.f_validar_centro_costo (p_id_id_mes_trabajo integer, p_id_periodo integer, p_id_centro_costo integer)
  OWNER TO postgres;