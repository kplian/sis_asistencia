<?php
/**
 *@package pXP
 *@file PermisoVoBo.php
 *@author  MAM
 *@date 27-12-2016 14:45
 *@Interface para el inicio de solicitudes de materiales
 */
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
    Phx.vista.PermisoVoBo = {
        require:'../../../sis_asistencia/vista/permiso/Permiso.php', // direcion de la clase que va herrerar
        requireclase:'Phx.vista.Permiso', // nombre de la calse
        title:'Solicitud Permiso', // nombre de interaz
        nombreVista: 'PermisoVoBo',
        bnew:false,
        bedit:false,
        bdel:false,
        tam_pag:50,
        //funcion para mandar el name de tab
        constructor: function(config) {
            Phx.vista.PermisoVoBo.superclass.constructor.call(this, config);
            this.store.baseParams = {tipo_interfaz: this.nombreVista};
            this.store.baseParams.pes_estado = 'registro';
            // this.finCons = true;
            this.load({params: {start: 0, limit: this.tam_pag}});
        }
    };
</script>

