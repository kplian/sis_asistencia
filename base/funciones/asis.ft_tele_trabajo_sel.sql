CREATE OR REPLACE FUNCTION asis.ft_tele_trabajo_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:        Sistema de Asistencia
 FUNCION:         asis.ft_tele_trabajo_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.ttele_trabajo'
 AUTOR:          (admin.miguel)
 FECHA:            01-02-2021 14:53:44
 COMENTARIOS:    
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE                FECHA                AUTOR                DESCRIPCION
 #0                01-02-2021 14:53:44    admin.miguel             Creacion    
 #
 ***************************************************************************/

DECLARE

    v_consulta            VARCHAR;
    v_parametros          RECORD;
    v_nombre_funcion      TEXT;
    v_resp                VARCHAR;
    v_filtro			  varchar;
	v_id_funcionario	  integer;
                
BEGIN

    v_nombre_funcion = 'asis.ft_tele_trabajo_sel';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************    
     #TRANSACCION:  'ASIS_TLT_SEL'
     #DESCRIPCION:    Consulta de datos
     #AUTOR:        admin.miguel    
     #FECHA:        01-02-2021 14:53:44
    ***********************************/

    IF (p_transaccion='ASIS_TLT_SEL') THEN
                     
        BEGIN
        
        	v_filtro = '';
        
        	if (v_parametros.tipo_interfaz = 'SolTeleTrabajo')then
            	
            	v_filtro = '( tlt.id_usuario_reg = '||p_id_usuario|| ') and ';
                
            end if;
            
            if (v_parametros.tipo_interfaz = 'TeleTrabajoVoBo')then
            	
            	 if p_administrador != 1  then

                	select f.id_funcionario into v_id_funcionario
                    from segu.vusuario u
                	inner join orga.vfuncionario_persona f on f.id_persona = u.id_persona
                    where u.id_usuario = p_id_usuario;

                     if v_id_funcionario is not null then
                    	v_filtro = 'tlt.id_responsable =  '||v_id_funcionario||' and ';
                     end if;
               	end if; 
                
            end if;
        
            --Sentencia de la consulta
            v_consulta:='select   tlt.id_tele_trabajo,
                                  tlt.estado_reg,
                                  tlt.id_funcionario,
                                  tlt.id_responsable,
                                  tlt.fecha_inicio,
                                  tlt.fecha_fin,
                                  tlt.justificacion,
                                  tlt.id_usuario_reg,
                                  tlt.fecha_reg,
                                  tlt.id_usuario_ai,
                                  tlt.usuario_ai,
                                  tlt.id_usuario_mod,
                                  tlt.fecha_mod,
                                  usu1.cuenta as usr_reg,
                                  usu2.cuenta as usr_mod,
                                  tlt.estado,
                                  tlt.nro_tramite,
                                  tlt.id_proceso_wf,
                                  tlt.id_estado_wf,
                                  fu.desc_funcionario2 as funcionario,
                                  res.desc_funcionario2 as responsable   
                                  from asis.ttele_trabajo tlt
                                  inner join segu.tusuario usu1 ON usu1.id_usuario = tlt.id_usuario_reg
                                  inner join orga.vfuncionario fu on fu.id_funcionario = tlt.id_funcionario
                                  inner join orga.vfuncionario res on res.id_funcionario = tlt.id_responsable
                                  left join segu.tusuario usu2 ON usu2.id_usuario = tlt.id_usuario_mod
                       	 		  where '||v_filtro;
            
            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            --Devuelve la respuesta
            RETURN v_consulta;
                        
        END;

    /*********************************    
     #TRANSACCION:  'ASIS_TLT_CONT'
     #DESCRIPCION:    Conteo de registros
     #AUTOR:        admin.miguel    
     #FECHA:        01-02-2021 14:53:44
    ***********************************/

    ELSIF (p_transaccion='ASIS_TLT_CONT') THEN

        BEGIN
            --Sentencia de la consulta de conteo de registros
            v_consulta:='select COUNT(id_tele_trabajo)
                        from asis.ttele_trabajo tlt
                        inner join segu.tusuario usu1 ON usu1.id_usuario = tlt.id_usuario_reg
                        inner join orga.vfuncionario fu on fu.id_funcionario = tlt.id_funcionario
                        inner join orga.vfuncionario res on res.id_funcionario = tlt.id_responsable
                        left join segu.tusuario usu2 ON usu2.id_usuario = tlt.id_usuario_mod
                        where ';
            
            --Definicion de la respuesta            
            v_consulta:=v_consulta||v_parametros.filtro;

            --Devuelve la respuesta
            RETURN v_consulta;

        END;
                    
    ELSE
                         
        RAISE EXCEPTION 'Transaccion inexistente';
                             
    END IF;
                    
EXCEPTION
                    
    WHEN OTHERS THEN
            v_resp='';
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
            v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
            v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
            RAISE EXCEPTION '%',v_resp;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
PARALLEL UNSAFE
COST 100;