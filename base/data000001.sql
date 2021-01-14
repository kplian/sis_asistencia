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
/***********************************I-DAT-MMV-ASIS-18-26/09/2019*****************************************/
select pxp.f_insert_tgui ('Hoja de tiempo', 'Hoja de tiempo', 'HFT', 'si', 1, '', 2, '', '', 'ASIS');
select pxp.f_insert_tgui ('Centro Costo HT', 'Centro Costo HT', 'CCT', 'si', 3, 'sis_asistencia/vista/mes_trabajo/MesTrabajoCc.php', 3, '', 'MesTrabajoCc', 'ASIS');
/***********************************F-DAT-MMV-ASIS-18-26/09/2019*****************************************/

/***********************************I-DAT-MMV-ASIS-1-22/12/2020*****************************************/
select pxp.f_insert_tgui ('<i class="fa fa-calendar" style="font-size:24px"></i>  SISTEMA DE ASISTENCIA', '', 'ASIS', 'si', 1, '', 1, '', '', 'ASIS');
select pxp.f_insert_tgui ('Mes Trabajo', 'Mes Trabajo', 'MTO', 'si', 1, 'sis_asistencia/vista/mes_trabajo/MesTrabajoReg.php', 3, '', 'MesTrabajoReg', 'ASIS');
select pxp.f_insert_tgui ('Mes Trabajo VoBo', 'Mes Trabajo VoBo', 'VOM', 'si', 3, 'sis_asistencia/vista/mes_trabajo/MesTrabajoVoBo.php', 3, '', 'MesTrabajoVoBo', 'ASIS');
select pxp.f_insert_tgui ('Tipo Aplicación ', 'Tipo Aplicación ', 'TPS', 'si', 2, 'sis_asistencia/vista/tipo_aplicacion/TipoAplicacion.php', 3, '', 'TipoAplicacion', 'ASIS');
select pxp.f_insert_tgui ('Reportes', 'Reportes', 'AREP', 'si', 5, '', 2, '', '', 'ASIS');
select pxp.f_insert_tgui ('Ingreso salida', 'Ingreso salida', 'INGSAL', 'si', 1, 'sis_asistencia/vista/ingreso_salida/IngresoSalida.php', 3, '', 'IngresoSalida', 'ASIS');
select pxp.f_insert_tgui ('Reporte Retrasos', 'Reporte Retrasos', 'RRET', 'si', 1, 'sis_asistencia/vista/reportes/FormReporteRetrasos.php', 3, '', 'FormReporteRetrasos', 'ASIS');
select pxp.f_insert_tgui ('Hoja de tiempo', 'Hoja de tiempo', 'HFT', 'si', 6, '', 2, '', '', 'ASIS');
select pxp.f_insert_tgui ('Centro Costo HT', 'Centro Costo HT', 'CCT', 'si', 2, 'sis_asistencia/vista/mes_trabajo/MesTrabajoCc.php', 3, '', 'MesTrabajoCc', 'ASIS');
select pxp.f_insert_tgui ('Reporte Total Horas', 'Reporte Total Horas', 'RTH', 'si', 1, 'sis_asistencia/vista/reporte_mes_trabajo/ReporteMesTrabajo.php', 3, '', 'ReporteMesTrabajo', 'ASIS');
select pxp.f_insert_tgui ('Rango de Horarios', 'Rango de Horarios', 'RHO', 'si', 1, 'sis_asistencia/vista/rango_horario/RangoHorario.php', 3, '', 'RangoHorario', 'ASIS');
select pxp.f_insert_tgui ('Parámetros', 'Parámetros', 'PARM', 'si', 1, '', 2, '', '', 'ASIS');
select pxp.f_insert_tgui ('Solicitud de Permisos', 'Solicitud de Permisos', 'PERMI', 'si', 2, 'sis_asistencia/vista/permiso/PermisoReg.php', 2, '', 'PermisoReg', 'ASIS');
select pxp.f_insert_tgui ('Vacaciones', 'Vacaciones', 'VAC', 'si', 10, '', 3, '', '', 'ASIS');
select pxp.f_insert_tgui ('Solicitud de Vacación', 'Solicitud de Vacación', 'SOLVAC', 'si', 3, 'sis_asistencia/vista/vacacion/SolicitudVacaciones.php', 2, '', 'SolicitudVacaciones', 'ASIS');
select pxp.f_insert_tgui ('Reporte de Marcado', 'Reporte de marcacion', 'RMAR', 'si', 3, 'sis_asistencia/vista/reportes/FormReporteMarcacion.php', 3, '', 'FormReporteMarcacion', 'ASIS');
select pxp.f_insert_tgui ('VoBo Vacaciones ', 'VoBo Vacaciones ', 'VOB', 'si', 1, 'sis_asistencia/vista/vacacion/VacacionVoBo.php', 3, '', 'VacacionVoBo', 'ASIS');
select pxp.f_insert_tgui ('Tipo Permiso', 'Tipo Permiso', 'TLS', 'si', 3, 'sis_asistencia/vista/tipo_permiso/TipoPermiso.php', 3, '', 'TipoPermiso', 'ASIS');
select pxp.f_insert_tgui ('Vacaciones', 'Movimiento Vacaciones', 'MVA', 'si', 10, 'sis_asistencia/vista/movimiento_vacacion/MovimientoVacacion.php', 4, '', 'MovimientoVacacion', 'ASIS');
select pxp.f_insert_tgui ('VoBo Permiso', 'VoBo Permiso', 'PVO', 'si', 2, 'sis_asistencia/vista/permiso/PermisoVoBo.php', 3, '', 'PermisoVoBo', 'ASIS');
select pxp.f_insert_tgui ('Consulta Permiso', 'Consulta Permiso', 'PRH', 'si', 2, 'sis_asistencia/vista/permiso/PermisoRRHH.php', 3, '', 'PermisoRRHH', 'ASIS');
select pxp.f_insert_tgui ('VoBo', 'VoBo', 'SBO', 'si', 8, '', 2, '', '', 'ASIS');
select pxp.f_insert_tgui ('Historial Vacaciones', 'Historial Vacaciones', 'VACFUN', 'si', 1, 'sis_asistencia/vista/movimiento_vacacion/MovVacUsuario.php', 3, '', 'MovVacUsuario', 'ASIS');
select pxp.f_insert_tgui ('Consultas', 'Consultas', 'CON', 'si', 4, '', 2, '', '', 'ASIS');
select pxp.f_insert_tgui ('Marcacion Biometrico', 'Marcacion Biometrico', 'MAB', 'si', 3, 'sis_asistencia/vista/transaccion/Transaccion.php', 3, '', 'Transaccion', 'ASIS');
select pxp.f_insert_tgui ('Feriados', 'Feriados', 'FERIA', 'si', 4, 'sis_parametros/vista/feriado/Feriado.php', 3, '', 'Feriado', 'ASIS');
select pxp.f_insert_tgui ('Reposición', 'Reposición', 'RPN', 'si', 4, 'sis_asistencia/vista/reposicion/Reposicion.php', 3, '', 'Reposicion', 'ASIS');
select pxp.f_insert_tgui ('Reporte Vacaciones', 'Reporte Vacaciones', 'RVS', 'si', 4, 'sis_asistencia/vista/reportes/FormReporteVacacion.php', 3, '', 'FormReporteVacacion', 'ASIS');
select pxp.f_insert_tgui ('Seguimiento Permiso', 'Seguimiento Permiso', 'CPO', 'si', 12, 'sis_asistencia/vista/consulta_rrhh/FormFiltro.php', 2, '', 'FormFiltro', 'ASIS');
select pxp.f_insert_tgui ('Seguimiento Vacación', 'Seguimiento Vacación', 'CVR', 'si', 13, 'sis_asistencia/vista/consulta_rrhh/FormFiltroVacacion.php', 2, '', 'FormFiltroVacacion', 'ASIS');
/***********************************F-DAT-MMV-ASIS-1-22/12/2020*****************************************/

/***********************************I-DAT-MMV-ASIS-2-22/12/2020*****************************************/
select wf.f_import_tproceso_macro ('insert','VAC', 'ASIS', 'Vacaciones','si');
select wf.f_import_tcategoria_documento ('insert','legales', 'Legales');
select wf.f_import_tcategoria_documento ('insert','proceso', 'Proceso');
select wf.f_import_ttipo_proceso ('insert','VAC-PRO',NULL,NULL,'VAC','Vacaciones','asis.vvacacion','va.id_vacacion','si','','obligatorio','','VAC-PRO',NULL);
select wf.f_import_ttipo_estado ('insert','registro','VAC-PRO','Registro','si','no','no','ninguno','','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL,'no',NULL,NULL,NULL,NULL,'no',NULL,NULL,NULL);
select wf.f_import_ttipo_estado ('insert','vobo','VAC-PRO','VoBo','no','no','no','funcion_listado','asis.f_lista_funcionario_jefe_vaciones','ninguno','','','no','no',NULL,'<h3><b>SOLICITUD DE VACACIÓN</b></h3>
<p style="font-size: 15px;"><b>Fecha solicitud:</b> {$tabla.fecha_solicitud}</p>
<p style="font-size: 15px;"><b>Solicitud para:</b> {$tabla.funcionario_solicitante}</p>
<p style="font-size: 15px;"><b>Desde:</b> {$tabla.fecha_inicio} <b>Hasta:</b> {$tabla.fecha_fin}</p>
<p style="font-size: 15px;"><b>Días solicitados:</b> {$tabla.dias}</p>
<p style="font-size: 15px;"><b>Justificación:</b> {$tabla.descripcion}</p>','Aviso WF ,  {PROCESO_MACRO}','','no','','','','','','','',NULL,'no',NULL,NULL,NULL,NULL,'no',NULL,NULL,NULL);
select wf.f_import_ttipo_estado ('insert','aprobado','VAC-PRO','Aprobado','no','no','si','anterior','','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL,'no',NULL,NULL,NULL,NULL,'no',NULL,NULL,NULL);
select wf.f_import_ttipo_estado ('insert','rechazado','VAC-PRO','Rechazado','no','no','si','ninguno','','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL,'no','Rechazado','','',NULL,'no',NULL,'','');
select wf.f_import_ttipo_estado ('insert','cancelado','VAC-PRO','Cancelado','no','no','si','ninguno','','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL,'no','Cancelado','','',NULL,'no',NULL,'','');
select wf.f_import_testructura_estado ('insert','registro','vobo','VAC-PRO',1,'','no');
select wf.f_import_testructura_estado ('insert','vobo','aprobado','VAC-PRO',1,'','no');
select wf.f_import_testructura_estado ('insert','vobo','rechazado','VAC-PRO',1,'','no');
select wf.f_import_testructura_estado ('insert','aprobado','cancelado','VAC-PRO',1,'','no');

select wf.f_import_tproceso_macro ('insert','PER', 'ASIS', 'Permisos','si');
select wf.f_import_tcategoria_documento ('insert','legales', 'Legales');
select wf.f_import_tcategoria_documento ('insert','proceso', 'Proceso');
select wf.f_import_ttipo_proceso ('insert','PER-ASI',NULL,NULL,'PER','Permisos','asis.vpermiso','p.id_permiso','si','','obligatorio','','PER-ASI',NULL);
select wf.f_import_ttipo_estado ('insert','registro','PER-ASI','Registro','si','no','no','ninguno','','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL,'no',NULL,NULL,NULL,NULL,'no',NULL,NULL,NULL);
select wf.f_import_ttipo_estado ('insert','vobo','PER-ASI','VoBo','no','no','no','funcion_listado','asis.f_lista_funcionario_jefe','ninguno','','','si','no',NULL,'<h3><b>SOLICITUD DE PERMISO</b></h3>
<p style="font-size: 15px;"><b>Tipo permiso:</b> {$tabla.tipo_permiso}</p>
<p style="font-size: 15px;"><b>Fecha solicitud:</b> {$tabla.fecha_solicitud}</p>
<p style="font-size: 15px;"><b>Solicitud para:</b> {$tabla.funcionario_solicitante}</p>
<p style="font-size: 15px;"><b>Desde:</b> {$tabla.hro_desde} <b>Hasta:</b> {$tabla.hro_hasta}</p>
<p style="font-size: 15px;"><b>Justificacion:</b> {$tabla.motivo}</p>','Aviso WF ,  {PROCESO_MACRO}','','no','','','','','','','',NULL,'no','VoBo','','',NULL,'no',NULL,NULL,NULL);
select wf.f_import_ttipo_estado ('insert','aprobado','PER-ASI','Aprobado','no','no','si','ninguno','','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL,'no',NULL,NULL,NULL,NULL,'no',NULL,NULL,NULL);
select wf.f_import_ttipo_estado ('insert','rechazado','PER-ASI','Rechazado','no','no','si','ninguno','','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL,'no','Rechazado','','',NULL,'no',NULL,'','');
select wf.f_import_ttipo_estado ('insert','cancelado','PER-ASI','Cancelado','no','no','si','ninguno','','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL,'no','Cancelado','','',NULL,'no',NULL,'','');
select wf.f_import_ttipo_estado ('insert','reposicion','PER-ASI','reposicion','no','no','no','ninguno','','ninguno','','','no','no',NULL,'<font color="99CC00" size="5"><font size="4">{TIPO_PROCESO}</font></font><br><br><b>&nbsp;</b>Tramite:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; <b>{NUM_TRAMITE}</b><br><b>&nbsp;</b>Usuario :<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {USUARIO_PREVIO} </b>en estado<b>&nbsp; {ESTADO_ANTERIOR}<br></b>&nbsp;<b>Responsable:&nbsp;&nbsp; &nbsp;&nbsp; </b><b>{FUNCIONARIO_PREVIO}&nbsp; {DEPTO_PREVIO}<br>&nbsp;</b>Estado Actual<b>: &nbsp; &nbsp;&nbsp; {ESTADO_ACTUAL}</b><br><br><br>&nbsp;{OBS} <br>','Aviso WF ,  {PROCESO_MACRO}  ({NUM_TRAMITE})','','no','','','','','','','',NULL,'no','reposicion','','',NULL,'no',NULL,NULL,NULL);
select wf.f_import_ttipo_documento ('insert','EVD','PER-ASI','Evidencia','Evidencia','','escaneado',1.00,'{}','no','',NULL,'');
select wf.f_import_testructura_estado ('insert','registro','vobo','PER-ASI',1,'','no');
select wf.f_import_testructura_estado ('insert','vobo','aprobado','PER-ASI',1,'','no');
select wf.f_import_testructura_estado ('insert','vobo','rechazado','PER-ASI',1,'','no');
select wf.f_import_testructura_estado ('insert','aprobado','cancelado','PER-ASI',1,'','no');

/***********************************F-DAT-MMV-ASIS-2-22/12/2020*****************************************/


/***********************************I-DAT-MMV-ASIS-3-22/12/2020*****************************************/

INSERT INTO asis.ttipo_permiso ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_usuario_ai", "usuario_ai", "obs_dba", "codigo", "nombre", "tiempo", "documento", "reposcion", "rango")
VALUES 
  (430, NULL, E'2020-10-13 14:47:31.558', NULL, E'activo', NULL, E'NULL', NULL, E'CPS', E'Caja Petrolera de Salud', E'00:00:00', E'si', E'no', E'si'),
  (430, 430, E'2020-10-13 14:58:42.489', E'2020-10-13 15:05:55.161', E'activo', NULL, E'NULL', NULL, E'PER', E'Personal', E'01:30:00', E'no', E'si', E'si'),
  (430, NULL, E'2020-10-13 15:06:15.776', NULL, E'activo', NULL, E'NULL', NULL, E'TRA', E'Trabajo', E'00:00:00', E'no', E'no', E'no');
/***********************************F-DAT-MMV-ASIS-3-22/12/2020*****************************************/

/***********************************I-DAT-MMV-ASIS-4-22/12/2020*****************************************/

INSERT INTO param.tferiado ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_usuario_ai", "usuario_ai", "obs_dba", "id_lugar", "descripcion", "fecha", "tipo", "id_gestion")
VALUES 
  (433, NULL, E'2019-10-23 09:47:47.932', NULL, E'activo', NULL, E'NULL', NULL, 66, E'Feriado Departamenal Potosí', E'2019-11-10', E'permanente', 3),
  (433, NULL, E'2019-10-23 09:51:41.707', NULL, E'activo', NULL, E'NULL', NULL, 70, E'Feriado Departamental de Beni', E'2019-11-18', E'permanente', 3),
  (433, NULL, E'2019-10-23 11:54:39.962', NULL, E'activo', NULL, E'NULL', NULL, 381, E'Feriado Departamental de Beni', E'2019-11-18', E'permanente', 3),
  (433, NULL, E'2019-10-23 12:07:23.434', NULL, E'activo', NULL, E'NULL', NULL, 73, E'Feriado Departamental de Beni', E'2019-11-18', E'permanente', 3),
  (433, NULL, E'2019-10-23 14:33:47.783', NULL, E'activo', NULL, E'NULL', NULL, 216, E'Feriado Departamental de Chuquisaca', E'2019-05-25', E'permanente', 3),
  (1, NULL, E'2020-05-25 12:43:34.079', E'2020-05-25 12:43:34.079', E'activo', NULL, NULL, NULL, 1, E'Año nuevo', E'2020-01-01', E'permanente', 4),
  (1, NULL, E'2020-05-25 12:43:34.079', E'2020-05-25 12:43:34.079', E'activo', NULL, NULL, NULL, 1, E'Fundación del Estado Plurinacional de Bolivia', E'2020-01-22', E'permanente', 4),
  (1, NULL, E'2020-05-25 12:43:34.079', E'2020-05-25 12:43:34.079', E'activo', NULL, NULL, NULL, 68, E'Feriado Departamental de Oruro', E'2020-02-10', E'permanente', 4),
  (1, NULL, E'2020-05-25 12:43:34.079', E'2020-05-25 12:43:34.079', E'activo', NULL, NULL, NULL, 1, E'Carnaval', E'2020-02-12', E'permanente', 4),
  (1, NULL, E'2020-05-25 12:43:34.079', E'2020-05-25 12:43:34.079', E'activo', NULL, NULL, NULL, 1, E'Carnaval', E'2020-02-13', E'permanente', 4),
  (1, NULL, E'2020-05-25 12:43:34.079', E'2020-05-25 12:43:34.079', E'activo', NULL, NULL, NULL, 65, E'Feriado Departamental de Tarija', E'2020-04-15', E'permanente', 4),
  (1, NULL, E'2020-05-25 12:43:34.079', E'2020-05-25 12:43:34.079', E'activo', NULL, NULL, NULL, 1, E'Día del trabajador', E'2020-05-01', E'permanente', 4),
  (1, NULL, E'2020-05-25 12:43:34.079', E'2020-05-25 12:43:34.079', E'activo', NULL, NULL, NULL, 1, E'Coprus Christi', E'2020-05-31', E'permanente', 4),
  (1, NULL, E'2020-05-25 12:43:34.079', E'2020-05-25 12:43:34.079', E'activo', NULL, NULL, NULL, 1, E'Solisticio de invierno', E'2020-06-21', E'permanente', 4),
  (1, NULL, E'2020-05-25 12:43:34.079', E'2020-05-25 12:43:34.079', E'activo', NULL, NULL, NULL, 1, E'Día de la Patria', E'2020-08-06', E'permanente', 4),
  (1, NULL, E'2020-05-25 12:43:34.079', E'2020-05-25 12:43:34.079', E'activo', NULL, NULL, NULL, 1, E'Día de los difuntos', E'2020-11-02', E'permanente', 4),
  (1, NULL, E'2020-05-25 12:43:34.079', E'2020-05-25 12:43:34.079', E'activo', NULL, NULL, NULL, 1, E'Navidad', E'2020-12-25', E'permanente', 4),
  (1, 513, E'2020-05-25 12:43:34.079', E'2020-05-25 12:44:24.002', E'activo', NULL, E'NULL', NULL, 61, E'Aniversario Departamental de La Paz', E'2020-07-16', E'permanente', 4),
  (1, 513, E'2020-05-25 12:43:34.079', E'2020-05-25 12:44:40.859', E'activo', NULL, E'NULL', NULL, 2, E'Aniversario Departamental de Cochabamba', E'2020-09-14', E'permanente', 4),
  (1, 513, E'2020-05-25 12:43:34.079', E'2020-05-25 12:44:49.737', E'activo', NULL, E'NULL', NULL, 63, E'Aniversario Departamental de Santa Cruz', E'2020-09-24', E'permanente', 4),
  (1, 513, E'2020-05-25 12:43:34.079', E'2020-05-25 12:45:05.970', E'activo', NULL, E'NULL', NULL, 66, E'Feriado Departamenal Potosí', E'2020-11-10', E'permanente', 4),
  (1, 513, E'2020-05-25 12:43:34.079', E'2020-05-25 12:45:17.087', E'activo', NULL, E'NULL', NULL, 70, E'Feriado Departamental de Beni', E'2020-11-18', E'permanente', 4),
  (1, 513, E'2020-05-25 12:43:34.079', E'2020-05-25 12:45:25.582', E'activo', NULL, E'NULL', NULL, 381, E'Feriado Departamental de Beni', E'2020-11-18', E'permanente', 4),
  (1, 513, E'2020-05-25 12:43:34.079', E'2020-05-25 12:45:33.578', E'activo', NULL, E'NULL', NULL, 73, E'Feriado Departamental de Beni', E'2020-11-18', E'permanente', 4),
  (433, 513, E'2019-10-15 15:15:41.686', E'2020-05-25 12:46:32.889', E'activo', NULL, E'NULL', NULL, 1, E'Año nuevo', E'2019-01-01', E'permanente', 3),
  (433, 513, E'2019-10-15 15:18:42.941', E'2020-05-25 12:46:40.782', E'activo', NULL, E'NULL', NULL, 1, E'Fundación del Estado Plurinacional de Bolivia', E'2019-01-22', E'permanente', 3),
  (433, 513, E'2019-10-15 15:20:33.065', E'2020-05-25 12:46:47.688', E'activo', NULL, E'NULL', NULL, 1, E'Carnaval', E'2019-02-12', E'permanente', 3),
  (433, 513, E'2019-10-15 15:21:14.026', E'2020-05-25 12:46:52.874', E'activo', NULL, E'NULL', NULL, 1, E'Carnaval', E'2019-02-13', E'permanente', 3),
  (433, 513, E'2019-10-15 15:22:04.221', E'2020-05-25 12:46:58.696', E'activo', NULL, E'NULL', NULL, 1, E'Día del trabajador', E'2019-05-01', E'permanente', 3),
  (433, 513, E'2019-10-15 15:23:06.083', E'2020-05-25 12:47:06.697', E'activo', NULL, E'NULL', NULL, 1, E'Coprus Christi', E'2019-05-31', E'permanente', 3),
  (433, 513, E'2019-10-15 15:25:36.211', E'2020-05-25 12:47:15.744', E'activo', NULL, E'NULL', NULL, 1, E'Solisticio de invierno', E'2019-06-21', E'permanente', 3),
  (433, 513, E'2019-10-15 15:26:41.339', E'2020-05-25 12:47:27.048', E'activo', NULL, E'NULL', NULL, 1, E'Día de la Patria', E'2019-08-06', E'permanente', 3),
  (433, 513, E'2019-10-15 15:27:19.392', E'2020-05-25 12:47:34.277', E'activo', NULL, E'NULL', NULL, 1, E'Día de los difuntos', E'2019-11-02', E'permanente', 3),
  (433, 513, E'2019-10-15 15:28:13.505', E'2020-05-25 12:47:39.629', E'activo', NULL, E'NULL', NULL, 1, E'Navidad', E'2019-12-25', E'permanente', 3),
  (433, 513, E'2019-10-23 09:46:08.309', E'2020-05-25 12:47:47.166', E'activo', NULL, E'NULL', NULL, 68, E'Feriado Departamental de Oruro', E'2019-02-10', E'permanente', 3),
  (433, 513, E'2019-10-23 09:49:09.769', E'2020-05-25 12:47:57.232', E'activo', NULL, E'NULL', NULL, 65, E'Feriado Departamental de Tarija', E'2019-04-15', E'permanente', 3),
  (433, 513, E'2017-10-27 10:51:45.314', E'2020-05-25 12:48:24.040', E'activo', NULL, E'NULL', NULL, 63, E'Aniversario Departamental de Santa Cruz', E'2019-09-24', E'permanente', 3),
  (1, 513, E'2017-10-27 10:05:57.632', E'2020-05-25 12:48:29.476', E'activo', NULL, E'NULL', NULL, 2, E'Aniversario Departamental de Cochabamba', E'2019-09-14', E'permanente', 3),
  (1, 513, E'2017-10-27 10:03:34.611', E'2020-05-25 12:48:35.395', E'activo', NULL, E'NULL', NULL, 61, E'Aniversario Departamental de La Paz', E'2019-07-16', E'permanente', 3),
  (1, 513, E'2020-05-25 12:43:34.079', E'2020-05-27 04:19:36.154', E'activo', NULL, E'NULL', NULL, 1, E'Feriado Departamental de Chuquisaca', E'2020-05-25', E'permanente', 4),
  (1, 563, E'2020-12-09 16:07:19.180', E'2020-12-22 16:04:15.126', E'activo', NULL, E'NULL', NULL, 1, E'Año nuevo', E'2021-01-01', E'permanente', 5),
  (1, 563, E'2020-12-09 16:07:19.193', E'2020-12-22 22:45:38.055', E'activo', NULL, E'NULL', NULL, 1, E'Fundación del Estado Plurinacional de Bolivia', E'2021-01-22', E'permanente', 5),
  (1, 563, E'2020-12-09 16:07:19.206', E'2020-12-22 22:45:45.376', E'activo', NULL, E'NULL', NULL, 68, E'Feriado Departamental de Oruro', E'2021-02-10', E'permanente', 5),
  (1, 563, E'2020-12-09 16:07:19.218', E'2020-12-22 22:45:53.489', E'activo', NULL, E'NULL', NULL, 1, E'Carnaval', E'2021-02-12', E'permanente', 5),
  (1, 563, E'2020-12-09 16:07:19.290', E'2020-12-22 22:46:00.347', E'activo', NULL, E'NULL', NULL, 1, E'Carnaval', E'2021-02-13', E'permanente', 5),
  (1, 563, E'2020-12-09 16:07:19.351', E'2020-12-22 22:46:08.505', E'activo', NULL, E'NULL', NULL, 65, E'Feriado Departamental de Tarija', E'2021-04-15', E'permanente', 5),
  (1, 563, E'2020-12-09 16:07:19.364', E'2020-12-22 22:46:27.930', E'activo', NULL, E'NULL', NULL, 1, E'Día del trabajador', E'2021-05-01', E'permanente', 5),
  (1, 563, E'2020-12-09 16:07:19.374', E'2020-12-22 22:46:33.526', E'activo', NULL, E'NULL', NULL, 1, E'Coprus Christi', E'2021-05-31', E'permanente', 5),
  (1, 563, E'2020-12-09 16:07:19.384', E'2020-12-22 22:46:39.610', E'activo', NULL, E'NULL', NULL, 1, E'Solisticio de invierno', E'2021-06-21', E'permanente', 5),
  (1, 563, E'2020-12-09 16:07:19.393', E'2020-12-22 22:46:46.677', E'activo', NULL, E'NULL', NULL, 1, E'Día de la Patria', E'2021-08-06', E'permanente', 5),
  (1, 563, E'2020-12-09 16:07:19.404', E'2020-12-22 22:46:52.698', E'activo', NULL, E'NULL', NULL, 1, E'Día de los difuntos', E'2021-11-02', E'permanente', 5),
  (1, 563, E'2020-12-09 16:07:19.419', E'2020-12-22 22:46:57.971', E'activo', NULL, E'NULL', NULL, 1, E'Navidad', E'2021-12-25', E'permanente', 5),
  (1, 563, E'2020-12-09 16:07:19.433', E'2020-12-22 22:47:03.542', E'activo', NULL, E'NULL', NULL, 61, E'Aniversario Departamental de La Paz', E'2021-07-16', E'permanente', 5),
  (1, 563, E'2020-12-09 16:07:19.447', E'2020-12-22 22:47:09.690', E'activo', NULL, E'NULL', NULL, 2, E'Aniversario Departamental de Cochabamba', E'2021-09-14', E'permanente', 5),
  (1, 563, E'2020-12-09 16:07:19.461', E'2020-12-22 22:47:16.079', E'activo', NULL, E'NULL', NULL, 63, E'Aniversario Departamental de Santa Cruz', E'2021-09-24', E'permanente', 5),
  (1, 563, E'2020-12-09 16:07:19.472', E'2020-12-22 22:47:21.544', E'activo', NULL, E'NULL', NULL, 66, E'Feriado Departamenal Potosí', E'2021-11-10', E'permanente', 5),
  (1, 563, E'2020-12-09 16:07:19.482', E'2020-12-22 22:47:32.759', E'activo', NULL, E'NULL', NULL, 70, E'Feriado Departamental de Beni', E'2021-11-18', E'permanente', 5),
  (1, 563, E'2020-12-09 16:07:19.493', E'2020-12-22 22:47:42.723', E'activo', NULL, E'NULL', NULL, 381, E'Feriado Departamental de Beni', E'2021-11-18', E'permanente', 5),
  (1, 563, E'2020-12-09 16:07:19.505', E'2020-12-22 22:47:49.244', E'activo', NULL, E'NULL', NULL, 73, E'Feriado Departamental de Beni', E'2021-11-18', E'permanente', 5),
  (1, 563, E'2020-12-09 16:07:19.516', E'2020-12-22 22:47:56.085', E'activo', NULL, E'NULL', NULL, 1, E'Feriado Departamental de Chuquisaca', E'2021-05-25', E'permanente', 5);
/***********************************F-DAT-MMV-ASIS-4-22/12/2020*****************************************/
/***********************************I-DAT-MMV-ASIS-1-07/01/2021*****************************************/
select pxp.f_insert_tgui ('Seguimiento Vacación', 'Seguimiento Vacación', 'CVR', 'si', 13, 'sis_asistencia/vista/consulta_rrhh/VacacionRrhh.php', 2, '', 'VacacionRrhh', 'ASIS');
/***********************************F-DAT-MMV-ASIS-1-07/01/2021*****************************************/
/***********************************I-DAT-MMV-ASIS-2-07/01/2021*****************************************/
select wf.f_import_testructura_estado ('insert','rechazado','vobo','VAC-PRO',1,'','si');
select wf.f_import_tplantilla_correo ('insert','SOCP','vobo','VAC-PRO','','<h3><b>SOLICITUD DE VACACIÓN</b></h3>
<p style="font-size: 15px;"><b>Fecha solicitud:</b> {$tabla.fecha_solicitud}</p>
<p style="font-size: 15px;"><b>Solicitud para:</b> {$tabla.funcionario_solicitante}</p>
<p style="font-size: 15px;"><b>Desde:</b> {$tabla.fecha_inicio} <b>Hasta:</b> {$tabla.fecha_fin}</p>
<p style="font-size: 15px;"><b>Días solicitados:</b> {$tabla.dias}</p>
<p style="font-size: 15px;"><b>Justificación:</b> {$tabla.descripcion}</p>','magali.sinani@endetransmision.bo','Solicitud de vacación','','no','','','','no','','','','');
/***********************************F-DAT-MMV-ASIS-2-07/01/2021*****************************************/
/***********************************I-DAT-MMV-ASIS-2-07/01/2021*****************************************/
select wf.f_import_testructura_estado ('insert','rechazado','vobo','PER-ASI',1,'','si');
select wf.f_import_tplantilla_correo ('insert','CSOPE','vobo','PER-ASI','','<h3><b>SOLICITUD DE PERMISO</b></h3>
<p style="font-size: 15px;"><b>Tipo permiso:</b> {$tabla.tipo_permiso}</p>
<p style="font-size: 15px;"><b>Fecha solicitud:</b> {$tabla.fecha_solicitud}</p>
<p style="font-size: 15px;"><b>Solicitud para:</b> {$tabla.funcionario_solicitante}</p>
<p style="font-size: 15px;"><b>Desde:</b> {$tabla.hro_desde} <b>Hasta:</b> {$tabla.hro_hasta}</p>
<p style="font-size: 15px;"><b>Justificacion:</b> {$tabla.motivo}</p>','magali.sinani@endetransmision.bo','Solicitud de persmiso','','no','','','','no','','','','');
/***********************************F-DAT-MMV-ASIS-2-07/01/2021*****************************************/
/***********************************I-DAT-VAN-ASIS-1-14/01/2021*****************************************/
select pxp.f_insert_tgui ('Consulta fondos', 'Consulta de Fondos', 'ACF', 'si', 14, 'sis_cuenta_documentada/vista/cuenta_doc/CuentaDocConsultaAsis.php', 2, '', 'CuentaDocConsultaAsis', 'ASIS');
/***********************************F-DAT-MMV-ASIS-1-14/01/2021*****************************************/
