CREATE OR REPLACE FUNCTION asis.ft_mes_trabajo_det_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.ft_mes_trabajo_det_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.tmes_trabajo_det'
 AUTOR: 		 (miguel.mamani)
 FECHA:	        31-01-2019 16:36:51
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				31-01-2019 16:36:51								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.tmes_trabajo_det'
 #12	ERT			21/08/2019 				 MMV			Nuevo campo COMP detalle hoja de trabajo
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;

BEGIN

	v_nombre_funcion = 'asis.ft_mes_trabajo_det_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'ASIS_MTD_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		miguel.mamani
 	#FECHA:		31-01-2019 16:36:51
	***********************************/

	if(p_transaccion='ASIS_MTD_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select   mtd.id_mes_trabajo_det,
                                  mtd.ingreso_manana,
                                  mtd.id_mes_trabajo,
                                  mtd.id_centro_costo,
                                  mtd.ingreso_tarde,
                                  mtd.extra_autorizada,
                                  mtd.tipo,
                                  mtd.ingreso_noche,
                                  mtd.total_normal,
                                  mtd.estado_reg,
                                  mtd.total_extra,
                                  mtd.salida_manana,
                                  mtd.salida_tarde,
                                  mtd.justificacion_extra,
                                  mtd.salida_noche,
                                  mtd.dia,
                                  mtd.total_nocturna,
                                  mtd.usuario_ai,
                                  mtd.fecha_reg,
                                  mtd.id_usuario_reg,
                                  mtd.id_usuario_ai,
                                  mtd.fecha_mod,
                                  mtd.id_usuario_mod,
                                  usu1.cuenta as usr_reg,
                                  usu2.cuenta as usr_mod,
                                  initcap(cc.codigo_cc) as codigo_cc,
                                  mtd.tipo_dos,
                                  mtd.tipo_tres,
                                  mtd.total_comp, --#12
                                  mes.estado,
                                  mtd.extra,
                                  mtd.fecha,
                                  asis.f_literal_periodo(to_char(mtd.fecha::date,''MM'')::integer) as literal
                                  from asis.tmes_trabajo_det mtd
                                  inner join segu.tusuario usu1 on usu1.id_usuario = mtd.id_usuario_reg
                                  inner join asis.tmes_trabajo mes on mes.id_mes_trabajo = mtd.id_mes_trabajo
                                  left join param.vcentro_costo cc on cc.id_centro_costo = mtd.id_centro_costo
                                  left join segu.tusuario usu2 on usu2.id_usuario = mtd.id_usuario_mod
                                  where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
			raise notice '%',v_consulta;
			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_MTD_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		31-01-2019 16:36:51
	***********************************/

	elsif(p_transaccion='ASIS_MTD_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_mes_trabajo_det),
           						 COALESCE(sum(mtd.total_comp),0) as suma_comp, --#12
            					COALESCE(sum(mtd.total_normal),0) as suma_normal,
                                COALESCE(sum(mtd.total_extra),0) as suma_extra,
                                COALESCE(sum(mtd.total_nocturna),0) as suma_nocturna,
                                COALESCE(sum(mtd.extra_autorizada),0) as suma_autorizada
					    from asis.tmes_trabajo_det mtd
					    inner join segu.tusuario usu1 on usu1.id_usuario = mtd.id_usuario_reg
                        inner join asis.tmes_trabajo mes on mes.id_mes_trabajo = mtd.id_mes_trabajo
                        left join param.vcentro_costo cc on cc.id_centro_costo = mtd.id_centro_costo
                        left join segu.tusuario usu2 on usu2.id_usuario = mtd.id_usuario_mod
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

ALTER FUNCTION asis.ft_mes_trabajo_det_sel (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;