CREATE OR REPLACE FUNCTION asis.f_insertar_registro (
  p_id_funcionario integer,
  p_id_permiso integer,
  p_id_cuenta_doc integer,
  p_id_vacacion integer,
  p_id_feriado integer,
  p_fecha date,
  p_dia_literal varchar,
  p_id_usuario integer,
  p_id_periodo integer
)
RETURNS boolean AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.f_asignar_pro
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.f_centro_validar'
 AUTOR: 		 MMV Kplian
 FECHA:	        31-01-2019 16:36:51
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				31-01-2019 16:36:51								Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'asis.tmes_trabajo_det'
 ***************************************************************************/
DECLARE
   v_resp                       varchar;
   v_nombre_funcion             text;
   v_filtro						varchar;
   v_consulta					varchar;
   v_consulta_record			record;
   v_rango						record;
   v_resultado					boolean;

BEGIN
  	v_nombre_funcion = 'asis.f_insertar_registro';

     v_resultado = false;
     v_filtro = asis.f_obtener_rango_asignado_fun (p_id_funcionario,p_fecha);

      v_consulta = 'select rh.id_rango_horario,
                            rh.hora_entrada,
                            rh.hora_salida
                    from asis.trango_horario rh
                    inner join asis.tasignar_rango ar on ar.id_rango_horario = rh.id_rango_horario
                    where '||v_filtro||'and rh.'||p_dia_literal||' = ''si''
                     and  '''||p_fecha||'''  between ar.desde and ar.hasta
                    order by rh.hora_entrada, ar.hasta asc';

      execute (v_consulta) into v_consulta_record;



      if v_consulta_record.id_rango_horario is null then

      	 v_consulta = 'select rh.id_rango_horario,
                              rh.hora_entrada,
                              rh.hora_salida
                      from asis.trango_horario rh
                      inner join asis.tasignar_rango ar on ar.id_rango_horario = rh.id_rango_horario
                      where '||v_filtro||'and rh.'||p_dia_literal||' = ''si''
                       and  '''||p_fecha||''' >= ar.desde  and ar.hasta is null
                    order by rh.hora_entrada, ar.hasta asc';


      end if;

      if p_id_vacacion is not null then
         v_resultado = true;
      end if;

      if p_id_permiso is not null then
         v_resultado = true;
      else


      for v_rango in execute (v_consulta)loop

            insert into asis.tpares(id_usuario_reg,
                                    id_usuario_mod,
                                    fecha_reg,
                                    fecha_mod,
                                    estado_reg,
                                    id_usuario_ai,
                                    usuario_ai,
                                    fecha_marcado,
                                    hora_ini,
                                    hora_fin,
                                    lector,
                                    acceso,
                                    id_transaccion_ini,
                                    id_transaccion_fin,
                                    id_funcionario,
                                    id_permiso,
                                    id_vacacion,
                                    id_viatico,
                                    id_pares_entrada,
                                    id_periodo,
                                    rango,
                                    impar,
                                    verificacion,
                                    permiso,
                                    id_rango_horario,
                                    id_feriado
                                    )values (
                                    p_id_usuario,
                                    null,
                                    now(),
                                    null,
                                    'activo',
                                    null, --v_parametros._id_usuario_ai,
                                    null, --v_parametros._nombre_usuario_ai,
                                    p_fecha,
                                    (p_fecha::varchar ||' '|| v_rango.hora_entrada::varchar)::timestamp,
                                    null,
                                   (case
                                          when p_id_vacacion is not null then
                                          'Vacacion'
                                          when p_id_permiso is not null then
                                          'Permiso'
                                          when p_id_feriado is not null then
                                          'Feriado'
                                          when p_id_cuenta_doc is not null then
                                          'Viatico'
                                          else
                                          '--'
                                       end
                                   ),
              						'Entrada',
                                    null,
                                    null,
                                    p_id_funcionario,
                                    p_id_permiso,
                                    p_id_vacacion,
                                    p_id_cuenta_doc,
                                    null,
                                    p_id_periodo,
                                    'si',
                                    'no',
                                    'no',
                                    'no',
                                    v_rango.id_rango_horario,
                                    p_id_feriado
                                    );
							insert into asis.tpares(id_usuario_reg,
                                    id_usuario_mod,
                                    fecha_reg,
                                    fecha_mod,
                                    estado_reg,
                                    id_usuario_ai,
                                    usuario_ai,
                                    fecha_marcado,
                                    hora_ini,
                                    hora_fin,
                                    lector,
                                    acceso,
                                    id_transaccion_ini,
                                    id_transaccion_fin,
                                    id_funcionario,
                                    id_permiso,
                                    id_vacacion,
                                    id_viatico,
                                    id_pares_entrada,
                                    id_periodo,
                                    rango,
                                    impar,
                                    verificacion,
                                    permiso,
                                    id_rango_horario,
                                    id_feriado
                                    )values (
                                    p_id_usuario,
                                    null,
                                    now(),
                                    null,
                                    'activo',
                                    null, --v_parametros._id_usuario_ai,
                                    null, --v_parametros._nombre_usuario_ai,
                                    p_fecha,
                                    (p_fecha::varchar ||' '|| v_rango.hora_salida::varchar)::timestamp,
                                    null,
                                    (case
                                          when p_id_vacacion is not null then
                                          'Vacacion'
                                          when p_id_permiso is not null then
                                          'Permiso'
                                          when p_id_feriado is not null then
                                          'Feriado'
                                          when p_id_cuenta_doc is not null then
                                          'Viatico'
                                          else
                                          '--'
                                       end
                                   ),
              						'Salida',
                                    null,
                                    null,
                                    p_id_funcionario,
                                    p_id_permiso,
                                    p_id_vacacion,
                                    p_id_cuenta_doc,
                                    null,
                                    p_id_periodo,
                                    'si',
                                    'no',
                                    'no',
                                    'no',
                                    v_rango.id_rango_horario,
                                    p_id_feriado
                                    );
            v_resultado = true;
      end loop;
       end if;

    return v_resultado;
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
LEAKPROOF
PARALLEL UNSAFE
COST 100;

ALTER FUNCTION asis.f_insertar_registro (p_id_funcionario integer, p_id_permiso integer, p_id_cuenta_doc integer, p_id_vacacion integer, p_id_feriado integer, p_fecha date, p_dia_literal varchar, p_id_usuario integer, p_id_periodo integer)
  OWNER TO dbaamamani;