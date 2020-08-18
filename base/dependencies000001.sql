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
/***********************************I-DEP-MMV-ASIS-20-23/10/2019*****************************************/
select pxp.f_insert_testructura_gui ('ASIS', 'SISTEMA');
select pxp.f_insert_testructura_gui ('AREP', 'ASIS');
select pxp.f_insert_testructura_gui ('RTH', 'AREP');
select pxp.f_insert_testructura_gui ('RRET', 'AREP');
select pxp.f_insert_testructura_gui ('PARM', 'ASIS');
select pxp.f_insert_testructura_gui ('RHO', 'PARM');
select pxp.f_insert_testructura_gui ('TPS', 'PARM');
select pxp.f_insert_testructura_gui ('RMAR', 'AREP');
select pxp.f_insert_testructura_gui ('TLS', 'PARM');
select pxp.f_insert_testructura_gui ('APR', 'ASIS');
select pxp.f_insert_testructura_gui ('PRH', 'APR');
select pxp.f_insert_testructura_gui ('MVA', 'APR');
select pxp.f_insert_testructura_gui ('MTO', 'APR');
select pxp.f_insert_testructura_gui ('SBO', 'ASIS');
select pxp.f_insert_testructura_gui ('PERMI', 'APR');
select pxp.f_insert_testructura_gui ('SOLVAC', 'APR');
select pxp.f_insert_testructura_gui ('VOB', 'SBO');
select pxp.f_insert_testructura_gui ('PVO', 'SBO');
select pxp.f_insert_testructura_gui ('VOM', 'SBO');
select pxp.f_insert_testructura_gui ('ASM', 'ASIS');
select pxp.f_insert_testructura_gui ('MFS', 'ASM');
select pxp.f_insert_testructura_gui ('marc', 'ASM');
select pxp.f_insert_testructura_gui ('PAR', 'ASM');
select pxp.f_insert_testructura_gui ('CCT', 'ASM');
select pxp.f_insert_testructura_gui ('INGSAL', 'ASIS');
/***********************************F-DEP-MMV-ASIS-20-23/10/2019*****************************************/


/***********************************I-DEP-APS-ASIS-22-31/10/2019*****************************************/
select pxp.f_insert_testructura_gui ('VACFUN', 'APR');
/***********************************F-DEP-APS-ASIS-22-31/10/2019*****************************************/

/***********************************I-DEP-MMV-ASIS-22-18/08/2020*****************************************/
select pxp.f_insert_testructura_gui ('ASIS', 'SISTEMA');
select pxp.f_insert_testructura_gui ('PARM', 'ASIS');
select pxp.f_insert_testructura_gui ('RHO', 'PARM');
select pxp.f_insert_testructura_gui ('TPS', 'PARM');
select pxp.f_insert_testructura_gui ('TLS', 'PARM');
select pxp.f_insert_testructura_gui ('PERMI', 'ASIS');
select pxp.f_insert_testructura_gui ('SOLVAC', 'ASIS');
select pxp.f_insert_testructura_gui ('CSA', 'ASIS');
select pxp.f_insert_testructura_gui ('CON', 'ASIS');
select pxp.f_insert_testructura_gui ('AREP', 'ASIS');
select pxp.f_insert_testructura_gui ('HFT', 'ASIS');
select pxp.f_insert_testructura_gui ('SBO', 'ASIS');
select pxp.f_insert_testructura_gui ('CONDIA', 'ASIS');
select pxp.f_insert_testructura_gui ('VACFUN', 'CON');
select pxp.f_insert_testructura_gui ('PRH', 'CON');
select pxp.f_insert_testructura_gui ('MAB', 'CON');
select pxp.f_insert_testructura_gui ('RRET', 'AREP');
select pxp.f_insert_testructura_gui ('MTO', 'HFT');
select pxp.f_insert_testructura_gui ('CCT', 'HFT');
select pxp.f_insert_testructura_gui ('VOB', 'SBO');
select pxp.f_insert_testructura_gui ('PVO', 'SBO');
select pxp.f_insert_testructura_gui ('VOM', 'SBO');
select pxp.f_insert_testructura_gui ('INGSAL', 'CONDIA');
/***********************************F-DEP-MMV-ASIS-22-18/08/2020*****************************************/

