<?php
/****************************************************************************************
*@package pXP
*@file gen-ACTBajaMedica.php
*@author  (admin.miguel)
*@date 05-02-2021 14:41:38
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo

 HISTORIAL DE MODIFICACIONES:
 #ISSUE                FECHA                AUTOR                DESCRIPCION
  #0                05-02-2021 14:41:38    admin.miguel             Creacion    
  #
*****************************************************************************************/
require_once(dirname(__FILE__).'/../reportes/RReporteBajaMedica.php');

class ACTBajaMedica extends ACTbase{    
            
    function listarBajaMedica(){
		$this->objParam->defecto('ordenacion','id_baja_medica');
        $this->objParam->defecto('dir_ordenacion','asc');
        if ($this->objParam->getParametro('tipo_interfaz') == 'BajaMedica'){
            switch ($this->objParam->getParametro('pes_estado')) {
                case 'registro':
                    $this->objParam->addFiltro("bma.estado in (''registro'')"); // un where de conuslta de sel es una concatenando
                    break;
                case 'enviado':
                    $this->objParam->addFiltro("bma.estado = ''enviado''");
                    break;
            }
        }
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODBajaMedica','listarBajaMedica');
        } else{
        	$this->objFunc=$this->create('MODBajaMedica');
            
        	$this->res=$this->objFunc->listarBajaMedica($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
                
    function insertarBajaMedica(){
        $this->objFunc=$this->create('MODBajaMedica');    
        if($this->objParam->insertar('id_baja_medica')){
            $this->res=$this->objFunc->insertarBajaMedica($this->objParam);            
        } else{            
            $this->res=$this->objFunc->modificarBajaMedica($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
                        
    function eliminarBajaMedica(){
        $this->objFunc=$this->create('MODBajaMedica');
        $this->res=$this->objFunc->eliminarBajaMedica($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function aprobarEstado(){
        $this->objFunc=$this->create('MODBajaMedica');
        $this->res=$this->objFunc->aprobarEstado($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function listarBajaMedicaReporte(){
        $this->objFunc=$this->create('MODBajaMedica');
        $this->res=$this->objFunc->listarBajaMedicaReporte($this->objParam);
        //obtener titulo del reporte
        $titulo = 'Baja Medica';
        //Genera el nombre del archivo (aleatorio + titulo)

        $nombreArchivo=uniqid(md5(session_id()).$titulo);
        $nombreArchivo.='.pdf';
        $this->objParam->addParametro('orientacion', 'L');
        $this->objParam->addParametro('tamano','LETTER');
        $this->objParam->addParametro('nombre_archivo',$nombreArchivo);
        //Instancia la clase de pdf
        $this->objReporteFormato=new RReporteBajaMedica($this->objParam);
        $this->objReporteFormato->setDatos($this->res->datos);
        $this->objReporteFormato->generarReporte();
        $this->objReporteFormato->output($this->objReporteFormato->url_archivo,'F');

        $this->mensajeExito = new Mensaje();
        $this->mensajeExito->setMensaje('EXITO', 'Reporte.php', 'Reporte generado','Se generó con éxito el reporte: ' . $nombreArchivo, 'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());

    }
            
}

?>