<?php
/****************************************************************************************
*@package pXP
*@file gen-Programacion.php
*@author  (admin.miguel)
*@date 14-12-2020 20:28:34
*@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema

HISTORIAL DE MODIFICACIONES:
#ISSUE                FECHA                AUTOR                DESCRIPCION
 #0                14-12-2020 20:28:34    admin.miguel            Creacion    
 #   

*******************************************************************************************/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
Phx.vista.Programacion=Ext.extend(Phx.gridInterfaz,{

    constructor:function(config){
        this.maestro=config.maestro;
        //llama al constructor de la clase padre
        this.initButtons=[this.cmbGestion, this.cmbPeriodo];

        Phx.vista.Programacion.superclass.constructor.call(this,config);
        this.cmbGestion.on('select', function(combo, record, index){
            this.tmpGestion = record.data.gestion;
            this.cmbPeriodo.enable();
            this.cmbPeriodo.reset();
            this.store.removeAll();
            this.cmbPeriodo.store.baseParams = Ext.apply(this.cmbPeriodo.store.baseParams, {id_gestion: this.cmbGestion.getValue()});
            this.cmbPeriodo.modificado = true;

        },this);
        this.cmbPeriodo.on('select', function( combo, record, index){
            this.tmpPeriodo = record.data.periodo;
            this.capturaFiltros();
        },this);
        this.init();
    },
            
    Atributos:[
        {
            //configuracion del componente
            config:{
                    labelSeparator:'',
                    inputType:'hidden',
                    name: 'id_programacion'
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
                    name: 'id_vacacion_det'
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
                name: 'tiempo',
                fieldLabel: 'Tiempo',
                allowBlank: true,
                anchor: '80%',
                gwidth: 60,
                renderer: function (value, p, record) {
                    var result;
                    result = String.format('{0}', "<div style='text-align:center'><img src = '../../../sis_asistencia/media/completo.png' align='center' width='45' height='45' title=''/></div>");

                    if(value == 'mañana'){
                        result = String.format('{0}', "<div style='text-align:center'><img src = '../../../sis_asistencia/media/medio.png' align='center' width='45' height='45' title=''/></div>");
                    }
                    if(value == 'tarde'){
                        result = String.format('{0}', "<div style='text-align:center'><img src = '../../../sis_asistencia/media/tarde.png' align='center' width='39' height='39' title=''/></div>");
                    }

                    return result;
                }
            },
            type:'TextField',
            id_grupo:0,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'fecha_programada',
                fieldLabel: 'Fecha',
                allowBlank: false,
                anchor: '80%',
                gwidth: 100,
                            format: 'd/m/Y', 
                            renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
            },
                type:'DateField',
                filters:{pfiltro:'prn.fecha_programada',type:'date'},
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
                maxLength:4
            },
            type:'Field',
            id_grupo:1,
            grid:true,
            form:false
        },
        {
            config:{
                name: 'estado',
                fieldLabel: 'Estado',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
            	maxLength:50
            },
                type:'TextField',
                filters:{pfiltro:'prn.estado',type:'string'},
                id_grupo:1,
                grid:true,
                form:true
		},
        {
            config:{
                name: 'tiempo',
                fieldLabel: 'Tipo',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
            	maxLength:50
            },
                type:'TextField',
                id_grupo:1,
                grid:true,
                form:true
		},

        {
            config:{
                name: 'valor',
                fieldLabel: 'Valor',
                allowBlank: true,
                anchor: '80%',
                gwidth: 100,
            	maxLength:-5
            },
                type:'NumberField',
                filters:{pfiltro:'prn.valor',type:'numeric'},
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
            filters:{pfiltro:'prn.estado_reg',type:'string'},
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
                filters:{pfiltro:'prn.fecha_reg',type:'date'},
                id_grupo:1,
                grid:true,
                form:false
		}

    ],
    tam_pag:31,
    title:'Programacion',
    ActSave:'../../sis_asistencia/control/Programacion/insertarProgramacion',
    ActDel:'../../sis_asistencia/control/Programacion/eliminarProgramacion',
    ActList:'../../sis_asistencia/control/Programacion/listarProgramacion',
    id_store:'id_programacion',
    fields: [
		{name:'id_programacion', type: 'numeric'},
		{name:'estado_reg', type: 'string'},
		{name:'id_periodo', type: 'numeric'},
		{name:'fecha_programada', type: 'date',dateFormat:'Y-m-d'},
		{name:'id_funcionario', type: 'numeric'},
		{name:'estado', type: 'string'},
		{name:'tiempo', type: 'string'},
		{name:'valor', type: 'numeric'},
		{name:'id_vacacion_det', type: 'numeric'},
		{name:'id_usuario_reg', type: 'numeric'},
		{name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
		{name:'usr_reg', type: 'string'},
        {name:'desc_funcionario1', type: 'string'}

        
    ],
    sortInfo:{
        field: 'id_programacion',
        direction: 'ASC'
    },
    bdel:false,
    bsave:true,
    bnew:false,
    bedit:false,
    cmbGestion: new Ext.form.ComboBox({
        fieldLabel: 'Gestion',
        allowBlank: false,
        emptyText:'Gestion...',
        blankText: 'Año',
        grupo:[0,1,2,3,4],
        store:new Ext.data.JsonStore(
            {
                url: '../../sis_parametros/control/Gestion/listarGestion',
                id: 'id_gestion',
                root: 'datos',
                sortInfo:{
                    field: 'gestion',
                    direction: 'DESC'
                },
                totalProperty: 'total',
                fields: ['id_gestion','gestion'],
                // turn on remote sorting
                remoteSort: true,
                baseParams:{par_filtro:'gestion'}
            }),
        valueField: 'id_gestion',
        triggerAction: 'all',
        displayField: 'gestion',
        hiddenName: 'id_gestion',
        mode:'remote',
        pageSize:50,
        queryDelay:500,
        listWidth:'280',
        width:80
    }),
    cmbPeriodo: new Ext.form.ComboBox({
        fieldLabel: 'Periodo',
        allowBlank: false,
        blankText : 'Mes',
        emptyText:'Periodo...',
        grupo:[0,1,2,3,4],
        store:new Ext.data.JsonStore(
            {
                url: '../../sis_parametros/control/Periodo/listarPeriodo',
                id: 'id_periodo',
                root: 'datos',
                sortInfo:{
                    field: 'periodo',
                    direction: 'ASC'
                },
                totalProperty: 'total',
                fields: ['id_periodo','periodo','id_gestion','literal'],
                // turn on remote sorting
                remoteSort: true,
                baseParams:{par_filtro:'gestion'}
            }),
        valueField: 'id_periodo',
        triggerAction: 'all',
        displayField: 'literal',
        hiddenName: 'id_periodo',
        mode:'remote',
        pageSize:50,
        disabled: true,
        queryDelay:500,
        listWidth:'280',
        width:80
    }),
    capturaFiltros:function(combo, record, index){
        if(this.validarFiltros()){
           // this.store.baseParams.id_gestion = this.cmbGestion.getValue();
            this.store.baseParams.id_periodo = this.cmbPeriodo.getValue();
            this.load({params:{start:0, limit:50}})
        }
    },
    validarFiltros:function(){
        return !!(this.cmbGestion.validate() && this.cmbPeriodo.validate());
    },
    onButtonAct:function(){
        // this.store.baseParams.id_gestion = this.cmbGestion.getValue();
        this.store.baseParams.id_periodo = this.cmbPeriodo.getValue();
        Phx.vista.Programacion.superclass.onButtonAct.call(this);
    },
    }
)
</script>
        
        