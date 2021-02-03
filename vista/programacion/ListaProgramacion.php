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
    Phx.vista.ListaProgramacion = {

        constructor: function (config) {
            this.maestro = config.maestro;
            Phx.vista.ListaProgramacion.superclass.constructor.call(this, config);
            this.panel.on('collapse', function (p) {
                if (!p.col) {
                    var id = p.getEl().id,
                        parent = p.getEl().parent(),
                        buscador = '#' + id + '-xcollapsed',
                        col = parent.down(buscador);
                    col.insertHtml('beforeEnd', '<div style="writing-mode: vertical-lr; transform: rotate(180deg); text-align: center; height: 100%;"><span class="x-panel-header-text"><b>' + p.title + '</b></span></div>');
                    p.col = col;
                }
                ;
            }, this);
            this.init();
            this.load({params: {start: 0, limit: 50, nombreVista: this.nombreVista}});
        },
        require: '../../../sis_asistencia/vista/programacion/ListaProgramacionBase.php',
        requireclase: 'Phx.vista.ListaProgramacionBase',
        bdel: true,
        bsave: false,
        bnew: false,
        bedit: false,
        nombreVista: 'ListaProgramacion',
        onReloadPage: function (m) {
            this.maestro = m;
            this.store.baseParams = {
                fecha_inicio: this.maestro.programacion.start,
                fecha_fin: this.maestro.programacion.end,
                nombreVista: this.nombreVista
            };
            this.load({params: {start: 0, limit: 50}});
        },
    }
</script>

