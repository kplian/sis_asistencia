<?php
/**
 * @package pXP
 * @file NuevaProgramacion.php
 * @author  (valvarado)
 * @date 29-01-2021 09:42:00
 * @description Permite la creacion de programacion
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.NuevaProgramacion = Ext.extend(Phx.frmInterfaz, {
        nombreVista: 'NuevaProgramacion',
        tam_pag: 50,
        title: 'Nuevo Programación',
        autoScroll: true,
        bsubmit: true,
        bcancel: true,
        breset: false,
        Atributos: [
            {
                config: {
                    labelSeparator: '',
                    inputType: 'hidden',
                    name: 'id_programacion',
                    width: '100%'
                },
                type: 'Field',
                id_group: 0,
                form: true
            },
            {
                config: {
                    name: 'fecha_programada',
                    fieldLabel: 'Fecha Inicio',
                    allowBlank: false,
                    width: '100%',
                    anchor: '100%',
                    renderer: function (value, p, record) {
                        return value ? value.dateFormat(conf.format_date) : ''
                    }
                },
                type: 'DateField',
                id_grupo: 1,
                grid: true,
                form: true
            },
            {
                config: {
                    name: 'fecha_fin',
                    fieldLabel: 'Fecha Fin',
                    allowBlank: false,
                    width: '100%',
                    anchor: '100%',
                    renderer: function (value, p, record) {
                        return value ? value.dateFormat(conf.format_date) : ''
                    }
                },
                type: 'DateField',
                id_grupo: 1,
                grid: false,
                form: true
            },
            {
                config: {
                    name: 'id_funcionario',
                    hiddenName: 'id_funcionario',
                    origen: 'FUNCIONARIO',
                    fieldLabel: 'Funcionario',
                    allowBlank: false,
                    width: '100%',
                    anchor: '100%',
                    valueField: 'id_funcionario',
                    gdisplayField: 'desc_funcionario',
                    baseParams: {par_filtro: 'VFUN.desc_funcionario1#FUNCIO.id_funcionario'},
                    renderer: function (value, p, record) {
                        return String.format('{0}', record.data['desc_funcionario']);
                    }
                },
                type: 'ComboRec',
                id_grupo: 2,
                filters: {pfiltro: 'fun.desc_funcionario1', type: 'string'},
                bottom_filter: true,
                grid: true,
                form: true
            },
            {
                config: {
                    name: 'tiempo',
                    fieldLabel: 'Tiempo',
                    allowBlank: false,
                    width: '100%',
                    anchor: '100%',
                    typeAhead: true,
                    triggerAction: 'all',
                    lazyRender: true,
                    mode: 'local',
                    store: new Ext.data.ArrayStore({
                        fields: ['variable', 'valor'],
                        data: [
                            ['C', 'Completo'],
                            ['M', 'Mañana'],
                            ['T', 'Tarde']
                        ]
                    }),
                    valueField: 'variable',
                    displayField: 'valor',
                },
                type: 'ComboBox',
                filters: {pfiltro: 'tas.tiempo', type: 'string'},
                id_grupo: 1,
                valorInicial: 'Completo',
                grid: true,
                form: true
            },
            {
                config: {
                    name: 'valor',
                    allowBlank: false,
                    currencyChar: ' ',
                    fieldLabel: 'Valor',
                    width: '100%'
                },
                type: 'NumberField',
                id_group: 0,
                form: true
            },
        ],
        fields: [
            {name: 'id_programacion', type: 'numeric'},
            {name: 'id_funcionario', type: 'numeric'},
            {name: 'fecha_programada', type: 'date', dateFormat: 'Y-m-d H:i:s'},
            {name: 'fecha_fin', type: 'date', dateFormat: 'Y-m-d H:i:s'},
            {name: 'valor', type: 'numeric'},
            {name: 'tiempo', type: 'string'}
        ],
        ActSave: '../../sis_asistencia/control/Programacion/insertarProgramacion',
        ActDel: '../../sis_asistencia/control/Programacion/eliminarProgramacion',
        constructor: function (config) {
            this.maestro = config;
            Phx.vista.NuevaProgramacion.superclass.constructor.call(this, config);
            this.form.toolbars[0].addButton({
                id: 'btn-eliminar',
                text: '<i class="fa fa-trash"></i> Eliminar',
                handler: function () {
                    var id_programacion = this.getComponente('id_programacion').getValue();
                    Phx.CP.loadingShow();
                    Ext.Ajax.request({
                        url: this.ActDel,
                        params: {id_programacion: id_programacion},
                        isUpload: this.fileUpload,
                        success: this.successSave,
                        argument: this.argumentSave,
                        failure: this.conexionFailure,
                        timeout: this.timeout,
                        scope: this
                    });
                },
                scope: this
            });
            this.init();
            var programacion = this.maestro.programacion;
            this.configurarForm(programacion);
        },
        construirGrupos: function () {
            var me = this;
            me.Grupos = [
                {
                    layout: 'form',
                    border: false,
                    defaults: {
                        border: false
                    },
                    items: [{
                        layout: 'column',
                        border: false,
                        items: [{
                            columnWidth: '.5',
                            border: false,
                            hidden: me.band,
                            items: [{
                                xtype: 'fieldset',
                                title: 'Datos Obligaci&oacute;n',
                                autoHeight: true,
                                items: [],
                                id_grupo: 0
                            }]
                        },
                            {
                                columnWidth: '.5',
                                padding: '0px 5px 0px',
                                border: false,
                                hidden: me.band,
                                items: [{
                                    xtype: 'fieldset',
                                    title: 'Datos Contrato',
                                    autoHeight: true,
                                    items: [],
                                    id_grupo: 1
                                }]
                            }
                        ]
                    }, {
                        border: false,
                        width: '100%',
                        items: [{
                            xtype: 'fieldset',
                            title: 'Datos Modificatorio',
                            autoHeight: true,
                            items: [],
                            id_grupo: 2
                        }]
                    }, {
                        border: false,
                        width: '100%',
                        items: [{
                            xtype: 'fieldset',
                            title: 'Datos Informe',
                            autoHeight: true,
                            items: [],
                            id_grupo: 3
                        }]
                    }]
                }
            ];

        },
        configurarForm: function (programacion) {
            var self = this;
            console.log(programacion)
            if (Boolean(programacion.id)) {
                var id = programacion.id;
                Phx.CP.loadingShow();
                Ext.Ajax.request({
                    url: '../../sis_asistencia/control/Programacion/obtenerProgramacion',
                    params:
                        {
                            id_programacion: programacion.id
                        },
                    success: self.resultProgramacion,
                    failure: self.conexionFailure,
                    timeout: 3.6e+6,
                    scope: self
                });
            } else {
                self.llenarFormulario(this.maestro.programacion);
            }
        },
        resultProgramacion: function (data) {
            var res = Ext.util.JSON.decode(Ext.util.Format.trim(data.responseText));
            console.log(res)
            Phx.CP.loadingHide();
            this.llenarFormulario(res.datos[0])
        },

        llenarFormulario: function (programacion) {
            var self = this;
            var id_funcionario = Phx.CP.config_ini.id_funcionario;
            var start = new Date();
            var end = new Date();
            var valor = '';
            var tiempo = '';
            var id_programacion = '';
            var btnEliminarVisible = false;
            if (Boolean(programacion['start']) && Boolean(programacion['end'])) {
                start = programacion.start.dateFormat('Y-m-d');
                end = programacion.end.dateFormat('Y-m-d');
            } else if (Boolean(programacion['start'])) {
                start = programacion.start.dateFormat('Y-m-d');
                end = programacion.start.dateFormat('Y-m-d');
            } else {
                start = programacion.fecha_inicio;
            }

            if (Boolean(programacion.id_funcionario)) {
                id_funcionario = programacion.id_funcionario;
                tiempo = programacion.tiempo;
                valor = programacion.valor;
                id_programacion = programacion.id_programacion;
                btnEliminarVisible = true;
            }

            self.getComponente('id_programacion').setValue(id_programacion);
            self.getComponente('fecha_programada').setValue(start);
            self.getComponente('fecha_fin').setValue(end);
            self.getComponente('valor').setValue(valor);
            self.getComponente('tiempo').setValue(tiempo);
            Ext.getCmp('btn-eliminar').setVisible(btnEliminarVisible);
            this.Cmp.id_funcionario.store.baseParams.query = id_funcionario;
            this.Cmp.id_funcionario.store.load({
                params: {start: 0, limit: this.tam_pag},
                callback: function (r) {
                    if (r.length > 0) {
                        this.Cmp.id_funcionario.setValue(r[0].data.id_funcionario);
                        this.Cmp.id_funcionario.fireEvent('select', this.Cmp.id_funcionario, r[0].data.id_funcionario, 0)
                    }

                }, scope: this
            });
        },
        successSave: function (resp) {
            var res = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            Phx.CP.loadingHide();
            this.panel.close();
            this.fireEvent('refresh', this, res);
        },
        onSubmit: function (o, x, force) {
            var me = this;
            if (me.form.getForm().isValid() || force === true) {
                Phx.CP.loadingShow();
                Ext.apply(me.argumentSave, o.argument);
                Ext.Ajax.request({
                    url: me.ActSave,
                    params: me.getValForm,
                    isUpload: me.fileUpload,
                    success: me.successSave,
                    argument: me.argumentSave,
                    failure: me.conexionFailure,
                    timeout: me.timeout,
                    scope: me
                });
            }
        },
    })
</script>

