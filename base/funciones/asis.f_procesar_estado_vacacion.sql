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


BEGIN
  v_nombre_funcion = 'mat.f_procesar_estados_solicitud';

	select 	me.fecha_inicio,
    		me.fecha_fin,
            me.dias,
            me.id_funcionario
            into
            v_registro
    from asis.tvacacion me
    where me.id_proceso_wf = p_id_proceso_wf;

   if p_codigo_estado = 'vobo' then
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

    if v_record.dias_actual < -3 then
    	raise exception 'Solo puede tomer 3 dias de anticipo.';
    end if;

     /*v_dias_saldo = v_registro.dias + v_record.dias_actual;

     --raise exception 'dias solicitados: %', v_dias_Saldo;
    if v_dias_saldo > 3 then
    	v_dif = 3+v_record.dias_actual;
    	raise exception 'Solo resa anticipar: %', v_dif;
    end if;*/

    INSERT INTO  asis.tmovimiento_vacacion
                        (
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
                          tipo
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
                          v_record.dias_actual - v_registro.dias,
                          'activo',
                          v_record.codigo,
                          -1 * v_registro.dias ,
                          'TOMADA'
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
COST 100;

ALTER FUNCTION asis.f_procesar_estado_vacacion (p_id_usuario integer, p_id_usuario_ai integer, p_usuario_ai varchar, p_id_estado_wf integer, p_id_proceso_wf integer, p_codigo_estado varchar)
  OWNER TO dbaamamani;