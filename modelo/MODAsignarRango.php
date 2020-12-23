<?php
/**
 *@package pXP
 *@file gen-MODAsignarRango.php
 *@author  (miguel.mamani)
 *@date 05-09-2019 21:07:38
 *@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 */

class MODAsignarRango extends MODbase{

    function __construct(CTParametro $pParam){
        parent::__construct($pParam);
    }

    function listarAsignarRango(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='asis.ft_asignar_rango_sel';
        $this->transaccion='ASIS_ARO_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        //Definicion de la lista del resultado del query
        $this->captura('asignar_rango','int4');
        $this->captura('id_rango_horario','int4');
        $this->captura('estado_reg','varchar');
        $this->captura('hasta','date');
        $this->captura('id_uo','int4');
        $this->captura('id_funcionario','int4');
        $this->captura('desde','date');
        $this->captura('id_usuario_reg','int4');
        $this->captura('fecha_reg','timestamp');
        $this->captura('usuario_ai','varchar');
        $this->captura('id_usuario_ai','int4');
        $this->captura('fecha_mod','timestamp');
        $this->captura('id_usuario_mod','int4');
        $this->captura('usr_reg','varchar');
        $this->captura('usr_mod','varchar');
        $this->captura('desc_funcionario','text');
        $this->captura('desc_uo','text');
        $this->captura('desc_grupos','text');
        $this->captura('id_grupo_asig','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function insertarAsignarRango(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='asis.ft_asignar_rango_ime';
        $this->transaccion='ASIS_ARO_INS';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_rango_horario','id_rango_horario','int4');
        $this->setParametro('estado_reg','estado_reg','varchar');
        $this->setParametro('hasta','hasta','date');
        $this->setParametro('id_uo','id_uo','int4');
        $this->setParametro('id_funcionario','id_funcionario','int4');
        $this->setParametro('desde','desde','date');
        $this->setParametro('id_grupo_asig','id_grupo_asig','int4');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function modificarAsignarRango(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='asis.ft_asignar_rango_ime';
        $this->transaccion='ASIS_ARO_MOD';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('asignar_rango','asignar_rango','int4');
        $this->setParametro('id_rango_horario','id_rango_horario','int4');
        $this->setParametro('estado_reg','estado_reg','varchar');
        $this->setParametro('hasta','hasta','date');
        $this->setParametro('id_uo','id_uo','int4');
        $this->setParametro('id_funcionario','id_funcionario','int4');
        $this->setParametro('desde','desde','date');
        $this->setParametro('id_grupo_asig','id_grupo_asig','int4');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function eliminarAsignarRango(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='asis.ft_asignar_rango_ime';
        $this->transaccion='ASIS_ARO_ELI';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('asignar_rango','asignar_rango','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    function listarUo(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='asis.ft_asignar_rango_sel';
        $this->transaccion='ASIS_UO_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setParametro('id_rango_horario','id_rango_horario','int4');

        //Definicion de la lista del resultado del query
        $this->captura('id_uo','int4');
        $this->captura('codigo','varchar');
        $this->captura('descripcion','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

}
?>