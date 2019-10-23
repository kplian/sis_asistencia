<?php
/**
*@package pXP
*@file gen-AsignarRango.php
*@author  (miguel.mamani)
*@date 05-09-2019 21:07:38
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.AsignarRango=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.AsignarRango.superclass.constructor.call(this,config);
		this.init();
		// this.load({params:{start:0, limit:this.tam_pag}})
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'asignar_rango'
			},
			type:'Field',
			form:true 
		},
        {
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_rango_horario'
			},
			type:'Field',
			form:true
		},
        {
            config : {
                name : 'id_funcionario',
                origen : 'FUNCIONARIOCAR',
                fieldLabel : 'Funcionario',
                gdisplayField : 'desc_funcionario', //mapea al store del grid
                valueField : 'id_funcionario',
                width : 300,
                gwidth: 250,
                renderer : function(value, p, record) {
                    return String.format('{0}', record.data['desc_funcionario']);
                }
            },
            type : 'ComboRec',
            id_grupo : 2,
            grid : true,
            form : true
        },
        {
            config : {
                name : 'id_uo',
                baseParams : {
                    gerencia : 'si'
                },
                origen : 'UO',
                allowBlank: true,
                fieldLabel : 'UO',
                gdisplayField : 'desc_uo', //mapea al store del grid
                width : 300,
                gwidth: 250,
                renderer : function(value, p, record) {
                    return String.format('{0}', record.data['desc_uo']);
                }
            },
            type : 'ComboRec',
            id_grupo : 1,
            filters : {
                pfiltro : 'desc_uo',
                type : 'string'
            },
            grid : true,
            form : true
        },
		{
			config:{
				name: 'desde',
				fieldLabel: 'Desde',
				allowBlank: true,
				gwidth: 100,
                width : 150,
                format: 'd/m/Y',
                renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
			},
				type:'DateField',
				filters:{pfiltro:'aro.desde',type:'date'},
				id_grupo:1,
				grid:true,
				form:true
		},
        {
            config:{
                name: 'hasta',
                fieldLabel: 'Hasta',
                allowBlank: true,
                gwidth: 100,
                width : 150,
                format: 'd/m/Y',
                renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
            type:'DateField',
            filters:{pfiltro:'aro.hasta',type:'date'},
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
            filters:{pfiltro:'aro.estado_reg',type:'string'},
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
				filters:{pfiltro:'aro.fecha_reg',type:'date'},
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
				filters:{pfiltro:'aro.usuario_ai',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
		{
			config:{
				name: 'id_usuario_ai',
				fieldLabel: 'Funcionaro AI',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'aro.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'aro.fecha_mod',type:'date'},
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
	title:'Asignar Rango',
	ActSave:'../../sis_asistencia/control/AsignarRango/insertarAsignarRango',
	ActDel:'../../sis_asistencia/control/AsignarRango/eliminarAsignarRango',
	ActList:'../../sis_asistencia/control/AsignarRango/listarAsignarRango',
	id_store:'asignar_rango',
	fields: [
		{name:'asignar_rango', type: 'numeric'},
		{name:'id_rango_horario', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'hasta', type: 'date',dateFormat:'Y-m-d'},
		{name:'id_uo', type: 'numeric'},
		{name:'id_funcionario', type: 'numeric'},
		{name:'desde', type: 'date',dateFormat:'Y-m-d'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
        {name:'desc_funcionario', type: 'string'},
        {name:'desc_uo', type: 'string'}
	],
	sortInfo:{
		field: 'asignar_rango',
		direction: 'ASC'
	},
	bdel:true,
	bsave:true,
    onReloadPage:function(m){
        this.maestro=m;
        this.store.baseParams = {id_rango_horario: this.maestro.id_rango_horario};
        this.load({params:{start:0, limit:50}})
    },
    loadValoresIniciales: function () {
        this.Cmp.id_rango_horario.setValue(this.maestro.id_rango_horario);
        Phx.vista.AsignarRango.superclass.loadValoresIniciales.call(this);
    }

	}
)
</script>
		
		