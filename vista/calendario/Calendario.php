<?php
/****************************************************************************************
 * @package pXP
 * @file Calendario.php
 * @author  (valvarado)
 * @date 28-12-2020 13:57:32
 * @description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 *
 * HISTORIAL DE MODIFICACIONES:
 * #ISSUE                FECHA                AUTOR                DESCRIPCION
 * #0                28-12-2020 13:57:32    valvarado            Creacion
 * #
 *******************************************************************************************/

header("content-type: text/javascript; charset=UTF-8");
?>
<!-- Calendar-specific includes -->
<link rel="stylesheet" type="text/css" href="../../../pxp/lib/ext3/examples/calendar/resources/css/calendar.css"/>
<!-- App -->
<link rel="stylesheet" type="text/css" href="../../../pxp/lib/ext3/examples/calendar/resources/css/examples.css"/>

<script>
    var calendarList = {
        "calendars": [{
            "id": 1,
            "title": "Home"
        }, {
            "id": 2,
            "title": "Work"
        }, {
            "id": 3,
            "title": "School"
        },
            {
                "id": 4,
                "title": "Office"
            }]
    };
    var today = new Date().clearTime();
    var eventList = {
        "evts": [
            {
                "id": 1007,
                "cid": 1,
                "title": "Miguel Mamani",
                "start": new Date().setTme(8,0,0),
                "end": new Date().setTme(12,0,0),
                "ad": true,
                "notes": "Get cash on the way"
            }
            ]
    };

    Phx.vista.Calendario = Ext.extend(Phx.baseInterfaz, {
            constructor: function (config) {
                const self = this;

                self.maestro = config.maestro;

                Phx.vista.Calendario.superclass.constructor.call(self, config);

                self.calendarStore = new Ext.data.JsonStore({
                    storeId: 'calendarStore',
                    root: 'calendars',
                    idProperty: 'id',
                    data: calendarList, // defined in calendar-list.js
                    proxy: new Ext.data.MemoryProxy(),
                    autoLoad: true,
                    fields: [
                        {name: 'CalendarId', mapping: 'id', type: 'int'},
                        {name: 'Title', mapping: 'title', type: 'string'}
                    ],
                    sortInfo: {
                        field: 'CalendarId',
                        direction: 'ASC'
                    }
                });

                self.eventStore = new Ext.data.JsonStore({
                    id: 'eventStore',
                    root: 'evts',
                    data: eventList, // defined in event-list.js
                    proxy: new Ext.data.MemoryProxy(),
                    fields: Ext.calendar.EventRecord.prototype.fields.getRange(),
                    sortInfo: {
                        field: 'StartDate',
                        direction: 'ASC'
                    }
                });

                this.graf = new Ext.Panel({
                    layout: 'border',
                    tbar:  new Ext.Toolbar({
                        enableOverflow: true,
                        defaults: {
                            scale: 'large',
                            iconAlign:'top',
                            minWidth: 50,
                            boxMinWidth: 50
                        },
                        items: [{
                            id: 'b-act-' + this.idContenedor,
                            iconCls: 'bact',
                            grupo: this.bactGroups,
                            tooltip: '<b>Actualizar</b>',
                            text: 'Actualizar',
                            handler: this.onButtonAct,
                            scope: this
                        }]
                    }),//self.tbar,
                    // region: 'center',
                    region:  'center',
                    margins: '3 3 3 0',
                    items: [
                        /*{
                            id: 'app-header',
                            region: 'north',
                            height: 35,
                            border: false,
                            contentEl: 'app-header-content'
                        },*/
                        {
                            id: 'app-center',
                            title: '...', // will be updated to view date range
                            region: 'center',
                            layout: 'border',
                            items:[
                               {
                                    id: 'app-west',
                                    region: 'west',
                                    width: 176,
                                    border: false,
                                    items: [{
                                        xtype: 'datepicker',
                                        id: 'app-nav-picker',
                                        cls: 'ext-cal-nav-picker',
                                        listeners: {
                                            'select': {
                                                fn: function (dp, dt) {
                                                    Ext.getCmp('app-calendar').setStartDate(dt);
                                                },
                                                scope: this
                                            }
                                        }
                                    }]
                                },
                                {
                                    xtype: 'calendarpanel',
                                    eventStore: self.eventStore,
                                    //calendarStore: self.calendarStore,
                                    border: false,
                                    id: 'app-calendar',
                                    region: 'center',
                                    activeItem: 2, // month view

                                    // CalendarPanel supports view-specific configs that are passed through to the
                                    // underlying views to make configuration possible without explicitly having to
                                    // create those views at this level:
                                    monthViewCfg: {
                                        showHeader: true,
                                        showWeekLinks: true,
                                        showWeekNumbers: true
                                    },

                                    // Some optional CalendarPanel configs to experiment with:
                                    // showDayView: false,
                                    // showWeekView: false,
                                    //showMonthView: false,
                                    //showNavBar: false,
                                    //showTodayText: false,
                                    //showTime: false,
                                    //title: 'My Calendar', // the header of the calendar, could be a subtitle for the app

                                    // Once this component inits it will set a reference to itself as an application
                                    // member property for easy reference in other functions within App.
                                    initComponent: function () {
                                        // App.calendarPanel = this;
                                        this.constructor.prototype.initComponent.apply(this, arguments);
                                    },

                                    listeners: {
                                        'eventclick': {
                                            fn: function (vw, rec, el) {
                                                //alert('Hola')
                                                // this.showEditWindow(rec, el);
                                                // this.clearMsg();
                                            },
                                            scope: this
                                        },
                                        'eventover': function (vw, rec, el) {
                                            //console.log('Entered evt rec='+rec.data.Title+', view='+ vw.id +', el='+el.id);
                                        },
                                        'eventout': function (vw, rec, el) {
                                            //console.log('Leaving evt rec='+rec.data.Title+', view='+ vw.id +', el='+el.id);
                                        },
                                        'eventadd': {
                                            fn: function (cp, rec) {
                                                this.showMsg('Event ' + rec.data.Title + ' was added');
                                            },
                                            scope: this
                                        },
                                        'eventupdate': {
                                            fn: function (cp, rec) {
                                                this.showMsg('Event ' + rec.data.Title + ' was updated');
                                            },
                                            scope: this
                                        },
                                        'eventdelete': {
                                            fn: function (cp, rec) {
                                                this.showMsg('Event ' + rec.data.Title + ' was deleted');
                                            },
                                            scope: this
                                        },
                                        'eventcancel': {
                                            fn: function (cp, rec) {
                                                // edit canceled
                                            },
                                            scope: this
                                        },
                                        'viewchange': {
                                            fn: function (p, vw, dateInfo) {
                                                if (this.editWin) {
                                                    this.editWin.hide();
                                                }
                                                if (dateInfo !== null) {
                                                    // will be null when switching to the event edit form so ignore
                                                    // Ext.getCmp('app-nav-picker').setValue(dateInfo.activeDate);
                                                    // this.updateTitle(dateInfo.viewStart, dateInfo.viewEnd);
                                                }
                                            },
                                            scope: this
                                        },
                                        'dayclick': {
                                            fn: function (vw, dt, ad, el) {
                                                //alert('Hola Papu')
                                                /*this.showEditWindow({
                                                    StartDate: dt,
                                                    IsAllDay: ad
                                                }, el);*/
                                              //  this.clearMsg();
                                            },
                                            scope: this
                                        },
                                        'rangeselect': {
                                            fn: function (win, dates, onComplete) {
                                                this.showEditWindow(dates);
                                                this.editWin.on('hide', onComplete, this, {single: true});
                                               // this.clearMsg();
                                            },
                                            scope: this
                                        },
                                        'eventmove': {
                                            fn: function (vw, rec) {
                                                rec.commit();
                                                var time = rec.data.IsAllDay ? '' : ' \\a\\t g:i a';
                                                this.showMsg('Event ' + rec.data.Title + ' was moved to ' + rec.data.StartDate.format('F jS' + time));
                                            },
                                            scope: this
                                        },
                                        'eventresize': {
                                            fn: function (vw, rec) {
                                                rec.commit();
                                                this.showMsg('Event ' + rec.data.Title + ' was updated');
                                            },
                                            scope: this
                                        },
                                        'initdrag': {
                                            fn: function (vw) {
                                                if (this.editWin && this.editWin.isVisible()) {
                                                    this.editWin.hide();
                                                }
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
                console.log(self.regiones)
                self.init();
                // this.load({params: {start: 0, limit: this.tam_pag}})

            },

            Atributos: [],
            tam_pag: 50,
            title: 'Calendario',
            ActList: '../../sis_gestion_social/control/DatosTecnicos/listarDatosTecnicos',
            id_store: 'id_dato_tecnico',
            fields: [],
            sortInfo: {
                field: 'id_dato_tecnico',
                direction: 'ASC'
            },
            bdel: true,
            bsave: true,

            // The edit popup window is not part of the CalendarPanel itself -- it is a separate component.
            // This makes it very easy to swap it out with a different type of window or custom view, or omit
            // it altogether. Because of this, it's up to the application code to tie the pieces together.
            // Note that this function is called from various event handlers in the CalendarPanel above.
            showEditWindow: function (rec, animateTarget) {
                if (!this.editWin) {
                    this.editWin = new Ext.calendar.EventEditWindow({
                        calendarStore: this.calendarStore,
                        listeners: {
                            'eventadd': {
                                fn: function (win, rec) {
                                    win.hide();
                                    rec.data.IsNew = false;
                                    this.eventStore.add(rec);
                                   // this.showMsg('Event ' + rec.data.Title + ' was added');
                                },
                                scope: this
                            },
                            'eventupdate': {
                                fn: function (win, rec) {
                                    win.hide();
                                    rec.commit();
                                    // this.showMsg('Event ' + rec.data.Title + ' was updated');
                                },
                                scope: this
                            },
                            'eventdelete': {
                                fn: function (win, rec) {
                                    this.eventStore.remove(rec);
                                    win.hide();
                                    // this.showMsg('Event ' + rec.data.Title + ' was deleted');
                                },
                                scope: this
                            },
                            'editdetails': {
                                fn: function (win, rec) {
                                    win.hide();
                                    this.showEditForm(rec);
                                }
                            }
                        }
                    });
                }
                this.editWin.show(rec, animateTarget);
            },

            // The CalendarPanel itself supports the standard Panel title config, but that title
            // only spans the calendar views.  For a title that spans the entire width of the app
            // we added a title to the layout's outer center region that is app-specific. This code
            // updates that outer title based on the currently-selected view range anytime the view changes.
            updateTitle: function (startDt, endDt) {
                var p = Ext.getCmp('app-center');

                if (startDt.clearTime().getTime() === endDt.clearTime().getTime()) {
                    p.setTitle(startDt.format('F j, Y'));
                } else if (startDt.getFullYear() === endDt.getFullYear()) {
                    if (startDt.getMonth() === endDt.getMonth()) {
                        p.setTitle(startDt.format('F j') + ' - ' + endDt.format('j, Y'));
                    } else {
                        p.setTitle(startDt.format('F j') + ' - ' + endDt.format('F j, Y'));
                    }
                } else {
                    p.setTitle(startDt.format('F j, Y') + ' - ' + endDt.format('F j, Y'));
                }
            },

            // This is an application-specific way to communicate CalendarPanel event messages back to the user.
            // This could be replaced with a function to do "toast" style messages, growl messages, etc. This will
            // vary based on application requirements, which is why it's not baked into the CalendarPanel.
           /* showMsg: function (msg) {
                Ext.fly('app-msg').update(msg).removeClass('x-hidden');
            },

            clearMsg: function () {
                Ext.fly('app-msg').update('').addClass('x-hidden');
            }*/
        }
    )
</script>
<div style="display:none; background-color: red">
    <div id="app-header-content" style="background-color: red">

        <!--<span id="app-msg" class="x-hidden"></span>-->
    </div>
</div>