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
            
}

?>