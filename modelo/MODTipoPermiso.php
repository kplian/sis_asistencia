<?php
/**
*@package pXP
*@file gen-MODTipoPermiso.php
*@author  (miguel.mamani)
*@date 16-10-2019 13:14:01
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				16-10-2019 13:14:01								CREACION

*/

class MODTipoPermiso extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarTipoPermiso(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='asis.ft_tipo_permiso_sel';
		$this->transaccion='ASIS_TPO_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_tipo_permiso','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('codigo','varchar');
		$this->captura('nombre','varchar');
		$this->captura('tiempo','time');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('documento','varchar');
		$this->captura('asignar_rango','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarTipoPermiso(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='asis.ft_tipo_permiso_ime';
		$this->transaccion='ASIS_TPO_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('tiempo','tiempo','time');
        $this->setParametro('documento','documento','varchar');
        $this->setParametro('asignar_rango','asignar_rango','varchar');
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarTipoPermiso(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='asis.ft_tipo_permiso_ime';
		$this->transaccion='ASIS_TPO_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_permiso','id_tipo_permiso','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('tiempo','tiempo','time');
        $this->setParametro('documento','documento','varchar');
        $this->setParametro('asignar_rango','asignar_rango','varchar');
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarTipoPermiso(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='asis.ft_tipo_permiso_ime';
		$this->transaccion='ASIS_TPO_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_permiso','id_tipo_permiso','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>