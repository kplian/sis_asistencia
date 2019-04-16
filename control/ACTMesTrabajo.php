<?php
/**
*@package pXP
*@file gen-ACTMesTrabajo.php
*@author  (miguel.mamani)
*@date 31-01-2019 13:53:10
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTMesTrabajo extends ACTbase{    
			
	function listarMesTrabajo(){
		$this->objParam->defecto('ordenacion','id_mes_trabajo');
		$this->objParam->defecto('dir_ordenacion','asc');
        if($this->objParam->getParametro('tipo_interfaz') == 'MesTrabajoVoBo'){
            $this->objParam->addFiltro("smt.estado in (''asignado'',''aprobado'')");
        }else {
            if($this->objParam->getParametro('id_gestion') != ''){
                $this->objParam->addFiltro("smt.id_gestion = ".$this->objParam->getParametro('id_gestion'));
            }
            if($this->objParam->getParametro('id_periodo') != ''){
                $this->objParam->addFiltro("smt.id_periodo = ".$this->objParam->getParametro('id_periodo'));
            }
            switch ($this->objParam->getParametro('pes_estado')) {
                case 'borrador':
                    $this->objParam->addFiltro("smt.estado = ''borrador''");
                    break;
                case 'asignado':
                    $this->objParam->addFiltro("smt.estado = ''asignado''");
                    break;
                case 'aprobado':
                    $this->objParam->addFiltro("smt.estado = ''aprobado''");
                    break;
            }
        }
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODMesTrabajo','listarMesTrabajo');
		} else{
			$this->objFunc=$this->create('MODMesTrabajo');
			
			$this->res=$this->objFunc->listarMesTrabajo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarMesTrabajo(){
		$this->objFunc=$this->create('MODMesTrabajo');	
		if($this->objParam->insertar('id_mes_trabajo')){
			$this->res=$this->objFunc->insertarMesTrabajo($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarMesTrabajo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarMesTrabajo(){
			$this->objFunc=$this->create('MODMesTrabajo');	
		$this->res=$this->objFunc->eliminarMesTrabajo($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
    function siguienteEstado(){
        $this->objFunc=$this->create('MODMesTrabajo');
        $this->res=$this->objFunc->siguienteEstado($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function anteriorEstado(){
        $this->objFunc=$this->create('MODMesTrabajo');
        $this->res=$this->objFunc->anteriorEstado($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
			
}

?>