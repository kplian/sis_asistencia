CREATE OR REPLACE FUNCTION asis.f_pares (
  p_id_funcionario integer,
  p_id_periodo integer,
  p_dia integer,
  p_hora time
)
RETURNS boolean AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.f_centro_validar
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.f_centro_validar'
 AUTOR: 		 MMV Kplian
 FECHA:	        31-01-2019 16:36:51
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				31-01-2019 16:36:51								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.tmes_trabajo_det'

 ***************************************************************************/
DECLARE
   v_resp                      			varchar;
   v_nombre_funcion            			text;
   v_resultado							boolean;
   v_marcaciones						record;

BEGIN
  	v_nombre_funcion = 'asis.f_pares';

    v_resultado = false;
    select   bio.id_transaccion_bio,
             bio.id_rango_horario,
             bio.evento
             into
            v_marcaciones
    from asis.ttransaccion_bio bio
    where bio.id_funcionario = p_id_funcionario
    and bio.id_periodo = p_id_periodo
    and to_char(bio.fecha_marcado,'DD')::integer  = p_dia
    and bio.hora = p_hora;

            if (v_marcaciones.id_rango_horario is not null and v_marcaciones.evento = 'Entrada')
             or
                (v_marcaciones.id_rango_horario is not  null and v_marcaciones.evento = 'Salida') then

                  update asis.ttransaccion_bio set
                  rango = 'si'
                  where id_transaccion_bio = v_marcaciones.id_transaccion_bio;

                  v_resultado = true;
            end if;

        return v_resultado;
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

ALTER FUNCTION asis.f_pares (p_id_funcionario integer, p_id_periodo integer, p_dia integer, p_hora time)
  OWNER TO dbaamamani;