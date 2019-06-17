CREATE OR REPLACE FUNCTION asis.ft_mes_trabajo_con_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.ft_mes_trabajo_con_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.tmes_trabajo_con'
 AUTOR: 		 (miguel.mamani)
 FECHA:	        13-03-2019 13:52:11
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				13-03-2019 13:52:11								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.tmes_trabajo_con'
 #4	ERT			17/06/2019 				 MMV					Correccion bug
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;

BEGIN

	v_nombre_funcion = 'asis.ft_mes_trabajo_con_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'ASIS_MTF_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		miguel.mamani
 	#FECHA:		13-03-2019 13:52:11
	***********************************/

	if(p_transaccion='ASIS_MTF_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select	mtf.id_mes_trabajo_con,
                                mtf.id_tipo_aplicacion,
                                mtf.total_horas,
                                mtf.id_centro_costo,
                                mtf.calculado_resta,
                                mtf.estado_reg,
                                mtf.factor,
                                mtf.id_mes_trabajo,
                                mtf.id_usuario_ai,
                                mtf.id_usuario_reg,
                                mtf.fecha_reg,
                                mtf.usuario_ai,
                                mtf.id_usuario_mod,
                                mtf.fecha_mod,
                                usu1.cuenta as usr_reg,
                                usu2.cuenta as usr_mod,
                                ap.codigo_aplicacion,
                                cc.codigo_tcc
                                from asis.tmes_trabajo_con mtf
                                inner join segu.tusuario usu1 on usu1.id_usuario = mtf.id_usuario_reg
                                inner join asis.ttipo_aplicacion ap on ap.id_tipo_aplicacion = mtf.id_tipo_aplicacion
                                inner join param.vcentro_costo cc on cc.id_centro_costo = mtf.id_centro_costo
                                left join segu.tusuario usu2 on usu2.id_usuario = mtf.id_usuario_mod
                                where ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
			raise notice '%',v_consulta;
			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_MTF_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		13-03-2019 13:52:11
	***********************************/

	elsif(p_transaccion='ASIS_MTF_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_mes_trabajo_con),
                                COALESCE(sum(mtf.total_horas),0) as suma_horas, -- #4
                                COALESCE(sum(mtf.factor),0) as suma_factor -- #4
					    from asis.tmes_trabajo_con mtf
					    inner join segu.tusuario usu1 on usu1.id_usuario = mtf.id_usuario_reg
                        inner join asis.ttipo_aplicacion ap on ap.id_tipo_aplicacion = mtf.id_tipo_aplicacion
                        inner join param.vcentro_costo cc on cc.id_centro_costo = mtf.id_centro_costo
                        left join segu.tusuario usu2 on usu2.id_usuario = mtf.id_usuario_mod
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