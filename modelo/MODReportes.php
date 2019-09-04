<?php
/**
 *@package pXP
 *@file MODReportes
 *@author  MMV
 *@date 19-08-2019 15:28:39
 *@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 * HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
#15		etr			02-09-2019			MVM               	Reporte Transacción marcados
#16		etr			04-09-2019			MMV               	Medicaciones reporte marcados listarReporteFuncionario

 */

class MODReportes extends MODbase{

    function __construct(CTParametro $pParam){
        parent::__construct($pParam);
    }

    function listarReporteRetrasos(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='asis.f_reportes_sel';
        $this->transaccion='ASIS_RET_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setCount(false);


        $this->setParametro('fecha_ini', 'fecha_ini', 'date');
        $this->setParametro('fecha_fin', 'fecha_fin', 'date');
        $this->setParametro('hora_ini', 'hora_ini', 'time');
        $this->setParametro('hora_fin', 'hora_fin', 'time');
        $this->setParametro('modo_verif', 'modo_verif', 'varchar');
        $this->setParametro('evento', 'evento', 'varchar');
        $this->setParametro('id_funcionario', 'id_funcionario', 'int4');


        //Definicion de la lista del resultado del query
        // $this->captura('idsolicitudplan','int4');
        $this->captura('dia','varchar');
        $this->captura('fecha_marcado','text');
        $this->captura('hora','varchar');
        $this->captura('id_funcionario','int4');
        $this->captura('codigo_funcionario','varchar');
        $this->captura('nombre_funcionario','text');
        $this->captura('departamento','text');
        $this->captura('tipo_evento','varchar');
        $this->captura('modo_verificacion','varchar');
        $this->captura('nombre_dispositivo','varchar');
        $this->captura('numero_tarjeta','varchar');
        $this->captura('nombre_area','varchar');
        $this->captura('gerencia','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //var_dump($this->respuesta);exit;
        //Devuelve la respuesta
        return $this->respuesta;
    }
    function listarReporteFuncionario(){ //#16
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='asis.f_reportes_sel';
        $this->transaccion='ASIS_REF_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setCount(false);


        $this->setParametro('fecha_ini', 'fecha_ini', 'date');
        $this->setParametro('fecha_fin', 'fecha_fin', 'date');
        $this->setParametro('hora_ini', 'hora_ini', 'time');
        $this->setParametro('hora_fin', 'hora_fin', 'time');
        $this->setParametro('modo_verif', 'modo_verif', 'varchar');
        $this->setParametro('evento', 'evento', 'varchar');
        $this->setParametro('id_funcionario', 'id_funcionario', 'int4');
        $this->setParametro('agrupar_por', 'agrupar_por', 'varchar');


        //Definicion de la lista del resultado del query
        // $this->captura('idsolicitudplan','int4');
        $this->captura('dia','varchar');
        $this->captura('fecha_marcado','text');
        $this->captura('hora','varchar');
        $this->captura('id_funcionario','int4');
        $this->captura('codigo_funcionario','varchar');
        $this->captura('nombre_funcionario','text');
        $this->captura('tipo_evento','varchar');
        $this->captura('modo_verificacion','varchar');
        $this->captura('nombre_dispositivo','varchar');
        $this->captura('gerencia','varchar');
        $this->captura('departamento','varchar');
        $this->captura('nombre_cargo','text');
        
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        // var_dump($this->respuesta);exit;
        //Devuelve la respuesta
        return $this->respuesta;
    }



}
?>