create or replace function asis.ft_baja_medica_ime(p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying) returns character varying
    language plpgsql
as
$$
/**************************************************************************
 SISTEMA:        Sistema de Asistencia
 FUNCION:         asis.ft_baja_medica_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.tbaja_medica'
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

v_nro_requerimiento        INTEGER;
    v_parametros               RECORD;
    v_id_requerimiento         INTEGER;
    v_resp                     VARCHAR;
    v_nombre_funcion           TEXT;
    v_mensaje_error            TEXT;
    v_id_baja_medica    	   INTEGER;

    v_id_gestion			   integer;
    v_codigo_proceso		   varchar;
    v_id_macro_proceso		   integer;

    v_nro_tramite			   varchar;
    v_id_proceso_wf			   integer;
    v_id_estado_wf			   integer;
    v_codigo_estado			   varchar;

    v_registro_estado		   record;
    v_recorrer				   record;

    va_id_tipo_estado 	  		integer [];
    va_codigo_estado 		  	varchar [];
    va_disparador 	      		varchar [];
    va_regla 				  	varchar [];
    va_prioridad 		      	integer [];

    v_acceso_directo 			varchar;
    v_clase 					varchar;
    v_parametros_ad 			varchar;
    v_tipo_noti 				varchar;
    v_titulo  					varchar;

    v_estado_maestro			varchar;
    v_id_estado_maestro 		integer;

    v_estado_record				record;
    v_id_estado_actual		    integer;

BEGIN

    v_nombre_funcion = 'asis.ft_baja_medica_ime';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
     #TRANSACCION:  'ASIS_BMA_INS'
     #DESCRIPCION:    Insercion de registros
     #AUTOR:        admin.miguel
     #FECHA:        05-02-2021 14:41:38
    ***********************************/

    IF (p_transaccion='ASIS_BMA_INS') THEN

BEGIN


select  g.id_gestion
into
    v_id_gestion
from param.tgestion g
where g.gestion = EXTRACT(YEAR FROM current_date);

--obtener el proceso
select   tp.codigo,
         pm.id_proceso_macro
into
    v_codigo_proceso,
    v_id_macro_proceso
from  wf.tproceso_macro pm
          inner join wf.ttipo_proceso tp on tp.id_proceso_macro = pm.id_proceso_macro
where pm.codigo = 'BMA' and tp.estado_reg = 'activo' and tp.inicio = 'si';



SELECT
    ps_num_tramite,
    ps_id_proceso_wf,
    ps_id_estado_wf,
    ps_codigo_estado
into
    v_nro_tramite,
    v_id_proceso_wf,
    v_id_estado_wf,
    v_codigo_estado
FROM wf.f_inicia_tramite(
        p_id_usuario,
        v_parametros._id_usuario_ai,
        v_parametros._nombre_usuario_ai,
        v_id_gestion,
        v_codigo_proceso,
        v_parametros.id_funcionario,
        NULL,
        'Baja Medica',
        v_codigo_proceso);

--Sentencia de la insercion
INSERT INTO asis.tbaja_medica(
    estado_reg,
    id_funcionario,
    id_tipo_bm,
    fecha_inicio,
    fecha_fin,
    dias_efectivo,
    id_proceso_wf,
    id_estado_wf,
    estado,
    nro_tramite,
    documento,
    id_usuario_reg,
    fecha_reg,
    id_usuario_ai,
    usuario_ai,
    id_usuario_mod,
    fecha_mod,
    observaciones
) VALUES (
             'activo',
             v_parametros.id_funcionario,
             v_parametros.id_tipo_bm,
             v_parametros.fecha_inicio,
             v_parametros.fecha_fin,
             v_parametros.dias_efectivo,
             v_id_proceso_wf,
             v_id_estado_wf,
             v_codigo_estado,
             v_nro_tramite,
             v_parametros.documento,
             p_id_usuario,
             now(),
             v_parametros._id_usuario_ai,
             v_parametros._nombre_usuario_ai,
             null,
             null,
             v_parametros.observaciones
         ) RETURNING id_baja_medica into v_id_baja_medica;

--Definicion de la respuesta
v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Baja medica almacenado(a) con exito (id_baja_medica'||v_id_baja_medica||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_baja_medica',v_id_baja_medica::varchar);

            --Devuelve la respuesta
RETURN v_resp;

END;

    /*********************************
     #TRANSACCION:  'ASIS_BMA_MOD'
     #DESCRIPCION:    Modificacion de registros
     #AUTOR:        admin.miguel
     #FECHA:        05-02-2021 14:41:38
    ***********************************/

    ELSIF (p_transaccion='ASIS_BMA_MOD') THEN

BEGIN
            --Sentencia de la modificacion
UPDATE asis.tbaja_medica SET
                             id_funcionario = v_parametros.id_funcionario,
                             id_tipo_bm = v_parametros.id_tipo_bm,
                             fecha_inicio = v_parametros.fecha_inicio,
                             fecha_fin = v_parametros.fecha_fin,
                             dias_efectivo = v_parametros.dias_efectivo,
                             id_proceso_wf = v_parametros.id_proceso_wf,
                             id_estado_wf = v_parametros.id_estado_wf,
                             estado = v_parametros.estado,
                             nro_tramite = v_parametros.nro_tramite,
                             documento = v_parametros.documento,
                             id_usuario_mod = p_id_usuario,
                             fecha_mod = now(),
                             id_usuario_ai = v_parametros._id_usuario_ai,
    usuario_ai = v_parametros._nombre_usuario_ai,
    observaciones = v_parametros.observaciones
WHERE id_baja_medica=v_parametros.id_baja_medica;

--Definicion de la respuesta
v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Baja medica modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_baja_medica',v_parametros.id_baja_medica::varchar);

            --Devuelve la respuesta
RETURN v_resp;

END;

    /*********************************
     #TRANSACCION:  'ASIS_BMA_ELI'
     #DESCRIPCION:    Eliminacion de registros
     #AUTOR:        admin.miguel
     #FECHA:        05-02-2021 14:41:38
    ***********************************/

    ELSIF (p_transaccion='ASIS_BMA_ELI') THEN

BEGIN
            --Sentencia de la eliminacion
DELETE FROM asis.tbaja_medica
WHERE id_baja_medica=v_parametros.id_baja_medica;

--Definicion de la respuesta
v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Baja medica eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_baja_medica',v_parametros.id_baja_medica::varchar);

            --Devuelve la respuesta
RETURN v_resp;

END;
    /*********************************
     #TRANSACCION:  'ASIS_BMA_SIG'
     #DESCRIPCION:    Cambiar de estado
     #AUTOR:        admin.miguel
     #FECHA:        01-02-2021 14:53:44
    ***********************************/
      ELSIF (p_transaccion='ASIS_BMA_SIG') THEN

BEGIN
           -- Validar estado
select  pw.id_proceso_wf,
        ew.id_estado_wf,
        te.codigo,
        pw.fecha_ini,
        te.id_tipo_estado,
        te.pedir_obs,
        pw.nro_tramite
into
    v_registro_estado
from wf.tproceso_wf pw
         inner join wf.testado_wf ew  on ew.id_proceso_wf = pw.id_proceso_wf and ew.estado_reg = 'activo'
         inner join wf.ttipo_estado te on ew.id_tipo_estado = te.id_tipo_estado
where pw.id_proceso_wf =  v_parametros.id_proceso_wf;


select  tt.id_baja_medica,
        tt.id_funcionario
into
    v_recorrer
from asis.tbaja_medica tt
where tt.id_proceso_wf = v_parametros.id_proceso_wf;



select  ps_id_tipo_estado,
        ps_codigo_estado,
        ps_disparador,
        ps_regla,
        ps_prioridad
into
    va_id_tipo_estado,
    va_codigo_estado,
    va_disparador,
    va_regla,
    va_prioridad
from wf.f_obtener_estado_wf( v_registro_estado.id_proceso_wf,
                             null,
                             v_registro_estado.id_tipo_estado,
                             'siguiente',
                             p_id_usuario);

v_acceso_directo = '';
                 v_clase = 'TeleTrabajoVoBo';
                 v_parametros_ad = '';
                 v_tipo_noti = '';
                 v_titulo  = '';



                  if( array_length(va_codigo_estado, 1) >= 2) then

select  tt.id_tipo_estado,
        tt.codigo
into
    v_estado_record
from wf.ttipo_estado tt
where tt.id_tipo_estado in (select unnest(ARRAY[va_id_tipo_estado]))
  and tt.codigo = v_parametros.evento;

v_id_estado_maestro = v_estado_record.id_tipo_estado;
                      v_estado_maestro = v_estado_record.codigo;

else

                      v_id_estado_maestro = va_id_tipo_estado[1]::integer;
                      v_estado_maestro = va_codigo_estado[1]::varchar;

end if ;

                v_id_estado_actual = wf.f_registra_estado_wf(   v_id_estado_maestro,
                                                                v_recorrer.id_funcionario,--v_parametros.id_funcionario_wf,
                                                                v_registro_estado.id_estado_wf,
                                                                v_registro_estado.id_proceso_wf,
                                                                p_id_usuario,
                                                                v_parametros._id_usuario_ai,
                                                                v_parametros._nombre_usuario_ai,
                                                                null,--v_id_depto,                       --depto del estado anterior
                                                                '', --obt
                                                                v_acceso_directo,
                                                                v_clase,
                                                                v_parametros_ad,
                                                                v_tipo_noti,
                                                                v_titulo);
update asis.tbaja_medica set
                             id_estado_wf =  v_id_estado_actual,
                             estado = v_estado_maestro,
                             id_usuario_mod = p_id_usuario,
                             id_usuario_ai = v_parametros._id_usuario_ai,
    usuario_ai = v_parametros._nombre_usuario_ai,
    fecha_mod = now()
where id_proceso_wf  = v_parametros.id_proceso_wf;

--Definicion de la respuesta
v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Tele Trabajo eliminado(a)');
          v_resp = pxp.f_agrega_clave(v_resp,'id_proceso_wf',v_parametros.id_proceso_wf::varchar);

          --Devuelve la respuesta
RETURN v_resp;

END;

ELSE

        RAISE EXCEPTION 'Transaccion inexistente: %',p_transaccion;

END IF;

EXCEPTION

    WHEN OTHERS THEN
        v_resp='';
        v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
        v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
        v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
        raise exception '%',v_resp;

END;
$$;