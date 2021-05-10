create function asis.ft_baja_medica_sel(p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying) returns character varying
    language plpgsql
as
$$
/**************************************************************************
 SISTEMA:        Sistema de Asistencia
 FUNCION:         asis.ft_baja_medica_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.tbaja_medica'
 AUTOR:          (admin.miguel)
 FECHA:            05-02-2021 14:41:38
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE                FECHA                AUTOR                DESCRIPCION
 #0                05-02-2021 14:41:38    admin.miguel             Creacion
 #
 ***************************************************************************/

DECLARE

v_consulta            VARCHAR;
    v_parametros          RECORD;
    v_nombre_funcion      TEXT;
    v_resp                VARCHAR;
    v_filtro		      varchar;

BEGIN

    v_nombre_funcion = 'asis.ft_baja_medica_sel';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
     #TRANSACCION:  'ASIS_BMA_SEL'
     #DESCRIPCION:    Consulta de datos
     #AUTOR:        admin.miguel
     #FECHA:        05-02-2021 14:41:38
    ***********************************/

    IF (p_transaccion='ASIS_BMA_SEL') THEN

BEGIN
            --Sentencia de la consulta
            v_consulta:='SELECT
                        bma.id_baja_medica,
                        bma.estado_reg,
                        bma.id_funcionario,
                        bma.id_tipo_bm,
                        bma.fecha_inicio,
                        bma.fecha_fin,
                        bma.dias_efectivo,
                        bma.id_proceso_wf,
                        bma.id_estado_wf,
                        bma.estado,
                        bma.nro_tramite,
                        bma.documento,
                        bma.id_usuario_reg,
                        bma.fecha_reg,
                        bma.id_usuario_ai,
                        bma.usuario_ai,
                        bma.id_usuario_mod,
                        bma.fecha_mod,
                        usu1.cuenta as usr_reg,
                        usu2.cuenta as usr_mod,
                        tp.nombre as desc_nombre,
                        fu.desc_funcionario2 as desc_funcionario,
                        fu.codigo, bma.observaciones
                        FROM asis.tbaja_medica bma
                        JOIN segu.tusuario usu1 ON usu1.id_usuario = bma.id_usuario_reg
                        JOIN asis.ttipo_bm tp on tp.id_tipo_bm = bma.id_tipo_bm
                        JOIN orga.vfuncionario fu on fu.id_funcionario = bma.id_funcionario
                        LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = bma.id_usuario_mod
                        WHERE  ';

            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;
            v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ' ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;

            --Devuelve la respuesta
RETURN v_consulta;

END;

    /*********************************
     #TRANSACCION:  'ASIS_BMA_CONT'
     #DESCRIPCION:    Conteo de registros
     #AUTOR:        admin.miguel
     #FECHA:        05-02-2021 14:41:38
    ***********************************/

    ELSIF (p_transaccion='ASIS_BMA_CONT') THEN

BEGIN
            --Sentencia de la consulta de conteo de registros
            v_filtro = '';


            v_consulta:='SELECT COUNT(id_baja_medica)
                          	FROM asis.tbaja_medica bma
                        	JOIN segu.tusuario usu1 ON usu1.id_usuario = bma.id_usuario_reg
                        	JOIN asis.ttipo_bm tp on tp.id_tipo_bm = bma.id_tipo_bm
                        	JOIN orga.vfuncionario fu on fu.id_funcionario = bma.id_funcionario
                        	LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = bma.id_usuario_mod
                         	WHERE ';

            --Definicion de la respuesta
            v_consulta:=v_consulta||v_parametros.filtro;

            --Devuelve la respuesta
RETURN v_consulta;

END;
    /*********************************
     #TRANSACCION:  'ASIS_BMA_REPO'
     #DESCRIPCION:    Reporte por fechas baja medicas
     #AUTOR:        MMV
     #FECHA:        22-02-2021 14:41:38
    ***********************************/

    ELSIF (p_transaccion='ASIS_BMA_REPO') THEN

BEGIN
            --Sentencia de la consulta de conteo de registros
            v_consulta:='select    fu.id_funcionario,
                                   initcap(fu.desc_funcionario2) as nombre,
                                   fu.departamento as centro,
                                   fu.gerencia as gerencia,
                                   to_char(ba.fecha_inicio,''DD/MM/YYYY'') as fecha_inicio,
                                   to_char(ba.fecha_fin,''DD/MM/YYYY'') as fecha_fin,
                                   ba.dias_efectivo,
                                   tb.nombre as tipo_baja,
                                   ba.observaciones
                            from (
                            select distinct on (uofun.id_funcionario) uofun.id_funcionario,
                                    fun.desc_funcionario2,
                                    ger.codigo as gerencia,
                                    dep.codigo as departamento
                                    -- dep.nombre_unidad as departamento
                              from orga.tuo_funcionario uofun
                              inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
                              inner join orga.ttipo_contrato tc on car.id_tipo_contrato = tc.id_tipo_contrato
                              inner join orga.vfuncionario fun on fun.id_funcionario = uofun.id_funcionario
                              inner join orga.tuo ger ON ger.id_uo = orga.f_get_uo_gerencia(uofun.id_uo, NULL::integer, NULL::date)
                              inner join orga.tuo dep ON dep.id_uo = orga.f_get_uo_departamento(uofun.id_uo, NULL::integer, NULL::date)
                              where tc.codigo in (''PLA'',''EVE'') and UOFUN.tipo = ''oficial'' and
                              uofun.fecha_asignacion <= '''||v_parametros.fecha_fin||'''::date and
                              (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >= '''||v_parametros.fecha_inicio||'''::date)
                              order by uofun.id_funcionario, uofun.fecha_asignacion desc) fu
                            inner join asis.tbaja_medica ba on ba.id_funcionario = fu.id_funcionario
                            inner join asis.ttipo_bm tb on tb.id_tipo_bm = ba.id_tipo_bm
                            where ba.fecha_inicio <= '''||v_parametros.fecha_fin||'''::date and ba.fecha_fin >= '''||v_parametros.fecha_inicio||'''::date
                                    and ba.estado = '''||v_parametros.estado||'''
                            order by gerencia, centro, nombre';
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
$$;
