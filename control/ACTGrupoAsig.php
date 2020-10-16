<?php
/**
 *@package pXP
 *@file gen-ACTGrupoAsig.php
 *@author  (miguel.mamani)
 *@date 20-11-2019 20:00:15
 *@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
#0				20-11-2019 20:00:15								CREACION

 */

class ACTGrupoAsig extends ACTbase{

    function listarGrupoAsig(){
        $this->objParam->defecto('ordenacion','id_grupo_asig');
        $this->objParam->defecto('dir_ordenacion','asc');
        // fill
        if($this->objParam->getParametro('fill') == 'si'){
            /*  $this->objParam->addFiltro("gru.id_grupo_asig not in (select gu.id_grupo_asig
                                                   from asis.tasignar_rango gu
                                                   where gu.id_rango_horario = ".$this->objParam->getParametro('id_rango_horario').")" );*/
        }

        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODGrupoAsig','listarGrupoAsig');
        } else{
            $this->objFunc=$this->create('MODGrupoAsig');

            $this->res=$this->objFunc->listarGrupoAsig($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function insertarGrupoAsig(){
        $this->objFunc=$this->create('MODGrupoAsig');
        if($this->objParam->insertar('id_grupo_asig')){
            $this->res=$this->objFunc->insertarGrupoAsig($this->objParam);
        } else{
            $this->res=$this->objFunc->modificarGrupoAsig($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function eliminarGrupoAsig(){
        $this->objFunc=$this->create('MODGrupoAsig');
        $this->res=$this->objFunc->eliminarGrupoAsig($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

}

?>