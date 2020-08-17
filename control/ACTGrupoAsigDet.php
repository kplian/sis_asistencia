<?php
/**
 *@package pXP
 *@file gen-ACTGrupoAsigDet.php
 *@author  (miguel.mamani)
 *@date 20-11-2019 20:55:17
 *@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
#0				20-11-2019 20:55:17								CREACION

 */

class ACTGrupoAsigDet extends ACTbase{

    function listarGrupoAsigDet(){
        $this->objParam->defecto('ordenacion','id_id_grupo_asig_det');
        $this->objParam->defecto('dir_ordenacion','asc');
        if($this->objParam->getParametro('id_grupo_asig') != '') {
            $this->objParam->addFiltro("grd.id_grupo_asig = " . $this->objParam->getParametro('id_grupo_asig'));
        }
        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODGrupoAsigDet','listarGrupoAsigDet');
        } else{
            $this->objFunc=$this->create('MODGrupoAsigDet');

            $this->res=$this->objFunc->listarGrupoAsigDet($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function insertarGrupoAsigDet(){
        $this->objFunc=$this->create('MODGrupoAsigDet');
        if($this->objParam->insertar('id_id_grupo_asig_det')){
            $this->res=$this->objFunc->insertarGrupoAsigDet($this->objParam);
        } else{
            $this->res=$this->objFunc->modificarGrupoAsigDet($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function eliminarGrupoAsigDet(){
        $this->objFunc=$this->create('MODGrupoAsigDet');
        $this->res=$this->objFunc->eliminarGrupoAsigDet($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

}

?>