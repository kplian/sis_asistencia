CREATE OR REPLACE FUNCTION asis.ft_pares_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.ft_pares_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.tpares'
 AUTOR: 		 (mgarcia)
 FECHA:	        19-09-2019 16:00:52
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				19-09-2019 16:00:52								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.tpares'
 #
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;



BEGIN

	v_nombre_funcion = 'asis.ft_pares_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'ASIS_PAR_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		mgarcia
 	#FECHA:		19-09-2019 16:00:52
	***********************************/

	if(p_transaccion='ASIS_PAR_SEL')then

    	begin
    		--Sentencia de la consulta

            if v_parametros.id_funcionario is null then
                  raise exception 'Usted no esta registrado como funcionario';
            end if;
			v_consulta:='select	  par.id_pares,
                                  par.estado_reg,
                                  par.id_transaccion_ini,
                                  par.id_transaccion_fin,
                                  to_char(par.fecha_marcado,''DD/MM/YYYY'') || '' - ''||initcap (asis.f_obtener_dia_literal(par.fecha_marcado)) || '' -- ''||asis.f_calcular_total_hora (503,par.fecha_marcado)|| '' hrs.''  ::text as fecha_marcado,
                                  par.id_funcionario,
                                  par.id_permiso,
                                  par.id_vacacion,
                                  par.id_viatico,
                                  par.id_usuario_reg,
                                  par.fecha_reg,
                                  par.id_usuario_ai,
                                  par.usuario_ai,
                                  par.id_usuario_mod,
                                  par.fecha_mod,
                                  usu1.cuenta as usr_reg,
                                  usu2.cuenta as usr_mod,
                                  to_char(par.fecha_marcado,''DD'')::integer as dia,
                                  (case
                                   when par.hora_ini is not null and par.hora_fin is not null then
                                        to_char( par.hora_ini, ''HH24:MI'')::varchar||'' - ''||to_char( par.hora_fin, ''HH24:MI'')::varchar
                                   when par.hora_ini is not null then
                                   to_char( par.hora_ini, ''HH24:MI'')::varchar
                                   else
                                    to_char( par.hora_fin, ''HH24:MI'')::varchar
                                   end)::varchar as hora,
                                   par.acceso as evento,
                                   par.lector::varchar as tipo_verificacion,
                                   '' ''::varchar as obs,
                                   ran.descripcion,
                                   par.rango,
                                   initcap(vfun.desc_funcionario1) as desc_funcionario,
                                    (case
                                        when par.id_vacacion is not null then
                                        	 vac.descripcion  ||'' - ''|| vac.nro_tramite
                                        when par.id_permiso is not null then
                                        	''(''||per.hro_desde ||'' - ''|| per.hro_hasta ||'') - ''|| per.nro_tramite
                                        when par.id_feriado is not null then
                                        	 fer.descripcion
                                        when par.id_viatico is not null then
                                         	 cdd.motivo ||'' - ''|| cdd.nro_tramite
                                        else
                                         	''Biometrico''
                                     end
                                   )::text as desc_motivo,
                                  extract(dow from par.fecha_marcado)::integer  as desc_dia
                                  from asis.tpares par
                                  inner join segu.tusuario usu1 on usu1.id_usuario = par.id_usuario_reg
                                  inner join orga.vfuncionario vfun on vfun.id_funcionario = par.id_funcionario
                                  left join asis.trango_horario ran on ran.id_rango_horario = par.id_rango_horario
                                  left join segu.tusuario usu2 on usu2.id_usuario = par.id_usuario_mod
                                  left join asis.tpermiso per on per.id_permiso = par.id_permiso
                                  left join asis.tvacacion vac on vac.id_vacacion= par.id_vacacion
                                  left join cd.tcuenta_doc cdd on cdd.id_cuenta_doc = par.id_viatico
                                  left join param.tferiado fer on fer.id_feriado = par.id_feriado
				        		  where par.id_funcionario ='||v_parametros.id_funcionario||' and';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ', dia, hora ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
			raise notice  '%',v_consulta;
			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_PAR_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		mgarcia
 	#FECHA:		19-09-2019 16:00:52
	***********************************/

	elsif(p_transaccion='ASIS_PAR_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros

            if v_parametros.id_funcionario is null then
                raise exception 'Usted no esta registrado como funcionario';
            end if;

			v_consulta:='select count(id_pares)
                                from asis.tpares par
                                inner join segu.tusuario usu1 on usu1.id_usuario = par.id_usuario_reg
                                inner join orga.vfuncionario vfun on vfun.id_funcionario = par.id_funcionario
                                left join asis.trango_horario ran on ran.id_rango_horario = par.id_rango_horario
                                left join segu.tusuario usu2 on usu2.id_usuario = par.id_usuario_mod
                                left join asis.tpermiso per on per.id_permiso = par.id_permiso
                                left join asis.tvacacion vac on vac.id_vacacion= par.id_vacacion
                                left join cd.tcuenta_doc cdd on cdd.id_cuenta_doc = par.id_viatico
                                left join param.tferiado fer on fer.id_feriado = par.id_feriado
                                where  par.id_funcionario ='||v_parametros.id_funcionario||' and';

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

ALTER FUNCTION asis.ft_pares_sel (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;