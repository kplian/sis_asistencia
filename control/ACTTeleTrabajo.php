<?php
/****************************************************************************************
*@package pXP
*@file gen-ACTTeleTrabajo.php
*@author  (admin.miguel)
*@date 01-02-2021 14:53:44
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo

 HISTORIAL DE MODIFICACIONES:
 #ISSUE                FECHA                AUTOR                DESCRIPCION
  #0                01-02-2021 14:53:44    admin.miguel             Creacion    
  #
*****************************************************************************************/

class ACTTeleTrabajo extends ACTbase{    
            
    function listarTeleTrabajo(){
		$this->objParam->defecto('ordenacion','id_tele_trabajo');
        $this->objParam->defecto('dir_ordenacion','asc');
        if ($this->objParam->getParametro('tipo_interfaz') == 'SolTeleTrabajo'){
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
        if ($this->objParam->getParametro('tipo_interfaz') == 'TeleTrabajoVoBo'){
            $this->objParam->addFiltro("tlt.estado = ''vobo''");
        }

		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODTeleTrabajo','listarTeleTrabajo');
        } else{
        	$this->objFunc=$this->create('MODTeleTrabajo');
            
        	$this->res=$this->objFunc->listarTeleTrabajo($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
                
    function insertarTeleTrabajo(){
        $this->objFunc=$this->create('MODTeleTrabajo');    
        if($this->objParam->insertar('id_tele_trabajo')){
            $this->res=$this->objFunc->insertarTeleTrabajo($this->objParam);            
        } else{            
            $this->res=$this->objFunc->modificarTeleTrabajo($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
                        
    function eliminarTeleTrabajo(){
        	$this->objFunc=$this->create('MODTeleTrabajo');    
        $this->res=$this->objFunc->eliminarTeleTrabajo($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function aprobarEstado(){
        $this->objFunc=$this->create('MODTeleTrabajo');
        $this->res=$this->objFunc->aprobarEstado($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
            
}

?>