--------------- SQL ---------------

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
 #
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;

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
    		--Sentencia de la consulta
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
                        vf.desc_funcionario1::varchar as funcionario
						from asis.tvacacion vac
						inner join segu.tusuario usu1 on usu1.id_usuario = vac.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = vac.id_usuario_mod
                        join orga.tfuncionario f on f.id_funcionario = vac.id_funcionario
                        join orga.vfuncionario vf on vf.id_funcionario = f.id_funcionario
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

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
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_vacacion)
					    from asis.tvacacion vac
					    inner join segu.tusuario usu1 on usu1.id_usuario = vac.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = vac.id_usuario_mod
					    where ';

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