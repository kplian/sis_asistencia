<?php
/**
 *@package pXP
 *@file Transaccion.php
 *@author  MAM
 *@date 27-12-2016 14:45
 *@Interface para el inicio de solicitudes de materiales
 */
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
    Phx.vista.Transaccion = {
        require:'../../../sis_asistencia/vista/transaccion/TransaccionBase.php',
        requireclase:'Phx.vista.TransaccionBase',
        title:'Transaccioo',
        nombreVista: 'Transaccion',

        constructor: function(config) {
            this.initButtons=[this.cmbGestion, this.cmbPeriodo];
            Phx.vista.Transaccion.superclass.constructor.call(this,config);

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
            this.addButton('btnReporte',
                {
                    text :'Exportar',
                    iconCls : 'bexport',
                    disabled: false,
                    handler : this.onButtonReporte,
                    tooltip : '<b>Reporte</b><br/><b>De mis marcados</b>'
                }
            );
        },
        onButtonAct: function () {
            if (this.validarFiltros()) {
                this.store.baseParams.id_periodo = this.cmbPeriodo.getValue();
                Phx.vista.Transaccion.superclass.onButtonAct.call(this);
            } else {
                alert('Seleccione la gestion y el periodo');
            }
        },
        capturaFiltros: function () {
            // this.desbloquearOrdenamientoGrid();
            if (this.validarFiltros()) {
                this.store.baseParams.id_periodo = this.cmbPeriodo.getValue();
                this.load();
            }
        },
        validarFiltros: function () {
            if (this.cmbGestion.validate() && this.cmbPeriodo.validate()) {
                return true;
            } else {
                return false;
            }
        },
        bdel:false,
        bsave:false,
        bedit:false,
        bnew:false,
        bexcel:true,
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
            width:100
        })

    };
</script>

