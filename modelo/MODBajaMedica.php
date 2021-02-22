<?php
/****************************************************************************************
*@package pXP
*@file gen-MODBajaMedica.php
*@author  (admin.miguel)
*@date 05-02-2021 14:41:38
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas

 HISTORIAL DE MODIFICACIONES:
 #ISSUE                FECHA                AUTOR                DESCRIPCION
  #0                05-02-2021 14:41:38    admin.miguel             Creacion    
  #
*****************************************************************************************/

class MODBajaMedica extends MODbase{
    
    function __construct(CTParametro $pParam){
        parent::__construct($pParam);
    }
            
    function listarBajaMedica(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='asis.ft_baja_medica_sel';
        $this->transaccion='ASIS_BMA_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
                
        //Definicion de la lista del resultado del query
		$this->captura('id_baja_medica','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_funcionario','int4');
		$this->captura('id_tipo_bm','int4');
		$this->captura('fecha_inicio','date');
		$this->captura('fecha_fin','date');
		$this->captura('dias_efectivo','numeric');
		$this->captura('id_proceso_wf','int4');
		$this->captura('id_estado_wf','int4');
		$this->captura('estado','varchar');
		$this->captura('nro_tramite','varchar');
		$this->captura('documento','varchar');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
        $this->captura('usr_mod','varchar');
        $this->captura('desc_nombre','varchar');
        $this->captura('desc_funcionario','text');
        $this->captura('codigo','varchar');
        $this->captura('observaciones','text');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        
        //Devuelve la respuesta
        return $this->respuesta;
    }
            
    function insertarBajaMedica(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='asis.ft_baja_medica_ime';
        $this->transaccion='ASIS_BMA_INS';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_funcionario','id_funcionario','int4');
		$this->setParametro('id_tipo_bm','id_tipo_bm','int4');
		$this->setParametro('fecha_inicio','fecha_inicio','date');
		$this->setParametro('fecha_fin','fecha_fin','date');
		$this->setParametro('dias_efectivo','dias_efectivo','numeric');
		$this->setParametro('id_proceso_wf','id_proceso_wf','int4');
		$this->setParametro('id_estado_wf','id_estado_wf','int4');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('nro_tramite','nro_tramite','varchar');
		$this->setParametro('documento','documento','varchar');
		$this->setParametro('observaciones','observaciones','text');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
            
    function modificarBajaMedica(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='asis.ft_baja_medica_ime';
        $this->transaccion='ASIS_BMA_MOD';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
		$this->setParametro('id_baja_medica','id_baja_medica','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_funcionario','id_funcionario','int4');
		$this->setParametro('id_tipo_bm','id_tipo_bm','int4');
		$this->setParametro('fecha_inicio','fecha_inicio','date');
		$this->setParametro('fecha_fin','fecha_fin','date');
		$this->setParametro('dias_efectivo','dias_efectivo','numeric');
		$this->setParametro('id_proceso_wf','id_proceso_wf','int4');
		$this->setParametro('id_estado_wf','id_estado_wf','int4');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('nro_tramite','nro_tramite','varchar');
		$this->setParametro('documento','documento','varchar');
        $this->setParametro('observaciones','observaciones','text');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
            
    function eliminarBajaMedica(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='asis.ft_baja_medica_ime';
        $this->transaccion='ASIS_BMA_ELI';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
		$this->setParametro('id_baja_medica','id_baja_medica','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    function aprobarEstado(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='asis.ft_baja_medica_ime';
        $this->transaccion='ASIS_BMA_SIG';
        $this->tipo_procedimiento='IME';
        //Define los parametros para la funcion
        $this->setParametro('id_proceso_wf','id_proceso_wf','int4');
        $this->setParametro('id_estado_wf','id_estado_wf','int4');
        $this->setParametro('evento','evento','varchar');
        $this->setParametro('obs', 'obs', 'text');
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //Devuelve la respuesta
        return $this->respuesta;
    }
    function listarBajaMedicaReporte(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='asis.ft_baja_medica_sel';
        $this->transaccion='ASIS_BMA_REPO';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        $this->setCount(false);
        $this->setParametro('fecha_inicio', 'fecha_inicio', 'date');
        $this->setParametro('fecha_fin', 'fecha_fin', 'date');
        $this->setParametro('estado', 'estado', 'varchar');
        //Definicion de la lista del resultado del query
        $this->captura('id_funcionario','int4');
        $this->captura('nombre','text');
        $this->captura('centro','varchar');
        $this->captura('gerencia','varchar');
        $this->captura('fecha_inicio','text');
        $this->captura('fecha_fin','text');
        $this->captura('dias_efectivo','numeric');
        $this->captura('tipo_baja','varchar');
        $this->captura('observaciones','text');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
         // var_dump($this->respuesta);exit;
        //Devuelve la respuesta
        return $this->respuesta;
    }
}
?>