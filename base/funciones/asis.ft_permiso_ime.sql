create or replace function asis.ft_permiso_ime(p_administrador integer, p_id_usuario integer, p_tabla character varying, p_transaccion character varying) returns character varying
    language plpgsql
as
$$
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
#25			14-08-2020 15:28:39		MMV						Refactorizacion permiso
 ***************************************************************************/

DECLARE

    v_parametros              record;
    v_resp                    varchar;
    v_nombre_funcion          text;
    v_id_permiso              integer;
    v_id_gestion              integer;
    v_codigo_proceso          varchar;
    v_id_macro_proceso        integer;
    v_nro_tramite             varchar;
    v_id_proceso_wf           integer;
    v_id_estado_wf            integer;
    v_codigo_estado           varchar;
    v_record                  record;
    v_id_tipo_estado          integer;
    v_id_depto                integer;
    v_acceso_directo          varchar;
    v_clase                   varchar;
    v_parametros_ad           varchar;
    v_tipo_noti               varchar;
    v_titulo                  varchar;
    v_id_estado_actual        integer;
    v_operacion               varchar;
    v_id_funcionario          integer;
    v_id_usuario_reg          integer;
    v_id_estado_wf_ant        integer;
    v_diferencia              time;
    v_registro_funcionario    record;
    v_consulta                varchar;
    v_inicio                  varchar;
    v_fin                     varchar;
    v_record_tipo             record;
    v_desde_hrs               timestamp;
    v_hasta_hrs               timestamp;
    v_desde_alm               timestamp;
    v_hasta_alm               timestamp;
    v_resultado               numeric;
    v_almuerzo                boolean;
    v_permiso                 record;
    va_id_tipo_estado         integer[];
    va_codigo_estado          varchar[];
    va_disparador             varchar[];
    va_regla                  varchar[];
    va_prioridad              integer[];
    v_registro_estado         record;
    v_record_solicitud        record;
    v_id_sol_funcionario      integer;
    v_descripcion_correo      varchar;
    v_id_alarma               integer;
    v_vista_permiso           record;
    v_estado_maestro          varchar;
    v_id_estado_maestro       integer;
    v_estado_record           record;
    v_rol                     integer;
    v_fecha_aux               date;
    v_domingo                 INTEGER = 0;
    v_sabado                  INTEGER = 6;
    v_valor_incremento        varchar;
    v_cant_dias               numeric=0;
    v_lugar                   varchar;
    v_id_gestion_actual       integer;
    v_incremento_fecha        date;
    v_dias_permetidos         numeric;
BEGIN

    v_nombre_funcion = 'asis.ft_permiso_ime';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
     #TRANSACCION:  'ASIS_PMO_INS'
     #DESCRIPCION:	Insercion de registros
     #AUTOR:		miguel.mamani
     #FECHA:		16-10-2019 13:14:05
    ***********************************/

    if (p_transaccion = 'ASIS_PMO_INS') then

        begin

            -- raise exception '%',v_parametros.jornada;

            select g.id_gestion
            into
                v_id_gestion
            from param.tgestion g
            where g.gestion = EXTRACT(YEAR FROM current_date);

            --obtener el proceso
            select tp.codigo,
                   pm.id_proceso_macro
            into
                v_codigo_proceso,
                v_id_macro_proceso
            from wf.tproceso_macro pm
                     inner join wf.ttipo_proceso tp on tp.id_proceso_macro = pm.id_proceso_macro
            where pm.codigo = 'PER'
              and tp.estado_reg = 'activo'
              and tp.inicio = 'si';

            -- inciar el tramite en el sistema de WF
            SELECT ps_num_tramite,
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

            select tp.documento,
                   tp.reposcion,
                   tp.rango,
                   tp.tiempo
            into
                v_record_tipo
            from asis.ttipo_permiso tp
            where tp.id_tipo_permiso = v_parametros.id_tipo_permiso;


            if (v_record_tipo.tiempo::time > '00:00:00'::time) then

                if (v_record_tipo.reposcion = 'si') then

                    v_diferencia = v_parametros.hro_total_permiso::time;

                    if (v_diferencia::time > v_record_tipo.tiempo::time) then
                        raise exception 'Excede el limite de tiempo para el permiso (%)',v_record_tipo.tiempo::time;
                    end if;

                    if v_parametros.hro_total_reposicion::time < v_parametros.hro_total_permiso::time then
                        raise exception 'El tiempo de reposicion es menor al tiempo del permiso';
                    elsif v_parametros.hro_total_reposicion::time > v_parametros.hro_total_permiso::time then
                        raise exception 'El tiempo de reposicion es mayor al tiempo del permiso';
                    elsif v_parametros.hro_total_permiso::time != v_parametros.hro_total_reposicion::time then
                        raise exception 'El tiempo de la reposición es distinto a tiempo del permiso';
                    end if;


                end if;
            end if;

            -- validar si tiene una vacacion registrada el dia

            v_id_sol_funcionario = null;

            select fp.id_funcionario, fp.desc_funcionario1
            into v_record_solicitud
            from segu.vusuario usu
                     inner join orga.vfuncionario_persona fp on fp.id_persona = usu.id_persona
            where usu.id_usuario = p_id_usuario;

            if (v_record_solicitud.id_funcionario <> v_parametros.id_funcionario) then
                v_id_sol_funcionario = v_record_solicitud.id_funcionario;
            end if;


            v_fecha_aux = v_parametros.fecha_inicio;


            v_valor_incremento := '1' || ' DAY';

            SELECT g.id_gestion
            INTO
                v_id_gestion_actual
            FROM param.tgestion g
            WHERE now() BETWEEN g.fecha_ini and g.fecha_fin;


            select l.codigo
            into v_lugar
            from segu.tusuario us
                     join segu.tpersona p on p.id_persona = us.id_persona
                     join orga.tfuncionario f on f.id_persona = p.id_persona
                     join orga.tuo_funcionario uf on uf.id_funcionario = f.id_funcionario
                     join orga.tcargo c on c.id_cargo = uf.id_cargo
                     join param.tlugar l on l.id_lugar = c.id_lugar
            where uf.estado_reg = 'activo'
              and uf.tipo = 'oficial'
              and uf.fecha_asignacion <= now()
              and coalesce(uf.fecha_finalizacion, now()) >= now()
              and us.id_usuario = p_id_usuario;


            WHILE (SELECT v_fecha_aux::date <= v_parametros.fecha_fin::date)
                loop
                    IF (select extract(dow from v_fecha_aux::date) not in (v_sabado, v_domingo)) THEN
                        IF NOT EXISTS(select *
                                      from param.tferiado f
                                               JOIN param.tlugar l on l.id_lugar = f.id_lugar
                                      WHERE l.codigo in ('BO', v_lugar)
                                        AND (EXTRACT(MONTH from f.fecha))::integer =
                                            (EXTRACT(MONTH from v_fecha_aux::date))::integer
                                        AND (EXTRACT(DAY from f.fecha))::integer = (EXTRACT(DAY from v_fecha_aux))
                                        AND f.id_gestion = v_id_gestion_actual) THEN
                            v_cant_dias = v_cant_dias + 1;

                        END IF;


                    END IF;

                    v_incremento_fecha = (SELECT v_fecha_aux::date + CAST(v_valor_incremento AS INTERVAL));
                    v_fecha_aux = v_incremento_fecha;
                end loop;

            /*IF v_cant_dias = 0 OR v_parametros.dias = 0 THEN-- contador de dias
                RAISE EXCEPTION 'ERROR: CANTIDAD DE DIAS MAXIMO PERMITIDO MAYOR 0.';
            END IF;*/

            select dt.dias
            into v_dias_permetidos
            from asis.tdetalle_tipo_permiso dt
            where dt.id_detalle_tipo_permiso = v_parametros.id_tipo_licencia;

            if v_cant_dias > v_dias_permetidos then
                raise exception 'Solo esta permitido (%) dias.',v_dias_permetidos;
            end if;

            --Sentencia de la insercion
            insert into asis.tpermiso(nro_tramite,
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
                                      hro_hasta,
                                      fecha_reposicion, ---nuevo
                                      hro_desde_reposicion,
                                      hro_hasta_reposicion,
                                      reposicion,
                                      hro_total_permiso,
                                      hro_total_reposicion,
                                      id_responsable,
                                      id_funcionario_sol,
                                      id_tipo_licencia,
                                      fecha_inicio,
                                      fecha_fin,
                                      dias
                -- jornada
            )
            values (v_nro_tramite,--v_parametros.nro_tramite,
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
                    v_parametros.hro_hasta,
                    v_parametros.fecha_reposicion, ---nuevo
                    v_parametros.hro_desde_reposicion,
                    v_parametros.hro_hasta_reposicion,
                    v_record_tipo.reposcion,
                    v_parametros.hro_total_permiso,
                    v_parametros.hro_total_reposicion,
                    v_parametros.id_responsable,
                    v_id_sol_funcionario,
                    v_parametros.id_tipo_licencia,
                    v_parametros.fecha_inicio,
                    v_parametros.fecha_fin,
                    v_cant_dias)
            RETURNING id_permiso into v_id_permiso;

            if (v_record_tipo.documento = 'si') then

                INSERT INTO wf.tdocumento_wf
                (id_usuario_reg,
                 fecha_reg,
                 estado_reg,
                 id_tipo_documento,
                 id_proceso_wf,
                 num_tramite,
                 momento,
                 chequeado,
                 id_estado_ini)
                VALUES (p_id_usuario,
                        now(),
                        'activo',
                        314,---v_registros.id_tipo_documento,
                        v_id_proceso_wf,
                        v_nro_tramite,
                        'verificar',
                        'no',
                        v_id_estado_wf--v_id_estado_actual
                       );


            end if;


            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp, 'mensaje',
                                        'Permiso almacenado(a) con exito (id_permiso' || v_id_permiso || ')');
            v_resp = pxp.f_agrega_clave(v_resp, 'id_permiso', v_id_permiso::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

        /*********************************
         #TRANSACCION:  'ASIS_PMO_MOD'
         #DESCRIPCION:	Modificacion de registros
         #AUTOR:		miguel.mamani
         #FECHA:		16-10-2019 13:14:05
        ***********************************/

    elsif (p_transaccion = 'ASIS_PMO_MOD') then

        begin
            --Sentencia de la modificacion

            v_fecha_aux = v_parametros.fecha_inicio;


            v_valor_incremento := '1' || ' DAY';

            SELECT g.id_gestion
            INTO
                v_id_gestion_actual
            FROM param.tgestion g
            WHERE now() BETWEEN g.fecha_ini and g.fecha_fin;


            select l.codigo
            into v_lugar
            from segu.tusuario us
                     join segu.tpersona p on p.id_persona = us.id_persona
                     join orga.tfuncionario f on f.id_persona = p.id_persona
                     join orga.tuo_funcionario uf on uf.id_funcionario = f.id_funcionario
                     join orga.tcargo c on c.id_cargo = uf.id_cargo
                     join param.tlugar l on l.id_lugar = c.id_lugar
            where uf.estado_reg = 'activo'
              and uf.tipo = 'oficial'
              and uf.fecha_asignacion <= now()
              and coalesce(uf.fecha_finalizacion, now()) >= now()
              and us.id_usuario = p_id_usuario;


            WHILE (SELECT v_fecha_aux::date <= v_parametros.fecha_fin::date)
                loop
                    IF (select extract(dow from v_fecha_aux::date) not in (v_sabado, v_domingo)) THEN
                        IF NOT EXISTS(select *
                                      from param.tferiado f
                                               JOIN param.tlugar l on l.id_lugar = f.id_lugar
                                      WHERE l.codigo in ('BO', v_lugar)
                                        AND (EXTRACT(MONTH from f.fecha))::integer =
                                            (EXTRACT(MONTH from v_fecha_aux::date))::integer
                                        AND (EXTRACT(DAY from f.fecha))::integer = (EXTRACT(DAY from v_fecha_aux))
                                        AND f.id_gestion = v_id_gestion_actual) THEN
                            v_cant_dias = v_cant_dias + 1;

                        END IF;


                    END IF;

                    v_incremento_fecha = (SELECT v_fecha_aux::date + CAST(v_valor_incremento AS INTERVAL));
                    v_fecha_aux = v_incremento_fecha;
                end loop;

            /*IF v_cant_dias = 0 OR v_parametros.dias = 0 THEN-- contador de dias
                RAISE EXCEPTION 'ERROR: CANTIDAD DE DIAS MAXIMO PERMITIDO MAYOR 0.';
            END IF;*/

            select dt.dias
            into v_dias_permetidos
            from asis.tdetalle_tipo_permiso dt
            where dt.id_detalle_tipo_permiso = v_parametros.id_tipo_licencia;

            if v_cant_dias > v_dias_permetidos then
                raise exception 'Solo esta permitido (%) dias.',v_dias_permetidos;
            end if;

            update asis.tpermiso
            set id_funcionario   = v_parametros.id_funcionario,
                fecha_solicitud  = v_parametros.fecha_solicitud,
                id_tipo_permiso  = v_parametros.id_tipo_permiso,
                motivo           = v_parametros.motivo,
                fecha_mod        = now(),
                id_usuario_mod   = p_id_usuario,
                id_usuario_ai    = v_parametros._id_usuario_ai,
                usuario_ai       = v_parametros._nombre_usuario_ai,
                hro_desde        = v_parametros.hro_desde,
                hro_hasta        = v_parametros.hro_hasta,
                id_responsable   = v_parametros.id_responsable,
                id_tipo_licencia = v_parametros.id_tipo_licencia,
                fecha_inicio     = v_parametros.fecha_inicio,
                fecha_fin        = v_parametros.fecha_fin,
                dias             = v_cant_dias
            where id_permiso = v_parametros.id_permiso;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'Permiso modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp, 'id_permiso', v_parametros.id_permiso::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

        /*********************************
         #TRANSACCION:  'ASIS_PMO_ELI'
         #DESCRIPCION:	Eliminacion de registros
         #AUTOR:		miguel.mamani
         #FECHA:		16-10-2019 13:14:05
        ***********************************/

    elsif (p_transaccion = 'ASIS_PMO_ELI') then

        begin
            --Sentencia de la eliminacion
            delete
            from asis.tpermiso
            where id_permiso = v_parametros.id_permiso;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'Permiso eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp, 'id_permiso', v_parametros.id_permiso::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

        /*********************************
         #TRANSACCION:  'ASIS_ANTPMO_IME'
         #DESCRIPCION:	Estado Anterior
         #AUTOR: MMV
         #FECHA: 07/10/2019
        ***********************************/
    elsif (p_transaccion = 'ASIS_ANTPMO_IME') then

        begin

            if pxp.f_existe_parametro(p_tabla, 'estado_destino') then
                v_operacion = v_parametros.estado_destino;
            end if;

            select me.*
            into
                v_record
            from asis.tpermiso me
                     inner join wf.tproceso_wf pwf on pwf.id_proceso_wf = me.id_proceso_wf
            where me.id_proceso_wf = v_parametros.id_proceso_wf;

            v_id_proceso_wf = v_record.id_proceso_wf;

            SELECT ps_id_tipo_estado,
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
            v_titulo = 'Visto Bueno';

            -- registra nuevo estado

            v_id_estado_actual = wf.f_registra_estado_wf(v_id_tipo_estado, --  id_tipo_estado al que retrocede
                                                         v_id_funcionario, --  funcionario del estado anterior
                                                         v_parametros.id_estado_wf, --  estado actual ...
                                                         v_id_proceso_wf, --  id del proceso actual
                                                         p_id_usuario, -- usuario que registra
                                                         v_parametros._id_usuario_ai,
                                                         v_parametros._nombre_usuario_ai,
                                                         v_id_depto, --depto del estado anterior
                                                         '[RETROCESO] ' || v_parametros.obs,
                                                         v_acceso_directo,
                                                         v_clase,
                                                         v_parametros_ad,
                                                         v_tipo_noti,
                                                         v_titulo);


            update asis.tpermiso
            set id_estado_wf   = v_id_estado_actual,
                estado         = v_codigo_estado,
                id_usuario_mod = p_id_usuario,
                id_usuario_ai  = v_parametros._id_usuario_ai,
                usuario_ai     = v_parametros._nombre_usuario_ai,
                fecha_mod      = now()
            where id_proceso_wf = v_parametros.id_proceso_wf;


            -- si hay mas de un estado disponible  preguntamos al usuario
            v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'Se realizo el cambio de estado)');
            v_resp = pxp.f_agrega_clave(v_resp, 'operacion', 'cambio_exitoso');

            --Devuelve la respuesta
            return v_resp;
        end;
        /*********************************
         #TRANSACCION:  'ASIS_RAF_IME'
         #DESCRIPCION:  optener los rango del funcionario
         #AUTOR: MMV
         #FECHA: 23/03/2020
        ***********************************/
    elsif (p_transaccion = 'ASIS_RAF_IME') then

        begin


            select distinct on (uof.id_funcionario) uof.id_funcionario, ger.id_uo
            into v_registro_funcionario
            from orga.tuo_funcionario uof
                     inner join orga.tuo ger on ger.id_uo = orga.f_get_uo_gerencia(uof.id_uo, NULL::integer, NULL::date)
            where uof.id_funcionario = v_parametros.id_funcionario
              and uof.fecha_asignacion <= v_parametros.fecha_solicitud
              and (uof.fecha_finalizacion is null or uof.fecha_finalizacion >= v_parametros.fecha_solicitud)
            order by uof.id_funcionario, uof.fecha_asignacion desc;

            -- raise exception '%',v_parametros.id_funcionario;

            if v_registro_funcionario.id_uo is null then
                raise exception 'No tiene asigando una uo';
            end if;

            v_consulta = 'select rh.hora_entrada,
                              rh.hora_salida
                      from asis.trango_horario rh
                      inner join asis.tasignar_rango ar on ar.id_rango_horario = rh.id_rango_horario
                      where ar.id_uo = ' || v_registro_funcionario.id_uo || 'and rh.' ||
                         asis.f_obtener_dia_literal(v_parametros.fecha_solicitud) || ' = ''si''
                       and  ''' || v_parametros.fecha_solicitud || ''' >=ar.desde and ar.hasta is null
                       and rh.jornada = ''' || v_parametros.jornada || '''
                      order by rh.hora_entrada, ar.hasta asc';


            v_inicio = null;
            v_fin = null;


            execute (v_consulta) into v_inicio, v_fin;

            if (v_inicio is null and v_fin is null) then

                raise exception 'Esta en horario continuo';

            end if;

            v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'Exito');
            v_resp = pxp.f_agrega_clave(v_resp, 'inicio', v_inicio);
            v_resp = pxp.f_agrega_clave(v_resp, 'fin', v_fin);

            return v_resp;

        end;

        /*********************************
         #TRANSACCION:  'ASIS_RAN_IME'
         #DESCRIPCION:  optener los rango del funcionario
         #AUTOR: MMV
         #FECHA: 13/10/2020
        ***********************************/
    elsif (p_transaccion = 'ASIS_RAN_IME') then

        begin

            if (v_parametros.desde::time > v_parametros.hasta::time) then
                raise exception 'Desde % es mayor que %',v_parametros.desde,v_parametros.hasta;
            end if;

            if (v_parametros.contro = 'si') then

                v_almuerzo = false;
                v_desde_alm = now()::date || ' ' || '12:30:00';
                v_hasta_alm = now()::date || ' ' || '14:30:00';


                if (v_parametros.hasta::time >= '12:30:00'::time and v_parametros.hasta::time <= '14:30:00'::time) then
                    v_almuerzo = true;
                end if;

                v_desde_hrs = now()::date || ' ' || v_parametros.desde;

                v_hasta_hrs = now()::date || ' ' || v_parametros.hasta;

                if (v_almuerzo) then

                    v_resultado =
                            COALESCE(COALESCE(asis.f_date_diff('minute', v_desde_hrs, v_hasta_hrs), 0) / 60::numeric,
                                     0);


                else
                    v_resultado =
                            COALESCE(COALESCE(asis.f_date_diff('minute', v_desde_hrs, v_hasta_hrs), 0) / 60::numeric,
                                     0);

                end if;

            else

                v_desde_hrs = now()::date || ' ' || v_parametros.desde;

                v_hasta_hrs = now()::date || ' ' || v_parametros.hasta;

                v_resultado =
                        COALESCE(COALESCE(asis.f_date_diff('minute', v_desde_hrs, v_hasta_hrs), 0) / 60::numeric, 0);

            end if;


            v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'Exito');
            v_resp = pxp.f_agrega_clave(v_resp, 'desde_hrs', v_desde_hrs::varchar);
            v_resp = pxp.f_agrega_clave(v_resp, 'hasta_hrs', v_hasta_hrs::varchar);
            v_resp = pxp.f_agrega_clave(v_resp, 'resultado',
                                        to_char(to_timestamp((v_resultado) * 60), 'MI:SS') ::varchar);


            return v_resp;

        end;

        /****************************************************
        #TRANSACCION:     'ASIS_VBO_IME'
        #DESCRIPCION:     Cambiar de estado
        #AUTOR:           MMV
        #FECHA:			  31-01-2020 13:53:10
        ***************************************************/

    elsif (p_transaccion = 'ASIS_VBO_IME') then

        begin

            -- Validar estado
            select pw.id_proceso_wf,
                   ew.id_estado_wf,
                   te.codigo,
                   pw.fecha_ini,
                   te.id_tipo_estado,
                   te.pedir_obs,
                   pw.nro_tramite
            into
                v_registro_estado
            from wf.tproceso_wf pw
                     inner join wf.testado_wf ew on ew.id_proceso_wf = pw.id_proceso_wf and ew.estado_reg = 'activo'
                     inner join wf.ttipo_estado te on ew.id_tipo_estado = te.id_tipo_estado
            where pw.id_proceso_wf = v_parametros.id_proceso_wf;


            select pe.*
            into
                v_permiso
            from asis.tpermiso pe
            where pe.id_proceso_wf = v_parametros.id_proceso_wf;

            select ps_id_tipo_estado,
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
            from wf.f_obtener_estado_wf(
                    v_registro_estado.id_proceso_wf,
                    null,
                    v_registro_estado.id_tipo_estado,
                    'siguiente',
                    p_id_usuario);


            v_acceso_directo = '../../../sis_asistencia/vista/permiso/PermisoVoBo.php';
            v_clase = 'PermisoVoBo';
            v_parametros_ad = '{filtro_directo:{campo:"pmo.id_proceso_wf",valor:"' ||
                              v_registro_estado.id_proceso_wf::varchar || '"}}';
            v_tipo_noti = 'notificacion';
            v_titulo = 'Visto Bueno';


            if (array_length(va_codigo_estado, 1) >= 2) then

                select tt.id_tipo_estado,
                       tt.codigo
                into
                    v_estado_record
                from wf.ttipo_estado tt
                where tt.id_tipo_estado in (select unnest(ARRAY [va_id_tipo_estado]))
                  and tt.codigo = v_parametros.evento;

                v_id_estado_maestro = v_estado_record.id_tipo_estado;
                v_estado_maestro = v_estado_record.codigo;

            else

                v_id_estado_maestro = va_id_tipo_estado[1]::integer;
                v_estado_maestro = va_codigo_estado[1]::varchar;

            end if;


            v_id_estado_actual = wf.f_registra_estado_wf(v_id_estado_maestro,
                                                         v_permiso.id_responsable,--v_parametros.id_funcionario_wf,
                                                         v_registro_estado.id_estado_wf,
                                                         v_registro_estado.id_proceso_wf,
                                                         p_id_usuario,
                                                         v_parametros._id_usuario_ai,
                                                         v_parametros._nombre_usuario_ai,
                                                         null,--v_id_depto,                       --depto del estado anterior
                                                         v_permiso.motivo, --obt
                                                         v_acceso_directo,
                                                         v_clase,
                                                         v_parametros_ad,
                                                         v_tipo_noti,
                                                         v_titulo);


            select pe.tipo_permiso,
                   pe.fecha_solicitud,
                   pe.funcionario_solicitante,
                   pe.hro_desde,
                   pe.hro_hasta,
                   pe.motivo
            into v_vista_permiso
            from asis.vpermiso pe
            where pe.id_proceso_wf = v_parametros.id_proceso_wf;

            if (v_estado_maestro = 'vobo') then

                select tp.documento,
                       tp.reposcion,
                       tp.rango,
                       tp.tiempo
                into
                    v_record_tipo
                from asis.ttipo_permiso tp
                where tp.id_tipo_permiso = v_permiso.id_tipo_permiso;

                if (v_record_tipo.reposcion = 'si') then

                    insert into asis.treposicion(id_usuario_reg,
                                                 id_usuario_mod,
                                                 fecha_reg,
                                                 fecha_mod,
                                                 estado_reg,
                                                 id_usuario_ai,
                                                 usuario_ai,
                                                 obs_dba,
                                                 id_permiso,
                                                 fecha_reposicion,
                                                 id_funcionario,
                                                 evento,
                                                 tiempo,
                                                 id_transacion_zkb)
                    values (p_id_usuario,
                            null,
                            now(),
                            null,
                            'activo',
                            v_parametros._id_usuario_ai,
                            v_parametros._nombre_usuario_ai,
                            '',
                            v_permiso.id_permiso,
                            v_permiso.fecha_reposicion,
                            v_permiso.id_funcionario,
                            'pendiente',
                            v_permiso.hro_total_reposicion,
                            null);
                end if;


                if (v_permiso.id_funcionario_sol is not null) then

                    v_descripcion_correo = '<h3><b>SOLICITUD DE PERMISO</b></h3>
                                          <p style="font-size: 15px;"><b>Tipo permiso:</b> ' ||
                                           v_vista_permiso.tipo_permiso || '</p>
                                          <p style="font-size: 15px;"><b>Fecha solicitud:</b> ' ||
                                           v_vista_permiso.fecha_solicitud || '</p>
                                          <p style="font-size: 15px;"><b>Solicitud para:</b> ' ||
                                           v_vista_permiso.funcionario_solicitante || '</p>
                                          <p style="font-size: 15px;"><b>Desde:</b> ' || v_vista_permiso.hro_desde ||
                                           ' <b>Hasta:</b> ' || v_vista_permiso.hro_hasta || '</p>
                                          <p style="font-size: 15px;"><b>Justificacion:</b> ' ||
                                           v_vista_permiso.motivo || '</p>';

                    v_id_alarma = param.f_inserta_alarma(
                            v_permiso.id_funcionario,
                            v_descripcion_correo,--par_descripcion
                            '',--acceso directo
                            now()::date,--par_fecha: Indica la fecha de vencimiento de la alarma
                            'notificacion', --notificacion
                            'Solicitud Permiso', --asunto
                            p_id_usuario,
                            '', --clase
                            'Solicitud Permiso',--titulo
                            '',--par_parametros varchar,   parametros a mandar a la interface de acceso directo
                            v_permiso.id_usuario_reg, --usuario a quien va dirigida la alarma
                            '',--titulo correo
                            '', --correo funcionario
                            null,--#9
                            v_permiso.id_proceso_wf,
                            v_permiso.id_estado_wf--#9
                        );
                end if;

            end if;

            if (v_estado_maestro = 'aprobado') then

                v_descripcion_correo = '<h3><b>SOLICITUD DE PERMISO</b></h3>
                                        <p style="font-size: 15px;"><b>Tipo permiso:</b> ' ||
                                       v_vista_permiso.tipo_permiso || '</p>
                                        <p style="font-size: 15px;"><b>Fecha solicitud:</b> ' ||
                                       v_vista_permiso.fecha_solicitud || '</p>
                                        <p style="font-size: 15px;"><b>Solicitud para:</b> ' ||
                                       v_vista_permiso.funcionario_solicitante || '</p>
                                        <p style="font-size: 15px;"><b>Desde:</b> ' || v_vista_permiso.hro_desde ||
                                       ' <b>Hasta:</b> ' || v_vista_permiso.hro_hasta || '</p>
                                        <p style="font-size: 15px;"><b>Justificacion:</b> ' || v_vista_permiso.motivo ||
                                       '</p>';

                v_id_alarma = param.f_inserta_alarma(
                        v_permiso.id_funcionario,
                        v_descripcion_correo,--par_descripcion
                        '',--acceso directo
                        now()::date,--par_fecha: Indica la fecha de vencimiento de la alarma
                        'notificacion', --notificacion
                        'Solicitud Permiso Aprobado', --asunto
                        p_id_usuario,
                        '', --clase
                        '',--titulo
                        '',--par_parametros varchar,   parametros a mandar a la interface de acceso directo
                        v_permiso.id_usuario_reg, --usuario a quien va dirigida la alarma
                        '',--titulo correo
                        '', --correo funcionario
                        null,--#9
                        v_permiso.id_proceso_wf,
                        v_permiso.id_estado_wf--#9
                    );
            end if;

            if (v_estado_maestro = 'rechazado') then

                v_descripcion_correo = '<h3><b>SOLICITUD DE PERMISO</b></h3>
                                        <p style="font-size: 15px;"><b>Tipo permiso:</b> ' ||
                                       v_vista_permiso.tipo_permiso || '</p>
                                        <p style="font-size: 15px;"><b>Fecha solicitud:</b> ' ||
                                       v_vista_permiso.fecha_solicitud || '</p>
                                        <p style="font-size: 15px;"><b>Solicitud para:</b> ' ||
                                       v_vista_permiso.funcionario_solicitante || '</p>
                                        <p style="font-size: 15px;"><b>Desde:</b> ' || v_vista_permiso.hro_desde ||
                                       ' <b>Hasta:</b> ' || v_vista_permiso.hro_hasta || '</p>
                                        <p style="font-size: 15px;"><b>Justificacion:</b> ' || v_vista_permiso.motivo || '</p>
                                        <p style="font-size: 15px;"><b>Obs.:</b> ' || v_parametros.obs || '</p>';

                v_id_alarma = param.f_inserta_alarma(
                        v_permiso.id_funcionario,
                        v_descripcion_correo,--par_descripcion
                        '',--acceso directo
                        now()::date,--par_fecha: Indica la fecha de vencimiento de la alarma
                        'notificacion', --notificacion
                        'Solicitud Permiso Rechazado', --asunto
                        p_id_usuario,
                        '', --clase
                        '',--titulo
                        '',--par_parametros varchar,   parametros a mandar a la interface de acceso directo
                        v_permiso.id_usuario_reg, --usuario a quien va dirigida la alarma
                        '',--titulo correo
                        '', --correo funcionario
                        null,--#9
                        v_permiso.id_proceso_wf,
                        v_permiso.id_estado_wf--#9
                    );
            end if;

            update asis.tpermiso
            set id_estado_wf   = v_id_estado_actual,
                estado         = v_estado_maestro,
                id_usuario_mod = p_id_usuario,
                id_usuario_ai  = v_parametros._id_usuario_ai,
                usuario_ai     = v_parametros._nombre_usuario_ai,
                fecha_mod      = now(),
                observaciones  = v_parametros.obs
            where id_proceso_wf = v_parametros.id_proceso_wf;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'Exito');
            v_resp = pxp.f_agrega_clave(v_resp, 'id_proceso_wf', v_parametros.id_proceso_wf::varchar);

            --Devuelve la respuesta
            return v_resp;


        end;

        /*********************************
           #TRANSACCION:  'ASIS_ROL_INS'
           #DESCRIPCION:	Eliminacion de registros
           #AUTOR:		miguel.mamani
           #FECHA:		16-10-2019 13:14:05
          ***********************************/

    elsif (p_transaccion = 'ASIS_ROL_INS') then

        begin


            -- if p_administrador != 1  then

            if exists(select 1
                      from segu.vusuario u
                               inner join segu.tusuario_rol ur on ur.id_usuario = u.id_usuario
                               inner join segu.trol r on r.id_rol = ur.id_rol
                      where u.id_usuario = p_id_usuario
                        and r.rol like '%ASIS - Rrhh') then

                v_rol = 1;

            else

                v_rol = 0;

            end if;

            --v_rol = 0;
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'Rol Asignado)');
            v_resp = pxp.f_agrega_clave(v_resp, 'rol', v_rol::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

    else

        raise exception 'Transaccion inexistente: %',p_transaccion;

    end if;

EXCEPTION

    WHEN OTHERS THEN
        v_resp = '';
        v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', SQLERRM);
        v_resp = pxp.f_agrega_clave(v_resp, 'codigo_error', SQLSTATE);
        v_resp = pxp.f_agrega_clave(v_resp, 'procedimientos', v_nombre_funcion);
        raise exception '%',v_resp;

END;
$$;


