<?php
/**
 * @package pXP
 * @file ComponsacionSol.php
 * @author  MAM
 * @date 27-12-2016 14:45
 * @Interface para el inicio de solicitudes de materiales
 */
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
    Phx.vista.CompensacionDetVobo = {
        require: '../../../sis_asistencia/vista/compensacion_det/CompensacionDet.php', // direcion de la clase que va herrerar
        requireclase: 'Phx.vista.CompensacionDet', // nombre de la calse
        title: 'CompensacionDet', // nombre de interaz
        nombreVista: 'CompensacionDetVobo',
        bsave: false,
        bnew: false,
        bedit: false,
        bdel: false,
        constructor: function (config) {
            this.Atributos[this.getIndAtributo('tiempo')].grid = false;
            Phx.vista.CompensacionDetVobo.superclass.constructor.call(this, config);
        }
    };
</script>

