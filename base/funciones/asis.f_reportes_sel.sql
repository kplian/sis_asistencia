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

BEGIN

	v_nombre_funcion = 'asis.f_reportes_sel';
    v_parametros = pxp.f_get_record(p_tabla);

	/*********************************
 	#TRANSACCION:  'ASIS_RET_SEL' #15
 	#DESCRIPCION:	Reporte de retrasos
 	#AUTOR:		miguel.mamani
 	#FECHA:		29/08/2019
	***********************************/

	if(p_transaccion='ASIS_RET_SEL')then
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
        	  v_filtro = 'and to_char(tr.event_time, ''HH12:MI'')::time BETWEEN '''|| v_parametros.hora_ini|| '''and'''|| v_parametros.hora_fin||''' ';
        end if;
        if v_parametros.hora_ini is not null and v_parametros.hora_fin is null then
        	  v_filtro = 'and to_char(tr.event_time, ''HH12:MI'')::time >= '''|| v_parametros.hora_ini||''' ';
        end if;
        if v_parametros.hora_ini is null and v_parametros.hora_fin is not null then
        	  v_filtro = 'and to_char(tr.event_time, ''HH12:MI'')::time <= '''|| v_parametros.hora_fin||''' ';
        end if;

       v_consulta_ := 'select   tr.pin as codigo_funcionario,
                                    tr.event_time::date as fecha_marcado,
                                    to_char(tr.event_time, ''HH12:MI'') as hora,
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
COST 100;

ALTER FUNCTION asis.f_reportes_sel (p_administrador integer, p_id_usuario integer, p_tabla varchar, p_transaccion varchar)
  OWNER TO dbaamamani;