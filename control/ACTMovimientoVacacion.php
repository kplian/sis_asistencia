<?php
/**
*@package pXP
*@file gen-ACTMovimientoVacacion.php
*@author  (miguel.mamani)
*@date 08-10-2019 10:39:21
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				08-10-2019 10:39:21								CREACION

*/

class ACTMovimientoVacacion extends ACTbase{    
			
	function listarMovimientoVacacion(){
		$this->objParam->defecto('ordenacion','id_movimiento_vacacion');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODMovimientoVacacion','listarMovimientoVacacion');
		} else{
			$this->objFunc=$this->create('MODMovimientoVacacion');
			
			$this->res=$this->objFunc->listarMovimientoVacacion($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarMovimientoVacacion(){
		$this->objFunc=$this->create('MODMovimientoVacacion');	
		if($this->objParam->insertar('id_movimiento_vacacion')){
			$this->res=$this->objFunc->insertarMovimientoVacacion($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarMovimientoVacacion($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarMovimientoVacacion(){
			$this->objFunc=$this->create('MODMovimientoVacacion');	
		$this->res=$this->objFunc->eliminarMovimientoVacacion($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>