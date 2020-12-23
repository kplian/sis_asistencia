CREATE OR REPLACE FUNCTION asis.ft_pares_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.ft_pares_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.tpares'
 AUTOR: 		 (mgarcia)
 FECHA:	        19-09-2019 16:00:52
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				19-09-2019 16:00:52								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.tpares'
 #
 ***************************************************************************/

DECLARE

	v_parametros           	record;
	v_resp		            varchar;
	v_nombre_funcion        text;
    v_id_pares				integer;

    v_periodo				integer;
    v_fecha_ini				date;
    v_fecha_fin				date;
    v_record_dia			record;

    v_filtro				varchar;

    v_consulta				varchar;
    v_rango					record;

    v_periodo_rec			record;
    v_quincena_one			record;
    v_quincena_two			record;
 	v_ht_one				record;
    v_ht_two				record;
	v_quincena_one_dia		record;

    v_calcular_ma			numeric;
    v_calcular_ta			numeric;
    v_calcular_no			numeric;
    v_calcular_ex			numeric;
    v_calcular				numeric;
    v_rec_gestion			record;
    v_codigo_tipo_proceso	varchar;
    v_id_proceso_macro		integer;
    v_nro_tramite			varchar;
    v_id_proceso_wf			integer;
    v_id_estado_wf			integer;
    v_codigo_estado			varchar;
    v_id_mes_trabajo			integer;
    v_log_array                 integer;
    v_consulta_record			record;
	v_fuera_rango				record;
	v_resultador				varchar[];
    v_resultador_time		    varchar[];
    v_marcaciones				record;
    v_hora_nr					timestamp;
    v_evente_times				timestamp[];
    v_periodo_mes				varchar;
    v_transaccion				record;
    v_resultado_final			numeric;
    v_hora						timestamp;
    v_id						integer;

BEGIN

    v_nombre_funcion = 'asis.ft_pares_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'ASIS_PAR_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		MMV
 	#FECHA:		19-09-2019 16:00:52
	***********************************/

	if(p_transaccion='ASIS_PAR_INS')then

        begin
        	--Sentencia de la insercion
        	insert into asis.tpares(
			estado_reg,
			id_transaccion_ini,
			id_transaccion_fin,
			fecha_marcado,
			id_funcionario,
			id_vacacion,
			id_viatico,
			id_usuario_reg,
			fecha_reg,
			id_usuario_ai,
			usuario_ai,
			id_usuario_mod,
			fecha_mod
          	) values(
			'activo',
			v_parametros.id_transaccion_ini,
			v_parametros.id_transaccion_fin,
			v_parametros.fecha_marcado,
			v_parametros.id_funcionario,
			v_parametros.id_vacacion,
			v_parametros.id_viatico,
			p_id_usuario,
			now(),
			v_parametros._id_usuario_ai,
			v_parametros._nombre_usuario_ai,
			null,
			null
            )RETURNING id_pares into v_id_pares;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Marcados Pares almacenado(a) con exito (id_pares'||v_id_pares||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_pares',v_id_pares::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_PAR_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		MMV
 	#FECHA:		19-09-2019 16:00:52
	***********************************/

	elsif(p_transaccion='ASIS_PAR_MOD')then

		begin
			--Sentencia de la modificacion
			update asis.tpares set
			id_transaccion_ini = v_parametros.id_transaccion_ini,
			id_transaccion_fin = v_parametros.id_transaccion_fin,
			fecha_marcado = v_parametros.fecha_marcado,
			id_funcionario = v_parametros.id_funcionario,
			id_vacacion = v_parametros.id_vacacion,
			id_viatico = v_parametros.id_viatico,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_pares=v_parametros.id_pares;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Marcados Pares modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_pares',v_parametros.id_pares::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_PAR_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		MMV
 	#FECHA:		19-09-2019 16:00:52
	***********************************/

	elsif(p_transaccion='ASIS_PAR_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from asis.tpares
            where id_pares=v_parametros.id_pares;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Marcados Pares eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_pares',v_parametros.id_pares::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

    /*********************************
 	#TRANSACCION:  'ASIS_PARS_INS'
 	#DESCRIPCION:	Armar Pares
 	#AUTOR:		MMV
 	#FECHA:		19-09-2019 16:00:52
	***********************************/

	elsif(p_transaccion='ASIS_PARS_INS')then

      begin
      v_filtro = '';
      ---obtener el periodo y fecha inicio y fecha fin del periodo
      select  pe.periodo,
              pe.fecha_ini,
              pe.fecha_fin
              into
              v_periodo,
              v_fecha_ini,
              v_fecha_fin
      from param.tperiodo pe
      where pe.id_periodo = v_parametros.id_periodo;

      for v_record_dia in (with periodo as (select mes::date as mes
                 from generate_series(v_fecha_ini,v_fecha_fin, '1 day'::interval) mes),
     permiso as (select pe.id_permiso,
               		    pe.fecha_solicitud
               from asis.tpermiso pe
               where pe.fecha_solicitud between v_fecha_ini and  v_fecha_fin
               and pe.id_funcionario = v_parametros.id_funcionario),
     vacacion as ( select va.id_vacacion,
                         dv.fecha_dia
                        from asis.tvacacion va
                        inner join asis.tvacacion_det dv on dv.id_vacacion = va.id_vacacion
                        where va.id_funcionario = v_parametros.id_funcionario
                        and  va.fecha_inicio >=v_fecha_ini and va.fecha_fin <= v_fecha_fin
                        and va.estado = 'aprobado'
                        order by fecha_dia),
     viaticos as (select cu.id_cuenta_doc,
                         unnest( string_to_array((select pxp.list(mes::date::text)
                              from generate_series(cu.fecha_salida,cu.fecha_llegada, '1 day'::interval) mes),','))::date as fecha_dia
                  from cd.tcuenta_doc cu
                  where cu.estado = 'pendiente'
                  and (v_parametros.id_funcionario = ANY (cu.id_funcionarios) or cu.id_funcionario = v_parametros.id_funcionario)
                  and  cu.fecha_salida >= v_fecha_ini and cu.fecha_llegada <= v_fecha_fin
                  order by fecha_dia),
     feriado as ( select  fe.id_feriado,
                		  fe.fecha
                from param.tferiado fe
                where fe.fecha between v_fecha_ini and v_fecha_fin
                order by fecha),
    biometrico as (select ma.dia,
                          asis.array_sort (string_to_array(pxp.list(ma.hora::text),','))  as horas
                  from ( select   etl.fecha as dia,
                                  etl.id_rango_horario,
                                  min(etl.event_time) as hora,
                                  etl.acceso
                            from asis.ttransacc_zkb_etl etl
                            where etl.acceso = 'Entrada'
                            and etl.id_funcionario = v_parametros.id_funcionario
                            and etl.id_rango_horario is not null
                            and etl.rango = 'no'
                            group by etl.id_rango_horario, etl.fecha,etl.acceso
                  union all
                  select    etl.fecha as dia,
                            etl.id_rango_horario,
                            max(etl.event_time) as hora,
                            etl.acceso
                      from asis.ttransacc_zkb_etl etl
                      where etl.acceso = 'Salida'
                      and etl.id_funcionario = v_parametros.id_funcionario
                      and etl.id_rango_horario is not null
                      and etl.rango = 'no'
                      group by etl.id_rango_horario, etl.fecha,etl.acceso
                      order by hora ) as ma
                      where dia between v_fecha_ini and v_fecha_fin
                      group by ma.dia
                      order by dia)
                 select asis.f_obtener_dia_literal(pe.mes::date) as dia_literal,
                        pe.mes,
                        extract(dow from pe.mes) as dia,
                        er.id_permiso,
                        vi.id_cuenta_doc,
                 	    va.id_vacacion,
                        fe.id_feriado,
                        bi.horas,
                        case
                        	when bi.horas is null then
                           	    asis.f_generar_asistencia (pe.mes,v_parametros.id_funcionario,bi.horas)
                            else
                        		asis.f_generar_asistencia_dia(pe.mes,v_parametros.id_funcionario,bi.horas)
                        end as asistencia_dia,
                         (case
                        	when  er.id_permiso is null and
                                  vi.id_cuenta_doc is null and
                                  va.id_vacacion is null and
                                  fe.id_feriado is null and
                                  bi.horas is null and
                                  asis.f_obtener_dia_literal(pe.mes::date) not in  ('sabado','domingo') then
                            	 0
                            else
                            	 array_length(bi.horas,1)
                            end) as total_dias
                 from periodo pe
                 left join vacacion va on va.fecha_dia = pe.mes
                 left join biometrico bi on bi.dia = pe.mes
                 left join feriado fe on fe.fecha =  pe.mes
                 left join permiso er on er.fecha_solicitud = pe.mes
                 left join viaticos vi on vi.fecha_dia = pe.mes
                 order by mes)loop

                  /** Permiso (Inicio)**/
                  if v_record_dia.id_permiso is not null then
                  	 v_filtro = asis.f_obtener_rango_asignado_fun (v_parametros.id_funcionario,v_record_dia.mes);

                	/** Dia hábil de Trabajo (Inicio) **/

                    v_consulta = 'select rh.id_rango_horario,
                                          rh.hora_entrada,
                                          rh.hora_salida
                                  from asis.trango_horario rh
                                  inner join asis.tasignar_rango ar on ar.id_rango_horario = rh.id_rango_horario
                                  where '||v_filtro||'and rh.'||v_record_dia.dia_literal||' = ''si''
                                   and  '''||v_record_dia.mes||'''::date  between ar.desde and ar.hasta
                                  order by rh.hora_entrada, ar.hasta asc';

                            execute (v_consulta) into v_consulta_record;

                            -- Rango especial Asigndo
                            if v_consulta_record.id_rango_horario is not null then
							v_filtro = asis.f_obtener_rango_asignado_fun (v_parametros.id_funcionario,v_record_dia.mes);

                            	for v_rango in execute (v_consulta)loop
                                  INSERT INTO asis.tpares(id_usuario_reg,
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
                                                          )VALUES (
                                                          p_id_usuario,
                                                          null,
                                                          now(),
                                                          null,
                                                          'activo',
                                                          v_parametros._id_usuario_ai,
                                                          v_parametros._nombre_usuario_ai,
                                                          v_record_dia.mes,
                                                          (v_record_dia.mes::varchar ||' '|| v_rango.hora_entrada::varchar)::timestamp,   -- v_rango.hora_entrada,
                                                           null,
                                                          'Permiso',
                                                          'Entrada',
                                                          null,
                                                          null,
                                                          v_parametros.id_funcionario,
                                                          v_record_dia.id_permiso,--id_permiso,
                                                          null,--id_vacacion,
                                                          null,--?id_viatico,
                                                          null,
                                                          v_parametros.id_periodo,
                                                          'si',
                                                          'no',
                                                          'no',
                                                          'no',
                                                          v_rango.id_rango_horario,
                                                          null--v_record_dia.id_feriado
                                                          );

                                  INSERT INTO asis.tpares(id_usuario_reg,
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
                                                          )VALUES (
                                                          p_id_usuario,
                                                          null,
                                                          now(),
                                                          null,
                                                          'activo',
                                                          v_parametros._id_usuario_ai,
                                                          v_parametros._nombre_usuario_ai,
                                                          v_record_dia.mes,
                                                          null,
                                                          (v_record_dia.mes::varchar ||' '|| v_rango.hora_salida::varchar)::timestamp,-- v_rango.hora_salida,--?hora_fin,
                                                          'Permiso',
                                                          'Salida',
                                                          null,
                                                          null,
                                                          v_parametros.id_funcionario,
                                                          v_record_dia.id_permiso,--id_permiso,
                                                          null,--id_vacacion,
                                                          null,--?id_viatico,
                                                          null,
                                                          v_parametros.id_periodo,
                                                          'si',
                                                          'no',
                                                          'no',
                                                          'no',
                                                           v_rango.id_rango_horario,
                                                           null--v_record_dia.id_feriado
                                                           ); -- v_rango.id_rango_horario
                               end loop;

                           	 else
                            -- Rango Genera Asigndo
                                v_consulta = 'select rh.id_rango_horario,
                                                      rh.hora_entrada,
                                                      rh.hora_salida
                                              from asis.trango_horario rh
                                              inner join asis.tasignar_rango ar on ar.id_rango_horario = rh.id_rango_horario
                                              where '||v_filtro||'and rh.'||v_record_dia.dia_literal||' = ''si''
                                               and  '''||v_record_dia.mes||'''::date >= ar.desde  and ar.hasta is null
                                            order by rh.hora_entrada, ar.hasta asc';

                                   	for v_rango in execute (v_consulta)loop

                                 INSERT INTO asis.tpares(id_usuario_reg,
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
                                                          )VALUES (
                                                          p_id_usuario,
                                                          null,
                                                          now(),
                                                          null,
                                                          'activo',
                                                          v_parametros._id_usuario_ai,
                                                          v_parametros._nombre_usuario_ai,
                                                          v_record_dia.mes,
                                                          (v_record_dia.mes::varchar ||' '|| v_rango.hora_entrada::varchar)::timestamp,   -- v_rango.hora_entrada,
                                                           null,
                                                          'Permiso',
                                                          'Entrada',
                                                          null,
                                                          null,
                                                          v_parametros.id_funcionario,
                                                          v_record_dia.id_permiso,--id_permiso,
                                                          null,--id_vacacion,
                                                          null,--?id_viatico,
                                                          null,
                                                          v_parametros.id_periodo,
                                                          'si',
                                                          'no',
                                                          'no',
                                                          'no',
                                                          v_rango.id_rango_horario,
                                                          null--v_record_dia.id_feriado
                                                          ); --

                                  INSERT INTO asis.tpares(id_usuario_reg,
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
                                                          )VALUES (
                                                          p_id_usuario,
                                                          null,
                                                          now(),
                                                          null,
                                                          'activo',
                                                          v_parametros._id_usuario_ai,
                                                          v_parametros._nombre_usuario_ai,
                                                          v_record_dia.mes,
                                                          null,
                                                          (v_record_dia.mes::varchar ||' '|| v_rango.hora_salida::varchar)::timestamp,-- v_rango.hora_salida,--?hora_fin,
                                                          'Permiso',
                                                          'Salida',
                                                          null,
                                                          null,
                                                          v_parametros.id_funcionario,
                                                          v_record_dia.id_permiso,--id_permiso,
                                                          null,--id_vacacion,
                                                          null,--?id_viatico,
                                                          null,
                                                          v_parametros.id_periodo,
                                                          'si',
                                                          'no',
                                                          'no',
                                                          'no',
                                                           v_rango.id_rango_horario,
                                                           null--v_record_dia.id_feriado
                                                           ); -- v_rango.id_rango_horario
                               end loop;

                            end if;
                  end if;
                   /** Permiso (Fin) **/

                   /** Viaticos (Inicio)**/
                  if v_record_dia.id_cuenta_doc is not null then
                  	raise notice 'Entra';
                  end if;
                   /** Viaticos (Fin) **/

                   /** Vacaciones (Inicio)**/
                  if v_record_dia.id_vacacion is not null then
                  v_filtro = asis.f_obtener_rango_asignado_fun (v_parametros.id_funcionario,v_record_dia.mes);

                	/** Dia hábil de Trabajo (Inicio) **/

                    v_consulta = 'select rh.id_rango_horario,
                                          rh.hora_entrada,
                                          rh.hora_salida
                                  from asis.trango_horario rh
                                  inner join asis.tasignar_rango ar on ar.id_rango_horario = rh.id_rango_horario
                                  where '||v_filtro||'and rh.'||v_record_dia.dia_literal||' = ''si''
                                   and  '''||v_record_dia.mes||'''::date  between ar.desde and ar.hasta
                                  order by rh.hora_entrada, ar.hasta asc';

                            execute (v_consulta) into v_consulta_record;

                            -- Rango especial Asigndo
                            if v_consulta_record.id_rango_horario is not null then
							v_filtro = asis.f_obtener_rango_asignado_fun (v_parametros.id_funcionario,v_record_dia.mes);

                            	for v_rango in execute (v_consulta)loop
                                  INSERT INTO asis.tpares(id_usuario_reg,
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
                                                          )VALUES (
                                                          p_id_usuario,
                                                          null,
                                                          now(),
                                                          null,
                                                          'activo',
                                                          v_parametros._id_usuario_ai,
                                                          v_parametros._nombre_usuario_ai,
                                                          v_record_dia.mes,
                                                          (v_record_dia.mes::varchar ||' '|| v_rango.hora_entrada::varchar)::timestamp,   -- v_rango.hora_entrada,
                                                           null,
                                                          'Vacacion',
                                                          'Entrada',
                                                          null,
                                                          null,
                                                          v_parametros.id_funcionario,
                                                          null,--id_permiso,
                                                          v_record_dia.id_vacacion,--id_vacacion,
                                                          null,--?id_viatico,
                                                          null,
                                                          v_parametros.id_periodo,
                                                          'si',
                                                          'no',
                                                          'no',
                                                          'no',
                                                          v_rango.id_rango_horario,
                                                          null--v_record_dia.id_feriado
                                                          );

                                  INSERT INTO asis.tpares(id_usuario_reg,
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
                                                          )VALUES (
                                                          p_id_usuario,
                                                          null,
                                                          now(),
                                                          null,
                                                          'activo',
                                                          v_parametros._id_usuario_ai,
                                                          v_parametros._nombre_usuario_ai,
                                                          v_record_dia.mes,
                                                          null,
                                                          (v_record_dia.mes::varchar ||' '|| v_rango.hora_salida::varchar)::timestamp,-- v_rango.hora_salida,--?hora_fin,
                                                          'Vacacion',
                                                          'Salida',
                                                          null,
                                                          null,
                                                          v_parametros.id_funcionario,
                                                          null,--id_permiso,
                                                          v_record_dia.id_vacacion,--id_vacacion,
                                                          null,--?id_viatico,
                                                          null,
                                                          v_parametros.id_periodo,
                                                          'si',
                                                          'no',
                                                          'no',
                                                          'no',
                                                           v_rango.id_rango_horario,
                                                           null--v_record_dia.id_feriado
                                                           ); -- v_rango.id_rango_horario
                               end loop;

                           	 else
                            -- Rango Genera Asigndo
                                v_consulta = 'select rh.id_rango_horario,
                                                      rh.hora_entrada,
                                                      rh.hora_salida
                                              from asis.trango_horario rh
                                              inner join asis.tasignar_rango ar on ar.id_rango_horario = rh.id_rango_horario
                                              where '||v_filtro||'and rh.'||v_record_dia.dia_literal||' = ''si''
                                               and  '''||v_record_dia.mes||'''::date >= ar.desde  and ar.hasta is null
                                            order by rh.hora_entrada, ar.hasta asc';

                                   	for v_rango in execute (v_consulta)loop

                                 INSERT INTO asis.tpares(id_usuario_reg,
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
                                                          )VALUES (
                                                          p_id_usuario,
                                                          null,
                                                          now(),
                                                          null,
                                                          'activo',
                                                          v_parametros._id_usuario_ai,
                                                          v_parametros._nombre_usuario_ai,
                                                          v_record_dia.mes,
                                                          (v_record_dia.mes::varchar ||' '|| v_rango.hora_entrada::varchar)::timestamp,   -- v_rango.hora_entrada,
                                                           null,
                                                          'Vacacion',
                                                          'Entrada',
                                                          null,
                                                          null,
                                                          v_parametros.id_funcionario,
                                                          null,--id_permiso,
                                                          v_record_dia.id_vacacion,--id_vacacion,
                                                          null,--?id_viatico,
                                                          null,
                                                          v_parametros.id_periodo,
                                                          'si',
                                                          'no',
                                                          'no',
                                                          'no',
                                                          v_rango.id_rango_horario,
                                                          null--v_record_dia.id_feriado
                                                          ); --

                                  INSERT INTO asis.tpares(id_usuario_reg,
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
                                                          )VALUES (
                                                          p_id_usuario,
                                                          null,
                                                          now(),
                                                          null,
                                                          'activo',
                                                          v_parametros._id_usuario_ai,
                                                          v_parametros._nombre_usuario_ai,
                                                          v_record_dia.mes,
                                                          null,
                                                          (v_record_dia.mes::varchar ||' '|| v_rango.hora_salida::varchar)::timestamp,-- v_rango.hora_salida,--?hora_fin,
                                                          'Vacacion',
                                                          'Salida',
                                                          null,
                                                          null,
                                                          v_parametros.id_funcionario,
                                                          null,--id_permiso,
                                                          v_record_dia.id_vacacion,--id_vacacion,
                                                          null,--?id_viatico,
                                                          null,
                                                          v_parametros.id_periodo,
                                                          'si',
                                                          'no',
                                                          'no',
                                                          'no',
                                                           v_rango.id_rango_horario,
                                                           null--v_record_dia.id_feriado
                                                           ); -- v_rango.id_rango_horario
                               end loop;

                            end if;
                  end if;
                   /** Vacaciones (Fin) **/

                   /** Feriado (Inicio)**/
                  if v_record_dia.id_feriado is not null then
                  		 v_filtro = asis.f_obtener_rango_asignado_fun (v_parametros.id_funcionario,v_record_dia.mes);

                	/** Dia hábil de Trabajo (Inicio) **/

                    v_consulta = 'select rh.id_rango_horario,
                                          rh.hora_entrada,
                                          rh.hora_salida
                                  from asis.trango_horario rh
                                  inner join asis.tasignar_rango ar on ar.id_rango_horario = rh.id_rango_horario
                                  where '||v_filtro||'and rh.'||v_record_dia.dia_literal||' = ''si''
                                   and  '''||v_record_dia.mes||'''::date  between ar.desde and ar.hasta
                                  order by rh.hora_entrada, ar.hasta asc';

                            execute (v_consulta) into v_consulta_record;

                            -- Rango especial Asigndo
                            if v_consulta_record.id_rango_horario is not null then
								                    v_filtro = asis.f_obtener_rango_asignado_fun (v_parametros.id_funcionario,v_record_dia.mes);

                            	for v_rango in execute (v_consulta)loop

                                  INSERT INTO asis.tpares(id_usuario_reg,
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
                                                          )VALUES (
                                                          p_id_usuario,
                                                          null,
                                                          now(),
                                                          null,
                                                          'activo',
                                                          v_parametros._id_usuario_ai,
                                                          v_parametros._nombre_usuario_ai,
                                                          v_record_dia.mes,
                                                          (v_record_dia.mes::varchar ||' '|| v_rango.hora_entrada::varchar)::timestamp,   -- v_rango.hora_entrada,
                                                           null,
                                                          'Feriado',
                                                          'Entrada',
                                                          null,
                                                          null,
                                                          v_parametros.id_funcionario,
                                                          null,--id_permiso,
                                                          null,--id_vacacion,
                                                          null,--?id_viatico,
                                                          null,
                                                          v_parametros.id_periodo,
                                                          'si',
                                                          'no',
                                                          'no',
                                                          'no',
                                                          v_rango.id_rango_horario,
                                                          v_record_dia.id_feriado
                                                          ); -- v_rango.id_rango_horario

                                  INSERT INTO asis.tpares(id_usuario_reg,
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
                                                          )VALUES (
                                                          p_id_usuario,
                                                          null,
                                                          now(),
                                                          null,
                                                          'activo',
                                                          v_parametros._id_usuario_ai,
                                                          v_parametros._nombre_usuario_ai,
                                                          v_record_dia.mes,
                                                          null,
                                                          (v_record_dia.mes::varchar ||' '|| v_rango.hora_salida::varchar)::timestamp,-- v_rango.hora_salida,--?hora_fin,
                                                          'Feriado',
                                                          'Salida',
                                                          null,
                                                          null,
                                                          v_parametros.id_funcionario,
                                                          null,--id_permiso,
                                                          null,--id_vacacion,
                                                          null,--?id_viatico,
                                                          null,
                                                          v_parametros.id_periodo,
                                                          'si',
                                                          'no',
                                                          'no',
                                                          'no',
                                                           v_rango.id_rango_horario,
                                                           v_record_dia.id_feriado); -- v_rango.id_rango_horario
                               end loop;

                           	 else
                            -- Rango Genera Asigndo
                                v_consulta = 'select rh.id_rango_horario,
                                                      rh.hora_entrada,
                                                      rh.hora_salida
                                              from asis.trango_horario rh
                                              inner join asis.tasignar_rango ar on ar.id_rango_horario = rh.id_rango_horario
                                              where '||v_filtro||'and rh.'||v_record_dia.dia_literal||' = ''si''
                                               and  '''||v_record_dia.mes||'''::date >= ar.desde  and ar.hasta is null
                                            order by rh.hora_entrada, ar.hasta asc';

                                   	for v_rango in execute (v_consulta)loop

                                 INSERT INTO asis.tpares(id_usuario_reg,
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
                                                          )VALUES (
                                                          p_id_usuario,
                                                          null,
                                                          now(),
                                                          null,
                                                          'activo',
                                                          v_parametros._id_usuario_ai,
                                                          v_parametros._nombre_usuario_ai,
                                                          v_record_dia.mes,
                                                          (v_record_dia.mes::varchar ||' '|| v_rango.hora_entrada::varchar)::timestamp,   -- v_rango.hora_entrada,
                                                           null,
                                                          'Feriado',
                                                          'Entrada',
                                                          null,
                                                          null,
                                                          v_parametros.id_funcionario,
                                                          null,--id_permiso,
                                                          null,--id_vacacion,
                                                          null,--?id_viatico,
                                                          null,
                                                          v_parametros.id_periodo,
                                                          'si',
                                                          'no',
                                                          'no',
                                                          'no',
                                                          v_rango.id_rango_horario,
                                                          v_record_dia.id_feriado); --

                                  INSERT INTO asis.tpares(id_usuario_reg,
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
                                                          )VALUES (
                                                          p_id_usuario,
                                                          null,
                                                          now(),
                                                          null,
                                                          'activo',
                                                          v_parametros._id_usuario_ai,
                                                          v_parametros._nombre_usuario_ai,
                                                          v_record_dia.mes,
                                                          null,
                                                          (v_record_dia.mes::varchar ||' '|| v_rango.hora_salida::varchar)::timestamp,-- v_rango.hora_salida,--?hora_fin,
                                                          'Feriado',
                                                          'Salida',
                                                          null,
                                                          null,
                                                          v_parametros.id_funcionario,
                                                          null,--id_permiso,
                                                          null,--id_vacacion,
                                                          null,--?id_viatico,
                                                          null,
                                                          v_parametros.id_periodo,
                                                          'si',
                                                          'no',
                                                          'no',
                                                          'no',
                                                           v_rango.id_rango_horario,
                                                           v_record_dia.id_feriado); -- v_rango.id_rango_horario
                               end loop;

                            end if;
                  end if;
                   /** Feriado (Fin) **/


          if v_record_dia.total_dias = 0 and v_record_dia.asistencia_dia is null then
                    v_filtro = asis.f_obtener_rango_asignado_fun (v_parametros.id_funcionario,v_record_dia.mes);

                	/** Dia hábil de Trabajo (Inicio) **/

                    v_consulta = 'select rh.id_rango_horario,
                                          rh.hora_entrada,
                                          rh.hora_salida
                                  from asis.trango_horario rh
                                  inner join asis.tasignar_rango ar on ar.id_rango_horario = rh.id_rango_horario
                                  where '||v_filtro||'and rh.'||v_record_dia.dia_literal||' = ''si''
                                   and  '''||v_record_dia.mes||'''::date  between ar.desde and ar.hasta
                                  order by rh.hora_entrada, ar.hasta asc';

                            execute (v_consulta) into v_consulta_record;

                            -- Rango especial Asigndo
                            if v_consulta_record.id_rango_horario is not null then
							v_filtro = asis.f_obtener_rango_asignado_fun (v_parametros.id_funcionario,v_record_dia.mes);

                            	for v_rango in execute (v_consulta)loop

                                  INSERT INTO asis.tpares(id_usuario_reg,
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
                                                          )VALUES (
                                                          p_id_usuario,
                                                          null,
                                                          now(),
                                                          null,
                                                          'activo',
                                                          v_parametros._id_usuario_ai,
                                                          v_parametros._nombre_usuario_ai,
                                                          v_record_dia.mes,
                                                          (v_record_dia.mes::varchar ||' '|| v_rango.hora_entrada::varchar)::timestamp,   -- v_rango.hora_entrada,
                                                           null,
                                                          'No tienes Registrado Permisos o Vacaciones No tienes Marcas en Biometrico',
                                                          'Entrada',
                                                          null,
                                                          null,
                                                          v_parametros.id_funcionario,
                                                          null,--id_permiso,
                                                          null,--id_vacacion,
                                                          null,--?id_viatico,
                                                          null,
                                                          v_parametros.id_periodo,
                                                          'no',
                                                          'no',
                                                          'no',
                                                          'no',
                                                          v_rango.id_rango_horario,
                                                          v_record_dia.id_feriado); -- v_rango.id_rango_horario

                                  INSERT INTO asis.tpares(id_usuario_reg,
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
                                                          )VALUES (
                                                          p_id_usuario,
                                                          null,
                                                          now(),
                                                          null,
                                                          'activo',
                                                          v_parametros._id_usuario_ai,
                                                          v_parametros._nombre_usuario_ai,
                                                          v_record_dia.mes,
                                                          null,
                                                          (v_record_dia.mes::varchar ||' '|| v_rango.hora_salida::varchar)::timestamp,-- v_rango.hora_salida,--?hora_fin,
                                                          'No tienes Registrado Permisos o Vacaciones No tienes Marcas en Biometrico',
                                                          'Salida',
                                                          null,
                                                          null,
                                                          v_parametros.id_funcionario,
                                                          null,--id_permiso,
                                                          null,--id_vacacion,
                                                          null,--?id_viatico,
                                                          null,
                                                          v_parametros.id_periodo,
                                                          'no',
                                                          'no',
                                                          'no',
                                                          'no',
                                                           v_rango.id_rango_horario,
                                                           v_record_dia.id_feriado); -- v_rango.id_rango_horario
                               end loop;

                           	 else


                            -- Rango Genera Asigndo
                                v_consulta = 'select rh.id_rango_horario,
                                                      rh.hora_entrada,
                                                      rh.hora_salida
                                              from asis.trango_horario rh
                                              inner join asis.tasignar_rango ar on ar.id_rango_horario = rh.id_rango_horario
                                              where '||v_filtro||'and rh.'||v_record_dia.dia_literal||' = ''si''
                                               and  '''||v_record_dia.mes||'''::date >= ar.desde  and ar.hasta is null
                                            order by rh.hora_entrada, ar.hasta asc';

                                   	for v_rango in execute (v_consulta)loop

                                 INSERT INTO asis.tpares(id_usuario_reg,
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
                                                          id_rango_horario
                                                          )VALUES (
                                                          p_id_usuario,
                                                          null,
                                                          now(),
                                                          null,
                                                          'activo',
                                                          v_parametros._id_usuario_ai,
                                                          v_parametros._nombre_usuario_ai,
                                                          v_record_dia.mes,
                                                          (v_record_dia.mes::varchar ||' '|| v_rango.hora_entrada::varchar)::timestamp,   -- v_rango.hora_entrada,
                                                           null,
                                                          'No tienes Registrado Permisos o Vacaciones No tienes Marcas en Biometrico',
                                                          'Entrada',
                                                          null,
                                                          null,
                                                          v_parametros.id_funcionario,
                                                          null,--id_permiso,
                                                          null,--id_vacacion,
                                                          null,--?id_viatico,
                                                          null,
                                                          v_parametros.id_periodo,
                                                          'no',
                                                          'no',
                                                          'no',
                                                          'no',
                                                          v_rango.id_rango_horario); --

                                  INSERT INTO asis.tpares(id_usuario_reg,
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
                                                          id_rango_horario
                                                          )VALUES (
                                                          p_id_usuario,
                                                          null,
                                                          now(),
                                                          null,
                                                          'activo',
                                                          v_parametros._id_usuario_ai,
                                                          v_parametros._nombre_usuario_ai,
                                                          v_record_dia.mes,
                                                          null,
                                                          (v_record_dia.mes::varchar ||' '|| v_rango.hora_salida::varchar)::timestamp,-- v_rango.hora_salida,--?hora_fin,
                                                          'No tienes Registrado Permisos o Vacaciones No tienes Marcas en Biometrico',
                                                          'Salida',
                                                          null,
                                                          null,
                                                          v_parametros.id_funcionario,
                                                          null,--id_permiso,
                                                          null,--id_vacacion,
                                                          null,--?id_viatico,
                                                          null,
                                                          v_parametros.id_periodo,
                                                          'no',
                                                          'no',
                                                          'no',
                                                          'no',
                                                           v_rango.id_rango_horario); -- v_rango.id_rango_horario
                               end loop;

                            end if;

                            /** Dia hábil de Trabajo (Fin)
                    			Cuando funcionario no tiene permios vacacion y marcas biometrico **/


                else
					/**Generar pares y completar (Inicio)**/
                   if not asis.f_pares(v_parametros.id_funcionario,
                                       v_record_dia.asistencia_dia,
                                       p_id_usuario,
                                       v_record_dia.mes)then
                        raise exception 'Ocurrio un error comuniquese con el administrador';
                    end if;
                    /**Generar pares y completar (Fin)**/
                end if;



      end loop;

      /**Justificar Horas fuera de rango (Inicio)**/
      v_resultador = null;
      v_resultador_time = null;
      for v_fuera_rango in (select 	  ntl.fecha,
                                      asis.array_sort(string_to_array(pxp.list(ntl.event_time::text),',')) as array_dia
                              from asis.ttransacc_zkb_etl ntl
                              where ntl.id_funcionario = v_parametros.id_funcionario
                              and ntl.fecha between v_fecha_ini and v_fecha_fin
                              and ntl.rango = 'no' and ntl.id_rango_horario is null
                              group by ntl.fecha
                              order by ntl.fecha)loop

                      if array_length(v_fuera_rango.array_dia,1) = 1 then

                        foreach v_hora_nr in array v_fuera_rango.array_dia loop

                         select  etl.id ,etl.event_time,etl.acceso
                                          into
                                          v_marcaciones
                                  from asis.ttransacc_zkb_etl etl
                                  where etl.id_funcionario = v_parametros.id_funcionario
                                  and etl.event_time = v_hora_nr::timestamp;

                         INSERT INTO asis.tpares(id_usuario_reg,
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
                                                          id_rango_horario
                                                          )VALUES (
                                                          p_id_usuario,
                                                          null,
                                                          now(),
                                                          null,
                                                          'activo',
                                                          v_parametros._id_usuario_ai,
                                                          v_parametros._nombre_usuario_ai,
                                                          v_fuera_rango.fecha,
                                                          ---v_evente_times[1]
                                                          (case
                                                           when v_marcaciones.acceso = 'Entrada' then
                                                                v_marcaciones.event_time
                                                           else
                                                                null
                                                          end),
                      										(case
                                                           when v_marcaciones.acceso = 'Salida' then
                                                                v_marcaciones.event_time
                                                           else
                                                                null
                                                          end),
                                                          'Justificar horas fuera de rango',
                                                          v_marcaciones.acceso,
                                                          (case
                                                           when v_marcaciones.acceso = 'Entrada' then
                                                                v_marcaciones.id
                                                           else
                                                                null
                                                          end),
                      										(case
                                                           when v_marcaciones.acceso = 'Salida' then
                                                                v_marcaciones.id
                                                           else
                                                                null
                                                          end),
                                                          v_parametros.id_funcionario,
                                                          null,--id_permiso,
                                                          null,--id_vacacion,
                                                          null,--?id_viatico,
                                                          null,
                                                          v_parametros.id_periodo,
                                                          'no',
                                                          'si',
                                                          'no',
                                                          'no',
                                                           null --v_rango.id_rango_horario
                                                           );
                       end loop;

                      else
                      foreach v_hora_nr in array v_fuera_rango.array_dia loop

                                 v_resultador_time = array_append(v_resultador,v_hora_nr::varchar);
                                  select  etl.id ,etl.event_time
                                          into
                                          v_marcaciones
                                  from asis.ttransacc_zkb_etl etl
                                  where etl.id_funcionario = v_parametros.id_funcionario
                                  and etl.event_time = v_hora_nr::timestamp;

                                  v_resultador =  array_append(v_resultador,v_marcaciones.id::varchar);
                                  v_evente_times = array_append(v_evente_times,v_marcaciones.event_time);

                                  if array_length(v_resultador,1) = 2 then

                                  	INSERT INTO asis.tpares(id_usuario_reg,
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
                                                          id_rango_horario
                                                          )VALUES (
                                                          p_id_usuario,
                                                          null,
                                                          now(),
                                                          null,
                                                          'activo',
                                                          v_parametros._id_usuario_ai,
                                                          v_parametros._nombre_usuario_ai,
                                                          v_fuera_rango.fecha,
                                                          v_evente_times[1],--v_resultador_time[1]::timestamp ,-- (v_fuera_rango.fecha::varchar ||' '|| to_char( v_resultador[1]::timestamp, 'HH24:MI')::varchar )::timestamp,-- v_rango.hora_salida,--?hora_fin,,
                                                          v_evente_times[2],--v_resultador_time[2]::timestamp ,-- (v_fuera_rango.fecha::varchar ||' '|| v_resultador[2]::varchar)::timestamp,-- v_rango.hora_salida,--?hora_fin,
                                                          'Justificar horas fuera de rango',
                                                          'Entrada - Salida',
                                                          v_resultador[1]::integer,
                                                          v_resultador[2]::integer,
                                                          v_parametros.id_funcionario,
                                                          null,--id_permiso,
                                                          null,--id_vacacion,
                                                          null,--?id_viatico,
                                                          null,
                                                          v_parametros.id_periodo,
                                                          'no',
                                                          'no',
                                                          'no',
                                                          'no',
                                                           null --v_rango.id_rango_horario
                                                           );

                                  v_resultador = null;
                                  v_evente_times = null;

                                  end if;

                           end loop;
                      end if;


      end loop;

      v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Marcados Pares almacenado(a) con exito');
      v_resp = pxp.f_agrega_clave(v_resp,'id_funcionario',v_parametros.id_funcionario::varchar);

      --Devuelve la respuesta
      return v_resp;

	end;
    /*********************************
 	#TRANSACCION:  'ASIS_INP_INS'
 	#DESCRIPCION:	Generar Par
 	#AUTOR:		MMV
 	#FECHA:		29-11-2019
	***********************************/

	elsif(p_transaccion='ASIS_INP_INS')then

		begin

          select  pe.periodo,
                  pe.fecha_ini,
                  pe.fecha_fin
              into
              v_periodo,
              v_fecha_ini,
              v_fecha_fin
      from param.tperiodo pe
      where pe.id_periodo = v_parametros.id_periodo;

     -- raise exception '%  v_fecha_ini % v_fecha_fin%',v_parametros.id_funcionario,v_fecha_ini,v_fecha_fin;
        delete from asis.tpares pa
		where pa.id_funcionario = v_parametros.id_funcionario and pa.id_periodo = v_parametros.id_periodo;--562

      for v_record_dia in (with periodo as (select mes::date as mes
                           from generate_series(v_fecha_ini,v_fecha_fin, '1 day'::interval) mes),
               permiso as (select pe.id_permiso,
                                  pe.fecha_solicitud
                         from asis.tpermiso pe
                         where pe.fecha_solicitud between v_fecha_ini and  v_fecha_fin
                         and pe.id_funcionario = v_parametros.id_funcionario),
               vacacion as ( select va.id_vacacion,
                                   dv.fecha_dia
                                  from asis.tvacacion va
                                  inner join asis.tvacacion_det dv on dv.id_vacacion = va.id_vacacion
                                  where va.id_funcionario = v_parametros.id_funcionario
                                  and  va.fecha_inicio >=v_fecha_ini and va.fecha_fin <= v_fecha_fin
                                  and va.estado = 'aprobado'
                                  order by fecha_dia),
               viaticos as (select cu.id_cuenta_doc,
                                   unnest( string_to_array((select pxp.list(mes::date::text)
                                        from generate_series(cu.fecha_salida,cu.fecha_llegada, '1 day'::interval) mes),','))::date as fecha_dia
                            from cd.tcuenta_doc cu
                            where cu.estado = 'pendiente'
                            and (v_parametros.id_funcionario = ANY (cu.id_funcionarios) or cu.id_funcionario = v_parametros.id_funcionario)
                            and  cu.fecha_salida >= v_fecha_ini and cu.fecha_llegada <= v_fecha_fin
                            order by fecha_dia),
               feriado as ( select  fe.id_feriado,
                                    fe.fecha
                          from param.tferiado fe
                          where fe.fecha between v_fecha_ini and v_fecha_fin
                          order by fecha),
              biometrico as (select ma.dia,
                              asis.array_sort (string_to_array(pxp.list(ma.hora::text),','))  as horas
                        from ( select etl.fecha as dia,
                                      etl.event_time as hora
                          from asis.ttransacc_zkb_etl etl
                          where etl.id_funcionario = v_parametros.id_funcionario
                          and etl.rango = 'si'
                          order by hora ) as ma
                          where dia between v_fecha_ini and v_fecha_fin
                          group by ma.dia
                          order by dia)
                           select asis.f_obtener_dia_literal(pe.mes::date) as dia_literal,
                                  pe.mes,
                                  extract(dow from pe.mes) as dia,
                                  er.id_permiso,
                                  vi.id_cuenta_doc,
                                  va.id_vacacion,
                                  fe.id_feriado,
                                  bi.horas,
                                   (case
                                      when  er.id_permiso is null and
                                            vi.id_cuenta_doc is null and
                                            va.id_vacacion is null and
                                            fe.id_feriado is null and
                                            bi.horas is null and
                                            asis.f_obtener_dia_literal(pe.mes::date) not in  ('sabado','domingo') then
                                           0
                                      else
                                           array_length(bi.horas,1)
                                      end) as total_dias
                           from periodo pe
                           left join vacacion va on va.fecha_dia = pe.mes
                           left join biometrico bi on bi.dia = pe.mes
                           left join feriado fe on fe.fecha =  pe.mes
                           left join permiso er on er.fecha_solicitud = pe.mes
                           left join viaticos vi on vi.fecha_dia = pe.mes
                           order by mes)loop

          		  /** Permiso (Inicio)**/
                  if v_record_dia.id_permiso is not null then
           				if not asis.f_insertar_registro(v_parametros.id_funcionario,
                        								v_record_dia.id_permiso,
                                                        null, --p_id_cuenta_doc
                                                        null, --p_id_vacacion
                                                        null,  --p_id_feriado
                                                        v_record_dia.mes,
                                                        v_record_dia.dia_literal,
                                                        p_id_usuario,
                                                        v_parametros.id_periodo
                                                        )then
                        	raise exception 'Error al insertar el perimiso';
                         end if;
                  end if;
                   /** Permiso (Fin) **/

                   /** Viaticos (Inicio)**/
                  if v_record_dia.id_cuenta_doc is not null then
                  	if not asis.f_insertar_registro(v_parametros.id_funcionario,
                                                    null, --v_record_dia.id_permiso,
                                                    v_record_dia.id_cuenta_doc, --p_id_cuenta_doc
                                                    null, --p_id_vacacion
                                                    null,  --p_id_feriado
                                                    v_record_dia.mes,
                                                    v_record_dia.dia_literal,
                                                    p_id_usuario,
                                                    v_parametros.id_periodo
                                                    )then
                        	raise exception 'Error al insertar el perimiso';
                     end if;
                  end if;
                   /** Viaticos (Fin) **/

                   /** Vacaciones (Inicio)**/
                  if v_record_dia.id_vacacion is not null then
                  	if not asis.f_insertar_registro(v_parametros.id_funcionario,
                                                    null, --v_record_dia.id_permiso,
                                                    null, --p_id_cuenta_doc
                                                    v_record_dia.id_vacacion, --p_id_vacacion
                                                    null,  --p_id_feriado
                                                    v_record_dia.mes,
                                                    v_record_dia.dia_literal,
                                                    p_id_usuario,
                                                    v_parametros.id_periodo
                                                    )then
                        	raise exception 'Error al insertar el perimiso';
                     end if;
                  end if;
                   /** Vacaciones (Fin) **/

                   /** Feriado (Inicio)**/
                  if v_record_dia.id_feriado is not null then
                  	if not asis.f_insertar_registro(v_parametros.id_funcionario,
                                                    null, --v_record_dia.id_permiso,
                                                    null, --p_id_cuenta_doc
                                                    null, --p_id_vacacion
                                                    v_record_dia.id_feriado,  --p_id_feriado
                                                    v_record_dia.mes,
                                                    v_record_dia.dia_literal,
                                                    p_id_usuario,
                                                    v_parametros.id_periodo
                                                    )then
                        	raise exception 'Error al insertar el perimiso';
                     end if;
                  end if;
                   /** Feriado (Fin) **/

                if v_record_dia.total_dias = 0 and v_record_dia.horas is null then

                       v_filtro = asis.f_obtener_rango_asignado_fun (v_parametros.id_funcionario,v_record_dia.mes);

                	/** Dia hábil de Trabajo (Inicio) **/

                    v_consulta = 'select rh.id_rango_horario,
                                          rh.hora_entrada,
                                          rh.hora_salida
                                  from asis.trango_horario rh
                                  inner join asis.tasignar_rango ar on ar.id_rango_horario = rh.id_rango_horario
                                  where '||v_filtro||'and rh.'||v_record_dia.dia_literal||' = ''si''
                                   and  '''||v_record_dia.mes||'''::date  between ar.desde and ar.hasta
                                  order by rh.hora_entrada, ar.hasta asc';

                            execute (v_consulta) into v_consulta_record;

                            -- Rango especial Asigndo
                            if v_consulta_record.id_rango_horario is not null then
							v_filtro = asis.f_obtener_rango_asignado_fun (v_parametros.id_funcionario,v_record_dia.mes);

                            	for v_rango in execute (v_consulta)loop

                                  INSERT INTO asis.tpares(id_usuario_reg,
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
                                                          )VALUES (
                                                          p_id_usuario,
                                                          null,
                                                          now(),
                                                          null,
                                                          'activo',
                                                          v_parametros._id_usuario_ai,
                                                          v_parametros._nombre_usuario_ai,
                                                          v_record_dia.mes,
                                                          (v_record_dia.mes::varchar ||' '|| v_rango.hora_entrada::varchar)::timestamp,   -- v_rango.hora_entrada,
                                                           null,
                                                          'No tienes Registrado Permisos o Vacaciones No tienes Marcas en Biometrico',
                                                          'Entrada',
                                                          null,
                                                          null,
                                                          v_parametros.id_funcionario,
                                                          null,--id_permiso,
                                                          null,--id_vacacion,
                                                          null,--?id_viatico,
                                                          null,
                                                          v_parametros.id_periodo,
                                                          'no',
                                                          'no',
                                                          'no',
                                                          'no',
                                                          v_rango.id_rango_horario,
                                                          v_record_dia.id_feriado); -- v_rango.id_rango_horario

                                  INSERT INTO asis.tpares(id_usuario_reg,
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
                                                          )VALUES (
                                                          p_id_usuario,
                                                          null,
                                                          now(),
                                                          null,
                                                          'activo',
                                                          v_parametros._id_usuario_ai,
                                                          v_parametros._nombre_usuario_ai,
                                                          v_record_dia.mes,
                                                          null,
                                                          (v_record_dia.mes::varchar ||' '|| v_rango.hora_salida::varchar)::timestamp,-- v_rango.hora_salida,--?hora_fin,
                                                          'No tienes Registrado Permisos o Vacaciones No tienes Marcas en Biometrico',
                                                          'Salida',
                                                          null,
                                                          null,
                                                          v_parametros.id_funcionario,
                                                          null,--id_permiso,
                                                          null,--id_vacacion,
                                                          null,--?id_viatico,
                                                          null,
                                                          v_parametros.id_periodo,
                                                          'no',
                                                          'no',
                                                          'no',
                                                          'no',
                                                           v_rango.id_rango_horario,
                                                           v_record_dia.id_feriado); -- v_rango.id_rango_horario
                               end loop;

                           	 else


                            -- Rango Genera Asigndo
                                v_consulta = 'select rh.id_rango_horario,
                                                      rh.hora_entrada,
                                                      rh.hora_salida
                                              from asis.trango_horario rh
                                              inner join asis.tasignar_rango ar on ar.id_rango_horario = rh.id_rango_horario
                                              where '||v_filtro||'and rh.'||v_record_dia.dia_literal||' = ''si''
                                               and  '''||v_record_dia.mes||'''::date >= ar.desde  and ar.hasta is null
                                            order by rh.hora_entrada, ar.hasta asc';

                                   	for v_rango in execute (v_consulta)loop

                                 INSERT INTO asis.tpares(id_usuario_reg,
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
                                                          id_rango_horario
                                                          )VALUES (
                                                          p_id_usuario,
                                                          null,
                                                          now(),
                                                          null,
                                                          'activo',
                                                          v_parametros._id_usuario_ai,
                                                          v_parametros._nombre_usuario_ai,
                                                          v_record_dia.mes,
                                                          (v_record_dia.mes::varchar ||' '|| v_rango.hora_entrada::varchar)::timestamp,   -- v_rango.hora_entrada,
                                                           null,
                                                          'No tienes Registrado Permisos o Vacaciones No tienes Marcas en Biometrico',
                                                          'Entrada',
                                                          null,
                                                          null,
                                                          v_parametros.id_funcionario,
                                                          null,--id_permiso,
                                                          null,--id_vacacion,
                                                          null,--?id_viatico,
                                                          null,
                                                          v_parametros.id_periodo,
                                                          'no',
                                                          'no',
                                                          'no',
                                                          'no',
                                                          v_rango.id_rango_horario); --

                                  INSERT INTO asis.tpares(id_usuario_reg,
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
                                                          id_rango_horario
                                                          )VALUES (
                                                          p_id_usuario,
                                                          null,
                                                          now(),
                                                          null,
                                                          'activo',
                                                          v_parametros._id_usuario_ai,
                                                          v_parametros._nombre_usuario_ai,
                                                          v_record_dia.mes,
                                                          null,
                                                          (v_record_dia.mes::varchar ||' '|| v_rango.hora_salida::varchar)::timestamp,-- v_rango.hora_salida,--?hora_fin,
                                                          'No tienes Registrado Permisos o Vacaciones No tienes Marcas en Biometrico',
                                                          'Salida',
                                                          null,
                                                          null,
                                                          v_parametros.id_funcionario,
                                                          null,--id_permiso,
                                                          null,--id_vacacion,
                                                          null,--?id_viatico,
                                                          null,
                                                          v_parametros.id_periodo,
                                                          'no',
                                                          'no',
                                                          'no',
                                                          'no',
                                                           v_rango.id_rango_horario); -- v_rango.id_rango_horario
                               end loop;

                            end if;

                else
					/**Generar pares y completar (Inicio)**/

                   if not asis.f_imsert_pares(v_parametros.id_funcionario,
                                              v_record_dia.horas,
                                              p_id_usuario,
                                              v_record_dia.mes)then
                        raise exception 'Ocurrio un error comuniquese con el administrador';
                    end if;

                end if;


      end loop;
       /**Justificar Horas fuera de rango (Inicio)**/
 /*     v_resultador = null;
      v_resultador_time = null;
      for v_fuera_rango in (select 	  ntl.fecha,
                                      asis.array_sort(string_to_array(pxp.list(ntl.event_time::text),',')) as array_dia
                              from asis.ttransacc_zkb_etl ntl
                              where ntl.id_funcionario = v_parametros.id_funcionario
                              and ntl.fecha between v_fecha_ini and v_fecha_fin
                              and ntl.rango = 'no'-- and ntl.id_rango_horario is null
                              and ntl.reader_name not in (select rn.name from asis.treader_no rn)
                              group by ntl.fecha
                              order by ntl.fecha)loop

                      if array_length(v_fuera_rango.array_dia,1) = 1 then

                        foreach v_hora_nr in array v_fuera_rango.array_dia loop

                         select  etl.id ,etl.event_time,etl.acceso
                                          into
                                          v_marcaciones
                                  from asis.ttransacc_zkb_etl etl
                                  where etl.id_funcionario = v_parametros.id_funcionario
                                  and etl.event_time = v_hora_nr::timestamp;

                         INSERT INTO asis.tpares(id_usuario_reg,
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
                                                          id_rango_horario
                                                          )VALUES (
                                                          p_id_usuario,
                                                          null,
                                                          now(),
                                                          null,
                                                          'activo',
                                                          v_parametros._id_usuario_ai,
                                                          v_parametros._nombre_usuario_ai,
                                                          v_fuera_rango.fecha,
                                                          ---v_evente_times[1]
                                                          (case
                                                           when v_marcaciones.acceso = 'Entrada' then
                                                                v_marcaciones.event_time
                                                           else
                                                                null
                                                          end),
                      										(case
                                                           when v_marcaciones.acceso = 'Salida' then
                                                                v_marcaciones.event_time
                                                           else
                                                                null
                                                          end),
                                                          'Justificar horas fuera de rango',
                                                          v_marcaciones.acceso,
                                                          (case
                                                           when v_marcaciones.acceso = 'Entrada' then
                                                                v_marcaciones.id
                                                           else
                                                                null
                                                          end),
                      										(case
                                                           when v_marcaciones.acceso = 'Salida' then
                                                                v_marcaciones.id
                                                           else
                                                                null
                                                          end),
                                                          v_parametros.id_funcionario,
                                                          null,--id_permiso,
                                                          null,--id_vacacion,
                                                          null,--?id_viatico,
                                                          null,
                                                          v_parametros.id_periodo,
                                                          'no',
                                                          'si',
                                                          'no',
                                                          'no',
                                                           null --v_rango.id_rango_horario
                                                           );
                       end loop;

                      else
                      foreach v_hora_nr in array v_fuera_rango.array_dia loop

                                 v_resultador_time = array_append(v_resultador,v_hora_nr::varchar);
                                  select  etl.id ,etl.event_time
                                          into
                                          v_marcaciones
                                  from asis.ttransacc_zkb_etl etl
                                  where etl.id_funcionario = v_parametros.id_funcionario
                                  and etl.event_time = v_hora_nr::timestamp;

                                  v_resultador =  array_append(v_resultador,v_marcaciones.id::varchar);
                                  v_evente_times = array_append(v_evente_times,v_marcaciones.event_time);

                                  if array_length(v_resultador,1) = 2 then
									-- then doors
                                    v_calcular =  COALESCE(round(COALESCE(asis.f_date_diff('minute', v_evente_times[1]::timestamp, v_evente_times[2]::timestamp),0)/60::numeric,1),0);

                      		  	   if v_calcular > 10 then  --0.13


                                  	INSERT INTO asis.tpares(id_usuario_reg,
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
                                                          id_rango_horario
                                                          )VALUES (
                                                          p_id_usuario,
                                                          null,
                                                          now(),
                                                          null,
                                                          'activo',
                                                          v_parametros._id_usuario_ai,
                                                          v_parametros._nombre_usuario_ai,
                                                          v_fuera_rango.fecha,
                                                          v_evente_times[1],
                                                          v_evente_times[2],
                                                          'Justificar horas fuera de rango',
                                                          'Entrada - Salida',
                                                          v_resultador[1]::integer,
                                                          v_resultador[2]::integer,
                                                          v_parametros.id_funcionario,
                                                          null,--id_permiso,
                                                          null,--id_vacacion,
                                                          null,--?id_viatico,
                                                          null,
                                                          v_parametros.id_periodo,
                                                          'no',
                                                          'no',
                                                          'no',
                                                          'no',
                                                           null --v_rango.id_rango_horario
                                                           );
									   end if;
                                  v_resultador = null;
                                  v_evente_times = null;

                                  end if;

                           end loop;
                      end if;


      end loop;*/

      v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Marcados Pares almacenado(a) con exito');
      v_resp = pxp.f_agrega_clave(v_resp,'id_funcionario',v_parametros.id_funcionario::varchar);

      --Devuelve la respuesta
      return v_resp;

	end;
    /*********************************
 	#TRANSACCION:  'ASIS_GHT_INS'
 	#DESCRIPCION:	Generar hojas de tiempo
 	#AUTOR:		MMV
 	#FECHA:		29-11-2019
	***********************************/

	elsif(p_transaccion='ASIS_GHT_INS')then

		begin


        if not exists ( select 1
                        from asis.tmes_trabajo me
                        where me.id_funcionario = v_parametros.id_funcionario
                        and me.id_periodo = v_parametros.id_periodo)then

        select  pe.id_gestion,
        		pe.id_periodo,
                pe.periodo - 1 as periodo
                into
                v_periodo_rec
        from param.tperiodo pe
        where pe.id_periodo = v_parametros.id_periodo;

        --Obtenemos la gestion
           select    g.id_gestion,
           			 g.gestion
                     into
                     v_rec_gestion
                     from param.tgestion g
                     where g.gestion = EXTRACT(YEAR FROM current_date);

             select tp.codigo,
                    pm.id_proceso_macro
                  		into
                   	v_codigo_tipo_proceso,
                    v_id_proceso_macro
             from  wf.tproceso_macro pm
             inner join wf.ttipo_proceso tp on tp.id_proceso_macro = pm.id_proceso_macro
             where pm.codigo='HT' and tp.estado_reg = 'activo' and tp.inicio = 'si';

             -- inciar el tramite en el sistema de WF
           SELECT
                 ps_num_tramite ,
                 ps_id_proceso_wf ,
                 ps_id_estado_wf ,
                 ps_codigo_estado
              into
                 v_nro_tramite,
                 v_id_proceso_wf,
                 v_id_estado_wf,
                 v_codigo_estado
            FROM wf.f_inicia_tramite(
                 p_id_usuario,
                 v_parametros._id_usuario_ai,
                 v_parametros._nombre_usuario_ai,
                 v_rec_gestion.id_gestion,
                 v_codigo_tipo_proceso,
                 NULL,
                 NULL,
                 'Horas de Trabajo',
                 v_codigo_tipo_proceso);



        insert into asis.tmes_trabajo(id_periodo,
                                            id_gestion,
                                            id_planilla,
                                            id_funcionario,
                                            id_estado_wf,
                                            id_proceso_wf,
                                           -- id_funcionario_apro,
                                            estado,
                                            estado_reg,
                                            obs,
                                            id_usuario_reg,
                                            usuario_ai,
                                            fecha_reg,
                                            id_usuario_ai,
                                            fecha_mod,
                                            id_usuario_mod,
                                            nro_tramite
                                            ) values(
                                            v_parametros.id_periodo,
                                            (select p.id_gestion
                                             from param.tperiodo p
                                             where p.id_periodo = v_parametros.id_periodo  ),--v_parametros.id_gestion,
                                            null,--v_parametros.id_planilla,
                                            v_parametros.id_funcionario,
                                            v_id_estado_wf,
                                            v_id_proceso_wf,
                                            --v_parametros.id_funcionario_apro,
                                            v_codigo_estado,
                                            'activo',
                                            'Biometrico',
                                            p_id_usuario,
                                            v_parametros._nombre_usuario_ai,
                                            now(),
                                            v_parametros._id_usuario_ai,
                                            null,
                                            null,
                                            v_nro_tramite
                                            )RETURNING id_mes_trabajo into v_id_mes_trabajo;


        --calculamos segunda quincena de mes anterior

        select  pe2.id_periodo,
                pe2.periodo,
                pe2.fecha_ini,
                date(case
               when to_char(pe2.fecha_fin,'DD')::integer = 30 then
               ge.gestion::varchar||case
               						 when pe2.periodo < 10 then
                                      '0'||pe2.periodo::varchar
                                      else
                                      pe2.periodo::varchar
                                     end
                                     ||'15'
               when to_char(pe2.fecha_fin,'DD')::integer = 31 then
               ge.gestion::varchar||case
               						 when pe2.periodo < 10 then
                                      '0'||pe2.periodo::varchar
                                      else
                                      pe2.periodo::varchar
                                     end
                                     ||'16'
                when to_char(pe2.fecha_fin,'DD')::integer = 28  then
                ge.gestion::varchar||case
               						 when pe2.periodo < 10 then
                                      '0'||pe2.periodo::varchar
                                      else
                                      pe2.periodo::varchar
                                     end
                                     ||'13'
                 when to_char(pe2.fecha_fin,'DD')::integer = 29 then
                             ge.gestion::varchar||case
                                                   when pe2.periodo < 10 then
                                                    '0'||pe2.periodo::varchar
                                                    else
                                                    pe2.periodo::varchar
                                                    end
                                                    ||'16'
               end::text) as fecha_mitad,
               pe2.fecha_fin
               into v_quincena_one
              from param.tperiodo pe2
              inner join param.tgestion ge on ge.id_gestion = pe2.id_gestion
              where pe2.periodo = v_periodo_rec.periodo
              and pe2.id_gestion = v_periodo_rec.id_gestion;

        	  v_calcular_ma =  0;
              v_calcular_ta	=  0;
              v_calcular_no	=  0;
              v_calcular =  0;
            -- raise exception 'entra';
              --RETURNING id_pares into
              for v_ht_one in ( select mes::date as mes
                                from generate_series( v_quincena_one.fecha_mitad::date,
                                                      v_quincena_one.fecha_fin::date,
                                                      '1 day'::interval) mes)loop

                                select  asis.array_sort(string_to_array(pxp.list (case
                                                  when pa.hora_ini is not null then
                                                       pa.hora_ini
                                                  when pa.hora_fin is not null then
                                                       pa.hora_fin
                                                  end::text),',')) as hora,
                                                  pa.id_permiso,
                                                  pa.id_vacacion,
                                                  pa.id_viatico
                                                  into
                                                  v_quincena_one_dia
                                        from asis.tpares pa
                                        where pa.id_funcionario = v_parametros.id_funcionario
                                        and pa.fecha_marcado = v_ht_one.mes
                                        and pa.rango = 'si'
                                        group by pa.id_permiso,
                                                  pa.id_vacacion,
                                                  pa.id_viatico;

                                        -- raise exception '%', asis.f_obtener_dia_literal(v_ht_one.mes);
                                      if v_quincena_one_dia.hora[1] is not null THEN

                                        v_calcular_ma =  COALESCE(round(COALESCE(asis.f_date_diff('minute', v_quincena_one_dia.hora[1]::timestamp, v_quincena_one_dia.hora[2]::timestamp),0)/60::numeric,1),0);
                                        v_calcular_ta =  COALESCE(round(COALESCE(asis.f_date_diff('minute', v_quincena_one_dia.hora[3]::timestamp, v_quincena_one_dia.hora[4]::timestamp),0)/60::numeric,1),0);
                                        v_calcular_no =  COALESCE(round(COALESCE(asis.f_date_diff('minute', v_quincena_one_dia.hora[5]::timestamp, v_quincena_one_dia.hora[6]::timestamp),0)/60::numeric,1),0);
                                        v_calcular = v_calcular_ma + v_calcular_ta + v_calcular_no;

                                         v_calcular_ex = 0;

                                        if v_calcular > 8 then
                                           v_calcular_ex = round(v_calcular -  8::numeric,1);
                                           v_resultado_final = 8;
                                           else
                                           v_resultado_final = v_calcular;
                                        end if;

                                 INSERT INTO asis.tmes_trabajo_det( id_usuario_reg,
                                                                    id_usuario_mod,
                                                                    fecha_reg,
                                                                    fecha_mod,
                                                                    estado_reg,
                                                                    id_usuario_ai,
                                                                    usuario_ai,
                                                                    id_mes_trabajo,
                                                                    id_centro_costo,
                                                                    dia,
                                                                    fecha,
                                                                    ingreso_manana_bio,
                                                                    salida_manana_bio,
                                                                    total_manana,
                                                                    ingreso_tarde_bio,
                                                                    salida_tarde_bio,
                                                                    total_tarde,
                                                                    ingreso_noche_bio,
                                                                    salida_noche_bio,
                                                                    total_noche,
                                                                    justificacion_extra,
                                                                    total_normal,
                                                                    total_nocturna,
                                                                    total_extra,
                                                                    extra_autorizada,
                                                                    total_comp,
                                                                    ingreso_manana,
                                                                    salida_manana,
                                                                    ingreso_tarde,
                                                                    salida_tarde,
                                                                    ingreso_noche,
                                                                    salida_noche,
                                                                    id_permiso,
                                                                    id_vacacion,
                                                                    id_viatico,
                                                                    id_periodo
                                                                  ) VALUES (
                                                                    p_id_usuario,
                                                                    null,
                                                                    now(),
                                                                    null,
                                                                    'activo',
                                                                    v_parametros._id_usuario_ai,
                                                                    v_parametros._nombre_usuario_ai,
                                                                    v_id_mes_trabajo,
                                                                    null,---?id_centro_costo,
                                                                    to_char(v_ht_one.mes, 'DD'::text)::integer,-- extract(dow from v_ht_one.mes),
                                                                    v_ht_one.mes,
                                                                    v_quincena_one_dia.hora[1]::timestamp,
                                                                    v_quincena_one_dia.hora[2]::timestamp,
                                                                    v_calcular_ma,--?total_manana,
                                                                    v_quincena_one_dia.hora[3]::timestamp,
                                                                    v_quincena_one_dia.hora[4]::timestamp,
                                                                    v_calcular_ta,--?total_tarde,
                                                                    v_quincena_one_dia.hora[5]::timestamp,
                                                                    v_quincena_one_dia.hora[6]::timestamp,
                                                                    v_calcular_no,--?total_noche,
                                                                    null,
                                                                    (
                                                                     case
                                                                     	when asis.f_obtener_dia_literal(v_ht_one.mes) not in  ('sabado','domingo') then
                                                                         v_resultado_final
                                                                         else
                                                                         0
                                                                         end
                                                                    ),--v_calcular,--?total_normal,
                                                                    0,--?total_nocturna,
                                                                    (
                                                                     case
                                                                     	when asis.f_obtener_dia_literal(v_ht_one.mes) not in  ('sabado','domingo') then
                                                                         v_calcular_ex
                                                                         else
                                                                         v_resultado_final
                                                                         end
                                                                    ),--?total_extra,
                                                                    0,--?extra_autorizada,
                                                                  	0,--?total_comp
                                                                  COALESCE(to_char(v_quincena_one_dia.hora[1]::timestamp, 'HH24:MI'),'00:00')::time,
                                                                  COALESCE(to_char(v_quincena_one_dia.hora[2]::timestamp, 'HH24:MI'),'00:00')::time,
                                                                  COALESCE(to_char(v_quincena_one_dia.hora[3]::timestamp, 'HH24:MI'),'00:00')::time,
                                                                  COALESCE(to_char(v_quincena_one_dia.hora[4]::timestamp, 'HH24:MI'),'00:00')::time,
                                                                  COALESCE(to_char(v_quincena_one_dia.hora[5]::timestamp, 'HH24:MI'),'00:00')::time,
                                                                  COALESCE(to_char(v_quincena_one_dia.hora[6]::timestamp, 'HH24:MI'),'00:00')::time,
                                                                  v_quincena_one_dia.id_permiso,
                                                                  v_quincena_one_dia.id_vacacion,
                                                                  v_quincena_one_dia.id_viatico,
                                                                	v_periodo_rec.id_periodo
                                                                );

                                      end if;
              end loop;

               --calculamos segunda quincena de mes actual

              select  pe.id_periodo,
                      pe.periodo,
                      pe.fecha_ini,
                      date(case
                             when to_char(pe.fecha_fin,'DD')::integer = 30 then
                             ge.gestion::varchar||case
                                                   when pe.periodo < 10 then
                                                    '0'||pe.periodo::varchar
                                                    else
                                                    pe.periodo::varchar
                                                    end
                                                    ||'15'
                             when to_char(pe.fecha_fin,'DD')::integer = 31 then
                             ge.gestion::varchar||case
                                                   when pe.periodo < 10 then
                                                    '0'||pe.periodo::varchar
                                                    else
                                                    pe.periodo::varchar
                                                    end
                                                    ||'16'
                              when to_char(pe.fecha_fin,'DD')::integer = 28  then
                              ge.gestion::varchar||case
                                                   when pe.periodo < 10 then
                                                    '0'||pe.periodo::varchar
                                                    else
                                                    pe.periodo::varchar
                                                    end
                                                    ||'13'
                               when to_char(pe.fecha_fin,'DD')::integer = 29 then
                             ge.gestion::varchar||case
                                                   when pe.periodo < 10 then
                                                    '0'||pe.periodo::varchar
                                                    else
                                                    pe.periodo::varchar
                                                    end
                                                    ||'16'
                             end::text) as fecha_mitad,
                             pe.fecha_fin into v_quincena_two
                from param.tperiodo pe
                inner join param.tgestion ge on ge.id_gestion = pe.id_gestion
                where pe.id_periodo  = v_parametros.id_periodo;
                  -- raise exception 'Entra % --> %',v_quincena_two.fecha_ini, v_parametros.id_periodo;
              v_calcular_ma =  0;
              v_calcular_ta	=  0;
              v_calcular_no	=  0;
              v_calcular =  0;

               for v_ht_two in ( select mes::date as mes
                                from generate_series( v_quincena_two.fecha_ini::date,
                                                      v_quincena_two.fecha_mitad::date,
                                                      '1 day'::interval) mes)loop

              		     select  asis.array_sort(string_to_array(pxp.list (case
                                                  when pa.hora_ini is not null then
                                                       pa.hora_ini
                                                  when pa.hora_fin is not null then
                                                       pa.hora_fin
                                                  end::text),',')) as hora,
                                                   pa.id_permiso,
                                                  pa.id_vacacion,
                                                  pa.id_viatico
                                                  into
                                                  v_quincena_one_dia
                                        from asis.tpares pa
                                        where pa.id_funcionario = v_parametros.id_funcionario
                                        and pa.fecha_marcado = v_ht_two.mes
                                        and pa.rango = 'si'
                                        group by pa.id_permiso,
                                                  pa.id_vacacion,
                                                  pa.id_viatico;

                                      if v_quincena_one_dia.hora[1] is not null THEN

                                        v_calcular_ma =  COALESCE(round(COALESCE(asis.f_date_diff('minute', v_quincena_one_dia.hora[1]::timestamp, v_quincena_one_dia.hora[2]::timestamp),0)/60::numeric,1),0);
                                        v_calcular_ta =  COALESCE(round(COALESCE(asis.f_date_diff('minute', v_quincena_one_dia.hora[3]::timestamp, v_quincena_one_dia.hora[4]::timestamp),0)/60::numeric,1),0);
                                        v_calcular_no =  COALESCE(round(COALESCE(asis.f_date_diff('minute', v_quincena_one_dia.hora[5]::timestamp, v_quincena_one_dia.hora[6]::timestamp),0)/60::numeric,1),0);
                                        v_calcular = v_calcular_ma + v_calcular_ta + v_calcular_no;

                                       if v_calcular > 8 then
                                           v_calcular_ex = round(v_calcular -  8::numeric,1);
                                           v_resultado_final = 8;
                                           else
                                           v_resultado_final = v_calcular;
                                        end if;

                                      INSERT INTO asis.tmes_trabajo_det( id_usuario_reg,
                                                                  id_usuario_mod,
                                                                  fecha_reg,
                                                                  fecha_mod,
                                                                  estado_reg,
                                                                  id_usuario_ai,
                                                                  usuario_ai,
                                                                  id_mes_trabajo,
                                                                  id_centro_costo,
                                                                  dia,
                                                                  fecha,
                                                                  ingreso_manana_bio,
                                                                  salida_manana_bio,
                                                                  total_manana,
                                                                  ingreso_tarde_bio,
                                                                  salida_tarde_bio,
                                                                  total_tarde,
                                                                  ingreso_noche_bio,
                                                                  salida_noche_bio,
                                                                  total_noche,
                                                                  justificacion_extra,
                                                                  total_normal,
                                                                  total_nocturna,
                                                                  total_extra,
                                                                  extra_autorizada,
                                                                  total_comp,
                                                                  ingreso_manana,
                                                                  salida_manana,
                                                                  ingreso_tarde,
                                                                  salida_tarde,
                                                                  ingreso_noche,
                                                                  salida_noche,
                                                                  id_permiso,
                                                                  id_vacacion,
                                                                  id_viatico,
                                                                  id_periodo
                                                                ) VALUES (
                                                                  p_id_usuario,
                                                                  null,
                                                                  now(),
                                                                  null,
                                                                  'activo',
                                                                  v_parametros._id_usuario_ai,
                                                                  v_parametros._nombre_usuario_ai,
                                                                  v_id_mes_trabajo,
                                                                  null,---?id_centro_costo,
                                                                  to_char(v_ht_two.mes, 'DD'::text)::integer,-- extract(dow from v_ht_two.mes),
                                                                  v_ht_two.mes,
                                                                  v_quincena_one_dia.hora[1]::timestamp,
                                                                  v_quincena_one_dia.hora[2]::timestamp,
                                                                  v_calcular_ma,--?total_manana,
                                                                  v_quincena_one_dia.hora[3]::timestamp,
                                                                  v_quincena_one_dia.hora[4]::timestamp,
                                                                  v_calcular_ta,--?total_tarde,
                                                                  v_quincena_one_dia.hora[5]::timestamp,
                                                                  v_quincena_one_dia.hora[6]::timestamp,
                                                                  v_calcular_no,--?total_noche,
                                                                  null,
                                                                  (
                                                                     case
                                                                     	when asis.f_obtener_dia_literal(v_ht_two.mes) not in  ('sabado','domingo') then
                                                                         v_resultado_final
                                                                         else
                                                                         0
                                                                         end
                                                                    ),--v_calcular,--?total_normal,
                                                                    0,--?total_nocturna,
                                                                    (
                                                                     case
                                                                     	when asis.f_obtener_dia_literal(v_ht_two.mes) not in  ('sabado','domingo') then
                                                                         v_calcular_ex
                                                                         else
                                                                         v_resultado_final
                                                                         end
                                                                    ),--?total_extra,
                                                                    0,--?extra_autorizada,
                                                                    0,--?total_comp
                                                                  COALESCE(to_char(v_quincena_one_dia.hora[1]::timestamp, 'HH24:MI'),'00:00')::time,
                                                                  COALESCE(to_char(v_quincena_one_dia.hora[2]::timestamp, 'HH24:MI'),'00:00')::time,
                                                                  COALESCE(to_char(v_quincena_one_dia.hora[3]::timestamp, 'HH24:MI'),'00:00')::time,
                                                                  COALESCE(to_char(v_quincena_one_dia.hora[4]::timestamp, 'HH24:MI'),'00:00')::time,
                                                                  COALESCE(to_char(v_quincena_one_dia.hora[5]::timestamp, 'HH24:MI'),'00:00')::time,
                                                                  COALESCE(to_char(v_quincena_one_dia.hora[6]::timestamp, 'HH24:MI'),'00:00')::time,
                                                                  v_quincena_one_dia.id_permiso,
                                                                  v_quincena_one_dia.id_vacacion,
                                                                  v_quincena_one_dia.id_viatico,
                                                                  v_periodo_rec.id_periodo
                                                                );



                                      end if;
            		--raise notice '--> %',v_ht_two.mes;
            	end loop;
            else

              select  hg.id_estado_wf,
                      hg.id_proceso_wf
                      into
                      v_id_estado_wf,
                      v_id_proceso_wf
              from asis.tmes_trabajo hg
              where hg.id_funcionario = v_parametros.id_funcionario
              and hg.id_periodo = v_parametros.id_periodo;
            end if;

              --Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Marcados Pares almacenado(a) con exito');
            v_resp = pxp.f_agrega_clave(v_resp,'id_funcionario',v_parametros.id_funcionario::varchar);
			v_resp = pxp.f_agrega_clave(v_resp,'id_estado_wf',v_id_estado_wf::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'id_proceso_wf',v_id_proceso_wf::varchar);
            --Devuelve la respuesta
            return v_resp;


    end;

    /*********************************
 	#TRANSACCION:  'ASIS_PER_INS'
 	#DESCRIPCION:	Generar hojas de tiempo
 	#AUTOR:		MMV
 	#FECHA:		29-11-2019
	***********************************/

	elsif(p_transaccion='ASIS_PER_INS')then
		begin

        select pe.periodo into v_periodo_mes
        from param.tperiodo pe
        where pe.id_periodo = v_parametros.id_periodo;

       --Definicion de la respuesta
	   v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Marcados Pares almacenado(a) con exito');
       v_resp = pxp.f_agrega_clave(v_resp,'periodo',v_periodo_mes::varchar);
       return v_resp;
	end;

     /*********************************
 	#TRANSACCION:  'ASIS_AGB_INS'
 	#DESCRIPCION:	Asignar rango
 	#AUTOR:		MMV
 	#FECHA:		29-11-2019
	***********************************/

	elsif(p_transaccion='ASIS_AGB_INS')then
		begin

          select  pe.periodo,
                  pe.fecha_ini,
                  pe.fecha_fin
                  into
                  v_periodo,
                  v_fecha_ini,
                  v_fecha_fin
          from param.tperiodo pe
          where pe.id_periodo = v_parametros.id_periodo;


         --- raise exception 'v_fecha_ini % v_fecha_fin %',v_fecha_ini,v_fecha_fin;


        for v_record_dia in(with periodo as (select mes::date as mes
                 from generate_series(v_fecha_ini,v_fecha_fin, '1 day'::interval) mes),
			 biometrico as ( select ma.dia,
                             asis.f_completar(ma.dia,
                                              v_parametros.id_funcionario,
                                              asis.array_sort(string_to_array(pxp.list(ma.hora::text),',')),
                                              asis.f_obtener_dia_literal(ma.dia)
                                              )as asistencia
                      from ( select   etl.fecha as dia,
                                    etl.id_rango_horario,
                                    min(etl.event_time) as hora,
                                    etl.acceso
                              from asis.ttransacc_zkb_etl etl
                              where etl.acceso = 'Entrada'
                              and etl.id_funcionario = v_parametros.id_funcionario
                              and etl.id_rango_horario is not null
                              and etl.rango = 'no'
                              group by etl.id_rango_horario, etl.fecha,etl.acceso
                      union all
                      select    etl.fecha as dia,
                              etl.id_rango_horario,
                              max(etl.event_time) as hora,
                              etl.acceso
                        from asis.ttransacc_zkb_etl etl
                        where etl.acceso = 'Salida'
                        and etl.id_funcionario = v_parametros.id_funcionario
                        and etl.id_rango_horario is not null
                        and etl.rango = 'no'
                        group by etl.id_rango_horario, etl.fecha,etl.acceso
                        order by hora ) as ma
                        where dia between v_fecha_ini and v_fecha_fin
                        group by ma.dia
                        order by dia)
             select pe.mes,
                    (case
                    	when  bi.asistencia is null then
                         asis.f_sin_rango(pe.mes,v_parametros.id_funcionario)
                        else
                         bi.asistencia
                        end ) as  asistencia
             from periodo pe
             left join biometrico bi on bi.dia = pe.mes
             order by mes)loop


         if v_record_dia.asistencia  is not null then

                    v_id = null;
           foreach v_hora in array v_record_dia.asistencia loop

                                  select  etl.id
                                          into
                                          v_id
                                  from asis.ttransacc_zkb_etl etl
                                  where etl.id_funcionario = v_parametros.id_funcionario
                                  and etl.event_time = v_hora;

           			if v_id is not null then
                     	update asis.ttransacc_zkb_etl set
                        rango = 'si'
              		    where id = v_id;
                    end if;

            end loop;
          end if;


        end loop;
     --Definicion de la respuesta
	   v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Marcados Pares almacenado(a) con exito');
       v_resp = pxp.f_agrega_clave(v_resp,'id_funcionario',v_parametros.id_funcionario::varchar);
       return v_resp;
	end;
    /*********************************
 	#TRANSACCION:  'ASIS_MAR_INS'
 	#DESCRIPCION:	Generar hojas de tiempo
 	#AUTOR:		MMV
 	#FECHA:		29-11-2019
	***********************************/

	elsif(p_transaccion='ASIS_MAR_INS')then
		begin

        select tra.id,
               tra.fecha,
               tra.rango
               into
               v_transaccion
        from asis.ttransacc_zkb_etl tra
        where tra.id = v_parametros.id;

         if v_transaccion.rango = 'no' then
           update asis.ttransacc_zkb_etl set
           rango = 'si'
           where id = v_parametros.id;
         end if;

         if v_transaccion.rango = 'si' then
           update asis.ttransacc_zkb_etl set
           rango = 'no'
           where id = v_parametros.id;
         end if;

       --Definicion de la respuesta
	   v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Marcados Pares almacenado(a) con exito');
       v_resp = pxp.f_agrega_clave(v_resp,'id',v_parametros.id::varchar);
       return v_resp;
	end;

    /*********************************
 	#TRANSACCION:  'ASIS_BOR_INS'
 	#DESCRIPCION:	Generar hojas de tiempo
 	#AUTOR:		MMV
 	#FECHA:		29-11-2019
	***********************************/

	elsif(p_transaccion='ASIS_BOR_INS')then
		begin

          select  pe.fecha_ini,
                  pe.fecha_fin
                  into
                  v_fecha_ini,
                  v_fecha_fin
          from param.tperiodo pe
          where pe.id_periodo = v_parametros.id_periodo;

    	update asis.ttransacc_zkb_etl set
        rango = 'no'
        where id_funcionario = v_parametros.id_funcionario
        and fecha between v_fecha_ini and v_fecha_fin;


       --Definicion de la respuesta
	   v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Marcados Pares almacenado(a) con exito');
       v_resp = pxp.f_agrega_clave(v_resp,'id_funcionario',v_parametros.id_funcionario::varchar);
       return v_resp;

	end;


    /*********************************
 	#TRANSACCION:  'ASIS_PJU_INS'
 	#DESCRIPCION:	Justificar
 	#AUTOR:		MMV
 	#FECHA:		29-11-2019
	***********************************/

	elsif(p_transaccion='ASIS_PJU_INS')then
		begin

       -- raise exception 'entra % ',v_parametros.id_pares;
       		update asis.tpares set
			rango = 'si',
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			justificar = v_parametros.justificar
			where id_pares=v_parametros.id_pares;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Marcados Pares modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_pares',v_parametros.id_pares::varchar);

            --Devuelve la respuesta
            return v_resp;
	end;


	else

    	raise exception 'Transaccion inexistente: %',p_transaccion;

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
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
PARALLEL UNSAFE
COST 100;

ALTER FUNCTION asis.ft_pares_ime (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;