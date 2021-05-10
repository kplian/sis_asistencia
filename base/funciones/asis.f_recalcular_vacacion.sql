
CREATE OR REPLACE FUNCTION asis.f_recalcular_vacacion (
    p_id_funcionario integer = NULL::integer
)
    RETURNS void AS
$body$
DECLARE
    v_resp                      varchar;
    v_nombre_funcion            text;
    v_registros 				record;
    v_funcionario				record;
    v_dias_actual 				numeric;
    v_operacion     			numeric;
    v_record					record;

BEGIN

    v_nombre_funcion = 'asis.f_recalcular_vacacion';

    FOR v_funcionario in (select f.id_funcionario,
                                 uf.fecha_asignacion,
                                 UF.fecha_finalizacion,
                                 tc.nombre,tc.codigo
                          from orga.tfuncionario f
                                   join orga.tuo_funcionario uf on uf.id_funcionario=f.id_funcionario
                                   join orga.tcargo c on c.id_cargo=uf.id_cargo
                                   join orga.ttipo_contrato tc on tc.id_tipo_contrato=c.id_tipo_contrato
                              and tc.codigo in ('PLA','EVE')
                          where uf.fecha_asignacion <= now() and coalesce(uf.fecha_finalizacion, now())>=now()
                            and uf.estado_reg = 'activo'
                            and uf.tipo = 'oficial'
                            and (case
                                     when p_id_funcionario is not null then
                                             f.id_funcionario = p_id_funcionario
                                     else
                                             0=0
                              end)
                          order by fecha_asignacion)LOOP
            v_dias_actual = 0;
            v_operacion = 0;


            FOR v_registros in (select m.id_movimiento_vacacion,
                                       m.id_funcionario,
                                       m.dias,
                                       m.dias_actual,
                                       m.fecha_reg,
                                       (case
                                            when m.tipo in ('ACUMULADA','CADUCADA') and m.desde is null then
                                                m.fecha_reg::date
                                            else
                                                m.desde
                                           end  ) as desde
                                from asis.tmovimiento_vacacion m
                                where m.id_funcionario = v_funcionario.id_funcionario
                                  and m.estado_reg = 'activo'
                                order by desde  )LOOP

                    v_operacion = v_registros.dias::numeric +  v_dias_actual;


                    update asis.tmovimiento_vacacion set
                                                         dias_saldo = v_registros.dias_actual,
                                                         dias_actual = v_operacion
                    where id_movimiento_vacacion = v_registros.id_movimiento_vacacion;

                    v_dias_actual = v_operacion;

                END LOOP;

            update asis.tmovimiento_vacacion set
                activo = 'inactivo'
            where id_funcionario = v_funcionario.id_funcionario;


            select m.id_movimiento_vacacion,
                   (case
                        when m.tipo in ('ACUMULADA','CADUCADA') and m.desde is null then
                            m.fecha_reg::date
                        else
                            m.desde
                       end) as fecha  into v_record
            from asis.tmovimiento_vacacion m
            where m.id_funcionario = v_funcionario.id_funcionario
              and m.estado_reg = 'activo'
            order by fecha desc, m.dias_actual desc limit 1;



            update asis.tmovimiento_vacacion set
                activo = 'activo'
            where id_funcionario = v_funcionario.id_funcionario
              and id_movimiento_vacacion = v_record.id_movimiento_vacacion;



        END LOOP;


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

ALTER FUNCTION asis.f_recalcular_vacacion (p_id_funcionario integer)