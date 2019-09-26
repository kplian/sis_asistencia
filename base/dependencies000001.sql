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
select pxp.f_insert_testructura_gui ('CCT', 'HFT');
/***********************************F-DEP-MMV-ASIS-18-26/09/2019*****************************************/
