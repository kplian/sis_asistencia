<?php
/**
 *@package pXP
 *@file gen-MODPermiso.php
 *@author  (miguel.mamani)
 *@date 16-10-2019 13:14:05
 *@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
#0				16-10-2019 13:14:05								CREACION

 */

class MODPermiso extends MODbase{

    function __construct(CTParametro $pParam){
        parent::__construct($pParam);
    }

    function listarPermiso(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='asis.ft_permiso_sel';
        $this->transaccion='ASIS_PMO_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setParametro('tipo_interfaz','tipo_interfaz','varchar');
        //Definicion de la lista del resultado del query
        $this->captura('id_permiso','int4');
        $this->captura('nro_tramite','varchar');
        $this->captura('id_funcionario','int4');
        $this->captura('id_estado_wf','int4');
        $this->captura('fecha_solicitud','date');
        $this->captura('id_tipo_permiso','int4');
        $this->captura('motivo','text');
        $this->captura('estado_reg','varchar');
        $this->captura('estado','varchar');
        $this->captura('id_proceso_wf','int4');
        $this->captura('id_usuario_ai','int4');
        $this->captura('id_usuario_reg','int4');
        $this->captura('usuario_ai','varchar');
        $this->captura('fecha_reg','timestamp');
        $this->captura('fecha_mod','timestamp');
        $this->captura('id_usuario_mod','int4');
        $this->captura('usr_reg','varchar');
        $this->captura('usr_mod','varchar');

        $this->captura('desc_tipo_permiso','text');
        $this->captura('desc_funcionario','text');
        $this->captura('hro_desde','time');
        $this->captura('hro_hasta','time');
        $this->captura('asignar_rango','varchar');
        $this->captura('documento','varchar');

        $this->captura('reposicion','varchar');
        $this->captura('fecha_reposicion','date');
        $this->captura('hro_desde_reposicion','time');
        $this->captura('hro_hasta_reposicion','time');


        $this->captura('hro_total_permiso','time');
        $this->captura('hro_total_reposicion','time');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function insertarPermiso(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='asis.ft_permiso_ime';
        $this->transaccion='ASIS_PMO_INS';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('nro_tramite','nro_tramite','varchar');
        $this->setParametro('id_funcionario','id_funcionario','int4');
        $this->setParametro('id_estado_wf','id_estado_wf','int4');
        $this->setParametro('fecha_solicitud','fecha_solicitud','date');
        $this->setParametro('id_tipo_permiso','id_tipo_permiso','int4');
        $this->setParametro('motivo','motivo','text');
        $this->setParametro('estado_reg','estado_reg','varchar');
        $this->setParametro('estado','estado','varchar');
        $this->setParametro('id_proceso_wf','id_proceso_wf','int4');

        $this->setParametro('hro_desde','hro_desde','time');
        $this->setParametro('hro_hasta','hro_hasta','time');
        $this->setParametro('diferencia_tiempo','diferencia_tiempo','varchar');

        $this->setParametro('reposicion','reposicion','varchar');
        $this->setParametro('fecha_reposicion','fecha_reposicion','date');
        $this->setParametro('hro_desde_reposicion','hro_desde_reposicion','time');
        $this->setParametro('hro_hasta_reposicion','hro_hasta_reposicion','time');

        $this->setParametro('hro_total_permiso','hro_total_permiso','time');
        $this->setParametro('hro_total_reposicion','hro_total_reposicion','time');


        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function modificarPermiso(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='asis.ft_permiso_ime';
        $this->transaccion='ASIS_PMO_MOD';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_permiso','id_permiso','int4');
        $this->setParametro('nro_tramite','nro_tramite','varchar');
        $this->setParametro('id_funcionario','id_funcionario','int4');
        $this->setParametro('id_estado_wf','id_estado_wf','int4');
        $this->setParametro('fecha_solicitud','fecha_solicitud','date');
        $this->setParametro('id_tipo_permiso','id_tipo_permiso','int4');
        $this->setParametro('motivo','motivo','text');
        $this->setParametro('estado_reg','estado_reg','varchar');
        $this->setParametro('estado','estado','varchar');
        $this->setParametro('id_proceso_wf','id_proceso_wf','int4');

        $this->setParametro('hro_desde','hro_desde','time');
        $this->setParametro('hro_hasta','hro_hasta','time');

        $this->setParametro('hro_total_permiso','hro_total_permiso','varchar');
        $this->setParametro('hro_total_reposicion','hro_total_reposicion','varchar');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function eliminarPermiso(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='asis.ft_permiso_ime';
        $this->transaccion='ASIS_PMO_ELI';
        $this->tipo_procedimiento='IME';

        //Define los parametros para la funcion
        $this->setParametro('id_permiso','id_permiso','int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    function siguienteEstado(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento = 'asis.ft_permiso_ime';
        $this->transaccion = 'ASIS_SIGPMO_IME';
        $this->tipo_procedimiento = 'IME';
        //Define los parametros para la funcion
        $this->setParametro('id_proceso_wf_act', 'id_proceso_wf_act', 'int4');
        $this->setParametro('id_estado_wf_act', 'id_estado_wf_act', 'int4');
        $this->setParametro('id_funcionario_usu', 'id_funcionario_usu', 'int4');
        $this->setParametro('id_tipo_estado', 'id_tipo_estado', 'int4');
        $this->setParametro('id_funcionario_wf', 'id_funcionario_wf', 'int4');
        $this->setParametro('id_depto_wf', 'id_depto_wf', 'int4');
        $this->setParametro('obs', 'obs', 'text');
        $this->setParametro('json_procesos', 'json_procesos', 'text');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //Devuelve la respuesta
        return $this->respuesta;
    }
    function anteriorEstado(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento = 'asis.ft_permiso_ime';
        $this->transaccion = 'ASIS_ANTPMO_IME';
        $this->tipo_procedimiento = 'IME';
        //Define los parametros para la funcion
        $this->setParametro('id_proceso_wf', 'id_proceso_wf', 'int4');
        $this->setParametro('id_estado_wf', 'id_estado_wf', 'int4');
        $this->setParametro('obs', 'obs', 'text');
        $this->setParametro('estado_destino', 'estado_destino', 'varchar');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //Devuelve la respuesta
        return $this->respuesta;
    }
    function optenerRango(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento = 'asis.ft_permiso_ime';
        $this->transaccion = 'ASIS_RAF_IME';
        $this->tipo_procedimiento = 'IME';
        //Define los parametros para la funcion
        $this->setParametro('id_funcionario', 'id_funcionario', 'int4');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //Devuelve la respuesta
        return $this->respuesta;
    }


}
?>
