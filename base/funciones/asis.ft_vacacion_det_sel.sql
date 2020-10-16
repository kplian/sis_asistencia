CREATE OR REPLACE FUNCTION asis.ft_vacacion_det_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.ft_vacacion_det_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.tvacacion_det'
 AUTOR: 		 (admin.miguel)
 FECHA:	        30-12-2019 13:41:59
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				30-12-2019 13:41:59								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.tvacacion_det'
 #25			14-08-2020 15:28:39		MMV						Refactorizacion vacaciones

 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;

BEGIN

	v_nombre_funcion = 'asis.ft_vacacion_det_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'ASIS_VDE_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin.miguel
 	#FECHA:		30-12-2019 13:41:59
	***********************************/

	if(p_transaccion='ASIS_VDE_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						vde.id_vacacion_det,
						vde.id_vacacion,
						vde.fecha_dia,
						vde.tiempo,
						vde.estado_reg,
						vde.id_usuario_ai,
						vde.usuario_ai,
						vde.fecha_reg,
						vde.id_usuario_reg,
						vde.fecha_mod,
						vde.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod
						from asis.tvacacion_det vde
						inner join segu.tusuario usu1 on usu1.id_usuario = vde.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = vde.id_usuario_mod
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_VDE_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin.miguel
 	#FECHA:		30-12-2019 13:41:59
	***********************************/

	elsif(p_transaccion='ASIS_VDE_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_vacacion_det)
					    from asis.tvacacion_det vde
					    inner join segu.tusuario usu1 on usu1.id_usuario = vde.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = vde.id_usuario_mod
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

ALTER FUNCTION asis.ft_vacacion_det_sel (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;