<?php
/**
*@package pXP
*@file gen-MODMesTrabajoCon.php
*@author  (miguel.mamani)
*@date 13-03-2019 13:52:11
 * HISTORIAL DE MODIFICACIONES:
 * #ISSUE				FECHA				AUTOR				DESCRIPCION
 * #4	ERT			17/06/2019 				 MMV					Correccion bug
 */

class MODMesTrabajoCon extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarMesTrabajoCon(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='asis.ft_mes_trabajo_con_sel';
		$this->transaccion='ASIS_MT_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
        $this->capturaCount('suma_horas','numeric');//#4
        $this->capturaCount('suma_factor','numeric');//#4

		$this->captura('id_mes_trabajo_con','int4');
		$this->captura('id_tipo_aplicacion','int4');
		$this->captura('total_horas','numeric');
		$this->captura('id_centro_costo','int4');
		$this->captura('calculado_resta','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('factor','numeric');
		$this->captura('id_mes_trabajo','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
        $this->captura('codigo_aplicacion','varchar');
        $this->captura('codigo_tcc','varchar');
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarMesTrabajoCon(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='asis.ft_mes_trabajo_con_ime';
		$this->transaccion='ASIS_MT_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_tipo_aplicacion','id_tipo_aplicacion','int4');
		$this->setParametro('total_horas','total_horas','numeric');
		$this->setParametro('id_centro_costo','id_centro_costo','int4');
		$this->setParametro('calculado_resta','calculado_resta','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('factor','factor','numeric');
		$this->setParametro('id_mes_trabajo','id_mes_trabajo','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarMesTrabajoCon(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='asis.ft_mes_trabajo_con_ime';
		$this->transaccion='ASIS_MT_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_mes_trabajo_con','id_mes_trabajo_con','int4');
		$this->setParametro('id_tipo_aplicacion','id_tipo_aplicacion','int4');
		$this->setParametro('total_horas','total_horas','numeric');
		$this->setParametro('id_centro_costo','id_centro_costo','int4');
		$this->setParametro('calculado_resta','calculado_resta','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('factor','factor','numeric');
		$this->setParametro('id_mes_trabajo','id_mes_trabajo','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarMesTrabajoCon(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='asis.ft_mes_trabajo_con_ime';
		$this->transaccion='ASIS_MT_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_mes_trabajo_con','id_mes_trabajo_con','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
}
?>