<?php
/**
 *@package pXP
 *@file    ItemEntRec.php
 *@author  admin
 *@date    13/09/2016
 *@description Reporte
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.ReporteMesTrabajo= Ext.extend(Phx.frmInterfaz, {
        Atributos : [
            {
                config:{
                    name : 'id_gestion',
                    origen : 'GESTION',
                    fieldLabel : 'Gestion',
                    gdisplayField: 'desc_gestion',
                    allowBlank : false,
                    width: 200
                },
                type : 'ComboRec',
                id_grupo : 0,
                form : true
            },
            {
                config:{
                    name : 'id_periodo',
                    origen : 'PERIODO',
                    fieldLabel : 'Periodo',
                    allowBlank : false,
                    width: 200,
                    baseParams:{par_filtro:'periodo',id_gestion:3}
                },
                type : 'ComboRec',
                id_grupo : 0,
                form : true
            },
            {
                config:{
                    name:'id_uo',
                    hiddenName: 'id_uo',
                    origen:'UO',
                    fieldLabel:'UO',
                    gdisplayField:'desc_uo',//mapea al store del grid
                    width: 300,
                    emptyText:'Dejar blanco para toda la empresa...',
                    baseParams: {nivel: 'si'},
                    allowBlank:true
                },
                type:'ComboRec',
                id_grupo : 0,
                form:true
            }
        ],
        title : 'Generar Reporte',
        ActSave : '../../sis_asistencia/control/MesTrabajo/reporteMesTrabajoUo',
        topBar : true,
        botones : false,
        labelSubmit : 'Generar',
        tooltipSubmit : '<b>Generar Excel</b>',
        constructor : function(config) {
            Phx.vista.ReporteMesTrabajo.superclass.constructor.call(this, config);
            this.init();
            this.Cmp.id_gestion.on('select', function(combo, record, index){
                console.log(record.data.gestion);
              //  this.Cmp.id_periodo.store.baseParams = Ext.apply(this.cmbPeriodo.store.baseParams, {id_gestion: this.cmbGestion.getValue()});
                /*this.Cmp.id_periodo.reset();
                this.store.removeAll();
                this.Cmp.id_periodo.store.baseParams = Ext.apply(this.cmbPeriodo.store.baseParams, {id_gestion: this.cmbGestion.getValue()});
                this.Cmp.id_periodo.modificado = true;*/
            },this);
        },

        tipo : 'reporte',
        clsSubmit : 'bprint',

        agregarArgsExtraSubmit: function() {
            this.argumentExtraSubmit.uo = this.Cmp.id_uo.getRawValue();
        }
    })
</script>
