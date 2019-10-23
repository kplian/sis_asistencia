CREATE OR REPLACE FUNCTION asis.f_buscar_su_par (
  p_id_funcionario integer,
  p_id_periodo integer,
  p_dia integer,
  p_hora time,
  p_id_rango integer
)
RETURNS boolean AS
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
   v_resultado 							boolean;
   v_marcaciones						record;
   v_registro							record;
   v_jornada							time;

BEGIN
  	v_nombre_funcion = 'asis.f_buscar_su_par';

	v_resultado = false;

    select  bio.id_usuario_reg,
    		bio.id_transaccion_bio,
            bio.id_rango_horario,
            bio.evento,
            bio.fecha_marcado
            into
            v_marcaciones
    from asis.ttransaccion_bio bio
    where bio.id_funcionario = p_id_funcionario
    and bio.id_periodo = p_id_periodo
    and to_char(bio.fecha_marcado,'DD')::integer  = p_dia
   -- and bio.rango = 'no'
    and bio.hora = p_hora;

    update asis.ttransaccion_bio set
    rango = 'si'
    where id_transaccion_bio = v_marcaciones.id_transaccion_bio;

	---le falta su Entrada
	if v_marcaciones.evento = 'Salida' then

    ---

        select   asis.f_id_transacion_bio (
                  min(bio.hora)::time,
                  p_id_periodo,
                  p_id_funcionario,
                  to_char(bio.fecha_marcado,'DD')::integer,
                  'no'
                ) as id_transaccion_bio,
                to_char(bio.fecha_marcado,'DD')::integer as dia,
                min(bio.hora) as hora,
                bio.fecha_marcado
                into
                v_registro
        from asis.ttransaccion_bio bio
        where  bio.id_funcionario = p_id_funcionario
        and bio.id_periodo = p_id_periodo
        and bio.id_rango_horario is null
        and bio.evento = 'Entrada'
        and bio.rango = 'no'
        and to_char(bio.fecha_marcado,'DD')::integer  = p_dia
        group by bio.fecha_marcado
        order by dia;

      	if v_registro.id_transaccion_bio is null then

        	select rh.hora_entrada into v_jornada
            from asis.trango_horario rh
            where rh.id_rango_horario = p_id_rango;

        	       INSERT INTO  asis.ttransaccion_bio
                      (
                        id_usuario_reg,
                        fecha_reg,
                        estado_reg,
                        fecha_marcado,
                        hora,
                        id_funcionario,
                        id_periodo,
                        obs,
                        id_rango_horario,
                        evento,
                        acceso,
                        rango,
                        pivot,
                        event_time,
                        registro
                      )
                      VALUES (
                      v_marcaciones.id_usuario_reg,
                      now(),
                      'activo',
                      v_marcaciones.fecha_marcado,
                      v_jornada::time,
                      p_id_funcionario,
                      p_id_periodo,
                      'NO MARCO SU SALIDA',
                       null,
                      'Entrada',
                      'no tiene marca',
                      'si',
                       0,
                       v_marcaciones.fecha_marcado::timestamp,
                      'manual');
        v_resultado = true;
        end if;

        update asis.ttransaccion_bio set
        rango = 'si'
        where id_transaccion_bio = v_registro.id_transaccion_bio;

        v_resultado = true;

    end if;

    ---le falta su Salida
	if v_marcaciones.evento = 'Entrada' then

        select   asis.f_id_transacion_bio (
                  max(bio.hora)::time,
                  p_id_periodo,
                  p_id_funcionario,
                  to_char(bio.fecha_marcado,'DD')::integer,
                  'no'
                ) as id_transaccion_bio,
                to_char(bio.fecha_marcado,'DD')::integer as dia,
                max(bio.hora) as hora,
                bio.fecha_marcado
                into
                v_registro
        from asis.ttransaccion_bio bio
        where  bio.id_funcionario = p_id_funcionario
        and bio.id_periodo = p_id_periodo
        and bio.id_rango_horario is null
        and bio.evento = 'Salida'
        and bio.rango = 'no'
        and to_char(bio.fecha_marcado,'DD')::integer  = p_dia
        group by bio.fecha_marcado
        order by dia;

        if v_registro.id_transaccion_bio is null then

        	select rh.hora_salida into v_jornada
            from asis.trango_horario rh
            where rh.id_rango_horario = p_id_rango;

        INSERT INTO  asis.ttransaccion_bio
                      (
                        id_usuario_reg,
                        fecha_reg,
                        estado_reg,
                        fecha_marcado,
                        hora,
                        id_funcionario,
                        id_periodo,
                        obs,
                        id_rango_horario,
                        evento,
                        acceso,
                        rango,
                        pivot,
                        event_time,
                        registro
                      )
                      VALUES (
                      v_marcaciones.id_usuario_reg,
                      now(),
                      'activo',
                      v_marcaciones.fecha_marcado,
                      v_jornada::time,
                      p_id_funcionario,
                      p_id_periodo,
                      'NO MARCO SU SALIDA',
                       null,
                      'Salida',
                      'no tiene marca',
                      'si',
                       0,
                       v_marcaciones.fecha_marcado::timestamp,
                      'manual');
        v_resultado = true;

        end if;

        update asis.ttransaccion_bio set
        rango = 'si'
        where id_transaccion_bio = v_registro.id_transaccion_bio;

        v_resultado = true;

    end if;


    RETURN v_resultado;
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
COST 100;

ALTER FUNCTION asis.f_buscar_su_par (p_id_funcionario integer, p_id_periodo integer, p_dia integer, p_hora time, p_id_rango integer)
  OWNER TO dbaamamani;