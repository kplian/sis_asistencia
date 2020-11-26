<?php
/**
 *@package sis_asistencia
 *@file    FormReporteVacacion.php
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
    Phx.vista.FormReporteVacacion= Ext.extend(Phx.frmInterfaz, {
        Atributos : [
            {
                config:{
                    name: 'reporte',
                    fieldLabel: 'Tipo Reporte',
                    allowBlank: false,
                    emptyText:'Tipo...',
                    typeAhead: true,
                    triggerAction: 'all',
                    lazyRender:true,
                    mode: 'local',
                    width:300,
                     store:['Saldo','Anticipadas','Vencimiento','Resumen','Personal en Vacaciones','Historial de Vacaciones']
                },
                type:'ComboBox',
                id_grupo:0,
                valorInicial: 'Anticipadas',
                form:true
            },
          /*  {
                config:{
                    name : 'id_gestion',
                    origen : 'GESTION',
                    fieldLabel : 'Gestion',
                    allowBlank : true,
                    valueField : 'gestion',
                    width : 300,

                },
                type : 'ComboRec',
                id_grupo : 0,
                form : true
            },*/
            {
                config : {
                    name : 'fecha_ini',
                    fieldLabel : 'Fecha',
                    allowBlank : true,
                    format : 'd/m/Y',
                    width : 300,
                },
                type : 'DateField',
                id_grupo : 0,
                form : true
            },
           /* {
                config : {
                    name : 'fecha_fin',
                    fieldLabel: 'Fecha Hasta',
                    allowBlank: true,
                    format: 'd/m/Y',
                    width : 300
                },
                type : 'DateField',
                id_grupo : 1,
                form : true
            },*/
           /* {
                config : {
                    name : 'id_funcionario',
                    origen : 'FUNCIONARIOCAR',
                    fieldLabel : 'Funcionario',
                    gdisplayField : 'desc_funcionario', //mapea al store del grid
                    valueField : 'id_funcionario',
                    width : 300,
                    baseParams: { fecha : new Date() },
                    renderer : function(value, p, record) {
                        return String.format('{0}', record.data['desc_funcionario']);
                    }
                },
                type : 'ComboRec',
                id_grupo : 2,
                grid : true,
                form : true
            },*/
            {
                config: {
                    name: 'id_funcionario',
                    fieldLabel: 'Funcionario',
                    allowBlank: false,
                    emptyText: 'Elija una opción...',
                    store: new Ext.data.JsonStore({
                        url: '../../sis_asistencia/control/Vacacion/listarFuncionarioOficiales',
                        id: 'id_funcionario',
                        root: 'datos',
                        totalProperty: 'total',
                        fields: ['id_funcionario','desc_funcionario','codigo','cargo','departamento','oficina'],
                        remoteSort: true,
                        baseParams: {par_filtro: 'pe.nombre_completo1'}
                    }),
                    valueField: 'id_funcionario',
                    displayField: 'desc_funcionario',
                    gdisplayField: 'responsable',
                    hiddenName: 'Funcionario',
                    tpl: '<tpl for="."><div class="x-combo-list-item"><p><b>{desc_funcionario}</b></p><p>{codigo}</p><p>{cargo}</p><p>{departamento}</p><p>{oficina}</p> </div></tpl>',
                    forceSelection: true,
                    typeAhead: false,
                    triggerAction: 'all',
                    lazyRender: true,
                    mode: 'remote',
                    pageSize: 15,
                    queryDelay: 1000,
                    width: 300,
                    gwidth:200,
                    minChars: 2
                },
                type: 'ComboBox',
                id_grupo: 1,
                grid: true,
                form: true
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
                    width : 300,
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
        ActSave : '../../sis_asistencia/control/Reporte/listarVacacionesSaldo',
        topBar : true,
        botones : false,
        labelSubmit : 'Generar',
        tooltipSubmit : '<b>Generar Excel</b>',
        constructor : function(config) {
            Phx.vista.FormReporteVacacion.superclass.constructor.call(this, config);
            this.init();

        },

        tipo : 'reporte',
        clsSubmit : 'bprint'

    })
</script>
