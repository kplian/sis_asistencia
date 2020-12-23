<?php
/**
*@package pXP
*@file gen-Reposicion.php
*@author  (admin.miguel)
*@date 15-10-2020 18:57:40
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				15-10-2020				 (admin.miguel)				CREACION	

*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.Reposicion=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.Reposicion.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag}})
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_reposicion'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_transacion_zkb'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_transacion_zkb'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
					labelSeparator:'id_funcionario',
					inputType:'hidden',
					name: 'id_permiso'
			},
			type:'Field',
			form:true 
		},
		{
			config:{
				name: 'obs_dba',
				fieldLabel: 'obs_dba',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:-5
			},
				type:'TextField',
				filters:{pfiltro:'rpc.obs_dba',type:'string'},
				id_grupo:1,
				grid:false,
				form:false
		},
		{
			config:{
				name: 'nro_tramite',
				fieldLabel: 'Nro Tramite',
				allowBlank: true,
				anchor: '80%',
				gwidth: 200,
			},
				type:'TextField',
				filters:{pfiltro:'pe.nro_tramite',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'tipo_permiso',
				fieldLabel: 'Tipo Permiso',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
			},
				type:'TextField',
				filters:{pfiltro:'tp.nombre',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'desc_funcionario1',
				fieldLabel: 'Funcionario',
				allowBlank: true,
				anchor: '80%',
				gwidth: 300,
			},
				type:'TextField',
				filters:{pfiltro:'fun.desc_funcionario1',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'fecha_reposicion',
				fieldLabel: 'Fecha Reposicion',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'rpc.fecha_reposicion',type:'date'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'evento',
				fieldLabel: 'Estado',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:30
			},
				type:'TextField',
				filters:{pfiltro:'rpc.evento',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'tiempo',
				fieldLabel: 'Tiempo',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:20
			},
				type:'TextField',
				filters:{pfiltro:'rpc.tiempo',type:'string'},
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
				filters:{pfiltro:'rpc.estado_reg',type:'string'},
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
				filters:{pfiltro:'rpc.fecha_reg',type:'date'},
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
				filters:{pfiltro:'rpc.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'rpc.usuario_ai',type:'string'},
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
				filters:{pfiltro:'rpc.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Reposicion',
	ActSave:'../../sis_asistencia/control/Reposicion/insertarReposicion',
	ActDel:'../../sis_asistencia/control/Reposicion/eliminarReposicion',
	ActList:'../../sis_asistencia/control/Reposicion/listarReposicion',
	id_store:'id_reposicion',
	fields: [
		{name:'id_reposicion', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'obs_dba', type: 'string'},
		{name:'id_permiso', type: 'numeric'},
		{name:'fecha_reposicion', type: 'date',dateFormat:'Y-m-d'},
		{name:'id_funcionario', type: 'numeric'},
		{name:'evento', type: 'string'},
		{name:'tiempo', type: 'string'},
		{name:'id_transacion_zkb', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
		{name:'desc_funcionario1', type: 'string'},
		{name:'tipo_permiso', type: 'string'},
		{name:'nro_tramite', type: 'string'},

		
	],
	sortInfo:{
		field: 'id_reposicion',
		direction: 'ASC'
	},
	bdel:false,
	bsave:false,
	bnew:false,
	bedit:false
	}
)
</script>
		
		