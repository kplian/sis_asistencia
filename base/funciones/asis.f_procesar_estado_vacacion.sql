CREATE OR REPLACE FUNCTION asis.f_procesar_estado_vacacion (
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_estado_wf integer,
  p_id_proceso_wf integer,
  p_codigo_estado varchar,
  p_obs text
)
RETURNS boolean AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de Asistencia
 FUNCION: 		asis.f_lista_funcionario_wf
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'asis.tmes_trabajo_con'
 AUTOR: 		 (miguel.mamani)
 FECHA:	        13-03-2019 13:52:11
 COMENTARIOS:
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 ***************************************************************************/
DECLARE
v_nombre_funcion   	 			text;
    v_resp    			 			varchar;
    v_mensaje 			 			varchar;
    v_registro						record;
	v_record						record;
    v_id_movimiento_vacacion		integer;
    v_codigo						varchar;
    v_dias_Saldo					numeric;
    v_dif							numeric;
	v_resultado						numeric;
    v_positivo						numeric;
    v_evento						varchar;
    v_pares							record;
    v_filtro						varchar;
    v_consulta						varchar;
    v_consulta_record				record;
    v_rango							record;
    v_dias_efectivo					numeric;
    v_descripcion_correo    		varchar;
    v_id_alarma        				integer;
    v_vacacion_record      			record;
    v_movimiento_vacacion			record;
    v_id_mov_actual					integer;
    v_id_alarma_copiar				integer;
    v_id_funcionario_copia			record;
    v_validar_vacacion				record;
    v_vacacion_anterior				record;
    v_mensaje_error					varchar;
    v_id_alarma_secretaria			integer;
    v_secretaria					record;
    v_saldo_actual					numeric;
    v_dia_actual					numeric;
    v_operacion						numeric;
    v_conversor						numeric;
    v_nombre_funcionario			varchar;
BEGIN
  v_nombre_funcion = 'asis.f_procesar_estado_vacacion';

select    v.id_vacacion,
          v.id_estado_wf,
          v.id_proceso_wf,
          v.nro_tramite,
          v.fecha_solicitud,
          v.fecha_inicio,
          v.fecha_fin,
          v.id_funcionario,
          v.id_funcionario_sol,
          v.id_responsable,
          v.id_secretaria,
          v.funcionario_solicitante,
          v.codigo,
          v.reponsable,
          v.codigo_res,
          v.solicitante_tercero,
          v.codigo_terc,
          v.codigo_secretaria,
          v.secretaria,
          v.descripcion,
          v.dias,
          v.saldo,
          v.id_usuario_reg,
          v.detalle_saldo
into
    v_registro
from asis.vvacacion v
where v.id_proceso_wf = p_id_proceso_wf;


if p_codigo_estado = 'vobo' then

    create temporary table tmp_error_vacacion(  id serial,
    											fecha_dia date,
                                                tiempo varchar,
                                                id_funcionario integer,
                                                estado varchar
                                                )ON COMMIT DROP;

for v_validar_vacacion in ( select vd.fecha_dia,
                                       vd.tiempo
                                 from asis.tvacacion v
                                 inner join asis.tvacacion_det vd on vd.id_vacacion = v.id_vacacion
                                 where v.id_vacacion = v_registro.id_vacacion ) loop

        if exists (select 1
               from asis.tvacacion va
               inner join asis.tvacacion_det vd on vd.id_vacacion = va.id_vacacion
               where va.id_funcionario = v_registro.id_funcionario
                      and vd.fecha_dia = v_validar_vacacion.fecha_dia
                      and va.estado in ('aprobado','vobo'))then

              for v_vacacion_anterior in (select  vd.fecha_dia,
                                                   vd.tiempo,
                                                   va.estado
                                              from asis.tvacacion va
                                              inner join asis.tvacacion_det vd on vd.id_vacacion = va.id_vacacion
                                              where va.id_funcionario = v_registro.id_funcionario
                                                      and vd.fecha_dia = v_validar_vacacion.fecha_dia
                                                      and va.estado in ('aprobado','vobo')) loop

                  if v_validar_vacacion.tiempo = 'completo' then
                          if exists (select 1
                                     from asis.tvacacion va
                                     inner join asis.tvacacion_det vd on vd.id_vacacion = va.id_vacacion
                                     where va.id_funcionario = v_registro.id_funcionario
                                            and vd.fecha_dia = v_validar_vacacion.fecha_dia
                                            and vd.tiempo = 'completo'
                                            and vd.tiempo = v_validar_vacacion.tiempo
                                            and va.estado in ('aprobado','vobo'))then

                                        insert into tmp_error_vacacion(  fecha_dia,
                                                                         tiempo,
                                                                         id_funcionario,
                                                                         estado
                                                                         )values(
                                                                         v_vacacion_anterior.fecha_dia,
                                                                         v_vacacion_anterior.tiempo,
                                                                         v_registro.id_funcionario,
                                                                         v_vacacion_anterior.estado);
else

                                      if(v_validar_vacacion.tiempo != v_vacacion_anterior.tiempo)then

                                      insert into tmp_error_vacacion(  fecha_dia,
                                                                       tiempo,
                                                                       id_funcionario,
                                                                       estado
                                                                       )values(
                                                                       v_vacacion_anterior.fecha_dia,
                                                                       v_vacacion_anterior.tiempo,
                                                                       v_registro.id_funcionario,
                                                                       v_vacacion_anterior.estado);

end if;
end if;
end if;
                   if v_validar_vacacion.tiempo != 'completo' then

                      if(v_validar_vacacion.tiempo = v_vacacion_anterior.tiempo)then

                                        insert into tmp_error_vacacion( fecha_dia,
                                                                         tiempo,
                                                                         id_funcionario,
                                                                         estado
                                                                         )values(
                                                                         v_vacacion_anterior.fecha_dia,
                                                                         v_vacacion_anterior.tiempo,
                                                                         v_registro.id_funcionario,
                                                                         v_vacacion_anterior.estado);

end if;

                      if (v_vacacion_anterior.tiempo = 'completo') then
                       insert into tmp_error_vacacion( fecha_dia,
                                                                         tiempo,
                                                                         id_funcionario,
                                                                         estado
                                                                         )values(
                                                                         v_vacacion_anterior.fecha_dia,
                                                                         v_vacacion_anterior.tiempo,
                                                                         v_registro.id_funcionario,
                                                                         v_vacacion_anterior.estado);
end if;

end if;
end loop;
end if;
end loop;

    if exists (  select 1
                 from tmp_error_vacacion t
                 where t.id_funcionario = v_registro.id_funcionario )then


select pxp.list(' Dia: '||tm.fecha_dia || ' - '||tm.tiempo||'' || ' Estado: '||tm.estado) into v_mensaje_error
from tmp_error_vacacion tm
where tm.id_funcionario = v_registro.id_funcionario;


raise exception 'Vacacion registrado: %',v_mensaje_error;

end if;


	v_descripcion_correo = ' <table border="1" align="center" bgcolor="#FFFFFF">
        <tbody>
            <tr>
                <td align="center" bgcolor="#12125A">
                    <font color="#FFFFCC"><b>Solicitud de Vacaciones</b></font>
                </td>
            </tr>
            <tr>
                <td>
                    <table border="0" cellpadding="2" cellspacing="3">
                        <tbody>
                            <tr>
                                <td>
                                    <table align="center" cellspacing="0" cellpadding="0" width="457" border="0">
                                        <tbody>
                                            <tr>
                                                <td bgcolor="#12125A">
                                                    <font color="#FFFFCC"><b>Solicitante de la Vacación</b></font>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td height="7"></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <table width="100%" cellpadding="1" cellspacing="1" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td bgcolor="#EEEEFB" width="30%">Cod Solicitante :</td>
                                                                <td>'||v_registro.codigo||'</td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#EEEEFB">Nombre Solicitante :</td>
                                                                <td>'||v_registro.funcionario_solicitante||'</td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <table align="center" cellspacing="0" cellpadding="0" width="457" border="0">
                                        <tbody>
                                            <tr>
                                                <td bgcolor="#12125A">
                                                    <font color="#FFFFCC"><b>Solicitud de Vacación para...</b></font>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td height="7"></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <table width="100%" cellpadding="1" cellspacing="1" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td bgcolor="#EEEEFB" width="30%">Empleado :</td>
                                                                <td>'||v_registro.codigo||' - '||v_registro.funcionario_solicitante||'</td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#EEEEFB" width="30%">Observación :</td>
                                                                <td>'||v_registro.descripcion||'</td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <table align="center" cellspacing="0" cellpadding="0" width="457" border="0">
                                        <tbody>
                                            <tr>
                                                <td bgcolor="#12125A">
                                                    <font color="#FFFFCC"><b>Detalle a Completar</b></font>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td height="7"></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <table width="100%" cellpadding="1" cellspacing="1" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td bgcolor="#EEEEFB">De Fecha :</td>
                                                                <td>'||v_registro.fecha_inicio||'</td>
                                                                <td bgcolor="#EEEEFB">Días :</td>
                                                                <td>'||v_registro.dias||'</td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#EEEEFB" width="30%">A Fecha :</td>
                                                                <td>'||v_registro.fecha_fin||'</td>
                                                                <td bgcolor="#EEEEFB" colspan="2"><strong>No</strong>
                                                                    Trabaja Sábados</td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <table align="center" cellspacing="0" cellpadding="0" width="457" border="0">
                                        <tbody>
                                            <tr>
                                                <td bgcolor="#12125A">
                                                    <font color="#FFFFCC"><b>Saldo</b></font>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td height="7"></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <table width="100%" cellpadding="1" cellspacing="1" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td bgcolor="#EEEEFB" width="30%">Saldo Vacación :</td>
                                                                <td colspan="3">'||v_registro.saldo||'</td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <table align="center" cellspacing="0" cellpadding="0" width="457" border="0">
                                        <tbody>
                                            <tr>
                                                <td bgcolor="#12125A">
                                                    <font color="#FFFFCC"><b>Destinatarios</b></font>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td height="7"></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <table width="100%" cellpadding="1" cellspacing="1" border="1">
                                                        <tbody>
                                                            <tr>
                                                                <td bgcolor="#EEEEFB" width="30%">Responsable :</td>
                                                                <td>'||v_registro.codigo_res||' - '||v_registro.reponsable||'</td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#EEEEFB" width="30%">Secretaria/Adm.
                                                                    Regional :</td>
                                                                <td>'||v_registro.codigo_secretaria||' - '||v_registro.secretaria||'</td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                '||v_registro.detalle_saldo||'
                            </tr>
                        </tbody>
                    </table>
                </td>
            </tr>
        </tbody>
    </table>';
    if (v_registro.id_funcionario_sol is not null)then
      v_id_alarma = param.f_inserta_alarma(
                          v_registro.id_funcionario,
                          v_descripcion_correo,--par_descripcion
                          '',--acceso directo
                          now()::date,--par_fecha: Indica la fecha de vencimiento de la alarma
                          'notificacion', --notificacion
                          'Solicitud Vacacion',  --asunto
                          p_id_usuario,
                          '', --clase
                          'Solicitud Vacacion',--titulo
                          '',--par_parametros varchar,   parametros a mandar a la interface de acceso directo
                          v_registro.id_funcionario, --usuario a quien va dirigida la alarma
                          '',--titulo correo
                          '', --correo funcionario
                          null,--#9
                          p_id_proceso_wf,
                          v_registro.id_estado_wf--#9
                         );
end if;

     	v_nombre_funcionario = '';
        v_codigo = '';
     	-- correo copia SURAY AGREDA LAZARTE MAGALI SIÑANI IRAHOLA
for v_id_funcionario_copia in (select   f.id_funcionario,
                                                f.desc_funcionario1 as funcionario,
                                                trim(both 'FUNODTPR' from f.codigo) as codigo
                                              from orga.vfuncionario_cargo f
                                              where (f.fecha_finalizacion is null or f.fecha_finalizacion >= now()::date)
                                              and f.id_funcionario in (373,700,v_registro.id_secretaria,v_registro.id_funcionario )) loop

         if v_registro.id_funcionario <> v_id_funcionario_copia.id_funcionario then
         	v_nombre_funcionario = ' - '||v_registro.funcionario_solicitante;
            	v_codigo =  ' '||v_registro.codigo;
end if;

         v_id_alarma = param.f_inserta_alarma( v_id_funcionario_copia.id_funcionario,
                                                          v_descripcion_correo,--par_descripcion
                                                          '',--acceso directo
                                                          now()::date,--par_fecha: Indica la fecha de vencimiento de la alarma
                                                          'notificacion', --notificacion
                                                          'SOLICITUD VACACION'||v_codigo || v_nombre_funcionario,  --asunto
                                                          p_id_usuario,
                                                          '', --clase
                                                          'Solicitud Vacacion',--titulo
                                                          '',--par_parametros varchar,   parametros a mandar a la interface de acceso directo
                                                          v_id_funcionario_copia.id_funcionario, --usuario a quien va dirigida la alarma
                                                          '',--titulo correo
                                                          '', --correo funcionario
                                                          null,--#9
                                                          p_id_proceso_wf,
                                                          v_registro.id_estado_wf);
            v_nombre_funcionario = '';
end loop;

select sum(d.dias_efectico) into v_dias_efectivo
from (
         select
             (case
                  when vd.tiempo  = 'completo' then
                      1
                  when vd.tiempo  = 'mañana' then
                      0.5
                  when vd.tiempo  = 'tarde' then
                      0.5
                  else
                      0
                 end ::numeric ) as dias_efectico
         from asis.tvacacion_det vd
         where vd.id_vacacion =  v_registro.id_vacacion ) d;


update asis.tvacacion  set
                           dias_efectivo = v_dias_efectivo,
                           dias = v_dias_efectivo
where  id_vacacion  =  v_registro.id_vacacion;


update asis.tvacacion  set
                           id_estado_wf =  p_id_estado_wf,
                           estado = p_codigo_estado,
                           id_usuario_mod=p_id_usuario,
                           id_usuario_ai = p_id_usuario_ai,
                           usuario_ai = p_usuario_ai,
                           fecha_mod=now(),
                           observaciones = p_obs
where id_proceso_wf = p_id_proceso_wf;

return true;

end if;

    if p_codigo_estado = 'aprobado' then

select va.id_movimiento_vacacion,
       va.id_funcionario,
       COALESCE(va.dias_actual,0) as dias_actual,
       va.codigo
into v_record
from asis.tmovimiento_vacacion va
where va.id_funcionario = v_registro.id_funcionario
  and va.activo = 'activo'
  and  va.estado_reg = 'activo';

v_evento = 'TOMADA';
            v_resultado =  v_record.dias_actual - v_registro.dias;

            if v_record.dias_actual <= 0 then

                v_positivo = -1 * v_record.dias_actual;
                v_resultado =  (v_positivo + v_registro.dias)* -1;

end if;

insert into  asis.tmovimiento_vacacion(
    id_usuario_reg,
    id_usuario_mod,
    fecha_reg,
    fecha_mod,
    estado_reg,
    id_usuario_ai,
    usuario_ai,
    id_funcionario,
    desde,
    hasta,
    dias_actual,
    activo,
    codigo,
    dias,
    tipo,
    id_vacacion
)values(
           v_registro.id_usuario_reg,
           null,
           now(),
           null,
           'activo',
           p_id_usuario_ai,
           p_usuario_ai,
           v_registro.id_funcionario,
           v_registro.fecha_inicio::date,
           v_registro.fecha_fin::date,
           v_resultado,-- v_record.dias_actual - v_registro.dias,
           'activo',
           v_record.codigo,
           -1 * v_registro.dias,
           v_evento,
           v_registro.id_vacacion
       )returning id_movimiento_vacacion into v_id_movimiento_vacacion;

if v_id_movimiento_vacacion is null then
           raise exception 'Algo salimo mal en calculo operacion';
end if;

update asis.tmovimiento_vacacion set
    activo = 'inactivo'
where id_movimiento_vacacion = v_record.id_movimiento_vacacion;

update asis.tvacacion  set
                           id_estado_wf =  p_id_estado_wf,
                           estado = p_codigo_estado,
                           id_usuario_mod=p_id_usuario,
                           id_usuario_ai = p_id_usuario_ai,
                           usuario_ai = p_usuario_ai,
                           fecha_mod=now(),
                           observaciones =  p_obs
where id_proceso_wf = p_id_proceso_wf;


v_descripcion_correo = '<table border="1" align="center" bgcolor="#FFFFFF">
        <tbody>
            <tr>
                <td align="center" bgcolor="#12125A">
                    <font color="#FFFFCC">Solicitud de Vacaciones</b></font>
                </td>
            </tr>
            <tr>
                <td>
                    <table border="0" cellpadding="2" cellspacing="3">
                        <tbody>
                            <tr>
                                <td>
                                    <table align="center" cellspacing="0" cellpadding="0" width="457" border="0">
                                        <tbody>
                                            <tr>
                                                <td align="center" bgcolor="#12125A">
                                                    <font color="lime"><b>SOLICITUD APROBADA</b></font>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td height="7"></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <table align="center" cellspacing="0" cellpadding="0" width="457" border="0">
                                        <tbody>
                                            <tr>
                                                <td bgcolor="#12125A">
                                                    <font color="#FFFFCC"><b>Detalle de la Solicitud</b></font>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td height="7"></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <table width="100%" cellpadding="1" cellspacing="1" border="1"
                                                        class="textoAzulPequeno">
                                                        <tbody>
                                                            <tr>
                                                                <td bgcolor="#EEEEFB" width="30%">Cod Solicitante :</td>
                                                                <td>'||v_registro.codigo||'</td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#EEEEFB" width="30%">Nombre Solicitante :
                                                                </td>
                                                                <td>'||v_registro.funcionario_solicitante||'</td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#EEEEFB" width="30%">Solicitud Para :</td>
                                                                <td>'||v_registro.codigo||' - '||v_registro.funcionario_solicitante||'</td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2">&nbsp;</td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#EEEEFB" width="30%">Fecha De :</td>
                                                                <td>'||v_registro.fecha_inicio||'</td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#EEEEFB" width="30%">Fecha A :</td>
                                                                <td>'||v_registro.fecha_fin||'</td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#EEEEFB" width="30%">Días Solicitados :
                                                                </td>
                                                                <td>'||v_registro.dias||'</td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#EEEEFB" width="30%">Observación :</td>
                                                                <td>'||v_registro.descripcion||'</td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td bgcolor="#12125A">
                                                    <font color="#FFFFCC"><b>Responsable</b></font>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <table width="100%" cellpadding="1" cellspacing="1" border="1"
                                                        class="textoAzulPequeno">
                                                        <tbody>
                                                            <tr>
                                                                <td bgcolor="#EEEEFB" width="30%">Responsable :</td>
                                                                <td>'||v_registro.codigo_res||' - '||v_registro.reponsable||'</td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#EEEEFB" width="30%">Secretaria/Adm.
                                                                    Regional :</td>
                                                                <td>'||v_registro.codigo_secretaria||' - '||v_registro.secretaria||'</td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </td>
            </tr>
        </tbody>
    </table>';


			v_nombre_funcionario = '';
            v_codigo = '';
			-- correo copia SURAY AGREDA LAZARTE MAGALI SIÑANI IRAHOLA
for v_id_funcionario_copia in (select   f.id_funcionario,
                                                f.desc_funcionario1 as funcionario,
                                                  trim(both 'FUNODTPR' from f.codigo) as codigo
                                              from orga.vfuncionario_cargo f
                                              where (f.fecha_finalizacion is null or f.fecha_finalizacion >= now()::date)
                                              and f.id_funcionario in (373,700,v_registro.id_secretaria,v_registro.id_funcionario )) loop


    	   if v_registro.id_funcionario != v_id_funcionario_copia.id_funcionario then
         		v_nombre_funcionario = ' - '||v_registro.funcionario_solicitante;
            	v_codigo =  ' '||v_registro.codigo;
end if;

           v_id_alarma = param.f_inserta_alarma( v_id_funcionario_copia.id_funcionario,
                                                    v_descripcion_correo,--par_descripcion
                                                    '',--acceso directo
                                                    now()::date,--par_fecha: Indica la fecha de vencimiento de la alarma
                                                    'notificacion', --notificacion
                                                    'Aprobada - SOLICITUD VACACION '||v_codigo || v_nombre_funcionario,
                                                    p_id_usuario,
                                                    '', --clase
                                                    'Solicitud Vacacion Aprobada',--titulo
                                                    '',--par_parametros varchar,   parametros a mandar a la interface de acceso directo
                                                     v_id_funcionario_copia.id_funcionario, --usuario a quien va dirigida la alarma
                                                    '',--titulo correo
                                                    '', --correo funcionario
                                                    null,--#9
                                                    p_id_proceso_wf,
                                                    v_registro.id_estado_wf--#9
                                                   );
           v_nombre_funcionario = '';

end loop;


return true;

end if;



      if p_codigo_estado = 'cancelado' then


select v.id_vacacion, v.id_funcionario into v_vacacion_record
from asis.tvacacion v
where v.id_proceso_wf = p_id_proceso_wf;


if exists ( select 1
                        from asis.tmovimiento_vacacion m
                        where m.id_vacacion = v_registro.id_vacacion
                                and m.id_funcionario = v_vacacion_record.id_funcionario
                                 and m.activo = 'activo' and m.estado_reg = 'activo')then

select m.id_movimiento_vacacion,
       m.id_funcionario
into
    v_movimiento_vacacion
from asis.tmovimiento_vacacion m
where m.id_vacacion = v_registro.id_vacacion
  and m.id_funcionario = v_vacacion_record.id_funcionario
  and m.activo = 'activo' and m.estado_reg = 'activo';

delete from asis.tmovimiento_vacacion  mv
where mv.id_movimiento_vacacion = v_movimiento_vacacion.id_movimiento_vacacion
  and mv.activo = 'activo';

select mm.id_movimiento_vacacion into v_id_mov_actual
from asis.tmovimiento_vacacion mm
where mm.id_funcionario = v_movimiento_vacacion.id_funcionario
  and mm.fecha_reg = (select max(m.fecha_reg)
                      from asis.tmovimiento_vacacion m
                      where m.id_funcionario = v_movimiento_vacacion.id_funcionario);

update asis.tmovimiento_vacacion set
                                     activo = 'activo',
                                     estado_reg = 'activo'
where id_movimiento_vacacion = v_id_mov_actual;
else


select  m.id_movimiento_vacacion,
        m.id_funcionario,
        m.dias
into
    v_movimiento_vacacion
from asis.tmovimiento_vacacion m
where m.id_vacacion = v_registro.id_vacacion
  and m.id_funcionario = v_vacacion_record.id_funcionario
  and m.estado_reg = 'activo';


delete from asis.tmovimiento_vacacion m
where m.id_movimiento_vacacion  = v_movimiento_vacacion.id_movimiento_vacacion;

select  sum(m.dias) into v_dia_actual
from asis.tmovimiento_vacacion m
where m.id_funcionario = v_vacacion_record.id_funcionario
  and m.estado_reg = 'activo';

update asis.tmovimiento_vacacion set
    dias_actual = v_dia_actual
where id_funcionario = v_vacacion_record.id_funcionario
  and estado_reg = 'activo'
  and activo = 'activo';


end if;



update asis.tvacacion  set
                           id_estado_wf =  p_id_estado_wf,
                           estado = p_codigo_estado,
                           id_usuario_mod=p_id_usuario,
                           id_usuario_ai = p_id_usuario_ai,
                           usuario_ai = p_usuario_ai,
                           fecha_mod=now(),
                           observaciones =  p_obs
where id_proceso_wf = p_id_proceso_wf;

return true;

end if;

	if p_codigo_estado = 'rechazado' then

update asis.tvacacion  set
                           id_estado_wf =  p_id_estado_wf,
                           estado = p_codigo_estado,
                           id_usuario_mod=p_id_usuario,
                           id_usuario_ai = p_id_usuario_ai,
                           usuario_ai = p_usuario_ai,
                           fecha_mod=now(),
                           observaciones =  p_obs
where id_proceso_wf = p_id_proceso_wf;

v_descripcion_correo = '<table border="1" align="center" bgcolor="#FFFFFF">
        <tbody>
            <tr>
                <td align="center" bgcolor="#12125A">
                    <font color="#FFFFCC">Solicitud de Vacaciones</b></font>
                </td>
            </tr>
            <tr>
                <td>
                    <table border="0" cellpadding="2" cellspacing="3">
                        <tbody>
                            <tr>
                                <td>
                                    <table align="center" cellspacing="0" cellpadding="0" width="457" border="0">
                                        <tbody>
                                            <tr>
                                                <td align="center" bgcolor="#12125A">
                                                    <font color="#E01010"><b>SOLICITUD RECHAZADA</b></font>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td height="7"></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <table align="center" cellspacing="0" cellpadding="0" width="457" border="0">
                                        <tbody>
                                            <tr>
                                                <td bgcolor="#12125A">
                                                    <font color="#FFFFCC"><b>Detalle de la Solicitud</b></font>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td height="7"></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <table width="100%" cellpadding="1" cellspacing="1" border="1"
                                                        class="textoAzulPequeno">
                                                        <tbody>
                                                            <tr>
                                                                <td bgcolor="#EEEEFB" width="30%">Cod Solicitante :</td>
                                                                <td>'||v_registro.codigo||'</td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#EEEEFB" width="30%">Nombre Solicitante :
                                                                </td>
                                                                <td>'||v_registro.funcionario_solicitante||'</td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#EEEEFB" width="30%">Solicitud Para :</td>
                                                                <td>'||v_registro.codigo||' - '||v_registro.funcionario_solicitante||'</td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="2">&nbsp;</td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#EEEEFB" width="30%">Fecha De :</td>
                                                                <td>'||v_registro.fecha_inicio||'</td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#EEEEFB" width="30%">Fecha A :</td>
                                                                <td>'||v_registro.fecha_fin||'</td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#EEEEFB" width="30%">Días Solicitados :
                                                                </td>
                                                                <td>'||v_registro.dias||'</td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#EEEEFB" width="30%">Observación :</td>
                                                                <td>'||v_registro.descripcion||'</td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td bgcolor="#12125A">
                                                    <font color="#FFFFCC"><b>Responsable</b></font>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <table width="100%" cellpadding="1" cellspacing="1" border="1"
                                                        class="textoAzulPequeno">
                                                        <tbody>
                                                            <tr>
                                                                <td bgcolor="#EEEEFB" width="30%">Responsable :</td>
                                                                <td>'||v_registro.codigo_res||' - '||v_registro.reponsable||'</td>
                                                            </tr>
                                                            <tr>
                                                                <td bgcolor="#EEEEFB" width="30%">Secretaria/Adm.
                                                                    Regional :</td>
                                                                <td>'||v_registro.codigo_secretaria||' - '||v_registro.secretaria||'</td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </td>
            </tr>
        </tbody>
    </table>';
		v_nombre_funcionario = '';
        v_codigo = '';
for v_id_funcionario_copia in (select   f.id_funcionario,
                                                f.desc_funcionario1 as funcionario,
                                                  trim(both 'FUNODTPR' from f.codigo) as codigo
                                              from orga.vfuncionario_cargo f
                                              where (f.fecha_finalizacion is null or f.fecha_finalizacion >= now()::date)
                                              and f.id_funcionario in (373,700,v_registro.id_secretaria,v_registro.id_funcionario  )) loop

      		if v_registro.id_funcionario <> v_id_funcionario_copia.id_funcionario then
         		v_nombre_funcionario = ' - '||v_registro.funcionario_solicitante;
            	v_codigo =  ' '||v_registro.codigo;
end if;

           v_id_alarma = param.f_inserta_alarma( v_id_funcionario_copia.id_funcionario,
                                                    v_descripcion_correo,--par_descripcion
                                                    '',--acceso directo
                                                    now()::date,--par_fecha: Indica la fecha de vencimiento de la alarma
                                                    'notificacion', --notificacion
                                                    'Rechazado - SOLICITUD VACACION '||v_codigo || v_nombre_funcionario,
                                                    p_id_usuario,
                                                    '', --clase
                                                    'Solicitud Vacacion Rechazado',--titulo
                                                    '',--par_parametros varchar,   parametros a mandar a la interface de acceso directo
                                                     v_id_funcionario_copia.id_funcionario, --usuario a quien va dirigida la alarma
                                                    '',--titulo correo
                                                    '', --correo funcionario
                                                    null,--#9
                                                    p_id_proceso_wf,
                                                    v_registro.id_estado_wf--#9
                                                   );
                     v_nombre_funcionario = '';
end loop;

return true;
end if;


update asis.tvacacion  set
                           id_estado_wf =  p_id_estado_wf,
                           estado = p_codigo_estado,
                           id_usuario_mod=p_id_usuario,
                           id_usuario_ai = p_id_usuario_ai,
                           usuario_ai = p_usuario_ai,
                           fecha_mod=now(),
                           observaciones =  p_obs
where id_proceso_wf = p_id_proceso_wf;


return true;
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