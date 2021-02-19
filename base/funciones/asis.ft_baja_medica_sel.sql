create or replace function  asis.ft_baja_medica_sel(p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying) returns character varying
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

