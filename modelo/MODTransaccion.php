<?php
/**
 *@package pXP
 *@file MODTransaccion.php
 *@author  (miguel.mamani)
 *@date 06-09-2019 13:08:03
 *@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 */

class MODTransaccion extends MODbase{

    function __construct(CTParametro $pParam){
        parent::__construct($pParam);
    }

    function listarTransaccion(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='asis.ft_transaccion_sel';
        $this->transaccion='ASIS_BIO_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        $this->setParametro('id_funcionario','id_funcionario','int4');
        $this->setParametro('id_periodo','id_periodo','int4');
        //Definicion de la lista del resultado del query
        $this->captura('id','int4');
        $this->captura('id_funcionario','int4');
        $this->captura('codigo_funcionario','varchar');
        $this->captura('nombre_area','varchar');
        $this->captura('verificacion','varchar');
        $this->captura('evento','varchar');
        $this->captura('pivot','int4');
        $this->captura('rango','text');
        $this->captura('desc_funcionario1','text');
        $this->captura('periodo','int4');
        $this->captura('fecha_registro','text');
        $this->captura('hora','varchar');
        $this->captura('dia','int4');
        $this->captura('accion','varchar');
        $this->captura('dispocitvo','varchar');
        $this->captura('obs','text');
        $this->captura('descripcion','varchar');
        $this->captura('id_rango_horario','int4');
        $this->captura('reader_name','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //Devuelve la respuesta
        // var_dump($this->respuesta);exit;
        return $this->respuesta;
    }

    function insertarTransaccion(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='asis.ft_transaccion_bio_ime';
        $this->transaccion='ASIS_BIO_INS';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('obs','obs','text');
        $this->setParametro('estado_reg','estado_reg','varchar');
        $this->setParametro('evento','evento','varchar');
        $this->setParametro('id_periodo','id_periodo','int4');
        $this->setParametro('hora','hora','time');
        $this->setParametro('id_funcionario','id_funcionario','int4');
        $this->setParametro('area','area','varchar');
        $this->setParametro('tipo_verificacion','tipo_verificacion','varchar');
        $this->setParametro('fecha_marcado','fecha_marcado','timestamp');
        $this->setParametro('id_rango_horario','id_rango_horario','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function modificarTransaccion(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='asis.ft_transaccion_bio_ime';
        $this->transaccion='ASIS_BIO_MOD';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_transaccion_bio','id_transaccion_bio','int4');
        $this->setParametro('obs','obs','text');
        $this->setParametro('estado_reg','estado_reg','varchar');
        $this->setParametro('evento','evento','varchar');
        $this->setParametro('id_periodo','id_periodo','int4');
        $this->setParametro('hora','hora','time');
        $this->setParametro('id_funcionario','id_funcionario','int4');
        $this->setParametro('area','area','varchar');
        $this->setParametro('tipo_verificacion','tipo_verificacion','varchar');
        $this->setParametro('fecha_marcado','fecha_marcado','timestamp');
        $this->setParametro('id_rango_horario','id_rango_horario','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function eliminarTransaccion(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='asis.ft_transaccion_bio_ime';
        $this->transaccion='ASIS_BIO_ELI';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_transaccion_bio','id_transaccion_bio','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    function migrarMarcadoFuncionario(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='asis.ft_transaccion_bio_ime';
        $this->transaccion='ASIS_BIO_TRA';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_periodo','id_periodo','int4');
        $this->setParametro('id_funcionario','id_funcionario','int4');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function ReporteTusMarcados(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='asis.ft_transaccion_sel';
        $this->transaccion='ASIS_BIORPT_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setCount(false);

        //$this->setParametro('id_gestion', 'fecha_ini', 'date');
        $this->setParametro('id_periodo', 'id_periodo', 'int4');
        $this->setParametro('id_funcionario', 'id_funcionario', 'int4');

        //Definicion de la lista del resultado del query
        //***************************************************************
        $this->captura('id_transaccion_bio','int4');
        $this->captura('obs','text');
        $this->captura('estado_reg','varchar');
        $this->captura('id_periodo','int4');
        $this->captura('hora','varchar');
        $this->captura('id_funcionario','int4');
        $this->captura('fecha_marcado','date');
        $this->captura('id_rango_horario','int4');
        $this->captura('id_usuario_reg','int4');
        $this->captura('usuario_ai','varchar');
        $this->captura('fecha_reg','timestamp');
        $this->captura('id_usuario_ai','int4');
        $this->captura('id_usuario_mod','int4');
        $this->captura('fecha_mod','timestamp');
        $this->captura('usr_reg','varchar');
        $this->captura('usr_mod','varchar');
        $this->captura('evento','varchar');
        $this->captura('tipo_verificacion','varchar');
        $this->captura('area','varchar');
        $this->captura('rango','varchar');
        $this->captura('dia','text');
        $this->captura('acceso','varchar');
        $this->captura('nombre','text');

        //***************************************************************

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //var_dump($this->respuesta);exit;
        //Devuelve la respuesta
        return $this->respuesta;
    }
    function listarReporteTranasaccion(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='asis.ft_transaccion_sel';
        $this->transaccion='ASIS_RFA_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        //Definicion de la lista del resultado del query
        $this->captura('id_transaccion_bio','int4');
        $this->captura('id_funcionario','int4');
        $this->captura('id_periodo','int4');
        $this->captura('id_rango_horario','int4');
        $this->captura('dia','text');
        $this->captura('fecha_marcado','date');
        $this->captura('hora','time');
        $this->captura('obs','text');
        $this->captura('evento','varchar');
        $this->captura('tipo_verificacion','varchar');
        $this->captura('area','varchar');
        $this->captura('rango','varchar');
        $this->captura('acceso','varchar');
        $this->captura('desc_funcionario','text');
        $this->captura('departamento','varchar');
        $this->captura('estado_reg','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    function reporteMarcados(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='asis.ft_transaccion_sel';
        $this->transaccion='ASIS_REM_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setCount(false);
        $this->setParametro('id_funcionario','id_funcionario','int4');
        $this->setParametro('id_periodo','id_periodo','int4');

        //Definicion de la lista del resultado del query
        $this->captura('funcionario','text');
        $this->captura('fecha','date');
        $this->captura('inicio_one','time');
        $this->captura('fin_one','time');
        $this->captura('result_one','numeric');
        $this->captura('inicio_two','time');
        $this->captura('fin_two','time');
        $this->captura('result_two','numeric');
        $this->captura('total','numeric');
        $this->captura('fecha_ini','date');
        $this->captura('fecha_fin','date');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //Devuelve la respuesta
        // var_dump($this->respuesta);exit;
        return $this->respuesta;
    }

}
?>