<?php
/**
*@package pXP
*@file gen-MODVacacion.php
*@author  (apinto)
*@date 01-10-2019 15:29:35
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				01-10-2019 15:29:35								CREACION

*/

class MODVacacion extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarVacacion(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='asis.ft_vacacion_sel';
		$this->transaccion='ASIS_VAC_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
				
		//Definicion de la lista del resultado del query
        $this->setParametro('tipo_interfaz','tipo_interfaz','varchar');
		$this->captura('id_vacacion','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_funcionario','int4');
		$this->captura('fecha_inicio','date');
		$this->captura('fecha_fin','date');
		$this->captura('dias','numeric');
		$this->captura('descripcion','text');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
        $this->captura('desc_funcionario1','varchar');
		//wf
        $this->captura('id_proceso_wf','int4');
        $this->captura('id_estado_wf','int4');
        $this->captura('estado','varchar');
        $this->captura('nro_tramite','varchar');
        $this->captura('medio_dia','integer');
        $this->captura('dias_efectivo', 'numeric');
		$this->captura('id_responsable','int4');
        $this->captura('responsable','text');

        $this->captura('funcionario_sol','text');
        $this->captura('observaciones','text');

        //Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}


	function insertarVacacion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='asis.ft_vacacion_ime';
		$this->transaccion='ASIS_VAC_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_funcionario','id_funcionario','int4');
		$this->setParametro('fecha_inicio','fecha_inicio','date');
		$this->setParametro('fecha_fin','fecha_fin','date');
		$this->setParametro('dias','dias','numeric');
		$this->setParametro('descripcion','descripcion','text');
		$this->setParametro('medio_dia','medio_dia','integer');   //medio_dia
        $this->setParametro('dias_efectivo','dias_efectivo','numeric');
        $this->setParametro('id_responsable','id_responsable','int4');


		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarVacacion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='asis.ft_vacacion_ime';
		$this->transaccion='ASIS_VAC_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_vacacion','id_vacacion','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_funcionario','id_funcionario','int4');
		$this->setParametro('fecha_inicio','fecha_inicio','date');
		$this->setParametro('fecha_fin','fecha_fin','date');
		$this->setParametro('dias','dias','numeric');
		$this->setParametro('descripcion','descripcion','text');
        $this->setParametro('medio_dia','medio_dia','integer');
        $this->setParametro('dias_efectivo','dias_efectivo', 'numeric');
        $this->setParametro('id_responsable','id_responsable','int4');

// medio_dia

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarVacacion(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='asis.ft_vacacion_ime';
		$this->transaccion='ASIS_VAC_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_vacacion','id_vacacion','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
    function siguienteEstado(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento = 'asis.ft_vacacion_ime';
        $this->transaccion = 'ASIS_SIGAV_IME';
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
        $this->procedimiento = 'asis.ft_vacacion_ime';
        $this->transaccion = 'ASIS_ANTV_IME';
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

    function getDias(){
        $this->procedimiento='asis.ft_vacacion_ime';
        $this->transaccion='ASIS_VAC_VALID';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('fecha_fin','fecha_fin','date');
        $this->setParametro('fecha_inicio','fecha_inicio','date');
        $this->setParametro('dias','dias','numeric');
        $this->setParametro('medios_dias','medios_dias','bool');
        $this->setParametro('dias_efectivo', 'dias_efectivo', 'numeric');
        $this->setParametro('id_funcionario', 'id_funcionario', 'int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
	function AsignarVacacion(){
		//Definicion de variables para ejecucion del procedimiento
	    $this->procedimiento='asis.ft_vacacion_sel';
		$this->transaccion='ASIS_ASIGVAC_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion

		$this->setCount(false);  
		
		$this->tipo_conexion='seguridad';
		
		$this->arreglo=array("id_usuario" =>1,
							 "tipo"=>'TODOS'
							 );
		
		$this->setParametro('id_usuario','id_usuario','int4');						 
        $this->captura('dias_asignados','int4');

	    //Ejecuta la instruccion
		$this->armarConsulta();
		
		$this->ejecutarConsulta();
		
		//echo ("entro al cron modelo vacacion juan ".$this->consulta.' fin juan');
		//exit;
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
    function movimientoGet(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='asis.ft_vacacion_ime';
        $this->transaccion='ASIS_VM_GET';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_funcionario','id_funcionario','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    function cancelarVacacion(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='asis.ft_vacacion_ime';
        $this->transaccion='ASIS_CAN_INS';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_vacacion','id_vacacion','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
	}
	
	function aprobarEstado(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='asis.ft_vacacion_ime';
        $this->transaccion='ASIS_VVB_IME';
        $this->tipo_procedimiento='IME';
        //Define los parametros para la funcion
        $this->setParametro('id_proceso_wf','id_proceso_wf','int4');
        $this->setParametro('id_estado_wf','id_estado_wf','int4');
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //Devuelve la respuesta
        return $this->respuesta;
    }
}
?>