<?php
/**
*@package pXP
*@file gen-ACTRangoHorario.php
*@author  (mgarcia)
*@date 19-08-2019 15:28:39
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTRangoHorario extends ACTbase{    
			
	function listarRangoHorario(){
		$this->objParam->defecto('ordenacion','id_rango_horario');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODRangoHorario','listarRangoHorario');
		} else{
			$this->objFunc=$this->create('MODRangoHorario');
			
			$this->res=$this->objFunc->listarRangoHorario($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarRangoHorario(){
		$this->objFunc=$this->create('MODRangoHorario');	
		if($this->objParam->insertar('id_rango_horario')){
			$this->res=$this->objFunc->insertarRangoHorario($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarRangoHorario($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarRangoHorario(){
			$this->objFunc=$this->create('MODRangoHorario');	
		$this->res=$this->objFunc->eliminarRangoHorario($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	function asignarDia(){
			$this->objFunc=$this->create('MODRangoHorario');
		$this->res=$this->objFunc->asignarDia($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>