<?php
/****************************************************************************************
 * @package pXP
 * @file ListaProgramacion.php
 * @author  (valvarado)
 * @date 14-12-2020 20:28:34
 * @description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 *
 * HISTORIAL DE MODIFICACIONES:
 * #ISSUE                FECHA                AUTOR                DESCRIPCION
 * #
 *******************************************************************************************/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.ListaProgramacionVoBo = {

        constructor: function (config) {
            this.maestro = config.maestro;
            this.Atributos[this.getIndAtributo('revisado')].grid=true;

            Phx.vista.ListaProgramacionVoBo.superclass.constructor.call(this, config);
            this.grid.addListener('cellclick', this.oncellclick,this);

            this.panel.on('collapse', function (p) {
                if (!p.col) {
                    var id = p.getEl().id,
                        parent = p.getEl().parent(),
                        buscador = '#' + id + '-xcollapsed',
                        col = parent.down(buscador);
                    col.insertHtml('beforeEnd', '<div style="writing-mode: vertical-lr; transform: rotate(180deg); text-align: center; height: 100%;"><span class="x-panel-header-text"><b>' + p.title + '</b></span></div>');
                    p.col = col;
                }
            }, this);
            this.addButton('btn-generar',
                {
                    text: 'Genear Solicitudes',
                    grupo: [0],
                    iconCls: 'bgood',
                    disabled: true,
                    handler: this.generar,
                    tooltip: '<b>Realiza la generación de las solicitudes de vacaciones correspondientes</b>.'
                }
            );
            this.init();
            var calendar = Phx.CP.getPagina(this.idContenedorPadre).calendar;
            var vStartDate = calendar.layout.activeItem.viewStart.format('Y-m-d');
            var vEndDate = calendar.layout.activeItem.viewEnd.format('Y-m-d');
            if (!Boolean(this.maestro)) {
                this.maestro = {
                    programacion: {
                        start: vStartDate,
                        end: vEndDate
                    }
                }
            }
            this.store.baseParams = {
                fecha_inicio: vStartDate,
                fecha_fin: vEndDate,
                nombreVista: this.nombreVista
            };
            this.load({params: {start: 0, limit: 50}});
        },
        require: '../../../sis_asistencia/vista/programacion/ListaProgramacionBase.php',
        requireclase: 'Phx.vista.ListaProgramacionBase',
        nombreVista: 'ProgramacionVoBo',
        bdel: true,
        bsave: false,
        bnew: false,
        bedit: false,
        tipoStore: 'GroupingStore',//GroupingStore o JsonStore #
        remoteGroup: true,
        groupField: 'desc_funcionario1',
        viewGrid: new Ext.grid.GroupingView({
            forceFit: false
        }),
        onReloadPage: function (m) {
            this.maestro = m;
            var start = this.maestro.programacion.start;
            var end = this.maestro.programacion.end;
            this.store.baseParams = {
                fecha_inicio: start,
                fecha_fin: end,
                nombreVista: this.nombreVista
            };
            this.load({params: {start: 0, limit: 50}});
        },
        generar: function () {
            console.log(this.maestro)
            Ext.Ajax.request({
                url: '../../sis_asistencia/control/Programacion/generarSolicitudes',
                params: {
                    fecha_inicio: this.maestro.programacion.start,
                    fecha_fin: this.maestro.programacion.end,
                    nombreVista: this.nombreVista
                },
                isUpload: this.fileUpload,
                success: this.successGenerar,
                argument: this.argumentSave,
                failure: this.conexionFailure,
                timeout: this.timeout,
                scope: this
            });
        },
        preparaMenu: function (n) {
            var data = this.getSelectedData();
            var tb = this.tbar;
            Phx.vista.ListaProgramacionVoBo.superclass.preparaMenu.call(this, n);
            if (data) {
                this.getBoton('btn-generar').enable();
            }
            return tb;
        },
        liberaMenu: function () {
            var tb = Phx.vista.ListaProgramacionVoBo.superclass.liberaMenu.call(this);
            if (tb) {
                this.getBoton('btn-generar').disable();
            }
            return tb;
        },
        successGenerar: function (resp) {
            Phx.CP.loadingHide();
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            Phx.CP.getPagina(this.idContenedorPadre).refresh();
        },

        oncellclick : function(grid, rowIndex, columnIndex, e) {
            var record = this.store.getAt(rowIndex),
                fieldName = grid.getColumnModel().getDataIndex(columnIndex); // Get field name
            if(fieldName === 'revisado') {
                this.cambiarRevision(record);
            }
        },
        cambiarRevision: function(record){
            Phx.CP.loadingShow();
            var d = record.data;
            Ext.Ajax.request({
                url:'../../sis_asistencia/control/Programacion/cambiarRevision',
                params:{ id_programacion: d.id_programacion},
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
    }
</script>

