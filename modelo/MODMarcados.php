<?php
/**
*@package pXP
*@file gen-MODMarcados.php
*@author  (mgarcia)
*@date 12-07-2019 12:56:19
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODMarcados extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarMarcados(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='asis.ft_marcados_sel';
		$this->transaccion='ASIS_MAS_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_marcado','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('hora','time');
		$this->captura('id_biometrico','varchar');
		$this->captura('fecha_marcado','date');
		$this->captura('observacion','varchar');
		$this->captura('id_funcionario','int4');
		$this->captura('id_uo','int4');
		$this->captura('id_uo_funcionario','int4');
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
			
	function insertarMarcados(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='asis.ft_marcados_ime';
		$this->transaccion='ASIS_MAS_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('hora','hora','time');
		$this->setParametro('id_biometrico','id_biometrico','varchar');
		$this->setParametro('fecha_marcado','fecha_marcado','date');
		$this->setParametro('observacion','observacion','varchar');
		$this->setParametro('id_funcionario','id_funcionario','int4');
		$this->setParametro('id_uo','id_uo','int4');
		$this->setParametro('id_uo_funcionario','id_uo_funcionario','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarMarcados(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='asis.ft_marcados_ime';
		$this->transaccion='ASIS_MAS_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_marcado','id_marcado','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('hora','hora','time');
		$this->setParametro('id_biometrico','id_biometrico','varchar');
		$this->setParametro('fecha_marcado','fecha_marcado','date');
		$this->setParametro('observacion','observacion','varchar');
		$this->setParametro('id_funcionario','id_funcionario','int4');
		$this->setParametro('id_uo','id_uo','int4');
		$this->setParametro('id_uo_funcionario','id_uo_funcionario','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarMarcados(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='asis.ft_marcados_ime';
		$this->transaccion='ASIS_MAS_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_marcado','id_marcado','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>