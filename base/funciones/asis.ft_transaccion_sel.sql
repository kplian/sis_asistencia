CREATE OR REPLACE FUNCTION asis.ft_transaccion_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.ft_transaccion_bio_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.ttransaccion_bio'
 AUTOR: 		 (miguel.mamani)
 FECHA:	        06-09-2019 13:08:03
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				06-09-2019 13:08:03							Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.ttransaccion_bio'
 #29			18-10-2019				SAZP				Reporte marcados del funcionario
 ***************************************************************************/

DECLARE

	v_consulta    		varchar;
	v_parametros  		record;
	v_nombre_funcion   	text;
	v_resp				varchar;

    v_fecha_ini			date;
    v_fecha_fin			date;
    v_record			record;
    v_time				timestamp;
    v_index				integer;
    v_calcular			integer;
    v_result			timestamp[];
    v_one				numeric;

BEGIN

	v_nombre_funcion = 'asis.ft_transaccion_bio_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'ASIS_BIO_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		miguel.mamani
 	#FECHA:		06-09-2019 13:08:03
	***********************************/

	if(p_transaccion='ASIS_BIO_SEL')then

    	begin
          ---Obtener el id funcionario
    /*    if v_parametros.id_funcionario is null then
        	raise exception 'Usted no esta registrado como funcionario';
        end if;*/


        select p.fecha_ini, p.fecha_fin into v_fecha_ini,v_fecha_fin
        from param.tperiodo p
        where p.id_periodo = v_parametros.id_periodo;

 		-- raise exception '% -> %',v_fecha_ini,v_fecha_fin;
    		--Sentencia de la consulta
			v_consulta:='select
                              bio.id,
                              bio.id_funcionario,
                              bio.pin as codigo_funcionario,
                              initcap(bio.area_name)::varchar as nombre_area,
                              bio.verify_mode_name as verificacion,
                              bio.event_name as evento,
                              bio.pivot,
                              bio.rango,
                              initcap(fun.desc_funcionario1) as desc_funcionario1,
                              EXTRACT(MONTH FROM bio.event_time::date)::integer as periodo,
                              to_char(event_time::date,''DD/MM/YYYY'') || '' - ''||initcap (asis.f_obtener_dia_literal(event_time::date))::text as fecha_registro,
                              to_char(bio.event_time, ''HH24:MI'')::varchar as hora,
                              to_char(bio.event_time, ''DD''::text)::integer as dia,
                              asis.f_estraer_palabra(bio.reader_name,''Entrada'',''Salida'')::varchar as accion,
                              initcap(asis.f_estraer_palabra(bio.reader_name,''barrera''))::varchar as dispocitvo,
                              bio.obs ,
                              ran.descripcion,
                              bio.id_rango_horario,
                              bio.reader_name
                          from
                            asis.ttransacc_zkb_etl bio
                            inner join orga.vfuncionario fun on fun.id_funcionario = bio.id_funcionario
                            left join asis.trango_horario ran on ran.id_rango_horario = bio.id_rango_horario
                            where bio.id_funcionario = '||v_parametros.id_funcionario||' and   bio.reader_name not in (select rn.name
																												      from asis.treader_no rn) and bio.event_name != ''Acceso denegado'' and event_time::date between '''||v_fecha_ini ||'''and '''||v_fecha_fin||''' and' ;

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ',hora asc ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
			--Devuelve la respuesta
            raise notice '%',v_consulta;
			return v_consulta;

		end;

	/*********************************
 	#TRANSACCION:  'ASIS_BIO_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		06-09-2019 13:08:03
	***********************************/

	elsif(p_transaccion='ASIS_BIO_CONT')then

		begin
          ---Obtener el id funcionario
        /*if v_parametros.id_funcionario is null then
        	raise exception 'Usted no esta registrado como funcionario';
        end if;*/

			--Sentencia de la consulta de conteo de registros
			v_consulta:='select  count (bio.id)
            			 from
                              asis.ttransacc_zkb_etl bio
                              inner join orga.vfuncionario fun on fun.id_funcionario = bio.id_funcionario
                              left join asis.trango_horario ran on ran.id_rango_horario = bio.id_rango_horario
                         where bio.id_funcionario = '||v_parametros.id_funcionario||' and   bio.reader_name not in (select rn.name
																												      from asis.treader_no rn) and bio.event_name != ''Acceso denegado'' and ';

			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
            raise notice '%',v_consulta;

			--Devuelve la respuesta
			return v_consulta;

		end;

    /*********************************
 	#TRANSACCION:  'ASIS_BIORPT_SEL'
 	#DESCRIPCION:	Consulta de datos
 	#AUTOR:		sazp
 	#FECHA:		21-10-2019 10:08:03
	***********************************/

	elseif(p_transaccion='ASIS_BIORPT_SEL')then

    	begin
    		--#29
            --Sentencia de la consulta
			v_consulta:='select bio.id_transaccion_bio,
                                bio.obs,
                                bio.estado_reg,
                                bio.id_periodo,
                                bio.hora::varchar,
                                bio.id_funcionario,
                                bio.fecha_marcado,
                                bio.id_rango_horario,
                                bio.id_usuario_reg,
                                bio.usuario_ai,
                                bio.fecha_reg,
                                bio.id_usuario_ai,
                                bio.id_usuario_mod,
                                bio.fecha_mod,
                                usu1.cuenta as usr_reg,
                                usu2.cuenta as usr_mod,
                                bio.evento,
                                bio.tipo_verificacion,
                                bio.area,
                                rh.descripcion as rango,
                                to_char(bio.fecha_marcado,''DD'')::text as dia,
                                bio.acceso,
                                vfun.desc_funcionario1 as nombre
                                from asis.ttransaccion_bio bio
                                inner join segu.tusuario usu1 on usu1.id_usuario = bio.id_usuario_reg
                                left join asis.trango_horario rh on rh.id_rango_horario = bio.id_rango_horario
                                left join segu.tusuario usu2 on usu2.id_usuario = bio.id_usuario_mod
                                inner join orga.vfuncionario vfun on vfun.id_funcionario = bio.id_funcionario
				        		where  bio.id_funcionario = '||v_parametros.id_funcionario|| ' and bio.id_periodo ='||v_parametros.id_periodo ||' order by bio.fecha_marcado, bio.hora';


			--Definicion de la respuesta
			raise notice '--> %',v_consulta;
			--Devuelve la respuesta
			return v_consulta;

		end;
    /*********************************
 	#TRANSACCION:  'ASIS_RFA_SEL'
 	#DESCRIPCION:	listar marcaciones
 	#AUTOR:		miguel.mamani
 	#FECHA:		06-09-2019 13:08:03
	***********************************/
    	elseif(p_transaccion='ASIS_RFA_SEL')then

    	begin
    		--Sentencia de la consulta
			v_consulta:='select	bio.id_transaccion_bio,
                                bio.id_funcionario,
                                bio.id_periodo,
                                bio.id_rango_horario,
                                to_char(bio.fecha_marcado,''DD'')::text as dia,
                                bio.fecha_marcado,
                                bio.hora,
                                bio.obs,
                                bio.evento,
                                bio.tipo_verificacion,
                                bio.area,
                                rh.descripcion as rango,
                                bio.acceso,
                                vfun.desc_funcionario1 as desc_funcionario,
                                dep.nombre_unidad as departamento,
                                bio.estado_reg
                                from asis.ttransaccion_bio bio
                                inner join orga.vfuncionario_cargo vfun on vfun.id_funcionario = bio.id_funcionario
                                inner join orga.tuo dep on dep.id_uo = orga.f_get_uo_departamento(vfun.id_uo, NULL::integer, NULL::date)
                                left join asis.trango_horario rh on rh.id_rango_horario = bio.id_rango_horario
                                where (vfun.fecha_finalizacion is null or vfun.fecha_finalizacion >= now()::date)
                                and ';
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			v_consulta:=v_consulta||' order by ' ||v_parametros.ordenacion|| ',hora ' || v_parametros.dir_ordenacion || ' limit ' || v_parametros.cantidad || ' offset ' || v_parametros.puntero;
			--Devuelve la respuesta
			return v_consulta;

		end;

    /*********************************
 	#TRANSACCION:  'ASIS_RFA_CONT'
 	#DESCRIPCION:	Conteo de registros
 	#AUTOR:		miguel.mamani
 	#FECHA:		06-09-2019 13:08:03
	***********************************/

    elsif(p_transaccion='ASIS_RFA_CONT')then

		begin
			--Sentencia de la consulta de conteo de registros
			v_consulta:=' select count( bio.id_transaccion_bio)
                          from asis.ttransaccion_bio bio
                          inner join orga.vfuncionario_cargo vfun on vfun.id_funcionario = bio.id_funcionario
                          inner join orga.tuo dep on dep.id_uo = orga.f_get_uo_departamento(vfun.id_uo, NULL::integer, NULL::date)
                          left join asis.trango_horario rh on rh.id_rango_horario = bio.id_rango_horario
                          where (vfun.fecha_finalizacion is null or vfun.fecha_finalizacion >= now()::date)
                          and ';
			--Definicion de la respuesta
			v_consulta:=v_consulta||v_parametros.filtro;
			--Devuelve la respuesta
			return v_consulta;

		end;

    /*********************************
 	#TRANSACCION:  'ASIS_REPOR_SEL'
 	#DESCRIPCION:	Reporte total horas
 	#AUTOR:		mgarcia
 	#FECHA:		12-03-2020
	***********************************/

	elsif(p_transaccion='ASIS_REPOR_SEL')then

		begin

               CREATE TEMPORARY TABLE tmp_marcas ( id serial,
                                                   funcionario text,
               									   fecha date,
                                                   inicio_one timestamp,
                                                   fin_one timestamp,
                                                   result_one numeric,
                                                   inicio_two timestamp,
                                                   fin_two timestamp,
                                                   result_two numeric,
                                                   total numeric) ON COMMIT DROP;

             select pe.fecha_ini,pe.fecha_fin
                  into
                  v_fecha_ini,
                  v_fecha_fin
             from param.tperiodo pe
             where pe.id_periodo = v_parametros.id_periodo;

            v_index = 1;
            v_calcular = 0;
            v_result = null;

            for v_record in (  select  initcap(fun.desc_funcionario1) as desc_funcionario1,
                                       etl.fecha,
                                       asis.array_sort(string_to_array(pxp.list(etl.event_time::text) ,',')) as marcas
                                from asis.ttransacc_zkb_etl etl
                                inner join orga.vfuncionario fun on fun.id_funcionario = etl.id_funcionario
                                where etl.id_funcionario = v_parametros.id_funcionario
                                      and etl.fecha between v_fecha_ini and v_fecha_fin
                                      and etl.rango = 'si'
                                group by fun.desc_funcionario1,
                                         etl.fecha
                                order by etl.fecha) loop

                    foreach v_time in array v_record.marcas loop

                    	 v_result = asis.array_sort(array_append(v_result,v_time));

                          raise notice 'fecha %',v_record.fecha;

                          if (v_index = 2) then
                               v_calcular = COALESCE(round(COALESCE(asis.f_date_diff('minute', v_result[1],v_result[2]),0)/60::numeric,1),0);
                               v_index = 1;

                          		raise notice 'matriz %',v_record.marcas;
                              raise notice 'cortar %',v_result;
                               if not exists (select 1
                                               from tmp_marcas tm
                                               where tm.fecha = v_record.fecha) then

                                   insert into tmp_marcas (  funcionario,
                                                             fecha,
                                                             inicio_one,
                                                             fin_one,
                                                             result_one,
                                                             inicio_two,
                                                             fin_two,
                                                             result_two,
                                                             total
                                                             )values (
                                                             v_record.desc_funcionario1,
                                                             v_record.fecha,
                                                             v_result[1],
                                                             v_result[2],
                                                             v_calcular,
                                                             null,
                                                             null,
                                                             0,
                                                             v_calcular
                                                           );
                                             v_result = null;
                                              v_calcular = 0;
                               else
                                v_calcular = COALESCE(round(COALESCE(asis.f_date_diff('minute', v_result[1],v_result[2]),0)/60::numeric,1),0);
                               v_index = 1;
                                   select tm.total into v_one
                                   from tmp_marcas tm
                                   where tm.fecha = v_record.fecha;

                                   update tmp_marcas set
                                     inicio_two =  v_result[1],
                                     fin_two = v_result[2],
                                     result_two  = v_calcular,
                                     total =  v_one + v_calcular
                                     where fecha = v_record.fecha;
                                          v_result = null;
                                           v_calcular = 0;
                               end if;

                           end if;

                           v_index = v_index + 1;
                    end loop;
            end loop;

            v_consulta:='select  funcionario,
                                 fecha,
                                 to_char(inicio_one, ''HH24:MI'')::time as inicio_one,
                                 to_char(fin_one, ''HH24:MI'')::time as fin_one,
                                 result_one,
                                 to_char(inicio_two, ''HH24:MI'')::time as inicio_two,
                                 to_char(fin_two, ''HH24:MI'')::time as fin_two,
                                 result_two,
                                 total,
                                 '''||v_fecha_ini||'''::date as fecha_ini,
                                 '''||v_fecha_fin||'''::date as fecha_fin
            					from tmp_marcas
                                order by fecha';
    		--Devuelve la respuesta
            -- raise notice '%',v_consulta;
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

ALTER FUNCTION asis.ft_transaccion_sel (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO dbaamamani;