<?php
/**
 *@package pXP
 *@file gen-TransaccionRep.php
 *@author  (miguel.mamani)
 *@date 22-10-2019 19:37:25
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
#0				22-10-2019				 (miguel.mamani)				CREACION

 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.TransaccionRep=Ext.extend(Phx.gridInterfaz,{
        constructor:function(config){
            this.maestro=config.maestro;
            //llama al constructor de la clase padre
            Phx.vista.TransaccionRep.superclass.constructor.call(this,config);
            this.init();
            this.load({params:{start:0, limit:this.tam_pag}})
        },

        Atributos:[
            {
                //configuracion del componente
                config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id_transaccion_bio'
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
                    name: 'id_periodo'
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
                config:{
                    name: 'dia',
                    fieldLabel: 'dia',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 50
                },
                type:'TextField',
                filters:{pfiltro:'trp.dia',type:'string'},
                id_grupo:1,
                grid:true,
                form:true
            },
            {
                config:{
                    name: 'fecha_marcado',
                    fieldLabel: 'fecha_marcado',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    format: 'd/m/Y',
                    renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
                },
                type:'DateField',
                filters:{pfiltro:'trp.fecha_marcado',type:'date'},
                id_grupo:1,
                grid:true,
                form:true
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
                filters:{pfiltro:'trp.hora',type:'string'},
                id_grupo:1,
                grid:true,
                form:true
            },
            {
                config:{
                    name: 'obs',
                    fieldLabel: 'obs',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength:-5
                },
                type:'TextField',
                filters:{pfiltro:'trp.obs',type:'string'},
                id_grupo:1,
                grid:true,
                form:true
            },
            {
                config:{
                    name: 'evento',
                    fieldLabel: 'evento',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength:50
                },
                type:'TextField',
                filters:{pfiltro:'trp.evento',type:'string'},
                id_grupo:1,
                grid:true,
                form:true
            },
            {
                config:{
                    name: 'tipo_verificacion',
                    fieldLabel: 'tipo_verificacion',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength:100
                },
                type:'TextField',
                filters:{pfiltro:'trp.tipo_verificacion',type:'string'},
                id_grupo:1,
                grid:true,
                form:true
            },
            {
                config:{
                    name: 'area',
                    fieldLabel: 'area',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength:100
                },
                type:'TextField',
                filters:{pfiltro:'trp.area',type:'string'},
                id_grupo:1,
                grid:true,
                form:true
            },
            {
                config:{
                    name: 'rango',
                    fieldLabel: 'rango',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength:50
                },
                type:'TextField',
                filters:{pfiltro:'trp.rango',type:'string'},
                id_grupo:1,
                grid:true,
                form:true
            },
            {
                config:{
                    name: 'acceso',
                    fieldLabel: 'acceso',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength:50
                },
                type:'TextField',
                filters:{pfiltro:'trp.acceso',type:'string'},
                id_grupo:1,
                grid:true,
                form:true
            },
            {
                config:{
                    name: 'desc_funcionario',
                    fieldLabel: 'desc_funcionario',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength:-5
                },
                type:'TextField',
                filters:{pfiltro:'trp.desc_funcionario',type:'string'},
                id_grupo:1,
                grid:true,
                form:true
            },
            {
                config:{
                    name: 'departamento',
                    fieldLabel: 'departamento',
                    allowBlank: true,
                    anchor: '80%',
                    gwidth: 100,
                    maxLength:100
                },
                type:'TextField',
                filters:{pfiltro:'trp.departamento',type:'string'},
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
                filters:{pfiltro:'trp.estado_reg',type:'string'},
                id_grupo:1,
                grid:true,
                form:false
            }
        ],
        tam_pag:50,
        title:'Reporte Asistencia ',
        ActList:'../../sis_asistencia/control/TransaccionBio/listarReporteTranasaccion',
        id_store:'id_transaccion_bio',
        fields: [
            {name:'id_transaccion_bio', type: 'numeric'},
            {name:'id_funcionario', type: 'numeric'},
            {name:'id_periodo', type: 'numeric'},
            {name:'id_rango_horario', type: 'numeric'},
            {name:'dia', type: 'string'},
            {name:'fecha_marcado', type: 'date',dateFormat:'Y-m-d'},
            {name:'hora', type: 'string'},
            {name:'obs', type: 'string'},
            {name:'evento', type: 'string'},
            {name:'tipo_verificacion', type: 'string'},
            {name:'area', type: 'string'},
            {name:'rango', type: 'string'},
            {name:'acceso', type: 'string'},
            {name:'desc_funcionario', type: 'string'},
            {name:'departamento', type: 'string'},
            {name:'estado_reg', type: 'string'}
        ],
        sortInfo:{
            field: 'dia',
            direction: 'ASC'
        },
        bdel:false,
        bsave:false,
        bedit:false,
        bnew:false,
        tipoStore: 'GroupingStore',//GroupingStore o JsonStore #
        remoteGroup: true,
        filtro:'departamento',
        groupField: 'departamento',
        viewGrid: new Ext.grid.GroupingView({
            forceFit: false
            // custom grouping text template to display the number of items per group
            //groupTextTpl: '{text} ({[values.rs.length]} {[values.rs.length > 1 ? "Items" : "Item"]})'
        })
        }
    )
</script>

