<?php
/****************************************************************************************
*@package pXP
*@file gen-ACTTipoBm.php
*@author  (admin.miguel)
*@date 05-02-2021 14:41:34
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo

 HISTORIAL DE MODIFICACIONES:
 #ISSUE                FECHA                AUTOR                DESCRIPCION
  #0                05-02-2021 14:41:34    admin.miguel             Creacion    
  #
*****************************************************************************************/

class ACTTipoBm extends ACTbase{    
            
    function listarTipoBm(){
		$this->objParam->defecto('ordenacion','id_tipo_bm');

        $this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODTipoBm','listarTipoBm');
        } else{
        	$this->objFunc=$this->create('MODTipoBm');
            
        	$this->res=$this->objFunc->listarTipoBm($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
                
    function insertarTipoBm(){
        $this->objFunc=$this->create('MODTipoBm');    
        if($this->objParam->insertar('id_tipo_bm')){
            $this->res=$this->objFunc->insertarTipoBm($this->objParam);            
        } else{            
            $this->res=$this->objFunc->modificarTipoBm($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
                        
    function eliminarTipoBm(){
        	$this->objFunc=$this->create('MODTipoBm');    
        $this->res=$this->objFunc->eliminarTipoBm($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
            
}

?>