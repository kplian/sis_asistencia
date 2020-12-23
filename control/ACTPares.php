<?php
/**
 *@package pXP
 *@file gen-ACTPares.php
 *@author  (mgarcia)
 *@date 19-09-2019 16:00:52
 *@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
#0				19-09-2019 16:00:52								CREACION

 */

class ACTPares extends ACTbase{

    function listarPares(){
        $this->objParam->defecto('ordenacion','id_pares');
        $this->objParam->defecto('dir_ordenacion','asc');
        if($this->objParam->getParametro('id_periodo') != ''){
            $this->objParam->addFiltro("par.id_periodo = ".$this->objParam->getParametro('id_periodo'));
        }
        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODPares','listarPares');
        } else{
            $this->objFunc=$this->create('MODPares');

            $this->res=$this->objFunc->listarPares($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function insertarPares(){
        $this->objFunc=$this->create('MODPares');
        if($this->objParam->insertar('id_pares')){
            $this->res=$this->objFunc->insertarPares($this->objParam);
        } else{
            $this->res=$this->objFunc->modificarPares($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function eliminarPares(){
        $this->objFunc=$this->create('MODPares');
        $this->res=$this->objFunc->eliminarPares($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function armarPares(){
        $this->objFunc=$this->create('MODPares');
        $this->res=$this->objFunc->armarPares($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function getht(){
        $this->objFunc=$this->create('MODPares');
        $this->res=$this->objFunc->getht($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function obtenerPeriodo(){
        $this->objFunc=$this->create('MODPares');
        $this->res=$this->objFunc->obtenerPeriodo($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function seleccionarMarca(){
        $this->objFunc=$this->create('MODPares');
        $this->res=$this->objFunc->seleccionarMarca($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function armarPareMar(){
        $this->objFunc=$this->create('MODPares');
        $this->res=$this->objFunc->armarPareMar($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function armarPareAuto(){
        $this->objFunc=$this->create('MODPares');
        $this->res=$this->objFunc->armarPareAuto($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function borrarRango(){
        $this->objFunc=$this->create('MODPares');
        $this->res=$this->objFunc->borrarRango($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function justificarPares(){
        $this->objFunc=$this->create('MODPares');
        $this->res=$this->objFunc->justificarPares($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
}

?>