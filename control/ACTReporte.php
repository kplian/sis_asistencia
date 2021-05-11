<?php
/**
 *@package pXP
 *@file MODReportes
 *@author  MMV
 *@date 19-08-2019 15:28:39
 *@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 * HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
#15		etr			02-09-2019			MVM               	Reporte Transacción marcados
#16		etr			04-09-2019			MMV               	Medicaciones reporte marcados
#21		etr			18-10-2019			SAZP				Modificacion datos funcionarion en el reporte
 */
require_once(dirname(__FILE__).'/../reportes/RRetrasos.php');
require_once(dirname(__FILE__).'/../reportes/RMarcacionFunc.php');
require_once(dirname(__FILE__).'/../reportes/RMarcadoGral.php');
require_once(dirname(__FILE__).'/../reportes/RMarcadoGralPDF.php');
require_once(dirname(__FILE__).'/../reportes/RIncumplimientos.php');
require_once(dirname(__FILE__).'/../reportes/RReporteHistoricoVacacionPDF.php');
require_once(dirname(__FILE__).'/../reportes/RReporteVacacionPDF.php');
require_once(dirname(__FILE__).'/../reportes/RReporteVacacionResumenPDF.php');
require_once(dirname(__FILE__).'/../reportes/RReporteVacacionSaldoPDF.php');
require_once(dirname(__FILE__).'/../reportes/RReporteVacacionXLSX.php');
require_once(dirname(__FILE__).'/../reportes/RReporteSaldoXLSX.php');
require_once(dirname(__FILE__).'/../reportes/RReporteSaldoPDF.php');
require_once(dirname(__FILE__).'/../reportes/RReporteAncticipo.php');
require_once(dirname(__FILE__).'/../reportes/RReporteAncticipoXls.php');
require_once(dirname(__FILE__).'/../reportes/RReporteVacacionResumenXls.php');
require_once(dirname(__FILE__).'/../reportes/RReporteHistoricoVacacionXls.php');
require_once(dirname(__FILE__).'/../reportes/RVencimientoPDF.php');
require_once(dirname(__FILE__).'/../reportes/RVencimientoXLS.php');
require_once(dirname(__FILE__).'/../reportes/RAsistencia.php');
require_once(dirname(__FILE__).'/../reportes/RAsistenciaPDF.php');
require_once(dirname(__FILE__).'/../reportes/RRetrasosDiarios.php');
require_once(dirname(__FILE__).'/../reportes/RRetrasosMensuales.php');
require_once(dirname(__FILE__).'/../reportes/RReporteRetrasos.php');
require_once(dirname(__FILE__).'/../reportes/RRetrasosDiarioXls.php');
require_once(dirname(__FILE__).'/../reportes/RRetrasosMensualesXls.php');
require_once(dirname(__FILE__).'/../reportes/RReporteRetrasosXls.php');

class ACTReporte extends ACTbase{
    function reporteAnexos(){
        $this->objFunc = $this->create('MODReportes');
        $this->res = $this->objFunc->listarReporteFuncionario($this->objParam); //#16
        $titulo = 'Retrasos';
        $nombreArchivo = uniqid(md5(session_id()) . $titulo);
        $nombreArchivo .= '.xls';
        $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
        $this->objParam->addParametro('datos', $this->res->datos);
        $this->objReporteFormato = new RRetrasos($this->objParam);
        $this->objReporteFormato->generarDatos();
        $this->objReporteFormato->generarReporte();
        $this->mensajeExito = new Mensaje();
        $this->mensajeExito->setMensaje('EXITO', 'Reporte.php', 'Reporte generado','Se generó con éxito el reporte: ' . $nombreArchivo, 'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
    }

    function ReporteMarcadoFuncionario(){
        $this->objFunc=$this->create('MODReportes');
        $this->res=$this->objFunc->ReporteMarcadoFuncionario($this->objParam);
        //obtener titulo del reporte
        $titulo = 'Marcado de funcionario';
        //Genera el nombre del archivo (aleatorio + titulo)
        $nombreArchivo=uniqid(md5(session_id()).$titulo);
        $nombreArchivo.='.xls';
        $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
        $this->objParam->addParametro('datos', $this->res->datos);
        $this->objReporteFormato = new RMarcacionFunc($this->objParam);
        $this->objReporteFormato->generarDatos();
        $this->objReporteFormato->generarReporte();
        $this->mensajeExito = new Mensaje();
        $this->mensajeExito->setMensaje('EXITO', 'Reporte.php', 'Reporte generado','Se generó con éxito el reporte: ' . $nombreArchivo, 'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());

    }

    function ReporteMarcadoFuncGral(){
        $this->objFunc=$this->create('MODReportes');
        $this->res=$this->objFunc->ReporteMarcadoFuncGral($this->objParam);
        //obtener titulo del reporte
        $titulo = 'Marcado de funcionario acceso general';
        //Genera el nombre del archivo (aleatorio + titulo)
        $nombreArchivo=uniqid(md5(session_id()).$titulo);
        $nombreArchivo.='.xls';
        $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
        $this->objParam->addParametro('datos', $this->res->datos);
        $this->objReporteFormato = new RMarcadoGral($this->objParam);
        $this->objReporteFormato->generarDatos();
        $this->objReporteFormato->generarReporte();
        $this->mensajeExito = new Mensaje();
        $this->mensajeExito->setMensaje('EXITO', 'Reporte.php', 'Reporte generado','Se generó con éxito el reporte: ' . $nombreArchivo, 'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());

    }

    function ReporteMarcadoFuncGralPDF(){

        switch ($this->objParam->getParametro('tipo_rpt')) {
            case "General":
                $this->objFunc=$this->create('MODReportes');
                $this->res=$this->objFunc->ReporteMarcadoFuncGralPDF($this->objParam);
                //obtener titulo del reporte
                $titulo = 'Marcado de funcionario acceso general';
                //Genera el nombre del archivo (aleatorio + titulo)
                $nombreArchivo=uniqid(md5(session_id()).$titulo);
                $nombreArchivo.='.pdf';
                $this->objParam->addParametro('orientacion','P');
                $this->objParam->addParametro('tamano','LETTER');
                $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
                //Instancia la clase de pdf
                $this->objReporteFormato=new RMarcadoGralPDF($this->objParam);
                $this->objReporteFormato->setDatos($this->res->datos);
                $this->objReporteFormato->generarReporte();
                $this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');
                break;
            case "Incumplimientos":
                $this->objFunc=$this->create('MODReportes');
                $this->res=$this->objFunc->ReporteMarcadoFuncGralPDF($this->objParam);
                //obtener titulo del reporte
                $titulo = 'Marcado de funcionario acceso general';
                //Genera el nombre del archivo (aleatorio + titulo)
                $nombreArchivo=uniqid(md5(session_id()).$titulo);
                $nombreArchivo.='.pdf';
                $this->objParam->addParametro('orientacion','P');
                $this->objParam->addParametro('tamano','LETTER');
                $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
                //Instancia la clase de pdf
                $this->objReporteFormato=new RIncumplimientos($this->objParam);
                $this->objReporteFormato->setDatos($this->res->datos);
                $this->objReporteFormato->generarReporte();
                $this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');
                break;
            case "Resumen":
                var_dump('Resumen');exit;
                break;
            case "Tiempos Maximos":
                var_dump('Tiempos Maximos');exit;
                break;
        }

        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
            'Se generó con éxito el reporte: '.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());

    }
    function listarReporteHistoricoVacaciones(){

        $this->objFunc=$this->create('MODReportes');
        $this->res=$this->objFunc->listarReporteHistoricoVacaciones($this->objParam);
        //obtener titulo del reporte
        $titulo = 'Marcado de funcionario acceso general';
        //Genera el nombre del archivo (aleatorio + titulo)
        $nombreArchivo=uniqid(md5(session_id()).$titulo);
        $nombreArchivo.='.pdf';
        $this->objParam->addParametro('orientacion','P');
        $this->objParam->addParametro('tamano','LETTER');
        $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
        //Instancia la clase de pdf
        $this->objReporteFormato=new RReporteHistoricoVacacionPDF($this->objParam);
        $this->objReporteFormato->setDatos($this->res->datos);
        $this->objReporteFormato->generarReporte();
        $this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');

        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
            'Se generó con éxito el reporte: '.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());

    }
    function listarVacacionesPersonal(){

        //  var_dump($this->objParam->getParametro('tipo'));Exit;
        switch ($this->objParam->getParametro('tipo')) {
            case "Personal en Vacaciones":
                $this->objFunc=$this->create('MODReportes');
                $this->res=$this->objFunc->listarVacacionesPersonal($this->objParam);
                //obtener titulo del reporte
                $titulo = 'Reporte Personas Vacaciones';
                //Genera el nombre del archivo (aleatorio + titulo)

                if($this->objParam->getParametro('formato') == 'PDF'){
                    $nombreArchivo=uniqid(md5(session_id()).$titulo);
                    $nombreArchivo.='.pdf';
                    $this->objParam->addParametro('orientacion','P');
                    $this->objParam->addParametro('tamano','LETTER');
                    $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
                    //Instancia la clase de pdf
                    $this->objReporteFormato=new RReporteVacacionPDF($this->objParam);
                    $this->objReporteFormato->setDatos($this->res->datos);
                    $this->objReporteFormato->generarReporte();
                    $this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');
                }else {
                    $nombreArchivo = uniqid(md5(session_id()) . $titulo);
                    $nombreArchivo .= '.xls';
                    $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
                    $this->objParam->addParametro('datos', $this->res->datos);
                    $this->objReporteFormato = new RReporteVacacionXLSX($this->objParam);
                    $this->objReporteFormato->generarDatos();
                    $this->objReporteFormato->generarReporte();
                }
                break;
            case "Historial de Vacaciones":
                $this->objFunc=$this->create('MODReportes');
                $this->res=$this->objFunc->listarReporteHistoricoVacaciones($this->objParam);
                //obtener titulo del reporte
                $titulo = 'Marcado de funcionario acceso general';
                if($this->objParam->getParametro('formato') == 'PDF'){
                    $nombreArchivo=uniqid(md5(session_id()).$titulo);
                    $nombreArchivo.='.pdf';
                    $this->objParam->addParametro('orientacion','P');
                    $this->objParam->addParametro('tamano','LETTER');
                    $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
                    //Instancia la clase de pdf
                    $this->objReporteFormato=new RReporteHistoricoVacacionPDF($this->objParam);
                    $this->objReporteFormato->setDatos($this->res->datos);
                    $this->objReporteFormato->generarReporte();
                    $this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');
                }else {
                    // var_dump('asdasda');exit;
                    $nombreArchivo = uniqid(md5(session_id()) . $titulo);
                    $nombreArchivo .= '.xls';
                    $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
                    $this->objParam->addParametro('datos', $this->res->datos);
                    $this->objReporteFormato = new RReporteHistoricoVacacionXls($this->objParam);
                    $this->objReporteFormato->generarDatos();
                    $this->objReporteFormato->generarReporte();
                }
                break;
        }


        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
            'Se generó con éxito el reporte: '.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());

    }

    /* function listarVacacionesResumen(){
             $this->objFunc=$this->create('MODReportes');
             $this->res=$this->objFunc->listarVacacionesResumen($this->objParam);
             //obtener titulo del reporte
             $titulo = 'Reporte Vacacion Resumen';
         if($this->objParam->getParametro('formato') == 'PDF') {
             //Genera el nombre del archivo (aleatorio + titulo)
             $nombreArchivo = uniqid(md5(session_id()) . $titulo);
             $nombreArchivo .= '.pdf';
             $this->objParam->addParametro('orientacion', 'P');
             $this->objParam->addParametro('tamano', 'LETTER');
             $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
             //Instancia la clase de pdf
             $this->objReporteFormato = new RReporteVacacionResumenPDF($this->objParam);
             $this->objReporteFormato->setDatos($this->res->datos);
             $this->objReporteFormato->generarReporte();
             $this->objReporteFormato->output($this->objReporteFormato->url_archivo, 'F');
         }
         else{
             $nombreArchivo=uniqid(md5(session_id()).$titulo);
             $nombreArchivo.='.xls';
             $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
             $this->objParam->addParametro('datos', $this->res->datos);
             $this->objReporteFormato = new RReporteVacacionResumenXls($this->objParam);
             $this->objReporteFormato->generarDatos();
             $this->objReporteFormato->generarReporte();
         }
             $this->mensajeExito=new Mensaje();
             $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
                 'Se generó con éxito el reporte: '.$nombreArchivo,'control');
             $this->mensajeExito->setArchivoGenerado($nombreArchivo);
             $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());

     }*/
    function listarVacacionesSaldo(){


        switch ($this->objParam->getParametro('reporte')) {
            case "Saldo":
                $this->objFunc=$this->create('MODReportes');
                $this->res=$this->objFunc->listarVacacionesSaldo($this->objParam);
                //obtener titulo del reporte
                $titulo = 'Reporte Vacacion Saldo';

                if($this->objParam->getParametro('formato') == 'PDF'){
                    $nombreArchivo=uniqid(md5(session_id()).$titulo);
                    $nombreArchivo.='.pdf';
                    $this->objParam->addParametro('orientacion','P');
                    $this->objParam->addParametro('tamano','LETTER');
                    $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
                    //Instancia la clase de pdf
                    $this->objReporteFormato=new RReporteSaldoPDF($this->objParam);
                    $this->objReporteFormato->setDatos($this->res->datos);
                    $this->objReporteFormato->generarReporte();
                    $this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');
                }else {
                    $nombreArchivo = uniqid(md5(session_id()) . $titulo);
                    $nombreArchivo .= '.xls';
                    $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
                    $this->objParam->addParametro('datos', $this->res->datos);
                    $this->objReporteFormato = new RReporteSaldoXLSX($this->objParam);
                    $this->objReporteFormato->generarDatos();
                    $this->objReporteFormato->generarReporte();
                }
                break;
            case "Anticipadas":
                // var_dump('Resumen');exit;
                $this->objFunc=$this->create('MODReportes');
                $this->res=$this->objFunc->listarVacacionesAnticipados($this->objParam);
                //obtener titulo del reporte
                $titulo = 'Reporte Vacacion Anticipos';

                if($this->objParam->getParametro('formato') == 'PDF'){
                    $nombreArchivo=uniqid(md5(session_id()).$titulo);
                    $nombreArchivo.='.pdf';
                    $this->objParam->addParametro('orientacion','P');
                    $this->objParam->addParametro('tamano','LETTER');
                    $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
                    //Instancia la clase de pdf
                    $this->objReporteFormato=new RReporteAncticipo($this->objParam);
                    $this->objReporteFormato->setDatos($this->res->datos);
                    $this->objReporteFormato->generarReporte();
                    $this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');
                }else {
                    $nombreArchivo = uniqid(md5(session_id()) . $titulo);
                    $nombreArchivo .= '.xls';
                    $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
                    $this->objParam->addParametro('datos', $this->res->datos);
                    $this->objReporteFormato = new RReporteAncticipoXls($this->objParam);
                    $this->objReporteFormato->generarDatos();
                    $this->objReporteFormato->generarReporte();
                }
                break;
            case "Historial de Vacaciones":
                $this->objFunc=$this->create('MODReportes');
                $this->res=$this->objFunc->listarReporteHistoricoVacaciones($this->objParam);
                //obtener titulo del reporte
                $titulo = 'Marcado de funcionario acceso general';
                if($this->objParam->getParametro('formato') == 'PDF'){
                    $nombreArchivo=uniqid(md5(session_id()).$titulo);
                    $nombreArchivo.='.pdf';
                    $this->objParam->addParametro('orientacion','P');
                    $this->objParam->addParametro('tamano','LETTER');
                    $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
                    //Instancia la clase de pdf
                    $this->objReporteFormato=new RReporteHistoricoVacacionPDF($this->objParam);
                    $this->objReporteFormato->setDatos($this->res->datos);
                    $this->objReporteFormato->generarReporte();
                    $this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');
                }else {
                    // var_dump('asdasda');exit;
                    $nombreArchivo = uniqid(md5(session_id()) . $titulo);
                    $nombreArchivo .= '.xls';
                    $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
                    $this->objParam->addParametro('datos', $this->res->datos);
                    $this->objReporteFormato = new RReporteHistoricoVacacionXls($this->objParam);
                    $this->objReporteFormato->generarDatos();
                    $this->objReporteFormato->generarReporte();
                }
                break;
            case "Resumen":
                //
                $this->objFunc=$this->create('MODReportes');
                $this->res=$this->objFunc->listarVacacionesResumen($this->objParam);
                //obtener titulo del reporte
                $titulo = 'Reporte Resumen';

                if($this->objParam->getParametro('formato') == 'PDF'){
                    $nombreArchivo = uniqid(md5(session_id()) . $titulo);
                    $nombreArchivo .= '.pdf';
                    $this->objParam->addParametro('orientacion', 'P');
                    $this->objParam->addParametro('tamano', 'LETTER');
                    $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
                    //Instancia la clase de pdf
                    $this->objReporteFormato = new RReporteVacacionResumenPDF($this->objParam);
                    $this->objReporteFormato->setDatos($this->res->datos);
                    $this->objReporteFormato->generarReporte();
                    $this->objReporteFormato->output($this->objReporteFormato->url_archivo, 'F');
                }else {
                    $nombreArchivo=uniqid(md5(session_id()).$titulo);
                    $nombreArchivo.='.xls';
                    $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
                    $this->objParam->addParametro('datos', $this->res->datos);
                    $this->objReporteFormato = new RReporteVacacionResumenXls($this->objParam);
                    $this->objReporteFormato->generarDatos();
                    $this->objReporteFormato->generarReporte();
                }
                break;
            case "Personal en Vacaciones":
                $this->objFunc=$this->create('MODReportes');
                $this->res=$this->objFunc->listarVacacionesPersonal($this->objParam);
                //obtener titulo del reporte
                $titulo = 'Reporte Personas Vacaciones';
                //Genera el nombre del archivo (aleatorio + titulo)

                if($this->objParam->getParametro('formato') == 'PDF'){
                    $nombreArchivo=uniqid(md5(session_id()).$titulo);
                    $nombreArchivo.='.pdf';
                    $this->objParam->addParametro('orientacion','P');
                    $this->objParam->addParametro('tamano','LETTER');
                    $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
                    //Instancia la clase de pdf
                    $this->objReporteFormato=new RReporteVacacionPDF($this->objParam);
                    $this->objReporteFormato->setDatos($this->res->datos);
                    $this->objReporteFormato->generarReporte();
                    $this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');
                }else {
                    $nombreArchivo = uniqid(md5(session_id()) . $titulo);
                    $nombreArchivo .= '.xls';
                    $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
                    $this->objParam->addParametro('datos', $this->res->datos);
                    $this->objReporteFormato = new RReporteVacacionXLSX($this->objParam);
                    $this->objReporteFormato->generarDatos();
                    $this->objReporteFormato->generarReporte();
                }
                break;
        }
        $this->mensajeExito = new Mensaje();
        $this->mensajeExito->setMensaje('EXITO', 'Reporte.php', 'Reporte generado','Se generó con éxito el reporte: ' . $nombreArchivo, 'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());

    }
    function listarAsistencia(){
        switch ($this->objParam->getParametro('tipo')) {
            case "General":
                $this->objFunc=$this->create('MODReportes');
                $this->res=$this->objFunc->listarAsistencia($this->objParam);
                $titulo = 'Marcado de funcionario acceso general';
                if($this->objParam->getParametro('formato') == 'PDF'){
                    $nombreArchivo=uniqid(md5(session_id()).$titulo);
                    $nombreArchivo.='.pdf';
                    if ($this->objParam->getParametro('tipo') == 'General') {
                        $this->objParam->addParametro('orientacion', 'P');
                    }elseif($this->objParam->getParametro('tipo') == 'Resumen'){
                        $this->objParam->addParametro('orientacion', 'L');
                    }
                    $this->objParam->addParametro('tamano','LETTER');
                    $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
                    //Instancia la clase de pdf
                    $this->objReporteFormato=new RAsistenciaPDF($this->objParam);
                    $this->objReporteFormato->setDatos($this->res->datos);
                    $this->objReporteFormato->generarReporte();
                    $this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');
                }else {
                    $nombreArchivo = uniqid(md5(session_id()) . $titulo);
                    $nombreArchivo.='.xls';
                    $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
                    $this->objParam->addParametro('datos', $this->res->datos);
                    $this->objReporteFormato = new RAsistencia($this->objParam);
                    $this->objReporteFormato->generarDatos();
                    $this->objReporteFormato->generarReporte();
                }
                break;
            case "Resumen":
                $this->objFunc=$this->create('MODReportes');
                $this->res=$this->objFunc->listarAsistencia($this->objParam);
                $titulo = 'Marcado de funcionario acceso general';
                if($this->objParam->getParametro('formato') == 'PDF'){
                    $nombreArchivo=uniqid(md5(session_id()).$titulo);
                    $nombreArchivo.='.pdf';
                    if ($this->objParam->getParametro('tipo') == 'General') {
                        $this->objParam->addParametro('orientacion', 'P');
                    }elseif($this->objParam->getParametro('tipo') == 'Resumen'){
                        $this->objParam->addParametro('orientacion', 'L');
                    }
                    $this->objParam->addParametro('tamano','LETTER');
                    $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
                    //Instancia la clase de pdf
                    $this->objReporteFormato=new RAsistenciaPDF($this->objParam);
                    $this->objReporteFormato->setDatos($this->res->datos);
                    $this->objReporteFormato->generarReporte();
                    $this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');
                }else {
                    $nombreArchivo = uniqid(md5(session_id()) . $titulo);
                    $nombreArchivo.='.xls';
                    $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
                    $this->objParam->addParametro('datos', $this->res->datos);
                    $this->objReporteFormato = new RAsistencia($this->objParam);
                    $this->objReporteFormato->generarDatos();
                    $this->objReporteFormato->generarReporte();
                }
                break;
            case "Diario":

                $this->objFunc=$this->create('MODReportes');
                $this->res=$this->objFunc->listarDiarioRetrasos($this->objParam);
                $titulo = 'REPORTE DIARIO DE RETRASOS';

                if($this->objParam->getParametro('formato') == 'PDF'){
                    $nombreArchivo=uniqid(md5(session_id()).$titulo);
                    $nombreArchivo.='.pdf';
                    $this->objParam->addParametro('orientacion', 'P');
                    $this->objParam->addParametro('tamano','LETTER');
                    $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
                    //Instancia la clase de pdf
                    $this->objReporteFormato=new RRetrasosDiarios($this->objParam);
                    $this->objReporteFormato->setDatos($this->res->datos);
                    $this->objReporteFormato->generarReporte();
                    $this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');
                }else {
                    $nombreArchivo = uniqid(md5(session_id()) . $titulo);
                    $nombreArchivo.='.xls';
                    $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
                    $this->objParam->addParametro('datos', $this->res->datos);
                    $this->objReporteFormato = new RRetrasosDiarioXls($this->objParam);
                    $this->objReporteFormato->generarDatos();
                    $this->objReporteFormato->generarReporte();
                }
                break;
            case "Mensual":

                $this->objFunc=$this->create('MODReportes');
                $this->res=$this->objFunc->listarMensualRetrasos($this->objParam);
                $titulo = 'DETALLE MENSUAL DE RETRASOS';

                if($this->objParam->getParametro('formato') == 'PDF'){
                    $nombreArchivo=uniqid(md5(session_id()).$titulo);
                    $nombreArchivo.='.pdf';
                    $this->objParam->addParametro('orientacion', 'P');
                    $this->objParam->addParametro('tamano','LETTER');
                    $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
                    //Instancia la clase de pdf
                    $this->objReporteFormato=new RRetrasosMensuales($this->objParam);
                    $this->objReporteFormato->setDatos($this->res->datos);
                    $this->objReporteFormato->generarReporte();
                    $this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');
                }else {
                    $nombreArchivo = uniqid(md5(session_id()) . $titulo);
                    $nombreArchivo.='.xls';
                    $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
                    $this->objParam->addParametro('datos', $this->res->datos);
                    $this->objReporteFormato = new RRetrasosMensualesXls($this->objParam);
                    $this->objReporteFormato->generarDatos();
                    $this->objReporteFormato->generarReporte();
                }
                break;
            case "Retrasos":
                $this->objFunc=$this->create('MODReportes');
                $this->res=$this->objFunc->listarRetrasos($this->objParam);
                $titulo = 'REPORTE DE RETRASOS';

                if($this->objParam->getParametro('formato') == 'PDF'){
                    $nombreArchivo=uniqid(md5(session_id()).$titulo);
                    $nombreArchivo.='.pdf';
                    $this->objParam->addParametro('orientacion', 'P');
                    $this->objParam->addParametro('tamano','LETTER');
                    $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
                    //Instancia la clase de pdf
                    $this->objReporteFormato=new RReporteRetrasos($this->objParam);
                    $this->objReporteFormato->setDatos($this->res->datos);
                    $this->objReporteFormato->generarReporte();
                    $this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');
                }else {
                    $nombreArchivo = uniqid(md5(session_id()) . $titulo);
                    $nombreArchivo.='.xls';
                    $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
                    $this->objParam->addParametro('datos', $this->res->datos);
                    $this->objReporteFormato = new RReporteRetrasosXls($this->objParam);
                    $this->objReporteFormato->generarDatos();
                    $this->objReporteFormato->generarReporte();
                }
                break;
        }


        $this->mensajeExito = new Mensaje();
        $this->mensajeExito->setMensaje('EXITO', 'Reporte.php', 'Reporte generado','Se generó con éxito el reporte: ' . $nombreArchivo, 'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());

    }

}
?>