<?php
/**
 *@package pXP
 *@file MesTrabajoDetConsulta.php
 *@author  MAM
 *@date 27-12-2016 14:45
 *@Interface para el inicio de solicitudes de materiales
 */
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
    Phx.vista.MesTrabajoDetConsulta = {
        bedit:false,
        bnew:false,
        bsave:false,
        bdel:false,
        require:'../../../sis_asistencia/vista/mes_trabajo_det/MesTrabajoDet.php',
        requireclase:'Phx.vista.MesTrabajoDet',
        title:'Detalle Consulta',
        nombreVista: 'MesTrabajoDetConsulta',
        constructor: function(config) {
            Phx.vista.MesTrabajoDetConsulta.superclass.constructor.call(this,config);
            this.store.baseParams = {tipo_interfaz: this.nombreVista};
            this.load({params:{start:0, limit:this.tam_pag}})
        }
    };
</script>

