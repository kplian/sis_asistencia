<?php
/****************************************************************************************
*@package pXP
*@file gen-ACTCompensacionDetCom.php
*@author  (amamani)
*@date 21-05-2021 17:01:17
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo

 HISTORIAL DE MODIFICACIONES:
 #ISSUE                FECHA                AUTOR                DESCRIPCION
  #0                21-05-2021 17:01:17    amamani             Creacion    
  #
*****************************************************************************************/

class ACTCompensacionDetCom extends ACTbase{    
            
    function listarCompensacionDetCom(){
		$this->objParam->defecto('ordenacion','id_compensacion_det_com');
        $this->objParam->defecto('dir_ordenacion','asc');
        if ($this->objParam->getParametro('id_compensacion_det') != '') {
            $this->objParam->addFiltro("fcn.id_compensacion_det = " . $this->objParam->getParametro('id_compensacion_det'));
        }
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODCompensacionDetCom','listarCompensacionDetCom');
        } else{
        	$this->objFunc=$this->create('MODCompensacionDetCom');
            
        	$this->res=$this->objFunc->listarCompensacionDetCom($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
                
    function insertarCompensacionDetCom(){
        $this->objFunc=$this->create('MODCompensacionDetCom');    
        if($this->objParam->insertar('id_compensacion_det_com')){
            $this->res=$this->objFunc->insertarCompensacionDetCom($this->objParam);            
        } else{            
            $this->res=$this->objFunc->modificarCompensacionDetCom($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
                        
    function eliminarCompensacionDetCom(){
        	$this->objFunc=$this->create('MODCompensacionDetCom');    
        $this->res=$this->objFunc->eliminarCompensacionDetCom($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
            
}

?>