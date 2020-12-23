CREATE OR REPLACE FUNCTION asis.ft_asignar_rango_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.ft_asignar_rango_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.tasignar_rango'
 AUTOR: 		 (miguel.mamani)
 FECHA:	        05-09-2019 21:07:38
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				05-09-2019 21:07:38								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.tasignar_rango'
 #23			14-08-2020 15:28:39								Refactorizacion rango horadio
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;

BEGIN

	v_nombre_funcion = 'asis.ft_asignar_rango_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'ASIS_ARO_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		miguel.mamani
 	#FECHA:		05-09-2019 21:07:38
	***********************************/

	if(p_transaccion='ASIS_ARO_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select aro.asignar_rango,
                                aro.id_rango_horario,
                                aro.estado_reg,
                                aro.hasta,
                                aro.id_uo,
                                aro.id_funcionario,
                                aro.desde,
                                aro.id_usuario_reg,
                                aro.fecha_reg,
                                aro.usuario_ai,
                                aro.id_usuario_ai,
                                aro.fecha_mod,
                                aro.id_usuario_mod,
                                usu1.cuenta as usr_reg,
                                usu2.cuenta as usr_mod,
                                initcap(fu.desc_funcionario1) as desc_funcionario,
                                initcap(uo.nombre_unidad) as desc_uo,
                                gra.descripcion ||'' (''||gra.codigo||'')'' as desc_grupos,
                                aro.id_grupo_asig
                                from asis.tasignar_rango aro
                                inner join segu.tusuario usu1 on usu1.id_usuario = aro.id_usuario_reg
                                left join segu.tusuario usu2 on usu2.id_usuario = aro.id_usuario_mod
                                left join orga.vfuncionario fu on fu.id_funcionario = aro.id_funcionario
                                left join orga.tuo uo on uo.id_uo = aro.id_uo
                                left join asis.tgrupo_asig gra on gra.id_grupo_asig = aro.id_grupo_asig
                                where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_ARO_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		05-09-2019 21:07:38
	***********************************/

	elsif(p_transaccion='ASIS_ARO_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(asignar_rango)
					    from asis.tasignar_rango aro
					    inner join segu.tusuario usu1 on usu1.id_usuario = aro.id_usuario_reg
                        left join segu.tusuario usu2 on usu2.id_usuario = aro.id_usuario_mod
                        left join orga.vfuncionario fu on fu.id_funcionario = aro.id_funcionario
                        left join orga.tuo uo on uo.id_uo = aro.id_uo
                        left join asis.tgrupo_asig gra on gra.id_grupo_asig = aro.id_grupo_asig
					    where ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;
    /*********************************
 	#TRANSACCION:  'ASIS_UO_SEL'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		17/02/2020
	***********************************/

	elsif(p_transaccion='ASIS_UO_SEL')then

		begin

			--Sentencia de la consulta de conteo de registros
			v_consulta:=' select  uo.id_uo,
                                  uo.codigo,
          						  uo.descripcion
                            from orga.tuo uo
                            where uo.estado_reg=''activo'' and
                                  (uo.gerencia = ''si'')
                                   and uo.gerencia = ''si''
                                   and uo.id_uo not in (select COALESCE(ar.id_uo,0)
                                   from asis.tasignar_rango ar
                                   where ar.id_rango_horario = '||v_parametros.id_rango_horario||') and';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;

			--Devuelve la respuesta
			return v_consulta;

		end;
    /*********************************
 	#TRANSACCION:  'ASIS_UO_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		17/02/2020
	***********************************/

	elsif(p_transaccion='ASIS_UO_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:=' select count(uo.id_uo)
                          from orga.tuo uo
                          where uo.estado_reg=''activo'' and
                                (uo.gerencia = ''si'')
                                 and uo.gerencia = ''si''
                                 and uo.id_uo not in (select COALESCE(ar.id_uo,0)
                                                       from asis.tasignar_rango ar
                                                       where ar.id_rango_horario = '||v_parametros.id_rango_horario||' ) and ';

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

ALTER FUNCTION asis.ft_asignar_rango_sel (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;