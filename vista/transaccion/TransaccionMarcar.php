<?php
/**
 *@package pXP
 *@file TransaccionMarcar.php
 *@author  MAM
 *@date 27-12-2016 14:45
 *@Interface para el inicio de solicitudes de materiales
 */
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
    Phx.vista.TransaccionMarcar = {
        require:'../../../sis_asistencia/vista/transaccion/TransaccionBase.php',
        requireclase:'Phx.vista.TransaccionBase',
        title:'TransaccionMarcar',
        nombreVista: 'TransaccionMarcar',
        bdel:false,
        bsave:false,
        bedit:false,
        bnew:false,
        bexcel:true,
        mes:'',
        id_periodo: null,
        constructor: function(config) {
            var periodo;
            this.idContenedor = config.idContenedor;
            this.maestro = config;
            this.id_periodo = this.maestro.id_periodo;
            periodo = this.maestro.id_periodo;
            this.Atributos.unshift({
                config: {
                    name: 'rango',
                    fieldLabel: 'Asignado',
                    allowBlank: true,
                    anchor: '50%',
                    gwidth: 80,
                    maxLength: 3,
                    renderer: function (value, p, record, rowIndex, colIndex) {
                         //check or un check row
                            var checked = '',
                                momento = 'no';
                            if (value == 'si') {
                                checked = 'checked';
                            }
                            return String.format('<div style="vertical-align:middle;text-align:center;"><input style="height:20px;width:20px;" type="checkbox"  {0}></div>', checked);
                    }
                },
                type: 'TextField',
                id_grupo: 0,
                grid: true,
                form: false
            });
            Phx.vista.TransaccionMarcar.superclass.constructor.call(this,config);
            this.init();
            var id;
            if (Phx.CP.config_ini.id_funcionario !== ''){
                id = Phx.CP.config_ini.id_funcionario;
            }else {
                id = null;
            }
            this.store.baseParams = {id_funcionario: id ,
                                     id_periodo: periodo};
            this.load({params:{start:0, limit:this.tam_pag}});
            this.grid.addListener('cellclick', this.oncellclick,this);
            this.addBotones();
            /*this.addButton('btnReporte', {
                text: 'Reporte',
                iconCls: 'bpdf32',
                disabled: false,
                handler: this.onReporte,
                tooltip: '<b>Reporte</b><br/> Este reporte calcula las hora de trabajo'
            });*/
            this.addButton('btnReprocesar', {
                text: 'Reprocesar',
                iconCls: 'bsee',
                disabled: false,
                handler: this.onReprecesar,
                tooltip: '<b>Reprocesar</b><br/> Genera tus pares de tus marcaciones'
            });
        },
        addBotones: function() {
            this.menuAdq = new Ext.Toolbar.SplitButton({
                id: 'btn-procesar-' + this.idContenedor,
                text: 'Procesar.',
                disabled: false,
                iconCls : 'bassign',
                handler:this.armarPareAuto,
                scope: this,
                tooltip: '<b>Esta funcion asignar de forma automarica tus pares del dia</b>',
                menu:{
                    items: [{
                        id:'b-btnAsignar-' + this.idContenedor,
                        text: 'Asignar marca automatico',
                        iconCls: 'bchecklist',
                        tooltip: '<b>Esta funcion asignar de forma automarica tus pares del dia</b>',
                        handler:this.armarPareAuto,
                        scope: this
                    }, {
                        id:'b-btnDesasignar-' + this.idContenedor,
                        text: 'Desasignar marca',
                        iconCls : 'blist',
                        tooltip: '<b>Esta funcion quita todo las marcas</b>',
                        handler:this.onBorrar,
                        scope: this
                    }
                    ]}
            });
            this.tbar.add(this.menuAdq);
        },
        oncellclick : function(grid, rowIndex, columnIndex, e) {/// revisar
            const record = this.store.getAt(rowIndex),
                fieldName = grid.getColumnModel().getDataIndex(columnIndex); // Get field name
            if (fieldName == 'rango')
                this.autorizarHoras(record,fieldName);
        },
        autorizarHoras: function(record,name){
            Phx.CP.loadingShow();
            var d = record.data;
            Ext.Ajax.request({
                url:'../../sis_asistencia/control/Pares/seleccionarMarca',
                params:{ id: d.id},
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
        onReprecesar:function () {
            if (confirm("Esta seguro de procesar sus marcaciones")) {
                Phx.CP.loadingShow();
                var id_funcionario = null;
                if (Phx.CP.config_ini.id_funcionario !== ''){
                    id_funcionario = Phx.CP.config_ini.id_funcionario;
                }
                Ext.Ajax.request({
                    url: '../../sis_asistencia/control/Pares/armarPareMar',
                    params: {
                        id_periodo:  this.id_periodo,
                        id_funcionario: id_funcionario
                    },
                    success: this.success,
                    failure: this.conexionFailure,
                    timeout: this.timeout,
                    scope: this
                });
            } else {
                txt = "cancelar";
            }
            console.log(txt);
        },
        success: function(resp){
            Phx.CP.loadingHide();
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            Phx.CP.getPagina(this.idContenedorPadre).reload();
           // this.reload();
        },
        armarPareAuto:function () {

                Phx.CP.loadingShow();
                var id_funcionario = null;
                if (Phx.CP.config_ini.id_funcionario !== ''){
                    id_funcionario = Phx.CP.config_ini.id_funcionario;
                }
                Ext.Ajax.request({
                    url: '../../sis_asistencia/control/Pares/armarPareAuto',
                    params: {
                        id_periodo:  this.id_periodo,
                        id_funcionario: id_funcionario
                    },
                    success: this.succesNew,
                    failure: this.conexionFailure,
                    timeout: this.timeout,
                    scope: this
                });

        },
        onBorrar:function () {
            if (confirm("Esta seguro de desmarcar tus marcas?")) {
                Phx.CP.loadingShow();
                var id_funcionario = null;
                if (Phx.CP.config_ini.id_funcionario !== ''){
                    id_funcionario = Phx.CP.config_ini.id_funcionario;
                }
                Ext.Ajax.request({
                    url: '../../sis_asistencia/control/Pares/borrarRango',
                    params: {
                        id_periodo:  this.id_periodo,
                        id_funcionario: id_funcionario
                    },
                    success: this.succesNew,
                    failure: this.conexionFailure,
                    timeout: this.timeout,
                    scope: this
                });
            }else {
                txt = "cancelar";
            }
            console.log(txt);
        },
        succesNew: function(resp){
            Phx.CP.loadingHide();
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            this.load({params:{start:0, limit:this.tam_pag}});
            //Phx.CP.getPagina(this.idContenedorPadre).reload();
            //this.reload();
        },
        onReporte: function () {
            Phx.CP.loadingHide();
            var id_funcionario = null;
            if (Phx.CP.config_ini.id_funcionario !== ''){
                id_funcionario = Phx.CP.config_ini.id_funcionario;
            }

            Ext.Ajax.request({
                url:'../../sis_asistencia/control/Transaccion/ReporteMarcadoPDF',
                params:{    id_funcionario : id_funcionario,
                    id_periodo : this.id_periodo
                },
                success: this.successExport,
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            });
        }
    }
</script>

