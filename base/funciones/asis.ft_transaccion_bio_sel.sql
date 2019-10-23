CREATE OR REPLACE FUNCTION asis.ft_transaccion_bio_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.ft_transaccion_bio_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.ttransaccion_bio'
 AUTOR: 		 (miguel.mamani)
 FECHA:	        06-09-2019 13:08:03
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				06-09-2019 13:08:03								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.ttransaccion_bio'
 #
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;

BEGIN

	v_nombre_funcion = 'asis.ft_transaccion_bio_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'ASIS_BIO_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		miguel.mamani
 	#FECHA:		06-09-2019 13:08:03
	***********************************/

	if(p_transaccion='ASIS_BIO_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select bio.id_transaccion_bio,
                                bio.obs,
                                bio.estado_reg,
                                bio.id_periodo,
                                bio.hora::varchar,
                                bio.id_funcionario,
                                bio.fecha_marcado,
                                bio.id_rango_horario,
                                bio.id_usuario_reg,
                                bio.usuario_ai,
                                bio.fecha_reg,
                                bio.id_usuario_ai,
                                bio.id_usuario_mod,
                                bio.fecha_mod,
                                usu1.cuenta as usr_reg,
                                usu2.cuenta as usr_mod,
                                bio.evento,
                                bio.tipo_verificacion,
                                bio.area,
                                rh.descripcion as rango,
                                to_char(bio.fecha_marcado,''DD'')::text as dia,
                                bio.acceso,
                                vfun.desc_funcionario1 as desc_funcionario
                                from asis.ttransaccion_bio bio
                                inner join segu.tusuario usu1 on usu1.id_usuario = bio.id_usuario_reg
                                inner join orga.vfuncionario vfun on vfun.id_funcionario = bio.id_funcionario
                                left join asis.trango_horario rh on rh.id_rango_horario = bio.id_rango_horario
                                left join segu.tusuario usu2 on usu2.id_usuario = bio.id_usuario_mod
				        		where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ',dia ,hora asc ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
			raise notice '--> %',v_consulta;
			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_BIO_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		06-09-2019 13:08:03
	***********************************/

	elsif(p_transaccion='ASIS_BIO_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_transaccion_bio)
					    from asis.ttransaccion_bio bio
					    inner join segu.tusuario usu1 on usu1.id_usuario = bio.id_usuario_reg
                        inner join orga.vfuncionario vfun on vfun.id_funcionario = bio.id_funcionario
                        left join asis.trango_horario rh on rh.id_rango_horario = bio.id_rango_horario
						left join segu.tusuario usu2 on usu2.id_usuario = bio.id_usuario_mod
					    where ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;

    /*********************************
 	#TRANSACCION:  'ASIS_BIORPT_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		sazp
 	#FECHA:		21-10-2019 10:08:03
	***********************************/

	elseif(p_transaccion='ASIS_BIORPT_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select bio.id_transaccion_bio,
                                bio.obs,
                                bio.estado_reg,
                                bio.id_periodo,
                                bio.hora::varchar,
                                bio.id_funcionario,
                                bio.fecha_marcado,
                                bio.id_rango_horario,
                                bio.id_usuario_reg,
                                bio.usuario_ai,
                                bio.fecha_reg,
                                bio.id_usuario_ai,
                                bio.id_usuario_mod,
                                bio.fecha_mod,
                                usu1.cuenta as usr_reg,
                                usu2.cuenta as usr_mod,
                                bio.evento,
                                bio.tipo_verificacion,
                                bio.area,
                                rh.descripcion as rango,
                                to_char(bio.fecha_marcado,''DD'')::text as dia,
                                bio.acceso,
                                vfun.desc_funcionario1 as nombre
                                from asis.ttransaccion_bio bio
                                inner join segu.tusuario usu1 on usu1.id_usuario = bio.id_usuario_reg
                                left join asis.trango_horario rh on rh.id_rango_horario = bio.id_rango_horario
                                left join segu.tusuario usu2 on usu2.id_usuario = bio.id_usuario_mod
                                inner join orga.vfuncionario vfun on vfun.id_funcionario = bio.id_funcionario
				        		where  bio.id_funcionario = '||591|| ' and bio.id_periodo ='||v_parametros.id_periodo ||' order by bio.fecha_marcado, bio.hora';


			--Definicion de la respuesta
			raise notice '--> %',v_consulta;
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

ALTER FUNCTION asis.ft_transaccion_bio_sel (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;