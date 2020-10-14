<?php
/**
 *@package pXP
 *@file gen-ACTPermiso.php
 *@author  (miguel.mamani)
 *@date 16-10-2019 13:14:05
 *@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
#0				16-10-2019 13:14:05								CREACION

 */

class ACTPermiso extends ACTbase{

    function listarPermiso(){
        $this->objParam->defecto('ordenacion','id_permiso');
        $this->objParam->defecto('dir_ordenacion','asc');

        if ($this->objParam->getParametro('tipo_interfaz') == 'PermisoReg'){

            switch ($this->objParam->getParametro('pes_estado')) {
                case 'registro':
                    $this->objParam->addFiltro("pmo.estado = ''registro''"); // un where de conuslta de sel es una concatenando
                    break;
                case 'vobo':
                    $this->objParam->addFiltro("pmo.estado = ''vobo''");
                    break;
                case 'reposicion':
                    $this->objParam->addFiltro("pmo.estado = ''reposicion''");
                    break;
                case 'finalizado':
                    $this->objParam->addFiltro("pmo.estado = ''aprobado''");
                    break;
            }

        }
        if ($this->objParam->getParametro('tipo_interfaz') == 'PermisoVoBo'){

            $this->objParam->addFiltro("pmo.estado = ''vobo''");
        }
        if ($this->objParam->getParametro('tipo_interfaz') == 'PermisoRRHH'){
            $this->objParam->addFiltro("pmo.estado <> ''registro''");
        }
        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODPermiso','listarPermiso');
        } else{
            $this->objFunc=$this->create('MODPermiso');

            $this->res=$this->objFunc->listarPermiso($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function insertarPermiso(){
        $this->objFunc=$this->create('MODPermiso');
        if($this->objParam->insertar('id_permiso')){
            $this->res=$this->objFunc->insertarPermiso($this->objParam);
        } else{
            $this->res=$this->objFunc->modificarPermiso($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function eliminarPermiso(){
        $this->objFunc=$this->create('MODPermiso');
        $this->res=$this->objFunc->eliminarPermiso($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function siguienteEstado(){
        $this->objFunc=$this->create('MODPermiso');
        $this->res=$this->objFunc->siguienteEstado($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function anteriorEstado(){
        $this->objFunc=$this->create('MODPermiso');
        $this->res=$this->objFunc->anteriorEstado($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function optenerRango(){
        $this->objFunc=$this->create('MODPermiso');
        $this->res=$this->objFunc->optenerRango($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function calcularRango(){
        $this->objFunc=$this->create('MODPermiso');
        $this->res=$this->objFunc->calcularRango($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function listaResponsable(){
        $this->objParam->defecto('ordenacion','id_funcionario');
        $this->objParam->defecto('dir_ordenacion','asc');

        $this->objFunc=$this->create('MODPermiso');
        $this->res=$this->objFunc->listaResponsable($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function aprobarEstado(){
        $this->objFunc=$this->create('MODPermiso');
        $this->res=$this->objFunc->aprobarEstado($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
}

?>
