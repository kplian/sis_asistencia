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
                    $this->objParam->addFiltro("vac.estado in (''registro'',''rechazado'')"); // un where de conuslta de sel es una concatenando
                    break;
                case 'vobo':
                    $this->objParam->addFiltro("vac.estado = ''vobo''");
                    break;
                case 'aprobado':
                    $this->objParam->addFiltro("vac.estado = ''aprobado''");
                    break;
                case 'cancelado':
                        $this->objParam->addFiltro("vac.estado = ''cancelado''");
                        break;
            }
        }
        if ($this->objParam->getParametro('tipo_interfaz') == 'VacacionVoBo'){
            $this->objParam->addFiltro("vac.estado = ''vobo''");
        }
        if ($this->objParam->getParametro('tipo_interfaz') == 'VacacionRrhh') {
            switch ($this->objParam->getParametro('pes_estado')) {
                case 'vobo':
                    $this->objParam->addFiltro("vac.estado = ''vobo''");
                    break;
                case 'aprobado':
                    $this->objParam->addFiltro("vac.estado = ''aprobado''");
                    break;
                case 'rechazado':
                    $this->objParam->addFiltro("vac.estado = ''rechazado''");
                    break;
                case 'cancelado':
                    $this->objParam->addFiltro("vac.estado = ''cancelado''");
                    break;
            }
            if ($this->objParam->getParametro('fecha') != '') {
                $fecha = $this->objParam->getParametro('fecha');
                $filtroInit = "vac.fecha_reg::date <= ''" . date($fecha) . "''"; // "vac.fecha_reg::date = now()::date";

                /*var_dump($this->objParam->getParametro('fecha'));
                exit;*/

                /*if ($this->objParam->getParametro('param') != '') {
                    if ($this->objParam->getParametro('desde') != '' && $this->objParam->getParametro('hasta') != '') {
                        $filtroInit = "vac.fecha_reg::date >= '' " . $this->objParam->getParametro('desde') . "'' and vac.fecha_reg::date <= ''" . $this->objParam->getParametro('hasta') . "''";
                    }
                  if ($this->objParam->getParametro('id_uo') != '') {

                      $filtroInit = "dep.id_uo =  " . $this->objParam->getParametro('id_uo') . "  ";
                  }
                }*/
                $this->objParam->addFiltro($filtroInit);
            }
            if ($this->objParam->getParametro('id_uo') != '') {
                $this->objParam->addFiltro("dep.id_uo =".$this->objParam->getParametro('id_uo')."");
            }
        }
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
    function cancelarVacacion(){
        $this->objFunc=$this->create('MODVacacion');
        $this->res=$this->objFunc->cancelarVacacion($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function aprobarEstado(){
        $this->objFunc=$this->create('MODVacacion');
        $this->res=$this->objFunc->aprobarEstado($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function listarFuncionarioOficiales(){
		$this->objParam->defecto('ordenacion','id_funcionario');
        // $this->objParam->defecto('dir_ordenacion','asc');
        $date = date('d/m/Y');

        if( $this->objParam->getParametro('es_combo_solicitud') == 'si' ) {
            $this->objParam->addFiltro(" uo.id_usuario =".$_SESSION["ss_id_usuario"]."");
		}
        $this->objFunc=$this->create('MODVacacion');
		$this->res=$this->objFunc->listarFuncionarioOficiales($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>