<?php
/**
*@package pXP
*@file gen-MesTrabajoCon.php
*@author  (miguel.mamani)
*@date 13-03-2019 13:52:11
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.MesTrabajoCon=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
        this.initButtons=[this.cmbAplicacion];
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.MesTrabajoCon.superclass.constructor.call(this,config);
        this.cmbAplicacion.on('select', function(combo, record, index){
            this.capturaFiltros();
        },this);
		this.init();
        var dataPadre = Phx.CP.getPagina(this.idContenedorPadre).getSelectedData();
        if(dataPadre){
            this.onEnablePanel(this, dataPadre);
        }
        else
        {
            this.bloquearMenus();
        }
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_mes_trabajo_con'
			},
			type:'Field',
			form:true 
		},
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
					name: 'id_tipo_aplicacion'
			},
			type:'Field',
			form:true
		},
        {
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_centro_costo'
			},
			type:'Field',
			form:true
		},
        {
            config:{
                name: 'codigo_aplicacion',
                fieldLabel: 'Aplicacion',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:5
            },
            type:'TextField',
            filters:{pfiltro:'mtf.codigo_aplicacion',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'codigo_tcc',
                fieldLabel: 'Centro Costo',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:5
            },
            type:'TextField',
            filters:{pfiltro:'cc.codigo_tcc',type:'string'},
            id_grupo:1,
            grid:true,
            form:true
        },
		{
			config:{
				name: 'total_horas',
				fieldLabel: 'Total Horas',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:6553602
			},
				type:'NumberField',
				filters:{pfiltro:'mtf.total_horas',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
        {
            config:{
                name: 'factor',
                fieldLabel: 'Factor',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                renderer:function(value, p, record){
                    return String.format('<div align="center"><b><font size=1>{0}</font></b></div>',parseFloat(value).toFixed(2)+"%");
                }
            },
            type:'NumberField',
            filters:{pfiltro:'mtf.factor',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'calculado_resta',
                fieldLabel: 'Calculado Resta',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:5
            },
            type:'TextField',
            filters:{pfiltro:'mtf.calculado_resta',type:'string'},
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
				filters:{pfiltro:'mtf.estado_reg',type:'string'},
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
				filters:{pfiltro:'mtf.id_usuario_ai',type:'numeric'},
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
				name: 'fecha_reg',
				fieldLabel: 'Fecha creación',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'mtf.fecha_reg',type:'date'},
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
				filters:{pfiltro:'mtf.usuario_ai',type:'string'},
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
				filters:{pfiltro:'mtf.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Mes Trabajo Factor',
	ActSave:'../../sis_asistencia/control/MesTrabajoCon/insertarMesTrabajoCon',
	ActDel:'../../sis_asistencia/control/MesTrabajoCon/eliminarMesTrabajoCon',
	ActList:'../../sis_asistencia/control/MesTrabajoCon/listarMesTrabajoCon',
	id_store:'id_mes_trabajo_con',
	fields: [
		{name:'id_mes_trabajo_con', type: 'numeric'},
		{name:'id_tipo_aplicacion', type: 'numeric'},
		{name:'total_horas', type: 'numeric'},
		{name:'id_centro_costo', type: 'numeric'},
		{name:'calculado_resta', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'factor', type: 'numeric'},
		{name:'id_mes_trabajo', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'codigo_aplicacion', type: 'string'},
		{name:'codigo_tcc', type: 'string'}
		
	],
	sortInfo:{
		field: 'codigo_aplicacion',
		direction: 'ASC'
	},
	bdel:false,
	bsave:false,
    bnew:false,
    bedit:false,

    onReloadPage:function(m){
        this.maestro=m;
        this.store.baseParams = {id_mes_trabajo: this.maestro.id_mes_trabajo};
        this.load({params:{start:0, limit:50}})
    },
    loadValoresIniciales: function () {
        this.Cmp.id_mes_trabajo.setValue(this.maestro.id_mes_trabajo);
        Phx.vista.MesTrabajoCon.superclass.loadValoresIniciales.call(this);
    },
    capturaFiltros:function(combo, record, index){
        // this.desbloquearOrdenamientoGrid();
        if(this.validarFiltros()){
            this.store.baseParams.id_tipo_aplicacion = this.cmbAplicacion.getValue();
            this.load();
        }

    },
    validarFiltros:function(){
        if(this.cmbAplicacion.validate()){
            console.log('bien');
            return true;
        } else{
            console.log('mal');
            return false;

        }
    },
    cmbAplicacion: new Ext.form.ComboBox({
        fieldLabel: 'Aplicacion',
        allowBlank: false,
        emptyText:'Aplicacion...',
        store:new Ext.data.JsonStore(
            {
                url: '../../sis_asistencia/control/TipoAplicacion/listarTipoAplicacion', //#4
                id: 'id_tipo_aplicacion',
                root: 'datos',
                sortInfo:{
                    field: 'id_tipo_aplicacion',
                    direction: 'DESC'
                },
                totalProperty: 'total',
                fields: ['id_tipo_aplicacion','codigo_aplicacion'],
                // turn on remote sorting
                remoteSort: true,
                baseParams:{par_filtro:'codigo_aplicacion'}
            }),
        valueField: 'id_tipo_aplicacion',
        triggerAction: 'all',
        displayField: 'codigo_aplicacion',
        hiddenName: 'id_tipo_aplicacion',
        mode:'remote',
        pageSize:1000,
        queryDelay:500,
        listWidth:'280',
        width:80
    })

	}

)
</script>
		
		