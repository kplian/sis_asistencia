CREATE OR REPLACE FUNCTION asis.f_reportes_sel (
    p_administrador integer,
    p_id_usuario integer,
    p_tabla varchar,
    p_transaccion varchar
)
    RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:        Sistema de Asistencia
 FUNCION:         asis.f_reportes_sel
 DESCRIPCION:   Funcion para Reportes
 AUTOR:          (miguel.mamani)
 FECHA:            29-08-2019
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE                FECHA                AUTOR                DESCRIPCION
#15        etr            02-09-2019            MMV                   Reporte Transacción marcados ASIS_RET_SEL
#16        etr            04-09-2019            MMV                   Modificaciones reporte marcados ASIS_REF_SEL
#0        etr            15-11-2019            SAZP                   Modificaciones reporte marcados ASIS_RPT_MAR_GRAL

 ***************************************************************************/

DECLARE

    v_consulta          varchar;
    v_parametros        record;
    v_nombre_funcion    text;
    v_resp              varchar;
    v_record            record;
    v_funcionario       record;
    v_consulta_         varchar;
    v_filtro            varchar;
    v_fil               varchar;
    v_acumulado         record;
    v_asistencia        record;
    v_dia               varchar;
    v_consulta_rango    varchar;
    v_hora              time;
    v_hora_resultado    time;
    v_retraso           varchar;
    v_evento            varchar;
    v_record_fecha      record;
    v_id_gestion_actual integer;

BEGIN

    v_nombre_funcion = 'asis.f_reportes_sel';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************
       #TRANSACCION:  'ASIS_RETO_SEL' #15
       #DESCRIPCION:    Reporte de retrasos
       #AUTOR:        miguel.mamani
       #FECHA:        29/08/2019
      ***********************************/

    if (p_transaccion = 'ASIS_RETO_SEL') then
        begin
            --Sentencia de la consulta

            CREATE TEMPORARY TABLE tmp_ret
            (
                dia                varchar,
                fecha_marcado      date,
                hora               varchar,
                id_funcionario     integer,
                codigo_funcionario varchar,
                nombre_funcionario varchar,
                departamento       varchar,
                tipo_evento        varchar,
                modo_verificacion  varchar,
                nombre_dispositivo varchar,
                numero_tarjeta     varchar,
                nombre_area        varchar,
                codigo_evento      varchar,
                id_uo              integer
            ) ON COMMIT DROP;
            v_filtro = '';
            if v_parametros.hora_ini is not null and v_parametros.hora_fin is not null
            then
                v_filtro = 'and to_char(tr.event_time, ''HH24:MI'')::time BETWEEN ''' ||
                           to_char(v_parametros.hora_ini, 'HH24:MI')::time || '''and''' || to_char(
                                   v_parametros.hora_fin, 'HH24:MI')::time || ''' ';
            end if;
            if v_parametros.hora_ini is not null and v_parametros.hora_fin is null
            then
                v_filtro = 'and to_char(tr.event_time, ''HH24:MI'')::time >= ''' ||
                           to_char(v_parametros.hora_ini, 'HH24:MI')::time || ''' ';
            end if;
            if v_parametros.hora_ini is null and v_parametros.hora_fin is not null
            then
                v_filtro = 'and to_char(tr.event_time, ''HH24:MI'')::time <= ''' ||
                           to_char(v_parametros.hora_fin, 'HH24:MI')::time || ''' ';
            end if;

            v_consulta_ := 'select   tr.pin as codigo_funcionario,
                                    tr.event_time::date as fecha_marcado,
                                    to_char(tr.event_time, ''HH24:MI'') as hora,
                                    to_char(tr.event_time, ''DD'') as dia,
                                    tr.event_no as codigo_evento,  --filtro
                                    tr.event_name::varchar as tipo_evento,
                                    tr.verify_mode_name as modo_verificacion,
                                    tr.reader_name as nombre_dispositivo,
                                    tr.card_no as numero_tarjeta,
                                    tr.area_name as nombre_area
                            from asis.ttranscc_zka tr
                            where tr.event_time::date BETWEEN ''' ||
                           v_parametros.fecha_ini || ''' and ''' ||
                           v_parametros.fecha_fin ||
                           '''';
            v_consulta_ := v_consulta_ || v_filtro;
            v_consulta_ := v_consulta_ || 'order by fecha_marcado';
            for v_record in EXECUTE (v_consulta_)
                loop
                    select distinct on (ca.id_funcionario) ca.id_funcionario,
                                                           ca.desc_funcionario1,
                                                           ca.codigo,
                                                           ca.nombre_unidad,
                                                           ca.id_uo
                    into v_funcionario
                    from orga.vfuncionario_cargo ca
                             inner join orga.tcargo car on car.id_cargo = ca.id_cargo
                             inner join orga.ttipo_contrato tc on car.id_tipo_contrato =
                                                                  tc.id_tipo_contrato
                    where tc.codigo in ('PLA', 'EVE')
                      and ca.fecha_asignacion <= v_parametros.fecha_fin
                      and (ca.fecha_finalizacion is null or
                           ca.fecha_finalizacion >= v_parametros.fecha_ini)
                      and trim(both 'FUNODTPR'
                               from ca.codigo) = v_record.codigo_funcionario::varchar
                    order by ca.id_funcionario,
                             ca.fecha_asignacion desc;
                    insert into tmp_ret(dia, fecha_marcado, hora, id_funcionario,
                                        codigo_funcionario, nombre_funcionario, departamento, tipo_evento,
                                        modo_verificacion, nombre_dispositivo, numero_tarjeta, nombre_area,
                                        codigo_evento, id_uo)
                    values (v_record.dia, v_record.fecha_marcado, v_record.hora,
                            v_funcionario.id_funcionario, v_record.codigo_funcionario::varchar,
                            v_funcionario.desc_funcionario1, v_funcionario.nombre_unidad,
                            translate(v_record.tipo_evento::text, 'áéíóúÁÉÍÓÚäëïöüÄËÏÖÜ',
                                      'aeiouAEIOUaeiouAEIOU'), v_record.modo_verificacion::varchar,
                            v_record.nombre_dispositivo, v_record.numero_tarjeta,
                            v_record.nombre_area, v_record.codigo_evento, v_funcionario.id_uo);

                end loop;

            v_fil = '0 = 0';

            if v_parametros.id_funcionario is not null then
                v_fil = 't.id_funcionario = ' || v_parametros.id_funcionario;
            end if;
            if v_parametros.modo_verif != '' then
                v_fil := v_fil || ' and t.modo_verificacion = ''' || v_parametros.modo_verif
                    || ''' ';
            end if;
            if v_parametros.evento != '' then
                v_fil := v_fil || ' and t.codigo_evento = ''' || v_parametros.evento || ''' ';
            end if;
            v_consulta := 'select t.dia,
              					to_char(t.fecha_marcado,''DD/MM/YYYY'') as fecha_marcado,
                                t.hora,
                                t.id_funcionario,
                                t.codigo_funcionario,
                                initcap(t.nombre_funcionario) as nombre_funcionario,
                                initcap(t.departamento) as departamento,
                                t.tipo_evento,
                                t.modo_verificacion,
                                t.nombre_dispositivo,
                                t.numero_tarjeta,
                                t.nombre_area,
                                ger.nombre_unidad as gerencia
            					from tmp_ret t
                                inner join orga.tuo ger on ger.id_uo = orga.f_get_uo_gerencia(t.id_uo, NULL::integer, NULL::date)
                                where ';
            v_consulta := v_consulta || v_fil;
            v_consulta := v_consulta ||
                          'order by gerencia desc, hora, tipo_evento,nombre_funcionario';
            return v_consulta;

        end;

        /*********************************
         #TRANSACCION:  'ASIS_RE_SEL' # 16
         #DESCRIPCION:    Reporte de retrasos funcionarios
         #AUTOR:        miguel.mamani
         #FECHA:        29/08/2019
        ***********************************/
    elsif (p_transaccion = 'ASIS_RE_SEL') then
        begin
            CREATE TEMPORARY TABLE tmp_retr
            (
                dia                varchar,
                fecha_marcado      date,
                hora               varchar,
                id_funcionario     integer,
                codigo_funcionario varchar,
                nombre_funcionario varchar,
                nombre_cargo       varchar,
                tipo_evento        varchar,
                modo_verificacion  varchar,
                nombre_dispositivo varchar,
                codigo_evento      varchar,
                gerencia           varchar,
                departamento       varchar
            ) ON COMMIT DROP;
            for v_record in (
                with funcionario as (
                    select distinct on (ca.id_funcionario) ca.id_funcionario,
                                                           ca.desc_funcionario1,
                                                           trim(both 'FUNODTPR'
                                                                from ca.codigo) as codigo,
                                                           ca.nombre_cargo,
                                                           ger.nombre_unidad    as gerencia,
                                                           dep.nombre_unidad    as departamento
                    from orga.vfuncionario_cargo ca
                             inner join orga.tcargo car on car.id_cargo = ca.id_cargo
                             inner join orga.ttipo_contrato tc on car.id_tipo_contrato =
                                                                  tc.id_tipo_contrato
                             inner join orga.tuo ger on ger.id_uo = orga.f_get_uo_gerencia(
                            ca.id_uo, NULL::integer, NULL::date)
                             inner join orga.tuo dep ON dep.id_uo = orga.f_get_uo_departamento(
                            ca.id_uo, NULL::integer, NULL::date)
                    where tc.codigo in ('PLA', 'EVE')
                      and ca.fecha_asignacion <= v_parametros.fecha_fin
                      and (ca.fecha_finalizacion is null or
                           ca.fecha_finalizacion >= v_parametros.fecha_ini)
                    order by ca.id_funcionario,
                             ca.fecha_asignacion desc),
                     marcador as (
                         select tm.codigo_funcionario,
                                tm.fecha_marcado,
                                tm.dia,
                                min(tm.hora) as hora,
                                tm.codigo_evento,
                                tm.tipo_evento,
                                tm.modo_verificacion,
                                tm.nombre_dispositivo
                         from asis.vtransaccion_marcados tm
                         where tm.fecha_marcado BETWEEN v_parametros.fecha_ini and
                                   v_parametros.fecha_fin
                         group by tm.codigo_funcionario,
                                  tm.fecha_marcado,
                                  tm.dia,
                                  tm.codigo_evento,
                                  tm.tipo_evento,
                                  tm.modo_verificacion,
                                  tm.nombre_dispositivo
                         order by fecha_marcado asc,
                                  hora asc)
                select ma.dia,
                       ma.fecha_marcado,
                       ma.hora,
                       fu.id_funcionario,
                       fu.codigo,
                       fu.desc_funcionario1,
                       fu.nombre_cargo,
                       fu.gerencia,
                       fu.departamento,
                       ma.codigo_evento,
                       ma.tipo_evento,
                       ma.modo_verificacion,
                       ma.nombre_dispositivo
                from funcionario fu
                         inner join marcador ma on ma.codigo_funcionario = fu.codigo)
                loop
                    insert into tmp_retr(dia, fecha_marcado, hora, id_funcionario,
                                         codigo_funcionario, nombre_funcionario, tipo_evento,
                                         modo_verificacion, nombre_dispositivo, codigo_evento, gerencia,
                                         departamento, nombre_cargo)
                    values (v_record.dia, v_record.fecha_marcado, v_record.hora,
                            v_record.id_funcionario, v_record.codigo,
                            v_record.desc_funcionario1, v_record.tipo_evento,
                            v_record.modo_verificacion, v_record.nombre_dispositivo,
                            v_record.codigo_evento, v_record.gerencia, v_record.departamento,
                            v_record.nombre_cargo);

                end loop;

            v_filtro = '0 = 0 ';
            if v_parametros.hora_ini is not null and v_parametros.hora_fin is not null then
                v_filtro = 'tmp.hora BETWEEN ''' || to_char(v_parametros.hora_ini,
                                                            'HH24:MI')::time || '''and''' ||
                           to_char(v_parametros.hora_fin,
                                   'HH24:MI')::time || ''' ';
            end if;
            if v_parametros.hora_ini is not null and v_parametros.hora_fin is null
            then
                v_filtro = 'tmp.hora >= ''' || to_char(v_parametros.hora_ini,
                                                       'HH24:MI')::time || ''' ';
            end if;
            if v_parametros.hora_ini is null and v_parametros.hora_fin is not null
            then
                v_filtro = 'tmp.hora <= ''' || to_char(v_parametros.hora_fin,
                                                       'HH24:MI')::time || ''' ';
            end if;

            if v_parametros.id_funcionario is not null then
                v_filtro := v_filtro || ' and tmp.id_funcionario = ' ||
                            v_parametros.id_funcionario;
            end if;
            if v_parametros.modo_verif != '' then
                v_filtro := v_filtro || ' and tmp.modo_verificacion = ''' ||
                            v_parametros.modo_verif || ''' ';
            end if;
            if v_parametros.evento != '' then
                v_filtro := v_filtro || ' and tmp.codigo_evento = ''' ||
                            v_parametros.evento || ''' ';
            end if;

            v_consulta := 'select  tmp.dia,
                              to_char(tmp.fecha_marcado,''DD/MM/YYYY'') as fecha_marcado,
                              tmp.hora,
                              tmp.id_funcionario,
                              tmp.codigo_funcionario,
                              initcap(tmp.nombre_funcionario) as nombre_funcionario,
                              tmp.tipo_evento,
                              tmp.modo_verificacion,
                              tmp.nombre_dispositivo,
                              tmp.gerencia,
                              tmp.departamento,
                              initcap(tmp.nombre_cargo) as nombre_cargo
                              from tmp_retr tmp
                              where ';
            v_consulta := v_consulta || v_filtro;
            if (v_parametros.agrupar_por = 'etr') then
                v_consulta := v_consulta ||
                              'order by gerencia desc, departamento,fecha_marcado,hora,nombre_funcionario';
            elsif (v_parametros.agrupar_por = 'gerencias') then
                v_consulta := v_consulta ||
                              'order by gerencia desc, fecha_marcado,hora,nombre_funcionario';
            elsif (v_parametros.agrupar_por = 'departamentos') then
                v_consulta := v_consulta ||
                              'order by departamento desc, fecha_marcado,hora,nombre_funcionario';
            end if;
            return v_consulta;
        end;
        /*********************************
         #TRANSACCION:  'ASIS_RPT_MAR'
         #DESCRIPCION:    Reporte de marcado de funcionarios
         #AUTOR:        szambrana
         #FECHA:        02/10/2019
        ***********************************/
    elseif (p_transaccion = 'ASIS_RPT_MAR') then
        begin

            --Sentencia de la consulta
            v_consulta := 'SELECT
                            bio.id_transaccion_bio,
                            bio.fecha_marcado,
                            bio.hora,
                            bio.id_funcionario,
                            vfu.desc_funcionario1 AS nombre_funcionario,
                            --bio.id_periodo,
                            per.periodo AS mes,
                            bio.obs,
                            --bio.id_rango_horario,
                            bio.evento
                            --bio.tipo_verificacion,
                            --bio.area,
                            --bio.codigo_evento,
                            --bio.codigo_verificacion,
                            --bio.acceso
                            FROM asis.ttransaccion_bio bio
                            INNER JOIN orga.vfuncionario_cargo vfu ON bio.id_funcionario = vfu.id_funcionario
                            INNER JOIN param.tperiodo per ON bio.id_periodo = per.id_periodo
                            WHERE bio.id_funcionario = ' ||
                          v_parametros.id_funcionario ||
                          ' AND bio.fecha_marcado::date BETWEEN ''' ||
                          v_parametros.fecha_ini || ''' AND ''' ||
                          v_parametros.fecha_fin || ''' ';

            --Devuelve la respuesta
            return v_consulta;
        end;
        /*********************************
         #TRANSACCION:  'ASIS_RPT_MAR_GRAL'
         #DESCRIPCION:    Reporte de marcado de funcionarios por columnas
         #AUTOR:        szambrana
         #FECHA:        02/10/2019
        ***********************************/
    elseif (p_transaccion = 'ASIS_RPT_MAR_GRAL') then
        begin
            --Sentencia de la consulta
            v_consulta := 'SELECT *
            				FROM crosstab($$
                            SELECT
                                  bio.fecha ||'' | ''|| vfu.desc_funcionario1 ||'' | ''|| ger.nombre_unidad::varchar AS fecha_usr,
                                  bio.pivot,
                                  bio.hora
                            FROM asis.ttransacc_zkb_etl bio
                            INNER JOIN orga.vfuncionario_cargo vfu ON bio.id_funcionario = vfu.id_funcionario
                            INNER JOIN orga.tuo ger on ger.id_uo = orga.f_get_uo_departamento(vfu.id_uo, NULL::integer, NULL::date)
                            WHERE bio.id_funcionario = ' ||
                          v_parametros.id_funcionario ||
                          ' AND bio.rango = ''si''   AND bio.fecha::date BETWEEN '''
                              || v_parametros.fecha_ini || ''' AND ''' ||
                          v_parametros.fecha_fin || '''
                            GROUP BY bio.fecha,1,2,3 ORDER BY bio.fecha, bio.pivot
                            $$,$$
                            SELECT DISTINCT pivot
                            FROM asis.ttransacc_zkb_etl
                            WHERE pivot <> 0 ORDER BY pivot
                            $$)
                          	AS (detalles text, hra1 time, hra2 time, hra3 time, hra4 time)';

            raise notice '%',v_consulta;
            --Devuelve la respuesta
            return v_consulta;
        end;
        /*********************************
         #TRANSACCION:  'ASIS_SAL_SEL'
         #DESCRIPCION:    Reporte Reporte saldo
         #AUTOR:        MMV
         #FECHA:        11/09/2019
        ***********************************/
    elsif (p_transaccion = 'ASIS_SAL_SEL') then

        begin
            --Sentencia de la consulta


            CREATE TEMPORARY TABLE temporal_saldo
            (
                id_funcionario    integer,
                codigo            varchar,
                desc_funcionario1 varchar,
                fecha_contrato    date,
                gerencia          varchar,
                departamento      varchar,
                gestion           integer,
                fecha_caducado    date,
                fecha_acomulado   date,
                saldo             numeric
            ) ON COMMIT DROP;
            for v_record in (
                select funs.id_funcionario,
                       funs.codigo,
                       funs.desc_funcionario2,
                       funs.fecha_contrato,
                       funs.gerencia,
                       funs.departamento,
                       sum(coalesce(mm.dias, 0)) as saldo
                from (
                         select distinct on (uofun.id_funcionario) uofun.id_funcionario,
                                                                   trim(both 'FUNODTPR'
                                                                        from fun.codigo)::varchar  as codigo,
                                                                   fun.desc_funcionario2,
                                                                   ger.nombre_unidad               as gerencia,
                                                                   dep.nombre_unidad               as departamento,
                                                                   plani.f_get_fecha_primer_contrato_empleado(
                                                                           uofun.id_uo_funcionario,
                                                                           uofun.id_funcionario,
                                                                           uofun.fecha_asignacion) as fecha_contrato
                         from orga.tuo_funcionario uofun
                                  inner join orga.tcargo car on car.id_cargo =
                                                                uofun.id_cargo
                                  inner join orga.ttipo_contrato tc on
                                 car.id_tipo_contrato = tc.id_tipo_contrato
                                  inner join orga.vfuncionario fun on fun.id_funcionario =
                                                                      uofun.id_funcionario
                                  inner join orga.tuo ger ON ger.id_uo =
                                                             orga.f_get_uo_gerencia(uofun.id_uo, NULL::integer,
                                                                                    NULL::date)
                                  inner join orga.tuo dep ON dep.id_uo =
                                                             orga.f_get_uo_departamento(uofun.id_uo, NULL::integer,
                                                                                        NULL::date)
                         where tc.codigo in ('PLA', 'EVE')
                           and UOFUN.tipo = 'oficial'
                           and uofun.fecha_asignacion <= v_parametros.fecha_fin::date
                           and (uofun.fecha_finalizacion is null or
                                uofun.fecha_finalizacion >= v_parametros.fecha_fin::
                                    date)
                           AND uofun.estado_reg != 'inactivo'
                           and (case
                                    when v_parametros.id_funcionario is null then 0 = 0
                                    else uofun.id_funcionario =
                                         v_parametros.id_funcionario
                             end)
                           and (case
                                    when v_parametros.id_tipo_contrato is null then 0 = 0
                                    else tc.id_tipo_contrato =
                                         v_parametros.id_tipo_contrato
                             end)
                           and (case
                                    when v_parametros.id_uo is null then 0 = 0
                                    else (ger.id_uo = v_parametros.id_uo or
                                          dep.id_uo = v_parametros.id_uo)
                             end)
                         order by uofun.id_funcionario,
                                  uofun.fecha_asignacion desc
                     ) funs
                         left join asis.tmovimiento_vacacion mm on mm.id_funcionario =
                                                                   funs.id_funcionario and mm.estado_reg = 'activo' and
                                                                   mm.fecha_reg::date <= now()::date
                group by funs.id_funcionario,
                         funs.codigo,
                         funs.desc_funcionario2,
                         funs.fecha_contrato,
                         funs.gerencia,
                         funs.departamento
                order by gerencia,
                         departamento,
                         desc_funcionario2)
                loop
                    select mo.fecha_reg::date as fecha_reg,
                           mo.dias
                    into v_acumulado
                    from asis.tmovimiento_vacacion mo
                    where mo.tipo = 'ACUMULADA'
                      and mo.id_funcionario = v_record.id_funcionario
                      and mo.estado_reg = 'activo'
                      and mo.fecha_reg::date =
                          (
                              select max(m.fecha_reg::date)
                              from asis.tmovimiento_vacacion m
                              where m.tipo = 'ACUMULADA'
                                and m.dias != 0
                                and m.id_funcionario = v_record.id_funcionario
                          );

                    --    raise notice  '------------------saldo %  acumulado % ------------------------',v_record.saldo, v_acumulado.dias;


                    if (v_record.saldo > v_acumulado.dias) then

                        perform asis.f_calcular_saldo_gestion(v_acumulado.fecha_reg,
                                                              v_acumulado.dias,
                                                              v_record,
                                                              v_record.saldo);

                    else
                        insert into temporal_saldo(id_funcionario, codigo,
                                                   desc_funcionario1, fecha_contrato, gerencia, departamento,
                                                   fecha_caducado, gestion, fecha_acomulado, saldo)
                        values (v_record.id_funcionario, v_record.codigo,
                                v_record.desc_funcionario2, v_record.fecha_contrato,
                                v_record.gerencia, v_record.departamento,
                                v_acumulado.fecha_reg, extract(year
                                                               from COALESCE(v_acumulado.fecha_reg, now())),
                                v_acumulado.fecha_reg, v_record.saldo);

                    end if;

                end loop;

            v_consulta := 'select  trim(both ''FUNODTPR'' from  ts.codigo)::varchar as codigo,
                                    ts.desc_funcionario1,
                                    to_char(ts.fecha_contrato,''DD/MM/YYYY'') as fecha_contrato,
                                    ts.gerencia,
                                    ts.departamento,
                                    ts.gestion,
                                     to_char(ts.fecha_caducado,''DD/MM/YYYY'') as fecha_caducado,
                                    ts.saldo,
                                    ''a''::varchar as ordenar
                            from temporal_saldo ts
                            union all
                            select   trim(both ''FUNODTPR'' from  ts.codigo)::varchar as codigo,
                                    ts.desc_funcionario1,
                                    to_char(ts.fecha_contrato,''DD/MM/YYYY'') as fecha_contrato,
                                    ts.gerencia,
                                    ts.departamento,
                                    0::integer as gestion,
                                    null::text as fecha_caducado,
                                    sum(ts.saldo) as saldo,
                                    ''b''::varchar as ordenar
                            from temporal_saldo ts
                            group by ts.codigo,
                                     ts.desc_funcionario1,
                                     ts.fecha_contrato,
                            		ts.gerencia,
                                    ts.departamento
                            order by gerencia, departamento, desc_funcionario1 asc ,ordenar, gestion';
            --Devuelve la respuesta
            return v_consulta;

        end;

        /*********************************
        #TRANSACCION:  'ASIS_VENS_SEL'
        #DESCRIPCION:    No funciona
        #AUTOR:        MMV
        #FECHA:        11/09/2019
        ***********************************/
    elsif (p_transaccion = 'ASIS_VENS_SEL') then

        begin
            --Sentencia de la consulta
            v_consulta := '';
            --Devuelve la respuesta
            return v_consulta;

        end;

        /*********************************
        #TRANSACCION:  'ASIS_ANT_SEL'
        #DESCRIPCION:    Reporte Reporte Anticipo
        #AUTOR:        MMV
        #FECHA:        11/09/2019
        ***********************************/
    elsif (p_transaccion = 'ASIS_ANT_SEL') then

        begin
            --Sentencia de la consulta
            v_filtro = '';

            if (v_parametros.id_funcionario is not null) then
                v_filtro = 'and uofun.id_funcionario = ' ||
                           v_parametros.id_funcionario || '';
            end if;

            if (v_parametros.id_tipo_contrato is not null) then
                v_filtro = 'and  tc.id_tipo_contrato = ' ||
                           v_parametros.id_tipo_contrato;
            end if;

            if (v_parametros.id_uo is not null) then
                v_filtro = 'and (ger.id_uo = ' || v_parametros.id_uo ||
                           ' or dep.id_uo = ' || v_parametros.id_uo || ')';
            end if;

            v_consulta := 'select  fun.desc_funcionario2,
            					 fun.codigo ,
                                 fun.gerencia,
                                 fun.departamento,
                                 (
                                  case
                                      when (select sum(coalesce(mm.dias, 0))
                                      from asis.tmovimiento_vacacion mm
                                      where   mm.id_funcionario = fun.id_funcionario
                                      and mm.fecha_reg::date <= ''' ||
                          v_parametros.fecha_fin || '''::date
                                      and mm.estado_reg = ''activo'') < 0 then

                                      (select -1 * sum(coalesce(mm.dias, 0))
                                        from asis.tmovimiento_vacacion mm
                                        where   mm.id_funcionario = fun.id_funcionario
                                        and mm.fecha_reg::date <= ''' ||
                          v_parametros.fecha_fin || '''::date
                                        and mm.estado_reg = ''activo'')
                                      else
                                       0
                                      end
                                 ) as anticipo
                          from (
                           select distinct on (uofun.id_funcionario) uofun.id_funcionario,
                                          trim(both ''FUNODTPR'' from  fun.codigo)::varchar as codigo,
                                          fun.desc_funcionario2,
                                          ger.nombre_unidad as gerencia,
                                          dep.nombre_unidad as departamento
                                  from orga.tuo_funcionario uofun
                                  inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
                                  inner join orga.ttipo_contrato tc on car.id_tipo_contrato = tc.id_tipo_contrato
                                  inner join orga.vfuncionario fun on fun.id_funcionario = uofun.id_funcionario
                                  inner join orga.tuo ger ON ger.id_uo = orga.f_get_uo_gerencia(uofun.id_uo, NULL::integer, NULL::date)
                                  inner join orga.tuo dep ON dep.id_uo = orga.f_get_uo_departamento(uofun.id_uo, NULL::integer, NULL::date)
                                  left join orga.toficina ofi on car.id_oficina = ofi.id_oficina
                                  where tc.codigo in (''PLA'',''EVE'') and UOFUN.tipo = ''oficial'' and
                                  uofun.fecha_asignacion <=  ''' ||
                          v_parametros.fecha_fin || '''::date and
                                  (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >=  '''
                              || v_parametros.fecha_fin || '''::date) AND
                                  uofun.estado_reg != ''inactivo'' ' || v_filtro || '
                                  order by uofun.id_funcionario, uofun.fecha_asignacion desc) fun
                                  order by gerencia, departamento, desc_funcionario2 asc';

            --Devuelve la respuesta
            return v_consulta;

        end;

        /*********************************
         #TRANSACCION:  'ASIS_AHT_SEL'
         #DESCRIPCION:    Reporte Historico vacaciones
         #AUTOR:        MMV
         #FECHA:        15/09/2019
         ***********************************/
    elsif (p_transaccion = 'ASIS_AHT_SEL') then

        begin
            --Sentencia de la consulta

            v_consulta := 'select  fun.id_funcionario,
                              fun.desc_funcionario1,
                              fun.descripcion_cargo,
                              fun.codigo,
                              mv.tipo,
                              to_char(mv.fecha_reg::date,''DD/MM/YYYY'') as fecha,
                              to_char(mv.desde,''DD/MM/YYYY'') as desde,
                              to_char(mv.hasta,''DD/MM/YYYY'') as hasta,
                              coalesce((case
                                  		when mv.dias < 0 then
                                        -1 * mv.dias
                                        else
                                        mv.dias
                                        end),0) as dias,
                              coalesce(mv.dias_actual,0)  as saldo,
                              fun.nombre_unidad,
                              to_char(fun.fecha_contrato,''DD/MM/YYYY'') as fecha_contrato
                      from (
                      select distinct on (uofun.id_funcionario) uofun.id_funcionario,
                                          trim(both ''FUNODTPR'' from  fun.codigo)::varchar as codigo,
                                          fun.desc_funcionario1,
                                          car.nombre as descripcion_cargo,
                                          dep.nombre_unidad,
                                          plani.f_get_fecha_primer_contrato_empleado(uofun.id_uo_funcionario, uofun.id_funcionario, uofun.fecha_asignacion) as fecha_contrato
                          from orga.tuo_funcionario uofun
                          inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
                          inner join orga.ttipo_contrato tc on car.id_tipo_contrato = tc.id_tipo_contrato
                          inner join orga.vfuncionario fun on fun.id_funcionario = uofun.id_funcionario
                          inner join orga.tuo dep ON dep.id_uo = orga.f_get_uo_departamento(uofun.id_uo, NULL::integer, NULL::date)
                          where tc.codigo in (''PLA'',''EVE'') and UOFUN.tipo = ''oficial'' and
                          uofun.fecha_asignacion <=  now()::date and
                          (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >= now()::date) AND
                          uofun.estado_reg != ''inactivo'' and uofun.id_funcionario = '
                              || v_parametros.id_funcionario || '
                          order by uofun.id_funcionario, uofun.fecha_asignacion desc ) fun
                          left join asis.tmovimiento_vacacion mv on mv.id_funcionario = fun.id_funcionario and  mv.estado_reg = ''activo''
                          order by (case
                          			when mv.tipo in (''ACUMULADA'',''CADUCADA'') then
                                   	  mv.fecha_reg::date
                                      else
                                      mv.desde
                                      end )::date asc ';

            --Devuelve la respuesta
            return v_consulta;

        end;

        /*********************************
        #TRANSACCION:  'ASIS_VPR_SEL'
        #DESCRIPCION:    Reporte Personas en vacacion
        #AUTOR:        MMV
        #FECHA:        15/09/2019
        ***********************************/
    elsif (p_transaccion = 'ASIS_VPR_SEL') then

        begin
            --Sentencia de la consulta


            v_filtro = '';

            if (v_parametros.id_funcionario is not null) then

                v_filtro = 'and uofun.id_funcionario = ' ||
                           v_parametros.id_funcionario;

            end if;

            if (v_parametros.id_uo is not null) then

                v_filtro = ' and (ger.id_uo = ' || v_parametros.id_uo ||
                           'or dep.id_uo =' || v_parametros.id_uo || ')';

            end if;

            v_consulta := 'select   funs.gerencia,
                                  funs.departamento,
                                  funs.desc_funcionario2  as desc_funcionario,
                                  funs.codigo,
                                  (case
                                  		when mm.dias < 0 then
                                        -1 * mm.dias
                                        else
                                        mm.dias
                                        end) as dias,
                                  to_char(mm.desde,''DD/MM/YYYY'') as desde,
                                  to_char(mm.hasta,''DD/MM/YYYY'') as hasta,
                                  funs.tipo_contrato,
                                   ''a''::varchar as ordenar
                          from (
                          select distinct on (uofun.id_funcionario) uofun.id_funcionario,
                                trim(both ''FUNODTPR'' from  fun.codigo)::varchar as codigo,
                                fun.desc_funcionario2,
                                ger.nombre_unidad as gerencia,
                                dep.nombre_unidad as departamento,
                                plani.f_get_fecha_primer_contrato_empleado(uofun.id_uo_funcionario, uofun.id_funcionario, uofun.fecha_asignacion) as fecha_contrato,
                                tc.nombre as tipo_contrato
                          from orga.tuo_funcionario uofun
                          inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
                          inner join orga.ttipo_contrato tc on car.id_tipo_contrato = tc.id_tipo_contrato
                          inner join orga.vfuncionario fun on fun.id_funcionario = uofun.id_funcionario
                          inner join orga.tuo ger ON ger.id_uo = orga.f_get_uo_gerencia(uofun.id_uo, NULL::integer, NULL::date)
                          inner join orga.tuo dep ON dep.id_uo = orga.f_get_uo_departamento(uofun.id_uo, NULL::integer, NULL::date)
                          where tc.codigo in (''PLA'', ''EVE'') and UOFUN.tipo = ''oficial'' and
                          uofun.fecha_asignacion <= ''' || v_parametros.fecha_fin
                              || '''::date  and
                          (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >=  '''
                              || v_parametros.fecha_ini || ''' ::date) AND
                          uofun.estado_reg != ''inactivo'' ' || v_filtro || '
                          order by uofun.id_funcionario, uofun.fecha_asignacion desc)funs
                          inner join asis.tmovimiento_vacacion mm on mm.id_funcionario = funs.id_funcionario
						  where mm.tipo = ''TOMADA'' and mm.estado_reg = ''activo''

                          and mm.desde::date <=''' || v_parametros.fecha_fin ||
                          '''::date
                        and  mm.hasta::date >= ''' || v_parametros.fecha_ini || '''::date

                          union all
                          select  funs.gerencia,
                                  funs.departamento,
                                  funs.desc_funcionario2  as desc_funcionario,
                                  funs.codigo,
                                  sum(case
                                  		when mm.dias < 0 then
                                        -1 * mm.dias
                                        else
                                        mm.dias
                                        end) as dias,
                                  null as desde,
                                  null as hasta,
                                  ''Total'' as tipo_contrato,
                                  ''b''::varchar as ordenar

                          from (
                          select distinct on (uofun.id_funcionario) uofun.id_funcionario,
                                trim(both ''FUNODTPR'' from  fun.codigo)::varchar as codigo,
                                fun.desc_funcionario2,
                                ger.nombre_unidad as gerencia,
                                dep.nombre_unidad as departamento,
                                plani.f_get_fecha_primer_contrato_empleado(uofun.id_uo_funcionario, uofun.id_funcionario, uofun.fecha_asignacion) as fecha_contrato,
                                tc.nombre as tipo_contrato
                          from orga.tuo_funcionario uofun
                          inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
                          inner join orga.ttipo_contrato tc on car.id_tipo_contrato = tc.id_tipo_contrato
                          inner join orga.vfuncionario fun on fun.id_funcionario = uofun.id_funcionario
                          inner join orga.tuo ger ON ger.id_uo = orga.f_get_uo_gerencia(uofun.id_uo, NULL::integer, NULL::date)
                          inner join orga.tuo dep ON dep.id_uo = orga.f_get_uo_departamento(uofun.id_uo, NULL::integer, NULL::date)
                          where tc.codigo in (''PLA'', ''EVE'') and UOFUN.tipo = ''oficial'' and
                          uofun.fecha_asignacion <= ''' || v_parametros.fecha_fin
                              || '''::date  and
                          (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >=  '''
                              || v_parametros.fecha_ini || ''' ::date) AND
                          uofun.estado_reg != ''inactivo'' ' || v_filtro || '
                          order by uofun.id_funcionario, uofun.fecha_asignacion desc)funs
                          inner join asis.tmovimiento_vacacion mm on mm.id_funcionario = funs.id_funcionario
                          where mm.tipo = ''TOMADA'' and mm.estado_reg = ''activo''
                          and mm.desde::date <=''' || v_parametros.fecha_fin ||
                          '''::date
                        and  mm.hasta::date >= ''' || v_parametros.fecha_ini || '''::date
                           group by funs.gerencia,
                                  funs.departamento,
                                  funs.desc_funcionario2,
                                  funs.codigo
                         order by gerencia, departamento,desc_funcionario,ordenar,tipo_contrato';
            --Devuelve la respuesta

            return v_consulta;

        end;

        /*********************************
        #TRANSACCION:  'ASIS_VARU_SEL'
        #DESCRIPCION:    Reporte Resumen de vacaciones
        #AUTOR:        MMV
        #FECHA:        15/09/2019
        ***********************************/
    elsif (p_transaccion = 'ASIS_VARU_SEL') then

        begin
            --Sentencia de la consulta


            -- raise exception '%',v_parametros.id_tipo_contrato;  tc.id_tipo_contrato
            v_filtro = '';

            if (v_parametros.id_funcionario is not null) then

                v_filtro = 'and uofun.id_funcionario = ' ||
                           v_parametros.id_funcionario;

            end if;

            if (v_parametros.id_uo is not null) then

                v_filtro = ' and (ger.id_uo = ' || v_parametros.id_uo ||
                           'or dep.id_uo =' || v_parametros.id_uo || ')';

            end if;

            if (v_parametros.id_tipo_contrato is not null) then

                v_filtro = 'and  tc.id_tipo_contrato = ' ||
                           v_parametros.id_tipo_contrato;

            end if;

            v_consulta := 'select   ant.desc_funcionario2,
                                  ant.codigo,
                                  ant.gerencia,
                                  ant.departamento,
                            (case
                              when ant.saldo_acumulado  < 0 then
                               -1 * ant.saldo_acumulado
                               else
                                ant.saldo_acumulado
                              end) as saldo_acumulado,
                              (case
                              when ant.saldo_tomada  < 0 then
                               -1 * ant.saldo_tomada
                               else
                                ant.saldo_tomada
                              end) as saldo_tomada,
                           (case
                              when ant.saldo_caducado  < 0 then
                               -1 * ant.saldo_caducado
                               else
                                ant.saldo_caducado
                              end) as saldo_caducado,
                            (case
                              when ant.saldo_anticipo  < 0 then
                               -1 * ant.saldo_anticipo
                               else
                                ant.saldo_anticipo
                              end) as saldo_anticipo,
                           (case
                              when ant.saldo_pagado  < 0 then
                               -1 * ant.saldo_pagado
                               else
                                ant.saldo_pagado
                              end) as saldo_pagado,
                            ant.saldo
                  from (

                  with acumulado as (select mm.id_funcionario,
                                            sum(coalesce(mm.dias, 0))  as saldo_acumulado
                                     from asis.tmovimiento_vacacion mm
                                     where mm.tipo = ''ACUMULADA'' and
                                           mm.fecha_reg::date <=''' ||
                          v_parametros.fecha_fin || '''::date
                                           and mm.estado_reg =  ''activo''
                                     group by mm.id_funcionario),
                       tomada as (select  mm.id_funcionario,
                                           sum(coalesce(mm.dias, 0))as saldo_tomada
                                   from asis.tmovimiento_vacacion mm
                                   where mm.tipo = ''TOMADA'' and
                                          mm.fecha_reg::date <=''' ||
                          v_parametros.fecha_fin || '''::date
                                          and mm.estado_reg =  ''activo''
                                   group by mm.id_funcionario),
                        caducada as (select mm.id_funcionario,
                                            sum(coalesce(mm.dias, 0))  as saldo_caducado
                                    from asis.tmovimiento_vacacion mm
                                    where mm.tipo = ''CADUCADA'' and
                                             mm.fecha_reg::date <=''' ||
                          v_parametros.fecha_fin || '''::date
                                             and mm.estado_reg =  ''activo''
                                    group by mm.id_funcionario),
                       anticipo as (select mm.id_funcionario,
                                            sum(coalesce(mm.dias, 0)) as saldo_anticipo
                                    from asis.tmovimiento_vacacion mm
                                    where mm.tipo = ''ANTICIPO'' and
                                              mm.fecha_reg::date <=''' ||
                          v_parametros.fecha_fin || '''::date
                                              and mm.estado_reg =  ''activo''
                                    group by mm.id_funcionario),
                        pagado as (select mm.id_funcionario,
                                           sum(coalesce(mm.dias, 0)) as saldo_pagado
                                   from asis.tmovimiento_vacacion mm
                                   where mm.tipo = ''PAGADO'' and
                                           mm.fecha_reg::date <=''' ||
                          v_parametros.fecha_fin || '''::date
                                           and mm.estado_reg =  ''activo''
                                   group by mm.id_funcionario),
                         saldo as (select mm.id_funcionario,
                                           sum(coalesce(mm.dias, 0)) as saldo
                                   from asis.tmovimiento_vacacion mm
                                   where  mm.fecha_reg::date <=''' ||
                          v_parametros.fecha_fin || '''::date
                                   and mm.estado_reg =  ''activo''
                                   group by mm.id_funcionario)
                       select distinct on (uofun.id_funcionario) uofun.id_funcionario,
                                      trim(both ''FUNODTPR'' from  fun.codigo)::varchar as codigo,
                                    initcap(fun.desc_funcionario2) as desc_funcionario2,
                                      ger.nombre_unidad as gerencia,
                                      dep.nombre_unidad as departamento,
                                      coalesce( di.saldo_acumulado,0) as saldo_acumulado ,
                                      coalesce( tom.saldo_tomada,0) as saldo_tomada,
                                      coalesce( cad.saldo_caducado,0) as saldo_caducado,
                                      coalesce( ant.saldo_anticipo,0) as saldo_anticipo,
                                      coalesce( pag.saldo_pagado,0) as saldo_pagado ,
                                      coalesce(sal.saldo,0) as saldo
                              from orga.tuo_funcionario uofun
                              inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
                              inner join orga.ttipo_contrato tc on car.id_tipo_contrato = tc.id_tipo_contrato
                              inner join orga.vfuncionario fun on fun.id_funcionario = uofun.id_funcionario
                              inner join orga.tuo ger ON ger.id_uo = orga.f_get_uo_gerencia(uofun.id_uo, NULL::integer, NULL::date)
                              inner join orga.tuo dep ON dep.id_uo = orga.f_get_uo_departamento(uofun.id_uo, NULL::integer, NULL::date)
                              left join orga.toficina ofi on car.id_oficina = ofi.id_oficina
                              left join  acumulado di on di.id_funcionario = uofun.id_funcionario
                              left join  tomada tom on tom.id_funcionario = uofun.id_funcionario
                              left join  caducada cad on cad.id_funcionario = uofun.id_funcionario
                              left join  anticipo ant on ant.id_funcionario = uofun.id_funcionario
                              left join  pagado pag on pag.id_funcionario = uofun.id_funcionario
                              left join  saldo sal on sal.id_funcionario = uofun.id_funcionario
                              where tc.codigo in (''PLA'',''EVE'') and UOFUN.tipo = ''oficial'' and
                              uofun.fecha_asignacion <= ''' ||
                          v_parametros.fecha_fin || '''::date and
                              (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >= '''
                              || v_parametros.fecha_fin || '''::date) AND
                              uofun.estado_reg != ''inactivo'' ' || v_filtro || '
                              order by uofun.id_funcionario, uofun.fecha_asignacion desc   ) ant
                              order by desc_funcionario2 asc';
            --Devuelve la respuesta
            return v_consulta;

        end;
        /*********************************
        #TRANSACCION:  'ASIS_COAS_SEL'
        #DESCRIPCION:    Reporte control de asistencia biomentrico baja medica teletrabajo permiso, vacacion
        #AUTOR:        MMV
        #FECHA:        15/09/2019
        ***********************************/
    elsif (p_transaccion = 'ASIS_COAS_SEL') then
        begin
            --Sentencia de la consulta
            create temporary table tmp_biometrico
            (
                pin   varchar,
                fecha date,
                hora  time
            ) on commit drop;

            insert into tmp_biometrico
            (pin,
             fecha,
             hora)
            select p.pin,
                   p.fecha,
                   to_char(p.hora, 'HH24:MI:SS')::time as hora
            from asis.tpersona_transaccion p
            where p.dev_alias in
                  ('ACCESO_SOT1', 'barrera1', 'barrera2', 'barrera3', 'barrera4', 'ALM_ACC260')
              and to_char(p.fecha, 'DD/MM/YYYY')::date = v_parametros.fecha::date;

            insert into tmp_biometrico
            (pin,
             fecha,
             hora)
            select h.pin::varchar                               as pin,
                   h.tiempo_evento::date                        as fecha,
                   to_char(h.tiempo_evento, 'HH24:MI:SS')::time as hora
            from asis.thuella_sotano h
            where h.dispositivo = 'FV18_SOT_ASIST'
              and h.tiempo_evento::date = v_parametros.fecha::date
              and h.pin is not null;

/*
            insert into tmp_biometrico
            (pin,
             fecha,
             hora)
            select p.pin,
                   p.fecha,
                   p.hora
            from asis.tpersona_transaccion_sucursal_ta p
            where to_char(p.fecha, 'DD/MM/YYYY')::date = v_parametros.fecha::date;*/

            CREATE TEMPORARY TABLE tmp_asitencia
            (
                codigo             varchar,
                fecha              date,
                gerencia           varchar,
                departamento       varchar,
                codigo_funcionario varchar,
                id_funcionario     integer,
                funcionario        varchar,
                cargo              varchar,
                observacion        varchar,
                evento             varchar,
                ausente            varchar default 'no'::character varying,
                retraso            varchar default 'no'::character varying,
                permiso            varchar default 'no'::character varying,
                vacacion           varchar default 'no'::character varying,
                viatico            varchar default 'no'::character varying,
                teletrabajo        varchar default 'no'::character varying,
                baje_medica        varchar default 'no'::character varying,
                ruta               text,
                nivel              integer
            ) ON COMMIT DROP;

            select g.id_gestion
            into
                v_id_gestion_actual
            from param.tgestion g
            where now() between g.fecha_ini and g.fecha_fin;

            for v_asistencia in (
                with biometrico as (
                    select bo.pin::integer as pin,
                           bo.fecha,
                           min(bo.hora)    as hora
                    from tmp_biometrico bo
                    group by bo.fecha, bo.pin
                ),
                     vacaciones as (
                         select v.id_funcionario,
                                v.nro_tramite,
                                v.fecha_inicio,
                                v.fecha_fin,
                                v.estado
                         from asis.tvacacion v
                         where v.estado in ('aprobado')
                           and v.fecha_inicio <= v_parametros.fecha::date
                           and v.fecha_fin >= v_parametros.fecha::date),
                     permiso as (
                         select p.id_funcionario,
                                p.nro_tramite,
                                p.fecha_solicitud,
                                p.estado,
                                p.hro_desde,
                                p.hro_hasta
                         from asis.tpermiso p
                         where p.estado in ('aprobado')
                           and p.fecha_solicitud = v_parametros.fecha::date
                           and p.id_tipo_licencia is null
                     ),
                     teletrabajo_temp as (
                         select t.id_funcionario,
                                t.nro_tramite,
                                t.fecha_inicio,
                                t.fecha_fin,
                                t.estado,
                                de.fecha
                         from asis.ttele_trabajo t
                                  inner join asis.ttele_trabajo_det de on de.id_tele_trabajo = t.id_tele_trabajo
                         where t.estado in ('aprobado', 'vobo')
                           and t.tipo_teletrabajo != 'Permanente'
                           and de.fecha = v_parametros.fecha::date),
                     teletrabajo_per as (
                         select t.id_funcionario,
                                t.nro_tramite,
                                t.fecha_inicio,
                                t.fecha_fin,
                                t.estado
                         from asis.ttele_trabajo t
                         where t.estado in ('aprobado', 'vobo')
                           and t.tipo_teletrabajo = 'Permanente'
                           and t.fecha_inicio <= v_parametros.fecha::date
                           and (t.fecha_fin is null or t.fecha_fin >= v_parametros.fecha::date)),
                     baje_medica as (
                         select b.id_funcionario,
                                b.nro_tramite,
                                b.fecha_inicio,
                                b.fecha_fin,
                                b.estado,
                                m.nombre as tipo_baja
                         from asis.tbaja_medica b
                                  inner join asis.ttipo_bm m on m.id_tipo_bm = b.id_tipo_bm
                         where v_parametros.fecha::date between b.fecha_inicio and b.fecha_fin),
                     viaticos as (
                         select cdoc.id_funcionario,
                                cdoc.nro_tramite,
                                cdoc.fecha_salida,
                                cdoc.fecha_llegada,
                                cdoc.estado
                         from cd.tcuenta_doc cdoc
                         where cdoc.estado_reg = 'activo'
                           and cdoc.id_tipo_cuenta_doc = 5
                           and v_parametros.fecha::date between cdoc.fecha_salida and cdoc.fecha_llegada
                     ),
                     licencias as (select p.id_funcionario,
                                          p.nro_tramite,
                                          p.fecha_solicitud,
                                          p.estado,
                                          p.fecha_inicio,
                                          p.fecha_fin,
                                          d.nombre as tipo_licencia,
                                          d.dias
                                   from asis.tpermiso p
                                            inner join asis.tdetalle_tipo_permiso d
                                                       on d.id_detalle_tipo_permiso = p.id_tipo_licencia
                                   where p.estado in ('aprobado', 'vobo')
                                     and v_parametros.fecha::date between p.fecha_inicio and p.fecha_fin
                                     and p.id_tipo_licencia is not null),
                     compensacion as (
                         select c.id_compensacion,
                                c.nro_tramite,
                                c.id_funcionario,
                                dc.tiempo_comp,
                                dc.fecha_comp
                         from asis.tcompensacion c
                                  inner join asis.tcompensacion_det de on de.id_compensacion = c.id_compensacion
                                  inner join asis.tcompensacion_det_com dc
                                             on dc.id_compensacion_det = de.id_compensacion_det
                         where dc.tiempo_comp in ('completo', 'mañana')
                           and c.estado = 'aprobado'
                           and dc.fecha_comp = v_parametros.fecha::date
                     )
                select fc.id_funcionario,
                       fc.funcioanrio,
                       fc.codigo::varchar  as codigo,
                       fc.cargo,
                       fc.id_gerencia      as id_uo,
                       fc.codigo_ger,
                       fc.gerencia,
                       fc.nombre_uo_centro as departamento,
                       bo.fecha,
                       bo.hora,
                       va.nro_tramite      as vacacion,
                       va.estado           as vacacion_estado,
                       pe.nro_tramite      as permiso,
                       pe.estado           as permiso_estado,
                       pe.hro_desde,
                       pe.hro_hasta,
                       ba.nro_tramite      as baje_medica,
                       ba.estado           as baje_medica_estado,
                       ba.tipo_baja,
                       vi.nro_tramite      as viatico,
                       vi.estado           as viatico_estado,
                       fc.ruta,
                       fc.nivel,
                       li.nro_tramite      as armonia,
                       li.estado           as armonia_estado,
                       tt.nro_tramite      as teletrabajo_temp,
                       tp.nro_tramite      as teletrabajo_per,
                       co.nro_tramite      as compesacion
                from asis.vfuncionario_centro_costo fc
                         left join biometrico bo on bo.pin = fc.codigo
                         left join vacaciones va on va.id_funcionario = fc.id_funcionario
                         left join permiso pe on pe.id_funcionario = fc.id_funcionario
                         left join teletrabajo_temp tt on tt.id_funcionario = fc.id_funcionario
                         left join teletrabajo_per tp on tp.id_funcionario = fc.id_funcionario
                         left join baje_medica ba on ba.id_funcionario = fc.id_funcionario
                         left join viaticos vi on vi.id_funcionario = fc.id_funcionario
                         left join licencias li on li.id_funcionario = fc.id_funcionario
                         left join compensacion co on co.id_funcionario = fc.id_funcionario
                where fc.fecha_asignacion <= v_parametros.fecha::date
                  and (fc.fecha_finalizacion is null or
                       fc.fecha_finalizacion >= v_parametros.fecha::date)
                  and (case
                           when v_parametros.id_uo is null then 0 = 0
                           else fc.id_gerencia = v_parametros.id_uo
                    end)
            )
                loop

                    v_dia = case extract(dow from v_parametros.fecha::date)
                                when 1 then 'lunes'
                                when 2 then 'martes'
                                when 3 then 'miercoles'
                                when 4 then 'jueves'
                                when 5 then 'viernes'
                                when 6 then 'sabado'
                                else 'domingo'
                        end;

                    v_consulta_rango = 'select rh.hora_entrada
                                                	from asis.trango_horario rh
                                                    inner join asis.tasignar_rango ar on ar.id_rango_horario = rh.id_rango_horario
                                                    where  ar.desde <=''' || v_parametros.fecha ||
                                       '''::date and (ar.hasta is null or ar.hasta >= '''
                                           || v_parametros.fecha || '''::date) and ar.id_uo = ' ||
                                       v_asistencia.id_uo || ' and rh.' || v_dia || ' = ''si'' ';

                    execute (v_consulta_rango) into v_hora;
                    if (v_asistencia.hora is not null) then

                        if (to_char(v_asistencia.hora, 'HH24:MI')::time <=
                            to_char(v_hora, 'HH24:MI')::time) then
                            insert into tmp_asitencia(codigo,
                                                      fecha,
                                                      gerencia,
                                                      departamento,
                                                      codigo_funcionario,
                                                      id_funcionario,
                                                      funcionario,
                                                      cargo,
                                                      observacion,
                                                      evento,
                                                      ruta,
                                                      nivel)
                            values (v_asistencia.codigo_ger,
                                    v_parametros.fecha::date,
                                    v_asistencia.gerencia,
                                    v_asistencia.departamento,
                                    v_asistencia.codigo,
                                    v_asistencia.id_funcionario,
                                    v_asistencia.funcioanrio,
                                    v_asistencia.cargo,
                                    'Oficina',
                                    'Personas en oficina',
                                    v_asistencia.ruta,
                                    v_asistencia.nivel);
                        else

                            if (v_asistencia.permiso is not null) then
                                if (v_hora::time between v_asistencia.hro_desde and v_asistencia.hro_hasta) then
                                    insert into tmp_asitencia(codigo,
                                                              fecha,
                                                              gerencia,
                                                              departamento,
                                                              codigo_funcionario,
                                                              id_funcionario,
                                                              funcionario,
                                                              cargo,
                                                              observacion,
                                                              evento,
                                                              vacacion,
                                                              ruta,
                                                              nivel)
                                    values (v_asistencia.codigo_ger,
                                            v_parametros.fecha::date,
                                            v_asistencia.gerencia,
                                            v_asistencia.departamento,
                                            v_asistencia.codigo,
                                            v_asistencia.id_funcionario,
                                            v_asistencia.funcioanrio,
                                            v_asistencia.cargo,
                                            'Permiso', --|| v_asistencia.hro_desde || ' - ' || v_asistencia.hro_hasta,
                                            'Personas en oficina',
                                            'si',
                                            v_asistencia.ruta,
                                            v_asistencia.nivel);
                                end if;
                            end if;

                            if (v_asistencia.cargo like '%Operador%') then
                                insert into tmp_asitencia(codigo,
                                                          fecha,
                                                          gerencia,
                                                          departamento,
                                                          codigo_funcionario,
                                                          id_funcionario,
                                                          funcionario,
                                                          cargo,
                                                          observacion,
                                                          evento,
                                                          ruta,
                                                          nivel)
                                values (v_asistencia.codigo_ger,
                                        v_parametros.fecha::date,
                                        v_asistencia.gerencia,
                                        v_asistencia.departamento,
                                        v_asistencia.codigo,
                                        v_asistencia.id_funcionario,
                                        v_asistencia.funcioanrio,
                                        v_asistencia.cargo,
                                        'Operador',
                                        'Personas en oficina',
                                        v_asistencia.ruta,
                                        v_asistencia.nivel);
                            end if;
                            if (v_asistencia.cargo like '%Conductor%') then
                                insert into tmp_asitencia(codigo,
                                                          fecha,
                                                          gerencia,
                                                          departamento,
                                                          codigo_funcionario,
                                                          id_funcionario,
                                                          funcionario,
                                                          cargo,
                                                          observacion,
                                                          evento,
                                                          ruta,
                                                          nivel)
                                values (v_asistencia.codigo_ger,
                                        v_parametros.fecha::date,
                                        v_asistencia.gerencia,
                                        v_asistencia.departamento,
                                        v_asistencia.codigo,
                                        v_asistencia.id_funcionario,
                                        v_asistencia.funcioanrio,
                                        v_asistencia.cargo,
                                        'Conductor',
                                        'Personas en oficina',
                                        v_asistencia.ruta,
                                        v_asistencia.nivel);
                            end if;

                            if not exists(
                                    select 1
                                    from tmp_asitencia t
                                    where t.id_funcionario = v_asistencia.id_funcionario) then
                                if (v_asistencia.hora::time > v_hora::time) then
                                    v_hora_resultado = v_asistencia.hora::time - v_hora::time;
                                    v_retraso = 'si';
                                end if;
                                v_evento = 'Retraso - ' || v_hora_resultado;

                                insert into tmp_asitencia(codigo,
                                                          fecha,
                                                          gerencia,
                                                          departamento,
                                                          codigo_funcionario,
                                                          id_funcionario,
                                                          funcionario,
                                                          cargo,
                                                          observacion,
                                                          evento,
                                                          retraso,
                                                          ruta,
                                                          nivel)
                                values (v_asistencia.codigo_ger,
                                        v_parametros.fecha::date,
                                        v_asistencia.gerencia,
                                        v_asistencia.departamento,
                                        v_asistencia.codigo,
                                        v_asistencia.id_funcionario,
                                        v_asistencia.funcioanrio,
                                        v_asistencia.cargo,
                                        v_evento,--'Retraso -' || v_hora_resultado,
                                        'Personas en oficina',
                                        v_retraso,
                                        v_asistencia.ruta,
                                        v_asistencia.nivel);
                            end if;
                        end if;
                    end if;

                    if (v_asistencia.hora is null) then

                        if (v_asistencia.vacacion is not null) then
                            insert into tmp_asitencia(codigo,
                                                      fecha,
                                                      gerencia,
                                                      departamento,
                                                      codigo_funcionario,
                                                      id_funcionario,
                                                      funcionario,
                                                      cargo,
                                                      observacion,
                                                      evento,
                                                      vacacion,
                                                      ruta,
                                                      nivel)
                            values (v_asistencia.codigo_ger,
                                    v_parametros.fecha::date,
                                    v_asistencia.gerencia,
                                    v_asistencia.departamento,
                                    v_asistencia.codigo,
                                    v_asistencia.id_funcionario,
                                    v_asistencia.funcioanrio,
                                    v_asistencia.cargo,
                                    'LPV',--''Vacación',
                                    'Licencia por vacación (LPV)',
                                    'si',
                                    v_asistencia.ruta,
                                    v_asistencia.nivel);
                        end if;
                        if (v_asistencia.teletrabajo_temp is not null) then
                            insert into tmp_asitencia(codigo,
                                                      fecha,
                                                      gerencia,
                                                      departamento,
                                                      codigo_funcionario,
                                                      id_funcionario,
                                                      funcionario,
                                                      cargo,
                                                      observacion,
                                                      evento,
                                                      teletrabajo,
                                                      ruta,
                                                      nivel)
                            values (v_asistencia.codigo_ger,
                                    v_parametros.fecha::date,
                                    v_asistencia.gerencia,
                                    v_asistencia.departamento,
                                    v_asistencia.codigo,
                                    v_asistencia.id_funcionario,
                                    v_asistencia.funcioanrio,
                                    v_asistencia.cargo,
                                    'Teletrabajo',
                                    'Personas en teletrabajo',
                                    'si',
                                    v_asistencia.ruta,
                                    v_asistencia.nivel);
                        end if;
                        if (v_asistencia.teletrabajo_per is not null) then
                            insert into tmp_asitencia(codigo,
                                                      fecha,
                                                      gerencia,
                                                      departamento,
                                                      codigo_funcionario,
                                                      id_funcionario,
                                                      funcionario,
                                                      cargo,
                                                      observacion,
                                                      evento,
                                                      teletrabajo,
                                                      ruta,
                                                      nivel)
                            values (v_asistencia.codigo_ger,
                                    v_parametros.fecha::date,
                                    v_asistencia.gerencia,
                                    v_asistencia.departamento,
                                    v_asistencia.codigo,
                                    v_asistencia.id_funcionario,
                                    v_asistencia.funcioanrio,
                                    v_asistencia.cargo,
                                    'Teletrabajo',
                                    'Personas en teletrabajo',
                                    'si',
                                    v_asistencia.ruta,
                                    v_asistencia.nivel);
                        end if;
                        if (v_asistencia.baje_medica is not null) then
                            insert into tmp_asitencia(codigo,
                                                      fecha,
                                                      gerencia,
                                                      departamento,
                                                      codigo_funcionario,
                                                      id_funcionario,
                                                      funcionario,
                                                      cargo,
                                                      observacion,
                                                      evento,
                                                      baje_medica,
                                                      ruta,
                                                      nivel)
                            values (v_asistencia.codigo_ger,
                                    v_parametros.fecha::date,
                                    v_asistencia.gerencia,
                                    v_asistencia.departamento,
                                    v_asistencia.codigo,
                                    v_asistencia.id_funcionario,
                                    v_asistencia.funcioanrio,
                                    v_asistencia.cargo,
                                    'LPE', --'Baja Medica (' || v_asistencia.tipo_baja || ') Esatdo ' ||v_asistencia.baje_medica_estado,
                                    'Licencia por enfermedad (LPE)',
                                    'si',
                                    v_asistencia.ruta,
                                    v_asistencia.nivel);
                        end if;
                        if (v_asistencia.viatico is not null) then
                            insert into tmp_asitencia(codigo,
                                                      fecha,
                                                      gerencia,
                                                      departamento,
                                                      codigo_funcionario,
                                                      id_funcionario,
                                                      funcionario,
                                                      cargo,
                                                      observacion,
                                                      evento,
                                                      viatico,
                                                      ruta,
                                                      nivel)
                            values (v_asistencia.codigo_ger,
                                    v_parametros.fecha::date,
                                    v_asistencia.gerencia,
                                    v_asistencia.departamento,
                                    v_asistencia.codigo,
                                    v_asistencia.id_funcionario,
                                    v_asistencia.funcioanrio,
                                    v_asistencia.cargo,
                                    'CDV',--'Comisión de viaje - Esatdo ' || v_asistencia.vacacion_estado,
                                    'Comisión de viaje (CDV)',
                                    'si',
                                    v_asistencia.ruta,
                                    v_asistencia.nivel);
                        end if;
                        if (v_asistencia.armonia is not null) then
                            insert into tmp_asitencia(codigo,
                                                      fecha,
                                                      gerencia,
                                                      departamento,
                                                      codigo_funcionario,
                                                      id_funcionario,
                                                      funcionario,
                                                      cargo,
                                                      observacion,
                                                      evento,
                                                      vacacion,
                                                      ruta,
                                                      nivel)
                            values (v_asistencia.codigo_ger,
                                    v_parametros.fecha::date,
                                    v_asistencia.gerencia,
                                    v_asistencia.departamento,
                                    v_asistencia.codigo,
                                    v_asistencia.id_funcionario,
                                    v_asistencia.funcioanrio,
                                    v_asistencia.cargo,
                                    'Programa Armonía',
                                    'Licencia por vacaión (LPV)',
                                    'si',
                                    v_asistencia.ruta,
                                    v_asistencia.nivel);
                        end if;
                        if (v_asistencia.cargo like '%Gerente%' or
                            v_asistencia.cargo like '%Asesor Legal%') then
                            insert into tmp_asitencia(codigo,
                                                      fecha,
                                                      gerencia,
                                                      departamento,
                                                      codigo_funcionario,
                                                      id_funcionario,
                                                      funcionario,
                                                      cargo,
                                                      observacion,
                                                      evento,
                                                      ruta,
                                                      nivel)
                            values (v_asistencia.codigo_ger,
                                    v_parametros.fecha::date,
                                    v_asistencia.gerencia,
                                    v_asistencia.departamento,
                                    v_asistencia.codigo,
                                    v_asistencia.id_funcionario,
                                    v_asistencia.funcioanrio,
                                    v_asistencia.cargo,
                                    'Oficina',
                                    'Personas en oficina',
                                    v_asistencia.ruta,
                                    v_asistencia.nivel);
                        end if;
                        if (v_asistencia.cargo like '%Operador%') then
                            insert into tmp_asitencia(codigo,
                                                      fecha,
                                                      gerencia,
                                                      departamento,
                                                      codigo_funcionario,
                                                      id_funcionario,
                                                      funcionario,
                                                      cargo,
                                                      observacion,
                                                      evento,
                                                      ruta,
                                                      nivel)
                            values (v_asistencia.codigo_ger,
                                    v_parametros.fecha::date,
                                    v_asistencia.gerencia,
                                    v_asistencia.departamento,
                                    v_asistencia.codigo,
                                    v_asistencia.id_funcionario,
                                    v_asistencia.funcioanrio,
                                    v_asistencia.cargo,
                                    'Operador',
                                    'Personas en oficina',
                                    v_asistencia.ruta,
                                    v_asistencia.nivel);
                        end if;
                        if (v_asistencia.cargo like '%Conductor%') then
                            insert into tmp_asitencia(codigo,
                                                      fecha,
                                                      gerencia,
                                                      departamento,
                                                      codigo_funcionario,
                                                      id_funcionario,
                                                      funcionario,
                                                      cargo,
                                                      observacion,
                                                      evento,
                                                      ruta,
                                                      nivel)
                            values (v_asistencia.codigo_ger,
                                    v_parametros.fecha::date,
                                    v_asistencia.gerencia,
                                    v_asistencia.departamento,
                                    v_asistencia.codigo,
                                    v_asistencia.id_funcionario,
                                    v_asistencia.funcioanrio,
                                    v_asistencia.cargo,
                                    'Conductor',
                                    'Personas en oficina',
                                    v_asistencia.ruta,
                                    v_asistencia.nivel);
                        end if;
                        if (v_asistencia.compesacion is not null) then
                            insert into tmp_asitencia(codigo,
                                                      fecha,
                                                      gerencia,
                                                      departamento,
                                                      codigo_funcionario,
                                                      id_funcionario,
                                                      funcionario,
                                                      cargo,
                                                      observacion,
                                                      evento,
                                                      vacacion,
                                                      ruta,
                                                      nivel)
                            values (v_asistencia.codigo_ger,
                                    v_parametros.fecha::date,
                                    v_asistencia.gerencia,
                                    v_asistencia.departamento,
                                    v_asistencia.codigo,
                                    v_asistencia.id_funcionario,
                                    v_asistencia.funcioanrio,
                                    v_asistencia.cargo,
                                    'LPV',--''Vacación',
                                    'Licencia por Compensacion (LPC)',
                                    'si',
                                    v_asistencia.ruta,
                                    v_asistencia.nivel);
                        end if;
                        if not exists(
                                select 1
                                from tmp_asitencia t
                                where t.id_funcionario = v_asistencia.id_funcionario) then
                            insert into tmp_asitencia(codigo,
                                                      fecha,
                                                      gerencia,
                                                      departamento,
                                                      codigo_funcionario,
                                                      id_funcionario,
                                                      funcionario,
                                                      cargo,
                                                      observacion,
                                                      evento,
                                                      ausente,
                                                      ruta,
                                                      nivel)
                            values (v_asistencia.codigo_ger,
                                    v_parametros.fecha::date,
                                    v_asistencia.gerencia,
                                    v_asistencia.departamento,
                                    v_asistencia.codigo,
                                    v_asistencia.id_funcionario,
                                    v_asistencia.funcioanrio,
                                    v_asistencia.cargo,
                                    'Ausente',
                                    'Personas ausentes',
                                    'si',
                                    v_asistencia.ruta,
                                    v_asistencia.nivel);
                        end if;
                        --end if;
                        -- end if;
                    end if;
                end loop;

            v_consulta = ' select  codigo,
                                    fecha,
                                    gerencia,
                                    departamento,
                                    codigo_funcionario,
                                    id_funcionario,
                                    funcionario,
                                    cargo,
                                    observacion,
                                    evento,
                                    retraso,
                                    permiso,
                                    vacacion,
                                    viatico,
                                    teletrabajo,
                                    baje_medica,
                                    ausente
                            from tmp_asitencia
                            order by ruta, nivel, funcionario';

            --Devuelve la respuesta
            return v_consulta;
        end;
        /*********************************
        #TRANSACCION:  'ASIS_RATR_SEL'
        #DESCRIPCION:    REPORTE DIARIO DE RETRASOS
        #AUTOR:        MMV
        #FECHA:        07/04/2021
        ***********************************/
    elsif (p_transaccion = 'ASIS_RATR_SEL') then
        begin
            --Sentencia de la consulta

            create temporary table tmp_biometrico
            (
                pin   varchar,
                fecha date,
                hora  time
            ) on commit drop;

            insert into tmp_biometrico
            (pin,
             fecha,
             hora)
            select p.pin,
                   p.fecha,
                   to_char(p.hora, 'HH24:MI:SS')::time as hora
            from asis.tpersona_transaccion p
            where p.dev_alias in
                  ('ACCESO_SOT1', 'barrera1', 'barrera2', 'barrera3', 'barrera4', 'ALM_ACC260')
              and to_char(p.fecha, 'DD/MM/YYYY')::date = v_parametros.fecha::date;

            insert into tmp_biometrico
            (pin,
             fecha,
             hora)
            select h.pin::varchar                               as pin,
                   h.tiempo_evento::date                        as fecha,
                   to_char(h.tiempo_evento, 'HH24:MI:SS')::time as hora
            from asis.thuella_sotano h
            where h.dispositivo = 'FV18_SOT_ASIST'
              and h.tiempo_evento::date = v_parametros.fecha::date
              and h.pin is not null;

            create temporary table tmp_control
            (
                codigo             varchar,
                fecha              date,
                gerencia           varchar,
                departamento       varchar,
                codigo_funcionario varchar,
                id_funcionario     integer,
                funcionario        text,
                cargo              text,
                hora               time,
                hora_cal           time,
                retraso            varchar,
                evento             varchar,
                ausente            varchar default 'no'::character varying
            ) on commit drop;

            for v_asistencia in (with biometrico as (
                select bo.pin::integer as pin,
                       bo.fecha,
                       min(bo.hora)    as hora
                from tmp_biometrico bo
                group by bo.fecha, bo.pin
            ),
                                      vacaciones as (
                                          select v.id_funcionario,
                                                 v.nro_tramite,
                                                 v.fecha_inicio,
                                                 v.fecha_fin,
                                                 v.estado
                                          from asis.tvacacion v
                                          where v.estado in ('aprobado', 'vobo')
                                            and v.fecha_inicio <= v_parametros.fecha::date
                                            and v.fecha_fin >= v_parametros.fecha::date),
                                      permiso as (
                                          select p.id_funcionario,
                                                 p.nro_tramite,
                                                 p.fecha_solicitud,
                                                 p.estado,
                                                 p.hro_desde,
                                                 p.hro_hasta
                                          from asis.tpermiso p
                                          where p.estado in ('aprobado', 'vobo')
                                            and p.fecha_solicitud = v_parametros.fecha::date
                                            and p.id_tipo_licencia is null
                                      ),
                                      teletrabajo as (
                                          select t.id_funcionario,
                                                 t.nro_tramite,
                                                 t.fecha_inicio,
                                                 t.fecha_fin,
                                                 t.estado
                                          from asis.ttele_trabajo t
                                                   inner join asis.ttele_trabajo_det de on de.id_tele_trabajo = t.id_tele_trabajo
                                          where t.estado in ('aprobado', 'vobo')
                                            and de.fecha = v_parametros.fecha::date),
                                      baje_medica as (
                                          select b.id_funcionario,
                                                 b.nro_tramite,
                                                 b.fecha_inicio,
                                                 b.fecha_fin,
                                                 b.estado,
                                                 m.nombre as tipo_baja
                                          from asis.tbaja_medica b
                                                   inner join asis.ttipo_bm m on m.id_tipo_bm = b.id_tipo_bm
                                          where v_parametros.fecha::date between b.fecha_inicio and b.fecha_fin),
                                      viaticos as (
                                          select cdoc.id_funcionario,
                                                 cdoc.nro_tramite,
                                                 cdoc.fecha_salida,
                                                 cdoc.fecha_llegada,
                                                 cdoc.estado
                                          from cd.tcuenta_doc cdoc
                                          where cdoc.estado_reg = 'activo'
                                            and cdoc.id_tipo_cuenta_doc = 5
                                            and v_parametros.fecha::date between cdoc.fecha_salida and cdoc.fecha_llegada
                                      ),
                                      licencias as (select p.id_funcionario,
                                                           p.nro_tramite,
                                                           p.fecha_solicitud,
                                                           p.estado,
                                                           p.fecha_inicio,
                                                           p.fecha_fin,
                                                           d.nombre as tipo_licencia,
                                                           d.dias
                                                    from asis.tpermiso p
                                                             inner join asis.tdetalle_tipo_permiso d
                                                                        on d.id_detalle_tipo_permiso = p.id_tipo_licencia
                                                    where p.estado in ('aprobado', 'vobo')
                                                      and v_parametros.fecha::date between p.fecha_inicio and p.fecha_fin
                                                      and p.id_tipo_licencia is not null),
                                      compensacion as (
                                          select c.id_compensacion,
                                                 c.nro_tramite,
                                                 c.id_funcionario,
                                                 dc.tiempo_comp,
                                                 dc.fecha_comp
                                          from asis.tcompensacion c
                                                   inner join asis.tcompensacion_det de on de.id_compensacion = c.id_compensacion
                                                   inner join asis.tcompensacion_det_com dc
                                                              on dc.id_compensacion_det = de.id_compensacion_det
                                          where dc.tiempo_comp in ('completo', 'mañana')
                                            and c.estado = 'aprobado'
                                            and dc.fecha_comp = v_parametros.fecha::date
                                      )
                                 select fc.id_funcionario,
                                        fc.codigo,
                                        fc.funcioanrio,
                                        fc.cargo,
                                        fc.id_gerencia,
                                        fc.codigo_ger,
                                        fc.gerencia,
                                        fc.nombre_uo_centro as departamento,
                                        bo.fecha,
                                        bo.hora,
                                        va.nro_tramite      as vacacion,
                                        pe.estado           as permiso,
                                        pe.hro_desde,
                                        pe.hro_hasta,
                                        tl.nro_tramite      as teletrabajo,
                                        ba.nro_tramite      as baje_medica,
                                        vi.nro_tramite      as viatico,
                                        fc.ruta,
                                        fc.nivel,
                                        li.nro_tramite      as armonia
                                 from asis.vfuncionario_centro_costo fc
                                          left join biometrico bo on bo.pin = fc.codigo
                                          left join vacaciones va on va.id_funcionario = fc.id_funcionario
                                          left join permiso pe on pe.id_funcionario = fc.id_funcionario
                                          left join teletrabajo tl on tl.id_funcionario = fc.id_funcionario
                                          left join baje_medica ba on ba.id_funcionario = fc.id_funcionario
                                          left join viaticos vi on vi.id_funcionario = fc.id_funcionario
                                          left join licencias li on li.id_funcionario = fc.id_funcionario
                                 where fc.fecha_asignacion <= v_parametros.fecha::date
                                   and (fc.fecha_finalizacion is null or
                                        fc.fecha_finalizacion >= v_parametros.fecha::date)
                                   and (case
                                            when v_parametros.id_uo is null then 0 = 0
                                            else fc.id_gerencia = v_parametros.id_uo
                                     end)
                                 order by fc.ruta, fc.nivel, fc.funcioanrio
            )
                loop

                    ---raise exception  'entra 12345678';
                    v_dia = case extract(dow from v_parametros.fecha::date)
                                when 1 then 'lunes'
                                when 2 then 'martes'
                                when 3 then 'miercoles'
                                when 4 then 'jueves'
                                when 5 then 'viernes'
                                when 6 then 'sabado'
                                else 'domingo'
                        end;

                    v_consulta_rango = 'select rh.hora_entrada
                                        from asis.trango_horario rh
                                        inner join asis.tasignar_rango ar on ar.id_rango_horario = rh.id_rango_horario
                                        where  ar.desde <=''' || v_parametros.fecha ||
                                       '''::date and (ar.hasta is null or ar.hasta >= '''
                                           || v_parametros.fecha || '''::date) and ar.id_uo = ' ||
                                       v_asistencia.id_gerencia || ' and rh.' || v_dia || ' = ''si'' ';

                    execute (v_consulta_rango) into v_hora;


                    if (v_asistencia.hora is not null) then
                        v_hora_resultado = '00:00:00'::time; -- v_asistencia.hora::time;
                        v_retraso = 'no';
                        if (v_asistencia.hora::time > v_hora::time) then
                            v_hora_resultado = v_asistencia.hora::time - v_hora::time;
                            v_retraso = 'si';
                        end if;

                        insert into tmp_control(codigo,
                                                fecha,
                                                gerencia,
                                                departamento,
                                                codigo_funcionario,
                                                id_funcionario,
                                                funcionario,
                                                cargo,
                                                hora,
                                                hora_cal,
                                                retraso)
                        values (v_asistencia.codigo_ger,
                                v_parametros.fecha::date,
                                v_asistencia.gerencia,
                                v_asistencia.departamento,
                                v_asistencia.codigo,
                                v_asistencia.id_funcionario,
                                v_asistencia.funcioanrio,
                                v_asistencia.cargo,
                                v_asistencia.hora,
                                COALESCE(v_hora_resultado, '00:00:00'::time),
                                v_retraso);
                    else
                        v_evento = 'asuente';

                        if (v_asistencia.vacacion is not null) then
                            v_evento = 'Vacacion';
                        end if;

                        if (v_asistencia.teletrabajo is not null) then
                            v_evento = 'Teletrabajo';
                        end if;

                        if (v_asistencia.baje_medica is not null) then
                            v_evento = 'Baja Medica';
                        end if;

                        if (v_asistencia.viatico is not null) then
                            v_evento = 'Viatico';
                        end if;

                        if (v_asistencia.permiso is not null) then
                            if (v_asistencia.hora between v_asistencia.hro_desde and v_asistencia.hro_hasta) then
                                v_evento = 'Permiso';
                            end if;
                        end if;

                        if (v_asistencia.armonia is not null) then
                            v_evento = 'Programa Armonía';
                        end if;

                        insert into tmp_control(codigo,
                                                fecha,
                                                gerencia,
                                                departamento,
                                                codigo_funcionario,
                                                id_funcionario,
                                                funcionario,
                                                cargo,
                                                hora,
                                                hora_cal,
                                                retraso,
                                                evento)
                        values (v_asistencia.codigo_ger,
                                v_parametros.fecha::date,
                                v_asistencia.gerencia,
                                v_asistencia.departamento,
                                v_asistencia.codigo,
                                v_asistencia.id_funcionario,
                                v_asistencia.funcioanrio,
                                v_asistencia.cargo,
                                '00:00:00'::time,
                                '00:00:00'::time,
                                'no',
                                v_evento);
                    end if;
                end loop;
            v_filtro = '';

            if (v_parametros.tipo_filtro != 'todo') then
                v_filtro = 'where tm.hora >'' ' || v_hora || ''' ';
            end if;

            v_consulta := 'select  tm.codigo,
                                   tm.fecha,
                                   tm.gerencia,
                                   tm.departamento,
                                   tm.codigo_funcionario,
                                   tm.id_funcionario,
                                   tm.funcionario,
                                   tm.cargo,
                                   tm.hora,
                                   tm.hora_cal,
                                   tm.retraso,
                                   tm.evento
                            from tmp_control tm  ' || v_filtro || ' ';
            --Devuelve la respuesta
            return v_consulta;

        end;
        /*********************************
       #TRANSACCION:  'ASIS_RMSU_SEL'
       #DESCRIPCION:    DETALLE MENSUAL DE RETRASOS
       #AUTOR:        MMV
       #FECHA:        07/04/2021
       ***********************************/
    elsif (p_transaccion = 'ASIS_RMSU_SEL') then

        begin
            --Sentencia de la consulta

            create temporary table tmp_biometrico
            (
                pin   varchar,
                fecha date,
                hora  time
            ) on commit drop;

            insert into tmp_biometrico
            (pin,
             fecha,
             hora)
            select p.pin,
                   p.fecha,
                   to_char(p.hora, 'HH24:MI:SS')::time as hora
            from asis.tpersona_transaccion p
            where p.dev_alias in
                  ('ACCESO_SOT1', 'barrera1', 'barrera2', 'barrera3', 'barrera4', 'ALM_ACC260')
              and to_char(p.fecha, 'DD/MM/YYYY')::date between v_parametros.fecha_ini::date and v_parametros.fecha_fin::date;

            insert into tmp_biometrico
            (pin,
             fecha,
             hora)
            select h.pin::varchar                               as pin,
                   h.tiempo_evento::date                        as fecha,
                   to_char(h.tiempo_evento, 'HH24:MI:SS')::time as hora
            from asis.thuella_sotano h
            where h.dispositivo = 'FV18_SOT_ASIST'
              and h.tiempo_evento::date between v_parametros.fecha_ini::date and v_parametros.fecha_fin::date
              and h.pin is not null;


            /*           insert into tmp_biometrico
                       (pin,
                        fecha,
                        hora)
                       select p.pin,
                              p.fecha,
                              p.hora
                       from asis.tpersona_transaccion_sucursal_ta p
                       where to_char(p.fecha, 'DD/MM/YYYY')::date between v_parametros.fecha_ini::date and v_parametros.fecha_fin::date;

           */
            CREATE TEMPORARY TABLE tmp_control_total
            (
                codigo             varchar,
                fecha              date,
                gerencia           varchar,
                departamento       varchar,
                codigo_funcionario varchar,
                id_funcionario     integer,
                funcionario        text,
                cargo              text,
                hora               time,
                hora_cal           time,
                retraso            varchar default 'no'::character varying,
                ruta               text,
                nivel_ordernar     integer,
                motivo             varchar
            ) ON COMMIT DROP;


            select g.id_gestion
            into
                v_id_gestion_actual
            from param.tgestion g
            where now() between g.fecha_ini and g.fecha_fin;

            for v_record_fecha in (select mes::date as dia
                                   from generate_series(v_parametros.fecha_ini::date, v_parametros.fecha_fin::date,
                                                        '1 day'::interval) mes
                                   order by dia)
                loop


                    for v_asistencia in (with biometrico as (select bo.pin::integer as pin,
                                                                    bo.fecha,
                                                                    min(bo.hora)    as hora
                                                             from tmp_biometrico bo
                                                             where bo.fecha = v_record_fecha.dia
                                                             group by bo.fecha,
                                                                      bo.pin),
                                              permiso as (
                                                  select p.id_funcionario,
                                                         p.nro_tramite,
                                                         p.fecha_solicitud,
                                                         p.estado,
                                                         p.hro_desde,
                                                         p.hro_hasta
                                                  from asis.tpermiso p
                                                  where p.estado in ('aprobado')
                                                    and p.fecha_solicitud = v_record_fecha.dia
                                                    and p.id_tipo_licencia is null
                                              ),
                                              vacaciones as (
                                                  select v.id_funcionario,
                                                         v.nro_tramite,
                                                         d.fecha_dia,
                                                         d.tiempo
                                                  from asis.tvacacion v
                                                           inner join asis.tvacacion_det d on d.id_vacacion = v.id_vacacion
                                                  where v.estado in ('aprobado')
                                                    and d.fecha_dia = v_record_fecha.dia),
                                              teletrabajo_temp as (
                                                  select t.id_funcionario,
                                                         t.nro_tramite,
                                                         t.fecha_inicio,
                                                         t.fecha_fin,
                                                         t.estado,
                                                         de.fecha
                                                  from asis.ttele_trabajo t
                                                           inner join asis.ttele_trabajo_det de on de.id_tele_trabajo = t.id_tele_trabajo
                                                  where t.estado in ('aprobado', 'vobo')
                                                    and t.tipo_teletrabajo != 'Permanente'
                                                    and de.fecha = v_record_fecha.dia),
                                              teletrabajo_per as (
                                                  select t.id_funcionario,
                                                         t.nro_tramite,
                                                         t.fecha_inicio,
                                                         t.fecha_fin,
                                                         t.estado
                                                  from asis.ttele_trabajo t
                                                  where t.estado in ('aprobado', 'vobo')
                                                    and t.tipo_teletrabajo = 'Permanente'
                                                    and t.fecha_inicio <= v_record_fecha.dia
                                                    and (t.fecha_fin is null or t.fecha_fin >= v_record_fecha.dia)),
                                              baje_medica as (
                                                  select b.id_funcionario,
                                                         b.nro_tramite,
                                                         b.fecha_inicio,
                                                         b.fecha_fin,
                                                         b.estado,
                                                         m.nombre as tipo_baja
                                                  from asis.tbaja_medica b
                                                           inner join asis.ttipo_bm m on m.id_tipo_bm = b.id_tipo_bm
                                                  where v_record_fecha.dia between b.fecha_inicio and b.fecha_fin),
                                              viaticos as (
                                                  select cdoc.id_funcionario,
                                                         cdoc.nro_tramite,
                                                         cdoc.fecha_salida,
                                                         cdoc.fecha_llegada,
                                                         cdoc.estado
                                                  from cd.tcuenta_doc cdoc
                                                  where cdoc.estado_reg = 'activo'
                                                    and cdoc.id_tipo_cuenta_doc = 5
                                                    and v_record_fecha.dia between cdoc.fecha_salida and cdoc.fecha_llegada
                                              ),
                                              licencias as (select p.id_funcionario,
                                                                   p.nro_tramite,
                                                                   p.fecha_solicitud,
                                                                   p.estado,
                                                                   p.fecha_inicio,
                                                                   p.fecha_fin,
                                                                   d.nombre as tipo_licencia,
                                                                   d.dias
                                                            from asis.tpermiso p
                                                                     inner join asis.tdetalle_tipo_permiso d
                                                                                on d.id_detalle_tipo_permiso = p.id_tipo_licencia
                                                            where p.estado in ('aprobado', 'vobo')
                                                              and v_record_fecha.dia between p.fecha_inicio and p.fecha_fin
                                                              and p.id_tipo_licencia is not null),
                                              compensacion as (
                                                  select c.id_compensacion,
                                                         c.nro_tramite,
                                                         c.id_funcionario,
                                                         dc.tiempo_comp,
                                                         dc.fecha_comp
                                                  from asis.tcompensacion c
                                                           inner join asis.tcompensacion_det de on de.id_compensacion = c.id_compensacion
                                                           inner join asis.tcompensacion_det_com dc
                                                                      on dc.id_compensacion_det = de.id_compensacion_det
                                                  where dc.tiempo_comp in ('completo', 'mañana')
                                                    and c.estado = 'aprobado'
                                                    and dc.fecha_comp =  v_record_fecha.dia
                                              )
                                         select fc.id_funcionario,
                                                fc.codigo,
                                                fc.funcioanrio,
                                                fc.cargo,
                                                fc.id_gerencia,
                                                fc.codigo_ger,
                                                fc.gerencia,
                                                fc.nombre_uo_centro as departamento,
                                                fc.ruta,
                                                fc.nivel,
                                                bo.fecha,
                                                bo.hora,
                                                pe.nro_tramite      as permiso,
                                                pe.hro_desde        as hro_desde_permiso,
                                                pe.hro_hasta        as hro_hasta_permiso,
                                                va.nro_tramite      as vacacion,
                                                va.tiempo,
                                                va.fecha_dia,
                                                tt.nro_tramite      as teletrabajo_temp,
                                                ba.nro_tramite      as baja_medica,
                                                vi.nro_tramite      as viatico,
                                                tp.nro_tramite      as teletrabajo_perm,
                                                li.nro_tramite      as lincencia,
                                                co.nro_tramite      as compesacion
                                         from asis.vfuncionario_centro_costo fc
                                                  left join biometrico bo on bo.pin = fc.codigo
                                                  left join permiso pe on pe.id_funcionario = fc.id_funcionario
                                                  left join vacaciones va on va.id_funcionario = fc.id_funcionario
                                                  left join teletrabajo_temp tt on tt.id_funcionario = fc.id_funcionario
                                                  left join teletrabajo_per tp on tp.id_funcionario = fc.id_funcionario
                                                  left join baje_medica ba on ba.id_funcionario = fc.id_funcionario
                                                  left join viaticos vi on vi.id_funcionario = fc.id_funcionario
                                                  left join licencias li on li.id_funcionario = fc.id_funcionario
                                                  left join compensacion co on co.id_funcionario = fc.id_funcionario

                                         where fc.fecha_asignacion <= v_record_fecha.dia
                                           and (fc.fecha_finalizacion is null
                                             or
                                                fc.fecha_finalizacion >= v_record_fecha.dia)
                                           and (case
                                                    when v_parametros.id_uo is null then 0 = 0
                                                    else fc.id_gerencia = v_parametros.id_uo
                                             end))
                        loop
                            v_dia = case extract(dow from v_record_fecha.dia::date)
                                        when 1 then 'lunes'
                                        when 2 then 'martes'
                                        when 3 then 'miercoles'
                                        when 4 then 'jueves'
                                        when 5 then 'viernes'
                                        when 6 then 'sabado'
                                        else 'domingo'
                                end;

                            v_consulta_rango = 'select rh.hora_entrada
                                        from asis.trango_horario rh
                                        inner join asis.tasignar_rango ar on ar.id_rango_horario = rh.id_rango_horario
                                        where  ar.desde <=''' || v_record_fecha.dia ||
                                               '''::date and (ar.hasta is null or ar.hasta >= '''
                                                   || v_record_fecha.dia || '''::date) and ar.id_uo = ' ||
                                               v_asistencia.id_gerencia || ' and rh.' || v_dia || ' = ''si'' ';

                            execute (v_consulta_rango) into v_hora;

                            v_hora_resultado = v_asistencia.hora::time;

                            -- v_retraso = 'no';

                            if (v_asistencia.hora is not null) then
                                if (to_char(v_asistencia.hora, 'HH24:MI')::time <=
                                    to_char(v_hora, 'HH24:MI')::time) then
                                    insert into tmp_control_total(codigo,
                                                                  fecha,
                                                                  gerencia,
                                                                  departamento,
                                                                  codigo_funcionario,
                                                                  id_funcionario,
                                                                  funcionario,
                                                                  cargo,
                                                                  hora,
                                                                  hora_cal,
                                                                  ruta,
                                                                  nivel_ordernar,
                                                                  motivo)
                                    values (v_asistencia.codigo_ger,
                                            v_asistencia.fecha::date,
                                            v_asistencia.gerencia,
                                            v_asistencia.departamento,
                                            v_asistencia.codigo,
                                            v_asistencia.id_funcionario,
                                            v_asistencia.funcioanrio,
                                            v_asistencia.cargo,
                                            v_asistencia.hora,
                                            '00:00:00'::time,
                                            v_asistencia.ruta,
                                            v_asistencia.nivel,
                                            'Oficina');
                                else

                                    if (v_asistencia.permiso is not null) then
                                        if (v_hora::time between v_asistencia.hro_desde_permiso::time and v_asistencia.hro_hasta_permiso::time) then
                                            insert into tmp_control_total(codigo,
                                                                          fecha,
                                                                          gerencia,
                                                                          departamento,
                                                                          codigo_funcionario,
                                                                          id_funcionario,
                                                                          funcionario,
                                                                          cargo,
                                                                          hora,
                                                                          hora_cal,
                                                                          retraso,
                                                                          ruta,
                                                                          nivel_ordernar,
                                                                          motivo)
                                            values (v_asistencia.codigo_ger,
                                                    v_record_fecha.dia::date,
                                                    v_asistencia.gerencia,
                                                    v_asistencia.departamento,
                                                    v_asistencia.codigo,
                                                    v_asistencia.id_funcionario,
                                                    v_asistencia.funcioanrio,
                                                    v_asistencia.cargo,
                                                    v_asistencia.hora,-- v_asistencia.hro_desde_permiso::time,
                                                    '00:00:00'::time,
                                                    'si',
                                                    v_asistencia.ruta,
                                                    v_asistencia.nivel,
                                                    'Permiso');
                                        end if;
                                    end if;
                                    if (v_asistencia.vacacion is not null
                                        and v_asistencia.tiempo = 'mañana') then
                                        insert into tmp_control_total(codigo,
                                                                      fecha,
                                                                      gerencia,
                                                                      departamento,
                                                                      codigo_funcionario,
                                                                      id_funcionario,
                                                                      funcionario,
                                                                      cargo,
                                                                      hora,
                                                                      hora_cal,
                                                                      ruta,
                                                                      nivel_ordernar,
                                                                      motivo)
                                        values (v_asistencia.codigo_ger,
                                                v_record_fecha.dia::date,
                                                v_asistencia.gerencia,
                                                v_asistencia.departamento,
                                                v_asistencia.codigo,
                                                v_asistencia.id_funcionario,
                                                v_asistencia.funcioanrio,
                                                v_asistencia.cargo,
                                                v_asistencia.hora,
                                                '00:00:00'::time,
                                                v_asistencia.ruta,
                                                v_asistencia.nivel,
                                                'Vacacion');
                                    end if;

                                    if (v_asistencia.cargo like '%Gerente%' or
                                        v_asistencia.cargo like '%Asesor Legal%' or
                                        v_asistencia.cargo like '%Operador%' or
                                        v_asistencia.cargo like '%Conductor%') then

                                        insert into tmp_control_total(codigo,
                                                                      fecha,
                                                                      gerencia,
                                                                      departamento,
                                                                      codigo_funcionario,
                                                                      id_funcionario,
                                                                      funcionario,
                                                                      cargo,
                                                                      hora,
                                                                      hora_cal,
                                                                      ruta,
                                                                      nivel_ordernar,
                                                                      motivo)
                                        values (v_asistencia.codigo_ger,
                                                v_record_fecha.dia::date,
                                                v_asistencia.gerencia,
                                                v_asistencia.departamento,
                                                v_asistencia.codigo,
                                                v_asistencia.id_funcionario,
                                                v_asistencia.funcioanrio,
                                                v_asistencia.cargo,
                                                (case
                                                     when extract(dow from v_record_fecha.dia::date) = 5 then
                                                         '08:30:00'
                                                     else
                                                         '08:00:00'
                                                    end
                                                    )::time,
                                                '00:00:00'::time,
                                                v_asistencia.ruta,
                                                v_asistencia.nivel,
                                                'Oficina');
                                    end if;
                                    if not exists(
                                            select 1
                                            from tmp_control_total t
                                            where t.id_funcionario =
                                                  v_asistencia.id_funcionario
                                              and t.fecha = v_record_fecha.dia) then


                                        v_hora_resultado = v_asistencia.hora::time - v_hora::time;
                                        v_retraso = 'si';

                                        insert into tmp_control_total(codigo,
                                                                      fecha,
                                                                      gerencia,
                                                                      departamento,
                                                                      codigo_funcionario,
                                                                      id_funcionario,
                                                                      funcionario,
                                                                      cargo,
                                                                      hora,
                                                                      hora_cal,
                                                                      retraso,
                                                                      ruta,
                                                                      nivel_ordernar,
                                                                      motivo)
                                        values (v_asistencia.codigo_ger,
                                                v_asistencia.fecha::date,
                                                v_asistencia.gerencia,
                                                v_asistencia.departamento,
                                                v_asistencia.codigo,
                                                v_asistencia.id_funcionario,
                                                v_asistencia.funcioanrio,
                                                v_asistencia.cargo,
                                                v_asistencia.hora,
                                                v_hora_resultado,
                                                'si',
                                                v_asistencia.ruta,
                                                v_asistencia.nivel,
                                                'Retraso');
                                    end if;
                                end if;
                            else

                                if not exists(select *
                                              from param.tferiado f
                                                       inner join param.tlugar l on l.id_lugar = f.id_lugar
                                              where l.codigo in ('BO')
                                                and (EXTRACT(MONTH from f.fecha))::integer =
                                                    (EXTRACT(MONTH from v_record_fecha.dia ::date))::integer
                                                and (EXTRACT(DAY from f.fecha))::integer =
                                                    (EXTRACT(DAY from v_record_fecha.dia))
                                                and f.id_gestion = v_id_gestion_actual) then
                                    if (extract(dow from v_record_fecha.dia::date) not in (6, 0)) then
                                        if (v_asistencia.vacacion is not null) then
                                            insert into tmp_control_total(codigo,
                                                                          fecha,
                                                                          gerencia,
                                                                          departamento,
                                                                          codigo_funcionario,
                                                                          id_funcionario,
                                                                          funcionario,
                                                                          cargo,
                                                                          hora,
                                                                          hora_cal,
                                                                          ruta,
                                                                          nivel_ordernar,
                                                                          motivo)
                                            values (v_asistencia.codigo_ger,
                                                    v_record_fecha.dia::date,
                                                    v_asistencia.gerencia,
                                                    v_asistencia.departamento,
                                                    v_asistencia.codigo,
                                                    v_asistencia.id_funcionario,
                                                    v_asistencia.funcioanrio,
                                                    v_asistencia.cargo,
                                                    '00:00:00'::time,
                                                    '00:00:00'::time,
                                                    v_asistencia.ruta,
                                                    v_asistencia.nivel,
                                                    'Vacacion');
                                        end if;

                                        if (v_asistencia.compesacion is not null) then
                                            insert into tmp_control_total(codigo,
                                                                          fecha,
                                                                          gerencia,
                                                                          departamento,
                                                                          codigo_funcionario,
                                                                          id_funcionario,
                                                                          funcionario,
                                                                          cargo,
                                                                          hora,
                                                                          hora_cal,
                                                                          ruta,
                                                                          nivel_ordernar,
                                                                          motivo)
                                            values (v_asistencia.codigo_ger,
                                                    v_record_fecha.dia::date,
                                                    v_asistencia.gerencia,
                                                    v_asistencia.departamento,
                                                    v_asistencia.codigo,
                                                    v_asistencia.id_funcionario,
                                                    v_asistencia.funcioanrio,
                                                    v_asistencia.cargo,
                                                    '00:00:00'::time,
                                                    '00:00:00'::time,
                                                    v_asistencia.ruta,
                                                    v_asistencia.nivel,
                                                    'Compensacion');
                                        end if;
                                        if (v_asistencia.lincencia is not null) then
                                            insert into tmp_control_total(codigo,
                                                                          fecha,
                                                                          gerencia,
                                                                          departamento,
                                                                          codigo_funcionario,
                                                                          id_funcionario,
                                                                          funcionario,
                                                                          cargo,
                                                                          hora,
                                                                          hora_cal,
                                                                          retraso,
                                                                          nivel_ordernar,
                                                                          motivo)
                                            values (v_asistencia.codigo_ger,
                                                    v_record_fecha.dia::date,
                                                    v_asistencia.gerencia,
                                                    v_asistencia.departamento,
                                                    v_asistencia.codigo,
                                                    v_asistencia.id_funcionario,
                                                    v_asistencia.funcioanrio,
                                                    v_asistencia.cargo,
                                                    '00:00:00'::time,
                                                    '00:00:00'::time,
                                                    v_asistencia.ruta,
                                                    v_asistencia.nivel,
                                                    'Programa Armonía');
                                        end if;
                                        if (v_asistencia.viatico is not null) then
                                            insert into tmp_control_total(codigo,
                                                                          fecha,
                                                                          gerencia,
                                                                          departamento,
                                                                          codigo_funcionario,
                                                                          id_funcionario,
                                                                          funcionario,
                                                                          cargo,
                                                                          hora,
                                                                          hora_cal,
                                                                          ruta,
                                                                          nivel_ordernar,
                                                                          motivo)
                                            values (v_asistencia.codigo_ger,
                                                    v_record_fecha.dia::date,
                                                    v_asistencia.gerencia,
                                                    v_asistencia.departamento,
                                                    v_asistencia.codigo,
                                                    v_asistencia.id_funcionario,
                                                    v_asistencia.funcioanrio,
                                                    v_asistencia.cargo,
                                                    '00:00:00'::time,
                                                    '00:00:00'::time,
                                                    v_asistencia.ruta,
                                                    v_asistencia.nivel,
                                                    'Viaticos');
                                        end if;
                                        if (v_asistencia.teletrabajo_temp is not null) then
                                            insert into tmp_control_total(codigo,
                                                                          fecha,
                                                                          gerencia,
                                                                          departamento,
                                                                          codigo_funcionario,
                                                                          id_funcionario,
                                                                          funcionario,
                                                                          cargo,
                                                                          hora,
                                                                          hora_cal,
                                                                          ruta,
                                                                          nivel_ordernar,
                                                                          motivo)
                                            values (v_asistencia.codigo_ger,
                                                    v_record_fecha.dia::date,
                                                    v_asistencia.gerencia,
                                                    v_asistencia.departamento,
                                                    v_asistencia.codigo,
                                                    v_asistencia.id_funcionario,
                                                    v_asistencia.funcioanrio,
                                                    v_asistencia.cargo,
                                                    '00:00:00'::time,
                                                    '00:00:00'::time,
                                                    v_asistencia.ruta,
                                                    v_asistencia.nivel,
                                                    'Teletrabajo');
                                        end if;
                                        if (v_asistencia.teletrabajo_perm is not null) then
                                            insert into tmp_control_total(codigo,
                                                                          fecha,
                                                                          gerencia,
                                                                          departamento,
                                                                          codigo_funcionario,
                                                                          id_funcionario,
                                                                          funcionario,
                                                                          cargo,
                                                                          hora,
                                                                          hora_cal,
                                                                          retraso,
                                                                          nivel_ordernar,
                                                                          motivo)
                                            values (v_asistencia.codigo_ger,
                                                    v_record_fecha.dia::date,
                                                    v_asistencia.gerencia,
                                                    v_asistencia.departamento,
                                                    v_asistencia.codigo,
                                                    v_asistencia.id_funcionario,
                                                    v_asistencia.funcioanrio,
                                                    v_asistencia.cargo,
                                                    '00:00:00'::time,
                                                    '00:00:00'::time,
                                                    v_asistencia.ruta,
                                                    v_asistencia.nivel,
                                                    'Teletrabajo');
                                        end if;
                                        if (v_asistencia.baja_medica is not null) then
                                            insert into tmp_control_total(codigo,
                                                                          fecha,
                                                                          gerencia,
                                                                          departamento,
                                                                          codigo_funcionario,
                                                                          id_funcionario,
                                                                          funcionario,
                                                                          cargo,
                                                                          hora,
                                                                          hora_cal,
                                                                          ruta,
                                                                          nivel_ordernar,
                                                                          motivo)
                                            values (v_asistencia.codigo_ger,
                                                    v_record_fecha.dia::date,
                                                    v_asistencia.gerencia,
                                                    v_asistencia.departamento,
                                                    v_asistencia.codigo,
                                                    v_asistencia.id_funcionario,
                                                    v_asistencia.funcioanrio,
                                                    v_asistencia.cargo,
                                                    '00:00:00'::time,
                                                    '00:00:00'::time,
                                                    v_asistencia.ruta,
                                                    v_asistencia.nivel,
                                                    'Baja Medica');
                                        end if;
                                        if (v_asistencia.cargo like '%Gerente%' or
                                            v_asistencia.cargo like '%Asesor Legal%' or
                                            v_asistencia.cargo like '%Operador%' or
                                            v_asistencia.cargo like '%Conductor%') then

                                            /*if (v_asistencia.cargo in ('Operador', 'Conductor')) then
                                                v_evento = v_asistencia.cargo;
                                            end if;*/

                                            insert into tmp_control_total(codigo,
                                                                          fecha,
                                                                          gerencia,
                                                                          departamento,
                                                                          codigo_funcionario,
                                                                          id_funcionario,
                                                                          funcionario,
                                                                          cargo,
                                                                          hora,
                                                                          hora_cal,
                                                                          ruta,
                                                                          nivel_ordernar,
                                                                          motivo)
                                            values (v_asistencia.codigo_ger,
                                                    v_record_fecha.dia::date,
                                                    v_asistencia.gerencia,
                                                    v_asistencia.departamento,
                                                    v_asistencia.codigo,
                                                    v_asistencia.id_funcionario,
                                                    v_asistencia.funcioanrio,
                                                    v_asistencia.cargo,
                                                    (case
                                                         when extract(dow from v_record_fecha.dia::date) = 5 then
                                                             '08:30:00'
                                                         else
                                                             '08:00:00'
                                                        end
                                                        )::time,
                                                    '00:00:00'::time,
                                                    v_asistencia.ruta,
                                                    v_asistencia.nivel,
                                                    'Oficina');
                                        end if;
                                        if not exists(
                                                select 1
                                                from tmp_control_total t
                                                where t.id_funcionario =
                                                      v_asistencia.id_funcionario
                                                  and t.fecha = v_record_fecha.dia) then
                                            insert into tmp_control_total(codigo,
                                                                          fecha,
                                                                          gerencia,
                                                                          departamento,
                                                                          codigo_funcionario,
                                                                          id_funcionario,
                                                                          funcionario,
                                                                          cargo,
                                                                          hora,
                                                                          hora_cal,
                                                                          retraso,
                                                                          ruta,
                                                                          nivel_ordernar,
                                                                          motivo)
                                            values (v_asistencia.codigo_ger,
                                                    v_record_fecha.dia::date,
                                                    v_asistencia.gerencia,
                                                    v_asistencia.departamento,
                                                    v_asistencia.codigo,
                                                    v_asistencia.id_funcionario,
                                                    v_asistencia.funcioanrio,
                                                    v_asistencia.cargo,
                                                    '00:00:00'::time,
                                                    '00:00:00'::time,
                                                    'si',
                                                    v_asistencia.ruta,
                                                    v_asistencia.nivel,
                                                    'Ausente');
                                        end if;
                                    end if;
                                end if;
                            end if;
                        end loop;
                end loop;

            if (v_parametros.tipo_filtro = 'todo') then
                v_filtro = 'where tm.retraso in (''si'',''no'') ';
            else
                v_filtro = 'where tm.retraso = ''si'' ';

            end if;
            v_consulta := 'select  tm.codigo,
                                   to_char(tm.fecha,''DD/MM/YYYY'') as fecha,
                                   tm.gerencia,
                                   initcap(tm.departamento) as departamento,
                                   tm.codigo_funcionario,
                                   tm.id_funcionario,
                                   tm.funcionario,
                                   tm.cargo,
                                   tm.hora,
                                   tm.hora_cal,
                                   tm.retraso,
                                   tm.ruta,
                                   tm.nivel_ordernar,
                                   tm.motivo,
                                   ''a''::varchar as nivel
                            from tmp_control_total tm '
                              || v_filtro || '
                            union all
                            select tm.codigo,
                                   null::text               as fecha,
                                   tm.gerencia,
                                   initcap(tm.departamento) as departamento,
                                   tm.codigo_funcionario,
                                   tm.id_funcionario,
                                   tm.funcionario,
                                   tm.cargo,
                                   null::time               as hora,
                                   COALESCE(sum(tm.hora_cal)::time, ''00:00:00''::time) as hora_cal,
                                   null::varchar            as retraso,
                                   tm.ruta,
                                   tm.nivel_ordernar,
                                   null::varchar as motivo,
                                   ''b''::varchar as nivel
                        from tmp_control_total tm '
                              || v_filtro || '
                        group by tm.codigo,
                                 tm.gerencia,
                                 tm.departamento,
                                 tm.codigo_funcionario,
                                 tm.id_funcionario,
                                 tm.funcionario,
                                 tm.cargo, tm.ruta, tm.nivel_ordernar
                        order by ruta, nivel_ordernar, funcionario, fecha, nivel ';

            --Devuelve la respuesta
            return v_consulta;
        end;
        /*********************************
      #TRANSACCION:  'ASIS_RARR_SEL'
      #DESCRIPCION:    REPORTE DE RETRASOS
      #AUTOR:        MMV
      #FECHA:        07/04/2021
      ***********************************/
    elsif (p_transaccion = 'ASIS_RARR_SEL') then

        begin
            --Sentencia de la consulta

            create temporary table tmp_biometrico
            (
                pin   varchar,
                fecha date,
                hora  time
            ) on commit drop;

            insert into tmp_biometrico
            (pin,
             fecha,
             hora)
            select p.pin,
                   p.fecha,
                   to_char(p.hora, 'HH24:MI:SS')::time as hora
            from asis.tpersona_transaccion p
            where p.dev_alias in
                  ('ACCESO_SOT1', 'barrera1', 'barrera2', 'barrera3', 'barrera4', 'ALM_ACC260')
              and to_char(p.fecha, 'DD/MM/YYYY')::date between v_parametros.fecha_ini::date and v_parametros.fecha_fin::date;

            insert into tmp_biometrico
            (pin,
             fecha,
             hora)
            select h.pin::varchar                               as pin,
                   h.tiempo_evento::date                        as fecha,
                   to_char(h.tiempo_evento, 'HH24:MI:SS')::time as hora
            from asis.thuella_sotano h
            where h.dispositivo = 'FV18_SOT_ASIST'
              and h.tiempo_evento::date between v_parametros.fecha_ini::date and v_parametros.fecha_fin::date
              and h.pin is not null;

            CREATE TEMPORARY TABLE tmp_retraso
            (
                codigo             varchar,
                fecha              date,
                gerencia           varchar,
                departamento       text,
                codigo_funcionario varchar,
                id_funcionario     integer,
                funcionario        text,
                cargo              text,
                hora               time,
                hora_cal           time,
                retraso            varchar,
                ruta               text,
                nivel_ordernar     integer
            ) ON COMMIT DROP;

            for v_asistencia in (
                with biometrico as (select bo.pin::integer as pin,
                                           bo.fecha,
                                           min(bo.hora)    as hora
                                    from tmp_biometrico bo
                                    group by bo.fecha, bo.pin)
                select fc.id_funcionario,
                       fc.codigo,
                       fc.funcioanrio,
                       fc.cargo,
                       fc.id_gerencia,
                       fc.codigo_ger,
                       fc.gerencia,
                       fc.nombre_uo_centro                 as departamento,
                       fc.ruta,
                       fc.nivel,
                       bo.fecha,
                       COALESCE(bo.hora, '00:00:00'::time) as hora
                from asis.vfuncionario_centro_costo fc
                         inner join biometrico bo on bo.pin = fc.codigo
                where fc.fecha_asignacion <= v_parametros.fecha_ini::date
                  and (fc.fecha_finalizacion is null or
                       fc.fecha_finalizacion >= v_parametros.fecha_fin::date)
                  and (case
                           when v_parametros.id_uo is null then 0 = 0
                           else fc.id_gerencia = v_parametros.id_uo
                    end)
            )
                loop


                    v_dia = case extract(dow from v_asistencia.fecha::date)
                                when 1 then 'lunes'
                                when 2 then 'martes'
                                when 3 then 'miercoles'
                                when 4 then 'jueves'
                                when 5 then 'viernes'
                                when 6 then 'sabado'
                                else 'domingo'
                        end;

                    v_consulta_rango = 'select rh.hora_entrada
                                        from asis.trango_horario rh
                                        inner join asis.tasignar_rango ar on ar.id_rango_horario = rh.id_rango_horario
                                        where  ar.desde <=''' || v_parametros.fecha_ini::date ||
                                       '''::date and (ar.hasta is null or ar.hasta >= '''
                                           || v_parametros.fecha_fin::date || '''::date) and ar.id_uo = ' ||
                                       v_asistencia.id_gerencia || ' and rh.' || v_dia || ' = ''si'' ';


                    execute (v_consulta_rango) into v_hora;

                    v_hora_resultado = v_asistencia.hora::time;
                    v_retraso = 'no';

                    if (v_asistencia.hora::time > v_hora::time) then

                        v_hora_resultado = v_asistencia.hora::time - v_hora::time;
                        v_retraso = 'si';

                        insert into tmp_retraso(codigo,
                                                fecha,
                                                gerencia,
                                                departamento,
                                                codigo_funcionario,
                                                id_funcionario,
                                                funcionario,
                                                cargo,
                                                hora,
                                                hora_cal,
                                                retraso,
                                                ruta,
                                                nivel_ordernar)
                        values (v_asistencia.codigo_ger,
                                v_asistencia.fecha::date,
                                v_asistencia.gerencia,
                                v_asistencia.departamento,
                                v_asistencia.codigo,
                                v_asistencia.id_funcionario,
                                v_asistencia.funcioanrio,
                                v_asistencia.cargo,
                                v_asistencia.hora,
                                COALESCE(v_hora_resultado, '00:00:00'::time),
                                v_retraso,
                                v_asistencia.ruta,
                                v_asistencia.nivel);
                    end if;

                end loop;

            v_filtro = '';

            v_consulta := 'select   r.codigo,
                                    r.gerencia ,
                                    initcap(r.departamento) as departamento,
                                    r.codigo_funcionario,
                                    r.funcionario,
                                    r.cargo,
                                    sum(r.hora_cal)::time as hora_cal,
                                    r.retraso
                           from tmp_retraso r
                           group by  r.codigo,
                                     r.gerencia,
                                     r.departamento,
                                     r.codigo_funcionario,
                                     r.funcionario,
                                     r.cargo,
                                     r.retraso, r.ruta, r.nivel_ordernar ' ||
                          'order by r.ruta, r.nivel_ordernar, r.funcionario';
            --Devuelve la respuesta
            return v_consulta;

        end;
    else

        raise exception 'Transaccion inexistente';

    end if;
EXCEPTION

    WHEN OTHERS THEN
        v_resp = '';
        v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', SQLERRM);
        v_resp = pxp.f_agrega_clave(v_resp, 'codigo_error', SQLSTATE);
        v_resp = pxp.f_agrega_clave(v_resp, 'procedimientos', v_nombre_funcion
            );
        raise exception '%',v_resp;
END;
$body$
    LANGUAGE 'plpgsql'
    VOLATILE
    CALLED ON NULL INPUT
    SECURITY INVOKER
    PARALLEL UNSAFE
    COST 100;

ALTER FUNCTION asis.f_reportes_sel (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
    OWNER TO postgres;