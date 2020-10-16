<?php
/**
 *@package pXP
 *@file gen-ACTTransaccion.php
 *@author  (miguel.mamani)
 *@date 06-09-2019 13:08:03
 *@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 */
require_once(dirname(__FILE__).'/../reportes/RTusMarcados.php');
require_once(dirname(__FILE__).'/../reportes/RReporteTotalPDF.php');

class ACTTransaccion extends ACTbase{
    function listarTransaccion(){
        $this->objParam->defecto('ordenacion','id');
        $this->objParam->defecto('dir_ordenacion','asc');
        /*if($this->objParam->getParametro('id_periodo') != ''){
            $this->objParam->addFiltro("EXTRACT(MONTH FROM bio.event_time::date)::integer = ".$this->objParam->getParametro('id_periodo'));
        }*/
        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODTransaccion','listarTransaccion');
        } else{
            $this->objFunc=$this->create('MODTransaccion');

            $this->res=$this->objFunc->listarTransaccion($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function insertarTransaccion(){
        $this->objFunc=$this->create('MODTransaccion');
        if($this->objParam->insertar('id_transaccion_bio')){
            $this->res=$this->objFunc->insertarTransaccion($this->objParam);
        } else{
            $this->res=$this->objFunc->modificarTransaccion($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function eliminarTransaccion(){
        $this->objFunc=$this->create('MODTransaccion');
        $this->res=$this->objFunc->eliminarTransaccion($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function migrarMarcadoFuncionario(){
        $this->objFunc=$this->create('MODTransaccion');
        $this->res=$this->objFunc->migrarMarcadoFuncionario($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function ReporteTusMarcados(){
        $this->objFunc=$this->create('MODTransaccion');
        $this->res=$this->objFunc->ReporteTusMarcados($this->objParam);
        //obtener titulo del reporte
        $titulo = 'Reporte de tus marcados';
        //Genera el nombre del archivo (aleatorio + titulo)
        $nombreArchivo=uniqid(md5(session_id()).$titulo);
        $nombreArchivo.='.xls';
        $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
        $this->objParam->addParametro('datos', $this->res->datos);
        $this->objReporteFormato = new RTusMarcados($this->objParam);
        $this->objReporteFormato->generarDatos();
        $this->objReporteFormato->generarReporte();
        $this->mensajeExito = new Mensaje();
        $this->mensajeExito->setMensaje('EXITO', 'Reporte.php', 'Reporte generado','Se generó con éxito el reporte: ' . $nombreArchivo, 'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());

    }
    function listarReporteTranasaccion(){
        $this->objParam->defecto('ordenacion','id_transaccion_bio');
        $this->objParam->defecto('dir_ordenacion','asc');
        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODTransaccion','listarReporteTranasaccion');
        } else{
            $this->objFunc=$this->create('MODTransaccion');
            $this->res=$this->objFunc->listarReporteTranasaccion($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function ReporteMarcadoPDF(){

        $this->objFunc=$this->create('MODTransaccion');
        $this->res=$this->objFunc->reporteMarcados($this->objParam);
        //obtener titulo del reporte
        $titulo = 'Marcado de funcionario';
        //Genera el nombre del archivo (aleatorio + titulo)
        $nombreArchivo=uniqid(md5(session_id()).$titulo);
        $nombreArchivo.='.pdf';
        $this->objParam->addParametro('orientacion','P');
        $this->objParam->addParametro('tamano','LETTER');
        $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
        //Instancia la clase de pdf
        $this->objReporteFormato=new RReporteTotalPDF($this->objParam);
        $this->objReporteFormato->setDatos($this->res->datos);
        $this->objReporteFormato->generarReporte();
        $this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');
        $this->mensajeExito=new Mensaje();
        $this->mensajeExito->setMensaje('EXITO','Reporte.php','Reporte generado',
            'Se generó con éxito el reporte: '.$nombreArchivo,'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());

    }

}

?>