<?php
/**
*@package pXP
*@file gen-ACTTipoPermiso.php
*@author  (miguel.mamani)
*@date 16-10-2019 13:14:01
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				16-10-2019 13:14:01								CREACION

*/

class ACTTipoPermiso extends ACTbase{    
			
	function listarTipoPermiso(){
		$this->objParam->defecto('ordenacion','id_tipo_permiso');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODTipoPermiso','listarTipoPermiso');
		} else{
			$this->objFunc=$this->create('MODTipoPermiso');
			
			$this->res=$this->objFunc->listarTipoPermiso($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarTipoPermiso(){
		$this->objFunc=$this->create('MODTipoPermiso');	
		if($this->objParam->insertar('id_tipo_permiso')){
			$this->res=$this->objFunc->insertarTipoPermiso($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarTipoPermiso($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarTipoPermiso(){
			$this->objFunc=$this->create('MODTipoPermiso');	
		$this->res=$this->objFunc->eliminarTipoPermiso($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>