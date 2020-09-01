CREATE OR REPLACE FUNCTION asis.f_imsert_pares (
  p_id_funcionario integer,
  p_horas text [],
  p_id_usuario integer,
  p_fecha date
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
   v_resp                      	varchar;
   v_nombre_funcion            	text;
   v_resultado					boolean = false;
   v_marcaciones				record;
   v_id_gestion					integer;
   v_id_periodo					integer;
   v_hora						timestamp;
   v_record						record;
   v_record_v					record;
   v_jornada					time;
   v_literal					varchar;
   v_id_transaccion				integer;

BEGIN
  	v_nombre_funcion = 'asis.f_pares';

     -- Obtner gestion
    select ge.id_gestion into v_id_gestion
    from param.tgestion ge
    where ge.gestion = EXTRACT(YEAR FROM p_fecha::date);

    -- Obtener periodo
    select pe.id_periodo into v_id_periodo
    from param.tperiodo pe
    where pe.id_gestion = v_id_gestion and pe.periodo = EXTRACT(MONTH FROM p_fecha::date);

    -- Cuando el vector no tiene datos
    if p_horas is null then
    	return true;
    end if;

    if array_length(p_horas,1)% 2 = 1 then

       for v_record in (select rt.id_rango_horario,
                               count(rt.id_rango_horario) as contador
                        from asis.ttransacc_zkb_etl rt
                        where rt.id_funcionario = p_id_funcionario
                                and rt.event_time::text = any(p_horas)
                        group by rt.id_rango_horario) loop


  			if v_record.contador = 1 then

            	select  t.id,
                		t.event_time::time as hora,
                        t.fecha,
                        t.id_rango_horario,
                        r.rango_entrada_ini,
                        r.rango_entrada_fin,
                        r.rango_salida_ini,
                        r.rango_salida_fin,
                        r.hora_entrada,
                        r.hora_salida
                        into
                        v_record_v
                from asis.ttransacc_zkb_etl t
                inner join asis.trango_horario r on r.id_rango_horario = t.id_rango_horario
                where t.id_funcionario = p_id_funcionario
                      and t.fecha = p_fecha
                      and t.id_rango_horario = v_record.id_rango_horario;


                if (v_record_v.hora between  v_record_v.rango_entrada_ini and  v_record_v.rango_entrada_fin) then
                        v_jornada = v_record_v.hora_salida;
                     	v_literal = 'Salida';
                end if;

                if (v_record_v.hora between  v_record_v.rango_salida_ini and  v_record_v.rango_salida_fin) then
                  	 	v_jornada = v_record_v.hora_entrada;
                        v_literal = 'Entrada';
                end if;

                insert into  asis.tpares(	id_usuario_reg,
                                          id_usuario_mod,
                                          fecha_reg,
                                          fecha_mod,
                                          estado_reg,
                                          fecha_marcado,
                                          hora_ini,
                                          hora_fin,
                                          lector,
                                          acceso,
                                          id_transaccion_ini,
                                          id_transaccion_fin,
                                          id_funcionario,
                                          id_permiso,
                                          id_vacacion,
                                          id_viatico,
                                          id_pares_entrada,
                                          id_periodo,
                                          rango,
                                          impar,
                                          verificacion,
                                          id_rango_horario
                                          )values (
                                           p_id_usuario,
                                           null,
                                           now(),
                                           null,
                                           'activo',
                							v_record_v.fecha,
                                           (case
                                             when v_literal = 'Entrada' then
                                             	TO_TIMESTAMP(v_record_v.fecha ||' '|| v_jornada, 'YYYY/MM/DD/HH24:MI:ss')
                                             else
                                                  null
                                            end),
                                            case
                                             when v_literal= 'Salida' then
                                             	 TO_TIMESTAMP(v_record_v.fecha ||' '|| v_jornada, 'YYYY/MM/DD/HH24:MI:ss')
                                             else
                                                  null
                                             end,
                                             'No tiene marca',
                                             v_literal,
                                              case
                                             when v_literal = 'Entrada' then
                                                  v_record_v.id
                                             else
                                                  null
                                             end,
                                            case
                                             when v_literal = 'Salida' then
                                                  v_record_v.id
                                             else
                                                  null
                                             end,
                                            p_id_funcionario,
                                            null,
                                            null,
                                            null,
                                            null, --?id_pares_entrada,
                                            v_id_periodo,
                                            'no',
                                            'no',
                                            'no maracodo',
                                            v_record_v.id_rango_horario);

            end if;

       end loop;

    	-- return true;
    end if;

    v_id_transaccion = null;
    -- raise exception 'f_pares';
    foreach v_hora in array p_horas loop

    		 select etl.id,
                    etl.event_time as hora,
                    etl.acceso as evento,
                    etl.fecha,
                    etl.reader_name,
                    etl.verify_mode_name,
                    etl.id_rango_horario
                    into
                    v_marcaciones
            from asis.ttransacc_zkb_etl etl
            where etl.id_funcionario = p_id_funcionario
            and etl.event_time = v_hora;

           /*
            if v_marcaciones.id_rango_horario is null then
            	v_marcaciones.id_rango_horario = v_id_transaccion;
            end if;
            */

            insert into  asis.tpares(	id_usuario_reg,
                                        id_usuario_mod,
                                        fecha_reg,
                                        fecha_mod,
                                        estado_reg,
                                        fecha_marcado,
                                        hora_ini,
                                        hora_fin,
                                        lector,
                                        acceso,
                                        id_transaccion_ini,
                                        id_transaccion_fin,
                                        id_funcionario,
                                        id_permiso,
                                        id_vacacion,
                                        id_viatico,
                                        id_pares_entrada,
                                        id_periodo,
                                        rango,
                                        impar,
                                        verificacion,
                                        id_rango_horario
                                        )values (
                                         p_id_usuario,
                                         null,
                                         now(),
                                         null,
                                         'activo',
                                         v_marcaciones.fecha,
                                         (case
                                           when v_marcaciones.evento = 'Entrada' then
                                                v_hora
                                           else
                                                null
                                          end),
                                          case
                                           when v_marcaciones.evento = 'Salida' then
                                                v_hora
                                           else
                                                null
                                           end,
                                           v_marcaciones.reader_name,
                                           v_marcaciones.evento,
                                            case
                                           when v_marcaciones.evento = 'Entrada' then
                                                v_marcaciones.id
                                           else
                                                null
                                           end,
                                          case
                                           when v_marcaciones.evento = 'Salida' then
                                                v_marcaciones.id
                                           else
                                                null
                                           end,
                                          p_id_funcionario,
                                          null,
                                          null,
                                          null,
                                          null, --?id_pares_entrada,
                                          v_id_periodo,
                                          'si',
                                          'no',
                                          v_marcaciones.verify_mode_name,
                                          v_marcaciones.id_rango_horario);

    		v_id_transaccion = v_marcaciones.id_rango_horario;

    	v_resultado = true;
    end loop;

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
PARALLEL UNSAFE
COST 100;

ALTER FUNCTION asis.f_imsert_pares (p_id_funcionario integer, p_horas text [], p_id_usuario integer, p_fecha date)
  OWNER TO dbaamamani;