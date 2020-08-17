CREATE OR REPLACE FUNCTION asis.ft_grupo_asig_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.ft_grupo_asig_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.tgrupo_asig'
 AUTOR: 		 (miguel.mamani)
 FECHA:	        20-11-2019 20:00:15
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				20-11-2019 20:00:15								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.tgrupo_asig'
 #23			14-08-2020 15:28:39								Refactorizacion rango horadio
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;

BEGIN

	v_nombre_funcion = 'asis.ft_grupo_asig_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'ASIS_GRU_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		miguel.mamani
 	#FECHA:		20-11-2019 20:00:15
	***********************************/

	if(p_transaccion='ASIS_GRU_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						gru.id_grupo_asig,
						gru.codigo,
						gru.estado_reg,
						gru.descripcion,
						gru.usuario_ai,
						gru.fecha_reg,
						gru.id_usuario_reg,
						gru.id_usuario_ai,
						gru.fecha_mod,
						gru.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod
						from asis.tgrupo_asig gru
						inner join segu.tusuario usu1 on usu1.id_usuario = gru.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = gru.id_usuario_mod
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_GRU_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		20-11-2019 20:00:15
	***********************************/

	elsif(p_transaccion='ASIS_GRU_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_grupo_asig)
					    from asis.tgrupo_asig gru
					    inner join segu.tusuario usu1 on usu1.id_usuario = gru.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = gru.id_usuario_mod
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

ALTER FUNCTION asis.ft_grupo_asig_sel (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;