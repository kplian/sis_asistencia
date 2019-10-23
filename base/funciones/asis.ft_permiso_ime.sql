CREATE OR REPLACE FUNCTION asis.ft_permiso_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.ft_permiso_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.tpermiso'
 AUTOR: 		 (miguel.mamani)
 FECHA:	        16-10-2019 13:14:05
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				16-10-2019 13:14:05								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.tpermiso'
 #
 ***************************************************************************/

DECLARE

	v_nro_requerimiento    	integer;
	v_parametros           	record;
	v_id_requerimiento     	integer;
	v_resp		            varchar;
	v_nombre_funcion        text;
	v_mensaje_error         text;
	v_id_permiso			integer;
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

    v_id_usuario_reg			integer;
    v_id_estado_wf_ant			integer;
    v_codigo_estado_siguiente	varchar;
    v_tiempo					time;
    v_diferencia				time;



BEGIN

    v_nombre_funcion = 'asis.ft_permiso_ime';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'ASIS_PMO_INS'
 	#DESCRIPCION:	Insercion de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		16-10-2019 13:14:05
	***********************************/

	if(p_transaccion='ASIS_PMO_INS')then

        begin

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
           where pm.codigo = 'PER' and tp.estado_reg = 'activo' and tp.inicio = 'si';

                 -- inciar el tramite en el sistema de WF
           SELECT
                 ps_num_tramite,
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
                 NULL,
                 'Permiso',
                 v_codigo_proceso);

      		v_tiempo = null;
            select tp.tiempo into v_tiempo
            from asis.ttipo_permiso tp
            where tp.id_tipo_permiso = v_parametros.id_tipo_permiso;

         -- raise exception 'entra la perra %',v_parametros.diferencia_tiempo;
           if v_parametros.diferencia_tiempo != '0' then

           		v_diferencia = left(v_parametros.diferencia_tiempo,5)::time;
                   if (v_diferencia > v_tiempo)then
                    raise exception 'Sobre pasa el limite de tiempo para el permiso';
                   end if;

           end if;

        	--Sentencia de la insercion
        	insert into asis.tpermiso(
			nro_tramite,
			id_funcionario,
			id_estado_wf,
			fecha_solicitud,
			id_tipo_permiso,
			motivo,
			estado_reg,
			estado,
			id_proceso_wf,
			id_usuario_ai,
			id_usuario_reg,
			usuario_ai,
			fecha_reg,
			fecha_mod,
			id_usuario_mod,
            hro_desde,
            hro_hasta
          	) values(
			v_nro_tramite,--v_parametros.nro_tramite,
			v_parametros.id_funcionario,
			v_id_estado_wf,--v_parametros.id_estado_wf,
			v_parametros.fecha_solicitud,
			v_parametros.id_tipo_permiso,
			v_parametros.motivo,
			'activo',
			v_codigo_estado,--v_parametros.estado,
			v_id_proceso_wf,--v_parametros.id_proceso_wf,
			v_parametros._id_usuario_ai,
			p_id_usuario,
			v_parametros._nombre_usuario_ai,
			now(),
			null,
			null,
            v_parametros.hro_desde,
            v_parametros.hro_hasta
			)RETURNING id_permiso into v_id_permiso;

			--Definicion de la respuesta
			v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Permiso almacenado(a) con exito (id_permiso'||v_id_permiso||')');
            v_resp = pxp.f_agrega_clave(v_resp,'id_permiso',v_id_permiso::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_PMO_MOD'
 	#DESCRIPCION:	Modificacion de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		16-10-2019 13:14:05
	***********************************/

	elsif(p_transaccion='ASIS_PMO_MOD')then

		begin
			--Sentencia de la modificacion
			update asis.tpermiso set
			id_funcionario = v_parametros.id_funcionario,
			fecha_solicitud = v_parametros.fecha_solicitud,
			id_tipo_permiso = v_parametros.id_tipo_permiso,
			motivo = v_parametros.motivo,
			fecha_mod = now(),
			id_usuario_mod = p_id_usuario,
			id_usuario_ai = v_parametros._id_usuario_ai,
			usuario_ai = v_parametros._nombre_usuario_ai,
            hro_desde = v_parametros.hro_desde,
            hro_hasta  = v_parametros.hro_hasta
			where id_permiso=v_parametros.id_permiso;

			--Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Permiso modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_permiso',v_parametros.id_permiso::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_PMO_ELI'
 	#DESCRIPCION:	Eliminacion de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		16-10-2019 13:14:05
	***********************************/

	elsif(p_transaccion='ASIS_PMO_ELI')then

		begin
			--Sentencia de la eliminacion
			delete from asis.tpermiso
            where id_permiso=v_parametros.id_permiso;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Permiso eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_permiso',v_parametros.id_permiso::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;

     /*********************************
 	#TRANSACCION:  'ASIS_SIGPMO_IME'
 	#DESCRIPCION:	siguiente
 	#AUTOR:		miguel.mamani
 	#FECHA:		31-01-2019 13:53:10
	***********************************/

	elsif(p_transaccion='ASIS_SIGPMO_IME')then

		begin
			--raise exception 'entra';
        	select 	me.id_permiso,
            		me.id_estado_wf,
                    me.estado,
                    me.nro_tramite
                    into
                    v_record
            from asis.tpermiso me
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

                 update asis.tpermiso set
                  id_estado_wf =  v_id_estado_actual,
                  estado = v_codigo_estado_siguiente,
                  id_usuario_mod = p_id_usuario,
                  id_usuario_ai = v_parametros._id_usuario_ai,
                  usuario_ai = v_parametros._nombre_usuario_ai,
                  fecha_mod = now()
                  where id_proceso_wf = v_parametros.id_proceso_wf_act;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','mes trabajo cambio de estado (a)');
            v_resp = pxp.f_agrega_clave(v_resp,'id_proceso_wf_act',v_parametros.id_proceso_wf_act::varchar);

            --Devuelve la respuesta
            return v_resp;

		end;
     /*********************************
 	#TRANSACCION:  'ASIS_ANTPMO_IME'
 	#DESCRIPCION:	Estado Anterior
 	#AUTOR: MMV
 	#FECHA: 07/10/2019
	***********************************/
    elsif(p_transaccion='ASIS_ANTPMO_IME')then

		begin

           if  pxp.f_existe_parametro(p_tabla , 'estado_destino')  then
               v_operacion = v_parametros.estado_destino;
            end if;

			select me.id_permiso,
            		me.id_estado_wf,
                    me.estado,
                    me.id_proceso_wf,
                    pwf.id_tipo_proceso
                    into
                    v_record
            from asis.tpermiso me
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

                  update asis.tpermiso set
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

ALTER FUNCTION asis.ft_permiso_ime (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO postgres;