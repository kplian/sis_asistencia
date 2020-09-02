<?php
/**
 *@package pXP
 *@file gen-Vacacion.php
 *@author  (apinto)
 *@date 01-10-2019 15:29:35
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
#0				01-10-2019				 (apinto)				CREACION

 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.Vacacion=Ext.extend(Phx.gridInterfaz,{

        constructor:function(config){
            this.maestro=config.maestro;
            //llama al constructor de la clase padre
            Phx.vista.Vacacion.superclass.constructor.call(this,config);
            this.init();
            this.finCons = true;
            this.addButton('btn_atras',{    grupo:[3],
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
                tooltip: '<b>Siguiente</b><p>cambia de estado</p>'});
            this.addBotonesGantt();
            this.addButton('btn_cancelar',{grupo:[2],
                text:'Cancelar',
                iconCls: 'bassign',
                disabled:true,
                handler:this.onCancelar,
                tooltip: '<b>Cancelar</b><p>la vacacion en caso que no tomara </p>'});
            this.iniciarEventos();
            // this.diasEfectivo(); //-->Función definida para el calculo de los dias efectivos
        },

        iniciarEventos: function(){

            this.Cmp.fecha_inicio.on('select', function (Fecha, dato) {
                Ext.Ajax.request({
                    url: '../../sis_asistencia/control/Vacacion/getDias', //llamando a la funcion getDias.
                    params: {
                        'fecha_fin': this.Cmp.fecha_fin.getValue(),
                        'fecha_inicio': Fecha.getValue(),
                        'dias': 0,

                        'medios_dias':  '',

                    },
                    success: this.respuestaValidacion,
                    failure: this.conexionFailure,
                    timeout: this.timeout,
                    scope: this
                });


            }, this);
            this.Cmp.fecha_fin.on('select', function (Fecha, dato) {
                Ext.Ajax.request({
                    url: '../../sis_asistencia/control/Vacacion/getDias', //llamando a la funcion getDias.
                    params: {
                        'fecha_fin': Fecha.getValue(),
                        'fecha_inicio': this.Cmp.fecha_inicio.getValue(),
                        'dias': 0,

                        'medios_dias':  '',

                    },
                    success: this.respuestaValidacion,
                    failure: this.conexionFailure,
                    timeout: this.timeout,
                    scope: this
                });


            }, this);
        },
        arrayStore :{
            'Selección':[
                ['',''],
            ],
            'Selección2':[ ],
        },
        respuestaValidacion: function (s,m){

            this.maestro = m;
            // console.log('Prueba de parametros1', s.responseText);
            var respuesta_valid = s.responseText.split('%');
            //console.log('Prueba de parametros2', respuesta_valid[1]);
            this.Cmp.dias_efectivo.setValue(respuesta_valid[1]); //dias

            this.arrayStore.Selección=[];
            this.arrayStore.Selección=['',''];
            for(var i=0; i<=parseInt(respuesta_valid[1]); i++){
                this.arrayStore.Selección[i]=["ID"+(i),(i)];
            }
            console.log(this.arrayStore);
            // this.Cmp.medio_dia.reset(); /// restablecer el campo evento_medios_dias, cada que se cambia el rango de fechas.
            // this.Cmp.medio_dia.store.loadData(this.arrayStore.Selección);
            this.Cmp.dias.reset(); /// dias_efectivo
            this.Cmp.dias.setValue(this.Cmp.dias_efectivo.getValue()); //diasdias_efectivo; dias


        },
        Atributos:[
            {
                //configuracion del componente
                config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id_vacacion'
                },
                type:'Field',
                form:true
            },{
                //configuracion del componente
                config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id_proceso_wf'
                },
                type:'Field',
                form:true
            },{
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
                config:{
                    name: 'nro_tramite',
                    fieldLabel: 'Nro Tramite',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 130,
                    maxLength:10
                },
                type:'TextField',
                filters:{pfiltro:'vac.nro_tramite',type:'string'},
                id_grupo:1,
                grid:true,
                form:false
            },{
                config:{
                    name: 'estado',
                    fieldLabel: 'Estado',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 80,
                    maxLength:10
                },
                type:'TextField',
                filters:{pfiltro:'vac.estado',type:'string'},
                id_grupo:1,
                grid:true,
                form:false
            },
            {
                config:{
                    name: 'evento',
                    fieldLabel: 'Evento',
                    allowBlank: true,
                    anchor: '70%',
                    gwidth: 100,
                    readOnly :true,
                    style: 'background-color: #F2F1F0; background-image: none;',
                    renderer:function (value,p,record){
                        return String.format('{0}', value);
                    }
                },
                type:'TextField',
                id_grupo:0,
                grid:false,
                form:true
            },
            {

                config:{
                    name: 'saldo',
                    fieldLabel: 'Saldo',
                    allowBlank: true,
                    anchor: '40%',
                    gwidth: 100,
                    readOnly :true,
                    style: 'background-color: #F2F1F0; background-image: none;'
                },
                type:'NumberField',
                id_grupo:0,
                grid:false,
                form:true,
            },
            {
                config:{
                    name:'id_funcionario',
                    hiddenName: 'id_funcionario',
                    origen:'FUNCIONARIOCAR',
                    fieldLabel:'Funcionario',
                    allowBlank:false,
                    anchor: '70%',
                    gwidth:200,
                    valueField: 'id_funcionario',
                    gdisplayField: 'desc_funcionario1',
                    baseParams: {par_filtro: 'id_funcionario#desc_funcionario1#codigo',es_combo_solicitud : 'si'},
                    renderer:function(value, p, record){return String.format('{0}', record.data['desc_funcionario1']);}
                },
                type:'ComboRec',//ComboRec
                id_grupo:1,
                filters:{pfiltro:'vf.desc_funcionario1',type:'string'},
                bottom_filter:true,
                grid:true,
                form:true,

            },
            {
                config:{
                    name: 'fecha_inicio',
                    fieldLabel: 'Fecha Inicio',
                    allowBlank: false,
                    anchor: '70%',
                    gwidth: 100,
                    format: 'd/m/Y',
                    disabledDays:  [0, 6],
                    renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
                },
                type:'DateField',
                filters:{pfiltro:'vac.fecha_inicio',type:'date'},
                id_grupo:1,
                grid:true,
                form:true
            },
            {
                config:{
                    name: 'fecha_fin',
                    fieldLabel: 'Fecha Fin',
                    allowBlank: false,
                    anchor: '70%',
                    gwidth: 100,
                    format: 'd/m/Y',
                    disabledDays:  [0, 6],
                    renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
                },
                type:'DateField',
                filters:{pfiltro:'vac.fecha_fin',type:'date'},
                id_grupo:1,
                grid:true,
                form:true
            },
            {
                config:{
                    name: 'dias_efectivo',
                    fieldLabel: 'Días Calendario',
                    allowBlank: true,
                    anchor: '35%',
                    gwidth: 100,
                    maxLength:4,
                    readOnly :true,
                    style: 'background-color: #F2F1F0; background-image: none;',
                    renderer:function (value,p,record){return String.format('<b>{0}</b>',value)}

                },
                type:'NumberField',
                filters:{pfiltro:'vac.dias_efectivo',type:'numeric'},
                id_grupo:1,
                grid:true,
                form:true
            },
            {

                config:{
                    name: 'dias',
                    fieldLabel: 'Dias Efectivos',
                    allowBlank: true,
                    anchor: '35%',
                    gwidth: 100,
                    readOnly :true,
                    style: 'background-color: #F2F1F0; background-image: none;'
                },
                type:'NumberField',
                filters:{pfiltro:'vac.dias',type:'numeric'},
                id_grupo:1,
                grid:true,
                form:true,
            },
            {
                config:{
                    name: 'descripcion',
                    fieldLabel: 'Descripcion',
                    allowBlank: false,
                    anchor: '70%',
                    gwidth: 200
                },
                type:'TextArea',
                filters:{pfiltro:'vac.descripcion',type:'string'},
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
                filters:{pfiltro:'vac.estado_reg',type:'string'},
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
                filters:{pfiltro:'vac.fecha_reg',type:'date'},
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
                filters:{pfiltro:'vac.id_usuario_ai',type:'numeric'},
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
                filters:{pfiltro:'vac.usuario_ai',type:'string'},
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
                filters:{pfiltro:'vac.fecha_mod',type:'date'},
                id_grupo:1,
                grid:true,
                form:false
            }
        ],
        tam_pag:50,
        title:'Vacación',
        ActSave:'../../sis_asistencia/control/Vacacion/insertarVacacion',
        ActDel:'../../sis_asistencia/control/Vacacion/eliminarVacacion',
        ActList:'../../sis_asistencia/control/Vacacion/listarVacacion',
        id_store:'id_vacacion',
        fields: [
            {name:'id_vacacion', type: 'numeric'},
            {name:'estado_reg', type: 'string'},
            {name:'id_funcionario', type: 'numeric'},
            {name:'fecha_inicio', type: 'date',dateFormat:'Y-m-d'},
            {name:'fecha_fin', type: 'date',dateFormat:'Y-m-d'},
            {name:'dias', type: 'numeric'},
            {name:'descripcion', type: 'string'},
            {name:'id_usuario_reg', type: 'numeric'},
            {name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
            {name:'id_usuario_ai', type: 'numeric'},
            {name:'usuario_ai', type: 'string'},
            {name:'id_usuario_mod', type: 'numeric'},
            {name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
            {name:'usr_reg', type: 'string'},
            {name:'usr_mod', type: 'string'},
            {name:'desc_funcionario1', type: 'string'},
            {name:'id_proceso_wf', type: 'numeric'}, // campos wf
            {name:'id_estado_wf', type: 'numeric'},
            {name:'estado', type: 'string'},
            {name:'nro_tramite', type: 'string'},
            {name:'medio_dia', type: 'numeric'},
            {name:'dias_efectivo', type: 'numeric'}
        ],
        sortInfo:{
            field: 'id_vacacion',
            direction: 'ASC'
        },
        bdel:true,
        bsave:false,
        fwidth: '35%',
        fheight: '70%',
        Grupos: [
            {
                layout: 'form',
                border: false,
                defaults: {
                    border: false
                },

                items: [
                    {
                        items: [

                            {
                                xtype: 'fieldset',
                                title: '  Movimiento Vacacion ',
                                autoHeight: true,
                                items: [],
                                id_grupo: 0
                            }

                        ]
                    },
                    {
                        items: [
                            {
                                xtype: 'fieldset',
                                title: ' Datos Generales ',
                                autoHeight: true,
                                items: [],
                                id_grupo: 1
                            }


                        ]
                    }
                ]
            }
        ],

        onButtonNew:function(){
            Phx.vista.Vacacion.superclass.onButtonNew.call(this);//habilita el boton y se abre
            this.movimientoVacacion(Phx.CP.config_ini.id_funcionario);
            this.Cmp.id_funcionario.store.load({params:{start:0,limit:this.tam_pag},
                callback : function (r) {
                    //  if (r.length == 1 ) {
                    this.Cmp.id_funcionario.setValue(r[0].data.id_funcionario);
                    this.Cmp.id_funcionario.fireEvent('select', this.Cmp.id_funcionario, r[0]);
                    //   }
                    this.Cmp.id_funcionario.collapse();
                }, scope : this
            });
        },
        onButtonEdit:function(){

            Phx.vista.Vacacion.superclass.onButtonEdit.call(this);
            var inicio;

            this.Cmp.fecha_inicio.on('select', function(menu, record){
                inicio = record;
            },this);


            this.arrayStore.Selección=[];
            this.arrayStore.Selección=['',''];
            for(var i=0; i<=parseInt(this.Cmp.dias.getValue()); i++){
                this.arrayStore.Selección[i]=["ID"+(i),(i)];
            }
            // this.Cmp.medio_dia.store.loadData(this.arrayStore.Selección);
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
                url:'../../sis_asistencia/control/Vacacion/anteriorEstado',
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
            console.log(rec);
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
                url:'../../sis_asistencia/control/Vacacion/siguienteEstado',
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
            Phx.vista.Vacacion.superclass.preparaMenu.call(this, n);
            this.getBoton('btn_atras').enable();
            this.getBoton('diagrama_gantt').enable();
            this.getBoton('btn_siguiente').enable();
            this.getBoton('btn_cancelar').enable();
        },
        liberaMenu:function() {
            var tb = Phx.vista.Vacacion.superclass.liberaMenu.call(this);
            if (tb) {
                this.getBoton('btn_atras').disable();
                this.getBoton('diagrama_gantt').disable();
                this.getBoton('btn_siguiente').disable();
                this.getBoton('btn_cancelar').disable();
            }
        },
        movimientoVacacion:function (value) {
            Ext.Ajax.request({
                url:'../../sis_asistencia/control/Vacacion/movimientoGet',
                params:{id_funcionario: value},
                success:function(resp){
                    const reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
                    this.Cmp.evento.setValue(reg.ROOT.datos.tipo); //dias
                    this.Cmp.saldo.setValue(reg.ROOT.datos.dias_actual); //dias
                },
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            });
        },
        onCancelar:function () {
            const data = this.sm.getSelected().data;
            console.log(data.id_vacacion)
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                url:'../../sis_asistencia/control/Vacacion/cancelarVacacion',
                params:{
                    id_vacacion:  data.id_vacacion
                },
                success: this.succesNew,
                failure: this.conexionFailure,
                timeout: this.timeout,
                scope: this
            });
        },
        succesNew: function(resp){
            Phx.CP.loadingHide();
            const reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            this.load({params:{start:0, limit:this.tam_pag}});
        },
    })
</script>
		
		