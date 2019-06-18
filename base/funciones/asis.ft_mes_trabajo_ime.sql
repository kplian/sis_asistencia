CREATE OR REPLACE FUNCTION asis.ft_mes_trabajo_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.ft_mes_trabajo_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.tmes_trabajo'
 AUTOR: 		 (miguel.mamani)
 FECHA:	        31-01-2019 13:53:10
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				31-01-2019 13:53:10							Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.tmes_trabajo'
 #4	ERT			17/06/2019 				 MMV				Validar cuando vuelve a estabo borrador se elimina los registros para el nuevo calculo de factor
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_mes_trabajo		integer;
    v_rec_gestion			record;
    v_codigo_tipo_proceso	varchar;
    v_id_proceso_macro		integer;
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
    v_id_mes_trabajo_con		integer; --#4

BEGIN

    v_nombre_funcion = 'asis.ft_mes_trabajo_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'ASIS_SMT_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		31-01-2019 13:53:10
	***********************************/

	if(p_transaccion='ASIS_SMT_INS')then

        begin

        if exists(	select 1
        			from asis.tmes_trabajo mt
        			where mt.id_periodo = v_parametros.id_periodo
        			and mt.id_funcionario = v_parametros.id_funcionario)then
        raise exception 'Ya fue registrao el funcionario para este periodo';
        end if;

        --Obtenemos la gestion
           select   g.id_gestion,
           			g.gestion
                   into
                   v_rec_gestion
                   from param.tgestion g
                   where g.gestion = EXTRACT(YEAR FROM current_date);

         select  tp.codigo,
           		 pm.id_proceso_macro
                into
                v_codigo_tipo_proceso,
                v_id_proceso_macro
           from  wf.tproceso_macro pm
           inner join wf.ttipo_proceso tp on tp.id_proceso_macro = pm.id_proceso_macro
           where pm.codigo='HT' and tp.estado_reg = 'activo' and tp.inicio = 'si';

             -- inciar el tramite en el sistema de WF
           SELECT
                 ps_num_tramite ,
                 ps_id_proceso_wf ,
                 ps_id_estado_wf ,
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
                 v_rec_gestion.id_gestion,
                 v_codigo_tipo_proceso,
                 NULL,
                 NULL,
                 'Horas de Trabajo',
                 v_codigo_tipo_proceso);

        	--Sentencia de la insercion
              insert into asis.tmes_trabajo(id_periodo,
                                            id_gestion,
                                            id_planilla,
                                            id_funcionario,
                                            id_estado_wf,
                                            id_proceso_wf,
                                           -- id_funcionario_apro,
                                            estado,
                                            estado_reg,
                                            obs,
                                            id_usuario_reg,
                                            usuario_ai,
                                            fecha_reg,
                                            id_usuario_ai,
                                            fecha_mod,
                                            id_usuario_mod,
                                            nro_tramite
                                            ) values(
                                            v_parametros.id_periodo,
                                            v_parametros.id_gestion,
                                            v_parametros.id_planilla,
                                            v_parametros.id_funcionario,
                                            v_id_estado_wf,
                                            v_id_proceso_wf,
                                            --v_parametros.id_funcionario_apro,
                                            v_codigo_estado,
                                            'activo',
                                            v_parametros.obs,
                                            p_id_usuario,
                                            v_parametros._nombre_usuario_ai,
                                            now(),
                                            v_parametros._id_usuario_ai,
                                            null,
                                            null,
                                            v_nro_tramite
                                            )RETURNING id_mes_trabajo into v_id_mes_trabajo;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','mes trabajo almacenado(a) con exito (id_mes_trabajo'||v_id_mes_trabajo||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_mes_trabajo',v_id_mes_trabajo::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_SMT_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		31-01-2019 13:53:10
	***********************************/

	elsif(p_transaccion='ASIS_SMT_MOD')then

		begin
			--Sentencia de la modificacion
			update asis.tmes_trabajo set
			id_periodo = v_parametros.id_periodo,
			id_gestion = v_parametros.id_gestion,
			id_planilla = v_parametros.id_planilla,
			id_funcionario = v_parametros.id_funcionario,
			obs = v_parametros.obs,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai
			where id_mes_trabajo=v_parametros.id_mes_trabajo;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','mes trabajo modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_mes_trabajo',v_parametros.id_mes_trabajo::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_SMT_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		31-01-2019 13:53:10
	***********************************/

	elsif(p_transaccion='ASIS_SMT_ELI')then

		begin

    		--Sentencia de la eliminacion
            delete from asis.tmes_trabajo_det
            where id_mes_trabajo = v_parametros.id_mes_trabajo;


			delete from asis.tmes_trabajo
            where id_mes_trabajo=v_parametros.id_mes_trabajo;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','mes trabajo eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_mes_trabajo',v_parametros.id_mes_trabajo::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;
    /*********************************
 	#TRANSACCION:  'ASIS_SIGA_IME'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		31-01-2019 13:53:10
	***********************************/

	elsif(p_transaccion='ASIS_SIGA_IME')then

		begin

        	select 	me.id_mes_trabajo,
            		me.id_estado_wf,
                    me.id_planilla,
                    me.estado,
                    me.nro_tramite
                    into
                    v_record
            from asis.tmes_trabajo me
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

           		IF NOT asis.f_procesar_estado(  p_id_usuario,
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
 	#TRANSACCION:  'ASIS_ANT_IME'
 	#DESCRIPCION:	Estado Anterior
 	#AUTOR:
 	#FECHA:
	***********************************/
    elsif(p_transaccion='ASIS_ANT_IME')then

		begin

           if  pxp.f_existe_parametro(p_tabla , 'estado_destino')  then
               v_operacion = v_parametros.estado_destino;
            end if;

			select me.id_mes_trabajo,
            		me.id_estado_wf,
                    me.id_planilla,
                    me.estado,
                    me.id_proceso_wf,
                    pwf.id_tipo_proceso
                    into
                    v_record
            from asis.tmes_trabajo me
            inner join wf.tproceso_wf pwf on pwf.id_proceso_wf = me.id_proceso_wf
            where me.id_proceso_wf = v_parametros.id_proceso_wf;

			v_id_proceso_wf = v_record.id_proceso_wf;


              delete from asis.tmes_trabajo_con c
              where c.id_mes_trabajo = v_record.id_mes_trabajo;


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

                  update asis.tmes_trabajo set
                  id_estado_wf =  v_id_estado_actual,
                  estado = v_codigo_estado,
                  id_usuario_mod = p_id_usuario,
                  id_usuario_ai = v_parametros._id_usuario_ai,
                  usuario_ai = v_parametros._nombre_usuario_ai,
                  fecha_mod = now()
                  where id_proceso_wf = v_parametros.id_proceso_wf;

                  ---#4---
				    select mt.id_mes_trabajo into v_id_mes_trabajo_con
                    from asis.tmes_trabajo mt
                    where mt.id_proceso_wf = v_parametros.id_proceso_wf;

                    delete from asis.tmes_trabajo_con mc
                    where mc.id_mes_trabajo = v_id_mes_trabajo_con;
                    ---#4---

             -- si hay mas de un estado disponible  preguntamos al usuario
                v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Se realizo el cambio de estado)');
                v_resp = pxp.f_agrega_clave(v_resp,'operacion','cambio_exitoso');

              --Devuelve la respuesta
                return v_resp;
 			end;

    /*********************************
 	#TRANSACCION:  'ASIS_FUN_IME'
 	#DESCRIPCION:	Obtener funcionario
 	#AUTOR:		MMV
 	#FECHA:		04/06/2019
	***********************************/
    elsif(p_transaccion='ASIS_FUN_IME')then
		begin

            select 	fun.id_funcionario,
                    pw.nombre_completo1
                    into
                    v_id_funcionario,
                    v_nombre_funcionario
            from segu.vpersona pw
            inner join orga.tfuncionario fun on fun.id_persona = pw.id_persona
            inner join segu.vusuario us on us.id_persona = pw.id_persona
            where us.id_usuario = p_administrador;

            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Transaccion Exitosa');
			v_resp = pxp.f_agrega_clave(v_resp,'id_funcionario',v_id_funcionario::varchar);
			v_resp = pxp.f_agrega_clave(v_resp,'nombre_completo',v_nombre_funcionario::varchar);
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