CREATE OR REPLACE FUNCTION asis.f_depurar_movimiento (
  p_fecha date,
  p_asignar boolean = false
)
RETURNS void AS
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
   v_record_funcionario					record;
   v_funcionario_plan					record;
   v_funcionario_odt					record;
   v_fecha_anterior						date;
   v_diferencia							integer;
   v_asignacion_anterior				date;
   v_viaje								date;
   
   v_record_id							record;
BEGIN

	if (p_asignar) then
    
    	for v_record_funcionario in (select pe.id_funcionario,
                                           pe.ci	
                                    from orga.vfuncionario_persona pe)loop
                                    
                if exists (select 1
                		     from asis.tmovimiento_vacacion mo
                             where mo.ci = v_record_funcionario.ci
                             		and mo.id_funcionario is null )then
                                               
        		update asis.tmovimiento_vacacion set
                id_funcionario = v_record_funcionario.id_funcionario
                where ci = v_record_funcionario.ci;
                
                
                else 
                
                	raise notice 'No existe %',v_record_funcionario.ci;
                
                end if;
        end loop;
    
    end if;
    
    for v_funcionario_plan in (select distinct on (ca.id_funcionario) ca.id_funcionario,
                              ca.desc_funcionario1,
                              trim(both 'FUNODTPR' from ca.codigo) as codigo,
                              ca.nombre_cargo,
                              ca.fecha_asignacion
                              from orga.vfuncionario_cargo ca
                              inner join orga.tcargo car on car.id_cargo = ca.id_cargo
                              inner join orga.ttipo_contrato tc on car.id_tipo_contrato = tc.id_tipo_contrato
                              where tc.codigo in ('PLA') --and  ca.id_funcionario = 702
                              and ca.fecha_asignacion <= p_fecha and (ca.fecha_finalizacion is null or ca.fecha_finalizacion >= p_fecha)
                              order by ca.id_funcionario, ca.fecha_asignacion desc) loop
                              
                              
    		if exists (select 1
                        from asis.tmovimiento_vacacion mv
                        where mv.id_funcionario = v_funcionario_plan.id_funcionario
                              and mv.tipo_contrato = 'planta')then
                              
            
            
            
            	if exists (select 1
                        from asis.tmovimiento_vacacion mv
                        where mv.id_funcionario = v_funcionario_plan.id_funcionario
                              and mv.tipo_contrato = 'obra_det')then
                                                
                    select co.fecha_finalizacion into v_fecha_anterior
                    from orga.vfuncionario_cargo co
                    where co.id_funcionario = v_funcionario_plan.id_funcionario 
                          and co.fecha_asignacion != v_funcionario_plan.fecha_asignacion
                          order by co.fecha_asignacion desc limit 1;
                                

                      
                      SELECT EXTRACT(DAY FROM age(date(v_funcionario_plan.fecha_asignacion) ,date(v_fecha_anterior) ) ) as dif_dias into v_diferencia;
                      
                      if (v_diferencia = 1) then
                      
                          update asis.tmovimiento_vacacion set
                          estado_reg = 'activo'
                          where id_funcionario = v_funcionario_plan.id_funcionario 
                    	  and tipo_contrato = 'planta';
                      
                      else
                      
                      	update asis.tmovimiento_vacacion set
                          estado_reg = 'activo'
                          where id_funcionario = v_funcionario_plan.id_funcionario 
                    	  and tipo_contrato = 'planta'
                          and fecha_reg::date >= v_funcionario_plan.fecha_asignacion;
                          
                      end if;
                      
                      
                      else
                      
                      
                      
                      
                      if exists (select 1
                        from asis.tmovimiento_vacacion mv
                        where mv.id_funcionario = v_funcionario_plan.id_funcionario
                              and mv.tipo_contrato = 'planta'
                              and mv.fecha_reg::date >= v_funcionario_plan.fecha_asignacion )then
                              
                        	  update asis.tmovimiento_vacacion set
                          estado_reg = 'activo'
                          where id_funcionario = v_funcionario_plan.id_funcionario 
                    	  and tipo_contrato = 'planta';
                          
                          else
                    
                    	SELECT EXTRACT(DAY FROM age(date(v_funcionario_plan.fecha_asignacion) ,date(v_fecha_anterior) ) ) as dif_dias into v_diferencia;
                      
                        if (v_diferencia = 1) then
                        
                            update asis.tmovimiento_vacacion set
                            estado_reg = 'activo'
                            where id_funcionario = v_funcionario_plan.id_funcionario 
                            and tipo_contrato = 'planta';
                        else
                        
                         update asis.tmovimiento_vacacion set
                          estado_reg = 'activo'
                          where id_funcionario = v_funcionario_plan.id_funcionario 
                    	  and tipo_contrato = 'planta'
                          and  fecha_reg::date >= v_funcionario_plan.fecha_asignacion;
                          
                        end if;
                                            
                         
               			
                        end if;
            	 end if;
                 
                 
                 
            
            end if;
            
            
      
    end loop;



 	for v_funcionario_odt in (select distinct on (ca.id_funcionario) ca.id_funcionario,
                              ca.desc_funcionario1,
                              trim(both 'FUNODTPR' from ca.codigo) as codigo,
                              ca.nombre_cargo,
                              ca.fecha_asignacion
                              from orga.vfuncionario_cargo ca
                              inner join orga.tcargo car on car.id_cargo = ca.id_cargo
                              inner join orga.ttipo_contrato tc on car.id_tipo_contrato = tc.id_tipo_contrato
                              where tc.codigo in ('EVE')   --and  ca.id_funcionario = 702
                              and ca.fecha_asignacion <= p_fecha and (ca.fecha_finalizacion is null or ca.fecha_finalizacion >= p_fecha)
                              order by ca.id_funcionario, ca.fecha_asignacion desc) loop
                              
                              
    		if exists (select 1
                        from asis.tmovimiento_vacacion mv
                        where mv.id_funcionario = v_funcionario_odt.id_funcionario
                              and mv.tipo_contrato = 'obra_det')then
                              
                              
            		 select co.fecha_finalizacion, co.fecha_asignacion into v_fecha_anterior,v_asignacion_anterior
                    from orga.vfuncionario_cargo co
                    where co.id_funcionario = v_funcionario_odt.id_funcionario 
                          and co.fecha_asignacion != v_funcionario_odt.fecha_asignacion
                          order by co.fecha_asignacion desc limit 1;
                    
                    
                     --raise notice 'fecha_asignacion %  v_fecha_anterior %',v_funcionario_odt.fecha_asignacion,v_fecha_anterior;

                      
                      SELECT EXTRACT(DAY FROM age(date(v_funcionario_odt.fecha_asignacion) ,date(v_fecha_anterior) ) ) as dif_dias into v_diferencia;
                      -- raise notice 'direr %',v_diferencia;
                       
                       
                      if (v_diferencia = 1) then
                     
                      
                     	 v_viaje = asis.f_contratos_continuos (v_funcionario_odt.id_funcionario,1);
                    
                       update asis.tmovimiento_vacacion set
                        estado_reg = 'activo'
                        where id_funcionario =  v_funcionario_odt.id_funcionario
                            and tipo_contrato = 'obra_det'
                            and fecha_reg::date >= v_viaje; -- v_asignacion_anterior ;
                      
                             
                     
                      
                      
                      end if;
                      
            
            		update asis.tmovimiento_vacacion set
                    estado_reg = 'activo'
                    where id_funcionario = v_funcionario_odt.id_funcionario 
                    	and tipo_contrato = 'obra_det'
                        and fecha_reg::date >= v_funcionario_odt.fecha_asignacion;
            
            end if;
            
            
      
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
PARALLEL UNSAFE
COST 100;
