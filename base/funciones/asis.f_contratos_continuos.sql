CREATE OR REPLACE FUNCTION asis.f_contratos_continuos (
  p_id_funcionario integer,
  p_diferencia integer
)
RETURNS date AS
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
   v_resultado 							date;
   v_actual_record						record;
   v_record								record;
   v_record_anterior					record;
   v_diferencia							integer;
BEGIN

  	v_nombre_funcion = 'asis.f_contratos_continuos';
    
    /*CREATE TEMP TABLE IF NOT EXISTS fechas_tmp (  id_funcionario INTEGER,
                                                       fecha_asignacion DATE,
                                                       fecha_finalizacion DATE )ON COMMIT DROP;*/
                                                       
                                                       
                                                       
    CREATE TEMPORARY TABLE IF NOT EXISTS fechas_tmp (  id_funcionario INTEGER,
        							   fecha_asignacion DATE,
                                       fecha_finalizacion DATE ) ON COMMIT DROP;


      
     v_diferencia = null;
     
     for v_record in (select  ca.id_funcionario,
                              ca.fecha_asignacion,
                              ca.fecha_finalizacion
                       from orga.vfuncionario_cargo ca 
                       where ca.id_funcionario = p_id_funcionario
                       		order by fecha_asignacion desc) loop
                            
                     --  raise notice '%',v_record.fecha_asignacion;
                       
                       insert into fechas_tmp (id_funcionario,
                                             fecha_asignacion,
                                             fecha_finalizacion
                                             )values(
                                             v_record.id_funcionario,
                                             v_record.fecha_asignacion,
                                             v_record.fecha_finalizacion
                                             );
                      -- raise notice ' fecha_asignacion --> %',v_record.fecha_asignacion;
                       
                       select f.id_funcionario, f.fecha_asignacion, f.fecha_finalizacion into v_record_anterior
                       from orga.vfuncionario_cargo f
                       where f.id_funcionario = v_record.id_funcionario
                       		 and f.fecha_asignacion not in (select t.fecha_asignacion
                             					        from fechas_tmp t
                                                        where t.id_funcionario = v_record.id_funcionario)
                             order by f.fecha_asignacion desc limit 1;
     	
     				--raise notice 'v_record_anterior % ',v_record_anterior.fecha_asignacion;
                    
                    
                   select extract(day from age(date(v_record.fecha_asignacion),
                                              date(v_record_anterior.fecha_finalizacion))) as dif_dias into v_diferencia;
				--	raise notice 'v_diferencia %',v_diferencia;
     				if v_diferencia != 1 or v_diferencia is null then
                   		v_resultado = v_record.fecha_asignacion;
                     return v_resultado;
                     
                     
                    end if;
     
     
     end loop;
                              
    -- DROP TABLE fechas_tmp;
    
   
	
     
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