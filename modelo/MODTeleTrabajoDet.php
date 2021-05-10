<?php
/****************************************************************************************
*@package pXP
*@file MODTeleTrabajoDet.php
*@author  (admin.miguel)
*@date 10-03-2021 14:50:44
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas

 HISTORIAL DE MODIFICACIONES:
 #ISSUE                FECHA                AUTOR                DESCRIPCION
  #0                10-03-2021 14:50:44    admin.miguel             Creacion    
  #
*****************************************************************************************/

class MODTeleTrabajoDet extends MODbase{
    
    function __construct(CTParametro $pParam){
        parent::__construct($pParam);
    }
            
    function listarTeleTrabajoDet(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='asis.ft_tele_trabajo_det_sel';
        $this->transaccion='ASIS_TTD_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
                
        //Definicion de la lista del resultado del query
		$this->captura('id_tele_trabajo_det','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_tele_trabajo','int4');
		$this->captura('fecha','date');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
        $this->captura('usr_mod','varchar');
        
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        
        //Devuelve la respuesta
        return $this->respuesta;
    }
            
    function insertarTeleTrabajoDet(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='asis.ft_tele_trabajo_det_ime';
        $this->transaccion='ASIS_TTD_INS';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_tele_trabajo','id_tele_trabajo','int4');
		$this->setParametro('fecha','fecha','date');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
            
    function modificarTeleTrabajoDet(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='asis.ft_tele_trabajo_det_ime';
        $this->transaccion='ASIS_TTD_MOD';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
		$this->setParametro('id_tele_trabajo_det','id_tele_trabajo_det','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_tele_trabajo','id_tele_trabajo','int4');
		$this->setParametro('fecha','fecha','date');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
            
    function eliminarTeleTrabajoDet(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='asis.ft_tele_trabajo_det_ime';
        $this->transaccion='ASIS_TTD_ELI';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
		$this->setParametro('id_tele_trabajo_det','id_tele_trabajo_det','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
            
}
?>