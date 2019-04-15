<?php
/**
*@package pXP
*@file gen-ACTTipoAplicacion.php
*@author  (miguel.mamani)
*@date 21-02-2019 13:27:56
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTTipoAplicacion extends ACTbase{    
			
	function listarTipoAplicacion(){
		$this->objParam->defecto('ordenacion','id_tipo_aplicacion');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODTipoAplicacion','listarTipoAplicacion');
		} else{
			$this->objFunc=$this->create('MODTipoAplicacion');
			
			$this->res=$this->objFunc->listarTipoAplicacion($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarTipoAplicacion(){
		$this->objFunc=$this->create('MODTipoAplicacion');	
		if($this->objParam->insertar('id_tipo_aplicacion')){
			$this->res=$this->objFunc->insertarTipoAplicacion($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarTipoAplicacion($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarTipoAplicacion(){
			$this->objFunc=$this->create('MODTipoAplicacion');	
		$this->res=$this->objFunc->eliminarTipoAplicacion($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>