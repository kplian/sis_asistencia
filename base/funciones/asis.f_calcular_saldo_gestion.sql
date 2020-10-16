CREATE OR REPLACE FUNCTION asis.f_calcular_saldo_gestion (
  p_gestion integer,
  p_record record,
  p_tomado numeric
)
RETURNS boolean AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.f_asignar_pro
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
   v_resp                       varchar;
   v_nombre_funcion             text;
   v_resultado					boolean = false;
   v_gestion					integer;
   v_acumulado					numeric;
   v_operacion 					numeric;
   v_tranca						boolean;
   
BEGIN
  	v_nombre_funcion = 'asis.f_calcular_saldo_gestion';
    
	v_gestion = p_gestion;

    v_acumulado = p_record.dias_acumulados::numeric;
    
    v_operacion = round(p_tomado - v_acumulado, 2  );
    
    v_tranca = false;
    
    insert into temporal_saldo (id_funcionario,
                                codigo,
                                desc_funcionario1,
                                fecha_contrato,
                                gerencia,
                                departamento,
                                gestion,
                                saldo
                                )values(
                                p_record.id_funcionario,
                                p_record.codigo,
                                p_record.desc_funcionario2, 
                                p_record.fecha_contrato,
                                p_record.gerencia, 
                                p_record.departamento,
                                v_gestion,
                                v_acumulado
                                ); 
                                
    if (v_operacion > v_acumulado) then
    	v_tranca = true;
    end if;
    
    if(v_tranca) then
    
    
    PERFORM asis.f_calcular_saldo_gestion(p_gestion - 1 ,p_record,v_operacion);
    else
    
      --      raise exception '-->%',v_operacion;

    insert into temporal_saldo (id_funcionario,
                                codigo,
                                desc_funcionario1,
                                fecha_contrato,
                                gerencia,
                                departamento,
                                gestion,
                                saldo
                                )values(
                                p_record.id_funcionario,
                                p_record.codigo,
                                p_record.desc_funcionario2, 
                                p_record.fecha_contrato,
                                p_record.gerencia, 
                                p_record.departamento,
                                p_gestion -1 ,
                                v_operacion
                                ); 
    
    	v_resultado = true;
    
    end if;
    
 
    return v_resultado;
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
LEAKPROOF
PARALLEL UNSAFE
COST 100;

ALTER FUNCTION asis.f_calcular_saldo_gestion (p_gestion integer, p_record record, p_tomado numeric)
  OWNER TO dbaamamani;