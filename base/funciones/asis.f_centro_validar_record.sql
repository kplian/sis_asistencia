CREATE OR REPLACE FUNCTION asis.f_centro_validar_record (
  p_centro_costo varchar,
  p_id_gestion integer,
  p_id_id_mes_trabajo integer,
  p_id_periodo integer
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:    Sistema de Asistencia
 FUNCION:     asis.f_centro_validar
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.f_centro_validar'
 AUTOR:      MMV Kplian
 FECHA:          31-01-2019 16:36:51
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE        FECHA        AUTOR        DESCRIPCION
  #7    ETR    24/0/2019   MMV          Correccion nombre
  #10   ETR	  16/07/2019   MMV			Validar Centtro de costo por autorizaciones

 ***************************************************************************/
DECLARE
   v_resp                            varchar;
   v_nombre_funcion                  text;
   v_id_centro_costo             	 integer;
   v_mensaje             			 varchar;
   v_estado                			 varchar;
   v_operativo              		 integer;
   v_autorizacion					 varchar; --#10


BEGIN
    v_nombre_funcion = 'asis.f_centro_validar_record';
    v_mensaje = '';
    v_autorizacion = '';
     v_id_centro_costo = asis.f_centro_validar(p_centro_costo,p_id_gestion);

    if v_id_centro_costo is null then
      v_mensaje = ' no existe';
      return v_mensaje;
    end if;

   if v_id_centro_costo is not null then
   		v_autorizacion = asis.f_validar_centro_costo(p_id_id_mes_trabajo,p_id_periodo,v_id_centro_costo); 	--#10


        if v_autorizacion <> '' then
       		 v_autorizacion = v_autorizacion;
        end if;

     	 select pr.estado into v_estado
             from pre.tpresupuesto pr
             where pr.id_centro_costo = v_id_centro_costo;

             if (v_estado is null or v_estado <> 'aprobado')then
                 v_mensaje = ' no tiene presupuesto asignado';
             end if;

          select cs.id_centro_costo into v_operativo
                from param.vcentro_costo cs
                where  cs.id_centro_costo = v_id_centro_costo and cs.operativo = 'si';

               if v_operativo is null then
                   v_mensaje = v_mensaje ||', no esta operativo';
                else
                  v_mensaje = v_mensaje;
                end if;
                if v_autorizacion = ''then
                	return v_mensaje;
                else
                	return v_mensaje ||' '|| v_autorizacion;  --#10;
                end if;

   end if;
  return  v_mensaje;
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
STABLE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;