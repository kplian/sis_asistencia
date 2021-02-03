<?php
/**
*@package pXP
*@file gen-MODMovimientoVacacion.php
*@author  (miguel.mamani)
*@date 08-10-2019 10:39:21
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				08-10-2019 10:39:21								CREACION

*/

class MODMovimientoVacacion extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarMovimientoVacacion(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='asis.ft_movimiento_vacacion_sel';
		$this->transaccion='ASIS_MVS_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setParametro('id_funcionario','id_funcionario','int4');
        $this->setParametro('interfaz','interfaz','varchar');
				
		//Definicion de la lista del resultado del query
		$this->captura('id_movimiento_vacacion','int4');
		$this->captura('activo','varchar');
		$this->captura('id_funcionario','int4');
		$this->captura('desde','date');
		$this->captura('hasta','date');
		$this->captura('dias','numeric');
		$this->captura('tipo','varchar');
		$this->captura('dias_actual','numeric');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
        $this->captura('funcionario','varchar');
        $this->captura('nombre','varchar');
        $this->captura('apellido_paterno','varchar');
        $this->captura('apellido_materno','varchar');

		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarMovimientoVacacion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='asis.ft_movimiento_vacacion_ime';
		$this->transaccion='ASIS_MVS_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_funcionario','id_funcionario','int4');
		$this->setParametro('desde','desde','date');
		$this->setParametro('hasta','hasta','date');
		$this->setParametro('dias_asignado','dias_asignado','numeric');
		$this->setParametro('dias_acumulado','dias_acumulado','numeric');
		$this->setParametro('dias_tomado','dias_tomado','numeric');
		$this->setParametro('dias_actual','dias_actual','numeric');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarMovimientoVacacion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='asis.ft_movimiento_vacacion_ime';
		$this->transaccion='ASIS_MVS_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_movimiento_vacacion','id_movimiento_vacacion','int4');
		$this->setParametro('desde','desde','date');
		$this->setParametro('hasta','hasta','date');
		$this->setParametro('dias','dias','numeric');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarMovimientoVacacion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='asis.ft_movimiento_vacacion_ime';
		$this->transaccion='ASIS_MVS_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_movimiento_vacacion','id_movimiento_vacacion','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>