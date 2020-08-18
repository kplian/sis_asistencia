<?php
/**
 *@package pXP
 *@file gen-MODGrupoAsig.php
 *@author  (miguel.mamani)
 *@date 20-11-2019 20:00:15
 *@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
#0				20-11-2019 20:00:15								CREACION

 */

class MODGrupoAsig extends MODbase{

    function __construct(CTParametro $pParam){
        parent::__construct($pParam);
    }

    function listarGrupoAsig(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='asis.ft_grupo_asig_sel';
        $this->transaccion='ASIS_GRU_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        //Definicion de la lista del resultado del query
        $this->captura('id_grupo_asig','int4');
        $this->captura('codigo','varchar');
        $this->captura('estado_reg','varchar');
        $this->captura('descripcion','varchar');
        $this->captura('usuario_ai','varchar');
        $this->captura('fecha_reg','timestamp');
        $this->captura('id_usuario_reg','int4');
        $this->captura('id_usuario_ai','int4');
        $this->captura('fecha_mod','timestamp');
        $this->captura('id_usuario_mod','int4');
        $this->captura('usr_reg','varchar');
        $this->captura('usr_mod','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function insertarGrupoAsig(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='asis.ft_grupo_asig_ime';
        $this->transaccion='ASIS_GRU_INS';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
       // $this->setParametro('codigo','codigo','varchar');
        $this->setParametro('estado_reg','estado_reg','varchar');
        $this->setParametro('descripcion','descripcion','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function modificarGrupoAsig(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='asis.ft_grupo_asig_ime';
        $this->transaccion='ASIS_GRU_MOD';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_grupo_asig','id_grupo_asig','int4');
        // $this->setParametro('codigo','codigo','varchar');
        $this->setParametro('estado_reg','estado_reg','varchar');
        $this->setParametro('descripcion','descripcion','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function eliminarGrupoAsig(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='asis.ft_grupo_asig_ime';
        $this->transaccion='ASIS_GRU_ELI';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_grupo_asig','id_grupo_asig','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

}
?>