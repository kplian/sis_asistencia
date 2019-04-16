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
/***********************************F-DAT-MMV-ASIS-49-16/04/2019*****************************************/


 