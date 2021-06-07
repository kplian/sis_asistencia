/***********************************I-DEP-RAC-ASIS-48-15/04/2019*****************************************/
select pxp.f_insert_testructura_gui ('ASIS', 'SISTEMA');
select pxp.f_insert_testructura_gui ('MTO', 'ASIS');
select pxp.f_insert_testructura_gui ('VOM', 'ASIS');
select pxp.f_insert_testructura_gui ('TPS', 'ASIS');
/***********************************F-DEP-RAC-ASIS-48-15/04/2019*****************************************/
/***********************************I-DEP-MMV-ASIS-48-16/04/2019*****************************************/
CREATE VIEW asis.vtotales_horas (
    id_funcionario,
    id_periodo,
    id_planilla,
    estado,
    total_normal,
    total_extra,
    total_nocturna,
    extra_autorizada)
AS
SELECT ta.id_funcionario,
    ta.id_periodo,
    ta.id_planilla,
    ta.estado,
    sum(de.total_normal) AS total_normal,
    sum(de.total_extra) AS total_extra,
    sum(de.total_nocturna) AS total_nocturna,
    sum(de.extra_autorizada) AS extra_autorizada
FROM asis.tmes_trabajo_det de
     JOIN asis.tmes_trabajo ta ON ta.id_mes_trabajo = de.id_mes_trabajo
GROUP BY ta.id_funcionario, ta.id_periodo, ta.id_planilla, ta.estado;

CREATE VIEW asis.vtotales_horas_centro_costo (
    id_funcionario,
    id_periodo,
    id_planilla,
    id_centro_costo,
    estado,
    total_normal,
    total_extra,
    total_nocturna,
    extra_autorizada)
AS
SELECT ta.id_funcionario,
    ta.id_periodo,
    ta.id_planilla,
    de.id_centro_costo,
    ta.estado,
    sum(de.total_normal) AS total_normal,
    sum(de.total_extra) AS total_extra,
    sum(de.total_nocturna) AS total_nocturna,
    sum(de.extra_autorizada) AS extra_autorizada
FROM asis.tmes_trabajo_det de
     JOIN asis.tmes_trabajo ta ON ta.id_mes_trabajo = de.id_mes_trabajo
GROUP BY ta.id_funcionario, ta.id_periodo, ta.id_planilla, de.id_centro_costo,
    ta.estado;
/***********************************F-DEP-MMV-ASIS-48-16/04/2019*****************************************/
/***********************************I-DEP-MMV-ASIS-2-30/04/2019*****************************************/
select pxp.f_insert_testructura_gui ('ASIS', 'SISTEMA');
select pxp.f_insert_testructura_gui ('MTO', 'ASIS');
select pxp.f_insert_testructura_gui ('VOM', 'ASIS');
select pxp.f_insert_testructura_gui ('TPS', 'ASIS');
select pxp.f_insert_testructura_gui ('AREP', 'ASIS');
/***********************************F-DEP-MMV-ASIS-2-30/04/2019*****************************************/


/***********************************I-DEP-JDJ-ASIS-48-14/08/2019*****************************************/
select pxp.f_insert_testructura_gui ('CONDIA', 'ASIS');
select pxp.f_insert_testructura_gui ('INGSAL', 'CONDIA');
/***********************************F-DEP-JDJ-ASIS-48-14/08/2019*****************************************/

/***********************************I-DEP-MMV-ASIS-15-02/09/2019*****************************************/
select pxp.f_insert_testructura_gui ('RRET', 'AREP');
/***********************************F-DEP-MMV-ASIS-15-02/09/2019*****************************************/
/***********************************I-DEP-MMV-ASIS-18-26/09/2019*****************************************/
select pxp.f_insert_testructura_gui ('HFT', 'ASIS');
select pxp.f_insert_testructura_gui ('MTO', 'HFT');
select pxp.f_insert_testructura_gui ('VOM', 'HFT');
select pxp.f_insert_testructura_gui ('CCT', 'HFT');
/***********************************F-DEP-MMV-ASIS-18-26/09/2019*****************************************/
/***********************************I-DEP-MMV-ASIS-1-22/12/2020*****************************************/
select pxp.f_insert_testructura_gui ('ASIS', 'SISTEMA');
select pxp.f_insert_testructura_gui ('TPS', 'PARM');
select pxp.f_insert_testructura_gui ('AREP', 'ASIS');
select pxp.f_insert_testructura_gui ('INGSAL', 'CONDIA');
select pxp.f_insert_testructura_gui ('RRET', 'AREP');
select pxp.f_insert_testructura_gui ('HFT', 'ASIS');
select pxp.f_insert_testructura_gui ('MTO', 'HFT');
select pxp.f_insert_testructura_gui ('VOM', 'SBO');
select pxp.f_insert_testructura_gui ('CCT', 'HFT');
select pxp.f_insert_testructura_gui ('RTH', 'AREP');
select pxp.f_insert_testructura_gui ('PARM', 'ASIS');
select pxp.f_insert_testructura_gui ('RHO', 'PARM');
select pxp.f_insert_testructura_gui ('RMAR', 'AREP');
select pxp.f_insert_testructura_gui ('TLS', 'PARM');
select pxp.f_insert_testructura_gui ('PRH', 'CON');
select pxp.f_insert_testructura_gui ('SBO', 'ASIS');
select pxp.f_insert_testructura_gui ('PERMI', 'ASIS');
select pxp.f_insert_testructura_gui ('SOLVAC', 'ASIS');
select pxp.f_insert_testructura_gui ('VOB', 'SBO');
select pxp.f_insert_testructura_gui ('PVO', 'SBO');
select pxp.f_insert_testructura_gui ('VACFUN', 'CON');
select pxp.f_insert_testructura_gui ('CON', 'ASIS');
select pxp.f_insert_testructura_gui ('MAB', 'CON');
select pxp.f_insert_testructura_gui ('FERIA', 'PARM');
select pxp.f_insert_testructura_gui ('RPN', 'CON');
select pxp.f_insert_testructura_gui ('RVS', 'AREP');
select pxp.f_insert_testructura_gui ('CPO', 'ASIS');
select pxp.f_insert_testructura_gui ('CVR', 'ASIS');
/***********************************F-DEP-MMV-ASIS-1-22/12/2020*****************************************/
/***********************************I-DEP-MMV-ASIS-2-22/12/2020*****************************************/
CREATE VIEW asis.vpermiso (
    id_permiso,
    id_estado_wf,
    id_proceso_wf,
    fecha_solicitud,
    hro_desde,
    hro_hasta,
    motivo,
    tipo_permiso,
    funcionario_solicitante)
AS
SELECT p.id_permiso,
    p.id_estado_wf,
    p.id_proceso_wf,
    to_char(p.fecha_solicitud::timestamp with time zone, 'DD/MM/YYYY'::text) AS
        fecha_solicitud,
    p.hro_desde,
    p.hro_hasta,
    p.motivo,
    tp.nombre AS tipo_permiso,
    initcap(fu.desc_funcionario1) AS funcionario_solicitante
FROM asis.tpermiso p
     JOIN asis.ttipo_permiso tp ON tp.id_tipo_permiso = p.id_tipo_permiso
     JOIN orga.vfuncionario fu ON fu.id_funcionario = p.id_funcionario
     LEFT JOIN orga.vfuncionario sf ON sf.id_funcionario = p.id_funcionario_sol;

CREATE VIEW asis.vvacacion (
    id_vacacion,
    id_estado_wf,
    id_proceso_wf,
    nro_tramite,
    fecha_solicitud,
    fecha_inicio,
    fecha_fin,
    descripcion,
    funcionario_solicitante,
    dias)
AS
SELECT va.id_vacacion,
    va.id_estado_wf,
    va.id_proceso_wf,
    va.nro_tramite,
    to_char(va.fecha_reg::date::timestamp with time zone, 'DD/MM/YYYY'::text)
        AS fecha_solicitud,
    to_char(va.fecha_inicio::timestamp with time zone, 'DD/MM/YYYY'::text) AS
        fecha_inicio,
    to_char(va.fecha_fin::timestamp with time zone, 'DD/MM/YYYY'::text) AS fecha_fin,
    va.descripcion,
    initcap(fu.desc_funcionario1) AS funcionario_solicitante,
    va.dias
FROM asis.tvacacion va
     JOIN orga.vfuncionario fu ON fu.id_funcionario = va.id_funcionario
     LEFT JOIN orga.vfuncionario sf ON sf.id_funcionario = va.id_funcionario_sol;
/***********************************F-DEP-MMV-ASIS-2-22/12/2020*****************************************/
/***********************************I-DEP-VAN-ASIS-0-15/01/2021*****************************************/
select pxp.f_insert_testructura_gui ('ACF', 'ASIS');
/***********************************F-DEP-VAN-ASIS-0-15/01/2021*****************************************/
/***********************************I-DEP-VAN-ASIS-0-27/01/2021*****************************************/
select pxp.f_insert_testructura_gui('PVN', 'ASIS');
select pxp.f_insert_testructura_gui('CLO', 'ASIS');
/***********************************F-DEP-VAN-ASIS-0-27/01/2021*****************************************/
/***********************************I-DEP-MMA-ASIS-SDA-50-01/02/2021*****************************************/
CREATE OR REPLACE VIEW asis.vvacacion(
    id_vacacion,
    id_estado_wf,
    id_proceso_wf,
    nro_tramite,
    fecha_solicitud,
    fecha_inicio,
    fecha_fin,
    id_funcionario,
    id_funcionario_sol,
    id_responsable,
    id_secretaria,
    funcionario_solicitante,
    codigo,
    reponsable,
    codigo_res,
    solicitante_tercero,
    codigo_terc,
    codigo_secretaria,
    secretaria,
    descripcion,
    dias,
    saldo,
    id_usuario_reg,
    detalle_saldo)
AS
WITH movimiento AS(
  SELECT mo.id_funcionario,
         ('<table align="center" cellspacing="0" cellpadding="0" width="457" border="0">
       		<tr>
              <td bgcolor="#EEEEFB" align="right">Dias</td>
              <td bgcolor="#EEEEFB" align="center">Fecha</td>
              <td bgcolor="#EEEEFB" align="center">Rango de Fechas </td>
              <td bgcolor="#EEEEFB" align="center">Tipo</td>
              <td bgcolor="#EEEEFB" align="right">Saldo</td>
          </tr>'::text || pxp.html_rows((((((((((((('
              <td align="right">'::text || COALESCE(CASE
                                                      WHEN mo.dias < 0::numeric
                                                        THEN '-1'::integer::
                                                        numeric * mo.dias
                                                      ELSE mo.dias
                                                    END, 0::numeric)::character
                                                      varying::text) || '</td>
              <td align="center">'::text) || COALESCE(to_char(mo.fecha_reg::date
                ::timestamp with time zone, 'DD/MM/YYYY'::text), '-'::text)) ||
                '</td>
              <td align="center">'::text) || COALESCE(to_char(mo.desde::
              timestamp with time zone, 'DD/MM/YYYY'::text), '-'::text)) || '-'
              ::text) || COALESCE(to_char(mo.hasta::timestamp with time zone,
              'DD/MM/YYYY'::text), '-'::text)) || '</td>
              <td align="center">'::text) || COALESCE(mo.tipo, '-'::character
                varying)::text) || '</td>
              <td align="right">'::text) || COALESCE(mo.dias_actual, 0::numeric)
                ::character varying::text) || '</td>'::text)::character varying)
                ::text) || '
           </table>'::text AS detalle_saldo
  FROM asis.tmovimiento_vacacion mo
  GROUP BY mo.id_funcionario)
 SELECT vaca.id_vacacion,
        vaca.id_estado_wf,
        vaca.id_proceso_wf,
        vaca.nro_tramite,
        vaca.fecha_solicitud,
        vaca.fecha_inicio,
        vaca.fecha_fin,
        vaca.id_funcionario,
        vaca.id_funcionario_sol,
        vaca.id_responsable,
        vaca.secretaria [ 1 ]::integer AS id_secretaria,
        vaca.funcionario_solicitante,
        vaca.codigo,
        vaca.reponsable,
        vaca.codigo_res,
        vaca.solicitante_tercero,
        vaca.codigo_terc,
        vaca.secretaria [ 3 ] AS codigo_secretaria,
        vaca.secretaria [ 2 ] AS secretaria,
        vaca.descripcion,
        vaca.dias,
        vaca.saldo,
        vaca.id_usuario_reg,
        mm.detalle_saldo
 FROM (
        SELECT va.id_vacacion,
               va.id_estado_wf,
               va.id_proceso_wf,
               va.nro_tramite,
               va.id_funcionario,
               to_char(va.fecha_reg::date::timestamp with time zone,
                 'DD/MM/YYYY'::text) AS fecha_solicitud,
               to_char(va.fecha_inicio::timestamp with time zone, 'DD/MM/YYYY'::
                 text) AS fecha_inicio,
               to_char(va.fecha_fin::timestamp with time zone, 'DD/MM/YYYY'::
                 text) AS fecha_fin,
               va.id_funcionario_sol,
               va.id_responsable,
               initcap(fu.desc_funcionario2) AS funcionario_solicitante,
               btrim(fu.codigo::text, 'FUNODTPR'::text) AS codigo,
               initcap(res.desc_funcionario2) AS reponsable,
               btrim(res.codigo::text, 'FUNODTPR'::text) AS codigo_res,
               initcap(sf.desc_funcionario2) AS solicitante_tercero,
               btrim(sf.codigo::text, 'FUNODTPR'::text) AS codigo_terc,
               asis.f_obtener_secretaria(va.id_funcionario) AS secretaria,
               va.descripcion,
               va.dias,
               va.saldo,
               va.id_usuario_reg
        FROM asis.tvacacion va
             JOIN orga.vfuncionario fu ON fu.id_funcionario = va.id_funcionario
             JOIN orga.vfuncionario res ON res.id_funcionario =
               va.id_responsable
             LEFT JOIN orga.vfuncionario sf ON sf.id_funcionario =
               va.id_funcionario_sol
      ) vaca
      JOIN movimiento mm ON mm.id_funcionario = vaca.id_funcionario;
/***********************************F-DEP-MMA-ASIS-SDA-50-01/02/2021*****************************************/

/***********************************I-DEP-MMV-ASIS-SDA-51-02/02/2021*****************************************/
select pxp.f_insert_testructura_gui ('SASL', 'ASIS');
/***********************************F-DEP-MMV-ASIS-SDA-51-02/02/2021*****************************************/

/***********************************I-DEP-MMV-ASIS-SDA-54-02/02/2021*****************************************/
select pxp.f_insert_testructura_gui ('STO', 'ASIS');
select pxp.f_insert_testructura_gui ('VTO', 'SBO');
/***********************************F-DEP-MMV-ASIS-SDA-54-02/02/2021*****************************************/

/***********************************I-DEP-MMV-ASIS-SDA-54-03/02/2021*****************************************/
select pxp.f_insert_testructura_gui ('STT', 'ASIS');
/***********************************F-DEP-MMV-ASIS-SDA-54-03/02/2021*****************************************/

/***********************************I-DEP-MMV-ASIS-SDA-56-05/02/2021*****************************************/
select pxp.f_insert_testructura_gui ('RBM', 'ASIS');
select wf.f_import_ttipo_documento_estado ('insert','BM-EV','SOL-BMA','registro','SOL-BMA','crear','superior','');
/***********************************F-DEP-MMV-ASIS-SDA-56-05/02/2021*****************************************/

/***********************************I-DEP-MMV-ASIS-SDA-66-17/02/2021*****************************************/
select pxp.f_insert_testructura_gui ('RAA', 'AREP');
/***********************************F-DEP-MMV-ASIS-SDA-66-17/02/2021*****************************************/

/***********************************I-DEP-MMV-ASIS-SDA-70-11/03/2021*****************************************/
select wf.f_import_ttipo_documento_estado ('insert','SOL-TE','SOL-TTO','registro','SOL-TTO','crear','superior','');
/***********************************F-DEP-MMV-ASIS-SDA-70-11/03/2021*****************************************/

/***********************************I-DEP-MMV-ASIS-SDA-0-11/05/2021*****************************************/
create or replace view  asis.vteletrabajo as (
                                             select t.id_tele_trabajo,
                                                    t.id_proceso_wf,
                                                    t.id_estado_wf,
                                                    t.id_funcionario,
                                                    f.desc_funcionario2 as funcionario,
                                                    (case
                                                         when t.tipo_teletrabajo != 'Permanente' then
                                                                     t.tipo_teletrabajo ||' - '|| t.tipo_temporal
                                                         else
                                                             t.tipo_teletrabajo
                                                        end) as tipo_teletrabajo,
                                                    (case
                                                         when t.tipo_teletrabajo = 'Permanente' then
                                                                 '<b>Fecha: </b>' ||to_char(t.fecha_inicio::timestamp with time zone, 'DD/MM/YYYY'::text)
                                                         else
                                                                         '<b>Desde: </b>' ||to_char(t.fecha_inicio::timestamp with time zone, 'DD/MM/YYYY'::text) ||' <b>Hasta: </b> '|| to_char(t.fecha_fin::timestamp with time zone, 'DD/MM/YYYY'::text)
                                                        end) as fecha,
                                                    t.fecha_inicio,
                                                    t.fecha_fin,
                                                    t.motivo,
                                                    t.justificacion
                                             from asis.ttele_trabajo t
                                                      inner join orga.vfuncionario f on f.id_funcionario = t.id_funcionario);
/***********************************F-DEP-MMV-ASIS-SDA-0-11/05/2021*****************************************/
/***********************************I-DEP-MMV-ASIS-ETR-4007-18/05/2021*****************************************/
select pxp.f_insert_testructura_gui ('SCN', 'ASIS');
select pxp.f_insert_testructura_gui ('VBN', 'SBO');
/***********************************F-DEP-MMV-ASIS-ETR-4007-18/05/2021*****************************************/

/***********************************I-DEP-MMV-ASIS-1-07/07/2021*****************************************/
CREATE OR REPLACE VIEW asis.vcompensacion_sol(
                                              id_compensacion,
                                              estado_reg,
                                              id_funcionario,
                                              id_responsable,
                                              desde,
                                              hasta,
                                              dias,
                                              desde_comp,
                                              hasta_comp,
                                              dias_comp,
                                              justificacion,
                                              id_usuario_reg,
                                              fecha_reg,
                                              id_usuario_ai,
                                              usuario_ai,
                                              id_usuario_mod,
                                              fecha_mod,
                                              usr_reg,
                                              usr_mod,
                                              id_proceso_wf,
                                              id_estado_wf,
                                              estado,
                                              nro_tramite,
                                              funcionario,
                                              responsable,
                                              social_forestal)
AS
SELECT cpm.id_compensacion,
       cpm.estado_reg,
       cpm.id_funcionario,
       cpm.id_responsable,
       cpm.desde,
       cpm.hasta,
       cpm.dias,
       cpm.desde_comp,
       cpm.hasta_comp,
       cpm.dias_comp,
       cpm.justificacion,
       cpm.id_usuario_reg,
       cpm.fecha_reg,
       cpm.id_usuario_ai,
       cpm.usuario_ai,
       cpm.id_usuario_mod,
       cpm.fecha_mod,
       usu1.cuenta AS usr_reg,
       usu2.cuenta AS usr_mod,
       cpm.id_proceso_wf,
       cpm.id_estado_wf,
       cpm.estado,
       cpm.nro_tramite,
       f.desc_funcionario2 AS funcionario,
       r.desc_funcionario2 AS responsable,
       cpm.social_forestal
FROM asis.tcompensacion cpm
         JOIN segu.tusuario usu1 ON usu1.id_usuario = cpm.id_usuario_reg
         JOIN orga.vfuncionario f ON f.id_funcionario = cpm.id_funcionario
         JOIN orga.vfuncionario r ON r.id_funcionario = cpm.id_responsable
         LEFT JOIN segu.tusuario usu2 ON usu2.id_usuario = cpm.id_usuario_mod;
/***********************************F-DEP-MMV-ASIS-1-07/07/2021*****************************************/
