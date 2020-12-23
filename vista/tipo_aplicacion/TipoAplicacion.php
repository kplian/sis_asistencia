<?php
/**
*@package pXP
*@file gen-TipoAplicacion.php
*@author  (miguel.mamani)
*@date 21-02-2019 13:27:56
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.TipoAplicacion=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.TipoAplicacion.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag}})
	},
			
	Atributos:[
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
			config:{
				name: 'nombre',
				fieldLabel: 'Nombre',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100
			},
				type:'TextField',
				filters:{pfiltro:'tas.nombre',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'descripcion',
				fieldLabel: 'Descripcion',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100
			},
				type:'TextField',
				filters:{pfiltro:'tas.descripcion',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'codigo_aplicacion',
				fieldLabel: 'Codigo Aplicacion',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100
			},
				type:'TextField',
				filters:{pfiltro:'tas.codigo_aplicacion',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
        {
            config: {
                name: 'id_tipo_columna',
                fieldLabel: 'Tipo Columna',
                allowBlank: true,
                emptyText: 'Elija una opción...',
                store: new Ext.data.JsonStore({
                    url: '../../sis_planillas/control/TipoColumna/listarTipoColumna',
                    id: 'id_tipo_columna',
                    root: 'datos',
                    sortInfo: {
                        field: 'nombre',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_tipo_columna', 'nombre', 'codigo'],
                    remoteSort: true,
                    baseParams: {par_filtro: 'tipcol.nombre#tipcol.codigo'}
                }),
                valueField: 'id_tipo_columna',
                displayField: 'nombre',
                gdisplayField: 'desc_tipo_columna',
                hiddenName: 'id_tipo_columna',
                forceSelection: true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender: true,
                mode: 'remote',
                pageSize: 15,
                queryDelay: 1000,
                anchor: '80%',
                gwidth: 70,
                minChars: 2,
                renderer : function(value, p, record) {
                    return String.format('{0}', record.data['desc_tipo_columna']);
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
                name: 'consolidable',
                fieldLabel: 'Consolidable',
                allowBlank: true,
                anchor: '40%',
                gwidth: 50,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                store:['si','no']
            },
            type:'ComboBox',
            filters:{pfiltro:'tas.consolidable',type:'string'},
            id_grupo:1,
            valorInicial: 'no',
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
            filters:{pfiltro:'tas.estado_reg',type:'string'},
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
				filters:{pfiltro:'tas.id_usuario_ai',type:'numeric'},
				id_grupo:1,
				grid:false,
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
				filters:{pfiltro:'tas.fecha_reg',type:'date'},
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
				filters:{pfiltro:'tas.usuario_ai',type:'string'},
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
				name: 'fecha_mod',
				fieldLabel: 'Fecha Modif.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'tas.fecha_mod',type:'date'},
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
	title:'Tipo Aplicación',
	ActSave:'../../sis_asistencia/control/TipoAplicacion/insertarTipoAplicacion',
	ActDel:'../../sis_asistencia/control/TipoAplicacion/eliminarTipoAplicacion',
	ActList:'../../sis_asistencia/control/TipoAplicacion/listarTipoAplicacion',
	id_store:'id_tipo_aplicacion',
	fields: [
		{name:'id_tipo_aplicacion', type: 'numeric'},
		{name:'id_tipo_columna', type: 'numeric'},
		{name:'nombre', type: 'string'},
		{name:'descripcion', type: 'string'},
		{name:'codigo_aplicacion', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'consolidable', type: 'string'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
        {name:'desc_tipo_columna', type: 'string'}
		
	],
	sortInfo:{
		field: 'id_tipo_aplicacion',
		direction: 'ASC'
	},
	bdel:true,
	bsave:false
	}
)
</script>
		
		