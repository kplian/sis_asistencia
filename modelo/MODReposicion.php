<?php
/**
*@package pXP
*@file gen-MODReposicion.php
*@author  (admin.miguel)
*@date 15-10-2020 18:57:40
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				15-10-2020 18:57:40								CREACION

*/

class MODReposicion extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarReposicion(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='asis.ft_reposicion_sel';
		$this->transaccion='ASIS_RPC_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
		$this->captura('id_reposicion','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('obs_dba','varchar');
		$this->captura('id_permiso','int4');
		$this->captura('fecha_reposicion','date');
		$this->captura('id_funcionario','int4');
		$this->captura('evento','varchar');
		$this->captura('tiempo','varchar');
		$this->captura('id_transacion_zkb','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('desc_funcionario1','text');
		$this->captura('nro_tramite','varchar');
		$this->captura('tipo_permiso','varchar');
		
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarReposicion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='asis.ft_reposicion_ime';
		$this->transaccion='ASIS_RPC_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('obs_dba','obs_dba','varchar');
		$this->setParametro('id_permiso','id_permiso','int4');
		$this->setParametro('fecha_reposicion','fecha_reposicion','date');
		$this->setParametro('id_funcionario','id_funcionario','int4');
		$this->setParametro('evento','evento','varchar');
		$this->setParametro('tiempo','tiempo','varchar');
		$this->setParametro('id_transacion_zkb','id_transacion_zkb','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarReposicion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='asis.ft_reposicion_ime';
		$this->transaccion='ASIS_RPC_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_reposicion','id_reposicion','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('obs_dba','obs_dba','varchar');
		$this->setParametro('id_permiso','id_permiso','int4');
		$this->setParametro('fecha_reposicion','fecha_reposicion','date');
		$this->setParametro('id_funcionario','id_funcionario','int4');
		$this->setParametro('evento','evento','varchar');
		$this->setParametro('tiempo','tiempo','varchar');
		$this->setParametro('id_transacion_zkb','id_transacion_zkb','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarReposicion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='asis.ft_reposicion_ime';
		$this->transaccion='ASIS_RPC_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_reposicion','id_reposicion','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>