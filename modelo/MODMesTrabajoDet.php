<?php
/**
*@package pXP
*@file gen-MODMesTrabajoDet.php
*@author  (miguel.mamani)
*@date 31-01-2019 16:36:51
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODMesTrabajoDet extends MODbase{
	
	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}
			
	function listarMesTrabajoDet(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='asis.ft_mes_trabajo_det_sel';
		$this->transaccion='ASIS_MTD_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion

        $this->capturaCount('suma_normal','numeric');
        $this->capturaCount('suma_extra','numeric');
        $this->capturaCount('suma_nocturna','numeric');
        $this->capturaCount('suma_autorizada','numeric');

		//Definicion de la lista del resultado del query
		$this->captura('id_mes_trabajo_det','int4');
		$this->captura('ingreso_manana','time');
		$this->captura('id_mes_trabajo','int4');
		$this->captura('id_centro_costo','int4');
		$this->captura('ingreso_tarde','time');
		$this->captura('extra_autorizada','numeric');
        $this->captura('tipo','varchar');
		$this->captura('ingreso_noche','time');
		$this->captura('total_normal','numeric');
		$this->captura('estado_reg','varchar');
		$this->captura('total_extra','numeric');
		$this->captura('salida_manana','time');
		$this->captura('salida_tarde','time');
		$this->captura('justificacion_extra','varchar');
		$this->captura('salida_noche','time');
		$this->captura('dia','int4');
		$this->captura('total_nocturna','numeric');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('id_usuario_mod','int4');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('codigo_cc','text');
        $this->captura('tipo_dos','varchar');
        $this->captura('tipo_tres','varchar');
		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();
		
		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function insertarMesTrabajoDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='asis.ft_mes_trabajo_det_ime';
		$this->transaccion='ASIS_MTD_INS';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('ingreso_manana','ingreso_manana','time');
		$this->setParametro('id_mes_trabajo','id_mes_trabajo','int4');
		$this->setParametro('id_centro_costo','id_centro_costo','int4');
		$this->setParametro('ingreso_tarde','ingreso_tarde','time');
		$this->setParametro('extra_autorizada','extra_autorizada','numeric');
		$this->setParametro('tipo','tipo','varchar');
		$this->setParametro('ingreso_noche','ingreso_noche','time');
		$this->setParametro('total_normal','total_normal','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('total_extra','total_extra','numeric');
		$this->setParametro('salida_manana','salida_manana','time');
		$this->setParametro('salida_tarde','salida_tarde','time');
		$this->setParametro('justificacion_extra','justificacion_extra','varchar');
		$this->setParametro('salida_noche','salida_noche','time');
		$this->setParametro('dia','dia','int4');
		$this->setParametro('total_nocturna','total_nocturna','numeric');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function modificarMesTrabajoDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='asis.ft_mes_trabajo_det_ime';
		$this->transaccion='ASIS_MTD_MOD';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_mes_trabajo_det','id_mes_trabajo_det','int4');
		$this->setParametro('ingreso_manana','ingreso_manana','time');
		$this->setParametro('id_mes_trabajo','id_mes_trabajo','int4');
		$this->setParametro('id_centro_costo','id_centro_costo','int4');
		$this->setParametro('ingreso_tarde','ingreso_tarde','time');
		$this->setParametro('extra_autorizada','extra_autorizada','numeric');
		$this->setParametro('tipo','tipo','varchar');
		$this->setParametro('ingreso_noche','ingreso_noche','time');
		$this->setParametro('total_normal','total_normal','numeric');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('total_extra','total_extra','numeric');
		$this->setParametro('salida_manana','salida_manana','time');
		$this->setParametro('salida_tarde','salida_tarde','time');
		$this->setParametro('justificacion_extra','justificacion_extra','varchar');
		$this->setParametro('salida_noche','salida_noche','time');
		$this->setParametro('dia','dia','int4');
		$this->setParametro('total_nocturna','total_nocturna','numeric');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
			
	function eliminarMesTrabajoDet(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='asis.ft_mes_trabajo_det_ime';
		$this->transaccion='ASIS_MTD_ELI';
		$this->tipo_procedimiento='IME';
				
		//Define los parametros para la funcion
		$this->setParametro('id_mes_trabajo_det','id_mes_trabajo_det','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}
    function insertarMesTrabajoSon(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='asis.ft_mes_trabajo_det_ime';
        $this->transaccion='ASIS_MJS_INS';
        $this->tipo_procedimiento='IME';
        //Define los parametros para la funcion
        $this->setParametro('mes_trabajo_json','mes_trabajo_json','text');
        $this->setParametro('id_mes_trabajo','id_mes_trabajo','int4');
        $this->setParametro('id_gestion','id_gestion','int4');
        $this->setParametro('desc_codigo','desc_codigo','text');
        $this->setParametro('periodo','periodo','int4');
        $this->setParametro('gestion','gestion','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
			
}
?>