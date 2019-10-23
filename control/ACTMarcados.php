<?php
/**
*@package pXP
*@file gen-ACTMarcados.php
*@author  (mgarcia)
*@date 12-07-2019 12:56:19
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTMarcados extends ACTbase{    
			
	function listarMarcados(){
		$this->objParam->defecto('ordenacion','id_marcado');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODMarcados','listarMarcados');
		} else{
			$this->objFunc=$this->create('MODMarcados');
			
			$this->res=$this->objFunc->listarMarcados($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarMarcados(){
		$this->objFunc=$this->create('MODMarcados');	
		if($this->objParam->insertar('id_marcado')){
			$this->res=$this->objFunc->insertarMarcados($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarMarcados($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarMarcados(){
			$this->objFunc=$this->create('MODMarcados');	
		$this->res=$this->objFunc->eliminarMarcados($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>