CREATE OR REPLACE FUNCTION asis.f_centro_validar (
  p_centro_costo varchar,
  p_id_gestion integer
)
RETURNS integer AS
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
   v_id_centro_costo		   			integer;
   v_centro_costo			   			varchar;
   v_posision				   			integer;
   v_id_centro_costo_operativo		   	integer;
   v_estado_presupuesto					varchar;

BEGIN
  	v_nombre_funcion = 'asis.f_centro_validar';

    v_id_centro_costo = null;
    v_centro_costo = p_centro_costo;

    select position('0' in v_centro_costo) into v_posision;

    if (v_posision != 1) then

        select cc.id_centro_costo
        		into
                v_id_centro_costo
        from param.vcentro_costo cc
        where cc.id_gestion = p_id_gestion
        		and cc.codigo_tcc = v_centro_costo;

         if v_id_centro_costo is null then
   			raise exception 'No existe el centro de costo % contacte con finanzas',v_centro_costo;
         end if;

         if v_centro_costo is not null then

               select cs.id_centro_costo into v_id_centro_costo_operativo
               from param.vcentro_costo cs
               where  cs.id_centro_costo = v_id_centro_costo and cs.operativo = 'si';

		       if v_id_centro_costo_operativo is null then
                  raise exception 'El centro de costo  % no esta operativo contacte con finanzasa',v_centro_costo;
               end if;

         end if;


         select pr.estado into v_estado_presupuesto
         from pre.tpresupuesto pr
         where pr.id_centro_costo = v_id_centro_costo;

         	if v_estado_presupuesto != 'aprobado'then
            	raise exception 'El centro de costo % no tiene presupuesto asignado contacte con finanzasa',v_centro_costo;
            end if;

        return v_id_centro_costo;
    else
        return asis.f_centro_validar(substr(v_centro_costo,2),p_id_gestion);
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
STABLE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;