<?php
/**
 *@package pXP
 *@file gen-Pares.php
 *@author  (mgarcia)
 *@date 19-09-2019 16:00:52
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
#0				19-09-2019				 (mgarcia)				CREACION

 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.Pares=Ext.extend(Phx.gridInterfaz,{
            id_par : null,
            constructor:function(config){
                this.initButtons=[this.cmbGestion, this.cmbPeriodo];
                this.maestro=config.maestro;

                //llama al constructor de la clase padre
                Phx.vista.Pares.superclass.constructor.call(this,config);
                var id;
                if (Phx.CP.config_ini.id_funcionario !== ''){
                    id = Phx.CP.config_ini.id_funcionario;
                }else {
                    id = null;
                }
                this.store.baseParams = {id_funcionario: id};
                this.init();

                this.cmbGestion.on('select', function(combo, record, index){
                    this.tmpGestion = record.data.gestion;
                    this.cmbPeriodo.enable();
                    this.cmbPeriodo.reset();
                    this.store.removeAll();
                    this.cmbPeriodo.store.baseParams = Ext.apply(this.cmbPeriodo.store.baseParams, {id_gestion: this.cmbGestion.getValue()});
                    this.cmbPeriodo.modificado = true;
                },this);
                this.cmbPeriodo.on('select', function( combo, record, index){
                    this.tmpPeriodo = record.data.periodo;
                    this.capturaFiltros();
                },this);
                this.addButton('btnManual',{
                        text: 'Asistencia',
                        iconCls: 'bchecklist',
                        disabled: false,
                        handler: this.armaManual,
                        tooltip: '<b>Asistencia</b><br/>Asignas tus marca del biometrico para generar tu hoja de tiempo'
                });
                this.addButton('justificarMarca', {
                    text: 'Justificar Marcar',
                    iconCls: 'bsee',
                    disabled: true,
                    handler: this.onJustificar,
                    tooltip: '<b>Justificar</b><br/>Marca no encontrada'
                });
                this.addButton('btnHojaTiempo',{
                        text: 'Generar Hoja de tiempo',
                        iconCls: 'badelante',
                        disabled: false,
                        handler: this.onCalcularHrs,
                        tooltip: '<b>Generar pares</b><br/>Trae los marcados segun periodo seleccionado'
                    }
                );
                /*
                this.addButton('RegistrarLicencia', {
                    text: 'Registrar Licencia',
                    iconCls: 'bsee',
                    disabled: false,
                    handler: this.BRegistrarLicencia,
                    tooltip: '<b>Registrar Licencia</b><br/>Permite registrar una licencia'
                });
                */
                this.crearFormExtra();
            },

            Atributos:[
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_pares'
                    },
                    type:'Field',
                    form:true
                },
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_transaccion_ini'
                    },
                    type:'Field',
                    form:true
                },
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'desc_dia'
                    },
                    type:'Field',
                    form:true
                },
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_transaccion_fin'
                    },
                    type:'Field',
                    form:true
                },
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_funcionario'
                    },
                    type:'Field',
                    form:true
                },
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_licencia'
                    },
                    type:'Field',
                    form:true
                },
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_vacacion'
                    },
                    type:'Field',
                    form:true
                },
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_viatico'
                    },
                    type:'Field',
                    form:true
                },
                {
                    config:{
                        name: 'dia',
                        fieldLabel: 'Dia',
                        allowBlank: true,
                        anchor: '50%',
                        gwidth: 50
                    },
                    type:'TextField',
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'hora',
                        fieldLabel: 'Hora',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 150,
                        renderer:function(value, p, record){
                            var color;

                            if (record.data.rango == 'no'){
                                color = '#b8271d';
                            }
                            else if (record.data.desc_dia == 0 || record.data.desc_dia == 6){
                                color = '#1320b8';
                            }
                            else{
                                color = '#2e8e10';
                            }
                            return String.format('<b><font size = 1 color="'+color+'" >{0}</font></b>', value);
                        }
                    },
                    type:'TextField',
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'evento',
                        fieldLabel: 'Evento',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100
                    },
                    type:'TextField',
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'descripcion',
                        fieldLabel: 'Rango',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 130
                    },
                    type:'TextField',
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'tipo_verificacion',
                        fieldLabel: 'Tipo Verificacion',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 250,
                        renderer: function(value, metaData, record, rowIndex, colIndex, store) {
                            metaData.css = 'multilineColumn';
                            return String.format('<div class="gridmultiline">{0}</div>', value);//#4
                        }

                    },
                    type:'TextField',
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'desc_motivo',
                        fieldLabel: 'Descripcion',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 300
                    },
                    type:'TextField',
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'obs',
                        fieldLabel: 'Observaciones',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 150
                    },
                    type:'TextField',
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'desc_funcionario',
                        fieldLabel: 'Funcionario',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 200
                    },
                    type:'TextField',
                    filters:{pfiltro:'vfun.desc_funcionario',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:true
                },

                {
                    config:{
                        name: 'fecha_marcado',
                        fieldLabel: 'Fecha Marcado',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100/*,
                        format: 'd/m/Y',
                        renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}*/
                    },
                    type:'TextField',
                    filters:{pfiltro:'par.fecha_marcado',type:'date'},
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'estado_reg',
                        fieldLabel: 'Estado Reg.',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:10
                    },
                    type:'TextField',
                    filters:{pfiltro:'par.estado_reg',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },
                {
                    config:{
                        name: 'usr_reg',
                        fieldLabel: 'Creado por',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:4
                    },
                    type:'Field',
                    filters:{pfiltro:'usu1.cuenta',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },
                {
                    config:{
                        name: 'fecha_reg',
                        fieldLabel: 'Fecha creación',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        format: 'd/m/Y',
                        renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
                    },
                    type:'DateField',
                    filters:{pfiltro:'par.fecha_reg',type:'date'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },
                {
                    config:{
                        name: 'id_usuario_ai',
                        fieldLabel: 'Fecha creación',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:4
                    },
                    type:'Field',
                    filters:{pfiltro:'par.id_usuario_ai',type:'numeric'},
                    id_grupo:1,
                    grid:false,
                    form:false
                },
                {
                    config:{
                        name: 'usuario_ai',
                        fieldLabel: 'Funcionaro AI',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:300
                    },
                    type:'TextField',
                    filters:{pfiltro:'par.usuario_ai',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },
                {
                    config:{
                        name: 'usr_mod',
                        fieldLabel: 'Modificado por',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:4
                    },
                    type:'Field',
                    filters:{pfiltro:'usu2.cuenta',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },
                {
                    config:{
                        name: 'fecha_mod',
                        fieldLabel: 'Fecha Modif.',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        format: 'd/m/Y',
                        renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
                    },
                    type:'DateField',
                    filters:{pfiltro:'par.fecha_mod',type:'date'},
                    id_grupo:1,
                    grid:true,
                    form:false
                }
            ],
            tam_pag:100,
            title:'Marcados Pares',
            ActSave:'../../sis_asistencia/control/Pares/insertarPares',
            ActDel:'../../sis_asistencia/control/Pares/eliminarPares',
            ActList:'../../sis_asistencia/control/Pares/listarPares',
            id_store:'id_pares',
            fields: [
                {name:'id_pares', type: 'numeric'},
                {name:'estado_reg', type: 'string'},
                {name:'id_transaccion_ini', type: 'numeric'},
                {name:'id_transaccion_fin', type: 'numeric'},
                {name:'fecha_marcado', type: 'string'},
                {name:'id_funcionario', type: 'numeric'},
                {name:'id_licencia', type: 'numeric'},
                {name:'id_vacacion', type: 'numeric'},
                {name:'id_viatico', type: 'numeric'},
                {name:'id_usuario_reg', type: 'numeric'},
                {name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
                {name:'id_usuario_ai', type: 'numeric'},
                {name:'usuario_ai', type: 'string'},
                {name:'id_usuario_mod', type: 'numeric'},
                {name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
                {name:'usr_reg', type: 'string'},
                {name:'usr_mod', type: 'string'},
                {name:'dia', type: 'numeric'},
                {name:'hora', type: 'string'},
                {name:'evento', type: 'string'},

                {name:'tipo_verificacion', type: 'string'},
                {name:'obs', type: 'string'},
                {name:'descripcion', type: 'string'},
                {name:'rango', type: 'string'},
                {name:'desc_funcionario', type: 'string'},
                {name:'desc_motivo', type: 'string'},
                {name:'desc_dia', type: 'numeric'}

            ],
            sortInfo:{
                field: 'fecha_marcado',
                direction: 'ASC'
            },
            bdel:false,
            bsave:false,
            bedit:false,
            bnew:false,
            tipoStore: 'GroupingStore',//GroupingStore o JsonStore #
            remoteGroup: true,
            groupField: 'fecha_marcado',
            viewGrid: new Ext.grid.GroupingView({
                forceFit: false
                // custom grouping text template to display the number of items per group
                //groupTextTpl: '{text} ({[values.rs.length]} {[values.rs.length > 1 ? "Items" : "Item"]})'
            }),
            BRegistrarLicencia: function () {
                var rec = this.sm.getSelected();
                Phx.CP.loadWindows('../../../sis_asistencia/vista/pares/RegistrarLicencia.php',
                    'Solicitud Licencia',
                    {
                        modal: true,
                        width: 500,
                        height: 250
                    }, rec.data, this.idContenedor, 'RegistrarLicencia')
            },
            capturaFiltros:function(){
                // this.desbloquearOrdenamientoGrid();
                if(this.validarFiltros()){
                    this.store.baseParams.id_periodo = this.cmbPeriodo.getValue();

                    this.load();
                }
            },
            validarFiltros:function(){
                if(this.cmbGestion.validate() && this.cmbPeriodo.validate()){
                    return true;
                } else{
                    return false;
                }
            },
            armaManual:function () {
                if(this.validarFiltros()) {
                    Phx.CP.loadingShow();

                    Phx.CP.loadWindows('../../../sis_asistencia/vista/transaccion/TransaccionMarcar.php',
                        'Marcaciones Biometrico', {
                            width:'80%',
                            height:'95%'
                        },{
                            periodo: this.tmpPeriodo,
                            id_periodo:this.cmbPeriodo.getValue()
                        },
                        this.idContenedor,
                        'TransaccionMarcar');
                        Phx.CP.loadingHide();
                }else {
                    alert('Seleccione la gestion y el periodo');
                }
            },
            armarPares:function () {
                if(this.validarFiltros()) {
                    Phx.CP.loadingShow();
                    var id_funcionario = null;
                    if (Phx.CP.config_ini.id_funcionario !== ''){
                        id_funcionario = Phx.CP.config_ini.id_funcionario;
                    }
                    Ext.Ajax.request({
                        url: '../../sis_asistencia/control/Pares/armarPares',
                        params: {
                                 id_periodo: this.cmbPeriodo.getValue(),
                                 id_funcionario: id_funcionario
                        },
                        success: this.success,
                        failure: this.conexionFailure,
                        timeout: this.timeout,
                        scope: this
                    });

                }else{
                    alert('Seleccione la gestion y el periodo');
                }
            },
            success: function(resp){
                Phx.CP.loadingHide();
                var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
                this.reload();
            },
            preparaMenu: function(n) {
                const rec = this.getSelectedData();
                if (rec.rango === 'no'){
                    // this.getBoton('RegistrarLicencia').enable();
                    this.getBoton('justificarMarca').enable();
                }
            },
            liberaMenu:function(){
                const tb = Phx.vista.Pares.superclass.liberaMenu.call(this);
                if(tb){
                    // this.getBoton('RegistrarLicencia').disable();
                    this.getBoton('justificarMarca').disable();
                }
                return tb
            },
            onCalcularHrs :function () {
                Phx.CP.loadingShow();
                var id_funcionario = null;
                var id_proceso_wf = null;
                var id_estado_wf = null;
                if (Phx.CP.config_ini.id_funcionario !== ''){
                    id_funcionario = Phx.CP.config_ini.id_funcionario;
                }
                Ext.Ajax.request({
                    url: '../../sis_asistencia/control/Pares/getht',
                    params: {id_periodo: this.cmbPeriodo.getValue(), id_funcionario: id_funcionario},
                    success:function(resp){
                        var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
                        if(reg.ROOT.datos){
                            id_proceso_wf = reg.ROOT.datos.id_proceso_wf;
                            id_estado_wf = reg.ROOT.datos.id_estado_wf;
                            var m = this;
                            Phx.CP.loadWindows('../../../sis_asistencia/vista/mes_trabajo_det/MesTrabajoDetBio.php',
                                'Hoja de Tiempo', {
                                    width:'80%',
                                    height:'95%'
                                }, {
                                    funcionarioID: id_funcionario,
                                    periodoID: m.cmbPeriodo.getValue(),
                                    proceso_wfID: id_proceso_wf,
                                    estado_wfID :id_estado_wf
                                },
                                this.idContenedor,
                                'MesTrabajoDetBio');
                            Phx.CP.loadingHide();

                        }
                    },
                    failure: this.conexionFailure,
                    timeout: this.timeout,
                    scope: this
                });
            },
            onJustificar:function(){
                const data = this.getSelectedData();
                this.cmpfecha_marcado.setValue(data.fecha_marcado);
                this.cmphora.setValue(data.hora);
                this.cmpevento.setValue(data.evento);
                this.cmpdescripcion.setValue(data.descripcion);
                this.cmptipo_verificacion.setValue(data.tipo_verificacion);
                this.id_par = data.id_pares;
                this.ventanaExtra.show();
            },
            crearFormExtra:function(){
                const fecha_marcado = new Ext.form.TextField({
                    name: 'fecha_marcado',
                    msgTarget: 'title',
                    fieldLabel: 'Fecha Marcado',
                    allowBlank: true,
                    anchor: '90%',
                    readOnly: true,
                    style: 'background-image: none; background: #A7EB8D;'
                });
                const hora = new Ext.form.TextField({
                    name: 'hora',
                    msgTarget: 'title',
                    fieldLabel: 'Hora',
                    allowBlank: true,
                    anchor: '90%',
                    readOnly: true,
                    style: 'background-image: none; background: #A7EB8D;'
                });
                const evento = new Ext.form.TextField({
                    name: 'evento',
                    msgTarget: 'title',
                    fieldLabel: 'Evento',
                    allowBlank: true,
                    anchor: '90%',
                    readOnly: true,
                    style: 'background-image: none; background: #A7EB8D;'
                });
                const descripcion = new Ext.form.TextField({
                    name: 'descripcion',
                    msgTarget: 'title',
                    fieldLabel: 'Rango',
                    allowBlank: true,
                    anchor: '90%',
                    readOnly: true,
                    style: 'background-image: none; background: #A7EB8D;'
                });
                const tipo_verificacion = new Ext.form.TextField({
                    name: 'tipo_verificacion',
                    msgTarget: 'title',
                    fieldLabel: 'Tipo Verificacion',
                    allowBlank: true,
                    anchor: '90%',
                    readOnly: true,
                    style: 'background-image: none; background: #E6EB8D;'

                });
                const justificar = new Ext.form.TextArea({
                    name: 'justificar',
                    msgTarget: 'title',
                    fieldLabel: 'Justificar',
                    allowBlank: true,
                    anchor: '90%',
                    // maxLength:50
                });
                this.formExtra = new Ext.form.FormPanel({
                    baseCls: 'x-plain',
                    autoDestroy: true,
                    border: false,
                    layout: 'form',
                    autoHeight: true,
                    items: [fecha_marcado,hora,evento,descripcion,tipo_verificacion,justificar]
                });
                this.ventanaExtra = new Ext.Window({
                    title: 'Formulario Justificar Marcas no Encontrados',
                    collapsible: true,
                    maximizable: true,
                    autoDestroy: true,
                    width: 450,
                    height: 300,
                    layout: 'fit',
                    plain: true,
                    bodyStyle: 'padding:5px;',
                    buttonAlign: 'center',
                    items: this.formExtra,
                    modal:true,
                    closeAction: 'hide',
                    buttons: [{
                        text: 'Guardar',
                        handler: this.saveExtra,
                        scope: this},
                        {
                            text: 'Cancelar',
                            handler: function(){ this.ventanaExtra.hide() },
                            scope: this
                        }]
                });
                this.cmpfecha_marcado = this.formExtra.getForm().findField('fecha_marcado');
                this.cmphora = this.formExtra.getForm().findField('hora');
                this.cmpevento = this.formExtra.getForm().findField('evento');
                this.cmpdescripcion = this.formExtra.getForm().findField('descripcion');
                this.cmptipo_verificacion = this.formExtra.getForm().findField('tipo_verificacion');
                this.cmpjustificar = this.formExtra.getForm().findField('justificar');

            },
            saveExtra:function () {
                Phx.CP.loadingShow();
                Ext.Ajax.request({
                    url: '../../sis_asistencia/control/Pares/justificarPares',
                    params: {
                        id_pares:  this.id_par,
                        justificar: this.cmpjustificar
                    },
                    success: this.successSincExtra,
                    failure: this.conexionFailure,
                    timeout: this.timeout,
                    scope: this
                });
            },
            successSincExtra:function(resp){
                Phx.CP.loadingHide();
                var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
                if(!reg.ROOT.error){
                    if(this.ventanaExtra){
                        this.ventanaExtra.hide();
                    }
                    this.lista = [];
                    this.load({params: {start: 0, limit: this.tam_pag}});
                    this.cmpjustificar.setValue(null);
                }else{
                    alert('ocurrio un error durante el proceso')
                }
            },
            cmbGestion: new Ext.form.ComboBox({
                fieldLabel: 'Gestion',
                allowBlank: false,
                emptyText:'Gestion...',
                blankText: 'Año',
                store:new Ext.data.JsonStore(
                    {
                        url: '../../sis_parametros/control/Gestion/listarGestion',
                        id: 'id_gestion',
                        root: 'datos',
                        sortInfo:{
                            field: 'gestion',
                            direction: 'DESC'
                        },
                        totalProperty: 'total',
                        fields: ['id_gestion','gestion'],
                        // turn on remote sorting
                        remoteSort: true,
                        baseParams:{par_filtro:'gestion'}
                    }),
                valueField: 'id_gestion',
                triggerAction: 'all',
                displayField: 'gestion',
                hiddenName: 'id_gestion',
                mode:'remote',
                pageSize:50,
                queryDelay:500,
                listWidth:'280',
                width:80
            }),
            cmbPeriodo: new Ext.form.ComboBox({
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
                disabled: true,
                queryDelay:500,
                listWidth:'280',
                width:100
            })

        }
    )
</script>
