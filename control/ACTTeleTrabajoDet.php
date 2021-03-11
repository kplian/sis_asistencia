<?php
/****************************************************************************************
 * @package pXP
 * @file ACTTeleTrabajoDet.php
 * @author  (admin.miguel)
 * @date 10-03-2021 14:50:44
 * @description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 *
 * HISTORIAL DE MODIFICACIONES:
 * #ISSUE                FECHA                AUTOR                DESCRIPCION
 * #0                10-03-2021 14:50:44    admin.miguel             Creacion
 * #
 *****************************************************************************************/

class ACTTeleTrabajoDet extends ACTbase
{

    function listarTeleTrabajoDet()
    {
        $this->objParam->defecto('ordenacion', 'id_tele_trabajo_det');
        $this->objParam->defecto('dir_ordenacion', 'asc');
        if ($this->objParam->getParametro('id_tele_trabajo') != '') {
            $this->objParam->addFiltro("ttd.id_tele_trabajo = " . $this->objParam->getParametro('id_tele_trabajo'));
        }
        if ($this->objParam->getParametro('tipoReporte') == 'excel_grid' || $this->objParam->getParametro('tipoReporte') == 'pdf_grid') {
            $this->objReporte = new Reporte($this->objParam, $this);
            $this->res = $this->objReporte->generarReporteListado('MODTeleTrabajoDet', 'listarTeleTrabajoDet');
        } else {
            $this->objFunc = $this->create('MODTeleTrabajoDet');

            $this->res = $this->objFunc->listarTeleTrabajoDet($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function insertarTeleTrabajoDet()
    {
        $this->objFunc = $this->create('MODTeleTrabajoDet');
        if ($this->objParam->insertar('id_tele_trabajo_det')) {
            $this->res = $this->objFunc->insertarTeleTrabajoDet($this->objParam);
        } else {
            $this->res = $this->objFunc->modificarTeleTrabajoDet($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function eliminarTeleTrabajoDet()
    {
        $this->objFunc = $this->create('MODTeleTrabajoDet');
        $this->res = $this->objFunc->eliminarTeleTrabajoDet($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
}

?>