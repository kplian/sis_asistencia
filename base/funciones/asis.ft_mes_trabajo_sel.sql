CREATE OR REPLACE FUNCTION asis.ft_mes_trabajo_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.ft_mes_trabajo_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.tmes_trabajo'
 AUTOR: 		 (miguel.mamani)
 FECHA:	        31-01-2019 13:53:10
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				31-01-2019 13:53:10								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.tmes_trabajo'
 #5				30/04/2019 				kplian MMV			Validaciones y reporte
 #8 ETR			24/06/2019				MMV					Validar fecha des contrato finalizados y listado
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
    v_filtro			varchar;
    v_id_funcionario	integer;
    v_id_gestion		integer;
    v_id_periodo		integer;
    v_fecha_ini			date;

BEGIN

	v_nombre_funcion = 'asis.ft_mes_trabajo_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'ASIS_SMT_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		miguel.mamani
 	#FECHA:		31-01-2019 13:53:10
	***********************************/

	if(p_transaccion='ASIS_SMT_SEL')then

    	begin

            if v_parametros.tipo_interfaz = 'Reg' then
            	if (p_administrador) then
                	v_filtro = '0=0 and';
                else
                                    	v_filtro = '0=0 and';

                end if;
            end if;

            if v_parametros.tipo_interfaz = 'VoBo' then
            	if (p_administrador) then
                		v_filtro = '0=0 and';

                else
                    select f.id_funcionario
                            into
                            v_id_funcionario
                            from segu.vusuario u
                            inner join orga.vfuncionario_persona f on f.id_persona = u.id_persona
                            where u.id_usuario = p_id_usuario;
                      v_filtro = 'ew.id_funcionario ='||v_id_funcionario||' and';
                end if;
            end if;

			select pe.fecha_ini into v_fecha_ini
            from param.tperiodo pe
            where pe.id_periodo = v_parametros.id_periodo;

		--	raise exception '%',v_parametros.id_periodo;
    		--Sentencia de la consulta
			v_consulta:='select	smt.id_mes_trabajo,
                                smt.id_periodo,
                                smt.id_gestion,
                                smt.id_planilla,
                                smt.id_funcionario,
                                smt.id_estado_wf,
                                smt.id_proceso_wf,
                                smt.id_funcionario_apro,
                                smt.estado,
                                smt.estado_reg,
                                smt.obs,
                                smt.id_usuario_reg,
                                smt.usuario_ai,
                                smt.fecha_reg,
                                smt.id_usuario_ai,
                                smt.fecha_mod,
                                smt.id_usuario_mod,
                                usu1.cuenta as usr_reg,
                                usu2.cuenta as usr_mod,
                                fun.desc_funcionario1 as desc_funcionario,
                                funa.desc_funcionario1 as desc_funcionario_apro,
                                smt.nro_tramite,
                                pe.periodo,
                                fun.codigo,
                                trim(both ''FUNODTPR'' from  fun.codigo ) as desc_codigo,
                                g.gestion,
                                fun.nombre_cargo,
                                tc.nombre as tipo_contrato
                                from asis.tmes_trabajo smt
                                inner join segu.tusuario usu1 on usu1.id_usuario = smt.id_usuario_reg
                                inner join orga.vfuncionario_cargo fun on fun.id_funcionario = smt.id_funcionario and (fun.fecha_finalizacion is null or fun.fecha_finalizacion >= '''||v_fecha_ini||''') --#8
                                inner join orga.tcargo ca on ca.id_cargo = fun.id_cargo
                                inner join orga.ttipo_contrato tc on tc.id_tipo_contrato = ca.id_tipo_contrato
                                left join orga.vfuncionario funa on funa.id_funcionario = smt.id_funcionario_apro
                                left join wf.tproceso_wf pw on pw.id_proceso_wf = smt.id_proceso_wf
                                left join wf.testado_wf ew on ew.id_estado_wf = smt.id_estado_wf
                                inner join param.tperiodo pe on pe.id_periodo = smt.id_periodo
                                inner join param.tgestion g on g.id_gestion = smt.id_gestion
                                left join segu.tusuario usu2 on usu2.id_usuario = smt.id_usuario_mod
				        		where  '|| v_filtro;
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_SMT_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		31-01-2019 13:53:10
	***********************************/

	elsif(p_transaccion='ASIS_SMT_CONT')then

		begin

        	 if v_parametros.tipo_interfaz = 'Reg' then
            	if (p_administrador) then
                	v_filtro = '0=0 and';
                else
                                    	v_filtro = '0=0 and';

                end if;
            end if;

            if v_parametros.tipo_interfaz = 'VoBo' then
            	if (p_administrador) then
                		v_filtro = '0=0 and';

                else
                    select f.id_funcionario
                            into
                            v_id_funcionario
                            from segu.vusuario u
                            inner join orga.vfuncionario_persona f on f.id_persona = u.id_persona
                            where u.id_usuario = p_id_usuario;
                      v_filtro = 'ew.id_funcionario ='||v_id_funcionario||' and';
                end if;
            end if;

            select pe.fecha_ini into v_fecha_ini
            from param.tperiodo pe
            where pe.id_periodo = v_parametros.id_periodo;

			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_mes_trabajo)
 								from asis.tmes_trabajo smt
                                inner join segu.tusuario usu1 on usu1.id_usuario = smt.id_usuario_reg
                                inner join orga.vfuncionario_cargo fun on fun.id_funcionario = smt.id_funcionario and (fun.fecha_finalizacion is null or fun.fecha_finalizacion >= '''||v_fecha_ini||''') --#8
                                inner join orga.tcargo ca on ca.id_cargo = fun.id_cargo
                                inner join orga.ttipo_contrato tc on tc.id_tipo_contrato = ca.id_tipo_contrato
                                left join orga.vfuncionario funa on funa.id_funcionario = smt.id_funcionario_apro
                                left join wf.tproceso_wf pw on pw.id_proceso_wf = smt.id_proceso_wf
                                left join wf.testado_wf ew on ew.id_estado_wf = smt.id_estado_wf
                                inner join param.tperiodo pe on pe.id_periodo = smt.id_periodo
                                inner join param.tgestion g on g.id_gestion = smt.id_gestion
                                left join segu.tusuario usu2 on usu2.id_usuario = smt.id_usuario_mod
					    		where '||v_filtro;

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;
    /*********************************
 	#TRANSACCION:  'ASIS_RHT_SEL' #5
 	#DESCRIPCION:	Reporte Hoja Tiempo
 	#AUTOR:		Kplian MMV
 	#FECHA:		31-01-2019 13:53:10
	***********************************/
	elsif(p_transaccion='ASIS_RHT_SEL')then
		begin

        --raise exception '%',v_parametros.id_proceso_wf;
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select  fun.desc_funcionario1 as nombre_funcionario,
                                  trim(both ''FUNODTPR'' from  fun.codigo ) as codigo,
                                  ges.gestion,
                                  per.periodo,
                                  mde.dia,
                                  mde.ingreso_manana,
                                  mde.salida_manana,
                                  mde.ingreso_tarde,
                                  mde.salida_tarde,
                                  mde.ingreso_noche,
                                  mde.salida_noche,
                                  cen.codigo_tcc,
                                  mde.total_normal,
                                  mde.total_extra,
                                  mde.total_nocturna,
                                  mde.extra_autorizada,
                                  mde.justificacion_extra
                          from asis.tmes_trabajo me
                          inner join orga.vfuncionario fun on fun.id_funcionario = me.id_funcionario
                          inner join param.tgestion ges on ges.id_gestion = me.id_gestion
                          inner join param.tperiodo per on per.id_periodo = per.id_periodo
                          inner join asis.tmes_trabajo_det mde on mde.id_mes_trabajo = me.id_mes_trabajo
                          inner join param.vcentro_costo cen on cen.id_centro_costo = mde.id_centro_costo
                          where me.id_proceso_wf = '||v_parametros.id_proceso_wf||' and per.id_periodo = '||v_id_periodo||' and ges.id_gestion = '||v_id_gestion||'
                          order by mde.id_mes_trabajo_det asc';
			--raise notice '%',v_consulta;
			--Devuelve la respuesta
			return v_consulta;
		end;
    /*********************************
 	#TRANSACCION:  'ASIS_FUA_SEL'  #8
 	#DESCRIPCION:	Listar funcionario
 	#AUTOR:		miguel.mamani
 	#FECHA:		31-01-2019 13:53:10
	***********************************/
    elsif(p_transaccion='ASIS_FUA_SEL')then
		begin

        	select pe.fecha_ini into v_fecha_ini
            from param.tperiodo pe
            where pe.id_periodo = v_parametros.id_periodo;

       		v_consulta:='select 	fun.id_funcionario,
                                  	fun.desc_funcionario1,
                    				fun.codigo
                          from orga.vfuncionario_cargo fun
                          where (fun.fecha_finalizacion is null or fun.fecha_finalizacion >= '''||v_fecha_ini||''')
                          and fun.id_funcionario not in (	select me.id_funcionario
                                                          from asis.tmes_trabajo me
                                                          where me.id_periodo = '||v_parametros.id_periodo||') and';

            --Definicion de la respuesta

			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
        	 return v_consulta;

        end;
    /*********************************
 	#TRANSACCION:  'ASIS_FUA_CONT'  #8
 	#DESCRIPCION:	count Listar funcionario
 	#AUTOR:		miguel.mamani
 	#FECHA:		31-01-2019 13:53:10
	***********************************/
    elsif(p_transaccion='ASIS_FUA_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
            select pe.fecha_ini into v_fecha_ini
            from param.tperiodo pe
            where pe.id_periodo = v_parametros.id_periodo;

            v_consulta:='select count(fun.id_funcionario)
                          from orga.vfuncionario_cargo fun
                          where (fun.fecha_finalizacion is null or fun.fecha_finalizacion >= '''||v_fecha_ini||''')
                          and fun.id_funcionario not in (	select me.id_funcionario
                                                          from asis.tmes_trabajo me
                                                          where me.id_periodo = '||v_parametros.id_periodo||') and';

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
COST 100;