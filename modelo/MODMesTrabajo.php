<?php
/**
*@package pXP
*@file gen-MODMesTrabajo.php
*@author  (miguel.mamani)
*@date 31-01-2019 13:53:10
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODMesTrabajo extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarMesTrabajo(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='asis.ft_mes_trabajo_sel';
		$this->transaccion='ASIS_SMT_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setParametro('tipo_interfaz', 'tipo_interfaz', 'varchar');
		//Definicion de la lista del resultado del query
		$this->captura('id_mes_trabajo','int4');
		$this->captura('id_periodo','int4');
		$this->captura('id_gestion','int4');
		$this->captura('id_planilla','int4');
		$this->captura('id_funcionario','int4');
		$this->captura('id_estado_wf','int4');
		$this->captura('id_proceso_wf','int4');
		$this->captura('id_funcionario_apro','int4');
		$this->captura('estado','varchar');
		$this->captura('estado_reg','varchar');
		$this->captura('obs','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
        $this->captura('desc_funcionario','text');
        $this->captura('desc_funcionario_apro','text');
        $this->captura('nro_tramite','varchar');
        $this->captura('periodo','int4');
        $this->captura('codigo','varchar');
        $this->captura('desc_codigo','text');
        $this->captura('gestion','integer');
        $this->captura('nombre_cargo','varchar');
        $this->captura('tipo_contrato','varchar');

        //Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarMesTrabajo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='asis.ft_mes_trabajo_ime';
		$this->transaccion='ASIS_SMT_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_periodo','id_periodo','int4');
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('id_planilla','id_planilla','int4');
		$this->setParametro('id_funcionario','id_funcionario','int4');
		$this->setParametro('id_estado_wf','id_estado_wf','int4');
		$this->setParametro('id_proceso_wf','id_proceso_wf','int4');
		//$this->setParametro('id_funcionario_apro','id_funcionario_apro','int4');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('obs','obs','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarMesTrabajo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='asis.ft_mes_trabajo_ime';
		$this->transaccion='ASIS_SMT_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_mes_trabajo','id_mes_trabajo','int4');
		$this->setParametro('id_periodo','id_periodo','int4');
		$this->setParametro('id_gestion','id_gestion','int4');
		$this->setParametro('id_planilla','id_planilla','int4');
		$this->setParametro('id_funcionario','id_funcionario','int4');
		$this->setParametro('id_estado_wf','id_estado_wf','int4');
		$this->setParametro('id_proceso_wf','id_proceso_wf','int4');
		//$this->setParametro('id_funcionario_apro','id_funcionario_apro','int4');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('obs','obs','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarMesTrabajo(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='asis.ft_mes_trabajo_ime';
		$this->transaccion='ASIS_SMT_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_mes_trabajo','id_mes_trabajo','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
    function siguienteEstado(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento = 'asis.ft_mes_trabajo_ime';
        $this->transaccion = 'ASIS_SIGA_IME';
        $this->tipo_procedimiento = 'IME';
        //Define los parametros para la funcion
        $this->setParametro('id_proceso_wf_act', 'id_proceso_wf_act', 'int4');
        $this->setParametro('id_estado_wf_act', 'id_estado_wf_act', 'int4');
        $this->setParametro('id_funcionario_usu', 'id_funcionario_usu', 'int4');
        $this->setParametro('id_tipo_estado', 'id_tipo_estado', 'int4');
        $this->setParametro('id_funcionario_wf', 'id_funcionario_wf', 'int4');
        $this->setParametro('id_depto_wf', 'id_depto_wf', 'int4');
        $this->setParametro('obs', 'obs', 'text');
        $this->setParametro('json_procesos', 'json_procesos', 'text');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //Devuelve la respuesta
        return $this->respuesta;
    }
    function anteriorEstado(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento = 'asis.ft_mes_trabajo_ime';
        $this->transaccion = 'ASIS_ANT_IME';
        $this->tipo_procedimiento = 'IME';
        //Define los parametros para la funcion
        $this->setParametro('id_proceso_wf', 'id_proceso_wf', 'int4');
        $this->setParametro('id_estado_wf', 'id_estado_wf', 'int4');
        $this->setParametro('obs', 'obs', 'text');
        $this->setParametro('estado_destino', 'estado_destino', 'varchar');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //Devuelve la respuesta
        return $this->respuesta;
    }
    function  reporteHojaTiempo(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='asis.ft_mes_trabajo_sel';
        $this->transaccion='ASIS_RHT_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setParametro('id_proceso_wf', 'id_proceso_wf', 'int4');
        $this->setParametro('id_periodo', 'id_periodo', 'int4');
        $this->setParametro('id_gestion', 'id_gestion', 'int4');
        $this->setCount(false);

        $this->captura('nombre_funcionario','text');
        $this->captura('codigo','text');
        $this->captura('gestion','integer');
        $this->captura('periodo','int4');
        $this->captura('dia','int4');
        $this->captura('ingreso_manana','time');
        $this->captura('salida_manana','time');
        $this->captura('ingreso_tarde','time');
        $this->captura('salida_tarde','time');
        $this->captura('ingreso_noche','time');
        $this->captura('salida_noche','time');
        $this->captura('codigo_tcc','varchar');
        $this->captura('total_normal','numeric');
        $this->captura('total_extra','numeric');
        $this->captura('total_nocturna','numeric');
        $this->captura('extra_autorizada','numeric');
        $this->captura('justificacion_extra','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //var_dump($this->respuesta);exit;
        //Devuelve la respuesta
        return $this->respuesta;
    }
}
?>