CREATE OR REPLACE FUNCTION asis.f_listar_funcioarios_periodo (
  p_gestion integer
)
RETURNS TABLE (
  fill_periodo integer,
  fill_id_funcionario integer,
  fill_tipo_contrato varchar,
  fill_nombre_funcionario varchar,
  fill_cargo varchar,
  fill_codigo_fun varchar,
  fill_ci varchar,
  fill_id_uo integer
) AS
$body$
DECLARE
v_nombre_funcion   				text;
v_resp							varchar;
v_record						record;
v_periodo						record;
v_consulta						record;
v_con							varchar;
v_id_gestion					integer;
BEGIN

CREATE TEMPORARY TABLE tmp_funcionario ( periodo integer,
                                         id_funcionario integer,
                                         nombre_funcionario	varchar,
                                         cargo varchar,
                                         codigo_fun varchar,
                                         tipo_contrato varchar,
                                         ci varchar,
                                         id_uo integer )ON COMMIT DROP;

	select ge.id_gestion into v_id_gestion
    from param.tgestion ge
    where ge.gestion = p_gestion;


    for v_record in ( select	pe.periodo,
                                pe.fecha_ini,
                                pe.fecha_fin
                        from param.tperiodo pe
                        where pe.id_gestion = v_id_gestion
                        order by periodo )loop
                for v_periodo in (select distinct on (uofun.id_funcionario) uofun.id_funcionario,
                                 car.id_cargo,
                                 tc.nombre as tipo_contrato,
                                 tc.codigo,
                                 pe.nombre_completo1 as nombre_funcionario,
                                 car.nombre as cargo,
                                 trim(both 'FUNODTPR' from  fun.codigo ) as codigo_fun,
                                 pe.ci,
                                 uofun.id_uo
                          from orga.tuo_funcionario uofun
                          inner join orga.tcargo car on car.id_cargo = uofun.id_cargo
                          inner join orga.ttipo_contrato tc on car.id_tipo_contrato = tc.id_tipo_contrato
                          inner join orga.tfuncionario fun on fun.id_funcionario = uofun.id_funcionario
                          inner join segu.vpersona pe on pe.id_persona = fun.id_persona
                          where tc.codigo in ('PLA', 'EVE') and UOFUN.tipo = 'oficial' and uofun.fecha_asignacion <= v_record.fecha_fin and
                           (uofun.fecha_finalizacion is null or uofun.fecha_finalizacion >= v_record.fecha_ini) AND
                           uofun.estado_reg != 'inactivo'
                           order by uofun.id_funcionario, uofun.fecha_asignacion desc)loop

                           insert into tmp_funcionario ( periodo,
                                                         id_funcionario,
                                                         nombre_funcionario,
                                                         cargo,
                                                         codigo_fun,
                                                         tipo_contrato,
                                                         ci,
                                                         id_uo
                                                         )values(
                                                         v_record.periodo,
                                                         v_periodo.id_funcionario,
                                                         v_periodo.nombre_funcionario,
                                                         v_periodo.cargo,
                                                         v_periodo.codigo_fun,
                                                         v_periodo.tipo_contrato,
                                                         v_periodo.ci,
                                                         v_periodo.id_uo
                                                         );

                end loop;
    end loop;

    RETURN QUERY  select   periodo,
                           id_funcionario,
                           tipo_contrato,
                           nombre_funcionario,
                           cargo,
                           codigo_fun,
                           ci,
                           id_uo
                  from tmp_funcionario;


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
COST 100 ROWS 1000;

ALTER FUNCTION asis.f_listar_funcioarios_periodo (p_gestion integer)
  OWNER TO dbaamamani;