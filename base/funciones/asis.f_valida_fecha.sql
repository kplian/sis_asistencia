CREATE OR REPLACE FUNCTION asis.f_validad_fecha(p_id_funcionario integer, p_fecha date) RETURNS boolean AS
$body$
DECLARE
    v_resp           VARCHAR;
    v_nombre_funcion TEXT;
    v_id_gestion     int;
    v_lugar          varchar;
    v_crear          boolean;
BEGIN
    v_nombre_funcion = 'asis.f_validad_fecha';

    v_crear = true;

    select g.id_gestion
    into v_id_gestion
    from param.tgestion g
    where g.gestion = EXTRACT(YEAR FROM current_date);

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
      and f.id_funcionario = p_id_funcionario;
    if exists(select 1
              from param.tferiado f
                       inner join param.tlugar l on l.id_lugar = f.id_lugar
              where l.codigo in ('BO', v_lugar)
                and (EXTRACT(MONTH from f.fecha))::integer =
                    (EXTRACT(MONTH from p_fecha::date))::integer
                and (EXTRACT(DAY from f.fecha))::integer =
                    (EXTRACT(DAY from p_fecha::date))
                and f.id_gestion = v_id_gestion) then
        v_crear = false;
    end if;

    if (select EXTRACT(ISODOW FROM p_fecha) IN (6, 7)) then
        v_crear = false;
    end if;

    return v_crear;
EXCEPTION

    WHEN OTHERS THEN
        v_resp = '';
        v_resp = pxp.f_agrega_clave(v_resp, 'mensaje', SQLERRM);
        v_resp = pxp.f_agrega_clave(v_resp, 'codigo_error', SQLSTATE);
        v_resp = pxp.f_agrega_clave(v_resp, 'procedimientos', v_nombre_funcion);
        raise exception '%',v_resp;

END
$body$
    LANGUAGE 'plpgsql'
    VOLATILE
    CALLED ON NULL INPUT
    SECURITY INVOKER
    COST 100;