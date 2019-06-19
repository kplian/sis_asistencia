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
 #5				30/04/2019 				kplian MMV			Validaciones y reporte
 #4	ERT			17/06/2019 				 MMV			Validar columna de excel
 #5	ERT			19/06/2019 				 MMV			Validar centro de costo

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
    v_codigo				varchar;--5
    v_orden					varchar;--5
    v_pep					varchar;--5
    v_id_gestion			integer;
    v_mensaje				varchar;
    v_error					text;
    v_count					integer;
    v_cc_validar			boolean;
    v_id_mes_trabajo		integer;
    v_id_usuario			integer;
    v_json_p				json;
    v_insertar				boolean;
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
 	#FECHA:		31-01-2019 16:36:51
	***********************************/

	elsif(p_transaccion='ASIS_MTD_MOD')then

		begin
			--Sentencia de la modificacion
			update asis.tmes_trabajo_det set
			id_centro_costo = v_parametros.id_centro_costo,
            extra_autorizada = v_parametros.extra_autorizada,
            justificacion_extra = v_parametros.justificacion_extra,
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
 	#TRANSACCION:  'ASIS_MJS_INS' #5
 	#DESCRIPCION:	Inserat json
 	#AUTOR:		miguel.mamani
 	#FECHA:		31-01-2019 16:36:51
	***********************************/

	elsif(p_transaccion='ASIS_MJS_INS')then

		begin
        	CREATE TEMPORARY TABLE temp_error( id serial,
                                               dia varchar,
                                               cc varchar,
                                               error varchar) ON COMMIT DROP;

            v_id_mes_trabajo = v_parametros.id_mes_trabajo;
            v_json_p = v_parametros.mes_trabajo_json::json;
            v_id_usuario = p_id_usuario;

              v_mensaje = '';
              v_centro_costo = '';
              v_id_centro_costo	= null;
              v_insertar = false;

                ---obtener la gesrion
              select me.id_gestion into v_id_gestion
              from asis.tmes_trabajo me
              where me.id_mes_trabajo = v_id_mes_trabajo;

        for v_json in (select json_array_elements(v_json_p))loop
              v_mes_trabajo = v_json.json_array_elements::json;
              v_dia = v_mes_trabajo::JSON->>'dia';
              v_total_normal = v_mes_trabajo::JSON->>'total_normal';
              v_total_extra = v_mes_trabajo::JSON->>'total_extra';
              v_total_nocturna = v_mes_trabajo::JSON->>'total_nocturna';
              v_extras_autorizadas  = v_mes_trabajo::JSON->>'extras_autorizadas';
              v_codigo = v_mes_trabajo::JSON->>'codigo';
              v_orden = v_mes_trabajo::JSON->>'orden';
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
                  if not v_insertar then

                          v_mensaje = asis.f_centro_validar_record(v_centro_costo,v_id_gestion);
                        if v_mensaje != '' then
                           insert into temp_error (dia,
                                                   cc,
                                                   error)
                                                   values
                                                  (v_dia,
                                                   v_centro_costo,
                                                   v_mensaje
                                                  );
                           end if;
                           select count(id)into v_count
                           from temp_error;

                           if v_count = 0 then
                              v_insertar	= true;
                           end if;

                  end if;

              else
                  raise exception 'Las columna no estan difinidas comuniquece con el admin.'; --#4
              end if;
            end if;

  		end loop;

        if v_insertar then
        	PERFORM asis.f_registrar_detalle(v_id_mes_trabajo,
                                             v_json_p,
                                             v_id_usuario
                                             );
        else
        select pxp.list( 'Dia '||dia||' - '||error) as mensaje  into v_error from temp_error;
				raise exception 'Observaciónes %',v_error ;
        end if;



            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Mes trabajo registrado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'v_parametros.id_mes_trabajo',v_parametros.id_mes_trabajo::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;
    	/*********************************
        #TRANSACCION:  'ASIS_ELT_ELI'
        #DESCRIPCION:	Eliminar Todo los registros detalle #4
        #AUTOR:		miguel.mamani
        #FECHA:		31-01-2019 16:36:51
		***********************************/

	elsif(p_transaccion='ASIS_ELT_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from asis.tmes_trabajo_det de
            where de.id_mes_trabajo =v_parametros.id_mes_trabajo;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Mes trabajo detalle eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_mes_trabajo',v_parametros.id_mes_trabajo::varchar);

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