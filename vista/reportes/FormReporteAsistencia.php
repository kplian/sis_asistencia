<?php
/**
 *@package sis_asistencia
 *@file    FormReporteAsistencia.php
 *@author  szambrna
 *@date    02/10/2019
 *@description Reporte
 * HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
#21		etr			18-10-2019			SAZP				Modificacion datos funcionarion en el combo del reporte

 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.FormReporteAsistencia= Ext.extend(Phx.frmInterfaz, {
        Atributos : [
            //fecha inicial
            {
                config : {
                    name : 'fecha',
                    fieldLabel : 'Fecha',
                    allowBlank : false,
                    format : 'd/m/Y',
                    vtype: 'daterange',
                    width : 250
                },
                type : 'DateField',
                id_grupo : 0,
                grid : true,
                form : true
            },
            {
                config:{
                    name:'id_uo',
                    hiddenName: 'id_uo',
                    origen:'UO',
                    fieldLabel:'UO',
                    gdisplayField:'desc_uo',//mapea al store del grid
                    gwidth:200,
                    emptyText:'Dejar blanco para toda la empresa...',
                    width : 250,
                    baseParams: {nivel: '0,1,2'},
                    allowBlank:true
                },
                type:'ComboRec',
                id_grupo:0,
                form:true
            },
            {
                config:{
                    name: 'formato',
                    fieldLabel: 'Formato',
                    allowBlank: false,
                    emptyText:'Tipo...',
                    typeAhead: true,
                    triggerAction: 'all',
                    lazyRender:true,
                    mode: 'local',
                    width:200,
                    store:['XLSX','PDF']
                },
                type:'ComboBox',
                id_grupo:0,
                valorInicial: 'PDF',
                form:true
            },

        ],
        title : 'Generar Reporte',
        ActSave : '../../sis_asistencia/control/Reporte/listarAsistencia',
        topBar : true,
        botones : false,
        labelSubmit : 'Generar',
        tooltipSubmit : '<b>Generar Resporte</b>',
        constructor : function(config) {
            Phx.vista.FormReporteAsistencia.superclass.constructor.call(this, config);
            this.init();
        },

        tipo : 'reporte',
        clsSubmit : 'bprint',

        /*agregarArgsExtraSubmit: function() {
          //   this.argumentExtraSubmit.eventodesc = this.Cmp.evento.getRawValue();
        },*/
    })
</script>
