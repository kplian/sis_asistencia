CREATE OR REPLACE FUNCTION asis.ft_compensacion_sel (
    p_administrador integer,
    p_id_usuario integer,
    p_tabla varchar,
    p_transaccion varchar
)
    RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:        Sistema de Asistencia
 FUNCION:         asis.ft_compensacion_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.tcompensacion'
 AUTOR:          (amamani)
 FECHA:            18-05-2021 14:14:39
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE                FECHA                AUTOR                DESCRIPCION
 #0                18-05-2021 14:14:39    amamani             Creacion
 #
 ***************************************************************************/

DECLARE

    v_consulta       VARCHAR;
    v_parametros     RECORD;
    v_nombre_funcion TEXT;
    v_resp           VARCHAR;
    v_id_funcionario INTEGER;
    v_count          INTEGER;
    v_filtro         VARCHAR;

BEGIN

    v_nombre_funcion = 'asis.ft_compensacion_sel';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
     #TRANSACCION:  'ASIS_CPM_SEL'
     #DESCRIPCION:    Consulta de datos
     #AUTOR:        amamani
     #FECHA:        18-05-2021 14:14:39
    ***********************************/

    IF (p_transaccion = 'ASIS_CPM_SEL') THEN

        BEGIN
            IF (v_parametros.tipo_interfaz = 'ComponsacionSol') THEN
                select fp.id_funcionario
                into v_id_funcionario
                from segu.vusuario usu
                         inner join orga.vfuncionario_persona fp on fp.id_persona = usu.id_persona
                         inner join asis.tpermiso p on p.id_funcionario = fp.id_funcionario
                where usu.id_usuario = p_id_usuario;

                select count(p.id_permiso)
                into v_count
                from asis.tpermiso p
                where p.id_usuario_reg = p_id_usuario;

                v_filtro = '';

                IF (p_administrador != 1) THEN
                    IF (v_id_funcionario is null and v_count = 0) THEN
                        v_filtro = '( cpm.id_usuario_reg = ' || p_id_usuario || ') and ';
                    ELSE
                        IF (v_id_funcionario is null) THEN
                            v_filtro = '( cpm.id_usuario_reg = ' || p_id_usuario || ') and ';
                        ELSE
                            v_filtro = '(cpm.id_funcionario = ' || v_id_funcionario || ' or cpm.id_usuario_reg = ' ||
                                       p_id_usuario || ') and ';
                        END IF;
                    END IF;
                END IF;

            END IF;

            IF (v_parametros.tipo_interfaz = 'ComponsacionVoBo') THEN
                v_filtro = '';
                IF (p_administrador != 1) THEN
                    select f.id_funcionario
                    into v_id_funcionario
                    from segu.vusuario u
                             inner join orga.vfuncionario_persona f on f.id_persona = u.id_persona
                    where u.id_usuario = p_id_usuario;

                    IF (v_id_funcionario is not null) THEN
                        v_filtro = 'cpm.id_responsable =  ' || v_id_funcionario || ' and ';
                    END IF;
                END IF;
            END IF;

            IF (v_parametros.tipo_interfaz = 'CompensacionRrhh') THEN
                v_filtro = '';
            END IF;

            --Sentencia de la consulta
            v_consulta := 'SELECT   cpm.id_compensacion,
                                   cpm.estado_reg,
                                   cpm.id_funcionario,
                                   cpm.id_responsable,
                                   cpm.desde,
                                   cpm.hasta,
                                   cpm.dias,
                                   cpm.desde_comp,
                                   cpm.hasta_comp,
                                   cpm.dias_comp,
                                   cpm.justificacion,
                                   cpm.id_usuario_reg,
                                   cpm.fecha_reg,
                                   cpm.id_usuario_ai,
                                   cpm.usuario_ai,
                                   cpm.id_usuario_mod,
                                   cpm.fecha_mod,
                                   usu1.cuenta as usr_reg,
                                   usu2.cuenta as usr_mod,
                                   cpm.id_proceso_wf,
                                   cpm.id_estado_wf,
                                   cpm.estado,
                                   cpm.nro_tramite,
                                   f.desc_funcionario2  as funcionario,
                                   r.desc_funcionario2 as responsable,
                                   cpm.social_forestal,
                                   ger.id_uo,
                                   ger.nombre_unidad as gerencia
                            FROM asis.tcompensacion cpm
                                     JOIN segu.tusuario usu1 ON usu1.id_usuario = cpm.id_usuario_reg
                                     JOIN orga.vfuncionario_cargo f on f.id_funcionario = cpm.id_funcionario
                                     JOIN orga.vfuncionario r on r.id_funcionario = cpm.id_responsable
                                     JOIN orga.tuo ger ON ger.id_uo = orga.f_get_uo_gerencia(f.id_uo, NULL::integer, NULL::date)
                                     LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = cpm.id_usuario_mod
                            WHERE  f.fecha_asignacion <=  now()::date and
                          (f.fecha_finalizacion is null or f.fecha_finalizacion >= now()::date) AND  ' || v_filtro;

            --Definicion de la respuesta
            v_consulta := v_consulta || v_parametros.filtro;
            v_consulta := v_consulta || ' order by ' || v_parametros.ordenacion || ' ' ||
                          v_parametros.dir_ordenacion ||
                          ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            --Devuelve la respuesta
            RETURN v_consulta;

        END;

        /*********************************
         #TRANSACCION:  'ASIS_CPM_CONT'
         #DESCRIPCION:    Conteo de registros
         #AUTOR:        amamani
         #FECHA:        18-05-2021 14:14:39
        ***********************************/

    ELSIF (p_transaccion = 'ASIS_CPM_CONT') THEN

        BEGIN

            IF (v_parametros.tipo_interfaz = 'ComponsacionSol') THEN
                select fp.id_funcionario
                into v_id_funcionario
                from segu.vusuario usu
                         inner join orga.vfuncionario_persona fp on fp.id_persona = usu.id_persona
                         inner join asis.tpermiso p on p.id_funcionario = fp.id_funcionario
                where usu.id_usuario = p_id_usuario;

                select count(p.id_permiso)
                into v_count
                from asis.tpermiso p
                where p.id_usuario_reg = p_id_usuario;

                v_filtro = '';

                IF (p_administrador != 1) THEN
                    IF (v_id_funcionario is null and v_count = 0) THEN
                        v_filtro = '( cpm.id_usuario_reg = ' || p_id_usuario || ') and ';
                    ELSE
                        IF (v_id_funcionario is null) THEN
                            v_filtro = '( cpm.id_usuario_reg = ' || p_id_usuario || ') and ';
                        ELSE
                            v_filtro = '(cpm.id_funcionario = ' || v_id_funcionario || ' or cpm.id_usuario_reg = ' ||
                                       p_id_usuario || ') and ';
                        END IF;
                    END IF;
                END IF;

            END IF;

            IF (v_parametros.tipo_interfaz = 'ComponsacionVoBo') THEN
                v_filtro = '';
                IF (p_administrador != 1) THEN
                    select f.id_funcionario
                    into v_id_funcionario
                    from segu.vusuario u
                             inner join orga.vfuncionario_persona f on f.id_persona = u.id_persona
                    where u.id_usuario = p_id_usuario;

                    IF (v_id_funcionario is not null) THEN
                        v_filtro = 'cpm.id_responsable =  ' || v_id_funcionario || ' and ';
                    END IF;
                END IF;
            END IF;

            IF (v_parametros.tipo_interfaz = 'CompensacionRrhh') THEN
                v_filtro = '';
            END IF;

            --Sentencia de la consulta de conteo de registros
            v_consulta := 'SELECT COUNT(id_compensacion)
                           FROM asis.tcompensacion cpm
                                     JOIN segu.tusuario usu1 ON usu1.id_usuario = cpm.id_usuario_reg
                                     JOIN orga.vfuncionario_cargo f on f.id_funcionario = cpm.id_funcionario
                                     JOIN orga.vfuncionario r on r.id_funcionario = cpm.id_responsable
                                     JOIN orga.tuo ger ON ger.id_uo = orga.f_get_uo_gerencia(f.id_uo, NULL::integer, NULL::date)
                                     LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = cpm.id_usuario_mod
                            WHERE  f.fecha_asignacion <=  now()::date and
                          (f.fecha_finalizacion is null or f.fecha_finalizacion >= now()::date) AND  ' || v_filtro;

            --Definicion de la respuesta
            v_consulta := v_consulta || v_parametros.filtro;

            --Devuelve la respuesta
            RETURN v_consulta;

        END;

    ELSE

        RAISE EXCEPTION 'Transaccion inexistente';

    END IF;

EXCEPTION

    WHEN OTHERS THEN
        v_resp = '';
        v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', SQLERRM);
        v_resp = pxp.f_agrega_clave(v_resp, 'codigo_error', SQLSTATE);
        v_resp = pxp.f_agrega_clave(v_resp, 'procedimientos', v_nombre_funcion);
        RAISE EXCEPTION '%',v_resp;
END;
$body$
    LANGUAGE 'plpgsql'
    VOLATILE
    CALLED ON NULL INPUT
    SECURITY INVOKER
    PARALLEL UNSAFE
    COST 100;

ALTER FUNCTION asis.ft_compensacion_sel (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
    OWNER TO postgres;