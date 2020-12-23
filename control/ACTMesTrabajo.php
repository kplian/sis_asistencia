<?php
/**
*@package pXP
*@file gen-ACTMesTrabajo.php
*@author  (miguel.mamani)
*@date 31-01-2019 13:53:10
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 * HISTORIAL DE MODIFICACIONES:
 * #ISSUE				FECHA				AUTOR				DESCRIPCION
 *  #8 ETR			24/06/2019				MMV					Validar fecha des contrato finalizados y listado
*/
require_once(dirname(__FILE__).'/../reportes/RHojaTiempo.php');
require_once(dirname(__FILE__).'/../reportes/RReporteMesTrabajoUo.php');

class ACTMesTrabajo extends ACTbase{    
			
	function listarMesTrabajo(){
		$this->objParam->defecto('ordenacion','id_mes_trabajo');
		$this->objParam->defecto('dir_ordenacion','asc');
        if($this->objParam->getParametro('tipo_interfaz') == 'cc_ht'){
            if($this->objParam->getParametro('id_periodo') != ''){
                $this->objParam->addFiltro("smt.id_periodo = ".$this->objParam->getParametro('id_periodo'));
            }
            $this->objParam->addFiltro("smt.estado in (''aprobado'')");
        }

        if($this->objParam->getParametro('tipo_interfaz') == 'VoBo'){
            if($this->objParam->getParametro('id_periodo') != ''){
                $this->objParam->addFiltro("smt.id_periodo = ".$this->objParam->getParametro('id_periodo'));
            }
            $this->objParam->addFiltro("smt.estado in (''asignado'')");
        }else {
            if($this->objParam->getParametro('id_periodo') != ''){
                $this->objParam->addFiltro("smt.id_periodo = ".$this->objParam->getParametro('id_periodo'));
            }
            switch ($this->objParam->getParametro('pes_estado')) {
                case 'borrador':
                    $this->objParam->addFiltro("smt.estado = ''borrador''");
                    break;
                case 'asignado':
                    $this->objParam->addFiltro("smt.estado = ''asignado''");
                    break;
                case 'aprobado':
                    $this->objParam->addFiltro("smt.estado = ''aprobado''");
                    break;
            }
        }
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODMesTrabajo','listarMesTrabajo');
		} else{
			$this->objFunc=$this->create('MODMesTrabajo');
			
			$this->res=$this->objFunc->listarMesTrabajo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarMesTrabajo(){
		$this->objFunc=$this->create('MODMesTrabajo');	
		if($this->objParam->insertar('id_mes_trabajo')){
			$this->res=$this->objFunc->insertarMesTrabajo($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarMesTrabajo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarMesTrabajo(){
			$this->objFunc=$this->create('MODMesTrabajo');	
		$this->res=$this->objFunc->eliminarMesTrabajo($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
    function siguienteEstado(){
        $this->objFunc=$this->create('MODMesTrabajo');
        $this->res=$this->objFunc->siguienteEstado($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function anteriorEstado(){
        $this->objFunc=$this->create('MODMesTrabajo');
        $this->res=$this->objFunc->anteriorEstado($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function reporteHojaTiempo(){

        $this->objFunc = $this->create('MODMesTrabajo');
        $this->res = $this->objFunc->reporteHojaTiempo($this->objParam);
        $titulo = 'Hoja Tiempo';
        $nombreArchivo = uniqid(md5(session_id()) . $titulo);
        $nombreArchivo .= '.xls';
        $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
        $this->objParam->addParametro('datos', $this->res->datos);
        $this->objReporteFormato = new RHojaTiempo($this->objParam);
        $this->objReporteFormato->generarDatos();
        $this->objReporteFormato->generarReporte();
        $this->mensajeExito = new Mensaje();
        $this->mensajeExito->setMensaje('EXITO', 'Reporte.php', 'Reporte generado','Se generó con éxito el reporte: ' . $nombreArchivo, 'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
    }
    //#8
    function listarFuncionarioHt(){
        $this->objFunc=$this->create('MODMesTrabajo');
        $this->res=$this->objFunc->listarFuncionarioHt($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function isertarAuto(){
        $this->objFunc=$this->create('MODMesTrabajo');
        $this->res=$this->objFunc->isertarAuto($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function reporteMesTrabajoUo(){
        $this->objFunc = $this->create('MODMesTrabajo');
        $this->res = $this->objFunc->reporteMesTrabajoUo($this->objParam);
        $titulo = 'Hoja Tiempo';
        $nombreArchivo = uniqid(md5(session_id()) . $titulo);
        $nombreArchivo .= '.xls';
        $this->objParam->addParametro('nombre_archivo', $nombreArchivo);
        $this->objParam->addParametro('datos', $this->res->datos);
        $this->objReporteFormato = new RReporteMesTrabajoUo($this->objParam);
        $this->objReporteFormato->generarDatos();
        $this->objReporteFormato->generarReporte();
        $this->mensajeExito = new Mensaje();
        $this->mensajeExito->setMensaje('EXITO', 'Reporte.php', 'Reporte generado','Se generó con éxito el reporte: ' . $nombreArchivo, 'control');
        $this->mensajeExito->setArchivoGenerado($nombreArchivo);
        $this->mensajeExito->imprimirRespuesta($this->mensajeExito->generarJson());
    }
    function listarHojaTiempoAgrupador(){
        $this->objParam->defecto('ordenacion','id_mes_trabajo');

        $this->objParam->defecto('dir_ordenacion','asc');
        if($this->objParam->getParametro('tipo_interfaz') == 'MesTrabajoVoBo'){
            $this->objParam->addFiltro("hta.estado in (''asignado'')");
        }
        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODMesTrabajo','listarHojaTiempoAgrupador');
        } else{
            $this->objFunc=$this->create('MODMesTrabajo');

            $this->res=$this->objFunc->listarHojaTiempoAgrupador($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

}

?>