<?php
/**
 *@package pXP
 *@file MesTrabajoVoBo.php
 *@author  (miguel.mamani)
 *@date 05-12-2019 22:01:27
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
#0				05-12-2019				 (miguel.mamani)				CREACION

 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.MesTrabajoVoBo=Ext.extend(Phx.gridInterfaz,{

            constructor:function(config){
                this.maestro=config.maestro;
                //llama al constructor de la clase padre
                Phx.vista.MesTrabajoVoBo.superclass.constructor.call(this,config);
                this.init();
                this.addButton('ant_estado',{   grupo:[2,3],
                                                argument: { estado: 'anterior'},
                                                text:'Anterior',
                                                iconCls: 'batras',
                                                disabled:true,
                                                handler:this.antEstado,
                                                tooltip: '<b>Pasar al Anterior Estado</b>'});
                this.addButton('fin_registro',{ grupo:[0,3],
                                                text:'Siguiente',
                                                iconCls: 'badelante',
                                                disabled:true,
                                                handler:this.fin_registro,
                                                tooltip: '<b>Siguiente</b><p>Pasa al siguiente estado</p>'});
                /*this.addButton('btnChequeoDocumentosWf',{
                    text: 'Documentos',
                    grupo: [0,1,2,3,4,5,6,7],
                    iconCls: 'bchecklist',
                    disabled: true,
                    handler: this.loadCheckDocumentosRecWf,
                    tooltip: '<b>Documentos </b><br/>Subir los documetos requeridos.'
                });*/
                this.grid.on('cellclick', this.abrirEnlace, this);
                // this.addBotonesGantt();
               // this.store.baseParams = {tipo_interfaz: 'MesTrabajoVoBo'};

                this.load({params:{start:0, limit:this.tam_pag, tipo_interfaz: 'MesTrabajoVoBo'}})
            },

            Atributos:[
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_mes_trabajo'
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
                        name: 'id_periodo'
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
                    config:{
                        name: 'nro_tramite',
                        fieldLabel: 'Nro Tramite',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 150,
                        maxLength:100,
                        renderer: function(value,p,record) {
                            return String.format('{0}','<i class="fa fa-reply-all" aria-hidden="true"></i> '+record.data['nro_tramite']);
                        }
                    },
                    type:'TextField',
                    filters:{pfiltro:'hta.nro_tramite',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'estado',
                        fieldLabel: 'Estado',
                        allowBlank: false,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:50
                    },
                    type:'TextField',
                    filters:{pfiltro:'hta.estado',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'desc_funcionario1',
                        fieldLabel: 'Funcionario.',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 200,
                        maxLength:10
                    },
                    type:'TextField',
                    filters:{pfiltro:'hta.estado_reg',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },
                {
                    config:{
                        name: 'total_comp',
                        fieldLabel: 'Total Comp',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        renderer: function(value,p,record){
                            return String.format('<b><font size = 2 >{0}</font></b>', value);
                        }
                    },
                    type:'NumberField',
                    filters:{pfiltro:'hto.total_comp',type:'numeric'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },
                {
                    config:{
                        name: 'total_normal',
                        fieldLabel: 'Total Normal',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        renderer: function(value,p,record){
                            return String.format('<b><font size = 2 >{0}</font></b>', value);
                        }
                    },
                    type:'NumberField',
                    filters:{pfiltro:'hto.total_normal',type:'numeric'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },
                {
                    config:{
                        name: 'total_extra',
                        fieldLabel: 'Total Extra',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        renderer: function(value,p,record){
                            var color = '#000000';
                            if (Number(value) > 0){
                                color = '#170caa';
                            }
                            return String.format('<b><font color="'+color+'" size = 2 >{0}</font></b>', value);
                        }
                    },
                    type:'NumberField',
                    filters:{pfiltro:'hto.total_extra',type:'numeric'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },
                {
                    config:{
                        name: 'total_nocturna',
                        fieldLabel: 'Total Nocturno',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        renderer: function(value,p,record){
                            var color = '#000000';
                            if (Number(value) > 0){
                                color = '#1eaa19';
                            }
                            return String.format('<b><font size = 2 >{0}</font></b>', value);
                        }
                    },
                    type:'NumberField',
                    filters:{pfiltro:'hto.total_nocturna',type:'numeric'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },
                {
                    config:{
                        name: 'extra_autorizada',
                        fieldLabel: 'Extra Autorizada',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        renderer: function(value,p,record){
                            return String.format('<b><font size = 2 >{0}</font></b>', value);
                        }
                    },
                    type:'NumberField',
                    filters:{pfiltro:'hto.extra_autorizada',type:'numeric'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },
                {
                    config:{
                        name: 'gestion',
                        fieldLabel: 'Gestion',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:10
                    },
                    type:'TextField',
                    filters:{pfiltro:'hta.estado_reg',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },
                {
                    config:{
                        name: 'periodo',
                        fieldLabel: 'Periodo',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:10
                    },
                    type:'TextField',
                    filters:{pfiltro:'hta.estado_reg',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:false
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
                    filters:{pfiltro:'hta.estado_reg',type:'string'},
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
                    filters:{pfiltro:'hta.fecha_reg',type:'date'},
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
                    filters:{pfiltro:'hta.id_usuario_ai',type:'numeric'},
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
                    filters:{pfiltro:'hta.usuario_ai',type:'string'},
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
                    filters:{pfiltro:'hta.fecha_mod',type:'date'},
                    id_grupo:1,
                    grid:true,
                    form:false
                }
            ],
            tam_pag:50,
            title:'Hoja Tiempo VoBo',
            ActList:'../../sis_asistencia/control/MesTrabajo/listarHojaTiempoAgrupador',
            id_store:'id_mes_trabajo',
            fields: [
                {name:'id_mes_trabajo', type: 'numeric'},
                {name:'estado_reg', type: 'string'},
                {name:'id_proceso_wf', type: 'numeric'},
                {name:'id_estado_wf', type: 'numeric'},
                {name:'id_periodo', type: 'numeric'},
                {name:'estado', type: 'string'},
                {name:'nro_tramite', type: 'string'},
                {name:'id_funcionario', type: 'numeric'},
                {name:'id_usuario_reg', type: 'numeric'},
                {name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
                {name:'id_usuario_ai', type: 'numeric'},
                {name:'usuario_ai', type: 'string'},
                {name:'id_usuario_mod', type: 'numeric'},
                {name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
                {name:'usr_reg', type: 'string'},
                {name:'usr_mod', type: 'string'},
                {name:'desc_funcionario1', type: 'string'},

                {name:'total_comp', type: 'numeric'},
                {name:'total_normal', type: 'numeric'},
                {name:'total_extra', type: 'numeric'},
                {name:'total_nocturna', type: 'numeric'},
                {name:'extra_autorizada', type: 'numeric'},
                {name:'periodo', type: 'numeric'},
                {name:'gestion', type: 'numeric'}

            ],
            sortInfo:{
                field: 'id_mes_trabajo',
                direction: 'ASC'
            },
            bdel:false,
            bsave:false,
            bnew: false,
            bedit:false,
            addBotonesGantt: function() {
                this.menuAdqGantt = new Ext.Toolbar.SplitButton({
                    id: 'b-diagrama_gantt-' + this.idContenedor,
                    text: 'Gantt',
                    disabled: true,
                    grupo:[0,1,2,3,4],
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
            abrirEnlace: function(cell,rowIndex,columnIndex,e){
                if(cell.colModel.getColumnHeader(columnIndex) === 'Nro Tramite'){
                    var data = this.sm.getSelected().data;
                    Phx.CP.loadWindows(
                        '../../../sis_asistencia/vista/mes_trabajo_det/MesTrabajoDetConsulta.php',
                        'Detalle', {
                            width:'90%',
                            height:'90%'
                        }, {
                            data: data,
                            link: true
                        },
                        this.idContenedor,
                        'MesTrabajoDetConsulta'
                    );
                }
            },
            preparaMenu:function(n){
                //var data = this.getSelectedData();
                Phx.vista.MesTrabajoVoBo.superclass.preparaMenu.call(this, n);
                this.getBoton('fin_registro').enable();
              // this.getBoton('diagrama_gantt').enable();
                this.getBoton('ant_estado').enable();
              // this.getBoton('btnChequeoDocumentosWf').enable();
            },
            liberaMenu:function() {
                var tb = Phx.vista.MesTrabajoVoBo.superclass.liberaMenu.call(this);
                if (tb) {
                    this.getBoton('fin_registro').disable();
                    // this.getBoton('diagrama_gantt').disable();
                    this.getBoton('ant_estado').disable();
                    // this.getBoton('btnChequeoDocumentosWf').disable();
                }
            },
            fin_registro: function(){
                var rec = this.sm.getSelected();
                Phx.CP.loadWindows(
                    '../../../sis_asistencia/vista/mes_trabajo_det/MesTrabajoDetExtra.php',
                    'Aoutorizar Horas Extras', {
                        width:'90%',
                        height:'90%'
                    }, {
                        data: rec.data,
                        link: true
                    },
                    this.idContenedor,
                    'MesTrabajoDetExtra'
                );
                /*this.objWizard = Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/FormEstadoWf.php',
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
                );*/
               /* if (rec.data.total_extra > 0){
                    Phx.CP.loadWindows(
                        '../../../sis_asistencia/vista/hojas_tiempo/HojaTiempoVoBo.php',
                        'Detalle', {
                            width:'90%',
                            height:'90%'
                        }, {
                            data: {rec:rec.data, voBo: 'si'},
                            link: true
                        },
                        this.idContenedor,
                        'HojaTiempoVoBo'
                    );
                }else {

                }*/

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
                this.reload();
            },
            antEstado:function(res){
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
                    url:'../../sis_asistencia/control/MesTrabajo/anteriorEstado',
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
            loadCheckDocumentosRecWf:function() {
                var rec=this.sm.getSelected();
                rec.data.nombreVista = this.nombreVista;
                Phx.CP.loadWindows('../../../sis_workflow/vista/documento_wf/DocumentoWf.php',
                    'Chequear documento del WF',
                    {
                        width:'90%',
                        height:500
                    },
                    rec.data,
                    this.idContenedor,
                    'DocumentoWf'
                )
            }
        }
    )
</script>

