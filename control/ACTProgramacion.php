<?php
/****************************************************************************************
*@package pXP
*@file gen-ACTProgramacion.php
*@author  (admin.miguel)
*@date 14-12-2020 20:28:34
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo

 HISTORIAL DE MODIFICACIONES:
 #ISSUE                FECHA                AUTOR                DESCRIPCION
  #0                14-12-2020 20:28:34    admin.miguel             Creacion    
  #
*****************************************************************************************/

class ACTProgramacion extends ACTbase{    
            
    function listarProgramacion(){
		$this->objParam->defecto('ordenacion','id_programacion');

        $this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODProgramacion','listarProgramacion');
        } else{
        	$this->objFunc=$this->create('MODProgramacion');
            
        	$this->res=$this->objFunc->listarProgramacion($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
                
    function insertarProgramacion(){
        $this->objFunc=$this->create('MODProgramacion');    
        if($this->objParam->insertar('id_programacion')){
            $this->res=$this->objFunc->insertarProgramacion($this->objParam);            
        } else{            
            $this->res=$this->objFunc->modificarProgramacion($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
                        
    function eliminarProgramacion(){
        	$this->objFunc=$this->create('MODProgramacion');    
        $this->res=$this->objFunc->eliminarProgramacion($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
            
}

?>