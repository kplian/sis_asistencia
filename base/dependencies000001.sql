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
