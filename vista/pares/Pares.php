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

        this.addButton('RegistrarLicencia', {
            text: 'Registrar Licencia',
            iconCls: 'bsee',
            disabled: false,
            handler: this.BRegistrarLicencia,
            tooltip: '<b>Registrar Licencia</b><br/>Permite registrar una licencia'
        });

        this.addButton('btnPares',{
                text: 'Arma Pares',
                iconCls: 'bchecklist',
                disabled: false,
                handler: this.armarPares,
                tooltip: '<b>Generar pares</b><br/>Trae los marcados segun periodo seleccionado'
            }
        );
        this.addButton('btnHojaTiempo',{
                text: 'Generar HT',
                iconCls: 'bchecklist',
                disabled: false,
                handler: this.onHojaTiempo,
                tooltip: '<b>Generar pares</b><br/>Trae los marcados segun periodo seleccionado'
            }
        );

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
                    if (record.data.tdo === 'to'){
                        color = '#b8271d';
                    }else{
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
                name: 'rango',
                fieldLabel: 'Rango',
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
                name: 'tipo_verificacion',
                fieldLabel: 'Tipo Verificacion',
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
                name: 'fecha_marcado',
                fieldLabel: 'Fecha Marcado',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                format: 'd/m/Y',
                renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
            type:'DateField',
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
        {name:'fecha_marcado', type: 'date',dateFormat:'Y-m-d'},
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
        {name:'rango', type: 'string'},
        {name:'tdo', type: 'string'},
        {name:'desc_funcionario', type: 'string'}
    ],
	sortInfo:{
		field: 'fecha_marcado',
		direction: 'ASC'
	},
    bdel:false,
    bsave:false,
    bedit:false,
    bnew:true,
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
    armarPares:function () {
        if(this.validarFiltros()) {
            Phx.CP.loadingShow();
            var id;
            if (Phx.CP.config_ini.id_funcionario !== ''){
                id = Phx.CP.config_ini.id_funcionario;
            }else {
                id = null;
            }
            Ext.Ajax.request({
                url: '../../sis_asistencia/control/Pares/armarPares',
                params: {id_periodo: this.cmbPeriodo.getValue(),
                        id_funcionario: id},
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
        var rec = this.getSelectedData();
        if (rec.tdo === 'to'){
            this.getBoton('RegistrarLicencia').enable();
        }
    },
    liberaMenu:function(){
        var tb = Phx.vista.Pares.superclass.liberaMenu.call(this);
        if(tb){
            this.getBoton('RegistrarLicencia').disable();
        }
        return tb
    },
    onHojaTiempo :function () {
      console.log('entra');
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
        valueField: 'periodo',
        triggerAction: 'all',
        displayField: 'literal',
        hiddenName: 'id_periodo',
        mode:'remote',
        pageSize:50,
        disabled: true,
        queryDelay:500,
        listWidth:'280',
        width:80
    })

	}
)
</script>
		
		