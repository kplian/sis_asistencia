<?php
/**
 *@package pXP
 *@file RegistroSolicitud.php
 *@author  MAM
 *@date 27-12-2016 14:45
 *@Interface para el inicio de solicitudes de materiales
 */
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
    Phx.vista.MesTrabajoDetVoBo = {
        bedit:true,
        bnew:false,
        bsave:false,
        bdel:false,
        require:'../../../sis_asistencia/vista/mes_trabajo_det/MesTrabajoDet.php',
        requireclase:'Phx.vista.MesTrabajoDet',
        title:'Detalle VoBo',
        nombreVista: 'MesTrabajoDetVoBo',
        constructor: function(config) {
            this.Atributos[this.getIndAtributo('id_centro_costo')].disabled = true;
            this.Atributos[this.getIndAtributo('justificacion_extra')].form = true;
            Phx.vista.MesTrabajoDetVoBo.superclass.constructor.call(this,config);
            this.store.baseParams = {tipo_interfaz: this.nombreVista};
            this.getBoton('btnTransaccionesUpload').setVisible(false);

        }

    };
</script>

