<?php
/**
*@package pXP
*@file gen-IngresoSalida.php
*@author  (jjimenez)
*@date 14-08-2019 12:53:11
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema


HISTORIAL DE MODIFICACIONES:

#ISSUE				FECHA				AUTOR				DESCRIPCION

 #14			23-08-2019 12:53:11		Juan 				Archivo Nuevo Control diario de ingreso salida a la empresa Ende Transmision S.A.'

 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.IngresoSalida=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.IngresoSalida.superclass.constructor.call(this,config);
		this.init();
		this.load({params:{start:0, limit:this.tam_pag}})
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_ingreso_salida'
			},
			type:'Field',
			form:true 
		},
        {
            config:{
                name:'id_funcionario',
                hiddenName: 'id_funcionario',
                origen:'FUNCIONARIOCAR',
                fieldLabel:'Funcionario',
                allowBlank:true,
                gwidth:200,
                valueField: 'id_funcionario',
                gdisplayField: 'funcionario',
                baseParams: {par_filtro: 'id_funcionario#desc_funcionario1#codigo'},
                renderer:function(value, p, record){return String.format('{0}', record.data['funcionario']);}
            },
            type:'ComboRec',//ComboRec
            id_grupo:0,
            filters:{pfiltro:'fun.desc_funcionario1',type:'string'},
            bottom_filter:false,
            grid:true,
            form:true
        },

        {
            config:{
                name: 'fecha',
                fieldLabel: 'fecha',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                format: 'd/m/Y',
                renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
            type:'DateField',
            filters:{pfiltro:'condia.fecha',type:'date'},
            id_grupo:1,
            grid:true,
            form:false
        },
		{
			config:{
				name: 'hora',
				fieldLabel: 'hora',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:8
			},
				type:'TextField',
				filters:{pfiltro:'condia.hora',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
        {
            config:{
                name: 'funcionario',
                fieldLabel: 'Funcionario',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:8
            },
            type:'TextField',
            filters:{pfiltro:'condia.funcionario',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config: {
                name: 'tipo',
                fieldLabel: 'Tipo',
                allowBlank: false,
                emptyText: 'Elija una opción...',
                store: new Ext.data.ArrayStore({
                    id: 0,
                    fields: [
                        'tipo'
                    ],
                    data: [['Ingreso'], ['Salida']]
                }),
                valueField: 'tipo',
                displayField: 'tipo',
                gdisplayField: 'tipo',
                hiddenName: 'tipo',
                //forceSelection: true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender: true,
                mode: 'local',
                pageSize: 15,
                queryDelay: 1000,
                anchor: '50%',
                gwidth: 150,
                minChars: 2,
            },
            type: 'ComboBox',
            id_grupo: 0,
            filters: {pfiltro: 'condia.tipo', type: 'string'},
            grid: true,
            //egrid: true,
            id_grupo: 0,
            form: true
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
				filters:{pfiltro:'condia.estado_reg',type:'string'},
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
				filters:{pfiltro:'condia.id_usuario_ai',type:'numeric'},
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
		/*{
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
				filters:{pfiltro:'condia.fecha_reg',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		},*/
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
				filters:{pfiltro:'condia.usuario_ai',type:'string'},
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
				filters:{pfiltro:'condia.fecha_mod',type:'date'},
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
	title:'Control diario',
	ActSave:'../../sis_asistencia/control/IngresoSalida/insertarIngresoSalida',
	ActDel:'../../sis_asistencia/control/IngresoSalida/eliminarIngresoSalida',
	ActList:'../../sis_asistencia/control/IngresoSalida/listarIngresoSalida',
	id_store:'id_ingreso_salida',
	fields: [
		{name:'id_ingreso_salida', type: 'numeric'},
		{name:'id_funcionario', type: 'numeric'},
		{name:'hora', type: 'string'},
		{name:'fecha', type: 'date',dateFormat:'Y-m-d'},
		{name:'tipo', type: 'string'},
		{name:'estado_reg', type: 'string'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
        {name:'funcionario', type: 'string'},
		
	],
	sortInfo:{
		field: 'id_ingreso_salida',
		direction: 'ASC'
	},
	bdel:false,
	bsave:true,
    bedit:false
	}
)
</script>
		
		