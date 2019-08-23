<?php
/**
*@package pXP
*@file gen-ACTIngresoSalida.php
*@author  (jjimenez)
*@date 14-08-2019 12:53:11
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo


HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION

#14			    23-08-2019 12:53:11		Juan 				Archivo Nuevo Control diario de ingreso salida a la empresa Ende Transmision S.A.'
 */

class ACTIngresoSalida extends ACTbase{    
			
	function listarIngresoSalida(){
		$this->objParam->defecto('ordenacion','id_ingreso_salida');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODIngresoSalida','listarIngresoSalida');
		} else{
			$this->objFunc=$this->create('MODIngresoSalida');
			
			$this->res=$this->objFunc->listarIngresoSalida($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarIngresoSalida(){
		$this->objFunc=$this->create('MODIngresoSalida');	
		if($this->objParam->insertar('id_ingreso_salida')){
			$this->res=$this->objFunc->insertarIngresoSalida($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarIngresoSalida($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarIngresoSalida(){
			$this->objFunc=$this->create('MODIngresoSalida');	
		$this->res=$this->objFunc->eliminarIngresoSalida($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>