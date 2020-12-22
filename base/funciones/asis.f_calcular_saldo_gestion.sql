CREATE OR REPLACE FUNCTION asis.f_calcular_saldo_gestion (
  p_fecha_reg date,
  p_dias_acumulado numeric,
  p_record record,
  p_saldo numeric
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
   v_record_acumnulado			record;
   v_fecha						date;
   v_fechas_arreglo				date[];
   v_acumular_mr				numeric;
BEGIN
  	v_nombre_funcion = 'asis.f_calcular_saldo_gestion';
    
   
    
	v_gestion = extract(year from p_fecha_reg);
    
	v_fecha = p_fecha_reg;
    
    
    v_acumulado = p_dias_acumulado;
    
    v_operacion = round(p_saldo - v_acumulado,2);
    
    v_tranca = false;
    
     
    insert into temporal_saldo (id_funcionario,
                                codigo,
                                desc_funcionario1,
                                fecha_contrato,
                                gerencia,
                                departamento,
                                gestion,
                                fecha_acomulado,
                                saldo
                                )values(
                                p_record.id_funcionario,
                                p_record.codigo,
                                p_record.desc_funcionario2, 
                                p_record.fecha_contrato,
                                p_record.gerencia, 
                                p_record.departamento,
                                v_gestion,
                                v_fecha,
                                v_acumulado
                                );
                              
    
     select  mo.dias into v_acumular_mr
     from asis.tmovimiento_vacacion mo
     where mo.tipo = 'ACUMULADA'
      and mo.id_funcionario = p_record.id_funcionario
      and mo.estado_reg = 'activo' 
      and  mo.fecha_reg::date = ( select max(m.fecha_reg::date)
                                  from asis.tmovimiento_vacacion m
                                  where m.tipo = 'ACUMULADA' 
                                  		and m.id_funcionario = p_record.id_funcionario
                                        and m.dias != 0
                                        and m.fecha_reg not in (select ts.fecha_acomulado
                                                                from temporal_saldo ts 
                                                                where ts.id_funcionario = p_record.id_funcionario));
   
    
    if (v_operacion > v_acumular_mr) then
    	v_tranca = true;
    end if;
  
    if(v_tranca) then
    
   
    
     select mo.fecha_reg::date as fecha_reg,
            	   mo.dias
                   into
                   v_record_acumnulado
            from asis.tmovimiento_vacacion mo
            where mo.tipo = 'ACUMULADA' and  mo.id_funcionario = p_record.id_funcionario
                    and mo.id_funcionario = p_record.id_funcionario
                    and mo.estado_reg = 'activo' 
                    and  mo.fecha_reg::date = ( select max(m.fecha_reg::date)
                                                from asis.tmovimiento_vacacion m
                                                where m.tipo = 'ACUMULADA' 
                                                      and m.id_funcionario = p_record.id_funcionario
                                                      and m.dias != 0
                                                      and m.fecha_reg not in (select ts.fecha_acomulado
                                                                              from temporal_saldo ts 
                                                                              where ts.id_funcionario = p_record.id_funcionario));
                     
 
    
      PERFORM asis.f_calcular_saldo_gestion(  v_record_acumnulado.fecha_reg,
                                                  v_record_acumnulado.dias,
                                                  p_record,
                                                  v_operacion);
     -- 
    else
     insert into temporal_saldo (id_funcionario,
                                codigo,
                                desc_funcionario1,
                                fecha_contrato,
                                gerencia,
                                departamento,
                                gestion,
                                fecha_acomulado,
                                saldo
                                )values(
                                p_record.id_funcionario,
                                p_record.codigo,
                                p_record.desc_funcionario2, 
                                p_record.fecha_contrato,
                                p_record.gerencia, 
                                p_record.departamento,
                                v_gestion - 1,
                                v_fecha,
                                v_operacion
                                ); 
    
    	v_resultado = true;
    
    end if;     
    
   /*
    
    if(v_tranca) then
    
            select mo.fecha_reg::date as fecha_reg,
            	   mo.dias
                   into
                   v_record_acumnulado
            from asis.tmovimiento_vacacion mo
            where mo.tipo = 'ACUMULADA' and  mo.id_funcionario = p_record.id_funcionario
            	  and mo.estado_reg = 'activo' and  mo.fecha_reg::date = (  select max(m.fecha_reg::date)
                                                                            from asis.tmovimiento_vacacion m
                                                                            where m.tipo = 'ACUMULADA' and
                                                                                 m.id_funcionario =  p_record.id_funcionario
                                                                                 and m.fecha_reg != v_fecha);
                                                                                 
        
    PERFORM asis.f_calcular_saldo_gestion(  v_record_acumnulado.fecha_reg,
      										v_record_acumnulado.dias,
                                            p_record,
                                            v_operacion);
    
    else
    
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
                                v_gestion ,
                                v_operacion
                                ); 
    
    	v_resultado = true;
    
    end if;*/
    
 
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
