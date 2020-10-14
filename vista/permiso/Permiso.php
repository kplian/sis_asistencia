<?php
/**
 *@package pXP
 *@file gen-Permiso.php
 *@author  (miguel.mamani)
 *@date 16-10-2019 13:14:05
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
#0				16-10-2019				 (miguel.mamani)				CREACION

 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.Permiso=Ext.extend(Phx.gridInterfaz,{
            constructor:function(config){
                this.maestro=config.maestro;
                //llama al constructor de la clase padre
                Phx.vista.Permiso.superclass.constructor.call(this,config);
                this.init();
                this.finCons = true;

                this.addButton('btn_atras',{grupo:[3],
                    argument: { estado: 'anterior'},
                    text:'Anterior',
                    iconCls: 'batras',
                    disabled:true,
                    handler:this.onAtras,
                    tooltip: '<b>Pasar al Anterior Estado</b>'});

                this.addButton('btn_siguiente',{grupo:[0,3],
                    text:'Siguiente',
                    iconCls: 'badelante',
                    disabled:true,
                    handler:this.onSiguiente,
                    tooltip: '<b>Siguiente</b><p>Hola</p>'});

                this.addBotonesGantt();

                this.onFormulario();
                this.load({params:{start:0, limit:this.tam_pag}})
            },

            Atributos:[
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_permiso'
                    },
                    type:'Field',
                    form:true
                },
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_proceso_wf'
                    },
                    type:'Field',
                    form:true
                },
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_estado_wf'
                    },
                    type:'Field',
                    form:true
                },
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'asignar_rango'
                    },
                    type:'Field',
                    form:true
                },
                {
                    config:{
                        name: 'nro_tramite',
                        fieldLabel: 'Nro Tramite',
                        allowBlank: true,
                        width: 250,
                        gwidth: 150
                    },
                    type:'TextField',
                    filters:{pfiltro:'pmo.nro_tramite',type:'string'},
                    id_grupo:0,
                    grid:true,
                    form:false
                },
                {
                    config:{
                        name: 'estado',
                        fieldLabel: 'Estado',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 80,
                        maxLength:50
                    },
                    type:'TextField',
                    filters:{pfiltro:'pmo.estado',type:'string'},
                    id_grupo:0,
                    grid:true,
                    form:false
                },
                {
                    config:{
                        name:'id_funcionario',
                        hiddenName: 'id_funcionario',
                        origen:'FUNCIONARIOCAR',
                        fieldLabel:'Funcionario',
                        allowBlank:false,
                        width: 300,
                        gwidth:200,
                        valueField: 'id_funcionario',
                        gdisplayField: 'desc_funcionario',
                        baseParams: {par_filtro: 'id_funcionario#desc_funcionario1#codigo',es_combo_solicitud : 'si'},
                        renderer:function(value, p, record){return String.format('{0}', record.data['desc_funcionario']);}
                    },
                    type:'ComboRec',//ComboRec
                    id_grupo:0,
                    filters:{pfiltro:'fun.desc_funcionario1',type:'string'},
                    bottom_filter:false,
                    grid:true,
                    form:true
                },
                {
                    config: {
                        name: 'id_tipo_permiso',
                        fieldLabel: 'Tipo Permiso',
                        allowBlank: false,
                        emptyText: 'Elija una opción...',
                        store: new Ext.data.JsonStore({
                            url: '../../sis_asistencia/control/TipoPermiso/listarTipoPermiso',
                            id: 'id_tipo_permiso',
                            root: 'datos',
                            sortInfo: {
                                field: 'nombre',
                                direction: 'ASC'
                            },
                            totalProperty: 'total',
                            fields: ['id_tipo_permiso', 'nombre', 'codigo','documento','reposcion','tiempo','rango'],
                            remoteSort: true,
                            baseParams: {par_filtro: 'tpo.nombre#tpo.codigo'}
                        }),
                        valueField: 'id_tipo_permiso',
                        displayField: 'nombre',
                        gdisplayField: 'desc_tipo_permiso',
                        hiddenName: 'id_tipo_permiso',
                        forceSelection: true,
                        typeAhead: false,
                        triggerAction: 'all',
                        lazyRender: true,
                        mode: 'remote',
                        pageSize: 15,
                        queryDelay: 1000,
                        width: 300,
                        gwidth: 150,
                        minChars: 2,
                        renderer : function(value, p, record) {
                            return String.format('{0}', record.data['desc_tipo_permiso']);
                        }
                    },
                    type: 'ComboBox',
                    id_grupo: 0,
                    filters: {pfiltro: 'movtip.nombre',type: 'string'},
                    grid: true,
                    form: true
                },
                {
                    config:{
                        name: 'fecha_solicitud',
                        fieldLabel: 'Fecha Permiso',
                        allowBlank: false,
                        width: 130,
                        gwidth: 100,
                        format: 'd/m/Y',
                        disabledDays:  [0, 6],
                        renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
                    },
                    type:'DateField',
                    filters:{pfiltro:'pmo.fecha_solicitud',type:'date'},
                    id_grupo:0,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'hro_desde',
                        fieldLabel: 'Desde',
                        allowBlank: false,
                        increment: 10,
                        minValue: '00:00:00',
                        maxValue: '23:55:00',
                        width: 100,
                        format: 'H:i:s',
                        renderer:function (value,p,record){return value?value.dateFormat('H:i:s'):''}
                    },
                    type:'TimeField',
                    id_grupo:0,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'hro_hasta',
                        fieldLabel: 'Hasta',
                        allowBlank: false,
                        increment: 10,
                        minValue: '00:00:00',
                        maxValue: '23:55:00',
                        width: 100,
                        format: 'H:i:s',
                        renderer:function (value,p,record){return value?value.dateFormat('H:i:s'):''}
                    },
                    type:'TimeField',
                    id_grupo:0,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'hro_total_permiso',
                        fieldLabel: 'Total Hora',
                        allowBlank: true,
                        anchor: '40%',
                        gwidth: 100,
                        readOnly: true,
                        format: 'H:i:s',
                        style: 'background-image: none;',
                        renderer:function (value,p,record){ return String.format('<b><font size=2>{0}</font></b>', value?value.dateFormat('H:i:s'):'')}

                    },
                    type:'TimeField',
                    id_grupo:0,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'motivo',
                        fieldLabel: 'Motivo',
                        allowBlank: false,
                        width: 300,
                        gwidth: 250
                    },
                    type:'TextArea',
                    filters:{pfiltro:'pmo.motivo',type:'string'},
                    id_grupo:0,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'fecha_reposicion',
                        fieldLabel: 'Fecha Reposicion',
                        allowBlank: false,
                        width: 130,
                        gwidth: 100,
                        readOnly: false,
                        format: 'd/m/Y',
                        renderer:function (value,p,record){ return String.format('<b><font size=2>{0}</font></b>', value?value.dateFormat('d/m/Y'):'')}
                    },
                    type:'DateField',
                    filters:{pfiltro:'pmo.fecha_solicitud',type:'date'},
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'hro_desde_reposicion',
                        fieldLabel: 'Desde',
                        increment: 30,
                        width: 100,
                        format: 'H:i:s',
                        renderer:function (value,p,record){return value?value.dateFormat('H:i:s'):''}

                    },
                    type:'TimeField',
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'hro_hasta_reposicion',
                        fieldLabel: 'Hasta',
                        increment: 30,
                        width: 100,
                        format: 'H:i:s',
                        renderer:function (value,p,record){return value?value.dateFormat('H:i:s'):''}

                    },
                    type:'TimeField',
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'hro_total_reposicion',
                        fieldLabel: 'Total Horas Reponer',
                        anchor: '40%',
                        gwidth: 100,
                        readOnly: true,
                        format: 'H:i:s',
                        style: 'background-image: none;',
                        renderer:function (value,p,record){return value?value.dateFormat('H:i:s'):''}
                    },
                    type:'TimeField',
                    id_grupo:1,
                    grid:false,
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
                    filters:{pfiltro:'pmo.estado_reg',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },
                {
                    config:{
                        name: 'id_usuario_ai',
                        fieldLabel: '',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:4
                    },
                    type:'Field',
                    filters:{pfiltro:'pmo.id_usuario_ai',type:'numeric'},
                    id_grupo:1,
                    grid:false,
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
                        name: 'usuario_ai',
                        fieldLabel: 'Funcionaro AI',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:300
                    },
                    type:'TextField',
                    filters:{pfiltro:'pmo.usuario_ai',type:'string'},
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
                    filters:{pfiltro:'pmo.fecha_reg',type:'date'},
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
                    filters:{pfiltro:'pmo.fecha_mod',type:'date'},
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
                }
            ],
            tam_pag:50,
            title:'Permiso',
            ActSave:'../../sis_asistencia/control/Permiso/insertarPermiso',
            ActDel:'../../sis_asistencia/control/Permiso/eliminarPermiso',
            ActList:'../../sis_asistencia/control/Permiso/listarPermiso',
            id_store:'id_permiso',
            fields: [
                {name:'id_permiso', type: 'numeric'},
                {name:'nro_tramite', type: 'string'},
                {name:'id_funcionario', type: 'numeric'},
                {name:'id_estado_wf', type: 'numeric'},
                {name:'fecha_solicitud', type: 'date',dateFormat:'Y-m-d'},
                {name:'id_tipo_permiso', type: 'numeric'},
                {name:'motivo', type: 'string'},
                {name:'estado_reg', type: 'string'},
                {name:'estado', type: 'string'},
                {name:'id_proceso_wf', type: 'numeric'},
                {name:'id_usuario_ai', type: 'numeric'},
                {name:'id_usuario_reg', type: 'numeric'},
                {name:'usuario_ai', type: 'string'},
                {name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
                {name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
                {name:'id_usuario_mod', type: 'numeric'},
                {name:'usr_reg', type: 'string'},
                {name:'usr_mod', type: 'string'},

                {name:'desc_tipo_permiso', type: 'string'},
                {name:'desc_funcionario', type: 'string'},
                {name:'hro_desde',type: 'date',dateFormat:'H:i:s'},
                {name:'hro_hasta',type: 'date',dateFormat:'H:i:s'},
                {name:'asignar_rango', type: 'string'},
                {name:'documento', type: 'string'},

                {name:'fecha_reposicion', type: 'date',dateFormat:'Y-m-d'},
                {name:'hro_desde_reposicion',type: 'date',dateFormat:'H:i:s'},
                {name:'hro_hasta_reposicion',type: 'date',dateFormat:'H:i:s'},
                {name:'hro_total_permiso',type: 'date',dateFormat:'H:i:s'},
                {name:'hro_total_reposicion',type: 'date',dateFormat:'H:i:s'},

            ],
            sortInfo:{
                field: 'id_permiso',
                direction: 'ASC'
            },
            bdel:true,
            bsave:false,
            fwidth: '32%',
            // fheight: '80%',
            onFormulario:function(){
                this.ocultarComponente(this.Cmp.fecha_reposicion);
                this.ocultarComponente(this.Cmp.hro_desde_reposicion);
                this.ocultarComponente(this.Cmp.hro_hasta_reposicion);
                this.ocultarComponente(this.Cmp.hro_total_reposicion);
                this.ocultarComponente(this.Cmp.hro_desde);
                this.ocultarComponente(this.Cmp.hro_hasta);
                this.ocultarComponente(this.Cmp.hro_total_permiso);
                this.ocultarComponente(this.Cmp.motivo);
            },
            addBotonesGantt: function() {
                this.menuAdqGantt = new Ext.Toolbar.SplitButton({
                    id: 'b-diagrama_gantt-' + this.idContenedor,
                    text: 'Gantt',
                    disabled: true,
                    grupo:[0,1,2],
                    iconCls : 'bgantt',
                    handler:this.diagramGanttDinamico,
                    scope: this,
                    menu:{
                        items: [{
                            id:'b-gantti-' + this.idContenedor,
                            text: 'Gantt Imagen',
                            tooltip: '<b>Muestra un reporte gantt en formato de imagen</b>',
                            handler:this.diagramGantt,
                            scope: this
                        }, {
                            id:'b-ganttd-' + this.idContenedor,
                            text: 'Gantt Dinámico',
                            tooltip: '<b>Muestra el reporte gantt facil de entender</b>',
                            handler:this.diagramGanttDinamico,
                            scope: this
                        }
                        ]}
                });
                this.tbar.add(this.menuAdqGantt);
            },
            diagramGantt : function (){
                var data=this.sm.getSelected().data.id_proceso_wf;
                Phx.CP.loadingShow();
                Ext.Ajax.request({
                    url: '../../sis_workflow/control/ProcesoWf/diagramaGanttTramite',
                    params: { 'id_proceso_wf': data },
                    success: this.successExport,
                    failure: this.conexionFailure,
                    timeout: this.timeout,
                    scope: this
                });
            },
            preparaMenu:function(n){
                Phx.vista.Permiso.superclass.preparaMenu.call(this, n);
                this.getBoton('btn_atras').enable();
                this.getBoton('diagrama_gantt').enable();
                this.getBoton('btn_siguiente').enable();
            },
            liberaMenu:function() {
                var tb = Phx.vista.Permiso.superclass.liberaMenu.call(this);
                if (tb) {
                    this.getBoton('btn_atras').disable();
                    this.getBoton('diagrama_gantt').disable();
                    this.getBoton('btn_siguiente').disable();
                }
            },
            onButtonNew:function(){
                Phx.vista.Permiso.superclass.onButtonNew.call(this);
                this.Cmp.fecha_solicitud.setValue(new Date());
                this.Cmp.fecha_solicitud.fireEvent('change');

                this.Cmp.id_tipo_permiso.on('select', function(combo, record, index){
                    // mostrar
                    this.mostrarComponente(this.Cmp.hro_desde);
                    this.mostrarComponente(this.Cmp.hro_hasta);
                    this.mostrarComponente(this.Cmp.hro_total_permiso);
                    this.mostrarComponente(this.Cmp.motivo);
    
                    if (record.data.reposcion === 'si'){
                        this.window.setSize(490,480);
                        this.mostrarComponente(this.Cmp.fecha_reposicion);
                        this.mostrarComponente(this.Cmp.hro_desde_reposicion);
                        this.mostrarComponente(this.Cmp.hro_hasta_reposicion);
                        this.mostrarComponente(this.Cmp.hro_total_reposicion);
                    }else {
                        this.window.setSize(490,360);
                        this.ocultarComponente(this.Cmp.fecha_reposicion);
                        this.ocultarComponente(this.Cmp.hro_desde_reposicion);
                        this.ocultarComponente(this.Cmp.hro_hasta_reposicion);
                        this.ocultarComponente(this.Cmp.hro_total_reposicion);
                    }
                },this);

                this.Cmp.hro_desde.on('select', function(combo, record){
                        if (this.Cmp.hro_hasta.getValue() !== ''){
                            this.Cmp.hro_total_permiso.reset();
                            Ext.Ajax.request({
                                    url:'../../sis_asistencia/control/Permiso/calcularRango',
                                    params:{desde : record.data.field1,
                                            hasta: this.Cmp.hro_hasta.getValue(),
                                            contro: 'si'},
                                    success:function(resp){
                                        const reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
                                        this.Cmp.hro_total_permiso.setValue(reg.ROOT.datos.resultado);
                                    },
                                    failure: this.conexionFailure,
                                    timeout:this.timeout,
                                    scope:this
                            });
                        }
                },this);

                this.Cmp.hro_hasta.on('select', function(combo, record){
                    if (this.Cmp.hro_desde.getValue() !== ''){
                        this.Cmp.hro_total_permiso.reset();
                        Ext.Ajax.request({
                                    url:'../../sis_asistencia/control/Permiso/calcularRango',
                                    params:{desde : this.Cmp.hro_desde.getValue(),
                                            hasta: record.data.field1,
                                            contro: 'si'},
                                    success:function(resp){
                                        const reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));                                      
                                        this.Cmp.hro_total_permiso.setValue(reg.ROOT.datos.resultado);
                                    },
                                    failure: this.conexionFailure,
                                    timeout:this.timeout,
                                    scope:this
                            });
                    }
                },this);

                this.Cmp.hro_desde_reposicion.on('select', function(combo, record, index){
                    if (this.Cmp.hro_hasta_reposicion.getValue() !== ''){
                            this.Cmp.hro_total_reposicion.reset();
                            Ext.Ajax.request({
                                    url:'../../sis_asistencia/control/Permiso/calcularRango',
                                    params:{desde : record.data.field1,
                                            hasta: this.Cmp.hro_hasta_reposicion.getValue(),
                                            contro: 'no'},
                                    success:function(resp){
                                        const reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
                                        this.Cmp.hro_total_reposicion.setValue(reg.ROOT.datos.resultado);
                                    },
                                    failure: this.conexionFailure,
                                    timeout:this.timeout,
                                    scope:this
                            });
                        }
                },this);

                this.Cmp.hro_hasta_reposicion.on('select', function(combo, record, index){
                    if (this.Cmp.hro_desde_reposicion.getValue() !== ''){
                        this.Cmp.hro_total_reposicion.reset();
                        Ext.Ajax.request({
                                    url:'../../sis_asistencia/control/Permiso/calcularRango',
                                    params:{desde : this.Cmp.hro_desde_reposicion.getValue(),
                                            hasta: record.data.field1,
                                            contro: 'no'},
                                    success:function(resp){
                                        const reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
                                        this.Cmp.hro_total_reposicion.setValue(reg.ROOT.datos.resultado);
                                    },
                                    failure: this.conexionFailure,
                                    timeout:this.timeout,
                                    scope:this
                            });
                    }
                },this);
                
                this.Cmp.id_funcionario.store.load({params:{start:0,limit:this.tam_pag},
                    callback : function (r) {
                        this.Cmp.id_funcionario.setValue(r[0].data.id_funcionario);
                        this.Cmp.id_funcionario.fireEvent('select', this.Cmp.id_funcionario, r[0]);
                        this.Cmp.id_funcionario.collapse();
                    }, scope : this
                });

            },
            onButtonEdit:function(){
                Phx.vista.Permiso.superclass.onButtonEdit.call(this);
                this.mostrarComponente(this.Cmp.hro_desde);
                this.mostrarComponente(this.Cmp.hro_hasta);
            },
            onAtras :function (res) {
                var rec=this.sm.getSelected();
                Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/AntFormEstadoWf.php',
                    'Estado de Wf',
                    {
                        modal:true,
                        width:450,
                        height:250
                    }, { data:rec.data, estado_destino: res.argument.estado}, this.idContenedor,'AntFormEstadoWf',
                    {
                        config:[{
                            event:'beforesave',
                            delegate: this.onAntEstado
                        }
                        ],
                        scope:this
                    })
            },
            onAntEstado: function(wizard,resp){
                Phx.CP.loadingShow();
                Ext.Ajax.request({
                    url:'../../sis_asistencia/control/Permiso/anteriorEstado',
                    params:{
                        id_proceso_wf: resp.id_proceso_wf,
                        id_estado_wf:  resp.id_estado_wf,
                        obs: resp.obs,
                        estado_destino: resp.estado_destino
                    },
                    argument:{wizard:wizard},
                    success:this.successEstadoSinc,
                    failure: this.conexionFailure,
                    timeout:this.timeout,
                    scope:this
                });
            },
            successEstadoSinc:function(resp){
                Phx.CP.loadingHide();
                resp.argument.wizard.panel.destroy();
                this.reload();
            },
            onSiguiente :function () {
                var rec = this.sm.getSelected(); //obtine los datos selecionado en la grilla
                this.objWizard = Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/FormEstadoWf.php',
                    'Estado de Wf',
                    {
                        modal: true,
                        width: 700,
                        height: 450
                    },
                    {
                        data: {
                            id_estado_wf: rec.data.id_estado_wf,
                            id_proceso_wf: rec.data.id_proceso_wf
                        }
                    }, this.idContenedor, 'FormEstadoWf',
                    {
                        config: [{
                            event: 'beforesave',
                            delegate: this.onSaveWizard
                        }],
                        scope: this
                    }
                );
            },
            onSaveWizard:function(wizard,resp){
                var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
                Phx.CP.loadingShow();
                Ext.Ajax.request({
                    url:'../../sis_asistencia/control/Permiso/siguienteEstado',
                    params:{
                        id_proceso_wf_act:  resp.id_proceso_wf_act,
                        id_estado_wf_act:   resp.id_estado_wf_act,
                        id_tipo_estado:     resp.id_tipo_estado,
                        id_funcionario_wf:  resp.id_funcionario_wf,
                        id_depto_wf:        resp.id_depto_wf,
                        obs:                resp.obs,
                        json_procesos:      Ext.util.JSON.encode(resp.procesos)
                    },
                    success:this.successWizard,
                    failure: this.conexionFailure,
                    argument:{wizard:wizard},
                    timeout:this.timeout,
                    scope:this
                });
            },
            successWizard:function(resp){
                Phx.CP.loadingHide();
                resp.argument.wizard.panel.destroy();
                this.reload();
            },
        }
    )
</script>
