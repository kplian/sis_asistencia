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
select pxp.f_insert_tgui ('Control Asistencia', 'Control Asistencia', 'CSA', 'si', 3, 'sis_asistencia/vista/pares/Pares.php', 2, '', 'Pares', 'ASIS');
select pxp.f_insert_tgui ('Consultas', 'Consultas', 'CON', 'si', 4, '', 2, '', '', 'ASIS');
select pxp.f_insert_tgui ('Marcacion Biometrico', 'Marcacion Biometrico', 'MAB', 'si', 3, 'sis_asistencia/vista/transaccion/Transaccion.php', 3, '', 'Transaccion', 'ASIS');
select pxp.f_insert_tgui ('Feriados', 'Feriados', 'FERIA', 'si', 4, 'sis_parametros/vista/feriado/Feriado.php', 3, '', 'Feriado', 'ASIS');
select pxp.f_insert_tgui ('Reposición', 'Reposición', 'RPN', 'si', 4, 'sis_asistencia/vista/reposicion/Reposicion.php', 3, '', 'Reposicion', 'ASIS');
select pxp.f_insert_tgui ('Reporte Vacaciones', 'Reporte Vacaciones', 'RVS', 'si', 4, 'sis_asistencia/vista/reportes/FormReporteVacacion.php', 3, '', 'FormReporteVacacion', 'ASIS');
select pxp.f_insert_tgui ('Seguimiento Permiso', 'Seguimiento Permiso', 'CPO', 'si', 12, 'sis_asistencia/vista/consulta_rrhh/FormFiltro.php', 2, '', 'FormFiltro', 'ASIS');
select pxp.f_insert_tgui ('Seguimiento Vacación', 'Seguimiento Vacación', 'CVR', 'si', 13, 'sis_asistencia/vista/consulta_rrhh/FormFiltroVacacion.php', 2, '', 'FormFiltroVacacion', 'ASIS');
/***********************************F-DAT-MMV-ASIS-1-22/12/2020*****************************************/
