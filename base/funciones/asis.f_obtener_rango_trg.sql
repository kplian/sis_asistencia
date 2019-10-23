CREATE OR REPLACE FUNCTION asis.f_obtener_rango_trg (
  p_pin varchar,
  p_hora time,
  p_fecha_marcado timestamp,
  p_lectora varchar
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
   v_id_funcionario						integer;
   v_id_uo								integer;
   v_consulta							varchar;
   v_consulta_v2						varchar;
   v_filtro								varchar;
   v_dia								varchar;
   v_rango								record;
   v_resultado							varchar[];
   v_asignacion							boolean;


BEGIN
  	v_nombre_funcion = 'asis.f_obtener_rango_trg';
    v_asignacion = false;

      --obtener el dia
      v_dia =  case extract(dow from p_fecha_marcado::date)
                    when 1 then 'lunes'
                    when 2 then 'martes'
                    when 3 then 'miercoles'
                    when 4 then 'jueves'
                    when 5 then 'viernes'
                    when 6 then 'sabado'
                    else 'no'
                    end;
      if v_dia = 'no' then
           v_resultado[1] = null;
           v_resultado[2] = 'Domingo';
           v_resultado[3] = 'Otro';
           v_resultado[4] = null;
           return v_resultado;
      end if;

    ---obtener el id _funcionario

    select distinct on (uofun.id_funcionario) uofun.id_funcionario,
                                              ger.id_uo
                                              into
                                              v_id_funcionario,
                                              v_id_uo
    from orga.tuo_funcionario uofun
    inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
    inner join orga.ttipo_contrato tc on car.id_tipo_contrato = tc.id_tipo_contrato
    inner join orga.tfuncionario fun on fun.id_funcionario = uofun.id_funcionario
    inner join segu.vpersona pe on pe.id_persona = fun.id_persona
    inner join orga.tuo ger on ger.id_uo = orga.f_get_uo_gerencia(uofun.id_uo, NULL::integer, NULL::date)
    where tc.codigo in ('PLA', 'EVE') and UOFUN.tipo = 'oficial' and uofun.fecha_asignacion <= p_fecha_marcado::date and
     (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >= p_fecha_marcado::date) and
     uofun.estado_reg != 'inactivo'  and trim(both 'FUNODTPR' from  fun.codigo) = p_pin
     order by uofun.id_funcionario, uofun.fecha_asignacion desc;


     if v_id_funcionario is not null then

     	--validacion por funcionario
         if exists ( select 1
                    from asis.tasignar_rango ar
                    where ar.id_funcionario = v_id_funcionario and
                          ar.desde >=  p_fecha_marcado::date and ar.hasta <= p_fecha_marcado::date)then
         	v_filtro = 'ar.id_funcionario ='||v_id_funcionario;
            v_asignacion = true;
         end if;

        --validar por uo
        if exists (select 1
                        from asis.tasignar_rango ar
                        where ar.id_uo = v_id_uo and
                             ar.desde <= p_fecha_marcado::date and
                             (ar.hasta is null or ar.hasta >= p_fecha_marcado::date))then
			v_filtro = 'ar.id_uo = '||v_id_uo;
            v_asignacion = true;
     	end if;

		if v_asignacion then

        	--lectura barrera podemos saber si es de el evento si es entrada o salida
            if asis.f_estraer_palabra(p_lectora,'barrera') = 'barrera' then

            	  --- puedo obtener si es entrada
                   if (asis.f_estraer_palabra(p_lectora,'Entrada','Salida') = 'Entrada')then
                   	 v_consulta := 'select rh.id_rango_horario,
                                  rh.codigo,
                                  rh.hora_entrada,
                                  rh.hora_salida,
                                  rh.tolerancia_retardo,
                                  rh.rango_entrada_ini,
                                  rh.rango_entrada_fin,
                                  rh.rango_salida_ini,
                                  rh.rango_salida_fin
                                from asis.trango_horario rh
                                inner join asis.tasignar_rango ar on ar.id_rango_horario = rh.id_rango_horario
                                where '||v_filtro||'
                                and '''||p_hora||'''::time between rh.rango_entrada_ini::time and rh.rango_entrada_fin::time
                                and rh.'||v_dia||' = ''si'' ';

                       ---ejecutamos la consulta
                       EXECUTE (v_consulta) into v_rango;
                         if v_rango.id_rango_horario is not null then
                                 v_resultado[1] = v_rango.id_rango_horario;
                                 v_resultado[2] = null;
                                 v_resultado[3] = 'Entrada';
                                 v_resultado[4] = v_id_funcionario;
                                 return v_resultado;
                          end if;
                          v_resultado[1] = null;
                          v_resultado[2] = 'fuera de rango de entrada';
                          v_resultado[3] = 'Entrada';
                          v_resultado[4] = v_id_funcionario;
                          return v_resultado;

                   end if;
                --- puedo obtener si es Salida
                  if (asis.f_estraer_palabra(p_lectora,'Entrada','Salida') = 'Salida')then
                  	  v_consulta := 'select rh.id_rango_horario,
                                  rh.codigo,
                                  rh.hora_entrada,
                                  rh.hora_salida,
                                  rh.tolerancia_retardo,
                                  rh.rango_entrada_ini,
                                  rh.rango_entrada_fin,
                                  rh.rango_salida_ini,
                                  rh.rango_salida_fin
                                from asis.trango_horario rh
                                inner join asis.tasignar_rango ar on ar.id_rango_horario = rh.id_rango_horario
                                where '||v_filtro||'
                                and '''||p_hora||'''::time between rh.rango_salida_ini::time and rh.rango_salida_fin::time
                                and rh.'||v_dia||' = ''si'' ';

                       ---ejecutamos la consulta
                       EXECUTE (v_consulta) into v_rango;
                         if v_rango.id_rango_horario is not null then
                                 v_resultado[1] = v_rango.id_rango_horario;
                                 v_resultado[2] = null;
                                 v_resultado[3] = 'Salida';
                                 v_resultado[4] = v_id_funcionario;
                                 return v_resultado;
                          end if;
                           v_resultado[1] = null;
                           v_resultado[2] = 'fuera de rango salida';
                           v_resultado[3] = 'Salida';
                           v_resultado[4] = v_id_funcionario;
                          return v_resultado;

                   end if;
            else
            	  --- aqui estoy asignado si  segun en que rango marca su entrada o salida
                --Entra
                 v_consulta:= 'select  rh.id_rango_horario,
                                        rh.rango_entrada_ini,
                                        rh.rango_entrada_fin
                            from asis.trango_horario rh
                            inner join asis.tasignar_rango ar on ar.id_rango_horario = rh.id_rango_horario
                            where ar.id_uo = '||v_id_uo||'
                            and '''||p_hora||'''::time >= rh.rango_entrada_ini::time and  '''||p_hora||'''::time < rh.rango_entrada_fin::time
                            and rh.'||v_dia||' = ''si'' ';

                 EXECUTE (v_consulta) into v_rango;

                 if v_rango.id_rango_horario is not null then
                 	   v_resultado[1] = v_rango.id_rango_horario;
                       v_resultado[2] = null;
                       v_resultado[3] = 'Entrada';
                       v_resultado[4] = v_id_funcionario;
                       return v_resultado;
                 end if;

                --Salida

                 if v_rango.id_rango_horario is  null then

                 v_consulta_v2:='select rh.id_rango_horario,
                 						rh.rango_salida_ini,
                                        rh.rango_salida_fin
                                        from asis.trango_horario rh
                                        inner join asis.tasignar_rango ar on ar.id_rango_horario = rh.id_rango_horario
                                        where ar.id_uo = '||v_id_uo||'
       										and '''||p_hora||'''::time >= rh.rango_salida_ini::time and '''||p_hora||'''::time < rh.rango_salida_fin::time
                                            and rh.'||v_dia||' = ''si'' ';

                 EXECUTE (v_consulta_v2) into v_rango;

                   if v_rango.id_rango_horario is not null then
                 	   v_resultado[1] = v_rango.id_rango_horario;
                       v_resultado[2] = null;
                       v_resultado[3] = 'Salida';
                       v_resultado[4] = v_id_funcionario;
                       return v_resultado;
                 	end if;

                 	   v_resultado[1] = null;
                       v_resultado[2] = null;
                       v_resultado[3] = 'Otro';
                       v_resultado[4] = v_id_funcionario;
                       return v_resultado;
                 end if;
            end if;
        else
          v_resultado[1] = null;
          v_resultado[2] = 'no tiene asignacion';
          v_resultado[3] = 'Otro';
          v_resultado[4] = v_id_funcionario;
           return v_resultado;
        end if;
     end if;
     v_resultado[1] = null;
     v_resultado[2] = 'no funcionario';
     v_resultado[3] = 'Otro';
     v_resultado[4] = null;
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
STABLE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;

ALTER FUNCTION asis.f_obtener_rango_trg (p_pin varchar, p_hora time, p_fecha_marcado timestamp, p_lectora varchar)
  OWNER TO dbaamamani;