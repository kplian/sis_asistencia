CREATE OR REPLACE FUNCTION asis.ft_movimiento_vacacion_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.ft_movimiento_vacacion_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.tmovimiento_vacacion'
 AUTOR: 		 (miguel.mamani)
 FECHA:	        08-10-2019 10:39:21
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				08-10-2019 10:39:21								Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.tmovimiento_vacacion'
 #
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;
    v_filtro			varchar;
    v_record			record;

BEGIN

	v_nombre_funcion = 'asis.ft_movimiento_vacacion_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'ASIS_MVS_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		miguel.mamani
 	#FECHA:		08-10-2019 10:39:21
	***********************************/

	if(p_transaccion='ASIS_MVS_SEL')then

    	begin

            v_filtro = '';
            	if  pxp.f_existe_parametro(p_tabla,'interfaz') then  --condicional a causa de que no existe en vista.
                	if v_parametros.interfaz = 'MovVacUsuario' then
                    	if p_administrador = 1 then
                       		if  pxp.f_existe_parametro(p_tabla,'id_funcionario') then
                       			if v_parametros.id_funcionario is null then
                       				-- raise exception 'Tu usuario no esta  registrado com funcionario';
                                    v_filtro= 'mvs.id_funcionario ='||v_parametros.id_funcionario||' and';
                            	end if;
                       	 		v_filtro= 'mvs.id_funcionario ='||v_parametros.id_funcionario||' and';
                    		end if;
                    	end if;
                    if pxp.f_existe_parametro(p_tabla,'id_funcionario') then
                    	v_filtro= 'mvs.id_funcionario ='||v_parametros.id_funcionario||' and';
                   	end if;
                end if;
    			end if;




    		--Sentencia de la consulta
                v_consulta:='select
                          mvs.id_movimiento_vacacion,
                          mvs.activo,
                          mvs.id_funcionario,
                		  (case
                          when mvs.tipo in (''ACUMULADA'',''CADUCADA'') and mvs.desde is null then
                               mvs.fecha_reg::date
                               else
                               mvs.desde
                               end  ) as desde,
                          mvs.hasta,
                          (
                          case
                          	when mvs.dias < 0 then
                            -1 * mvs.dias
                            else
                          	mvs.dias
                            end ) as dias,
                          mvs.tipo,
                          mvs.dias_actual,
                          mvs.id_usuario_reg,
                          mvs.fecha_reg,
                          mvs.id_usuario_ai,
                          mvs.usuario_ai,
                          mvs.id_usuario_mod,
                          mvs.fecha_mod,
                          usu1.cuenta as usr_reg,
                          usu2.cuenta as usr_mod,
                          (p.nombre||'' ''||p.apellido_paterno||'' ''||p.apellido_materno)::varchar as funcionario,
                          p.nombre::varchar,
                          p.apellido_paterno::varchar,
                          p.apellido_materno::varchar

                          from asis.tmovimiento_vacacion mvs
                          inner join segu.tusuario usu1 on usu1.id_usuario = mvs.id_usuario_reg
                          left join segu.tusuario usu2 on usu2.id_usuario = mvs.id_usuario_mod
                          join orga.tfuncionario f on f.id_funcionario = mvs.id_funcionario
                          join segu.tpersona p on p.id_persona = f.id_persona

                          where  mvs.estado_reg = ''activo'' and '||v_filtro;

              --Definicion de la respuesta
              v_consulta:=v_consulta||v_parametros.filtro;
              v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

			RAISE NOTICE '%', v_consulta;

			--Devuelve la respuesta
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_MVS_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		08-10-2019 10:39:21
	***********************************/

	elsif(p_transaccion='ASIS_MVS_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
               v_filtro = '';
               if  pxp.f_existe_parametro(p_tabla,'interfaz') then
                 if v_parametros.interfaz = 'MovVacUsuario' then
                 	if p_administrador = 1 then
                       if  pxp.f_existe_parametro(p_tabla,'id_funcionario') then
                       		if v_parametros.id_funcionario is null then
                       			raise exception 'Tu usuario no esta  registrado com funcionario';
                            end if;
                       	 v_filtro= 'mvs.id_funcionario ='||v_parametros.id_funcionario||' and';
                   		end if;
                    end if;
                    if  pxp.f_existe_parametro(p_tabla,'id_funcionario') then
                       v_filtro= 'mvs.id_funcionario ='||v_parametros.id_funcionario||' and';
                   	end if;
                  end if;
               end if;

			v_consulta:='select count(id_movimiento_vacacion)
					    from asis.tmovimiento_vacacion mvs
					    inner join segu.tusuario usu1 on usu1.id_usuario = mvs.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = mvs.id_usuario_mod
                        join orga.tfuncionario f on f.id_funcionario = mvs.id_funcionario
                        join segu.tpersona p on p.id_persona = f.id_persona
					    where mvs.estado_reg = ''activo'' and'||v_filtro;

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