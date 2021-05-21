<?php
/****************************************************************************************
*@package pXP
*@file gen-MODCompensacionDetCom.php
*@author  (amamani)
*@date 21-05-2021 17:01:17
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas

 HISTORIAL DE MODIFICACIONES:
 #ISSUE                FECHA                AUTOR                DESCRIPCION
  #0                21-05-2021 17:01:17    amamani             Creacion    
  #
*****************************************************************************************/

class MODCompensacionDetCom extends MODbase{
    
    function __construct(CTParametro $pParam){
        parent::__construct($pParam);
    }
            
    function listarCompensacionDetCom(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='asis.ft_compensacion_det_com_sel';
        $this->transaccion='ASIS_FCN_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
                
        //Definicion de la lista del resultado del query
		$this->captura('id_compensacion_det_com','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('fecha_comp','date');
		$this->captura('tiempo_comp','varchar');
		$this->captura('id_compensacion_det','int4');
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
            
    function insertarCompensacionDetCom(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='asis.ft_compensacion_det_com_ime';
        $this->transaccion='ASIS_FCN_INS';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('fecha_comp','fecha_comp','date');
		$this->setParametro('tiempo_comp','tiempo_comp','varchar');
		$this->setParametro('id_compensacion_det','id_compensacion_det','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
            
    function modificarCompensacionDetCom(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='asis.ft_compensacion_det_com_ime';
        $this->transaccion='ASIS_FCN_MOD';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
		$this->setParametro('id_compensacion_det_com','id_compensacion_det_com','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('fecha_comp','fecha_comp','date');
		$this->setParametro('tiempo_comp','tiempo_comp','varchar');
		$this->setParametro('id_compensacion_det','id_compensacion_det','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
            
    function eliminarCompensacionDetCom(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='asis.ft_compensacion_det_com_ime';
        $this->transaccion='ASIS_FCN_ELI';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
		$this->setParametro('id_compensacion_det_com','id_compensacion_det_com','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
            
}
?>