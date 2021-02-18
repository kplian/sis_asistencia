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
        $this->transaccion='ASIS_RETO_SEL';
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
    //aumentado para listar el usuario
    function listarSomUsuario(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='ssom.ft_no_conformidad_sel';
        $this->transaccion='SSOM_USU_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        //$this->setCount(false);

        //Definicion de la lista del resultado del query
        $this->captura('id_uo_funcionario','int4');
        $this->captura('id_funcionario','int4');
        $this->captura('desc_funcionario1','text');
        $this->captura('desc_funcionario2','text');
        $this->captura('id_uo','int4');
        $this->captura('nombre_cargo','varchar');
        $this->captura('fecha_asignacion','date');
        $this->captura('fecha_finalizacion','date');
        $this->captura('num_doc','int4');
        $this->captura('ci','varchar');
        $this->captura('codigo','varchar');
        $this->captura('email_empresa','varchar');
        $this->captura('estado_reg_fun','varchar');
        $this->captura('estado_reg_asi','varchar');
        $this->captura('id_cargo','int4');
        $this->captura('descripcion_cargo','varchar');
        $this->captura('cargo_codigo','varchar');
        $this->captura('nombre_unidad','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

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
    function ReporteMarcadoFuncionario(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='asis.f_reportes_sel';
        $this->transaccion='ASIS_RPT_MAR';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setCount(false);

        $this->setParametro('fecha_ini', 'fecha_ini', 'date');
        $this->setParametro('fecha_fin', 'fecha_fin', 'date');
        $this->setParametro('id_funcionario', 'id_funcionario', 'int4');

        //Definicion de la lista del resultado del query
        // $this->captura('idsolicitudplan','int4');
        $this->captura('id_transaccion_bio','int4');
        $this->captura('fecha_marcado','date');
        $this->captura('hora','time');
        $this->captura('id_funcionario','int4');
        $this->captura('nombre_funcionario','text');
        $this->captura('mes','int4');
        $this->captura('obs','text');
        $this->captura('evento','varchar');


        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //var_dump($this->respuesta);exit;
        //Devuelve la respuesta
        return $this->respuesta;
    }

    function ReporteMarcadoFuncGralPDF(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='asis.f_reportes_sel';
        $this->transaccion='ASIS_RPT_MAR_GRAL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setCount(false);

        $this->setParametro('fecha_ini', 'fecha_ini', 'date');
        $this->setParametro('fecha_fin', 'fecha_fin', 'date');
        $this->setParametro('id_funcionario', 'id_funcionario', 'int4');

        //Definicion de la lista del resultado del query
        // $this->captura('idsolicitudplan','int4');
        $this->captura('detalles','text');
        $this->captura('hra1','time');
        $this->captura('hra2','time');
        $this->captura('hra3','time');
        $this->captura('hra4','time');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //var_dump($this->respuesta);exit;
        //Devuelve la respuesta
        return $this->respuesta;
    }
    function listarReporteHistoricoVacaciones(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='asis.f_reportes_sel';
        $this->transaccion='ASIS_AHT_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setCount(false);

        $this->setParametro('id_funcionario', 'id_funcionario', 'int4');

        //Definicion de la lista del resultado del query

        $this->captura('id_funcionario','int4');
        $this->captura('desc_funcionario1','text');
        $this->captura('descripcion_cargo','varchar');
        $this->captura('codigo','varchar');
        $this->captura('tipo','varchar');
        $this->captura('fecha','text');
        $this->captura('desde','text');
        $this->captura('hasta','text');
        $this->captura('dia','numeric');
        $this->captura('saldo','numeric');
        $this->captura('nombre_unidad','varchar');
        $this->captura('fecha_contrato','text');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
         // var_dump($this->respuesta);exit;
        //Devuelve la respuesta
        return $this->respuesta;
    }
    function listarVacacionesPersonal(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='asis.f_reportes_sel';
        $this->transaccion='ASIS_VPR_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setCount(false);
        $this->setParametro('tipo', 'tipo', 'varchar');
        $this->setParametro('fecha_ini', 'fecha_ini', 'date');
        $this->setParametro('fecha_fin', 'fecha_fin', 'date');
        $this->setParametro('id_funcionario', 'id_funcionario', 'int4');
        $this->setParametro('id_uo', 'id_uo', 'int4');
        $this->setParametro('formato', 'formato', 'varchar');

        //Definicion de la lista del resultado del query
        $this->captura('gerencia','varchar');
        $this->captura('departamento','varchar');
        $this->captura('desc_funcionario1','text');
        $this->captura('codigo','varchar');
        $this->captura('dia','numeric');
        $this->captura('desde','text');
        $this->captura('hasta','text');
        $this->captura('tipo_contrato','varchar');
        $this->captura('ordenar','varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        // var_dump($this->respuesta);exit;
        //Devuelve la respuesta
        return $this->respuesta;
    }
    function listarVacacionesResumen(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='asis.f_reportes_sel';
        $this->transaccion='ASIS_VARU_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion


        $this->setCount(false);

        $this->setParametro('formato', 'formato', 'varchar');
        $this->setParametro('reporte', 'reporte', 'varchar');
        $this->setParametro('id_funcionario', 'id_funcionario', 'int4');
        $this->setParametro('id_uo', 'id_uo', 'int4');
        $this->setParametro('fecha_fin', 'fecha_fin', 'date');
        $this->setParametro('id_tipo_contrato', 'id_tipo_contrato', 'int4');
        //Definicion de la lista del resultado del query
        $this->captura('desc_funcionario1','text');
        $this->captura('codigo','varchar');
        $this->captura('gerencia','varchar');
        $this->captura('departamento','varchar');

        $this->captura('saldo_acumulado','numeric');
        $this->captura('saldo_tomada','numeric');
        $this->captura('saldo_caducado','numeric');
        $this->captura('saldo_anticipo','numeric');
        $this->captura('saldo_pagado','numeric');
        $this->captura('saldo','numeric');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
         // var_dump($this->respuesta);exit;
        //Devuelve la respuesta
        return $this->respuesta;
    }

    function listarVacacionesSaldo(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='asis.f_reportes_sel';
        $this->transaccion='ASIS_SAL_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        $this->setCount(false);

        $this->setParametro('formato', 'formato', 'varchar');
        $this->setParametro('reporte', 'reporte', 'varchar');
        $this->setParametro('id_funcionario', 'id_funcionario', 'int4');
        $this->setParametro('id_uo', 'id_uo', 'int4');
        $this->setParametro('fecha_fin', 'fecha_fin', 'date');
        $this->setParametro('id_tipo_contrato', 'id_tipo_contrato', 'int4');
        //Definicion de la lista del resultado del query
        $this->captura('codigo','varchar');
        $this->captura('desc_funcionario1','varchar');
        $this->captura('fecha_contrato','text');
        $this->captura('gerencia','varchar');
        $this->captura('departamento','varchar');
        $this->captura('gestion','int4');
        $this->captura('fecha_caducado','text');

        $this->captura('saldo','numeric');
        $this->captura('ordenar','varchar');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
         // var_dump($this->respuesta);exit;
        //Devuelve la respuesta
        return $this->respuesta;
    }
    function listarVacacionesVencimiento(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='asis.f_reportes_sel';
        $this->transaccion='ASIS_VENS_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion

        $this->setCount(false);

        $this->setParametro('formato', 'formato', 'varchar');
        $this->setParametro('reporte', 'reporte', 'varchar');
        $this->setParametro('id_funcionario', 'id_funcionario', 'int4');
        $this->setParametro('id_uo', 'id_uo', 'int4');
        $this->setParametro('fecha_ini', 'fecha_ini', 'date');

        //Definicion de la lista del resultado del query
        $this->captura('codigo','varchar');
        $this->captura('desc_funcionario1','varchar');
        $this->captura('fecha_contrato','text');
        $this->captura('gerencia','varchar');
        $this->captura('departamento','varchar');
        $this->captura('gestion','int4');
        $this->captura('fecha_caducado','text');

        $this->captura('saldo','numeric');
        $this->captura('ordenar','varchar');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        // var_dump($this->respuesta);exit;
        //Devuelve la respuesta
        return $this->respuesta;
    }
    function listarVacacionesAnticipados(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='asis.f_reportes_sel';
        $this->transaccion='ASIS_ANT_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setCount(false);
        $this->setParametro('formato', 'formato', 'varchar');
        $this->setParametro('reporte', 'reporte', 'varchar');
        $this->setParametro('id_funcionario', 'id_funcionario', 'int4');
        $this->setParametro('id_uo', 'id_uo', 'int4');
        $this->setParametro('fecha_fin', 'fecha_fin', 'date');
        $this->setParametro('id_tipo_contrato', 'id_tipo_contrato', 'int4');

        //Definicion de la lista del resultado del query
        $this->captura('desc_funcionario2','text');
        $this->captura('codigo','varchar');
        $this->captura('gerencia','varchar');
        $this->captura('departamento','varchar');
        $this->captura('anticipo','numeric');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
         // var_dump($this->respuesta);exit;
        //Devuelve la respuesta
        return $this->respuesta;
    }

    function listarAsistencia(){
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento='asis.f_reportes_sel';
        $this->transaccion='ASIS_COAS_SEL';
        $this->tipo_procedimiento='SEL';//tipo de transaccion
        $this->setCount(false);
        $this->setParametro('fecha', 'fecha', 'date');
        $this->setParametro('formato', 'formato', 'varchar');
        $this->setParametro('id_uo', 'id_uo', 'int4');

        //Definicion de la lista del resultado del query
        $this->captura('codigo','varchar');
        $this->captura('fecha','date');
        $this->captura('gerencia','varchar');
        $this->captura('departamento','varchar');
        $this->captura('codigo_funcionario','varchar');
        $this->captura('id_funcionario','integer');
        $this->captura('funcionario','varchar');
        $this->captura('cargo','varchar');
        $this->captura('observacion','varchar');
        $this->captura('evento','varchar');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
       //  var_dump($this->respuesta);exit;
        //Devuelve la respuesta
        return $this->respuesta;
    }
}
?>
