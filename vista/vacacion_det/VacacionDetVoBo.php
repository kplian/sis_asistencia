<?php
/**
 *@package pXP
 *@file VacacionDetVoBo.php
 *@author  MAM
 *@date 27-12-2016 14:45
 *@Interface para el inicio de solicitudes de materiales
 */
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
    Phx.vista.VacacionDetVoBo = {
        require:'../../../sis_asistencia/vista/vacacion_det/VacacionDet.php', // direcion de la clase que va herrerar
        requireclase:'Phx.vista.VacacionDet', // nombre de la calse
        title:'VoBo Vacaciones', // nombre de interaz
        nombreVista: 'VacacionDetVoBo',
        bnew:false,
        bedit:false,
        bdel:false,
        bsave:false,
        constructor: function(config) {
            this.Atributos[this.getIndAtributo('tiempo')].grid=false;
            Phx.vista.VacacionDetVoBo.superclass.constructor.call(this, config);
        }
    };
</script>

