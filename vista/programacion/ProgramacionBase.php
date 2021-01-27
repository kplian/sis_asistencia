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

    Phx.vista.ProgramacionBase = Ext.extend(Phx.baseInterfaz, {

            constructor: function (config) {
                var self = this;
                this.maestro = config.maestro;
                Phx.vista.ProgramacionBase.superclass.constructor.call(this, config);
                self.eventStore = new Ext.data.JsonStore({
                    id: 'eventStore',
                    root: 'datos',
                    baseParams: {nombreVista: this.nombreVista},
                    url: '../../sis_asistencia/control/Programacion/listarProgramacion',
                    fields: Ext.calendar.EventRecord.prototype.fields.getRange(),
                    autoLoad: false,
                });
                this.graf = new Ext.Panel({
                    layout: 'border',
                    tbar: new Ext.Toolbar({
                        enableOverflow: true,
                        defaults: {
                            scale: 'large',
                            iconAlign: 'top',
                            minWidth: 50,
                            boxMinWidth: 50
                        },
                        items: [{
                            id: 'b-act-' + this.idContenedor,
                            iconCls: 'bact',
                            grupo: this.bactGroups,
                            tooltip: '<b>Actualizar</b>',
                            text: 'Actualizar',
                            handler: this.refresh,
                            scope: this
                        }]
                    }),
                    region: 'center',
                    margins: '3 3 3 0',
                    items: [{
                        id: 'app-center',
                        title: '...', // will be updated to view date range
                        region: 'center',
                        layout: 'border',
                        items: [
                            {
                                xtype: 'calendarpanel',
                                eventStore: self.eventStore,
                                border: false,
                                id: 'calendar-progrmacion',
                                region: 'center',
                                activeItem: 2,
                                monthViewCfg: {
                                    showHeader: true,
                                    showWeekLinks: true,
                                    showWeekNumbers: true
                                },

                                // Some optional CalendarPanel configs to experiment with:
                                showDayView: false,
                                showWeekView: false,
                                showMonthView: true,
                                initComponent: function () {
                                    this.constructor.prototype.initComponent.apply(this, arguments);
                                },

                                listeners: {
                                    'eventclick': {
                                        fn: function (vw, rec, el) {
                                            this.nuevaProgramacion(rec.json);
                                        },
                                        scope: this
                                    },
                                    'datechange': {
                                        fn: function (vw, starDate, viewStart, viewEnd) {
                                            this.refresh(starDate);
                                        },
                                        scope: this
                                    },
                                    'dayclick': {
                                        fn: function (vw, dt, ad, el) {
                                            var rec = {
                                                start: dt,
                                                ad: ad
                                            }
                                            this.nuevaProgramacion(rec);
                                        },
                                        scope: this
                                    },
                                    'rangeselect': {
                                        fn: function (win, dates, onComplete) {
                                            var rec = {
                                                start: dates.StartDate,
                                                end: dates.EndDate
                                            }
                                            this.nuevaProgramacion(rec);
                                            onComplete();
                                        },
                                        scope: this
                                    },
                                    'eventmove': {
                                        fn: function (vw, rec) {
                                            console.log("EVENT: eventmove", rec)
                                            rec.commit();
                                            var programacion = {
                                                id_programacion: rec.data.EventId,
                                                fecha_programada: rec.data.StartDate
                                            }
                                            this.cambiarAsignacion(programacion);
                                        },
                                        scope: this
                                    }
                                }
                            }
                        ]
                    }
                    ]
                });
                self.regiones = new Array();
                self.regiones.push(self.graf);
                self.definirRegiones();
                self.init();
                self.calendar = Ext.getCmp('calendar-progrmacion');
            },
            Atributos: [],
            tam_pag: 31,
            title: 'Programacion',
            id_store: 'id_programacion',
            fields: [],
            sortInfo: {
                field: 'id',
                direction: 'ASC'
            },
            bdel: false,
            bsave: true,
            bnew: false,
            bedit: false,
        }
    )
</script>
        
        