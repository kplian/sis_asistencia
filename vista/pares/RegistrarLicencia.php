<?php
/**
 *@package pXP
 *@file RegistrarLicencia.php
 *@author  (mgarcia)
 *@date 24-09-2019 16:53:42
 *@description permites registrar licencias
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.RegistrarLicencia=Ext.extend(Phx.frmInterfaz,{

            constructor:function(config) {
                this.maestro = config;
                //llama al constructor de la clase padre
                Phx.vista.RegistrarLicencia.superclass.constructor.call(this,config);
                this.init();
               // this.loadValoresIniciales();
            },



            loadValoresIniciales:function()
            {

                Phx.vista.RegistrarLicencia.superclass.loadValoresIniciales.call(this);
                this.Cmp.fecha_solicitud.setValue(new Date());
                this.Cmp.fecha_solicitud.fireEvent('change');
                this.ocultarComponente(this.Cmp.hro_desde);
                this.ocultarComponente(this.Cmp.hro_hasta);
                this.Cmp.id_tipo_permiso.on('select', function(combo, record, index){

                    if (record.data.asignar_rango === 'si'){
                        this.mostrarComponente(this.Cmp.hro_desde);
                        this.mostrarComponente(this.Cmp.hro_hasta);
                    }
                    if (record.data.asignar_rango === 'no'){
                        this.ocultarComponente(this.Cmp.hro_desde);
                        this.ocultarComponente(this.Cmp.hro_hasta);
                    }
                },this);
                this.Cmp.hro_desde.on('select', function(combo, record, index){
                    console.log(record.data.field1)
                },this);
                this.Cmp.hro_hasta.on('select', function(combo, record, index){
                    console.log(record.data.field1);
                    this.calcularDiferenciaHora(this.Cmp.hro_desde.getValue(),record.data.field1);
                },this);
                /*this.getComponente('id_correspondencia').setValue(this.id_correspondencia);
                this.argumentExtraSubmit.version = this.version;
                this.argumentExtraSubmit.id_gestion = this.id_gestion;
                this.argumentExtraSubmit.numero = this.numero;
                this.getComponente('numeroCorres').setValue(this.numero);*/
            },


            successSave:function(resp){
                Phx.CP.loadingHide();
                Phx.CP.getPagina(this.idContenedorPadre).reload();
                this.panel.close();
            },

            Atributos:[
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_permiso'
                    },
                    type:'Field',
                    form:true
                },
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_proceso_wf'
                    },
                    type:'Field',
                    form:true
                },
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_estado_wf'
                    },
                    type:'Field',
                    form:true
                },{
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
                    config:{
                        name: 'nro_tramite',
                        fieldLabel: 'Nro Tramite',
                        allowBlank: true,
                        width: 250,
                        gwidth: 100,
                        maxLength:100
                    },
                    type:'TextField',
                    filters:{pfiltro:'pmo.nro_tramite',type:'string'},
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
                    filters:{pfiltro:'pmo.estado',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },
                {
                    config:{
                        name: 'fecha_solicitud',
                        fieldLabel: 'Fecha Solicitud',
                        allowBlank: false,
                        width: 130,
                        gwidth: 100,
                        format: 'd/m/Y',
                        renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
                    },
                    type:'DateField',
                    filters:{pfiltro:'pmo.fecha_solicitud',type:'date'},
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name:'id_funcionario',
                        hiddenName: 'id_funcionario',
                        origen:'FUNCIONARIOCAR',
                        fieldLabel:'Funcionario',
                        allowBlank:false,
                        width: 300,
                        gwidth:250,
                        valueField: 'id_funcionario',
                        gdisplayField: 'desc_funcionario',
                        baseParams: {par_filtro: 'id_funcionario#desc_funcionario1#codigo'},
                        renderer:function(value, p, record){return String.format('{0}', record.data['desc_funcionario']);}
                    },
                    type:'ComboRec',//ComboRec
                    id_grupo:0,
                    filters:{pfiltro:'fun.desc_funcionario1',type:'string'},
                    bottom_filter:false,
                    grid:true,
                    form:true
                },
                {
                    config: {
                        name: 'id_tipo_permiso',
                        fieldLabel: 'Tipo Permiso',
                        allowBlank: false,
                        emptyText: 'Elija una opción...',
                        store: new Ext.data.JsonStore({
                            url: '../../sis_asistencia/control/TipoPermiso/listarTipoPermiso',
                            id: 'id_tipo_permiso',
                            root: 'datos',
                            sortInfo: {
                                field: 'nombre',
                                direction: 'ASC'
                            },
                            totalProperty: 'total',
                            fields: ['id_tipo_permiso', 'nombre', 'codigo','documento','asignar_rango'],
                            remoteSort: true,
                            baseParams: {par_filtro: 'tpo.nombre#tpo.codigo'}
                        }),
                        valueField: 'id_tipo_permiso',
                        displayField: 'nombre',
                        gdisplayField: 'desc_tipo_permiso',
                        hiddenName: 'id_tipo_permiso',
                        forceSelection: true,
                        typeAhead: false,
                        triggerAction: 'all',
                        lazyRender: true,
                        mode: 'remote',
                        pageSize: 15,
                        queryDelay: 1000,
                        width: 300,
                        gwidth: 250,
                        minChars: 2,
                        renderer : function(value, p, record) {
                            return String.format('{0}', record.data['desc_tipo_permiso']);
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
                        name: 'hro_desde',
                        fieldLabel: 'Desde',
                        format: 'H:i',
                        increment: 1,
                        width: 100
                    },
                    type:'TimeField',
                    id_grupo:0,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'hro_hasta',
                        fieldLabel: 'Hasta',
                        format: 'H:i',
                        increment: 1,
                        width: 100
                    },
                    type:'TimeField',
                    id_grupo:0,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'motivo',
                        fieldLabel: 'Motivo',
                        allowBlank: false,
                        width: 300,
                        gwidth: 300
                    },
                    type:'TextArea',
                    filters:{pfiltro:'pmo.motivo',type:'string'},
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
                    filters:{pfiltro:'pmo.estado_reg',type:'string'},
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
                    filters:{pfiltro:'pmo.id_usuario_ai',type:'numeric'},
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
                    filters:{pfiltro:'pmo.usuario_ai',type:'string'},
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
                    filters:{pfiltro:'pmo.fecha_reg',type:'date'},
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
                    filters:{pfiltro:'pmo.fecha_mod',type:'date'},
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
        title:'Permiso',
        ActSave:'../../sis_asistencia/control/Permiso/insertarPermiso',
        ActDel:'../../sis_asistencia/control/Permiso/eliminarPermiso',
        ActList:'../../sis_asistencia/control/Permiso/listarPermiso',
        id_store:'id_permiso',
        fields: [
            {name:'id_permiso', type: 'numeric'},
            {name:'nro_tramite', type: 'string'},
            {name:'id_funcionario', type: 'numeric'},
            {name:'id_estado_wf', type: 'numeric'},
            {name:'fecha_solicitud', type: 'date',dateFormat:'Y-m-d'},
            {name:'id_tipo_permiso', type: 'numeric'},
            {name:'motivo', type: 'string'},
            {name:'estado_reg', type: 'string'},
            {name:'estado', type: 'string'},
            {name:'id_proceso_wf', type: 'numeric'},
            {name:'id_usuario_ai', type: 'numeric'},
            {name:'id_usuario_reg', type: 'numeric'},
            {name:'usuario_ai', type: 'string'},
            {name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
            {name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
            {name:'id_usuario_mod', type: 'numeric'},
            {name:'usr_reg', type: 'string'},
            {name:'usr_mod', type: 'string'},

            {name:'desc_tipo_permiso', type: 'string'},
            {name:'desc_funcionario', type: 'string'},
            {name:'hro_desde',type: 'string'},
            {name:'hro_hasta',type: 'string'},
            {name:'asignar_rango', type: 'string'}

        ],
        sortInfo:{
            field: 'id_permiso',
            direction: 'ASC'
        },

        fwidth: '45%',
        fheight: '45%'
        }
    )

</script>