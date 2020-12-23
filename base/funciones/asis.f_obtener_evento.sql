CREATE OR REPLACE FUNCTION asis.f_obtener_evento (
  p_dia varchar,
  p_hora time,
  p_id_uo integer,
  p_id_funcionario integer = NULL::integer
)
RETURNS varchar [] AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.f_obtener_evento
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
   v_consulta							varchar;
   v_consulta_v2							varchar;
   v_rango								record;
   v_rango_v2								record;
   v_resultado							varchar[];

BEGIN
  	v_nombre_funcion = 'asis.f_obtener_evento';

   	   v_consulta := 'select  rh.id_rango_horario,
                              rh.rango_entrada_ini,
                              rh.rango_entrada_fin
                            from asis.trango_horario rh
                            inner join asis.tasignar_rango ar on ar.id_rango_horario = rh.id_rango_horario
                            where ar.id_uo = '||p_id_uo||'
                            and '''||p_hora||'''::time between rh.rango_entrada_ini::time and rh.rango_entrada_fin::time
                            and rh.'||p_dia||' = ''si'' ';

       EXECUTE (v_consulta) into v_rango;

       if (p_hora >= v_rango.rango_entrada_ini and p_hora < v_rango.rango_entrada_fin) then
             v_resultado[1] = v_rango.id_rango_horario;
             v_resultado[2] = 'normal';
             v_resultado[3] = 'Entrada';
             return v_resultado;
       end if;

       v_consulta_v2 := 'select rh.id_rango_horario,
                      						rh.rango_salida_ini,
                                            rh.rango_salida_fin
                                            from asis.trango_horario rh
                                            inner join asis.tasignar_rango ar on ar.id_rango_horario = rh.id_rango_horario
                                            where ar.id_uo = '||p_id_uo||'
       										and '''||p_hora||'''::time between rh.rango_salida_ini::time and rh.rango_salida_fin::time
                                            and rh.'||p_dia||' = ''si'' ';

                      EXECUTE (v_consulta_v2) into v_rango_v2;

                      if (p_hora >= v_rango_v2.rango_salida_ini and  p_hora < v_rango_v2.rango_salida_fin) then

                           v_resultado[1] = v_rango_v2.id_rango_horario;
                           v_resultado[2] = 'normal';
                           v_resultado[3] = 'Salida';
                           return v_resultado;
                        end if;

         v_resultado[1] = null;
         v_resultado[2] = 'mal';
         v_resultado[3] = 'Otro';
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

ALTER FUNCTION asis.f_obtener_evento (p_dia varchar, p_hora time, p_id_uo integer, p_id_funcionario integer)
  OWNER TO dbaamamani;