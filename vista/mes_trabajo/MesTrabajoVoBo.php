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
    Phx.vista.MesTrabajoVoBo = {
        require:'../../../sis_asistencia/vista/mes_trabajo/MesTrabajo.php',
        requireclase:'Phx.vista.MesTrabajo',
        title:'Mes trabajo VoBo',
        nombreVista: 'MesTrabajoVoBo',
        bnew:false,
        bedit:false,
        bdel:false,
        constructor: function(config) {
            this.Atributos[this.getIndAtributo('desc_codigo')].grid=false;
            this.Atributos[this.getIndAtributo('nombre_archivo')].grid=false;
            Phx.vista.MesTrabajoVoBo.superclass.constructor.call(this, config);
            this.store.baseParams = {tipo_interfaz: this.nombreVista};
            this.load({params: {start: 0, limit: this.tam_pag}});
        },
        tabsouth:[
            {
                url:'../../../sis_asistencia/vista/mes_trabajo_det/MesTrabajoDetVoBo.php',
                title:'Detalle',
                height:'50%',
                cls:'MesTrabajoDetVoBo'
            }
        ]

    };
</script>

