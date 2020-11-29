<?php
/**
 *@package pXP
 *@file gen-ACTPermiso.php
 *@author  (miguel.mamani)
 *@date 16-10-2019 13:14:05
 *@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
#0				16-10-2019 13:14:05								CREACION

 */

class ACTPermiso extends ACTbase{

    function listarPermiso(){
        $this->objParam->defecto('ordenacion','id_permiso');
        $this->objParam->defecto('dir_ordenacion','asc');

        if ($this->objParam->getParametro('tipo_interfaz') == 'PermisoReg'){

            switch ($this->objParam->getParametro('pes_estado')) {
                case 'registro':
                    $this->objParam->addFiltro("pmo.estado in (''registro'',''rechazado'')"); // un where de conuslta de sel es una concatenando
                    break;
                case 'vobo':
                    $this->objParam->addFiltro("pmo.estado = ''vobo''");
                    break;
                case 'aprobado':
                    $this->objParam->addFiltro("pmo.estado = ''aprobado''");
                    break;
                case 'rechazado':
                    $this->objParam->addFiltro("pmo.estado = ''rechazado''");
                    break;
                case 'cancelado':
                    $this->objParam->addFiltro("pmo.estado = ''cancelado''");
                    break;
            }

        }
        if ($this->objParam->getParametro('tipo_interfaz') == 'PermisoVoBo'){

            $this->objParam->addFiltro("pmo.estado = ''vobo''");
        }
        if ($this->objParam->getParametro('tipo_interfaz') == 'PermisoRRHH'){
            $this->objParam->addFiltro("pmo.estado <> ''registro''");
        }

          if ($this->objParam->getParametro('tipo_interfaz') == 'PermisoRrhh') {

              switch ($this->objParam->getParametro('pes_estado')) {
                  case 'vobo':
                      $this->objParam->addFiltro("pmo.estado = ''vobo''");
                      break;
                  case 'aprobado':
                      $this->objParam->addFiltro("pmo.estado = ''aprobado''");
                      break;
                  case 'rechazado':
                      $this->objParam->addFiltro("pmo.estado = ''rechazado''");
                      break;
                  case 'cancelado':
                      $this->objParam->addFiltro("pmo.estado = ''cancelado''");
                      break;
              }
             /* $filtroInit = "pmo.fecha_solicitud = now()::date";

              $this->objParam->addFiltro("pmo.estado = ''vobo''");

              if ($this->objParam->getParametro('param') != '') {
                  if ($this->objParam->getParametro('desde') != '' && $this->objParam->getParametro('hasta') != '') {
                      $filtroInit = "pmo.fecha_solicitud >= '' " . $this->objParam->getParametro('desde') . "'' and pmo.fecha_solicitud <= ''" . $this->objParam->getParametro('hasta') . "''";
                  }
                  if ($this->objParam->getParametro('id_tipo_estado') != '') {
                      $this->objParam->addFiltro("pmo.id_estado_wf =  " . $this->objParam->getParametro('id_tipo_estado') . " and ");
                  }
              }
              $this->objParam->addFiltro($filtroInit);*/

          }


        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODPermiso','listarPermiso');
        } else{
            $this->objFunc=$this->create('MODPermiso');

            $this->res=$this->objFunc->listarPermiso($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function insertarPermiso(){
        $this->objFunc=$this->create('MODPermiso');
        if($this->objParam->insertar('id_permiso')){
            $this->res=$this->objFunc->insertarPermiso($this->objParam);
        } else{
            $this->res=$this->objFunc->modificarPermiso($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function eliminarPermiso(){
        $this->objFunc=$this->create('MODPermiso');
        $this->res=$this->objFunc->eliminarPermiso($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function siguienteEstado(){
        $this->objFunc=$this->create('MODPermiso');
        $this->res=$this->objFunc->siguienteEstado($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function anteriorEstado(){
        $this->objFunc=$this->create('MODPermiso');
        $this->res=$this->objFunc->anteriorEstado($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function optenerRango(){
        $this->objFunc=$this->create('MODPermiso');
        $this->res=$this->objFunc->optenerRango($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function calcularRango(){
        $this->objFunc=$this->create('MODPermiso');
        $this->res=$this->objFunc->calcularRango($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function listaResponsable(){
        $this->objParam->defecto('ordenacion','id_funcionario');
        $this->objParam->defecto('dir_ordenacion','asc');

        $this->objFunc=$this->create('MODPermiso');
        $this->res=$this->objFunc->listaResponsable($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function aprobarEstado(){
        $this->objFunc=$this->create('MODPermiso');
        $this->res=$this->objFunc->aprobarEstado($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function listarEstados(){
        $this->objParam->defecto('ordenacion','id_tipo_estado');
        $this->objParam->defecto('dir_ordenacion','asc');

           if ($this->objParam->getParametro('marco') != '' && $this->objParam->getParametro('codigo') != ''){
              //  var_dump($this->objParam->getParametro('marco') ,$this->objParam->getParametro('codigo'));exit;
               $this->objParam->addFiltro("mp.codigo = ''".$this->objParam->getParametro('marco') ."'' and  tp.codigo =''".$this->objParam->getParametro('codigo')."'' ");

           }
        $this->objFunc=$this->create('MODPermiso');
        $this->res=$this->objFunc->listarEstados($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

}

?>
