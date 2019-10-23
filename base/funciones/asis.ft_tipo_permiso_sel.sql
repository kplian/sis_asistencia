CREATE OR REPLACE FUNCTION asis.ft_tipo_permiso_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.ft_tipo_permiso_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.ttipo_permiso'
 AUTOR: 		 (miguel.mamani)
 FECHA:	        16-10-2019 13:14:01
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				16-10-2019 13:14:01								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.ttipo_permiso'
 #
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;

BEGIN

	v_nombre_funcion = 'asis.ft_tipo_permiso_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'ASIS_TPO_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		miguel.mamani
 	#FECHA:		16-10-2019 13:14:01
	***********************************/

	if(p_transaccion='ASIS_TPO_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						tpo.id_tipo_permiso,
						tpo.estado_reg,
						tpo.codigo,
						tpo.nombre,
						tpo.tiempo,
						tpo.id_usuario_reg,
						tpo.fecha_reg,
						tpo.id_usuario_ai,
						tpo.usuario_ai,
						tpo.id_usuario_mod,
						tpo.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        tpo.documento,
                        tpo.asignar_rango
						from asis.ttipo_permiso tpo
						inner join segu.tusuario usu1 on usu1.id_usuario = tpo.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = tpo.id_usuario_mod
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_TPO_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		16-10-2019 13:14:01
	***********************************/

	elsif(p_transaccion='ASIS_TPO_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_tipo_permiso)
					    from asis.ttipo_permiso tpo
					    inner join segu.tusuario usu1 on usu1.id_usuario = tpo.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = tpo.id_usuario_mod
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

ALTER FUNCTION asis.ft_tipo_permiso_sel (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;