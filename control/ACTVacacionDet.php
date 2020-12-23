<?php
/**
 *@package pXP
 *@file gen-ACTVacacionDet.php
 *@author  (admin.miguel)
 *@date 30-12-2019 13:41:59
 *@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
#0				30-12-2019 13:41:59								CREACION

 */

class ACTVacacionDet extends ACTbase{

    function listarVacacionDet(){
        $this->objParam->defecto('ordenacion','id_vacacion_det');
        $this->objParam->defecto('dir_ordenacion','asc');
        if($this->objParam->getParametro('id_vacacion') != '') {
            $this->objParam->addFiltro("vde.id_vacacion = " . $this->objParam->getParametro('id_vacacion'));
        }
        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODVacacionDet','listarVacacionDet');
        } else{
            $this->objFunc=$this->create('MODVacacionDet');

            $this->res=$this->objFunc->listarVacacionDet($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function cambiarTiempo(){
        $this->objFunc=$this->create('MODVacacionDet');
        $this->res=$this->objFunc->cambiarTiempo($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function eliminarVacacionDet(){
        $this->objFunc=$this->create('MODVacacionDet');
        $this->res=$this->objFunc->eliminarVacacionDet($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

}

?>