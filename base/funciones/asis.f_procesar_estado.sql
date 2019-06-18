CREATE OR REPLACE FUNCTION asis.f_procesar_estado (
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
 #5				30/04/2019 				kplian MMV			Validaciones y reporte
 #4	ERT			17/06/2019 				 MMV				Validar que tenga registros el detalle
 ***************************************************************************/
DECLARE
  	v_nombre_funcion   	 			text;
    v_resp    			 			varchar;
    v_mensaje 			 			varchar;
    v_registo						record;
	v_record						record;
    v_id_tipo_aplicacion			integer;
    v_id_mes_trabajo_normal			integer;
    v_id_mes_trabajo_nocturno		integer;
    v_id_mes_trabajo_extra			integer;
    v_sumar_normar					numeric;
    v_ultimo_normal					numeric;
    v_sumar_nocturno				numeric;
    v_ultimo_nocturno				numeric;
    v_sumar_extra					numeric;
    v_ultimo_extra				    numeric;
    v_count							integer; --#4

BEGIN
  v_nombre_funcion = 'mat.f_procesar_estados_solicitud';

	select 	me.id_mes_trabajo,
    		me.id_funcionario,
    		me.id_periodo
            into
            v_registo
    from asis.tmes_trabajo me
    where me.id_proceso_wf = p_id_proceso_wf;

   if p_codigo_estado = 'asignado' then
   -----#4-------
   select count(md.id_mes_trabajo_det)
        	into v_count
        from asis.tmes_trabajo mt
        inner join asis.tmes_trabajo_det md on md.id_mes_trabajo = mt.id_mes_trabajo
        where mt.id_proceso_wf = p_id_proceso_wf;

        if (v_count = 0 or v_count is null) then
        	raise exception 'No tiene detelle HT';
    	end if;
         -----#4-------
    -----#5-------
  	if not asis.f_validar_centro_costo(v_registo.id_mes_trabajo)then
		raise exception 'Validar centro de costo';
 	end if;
   -----#5-------
      update asis.tmes_trabajo  set
      id_estado_wf =  p_id_estado_wf,
      estado = p_codigo_estado,
      id_usuario_mod=p_id_usuario,
      id_usuario_ai = p_id_usuario_ai,
      usuario_ai = p_usuario_ai,
      fecha_mod=now()
      where id_proceso_wf = p_id_proceso_wf;

   elsif p_codigo_estado = 'aprobado' then

    v_sumar_normar = 0;
    v_ultimo_normal = 0;
    v_sumar_nocturno = 0;
    v_ultimo_nocturno = 0;
    v_sumar_extra = 0;
    v_ultimo_extra = 0;
  -----#4-------
		select count(md.id_mes_trabajo_det)
        	into v_count
        from asis.tmes_trabajo mt
        inner join asis.tmes_trabajo_det md on md.id_mes_trabajo = mt.id_mes_trabajo
        where mt.id_proceso_wf = p_id_proceso_wf;

        if (v_count = 0 or v_count is null) then
        	raise exception 'No tiene detelle HT';
    	end if;
     -----#4-------
     for v_record in (with  total as (select    hc.id_funcionario,
                                                sum(hc.total_normal) as total_normal,
                                                sum(hc.total_extra) as total_extra,
                                                sum(hc.total_nocturna) as total_nocturna,
                                                sum(hc.extra_autorizada) as  extra_autorizada
                                                from asis.vtotales_horas_centro_costo hc
                                                where  hc.id_funcionario = v_registo.id_funcionario
                                                and hc.id_periodo = v_registo.id_periodo
                                                group by hc.id_funcionario),
                          total_cc as (select   hc.id_funcionario,
                                                hc.id_centro_costo,
                                                sum(hc.total_normal) as total_normal_cc,
                                                sum(hc.total_extra) as total_extra_cc,
                                                sum(hc.total_nocturna) as total_nocturna_cc,
                                                sum(hc.extra_autorizada) as  extra_autorizada_cc
                                                from asis.vtotales_horas_centro_costo hc
                                                where hc.id_funcionario = v_registo.id_funcionario
                                                and hc.id_periodo = v_registo.id_periodo
                                                group by hc.id_funcionario,
                                                hc.id_centro_costo)
                  select  tot.id_funcionario,
                          tcc.id_centro_costo,
                          tcc.total_normal_cc,
                          (select count(cc.id_funcionario)
                      	   from total_cc cc) as contador,
                          (case
                            when tot.total_normal > 0 then
                            (100*tcc.total_normal_cc::numeric/tot.total_normal::numeric)
                            else
                                0
                            end)::numeric as porcentaje_normal, --Hra normal
                            tcc.total_nocturna_cc,
                            (case
                            when tot.total_nocturna > 0 then
                            (100*tcc.total_nocturna_cc::numeric/tot.total_nocturna::numeric)
                            else
                                0
                            end)::numeric as porcentaje_nocturno, --Hra nocturno
                            tcc.extra_autorizada_cc,
                            (case
                            when tot.extra_autorizada > 0 then
                            (100*tcc.extra_autorizada_cc::numeric/tot.extra_autorizada::numeric)
                            else
                                0
                            end)::numeric as porcentaje_extra --Hra extras
                  from total tot
                  inner join total_cc tcc on tcc.id_funcionario = tot.id_funcionario)
   			loop

                              if v_record.total_normal_cc > 0  then

                                 select ap.id_tipo_aplicacion
                                       into
                                       v_id_tipo_aplicacion
                                 from asis.ttipo_aplicacion ap
                                 where ap.codigo_aplicacion = 'normal';

                                     insert into asis.tmes_trabajo_con(	  id_usuario_reg,
                                                                          id_usuario_mod,
                                                                          fecha_reg,
                                                                          fecha_mod,
                                                                          estado_reg,
                                                                          id_usuario_ai,
                                                                          usuario_ai,
                                                                          id_mes_trabajo,
                                                                          id_centro_costo,
                                                                          id_tipo_aplicacion,
                                                                          total_horas,
                                                                          factor)
                                                                          values(
                                                                          p_id_usuario,
                                                                          null,
                                                                          now(),
                                                                          null,
                                                                          'activo',
                                                                          p_id_usuario_ai,
                                                                          p_usuario_ai,
                                                                          v_registo.id_mes_trabajo,
                                                                          v_record.id_centro_costo,
                                                                          v_id_tipo_aplicacion,
                                                                          v_record.total_normal_cc,
                                                                          v_record.porcentaje_normal)RETURNING id_mes_trabajo_con into v_id_mes_trabajo_normal;

                                      v_sumar_normar = v_sumar_normar + v_record.porcentaje_normal;
                                      v_ultimo_normal = v_record.porcentaje_normal;

                            	end if;

                                if v_record.total_nocturna_cc > 0  then

                                 select ap.id_tipo_aplicacion
                                       into
                                       v_id_tipo_aplicacion
                                 from asis.ttipo_aplicacion ap
                                 where ap.codigo_aplicacion = 'nocturno';


                                 insert into asis.tmes_trabajo_con(	  id_usuario_reg,
                                                                      id_usuario_mod,
                                                                      fecha_reg,
                                                                      fecha_mod,
                                                                      estado_reg,
                                                                      id_usuario_ai,
                                                                      usuario_ai,
                                                                      id_mes_trabajo,
                                                                      id_centro_costo,
                                                                      id_tipo_aplicacion,
                                                                      total_horas,
                                                                      factor)
                                                                      values(
                                                                      p_id_usuario,
                                                                      null,
                                                                      now(),
                                                                      null,
                                                                      'activo',
                                                                      p_id_usuario_ai,
                                                                      p_usuario_ai,
                                                                      v_registo.id_mes_trabajo,
                                                                      v_record.id_centro_costo,
                                                                      v_id_tipo_aplicacion,
                                                                      v_record.total_nocturna_cc,
                                                                      v_record.porcentaje_nocturno)RETURNING id_mes_trabajo_con into v_id_mes_trabajo_nocturno;

                                 v_sumar_nocturno = v_sumar_nocturno + v_record.porcentaje_nocturno;
                                 v_ultimo_nocturno = v_record.porcentaje_nocturno;

                            	end if;

                                if v_record.extra_autorizada_cc > 0  then

                                 select ap.id_tipo_aplicacion
                                       into
                                       v_id_tipo_aplicacion
                                 from asis.ttipo_aplicacion ap
                                 where ap.codigo_aplicacion = 'extra';


                                 insert into asis.tmes_trabajo_con(	  id_usuario_reg,
                                                                      id_usuario_mod,
                                                                      fecha_reg,
                                                                      fecha_mod,
                                                                      estado_reg,
                                                                      id_usuario_ai,
                                                                      usuario_ai,
                                                                      id_mes_trabajo,
                                                                      id_centro_costo,
                                                                      id_tipo_aplicacion,
                                                                      total_horas,
                                                                      factor)
                                                                      values(
                                                                      p_id_usuario,
                                                                      null,
                                                                      now(),
                                                                      null,
                                                                      'activo',
                                                                      p_id_usuario_ai,
                                                                      p_usuario_ai,
                                                                      v_registo.id_mes_trabajo,
                                                                      v_record.id_centro_costo,
                                                                      v_id_tipo_aplicacion,
                                                                      v_record.extra_autorizada_cc,
                                                                      v_record.porcentaje_extra)RETURNING id_mes_trabajo_con into v_id_mes_trabajo_extra;

                                 v_sumar_extra = v_sumar_extra + v_record.porcentaje_extra;
                                 v_ultimo_extra = v_record.porcentaje_extra;

                            	end if;
         end loop;



       update asis.tmes_trabajo_con set
       calculado_resta = 'si',
       factor = 100-(v_sumar_normar - v_ultimo_normal)
       where id_mes_trabajo_con = v_id_mes_trabajo_normal;

       update asis.tmes_trabajo_con set
       calculado_resta = 'si',
       factor = 100-(v_sumar_nocturno - v_ultimo_nocturno)
       where id_mes_trabajo_con = v_id_mes_trabajo_nocturno;

       update asis.tmes_trabajo_con set
       calculado_resta = 'si',
       factor = 100-(v_sumar_extra - v_ultimo_extra)
       where id_mes_trabajo_con = v_id_mes_trabajo_extra;


      update asis.tmes_trabajo  set
      id_estado_wf = p_id_estado_wf,
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