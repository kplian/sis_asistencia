<?php
/****************************************************************************************
*@package pXP
*@file gen-MODProgramacion.php
*@author  (admin.miguel)
*@date 14-12-2020 20:28:34
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas

 HISTORIAL DE MODIFICACIONES:
 #ISSUE                FECHA                AUTOR                DESCRIPCION
  #0                14-12-2020 20:28:34    admin.miguel             Creacion    
  #
*****************************************************************************************/

class MODProgramacion extends MODbase{
    
    function __construct(CTParametro $pParam){
        parent::__construct($pParam);
    }
            
    function listarProgramacion(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='asis.ft_programacion_sel';
        $this->transaccion='ASIS_PRN_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setCount(false);

        //Definicion de la lista del resultado del query
        $this->setParametro('id_periodo', 'id_periodo', 'int4');
		$this->captura('id_programacion','int4');
        $this->captura('id_periodo','int4');
        $this->captura('fecha_programada','date');
        $this->captura('id_funcionario','int4');
        $this->captura('id_usuario_reg','int4');
        $this->captura('tiempo','varchar');
        $this->captura('valor','numeric');
        $this->captura('estado_reg','varchar');
		$this->captura('estado','varchar');
		$this->captura('desc_funcionario1','text');
		$this->captura('id_vacacion_det','int4');
		$this->captura('fecha_reg','timestamp');
        $this->captura('usr_reg','varchar');

        
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        
        //Devuelve la respuesta
        return $this->respuesta;
    }
            
    function insertarProgramacion(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='asis.ft_programacion_ime';
        $this->transaccion='ASIS_PRN_INS';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_periodo','id_periodo','int4');
		$this->setParametro('fecha_programada','fecha_programada','date');
		$this->setParametro('id_funcionario','id_funcionario','int4');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('tiempo','tiempo','varchar');
		$this->setParametro('valor','valor','numeric');
		$this->setParametro('id_vacacion_det','id_vacacion_det','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
            
    function modificarProgramacion(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='asis.ft_programacion_ime';
        $this->transaccion='ASIS_PRN_MOD';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
		$this->setParametro('id_programacion','id_programacion','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_periodo','id_periodo','int4');
		$this->setParametro('fecha_programada','fecha_programada','date');
		$this->setParametro('id_funcionario','id_funcionario','int4');
		$this->setParametro('estado','estado','varchar');
		$this->setParametro('tiempo','tiempo','varchar');
		$this->setParametro('valor','valor','numeric');
		$this->setParametro('id_vacacion_det','id_vacacion_det','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
            
    function eliminarProgramacion(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='asis.ft_programacion_ime';
        $this->transaccion='ASIS_PRN_ELI';
        $this->tipo_procedimiento='IME';
                
        //Define los parametros para la funcion
		$this->setParametro('id_programacion','id_programacion','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
            
}
?>