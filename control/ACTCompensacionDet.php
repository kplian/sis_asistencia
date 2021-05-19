<?php
/****************************************************************************************
 * @package pXP
 * @file ACTCompensacionDet.php
 * @author  (amamani)
 * @date 18-05-2021 14:14:47
 * @description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 *
 * HISTORIAL DE MODIFICACIONES:
 * #ISSUE                FECHA                AUTOR                DESCRIPCION
 * #0                18-05-2021 14:14:47    amamani             Creacion
 * #
 *****************************************************************************************/

class ACTCompensacionDet extends ACTbase
{

    function listarCompensacionDet()
    {
        $this->objParam->defecto('ordenacion', 'id_compensacion_det');
        $this->objParam->defecto('dir_ordenacion', 'asc');
        if ($this->objParam->getParametro('id_compensacion') != '') {
            $this->objParam->addFiltro("cmd.id_compensacion = " . $this->objParam->getParametro('id_compensacion'));
        }
        if ($this->objParam->getParametro('tipoReporte') == 'excel_grid' || $this->objParam->getParametro('tipoReporte') == 'pdf_grid') {
            $this->objReporte = new Reporte($this->objParam, $this);
            $this->res = $this->objReporte->generarReporteListado('MODCompensacionDet', 'listarCompensacionDet');
        } else {
            $this->objFunc = $this->create('MODCompensacionDet');

            $this->res = $this->objFunc->listarCompensacionDet($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function insertarCompensacionDet()
    {
        $this->objFunc = $this->create('MODCompensacionDet');
        if ($this->objParam->insertar('id_compensacion_det')) {
            $this->res = $this->objFunc->insertarCompensacionDet($this->objParam);
        } else {
            $this->res = $this->objFunc->modificarCompensacionDet($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function eliminarCompensacionDet()
    {
        $this->objFunc = $this->create('MODCompensacionDet');
        $this->res = $this->objFunc->eliminarCompensacionDet($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function cambiarTiempo()
    {
        $this->objFunc = $this->create('MODCompensacionDet');
        $this->res = $this->objFunc->cambiarTiempo($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

}

?>