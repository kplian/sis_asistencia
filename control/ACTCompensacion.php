<?php
/****************************************************************************************
 * @package pXP
 * @file ACTCompensacion.php
 * @author  (amamani)
 * @date 18-05-2021 14:14:39
 * @description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 *
 * HISTORIAL DE MODIFICACIONES:
 * #ISSUE                FECHA                AUTOR                DESCRIPCION
 * #0                18-05-2021 14:14:39    amamani             Creacion
 * #
 *****************************************************************************************/

class ACTCompensacion extends ACTbase
{

    function listarCompensacion()
    {
        $this->objParam->defecto('ordenacion', 'id_compensacion');
        $this->objParam->defecto('dir_ordenacion', 'asc');

        if ($this->objParam->getParametro('tipo_interfaz') == 'ComponsacionSol') {
            switch ($this->objParam->getParametro('pes_estado')) {
                case 'registro':
                    $this->objParam->addFiltro("cpm.estado in (''registro'',''rechazado'')"); // un where de conuslta de sel es una concatenando
                    break;
                case 'vobo':
                    $this->objParam->addFiltro("cpm.estado = ''vobo''");
                    break;
                case 'aprobado':
                    $this->objParam->addFiltro("cpm.estado = ''aprobado''");
                    break;
                case 'cancelado':
                    $this->objParam->addFiltro("cpm.estado = ''cancelado''");
                    break;
            }
        }
        if ($this->objParam->getParametro('tipo_interfaz') == 'ComponsacionVoBo'){
            $this->objParam->addFiltro("cpm.estado = ''vobo''");
        }
        if ($this->objParam->getParametro('tipoReporte') == 'excel_grid' || $this->objParam->getParametro('tipoReporte') == 'pdf_grid') {
            $this->objReporte = new Reporte($this->objParam, $this);
            $this->res = $this->objReporte->generarReporteListado('MODCompensacion', 'listarCompensacion');
        } else {
            $this->objFunc = $this->create('MODCompensacion');

            $this->res = $this->objFunc->listarCompensacion($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function insertarCompensacion()
    {
        $this->objFunc = $this->create('MODCompensacion');
        if ($this->objParam->insertar('id_compensacion')) {
            $this->res = $this->objFunc->insertarCompensacion($this->objParam);
        } else {
            $this->res = $this->objFunc->modificarCompensacion($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function eliminarCompensacion()
    {
        $this->objFunc = $this->create('MODCompensacion');
        $this->res = $this->objFunc->eliminarCompensacion($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function getDias()
    {
        $this->objFunc = $this->create('MODCompensacion');
        $this->res = $this->objFunc->getDias($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function cambiarEstado()
    {
        $this->objFunc = $this->create('MODCompensacion');
        $this->res = $this->objFunc->cambiarEstado($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
}

?>