CREATE OR REPLACE FUNCTION asis.f_get_funcionario_boss (
  par_id_funcionario integer,
  par_total_horas_extras numeric
)
RETURNS integer AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.f_get_funcionario_boss
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.tmes_trabajo_con'
 AUTOR: 		 (miguel.mamani)
 FECHA:	        13-03-2019 13:52:11
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #5				30/04/2019 				kplian MMV			Validaciones y reporte
 ***************************************************************************/

DECLARE
  	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
    v_record				record;
    v_id_funcionario		integer;
   	v_nivel					integer;
BEGIN
  	v_nombre_funcion = 'asis.f_get_funcionario_boss';

    for v_record  in ( with recursive funcionario_apro(   id_funcionario,
                                                          id_uo,
                                                          presupuesta,
                                                          gerencia,
                                                          numero_nivel,nombre_nivel) AS (
                                select 	uofun.id_funcionario,
                                          uo.id_uo,
                                          uo.presupuesta,
                                          uo.gerencia,
                                          no.numero_nivel,
                                          no.nombre_nivel
                                  from orga.tuo_funcionario uofun
                                  inner join orga.tuo uo on uo.id_uo = uofun.id_uo
                                  inner join orga.tnivel_organizacional no on no.id_nivel_organizacional = uo.id_nivel_organizacional
                                  where uofun.fecha_asignacion <= now()::date and
                                  (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >= now()::date)
                                  and uofun.estado_reg = 'activo' and uofun.id_funcionario = par_id_funcionario
                              union
                               select uofun.id_funcionario,
                                      euo.id_uo_padre,
                                      uo.presupuesta,
                                      uo.gerencia,
                                      no.numero_nivel,
                                      no.nombre_nivel
                                  from orga.testructura_uo euo
                                  inner join orga.tuo uo on uo.id_uo = euo.id_uo_padre
                                  inner join orga.tnivel_organizacional no on no.id_nivel_organizacional = uo.id_nivel_organizacional
                                  inner join funcionario_apro hijo on hijo.id_uo = euo.id_uo_hijo
                                  left join orga.tuo_funcionario uofun on uo.id_uo = uofun.id_uo and uofun.estado_reg = 'activo'
                                  and uofun.fecha_asignacion <= now()::date
                                  and (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >= now()::date))
                                  select 	f.id_funcionario,
                                          f.numero_nivel
                                  from funcionario_apro f
                                  where f.numero_nivel <= 6 and f.numero_nivel != 0
                                  order by numero_nivel  desc limit 1)loop

                              if v_record.id_funcionario is not null and v_record.numero_nivel = 2 then
                              	v_id_funcionario = v_record.id_funcionario;
                              elsif v_record.id_funcionario is not null and v_record.numero_nivel = 4 then
                              	v_id_funcionario = v_record.id_funcionario;
							  elsif v_record.id_funcionario is not null and v_record.numero_nivel = 5 then
                              	v_id_funcionario = v_record.id_funcionario;
                              elsif v_record.id_funcionario is not null and v_record.numero_nivel = 6 then
                              	v_id_funcionario = v_record.id_funcionario;
                              end if;


    end loop;
    /* with recursive funcionario_apro(   id_funcionario,
                                    id_uo,
                                    presupuesta,
                                    gerencia,
                                    numero_nivel,nombre_nivel) AS (
                                select 	uofun.id_funcionario,
                                          uo.id_uo,
                                          uo.presupuesta,
                                          uo.gerencia,
                                          no.numero_nivel,
                                          no.nombre_nivel
                                  from orga.tuo_funcionario uofun
                                  inner join orga.tuo uo on uo.id_uo = uofun.id_uo
                                  inner join orga.tnivel_organizacional no on no.id_nivel_organizacional = uo.id_nivel_organizacional
                                  where uofun.fecha_asignacion <= now()::date and
                                  (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >= now()::date)
                                  and uofun.estado_reg = 'activo' and uofun.id_funcionario = par_id_funcionario
                              union
                               select uofun.id_funcionario,
                                      euo.id_uo_padre,
                                      uo.presupuesta,
                                      uo.gerencia,
                                      no.numero_nivel,
                                      no.nombre_nivel
                                  from orga.testructura_uo euo
                                  inner join orga.tuo uo on uo.id_uo = euo.id_uo_padre
                                  inner join orga.tnivel_organizacional no on no.id_nivel_organizacional = uo.id_nivel_organizacional
                                  inner join funcionario_apro hijo on hijo.id_uo = euo.id_uo_hijo
                                  left join orga.tuo_funcionario uofun on uo.id_uo = uofun.id_uo and uofun.estado_reg = 'activo'
                                  and uofun.fecha_asignacion <= now()::date
                                  and (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >= now()::date))
                                  select  f.id_funcionario,max(f.numero_nivel)
                                  into v_id_funcionario,v_nivel
                                  from funcionario_apro f
                                  where f.id_funcionario is not null  and  f.numero_nivel <= 6
                                  group by f.id_funcionario limit 1;*/
RETURN v_id_funcionario;

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