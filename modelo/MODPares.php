<?php
/**
*@package pXP
*@file gen-MODPares.php
*@author  (mgarcia)
*@date 19-09-2019 16:00:52
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				19-09-2019 16:00:52								CREACION

*/

class MODPares extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarPares(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='asis.ft_pares_sel';
		$this->transaccion='ASIS_PAR_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setParametro('id_funcionario','id_funcionario','int4');

        //Definicion de la lista del resultado del query
		$this->captura('id_pares','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_transaccion_ini','int4');
		$this->captura('id_transaccion_fin','int4');
		$this->captura('fecha_marcado','date');
		$this->captura('id_funcionario','int4');
		$this->captura('id_licencia','int4');
		$this->captura('id_vacacion','int4');
		$this->captura('id_viatico','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('dia','int4');
        $this->captura('hora','varchar');
        $this->captura('evento','varchar');

        $this->captura('tipo_verificacion','varchar');
        $this->captura('obs','varchar');
        $this->captura('rango','varchar');
        $this->captura('tdo','varchar');
        $this->captura('desc_funcionario','text');

        //Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		//var_dump($this->respuesta);exit;
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarPares(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='asis.ft_pares_ime';
		$this->transaccion='ASIS_PAR_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_transaccion_ini','id_transaccion_ini','int4');
		$this->setParametro('id_transaccion_fin','id_transaccion_fin','int4');
		$this->setParametro('fecha_marcado','fecha_marcado','timestamp');
		$this->setParametro('id_funcionario','id_funcionario','int4');
		$this->setParametro('id_licencia','id_licencia','int4');
		$this->setParametro('id_vacacion','id_vacacion','int4');
		$this->setParametro('id_viatico','id_viatico','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarPares(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='asis.ft_pares_ime';
		$this->transaccion='ASIS_PAR_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_pares','id_pares','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_transaccion_ini','id_transaccion_ini','int4');
		$this->setParametro('id_transaccion_fin','id_transaccion_fin','int4');
		$this->setParametro('fecha_marcado','fecha_marcado','timestamp');
		$this->setParametro('id_funcionario','id_funcionario','int4');
		$this->setParametro('id_licencia','id_licencia','int4');
		$this->setParametro('id_vacacion','id_vacacion','int4');
		$this->setParametro('id_viatico','id_viatico','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarPares(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='asis.ft_pares_ime';
		$this->transaccion='ASIS_PAR_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_pares','id_pares','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
    function armarPares(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='asis.ft_pares_ime';
        $this->transaccion='ASIS_PARS_INS';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        /// this->setParametro('id_funcionario','id_funcionario','int4');
        $this->setParametro('id_periodo','id_periodo','int4');
        $this->setParametro('id_funcionario','id_funcionario','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }


}
?>