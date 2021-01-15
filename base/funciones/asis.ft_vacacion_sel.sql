CREATE OR REPLACE FUNCTION asis.ft_vacacion_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.ft_vacacion_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.tvacacion'
 AUTOR: 		 (apinto)
 FECHA:	        01-10-2019 15:29:35
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				01-10-2019 15:29:35								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.tvacacion'
 #25			14-08-2020 15:28:39		MMV						Refactorizacion vacaciones
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
	v_filtro			varchar;
    item                record;
    v_tiempo_vacacion   varchar;
    v_record_tiempo     record;
    v_id_gestion_actual integer;
    v_id_ultima_gestion_antiguedad integer;
    v_dias_incremento_vacacion     numeric;
    v_record_ultima_vacacion       record;
	v_id_funcionario	           integer;
    v_id_funcionario_sol		   integer;
    v_count						   integer;
    v_id_movimiento				   integer;
    v_fecha_acomulado				date;
BEGIN

	v_nombre_funcion = 'asis.ft_vacacion_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'ASIS_VAC_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		apinto
 	#FECHA:		01-10-2019 15:29:35
	***********************************/

	if(p_transaccion='ASIS_VAC_SEL')then

    	begin
		--raise exception


             if v_parametros.tipo_interfaz = 'SolicitudVacaciones'then
             
             
                select  fp.id_funcionario into v_id_funcionario_sol
                from segu.vusuario usu
                inner join orga.vfuncionario_persona fp on fp.id_persona = usu.id_persona
                inner join asis.tpermiso p on p.id_funcionario = fp.id_funcionario
                where usu.id_usuario  = p_id_usuario;
                 
                
            
                  select count(p.id_permiso) into v_count
                  from asis.tpermiso p
                  where p.id_usuario_reg = p_id_usuario;
             
                  v_filtro = '';
                  
                  if p_administrador != 1  then                   
                   
                   if v_id_funcionario_sol is null and v_count = 0 then
                		
             
                		v_filtro = '( vac.id_usuario_reg = '||p_id_usuario|| ') and ';
					
                	else
                  
                      if (v_id_funcionario_sol is null)then
                      
                          v_filtro = '( vac.id_usuario_reg = '||p_id_usuario|| ') and ';
                      
                      else
                          v_filtro = '(vac.id_funcionario = '||v_id_funcionario_sol||' or vac.id_usuario_reg = '||p_id_usuario|| ') and ';

                      end if;

                	end if;
                  end if;
            end if;

            if v_parametros.tipo_interfaz = 'VacacionVoBo'then
               v_filtro = '';
                if p_administrador != 1  then

                	select f.id_funcionario into v_id_funcionario
                    from segu.vusuario u
                	inner join orga.vfuncionario_persona f on f.id_persona = u.id_persona
                    where u.id_usuario = p_id_usuario;

                     if v_id_funcionario is not null then
                    	v_filtro = 'wet.id_funcionario =  '||v_id_funcionario||' and ';
                     end if;
               	end if; 
            end if;
            
             if v_parametros.tipo_interfaz = 'VacacionRrhh'then
                v_filtro = '';
            end if;
			v_consulta:='select
						vac.id_vacacion,
						vac.estado_reg,
						vac.id_funcionario,
						vac.fecha_inicio,
						vac.fecha_fin,
						vac.dias,
						vac.descripcion,
						vac.id_usuario_reg,
						vac.fecha_reg,
						vac.id_usuario_ai,
						vac.usuario_ai,
						vac.id_usuario_mod,
						vac.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        vf.desc_funcionario1::varchar as desc_funcionario1,
                        vac.id_proceso_wf,  --- nuevos campos wf
                        vac.id_estado_wf,
                        vac.estado,
                        vac.nro_tramite,
                        vac.medio_dia,
                        vac.dias_efectivo,
                        vac.id_responsable,
                        rep.desc_funcionario1 as responsable,
                        sof.desc_funcionario1 as funcionario_sol,
                        vac.observaciones,
                        dep.id_uo,
                        dep.nombre_unidad as departamento,
                        vac.saldo
						from asis.tvacacion vac
						inner join segu.tusuario usu1 on usu1.id_usuario = vac.id_usuario_reg
                        inner join wf.testado_wf wet on wet.id_estado_wf = vac.id_estado_wf
                        inner join orga.vfuncionario rep on rep.id_funcionario = vac.id_responsable
                        inner join orga.vfuncionario_cargo vf on vf.id_funcionario = vac.id_funcionario
                        inner join orga.tuo dep ON dep.id_uo = orga.f_get_uo_departamento(vf.id_uo, NULL::integer, NULL::date)
                        left join orga.vfuncionario sof on sof.id_funcionario = vac.id_funcionario_sol
						left join segu.tusuario usu2 on usu2.id_usuario = vac.id_usuario_mod
				        where vf.fecha_asignacion <= now()::date 
                                and (vf.fecha_finalizacion is null or vf.fecha_finalizacion >= now()::date) and '||v_filtro;

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
            --RAISE EXCEPTION 'error provocado EXPETPIOM %', v_consulta;
			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_VAC_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		apinto
 	#FECHA:		01-10-2019 15:29:35
	***********************************/

	elsif(p_transaccion='ASIS_VAC_CONT')then

		begin
          if v_parametros.tipo_interfaz = 'SolicitudVacaciones'then
          
          
                select  fp.id_funcionario into v_id_funcionario_sol
                from segu.vusuario usu
                inner join orga.vfuncionario_persona fp on fp.id_persona = usu.id_persona
                inner join asis.tpermiso p on p.id_funcionario = fp.id_funcionario
                where usu.id_usuario  = p_id_usuario;
                 
                
            
                  select count(p.id_permiso) into v_count
                  from asis.tpermiso p
                  where p.id_usuario_reg = p_id_usuario;
             
                  v_filtro = '';
                  
                  if p_administrador != 1  then                   
                   
                   if v_id_funcionario_sol is null and v_count = 0 then
                		
             
                		v_filtro = '( vac.id_usuario_reg = '||p_id_usuario|| ') and ';
					
                	else
                  
                      if (v_id_funcionario_sol is null)then
                      
                          v_filtro = '( vac.id_usuario_reg = '||p_id_usuario|| ') and ';
                      
                      else
                          v_filtro = '(vac.id_funcionario = '||v_id_funcionario_sol||' or vac.id_usuario_reg = '||p_id_usuario|| ') and ';

                      end if;

                	end if;
                  end if;
            end if;

            if v_parametros.tipo_interfaz = 'VacacionVoBo'then
               v_filtro = '';
                if p_administrador != 1  then

                	select f.id_funcionario into v_id_funcionario
                    from segu.vusuario u
                	inner join orga.vfuncionario_persona f on f.id_persona = u.id_persona
                    where u.id_usuario = p_id_usuario;

                     if v_id_funcionario is not null then
                    	v_filtro = 'wet.id_funcionario =  '||v_id_funcionario||' and ';
                     end if;
               	end if;
            end if;
            
            
             if v_parametros.tipo_interfaz = 'VacacionRrhh'then
                v_filtro = '';
            end if;
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_vacacion)
					    from asis.tvacacion vac
						inner join segu.tusuario usu1 on usu1.id_usuario = vac.id_usuario_reg
                        inner join wf.testado_wf wet on wet.id_estado_wf = vac.id_estado_wf
                        inner join orga.vfuncionario rep on rep.id_funcionario = vac.id_responsable
                        inner join orga.vfuncionario_cargo vf on vf.id_funcionario = vac.id_funcionario
                        inner join orga.tuo dep ON dep.id_uo = orga.f_get_uo_departamento(vf.id_uo, NULL::integer, NULL::date)
                        left join orga.vfuncionario sof on sof.id_funcionario = vac.id_funcionario_sol
						left join segu.tusuario usu2 on usu2.id_usuario = vac.id_usuario_mod
					    where vf.fecha_asignacion <= now()::date 
                                and (vf.fecha_finalizacion is null or vf.fecha_finalizacion >= now()::date) and '||v_filtro;

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;

    
        /*********************************
 	#TRANSACCION:  'ASIS_REFOF_SEL'  
 	#DESCRIPCION:	Listar funcionario
 	#AUTOR:		miguel.mamani
 	#FECHA:		31-01-2019 13:53:10
	***********************************/
    elsif(p_transaccion='ASIS_REFOF_SEL')then
		begin

       		v_consulta:='select distinct on (uofun.id_funcionario) uofun.id_funcionario,
                                           pe.nombre_completo1::text as desc_funcionario1,
                                           fun.codigo,
                                           car.nombre as cargo,
                                           dep.nombre_unidad as departamento,
                                           ofi.nombre as oficina
                        from orga.tuo_funcionario uofun
                        inner join orga.tfuncionario fun on fun.id_funcionario = uofun.id_funcionario
                        inner join segu.vpersona pe on pe.id_persona = fun.id_persona
                        inner join segu.vusuario uo on uo.id_persona = pe.id_persona
                        inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
                        inner join orga.ttipo_contrato tc on car.id_tipo_contrato = tc.id_tipo_contrato
                        inner join orga.tuo dep ON dep.id_uo = orga.f_get_uo_departamento(uofun.id_uo, NULL::integer, NULL::date)
                        inner join orga.toficina ofi on ofi.id_oficina = car.id_oficina
                        where tc.codigo in (''PLA'', ''EVE'') and UOFUN.tipo = ''oficial'' and uofun.fecha_asignacion <=  now()::date and
                         (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >= now()::date) and
                         uofun.estado_reg != ''inactivo'' and ';

            --Definicion de la respuesta

			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by uofun.id_funcionario, uofun.fecha_asignacion desc' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
            raise notice '%',v_consulta;
            return v_consulta;
        end;
    /*********************************
 	#TRANSACCION:  'ASIS_REFOF_CONT'  
 	#DESCRIPCION:	count Listar funcionario
 	#AUTOR:		miguel.mamani
 	#FECHA:		31-01-2019 13:53:10
	***********************************/
    elsif(p_transaccion='ASIS_REFOF_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
            
            v_consulta:='select count(distinct uofun.id_funcionario) 
                          from orga.tuo_funcionario uofun
                          inner join orga.tfuncionario fun on fun.id_funcionario = uofun.id_funcionario
                          inner join segu.vpersona pe on pe.id_persona = fun.id_persona
                          inner join segu.vusuario uo on uo.id_persona = pe.id_persona
                          inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
                          inner join orga.ttipo_contrato tc on car.id_tipo_contrato = tc.id_tipo_contrato
                          inner join orga.tuo dep ON dep.id_uo = orga.f_get_uo_departamento(uofun.id_uo, NULL::integer, NULL::date)
                          inner join orga.toficina ofi on ofi.id_oficina = car.id_oficina
                          where tc.codigo in (''PLA'', ''EVE'') and UOFUN.tipo = ''oficial'' and uofun.fecha_asignacion <=  now()::date and
                           (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >= now()::date) and
                           uofun.estado_reg != ''inactivo'' and ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			--Devuelve la respuesta

			return v_consulta;

		end;
       /*********************************
         #TRANSACCION:  'ASIS_ASIGVAC_SEL'
         #DESCRIPCION:   Cron Asigna vacaciones segun su fecha de contrato y copia los ultimos datos de feriados a a gestion actual
         #AUTOR:            Juan
         #FECHA:            15-10-2019 14:48:35
        ***********************************/

        elsif(p_transaccion='ASIS_ASIGVAC_SEL')then

            begin

                SELECT g.id_gestion
                INTO
                v_id_gestion_actual
                FROM param.tgestion g
                WHERE now() BETWEEN g.fecha_ini and g.fecha_fin;
                    
                select a.id_gestion
                INTO
                v_id_ultima_gestion_antiguedad
                from param.tantiguedad a order by a.id_gestion desc limit 1;

                IF NOT EXISTS(select * 
                              from param.tantiguedad a 
                              where a.id_gestion = v_id_gestion_actual)THEN

                    INSERT INTO param.tantiguedad (
                                categoria_antiguedad,
                                dias_asignados,
                                desde_anhos,
                                hasta_anhos,
                                obs_antiguedad,
                                id_gestion,
                                id_usuario_reg,
                                fecha_reg,
                                estado_reg
                                )SELECT a.categoria_antiguedad,
                                        a.dias_asignados,
                                        a.desde_anhos,
                                        a.hasta_anhos,
                                        a.obs_antiguedad,
                                        v_id_gestion_actual,
                                        a.id_usuario_reg,
                                        now()::TIMESTAMP,
                                        a.estado_reg 
                                        FROM param.tantiguedad a  
                                        WHERE a.id_gestion = v_id_ultima_gestion_antiguedad 
                                        ORDER BY a.id_antiguedad ASC;

                END IF;


                for item in(select f.id_funcionario,
                                   uf.fecha_asignacion,
                                   UF.fecha_finalizacion,
                                   tc.nombre,tc.codigo
                                   from orga.tfuncionario f
                                   join orga.tuo_funcionario uf on uf.id_funcionario=f.id_funcionario
                                   join orga.tcargo c on c.id_cargo=uf.id_cargo
                                   join orga.ttipo_contrato tc on tc.id_tipo_contrato=c.id_tipo_contrato and tc.codigo in ('PLA','EVE')
                                   where uf.fecha_asignacion<=now() and coalesce(uf.fecha_finalizacion, now())>=now()
                                   and uf.estado_reg = 'activo' and uf.tipo = 'oficial' /*and f.id_funcionario = 408*/) LOOP


                     IF EXISTS(with antiguedad AS (SELECT mv.id_funcionario,
                                                          (age(now()::date,mv.fecha_reg::date))::varchar as tiempo_transcurrido 
                                                   FROM asis.tmovimiento_vacacion mv 
                                                   WHERE mv.tipo='ACUMULADA' 
                                                        AND mv.id_funcionario=item.id_funcionario 
                                                        AND mv.estado_reg = 'activo'
                                                   ORDER BY mv.fecha_reg DESC LIMIT 1 )
                              SELECT a.id_funcionario,
                                     a.tiempo_transcurrido
                              from antiguedad a 
                              where a.tiempo_transcurrido like '%year%')THEN


							
                              WITH antiguedad AS
                              (SELECT  mv.id_funcionario,
                                       (age(now()::date,mv.fecha_reg::date))::varchar as tiempo_transcurrido,
                                       (age(now()::date,item.fecha_asignacion::date))::varchar as tiempo_antiguedad,
                                       mv.fecha_reg,
                                       mv.id_movimiento_vacacion
                               FROM asis.tmovimiento_vacacion mv
                               WHERE mv.tipo='ACUMULADA' 
                               AND mv.id_funcionario=item.id_funcionario
                               AND mv.estado_reg = 'activo'
                               ORDER BY mv.fecha_reg ASC LIMIT 1 )
                              SELECT a.id_funcionario,
                                    a.tiempo_transcurrido,
                                    a.tiempo_antiguedad,
                                    a.fecha_reg,
                                    a.id_movimiento_vacacion
                              INTO
                              v_record_ultima_vacacion
                              FROM antiguedad a
                              WHERE a.tiempo_transcurrido LIKE '%year%';
                              
                              
                              	--raise exception '%',v_record_ultima_vacacion;

                             /*with dias as(SELECT
                                          SPLIT_PART(v_record_ultima_vacacion.tiempo_transcurrido, 'year', 1) AS anios_pasado,
                                          SPLIT_PART(v_record_ultima_vacacion.tiempo_transcurrido, 'year', 1) AS anios_antiguedad,
                                          (v_record_ultima_vacacion.fecha_reg::date+'1 year'::interval)::date as nueva_fecha,
                                          (select mv.dias_actual 
                                          from asis.tmovimiento_vacacion mv 
                                          where mv.id_funcionario=item.id_funcionario
                                                AND mv.estado_reg = 'activo'
                                          ORDER BY mv.fecha_reg desc limit 1 )::integer as dias_actual )
                                          SELECT d.anios_pasado,d.anios_antiguedad,d.nueva_fecha,d.dias_actual
                                          INTO
                                          v_record_tiempo
                                          FROM dias d;*/
                                          
                               SELECT mv.fecha_reg::date into v_fecha_acomulado
                               FROM asis.tmovimiento_vacacion mv
                               WHERE mv.tipo='ACUMULADA' 
                               AND mv.id_funcionario=item.id_funcionario
                               AND mv.estado_reg = 'activo'
                               ORDER BY mv.fecha_reg DESC LIMIT 1;
                                          
                     		
                                     
                                     with dias as(SELECT
                                          SPLIT_PART(v_record_ultima_vacacion.tiempo_transcurrido, 'year', 1) AS anios_pasado,
                                          SPLIT_PART(v_record_ultima_vacacion.tiempo_transcurrido, 'year', 1) AS anios_antiguedad,
                                          (v_fecha_acomulado::date+'1 year'::interval)::date as nueva_fecha,
                                          (select m.dias_actual
                                           from asis.tmovimiento_vacacion m
                                           where m.id_funcionario = item.id_funcionario
                                     		and m.estado_reg = 'activo' and m.activo = 'activo')::numeric as dias_actual )
                                          SELECT d.anios_pasado,d.anios_antiguedad,d.nueva_fecha,d.dias_actual
                                          INTO
                                          v_record_tiempo
                                          FROM dias d;
                     	      
                               


                             SELECT
                             a.dias_asignados
                             INTO
                             v_dias_incremento_vacacion
                             FROM param.tantiguedad a
                             WHERE a.id_gestion=v_id_gestion_actual
                             AND (v_record_tiempo.anios_antiguedad::INTEGER BETWEEN a.desde_anhos AND a.hasta_anhos );


                             INSERT INTO asis.tmovimiento_vacacion ( id_funcionario,
                                                                     desde,
                                                                     hasta,
                                                                     dias_actual,
                                                                     activo,
                                                                     dias,
                                                                     tipo,
                                                                     id_usuario_reg,
                                                                     fecha_reg,
                                                                     estado_reg
                                                                     )VALUES(
                                                                     item.id_funcionario,
                                                                     NULL,
                                                                     NULL,(
                                                                     v_record_tiempo.dias_actual+v_dias_incremento_vacacion)::NUMERIC,
                                                                     'activo',
                                                                     v_dias_incremento_vacacion::NUMERIC,
                                                                     'ACUMULADA',
                                                                     9,
                                                                     v_record_tiempo.nueva_fecha::TIMESTAMP,
                                                                     'activo');

							 select m.id_movimiento_vacacion into  v_id_movimiento
                             from asis.tmovimiento_vacacion m
                             where m.id_funcionario = item.id_funcionario
                                     		and m.estado_reg = 'activo' and m.activo = 'activo';


                             UPDATE asis.tmovimiento_vacacion
                             SET activo = 'inactivo'
                             WHERE id_movimiento_vacacion = v_id_movimiento
                             AND estado_reg = 'activo';

                     ELSE

                             IF NOT EXISTS (SELECT * 
                                            FROM asis.tmovimiento_vacacion mv 
                                            where mv.id_funcionario=item.id_funcionario
                                            and mv.estado_reg = 'activo')THEN
                                            
                                  INSERT INTO asis.tmovimiento_vacacion ( id_funcionario,
                                                                          desde,
                                                                          hasta,
                                                                          dias_actual,
                                                                          activo,
                                                                          dias,
                                                                          tipo,
                                                                          id_usuario_reg,
                                                                          fecha_reg,
                                                                          estado_reg )
                                                                VALUES (item.id_funcionario,
                                                                          NULL,
                                                                          NULL,
                                                                          0::NUMERIC,
                                                                          'activo',
                                                                          0::NUMERIC,
                                                                          'ACUMULADA',
                                                                          10,
                                                                          item.fecha_asignacion,
                                                                          'activo');
                             END IF;
                     END IF;

                end loop;

                ---------------------Copiar ultimos datos de feriados a la nueva gestion-----------------------
                v_id_gestion_actual := null;
                v_id_ultima_gestion_antiguedad := null;

                select
                max(f.id_gestion)
                into
                v_id_gestion_actual
                from param.tferiado f;

                select
                f.id_gestion
                into
                v_id_ultima_gestion_antiguedad
                from param.tgestion f
                where f.id_gestion> v_id_gestion_actual::integer
                order by f.id_gestion asc limit 1;

                insert into param.tferiado
                (id_usuario_reg,id_usuario_mod,fecha_reg,fecha_mod,estado_reg,id_usuario_ai,usuario_ai,id_lugar,descripcion,fecha,tipo,id_gestion)
                select
                id_usuario_reg,id_usuario_mod,fecha_reg,fecha_mod,estado_reg,id_usuario_ai,usuario_ai,id_lugar,descripcion,fecha,tipo,v_id_ultima_gestion_antiguedad
                from param.tferiado  where id_gestion=v_id_gestion_actual;
                --------------------------------------------------------------------------------------------------


                v_consulta:='select a.dias_asignados from param.tantiguedad a ';
                return v_consulta;
            end;


	else

		raise exception 'Transaccion inexistente';

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