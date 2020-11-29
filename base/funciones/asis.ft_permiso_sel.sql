CREATE OR REPLACE FUNCTION asis.ft_permiso_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.ft_permiso_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.tpermiso'
 AUTOR: 		 (miguel.mamani)
 FECHA:	        16-10-2019 13:14:05
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				16-10-2019 13:14:05								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.tpermiso'
 #25			14-08-2020 15:28:39		MMV						Refactorizacion permiso

 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
    v_filtro			varchar;
    v_id_funcionario	integer;
    v_id_funcionario_sol	integer;

BEGIN

	v_nombre_funcion = 'asis.ft_permiso_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'ASIS_PMO_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		miguel.mamani
 	#FECHA:		16-10-2019 13:14:05
	***********************************/

	if(p_transaccion='ASIS_PMO_SEL')then

    	begin
            if v_parametros.tipo_interfaz = 'PermisoReg'then
                v_filtro = '';
                if p_administrador != 1  then


                select fp.id_funcionario into v_id_funcionario_sol
                from segu.vusuario usu
                inner join orga.vfuncionario_persona fp on fp.id_persona = usu.id_persona
                inner join asis.tpermiso p on p.id_funcionario = fp.id_funcionario
                where usu.id_usuario  = p_id_usuario;

                	v_filtro = '(pmo.id_funcionario = '||v_id_funcionario_sol||' or pmo.id_usuario_reg = '||p_id_usuario|| ') and ';

            	end if;
            end if;

            if v_parametros.tipo_interfaz = 'PermisoVoBo'then
               v_filtro = '';
                if p_administrador != 1  then

                	select f.id_funcionario into v_id_funcionario_sol
                    from segu.vusuario u
                	inner join orga.vfuncionario_persona f on f.id_persona = u.id_persona
                    where u.id_usuario = p_id_usuario;


					v_filtro = 'wet.id_funcionario =  '||v_id_funcionario_sol||' and ';



               	end if;
            end if;
            if v_parametros.tipo_interfaz = 'PermisoRRHH' or v_parametros.tipo_interfaz = 'PermisoRrhh' then
                v_filtro = '';
            end if;


    		--Sentencia de la consulta
			v_consulta:='select	pmo.id_permiso,
                                pmo.nro_tramite,
                                pmo.id_funcionario,
                                pmo.id_estado_wf,
                                pmo.fecha_solicitud,
                                pmo.id_tipo_permiso,
                                pmo.motivo,
                                pmo.estado_reg,
                                pmo.estado,
                                pmo.id_proceso_wf,
                                pmo.id_usuario_ai,
                                pmo.id_usuario_reg,
                                pmo.usuario_ai,
                                pmo.fecha_reg,
                                pmo.fecha_mod,
                                pmo.id_usuario_mod,
                                usu1.cuenta as usr_reg,
                                usu2.cuenta as usr_mod,
                                tip.nombre ||'' (''||tip.codigo||'')''::text as desc_tipo_permiso,
                                fun.desc_funcionario1::text as desc_funcionario,
                                pmo.hro_desde,
                                pmo.hro_hasta,
                                tip.reposcion as asignar_rango,
                                tip.documento,
                                pmo.reposicion,
                                pmo.fecha_reposicion,
                                pmo.hro_desde_reposicion,
                                pmo.hro_hasta_reposicion,
                                pmo.hro_total_permiso,
                                pmo.hro_total_reposicion,
                                pmo.jornada,
                                pmo.id_responsable,
                                rep.desc_funcionario1 as responsable,
                                ded.desc_funcionario1 as funcionario_sol,
                                pmo.observaciones,
                                fun.id_uo,
                                dep.nombre_unidad as departamento
                                from asis.tpermiso pmo
                                inner join segu.tusuario usu1 on usu1.id_usuario = pmo.id_usuario_reg
                                inner join asis.ttipo_permiso tip on tip.id_tipo_permiso = pmo.id_tipo_permiso
                                inner join orga.vfuncionario_cargo fun on fun.id_funcionario = pmo.id_funcionario
                                inner join wf.testado_wf wet on wet.id_estado_wf = pmo.id_estado_wf
                                inner join orga.vfuncionario rep on rep.id_funcionario = pmo.id_responsable
                                inner join orga.tuo dep ON dep.id_uo = orga.f_get_uo_departamento(fun.id_uo, NULL::integer, NULL::date)
                                left join segu.tusuario usu2 on usu2.id_usuario = pmo.id_usuario_mod
                                left join orga.vfuncionario ded on ded.id_funcionario = pmo.id_funcionario_sol
                                where fun.fecha_asignacion <= now()::date
                                and (fun.fecha_finalizacion is null or fun.fecha_finalizacion >= now()::date) and '||v_filtro;

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
			--Devuelve la respuesta
            raise notice '%',v_consulta;
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_PMO_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		16-10-2019 13:14:05
	***********************************/

	elsif(p_transaccion='ASIS_PMO_CONT')then

		begin
            if v_parametros.tipo_interfaz = 'PermisoReg'then
                v_filtro = '';
                if p_administrador != 1  then
                  select fp.id_funcionario into v_id_funcionario_sol
                  from segu.vusuario usu
                  inner join orga.vfuncionario_persona fp on fp.id_persona = usu.id_persona
                  inner join asis.tpermiso p on p.id_funcionario = fp.id_funcionario
                  where usu.id_usuario  = p_id_usuario;

                	v_filtro = '(pmo.id_funcionario = '||v_id_funcionario_sol||' or pmo.id_usuario_reg = '||p_id_usuario|| ') and ';

               	end if;
            end if;

            if v_parametros.tipo_interfaz = 'PermisoVoBo'then
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
            if v_parametros.tipo_interfaz = 'PermisoRRHH' or v_parametros.tipo_interfaz = 'PermisoRrhh' then
                v_filtro = '';
            end if;
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_permiso)
					    from asis.tpermiso pmo
					    inner join segu.tusuario usu1 on usu1.id_usuario = pmo.id_usuario_reg
                        inner join asis.ttipo_permiso tip on tip.id_tipo_permiso = pmo.id_tipo_permiso
                        inner join orga.vfuncionario_cargo fun on fun.id_funcionario = pmo.id_funcionario
                        inner join wf.testado_wf wet on wet.id_estado_wf = pmo.id_estado_wf
                        inner join orga.vfuncionario rep on rep.id_funcionario = pmo.id_responsable
                        inner join orga.tuo dep ON dep.id_uo = orga.f_get_uo_departamento(fun.id_uo, NULL::integer, NULL::date)
                        left join segu.tusuario usu2 on usu2.id_usuario = pmo.id_usuario_mod
                        left join orga.vfuncionario ded on ded.id_funcionario = pmo.id_funcionario_sol
                        where fun.fecha_asignacion <= now()::date
                        and (fun.fecha_finalizacion is null or fun.fecha_finalizacion >= now()::date) and '||v_filtro;

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;

    /*********************************
 	#TRANSACCION:  'ASIS_RFL_SEL'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		16-10-2019 13:14:05
	***********************************/

	elsif(p_transaccion='ASIS_RFL_SEL')then

		begin

        	v_consulta := 'select  fun.id_funcionario,
                                   fun.desc_funcionario1 as desc_funcionario,
                                    ''''::text  as desc_funcionario_cargo
                            from  orga.vfuncionario fun
                            where fun.id_funcionario in (select *
                                                         from orga.f_get_aprobadores_x_funcionario(CURRENT_DATE,'||v_parametros.id_funcionario||',''todos'',''todos'',''2,3,4,6'') as
                                                        (id_funcionario integer)) and';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
		end;


	/*********************************
 	#TRANSACCION:  'ASIS_RFL_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		16-10-2019 13:14:05
	***********************************/

	elsif(p_transaccion='ASIS_RFL_CONT')then

		begin

			--Sentencia de la consulta de conteo de registros
			v_consulta:='select   count (fun.id_funcionario)
                            from  orga.vfuncionario fun
                            where fun.id_funcionario in (select *
                                                         from orga.f_get_aprobadores_x_funcionario(CURRENT_DATE,'||v_parametros.id_funcionario||',''todos'',''todos'',''2,3,4,6'') as
                                                        (id_funcionario integer)) and';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			--Devuelve la respuesta
			return v_consulta;

		end;

	  /*********************************
    #TRANSACCION:  'ASIS_AOES_SEL'
    #DESCRIPCION:	Consult area list
    #AUTOR:		MMV
    #FECHA:		17-07-2019 17:41:55
    ***********************************/

	elsif(p_transaccion='ASIS_AOES_SEL')then

		begin
			--Sentencia de la consulta
			v_consulta:=' select ts.id_tipo_estado,
                                 ts.codigo,
                                 ts.nombre_estado,
                                 mp.codigo as codigo_macro
                          from wf.tproceso_macro mp
                          inner join wf.ttipo_proceso tp on tp.id_proceso_macro = mp.id_proceso_macro
                          inner join wf.ttipo_estado ts on ts.id_tipo_proceso = tp.id_tipo_proceso
                          where ts.estado_reg = ''activo'' and';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
			--Devuelve la respuesta
			return v_consulta;

		end;

    /*********************************
    #TRANSACCION:  'ASIS_AOES_CONT'
    #DESCRIPCION:	Count area list
    #AUTOR:		MMV
    #FECHA:		17-07-2019 17:41:55
    ***********************************/

	elsif(p_transaccion='ASIS_AOES_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:=' select count(ts.id_tipo_estado)
                          from wf.tproceso_macro mp
                          inner join wf.ttipo_proceso tp on tp.id_proceso_macro = mp.id_proceso_macro
                          inner join wf.ttipo_estado ts on ts.id_tipo_proceso = tp.id_tipo_proceso
                          where ts.estado_reg = ''activo'' and';

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

ALTER FUNCTION asis.ft_permiso_sel (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;