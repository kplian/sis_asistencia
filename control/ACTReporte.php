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

}
?>