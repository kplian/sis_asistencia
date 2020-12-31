CREATE OR REPLACE FUNCTION asis.f_procesar_estado_vacacion (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_estado_wf integer,
  p_id_proceso_wf integer,
  p_codigo_estado varchar,
  p_obs text
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
    v_consulta						varchar;
    v_consulta_record				record;
    v_rango							record;
    v_dias_efectivo					numeric;
    v_descripcion_correo    		varchar;
    v_id_alarma        				integer;
    v_vacacion_record      			record;
    v_movimiento_vacacion			record;
    v_id_mov_actual					integer;

BEGIN
  v_nombre_funcion = 'mat.f_procesar_estados_solicitud';

	select 	me.id_vacacion,
    		me.fecha_inicio,
    		me.fecha_fin,
            me.dias,
            me.id_funcionario,
            me.prestado,
            me.id_funcionario_sol,
            me.id_estado_wf,
            fu.desc_funcionario1,
            to_char(me.fecha_reg::date, 'DD/MM/YYYY') as fecha_solictudo,
            to_char(me.fecha_inicio,'DD/MM/YYYY') as fecha_inicio,
            to_char(me.fecha_fin, 'DD/MM/YYYY') as fecha_fin,
            me.descripcion,
            me.dias,
            me.id_usuario_reg
            into
            v_registro
    from asis.tvacacion me
    inner join orga.vfuncionario fu on fu.id_funcionario = me.id_funcionario
    where me.id_proceso_wf = p_id_proceso_wf;


   if p_codigo_estado = 'vobo' then

    		if (v_registro.id_funcionario_sol is not null)then
                v_descripcion_correo = '<h3><b>SOLICITUD DE VACACIÓN</b></h3>
                                      <p style="font-size: 15px;"><b>Fecha solicitud:</b> '||v_registro.fecha_solictudo||' </p>
                                      <p style="font-size: 15px;"><b>Solicitud para:</b> '||v_registro.desc_funcionario1||'</p>
                                      <p style="font-size: 15px;"><b>Desde:</b> '||v_registro.fecha_inicio||' <b>Hasta:</b> '||v_registro.fecha_fin||'</p>
                                      <p style="font-size: 15px;"><b>Días solicitados:</b> '||v_registro.dias||'</p>
                                      <p style="font-size: 15px;"><b>Justificación:</b> '||v_registro.descripcion||'</p>';

                v_id_alarma = param.f_inserta_alarma(
                                    v_registro.id_funcionario,
                                    v_descripcion_correo,--par_descripcion
                                    '',--acceso directo
                                    now()::date,--par_fecha: Indica la fecha de vencimiento de la alarma
                                    'notificacion', --notificacion
                                    'Solicitud Vacacion',  --asunto
                                    p_id_usuario,
                                    '', --clase
                                    'Solicitud Vacacion',--titulo
                                    '',--par_parametros varchar,   parametros a mandar a la interface de acceso directo
                                    p_id_usuario, --usuario a quien va dirigida la alarma
                                    '',--titulo correo
                                    '', --correo funcionario
                                    null,--#9
                                    p_id_proceso_wf,
                                    v_registro.id_estado_wf--#9
                                   );
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
      fecha_mod=now(),
       observaciones = p_obs
      where id_proceso_wf = p_id_proceso_wf;
        
      return true;

	end if;
	
    if p_codigo_estado = 'aprobado' then
    
            select va.id_movimiento_vacacion,
                   va.id_funcionario,
                   COALESCE(va.dias_actual,0) as dias_actual,
                   va.codigo
                  into v_record
            from asis.tmovimiento_vacacion va
            where va.id_funcionario = v_registro.id_funcionario 
                and va.activo = 'activo' 
                and  va.estado_reg = 'activo';
        
            v_evento = 'TOMADA';
            v_resultado =  v_record.dias_actual - v_registro.dias;
        
            if v_record.dias_actual <= 0 then
              
                v_positivo = -1 * v_record.dias_actual;
                v_resultado =  (v_positivo + v_registro.dias)* -1;
                  
            end if;
         
          insert into  asis.tmovimiento_vacacion(
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
                            )values(
                             v_registro.id_usuario_reg,
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
                            -1*v_registro.dias,
                            v_evento,
                            v_registro.id_vacacion
                            )returning id_movimiento_vacacion into v_id_movimiento_vacacion;

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
          fecha_mod=now(),
          observaciones =  p_obs
          where id_proceso_wf = p_id_proceso_wf;
          
          
           		v_descripcion_correo = '<h3><b>SOLICITUD DE VACACIÓN</b></h3>
                                      <p style="font-size: 15px;"><b>Fecha solicitud:</b> '||v_registro.fecha_solictudo||' </p>
                                      <p style="font-size: 15px;"><b>Solicitud para:</b> '||v_registro.desc_funcionario1||'</p>
                                      <p style="font-size: 15px;"><b>Desde:</b> '||v_registro.fecha_inicio||' <b>Hasta:</b> '||v_registro.fecha_fin||'</p>
                                      <p style="font-size: 15px;"><b>Días solicitados:</b> '||v_registro.dias||'</p>
                                      <p style="font-size: 15px;"><b>Justificación:</b> '||v_registro.descripcion||'</p>';

                v_id_alarma = param.f_inserta_alarma(
                                    v_registro.id_funcionario,
                                    v_descripcion_correo,--par_descripcion
                                    '',--acceso directo
                                    now()::date,--par_fecha: Indica la fecha de vencimiento de la alarma
                                    'notificacion', --notificacion
                                    'Solicitud Vacacion Aprobada',  --asunto
                                    p_id_usuario,
                                    '', --clase
                                    'Solicitud Vacacion Aprobada',--titulo
                                    '',--par_parametros varchar,   parametros a mandar a la interface de acceso directo
                                    p_id_usuario, --usuario a quien va dirigida la alarma
                                    '',--titulo correo
                                    '', --correo funcionario
                                    null,--#9
                                    p_id_proceso_wf,
                                    v_registro.id_estado_wf--#9
                                   );

          return true;

    end if;



      if p_codigo_estado = 'cancelado' then


            select v.id_vacacion, v.id_funcionario into v_vacacion_record
            from asis.tvacacion v
            where v.id_proceso_wf = p_id_proceso_wf;


            select m.id_movimiento_vacacion, m.id_funcionario into v_movimiento_vacacion
            from asis.tmovimiento_vacacion m
            where m.id_vacacion = v_registro.id_vacacion
				 and m.activo = 'activo';


            delete from asis.tmovimiento_vacacion  mv
            where mv.id_movimiento_vacacion = v_movimiento_vacacion.id_movimiento_vacacion
            	and mv.activo = 'activo';


            delete from asis.tpares pa
            where pa.id_vacacion = v_registro.id_vacacion
            	and pa.id_funcionario = v_vacacion_record.id_funcionario;

           
            select mm.id_movimiento_vacacion into v_id_mov_actual
            from asis.tmovimiento_vacacion mm
            where mm.id_funcionario = v_movimiento_vacacion.id_funcionario
            		and mm.fecha_reg = (select max(m.fecha_reg)
                                        from asis.tmovimiento_vacacion m
                                        where m.id_funcionario = v_movimiento_vacacion.id_funcionario);


            update asis.tmovimiento_vacacion set
            activo = 'activo',
            estado_reg = 'activo'
            where id_movimiento_vacacion = v_id_mov_actual;


            update asis.tvacacion  set
            id_estado_wf =  p_id_estado_wf,
            estado = p_codigo_estado,
            id_usuario_mod=p_id_usuario,
            id_usuario_ai = p_id_usuario_ai,
            usuario_ai = p_usuario_ai,
            fecha_mod=now(),
            observaciones =  p_obs
            where id_proceso_wf = p_id_proceso_wf;
          		
        return true;

	end if;
    
	if p_codigo_estado = 'rechazado' then
    
    	update asis.tvacacion  set
        id_estado_wf =  p_id_estado_wf,
        estado = p_codigo_estado,
        id_usuario_mod=p_id_usuario,
        id_usuario_ai = p_id_usuario_ai,
        usuario_ai = p_usuario_ai,
        fecha_mod=now(),
        observaciones =  p_obs
        where id_proceso_wf = p_id_proceso_wf;
        
        v_descripcion_correo = '<h3><b>SOLICITUD DE VACACIÓN</b></h3>
                                      <p style="font-size: 15px;"><b>Fecha solicitud:</b> '||v_registro.fecha_solictudo||' </p>
                                      <p style="font-size: 15px;"><b>Solicitud para:</b> '||v_registro.desc_funcionario1||'</p>
                                      <p style="font-size: 15px;"><b>Desde:</b> '||v_registro.fecha_inicio||' <b>Hasta:</b> '||v_registro.fecha_fin||'</p>
                                      <p style="font-size: 15px;"><b>Días solicitados:</b> '||v_registro.dias||'</p>
                                      <p style="font-size: 15px;"><b>Justificación:</b> '||v_registro.descripcion||'</p>
                                      <p style="font-size: 15px;"><b>Obs.:</b> '||p_obs||'</p>';

                v_id_alarma = param.f_inserta_alarma(
                                    v_registro.id_funcionario,
                                    v_descripcion_correo,--par_descripcion
                                    '',--acceso directo
                                    now()::date,--par_fecha: Indica la fecha de vencimiento de la alarma
                                    'notificacion', --notificacion
                                    'Solicitud Vacacion Rechazado',  --asunto
                                    p_id_usuario,
                                    '', --clase
                                    'Solicitud Vacacion Rechazado',--titulo
                                    '',--par_parametros varchar,   parametros a mandar a la interface de acceso directo
                                    p_id_usuario, --usuario a quien va dirigida la alarma
                                    '',--titulo correo
                                    '', --correo funcionario
                                    null,--#9
                                    p_id_proceso_wf,
                                    v_registro.id_estado_wf--#9
                                   );
	
    	return true;
      end if;
    
    
      update asis.tvacacion  set
      id_estado_wf =  p_id_estado_wf,
      estado = p_codigo_estado,
      id_usuario_mod=p_id_usuario,
      id_usuario_ai = p_id_usuario_ai,
      usuario_ai = p_usuario_ai,
      fecha_mod=now(),
      observaciones =  p_obs
      where id_proceso_wf = p_id_proceso_wf;


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