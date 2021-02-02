<?php
/****************************************************************************************
*@package pXP
*@file gen-TeleTrabajo.php
*@author  (admin.miguel)
*@date 01-02-2021 14:53:44
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema

HISTORIAL DE MODIFICACIONES:
#ISSUE                FECHA                AUTOR                DESCRIPCION
 #0                01-02-2021 14:53:44    admin.miguel            Creacion    
 #   

*******************************************************************************************/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.TeleTrabajo=Ext.extend(Phx.gridInterfaz,{

    constructor:function(config){
        this.maestro=config.maestro;
        //llama al constructor de la clase padre
        Phx.vista.TeleTrabajo.superclass.constructor.call(this,config);
        this.init();
        this.finCons = true;
        this.load({params:{start:0, limit:this.tam_pag}})
    },
            
    Atributos:[
        {
            //configuracion del componente
            config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id_tele_trabajo'
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
            config:{
                name: 'nro_tramite',
                fieldLabel: 'Nro Tramite',
                allowBlank: true,
                anchor: '80%',
                gwidth: 130
            },
            type:'TextField',
            filters:{pfiltro:'vac.nro_tramite',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'estado',
                fieldLabel: 'Estado',
                allowBlank: true,
                anchor: '80%',
                gwidth: 80
            },
            type:'TextField',
            filters:{pfiltro:'vac.estado',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config: {
                name: 'id_responsable',
                fieldLabel: 'Responsable',
                allowBlank: false,
                emptyText: 'Elija una opción...',
                store: new Ext.data.JsonStore({
                    url: '../../sis_asistencia/control/Permiso/listaResponsable',
                    id: 'id_funcionario',
                    root: 'datos',
                    sortInfo: {
                        field: 'numero_nivel',
                        direction: 'DESC'
                    },
                    totalProperty: 'total',
                    fields: ['id_funcionario','desc_funcionario'],
                    remoteSort: true,
                    baseParams: {par_filtro: 'f.desc_funcionario1'}
                }),
                valueField: 'id_funcionario',
                displayField: 'desc_funcionario',
                gdisplayField: 'responsable',
                hiddenName: 'id_responsable',
                forceSelection: true,
                disableKeyFilter: true,
                editable: false,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender: true,
                mode: 'remote',
                pageSize: 15,
                queryDelay: 1000,
                width: 320,
                gwidth:200,
                minChars: 2,
                renderer : function(value, p, record) {
                    return String.format('{0}', record.data['responsable']);
                }
            },
            type: 'ComboBox',
            id_grupo: 1,
            grid: true,
            form: true
        },
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
                gdisplayField: 'desc_funcionario1',
                hiddenName: 'Funcionario',
                tpl: '<tpl for="."><div class="x-combo-list-item"><p><b>{desc_funcionario}</b></p><p>{codigo}</p><p>{cargo}</p><p>{departamento}</p><p>{oficina}</p> </div></tpl>',
                forceSelection: true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender: true,
                mode: 'remote',
                pageSize: 15,
                queryDelay: 1000,
                width: 320,
                gwidth:220,
                minChars: 2,
                renderer : function(value, p, record) {
                    return String.format('{0}', record.data['funcionario']);
                }
            },
            type: 'ComboBox',
            filters:{pfiltro:'fu.desc_funcionario2',type:'string'},
            id_grupo: 1,
            grid: true,
            form: true,
            bottom_filter:true
        },
        {
            config:{
                name: 'fecha_inicio',
                fieldLabel: 'Desde',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                            format: 'd/m/Y', 
                            renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
                type:'DateField',
                filters:{pfiltro:'tlt.fecha_inicio',type:'date'},
                id_grupo:1,
                grid:true,
                form:true
		},
        {
            config:{
                name: 'fecha_fin',
                fieldLabel: 'Hasta',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                            format: 'd/m/Y', 
                            renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
                type:'DateField',
                filters:{pfiltro:'tlt.fecha_fin',type:'date'},
                id_grupo:1,
                grid:true,
                form:true
		},
        {
            config:{
                name: 'justificacion',
                fieldLabel: 'Justificacion',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100
            },
                type:'TextArea',
                filters:{pfiltro:'tlt.justificacion',type:'string'},
                id_grupo:1,
                grid:true,
                form:true
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
                name: 'estado_reg',
                fieldLabel: 'Estado Reg.',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:10
            },
            type:'TextField',
            filters:{pfiltro:'tlt.estado_reg',type:'string'},
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
                filters:{pfiltro:'tlt.fecha_reg',type:'date'},
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
                filters:{pfiltro:'tlt.id_usuario_ai',type:'numeric'},
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
                filters:{pfiltro:'tlt.usuario_ai',type:'string'},
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
                filters:{pfiltro:'tlt.fecha_mod',type:'date'},
                id_grupo:1,
                grid:true,
                form:false
		}
    ],
    tam_pag:50,    
    title:'Tele Trabajo',
    ActSave:'../../sis_asistencia/control/TeleTrabajo/insertarTeleTrabajo',
    ActDel:'../../sis_asistencia/control/TeleTrabajo/eliminarTeleTrabajo',
    ActList:'../../sis_asistencia/control/TeleTrabajo/listarTeleTrabajo',
    id_store:'id_tele_trabajo',
    fields: [
		{name:'id_tele_trabajo', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_funcionario', type: 'numeric'},
		{name:'id_responsable', type: 'numeric'},
		{name:'fecha_inicio', type: 'date',dateFormat:'Y-m-d'},
		{name:'fecha_fin', type: 'date',dateFormat:'Y-m-d'},
		{name:'justificacion', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},

        {name:'estado', type: 'string'},
        {name:'nro_tramite', type: 'string'},
        {name:'id_proceso_wf', type: 'numeric'},
        {name:'id_estado_wf', type: 'numeric'},
        {name:'funcionario', type: 'string'},
        {name:'responsable', type: 'string'},
    ],
    sortInfo:{
        field: 'id_tele_trabajo',
        direction: 'ASC'
    },
    bdel:true,
    bsave:false,
    onButtonNew:function(){
        Phx.vista.TeleTrabajo.superclass.onButtonNew.call(this);//habilita el boton y se abre

        this.Cmp.id_funcionario.store.load({params:{start:0,limit:this.tam_pag,es_combo_solicitud:'si'},
            callback : function (r) {
                if(r.length > 0){
                    this.Cmp.id_funcionario.setValue(r[0].data.id_funcionario);
                    this.Cmp.id_funcionario.fireEvent('select', this.Cmp.id_funcionario, r[0]);
                    this.Cmp.id_funcionario.modificado = true;
                    this.Cmp.id_funcionario.collapse();
                    this.onCargarResponsable(r[0].data.id_funcionario,true);
                }

            }, scope : this
        });

        this.Cmp.id_funcionario.on('select', function(combo, record, index){
            this.Cmp.id_responsable.reset();
            this.Cmp.id_responsable.store.baseParams = Ext.apply(this.Cmp.id_responsable.store.baseParams, {id_funcionario: record.data.id_funcionario});
            this.movimientoVacacion(record.data.id_funcionario);
            this.Cmp.id_responsable.modificado = true;
        },this);

    },
    onButtonEdit:function(){
        Phx.vista.TeleTrabajo.superclass.onButtonEdit.call(this);
        this.onCargarResponsable(this.Cmp.id_funcionario.getValue(),false);
        this.Cmp.id_funcionario.on('select', function(combo, record, index){
            this.Cmp.id_responsable.reset();
            this.Cmp.id_responsable.store.baseParams = Ext.apply(this.Cmp.id_responsable.store.baseParams, {id_funcionario: record.data.id_funcionario});
            this.movimientoVacacion(record.data.id_funcionario);
            this.onCargarResponsable(record.data.id_funcionario,true);
            this.Cmp.id_responsable.modificado = true;
        },this);
    },
    onCargarResponsable:function(id, filtro = true){
        const rec = this.sm.getSelected();
        this.Cmp.id_responsable.store.baseParams = Ext.apply(this.Cmp.id_responsable.store.baseParams, {id_funcionario: id});
        this.Cmp.id_responsable.modificado = true;
        if(filtro) {
            this.Cmp.id_responsable.store.load({
                params: {start: 0, limit: this.tam_pag, id_funcionario: id},
                callback: function (r) {
                    this.Cmp.id_responsable.setValue(r[0].data.id_funcionario);
                    this.Cmp.id_responsable.fireEvent('select', this.Cmp.id_responsable, r[0]);
                    this.Cmp.id_responsable.collapse();
                }, scope: this
            });
        }
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
    onSiguiente :function () {
        Phx.CP.loadingShow();
        const rec = this.sm.getSelected(); //obtine los datos selecionado en la grilla
        console.log(rec);
        if(confirm('¿Enviar solicitud a '+rec.data.responsable+'?')) {
            Ext.Ajax.request({
                url: '../../sis_asistencia/control/TeleTrabajo/aprobarEstado',
                params: {
                    id_proceso_wf:  rec.data.id_proceso_wf,
                    id_estado_wf:  rec.data.id_estado_wf,
                    evento : 'siguiente',
                    obs : ''
                },
                success: this.successWizard,
                failure: this.conexionFailure,
                timeout: this.timeout,
                scope: this
            });
        }else{
            Phx.CP.loadingHide();
        }
    },
    successWizard:function(resp){
        Phx.CP.loadingHide();
        this.reload();
    },
    }
)
</script>
        
        