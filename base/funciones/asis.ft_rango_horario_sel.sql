CREATE OR REPLACE FUNCTION asis.ft_rango_horario_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.ft_rango_horario_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.trango_horario'
 AUTOR: 		 (mgarcia)
 FECHA:	        19-08-2019 15:28:39
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				19-08-2019 15:28:39								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.trango_horario'
 #23			14-08-2020 15:28:39								Refactorizacion rango horadio
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;

BEGIN

	v_nombre_funcion = 'asis.ft_rango_horario_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'ASIS_RHO_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		mgarcia
 	#FECHA:		19-08-2019 15:28:39
	***********************************/

	if(p_transaccion='ASIS_RHO_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						rho.id_rango_horario,
						rho.estado_reg,
						rho.codigo,
						rho.descripcion,
						rho.hora_entrada,
						rho.hora_salida,
						rho.rango_entrada_ini,
						rho.rango_entrada_fin,
						rho.rango_salida_ini,
						rho.rango_salida_fin,
						rho.fecha_desde,
						rho.fecha_hasta,
						rho.tolerancia_retardo,
						rho.jornada_laboral,
						rho.lunes,
						rho.martes,
						rho.miercoles,
						rho.jueves,
						rho.viernes,
						rho.sabado,
                        rho.domingo,
						rho.id_usuario_reg,
						rho.fecha_reg,
						rho.id_usuario_ai,
						rho.usuario_ai,
						rho.id_usuario_mod,
						rho.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod
						from asis.trango_horario rho
						inner join segu.tusuario usu1 on usu1.id_usuario = rho.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = rho.id_usuario_mod
				        where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_RHO_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		mgarcia
 	#FECHA:		19-08-2019 15:28:39
	***********************************/

	elsif(p_transaccion='ASIS_RHO_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_rango_horario)
					    from asis.trango_horario rho
					    inner join segu.tusuario usu1 on usu1.id_usuario = rho.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = rho.id_usuario_mod
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

ALTER FUNCTION asis.ft_rango_horario_sel (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;