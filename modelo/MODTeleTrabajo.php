<?php
/****************************************************************************************
*@package pXP
*@file gen-MODTeleTrabajo.php
*@author  (admin.miguel)
*@date 01-02-2021 14:53:44
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas

 HISTORIAL DE MODIFICACIONES:
 #ISSUE                FECHA                AUTOR                DESCRIPCION
  #0                01-02-2021 14:53:44    admin.miguel             Creacion    
  #
*****************************************************************************************/

class MODTeleTrabajo extends MODbase{
    
    function __construct(CTParametro $pParam){
        parent::__construct($pParam);
    }
            
    function listarTeleTrabajo(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='asis.ft_tele_trabajo_sel';
        $this->transaccion='ASIS_TLT_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setParametro('tipo_interfaz','tipo_interfaz','varchar');
        //Definicion de la lista del resultado del query
		$this->captura('id_tele_trabajo','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('id_funcionario','int4');
		$this->captura('id_responsable','int4');
		$this->captura('fecha_inicio','date');
		$this->captura('fecha_fin','date');
		$this->captura('justificacion','text');
		$this->captura('id_usuario_reg','int4');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_ai','int4');
		$this->captura('usuario_ai','varchar');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
        $this->captura('usr_mod','varchar');

        $this->captura('estado','varchar');
        $this->captura('nro_tramite','varchar');
        $this->captura('id_proceso_wf','int4');
        $this->captura('id_estado_wf','int4');
        $this->captura('funcionario','text');
        $this->captura('responsable','text');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        
        //Devuelve la respuesta
        return $this->respuesta;
    }
            
    function insertarTeleTrabajo(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='asis.ft_tele_trabajo_ime';
        $this->transaccion='ASIS_TLT_INS';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_funcionario','id_funcionario','int4');
		$this->setParametro('id_responsable','id_responsable','int4');
		$this->setParametro('fecha_inicio','fecha_inicio','date');
		$this->setParametro('fecha_fin','fecha_fin','date');
		$this->setParametro('justificacion','justificacion','text');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
            
    function modificarTeleTrabajo(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='asis.ft_tele_trabajo_ime';
        $this->transaccion='ASIS_TLT_MOD';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
		$this->setParametro('id_tele_trabajo','id_tele_trabajo','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_funcionario','id_funcionario','int4');
		$this->setParametro('id_responsable','id_responsable','int4');
		$this->setParametro('fecha_inicio','fecha_inicio','date');
		$this->setParametro('fecha_fin','fecha_fin','date');
		$this->setParametro('justificacion','justificacion','text');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
            
    function eliminarTeleTrabajo(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='asis.ft_tele_trabajo_ime';
        $this->transaccion='ASIS_TLT_ELI';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
		$this->setParametro('id_tele_trabajo','id_tele_trabajo','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    function aprobarEstado(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='asis.ft_tele_trabajo_ime';
        $this->transaccion='ASIS_TLT_SIG';
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
}
?>