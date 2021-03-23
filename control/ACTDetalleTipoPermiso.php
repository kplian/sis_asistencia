<?php
/****************************************************************************************
*@package pXP
*@file ACTDetalleTipoPermiso.php
*@author  (admin.miguel)
*@date 22-03-2021 01:35:43
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo

 HISTORIAL DE MODIFICACIONES:
 #ISSUE                FECHA                AUTOR                DESCRIPCION
  #0                22-03-2021 01:35:43    admin.miguel             Creacion    
  #
*****************************************************************************************/

class ACTDetalleTipoPermiso extends ACTbase{    
            
    function listarDetalleTipoPermiso(){
		$this->objParam->defecto('ordenacion','id_detalle_tipo_permiso');
        $this->objParam->defecto('dir_ordenacion','asc');
        if($this->objParam->getParametro('id_tipo_permiso') != '') {
            $this->objParam->addFiltro("dtp.id_tipo_permiso = " . $this->objParam->getParametro('id_tipo_permiso'));
        }
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODDetalleTipoPermiso','listarDetalleTipoPermiso');
        } else{
        	$this->objFunc=$this->create('MODDetalleTipoPermiso');
            
        	$this->res=$this->objFunc->listarDetalleTipoPermiso($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
                
    function insertarDetalleTipoPermiso(){
        $this->objFunc=$this->create('MODDetalleTipoPermiso');    
        if($this->objParam->insertar('id_detalle_tipo_permiso')){
            $this->res=$this->objFunc->insertarDetalleTipoPermiso($this->objParam);            
        } else{            
            $this->res=$this->objFunc->modificarDetalleTipoPermiso($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
                        
    function eliminarDetalleTipoPermiso(){
        	$this->objFunc=$this->create('MODDetalleTipoPermiso');    
        $this->res=$this->objFunc->eliminarDetalleTipoPermiso($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
            
}

?>