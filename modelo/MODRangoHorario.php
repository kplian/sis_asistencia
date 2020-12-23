<?php
/**
 *@package pXP
 *@file gen-MODRangoHorario.php
 *@author  (mgarcia)
 *@date 19-08-2019 15:28:39
 *@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 */

class MODRangoHorario extends MODbase{

    function __construct(CTParametro $pParam){
        parent::__construct($pParam);
    }

    function listarRangoHorario(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='asis.ft_rango_horario_sel';
        $this->transaccion='ASIS_RHO_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        //Definicion de la lista del resultado del query
        $this->captura('id_rango_horario','int4');
        $this->captura('estado_reg','varchar');
        $this->captura('codigo','varchar');
        $this->captura('descripcion','varchar');
        $this->captura('hora_entrada','time');
        $this->captura('hora_salida','time');
        $this->captura('rango_entrada_ini','time');
        $this->captura('rango_entrada_fin','time');
        $this->captura('rango_salida_ini','time');
        $this->captura('rango_salida_fin','time');
        $this->captura('fecha_desde','date');
        $this->captura('fecha_hasta','date');
        $this->captura('tolerancia_retardo','int4');
        $this->captura('jornada_laboral','int4');
        $this->captura('lunes','varchar');
        $this->captura('martes','varchar');
        $this->captura('miercoles','varchar');
        $this->captura('jueves','varchar');
        $this->captura('viernes','varchar');
        $this->captura('sabado','varchar');
        $this->captura('domingo','varchar');
        $this->captura('id_usuario_reg','int4');
        $this->captura('fecha_reg','timestamp');
        $this->captura('id_usuario_ai','int4');
        $this->captura('usuario_ai','varchar');
        $this->captura('id_usuario_mod','int4');
        $this->captura('fecha_mod','timestamp');
        $this->captura('usr_reg','varchar');
        $this->captura('usr_mod','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //Devuelve la respuesta
        return $this->respuesta;
    }

    function insertarRangoHorario(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='asis.ft_rango_horario_ime';
        $this->transaccion='ASIS_RHO_INS';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('estado_reg','estado_reg','varchar');
        $this->setParametro('codigo','codigo','varchar');
        $this->setParametro('descripcion','descripcion','varchar');
        $this->setParametro('hora_entrada','hora_entrada','time');
        $this->setParametro('hora_salida','hora_salida','time');
        $this->setParametro('rango_entrada_ini','rango_entrada_ini','time');
        $this->setParametro('rango_entrada_fin','rango_entrada_fin','time');
        $this->setParametro('rango_salida_ini','rango_salida_ini','time');
        $this->setParametro('rango_salida_fin','rango_salida_fin','time');
        $this->setParametro('fecha_desde','fecha_desde','date');
        $this->setParametro('fecha_hasta','fecha_hasta','date');
        $this->setParametro('tolerancia_retardo','tolerancia_retardo','int4');
        $this->setParametro('jornada_laboral','jornada_laboral','int4');
        $this->setParametro('lunes','lunes','varchar');
        $this->setParametro('martes','martes','varchar');
        $this->setParametro('miercoles','miercoles','varchar');
        $this->setParametro('jueves','jueves','varchar');
        $this->setParametro('viernes','viernes','varchar');
        $this->setParametro('sabado','sabado','varchar');
        $this->setParametro('domingo','domingo','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function modificarRangoHorario(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='asis.ft_rango_horario_ime';
        $this->transaccion='ASIS_RHO_MOD';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_rango_horario','id_rango_horario','int4');
        $this->setParametro('estado_reg','estado_reg','varchar');
        $this->setParametro('codigo','codigo','varchar');
        $this->setParametro('descripcion','descripcion','varchar');
        $this->setParametro('hora_entrada','hora_entrada','time');
        $this->setParametro('hora_salida','hora_salida','time');
        $this->setParametro('rango_entrada_ini','rango_entrada_ini','time');
        $this->setParametro('rango_entrada_fin','rango_entrada_fin','time');
        $this->setParametro('rango_salida_ini','rango_salida_ini','time');
        $this->setParametro('rango_salida_fin','rango_salida_fin','time');
        $this->setParametro('fecha_desde','fecha_desde','date');
        $this->setParametro('fecha_hasta','fecha_hasta','date');
        $this->setParametro('tolerancia_retardo','tolerancia_retardo','int4');
        $this->setParametro('jornada_laboral','jornada_laboral','int4');
        $this->setParametro('lunes','lunes','varchar');
        $this->setParametro('martes','martes','varchar');
        $this->setParametro('miercoles','miercoles','varchar');
        $this->setParametro('jueves','jueves','varchar');
        $this->setParametro('viernes','viernes','varchar');
        $this->setParametro('sabado','sabado','varchar');
        $this->setParametro('domingo','domingo','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function eliminarRangoHorario(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='asis.ft_rango_horario_ime';
        $this->transaccion='ASIS_RHO_ELI';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_rango_horario','id_rango_horario','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    function asignarDia(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='asis.ft_rango_horario_ime';
        $this->transaccion='ASIS_RCHE_MOD';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_rango_horario','id_rango_horario','int4');
        $this->setParametro('field_name','field_name','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

}
?>
