<?php
/****************************************************************************************
 * @package pXP
 * @file MODCompensacionDet.php
 * @author  (amamani)
 * @date 18-05-2021 14:14:47
 * @description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
 *
 * HISTORIAL DE MODIFICACIONES:
 * #ISSUE                FECHA                AUTOR                DESCRIPCION
 * #0                18-05-2021 14:14:47    amamani             Creacion
 * #
 *****************************************************************************************/

class MODCompensacionDet extends MODbase
{

    function __construct(CTParametro $pParam)
    {
        parent::__construct($pParam);
    }

    function listarCompensacionDet()
    {
        //Definicion de variables para ejecucion del procedimientp
        $this->procedimiento = 'asis.ft_compensacion_det_sel';
        $this->transaccion = 'ASIS_CMD_SEL';
        $this->tipo_procedimiento = 'SEL';//tipo de transaccion

        //Definicion de la lista del resultado del query
        $this->captura('id_compensacion_det', 'int4');
        $this->captura('estado_reg', 'varchar');
        $this->captura('fecha', 'date');
        $this->captura('id_compensacion', 'int4');
        $this->captura('tiempo', 'varchar');
        $this->captura('id_usuario_reg', 'int4');
        $this->captura('fecha_reg', 'timestamp');
        $this->captura('id_usuario_ai', 'int4');
        $this->captura('usuario_ai', 'varchar');
        $this->captura('id_usuario_mod', 'int4');
        $this->captura('fecha_mod', 'timestamp');
        $this->captura('usr_reg', 'varchar');
        $this->captura('usr_mod', 'varchar');
        $this->captura('obs_dba', 'varchar');
        $this->captura('fecha_comp', 'date');
        $this->captura('tiempo_comp', 'varchar');
        $this->captura('social_forestal', 'boolean');
        $this->captura('fecha_fin', 'date');
        $this->captura('fecha_comp_fin', 'date');
        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function cambiarTiempo()
    {
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento = 'asis.ft_compensacion_det_ime';
        $this->transaccion = 'ASIS_CMD_INS';
        $this->tipo_procedimiento = 'IME';

        //Define los parametros para la funcion
        $this->setParametro('id_compensacion_det', 'id_compensacion_det', 'int4');
        $this->setParametro('field_name', 'field_name', 'varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function modificarCompensacionDet()
    {
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento = 'asis.ft_compensacion_det_ime';
        $this->transaccion = 'ASIS_CMD_MOD';
        $this->tipo_procedimiento = 'IME';

        //Define los parametros para la funcion
        $this->setParametro('id_compensacion_det', 'id_compensacion_det', 'int4');
        $this->setParametro('estado_reg', 'estado_reg', 'varchar');
        $this->setParametro('fecha', 'fecha', 'date');
        $this->setParametro('id_compensacion', 'id_compensacion', 'int4');
        $this->setParametro('tiempo', 'tiempo', 'varchar');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

    function eliminarCompensacionDet()
    {
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento = 'asis.ft_compensacion_det_ime';
        $this->transaccion = 'ASIS_CMD_ELI';
        $this->tipo_procedimiento = 'IME';

        //Define los parametros para la funcion
        $this->setParametro('id_compensacion_det', 'id_compensacion_det', 'int4');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

}

?>