<?php
/****************************************************************************************
 * @package pXP
 * @file gen-Programacion.php
 * @author  (admin.miguel)
 * @date 14-12-2020 20:28:34
 * @description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 *
 * HISTORIAL DE MODIFICACIONES:
 * #ISSUE                FECHA                AUTOR                DESCRIPCION
 * #0                14-12-2020 20:28:34    admin.miguel            Creacion
 * #
 *******************************************************************************************/

header("content-type: text/javascript; charset=UTF-8");
?>
<!-- Calendar-specific includes -->
<link rel="stylesheet" type="text/css" href="../../../pxp/lib/ext3/examples/calendar/resources/css/calendar.css"/>
<style>
    /*
  * Calendar event colors
  */
    .ext-cal-evr,
    .ext-cal-evi,
    .ext-cal-evt dl {
        color: #fff;
    }

    .ext-color-1,
    .ext-ie .ext-color-1-ad,
    .ext-opera .ext-color-1-ad {
        color: #00A1AE !important;
    }

    .ext-cal-day-col .ext-color-1,
    .ext-dd-drag-proxy .ext-color-1,
    .ext-color-1-ad,
    .ext-color-1-ad .ext-cal-evm,
    .ext-color-1 .ext-cal-picker-icon,
    .ext-color-1-x dl,
    .ext-color-1-x .ext-cal-evb {
        background: #00A1AE !important;
    }

    .ext-color-1-x .ext-cal-evb,
    .ext-color-1-x dl {
        border-color: #29527A;
    }

    .ext-color-2,
    .ext-ie .ext-color-2-ad,
    .ext-opera .ext-color-2-ad {
        color: #EA5555 !important;
    }

    .ext-cal-day-col .ext-color-2,
    .ext-dd-drag-proxy .ext-color-2,
    .ext-color-2-ad,
    .ext-color-2-ad .ext-cal-evm,
    .ext-color-2 .ext-cal-picker-icon,
    .ext-color-2-x dl,
    .ext-color-2-x .ext-cal-evb {
        background: #EA5555 !important;
    }

    .ext-color-2-x .ext-cal-evb,
    .ext-color-2-x dl {
        border-color: #711616;
    }

    .ext-color-3,
    .ext-ie .ext-color-3-ad,
    .ext-opera .ext-color-3-ad {
        color: #F78F1F !important;
    }

    .ext-cal-day-col .ext-color-3,
    .ext-dd-drag-proxy .ext-color-3,
    .ext-color-3-ad,
    .ext-color-3-ad .ext-cal-evm,
    .ext-color-3 .ext-cal-picker-icon,
    .ext-color-3-x dl,
    .ext-color-3-x .ext-cal-evb {
        background: #F78F1F !important;
    }

    .ext-color-3-x .ext-cal-evb,
    .ext-color-3-x dl {
        border-color: #8C500B;
    }

    .ext-cal-day-col .ext-cal-evt {
        position: absolute;
    }

    .ext-cal-day-col .ext-cal-evr,
    .ext-cal-day-col .ext-cal-evi {
        white-space: normal;
    }

</style>
<script>

    Phx.vista.ProgramacionVoBo = {

        constructor: function (config) {
            var self = this;
            this.maestro = config.maestro;
            Phx.vista.ProgramacionVoBo.superclass.constructor.call(this, config);
            this.init();
            console.log(this.calendar.events.dayclick)
            this.calendar.events.dayclick = false;
            this.calendar.events.rangeselect = false;
            this.calendar.events.eventclick = false;
        },
        east: {
            url: '../../../sis_asistencia/vista/programacion/ListaProgramacionVoBo.php',
            cls: 'ListaProgramacionVoBo',
            width: '30%',
            height: '100%',
            title: "Programaciones",
            layout: 'accordion',
            floating: true,
            collapsed: true,
            animCollapse: true,
            collapsible: true
        },
        Atributos: [],
        tam_pag: 31,
        title: 'Programacion',
        require: '../../../sis_asistencia/vista/programacion/ProgramacionBase.php',
        requireclase: 'Phx.vista.ProgramacionBase',
        nombreVista: 'ProgramacionVoBo',
        bdel: false,
        bsave: true,
        bnew: false,
        bedit: false,
        refresh: function (date = undefined) {
            var vStartDate = this.calendar.layout.activeItem.viewStart.format('Y-m-d');
            var vEndDate = this.calendar.layout.activeItem.viewEnd.format('Y-m-d');
            this.eventStore.baseParams = {nombreVista: this.nombreVista}
            this.eventStore.reload();
            this.calendar.fireViewChange();
            var data = {
                programacion: {
                    start: vStartDate,
                    end: vEndDate
                }
            }
            var pe = Phx.CP.getPagina(this.idContenedor + '-east');
            if (Boolean(pe))
                pe.onReloadPage(data);
        },

        nuevaProgramacion: function (programacion) {
            self.winProgramacionForm = Phx.CP.loadWindows('../../../sis_asistencia/vista/programacion/NuevaProgramacion.php',
                'Nueva Progrmación',
                {
                    modal: true,
                    width: '30%',
                    height: '30%',
                    closeAction: "close"
                },
                {
                    parent: this,
                    isNew: true,
                    programacion: programacion
                },
                this.idContenedor,
                'NuevaProgramacion',
                {
                    config: [{
                        event: 'refresh',
                        delegate: this.refresh
                    }],
                    scope: this
                });
        },
        cambiarAsignacion: function (programacion) {
            Ext.Ajax.request({
                url: '../../sis_asistencia/control/Programacion/cambiarFecha',
                params: programacion,
                isUpload: this.fileUpload,
                success: this.refresh,
                argument: this.argumentSave,
                failure: this.conexionFailure,
                timeout: this.timeout,
                scope: this
            });
        },
        conexionFailure: function (res) {
            Phx.vista.ProgramacionVoBo.superclass.conexionFailure.call(this, res);
            this.refresh();
        }

    }
</script>
        
        