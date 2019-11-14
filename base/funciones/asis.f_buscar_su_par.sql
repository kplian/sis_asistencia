CREATE OR REPLACE FUNCTION asis.f_buscar_su_par (
  p_id_funcionario integer,
  p_id_periodo integer,
  p_dia integer,
  p_hora time,
  p_id_rango integer
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
   v_resultado 							boolean;
   v_marcaciones						record;
   v_registro							record;
   v_jornada							time;

BEGIN

  	v_nombre_funcion = 'asis.f_buscar_su_par';
	v_resultado = false;

    select  bio.id,
            bio.id_rango_horario,
            bio.acceso,
            bio.fecha
            into
            v_marcaciones
    from asis.ttransacc_zkb_etl bio
    where bio.id_funcionario = p_id_funcionario
    and EXTRACT(MONTH FROM bio.fecha::date)::integer = p_id_periodo
    and to_char(bio.fecha,'DD')::integer = p_dia
    and bio.hora = p_hora
     and bio.reader_name not in  ('10.231.14.120-1-Entrada',
                                                              '10.231.14.120-2-Salida',
                                                              '10.231.14.170-1-Entrada',
                                                              '10.231.14.170-2-Entrada',
                                                              '10.231.14.170-3-Entrada',
                                                              '10.231.14.170-4-Entrada',
                                                              '10.231.14.171-1-Entrada',
                                                              '10.231.14.171-2-Entrada',
                                                              '10.231.14.171-3-Entrada',
                                                              '10.231.14.171-4-Entrada',
                                                              '10.231.14.171-4-Salida',
                                                              '10.231.14.172-1-Entrada',
                                                              '10.231.14.172-2-Entrada',
                                                              '10.231.14.172-3-Entrada',
                                                              '10.231.14.172-4-Entrada',
                                                              '10.231.14.173-1-Entrada',
                                                              '10.231.14.173-2-Entrada',
                                                              '10.231.14.173-3-Entrada',
                                                              '10.231.14.173-4-Entrada',
                                                              'PB_COT_INBIO460-1-Entrada',
                                                              'PB_COT_INBIO460-2-Entrada',
                                                              'PB_COT_INBIO460-3-Entrada',
                                                              'PB_COT_INBIO460-3-Salida',
                                                              'PB_COT_INBIO460-4-Entrada',
                                                              'PB_COT_INBIO460-4-Salida',
                                                              'P1_ACC1_INBIO460-1-Entrada',
                                                              'P1_ACC1_INBIO460-2-Entrada',
                                                              'P1_ACC1_INBIO460-3-Entrada',
                                                              'P1_ACC1_INBIO460-3-Salida',
                                                              'P1_ACC1_INBIO460-4-Entrada',
                                                              'P1_ACC2_INBIO260-1-Entrada',
                                                              'P2_ACC1_INBIO260-1-Entrada',
                                                              'P2_ACC1_INBIO260-2-Entrada',
                                                              'P2_ACC2_INBIO260-1-Entrada',
                                                              'PB_ACC1_INBIO260-1-Entrada',
                                                              'PB_ACC1_INBIO260-2-Entrada',
                                                              'PB_ACC2_INBIO460-1-Entrada',
                                                              'PB_ACC2_INBIO460-2-Entrada',
                                                              'PB_ACC2_INBIO460-3-Entrada',
                                                              'PB_ACC2_INBIO460-3-Salida',
                                                              'PB_ACC3_INBIO460-1-Entrada',
                                                              'PB_ACC3_INBIO460-2-Entrada',
                                                              'PB_ACC3_INBIO460-2-Salida',
                                                              'PB_ACC3_INBIO460-3-Entrada',
                                                              'PB_ACC3_INBIO460-4-Entrada',
                                                              'PB_ACC3_INBIO460-4-Salida');

    update asis.ttransacc_zkb_etl set
    rango = 'si'
    where id = v_marcaciones.id;

	---le falta su Entrada
	if v_marcaciones.acceso = 'Salida' then

    select asis.f_id_transacion_bio ( min(etl.hora)::time,
     						          p_id_periodo,
                                      p_id_funcionario,
                                      to_char(etl.fecha::date,'DD')::integer,
                                      'no'
                                      ) as id,
                                      to_char(etl.fecha, 'DD'::text)::integer as dia,
                                      min(etl.hora) as hora,
                                      etl.fecha,
                                      etl.reader_name,
             						  etl.verify_mode_name,
                                      etl.acceso as evento
                                      into
                                      v_registro
                                      from asis.ttransacc_zkb_etl etl
                                      where etl.acceso in ('Entrada','otro')
                                      and etl.id_funcionario = p_id_funcionario
                                      and EXTRACT(MONTH FROM etl.fecha::date)::integer = p_id_periodo
       								  and (etl.rango = 'no' or etl.rango is null)
                                      and to_char(etl.fecha, 'DD'::text)::integer = p_dia
                                       and etl.reader_name not in  ('10.231.14.120-1-Entrada',
                                                              '10.231.14.120-2-Salida',
                                                              '10.231.14.170-1-Entrada',
                                                              '10.231.14.170-2-Entrada',
                                                              '10.231.14.170-3-Entrada',
                                                              '10.231.14.170-4-Entrada',
                                                              '10.231.14.171-1-Entrada',
                                                              '10.231.14.171-2-Entrada',
                                                              '10.231.14.171-3-Entrada',
                                                              '10.231.14.171-4-Entrada',
                                                              '10.231.14.171-4-Salida',
                                                              '10.231.14.172-1-Entrada',
                                                              '10.231.14.172-2-Entrada',
                                                              '10.231.14.172-3-Entrada',
                                                              '10.231.14.172-4-Entrada',
                                                              '10.231.14.173-1-Entrada',
                                                              '10.231.14.173-2-Entrada',
                                                              '10.231.14.173-3-Entrada',
                                                              '10.231.14.173-4-Entrada',
                                                              'PB_COT_INBIO460-1-Entrada',
                                                              'PB_COT_INBIO460-2-Entrada',
                                                              'PB_COT_INBIO460-3-Entrada',
                                                              'PB_COT_INBIO460-3-Salida',
                                                              'PB_COT_INBIO460-4-Entrada',
                                                              'PB_COT_INBIO460-4-Salida',
                                                              'P1_ACC1_INBIO460-1-Entrada',
                                                              'P1_ACC1_INBIO460-2-Entrada',
                                                              'P1_ACC1_INBIO460-3-Entrada',
                                                              'P1_ACC1_INBIO460-3-Salida',
                                                              'P1_ACC1_INBIO460-4-Entrada',
                                                              'P1_ACC2_INBIO260-1-Entrada',
                                                              'P2_ACC1_INBIO260-1-Entrada',
                                                              'P2_ACC1_INBIO260-2-Entrada',
                                                              'P2_ACC2_INBIO260-1-Entrada',
                                                              'PB_ACC1_INBIO260-1-Entrada',
                                                              'PB_ACC1_INBIO260-2-Entrada',
                                                              'PB_ACC2_INBIO460-1-Entrada',
                                                              'PB_ACC2_INBIO460-2-Entrada',
                                                              'PB_ACC2_INBIO460-3-Entrada',
                                                              'PB_ACC2_INBIO460-3-Salida',
                                                              'PB_ACC3_INBIO460-1-Entrada',
                                                              'PB_ACC3_INBIO460-2-Entrada',
                                                              'PB_ACC3_INBIO460-2-Salida',
                                                              'PB_ACC3_INBIO460-3-Entrada',
                                                              'PB_ACC3_INBIO460-4-Entrada',
                                                              'PB_ACC3_INBIO460-4-Salida')
                                      group by etl.fecha, etl.fecha,
                                                          etl.reader_name,
                                                          etl.verify_mode_name,
                                                          etl.acceso
                                      order by dia;

        update asis.ttransacc_zkb_etl set
        rango = 'si'
        where id = v_registro.id;

         INSERT INTO  asis.tpares
                              (
                                id_usuario_reg,
                                id_usuario_mod,
                                fecha_reg,
                                fecha_mod,
                                estado_reg,
                                fecha_marcado,
                                hora_ini,
                                hora_fin,
                                lector,
                                acceso,
                                id_transaccion_ini,
                                id_transaccion_fin,
                                id_funcionario,
                                id_permiso,
                                id_vacacion,
                                id_viatico,
                                id_pares_entrada,
                                id_periodo,
                                rango,
                                impar,
                                verificacion
                              )
                              VALUES (
                                1,
                                null,
                                now(),
                                null,
                                'activo',
                                v_registro.fecha,
                                case
                                 when v_registro.evento = 'Entrada' then
                                      v_registro.hora
                                 else
                                      null
                                 end,
                                case
                                 when v_registro.evento = 'Salida' then
                                      v_registro.hora
                                 else
                                      null
                                 end,
                                v_registro.reader_name,
                                v_registro.evento,
                                  case
                                 when v_registro.evento = 'Entrada' then
                                      v_registro.id
                                 else
                                      null
                                 end,
                                case
                                 when v_registro.evento = 'Salida' then
                                      v_registro.id
                                 else
                                      null
                                 end,
                                p_id_funcionario,
                                null,
                              	null,
                                null,
                                null, --?id_pares_entrada,
                                p_id_periodo,
                                'si',
                                'no',
                                v_registro.verify_mode_name
                              );
        v_resultado = true;
    end if;

    ---le falta su Salida
	if v_marcaciones.acceso = 'Entrada' then
    select asis.f_id_transacion_bio ( max(etl.hora)::time,
     						          p_id_periodo,
                                      p_id_funcionario,
                                      to_char(etl.fecha::date,'DD')::integer,
                                      'no'
                                      ) as id,
                                      to_char(etl.fecha, 'DD'::text)::integer as dia,
                                      max(etl.hora) as hora,
                                      etl.fecha,
                                      etl.reader_name,
             						  etl.verify_mode_name,
                                      etl.acceso as evento
                                      into
                                      v_registro
                                      from asis.ttransacc_zkb_etl etl
                                      where etl.acceso in ('Salida','otro')
                                      and etl.id_funcionario = p_id_funcionario
                                      and EXTRACT(MONTH FROM etl.fecha::date)::integer = p_id_periodo
       								  and (etl.rango = 'no' or etl.rango is null)
                                      and to_char(etl.fecha, 'DD'::text)::integer = p_dia
                                       and etl.reader_name not in  ('10.231.14.120-1-Entrada',
                                                              '10.231.14.120-2-Salida',
                                                              '10.231.14.170-1-Entrada',
                                                              '10.231.14.170-2-Entrada',
                                                              '10.231.14.170-3-Entrada',
                                                              '10.231.14.170-4-Entrada',
                                                              '10.231.14.171-1-Entrada',
                                                              '10.231.14.171-2-Entrada',
                                                              '10.231.14.171-3-Entrada',
                                                              '10.231.14.171-4-Entrada',
                                                              '10.231.14.171-4-Salida',
                                                              '10.231.14.172-1-Entrada',
                                                              '10.231.14.172-2-Entrada',
                                                              '10.231.14.172-3-Entrada',
                                                              '10.231.14.172-4-Entrada',
                                                              '10.231.14.173-1-Entrada',
                                                              '10.231.14.173-2-Entrada',
                                                              '10.231.14.173-3-Entrada',
                                                              '10.231.14.173-4-Entrada',
                                                              'PB_COT_INBIO460-1-Entrada',
                                                              'PB_COT_INBIO460-2-Entrada',
                                                              'PB_COT_INBIO460-3-Entrada',
                                                              'PB_COT_INBIO460-3-Salida',
                                                              'PB_COT_INBIO460-4-Entrada',
                                                              'PB_COT_INBIO460-4-Salida',
                                                              'P1_ACC1_INBIO460-1-Entrada',
                                                              'P1_ACC1_INBIO460-2-Entrada',
                                                              'P1_ACC1_INBIO460-3-Entrada',
                                                              'P1_ACC1_INBIO460-3-Salida',
                                                              'P1_ACC1_INBIO460-4-Entrada',
                                                              'P1_ACC2_INBIO260-1-Entrada',
                                                              'P2_ACC1_INBIO260-1-Entrada',
                                                              'P2_ACC1_INBIO260-2-Entrada',
                                                              'P2_ACC2_INBIO260-1-Entrada',
                                                              'PB_ACC1_INBIO260-1-Entrada',
                                                              'PB_ACC1_INBIO260-2-Entrada',
                                                              'PB_ACC2_INBIO460-1-Entrada',
                                                              'PB_ACC2_INBIO460-2-Entrada',
                                                              'PB_ACC2_INBIO460-3-Entrada',
                                                              'PB_ACC2_INBIO460-3-Salida',
                                                              'PB_ACC3_INBIO460-1-Entrada',
                                                              'PB_ACC3_INBIO460-2-Entrada',
                                                              'PB_ACC3_INBIO460-2-Salida',
                                                              'PB_ACC3_INBIO460-3-Entrada',
                                                              'PB_ACC3_INBIO460-4-Entrada',
                                                              'PB_ACC3_INBIO460-4-Salida')
                                      group by  etl.fecha , etl.fecha,
                                                            etl.reader_name,
                                                            etl.verify_mode_name,
                                                            etl.acceso
                                      order by dia;

        update asis.ttransacc_zkb_etl set
        rango = 'si'
        where id = v_registro.id;


        INSERT INTO  asis.tpares
                              (
                                id_usuario_reg,
                                id_usuario_mod,
                                fecha_reg,
                                fecha_mod,
                                estado_reg,
                                fecha_marcado,
                                hora_ini,
                                hora_fin,
                                lector,
                                acceso,
                                id_transaccion_ini,
                                id_transaccion_fin,
                                id_funcionario,
                                id_permiso,
                                id_vacacion,
                                id_viatico,
                                id_pares_entrada,
                                id_periodo,
                                rango,
                                impar,
                                verificacion
                              )
                              VALUES (
                                1,
                                null,
                                now(),
                                null,
                                'activo',
                                v_registro.fecha,
                                case
                                 when v_registro.evento = 'Entrada' then
                                      v_registro.hora
                                 else
                                      null
                                 end,
                                case
                                 when v_registro.evento = 'Salida' then
                                      v_registro.hora
                                 else
                                      null
                                 end,
                                v_registro.reader_name,
                                v_registro.evento,
                                  case
                                 when v_registro.evento = 'Entrada' then
                                      v_registro.id
                                 else
                                      null
                                 end,
                                case
                                 when v_registro.evento = 'Salida' then
                                      v_registro.id
                                 else
                                      null
                                 end,
                                p_id_funcionario,
                                null,
                              	null,
                                null,
                                null, --?id_pares_entrada,
                                p_id_periodo,
                                'si',
                                'no',
                                v_registro.verify_mode_name
                              );

        v_resultado = true;

    end if;


    RETURN v_resultado;
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

ALTER FUNCTION asis.f_buscar_su_par (p_id_funcionario integer, p_id_periodo integer, p_dia integer, p_hora time, p_id_rango integer)
  OWNER TO dbaamamani;