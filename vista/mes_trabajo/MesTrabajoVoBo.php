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
        nombreVista: 'VoBo',
        bnew:false,
        bedit:false,
        bdel:false,
        constructor: function(config) {
            this.initButtons=[this.cmbGestion, this.cmbPeriodo];
            Phx.vista.MesTrabajoVoBo.superclass.constructor.call(this, config);
            this.store.baseParams = {tipo_interfaz: this.nombreVista};
            //this.load({params: {start: 0, limit: this.tam_pag}});
        },
        onButtonAct:function(){
            if(!this.validarFiltros()){
                alert('Especifique el año y el mes antes')
            }
            else{
                this.store.baseParams.id_gestion=this.cmbGestion.getValue();
                this.store.baseParams.id_periodo = this.cmbPeriodo.getValue();
                Phx.vista.MesTrabajoVoBo.superclass.onButtonAct.call(this);
            }
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

