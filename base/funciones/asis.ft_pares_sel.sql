CREATE OR REPLACE FUNCTION asis.ft_pares_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.ft_pares_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.tpares'
 AUTOR: 		 (mgarcia)
 FECHA:	        19-09-2019 16:00:52
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				19-09-2019 16:00:52								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.tpares'
 #
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;

BEGIN

	v_nombre_funcion = 'asis.ft_pares_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'ASIS_PAR_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		mgarcia
 	#FECHA:		19-09-2019 16:00:52
	***********************************/

	if(p_transaccion='ASIS_PAR_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select	  par.id_pares,
                                  par.estado_reg,
                                  par.id_transaccion_ini,
                                  par.id_transaccion_fin,
                                  par.fecha_marcado,
                                  par.id_funcionario,
                                  par.id_licencia,
                                  par.id_vacacion,
                                  par.id_viatico,
                                  par.id_usuario_reg,
                                  par.fecha_reg,
                                  par.id_usuario_ai,
                                  par.usuario_ai,
                                  par.id_usuario_mod,
                                  par.fecha_mod,
                                  usu1.cuenta as usr_reg,
                                  usu2.cuenta as usr_mod,
                                  (case
                                      when to_char(te.fecha_marcado, ''DD''::text) is not null then
                                       to_char(te.fecha_marcado, ''DD''::text)
                                      else
                                      to_char(ts.fecha_marcado, ''DD''::text)
                                      end )::integer as dia,
                                  (case
                                     when te.hora is not null and ts.hora is not null then
                                      	  ts.hora::varchar||'' - ''||te.hora::varchar
                                      when te.hora is not null then
                                      te.hora::varchar
                                      else
                                       ts.hora::varchar
                                       end )::varchar as hora,
                                       (case

                                          when te.hora is not null and ts.hora is not null then
                                      			ts.evento ||'' - ''||te.evento
                                           when te.evento is not null then
                                          		te.evento
                                          else
                                          ts.evento
                                          end)::varchar as evento,
                                           (case
                                          when te.evento is not null then
                                          te.tipo_verificacion
                                          else
                                          ts.tipo_verificacion
                                          end)::varchar as tipo_verificacion,
                                          (case
                                           when te.hora is not null and ts.hora is not null then
                                           ''JUSTIFICAR''::varchar
                                          when te.evento is not null then
                                          te.obs
                                          else
                                          ts.obs
                                          end)::varchar as obs,
                                          (case
                                            when te.evento is not null then
                                          re.descripcion
                                          else
                                          rs.descripcion
                                          end)::varchar as rango,
                                          par.rango as tdo,
                                          vfun.desc_funcionario1 as desc_funcionario
                                  from asis.tpares par
                                  inner join segu.tusuario usu1 on usu1.id_usuario = par.id_usuario_reg
                                  inner join orga.vfuncionario vfun on vfun.id_funcionario = par.id_funcionario
                                  left join segu.tusuario usu2 on usu2.id_usuario = par.id_usuario_mod
                                  left join asis.ttransaccion_bio te on te.id_transaccion_bio = par.id_transaccion_ini
                                  left join asis.trango_horario re on re.id_rango_horario = te.id_rango_horario
                                  left join asis.ttransaccion_bio ts on ts.id_transaccion_bio = par.id_transaccion_fin
                                  left join asis.trango_horario rs on rs.id_rango_horario = ts.id_rango_horario
				        		  where  ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by dia,hora, ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_PAR_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		mgarcia
 	#FECHA:		19-09-2019 16:00:52
	***********************************/

	elsif(p_transaccion='ASIS_PAR_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_pares)
					    from asis.tpares par
					    inner join segu.tusuario usu1 on usu1.id_usuario = par.id_usuario_reg
                        inner join orga.vfuncionario vfun on vfun.id_funcionario = par.id_funcionario
                        left join segu.tusuario usu2 on usu2.id_usuario = par.id_usuario_mod
                        left join asis.ttransaccion_bio te on te.id_transaccion_bio = par.id_transaccion_ini
                        left join asis.trango_horario re on re.id_rango_horario = te.id_rango_horario
                        left join asis.ttransaccion_bio ts on ts.id_transaccion_bio = par.id_transaccion_fin
                        left join asis.trango_horario rs on rs.id_rango_horario = ts.id_rango_horario
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

ALTER FUNCTION asis.ft_pares_sel (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;