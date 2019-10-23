<?php
/**
*@package pXP
*@file gen-MovimientoVacacion.php
*@author  (miguel.mamani)
*@date 08-10-2019 10:39:21
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
 #0				08-10-2019				 (miguel.mamani)				CREACION	

*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.MovimientoVacacion=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.MovimientoVacacion.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag}})
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_movimiento_vacacion'
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
				name: 'desde',
				fieldLabel: 'Desde',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'mvs.desde',type:'date'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'hasta',
				fieldLabel: 'Hasta',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
							format: 'd/m/Y', 
							renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'mvs.hasta',type:'date'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
				name: 'tipo',
				fieldLabel: 'Evento',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100
			},
				type:'Field',
				filters:{pfiltro:'mvs.tipo',type:'string'},
				id_grupo:1,
				grid:true,
				form:true
		},

        {
            config:{
                name: 'dias',
                fieldLabel: 'Dias',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100
            },
            type:'NumberField',
            filters:{pfiltro:'mvs.dias',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },

		{
			config:{
				name: 'dias_actual',
				fieldLabel: 'Saldo',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100
			},
				type:'NumberField',
				bottom_filter: true,
				filters:{pfiltro:'mvs.dias_actual',type:'numeric'},
				id_grupo:1,
				grid:true,
				form:true
		},
		{
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'nombre'
			},
			type:'Field',
			bottom_filter: true,
			filters:{pfiltro:'p.nombre',type:'string'},
			form:true 
		},
		{
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'apellido_materno'
			},
			type:'Field',
			bottom_filter: true,
			filters:{pfiltro:'p.apellido_materno',type:'string'},
			form:true 
		},
		{
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'apellido_paterno'
			},
			type:'Field',
			bottom_filter: true,
			filters:{pfiltro:'p.apellido_paterno',type:'string'},
			form:true 
		},
        {
            config:{
                name: 'funcionario',
                fieldLabel: 'Funcionario',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:4
            },
            type:'Field',
            filters:{pfiltro:'funcionario',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },

        {
            config:{
                name: 'activo',
                fieldLabel: 'Estado',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:10
            },
            type:'TextField',
            filters:{pfiltro:'mvs.activo',type:'string'},
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
							//format: 'd/m/Y',
							//renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
			},
				type:'DateField',
				filters:{pfiltro:'mvs.fecha_reg',type:'date'},
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
				filters:{pfiltro:'mvs.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'mvs.usuario_ai',type:'string'},
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
				filters:{pfiltro:'mvs.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,	
	title:'Movimiento Vacaciones',
	ActSave:'../../sis_asistencia/control/MovimientoVacacion/insertarMovimientoVacacion',
	ActDel:'../../sis_asistencia/control/MovimientoVacacion/eliminarMovimientoVacacion',
	ActList:'../../sis_asistencia/control/MovimientoVacacion/listarMovimientoVacacion',
	id_store:'id_movimiento_vacacion',
	fields: [
		{name:'id_movimiento_vacacion', type: 'numeric'},
		{name:'activo', type: 'string'},
		{name:'id_funcionario', type: 'numeric'},
		{name:'desde', type: 'date',dateFormat:'Y-m-d'},
		{name:'hasta', type: 'date',dateFormat:'Y-m-d'},
		{name:'dias', type: 'numeric'},
		{name:'tipo', type: 'string'},
		
		{name:'dias_actual', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'string'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
        {name:'funcionario', type: 'string'},
        {name:'nombre', type: 'string'},
        {name:'apellido_paterno', type: 'string'},
        {name:'apellido_materno', type: 'string'}

		
	],
	sortInfo:{
		field: 'id_movimiento_vacacion',
		direction: 'ASC'
	},
	bdel:false,
	bsave:false,
    bnew:false,
    bedit:false
	}
)
</script>
		
		