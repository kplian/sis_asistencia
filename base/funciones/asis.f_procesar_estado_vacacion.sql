CREATE OR REPLACE FUNCTION asis.f_procesar_estado_vacacion (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_estado_wf integer,
  p_id_proceso_wf integer,
  p_codigo_estado varchar
)
RETURNS boolean AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.f_lista_funcionario_wf
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.tmes_trabajo_con'
 AUTOR: 		 (miguel.mamani)
 FECHA:	        13-03-2019 13:52:11
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 ***************************************************************************/
DECLARE
  	v_nombre_funcion   	 			text;
    v_resp    			 			varchar;
    v_mensaje 			 			varchar;
    v_registro						record;
	v_record						record;
    v_id_movimiento_vacacion		integer;
    v_codigo						varchar;
    v_dias_Saldo					numeric;
    v_dif							numeric;
	v_resultado						numeric;
    v_positivo						numeric;
    v_evento						varchar;
    v_pares							record;

   v_filtro						varchar;
   v_consulta					varchar;
   v_consulta_record			record;
   v_rango						record;
   v_dias_efectivo				numeric;
   v_descripcion_correo    		varchar;
   v_id_alarma        			integer;
   v_vista_vacacion				record;

BEGIN
  v_nombre_funcion = 'mat.f_procesar_estados_solicitud';

	select 	me.id_vacacion,
    		me.fecha_inicio,
    		me.fecha_fin,
            me.dias,
            me.id_funcionario,
            me.prestado,
            me.id_funcionario_sol,
            me.id_estado_wf
            into
            v_registro
    from asis.tvacacion me
    where me.id_proceso_wf = p_id_proceso_wf;

   if p_codigo_estado = 'vobo' then

    if (v_registro.id_funcionario_sol is not null)then

				select va.fecha_solicitud, va.funcionario_solicitante, va.fecha_inicio,va.fecha_fin,va.descripcion
                into v_vista_vacacion
                from asis.vvacacion va
                where va.id_proceso_wf = p_id_proceso_wf;


                v_descripcion_correo = '
                	<div>
                    <p><font size="4">SOLICITUD DE VACACIÓn</font><br></p>
                    <p>Fecha solicitud: <b>'||v_vista_vacacion.fecha_solicitud||'</b>/p>
					<p><b>'||v_vista_vacacion.funcionario_solicitante||'</b></p>
                    <p> Desde: <b>'||v_vista_vacacion.fecha_inicio||'</b Hasta: <b>'||v_vista_vacacion.fecha_fin||'</b </p>
                    <p> Justificacion: <b>'||v_vista_vacacion.descripcion||'</b</p>
                    </div>
                ';

                v_id_alarma = param.f_inserta_alarma(
                                    v_registro.id_funcionario,
                                    v_descripcion_correo,--par_descripcion
                                    '',--acceso directo
                                    now()::date,--par_fecha: Indica la fecha de vencimiento de la alarma
                                    'notificacion', --notificacion
                                    'Solicitud Permiso',  --asunto
                                    p_id_usuario,
                                    '', --clase
                                    'Solicitud Permiso',--titulo
                                    '',--par_parametros varchar,   parametros a mandar a la interface de acceso directo
                                    p_id_usuario, --usuario a quien va dirigida la alarma
                                    'Solicitud Permiso',--titulo correo
                                    '', --correo funcionario
                                    null,--#9
                                    p_id_proceso_wf,
                                    v_registro.id_estado_wf--#9
                                   );
               		---raise exception 'para';
               end if;

    	select sum(d.dias_efectico) into v_dias_efectivo
        	from (
            select
            	    (case
                    				when vd.tiempo  = 'completo' then
                                     1
                                    when vd.tiempo  = 'mañana' then
                                    0.5
                                    when vd.tiempo  = 'tarde' then
                                    0.5
                                    else
                                    0
                                    end ::numeric ) as dias_efectico

            from asis.tvacacion_det vd
            where vd.id_vacacion =  v_registro.id_vacacion ) d;

            update asis.tvacacion  set
            dias_efectivo = v_dias_efectivo,
            dias = v_dias_efectivo
            where  id_vacacion  =  v_registro.id_vacacion;


      update asis.tvacacion  set
      id_estado_wf =  p_id_estado_wf,
      estado = p_codigo_estado,
      id_usuario_mod=p_id_usuario,
      id_usuario_ai = p_id_usuario_ai,
      usuario_ai = p_usuario_ai,
      fecha_mod=now()
      where id_proceso_wf = p_id_proceso_wf;

	end if;

    if p_codigo_estado = 'aprobado' then


        select va.id_movimiento_vacacion,
               va.id_funcionario,
               va.dias_actual,
               va.codigo
              into v_record
        from asis.tmovimiento_vacacion va
        where va.id_funcionario =  v_registro.id_funcionario and va.activo = 'activo';


        v_evento = 'TOMADA';
        v_resultado =  v_record.dias_actual - v_registro.dias;

        if v_registro.prestado = 'si' then

            if v_record.dias_actual < 0 then
                v_positivo = -1 * v_record.dias_actual;
                v_resultado =  (v_positivo + v_registro.dias)* -1;
            end if;

            v_evento = 'PRESTADO';

        end if;

    	INSERT INTO  asis.tmovimiento_vacacion(
                          id_usuario_reg,
                          id_usuario_mod,
                          fecha_reg,
                          fecha_mod,
                          estado_reg,
                          id_usuario_ai,
                          usuario_ai,
                          id_funcionario,
                          desde,
                          hasta,
                          dias_actual,
                          activo,
                          codigo,
                          dias,
                          tipo,
                          id_vacacion
                        )
                        VALUES (
                           p_id_usuario,
                          null,
                          now(),
                          null,
                          'activo',
                          p_id_usuario_ai,
                          p_usuario_ai,
                          v_registro.id_funcionario,
                          v_registro.fecha_inicio,
                          v_registro.fecha_fin,
                          v_resultado,-- v_record.dias_actual - v_registro.dias,
                          'activo',
                          v_record.codigo,
                          -1 * v_registro.dias ,
                          v_evento,
                          v_registro.id_vacacion
                        )RETURNING id_movimiento_vacacion into v_id_movimiento_vacacion;

          if v_id_movimiento_vacacion is null then
           raise exception 'Algo salimo mal en calculo operacion';
          end if;

        update asis.tmovimiento_vacacion set
        activo = 'inactivo'
        where id_movimiento_vacacion = v_record.id_movimiento_vacacion;

        update asis.tvacacion  set
        id_estado_wf =  p_id_estado_wf,
        estado = p_codigo_estado,
        id_usuario_mod=p_id_usuario,
        id_usuario_ai = p_id_usuario_ai,
        usuario_ai = p_usuario_ai,
        fecha_mod=now()
        where id_proceso_wf = p_id_proceso_wf;


       /* for v_pares in (select  vd.fecha_dia,

        						case
                                	when vd.tiempo  = 'completo' then
                                    8
                                    when vd.tiempo  = 'mañana' then
                                    4
                                    when vd.tiempo  = 'tarde' then
                                    4
                                    else
                                    0
                                    end ::integer as tiempo
                        from asis.tvacacion v
                        inner join asis.tvacacion_det vd on vd.id_vacacion = v.id_vacacion
                        where v.id_vacacion = v_registro.id_vacacion) loop

     	  v_filtro = asis.f_obtener_rango_asignado_fun (v_registro.id_funcionario,v_pares.fecha_dia);

          v_consulta = 'select rh.id_rango_horario,
                                rh.hora_entrada,
                                rh.hora_salida
                        from asis.trango_horario rh
                        inner join asis.tasignar_rango ar on ar.id_rango_horario = rh.id_rango_horario
                        where '||v_filtro||'and rh.'||asis.f_obtener_dia_literal(v_pares.fecha_dia)||' = ''si''
                         and  '''||v_pares.fecha_dia||'''  between ar.desde and ar.hasta
                        order by rh.hora_entrada, ar.hasta asc';

          execute (v_consulta) into v_consulta_record;

      	 	 if v_consulta_record.id_rango_horario is null then

               v_consulta = 'select rh.id_rango_horario,
                                    rh.hora_entrada,
                                    rh.hora_salida
                            from asis.trango_horario rh
                            inner join asis.tasignar_rango ar on ar.id_rango_horario = rh.id_rango_horario
                            where '||v_filtro||'and rh.'||asis.f_obtener_dia_literal(v_pares.fecha_dia)||' = ''si''
                             and  '''||v_pares.fecha_dia||''' >= ar.desde  and ar.hasta is null
                          order by rh.hora_entrada, ar.hasta asc';

     		 end if;

          	  for v_rango in execute (v_consulta)loop

                  insert into asis.tpares(id_usuario_reg,
                                          id_usuario_mod,
                                          fecha_reg,
                                          fecha_mod,
                                          estado_reg,
                                          id_usuario_ai,
                                          usuario_ai,
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
                                          permiso,
                                          id_rango_horario,
                                          id_feriado
                                          )values (
                                          p_id_usuario,
                                          null,
                                          now(),
                                          null,
                                          'activo',
                                          null, --v_parametros._id_usuario_ai,
                                          null, --v_parametros._nombre_usuario_ai,
                                          v_pares.fecha_dia,
                                          (v_pares.fecha_dia::varchar ||' '|| v_rango.hora_entrada::varchar)::timestamp,
                                          null,
                                          'Vacacion',
                                          'Entrada',
                                          null,
                                          null,
                                          v_registro.id_funcionario,
                                          null,--p_id_permiso,
                                          v_registro.id_vacacion,
                                          null,--p_id_cuenta_doc,
                                          null,
                                          (
                                          select  p.id_periodo
                                          from param.tperiodo p
                                          where v_pares.fecha_dia  between p.fecha_ini and p.fecha_fin
                                          ),
                                          'si',
                                          'no',
                                          'no',
                                          'no',
                                          v_rango.id_rango_horario,
                                          null--p_id_feriado
                                          );
                                  insert into asis.tpares(id_usuario_reg,
                                          id_usuario_mod,
                                          fecha_reg,
                                          fecha_mod,
                                          estado_reg,
                                          id_usuario_ai,
                                          usuario_ai,
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
                                          permiso,
                                          id_rango_horario,
                                          id_feriado
                                          )values (
                                          p_id_usuario,
                                          null,
                                          now(),
                                          null,
                                          'activo',
                                          null, --v_parametros._id_usuario_ai,
                                          null, --v_parametros._nombre_usuario_ai,
                                          v_pares.fecha_dia,
                                          (v_pares.fecha_dia::varchar ||' '|| v_rango.hora_salida::varchar)::timestamp,
                                          null,
                                          'Vacacion',
                                          'Salida',
                                          null,
                                          null,
                                          v_registro.id_funcionario,
                                          null,--p_id_permiso,
                                          v_registro.id_vacacion,
                                          null,--p_id_cuenta_doc,
                                          null,
                                          (
                                          select  p.id_periodo
                                          from param.tperiodo p
                                          where v_pares.fecha_dia  between p.fecha_ini and p.fecha_fin
                                          ),
                                          'si',
                                          'no',
                                          'no',
                                          'no',
                                          v_rango.id_rango_horario,
                                          null-- p_id_feriado
                                          );
		      end loop;


        end loop;*/


	end if;

  return true;
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

ALTER FUNCTION asis.f_procesar_estado_vacacion (p_id_usuario integer, p_id_usuario_ai integer, p_usuario_ai varchar, p_id_estado_wf integer, p_id_proceso_wf integer, p_codigo_estado varchar)
  OWNER TO dbaamamani;