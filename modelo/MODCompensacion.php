<?php
/****************************************************************************************
 * @package pXP
 * @file MODCompensacion.php
 * @author  (amamani)
 * @date 18-05-2021 14:14:39
 * @description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 *
 * HISTORIAL DE MODIFICACIONES:
 * #ISSUE                FECHA                AUTOR                DESCRIPCION
 * #0                18-05-2021 14:14:39    amamani             Creacion
 * #
 *****************************************************************************************/

class MODCompensacion extends MODbase
{

    function __construct(CTParametro $pParam)
    {
        parent::__construct($pParam);
    }

    function listarCompensacion()
    {
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento = 'asis.ft_compensacion_sel';
        $this->transaccion = 'ASIS_CPM_SEL';
        $this->tipo_procedimiento = 'SEL';//tipo de transaccion
        $this->setParametro('tipo_interfaz','tipo_interfaz','varchar');

        //Definicion de la lista del resultado del query
        $this->captura('id_compensacion', 'int4');
        $this->captura('estado_reg', 'varchar');
        $this->captura('id_funcionario', 'int4');
        $this->captura('id_responsable', 'int4');
        $this->captura('desde', 'date');
        $this->captura('hasta', 'date');
        $this->captura('dias', 'numeric');
        $this->captura('desde_comp', 'date');
        $this->captura('hasta_comp', 'date');
        $this->captura('dias_comp', 'numeric');
        $this->captura('justificacion', 'varchar');
        $this->captura('id_usuario_reg', 'int4');
        $this->captura('fecha_reg', 'timestamp');
        $this->captura('id_usuario_ai', 'int4');
        $this->captura('usuario_ai', 'varchar');
        $this->captura('id_usuario_mod', 'int4');
        $this->captura('fecha_mod', 'timestamp');
        $this->captura('usr_reg', 'varchar');
        $this->captura('usr_mod', 'varchar');

        $this->captura('id_proceso_wf', 'int4');
        $this->captura('id_estado_wf', 'int4');
        $this->captura('estado', 'varchar');
        $this->captura('nro_tramite', 'varchar');

        $this->captura('funcionario', 'text');
        $this->captura('responsable', 'text');
        $this->captura('social_forestal', 'boolean');
        $this->captura('id_uo', 'int4');
        $this->captura('gerencia', 'varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function insertarCompensacion()
    {
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento = 'asis.ft_compensacion_ime';
        $this->transaccion = 'ASIS_CPM_INS';
        $this->tipo_procedimiento = 'IME';

        //Define los parametros para la funcion
        $this->setParametro('estado_reg', 'estado_reg', 'varchar');
        $this->setParametro('id_funcionario', 'id_funcionario', 'int4');
        $this->setParametro('id_responsable', 'id_responsable', 'int4');
        $this->setParametro('desde', 'desde', 'date');
        $this->setParametro('hasta', 'hasta', 'date');
        $this->setParametro('dias', 'dias', 'numeric');
        $this->setParametro('desde_comp', 'desde_comp', 'date');
        $this->setParametro('hasta_comp', 'hasta_comp', 'date');
        $this->setParametro('dias_comp', 'dias_comp', 'numeric');
        $this->setParametro('justificacion', 'justificacion', 'varchar');
        $this->setParametro('social_forestal', 'social_forestal', 'boolean');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function modificarCompensacion()
    {
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento = 'asis.ft_compensacion_ime';
        $this->transaccion = 'ASIS_CPM_MOD';
        $this->tipo_procedimiento = 'IME';

        //Define los parametros para la funcion
        $this->setParametro('id_compensacion', 'id_compensacion', 'int4');
        $this->setParametro('estado_reg', 'estado_reg', 'varchar');
        $this->setParametro('id_funcionario', 'id_funcionario', 'int4');
        $this->setParametro('id_responsable', 'id_responsable', 'int4');
        $this->setParametro('desde', 'desde', 'date');
        $this->setParametro('hasta', 'hasta', 'date');
        $this->setParametro('dias', 'dias', 'numeric');
        $this->setParametro('desde_comp', 'desde_comp', 'date');
        $this->setParametro('hasta_comp', 'hasta_comp', 'date');
        $this->setParametro('dias_comp', 'dias_comp', 'numeric');
        $this->setParametro('justificacion', 'justificacion', 'varchar');
        $this->setParametro('social_forestal', 'social_forestal', 'boolean');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function eliminarCompensacion()
    {
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento = 'asis.ft_compensacion_ime';
        $this->transaccion = 'ASIS_CPM_ELI';
        $this->tipo_procedimiento = 'IME';

        //Define los parametros para la funcion
        $this->setParametro('id_compensacion', 'id_compensacion', 'int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function getDias()
    {
        $this->procedimiento = 'asis.ft_compensacion_ime';
        $this->transaccion = 'ASIS_CMP_DAT';
        $this->tipo_procedimiento = 'IME';

        //Define los parametros para la funcion
        $this->setParametro('fecha_fin', 'fecha_fin', 'date');
        $this->setParametro('fecha_inicio', 'fecha_inicio', 'date');
        $this->setParametro('id_funcionario', 'id_funcionario', 'int4');
        $this->setParametro('fin_semana', 'fin_semana', 'varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
    function cambiarEstado(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='asis.ft_compensacion_ime';
        $this->transaccion='ASIS_CPM_SEG';
        $this->tipo_procedimiento='IME';
        //Define los parametros para la funcion
        $this->setParametro('id_proceso_wf','id_proceso_wf','int4');
        $this->setParametro('id_estado_wf','id_estado_wf','int4');
        $this->setParametro('evento','evento','varchar');
        $this->setParametro('obs', 'obs', 'text');

        $this->armarConsulta();
        $this->ejecutarConsulta();
        //Devuelve la respuesta
        return $this->respuesta;
    }
    function getDiaDisable()
    {
        $this->procedimiento = 'asis.ft_compensacion_ime';
        $this->transaccion = 'ASIS_FDI_INS';
        $this->tipo_procedimiento = 'IME';
        $this->setParametro('p_id_usuario', 'p_id_usuario', 'int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }
}

?>