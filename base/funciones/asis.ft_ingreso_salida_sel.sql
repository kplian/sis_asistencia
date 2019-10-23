CREATE OR REPLACE FUNCTION asis.ft_ingreso_salida_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.ft_ingreso_salida_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.tingreso_salida'
 AUTOR: 		 (jjimenez)
 FECHA:	        14-08-2019 12:53:11
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				14-08-2019 12:53:11							Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.tingreso_salida'
 #14			23-08-2019 12:53:11		Juan 				Archivo Nuevo Control diario de ingreso salida a la empresa Ende Transmision S.A.'
 #
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;

BEGIN

	v_nombre_funcion = 'asis.ft_ingreso_salida_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'ASIS_CONDIA_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		jjimenez
 	#FECHA:		14-08-2019 12:53:11
	***********************************/

	if(p_transaccion='ASIS_CONDIA_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						condia.id_ingreso_salida,
						condia.id_funcionario,
						condia.hora,
						condia.fecha,
						condia.tipo,
						condia.estado_reg,
						condia.id_usuario_ai,
						condia.id_usuario_reg,
						condia.fecha_reg,
						condia.usuario_ai,
						condia.fecha_mod,
						condia.id_usuario_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,

                        (p.nombre||'' ''||p.ap_paterno||'' ''||p.ap_materno)::varchar as funcionario

						from asis.tingreso_salida condia
						inner join segu.tusuario usu1 on usu1.id_usuario = condia.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = condia.id_usuario_mod
                        join orga.tfuncionario f on f.id_funcionario=condia.id_funcionario
                        join segu.vpersona p on p.id_persona=f.id_persona

				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_CONDIA_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		jjimenez
 	#FECHA:		14-08-2019 12:53:11
	***********************************/

	elsif(p_transaccion='ASIS_CONDIA_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_ingreso_salida)
					    from asis.tingreso_salida condia
					    inner join segu.tusuario usu1 on usu1.id_usuario = condia.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = condia.id_usuario_mod
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

ALTER FUNCTION asis.ft_ingreso_salida_sel (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;