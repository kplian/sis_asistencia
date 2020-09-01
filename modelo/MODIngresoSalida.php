<?php
/**
*@package pXP
*@file gen-MODIngresoSalida.php
*@author  (jjimenez)
*@date 14-08-2019 12:53:11
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas


HISTORIAL DE MODIFICACIONES:
 *
#ISSUE				FECHA				AUTOR				DESCRIPCION

#14			    23-08-2019 12:53:11		Juan 				Archivo Nuevo Control diario de ingreso salida a la empresa Ende Transmision S.A.'

 */

class MODIngresoSalida extends MODbase{

	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarIngresoSalida(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='asis.ft_ingreso_salida_sel';
		$this->transaccion='ASIS_COND_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_ingreso_salida','int4');
		$this->captura('id_funcionario','int4');
		$this->captura('hora','time');
		$this->captura('fecha','date');
		$this->captura('tipo','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
        $this->captura('funcionario','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarIngresoSalida(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='asis.ft_ingreso_salida_ime';
		$this->transaccion='ASIS_COND_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_funcionario','id_funcionario','int4');
		$this->setParametro('hora','hora','time');
		$this->setParametro('fecha','fecha','date');
		$this->setParametro('tipo','tipo','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarIngresoSalida(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='asis.ft_ingreso_salida_ime';
		$this->transaccion='ASIS_COND_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_ingreso_salida','id_ingreso_salida','int4');
		$this->setParametro('id_funcionario','id_funcionario','int4');
		$this->setParametro('hora','hora','time');
		$this->setParametro('fecha','fecha','date');
		$this->setParametro('tipo','tipo','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarIngresoSalida(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='asis.ft_ingreso_salida_ime';
		$this->transaccion='ASIS_COND_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_ingreso_salida','id_ingreso_salida','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>