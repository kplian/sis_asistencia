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

	v_parametros           	    record;
	v_resp		                varchar;
	v_nombre_funcion            text;
	v_id_vacacion			    integer;
    v_id_gestion			    integer;
    v_codigo_proceso		    varchar;
    v_id_macro_proceso		    integer;
    v_nro_tramite			    varchar;
    v_id_proceso_wf			    integer;
	v_id_estado_wf			    integer;
    v_codigo_estado			    varchar;
    v_record				    record;
    v_id_tipo_estado		    integer;
    v_pedir_obs				    varchar;
    v_id_depto				    integer;
    v_obs					    text;
    v_acceso_directo 		    varchar;
    v_clase 				    varchar;
    v_parametros_ad 		    varchar;
    v_tipo_noti 			    varchar;
    v_titulo  				    varchar;
    v_id_estado_actual		    integer;
	v_operacion				    varchar;
    v_id_funcionario		    integer;
    v_id_usuario_reg			integer;
    v_id_estado_wf_ant			integer;
    v_codigo_estado_siguiente	varchar;
    v_cant_dias					numeric=0;
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
    v_movimiento				record;
    v_prestado					varchar;
	v_movimiento_vacacion		record;
    v_id_mov_actual				integer;
    v_vacacion_record			record;
    v_registro_estado 	  		record;
    va_id_tipo_estado 	  		integer [];
    va_codigo_estado 		  	varchar [];
    va_disparador 	      		varchar [];
    va_regla 				  	varchar [];
    va_prioridad 		      	integer [];
	v_id_sol_funcionario		integer;
    v_record_solicitud			record;
    v_estado_maestro			varchar;
    v_id_estado_maestro 		integer;
    v_estado_record             record;
    v_saldo_resgistro			numeric;
    v_operacion_reg					numeric;
    v_actual_vacacion				record;
    v_saldo_anterior				numeric;
    v_saldo							numeric;
    v_saldo_ant						numeric;
    v_registro						record;
    v_descripcion_correo    		varchar;
    v_id_alarma        				integer;
    v_dia_anerior					numeric;
    v_id_alarma_copiar				integer;
    v_id_funcionario_copia			integer;
    v_detalle_vac					record;
    -- v_movimiento_vacacion			record;

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
          
			--raise exception 'engt';
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
           

            v_valor_incremento := '1' || ' DAY';

            SELECT g.id_gestion
            INTO
            v_id_gestion_actual
            FROM param.tgestion g
            WHERE now() BETWEEN g.fecha_ini and g.fecha_fin;


			   	select
            l.codigo
            into v_lugar
            from segu.tusuario us
            join segu.tpersona p on p.id_persona=us.id_persona
            join orga.tfuncionario f on f.id_persona = p.id_persona
            join orga.tuo_funcionario uf on uf.id_funcionario=f.id_funcionario
            join orga.tcargo c on c.id_cargo=uf.id_cargo
            join param.tlugar l on l.id_lugar=c.id_lugar
            where uf.estado_reg = 'activo' and uf.tipo = 'oficial' 
            and uf.fecha_asignacion<=now() and
             coalesce(uf.fecha_finalizacion, now())>=now() and us.id_usuario=p_id_usuario;




            WHILE (SELECT v_fecha_aux::date <= v_parametros.fecha_fin::date ) loop
            	IF(select extract(dow from v_fecha_aux::date)not in (v_sabado, v_domingo)) THEN
                	IF NOT EXISTS(select * from param.tferiado f
                                          JOIN param.tlugar l on l.id_lugar = f.id_lugar
                                          WHERE l.codigo in ('BO',v_lugar)
                                           AND (EXTRACT(MONTH from f.fecha))::integer = (EXTRACT(MONTH from v_fecha_aux::date))::integer
                                          AND (EXTRACT(DAY from f.fecha))::integer = (EXTRACT(DAY from v_fecha_aux)) AND f.id_gestion=v_id_gestion_actual )THEN
                                          v_cant_dias=v_cant_dias+1;

                	END IF;


                END IF;

                v_incremento_fecha=(SELECT v_fecha_aux::date + CAST(v_valor_incremento AS INTERVAL));
                v_fecha_aux = v_incremento_fecha;
            end loop;

			IF v_cant_dias = 0 OR v_parametros.dias = 0 THEN-- contador de dias
	           RAISE EXCEPTION 'ERROR: CANTIDAD DE DIAS MAXIMO PERMITIDO MAYOR 0.';
            END IF;
		
              select va.id_movimiento_vacacion,
                     va.id_funcionario,
                     va.dias_actual,
                     va.codigo
                     into
                     v_movimiento
              from asis.tmovimiento_vacacion va
              where va.id_funcionario = v_parametros.id_funcionario
              		and va.activo = 'activo';
                    
            v_prestado = 'no';

            v_id_sol_funcionario = null;

            select fp.id_funcionario, fp.desc_funcionario1 into v_record_solicitud
            from segu.vusuario usu
            inner join orga.vfuncionario_persona fp on fp.id_persona = usu.id_persona
            where usu.id_usuario  = p_id_usuario;

            if(v_record_solicitud.id_funcionario <> v_parametros.id_funcionario)then
                v_id_sol_funcionario = v_record_solicitud.id_funcionario;
            end if;



              select v.dias_actual
                   		into
                   v_movimiento
            from asis.tmovimiento_vacacion v
            where v.id_funcionario = v_parametros.id_funcionario
            		and v.activo = 'activo' and v.estado_reg = 'activo';

	


				if(v_movimiento.dias_actual > 0 )then 

	                v_saldo_resgistro = v_movimiento.dias_actual - v_parametros.dias;
             
               	else
            		
               		v_operacion_reg = 1* - v_movimiento.dias_actual;
               
    	            v_saldo_resgistro = -1*(v_operacion_reg + v_parametros.dias);
               
                end if;
	
    				
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
                                        ---dias_efectivo,
                                        prestado,
                                        id_responsable,
                                        id_funcionario_sol,
                                        saldo
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
                                        --v_parametros.dias_efectivo,
                                        v_prestado,
                                        v_parametros.id_responsable,
                                        v_id_sol_funcionario,
                                        v_saldo_resgistro
                                        )RETURNING id_vacacion into v_id_vacacion;

            --Insertar detalle dias de la solicitud de vacion
            
           

            for v_record_det in (select dia::date as dia
                                  from generate_series(v_parametros.fecha_inicio,v_parametros.fecha_fin,
                                  '1 day'::interval) dia)loop

			IF NOT EXISTS(select * from param.tferiado f
                                          JOIN param.tlugar l on l.id_lugar = f.id_lugar
                                          WHERE l.codigo in ('BO',v_lugar)
                                          AND (EXTRACT(MONTH from f.fecha))::integer = (EXTRACT(MONTH from v_record_det.dia::date))::integer
                                          AND (EXTRACT(DAY from f.fecha))::integer = (EXTRACT(DAY from v_record_det.dia)) AND f.id_gestion=v_id_gestion_actual)THEN

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
                END IF;

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


			--raise exception 'v_fecha_aux %  v_id_gestion_actual %',v_fecha_aux,v_id_gestion_actual;
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
            
            select va.estado  into v_actual_vacacion
            from asis.tvacacion va
            where va.id_vacacion = v_parametros.id_vacacion;
            

            ----
            select v.dias into v_dia_anerior
            from asis.tvacacion v
			where v.id_vacacion = v_parametros.id_vacacion;
                
            v_saldo = 0;
            
            if (v_actual_vacacion.estado = 'aprobado') then
            	
            	if exists (	select 1
                            from asis.tmovimiento_vacacion mo 
                            where mo.id_vacacion = v_parametros.id_vacacion)then
                            
                        select mm.id_movimiento_vacacion,
                               mm.dias,
                               mm.dias_actual into v_movimiento_vacacion
                        from asis.tmovimiento_vacacion mm
                        where mm.id_vacacion = v_parametros.id_vacacion
                        	and mm.estado_reg = 'activo' and mm.activo='activo';    
                            
                            
                            
                            select ma.dias_actual into v_saldo_anterior
                            from asis.tmovimiento_vacacion ma
                            where ma.id_funcionario =  v_parametros.id_funcionario
                            	and ma.estado_reg = 'activo'
                            		and ma.fecha_reg = (select max(m.fecha_reg)
                                                        from asis.tmovimiento_vacacion m
                                                        where m.id_funcionario = v_parametros.id_funcionario
                                                            and m.estado_reg = 'activo'
                                                             and m.id_movimiento_vacacion != v_movimiento_vacacion.id_movimiento_vacacion);
                            
                            v_saldo = v_saldo_anterior - v_parametros.dias;
                            
                            update asis.tmovimiento_vacacion set
                            dias = v_parametros.dias,
                            dias_actual = v_saldo,
                            desde = v_parametros.fecha_inicio,
                            hasta =  v_parametros.fecha_fin
                            where id_movimiento_vacacion = v_movimiento_vacacion.id_movimiento_vacacion;
                            
                           
                else
                	
                	raise exception 'Comuníquese con el administrador.';
                
                end if;
                        
            end if;
            
            
            if (v_saldo = 0)then	
            
            	     
               select mo.dias_actual into v_saldo_ant
               from asis.tmovimiento_vacacion mo
               where mo.id_funcionario = v_parametros.id_funcionario and 
                    mo.estado_reg= 'activo' and activo = 'activo';
                    
               -- raise exception '%',v_saldo_ant;
               v_saldo = v_saldo_ant - v_parametros.dias;
            
            end if;
   
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
            id_responsable = v_parametros.id_responsable,
            saldo = v_saldo
			where id_vacacion=v_parametros.id_vacacion;


			select l.codigo
            into v_lugar
            from segu.tusuario us
            join segu.tpersona p on p.id_persona=us.id_persona
            join orga.tfuncionario f on f.id_persona = p.id_persona
            join orga.tuo_funcionario uf on uf.id_funcionario=f.id_funcionario
            join orga.tcargo c on c.id_cargo=uf.id_cargo
            join param.tlugar l on l.id_lugar=c.id_lugar
            where uf.estado_reg = 'activo' and uf.tipo = 'oficial' 
            and uf.fecha_asignacion<=now() 
            and coalesce(uf.fecha_finalizacion, now())>=now() and uf.id_funcionario = v_parametros.id_funcionario;

			
            SELECT g.id_gestion
            INTO
            v_id_gestion_actual
            FROM param.tgestion g
            WHERE now() BETWEEN g.fecha_ini and g.fecha_fin;


				
                
            if (v_dia_anerior != v_parametros.dias) then    
                
            delete from asis.tvacacion_det vd
            where vd.id_vacacion = v_parametros.id_vacacion;

            for v_record_det in (select dia::date as dia
                                  from generate_series(v_parametros.fecha_inicio,v_parametros.fecha_fin, '1 day'::interval) dia)loop

			IF NOT EXISTS(select * from param.tferiado f
                          JOIN param.tlugar l on l.id_lugar = f.id_lugar
                          WHERE l.codigo in ('BO',v_lugar)
                          AND (EXTRACT(MONTH from f.fecha))::integer = (EXTRACT(MONTH from v_record_det.dia::date))::integer
                          AND (EXTRACT(DAY from f.fecha))::integer = (EXTRACT(DAY from v_record_det.dia)) AND f.id_gestion=v_id_gestion_actual )THEN
    

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
                                  v_parametros.id_vacacion,
                                  v_record_det.dia
                                );
                        end if;
                    end if;
    			 end if;
                end loop;
            end if;
            

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
            
            select v.estado, v.prestado into v_vacacion_record
            from asis.tvacacion v
            where v.id_vacacion = v_parametros.id_vacacion;
            
            if(v_vacacion_record.prestado = 'si')then
            
            
            	
            	for v_detalle_vac in (select d.id_vacacion_det
                                      from asis.tvacacion_det d
                                      where d.id_vacacion)loop
            
            			update asis.tprogramacion set
                        estado = 'rechazado'
                        where id_vacacion_det = v_detalle_vac.id_vacacion_det;
            	    
                end loop;
            
            
            end if;
            
            delete from asis.tvacacion_det
			where id_vacacion = v_parametros.id_vacacion;

			delete from asis.tvacacion
            where id_vacacion = v_parametros.id_vacacion;
            
            
            

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
    /*********************************
 	#TRANSACCION:  'ASIS_VM_GET'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		MMV
 	#FECHA:		01-10-2019 15:29:35
	***********************************/

	elsif(p_transaccion='ASIS_VM_GET')then

		begin
			--Sentencia de la modificacion

              v_mensaje = 'Saldo disponible';

              select v.tipo,
                   v.dias_actual
                   into
                   v_movimiento
            from asis.tmovimiento_vacacion v
            where v.id_funcionario = v_parametros.id_funcionario
            		and v.activo = 'activo' and v.estado_reg = 'activo';


            if (v_movimiento.dias_actual <= 0)then

        		v_mensaje = 'Saldo no disponible';

            end if;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','El existo papu');
            v_resp = pxp.f_agrega_clave(v_resp,'id_funcionario',v_parametros.id_funcionario::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'tipo',v_movimiento.tipo::varchar);
            v_resp = pxp.f_agrega_clave(v_resp,'dias_actual',v_movimiento.dias_actual::varchar);
			v_resp = pxp.f_agrega_clave(v_resp,'evento',v_mensaje::varchar);
            --Devuelve la respuesta
            return v_resp;

		end;
    /*********************************
 	#TRANSACCION:  'ASIS_CAN_INS'
 	#DESCRIPCION:	Cancelar vacacion
 	#AUTOR:		MMV
 	#FECHA:		02-9-2020 15:29:35
	***********************************/

	elsif(p_transaccion='ASIS_CAN_INS')then

		begin
			--Sentencia de la modificacion


            select v.id_vacacion, v.id_funcionario into v_vacacion_record
            from asis.tvacacion v
            where v.id_vacacion = v_parametros.id_vacacion;



            select m.id_movimiento_vacacion, m.id_funcionario into v_movimiento_vacacion
            from asis.tmovimiento_vacacion m
            where m.id_vacacion = v_parametros.id_vacacion
				 and m.activo = 'activo';

               -- raise exception '%',v_movimiento_vacacion;

            delete from asis.tmovimiento_vacacion  mv
            where mv.id_movimiento_vacacion = v_movimiento_vacacion.id_movimiento_vacacion
            	and mv.activo = 'activo';


           -- raise exception '% -> %',v_parametros.id_vacacion
            delete from asis.tpares pa
            where pa.id_vacacion = v_parametros.id_vacacion
            	and pa.id_funcionario = v_vacacion_record.id_funcionario;


            select mm.id_movimiento_vacacion into v_id_mov_actual
            from asis.tmovimiento_vacacion mm
            where mm.id_funcionario = v_movimiento_vacacion.id_funcionario
            		and mm.fecha_reg = (select max(m.fecha_reg)
                                        from asis.tmovimiento_vacacion m
                                        where m.id_funcionario = v_movimiento_vacacion.id_funcionario);


            update asis.tmovimiento_vacacion set
            activo = 'activo',
            estado_reg = 'activo'
            where id_movimiento_vacacion = v_id_mov_actual;


             update asis.tvacacion set
             estado = 'cancelado'
             where id_vacacion = v_parametros.id_vacacion;

          /*  delete from asis.tvacacion  v
            where v.id_vacacion = v_parametros.id_vacacion;

            delete from asis.tvacacion_det vd
            where vd.id_vacacion = v_parametros.id_vacacion;*/



			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','El existo papu');
            v_resp = pxp.f_agrega_clave(v_resp,'id_vacacion',v_parametros.id_vacacion::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

    /****************************************************
    #TRANSACCION:     'ASIS_VVB_IME'
    #DESCRIPCION:     Cambiar de estado
    #AUTOR:           MMV
    #FECHA:			  31-01-2020 13:53:10
    ***************************************************/

    elsif( p_transaccion='ASIS_VVB_IME') then

   	 begin

          -- Validar estado
          select  pw.id_proceso_wf,
                  ew.id_estado_wf,
                  te.codigo,
                  pw.fecha_ini,
                  te.id_tipo_estado,
                  te.pedir_obs,
                  pw.nro_tramite
                into
                  v_registro_estado
                from wf.tproceso_wf pw
                inner join wf.testado_wf ew  on ew.id_proceso_wf = pw.id_proceso_wf and ew.estado_reg = 'activo'
                inner join wf.ttipo_estado te on ew.id_tipo_estado = te.id_tipo_estado
                where pw.id_proceso_wf =  v_parametros.id_proceso_wf;


               select v.id_vacacion,
               	      v.id_responsable,
                      v.descripcion
                      into
                      v_vacacion_record
               from  asis.tvacacion v
               where v.id_proceso_wf = v_parametros.id_proceso_wf;

               select  ps_id_tipo_estado,
                       ps_codigo_estado,
                       ps_disparador,
                       ps_regla,
                       ps_prioridad
                   into
                      va_id_tipo_estado,
                      va_codigo_estado,
                      va_disparador,
                      va_regla,
                      va_prioridad
                  from wf.f_obtener_estado_wf( v_registro_estado.id_proceso_wf,
                                               null,
                                               v_registro_estado.id_tipo_estado,
                                               'siguiente',
                                               p_id_usuario);

                      
                       v_acceso_directo = '../../../sis_asistencia/vista/vacacion/VacacionVoBo.php';
                       v_clase = 'VacacionVoBo';
                       v_parametros_ad = '{filtro_directo:{campo:"pmo.id_proceso_wf",valor:"'||v_registro_estado.id_proceso_wf::varchar||'"}}';
                       v_tipo_noti = 'notificacion';
                       v_titulo  = 'Visto Bueno';


		
                   		if( array_length(va_codigo_estado, 1) >= 2) then
                        
                   		     select  tt.id_tipo_estado,
                                tt.codigo
                                into
                                v_estado_record
                        from wf.ttipo_estado tt
                        where tt.id_tipo_estado in (select unnest(ARRAY[va_id_tipo_estado]))
                   		     and tt.codigo = v_parametros.evento;
                        
                            v_id_estado_maestro = v_estado_record.id_tipo_estado; 
                   		    v_estado_maestro = v_estado_record.codigo; 
                        
                        
                        else
                        
                       	    v_id_estado_maestro = va_id_tipo_estado[1]::integer;
                            v_estado_maestro = va_codigo_estado[1]::varchar;
                        
                        end if ;



                       v_id_estado_actual = wf.f_registra_estado_wf(  v_id_estado_maestro,
                                                                      v_vacacion_record.id_responsable,--v_parametros.id_funcionario_wf,
                                                                      v_registro_estado.id_estado_wf,
                                                                      v_registro_estado.id_proceso_wf,
                                                                      p_id_usuario,
                                                                      v_parametros._id_usuario_ai,
                                                                      v_parametros._nombre_usuario_ai,
                                                                      null,--v_id_depto,                       --depto del estado anterior
                                                                      v_vacacion_record.descripcion, --obt
                                                                      v_acceso_directo,
                                                                      v_clase,
                                                                      v_parametros_ad,
                                                                      v_tipo_noti,
                                                                      v_titulo);




             	IF NOT asis.f_procesar_estado_vacacion( p_id_usuario,
                                                        v_parametros._id_usuario_ai,
                                                        v_parametros._nombre_usuario_ai,
                                                        v_id_estado_actual,
                                                        v_parametros.id_proceso_wf,
                                                        v_estado_maestro,
                                                        v_parametros.obs) THEN

         			RAISE NOTICE 'PASANDO DE ESTADO';

          		END IF;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Exito');
            v_resp = pxp.f_agrega_clave(v_resp,'id_proceso_wf',v_parametros.id_proceso_wf::varchar);

            --Devuelve la respuesta
            return v_resp;



 		end;
    
    /*********************************
 	#TRANSACCION:  'ASIS_EMAIL_INS'
 	#DESCRIPCION:	Reenviar Correo
 	#AUTOR:		MMV
 	#FECHA:		5-1-2021 
	***********************************/

	elsif(p_transaccion='ASIS_EMAIL_INS')then

		begin
			--Sentencia de la modificacion
            
            	select 	me.id_vacacion,
                        me.fecha_inicio,
                        me.fecha_fin,
                        me.dias,
                        me.id_funcionario,
                        me.prestado,
                        me.id_funcionario_sol,
                        me.id_estado_wf,
                        fu.desc_funcionario1,
                        to_char(me.fecha_reg::date, 'DD/MM/YYYY') as fecha_solictudo,
                        to_char(me.fecha_inicio,'DD/MM/YYYY') as fecha_inicio,
                        to_char(me.fecha_fin, 'DD/MM/YYYY') as fecha_fin,
                        me.descripcion,
                        me.dias,
                        me.id_usuario_reg,
                        me.id_proceso_wf,
                        me.id_responsable
                        into
                        v_registro
                from asis.tvacacion me
                inner join orga.vfuncionario fu on fu.id_funcionario = me.id_funcionario
                where me.id_vacacion = v_parametros.id_vacacion;

            
               v_descripcion_correo = '<h3><b>SOLICITUD DE VACACIÓN</b></h3>
                                      <p style="font-size: 15px;"><b>Fecha solicitud:</b> '||v_registro.fecha_solictudo||' </p>
                                      <p style="font-size: 15px;"><b>Solicitud para:</b> '||v_registro.desc_funcionario1||'</p>
                                      <p style="font-size: 15px;"><b>Desde:</b> '||v_registro.fecha_inicio||' <b>Hasta:</b> '||v_registro.fecha_fin||'</p>
                                      <p style="font-size: 15px;"><b>Días solicitados:</b> '||v_registro.dias||'</p>
                                      <p style="font-size: 15px;"><b>Justificación:</b> '||v_registro.descripcion||'</p>';

                v_id_alarma = param.f_inserta_alarma(
                                    v_registro.id_responsable,
                                    v_descripcion_correo,--par_descripcion
                                    '../../../sis_asistencia/vista/vacacion/VacacionVoBo.php',--acceso directo
                                    now()::date,--par_fecha: Indica la fecha de vencimiento de la alarma
                                    'notificacion', --notificacion
                                    'Solicitud Vacacion',  --asunto
                                    p_id_usuario,
                                    'VacacionVoBo', --clase
                                    'Solicitud Vacacion',--titulo
                                    '',--par_parametros varchar,   parametros a mandar a la interface de acceso directo
                                    v_registro.id_usuario_reg, --usuario a quien va dirigida la alarma
                                    '',--titulo correo
                                    '', --correo funcionario
                                    null,--#9
                                    v_registro.id_proceso_wf,
                                    v_registro.id_estado_wf--#9
                                   );
                                   
                select f.id_funcionario into v_id_funcionario_copia
                from orga.vfuncionario_cargo f
                where (f.fecha_finalizacion is null or f.fecha_asignacion >= now()::date)
                      and f.desc_funcionario1 like '%MAGALI SIÑANI IRAHOLA%';
                
                v_id_alarma_copiar = param.f_inserta_alarma(
                                    v_id_funcionario_copia,
                                    v_descripcion_correo,--par_descripcion
                                    null,--acceso directo
                                    now()::date,--par_fecha: Indica la fecha de vencimiento de la alarma
                                    'notificacion', --notificacion
                                    'Solicitud Vacacion',  --asunto
                                    p_id_usuario,
                                    null, --clase
                                    'Solicitud Vacacion',--titulo
                                    '',--par_parametros varchar,   parametros a mandar a la interface de acceso directo
                                    v_id_funcionario_copia, --usuario a quien va dirigida la alarma
                                    '',--titulo correo
                                    '', --correo funcionario
                                    null,--#9
                                    v_registro.id_proceso_wf,
                                    v_registro.id_estado_wf--#9
                                   );      
                

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','El existo papu');
            v_resp = pxp.f_agrega_clave(v_resp,'id_vacacion',v_parametros.id_vacacion::varchar);

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
PARALLEL UNSAFE
COST 100;