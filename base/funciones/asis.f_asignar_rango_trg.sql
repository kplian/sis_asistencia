CREATE OR REPLACE FUNCTION asis.f_asignar_rango_trg (
)
RETURNS trigger AS
$body$
DECLARE
  v_nombre_funcion 			varchar;
  v_registro_funcionario 	record;
  v_filtro					varchar;
  v_asigacion_funcionario 	boolean;
  v_asignado				boolean;
  v_dia						varchar;
  v_consulta				varchar;
  v_rango					record;
  v_hora					time;
  v_consulta_v2				varchar;
  v_rango_salida			record;

BEGIN
	v_nombre_funcion = 'asis.f_asignar_rango_trg';

      IF TG_OP = 'INSERT' THEN

      	if new.id_funcionario is not null then
        	v_hora = to_char(new.event_time,'HH24:MI');
        	v_asigacion_funcionario = false;
            v_asignado = false;

            ---obtenemos el rango al que se encuentra asignado
            select distinct on (uof.id_funcionario) uof.id_funcionario, ger.id_uo
                into
                v_registro_funcionario
            from orga.tuo_funcionario uof
            inner join orga.tuo ger on ger.id_uo = orga.f_get_uo_gerencia(uof.id_uo, NULL::integer, NULL::date)
            where uof.id_funcionario = new.id_funcionario and
            uof.fecha_asignacion <= new.event_time::date and
            (uof.fecha_finalizacion is null or uof.fecha_finalizacion >= new.event_time::date)
            order by uof.id_funcionario, uof.fecha_asignacion desc;



        	if exists ( select 1
                        from asis.tasignar_rango ar
                        where ar.id_funcionario = v_registro_funcionario.id_funcionario and
                        new.event_time::date between ar.desde and ar.hasta)then

                        v_filtro = 'ar.id_funcionario = '||v_registro_funcionario.id_funcionario;
                        v_asigacion_funcionario = true;
                        v_asignado = true;
        	end if;
            if not v_asigacion_funcionario then
                  if exists ( select 1
                              from asis.tasignar_rango ar
                              where ar.id_uo = v_registro_funcionario.id_uo and
                                    new.event_time::date >= ar.desde and
                                   (ar.hasta is null or new.event_time::date <= ar.hasta))then
                              v_filtro = 'ar.id_uo = '||v_registro_funcionario.id_uo;
                              v_asignado = true;
                   end if;
            end if;

            if v_asignado then
                v_dia =  case extract(dow from new.event_time::date)
                                            when 0 then
                                                'domingo'
                                            when 1 then
                                                'lunes'
                                            when 2 then
                                                'martes'
                                            when 3 then
                                                'miercoles'
                                            when 4 then
                                                'jueves'
                                            when 5 then
                                                'viernes'
                                            when 6 then
                                                'sabado'
                                            end;
                if asis.f_estraer_palabra(new.reader_name,'barrera') = 'barrera' then

                	 if (asis.f_estraer_palabra(new.reader_name,'Entrada','Salida') = 'Entrada')then

                  	 v_consulta := 'select  rh.id_rango_horario,
                                            rh.rango_entrada_ini,
                                            rh.rango_entrada_fin
                                        from asis.trango_horario rh
                                        inner join asis.tasignar_rango ar on ar.id_rango_horario = rh.id_rango_horario
                                        where  '||v_filtro||'
                                        and '''||v_hora||'''::time between rh.rango_entrada_ini::time and rh.rango_entrada_fin::time
                                        and  ('''||new.event_time||'''::date  between ar.desde and ar.hasta
                                        	or '''||new.event_time||'''::date >= ar.desde  and ar.hasta is null)
                                        and rh.'||v_dia||' = ''si''
                                        order by ar.hasta asc';

                      EXECUTE (v_consulta) into v_rango;
                         update asis.ttransacc_zkb_etl set
                                  id_rango_horario = v_rango.id_rango_horario,
                                  fecha = new.event_time::date,
                                  hora = v_hora,
                                  acceso = asis.f_estraer_palabra(new.reader_name,'Entrada','Salida'),
                                  obs = case
                                  			when  v_rango.id_rango_horario is null then
                                            'fuera de rango'
                                            else
                                            null
                                  	   end
                          where id = new.id;
                  end if;

                  if (asis.f_estraer_palabra(new.reader_name,'Entrada','Salida') = 'Salida')then

                       v_consulta := 'select  rh.id_rango_horario,
                                      rh.rango_salida_ini,
                                      rh.rango_salida_fin
                                  from asis.trango_horario rh
                                  inner join asis.tasignar_rango ar on ar.id_rango_horario = rh.id_rango_horario
                                  where  '||v_filtro||'
                                  and '''||v_hora||'''::time between rh.rango_salida_ini::time and rh.rango_salida_fin::time
                                   and  ('''||new.event_time||'''::date  between ar.desde and ar.hasta
                                        	or '''||new.event_time||'''::date >= ar.desde  and ar.hasta is null)
                                  and rh.'||v_dia||' = ''si''
                                  order by ar.hasta asc';

                         EXECUTE (v_consulta) into v_rango;

                          update asis.ttransacc_zkb_etl set
                                  id_rango_horario = v_rango.id_rango_horario,
                                  fecha = new.event_time::date,
                                  hora = v_hora,
                                  acceso = asis.f_estraer_palabra(new.reader_name,'Entrada','Salida'),
                                  obs = case
                                  			when  v_rango.id_rango_horario is null then
                                            'fuera de rango'
                                            else
                                            null
                                  	   end
                          where id = new.id;

                  end if;

                else
                	 v_consulta:= 'select  rh.id_rango_horario,
                                        rh.rango_entrada_ini,
                                        rh.rango_entrada_fin,
                                        rh.rango_salida_ini,
                                        rh.rango_salida_fin
                            from asis.trango_horario rh
                            inner join asis.tasignar_rango ar on ar.id_rango_horario = rh.id_rango_horario
                            where  '||v_filtro||'
                            and '''||v_hora||'''::time >= rh.rango_entrada_ini::time and  '''||v_hora||'''::time < rh.rango_entrada_fin::time
                             and  ('''||new.event_time||'''::date  between ar.desde and ar.hasta
                                        	or '''||new.event_time||'''::date >= ar.desde  and ar.hasta is null)
                     	    and rh.'||v_dia||' = ''si''
                            order by ar.hasta asc';

                            EXECUTE (v_consulta) into v_rango;

                             if v_rango.id_rango_horario is not null then
                                 update asis.ttransacc_zkb_etl set
                                    id_rango_horario =  v_rango.id_rango_horario,
                                    fecha = new.event_time::date,
                                    hora = v_hora,
                                    acceso = asis.f_estraer_palabra(new.reader_name,'Entrada','Salida'),
                                    obs = null
                                  where id = new.id;
                             end if;

                             if v_rango.id_rango_horario is null then
                         	  v_consulta_v2 := 'select  rh.id_rango_horario,
                                                      rh.rango_entrada_ini,
                                        			  rh.rango_entrada_fin,
                                                      rh.rango_salida_ini,
                                                      rh.rango_salida_fin
                                                  from asis.trango_horario rh
                                                  inner join asis.tasignar_rango ar on ar.id_rango_horario = rh.id_rango_horario
                                                  where  '||v_filtro||'
       											  and '''||v_hora||'''::time >= rh.rango_salida_ini::time and '''||v_hora||'''::time < rh.rango_salida_fin::time
                              				       and  ('''||new.event_time||'''::date  between ar.desde and ar.hasta
                                        	or '''||new.event_time||'''::date >= ar.desde  and ar.hasta is null)
                                                  and rh.'||v_dia||' = ''si''
                                                  order by ar.hasta asc';

                                         EXECUTE (v_consulta_v2) into v_rango_salida;

                                         if v_rango_salida.id_rango_horario is not null then

                                              update asis.ttransacc_zkb_etl set
                                                id_rango_horario =  v_rango.id_rango_horario,
                                                fecha = new.event_time::date,
                                                hora = v_hora,
                                                acceso = asis.f_estraer_palabra(new.reader_name,'Entrada','Salida'),
                                                obs = null
                                              where id = new.id;

                                         end if;
                           update asis.ttransacc_zkb_etl set
                                  id_rango_horario =  null,
                                  fecha = new.event_time::date,
                                  hora = v_hora,
                                  acceso = asis.f_estraer_palabra(new.reader_name,'Entrada','Salida'),
                                  obs = 'fuera de rango'
                           where id = new.id;
                         end if;
                end if;

            else
              update asis.ttransacc_zkb_etl set
                  id_rango_horario = null,
                  fecha = new.event_time::date,
                  hora = v_hora,
                  acceso =  asis.f_estraer_palabra(new.reader_name,'Entrada','Salida'),
                  obs = 'No tienes un rango asignado'
                  where id = new.id;

                   if v_registro_funcionario.id_uo is null then
                         update asis.ttransacc_zkb_etl set
                      id_rango_horario = null,
                      fecha = new.event_time::date,
                      hora = v_hora,
                      acceso =  asis.f_estraer_palabra(new.reader_name,'Entrada','Salida'),
                      obs = 'No tiene asignado una uo'
                      where id = new.id;

            		end if;
            end if;


        end if;

  END IF;
   RETURN NULL;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;

ALTER FUNCTION asis.f_asignar_rango_trg ()
  OWNER TO dbaamamani;