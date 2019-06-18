<?php
/**
*@package pXP
*@file gen-MesTrabajo.php
*@author  (miguel.mamani)
*@date 31-01-2019 13:53:10
 * HISTORIAL DE MODIFICACIONES:
 * #ISSUE				FECHA				AUTOR				DESCRIPCION
 *  #4	ERT			17/06/2019 				 MMV				Correccion Boton reporte mostrar grupos
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.MesTrabajo=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
        this.maestro=config.maestro;
    	//llama al constructor de la clase padre
        //this.initButtons=[this.cmbGestion, this.cmbPeriodo];
        Phx.vista.MesTrabajo.superclass.constructor.call(this,config);
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
        this.init();
        this.addButton('ant_estado',{  grupo:[3], argument: { estado: 'anterior'},text:'Anterior',iconCls: 'batras',disabled:true,handler:this.antEstado,tooltip: '<b>Pasar al Anterior Estado</b>'});
        this.addButton('fin_registro',{ grupo:[0,3], text:'Siguiente', iconCls: 'badelante',disabled:true,handler:this.fin_registro,tooltip: '<b>Siguiente</b><p>Pasa al siguiente estado</p>'});
        this.addButton('Report',{
            grupo:[0,3,1,2], //#4
            text :'Reporte',
            iconCls : 'bexcel',
            disabled: true,
            handler : this.onButtonReporte,
            tooltip : '<b>Reporte Requerimiento de Materiale</b>'
        });
        this.addBotonesGantt();
        this.finCons = true;
        this.store.baseParams.id_usuario = Phx.CP.config_ini.id_usuario;
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
					name: 'gestion'
			},
			type:'Field',
			form:true
		},
        {
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_gestion'
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
                name: 'id_planilla'
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
                gwidth: 100,
                maxLength:100
            },
            type:'TextField',
            filters:{pfiltro:'smt.nro_tramite',type:'string'},
            id_grupo:1,
            grid:true,
            bottom_filter:true,
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
            filters:{pfiltro:'smt.estado',type:'string'},
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
                maxLength:100,
                renderer:function(value, p, record){
                    return String.format('<div align="center"><b><font size=2 >{0}</font></b></div>',value);
                }
            },
            type:'TextField',
            filters:{pfiltro:'g.gestion',type:'string'},
            id_grupo:1,
            grid:true,
            bottom_filter:true,
            form:false
        },
        {
            config:{
                name: 'periodo',
                fieldLabel: 'Periodo',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:100,
                renderer:function(value, p, record){
                    var mes;
                    if (value <= 9){
                        mes = '0'+value;
                    }else{
                        mes = ''+value;
                    }
                    return String.format('<div align="center"><b><font size=2 >{0}</font></b></div>',mes);
                }

            },
            type:'TextField',
            filters:{pfiltro:'pe.periodo',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name:'id_funcionario',
                hiddenName: 'id_funcionario',
                origen:'FUNCIONARIO',
                fieldLabel:'Funcionario',
                allowBlank:false,
                gwidth:200,
                valueField: 'id_funcionario',
                gdisplayField: 'desc_funcionario',
                baseParams: { es_combo_solicitud : 'si' },
                renderer:function(value, p, record){return String.format('{0}', record.data['desc_funcionario']);}
            },
            type:'ComboRec',//ComboRec
            id_grupo:0,
            filters:{pfiltro:'fun.desc_funcionario1',type:'string'},
            bottom_filter:true,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'nombre_cargo',
                fieldLabel: 'Cargo',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:100
            },
            type:'TextField',
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'tipo_contrato',
                fieldLabel: 'Tipo Contrato',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:100
            },
            type:'TextField',
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'desc_codigo',
                fieldLabel: 'Codigo Funcionario',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:100,
                renderer:function(value, p, record){
                    return String.format('<b><font size=2 >{0}</font></b>',value);
                }
            },
            type:'TextField',
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'nombre_archivo',
                fieldLabel: 'Nombre Archivo',
                allowBlank: true,
                anchor: '80%',
                gwidth: 200,
                renderer:function(value, p, record){
                    var mes;
                    if (record.data['periodo'] <= 9){
                        mes = '0'+record.data['periodo'];
                    }else{
                        mes = ''+record.data['periodo'];
                    }
                    return String.format('<div align="center"><b><font size=3 color="#006400">{0}</font></b></div>',record.data['desc_codigo']+'_'+mes+record.data['gestion']);
                }
            },
            type:'TextField',
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'obs',
                fieldLabel: 'obs',
                allowBlank: true,
                anchor: '80%',
                gwidth: 300
            },
            type:'TextArea',
            filters:{pfiltro:'smt.obs',type:'string'},
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
				filters:{pfiltro:'smt.estado_reg',type:'string'},
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
				name: 'usuario_ai',
				fieldLabel: 'Funcionaro AI',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:300
			},
				type:'TextField',
				filters:{pfiltro:'smt.usuario_ai',type:'string'},
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
				filters:{pfiltro:'smt.fecha_reg',type:'date'},
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
				filters:{pfiltro:'smt.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
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
				filters:{pfiltro:'smt.fecha_mod',type:'date'},
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
	title:'mes trabajo',
	ActSave:'../../sis_asistencia/control/MesTrabajo/insertarMesTrabajo',
	ActDel:'../../sis_asistencia/control/MesTrabajo/eliminarMesTrabajo',
	ActList:'../../sis_asistencia/control/MesTrabajo/listarMesTrabajo',
	id_store:'id_mes_trabajo',
	fields: [
		{name:'id_mes_trabajo', type: 'numeric'},
		{name:'id_periodo', type: 'numeric'},
		{name:'id_gestion', type: 'numeric'},
		{name:'id_planilla', type: 'numeric'},
		{name:'id_funcionario', type: 'numeric'},
		{name:'id_estado_wf', type: 'numeric'},
		{name:'id_proceso_wf', type: 'numeric'},
		//{name:'id_funcionario_apro', type: 'numeric'},
		{name:'estado', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'obs', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},

        {name:'desc_funcionario', type: 'string'},
        {name:'desc_funcionario_apro', type: 'string'},
        {name:'nro_tramite', type: 'string'},
        {name:'periodo', type: 'numeric'},
        {name:'desc_codigo', type: 'string'},
        {name:'gestion', type: 'numeric'},
        {name:'nombre_cargo', type: 'string'},
        {name:'tipo_contrato', type: 'string'}


    ],
	sortInfo:{
		field: 'id_mes_trabajo',
		direction: 'DESC'
	},
	bdel:true,
	bsave:false,
    onButtonNew:function(){
        if(!this.validarFiltros()){
            alert('Especifique el año y el mes antes')
        }else{
            Phx.vista.MesTrabajo.superclass.onButtonNew.call(this);//habilita el boton y se abre
            this.Cmp.id_gestion.setValue(this.cmbGestion.getValue());
            this.Cmp.id_periodo.setValue(this.cmbPeriodo.getValue());
            //this.mostrarComponente(this.Cmp.id_funcionario_apro);
        }
    },
    onButtonEdit:function(){
        Phx.vista.MesTrabajo.superclass.onButtonEdit.call(this);
        //this.ocultarComponente(this.Cmp.id_funcionario_apro);
    },
    capturaFiltros:function(combo, record, index){
       // this.desbloquearOrdenamientoGrid();
        if(this.validarFiltros()){
            this.store.baseParams.id_gestion = this.cmbGestion.getValue();
            this.store.baseParams.id_periodo = this.cmbPeriodo.getValue();
            this.load();
        }

    },
    validarFiltros:function(){
        if(this.cmbGestion.validate() && this.cmbPeriodo.validate()){
            console.log('bien');
            return true;
        } else{
            console.log('mal');
            return false;

        }
    },
    onButtonAct:function(){
        this.store.baseParams.id_gestion=this.cmbGestion.getValue();
        this.store.baseParams.id_periodo = this.cmbPeriodo.getValue();
        Phx.vista.MesTrabajo.superclass.onButtonAct.call(this);
    },
    diagramGanttDinamico : function(){
        var data=this.sm.getSelected().data.id_proceso_wf;
        window.open('../../../sis_workflow/reportes/gantt/gantt_dinamico.html?id_proceso_wf='+data)
    },

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
                    tooltip: '<b>Mues un reporte gantt en formato de imagen</b>',
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
        //var data = this.getSelectedData();
        Phx.vista.MesTrabajo.superclass.preparaMenu.call(this, n);
        this.getBoton('fin_registro').enable();
        this.getBoton('diagrama_gantt').enable();
        this.getBoton('ant_estado').enable();
        this.getBoton('Report').enable();
    },
    liberaMenu:function() {
        var tb = Phx.vista.MesTrabajo.superclass.liberaMenu.call(this);
        if (tb) {
            this.getBoton('fin_registro').disable();
            this.getBoton('diagrama_gantt').disable();
            this.getBoton('ant_estado').disable();
            this.getBoton('Report').disable();
        }
    },
    fin_registro: function(){
        var rec = this.sm.getSelected();
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
    cmbGestion: new Ext.form.ComboBox({
        fieldLabel: 'Gestion',
        allowBlank: false,
        emptyText:'Gestion...',
        blankText: 'Año',
        grupo:[0,1,2,3,4],
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
        grupo:[0,1,2,3,4],
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
        width:80
    }),
    tabsouth:[
        {
            url:'../../../sis_asistencia/vista/mes_trabajo_det/MesTrabajoDet.php',
            title:'Detalle',
            height:'50%',
            cls:'MesTrabajoDet'
        },
        {
            url:'../../../sis_asistencia/vista/mes_trabajo_con/MesTrabajoCon.php',
            title:'Detalle Factor',
            height:'50%',
            cls:'MesTrabajoCon'
        }
    ],
    onButtonReporte :function () {
        var rec = this.sm.getSelected();
        Ext.Ajax.request({
            url:'../../sis_asistencia/control/MesTrabajo/reporteHojaTiempo',
            params:{    id_proceso_wf : rec.data.id_proceso_wf,
                        id_periodo : this.cmbPeriodo.getValue(),
                        id_gestion : this.cmbGestion.getValue()
            },
            success: this.successExport,
            failure: this.conexionFailure,
            timeout:this.timeout,
            scope:this
        });
    }
    }
)
</script>
		
		