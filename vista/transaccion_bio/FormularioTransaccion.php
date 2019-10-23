<?php
/**
 *@package pXP
 *@file    SolModPresupuesto.php
 *@author  Rensi Arteaga Copari
 *@date    30-01-2014
 *@description permites subir archivos a la tabla de documento_sol
 */
/**
HISTORIAL DE MODIFICACIONES:
ISSUE 		   FECHA   			 AUTOR				 DESCRIPCION:
 */
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
    Phx.vista.FormularioTransaccion=Ext.extend(Phx.frmInterfaz,{
        constructor:function(config) {
           /* this.panelResumen = new Ext.Panel({html:''});
            this.Grupos =
                [
                    {
                        xtype: 'fieldset',
                        border: true,
                        autoScroll: true,
                        layout: 'form',
                        items:
                            [
                            ],
                        id_grupo: 0
                    },
                    this.panelResumen
                ];*/

            Phx.vista.FormularioTransaccion.superclass.constructor.call(this,config);
            this.init();
            this.iniciarEvento();
            if(config.detalle){
                //cargar los valores para el filtro
                this.loadForm({data: config.detalle});
                var me = this;
                setTimeout(function(){
                    me.onSubmit()
                }, 1500);
            }
        },
        Atributos:[
            {
                config:{
                    name : 'tipo_filtro',
                    fieldLabel : 'Filtros',
                    items: [
                        {boxLabel: 'Periodos', name: 'tipo_filtro', inputValue: 'periodo', checked: true},
                        {boxLabel: 'Solo fechas', name: 'tipo_filtro', inputValue: 'fechas'}
                    ]
                },
                type : 'RadioGroupField',
                id_grupo : 0,
                form : true
            },
            {
                config:{
                    name : 'id_gestion',
                    origen : 'GESTION',
                    fieldLabel : 'Gestion',
                    gdisplayField: 'desc_gestion',
                    allowBlank : false,
                    width: 150
                },
                type : 'ComboRec',
                id_grupo : 0,
                form : true
            },
            {
                config: {
                    name: 'id_periodo',
                    fieldLabel: 'Periodo',
                    allowBlank: false,
                    blankText : 'Mes',
                    emptyText:'Periodo...',
                    store:new Ext.data.JsonStore(
                        {
                            url: '../../sis_parametros/control/Periodo/listarPeriodo',
                            id: 'id_periodo',
                            root: 'datos',
                            sortInfo:{
                                field: 'periodo',
                                direction: 'ASC'
                            },
                            totalProperty: 'total',
                            fields: ['id_periodo','periodo','id_gestion','literal'],
                            // turn on remote sorting
                            remoteSort: true,
                            baseParams:{par_filtro:'gestion'}
                        }),
                    valueField: 'id_periodo',
                    triggerAction: 'all',
                    displayField: 'literal',
                    hiddenName: 'id_periodo',
                    mode:'remote',
                    pageSize:50,
                    disabled: false,
                    queryDelay:500,
                    listWidth:'280',
                    width:150
                },
                type: 'ComboBox',
                id_grupo: 1,
                form: true
            },
            {
                config:{
                    name: 'desde',
                    fieldLabel: 'Desde',
                    allowBlank: false,
                    format: 'd/m/Y',
                    width: 150
                },
                type: 'DateField',
                id_grupo: 0,
                form: true
            },
            {
                config:{
                    name: 'hasta',
                    fieldLabel: 'Hasta',
                    allowBlank: false,
                    format: 'd/m/Y',
                    width: 150
                },
                type: 'DateField',
                id_grupo: 0,
                form: true
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
            },
            {
                config: {
                    name: 'id_uo',
                    baseParams : { correspondencia : 'si' },
                    origen : 'UO',
                    allowBlank: false,
                    //LabelWidth:500,
                    fieldLabel : 'UO Remitente',
                    gdisplayField : 'desc_uo', //mapea al store del grid
                    //gwidth : 500,
                    renderer : function(value, p, record) {
                        return String.format('{0}', record.data['desc_uo']);
                    }
                },
                type: 'ComboRec',
                id_grupo : 1,
                filters: {  pfiltro : 'desc_uo', type : 'string'},
                grid : true,
                form : true
            },
            {
                config:{
                    name: 'hora_ini',
                    fieldLabel: 'Hora Desde',
                    format: 'H:i',
                    increment: 1,
                    //allowBlank: false,
                    width: 250

                },
                type:'TimeField',
                filters:{pfiltro:'rho.hora_ini',type:'string'},
                id_grupo:0,
                form:true
            },
            {
                config:{
                    name: 'hora_fin',
                    fieldLabel: 'Hora Hasta',
                    format: 'H:i',
                    increment: 1,
                    //allowBlank: false,
                    width: 250
                },
                type:'TimeField',
                filters:{pfiltro:'rho.hora_fin',type:'string'},
                id_grupo:1,
                form:true
            },
            {
                config: {
                    name: 'id_rango_horario',
                    fieldLabel: 'Rango',
                    allowBlank: false,
                    blankText : 'Mes',
                    emptyText:'Rango...',
                    store:new Ext.data.JsonStore(
                        {
                            url: '../../sis_asistencia/control/RangoHorario/listarRangoHorario',
                            id: 'id_periodo',
                            root: 'datos',
                            sortInfo:{
                                field: 'id_rango_horario',
                                direction: 'ASC'
                            },
                            totalProperty: 'total',
                            fields: ['id_rango_horario','descripcion','codigo'],
                            // turn on remote sorting
                            remoteSort: true,
                            baseParams:{par_filtro:'descripcion'}
                        }),
                    valueField: 'id_rango_horario',
                    triggerAction: 'all',
                    displayField: 'descripcion',
                    hiddenName: 'id_rango_horario',
                    mode:'remote',
                    pageSize:50,
                    disabled: false,
                    queryDelay:500,
                    listWidth:'280',
                    width:200
                },
                type: 'ComboBox',
                id_grupo: 1,
                form: true
            }

        ],
        labelSubmit: '<i class="fa fa-check"></i> Aplicar Filtro',
        east: {
            url: '../../../sis_asistencia/vista/transaccion_bio/TransaccionRep.php',
            title: undefined,
            width: '70%',
            cls: 'TransaccionRep'
        },
        title: 'Filtro Transaccion',
        autoScroll: true,
        onSubmit: function(o) {
            var me = this;
            if (me.form.getForm().isValid()) {
               /* var parametros = me.getValForm();

                var gest=this.Cmp.id_gestion.lastSelectionText;
                var dpto=this.Cmp.id_depto.lastSelectionText;
                var tpocuenta=this.Cmp.id_config_tipo_cuenta.lastSelectionText;
                var subtpocuenta=this.Cmp.id_config_subtipo_cuenta.lastSelectionText;

                var cuenta=this.Cmp.id_cuenta.lastSelectionText;
                var auxiliar=this.Cmp.id_auxiliar.lastSelectionText;
                var partida=this.Cmp.id_partida.lastSelectionText;
                var tcc=this.Cmp.id_tipo_cc.lastSelectionText;

                var cc=this.Cmp.id_centro_costo.lastSelectionText;
                var ot=this.Cmp.id_orden_trabajo.lastSelectionText;
                var suborden=this.Cmp.id_suborden.lastSelectionText;
                var nro_tram=this.Cmp.nro_tramite.lastSelectionText;
                var nro_tram_aux=this.Cmp.nro_tramite_aux.lastSelectionText;
                var cerrar= this.Cmp.cerrado.getValue();
                var cbte_cierre= this.Cmp.cbte_cierre.getValue();
                this.onEnablePanel(this.idContenedor + '-east',*/
                   /* Ext.apply(parametros,{
                        'gest': gest,
                        'dpto': dpto,
                        'tpocuenta': tpocuenta,
                        'subtpocuenta': subtpocuenta,
                        'cuenta': cuenta,
                        'auxiliar': auxiliar,
                        'partida': partida,
                        'tcc' : tcc,
                        'cc' : cc,
                        'ot' : ot,
                        'suborden' : suborden,
                        'nro_tram' : nro_tram,
                        'nro_tram_aux' : nro_tram_aux,
                        'cerrar':cerrar,
                        'cbte_cierre':cbte_cierre
                    }));*/
            }
        },
        iniciarEvento:function () {
            this.ocultarComponente(this.Cmp.desde);
            this.ocultarComponente(this.Cmp.hasta);
            this.mostrarComponente(this.Cmp.id_gestion);

            this.Cmp.tipo_filtro.on('change', function(cmp, check){
                if(check.getRawValue() !== 'periodo'){
                    this.Cmp.id_gestion.reset();
                    this.mostrarComponente(this.Cmp.desde);
                    this.mostrarComponente(this.Cmp.hasta);
                    this.ocultarComponente(this.Cmp.id_gestion);
                    this.ocultarComponente(this.Cmp.id_periodo);
                }
                else{
                    this.ocultarComponente(this.Cmp.desde);
                    this.ocultarComponente(this.Cmp.hasta);
                    this.mostrarComponente(this.Cmp.id_gestion);
                }
            }, this);
        },
        loadValoresIniciales: function(){
            Phx.vista.FormularioTransaccion.superclass.loadValoresIniciales.call(this);
        }

    })
</script>
