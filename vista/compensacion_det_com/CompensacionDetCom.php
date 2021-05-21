<?php
/****************************************************************************************
*@package pXP
*@file gen-CompensacionDetCom.php
*@author  (amamani)
*@date 21-05-2021 17:01:17
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema

HISTORIAL DE MODIFICACIONES:
#ISSUE                FECHA                AUTOR                DESCRIPCION
 #0                21-05-2021 17:01:17    amamani            Creacion    
 #   

*******************************************************************************************/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.CompensacionDetCom=Ext.extend(Phx.gridInterfaz,{

    constructor:function(config){
        this.maestro=config.maestro;
        //llama al constructor de la clase padre
        Phx.vista.CompensacionDetCom.superclass.constructor.call(this,config);
        this.init();
    },
            
    Atributos:[
        {
            //configuracion del componente
            config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id_compensacion_det_com'
            },
            type:'Field',
            form:true 
        },
        {
            //configuracion del componente
            config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id_compensacion_det'
            },
            type:'Field',
            form:true
        },
        {
            config:{
                name: 'tiempo_comp',
                fieldLabel: 'Tiempo',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                maxLength:100,
                renderer: function (value, p, record) {
                    var result;
                    result = String.format('{0}', "<div style='text-align:center'><img src = '../../../sis_asistencia/media/completo.png' align='center' width='45' height='45' title=''/></div>");

                    if (value == 'mañana') {
                        result = String.format('{0}', "<div style='text-align:center'><img src = '../../../sis_asistencia/media/medio.png' align='center' width='45' height='45' title=''/></div>");
                    }
                    if (value == 'tarde') {
                        result = String.format('{0}', "<div style='text-align:center'><img src = '../../../sis_asistencia/media/tarde.png' align='center' width='39' height='39' title=''/></div>");
                    }

                    return result;
                }
            },
            type:'TextField',
            filters:{pfiltro:'fcn.tiempo_comp',type:'string'},
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'fecha_comp',
                fieldLabel: 'Fecha Compensación',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
                            format: 'd/m/Y', 
                            renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
                type:'DateField',
                filters:{pfiltro:'fcn.fecha_comp',type:'date'},
                id_grupo:1,
                grid:true,
                form:true
		},
        {
            config: {
                name: 'tiempo_comp',
                fieldLabel: 'Tiempo',
                allowBlank: false,
                width: '100%',
                anchor: '80%',
                typeAhead: true,
                triggerAction: 'all',
                lazyRender: true,
                mode: 'local',
                store: new Ext.data.ArrayStore({
                    fields: ['variable', 'valor'],
                    data: [
                        ['completo', 'Completo'],
                        ['mañana', 'Mañana'],
                        ['tarde', 'Tarde']
                    ]
                }),
                valueField: 'variable',
                displayField: 'valor',
                renderer: function (value, p, record) {
                    if (value === 'completo') {
                        return String.format('<p class="text-align:center"><b>Tiempo Completo</b></p>', value)
                    }
                    if (value === 'mañana') {
                        return String.format('<p class="text-align:center"><b>Mañana</b></p>', value)
                    }
                    if (value === 'tarde') {
                        return String.format('<p class="text-align:center"><b>Tarde</b></p>', value)
                    }
                }
            },
            type: 'ComboBox',
            filters: {pfiltro: 'tas.tiempo', type: 'string'},
            id_grupo: 1,
            // valorInicial: 'Completo',
            grid: true,
            form: false
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
            filters:{pfiltro:'fcn.estado_reg',type:'string'},
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
                filters:{pfiltro:'fcn.fecha_reg',type:'date'},
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
                filters:{pfiltro:'fcn.id_usuario_ai',type:'numeric'},
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
                filters:{pfiltro:'fcn.usuario_ai',type:'string'},
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
                filters:{pfiltro:'fcn.fecha_mod',type:'date'},
                id_grupo:1,
                grid:true,
                form:false
		}
    ],
    tam_pag:50,    
    title:'Fecha Compensación',
    ActSave:'../../sis_asistencia/control/CompensacionDetCom/insertarCompensacionDetCom',
    ActDel:'../../sis_asistencia/control/CompensacionDetCom/eliminarCompensacionDetCom',
    ActList:'../../sis_asistencia/control/CompensacionDetCom/listarCompensacionDetCom',
    id_store:'id_compensacion_det_com',
    fields: [
		{name:'id_compensacion_det_com', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'fecha_comp', type: 'date',dateFormat:'Y-m-d'},
		{name:'tiempo_comp', type: 'string'},
		{name:'id_compensacion_det', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'id_usuario_ai', type: 'numeric'},
		{name:'usuario_ai', type: 'string'},
		{name:'id_usuario_mod', type: 'numeric'},
		{name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
		{name:'usr_mod', type: 'string'},
        
    ],
    sortInfo:{
        field: 'id_compensacion_det_com',
        direction: 'DESC'
    },
    bdel:true,
    bsave:true
    }
)
</script>
        
        