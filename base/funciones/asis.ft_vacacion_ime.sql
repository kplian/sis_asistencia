CREATE OR REPLACE FUNCTION asis.ft_vacacion_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.ft_vacacion_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.tvacacion'
 AUTOR: 		 (apinto)
 FECHA:	        01-10-2019 15:29:35
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				01-10-2019 15:29:35								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.tvacacion'
#25			14-08-2020 15:28:39		MMV						Refactorizacion vacaciones
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_vacacion			integer;
    v_id_gestion			integer;
    v_codigo_proceso		varchar;
    v_id_macro_proceso		integer;
    v_nro_tramite			varchar;
    v_id_proceso_wf			integer;
	v_id_estado_wf			integer;
    v_codigo_estado			varchar;
    v_record				record;
    v_id_tipo_estado		integer;
    v_pedir_obs				varchar;
    v_id_depto				integer;
    v_obs					text;
    v_acceso_directo 		varchar;
    v_clase 				varchar;
    v_parametros_ad 		varchar;
    v_tipo_noti 			varchar;
    v_titulo  				varchar;
    v_id_estado_actual		integer;
	v_operacion				varchar;
    v_id_funcionario		integer;
    v_nombre_funcionario	varchar;
    v_id_usuario_reg			integer;
    v_id_estado_wf_ant			integer;
    v_codigo_estado_siguiente	varchar;
    v_cant_dias					numeric=0;
    v_fecha_inicial				date;
    v_fecha_final				date;
    v_incremento_fecha      	date;
    v_valor_incremento			varchar;
    v_domingo 					INTEGER = 0;
    v_sabado 					INTEGER = 6;
    v_parte_decimal				varchar;
    v_mensaje					varchar;
    v_fecha_aux					date;
    v_lugar						varchar;
    v_id_gestion_actual         integer;
    v_record_det                record;


BEGIN

    v_nombre_funcion = 'asis.ft_vacacion_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'ASIS_VAC_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		apinto
 	#FECHA:		01-10-2019 15:29:35
	***********************************/

	if(p_transaccion='ASIS_VAC_INS')then

        begin
          --Obtenemos la gestion
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
           where pm.codigo = 'VAC' and tp.estado_reg = 'activo' and tp.inicio = 'si';


           -- inciar el tramite en el sistema de WF

           SELECT
                 ps_num_tramite ,
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
                 null,
                 'Vacaciones',
                 v_codigo_proceso);


        	--validar si tiene vacacione

        	--Sentencia de la insercion

            v_fecha_aux = v_parametros.fecha_inicio;
            IF v_fecha_aux::DATE > v_parametros.fecha_fin::DATE THEN
	            RAISE EXCEPTION 'ERROR: FECHA INICIO MAYOR A FECHA FIN.';
            END IF;

            v_valor_incremento := '1' || ' DAY';

            SELECT g.id_gestion
            INTO
            v_id_gestion_actual
            FROM param.tgestion g
            WHERE now() BETWEEN g.fecha_ini and g.fecha_fin;

            WHILE (SELECT v_fecha_aux::date <= v_parametros.fecha_fin::date ) loop
            	IF(select extract(dow from v_fecha_aux::date)not in (v_sabado, v_domingo)) THEN
                	IF NOT EXISTS(select * from param.tferiado f
                                          JOIN param.tlugar l on l.id_lugar = f.id_lugar
                                          WHERE l.codigo='BO' AND (EXTRACT(MONTH from f.fecha))::integer = (EXTRACT(MONTH from v_fecha_aux::date))::integer
                                          AND (EXTRACT(DAY from f.fecha))::integer = (EXTRACT(DAY from v_fecha_aux)) AND f.id_gestion=v_id_gestion_actual )THEN
                                          v_cant_dias=v_cant_dias+1;

                	END IF;


                END IF;

                v_incremento_fecha=(SELECT v_fecha_aux::date + CAST(v_valor_incremento AS INTERVAL));
                v_fecha_aux = v_incremento_fecha;
            end loop;

            IF v_cant_dias = 0 OR v_parametros.dias = 0 THEN-- contador de dias
	           RAISE EXCEPTION 'ERROR: DIA NO PERMITIDO.';
            END IF;

            IF v_cant_dias < v_parametros.dias::numeric AND v_parametros.dias::numeric >= 0.5 then
	            RAISE EXCEPTION 'ERROR: CANTIDAD DE DIAS MAXIMO PERMITIDO: %', v_cant_dias ;
            END IF;

            --v_parte_decimal = SELECT split_part(v_parametros.dias, '.', 2);
            IF((SELECT split_part(v_parametros.dias::varchar, '.', 2))::varchar != '5' AND (SELECT split_part(v_parametros.dias::varchar, '.', 2))::varchar != '')THEN
            	RAISE EXCEPTION 'ERROR, DECIMAL NO PERMITIDO! %', v_parte_decimal ;
            END IF;


            insert into asis.tvacacion( estado_reg,
                                        id_funcionario,
                                        fecha_inicio,
                                        fecha_fin,
                                        dias,
                                        descripcion,
                                        id_usuario_reg,
                                        fecha_reg,
                                        id_usuario_ai,
                                        usuario_ai,
                                        id_usuario_mod,
                                        fecha_mod,
                                        id_proceso_wf, --campo wf
                                        id_estado_wf,--campo wf
                                        estado,--campo wf
                                        nro_tramite,--campo wf
                                        medio_dia,-- medio_dia
                                        dias_efectivo
                                        ) values(
                                        'activo',
                                        v_parametros.id_funcionario,
                                        v_parametros.fecha_inicio,
                                        v_parametros.fecha_fin,
                                        v_parametros.dias,
                                        v_parametros.descripcion,
                                        p_id_usuario,
                                        now(),
                                        v_parametros._id_usuario_ai,
                                        v_parametros._nombre_usuario_ai,
                                        null,
                                        null,
                                        v_id_proceso_wf,
                                        v_id_estado_wf,
                                        v_codigo_estado,
                                        v_nro_tramite,
                                        0,--v_parametros.medio_dia,
                                        v_parametros.dias_efectivo)RETURNING id_vacacion into v_id_vacacion;

            --Insertar detalle dias de la solicitud de vacion

            for v_record_det in (select dia::date as dia
                                  from generate_series(v_parametros.fecha_inicio,v_parametros.fecha_fin, '1 day'::interval) dia)loop


                if extract(dow from v_record_det.dia::date) <> 0 then
                    if extract(dow from v_record_det.dia::date) <> 6 then
                    INSERT INTO
                                  asis.tvacacion_det
                                (
                                  id_usuario_reg,
                                  id_usuario_mod,
                                  fecha_reg,
                                  fecha_mod,
                                  id_usuario_ai,
                                  usuario_ai,
                                  id_vacacion,
                                  fecha_dia
                                )
                                VALUES (
                                  p_id_usuario,
                                  null,
                                  now(),
                                  null,
                                  v_parametros._id_usuario_ai,
                                  v_parametros._nombre_usuario_ai,
                                  v_id_vacacion,
                                  v_record_det.dia
                                );
                        end if;
                    end if;
                end loop;


			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Vacación almacenado(a) con exito (id_vacacion'||v_id_vacacion||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_vacacion',v_id_vacacion::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

    /*********************************
 	#TRANSACCION:  'ASIS_VAC_VALID'
 	#DESCRIPCION:	VALIDACION DE DATOS VACACIÓN.
 	#AUTOR:		apinto
 	#FECHA:		15-10-2019 15:29:35
	***********************************/

	elsif(p_transaccion='ASIS_VAC_VALID')then

        begin
        	--Raise exception '%', p_id_usuario;
         	select
            l.codigo
            into v_lugar
            from segu.tusuario us
            join segu.tpersona p on p.id_persona=us.id_persona
            join orga.tfuncionario f on f.id_persona = p.id_persona
            join orga.tuo_funcionario uf on uf.id_funcionario=f.id_funcionario
            join orga.tcargo c on c.id_cargo=uf.id_cargo
            join param.tlugar l on l.id_lugar=c.id_lugar
            where uf.estado_reg = 'activo' and uf.tipo = 'oficial' and uf.fecha_asignacion<=now() and coalesce(uf.fecha_finalizacion, now())>=now() and us.id_usuario=p_id_usuario;

        	--Sentencia de la insercion
            IF v_parametros.fecha_inicio::DATE > v_parametros.fecha_fin::DATE THEN
            	v_mensaje = 'ERROR: FECHA INICIO MAYOR A FECHA FIN.';
            END IF;

            v_fecha_aux := v_parametros.fecha_inicio;
            v_valor_incremento := '1' || ' DAY';

            SELECT g.id_gestion
            INTO
            v_id_gestion_actual
            FROM param.tgestion g
            WHERE v_fecha_aux BETWEEN g.fecha_ini and g.fecha_fin;

            WHILE (SELECT (v_fecha_aux::date) <= v_parametros.fecha_fin::date ) loop
            	IF(select extract(dow from v_fecha_aux::date)not in (v_sabado, v_domingo) ) THEN
                	IF NOT EXISTS(select * from param.tferiado f
                                          JOIN param.tlugar l on l.id_lugar = f.id_lugar
                                          WHERE l.codigo in ('BO',v_lugar)
                                          AND (EXTRACT(MONTH from f.fecha))::integer = (EXTRACT(MONTH from v_fecha_aux::date))::integer
                                          AND (EXTRACT(DAY from f.fecha))::integer = (EXTRACT(DAY from v_fecha_aux)) AND f.id_gestion=v_id_gestion_actual )THEN
                                          	v_cant_dias=v_cant_dias+1;

                	END IF;
                END IF;
                v_incremento_fecha = v_fecha_aux::date + v_valor_incremento::INTERVAL;
                v_fecha_aux := v_incremento_fecha;
            end loop;


            IF v_cant_dias = 0 then -- contador de dias
            	v_mensaje = 'ERROR: DIA NO PERMITIDO.';
            END IF;

            IF(v_parametros.medios_dias = TRUE)THEN
            	v_cant_dias = v_cant_dias/2;
            END IF;

			--Definicion de la respuesta

			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Vacación almacenado(a) con exito (id_vacacion'||v_id_vacacion||')');
            v_resp = pxp.f_agrega_clave(v_resp,'v_cant_dias','%'||v_cant_dias||'%'::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;


	/*********************************
 	#TRANSACCION:  'ASIS_VAC_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		apinto
 	#FECHA:		01-10-2019 15:29:35
	***********************************/

	elsif(p_transaccion='ASIS_VAC_MOD')then

		begin
			--Sentencia de la modificacion
			update asis.tvacacion set
			id_funcionario = v_parametros.id_funcionario,
			fecha_inicio = v_parametros.fecha_inicio,
			fecha_fin = v_parametros.fecha_fin,
			dias = v_parametros.dias,
			descripcion = v_parametros.descripcion,
			id_usuario_mod = p_id_usuario,
			fecha_mod = now(),
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai,
            medio_dia = v_parametros.medio_dia,
            dias_efectivo = v_parametros.dias_efectivo
            --medio_dia

			where id_vacacion=v_parametros.id_vacacion;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Vacación modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_vacacion',v_parametros.id_vacacion::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_VAC_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		apinto
 	#FECHA:		01-10-2019 15:29:35
	***********************************/

	elsif(p_transaccion='ASIS_VAC_ELI')then

		begin
			--Sentencia de la eliminacion
            delete from asis.tvacacion_det
			where id_vacacion = v_parametros.id_vacacion;

			delete from asis.tvacacion
            where id_vacacion=v_parametros.id_vacacion;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Vacación eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_vacacion',v_parametros.id_vacacion::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

     /*********************************
 	#TRANSACCION:  'ASIS_SIGAV_IME'
 	#DESCRIPCION:	siguiente
 	#AUTOR:		miguel.mamani
 	#FECHA:		31-01-2019 13:53:10
	***********************************/

	elsif(p_transaccion='ASIS_SIGAV_IME')then

		begin

        	select 	me.id_vacacion,
            		me.id_estado_wf,
                    me.estado,
                    me.nro_tramite
                    into
                    v_record
            from asis.tvacacion me
            where me.id_proceso_wf = v_parametros.id_proceso_wf_act;


            select ew.id_tipo_estado,
                   te.pedir_obs,
                   ew.id_estado_wf
             into
              v_id_tipo_estado,
              v_pedir_obs,
              v_id_estado_wf
            from wf.testado_wf ew
            inner join wf.ttipo_estado te on te.id_tipo_estado = ew.id_tipo_estado
            where ew.id_estado_wf =  v_parametros.id_estado_wf_act;

            select te.codigo
            	into
               v_codigo_estado_siguiente
            from wf.ttipo_estado te
            where te.id_tipo_estado = v_parametros.id_tipo_estado;

           IF  pxp.f_existe_parametro(p_tabla,'id_depto_wf') THEN
           	 v_id_depto = v_parametros.id_depto_wf;
           END IF;

           IF  pxp.f_existe_parametro(p_tabla,'obs') THEN
           	 v_obs = v_parametros.obs;
           ELSE
           	 v_obs='---';
           END IF;

           --configurar acceso directo para la alarma
             v_acceso_directo = '';
             v_clase = '';
             v_parametros_ad = '';
             v_tipo_noti = 'notificacion';
             v_titulo  = 'Visto Bueno';


             -- hay que recuperar el supervidor que seria el estado inmediato...
            v_id_estado_actual = wf.f_registra_estado_wf(v_parametros.id_tipo_estado,
                                                         v_parametros.id_funcionario_wf,
                                                         v_parametros.id_estado_wf_act,
                                                         v_parametros.id_proceso_wf_act,
                                                         p_id_usuario,
                                                         v_parametros._id_usuario_ai,
                                                         v_parametros._nombre_usuario_ai,
                                                         v_id_depto,
                                                         COALESCE(v_record.nro_tramite,'--')||' Obs:'||v_obs,
                                                         v_acceso_directo ,
                                                         v_clase,
                                                         v_parametros_ad,
                                                         v_tipo_noti,
                                                         v_titulo);

           		IF NOT asis.f_procesar_estado_vacacion(  p_id_usuario,
                                                        v_parametros._id_usuario_ai,
                                                        v_parametros._nombre_usuario_ai,
                                                        v_id_estado_actual,
                                                        v_parametros.id_proceso_wf_act,
                                                        v_codigo_estado_siguiente) THEN

         			RAISE NOTICE 'PASANDO DE ESTADO';

          		END IF;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','mes trabajo cambio de estado (a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_proceso_wf_act',v_parametros.id_proceso_wf_act::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;
     /*********************************
 	#TRANSACCION:  'ASIS_ANTV_IME'
 	#DESCRIPCION:	Estado Anterior
 	#AUTOR: MMV
 	#FECHA: 07/10/2019
	***********************************/
    elsif(p_transaccion='ASIS_ANTV_IME')then

		begin

           if  pxp.f_existe_parametro(p_tabla , 'estado_destino')  then
               v_operacion = v_parametros.estado_destino;
            end if;

			select me.id_vacacion,
            		me.id_estado_wf,
                    me.estado,
                    me.id_proceso_wf,
                    pwf.id_tipo_proceso
                    into
                    v_record
            from asis.tvacacion me
            inner join wf.tproceso_wf pwf on pwf.id_proceso_wf = me.id_proceso_wf
            where me.id_proceso_wf = v_parametros.id_proceso_wf;

			v_id_proceso_wf = v_record.id_proceso_wf;




          SELECT

             ps_id_tipo_estado,
             ps_id_funcionario,
             ps_id_usuario_reg,
             ps_id_depto,
             ps_codigo_estado,
             ps_id_estado_wf_ant
          into
             v_id_tipo_estado,
             v_id_funcionario,
             v_id_usuario_reg,
             v_id_depto,
             v_codigo_estado,
             v_id_estado_wf_ant
          FROM wf.f_obtener_estado_ant_log_wf(v_parametros.id_estado_wf);


             --configurar acceso directo para la alarma
                 v_acceso_directo = '';
                 v_clase = '';
                 v_parametros_ad = '';
                 v_tipo_noti = 'notificacion';
                 v_titulo  = 'Visto Bueno';

              -- registra nuevo estado

              v_id_estado_actual = wf.f_registra_estado_wf(	  v_id_tipo_estado,                --  id_tipo_estado al que retrocede
                                                              v_id_funcionario,                --  funcionario del estado anterior
                                                              v_parametros.id_estado_wf,       --  estado actual ...
                                                              v_id_proceso_wf,                 --  id del proceso actual
                                                              p_id_usuario,                    -- usuario que registra
                                                              v_parametros._id_usuario_ai,
                                                              v_parametros._nombre_usuario_ai,
                                                              v_id_depto,                       --depto del estado anterior
                                                              '[RETROCESO] '|| v_parametros.obs,
                                                              v_acceso_directo,
                                                              v_clase,
                                                              v_parametros_ad,
                                                              v_tipo_noti,
                                                              v_titulo);

                  update asis.tvacacion set
                  id_estado_wf =  v_id_estado_actual,
                  estado = v_codigo_estado,
                  id_usuario_mod = p_id_usuario,
                  id_usuario_ai = v_parametros._id_usuario_ai,
                  usuario_ai = v_parametros._nombre_usuario_ai,
                  fecha_mod = now()
                  where id_proceso_wf = v_parametros.id_proceso_wf;


             -- si hay mas de un estado disponible  preguntamos al usuario
                v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se realizo el cambio de estado)');
                v_resp = pxp.f_agrega_clave(v_resp,'operacion','cambio_exitoso');

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

ALTER FUNCTION asis.ft_vacacion_ime (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;