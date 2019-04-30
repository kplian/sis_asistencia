CREATE OR REPLACE FUNCTION asis.ft_mes_trabajo_det_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
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
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				31-01-2019 16:36:51								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.tmes_trabajo_det'
 #2				30/04/2019 				kplian MMV			Validaciones y reporte

 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_mes_trabajo_det	integer;
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
    v_codigo				varchar;--2
    v_orden					varchar;--2
    v_pep					varchar;--2


BEGIN

    v_nombre_funcion = 'asis.ft_mes_trabajo_det_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'ASIS_MTD_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		31-01-2019 16:36:51
	***********************************/

	if(p_transaccion='ASIS_MTD_INS')then

        begin
        	--Sentencia de la insercion
        	insert into asis.tmes_trabajo_det(
			ingreso_manana,
			id_mes_trabajo,
			id_centro_costo,
			ingreso_tarde,
			extra_autorizada,
			tipo,
			ingreso_noche,
			total_normal,
			estado_reg,
			total_extra,
			salida_manana,
			salida_tarde,
			justificacion_extra,
			salida_noche,
			dia,
			total_nocturna,
			usuario_ai,
			fecha_reg,
			id_usuario_reg,
			id_usuario_ai,
			fecha_mod,
			id_usuario_mod
          	) values(
			v_parametros.ingreso_manana,
			v_parametros.id_mes_trabajo,
			v_parametros.id_centro_costo,
			v_parametros.ingreso_tarde,
			v_parametros.extra_autorizada,
			v_parametros.tipo,
			v_parametros.ingreso_noche,
			v_parametros.total_normal,
			'activo',
			v_parametros.total_extra,
			v_parametros.salida_manana,
			v_parametros.salida_tarde,
			v_parametros.justificacion_extra,
			v_parametros.salida_noche,
			v_parametros.dia,
			v_parametros.total_nocturna,
			v_parametros._nombre_usuario_ai,
			now(),
			p_id_usuario,
			v_parametros._id_usuario_ai,
			null,
			null



			)RETURNING id_mes_trabajo_det into v_id_mes_trabajo_det;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Mes trabajo detalle almacenado(a) con exito (id_mes_trabajo_det'||v_id_mes_trabajo_det||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_mes_trabajo_det',v_id_mes_trabajo_det::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_MTD_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		31-01-2019 16:36:21
	***********************************/

	elsif(p_transaccion='ASIS_MTD_MOD')then

		begin
			--Sentencia de la modificacion
			update asis.tmes_trabajo_det set
			/*ingreso_manana = v_parametros.ingreso_manana,
			id_mes_trabajo = v_parametros.id_mes_trabajo,*/
			id_centro_costo = v_parametros.id_centro_costo,
			/*ingreso_tarde = v_parametros.ingreso_tarde,

			tipo = v_parametros.tipo,
			ingreso_noche = v_parametros.ingreso_noche,

			salida_manana = v_parametros.salida_manana,
			salida_tarde = v_parametros.salida_tarde,
			justificacion_extra = v_parametros.justificacion_extra,
			salida_noche = v_parametros.salida_noche,
			dia = v_parametros.dia,
			,*/
            --total_normal = v_parametros.total_normal,
			total_extra = v_parametros.total_extra,
            extra_autorizada = v_parametros.total_extra +  v_parametros.total_nocturna,
            total_nocturna = v_parametros.total_nocturna,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_mes_trabajo_det=v_parametros.id_mes_trabajo_det;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Mes trabajo detalle modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_mes_trabajo_det',v_parametros.id_mes_trabajo_det::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_MTD_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		31-01-2019 16:36:51
	***********************************/

	elsif(p_transaccion='ASIS_MTD_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from asis.tmes_trabajo_det
            where id_mes_trabajo_det=v_parametros.id_mes_trabajo_det;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Mes trabajo detalle eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_mes_trabajo_det',v_parametros.id_mes_trabajo_det::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

    /*********************************
 	#TRANSACCION:  'ASIS_MJS_INS'
 	#DESCRIPCION:	Inserat json
 	#AUTOR:		miguel.mamani
 	#FECHA:		31-01-2019 16:36:51
	***********************************/

	elsif(p_transaccion='ASIS_MJS_INS')then

		begin

        v_tipo[1] = 'HRN';
        v_tipo[2] = 'LPV';
        v_tipo[3] = 'LPC';
        v_tipo[4] = 'FER';
        v_tipo[5] = 'CDV';
        v_tipo[6] = 'LMP';
        v_centro_costo = '';

        if exists( select 1
        		   from asis.tmes_trabajo_det md
                   where md.id_mes_trabajo = v_parametros.id_mes_trabajo)then

                   delete from asis.tmes_trabajo_det m
                   where m.id_mes_trabajo = v_parametros.id_mes_trabajo;
        end if;

        for v_json in (select json_array_elements(v_parametros.mes_trabajo_json::json))loop
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

            --2
            if v_codigo != '' then
            	v_centro_costo = v_codigo;
            end if;

            if v_orden != '' then
            	v_centro_costo = v_orden;
            end if;

            if v_pep != '' then
            	v_centro_costo = v_pep;
            end if;

            if(v_centro_costo != '')then
                select cc.id_centro_costo into v_id_centro_costo
                from param.vcentro_costo  cc
                where cc.codigo_tcc = v_centro_costo and
                cc.id_gestion = v_parametros.id_gestion;
            end if;
            --2
           /* if v_id_centro_costo is null then
            	raise exception 'Error no se encuentra el centro de costo % ',v_centro_costo;
            end if;
            */
            if(v_ingreso_ma <> '' or v_salidad_ma <> '')then
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
                                                  v_parametros.id_mes_trabajo,
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
                                                  v_parametros._nombre_usuario_ai,
                                                  now(),
                                                  p_id_usuario,
                                                  v_parametros._id_usuario_ai,
                                                  null,
                                                  null);
              end if;
        end loop;



            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Mes trabajo detalle eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'v_id_mes_trabajo_det',v_id_mes_trabajo_det::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	else

    	raise exception 'Transaccion inexistente: %',p_transaccion;

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
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;