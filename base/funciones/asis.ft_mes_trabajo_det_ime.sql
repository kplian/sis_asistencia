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
 #10 ETR		16/07/2019				MMV				Validar Centtro de costo por autorizaciones
 #13	ERT			23/08/2019 				 MMV			Corregir validación insertado comp
  #18	ERT			26/09/2019 				 MMV			Modificar centros de costo


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
    v_id_periodo			integer;
    v_total_comp			numeric; -- #13
    v_count_det				integer;
    v_notificar				varchar;
    v_cc					varchar[];
    v_count_tmp				integer;
    v_record_tmp 			record;
	v_record_dm				record;

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

        --Creamos una table temporal para alamcenar los erros de los centros de costo
        create temporary table tmp_error( id serial, dia varchar, centro_costo varchar, mensaje varchar);
        --inicioamos la varible
        v_id_mes_trabajo = v_parametros.id_mes_trabajo;
        v_id_usuario = p_id_usuario;
        v_mensaje = '';
        v_centro_costo = '';
        v_id_centro_costo= null;
        v_insertar = false;
        ---json obtener los datos del excel
    	v_json_p = v_parametros.mes_trabajo_json::json;
        --obtenemos la gestion y perido
		select me.id_gestion, me.id_periodo into v_id_gestion,v_id_periodo
        from asis.tmes_trabajo me
        where me.id_mes_trabajo = v_id_mes_trabajo;
        --recorremos el json
        for v_json in (select json_array_elements(v_json_p))loop
			---asignamos valores alas varibles

        	v_mes_trabajo = v_json.json_array_elements::json;
            v_dia = v_mes_trabajo::JSON->>'dia';
            v_total_comp = v_mes_trabajo::JSON->>'comp';  -- #13
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

            ---Para en caso que no tenga ninguna hora  asignada
        	if((v_total_normal > 0) or --#10
               (v_extras_autorizadas > 0) or   --#10
               (v_total_nocturna > 0)or
               (v_total_comp > 0))then  --#10
               ---obtenemos el codigo del centro de contso segun columna
          			 if rtrim(v_codigo) != '' then
                        v_centro_costo = v_codigo;
                      end if;

                      if rtrim(v_orden) != '' then
                        v_centro_costo = v_orden;
                      end if;

                      if rtrim(v_pep) != '' then
                        v_centro_costo = v_pep;
                      end if;

                      if(v_centro_costo != '')then
                      	v_mensaje = asis.f_centro_validar_record(v_centro_costo,
                        										 v_id_gestion,
                                                                 v_id_mes_trabajo,
                                                                 v_id_periodo
                                                                 );
                          if v_mensaje != '' then
                             insert into tmp_error ( dia,
                                                     centro_costo,
                                                     mensaje)
                                                     values
                                                    (v_dia,
                                                     v_centro_costo,
                                                     v_mensaje
                                                    );
                           end if;
                      else
                     		raise exception 'Las columna no estan difinidas comuniquece con el admin.'; --#4
                      end if;

            end if;
  		end loop;
        --si el contador es mayor a 0 hay errores en los centos de costso
        select count(id)into v_count from tmp_error;

         if v_count = 0 then
            v_insertar = true;
         end if;

        if v_insertar then
        	PERFORM asis.f_registrar_detalle(v_id_mes_trabajo,
                                             v_json_p,
                                             v_id_usuario
                                             );
        else
        select pxp.list(DISTINCT centro_costo||' - '||mensaje) as mensaje  into v_error from tmp_error;
				raise exception 'Observaciónes % contactese con finanzas',v_error ;
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
     /*********************************
 	#TRANSACCION:  'ASIS_MCS_INS'
 	#DESCRIPCION:	modificar cento de costo
 	#AUTOR:		miguel.mamani
 	#FECHA:		31-01-2019 16:36:51
	***********************************/

	elsif(p_transaccion='ASIS_MCS_INS')then

		begin
        v_centro_costo = '';
        v_id_centro_costo= null;
        v_mensaje = '';
        v_notificar = '';

        create temporary table tmp_ht(  id SERIAL,
                                        id_centro_costo INTEGER NOT NULL,
                                        dia INTEGER NOT NULL,
                                        ingreso_manana TIME WITHOUT TIME ZONE,
                                        salida_manana TIME WITHOUT TIME ZONE,
                                        ingreso_tarde TIME WITHOUT TIME ZONE,
                                        salida_tarde TIME WITHOUT TIME ZONE,
                                        ingreso_noche TIME WITHOUT TIME ZONE,
                                        salida_noche TIME WITHOUT TIME ZONE,
                                        justificacion_extra VARCHAR,
                                        total_normal NUMERIC(100,2) DEFAULT 0,
                                        total_nocturna NUMERIC(100,2) DEFAULT 0,
                                        total_extra NUMERIC(100,2) DEFAULT 0,
                                        extra_autorizada NUMERIC(100,2) DEFAULT 0 ,
                                        tipo VARCHAR(6),
                                        tipo_dos VARCHAR(6),
                                        tipo_tres VARCHAR(6),
                                        total_comp NUMERIC DEFAULT 0);

         ---json obtener los datos del excel
    	v_json_p = v_parametros.mes_trabajo_json::json;


        --obtenemos la gestion y perido
		select  me.id_gestion,
        		me.id_periodo
                into
                v_id_gestion,
                v_id_periodo
        from asis.tmes_trabajo me
        where me.id_mes_trabajo = v_parametros.id_mes_trabajo;

        select count (me.id_mes_trabajo_det) into v_count_det
        from asis.tmes_trabajo_det me
        where me.id_mes_trabajo = v_parametros.id_mes_trabajo;

        --recorremos el json
        FOR v_json in (select json_array_elements(v_json_p))LOOP

                    ---asignamos valores alas varibles
                    v_mes_trabajo = v_json.json_array_elements::json;
                    v_dia = v_mes_trabajo::JSON->>'dia';
                    v_total_comp = v_mes_trabajo::JSON->>'comp';
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

        	IF 	  v_total_comp > 0 or
                  v_total_normal > 0 or
                  v_total_extra > 0 or
                  v_total_nocturna > 0 or
                  v_extras_autorizadas > 0 THEN

                  	  if rtrim(v_codigo) != '' then
                      	v_centro_costo = v_codigo;
                      end if;

                      if rtrim(v_orden) != '' then
                        v_centro_costo = v_orden;
                      end if;

                      if rtrim(v_pep) != '' then
                        v_centro_costo = v_pep;
                      end if;

                      if(v_centro_costo != '')then
                      	v_mensaje = asis.f_centro_validar_record(v_centro_costo,
                        										 v_id_gestion,
                                                                 v_id_mes_trabajo,
                                                                 v_id_periodo
                                                                 );
                        	 if v_mensaje != '' then
                             	--v_cc = 	array_append(v_cc, v_centro_costo);
                                v_notificar := v_notificar || ' dia: '||v_dia||' centro: '|| v_centro_costo ||' mensaje: '|| v_mensaje;
                             end if;

                      else
                     		raise exception 'Las columna no estan difinidas comuniquece con el admin.';
                      end if;
            END IF;

        END LOOP;

        IF v_notificar != ''THEN
        	raise exception 'Observaciones: %',v_notificar;
        END IF;

        v_tipo[1] = 'HRN';
        v_tipo[2] = 'LPV';
        v_tipo[3] = 'LPC';
        v_tipo[4] = 'FER';
        v_tipo[5] = 'CDV';
        v_tipo[6] = 'LMP';
        v_tipo[7] = 'LP';
        v_tipo[8] = 'LPE';

        FOR v_json in (select json_array_elements(v_json_p))LOOP
              v_mes_trabajo = v_json.json_array_elements::json;
              v_dia = v_mes_trabajo::JSON->>'dia';
              v_total_comp = v_mes_trabajo::JSON->>'comp';
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

              IF  v_total_comp > 0 or
                  v_total_normal > 0 or
                  v_total_extra > 0 or
                  v_total_nocturna > 0 or
                  v_extras_autorizadas > 0 THEN

                      if rtrim(v_codigo) != '' then
                        v_centro_costo = v_codigo;
                      end if;

                      if rtrim(v_orden) != '' then
                        v_centro_costo = v_orden;
                      end if;

                      if rtrim(v_pep) != '' then
                        v_centro_costo = v_pep;
                      end if;

                       if(v_centro_costo != '')then
            				v_id_centro_costo = asis.f_centro_validar(v_centro_costo,v_id_gestion);

                                     insert into tmp_ht(  id_centro_costo,
                                                          dia,
                                                          ingreso_manana,
                                                          salida_manana,
                                                          ingreso_tarde,
                                                          salida_tarde,
                                                          ingreso_noche,
                                                          salida_noche,
                                                          total_normal,
                                                          total_nocturna,
                                                          total_extra,
                                                          extra_autorizada,
                                                          total_comp,
                                                          justificacion_extra,
                                                          tipo,
                                                          tipo_dos,
                                                          tipo_tres
                                                          )values(
                                                          v_id_centro_costo,
                                                          v_dia,
                                                          (case
                                                            when v_ingreso_ma = ANY (v_tipo) then
                                                              '08:30'
                                                            else
                                                              to_timestamp(v_ingreso_ma, 'HH24:MI')::time
                                                           end),
                                                           (case
                                                                when v_salidad_ma = ANY (v_tipo) then
                                                                  '13:30'
                                                                else
                                                                  to_timestamp(v_salidad_ma, 'HH24:MI')::time
                                                            end),
                                                            (case
                                                              when v_ingreso_ta = ANY (v_tipo) then
                                                                '14:30'
                                                              else
                                                                to_timestamp(v_ingreso_ta, 'HH24:MI')::time
                                                            end),
                                                              (case
                                                              when v_salidad_ta = ANY (v_tipo) then
                                                                '18:30'
                                                              else
                                                                to_timestamp(v_salidad_ta, 'HH24:MI')::time
                                                            end),
                                                            (case
                                                              when v_ingreso_no = ANY (v_tipo) then
                                                                '00:00'
                                                              else
                                                                to_timestamp(v_ingreso_no, 'HH24:MI')::time
                                                            end),
                                                            (case
                                                              when v_salidad_no = ANY (v_tipo) then
                                                                '00:00'
                                                              else
                                                                to_timestamp(v_salidad_no, 'HH24:MI')::time
                                                            end),
                                                            v_total_normal,
                                                            v_total_extra,
                                                            v_total_nocturna,
                                                            v_extras_autorizadas,
                                                            v_total_comp,
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
                                                            end);

                       end if;
              END IF;
		 END LOOP;

        select count (me.id_mes_trabajo_det) into v_count_det
        from asis.tmes_trabajo_det me
        where me.id_mes_trabajo = v_parametros.id_mes_trabajo;

        select count (tm.id) into v_count_tmp
        from tmp_ht tm;

        if (v_count_det != v_count_tmp)then
        	raise exception 'Hay diferencia de fila entre el archivo y lo registrado en etr';
        end if;
    	for v_record_tmp in ( select  tm.id_centro_costo,
                                      tm.dia,
                                      tm.ingreso_manana,
                                      tm.salida_manana,
                                      tm.ingreso_tarde,
                                      tm.salida_tarde,
                                      tm.ingreso_noche,
                                      tm.salida_noche,
                                      tm.total_normal,
                                      tm.total_nocturna,
                                      tm.total_extra,
                                      tm.extra_autorizada,
                                      tm.total_comp,
                                      tm.justificacion_extra,
                                      tm.tipo,
                                      tm.tipo_dos,
                                      tm.tipo_tres
                               from tmp_ht tm
                               order by dia) loop

                               select   md.id_mes_trabajo_det,
                                        md.id_centro_costo,
                                        md.dia,
                                        md.justificacion_extra,
                                        md.total_normal,
                                        md.total_extra,
                                        md.total_nocturna,
                                        md.total_comp,
                                        md.extra_autorizada,
                                        md.tipo,
                                        md.tipo_dos,
                                        md.tipo_tres
                                        into
                                        v_record_dm
                                from asis.tmes_trabajo_det md
                                where md.id_mes_trabajo = v_parametros.id_mes_trabajo and md.dia = v_record_tmp.dia;

                               if v_record_tmp.total_normal != v_record_dm.total_normal then
                                  raise exception 'Dia % las hora normales fuero modificados',v_record_tmp.dia;
                               end if;

                               if v_record_tmp.total_extra != v_record_dm.total_extra then
                                  raise exception 'Dia % las hora extras fuero modificados',v_record_tmp.dia;
                               end if;

                               if v_record_tmp.total_nocturna != v_record_dm.total_nocturna then
                                  raise exception 'Dia % las hora nocturnas fuero modificados',v_record_tmp.dia;
                               end if;

                               if v_record_tmp.total_comp != v_record_dm.total_comp then
                                  raise exception 'Dia % las hora compensacion fuero modificados',v_record_tmp.dia;
                               end if;

                               if v_record_tmp.extra_autorizada != v_record_dm.extra_autorizada then
                                  raise exception 'Dia % las hora autorizadas fuero modificados',v_record_tmp.dia;
                               end if;
                               ----
                                if v_record_tmp.tipo != v_record_dm.tipo then
                                  raise exception 'Columna modificado en tipo mañana';
                               end if;
                                if v_record_tmp.tipo_dos != v_record_dm.tipo_dos then
                                  raise exception 'Columna modificado en tipo tarde';
                               end if;
                                if v_record_tmp.tipo_tres != v_record_dm.tipo_tres then
                                  raise exception 'Columna modificado en tipo noche';
                               end if;

        	if v_record_tmp.id_centro_costo != v_record_dm.id_centro_costo then
                update asis.tmes_trabajo_det set
                id_centro_costo = v_record_tmp.id_centro_costo,
                id_centro_costo_anterior = v_record_dm.id_centro_costo
                where id_mes_trabajo_det = v_record_dm.id_mes_trabajo_det;
            end if;

        end loop;

          --Definicion de la respuesta
        v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Mes trabajo registrado(a)');
        v_resp = pxp.f_agrega_clave(v_resp,'v_parametros.id_mes_trabajo',v_parametros.id_mes_trabajo::varchar);

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

ALTER FUNCTION asis.ft_mes_trabajo_det_ime (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;