CREATE OR REPLACE FUNCTION "asis"."ft_marcados_sel"(	
				p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying)
RETURNS character varying AS
$BODY$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.ft_marcados_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.tmarcados'
 AUTOR: 		 (mgarcia)
 FECHA:	        12-07-2019 12:56:19
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				12-07-2019 12:56:19								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.tmarcados'	
 #
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
			    
BEGIN

	v_nombre_funcion = 'asis.ft_marcados_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'ASIS_MAS_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		mgarcia	
 	#FECHA:		12-07-2019 12:56:19
	***********************************/

	if(p_transaccion='ASIS_MAS_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						mas.id_marcado,
						mas.estado_reg,
						mas.hora,
						mas.id_biometrico,
						mas.fecha_marcado,
						mas.observacion,
						mas.id_funcionario,
						mas.id_uo,
						mas.id_uo_funcionario,
						mas.id_usuario_reg,
						mas.fecha_reg,
						mas.id_usuario_ai,
						mas.usuario_ai,
						mas.id_usuario_mod,
						mas.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod	
						from asis.tmarcados mas
						inner join segu.tusuario usu1 on usu1.id_usuario = mas.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = mas.id_usuario_mod
				        where  ';
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'ASIS_MAS_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		mgarcia	
 	#FECHA:		12-07-2019 12:56:19
	***********************************/

	elsif(p_transaccion='ASIS_MAS_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_marcado)
					    from asis.tmarcados mas
					    inner join segu.tusuario usu1 on usu1.id_usuario = mas.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = mas.id_usuario_mod
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
$BODY$
LANGUAGE 'plpgsql' VOLATILE
COST 100;
ALTER FUNCTION "asis"."ft_marcados_sel"(integer, integer, character varying, character varying) OWNER TO postgres;
