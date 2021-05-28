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
            {
                config:{
                    name: 'tipo',
                    fieldLabel: 'Tipo',
                    allowBlank: false,
                    emptyText:'Tipo...',
                    typeAhead: true,
                    triggerAction: 'all',
                    lazyRender:true,
                    mode: 'local',
                    width:250,
                    store: new Ext.data.ArrayStore({
                        fields: ['variable', 'valor'],
                        data: [
                            ['General', 'Reporte General'],
                            ['Resumen', 'Reporte Resumen'],
                            ['Diario', 'Reporte Diario de Retrasos'],
                            ['Mensual', 'Detalle Mensual de Retrasos'],
                            ['Retrasos', 'Reporte de Retrasos']
                        ]
                    }),
                    valueField: 'variable',
                    displayField: 'valor',
                },
                type:'ComboBox',
                valorInicial: 'Completo',
                id_grupo:0,
                valorInicial: 'General',
                form:true
            },
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
                config : {
                    name : 'fecha_ini',
                    fieldLabel : 'Fecha Desde',
                    allowBlank : false,
                    format : 'd/m/Y',
                    vtype: 'daterange',
                    width : 250
                },
                type : 'DateField',
                id_grupo : 0,
                form : true
            },
            {
                config : {
                    name : 'fecha_fin',
                    fieldLabel : 'Fecha Hasta',
                    allowBlank : false,
                    format : 'd/m/Y',
                    vtype: 'daterange',
                    width : 250
                },
                type : 'DateField',
                id_grupo : 0,
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
                    width:250,
                    store:['XLSX','PDF']
                },
                type:'ComboBox',
                id_grupo:0,
                valorInicial: 'PDF',
                form:true
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
                    width : 315,
                    baseParams: {gerencia: 'si'},
                    allowBlank:true,
                    tpl:'<tpl for="."><div class="x-combo-list-item"><p><b>{codigo}</b> - {nombre_unidad}</p> </div></tpl>',
                    listWidth:'315',
                },
                type:'ComboRec',
                id_grupo:0,
                form:true
            },
            {
                config: {
                    name: 'tipo_filtro',
                    fieldLabel: 'Filtro Marcas',
                    items: [
                        {boxLabel: 'Filtrar todo', name: 'tipo_filtro', inputValue: 'todo', checked: true},
                        {boxLabel: 'Filtrar solo retraso, permiso, ausentes', name: 'tipo_filtro', inputValue: 'retraso'}
                    ],
                },
                type: 'RadioGroupField',
                id_grupo: 0,
                form: true
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
            this.ocultarComponente(this.Cmp.fecha_ini);
            this.ocultarComponente(this.Cmp.fecha_fin);
            const sef = this;
            this.Cmp.tipo.on('select',function(c,r,i) {

                if(r.data.variable === 'General'){
                    sef.ocultarComponente(sef.Cmp.fecha_ini);
                    sef.ocultarComponente(sef.Cmp.fecha_fin);
                    sef.mostrarComponente(sef.Cmp.tipo_filtro);
                    sef.mostrarComponente(sef.Cmp.fecha);
                }

                if(r.data.variable === 'Resumen'){
                    sef.ocultarComponente(sef.Cmp.fecha_ini);
                    sef.ocultarComponente(sef.Cmp.fecha_fin);
                    sef.ocultarComponente(sef.Cmp.tipo_filtro);
                    sef.mostrarComponente(sef.Cmp.fecha);
                }

                if(r.data.variable === 'Diario'){
                    sef.ocultarComponente(sef.Cmp.fecha_ini);
                    sef.ocultarComponente(sef.Cmp.fecha_fin);
                    sef.mostrarComponente(sef.Cmp.tipo_filtro);
                    sef.mostrarComponente(sef.Cmp.fecha);

                }

                if(r.data.variable === 'Mensual'){
                    sef.mostrarComponente(sef.Cmp.fecha_ini);
                    sef.mostrarComponente(sef.Cmp.fecha_fin);
                    sef.ocultarComponente(sef.Cmp.fecha);
                    sef.mostrarComponente(sef.Cmp.tipo_filtro);  //no da
                }

                if(r.data.variable === 'Retrasos'){
                    sef.mostrarComponente(sef.Cmp.fecha_ini);
                    sef.mostrarComponente(sef.Cmp.fecha_fin);
                    sef.ocultarComponente(sef.Cmp.fecha);
                    sef.ocultarComponente(sef.Cmp.tipo_filtro);
                }
            });
        },
        tipo : 'reporte',
        clsSubmit : 'bprint'
    })
</script>
