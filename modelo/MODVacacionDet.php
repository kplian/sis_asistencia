<?php
/**
 *@package pXP
 *@file gen-MODVacacionDet.php
 *@author  (admin.miguel)
 *@date 30-12-2019 13:41:59
 *@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
#0				30-12-2019 13:41:59								CREACION

 */

class MODVacacionDet extends MODbase{

    function __construct(CTParametro $pParam){
        parent::__construct($pParam);
    }

    function listarVacacionDet(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='asis.ft_vacacion_det_sel';
        $this->transaccion='ASIS_VDE_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        //Definicion de la lista del resultado del query
        $this->captura('id_vacacion_det','int4');
        $this->captura('id_vacacion','int4');
        $this->captura('fecha_dia','date');
        $this->captura('tiempo','int4');
        $this->captura('estado_reg','varchar');
        $this->captura('id_usuario_ai','int4');
        $this->captura('usuario_ai','varchar');
        $this->captura('fecha_reg','timestamp');
        $this->captura('id_usuario_reg','int4');
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
    function cambiarTiempo(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='asis.ft_vacacion_det_ime';
        $this->transaccion='ASIS_VDE_INS';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_vacacion_det','id_vacacion_det','int4');
        $this->setParametro('field_name','field_name','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
}
?>