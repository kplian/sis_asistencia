CREATE OR REPLACE FUNCTION asis.ft_tele_trabajo_ime (
    p_administrador integer,
    p_id_usuario integer,
    p_tabla varchar,
    p_transaccion varchar
)
    RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:        Sistema de Asistencia
 FUNCION:         asis.ft_tele_trabajo_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.ttele_trabajo'
 AUTOR:          (admin.miguel)
 FECHA:            01-02-2021 14:53:44
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE                FECHA                AUTOR                DESCRIPCION
 #0                01-02-2021 14:53:44    admin.miguel             Creacion
 #
 ***************************************************************************/

DECLARE

    v_parametros        RECORD;
    v_resp              VARCHAR;
    v_nombre_funcion    TEXT;
    v_id_tele_trabajo   INTEGER;
    v_id_gestion        integer;
    v_codigo_proceso    varchar;
    v_id_macro_proceso  integer;
    v_nro_tramite       varchar;
    v_id_proceso_wf     integer;
    v_id_estado_wf      integer;
    v_codigo_estado     varchar;
    v_registro_estado   record;
    v_recorrer          record;
    va_id_tipo_estado   integer[];
    va_codigo_estado    varchar[];
    va_disparador       varchar[];
    va_regla            varchar[];
    va_prioridad        integer[];
    v_acceso_directo    varchar;
    v_clase             varchar;
    v_parametros_ad     varchar;
    v_tipo_noti         varchar;
    v_titulo            varchar;
    v_estado_maestro    varchar;
    v_id_estado_maestro integer;
    v_estado_record     record;
    v_id_estado_actual  integer;
    v_record_det        record;
    v_dia               varchar;
    v_condicion         boolean;
    v_lugar             varchar;
    v_fecha_aux         date;
    v_id_gestion_actual integer;
BEGIN

    v_nombre_funcion = 'asis.ft_tele_trabajo_ime';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
     #TRANSACCION:  'ASIS_TLT_INS'
     #DESCRIPCION:    Insercion de registros
     #AUTOR:        admin.miguel
     #FECHA:        01-02-2021 14:53:44
    ***********************************/

    IF (p_transaccion = 'ASIS_TLT_INS') THEN

        BEGIN


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
            where pm.codigo = 'TTO'
              and tp.estado_reg = 'activo'
              and tp.inicio = 'si';


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
                    'Teletrabajo',
                    v_codigo_proceso);

            --Sentencia de la insercion
            INSERT INTO asis.ttele_trabajo(estado_reg,
                                           id_funcionario,
                                           id_responsable,
                                           fecha_inicio,
                                           fecha_fin,
                                           justificacion,
                                           id_usuario_reg,
                                           fecha_reg,
                                           id_usuario_ai,
                                           usuario_ai,
                                           id_usuario_mod,
                                           fecha_mod,
                                           estado,
                                           nro_tramite,
                                           id_proceso_wf,
                                           id_estado_wf,
                                           tipo_teletrabajo,
                                           motivo,
                                           tipo_temporal,
                                           lunes,
                                           martes,
                                           miercoles,
                                           jueves,
                                           viernes)
            VALUES ('activo',
                    v_parametros.id_funcionario,
                    v_parametros.id_responsable,
                    v_parametros.fecha_inicio,
                    v_parametros.fecha_fin,
                    v_parametros.justificacion,
                    p_id_usuario,
                    now(),
                    v_parametros._id_usuario_ai,
                    v_parametros._nombre_usuario_ai,
                    null,
                    null,
                    v_codigo_estado,
                    v_nro_tramite,
                    v_id_proceso_wf,
                    v_id_estado_wf,
                    v_parametros.tipo_teletrabajo,
                    v_parametros.motivo,
                    v_parametros.tipo_temporal,
                    v_parametros.lunes,
                    v_parametros.martes,
                    v_parametros.miercoles,
                    v_parametros.jueves,
                    v_parametros.viernes)
                RETURNING id_tele_trabajo into v_id_tele_trabajo;


            v_fecha_aux = v_parametros.fecha_inicio;

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


            for v_record_det in (select dia::date as dia
                                 from generate_series(v_parametros.fecha_inicio, v_parametros.fecha_fin,
                                                      '1 day'::interval) dia)
                loop
                    if not exists(select *
                                  from param.tferiado f
                                           join param.tlugar l on l.id_lugar = f.id_lugar
                                  where l.codigo in ('BO', v_lugar)
                                    and (extract(MONTH from f.fecha))::integer = (extract(MONTH from v_fecha_aux::date))::integer
                                    and (extract(DAY from f.fecha))::integer = (extract(DAY from v_fecha_aux))
                                    and f.id_gestion = v_id_gestion_actual) then

                        if (extract(dow from v_record_det.dia::date) not in (6, 0)) then
                            v_dia = case extract(dow from v_record_det.dia::date)
                                        when 1 then 'lunes'
                                        when 2 then 'martes'
                                        when 3 then 'miercoles'
                                        when 4 then 'jueves'
                                        when 5 then 'viernes'
                                end;

                            EXECUTE ('select 1
                                from asis.ttele_trabajo tl
                                where tl.id_tele_trabajo = ' || v_id_tele_trabajo || '
                                and tl.' || v_dia || ' = true') into v_condicion;


                            if v_condicion then

                                insert into asis.ttele_trabajo_det
                                (id_usuario_reg,
                                 id_usuario_mod,
                                 fecha_reg,
                                 fecha_mod,
                                 estado_reg,
                                 id_usuario_ai,
                                 usuario_ai,
                                 id_tele_trabajo,
                                 fecha)
                                VALUES (p_id_usuario,
                                        null,
                                        now(),
                                        null,
                                        'activo',
                                        v_parametros._id_usuario_ai,
                                        v_parametros._nombre_usuario_ai,
                                        v_id_tele_trabajo,
                                        v_record_det.dia::date);

                            end if;
                        end if;
                    end if;
                end loop;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp, 'mensaje',
                                        'Tele Trabajo almacenado(a) con exito (id_tele_trabajo' || v_id_tele_trabajo ||
                                        ')');
            v_resp = pxp.f_agrega_clave(v_resp, 'id_tele_trabajo', v_id_tele_trabajo::varchar);

            --Devuelve la respuesta
            RETURN v_resp;

        END;

        /*********************************
         #TRANSACCION:  'ASIS_TLT_MOD'
         #DESCRIPCION:    Modificacion de registros
         #AUTOR:        admin.miguel
         #FECHA:        01-02-2021 14:53:44
        ***********************************/

    ELSIF (p_transaccion = 'ASIS_TLT_MOD') THEN

        BEGIN
            --Sentencia de la modificacion
            UPDATE asis.ttele_trabajo
            SET id_funcionario   = v_parametros.id_funcionario,
                id_responsable   = v_parametros.id_responsable,
                fecha_inicio     = v_parametros.fecha_inicio,
                fecha_fin        = v_parametros.fecha_fin,
                justificacion    = v_parametros.justificacion,
                id_usuario_mod   = p_id_usuario,
                fecha_mod        = now(),
                id_usuario_ai    = v_parametros._id_usuario_ai,
                usuario_ai       = v_parametros._nombre_usuario_ai,
                tipo_teletrabajo = v_parametros.tipo_teletrabajo,
                motivo           = v_parametros.motivo,
                tipo_temporal    = v_parametros.tipo_temporal,
                lunes            = v_parametros.lunes,
                martes           = v_parametros.martes,
                miercoles        = v_parametros.miercoles,
                jueves           = v_parametros.jueves,
                viernes          = v_parametros.viernes
            WHERE id_tele_trabajo = v_parametros.id_tele_trabajo;

            v_fecha_aux = v_parametros.fecha_inicio;

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

            if exists(select 1
                      from asis.ttele_trabajo_det d
                      where d.id_tele_trabajo = v_parametros.id_tele_trabajo) then

                delete
                from asis.ttele_trabajo_det d
                where d.id_tele_trabajo = v_parametros.id_tele_trabajo;

                for v_record_det in (select dia::date as dia
                                     from generate_series(v_parametros.fecha_inicio, v_parametros.fecha_fin,
                                                          '1 day'::interval) dia)
                    loop
                        if not exists(select *
                                      from param.tferiado f
                                               join param.tlugar l on l.id_lugar = f.id_lugar
                                      where l.codigo in ('BO', v_lugar)
                                        and (extract(MONTH from f.fecha))::integer =
                                            (extract(MONTH from v_record_det.dia::date))::integer
                                        and (extract(DAY from f.fecha))::integer = (extract(DAY from v_record_det.dia::date))
                                        and f.id_gestion = v_id_gestion_actual) then

                            if (extract(dow from v_record_det.dia::date) not in (6, 0)) then

                                v_dia = case extract(dow from v_record_det.dia::date)
                                            when 1 then 'lunes'
                                            when 2 then 'martes'
                                            when 3 then 'miercoles'
                                            when 4 then 'jueves'
                                            when 5 then 'viernes'
                                    end;
                                EXECUTE ('select 1
                                from asis.ttele_trabajo tl
                                where tl.id_tele_trabajo = ' || v_parametros.id_tele_trabajo || '
                                and tl.' || v_dia || ' = true') into v_condicion;

                                if v_condicion then
                                    insert into asis.ttele_trabajo_det
                                    (id_usuario_reg,
                                     id_usuario_mod,
                                     fecha_reg,
                                     fecha_mod,
                                     estado_reg,
                                     id_usuario_ai,
                                     usuario_ai,
                                     id_tele_trabajo,
                                     fecha)
                                    VALUES (p_id_usuario,
                                            null,
                                            now(),
                                            null,
                                            'activo',
                                            v_parametros._id_usuario_ai,
                                            v_parametros._nombre_usuario_ai,
                                            v_parametros.id_tele_trabajo,
                                            v_record_det.dia::date);

                                end if;
                            end if;
                        end if;
                    end loop;

            end if;
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'Tele Trabajo modificado(a)');
            v_resp = pxp.f_agrega_clave(v_resp, 'id_tele_trabajo', v_parametros.id_tele_trabajo::varchar);

            --Devuelve la respuesta
            RETURN v_resp;

        END;

        /*********************************
         #TRANSACCION:  'ASIS_TLT_ELI'
         #DESCRIPCION:    Eliminacion de registros
         #AUTOR:        admin.miguel
         #FECHA:        01-02-2021 14:53:44
        ***********************************/

    ELSIF (p_transaccion = 'ASIS_TLT_ELI') THEN

        BEGIN
            --Sentencia de la eliminacion
            DELETE
            FROM asis.ttele_trabajo
            WHERE id_tele_trabajo = v_parametros.id_tele_trabajo;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'Tele Trabajo eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp, 'id_tele_trabajo', v_parametros.id_tele_trabajo::varchar);

            --Devuelve la respuesta
            RETURN v_resp;

        END;

        /*********************************
         #TRANSACCION:  'ASIS_TLT_SIG'
         #DESCRIPCION:    Cambiar de estado
         #AUTOR:        admin.miguel
         #FECHA:        01-02-2021 14:53:44
        ***********************************/
    ELSIF (p_transaccion = 'ASIS_TLT_SIG') THEN

        BEGIN
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


            select tt.id_tele_trabajo,
                   tt.id_responsable,
                   tt.justificacion
            into
                v_recorrer
            from asis.ttele_trabajo tt
            where tt.id_proceso_wf = v_parametros.id_proceso_wf;


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
            from wf.f_obtener_estado_wf(v_registro_estado.id_proceso_wf,
                                        null,
                                        v_registro_estado.id_tipo_estado,
                                        'siguiente',
                                        p_id_usuario);

            v_acceso_directo = '../../../sis_asistencia/vista/tele_trabajo/TeleTrabajoVoBo.php';
            v_clase = 'TeleTrabajoVoBo';
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
                                                         v_recorrer.id_responsable,--v_parametros.id_funcionario_wf,
                                                         v_registro_estado.id_estado_wf,
                                                         v_registro_estado.id_proceso_wf,
                                                         p_id_usuario,
                                                         v_parametros._id_usuario_ai,
                                                         v_parametros._nombre_usuario_ai,
                                                         null,--v_id_depto,                       --depto del estado anterior
                                                         v_recorrer.justificacion, --obt
                                                         v_acceso_directo,
                                                         v_clase,
                                                         v_parametros_ad,
                                                         v_tipo_noti,
                                                         v_titulo);
            update asis.ttele_trabajo
            set id_estado_wf   = v_id_estado_actual,
                estado         = v_estado_maestro,
                id_usuario_mod = p_id_usuario,
                id_usuario_ai  = v_parametros._id_usuario_ai,
                usuario_ai     = v_parametros._nombre_usuario_ai,
                fecha_mod      = now() --,
                --  justificacion = v_parametros.obs
            where id_proceso_wf = v_parametros.id_proceso_wf;

            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', 'Tele Trabajo eliminado(a)');
            v_resp = pxp.f_agrega_clave(v_resp, 'id_proceso_wf', v_parametros.id_proceso_wf::varchar);

            --Devuelve la respuesta
            RETURN v_resp;

        END;

    ELSE

        RAISE EXCEPTION 'Transaccion inexistente: %',p_transaccion;

    END IF;

EXCEPTION

    WHEN OTHERS THEN
        v_resp = '';
        v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', SQLERRM);
        v_resp = pxp.f_agrega_clave(v_resp, 'codigo_error', SQLSTATE);
        v_resp = pxp.f_agrega_clave(v_resp, 'procedimientos', v_nombre_funcion);
        raise exception '%',v_resp;

END;
$body$
    LANGUAGE 'plpgsql'
    VOLATILE
    CALLED ON NULL INPUT
SECURITY INVOKER
PARALLEL UNSAFE
COST 100;