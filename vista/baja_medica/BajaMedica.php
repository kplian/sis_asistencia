<?php
/****************************************************************************************
*@package pXP
*@file gen-BajaMedica.php
*@author  (admin.miguel)
*@date 05-02-2021 14:41:38
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema

HISTORIAL DE MODIFICACIONES:
#ISSUE                FECHA                AUTOR                DESCRIPCION
 #0                05-02-2021 14:41:38    admin.miguel            Creacion    
 #   

*******************************************************************************************/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.BajaMedica=Ext.extend(Phx.gridInterfaz,{

    constructor:function(config){
        this.maestro=config.maestro;
        //llama al constructor de la clase padre
        Phx.vista.BajaMedica.superclass.constructor.call(this,config);
        this.init();
        this.finCons = true;
        this.iniciarEventos();
        this.addButton('btn_siguiente',{grupo:[0,3],
            text:'Enviar Comunicación',
            iconCls: 'bemail',
            disabled:true,
            handler:this.onSiguiente});
        this.addButton('btnChequeoDocumentosWf',{
            grupo:[0,1,2,3,4,5],
            text: 'Documentos',
            iconCls: 'bchecklist',
            disabled: true,
            handler: this.loadCheckDocumentosRecWf,
            tooltip: '<b>Documentos </b><br/>Subir los documetos requeridos.'
        });
        this.addBotonesGantt();

        this.load({params:{start:0, limit:this.tam_pag}})
    },
    iniciarEventos: function(){
        this.Cmp.fecha_inicio.on('select', function (Fecha, dato) {
            Ext.Ajax.request({
                url: '../../sis_asistencia/control/Vacacion/getDias', //llamando a la funcion getDias.
                params: {
                    'fecha_fin': this.Cmp.fecha_fin.getValue(),
                    'fecha_inicio': Fecha.getValue(),
                    'medios_dias':''
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
                    'medios_dias':''
                },
                success: this.respuestaValidacion,
                failure: this.conexionFailure,
                timeout: this.timeout,
                scope: this
            });
        }, this);

        this.Cmp.fecha_inicio.on('change', function (Fecha, dato) {
            Ext.Ajax.request({
                url: '../../sis_asistencia/control/Vacacion/getDias', //llamando a la funcion getDias.
                params: {
                    'fecha_fin': this.Cmp.fecha_fin.getValue(),
                    'fecha_inicio': Fecha.getValue(),
                    'medios_dias':''
                },
                success: this.respuestaValidacion,
                failure: this.conexionFailure,
                timeout: this.timeout,
                scope: this
            });
        }, this);

        this.Cmp.fecha_fin.on('change', function (Fecha, dato) {
            Ext.Ajax.request({
                url: '../../sis_asistencia/control/Vacacion/getDias', //llamando a la funcion getDias.
                params: {
                    'fecha_fin': Fecha.getValue(),
                    'fecha_inicio': this.Cmp.fecha_inicio.getValue(),
                    'medios_dias':''
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
        var respuesta_valid = s.responseText.split('%');
        this.arrayStore.Selección=[];
        this.arrayStore.Selección=['',''];
        for(var i=0; i<=parseInt(respuesta_valid[1]); i++){
            this.arrayStore.Selección[i]=["ID"+(i),(i)];
        }
        console.log(this.arrayStore);
        this.Cmp.dias_efectivo.reset(); /// dias_efectivo
        this.Cmp.dias_efectivo.setValue(respuesta_valid[1]); //diasdias_efectivo; dias
    },
    Atributos:[
        {
            //configuracion del componente
            config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id_baja_medica'
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
                gwidth: 150
            },
            type:'TextField',
            filters:{pfiltro:'bma.nro_tramite',type:'string'},
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
                gwidth: 100,
                maxLength:100
            },
            type:'TextField',
            filters:{pfiltro:'bma.estado',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config: {
                name: 'id_funcionario',
                hiddenName: 'id_funcionario',
                origen: 'FUNCIONARIO',
                fieldLabel: 'Funcionario',
                allowBlank: false,
                disabled: false,
                width: 320,
                gwidth: 250,
                valueField: 'id_funcionario',
                gdisplayField: 'desc_funcionario',
                baseParams: {par_filtro: 'VFUN.desc_funcionario1#FUNCIO.id_funcionario'},
                renderer: function (value, p, record) {
                    return String.format('{0}', record.data['desc_funcionario']);
                }
            },
            type: 'ComboRec',
            id_grupo: 2,
            filters: {pfiltro: 'fu.desc_funcionario2', type: 'string'},
            bottom_filter: true,
            grid: true,
            form: true
        },
        {
            config:{
                name: 'codigo',
                fieldLabel: 'Codigo Funcionario',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100
            },
            type:'TextField',
            filters:{pfiltro:'fu.codigo',type:'string'},
            bottom_filter: true,
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config: {
                name: 'id_tipo_bm',
                fieldLabel: 'Tipo Baja Medica',
                allowBlank: false,
                emptyText: 'Elija una opción...',
                store: new Ext.data.JsonStore({
                    url: '../../sis_asistencia/control/TipoBm/listarTipoBm',
                    id: 'id_tipo_bm',
                    root: 'datos',
                    sortInfo: {
                        field: 'nombre',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_tipo_bm', 'nombre', 'descripcion'],
                    remoteSort: true,
                    baseParams: {par_filtro: 'tba.nombre#tba.descripcion'}
                }),
                valueField: 'id_tipo_bm',
                displayField: 'nombre',
                gdisplayField: 'desc_nombre',
                hiddenName: 'id_tipo_bm',
                forceSelection: true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender: true,
                mode: 'remote',
                pageSize: 15,
                queryDelay: 1000,
                width: 320,
                gwidth: 150,
                minChars: 2,
                renderer : function(value, p, record) {
                    return String.format('{0}', record.data['desc_nombre']);
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
                name: 'fecha_inicio',
                fieldLabel: 'Fecha Inicio',
                allowBlank: false,
                width: 320,
                gwidth: 100,
                disabledDays:  [0, 6],
                format: 'd/m/Y',
                renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
                type:'DateField',
                filters:{pfiltro:'bma.fecha_inicio',type:'date'},
                id_grupo:1,
                grid:true,
                form:true
		},
        {
            config:{
                name: 'fecha_fin',
                fieldLabel: 'Fecha Fin',
                allowBlank: false,
                width: 320,
                gwidth: 100,
                disabledDays:  [0, 6],
                format: 'd/m/Y',
                renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
                type:'DateField',
                filters:{pfiltro:'bma.fecha_fin',type:'date'},
                id_grupo:1,
                grid:true,
                form:true
		},
        {
            config:{
                name: 'dias_efectivo',
                fieldLabel: 'Días efectivos de baja',
                allowBlank: true,
                width: 80,
                gwidth: 120,
            },
                type:'NumberField',
                filters:{pfiltro:'bma.dias_efectivo',type:'numeric'},
                id_grupo:1,
                grid:true,
                form:true
		},
        {
            config : {
                name : 'documento',
                fieldLabel : 'Respaldo',
                allowBlank : false,
                gwidth : 80,
                width : 80,
                typeAhead : true,
                triggerAction : 'all',
                lazyRender : true,
                mode : 'local',
                store : ['no', 'si'],
                disableKeyFilter: true,
                editable: false
            },
            type : 'ComboBox',
            filters : {
                pfiltro : 'bma.documento',
                type : 'string'
            },
            valorInicial : 'no',
            id_grupo : 0,
            grid : true,
            form : true
        },
        {
            config:{
                name: 'observaciones',
                fieldLabel: 'Observaciones',
                allowBlank: false,
                width: 300,
                gwidth: 250,
                renderer:function (value,p,record){
                    return String.format('<b><font color="#a52a2a">{0}</font></b>', value)
                }
            },
            type:'TextArea',
            filters:{pfiltro:'pmo.observaciones',type:'string'},
            id_grupo:0,
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
            filters:{pfiltro:'bma.estado_reg',type:'string'},
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
                filters:{pfiltro:'bma.fecha_reg',type:'date'},
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
                filters:{pfiltro:'bma.id_usuario_ai',type:'numeric'},
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
                filters:{pfiltro:'bma.usuario_ai',type:'string'},
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
                filters:{pfiltro:'bma.fecha_mod',type:'date'},
                id_grupo:1,
                grid:true,
                form:false
		}
    ],
    tam_pag:50,    
    title:'Baja medica',
    ActSave:'../../sis_asistencia/control/BajaMedica/insertarBajaMedica',
    ActDel:'../../sis_asistencia/control/BajaMedica/eliminarBajaMedica',
    ActList:'../../sis_asistencia/control/BajaMedica/listarBajaMedica',
    id_store:'id_baja_medica',
    fields: [
		{name:'id_baja_medica', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_funcionario', type: 'numeric'},
		{name:'id_tipo_bm', type: 'numeric'},
		{name:'fecha_inicio', type: 'date',dateFormat:'Y-m-d'},
		{name:'fecha_fin', type: 'date',dateFormat:'Y-m-d'},
		{name:'dias_efectivo', type: 'numeric'},
		{name:'id_proceso_wf', type: 'numeric'},
		{name:'id_estado_wf', type: 'numeric'},
		{name:'estado', type: 'string'},
		{name:'nro_tramite', type: 'string'},
		{name:'documento', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
        {name:'desc_nombre', type: 'string'},
		{name:'desc_funcionario', type: 'string'},
        {name:'codigo', type: 'string'},
        {name:'observaciones', type: 'string'}
        
    ],
    sortInfo:{
        field: 'id_baja_medica',
        direction: 'ASC'
    },
    bdel:true,
    bsave:false,
    fwidth: '35%',
    fheight: '55%',
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
        if(confirm('¿Enviar comunicado ?')) {
            Ext.Ajax.request({
                url: '../../sis_asistencia/control/BajaMedica/aprobarEstado',
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
    onButtonNew:function(){
        Phx.vista.BajaMedica.superclass.onButtonNew.call(this);//habilita el boton y se abre
    },
    onButtonEdit:function(){
        Phx.vista.BajaMedica.superclass.onButtonEdit.call(this);
        let inicio;
        this.Cmp.fecha_inicio.on('select', function(menu, record){
            inicio = record;
        },this);
        this.arrayStore.Selección=[];
        this.arrayStore.Selección=['',''];
        for(var i=0; i<=parseInt(this.Cmp.dias_efectivo.getValue()); i++){
            this.arrayStore.Selección[i]=["ID"+(i),(i)];
        }
    }
    }
)
</script>
        
        