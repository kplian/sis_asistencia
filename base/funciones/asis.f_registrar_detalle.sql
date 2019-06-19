CREATE OR REPLACE FUNCTION asis.f_registrar_detalle (
  p_id_mes_trabajo integer,
  p_mes_trabajo_json json,
  p_id_usuario integer
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
 #5	ERT			19/06/2019 				 MMV			Insertar HT

 ***************************************************************************/
DECLARE
    v_resp                  varchar;
    v_nombre_funcion        text;
    v_json					record;
    v_mes_trabajo			varchar;
	v_dia					integer;
    v_id_centro_costo		integer;
    v_total_normal			numeric;
    v_total_extra			numeric;
    v_total_nocturna		numeric;
    v_centro_costo			varchar;
    v_tipo					varchar[];
    v_ingreso_ma			varchar;
    v_salidad_ma			varchar;
    v_ingreso_ta			varchar;
    v_salidad_ta			varchar;
    v_ingreso_no			varchar;
    v_salidad_no			varchar;
    v_justificacion			varchar;
    v_extras_autorizadas	numeric;
    v_codigo				varchar;--5
    v_orden					varchar;--5
    v_pep					varchar;--5
    v_id_gestion			integer;
    v_mensaje 				varchar;
    v_insertar				boolean;
    v_count					integer;
    v_error					text;
BEGIN
  v_tipo[1] = 'HRN';
  v_tipo[2] = 'LPV';
  v_tipo[3] = 'LPC';
  v_tipo[4] = 'FER';
  v_tipo[5] = 'CDV';
  v_tipo[6] = 'LMP';
  v_mensaje = '';
  v_centro_costo = '';
  v_id_centro_costo	= null;
  ---obtener la gesrion
  select me.id_gestion into v_id_gestion
  from asis.tmes_trabajo me
  where me.id_mes_trabajo = p_id_mes_trabajo;


    ---Valida si existe registro se vuelve a insertar
      if exists( select 1
                  from asis.tmes_trabajo_det md
                  where md.id_mes_trabajo = p_id_mes_trabajo)then

                  delete from asis.tmes_trabajo_det m
                  where m.id_mes_trabajo = p_id_mes_trabajo;
      end if;

  for v_json in (select json_array_elements(p_mes_trabajo_json))loop
      v_mes_trabajo = v_json.json_array_elements::json;
      v_dia = v_mes_trabajo::JSON->>'dia';
      v_total_normal = v_mes_trabajo::JSON->>'total_normal';
      v_total_extra = v_mes_trabajo::JSON->>'total_extra';
      v_total_nocturna = v_mes_trabajo::JSON->>'total_nocturna';
      v_extras_autorizadas  = v_mes_trabajo::JSON->>'extras_autorizadas';
      v_codigo = v_mes_trabajo::JSON->>'codigo';
      v_orden	= v_mes_trabajo::JSON->>'orden';
      v_pep = v_mes_trabajo::JSON->>'pep';
      v_ingreso_ma = v_mes_trabajo::JSON->>'ingreso_manana';
      v_salidad_ma = v_mes_trabajo::JSON->>'salida_manana';
      v_ingreso_ta = v_mes_trabajo::JSON->>'ingreso_tarde';
      v_salidad_ta = v_mes_trabajo::JSON->>'salida_tarde';
      v_ingreso_no = v_mes_trabajo::JSON->>'ingreso_noche';
      v_salidad_no = v_mes_trabajo::JSON->>'salida_noche';
      v_justificacion = v_mes_trabajo::JSON->>'justificacion_extra';

        if v_codigo != '' then
          v_centro_costo = v_codigo;
        end if;

        if v_orden != '' then
          v_centro_costo = v_orden;
        end if;

        if v_pep != '' then
          v_centro_costo = v_pep;
        end if;

      if(v_ingreso_ma <> '' or v_salidad_ma <> '')then
        if(v_centro_costo != '')then
            v_id_centro_costo = asis.f_centro_validar(v_centro_costo,v_id_gestion);
                insert into asis.tmes_trabajo_det(  id_mes_trabajo,
                                        id_centro_costo,
                                        ingreso_manana,
                                        salida_manana,
                                        ingreso_tarde,
                                        salida_tarde,
                                        ingreso_noche,
                                        salida_noche,
                                        total_normal,
                                        total_extra,
                                        total_nocturna,
                                        extra_autorizada,
                                        dia,
                                        justificacion_extra,
                                        tipo,
                                        tipo_dos,
                                        tipo_tres,
                                        usuario_ai,
                                        fecha_reg,
                                        id_usuario_reg,
                                        id_usuario_ai,
                                        fecha_mod,
                                        id_usuario_mod
    									) values(
                                        p_id_mes_trabajo,
                                        v_id_centro_costo,
                                        '08:30',
                                        '12:30',
                                        '14:30',
                                        '18:30',
                                        '0:00',
                                        '0:00',
                                        v_total_normal,
                                        v_total_extra,
                                        v_total_nocturna,
                                        v_extras_autorizadas,
                                        v_dia,
                                        v_justificacion,
                                        case
                                          when v_ingreso_ma = ANY (v_tipo) then
                                            v_ingreso_ma
                                          else
                                            v_tipo[1]
                                        end,
                                        case
                                          when v_ingreso_ta = ANY (v_tipo) then
                                            v_ingreso_ta
                                          else
                                            v_tipo[1]
                                        end,
                                        case
                                          when v_ingreso_no = ANY (v_tipo) then
                                            v_ingreso_no
                                          else
                                            v_tipo[1]
                                        end,
                                        null,
                                        now(),
                                        p_id_usuario,
                                        null,
                                        null,
                                        null);

        else
            raise exception 'Las columna no estan difinidas comuniquece con el admin.'; --#4
        end if;
      end if;

  end loop;




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