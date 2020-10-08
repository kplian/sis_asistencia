<?php
/**
 *@package pXP
 *@file RegistroSolicitud.php
 *@author  MAM
 *@date 27-12-2016 14:45
 *@Interface para el inicio de solicitudes de materiales
 */
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
    Phx.vista.MesTrabajoDetBio = {
        bedit:false,
        bnew:false,
        bsave:false,
        bdel:false,
        lista:[],
        id_proceso:null,
        id_estado:null,
        id_periodo:null,
        require:'../../../sis_asistencia/vista/mes_trabajo_det/MesTrabajoDet.php',
        requireclase:'Phx.vista.MesTrabajoDet',
        title:'Hoja Tiempo',
        nombreVista: 'MesTrabajoDetBio',

        gruposBarraTareas:[
            {name:'borrador',title:'<h1 align="center"><i></i>Borrador</h1>',grupo:1,height:0},
            {name:'asignado',title:'<h1 align="center"><i></i>Asignado</h1>',grupo:0,height:0},
            {name:'aprobado',title:'<h1 align="center"><i></i>Aprobado</h1>',grupo:0,height:0}
        ],
        tam_pag:50,

        bnewGroups:[0],
        bactGroups:[0,1,2],
        bdelGroups:[0],
        beditGroups:[0],
        bexcelGroups:[0,1,2],

        tipoStore: 'GroupingStore',//GroupingStore o JsonStore #
        remoteGroup: true,
        groupField: 'literal',
        viewGrid: new Ext.grid.GroupingView({
            forceFit: false
        }),

        constructor: function(config) {
           //  this.Atributos[this.getIndAtributo('tipo')].grid=false;
            this.Atributos[this.getIndAtributo('tipo_dos')].grid=false;
            this.Atributos[this.getIndAtributo('tipo_tres')].grid=false;


            this.idContenedor = config.idContenedor;
            this.maestro = config;

            this.id_proceso = this.maestro.proceso_wfID;
            this.id_estado = this.maestro.estado_wfID;
            this.id_periodo = this.maestro.periodoID;
            Phx.vista.MesTrabajoDetBio.superclass.constructor.call(this,config);
            this.crearFormCc();
            this.crearFormExtra();


            this.store.baseParams = {tipo_interfaz: this.nombreVista};
            // this.getBoton('btnTransaccionesUpload').setVisible(false);
           // this.getBoton('btmBorrarTodo').setVisible(false);
            this.addButton('btnCentro',{
                    grupo:[1],
                    text: 'Asignar CC',
                    iconCls: 'blist',
                    disabled: false,
                    handler: this.onCentroCosto,
                    tooltip: '<b>Asignar centro costo </b><br/>Puesde asignar tu centro costo en grupo o solo un registro'
                }
            );
            this.addButton('btnExtra',{
                    grupo:[1],
                    text: 'Justificar Extras',
                    iconCls: 'blist',
                    disabled: false,
                    handler: this.onJustificarExtra,
                    tooltip: '<b>Justificar horas extras</b><br/>Puedes justificar tus horas extras por grupo o solo un registro'
                }
            );
            this.addButton('btnSig',{ grupo:[1],
                text:'Siguiente',
                iconCls: 'badelante',
                disabled:false,
                handler:this.fin_registro,
                tooltip: '<b>Siguiente</b><p>Pasa al siguiente estado</p>'});

            this.store.baseParams.detalle = 'biometrico';
            this.store.baseParams.pes_estado = 'borrador';
            // this.store.baseParams.id_periodo = this.id_periodo;

            this.load({params: {start: 0, limit: this.tam_pag, id_periodo : this.id_periodo}});
        },
        actualizarSegunTab: function(name, indice){
            if (this.finCons) {
                this.store.baseParams.pes_estado = name;
                this.load({params: {start: 0, limit: this.tam_pag, id_periodo : this.id_periodo}});
            }
        },
        preparaMenu:function(n){
            var tb =this.tbar;
            Phx.vista.MesTrabajoDetBio.superclass.preparaMenu.call(this,n);
                this.getBoton('btnCentro').enable();
                this.getBoton('btnExtra').enable();
            return tb;
        },
        liberaMenu: function() {
            var tb = Phx.vista.MesTrabajoDetBio.superclass.liberaMenu.call(this);
            if(tb){
                this.getBoton('btnCentro').disable();
                this.getBoton('btnExtra').disable();
            }
            return tb;
        },
        onCentroCosto:function () {
            var seleccionados = this.sm.getSelections();
            for (var i = 0 ; i< seleccionados.length;i++){
                this.lista.push(seleccionados[i].id);
            }
            this.mostarFormCc();
        },
        mostarFormCc:function(){
            var seleccionados = this.sm.getSelections();
            if(seleccionados){
                this.ventanaCentroCosto.show();
            }
        },
        crearFormCc:function(){
            var storeCombo = new Ext.data.JsonStore({
                url: '../../sis_parametros/control/CentroCosto/listarCentroCosto',
                id: 'id_centro_costo',
                root: 'datos',
                sortInfo:{
                    field: 'codigo_cc',
                    direction: 'ASC'
                },
                totalProperty: 'total',
                fields: ['id_centro_costo','codigo_cc','codigo_uo','ep','gestion','nombre_uo',
                    'nombre_programa','nombre_proyecto','nombre_financiador','nombre_regional',
                    'nombre_actividad','movimiento_tipo_pres'],
                remoteSort: true,
                baseParams: {par_filtro: 'id_centro_costo#codigo_cc#codigo_uo#nombre_uo#nombre_actividad#nombre_programa#nombre_proyecto#nombre_regional#nombre_financiador',
                    aprobado: 'si',
                    tipo_pres:"gasto,administrativo,recurso,ingreso_egreso"
                }
            });
            var combo = new Ext.form.ComboBox({
                name:'id_centro_costo',
                fieldLabel:'Centro Costo',
                allowBlank : false,
                typeAhead: true,
                store: storeCombo,
                mode: 'remote',
                pageSize: 15,
                triggerAction: 'all',
                valueField : 'id_centro_costo',
                displayField : 'codigo_cc',
                forceSelection: true,
                allowBlank : false,
                anchor: '100%',
                resizable : true,
                enableMultiSelect: false
            });
            this.formCc = new Ext.form.FormPanel({
                baseCls: 'x-plain',
                autoDestroy: true,
                border: false,
                layout: 'form',
                autoHeight: true,
                items: [combo]
            });
            this.ventanaCentroCosto = new Ext.Window({
                title: 'Centro de costo',
                collapsible: true,
                maximizable: true,
                autoDestroy: true,
                width: 600,
                height: 170,
                layout: 'fit',
                plain: true,
                bodyStyle: 'padding:5px;',
                buttonAlign: 'center',
                items: this.formCc,
                modal:true,
                closeAction: 'hide',
                buttons: [{
                    text: 'Guardar',
                    handler: this.saveAutorizacion,
                    scope: this},
                    {
                        text: 'Cancelar',
                        handler: function(){ this.ventanaCentroCosto.hide() },
                        scope: this
                    }]
            });
            this.cmpCc = this.formCc.getForm().findField('id_centro_costo');
        },
        saveAutorizacion: function(){
           // var d = this.getSelectedData();
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                url: '../../sis_asistencia/control/MesTrabajoDet/insertarCentro',
                params: {
                    id_mes_trabajo_det: this.lista.toString(),
                    id_centro_costo: this.cmpCc.getValue()
                },
                success: this.successSinc,
                failure: this.conexionFailure,
                timeout: this.timeout,
                scope: this
            });
        },
        successSinc:function(resp){
            Phx.CP.loadingHide();
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            if(!reg.ROOT.error){
                if(this.ventanaCentroCosto){
                    this.ventanaCentroCosto.hide();
                }
                this.lista = [];
                // var sn = this.sm.getSelections();
                this.load({params: {start: 0, limit: this.tam_pag, id_periodo : this.id_periodo}});
                this.cmpCc.setValue(null);
            }else{
                alert('ocurrio un error durante el proceso')
            }
        },
        onJustificarExtra:function () {
            var seleccionados = this.sm.getSelections();
            for (var i = 0 ; i< seleccionados.length;i++){
              if (parseFloat(seleccionados[i].data.total_extra) > 0){
                  this.lista.push(seleccionados[i].id);
              }
            }
            this.ventanaExtra.show();
        },
        crearFormExtra:function(){
            var justificar = new Ext.form.TextArea({
                    name: 'justificar',
                    msgTarget: 'title',
                    fieldLabel: 'Justificar Hrs. Extras',
                    allowBlank: true,
                    anchor: '90%',
                    maxLength:50
                });
            this.formExtra = new Ext.form.FormPanel({
                baseCls: 'x-plain',
                autoDestroy: true,
                border: false,
                layout: 'form',
                autoHeight: true,
                items: [justificar]
            });
            this.ventanaExtra = new Ext.Window({
                title: 'Comentario',
                collapsible: true,
                maximizable: true,
                autoDestroy: true,
                width: 550,
                height: 170,
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
            this.cmpjustificar = this.formExtra.getForm().findField('justificar');
        },
        saveExtra:function () {
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                url: '../../sis_asistencia/control/MesTrabajoDet/insertarExtra',
                params: {
                    id_mes_trabajo_det: this.lista.toString(),
                    justificar: this.cmpjustificar.getValue()
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
                this.load({params: {start: 0, limit: this.tam_pag, id_periodo : this.id_periodo}});

                this.cmpjustificar.setValue(null);
            }else{
                alert('ocurrio un error durante el proceso')
            }
        },
        fin_registro: function(){
            this.objWizard = Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/FormEstadoWf.php',
                'Estado de Wf',
                {
                    modal: true,
                    width: 700,
                    height: 450
                },
                {
                    data: {
                        id_estado_wf: this.id_estado ,
                        id_proceso_wf:this.id_proceso
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
                url:'../../sis_asistencia/control/MesTrabajo/siguienteEstado',
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
            this.load({params: {start: 0, limit: this.tam_pag, id_periodo : this.id_periodo}});
        }

    };
</script>

