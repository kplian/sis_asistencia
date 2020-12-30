CREATE OR REPLACE FUNCTION asis.ft_reposicion_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.ft_reposicion_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.treposicion'
 AUTOR: 		 (admin.miguel)
 FECHA:	        15-10-2020 18:57:40
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				15-10-2020 18:57:40								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.treposicion'	
 #
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
			    
BEGIN

	v_nombre_funcion = 'asis.ft_reposicion_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************    
 	#TRANSACCION:  'ASIS_RPC_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		admin.miguel	
 	#FECHA:		15-10-2020 18:57:40
	***********************************/

	if(p_transaccion='ASIS_RPC_SEL')then
     				
    	begin
    		--Sentencia de la consulta
			v_consulta:='select
						rpc.id_reposicion,
						rpc.estado_reg,
						rpc.obs_dba,
						rpc.id_permiso,
						rpc.fecha_reposicion,
						rpc.id_funcionario,
						rpc.evento,
						rpc.tiempo,
						rpc.id_transacion_zkb,
						rpc.id_usuario_reg,
						rpc.fecha_reg,
						rpc.id_usuario_ai,
						rpc.usuario_ai,
						rpc.id_usuario_mod,
						rpc.fecha_mod,
						usu1.cuenta as usr_reg,
						usu2.cuenta as usr_mod,
                        fun.desc_funcionario1,
                        pe.nro_tramite,
                        tp.nombre as tipo_permiso	
						from asis.treposicion rpc
						inner join segu.tusuario usu1 on usu1.id_usuario = rpc.id_usuario_reg
                        inner join orga.vfuncionario fun on fun.id_funcionario = rpc.id_funcionario
                        inner join asis.tpermiso pe on pe.id_permiso = rpc.id_permiso
                        inner join asis.ttipo_permiso tp on tp.id_tipo_permiso = pe.id_tipo_permiso
						left join segu.tusuario usu2 on usu2.id_usuario = rpc.id_usuario_mod
				        where  rpc.id_usuario_reg ='||p_id_usuario||' and' ;
			
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			--Devuelve la respuesta
			return v_consulta;
						
		end;

	/*********************************    
 	#TRANSACCION:  'ASIS_RPC_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		admin.miguel	
 	#FECHA:		15-10-2020 18:57:40
	***********************************/

	elsif(p_transaccion='ASIS_RPC_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:='select count(id_reposicion)
					    from asis.treposicion rpc
					    inner join segu.tusuario usu1 on usu1.id_usuario = rpc.id_usuario_reg
                        inner join orga.vfuncionario fun on fun.id_funcionario = rpc.id_funcionario
                        inner join asis.tpermiso pe on pe.id_permiso = rpc.id_permiso
                        inner join asis.ttipo_permiso tp on tp.id_tipo_permiso = pe.id_tipo_permiso
						left join segu.tusuario usu2 on usu2.id_usuario = rpc.id_usuario_mod
					    where  rpc.id_usuario_reg ='||p_id_usuario||' and';
			
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
PARALLEL UNSAFE
COST 100;