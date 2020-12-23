CREATE OR REPLACE FUNCTION asis.f_registrar_salida (
  p_id_transaccion_bio integer,
  p_dia integer,
  p_id_usuario integer,
  p_id_funcionario integer,
  p_id_periodo integer
)
RETURNS boolean AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.ft_mes_trabajo_det_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.tmes_trabajo_det'
 AUTOR: 		 (miguel.mamani)
 FECHA:	        31-01-2019 16:36:51
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
	ERT			23/08/2019 				 MMV			Corregir validación insertado comp

 ***************************************************************************/
DECLARE
    v_resp                  varchar;
    v_nombre_funcion        text;
    v_marcados				record;

BEGIN
	v_nombre_funcion = 'asis.f_registrar_salida';

	select  bio.id_transaccion_bio,
            to_char(bio.fecha_marcado,'DD'::text) as dia,
            max (to_char(bio.hora,'HH24:MI'::text)) as hora,
            bio.evento,
            ra.codigo

            from asis.ttransaccion_bio bio
            left join asis.trango_horario ra on ra.id_rango_horario = bio.id_rango_horario
            where bio.id_periodo = v_parametros.id_periodo and bio.id_funcionario = v_id_funcionario and  bio.evento = 'Salida'
            and bio.id_rango_horario is not null
            group by bio.fecha_marcado ,bio.evento,ra.codigo, bio.id_transaccion_bi;

RETURN TRUE;
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

ALTER FUNCTION asis.f_registrar_salida (p_id_transaccion_bio integer, p_dia integer, p_id_usuario integer, p_id_funcionario integer, p_id_periodo integer)
  OWNER TO dbaamamani;