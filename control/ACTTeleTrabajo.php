<?php
/****************************************************************************************
 * @package pXP
 * @file gen-ACTTeleTrabajo.php
 * @author  (admin.miguel)
 * @date 01-02-2021 14:53:44
 * @description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 *
 * HISTORIAL DE MODIFICACIONES:
 * #ISSUE                FECHA                AUTOR                DESCRIPCION
 * #0                01-02-2021 14:53:44    admin.miguel             Creacion
 * #
 *****************************************************************************************/
require_once(dirname(__FILE__) . '/../reportes/RTeletrabajo.php');

class ACTTeleTrabajo extends ACTbase
{

    function listarTeleTrabajo()
    {
        $this->objParam->defecto('ordenacion', 'id_tele_trabajo');
        $this->objParam->defecto('dir_ordenacion', 'asc');
        if ($this->objParam->getParametro('tipo_interfaz') == 'SolTeleTrabajo') {
            switch ($this->objParam->getParametro('pes_estado')) {
                case 'registro':
                    $this->objParam->addFiltro("tlt.estado in (''registro'',''rechazado'')"); // un where de conuslta de sel es una concatenando
                    break;
                case 'vobo':
                    $this->objParam->addFiltro("tlt.estado = ''vobo''");
                    break;
                case 'aprobado':
                    $this->objParam->addFiltro("tlt.estado = ''aprobado''");
                    break;
                case 'cancelado':
                    $this->objParam->addFiltro("tlt.estado = ''cancelado''");
                    break;
            }
        }
        if ($this->objParam->getParametro('tipo_interfaz') == 'TeleTrabajoVoBo') {
            $this->objParam->addFiltro("tlt.estado = ''vobo''");
        }
        if ($this->objParam->getParametro('tipo_interfaz') == 'TeleTrabajoRrhh') {
            switch ($this->objParam->getParametro('pes_estado')) {
                case 'registro':
                    $this->objParam->addFiltro("tlt.estado = ''registro''");
                    break;
                case 'vobo':
                    $this->objParam->addFiltro("tlt.estado = ''vobo''");
                    break;
                case 'aprobado':
                    $this->objParam->addFiltro("tlt.estado = ''aprobado''");
                    break;
                case 'rechazado':
                    $this->objParam->addFiltro("tlt.estado = ''rechazado''");
                    break;
                case 'cancelado':
                    $this->objParam->addFiltro("tlt.estado = ''cancelado''");
                    break;
            }
            $filtroInit = "tlt.fecha_reg::date = now()::date";

            if ($this->objParam->getParametro('param') != '') {
                if ($this->objParam->getParametro('desde') != '' && $this->objParam->getParametro('hasta') != '') {
                    $filtroInit = "tlt.fecha_reg::date >= '' " . $this->objParam->getParametro('desde') . "'' and tlt.fecha_reg::date <= ''" . $this->objParam->getParametro('hasta') . "''";
                }
                if ($this->objParam->getParametro('id_uo') != '') {

                    $filtroInit = "dep.id_uo =  " . $this->objParam->getParametro('id_uo') . "  ";
                }
            }
            $this->objParam->addFiltro($filtroInit);
        }
        if ($this->objParam->getParametro('tipoReporte') == 'excel_grid' || $this->objParam->getParametro('tipoReporte') == 'pdf_grid') {
            $this->objReporte = new Reporte($this->objParam, $this);
            $this->res = $this->objReporte->generarReporteListado('MODTeleTrabajo', 'listarTeleTrabajo');
        } else {
            $this->objFunc = $this->create('MODTeleTrabajo');

            $this->res = $this->objFunc->listarTeleTrabajo($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function insertarTeleTrabajo()
    {
        $this->objFunc = $this->create('MODTeleTrabajo');
        if ($this->objParam->insertar('id_tele_trabajo')) {
            $this->res = $this->objFunc->insertarTeleTrabajo($this->objParam);
        } else {
            $this->res = $this->objFunc->modificarTeleTrabajo($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function eliminarTeleTrabajo()
    {
        $this->objFunc = $this->create('MODTeleTrabajo');
        $this->res = $this->objFunc->eliminarTeleTrabajo($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function aprobarEstado()
    {
        $this->objFunc = $this->create('MODTeleTrabajo');
        $this->res = $this->objFunc->aprobarEstado($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function listarTeleTrabajoReporte()
    {

        $this->objFunc = $this->create('MODTeleTrabajo');
        $this->res = $this->objFunc->listarTeleTrabajoReporte($this->objParam);
        //obtener titulo del reporte
        $titulo = 'Solicitud Teletrabajo';
        //Genera el nombre del archivo (aleatorio + titulo)
        $nombreArchivo = uniqid(md5(session_id()) . $titulo);
        $nombreArchivo .= '.pdf';
        $this->objParam->addParametro('orientacion', 'P');
        $this->objParam->addParametro('tamano', 'LETTER');
        $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
        //Instancia la clase de pdf
        $this->objReporteFormato = new RTeletrabajo($this->objParam);
        $this->objReporteFormato->setDatos($this->res->datos);
        $this->objReporteFormato->generarReporte();
        $this->objReporteFormato->output($this->objReporteFormato->url_archivo, 'F');

        $this->mensajeExito = new Mensaje();
        $this->mensajeExito->setMensaje('EXITO', 'Reporte.php', 'Reporte generado',
            'Se generó con éxito el reporte: ' . $nombreArchivo, 'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());

    }
}

?>