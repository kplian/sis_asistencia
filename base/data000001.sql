/***********************************I-DAT-RAC-ASIS-48-30/01/2019*****************************************/



INSERT INTO segu.tsubsistema ("codigo", "nombre", "fecha_reg", "prefijo", "estado_reg", "nombre_carpeta", "id_subsis_orig")
VALUES 
  (E'ASIS', E'Sistema de Asistencia', E'2019-01-30', E'ASIS', E'activo', E'asistencia', NULL);

/***********************************F-DAT-RAC-ASIS-48-30/01/2019*****************************************/
/***********************************I-DAT-MMV-ASIS-48-16/04/2019*****************************************/
select pxp.f_insert_tgui ('SISTEMA DE ASISTENCIA', '', 'ASIS', 'si', 1, '', 1, '', '', 'ASIS');
select pxp.f_insert_tgui ('Mes Trabajo', 'Mes Trabajo', 'MTO', 'si', 1, 'sis_asistencia/vista/mes_trabajo/MesTrabajoReg.php', 2, '', 'MesTrabajoReg', 'ASIS');
select pxp.f_insert_tgui ('Mes Trabajo VoBo', 'Mes Trabajo VoBo', 'VOM', 'si', 2, 'sis_asistencia/vista/mes_trabajo/MesTrabajoVoBo.php', 2, '', 'MesTrabajoVoBo', 'ASIS');
select pxp.f_insert_tgui ('Tipo Aplicación ', 'Tipo Aplicación', 'TPS', 'si', 3, 'sis_asistencia/vista/tipo_aplicacion/TipoAplicacion.php', 2, '', 'TipoAplicacion', 'ASIS');
/***********************************F-DAT-MMV-ASIS-48-16/04/2019*****************************************/
/***********************************I-DAT-MMV-ASIS-49-16/04/2019*****************************************/
select wf.f_import_tproceso_macro ('insert','HT', 'ASIS', 'Asistencia','si');
select wf.f_import_tcategoria_documento ('insert','legales', 'Legales');
select wf.f_import_tcategoria_documento ('insert','proceso', 'Proceso');
select wf.f_import_ttipo_proceso ('insert','HT-MT',NULL,NULL,'HT','Mes trabajo','','','si','','','','HT-MT',NULL);
select wf.f_import_ttipo_estado ('insert','borrador','HT-MT','Borrador','si','no','no','todos','','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','asignado','HT-MT','Asignado','no','no','no','funcion_listado','asis.f_lista_funcionario_wf','ninguno','','','si','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','aprobado','HT-MT','Aprobado','no','no','si','anterior','','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_testructura_estado ('insert','borrador','asignado','HT-MT',1,'');
select wf.f_import_testructura_estado ('insert','asignado','aprobado','HT-MT',1,'');

select param.f_import_tplantilla_archivo_excel ('insert','HT','Horas Trabajo','activo',NULL,'9',NULL,'','xls','');
select param.f_import_tcolumna_plantilla_archivo_excel ('insert','ISA','HT','si','',NULL,'3','Salida','salida_manana','string','','activo');
select param.f_import_tcolumna_plantilla_archivo_excel ('insert','NSA','HT','si','',NULL,'7','Salida','salida_noche','string','','activo');
select param.f_import_tcolumna_plantilla_archivo_excel ('insert','COM','HT','si','',NULL,'8','COMP','comp','string','','activo');
select param.f_import_tcolumna_plantilla_archivo_excel ('insert','JUS','HT','si','',NULL,'16','Justificación Extras','justificacion_extra','string','','activo');
--select param.f_import_tcolumna_plantilla_archivo_excel ('insert','CEC','CEC','si','',NULL,'12','CeCo','codigo','string','','activo');
select param.f_import_tcolumna_plantilla_archivo_excel ('insert','NOR','HT','si','',NULL,'9','Normales','total_normal','numeric',',','activo');
select param.f_import_tcolumna_plantilla_archivo_excel ('insert','TIN','HT','si','',NULL,'4','Ingreso','ingreso_tarde','string','','activo');
select param.f_import_tcolumna_plantilla_archivo_excel ('insert','ORD','HT','si','',NULL,'13','Orden','orden','string','','activo');
select param.f_import_tcolumna_plantilla_archivo_excel ('insert','D','HT','si','',NULL,'1','D','dia','entero','','activo');
select param.f_import_tcolumna_plantilla_archivo_excel ('insert','TSA','HT','si','',NULL,'5','Salida','salida_tarde','string','','activo');
select param.f_import_tcolumna_plantilla_archivo_excel ('insert','EXT','HT','si','',NULL,'10','Extras','total_extra','numeric',',','activo');
select param.f_import_tcolumna_plantilla_archivo_excel ('insert','PEP','HT','si','',NULL,'14','PEP','pep','string','','activo');
select param.f_import_tcolumna_plantilla_archivo_excel ('insert','MIN','HT','si','',NULL,'2','Ingreso','ingreso_manana','string','','activo');
select param.f_import_tcolumna_plantilla_archivo_excel ('insert','NIN','HT','si','',NULL,'6','Ingreso','ingreso_noche','string','','activo');
select param.f_import_tcolumna_plantilla_archivo_excel ('insert','NOC','HT','si','',NULL,'11','Noct.','total_nocturna','numeric',',','activo');
select param.f_import_tcolumna_plantilla_archivo_excel ('insert','EXA','HT','si','',NULL,'15','Extras Autorizadas','extras_autorizadas','string','','activo');
/***********************************F-DAT-MMV-ASIS-49-16/04/2019*****************************************/
/***********************************I-DAT-MMV-ASIS-2-30/04/2019*****************************************/
select pxp.f_insert_tgui ('<i class="fa fa-calendar" style="font-size:24px"></i>  SISTEMA DE ASISTENCIA', '', 'ASIS', 'si', 1, '', 1, '', '', 'ASIS');
select pxp.f_insert_tgui ('Mes Trabajo', 'Mes Trabajo', 'MTO', 'si', 1, 'sis_asistencia/vista/mes_trabajo/MesTrabajoReg.php', 2, '', 'MesTrabajoReg', 'ASIS');
select pxp.f_insert_tgui ('Mes Trabajo VoBo', 'Mes Trabajo VoBo', 'VOM', 'si', 2, 'sis_asistencia/vista/mes_trabajo/MesTrabajoVoBo.php', 2, '', 'MesTrabajoVoBo', 'ASIS');
select pxp.f_insert_tgui ('Tipo Aplicación ', 'Tipo Aplicación', 'TPS', 'si', 3, 'sis_asistencia/vista/tipo_aplicacion/TipoAplicacion.php', 2, '', 'TipoAplicacion', 'ASIS');
select pxp.f_insert_tgui ('Reportes', 'Reportes', 'AREP', 'si', 4, '', 2, '', '', 'ASIS');

select wf.f_import_tproceso_macro ('insert','HT', 'ASIS', 'Asistencia','si');
select wf.f_import_tcategoria_documento ('insert','legales', 'Legales');
select wf.f_import_tcategoria_documento ('insert','proceso', 'Proceso');
select wf.f_import_ttipo_proceso ('insert','HT-MT',NULL,NULL,'HT','Mes trabajo','','','si','','','','HT-MT',NULL);
select wf.f_import_ttipo_estado ('insert','borrador','HT-MT','Borrador','si','no','no','todos','','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','asignado','HT-MT','Asignado','no','no','no','funcion_listado','asis.f_lista_funcionario_wf','ninguno','','','si','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_ttipo_estado ('insert','aprobado','HT-MT','Aprobado','no','no','si','anterior','','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL);
select wf.f_import_testructura_estado ('insert','borrador','asignado','HT-MT',1,'');
select wf.f_import_testructura_estado ('insert','asignado','aprobado','HT-MT',1,'');
/***********************************F-DAT-MMV-ASIS-2-30/04/2019*****************************************/



/***********************************I-DAT-JDJ-ASIS-48-14/08/2019*****************************************/
select pxp.f_insert_tgui ('Control diario', 'Control diario', 'CONDIA', 'si', 4, '', 2, '', '', 'ASIS');
select pxp.f_insert_tgui ('Ingreso salida', 'Ingreso salida', 'INGSAL', 'si', 1, 'sis_asistencia/vista/ingreso_salida/IngresoSalida.php', 3, '', 'IngresoSalida', 'ASIS');
/***********************************F-DAT-JDJ-ASIS-48-14/08/2019*****************************************/

/***********************************I-DAT-MMV-ASIS-15-02/09/2019*****************************************/
select pxp.f_insert_tgui ('Reporte Retrasos', 'Reporte Retrasos', 'RRET', 'si', 2, 'sis_asistencia/vista/reportes/FormReporteRetrasos.php', 3, '', 'FormReporteRetrasos', 'ASIS');
/***********************************F-DAT-MMV-ASIS-15-02/09/2019*****************************************/
