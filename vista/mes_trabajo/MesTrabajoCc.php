<?php
/**
 *@package pXP
 *@file RegistroSolicitud.php
 *@author  MAM
 *@date 27-12-2016 14:45
 *@Interface para el inicio de solicitudes de materiales
 * HISTORIAL DE MODIFICACIONES:
 * #ISSUE				FECHA				AUTOR				DESCRIPCION
 * #18	ERT			26/09/2019 				 MMV			Modificar centros de costo

 */
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
    Phx.vista.MesTrabajoCc = {
        require:'../../../sis_asistencia/vista/mes_trabajo/MesTrabajo.php',
        requireclase:'Phx.vista.MesTrabajo',
        title:'Mes trabajo VoBo',
        nombreVista: 'cc_ht',
        bnew:false,
        bedit:false,
        bdel:false,
        constructor: function(config) {
            this.initButtons=[this.cmbGestion, this.cmbPeriodo];
            Phx.vista.MesTrabajoCc.superclass.constructor.call(this,config);
            this.getBoton('insert_aunto').setVisible(false);
            this.getBoton('ant_estado').setVisible(false);
            this.getBoton('fin_registro').setVisible(false);
            this.getBoton('diagrama_gantt').setVisible(false);
            this.store.baseParams = {tipo_interfaz: this.nombreVista};
        },
        onButtonAct:function(){
            if(!this.validarFiltros()){
                alert('Especifique el año y el mes antes')
            }
            else{
                this.store.baseParams.id_gestion=this.cmbGestion.getValue();
                this.store.baseParams.id_periodo = this.cmbPeriodo.getValue();
                Phx.vista.MesTrabajoCc.superclass.onButtonAct.call(this);
            }
        },
        tabsouth:[
            {
                url:'../../../sis_asistencia/vista/mes_trabajo_det/MesTrabajoDetCc.php',
                title:'Detalle',
                height:'50%',
                cls:'MesTrabajoDetCc'
            },
            {
                url:'../../../sis_asistencia/vista/mes_trabajo_con/MesTrabajoCon.php',
                title:'Detalle Factor',
                height:'50%',
                cls:'MesTrabajoCon'
            }
        ]

    };
</script>

