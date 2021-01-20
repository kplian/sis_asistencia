CREATE OR REPLACE FUNCTION asis.f_reportes_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.f_reportes_sel
 DESCRIPCION:   Funcion para Reportes
 AUTOR: 		 (miguel.mamani)
 FECHA:	        29-08-2019
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
#15		etr			02-09-2019			MMV               	Reporte Transacción marcados ASIS_RET_SEL
#16		etr			04-09-2019			MMV               	Modificaciones reporte marcados ASIS_REF_SEL
#0		etr			15-11-2019			SAZP               	Modificaciones reporte marcados ASIS_RPT_MAR_GRAL

 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
    v_resp				varchar;
    v_record			record;
    v_funcionario		record;
	v_consulta_			varchar;
    v_filtro			varchar;
    v_fil				varchar;
    v_marcado			record;
    v_id_funcionario	integer;
    v_fecha_ini         date;
    v_fecha_fin         date;
    v_acumulado_record	record;
    v_dia_saldo			numeric;
    v_acumulado			record;

BEGIN

	v_nombre_funcion = 'asis.f_reportes_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'ASIS_RETO_SEL' #15
 	#DESCRIPCION:	Reporte de retrasos
 	#AUTOR:		miguel.mamani
 	#FECHA:		29/08/2019
	***********************************/

	if(p_transaccion='ASIS_RETO_SEL')then
    	begin
    		--Sentencia de la consulta

        CREATE TEMPORARY TABLE tmp_ret (  dia varchar,
        								  fecha_marcado date,
                                          hora varchar,
                                          id_funcionario integer,
                                          codigo_funcionario varchar,
                                          nombre_funcionario varchar,
                                          departamento	varchar,
                                          tipo_evento varchar,
                                          modo_verificacion varchar,
        								  nombre_dispositivo varchar,
                						  numero_tarjeta varchar,
                                          nombre_area varchar,
                                          codigo_evento varchar,
                                          id_uo integer ) ON COMMIT DROP;
        v_filtro = '';
    	if v_parametros.hora_ini is not null and v_parametros.hora_fin is not null then
        	  v_filtro = 'and to_char(tr.event_time, ''HH24:MI'')::time BETWEEN '''|| to_char(v_parametros.hora_ini,'HH24:MI')::time || '''and'''||to_char(v_parametros.hora_fin,'HH24:MI')::time||''' ';
        end if;
        if v_parametros.hora_ini is not null and v_parametros.hora_fin is null then
        	  v_filtro = 'and to_char(tr.event_time, ''HH24:MI'')::time >= '''|| to_char(v_parametros.hora_ini,'HH24:MI')::time||''' ';
        end if;
        if v_parametros.hora_ini is null and v_parametros.hora_fin is not null then
        	  v_filtro = 'and to_char(tr.event_time, ''HH24:MI'')::time <= '''|| to_char(v_parametros.hora_fin,'HH24:MI')::time||''' ';
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
                            where tr.event_time::date BETWEEN '''|| v_parametros.fecha_ini||''' and '''||v_parametros.fecha_fin||
                            '''';
        v_consulta_:= v_consulta_ || v_filtro;
        v_consulta_:= v_consulta_ || 'order by fecha_marcado';
            for v_record in EXECUTE(v_consulta_) loop

               select distinct on (ca.id_funcionario) ca.id_funcionario, ca.desc_funcionario1,ca.codigo,ca.nombre_unidad,ca.id_uo
               			into v_funcionario
                        from orga.vfuncionario_cargo ca
                        inner join orga.tcargo car on car.id_cargo = ca.id_cargo
						inner join orga.ttipo_contrato tc on car.id_tipo_contrato = tc.id_tipo_contrato
                        where tc.codigo in ('PLA', 'EVE')
                        and ca.fecha_asignacion <= v_parametros.fecha_fin and (ca.fecha_finalizacion is null or ca.fecha_finalizacion >= v_parametros.fecha_ini)
                        and trim(both 'FUNODTPR' from ca.codigo) = v_record.codigo_funcionario::varchar
                        order by ca.id_funcionario, ca.fecha_asignacion desc;

                 insert into tmp_ret (  dia,
                                        fecha_marcado,
                                        hora,
                                        id_funcionario,
                                        codigo_funcionario,
                                        nombre_funcionario,
                                        departamento,
                                        tipo_evento,
                                        modo_verificacion,
                                        nombre_dispositivo,
                                        numero_tarjeta,
                                        nombre_area,
                                        codigo_evento,
                                        id_uo
                                        )values (
                                        v_record.dia,
                                        v_record.fecha_marcado,
                                        v_record.hora,
                                        v_funcionario.id_funcionario,
                                        v_record.codigo_funcionario::varchar,
                                        v_funcionario.desc_funcionario1,
                                        v_funcionario.nombre_unidad,
                                        translate(v_record.tipo_evento::text,'áéíóúÁÉÍÓÚäëïöüÄËÏÖÜ','aeiouAEIOUaeiouAEIOU'),
                                        v_record.modo_verificacion::varchar,
                                        v_record.nombre_dispositivo,
                                        v_record.numero_tarjeta,
                                        v_record.nombre_area,
                                        v_record.codigo_evento,
                                        v_funcionario.id_uo
                                        );

            end loop;

            v_fil = '0 = 0';

            if v_parametros.id_funcionario is not null then
            	v_fil = 't.id_funcionario = '|| v_parametros.id_funcionario;
            end if;
            if v_parametros.modo_verif != '' then
        		v_fil:= v_fil||' and t.modo_verificacion = '''||v_parametros.modo_verif||''' ';
       		 end if;
            if v_parametros.evento != '' then
                v_fil:= v_fil||' and t.codigo_evento = '''||v_parametros.evento||''' ';
            end if;
			v_consulta:='select t.dia,
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
            v_consulta:= v_consulta || v_fil;
            v_consulta:= v_consulta || 'order by gerencia desc, hora, tipo_evento,nombre_funcionario';
			return v_consulta;

		end;

    /*********************************
 	#TRANSACCION:  'ASIS_RE_SEL' # 16
 	#DESCRIPCION:	Reporte de retrasos funcionarios
 	#AUTOR:		miguel.mamani
 	#FECHA:		29/08/2019
	***********************************/
	elsif(p_transaccion='ASIS_RE_SEL')then
    	begin
            CREATE TEMPORARY TABLE tmp_retr (   dia varchar,
                                                fecha_marcado date,
                                                hora varchar,
                                                id_funcionario integer,
                                                codigo_funcionario varchar,
                                                nombre_funcionario varchar,
                                                nombre_cargo varchar,
                                                tipo_evento varchar,
                                                modo_verificacion varchar,
                                                nombre_dispositivo varchar,
                                                codigo_evento varchar,
                                                gerencia varchar,
                                                departamento varchar ) ON COMMIT DROP;

        for v_record in (with funcionario as (select distinct on (ca.id_funcionario) ca.id_funcionario,
                                                    ca.desc_funcionario1,
                                                    trim(both 'FUNODTPR' from ca.codigo) as codigo,
                                                    ca.nombre_cargo,
                                                    ger.nombre_unidad as gerencia,
                                                    dep.nombre_unidad as departamento
                                                    from orga.vfuncionario_cargo ca
                                                    inner join orga.tcargo car on car.id_cargo = ca.id_cargo
                                                    inner join orga.ttipo_contrato tc on car.id_tipo_contrato = tc.id_tipo_contrato
                                                    inner join orga.tuo ger on ger.id_uo = orga.f_get_uo_gerencia(ca.id_uo, NULL::integer, NULL::date)
                                                    inner join orga.tuo dep ON dep.id_uo = orga.f_get_uo_departamento(ca.id_uo, NULL::integer, NULL::date)
                                                    where tc.codigo in ('PLA', 'EVE')
                                                    and ca.fecha_asignacion <= v_parametros.fecha_fin and (ca.fecha_finalizacion is null or ca.fecha_finalizacion >= v_parametros.fecha_ini)
                                                    order by ca.id_funcionario, ca.fecha_asignacion desc),
                                       marcador as (select  tm.codigo_funcionario,
                                                               tm.fecha_marcado,
                                                               tm.dia,
                                                               min(tm.hora) as hora,
                                                               tm.codigo_evento,
                                                               tm.tipo_evento,
                                                               tm.modo_verificacion,
                                                               tm.nombre_dispositivo
                                                        from asis.vtransaccion_marcados  tm
                                                        where tm.fecha_marcado BETWEEN v_parametros.fecha_ini and v_parametros.fecha_fin
                                                        group by tm.codigo_funcionario,
                                                                 tm.fecha_marcado,
                                                                 tm.dia,
                                                                 tm.codigo_evento,
                                                                 tm.tipo_evento,
                                                                 tm.modo_verificacion,
                                                                 tm.nombre_dispositivo
                                                        		 order by fecha_marcado asc, hora asc)
                  select 	ma.dia,
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
                  inner join marcador ma on ma.codigo_funcionario = fu.codigo) loop

        					insert into tmp_retr ( 	dia,
                                                    fecha_marcado,
                                                    hora,
                                                    id_funcionario,
                                                    codigo_funcionario,
                                                    nombre_funcionario,
                                                    tipo_evento,
                                                    modo_verificacion,
                                                    nombre_dispositivo,
                                                    codigo_evento,
                                                    gerencia,
                                                    departamento,
                                                    nombre_cargo
                                                    )values (
                                                    v_record.dia,
                                                    v_record.fecha_marcado,
                                                    v_record.hora,
                                                    v_record.id_funcionario,
                                                    v_record.codigo,
                                                    v_record.desc_funcionario1,
                                                    v_record.tipo_evento,
                                                    v_record.modo_verificacion,
                                                    v_record.nombre_dispositivo,
                                                    v_record.codigo_evento,
                                                    v_record.gerencia,
                                                    v_record.departamento,
                                                    v_record.nombre_cargo
                                                    );

        end loop;

        v_filtro = '0 = 0 ';
    	if v_parametros.hora_ini is not null and v_parametros.hora_fin is not null then
        	  v_filtro = 'tmp.hora BETWEEN '''|| to_char(v_parametros.hora_ini,'HH24:MI')::time || '''and'''||to_char(v_parametros.hora_fin,'HH24:MI')::time||''' ';
        end if;
        if v_parametros.hora_ini is not null and v_parametros.hora_fin is null then
        	  v_filtro = 'tmp.hora >= '''|| to_char(v_parametros.hora_ini,'HH24:MI')::time||''' ';
        end if;
        if v_parametros.hora_ini is null and v_parametros.hora_fin is not null then
        	  v_filtro = 'tmp.hora <= '''|| to_char(v_parametros.hora_fin,'HH24:MI')::time||''' ';
        end if;

        if v_parametros.id_funcionario is not null then
          v_filtro:= v_filtro || ' and tmp.id_funcionario = '|| v_parametros.id_funcionario;
        end if;
        if v_parametros.modo_verif != '' then
            v_filtro:= v_filtro||' and tmp.modo_verificacion = '''||v_parametros.modo_verif||''' ';
        end if;
        if v_parametros.evento != '' then
            v_filtro:= v_filtro||' and tmp.codigo_evento = '''||v_parametros.evento||''' ';
        end if;

        v_consulta:= 'select  tmp.dia,
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
        v_consulta:= v_consulta || v_filtro;
        if (v_parametros.agrupar_por = 'etr')then
                v_consulta:= v_consulta || 'order by gerencia desc, departamento,fecha_marcado,hora,nombre_funcionario';
        elsif(v_parametros.agrupar_por = 'gerencias')then
        		v_consulta:= v_consulta || 'order by gerencia desc, fecha_marcado,hora,nombre_funcionario';
        elsif(v_parametros.agrupar_por = 'departamentos')then
        		v_consulta:= v_consulta || 'order by departamento desc, fecha_marcado,hora,nombre_funcionario';
        end if;
        return v_consulta;
    end;
    /*********************************
 	#TRANSACCION:  'ASIS_RPT_MAR'
 	#DESCRIPCION:	Reporte de marcado de funcionarios
 	#AUTOR:		szambrana
 	#FECHA:		02/10/2019
	***********************************/
    elseif (p_transaccion='ASIS_RPT_MAR') then
		begin

    		--Sentencia de la consulta
   			v_consulta:= 'SELECT
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
                            WHERE bio.id_funcionario = '||v_parametros.id_funcionario||' AND bio.fecha_marcado::date BETWEEN '''|| v_parametros.fecha_ini ||''' AND '''||v_parametros.fecha_fin||''' ';

			--Devuelve la respuesta
			return v_consulta;
		end;
    /*********************************
 	#TRANSACCION:  'ASIS_RPT_MAR_GRAL'
 	#DESCRIPCION:	Reporte de marcado de funcionarios por columnas
 	#AUTOR:		szambrana
 	#FECHA:		02/10/2019
	***********************************/
    elseif (p_transaccion='ASIS_RPT_MAR_GRAL') then
		begin
    		--Sentencia de la consulta
			v_consulta:= 'SELECT *
            				FROM crosstab($$
                            SELECT
                                  bio.fecha ||'' | ''|| vfu.desc_funcionario1 ||'' | ''|| ger.nombre_unidad::varchar AS fecha_usr,
                                  bio.pivot,
                                  bio.hora
                            FROM asis.ttransacc_zkb_etl bio
                            INNER JOIN orga.vfuncionario_cargo vfu ON bio.id_funcionario = vfu.id_funcionario
                            INNER JOIN orga.tuo ger on ger.id_uo = orga.f_get_uo_departamento(vfu.id_uo, NULL::integer, NULL::date)
                            WHERE bio.id_funcionario = '||v_parametros.id_funcionario||' AND bio.rango = ''si''   AND bio.fecha::date BETWEEN '''|| v_parametros.fecha_ini ||''' AND '''||v_parametros.fecha_fin||'''
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
 	#DESCRIPCION:	Reporte Reporte saldo
 	#AUTOR:		MMV
 	#FECHA:		11/09/2019
	***********************************/
	elsif(p_transaccion='ASIS_SAL_SEL')then

    	begin
        --Sentencia de la consulta


        CREATE TEMPORARY TABLE temporal_saldo ( id_funcionario integer,
                                                codigo varchar,
                                                desc_funcionario1 varchar,
                                                fecha_contrato date,
                                                gerencia varchar,
                                                departamento varchar,
                                                gestion integer,
                                                fecha_caducado date,
                                                fecha_acomulado date,
                                                saldo numeric ) ON COMMIT DROP;

        for  v_record in (select  funs.id_funcionario,
                                  funs.codigo,
                                  funs.desc_funcionario2,
                                  funs.fecha_contrato,
                                  funs.gerencia,
                                  funs.departamento,
                                  sum(coalesce(mm.dias, 0)) as saldo
                          from (
                          select distinct on (uofun.id_funcionario) uofun.id_funcionario,
                                trim(both 'FUNODTPR' from  fun.codigo)::varchar as codigo,
                                fun.desc_funcionario2,
                                ger.nombre_unidad as gerencia,
                                dep.nombre_unidad as departamento,
                                plani.f_get_fecha_primer_contrato_empleado(uofun.id_uo_funcionario, uofun.id_funcionario, uofun.fecha_asignacion) as fecha_contrato

                          from orga.tuo_funcionario uofun
                          inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
                          inner join orga.ttipo_contrato tc on car.id_tipo_contrato = tc.id_tipo_contrato
                          inner join orga.vfuncionario fun on fun.id_funcionario = uofun.id_funcionario
                          inner join orga.tuo ger ON ger.id_uo = orga.f_get_uo_gerencia(uofun.id_uo, NULL::integer, NULL::date)
                          inner join orga.tuo dep ON dep.id_uo = orga.f_get_uo_departamento(uofun.id_uo, NULL::integer, NULL::date)
                          where tc.codigo in ('PLA','EVE') and UOFUN.tipo = 'oficial' and
                          uofun.fecha_asignacion <= v_parametros.fecha_fin::date and
                          (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >= v_parametros.fecha_fin::date) AND
                          uofun.estado_reg != 'inactivo' and
                              (case
                          			when v_parametros.id_funcionario is null then
                                    0 = 0
                                    else
                                    uofun.id_funcionario = v_parametros.id_funcionario
                                    end )
                                    and
                                   (case
                          			when v_parametros.id_tipo_contrato is null then
                                    0 = 0
                                    else
                                    tc.id_tipo_contrato = v_parametros.id_tipo_contrato
                                    end )
                                    and
                                    (case
                                      when v_parametros.id_uo is null then
                                      0 = 0
                                      else
                                      (ger.id_uo = v_parametros.id_uo or dep.id_uo = v_parametros.id_uo)
                                      end )
                          order by uofun.id_funcionario, uofun.fecha_asignacion desc)funs
                          left join asis.tmovimiento_vacacion mm on mm.id_funcionario = funs.id_funcionario and  mm.estado_reg = 'activo' and mm.fecha_reg::date <= now()::date
                          group by  funs.id_funcionario,
                                    funs.codigo,
                                    funs.desc_funcionario2,
                                    funs.fecha_contrato,
                                    funs.gerencia,
                                    funs.departamento
                          order by gerencia, departamento, desc_funcionario2) loop

            select mo.fecha_reg::date as fecha_reg,
            	   mo.dias
                   into
                   v_acumulado
            from asis.tmovimiento_vacacion mo
            where mo.tipo = 'ACUMULADA' 
                  and mo.id_funcionario = v_record.id_funcionario
            	  and mo.estado_reg = 'activo' 
                  and mo.fecha_reg::date = (select max(m.fecha_reg::date)
                  							from asis.tmovimiento_vacacion m
                                            where m.tipo = 'ACUMULADA' 
                                            and m.dias != 0                                 
                                            and m.id_funcionario = v_record.id_funcionario);

				
            --    raise notice  '------------------saldo %  acumulado % ------------------------',v_record.saldo, v_acumulado.dias;
                
                
                if (v_record.saldo > v_acumulado.dias) then



                      perform asis.f_calcular_saldo_gestion(v_acumulado.fecha_reg,
                      									    v_acumulado.dias,
                                                            v_record,
                                                            v_record.saldo);


                else

                	  insert into temporal_saldo (id_funcionario,
                                                    codigo,
                                                    desc_funcionario1,
                                                    fecha_contrato,
                                                    gerencia,
                                                    departamento,
                                                    fecha_caducado,
                                                    gestion,
                                                    fecha_acomulado,
                                                    saldo
                                                    )values(
                                                    v_record.id_funcionario,
                                                    v_record.codigo,
                                                    v_record.desc_funcionario2,
                                                    v_record.fecha_contrato,
                                                    v_record.gerencia,
                                                    v_record.departamento,
                                                    v_acumulado.fecha_reg,
                                                    extract(year from COALESCE(v_acumulado.fecha_reg,now())),
                                                    v_acumulado.fecha_reg,
                                                    v_record.saldo
                                                    );

                end if;


        end loop;


              	v_consulta:='select  trim(both ''FUNODTPR'' from  ts.codigo)::varchar as codigo,
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
 	#DESCRIPCION:	No funciona
 	#AUTOR:		MMV
 	#FECHA:		11/09/2019
	***********************************/
	elsif(p_transaccion='ASIS_VENS_SEL')then

    	begin
           --Sentencia de la consulta
           v_consulta:='';
		   --Devuelve la respuesta
            return v_consulta;

		end;


    /*********************************
 	#TRANSACCION:  'ASIS_ANT_SEL'
 	#DESCRIPCION:	Reporte Reporte Anticipo
 	#AUTOR:		MMV
 	#FECHA:		11/09/2019
	***********************************/
	elsif(p_transaccion='ASIS_ANT_SEL')then

    	begin
        --Sentencia de la consulta
        		v_filtro = '';

                if (v_parametros.id_funcionario is not null )then
                	v_filtro = 'and uofun.id_funcionario = '||v_parametros.id_funcionario||'';
                end if;

                if (v_parametros.id_tipo_contrato is not null) then
                    v_filtro = 'and  tc.id_tipo_contrato = '||v_parametros.id_tipo_contrato;
                end if;

         		if (v_parametros.id_uo is not null )then
                	v_filtro = 'and (ger.id_uo = '||v_parametros.id_uo ||' or dep.id_uo = '||v_parametros.id_uo ||')';
                end if;

         	v_consulta:='select  fun.desc_funcionario2,
            					 fun.codigo ,
                                 fun.gerencia,
                                 fun.departamento,
                                 (
                                  case
                                      when (select sum(coalesce(mm.dias, 0))
                                      from asis.tmovimiento_vacacion mm
                                      where   mm.id_funcionario = fun.id_funcionario
                                      and mm.fecha_reg::date <= '''||v_parametros.fecha_fin||'''::date
                                      and mm.estado_reg = ''activo'') < 0 then

                                      (select -1 * sum(coalesce(mm.dias, 0))
                                        from asis.tmovimiento_vacacion mm
                                        where   mm.id_funcionario = fun.id_funcionario
                                        and mm.fecha_reg::date <= '''||v_parametros.fecha_fin||'''::date
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
                                  uofun.fecha_asignacion <=  '''||v_parametros.fecha_fin||'''::date and
                                  (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >=  '''||v_parametros.fecha_fin||'''::date) AND
                                  uofun.estado_reg != ''inactivo'' '||v_filtro||'
                                  order by uofun.id_funcionario, uofun.fecha_asignacion desc) fun
                                  order by gerencia, departamento, desc_funcionario2 asc';

		   --Devuelve la respuesta
            return v_consulta;

		end;

    /*********************************
 	#TRANSACCION:  'ASIS_AHT_SEL'
 	#DESCRIPCION:	Reporte Historico vacaciones
 	#AUTOR:		MMV
 	#FECHA:		15/09/2019
	***********************************/
	elsif(p_transaccion='ASIS_AHT_SEL')then

    	begin
        --Sentencia de la consulta

        v_consulta:= 'select  fun.id_funcionario,
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
                          uofun.estado_reg != ''inactivo'' and uofun.id_funcionario = '||v_parametros.id_funcionario||'
                          order by uofun.id_funcionario, uofun.fecha_asignacion desc ) fun
                          left join asis.tmovimiento_vacacion mv on mv.id_funcionario = fun.id_funcionario and  mv.estado_reg = ''activo''
                          order by mv.fecha_reg';




		   --Devuelve la respuesta
            return v_consulta;

		end;

     /*********************************
 	#TRANSACCION:  'ASIS_VPR_SEL'
 	#DESCRIPCION:	Reporte Personas en vacacion
 	#AUTOR:		MMV
 	#FECHA:		15/09/2019
	***********************************/
	elsif(p_transaccion='ASIS_VPR_SEL')then

    	begin
        --Sentencia de la consulta


        	v_filtro = '';


            if (v_parametros.id_funcionario is not null) then

            	v_filtro = 'and uofun.id_funcionario = '||v_parametros.id_funcionario;

            end if;


            if (v_parametros.id_uo is not null) then

            	 v_filtro = ' and (ger.id_uo = ' || v_parametros.id_uo || 'or dep.id_uo ='||v_parametros.id_uo||')';

            end if;

         	v_consulta:='select   funs.gerencia,
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
                                  funs.tipo_contrato
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
                          uofun.fecha_asignacion <= '''||v_parametros.fecha_fin||'''::date and
                          (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >= '''||v_parametros.fecha_ini||''' ::date) AND
                          uofun.estado_reg != ''inactivo'' '||v_filtro||'
                          order by uofun.id_funcionario, uofun.fecha_asignacion desc)funs
                          inner join asis.tmovimiento_vacacion mm on mm.id_funcionario = funs.id_funcionario
                          where mm.tipo = ''TOMADA'' and mm.estado_reg = ''activo'' and mm.desde::date >= '''||v_parametros.fecha_ini||''' ::date and mm.hasta::date <='''||v_parametros.fecha_fin||'''::date
                          order by gerencia, departamento,tipo_contrato, desc_funcionario2 asc';

            --Devuelve la respuesta

        	raise notice '%',v_consulta;
            return v_consulta;

		end;

      /*********************************
 	#TRANSACCION:  'ASIS_VARU_SEL'
 	#DESCRIPCION:	Reporte Resumen de vacaciones
 	#AUTOR:		MMV
 	#FECHA:		15/09/2019
	***********************************/
	elsif(p_transaccion='ASIS_VARU_SEL')then

    	begin
        --Sentencia de la consulta


        -- raise exception '%',v_parametros.id_tipo_contrato;  tc.id_tipo_contrato
        v_filtro = '';


            if (v_parametros.id_funcionario is not null) then

            	v_filtro = 'and uofun.id_funcionario = '||v_parametros.id_funcionario;

            end if;


            if (v_parametros.id_uo is not null) then

            	 v_filtro = ' and (ger.id_uo = ' || v_parametros.id_uo || 'or dep.id_uo ='||v_parametros.id_uo||')';

            end if;

             if (v_parametros.id_tipo_contrato is not null) then

            	v_filtro = 'and  tc.id_tipo_contrato = '||v_parametros.id_tipo_contrato;

            end if;


         	v_consulta:='select   ant.desc_funcionario2,
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
                                           mm.fecha_reg::date <='''||v_parametros.fecha_fin||'''::date
                                           and mm.estado_reg =  ''activo''
                                     group by mm.id_funcionario),
                       tomada as (select  mm.id_funcionario,
                                           sum(coalesce(mm.dias, 0))as saldo_tomada
                                   from asis.tmovimiento_vacacion mm
                                   where mm.tipo = ''TOMADA'' and
                                          mm.fecha_reg::date <='''||v_parametros.fecha_fin||'''::date
                                          and mm.estado_reg =  ''activo''
                                   group by mm.id_funcionario),
                        caducada as (select mm.id_funcionario,
                                            sum(coalesce(mm.dias, 0))  as saldo_caducado
                                    from asis.tmovimiento_vacacion mm
                                    where mm.tipo = ''CADUCADA'' and
                                             mm.fecha_reg::date <='''||v_parametros.fecha_fin||'''::date
                                             and mm.estado_reg =  ''activo''
                                    group by mm.id_funcionario),
                       anticipo as (select mm.id_funcionario,
                                            sum(coalesce(mm.dias, 0)) as saldo_anticipo
                                    from asis.tmovimiento_vacacion mm
                                    where mm.tipo = ''ANTICIPO'' and
                                              mm.fecha_reg::date <='''||v_parametros.fecha_fin||'''::date
                                              and mm.estado_reg =  ''activo''
                                    group by mm.id_funcionario),
                        pagado as (select mm.id_funcionario,
                                           sum(coalesce(mm.dias, 0)) as saldo_pagado
                                   from asis.tmovimiento_vacacion mm
                                   where mm.tipo = ''PAGADO'' and
                                           mm.fecha_reg::date <='''||v_parametros.fecha_fin||'''::date
                                           and mm.estado_reg =  ''activo''
                                   group by mm.id_funcionario),
                         saldo as (select mm.id_funcionario,
                                           sum(coalesce(mm.dias, 0)) as saldo
                                   from asis.tmovimiento_vacacion mm
                                   where  mm.fecha_reg::date <='''||v_parametros.fecha_fin||'''::date
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
                              uofun.fecha_asignacion <= '''||v_parametros.fecha_fin||'''::date and
                              (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >= '''||v_parametros.fecha_fin||'''::date) AND
                              uofun.estado_reg != ''inactivo'' '||v_filtro||'
                              order by uofun.id_funcionario, uofun.fecha_asignacion desc   ) ant
                              order by desc_funcionario2 asc';
		   --Devuelve la respuesta
            return v_consulta;

		end;

	else

		raise exception 'Transaccion inexistente';

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