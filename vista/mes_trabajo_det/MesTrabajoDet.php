<?php
/**
*@package pXP
*@file gen-MesTrabajoDet.php
*@author  (miguel.mamani)
*@date 31-01-2019 16:36:51
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
*/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.MesTrabajoDet=Ext.extend(Phx.gridInterfaz,{

	constructor:function(config){
		this.maestro=config.maestro;
    	//llama al constructor de la clase padre
		Phx.vista.MesTrabajoDet.superclass.constructor.call(this,config);
		this.init();
        this.addButton('btnTransaccionesUpload',
            {
                text: 'Subir Trans.',
                iconCls: 'bchecklist',
                disabled: true,
                handler: this.SubirArchivo,
                tooltip: '<b>Subir Transacciones</b><br/>desde Excel (xlsx).'
            }
        );
	},
			
	Atributos:[
		{
			//configuracion del componente
			config:{
					labelSeparator:'',
					inputType:'hidden',
					name: 'id_mes_trabajo_det'
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
            config:{
                name: 'id_centro_costo',
                fieldLabel: 'Centro Costo',
                allowBlank: true,
                tinit: false,
                origen: 'CENTROCOSTO',
                gdisplayField: 'codigo_cc',
                width: 320,
                gwidth:300,
                disabled:false
            },
            type: 'ComboRec',
            id_grupo: 0,
            grid:true,
            form: true
        },
        {
            config:{
                name: 'dia',
                fieldLabel: 'Dia',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:4
            },
            type:'NumberField',
            filters:{pfiltro:'mtd.dia',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:false
        },
        {
			config:{
				name: 'ingreso_manana',
				fieldLabel: 'Ingreso Mañana',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:8
			},
				type:'TextField',
				filters:{pfiltro:'mtd.ingreso_manana',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
        {
            config:{
                name: 'salida_manana',
                fieldLabel: 'Salida Mañana',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:8
            },
            type:'TextField',
            filters:{pfiltro:'mtd.salida_manana',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },
		{
			config:{
				name: 'ingreso_tarde',
				fieldLabel: 'Ingreso Tarde',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:8
			},
				type:'TextField',
				filters:{pfiltro:'mtd.ingreso_tarde',type:'string'},
				id_grupo:1,
				grid:true,
				form:false
		},
        {
            config:{
                name: 'salida_tarde',
                fieldLabel: 'Salida Tarde',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:8
            },
            type:'TextField',
            filters:{pfiltro:'mtd.salida_tarde',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'ingreso_noche',
                fieldLabel: 'Ingreso Noche',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:8
            },
            type:'TextField',
            filters:{pfiltro:'mtd.ingreso_noche',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'salida_noche',
                fieldLabel: 'Salida Noche',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:8
            },
            type:'TextField',
            filters:{pfiltro:'mtd.salida_noche',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'tipo',
                fieldLabel: 'Tipo Mañana',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:6
            },
            type:'TextField',
            filters:{pfiltro:'mtd.tipo',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'tipo_dos',
                fieldLabel: 'Tipo Tarde',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:6
            },
            type:'TextField',
            filters:{pfiltro:'mtd.tipo_dos',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'tipo_tres',
                fieldLabel: 'Tipo Noche',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:6
            },
            type:'TextField',
            filters:{pfiltro:'mtd.tipo_tres',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'total_normal',
                fieldLabel: 'Total Normal',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:6553602,
                renderer: function(value,p,record){
                    if(record.data.estado_reg != 'summary'){
                        return String.format('<b><font size = 2 >{0}</font></b>', value);
                    }else{
                        return String.format('<b><font size = 2 color="green" >{0}</font></b>', value);
                    }
                }
            },
            type:'NumberField',
            filters:{pfiltro:'mtd.total_normal',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'total_extra',
                fieldLabel: 'Total Extra',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:6553602,
                renderer: function(value,p,record){
                    if(record.data.estado_reg != 'summary'){
                        return String.format('<b><font size = 2 >{0}</font></b>', value);
                    }else{
                        return String.format('<b><font size = 2 color="green" >{0}</font></b>', value);
                    }
                }
            },
            type:'NumberField',
            filters:{pfiltro:'mtd.total_extra',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'total_nocturna',
                fieldLabel: 'Total Nocturna',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:6553602,
                renderer: function(value,p,record){
                    if(record.data.estado_reg != 'summary'){
                        return String.format('<b><font size = 2 >{0}</font></b>', value);
                    }else{
                        return String.format('<b><font size = 2 color="green" >{0}</font></b>', value);
                    }
                }
            },
            type:'NumberField',
            filters:{pfiltro:'mtd.total_nocturna',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:true
        },
        {
            config:{
                name: 'extra_autorizada',
                fieldLabel: 'Extra Autorizada',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                maxLength:6553602,
                renderer: function(value,p,record){
                    if(record.data.estado_reg != 'summary'){
                        return String.format('<b><font size = 2 >{0}</font></b>', value);
                    }else{
                        return String.format('<b><font size = 2 color="green" >{0}</font></b>', value);
                    }
                }
            },
            type:'NumberField',
            filters:{pfiltro:'mtd.extra_autorizada',type:'numeric'},
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'justificacion_extra',
                fieldLabel: 'Justificacion Extra',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100
            },
            type:'TextArea',
            filters:{pfiltro:'mtd.justificacion_extra',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },
		{
			config:{
				name: 'estado_reg',
				fieldLabel: 'Estado Reg.',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:10,
                renderer:function (value,p,record){
                    if(record.data.estado_reg != 'summary'){
                        return  String.format('{0}',record.data.estado_reg);
                    }
                }
            },
				type:'TextField',
				filters:{pfiltro:'mtd.estado_reg',type:'string'},
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
				filters:{pfiltro:'mtd.usuario_ai',type:'string'},
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
				filters:{pfiltro:'mtd.fecha_reg',type:'date'},
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
				name: 'id_usuario_ai',
				fieldLabel: 'Creado por',
				allowBlank: true,
				anchor: '80%',
				gwidth: 100,
				maxLength:4
			},
				type:'Field',
				filters:{pfiltro:'mtd.id_usuario_ai',type:'numeric'},
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
				filters:{pfiltro:'mtd.fecha_mod',type:'date'},
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
	title:'Mes trabajo detalle',
	ActSave:'../../sis_asistencia/control/MesTrabajoDet/insertarMesTrabajoDet',
	ActDel:'../../sis_asistencia/control/MesTrabajoDet/eliminarMesTrabajoDet',
	ActList:'../../sis_asistencia/control/MesTrabajoDet/listarMesTrabajoDet',
	id_store:'id_mes_trabajo_det',
	fields: [
		{name:'id_mes_trabajo_det', type: 'numeric'},
		{name:'ingreso_manana', type: 'string'},
		{name:'id_mes_trabajo', type: 'numeric'},
		{name:'id_centro_costo', type: 'numeric'},
		{name:'ingreso_tarde', type: 'string'},
		{name:'extra_autorizada', type: 'numeric'},
		{name:'tipo', type: 'string'},
		{name:'ingreso_noche', type: 'string'},
		{name:'total_normal', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'total_extra', type: 'numeric'},
		{name:'salida_manana', type: 'string'},
		{name:'salida_tarde', type: 'string'},
		{name:'justificacion_extra', type: 'string'},
		{name:'salida_noche', type: 'string'},
		{name:'dia', type: 'numeric'},
		{name:'total_nocturna', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
        {name:'codigo_cc', type: 'string'},
        {name:'tipo_dos', type: 'string'},
        {name:'tipo_tres', type: 'string'}
	],
	sortInfo:{
		field: 'id_mes_trabajo_det',
		direction: 'ASC'
	},
	bdel:false,
	bsave:false,
    bnew:false,
    onReloadPage:function(m){
        this.maestro=m;
        this.store.baseParams = {id_mes_trabajo: this.maestro.id_mes_trabajo};
        Ext.apply(this.Cmp.id_centro_costo.store.baseParams,{id_gestion: this.maestro.id_gestion});
        this.load({params:{start:0, limit:50}})
    },
    loadValoresIniciales: function () {
        this.Cmp.id_mes_trabajo.setValue(this.maestro.id_mes_trabajo);
        Phx.vista.MesTrabajoDet.superclass.loadValoresIniciales.call(this);
    },
    SubirArchivo : function(rec) {
        Phx.CP.loadWindows('../../../sis_asistencia/vista/mes_trabajo_det/SubirArchivo.php',
            'Subir Transacciones desde Excel',
            {
                modal:true,
                width:450,
                height:150
            },this.maestro,this.idContenedor,'SubirArchivo');
    }
	}
)
</script>
		
		