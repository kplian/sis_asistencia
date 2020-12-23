<?php
/**
 *@package sis_asistencia
 *@file    FormReporteMarcacion.php
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
    Phx.vista.FormReporteMarcacion= Ext.extend(Phx.frmInterfaz, {
        Atributos : [
			//fecha inicial
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

			//fecha inicial
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
					name:'id_funcionario',
					hiddenName: 'id_funcionario',
					origen:'FUNCIONARIOCAR',
					fieldLabel:'Funcionario',
					allowBlank:false,
					anchor: '85%',
					gwidth:85,
					valueField: 'id_funcionario',
					gdisplayField: 'funcionario',
					baseParams: {par_filtro: 'id_funcionario#desc_funcionario1#codigo'},
					renderer:function(value, p, record){return String.format('{0}', record.data['funcionario']);}
				},
				type:'ComboRec',//ComboRec
				id_grupo:2,
				filters:{pfiltro:'fun.desc_funcionario1',type:'string'},
				bottom_filter:false,
				grid:true,
				form:true
			},

			{
				config : {
					name : 'tipo_rpt',
					fieldLabel : 'Tipo de Reporte',
					//labelStyle: 'width:150px; margin: 5;',
					emptyText : 'Seleccione Opcion...',
					width : 250,
					mode : 'local',
					store : new Ext.data.ArrayStore({
						fields : ['ID', 'valor'],
						data : [['General', 'General'], ['Resumen', 'Resumen'], ['Tiempos Maximos', 'Tiempos Maximos'], ['Incumplimientos', 'Incumplimientos'], ['Impares', 'Impares'] ]

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

        ],
        title : 'Generar Reporte',
        //ActSave : '../../sis_asistencia/control/Reporte/ReporteMarcadoFuncGral',
		ActSave : '../../sis_asistencia/control/Reporte/ReporteMarcadoFuncGralPDF',
        topBar : true,
        botones : false,
        labelSubmit : 'Generar',
        //tooltipSubmit : '<b>Generar Excel</b>',
		tooltipSubmit : '<b>Generar PDF</b>',
		constructor : function(config) {
            Phx.vista.FormReporteMarcacion.superclass.constructor.call(this, config);
            this.init();
            /*this.Cmp.id_gestion.on('select', function(combo, record, index){
                console.log(record.data.gestion);
            },this);*/
        },

        tipo : 'reporte',
        clsSubmit : 'bprint',

        /*agregarArgsExtraSubmit: function() {
          //   this.argumentExtraSubmit.eventodesc = this.Cmp.evento.getRawValue();
        },*/

        Grupos:[
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
                                    }

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
