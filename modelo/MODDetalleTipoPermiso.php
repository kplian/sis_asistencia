<?php
/****************************************************************************************
*@package pXP
*@file MODDetalleTipoPermiso.php
*@author  (admin.miguel)
*@date 22-03-2021 01:35:43
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas

 HISTORIAL DE MODIFICACIONES:
 #ISSUE                FECHA                AUTOR                DESCRIPCION
  #0                22-03-2021 01:35:43    admin.miguel             Creacion    
  #
*****************************************************************************************/

class MODDetalleTipoPermiso extends MODbase{
    
    function __construct(CTParametro $pParam){
        parent::__construct($pParam);
    }
            
    function listarDetalleTipoPermiso(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='asis.ft_detalle_tipo_permiso_sel';
        $this->transaccion='ASIS_DTP_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
                
        //Definicion de la lista del resultado del query
		$this->captura('id_detalle_tipo_permiso','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('nombre','varchar');
		$this->captura('descripcion','varchar');
		$this->captura('dias','numeric');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
        $this->captura('usr_mod','varchar');
        $this->captura('id_tipo_permiso','int4');


        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        
        //Devuelve la respuesta
        return $this->respuesta;
    }
            
    function insertarDetalleTipoPermiso(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='asis.ft_detalle_tipo_permiso_ime';
        $this->transaccion='ASIS_DTP_INS';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('dias','dias','numeric');
		$this->setParametro('id_tipo_permiso','id_tipo_permiso','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
            
    function modificarDetalleTipoPermiso(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='asis.ft_detalle_tipo_permiso_ime';
        $this->transaccion='ASIS_DTP_MOD';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
		$this->setParametro('id_detalle_tipo_permiso','id_detalle_tipo_permiso','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('dias','dias','numeric');
        $this->setParametro('id_tipo_permiso','id_tipo_permiso','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
            
    function eliminarDetalleTipoPermiso(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='asis.ft_detalle_tipo_permiso_ime';
        $this->transaccion='ASIS_DTP_ELI';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
		$this->setParametro('id_detalle_tipo_permiso','id_detalle_tipo_permiso','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
            
}
?>