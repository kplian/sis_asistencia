<?php
/**
*@package pXP
*@file gen-ACTReposicion.php
*@author  (admin.miguel)
*@date 15-10-2020 18:57:40
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				15-10-2020 18:57:40								CREACION

*/

class ACTReposicion extends ACTbase{    
			
	function listarReposicion(){
		$this->objParam->defecto('ordenacion','id_reposicion');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODReposicion','listarReposicion');
		} else{
			$this->objFunc=$this->create('MODReposicion');
			
			$this->res=$this->objFunc->listarReposicion($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarReposicion(){
		$this->objFunc=$this->create('MODReposicion');	
		if($this->objParam->insertar('id_reposicion')){
			$this->res=$this->objFunc->insertarReposicion($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarReposicion($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarReposicion(){
			$this->objFunc=$this->create('MODReposicion');	
		$this->res=$this->objFunc->eliminarReposicion($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>