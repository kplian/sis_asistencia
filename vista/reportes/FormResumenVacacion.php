<?php
/**
 *@package sis_asistencia
 *@file    FormResumenVacacion.php
 *@author  MMV
 *@date    29/08/2019
 *@description Reporte
 * HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
#15		etr			02-09-2019			MCGH               	Reporte Transacción marcados

 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.FormResumenVacacion= Ext.extend(Phx.frmInterfaz, {
        Atributos : [
            {
                config : {
                    name : 'fecha_ini',
                    fieldLabel : 'Fecha Desde',
                    allowBlank : false,
                    format : 'd/m/Y',
                    width : 200,
                },
                type : 'DateField',
                id_grupo : 0,
                form : true
            },
            {
                config : {
                    name : 'fecha_fin',
                    fieldLabel: 'Fecha Hasta',
                    allowBlank: false,
                    format: 'd/m/Y',
                    width : 200
                },
                type : 'DateField',
                id_grupo : 1,
                form : true
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
        ActSave : '../../sis_asistencia/control/Reporte/listarVacacionesResumen',
        topBar : true,
        botones : false,
        labelSubmit : 'Generar',
        tooltipSubmit : '<b>Generar Excel</b>',
        constructor : function(config) {
            Phx.vista.FormResumenVacacion.superclass.constructor.call(this, config);
            this.init();
        },
        tipo : 'reporte',
        clsSubmit : 'bprint'
    })
</script>
