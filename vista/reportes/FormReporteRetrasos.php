<?php
/**
 *@package sis_asistencia
 *@file    FormReporteRetrasos.php
 *@author  mgarcia
 *@date    29/08/2019
 *@description Reporte
 * HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
#15		etr			02-09-2019			MCGH               	Reporte Transacción marcados
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.FormReporteRetrasos= Ext.extend(Phx.frmInterfaz, {
        Atributos : [
            {
                config : {
                    name : 'fecha_ini',
                    id:'fecha_ini'+this.idContenedor,
                    fieldLabel : 'Fecha Desde',
                    allowBlank : false,
                    format : 'd/m/Y',
                    renderer : function(value, p, record) {
                        return value ? value.dateFormat('d/m/Y h:i:s') : ''
                    },
                    vtype: 'daterange',
                    width : 250,
                    endDateField: 'fecha_fin'+this.idContenedor
                },
                type : 'DateField',
                id_grupo : 0,
                grid : true,
                form : true
            },
            {
                config:{
                    name: 'hora_ini',
                    fieldLabel: 'Hora Desde',
                    // minValue: '12:00 AM',
                    // maxValue: '11:59 PM',
                    format: 'H:i',
                    increment: 1,
                    //allowBlank: false,
                    width: 250,

                },
                type:'TimeField',
                filters:{pfiltro:'rho.hora_ini',type:'string'},
                id_grupo:0,
                grid:true,
                form:true
            },
            {
                config : {
                    name : 'fecha_fin',
                    id:'fecha_fin'+this.idContenedor,
                    fieldLabel: 'Fecha Hasta',
                    allowBlank: false,
                    format: 'd/m/Y',
                    renderer: function(value, p, record) {
                        return value ? value.dateFormat('d/m/Y h:i:s') : ''
                    },
                    vtype: 'daterange',
                    width : 250,
                    startDateField: 'fecha_ini'+this.idContenedor
                },
                type : 'DateField',
                id_grupo : 1,
                grid : true,
                form : true
            },
            {
                config:{
                    name: 'hora_fin',
                    fieldLabel: 'Hora Hasta',
                    // minValue: '12:00 AM',
                    // maxValue: '11:59 PM',
                    format: 'H:i',
                    increment: 1,
                    //allowBlank: false,
                    width: 250,
                },
                type:'TimeField',
                filters:{pfiltro:'rho.hora_fin',type:'string'},
                id_grupo:1,
                grid:true,
                form:true
            },
            {
                config : {
                    name : 'modo_verif',
                    fieldLabel : 'Modo Verificación',
                    //labelStyle: 'width:150px; margin: 5;',
                    emptyText : 'Seleccione Opcion...',
                    width : 250,
                    mode : 'local',
                    store : new Ext.data.ArrayStore({
                        fields : ['ID', 'valor'],
                        data : [['Solo Huella', 'Solo Huella'], ['Solo Tarjeta', 'Solo Tarjeta'], ['Otro', 'Otro']]

                    }),
                    triggerAction : 'all',
                    valueField : 'ID',
                    displayField : 'valor'

                },
                type : 'ComboBox',
                id_grupo : 2,
                grid : true,
                form : true
            },
            {
                config : {
                    name : 'evento',
                    fieldLabel : 'Descripción del Evento',
                    //labelStyle: 'width:150px; margin: 5;',
                    emptyText : 'Seleccione Opcion...',
                    width : 250,
                    mode : 'local',
                    store : new Ext.data.ArrayStore({
                        fields : ['ID', 'valor'],
                        data : [['0', 'Apertura con verificación normal'], ['27', 'Usuario no Registrado'], ['22', 'Fuera del horario permitido'],['', 'Otro']],

                    }),
                    triggerAction : 'all',
                    valueField : 'ID',
                    displayField : 'valor'

                },
                type : 'ComboBox',
                id_grupo : 2,
                grid : true,
                form : true
            },
            {
                config : {
                    name : 'id_funcionario',
                    origen : 'FUNCIONARIOCAR',
                    fieldLabel : 'Funcionario',
                    gdisplayField : 'desc_funcionario', //mapea al store del grid
                    valueField : 'id_funcionario',
                    width : 250,
                    renderer : function(value, p, record) {
                        return String.format('{0}', record.data['desc_funcionario']);
                    }
                },
                type : 'ComboRec',
                id_grupo : 2,
                grid : true,
                form : true
            }
        ],
        title : 'Generar Reporte',
        ActSave : '../../sis_asistencia/control/Reporte/reporteAnexos',
        topBar : true,
        botones : false,
        labelSubmit : 'Generar',
        tooltipSubmit : '<b>Generar Excel</b>',
        constructor : function(config) {
            Phx.vista.FormReporteRetrasos.superclass.constructor.call(this, config);
            this.init();
            /*this.Cmp.id_gestion.on('select', function(combo, record, index){
                console.log(record.data.gestion);
            },this);*/
        },

        tipo : 'reporte',
        clsSubmit : 'bprint',

        agregarArgsExtraSubmit: function() {
            this.argumentExtraSubmit.eventodesc = this.Cmp.evento.getRawValue();
        },

        Grupos:
            [
                {
                    layout: 'column',
                    border: false,
                    defaults: {
                        border: false
                    },
                    items : [{
                        bodyStyle : 'padding-left:5px;padding-left:5px;',
                        border : false,
                        defaults : {
                            border : false
                        },
                        width : 800,
                        items: [
                            {
                            bodyStyle: 'padding-left:5px;',
                            items: [{
                                xtype: 'fieldset',
                                title: 'Criterios de Búsqueda',
                                autoHeight: true,
                                items: [
                                    {
                                        xtype: 'compositefield',
                                        fieldLabel: 'Tiempo Desde',
                                        msgTarget : 'side',
                                        anchor    : '-100',
                                        defaults: {
                                            flex: 1
                                        },
                                        items: [],
                                        id_grupo:0
                                    },
                                    {
                                        xtype: 'compositefield',
                                        fieldLabel: 'Tiempo Hasta',
                                        msgTarget : 'side',
                                        anchor    : '-100',
                                        defaults: {
                                            flex: 1
                                        },
                                        items: [],
                                        id_grupo:1
                                    }/*,
                                    {
                                        xtype: 'compositefield',
                                        fieldLabel: 'UO',
                                        msgTarget : 'side',
                                        anchor    : '-100',
                                        defaults: {
                                            flex: 1
                                        },
                                        items: [],
                                        id_grupo:2
                                    }*/
                                ]
                            }]
                        },
                        {
                            bodyStyle: 'padding-right:5px;',
                            items: [{
                                xtype: 'fieldset',
                                title: 'Otros Criterios de Búsqueda',
                                autoHeight: true,
                                items: [],
                                id_grupo:2
                            }]
                        }]
                    }] //
                }
            ]
    })
</script>
