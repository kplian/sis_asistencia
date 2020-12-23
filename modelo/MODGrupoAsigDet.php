<?php
/**
 *@package pXP
 *@file gen-MODGrupoAsigDet.php
 *@author  (miguel.mamani)
 *@date 20-11-2019 20:55:17
 *@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
#0				20-11-2019 20:55:17								CREACION

 */

class MODGrupoAsigDet extends MODbase{

    function __construct(CTParametro $pParam){
        parent::__construct($pParam);
    }

    function listarGrupoAsigDet(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='asis.ft_grupo_asig_det_sel';
        $this->transaccion='ASIS_GRD_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        //Definicion de la lista del resultado del query
        $this->captura('id_id_grupo_asig_det','int4');
        $this->captura('estado_reg','varchar');
        $this->captura('id_funcionario','int4');
        $this->captura('id_grupo_asig','int4');
        $this->captura('id_usuario_reg','int4');
        $this->captura('usuario_ai','varchar');
        $this->captura('fecha_reg','timestamp');
        $this->captura('id_usuario_ai','int4');
        $this->captura('id_usuario_mod','int4');
        $this->captura('fecha_mod','timestamp');
        $this->captura('usr_reg','varchar');
        $this->captura('usr_mod','varchar');
        $this->captura('nombre_completo','text');
        $this->captura('codigo','varchar');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function insertarGrupoAsigDet(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='asis.ft_grupo_asig_det_ime';
        $this->transaccion='ASIS_GRD_INS';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('estado_reg','estado_reg','varchar');
        $this->setParametro('id_funcionario','id_funcionario','int4');
        $this->setParametro('id_grupo_asig','id_grupo_asig','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function modificarGrupoAsigDet(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='asis.ft_grupo_asig_det_ime';
        $this->transaccion='ASIS_GRD_MOD';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_id_grupo_asig_det','id_id_grupo_asig_det','int4');
        $this->setParametro('estado_reg','estado_reg','varchar');
        $this->setParametro('id_funcionario','id_funcionario','int4');
        $this->setParametro('id_grupo_asig','id_grupo_asig','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function eliminarGrupoAsigDet(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='asis.ft_grupo_asig_det_ime';
        $this->transaccion='ASIS_GRD_ELI';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_id_grupo_asig_det','id_id_grupo_asig_det','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

}
?>