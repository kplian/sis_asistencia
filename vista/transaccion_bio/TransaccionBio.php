<?php
/**
 *@package pXP
 *@file gen-TransaccionBio.php
 *@author  (miguel.mamani)
 *@date 06-09-2019 13:08:03
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.TransaccionBio=Ext.extend(Phx.gridInterfaz,{

            constructor:function(config){
                this.initButtons=[this.cmbGestion, this.cmbPeriodo];
                this.maestro=config.maestro;
                //llama al constructor de la clase padre
                Phx.vista.TransaccionBio.superclass.constructor.call(this,config);
                var id;
                if (Phx.CP.config_ini.id_funcionario !== ''){
                    id = Phx.CP.config_ini.id_funcionario;
                }else {
                    id = null;
                }
                this.store.baseParams = {id_funcionario: id};
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

                this.addButton('btnMigracion',{
                        text: 'Traer Marcados',
                        iconCls: 'bchecklist',
                        disabled: false,
                        handler: this.migrarMarcas,
                        tooltip: '<b>Traer Marcados</b><br/>Trae los marcados segun periodo seleccionado'
                    }
                );
                this.addButton('btnReporte',
                    {
                        text :'Reporte',
                        iconCls : 'bpdf32',
                        disabled: false,
                        handler : this.onButtonReporte,
                        tooltip : '<b>Reporte</b><br/><b>De mis marcados</b>'
                    }
                );
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
                        name: 'id_rango_horario'
                    },
                    type:'Field',
                    form:true
                },
                {
                    config:{
                        name: 'dia',
                        fieldLabel: 'Dia',
                        allowBlank: true,
                        anchor: '50%',
                        gwidth: 50
                    },
                    type:'TextField',
                    filters:{pfiltro:'bio.obs',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'hora',
                        fieldLabel: 'Hora',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 60,
                        renderer:function(value, p, record){
                            var color;
                            if (record.data.id_rango_horario === null){
                                color = '#b8271d';
                            }else{
                                color = '#2e8e10';
                            }
                            return String.format('<b><font size = 1 color="'+color+'" >{0}</font></b>', value);
                        }
                    },
                    type:'TextField',
                    filters:{pfiltro:'bio.hora',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'evento',
                        fieldLabel: 'Evento',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 70
                    },
                    type:'TextField',
                    filters:{pfiltro:'bio.evento',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'tipo_verificacion',
                        fieldLabel: 'Tipo Verificacion',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 200,
                        maxLength:10
                    },
                    type:'TextField',
                    filters:{pfiltro:'bio.tipo_verificacion',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'acceso',
                        fieldLabel: 'Acceso',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 70
                    },
                    type:'TextField',
                    filters:{pfiltro:'bio.acceso',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'rango',
                        fieldLabel: 'Rango',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100
                    },
                    type:'TextField',
                    filters:{pfiltro:'rh.descripcion',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'area',
                        fieldLabel: 'Area',
                        allowBlank: true,
                        anchor: '80%'
                    },
                    type:'TextField',
                    filters:{pfiltro:'bio.area',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'desc_funcionario',
                        fieldLabel: 'Funcionario',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 200
                    },
                    type:'TextField',
                    filters:{pfiltro:'vfun.desc_funcionario',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'obs',
                        fieldLabel: 'Obs',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 200
                    },
                    type:'TextField',
                    filters:{pfiltro:'bio.obs',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'fecha_marcado',
                        fieldLabel: 'Fecha Marcado',
                        allowBlank: false,
                        anchor: '80%',
                        gwidth: 100,
                        format: 'd/m/Y',
                        renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
                    },
                    type:'DateField',
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
                    filters:{pfiltro:'bio.estado_reg',type:'string'},
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
                        name: 'usuario_ai',
                        fieldLabel: 'Funcionaro AI',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:300
                    },
                    type:'TextField',
                    filters:{pfiltro:'bio.usuario_ai',type:'string'},
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
                    filters:{pfiltro:'bio.fecha_reg',type:'date'},
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
                    filters:{pfiltro:'bio.id_usuario_ai',type:'numeric'},
                    id_grupo:1,
                    grid:false,
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
                    filters:{pfiltro:'bio.fecha_mod',type:'date'},
                    id_grupo:1,
                    grid:true,
                    form:false
                }
            ],
            tam_pag:100,
            title:'Transaccion Bio',
            ActSave:'../../sis_asistencia/control/TransaccionBio/insertarTransaccionBio',
            ActDel:'../../sis_asistencia/control/TransaccionBio/eliminarTransaccionBio',
            ActList:'../../sis_asistencia/control/TransaccionBio/listarTransaccionBio',
            id_store:'id_transaccion_bio',
            fields: [
                {name:'id_transaccion_bio', type: 'numeric'},
                {name:'obs', type: 'string'},
                {name:'estado_reg', type: 'string'},
                {name:'id_periodo', type: 'numeric'},
                {name:'hora', type: 'string'},
                {name:'id_funcionario', type: 'numeric'},
                {name:'fecha_marcado', type: 'date',dateFormat:'Y-m-d'},
                {name:'id_rango_horario', type: 'numeric'},
                {name:'id_usuario_reg', type: 'numeric'},
                {name:'usuario_ai', type: 'string'},
                {name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
                {name:'id_usuario_ai', type: 'numeric'},
                {name:'id_usuario_mod', type: 'numeric'},
                {name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
                {name:'usr_reg', type: 'string'},
                {name:'usr_mod', type: 'string'},
                {name:'evento', type: 'string'},
                {name:'tipo_verificacion', type: 'string'},
                {name:'area', type: 'string'},
                {name:'rango', type: 'string'},
                {name:'dia', type: 'string'},
                {name:'acceso', type: 'string'},
                {name:'desc_funcionario', type: 'string'}
            ],
            sortInfo:{
                field: 'fecha_marcado',
                direction: 'ASC'
            },
            onButtonAct:function(){
                if(this.validarFiltros()) {
                    this.store.baseParams.id_periodo = this.cmbPeriodo.getValue();
                    Phx.vista.TransaccionBio.superclass.onButtonAct.call(this);
                }else{
                    alert('Seleccione la gestion y el periodo');
                }
            },
            capturaFiltros:function(){
                // this.desbloquearOrdenamientoGrid();
                if(this.validarFiltros()){
                    this.store.baseParams.id_periodo = this.cmbPeriodo.getValue();
                    this.load();
                }
            },
            validarFiltros:function(){
                if(this.cmbGestion.validate() && this.cmbPeriodo.validate()){
                    return true;
                } else{
                    return false;
                }
            },
            migrarMarcas:function () {
                if(this.validarFiltros()) {
                    Phx.CP.loadingShow();
                    var id;
                    if (Phx.CP.config_ini.id_funcionario !== ''){
                        id = Phx.CP.config_ini.id_funcionario;
                    }else {
                        id = null;
                    }

                    Ext.Ajax.request({
                        url: '../../sis_asistencia/control/TransaccionBio/migrarMarcadoFuncionario',
                        params: {id_periodo: this.cmbPeriodo.getValue(),
                                 id_funcionario: id},
                        success: this.success,
                        failure: this.conexionFailure,
                        timeout: this.timeout,
                        scope: this
                    });
                    this.reload();
                }else{
                    alert('Seleccione la gestion y el periodo');
                }
            },
            success: function(resp){
                Phx.CP.loadingHide();
                var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            },
            tipoStore: 'GroupingStore',//GroupingStore o JsonStore #
            remoteGroup: true,
            groupField: 'fecha_marcado',
            viewGrid: new Ext.grid.GroupingView({
                forceFit: false
            }),
            //boton reporte de marcados
            onButtonReporte :function () {
                Phx.CP.loadingShow();
                Ext.Ajax.request({
                    url:'../../sis_asistencia/control/TransaccionBio/ReporteTusMarcados',
                    params:{ id_funcionario : Phx.CP.config_ini.id_funcionario, id_periodo : this.cmbPeriodo.getValue()
                    },
                    success: this.successExport,
                    failure: this.conexionFailure,
                    timeout:this.timeout,
                    scope:this
                });
            },
            //*****************
            bdel:false,
            bsave:false,
            bedit:false,
            bnew:false,
            cmbGestion: new Ext.form.ComboBox({
                fieldLabel: 'Gestion',
                allowBlank: false,
                emptyText:'Gestion...',
                blankText: 'Año',
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
            })
        }
    )
</script>

