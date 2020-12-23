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
    v_dias_incremento_vacacion     integer;
    v_record_ultima_vacacion       record;
	v_id_funcionario	           integer;

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
                v_filtro = '';
                  if p_administrador != 1  then
                     v_filtro = 'vac.id_usuario_reg =  '||p_id_usuario||' and ';
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
		RAISE NOTICE 'error provocado NOTICE %', v_consulta;
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
                v_filtro = '';
                  if p_administrador != 1  then
                     v_filtro = 'vac.id_usuario_reg =  '||p_id_usuario||' and ';
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