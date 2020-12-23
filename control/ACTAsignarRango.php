<?php
/**
 *@package pXP
 *@file gen-ACTAsignarRango.php
 *@author  (miguel.mamani)
 *@date 05-09-2019 21:07:38
 *@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 */

class ACTAsignarRango extends ACTbase{

    function listarAsignarRango(){
        $this->objParam->defecto('ordenacion','asignar_rango');
        $this->objParam->defecto('dir_ordenacion','asc');
        if($this->objParam->getParametro('id_rango_horario') != '') {
            $this->objParam->addFiltro("aro.id_rango_horario = " . $this->objParam->getParametro('id_rango_horario'));
        }
        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODAsignarRango','listarAsignarRango');
        } else{
            $this->objFunc=$this->create('MODAsignarRango');

            $this->res=$this->objFunc->listarAsignarRango($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function insertarAsignarRango(){
        $this->objFunc=$this->create('MODAsignarRango');
        if($this->objParam->insertar('asignar_rango')){
            $this->res=$this->objFunc->insertarAsignarRango($this->objParam);
        } else{
            $this->res=$this->objFunc->modificarAsignarRango($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function eliminarAsignarRango(){
        $this->objFunc=$this->create('MODAsignarRango');
        $this->res=$this->objFunc->eliminarAsignarRango($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function listarUo(){
        $this->objParam->defecto('ordenacion','id_uo');
        $this->objParam->defecto('dir_ordenacion','asc');
        $this->objFunc=$this->create('MODAsignarRango');
        $this->res=$this->objFunc->listarUo($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

}

?>