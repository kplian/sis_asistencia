<?php
/**
*@package pXP
*@file gen-RangoHorario.php
*@author  (mgarcia)
*@date 19-08-2019 15:28:39
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.RangoHorario=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.RangoHorario.superclass.constructor.call(this,config);
		this.init();
        this.grid.addListener('cellclick', this.oncellclick,this);
        this.load({params:{start:0, limit:this.tam_pag}})
	},
			
	Atributos:[
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
			config:{
				name: 'codigo',
				fieldLabel: 'Código',
				allowBlank: false,
				anchor: '80%',
				gwidth: 100,
				maxLength:5
			},
				type:'TextField',
				filters:{pfiltro:'rho.codigo',type:'string'},
				id_grupo:0,
				grid:true,
				form:true,
                egrid:true

        },
		{
			config:{
				name: 'descripcion',
				fieldLabel: 'Descripción',
				allowBlank: false,
				anchor: '80%',
				gwidth: 150,
				maxLength:50
			},
				type:'TextArea',
				filters:{pfiltro:'rho.descripcion',type:'string'},
				id_grupo:0,
				grid:true,
				form:true,
                egrid:true

        },
        {
            config:{
                name: 'fecha_desde',
                fieldLabel: 'Desde',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                format: 'd/m/Y',
                renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
            },
            type:'DateField',
            filters:{pfiltro:'rho.fecha_desde',type:'date'},
            id_grupo:0,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'fecha_hasta',
                fieldLabel: 'Hesde',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                format: 'd/m/Y',
                renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
            },
            type:'DateField',
            filters:{pfiltro:'rho.fecha_hasta',type:'date'},
            id_grupo:0,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'lunes',
                fieldLabel: 'Lunes',
                allowBlank: true,
                anchor: '40%',
                gwidth: 50,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                store:['si','no'],
                renderer:function (value,p,record){
                    var checked = '';
                    if(value === 'si'){
                        checked = 'checked';
                    }
                    return  String.format('<div style="vertical-align:middle;text-align:center;"><input style="height:30px;width:30px;" type="checkbox"{0}></div>',checked);

                }
            },
            type:'ComboBox',
            id_grupo:3,
            valorInicial: 'no',
            filters: { pfiltro: 'rho.lunes', type: 'string' },
            grid: true,
            form: true
        },
        {
            config:{
                name: 'martes',
                fieldLabel: 'Martes',
                allowBlank: true,
                anchor: '40%',
                gwidth: 50,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                store:['si','no'],
                renderer:function (value,p,record){
                    var checked = '';
                    if(value === 'si'){
                        checked = 'checked';
                    }
                    return  String.format('<div style="vertical-align:middle;text-align:center;"><input style="height:30px;width:30px;" type="checkbox"{0}></div>',checked);

                }
            },
            type:'ComboBox',
            id_grupo:3,
            valorInicial: 'no',
            filters: { pfiltro: 'rho.martes', type: 'string' },
            grid: true,
            form: true
        },
        {
            config:{
                name: 'miercoles',
                fieldLabel: 'Miercoles',
                allowBlank: true,
                anchor: '40%',
                gwidth: 50,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                store:['si','no'],
                renderer:function (value,p,record){
                    var checked = '';
                    if(value === 'si'){
                        checked = 'checked';
                    }
                    return  String.format('<div style="vertical-align:middle;text-align:center;"><input style="height:30px;width:30px;" type="checkbox"{0}></div>',checked);

                }
            },
            type:'ComboBox',
            id_grupo:3,
            valorInicial: 'no',
            filters: { pfiltro: 'rho.miercoles', type: 'string' },
            grid: true,
            form: true
        },
        {
            config:{
                name: 'jueves',
                fieldLabel: 'Jueves',
                allowBlank: true,
                anchor: '40%',
                gwidth: 50,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                store:['si','no'],
                renderer:function (value,p,record){
                    var checked = '';
                    if(value === 'si'){
                        checked = 'checked';
                    }
                    return  String.format('<div style="vertical-align:middle;text-align:center;"><input style="height:30px;width:30px;" type="checkbox"{0}></div>',checked);

                }
            },
            type:'ComboBox',
            id_grupo:3,
            valorInicial: 'no',
            filters: { pfiltro: 'rho.jueves', type: 'string' },
            grid: true,
            form: true
        },
        {
            config:{
                name: 'viernes',
                fieldLabel: 'Viernes',
                allowBlank: true,
                anchor: '40%',
                gwidth: 50,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                store:['si','no'],
                renderer:function (value,p,record){
                    var checked = '';
                    if(value === 'si'){
                        checked = 'checked';
                    }
                    return  String.format('<div style="vertical-align:middle;text-align:center;"><input style="height:30px;width:30px;" type="checkbox"{0}></div>',checked);

                }
            },
            type:'ComboBox',
            id_grupo:3,
            valorInicial: 'no',
            filters: { pfiltro: 'rho.viernes', type: 'string' },
            grid: true,
            form: true
        },
        {
            config:{
                name: 'sabado',
                fieldLabel: 'Sabado',
                allowBlank: true,
                anchor: '40%',
                gwidth: 50,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender:true,
                mode: 'local',
                store:['si','no'],
                renderer:function (value,p,record){
                    var checked = '';
                    if(value === 'si'){
                        checked = 'checked';
                    }
                    return  String.format('<div style="vertical-align:middle;text-align:center;"><input style="height:30px;width:30px;" type="checkbox"{0}></div>',checked);

                }
            },
            type:'ComboBox',
            id_grupo:3,
            valorInicial: 'no',
            filters: { pfiltro: 'rho.sabado', type: 'string' },
            grid: true,
            form: true
        },
        {
            config:{
                name: 'rango_entrada_ini',
                fieldLabel: 'Rango Entrada Inicial',
                allowBlank: false,
                anchor: '50%',
                gwidth: 100,
                maxLength:8,
                format: 'H:i',
                increment: 1
            },
            type:'TimeField',
            filters:{pfiltro:'rho.rango_entrada_ini',type:'string'},
            id_grupo:1,
            grid:true,
            form:true,
            egrid:true
        },
		{
            config:{
                name: 'hora_entrada',
                fieldLabel: 'Hora Entrada',
                increment: 15,
                allowBlank: false,
                anchor: '50%',
                gwidth: 100,
                maxLength:8,
                format: 'H:i',
                increment: 1
            },
            type:'TimeField',
            filters:{pfiltro:'rho.hora_entrada',type:'string'},
            id_grupo:1,
            grid:true,
            form:true,
            egrid:true

        },
        {
            config:{
                name: 'rango_entrada_fin',
                fieldLabel: 'Rango Entrada Final',
                increment: 15,
                allowBlank: false,
                anchor: '50%',
                gwidth: 100,
                maxLength:8,
                format: 'H:i',
                increment: 1
            },
            type:'TimeField',
            filters:{pfiltro:'rho.rango_entrada_fin',type:'string'},
            id_grupo:1,
            grid:true,
            form:true,
            egrid:true

        },
        {
            config:{
                name: 'rango_salida_ini',
                fieldLabel: 'Rango Salida Inicial',
                increment: 15,
                allowBlank: false,
                anchor: '50%',
                gwidth: 100,
                maxLength:8,
                format: 'H:i',
                increment: 1
            },
            type:'TimeField',
            filters:{pfiltro:'rho.rango_salida_ini',type:'string'},
            id_grupo:2,
            grid:true,
            form:true,
            egrid:true

        },
        {
            config:{
                name: 'hora_salida',
                fieldLabel: 'Hora Salida',
                increment: 15,
                allowBlank: false,
                anchor: '50%',
                gwidth: 100,
                maxLength:8,
                format: 'H:i',
                increment: 1
            },
            type:'TimeField',
            filters:{pfiltro:'rho.hora_salida',type:'string'},
            id_grupo:2,
            grid:true,
            form:true,
            egrid:true

        },
        {
            config:{
                name: 'rango_salida_fin',
                fieldLabel: 'Rango Salida Final',
                increment: 15,
                allowBlank: false,
                anchor: '50%',
                gwidth: 100,
                maxLength:8,
                format: 'H:i',
                increment: 1
            },
            type:'TimeField',
            filters:{pfiltro:'rho.rango_salida_fin',type:'string'},
            id_grupo:2,
            grid:true,
            form:true,
            egrid:true

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
            filters:{pfiltro:'rho.estado_reg',type:'string'},
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
				filters:{pfiltro:'rho.fecha_reg',type:'date'},
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
				filters:{pfiltro:'rho.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'rho.usuario_ai',type:'string'},
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
				filters:{pfiltro:'rho.fecha_mod',type:'date'},
				id_grupo:1,
				grid:true,
				form:false
		}
	],
	tam_pag:50,
    fheight: '85%',
	title:'Rango de Horarios',
	ActSave:'../../sis_asistencia/control/RangoHorario/insertarRangoHorario',
	ActDel:'../../sis_asistencia/control/RangoHorario/eliminarRangoHorario',
	ActList:'../../sis_asistencia/control/RangoHorario/listarRangoHorario',
	id_store:'id_rango_horario',
	fields: [
		{name:'id_rango_horario', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'codigo', type: 'string'},
		{name:'descripcion', type: 'string'},
		{name:'hora_entrada', type: 'string'},
		{name:'hora_salida', type: 'string'},
		{name:'rango_entrada_ini', type: 'string'},
		{name:'rango_entrada_fin', type: 'string'},
		{name:'rango_salida_ini', type: 'string'},
		{name:'rango_salida_fin', type: 'string'},
		{name:'fecha_desde', type: 'date',dateFormat:'Y-m-d'},
		{name:'fecha_hasta', type: 'date',dateFormat:'Y-m-d'},
		{name:'tolerancia_retardo', type: 'numeric'},
		{name:'jornada_laboral', type: 'numeric'},
		{name:'lunes', type: 'string'},
		{name:'martes', type: 'string'},
		{name:'miercoles', type: 'string'},
		{name:'jueves', type: 'string'},
		{name:'viernes', type: 'string'},
		{name:'sabado', type: 'string'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'}
		
	],
	sortInfo:{
		field: 'id_rango_horario',
		direction: 'ASC'
	},
    oncellclick : function(grid, rowIndex, columnIndex, e) {
        const record = this.store.getAt(rowIndex),
              fieldName = grid.getColumnModel().getDataIndex(columnIndex); // Get field name
        if (fieldName === 'lunes' || fieldName === 'martes'|| fieldName === 'miercoles' ||
            fieldName === 'jueves' || fieldName === 'viernes'|| fieldName === 'sabado')
        this.cambiarAsignacion(record,fieldName);
    },
    cambiarAsignacion: function(record,name){
        Phx.CP.loadingShow();
        var d = record.data;
        Ext.Ajax.request({
            url:'../../sis_asistencia/control/RangoHorario/asignarDia',
            params:{ id_rango_horario: d.id_rango_horario,
                     field_name: name
            },
            success: this.successRevision,
            failure: this.conexionFailure,
            timeout: this.timeout,
            scope: this
        });
        this.reload();
    },
    successRevision: function(resp){
        Phx.CP.loadingHide();
        var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
    },
    tabsouth:[
        {
            url:'../../../sis_asistencia/vista/asignar_rango/AsignarRango.php',
            title:'Asignar Rango',
            height:'50%',
            cls:'AsignarRango'
        }
    ],
    Grupos:
        [
            {
                layout: 'column',
                border: false,
                defaults: {
                    border: false
                },
                items : [{
                    bodyStyle : 'padding-left:5px;padding-left:5px;',
                    border : false,
                    defaults : {
                        border : false
                    },
                    width : 600,
                    items: [{
                        bodyStyle: 'padding-right:5px;',
                        items: [{
                            xtype: 'fieldset',
                            title: 'Datos Generales',
                            autoHeight: true,
                            items: [],
                            id_grupo:0
                        }]
                    },{
                        bodyStyle: 'padding-right:5px;',
                        items: [{
                            xtype: 'fieldset',
                            title: 'Horarios Entrada',
                            autoHeight: true,
                            items: [],
                            id_grupo:1
                        }]
                    },{
                        bodyStyle: 'padding-right:5px;',
                        items: [{
                            xtype: 'fieldset',
                            title: 'Horarios Salida',
                            autoHeight: true,
                            items: [],
                            id_grupo:2
                        }]
                    },{
                        bodyStyle: 'padding-left:5px;',
                        items: [{
                            xtype: 'fieldset',
                            title: 'Días asociados al horario',
                            autoHeight: true,
                            items: [],
                            id_grupo:3
                        }]
                    }]
                }] //
            }
        ],
	bdel:true,
	bsave:true
	}
)
</script>
		
		