<?php
/**
*@package pXP
*@file gen-MODTipoAplicacion.php
*@author  (miguel.mamani)
*@date 21-02-2019 13:27:56
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODTipoAplicacion extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarTipoAplicacion(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='asis.ft_tipo_aplicacion_sel';
		$this->transaccion='ASIS_TAS_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_tipo_aplicacion','int4');
		$this->captura('id_tipo_columna','int4');
		$this->captura('nombre','varchar');
		$this->captura('descripcion','varchar');
		$this->captura('codigo_aplicacion','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('consolidable','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_tipo_columna','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarTipoAplicacion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='asis.ft_tipo_aplicacion_ime';
		$this->transaccion='ASIS_TAS_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_columna','id_tipo_columna','int4');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('codigo_aplicacion','codigo_aplicacion','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('consolidable','consolidable','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarTipoAplicacion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='asis.ft_tipo_aplicacion_ime';
		$this->transaccion='ASIS_TAS_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_aplicacion','id_tipo_aplicacion','int4');
		$this->setParametro('id_tipo_columna','id_tipo_columna','int4');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('descripcion','descripcion','varchar');
		$this->setParametro('codigo_aplicacion','codigo_aplicacion','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('consolidable','consolidable','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarTipoAplicacion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='asis.ft_tipo_aplicacion_ime';
		$this->transaccion='ASIS_TAS_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_aplicacion','id_tipo_aplicacion','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>