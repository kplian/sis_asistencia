<?php
/**
*@package pXP
*@file gen-ACTMesTrabajoCon.php
*@author  (miguel.mamani)
*@date 13-03-2019 13:52:11
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTMesTrabajoCon extends ACTbase{    
			
	function listarMesTrabajoCon(){
		$this->objParam->defecto('ordenacion','id_mes_trabajo_con');
		$this->objParam->defecto('dir_ordenacion','asc');
        if($this->objParam->getParametro('id_mes_trabajo') != '') {
            $this->objParam->addFiltro("mtf.id_mes_trabajo = " . $this->objParam->getParametro('id_mes_trabajo'));
        }
        if($this->objParam->getParametro('id_tipo_aplicacion') != '') {
            $this->objParam->addFiltro("mtf.id_tipo_aplicacion = " . $this->objParam->getParametro('id_tipo_aplicacion'));
        }
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODMesTrabajoCon','listarMesTrabajoCon');
		} else{
			$this->objFunc=$this->create('MODMesTrabajoCon');
			
			$this->res=$this->objFunc->listarMesTrabajoCon($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarMesTrabajoCon(){
		$this->objFunc=$this->create('MODMesTrabajoCon');	
		if($this->objParam->insertar('id_mes_trabajo_con')){
			$this->res=$this->objFunc->insertarMesTrabajoCon($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarMesTrabajoCon($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarMesTrabajoCon(){
			$this->objFunc=$this->create('MODMesTrabajoCon');	
		$this->res=$this->objFunc->eliminarMesTrabajoCon($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>