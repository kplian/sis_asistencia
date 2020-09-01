<?php
/**
*@package pXP
*@file gen-ACTVacacion.php
*@author  (apinto)
*@date 01-10-2019 15:29:35
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				01-10-2019 15:29:35								CREACION

*/

class ACTVacacion extends ACTbase{    
			
	function listarVacacion(){
		$this->objParam->defecto('ordenacion','id_vacacion');
		$this->objParam->defecto('dir_ordenacion','asc');
		//var_dump sirver para ver que estas mandando o para ver que estas recibiendo
		//var_dump($this->objParam->getParametro('pes_estado'));exit;
		//filtro por estados y tabl
        if ($this->objParam->getParametro('tipo_interfaz') == 'SolicitudVacaciones'){
            switch ($this->objParam->getParametro('pes_estado')) {
                case 'registro':
                    $this->objParam->addFiltro("vac.estado = ''registro''"); // un where de conuslta de sel es una concatenando
                    break;
                case 'vobo':
                    $this->objParam->addFiltro("vac.estado = ''vobo''");
                    break;
                case 'aprobado':
                    $this->objParam->addFiltro("vac.estado = ''aprobado''");
                    break;
            }
        }
        if ($this->objParam->getParametro('tipo_interfaz') == 'VacacionVoBo'){
            $this->objParam->addFiltro("vac.estado = ''vobo''");
        }
        //var_dump("hiola", $this->objParam); exit;
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODVacacion','listarVacacion');
		} else{
			$this->objFunc=$this->create('MODVacacion');
			
			$this->res=$this->objFunc->listarVacacion($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarVacacion(){
		$this->objFunc=$this->create('MODVacacion');	
		if($this->objParam->insertar('id_vacacion')){
			$this->res=$this->objFunc->insertarVacacion($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarVacacion($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarVacacion(){
			$this->objFunc=$this->create('MODVacacion');	
		$this->res=$this->objFunc->eliminarVacacion($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
    function siguienteEstado(){
        $this->objFunc=$this->create('MODVacacion');
        $this->res=$this->objFunc->siguienteEstado($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function anteriorEstado(){
        $this->objFunc=$this->create('MODVacacion');
        $this->res=$this->objFunc->anteriorEstado($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function getDias(){
        $this->objFunc=$this->create('MODVacacion');

        $this->res=$this->objFunc->getDias($this->objParam);

        $this->res->imprimirRespuesta($this->res->generarJson());

    }
    function movimientoGet(){
        $this->objFunc=$this->create('MODVacacion');
        $this->res=$this->objFunc->movimientoGet($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());

    }
			
}

?>