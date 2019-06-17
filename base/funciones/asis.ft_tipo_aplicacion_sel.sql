CREATE OR REPLACE FUNCTION asis.ft_tipo_aplicacion_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.ft_tipo_aplicacion_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.ttipo_aplicacion'
 AUTOR: 		 (miguel.mamani)
 FECHA:	        21-02-2019 13:27:56
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				21-02-2019 13:27:56								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.ttipo_aplicacion'
 #4	ERT			17/06/2019 				 MMV					Correccion bug
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;

BEGIN

	v_nombre_funcion = 'asis.ft_tipo_aplicacion_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'ASIS_TAS_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		miguel.mamani
 	#FECHA:		21-02-2019 13:27:56
	***********************************/

	if(p_transaccion='ASIS_TAS_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						tas.id_tipo_aplicacion,
						tas.id_tipo_columna,
						tas.nombre,
						tas.descripcion,
						tas.codigo_aplicacion,
						tas.estado_reg,
						tas.consolidable,
						tas.id_usuario_ai,
						tas.fecha_reg,
						tas.usuario_ai,
						tas.id_usuario_reg,
						tas.fecha_mod,
						tas.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        tc.nombre as desc_tipo_columna
						from asis.ttipo_aplicacion tas
						inner join segu.tusuario usu1 on usu1.id_usuario = tas.id_usuario_reg
                        left join plani.ttipo_columna tc on tc.id_tipo_columna = tas.id_tipo_columna --#4
						left join segu.tusuario usu2 on usu2.id_usuario = tas.id_usuario_mod
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_TAS_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		21-02-2019 13:27:56
	***********************************/

	elsif(p_transaccion='ASIS_TAS_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_tipo_aplicacion)
					    from asis.ttipo_aplicacion tas
					    inner join segu.tusuario usu1 on usu1.id_usuario = tas.id_usuario_reg
                        left join plani.ttipo_columna tc on tc.id_tipo_columna = tas.id_tipo_columna --#4
						left join segu.tusuario usu2 on usu2.id_usuario = tas.id_usuario_mod
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