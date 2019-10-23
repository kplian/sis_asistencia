CREATE OR REPLACE FUNCTION asis.f_obtener_rango (
  p_id_funcionario integer,
  p_event_time timestamp,
  p_hora time,
  p_reader_name varchar
)
RETURNS varchar [] AS
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
   v_resultado							varchar[];
   v_dia								varchar;
   v_filtron							varchar;
   v_id_funcionario						integer;
   v_id_uo								integer;
   v_asignado							boolean;
   v_consulta							varchar;
   v_consulta_v2						varchar;
   v_filtro								varchar;
   v_rango								record;

BEGIN
  	v_nombre_funcion = 'asis.f_obtener_rango';

    --obtener el dia
    v_dia =  case extract(dow from p_event_time::date)
                  when 1 then 'lunes'
                  when 2 then 'martes'
                  when 3 then 'miercoles'
                  when 4 then 'jueves'
                  when 5 then 'viernes'
                  when 6 then 'sabado'
                  else 'no'
                  end;
    if v_dia = 'no' then
        raise exception 'No esta paramtrizado rango hrs';
    end if;

      --obtener datos de funcionario
      select distinct on (uof.id_funcionario) uof.id_funcionario,
                      ger.id_uo
                      into
                      v_id_funcionario,
                      v_id_uo
      from orga.tuo_funcionario uof
      inner join orga.tuo ger on ger.id_uo = orga.f_get_uo_gerencia(uof.id_uo, NULL::integer, NULL::date)
      where uof.id_funcionario = p_id_funcionario and
      uof.fecha_asignacion <= p_event_time::date and
      (uof.fecha_finalizacion is null or uof.fecha_finalizacion >= p_event_time::date)
      order by uof.id_funcionario, uof.fecha_asignacion desc;

      v_asignado = false;

      --validar si tiene una asignacion especial
      if exists ( select 1
                  from asis.tasignar_rango ar
                  where ar.id_funcionario = v_id_funcionario and
                        ar.desde >= p_event_time::date and ar.hasta <= p_event_time::date)then
                  v_filtro = 'ar.id_funcionario = '||v_id_funcionario;
      			  v_asignado = true;
      end if;

      --validar si tiene asignacion por ui
       if exists ( select 1
                  from asis.tasignar_rango ar
                  where ar.id_uo = v_id_uo and
                       ar.desde <= p_event_time::date and
                       (ar.hasta is null or ar.hasta >= p_event_time::date ))then
                  v_filtro = 'ar.id_uo = '||v_id_uo;
                  v_asignado = true;
       end if;

       --validar que tenga una asignacion de rango
       if v_asignado then

       		--aqui la barreras tiene entrad y salida
       		if asis.f_estraer_palabra(p_reader_name,'barrera') = 'barrera' then

                  --entrada
            	  if (asis.f_estraer_palabra(p_reader_name,'Entrada','Salida') = 'Entrada')then
                  	 v_consulta := 'select  rh.id_rango_horario,
                                            rh.rango_entrada_ini,
                                            rh.rango_entrada_fin
                                        from asis.trango_horario rh
                                        inner join asis.tasignar_rango ar on ar.id_rango_horario = rh.id_rango_horario
                                        where  '||v_filtro||'
                                        and '''||p_hora||'''::time between rh.rango_entrada_ini::time and rh.rango_entrada_fin::time
                                        and rh.'||v_dia||' = ''si'' ';
                      EXECUTE (v_consulta) into v_rango;
                         if v_rango.id_rango_horario is not null then
                           		 v_resultado[1] = v_rango.id_rango_horario;
                                 v_resultado[2] = null;
                                 v_resultado[3] = 'Entrada';
                                 return v_resultado;
                         end if;

                         v_resultado[1] = null;
                         v_resultado[2] = 'Fuera de Rango';
                         v_resultado[3] = 'Entrada';
                         return v_resultado;
                  end if;

                  --salida
                  if (asis.f_estraer_palabra(p_reader_name,'Entrada','Salida') = 'Salida')then
                       v_consulta := 'select  rh.id_rango_horario,
                                      rh.rango_salida_ini,
                                      rh.rango_salida_fin
                                  from asis.trango_horario rh
                                  inner join asis.tasignar_rango ar on ar.id_rango_horario = rh.id_rango_horario
                                  where  '||v_filtro||'
                                  and '''||p_hora||'''::time between rh.rango_salida_ini::time and rh.rango_salida_fin::time
                                  and rh.'||v_dia||' = ''si'' ';
                        EXECUTE (v_consulta) into v_rango;
                        if v_rango.id_rango_horario is not null then
                                 v_resultado[1] = v_rango.id_rango_horario;
                                 v_resultado[2] = null;
                                 v_resultado[3] = 'Salida';
                                 return v_resultado;
                         end if;

                         v_resultado[1] = null;
                         v_resultado[2] = 'Fuera de Rango';
                         v_resultado[3] = 'Salida';
                         return v_resultado;
                  end if;
            --aqui estoy asignado segun si cae en rango
            else
            --entrada
             v_consulta:= 'select  rh.id_rango_horario,
                                        rh.rango_entrada_ini,
                                        rh.rango_entrada_fin
                            from asis.trango_horario rh
                            inner join asis.tasignar_rango ar on ar.id_rango_horario = rh.id_rango_horario
                            where  '||v_filtro||'
                            and '''||p_hora||'''::time >= rh.rango_entrada_ini::time and  '''||p_hora||'''::time < rh.rango_entrada_fin::time
                            and rh.'||v_dia||' = ''si'' ';

               			EXECUTE (v_consulta) into v_rango;
                        if v_rango.id_rango_horario is not null then
                                 v_resultado[1] = v_rango.id_rango_horario;
                                 v_resultado[2] = null;
                                 v_resultado[3] = 'Salida';
                                 return v_resultado;
                         end if;
                         --salida
                         if v_rango.id_rango_horario is null then
                         	v_consulta_v2 := 'select  rh.id_rango_horario,
                                                      rh.rango_salida_ini,
                                                      rh.rango_salida_fin
                                                  from asis.trango_horario rh
                                                  inner join asis.tasignar_rango ar on ar.id_rango_horario = rh.id_rango_horario
                                                  where  '||v_filtro||'
       											  and '''||p_hora||'''::time >= rh.rango_salida_ini::time and '''||p_hora||'''::time < rh.rango_salida_fin::time
                                                  and rh.'||v_dia||' = ''si'' ';

                                         EXECUTE (v_consulta_v2) into v_rango;
                                         if v_rango.id_rango_horario is not null then
                                           v_resultado[1] = v_rango.id_rango_horario;
                                           v_resultado[2] = null;
                                           v_resultado[3] = 'Salida';
                                           return v_resultado;
                                         end if;
                             v_resultado[1] = null;
                             v_resultado[2] = null;
                             v_resultado[3] = 'Otro';
                             return v_resultado;
                         end if;


       		end if;

       else
         v_resultado[1] = null;
         v_resultado[2] = 'no tiene asignado un rango';
         v_resultado[3] = 'Otro';
         return v_resultado;
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
COST 100;

ALTER FUNCTION asis.f_obtener_rango (p_id_funcionario integer, p_event_time timestamp, p_hora time, p_reader_name varchar)
  OWNER TO dbaamamani;