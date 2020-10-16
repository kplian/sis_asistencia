CREATE OR REPLACE FUNCTION asis.ft_grupo_asig_det_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.ft_grupo_asig_det_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.tgrupo_asig_det'
 AUTOR: 		 (miguel.mamani)
 FECHA:	        20-11-2019 20:55:17
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				20-11-2019 20:55:17								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.tgrupo_asig_det'
  #23			14-08-2020 15:28:39								Refactorizacion rango horadio

 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;

BEGIN

	v_nombre_funcion = 'asis.ft_grupo_asig_det_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'ASIS_GRD_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		miguel.mamani
 	#FECHA:		20-11-2019 20:55:17
	***********************************/

	if(p_transaccion='ASIS_GRD_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						grd.id_id_grupo_asig_det,
						grd.estado_reg,
						grd.id_funcionario,
						grd.id_grupo_asig,
						grd.id_usuario_reg,
						grd.usuario_ai,
						grd.fecha_reg,
						grd.id_usuario_ai,
						grd.id_usuario_mod,
						grd.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        fun.desc_funcionario1 as nombre_completo,
                        fun.codigo
						from asis.tgrupo_asig_det grd
						inner join segu.tusuario usu1 on usu1.id_usuario = grd.id_usuario_reg
                        inner join orga.vfuncionario fun on fun.id_funcionario = grd.id_funcionario
						left join segu.tusuario usu2 on usu2.id_usuario = grd.id_usuario_mod
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_GRD_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		20-11-2019 20:55:17
	***********************************/

	elsif(p_transaccion='ASIS_GRD_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_id_grupo_asig_det)
					    from asis.tgrupo_asig_det grd
					    inner join segu.tusuario usu1 on usu1.id_usuario = grd.id_usuario_reg
                        inner join orga.vfuncionario fun on fun.id_funcionario = grd.id_funcionario
						left join segu.tusuario usu2 on usu2.id_usuario = grd.id_usuario_mod
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

ALTER FUNCTION asis.ft_grupo_asig_det_sel (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;