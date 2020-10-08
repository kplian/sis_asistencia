<?php
/**
 *@package pXP
 *@file VacacionVoBo.php
 *@author  MAM
 *@date 27-12-2016 14:45
 *@Interface para el inicio de solicitudes de materiales
 */
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
    Phx.vista.VacacionVoBo = {
        require:'../../../sis_asistencia/vista/vacacion/Vacacion.php', // direcion de la clase que va herrerar
        requireclase:'Phx.vista.Vacacion', // nombre de la calse
        title:'VoBo Vacaciones', // nombre de interaz
        nombreVista: 'VacacionVoBo',
        bnew:false,
        bedit:false,
        bdel:false,
        bsave:false,
        constructor: function(config) {
            Phx.vista.VacacionVoBo.superclass.constructor.call(this, config);
            this.store.baseParams = {tipo_interfaz: this.nombreVista};
            this.load({params: {start: 0, limit: this.tam_pag}});
        },
        south:{
            url:'../../../sis_asistencia/vista/vacacion_det/VacacionDetVoBo.php',
            title:'Detalle',
            height:'50%',
            cls:'VacacionDetVoBo'
        }
    };
</script>

