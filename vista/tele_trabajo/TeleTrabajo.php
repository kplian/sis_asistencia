<?php
/****************************************************************************************
 * @package pXP
 * @file gen-TeleTrabajo.php
 * @author  (admin.miguel)
 * @date 01-02-2021 14:53:44
 * @description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 *
 * HISTORIAL DE MODIFICACIONES:
 * #ISSUE                FECHA                AUTOR                DESCRIPCION
 * #0                01-02-2021 14:53:44    admin.miguel            Creacion
 * #
 *******************************************************************************************/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.TeleTrabajo = Ext.extend(Phx.gridInterfaz, {

            constructor: function (config) {
                this.maestro = config.maestro;
                //llama al constructor de la clase padre
                Phx.vista.TeleTrabajo.superclass.constructor.call(this, config);
                this.init();
                this.finCons = true;
                this.addButton('btnChequeoDocumentosWf', {
                    grupo: [0, 1, 2, 3, 4, 5],
                    text: 'Documentos',
                    iconCls: 'bchecklist',
                    disabled: true,
                    handler: this.loadCheckDocumentosRecWf,
                    tooltip: '<b>Documentos </b><br/>Subir los documetos requeridos.'
                });
                this.load({params: {start: 0, limit: this.tam_pag}});
                this.ocultarComponente(this.Cmp.fecha_inicio);
                this.ocultarComponente(this.Cmp.fecha_fin);
                this.ocultarComponente(this.Cmp.tipo_temporal);


                this.ocultarComponente(this.Cmp.lunes);
                this.ocultarComponente(this.Cmp.martes);
                this.ocultarComponente(this.Cmp.miercoles);
                this.ocultarComponente(this.Cmp.jueves);
                this.ocultarComponente(this.Cmp.viernes);
                this.iniciarEvento();
            },

            Atributos: [
                {
                    //configuracion del componente
                    config: {
                        labelSeparator: '',
                        inputType: 'hidden',
                        name: 'id_tele_trabajo'
                    },
                    type: 'Field',
                    form: true
                },
                {
                    //configuracion del componente
                    config: {
                        labelSeparator: '',
                        inputType: 'hidden',
                        name: 'id_proceso_wf'
                    },
                    type: 'Field',
                    form: true
                },
                {
                    //configuracion del componente
                    config: {
                        labelSeparator: '',
                        inputType: 'hidden',
                        name: 'id_estado_wf'
                    },
                    type: 'Field',
                    form: true
                },
                {
                    config: {
                        name: 'nro_tramite',
                        fieldLabel: 'Nro Tramite',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 130
                    },
                    type: 'TextField',
                    filters: {pfiltro: 'vac.nro_tramite', type: 'string'},
                    id_grupo: 1,
                    grid: true,
                    form: false
                },
                {
                    config: {
                        name: 'estado',
                        fieldLabel: 'Estado',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 80
                    },
                    type: 'TextField',
                    filters: {pfiltro: 'vac.estado', type: 'string'},
                    id_grupo: 1,
                    grid: true,
                    form: false
                },
                {
                    config: {
                        name: 'id_funcionario',
                        fieldLabel: 'Funcionario',
                        allowBlank: false,
                        emptyText: 'Elija una opción...',
                        store: new Ext.data.JsonStore({
                            url: '../../sis_asistencia/control/Vacacion/listarFuncionarioOficiales',
                            id: 'id_funcionario',
                            root: 'datos',
                            totalProperty: 'total',
                            fields: ['id_funcionario', 'desc_funcionario', 'codigo', 'cargo', 'departamento', 'oficina'],
                            remoteSort: true,
                            baseParams: {par_filtro: 'pe.nombre_completo1'}
                        }),
                        valueField: 'id_funcionario',
                        displayField: 'desc_funcionario',
                        gdisplayField: 'funcionario',
                        hiddenName: 'id_funcionario',
                        tpl: '<tpl for="."><div class="x-combo-list-item"><p><b>{desc_funcionario}</b></p><p>{codigo}</p><p>{cargo}</p><p>{departamento}</p><p>{oficina}</p> </div></tpl>',
                        forceSelection: true,
                        typeAhead: false,
                        triggerAction: 'all',
                        lazyRender: true,
                        disabled: false,
                        mode: 'remote',
                        pageSize: 15,
                        queryDelay: 1000,
                        width: 320,
                        gwidth: 220,
                        minChars: 2,
                        renderer: function (value, p, record) {
                            return String.format('{0}', record.data['funcionario']);
                        }
                    },
                    type: 'ComboBox',
                    filters: {pfiltro: 'fu.desc_funcionario2', type: 'string'},
                    id_grupo: 1,
                    grid: true,
                    form: true,
                    bottom_filter: true
                },
                {
                    config: {
                        name: 'id_responsable',
                        fieldLabel: 'Responsable',
                        allowBlank: false,
                        emptyText: 'Elija una opción...',
                        store: new Ext.data.JsonStore({
                            url: '../../sis_asistencia/control/Permiso/listaResponsable',
                            id: 'id_funcionario',
                            root: 'datos',
                            sortInfo: {
                                field: 'numero_nivel',
                                direction: 'DESC'
                            },
                            totalProperty: 'total',
                            fields: ['id_funcionario', 'desc_funcionario'],
                            remoteSort: true,
                            baseParams: {par_filtro: 'f.desc_funcionario1'}
                        }),
                        valueField: 'id_funcionario',
                        displayField: 'desc_funcionario',
                        gdisplayField: 'responsable',
                        hiddenName: 'id_responsable',
                        forceSelection: true,
                        disableKeyFilter: true,
                        editable: false,
                        typeAhead: false,
                        triggerAction: 'all',
                        lazyRender: true,
                        mode: 'remote',
                        pageSize: 15,
                        queryDelay: 1000,
                        width: 320,
                        gwidth: 200,
                        minChars: 2,
                        renderer: function (value, p, record) {
                            return String.format('{0}', record.data['responsable']);
                        }
                    },
                    type: 'ComboBox',
                    id_grupo: 1,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'tipo_teletrabajo',
                        fieldLabel: 'Tipo',
                        allowBlank: false,
                        emptyText: 'Tipo Teletrabajo...',
                        typeAhead: true,
                        triggerAction: 'all',
                        lazyRender: true,
                        mode: 'local',
                        width: 320,
                        store: ['Permanente', 'Temporal'],
                        editable: false,
                    },
                    type: 'ComboBox',
                    id_grupo: 0,
                    form: true,
                    grid: true
                },
                {
                    config: {
                        name: 'tipo_temporal',
                        fieldLabel: 'Tipo Temporal',
                        allowBlank: false,
                        emptyText: 'Tipo Temporal...',
                        typeAhead: true,
                        triggerAction: 'all',
                        lazyRender: true,
                        mode: 'local',
                        width: 320,
                        store: ['Mixto', 'Alterno'],
                        editable: false,
                    },
                    type: 'ComboBox',
                    id_grupo: 0,
                    form: true,
                    grid: true
                },
                {
                    config: {
                        name: 'fecha_inicio',
                        fieldLabel: 'Desde',
                        allowBlank: false,
                        width: 320,
                        gwidth: 100,
                        format: 'd/m/Y',
                        disabledDays: [0, 6],
                        renderer: function (value, p, record) {
                            return value ? value.dateFormat('d/m/Y') : ''
                        }
                    },
                    type: 'DateField',
                    filters: {pfiltro: 'tlt.fecha_inicio', type: 'date'},
                    id_grupo: 1,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'fecha_fin',
                        fieldLabel: 'Hasta',
                        allowBlank: false,
                        width: 320,
                        gwidth: 100,
                        format: 'd/m/Y',
                        disabledDays: [0, 6],
                        renderer: function (value, p, record) {
                            return value ? value.dateFormat('d/m/Y') : ''
                        }
                    },
                    type: 'DateField',
                    filters: {pfiltro: 'tlt.fecha_fin', type: 'date'},
                    id_grupo: 1,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'lunes',
                        fieldLabel: 'Lu',
                        qtip:'Seleccione los dias de teletrabajo',
                        renderer: function (value, p, record) {
                            return record.data['lunes'] ? 'si' : 'no';
                        },
                        gwidth: 50,

                    },
                    type: 'Checkbox',
                    id_grupo: 1,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'martes',
                        fieldLabel: 'Ma',
                        qtip:'Seleccione los dias de teletrabajo',
                        renderer: function (value, p, record) {
                            return record.data['martes'] ? 'si' : 'no';
                        },
                        gwidth: 50,

                    },
                    type: 'Checkbox',
                    id_grupo: 1,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'miercoles',
                        fieldLabel: 'Mi',
                        qtip:'Seleccione los dias de teletrabajo',
                        renderer: function (value, p, record) {
                            return record.data['miercoles'] ? 'si' : 'no';
                        },
                        gwidth: 50,

                    },
                    type: 'Checkbox',
                    id_grupo: 1,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'jueves',
                        fieldLabel: 'Ju',
                        qtip:'Seleccione los dias de teletrabajo',
                        renderer: function (value, p, record) {
                            return record.data['jueves'] ? 'si' : 'no';
                        },
                        gwidth: 50,

                    },
                    type: 'Checkbox',
                    id_grupo: 1,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'viernes',
                        fieldLabel: 'Vi',
                        qtip:'Seleccione los dias de teletrabajo',
                        renderer: function (value, p, record) {
                            return record.data['viernes'] ? 'si' : 'no';
                        },
                        gwidth: 50,

                    },
                    type: 'Checkbox',
                    id_grupo: 1,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'motivo',
                        fieldLabel: 'Motivo',
                        allowBlank: false,
                        emptyText: 'Tipo Motivo...',
                        typeAhead: true,
                        triggerAction: 'all',
                        lazyRender: true,
                        mode: 'local',
                        width: 320,
                        store: ['Salud', 'Caso Fortuito', 'Fuerza Mayor'],
                        editable: false,
                    },
                    type: 'ComboBox',
                    id_grupo: 0,
                    form: true,
                    grid: true
                },
                {
                    config: {
                        name: 'justificacion',
                        fieldLabel: 'Justificacion',
                        allowBlank: false,
                        width: 320,
                        gwidth: 100
                    },
                    type: 'TextArea',
                    filters: {pfiltro: 'tlt.justificacion', type: 'string'},
                    id_grupo: 1,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'usr_reg',
                        fieldLabel: 'Creado por',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength: 4
                    },
                    type: 'Field',
                    filters: {pfiltro: 'usu1.cuenta', type: 'string'},
                    id_grupo: 1,
                    grid: true,
                    form: false
                },
                {
                    config: {
                        name: 'estado_reg',
                        fieldLabel: 'Estado Reg.',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength: 10
                    },
                    type: 'TextField',
                    filters: {pfiltro: 'tlt.estado_reg', type: 'string'},
                    id_grupo: 1,
                    grid: true,
                    form: false
                },
                {
                    config: {
                        name: 'fecha_reg',
                        fieldLabel: 'Fecha creación',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        format: 'd/m/Y',
                        renderer: function (value, p, record) {
                            return value ? value.dateFormat('d/m/Y H:i:s') : ''
                        }
                    },
                    type: 'DateField',
                    filters: {pfiltro: 'tlt.fecha_reg', type: 'date'},
                    id_grupo: 1,
                    grid: true,
                    form: false
                },
                {
                    config: {
                        name: 'id_usuario_ai',
                        fieldLabel: 'Fecha creación',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength: 4
                    },
                    type: 'Field',
                    filters: {pfiltro: 'tlt.id_usuario_ai', type: 'numeric'},
                    id_grupo: 1,
                    grid: false,
                    form: false
                },
                {
                    config: {
                        name: 'usuario_ai',
                        fieldLabel: 'Funcionaro AI',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength: 300
                    },
                    type: 'TextField',
                    filters: {pfiltro: 'tlt.usuario_ai', type: 'string'},
                    id_grupo: 1,
                    grid: true,
                    form: false
                },
                {
                    config: {
                        name: 'usr_mod',
                        fieldLabel: 'Modificado por',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength: 4
                    },
                    type: 'Field',
                    filters: {pfiltro: 'usu2.cuenta', type: 'string'},
                    id_grupo: 1,
                    grid: true,
                    form: false
                },
                {
                    config: {
                        name: 'fecha_mod',
                        fieldLabel: 'Fecha Modif.',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        format: 'd/m/Y',
                        renderer: function (value, p, record) {
                            return value ? value.dateFormat('d/m/Y H:i:s') : ''
                        }
                    },
                    type: 'DateField',
                    filters: {pfiltro: 'tlt.fecha_mod', type: 'date'},
                    id_grupo: 1,
                    grid: true,
                    form: false
                }
            ],
            tam_pag: 50,
            title: 'Tele Trabajo',
            ActSave: '../../sis_asistencia/control/TeleTrabajo/insertarTeleTrabajo',
            ActDel: '../../sis_asistencia/control/TeleTrabajo/eliminarTeleTrabajo',
            ActList: '../../sis_asistencia/control/TeleTrabajo/listarTeleTrabajo',
            id_store: 'id_tele_trabajo',
            fields: [
                {name: 'id_tele_trabajo', type: 'numeric'},
                {name: 'estado_reg', type: 'string'},
                {name: 'id_funcionario', type: 'numeric'},
                {name: 'id_responsable', type: 'numeric'},
                {name: 'fecha_inicio', type: 'date', dateFormat: 'Y-m-d'},
                {name: 'fecha_fin', type: 'date', dateFormat: 'Y-m-d'},
                {name: 'justificacion', type: 'string'},
                {name: 'id_usuario_reg', type: 'numeric'},
                {name: 'fecha_reg', type: 'date', dateFormat: 'Y-m-d H:i:s.u'},
                {name: 'id_usuario_ai', type: 'numeric'},
                {name: 'usuario_ai', type: 'string'},
                {name: 'id_usuario_mod', type: 'numeric'},
                {name: 'fecha_mod', type: 'date', dateFormat: 'Y-m-d H:i:s.u'},
                {name: 'usr_reg', type: 'string'},
                {name: 'usr_mod', type: 'string'},
                {name: 'estado', type: 'string'},
                {name: 'nro_tramite', type: 'string'},
                {name: 'id_proceso_wf', type: 'numeric'},
                {name: 'id_estado_wf', type: 'numeric'},
                {name: 'funcionario', type: 'string'},
                {name: 'responsable', type: 'string'},
                {name: 'tipo_teletrabajo', type: 'string'},
                {name: 'motivo', type: 'string'},
                {name: 'tipo_temporal', type: 'string'},
                {name: 'lunes', type: 'boolean'},
                {name: 'martes', type: 'boolean'},
                {name: 'miercoles', type: 'boolean'},
                {name: 'jueves', type: 'boolean'},
                {name: 'viernes', type: 'boolean'},
            ],
            sortInfo: {
                field: 'id_tele_trabajo',
                direction: 'DESC'
            },
            bdel: true,
            bsave: false,
            fwidth: '35%',
            fheight: '68%',
            onButtonNew: function () {
                Phx.vista.TeleTrabajo.superclass.onButtonNew.call(this);//habilita el boton y se abre

                this.Cmp.id_funcionario.store.load({
                    params: {start: 0, limit: this.tam_pag, es_combo_solicitud: 'si'},
                    callback: function (r) {
                        if (r.length > 0) {
                            this.Cmp.id_funcionario.setValue(r[0].data.id_funcionario);
                            this.Cmp.id_funcionario.fireEvent('select', this.Cmp.id_funcionario, r[0]);
                            this.Cmp.id_funcionario.modificado = true;
                            this.Cmp.id_funcionario.collapse();
                            this.onCargarResponsable(r[0].data.id_funcionario, true);
                        }

                    }, scope: this
                });

                this.Cmp.id_funcionario.on('select', function (combo, record, index) {
                    this.Cmp.id_responsable.reset();
                    this.Cmp.id_responsable.store.baseParams = Ext.apply(this.Cmp.id_responsable.store.baseParams, {id_funcionario: record.data.id_funcionario});
                    this.Cmp.id_responsable.modificado = true;
                }, this);

            },
            onButtonEdit: function () {
                Phx.vista.TeleTrabajo.superclass.onButtonEdit.call(this);
                this.onCargarResponsable(this.Cmp.id_funcionario.getValue(), false);
                this.Cmp.id_funcionario.on('select', function (combo, record, index) {
                    this.Cmp.id_responsable.reset();
                    this.Cmp.id_responsable.store.baseParams = Ext.apply(this.Cmp.id_responsable.store.baseParams, {id_funcionario: record.data.id_funcionario});
                    this.onCargarResponsable(record.data.id_funcionario, true);
                    this.Cmp.id_responsable.modificado = true;
                }, this);
                if (this.Cmp.tipo_teletrabajo.getValue() === 'Permanente') {
                    this.mostrarComponente(this.Cmp.fecha_inicio);
                    this.ocultarComponente(this.Cmp.fecha_fin);
                    this.ocultarComponente(this.Cmp.tipo_temporal);
                }
                if (this.Cmp.tipo_teletrabajo.getValue() === 'Temporal') {
                    this.ocultarComponente(this.Cmp.fecha_inicio);
                    this.ocultarComponente(this.Cmp.fecha_fin);
                    this.mostrarComponente(this.Cmp.tipo_temporal);
                }
                if (this.Cmp.tipo_temporal.getValue() === 'Mixto') {
                    this.mostrarComponente(this.Cmp.fecha_inicio);
                    this.mostrarComponente(this.Cmp.fecha_fin);
                    this.mostrarComponente(this.Cmp.lunes);
                    this.mostrarComponente(this.Cmp.martes);
                    this.mostrarComponente(this.Cmp.miercoles);
                    this.mostrarComponente(this.Cmp.jueves);
                    this.mostrarComponente(this.Cmp.viernes);
                }
                if (this.Cmp.tipo_temporal.getValue() === 'Alterno') {
                    this.mostrarComponente(this.Cmp.fecha_inicio);
                    this.mostrarComponente(this.Cmp.fecha_fin);
                    this.mostrarComponente(this.Cmp.lunes);
                    this.mostrarComponente(this.Cmp.martes);
                    this.mostrarComponente(this.Cmp.miercoles);
                    this.mostrarComponente(this.Cmp.jueves);
                    this.mostrarComponente(this.Cmp.viernes);
                }


            },
            onCargarResponsable: function (id, filtro = true) {
                const rec = this.sm.getSelected();
                this.Cmp.id_responsable.store.baseParams = Ext.apply(this.Cmp.id_responsable.store.baseParams, {id_funcionario: id});
                this.Cmp.id_responsable.modificado = true;
                if (filtro) {
                    this.Cmp.id_responsable.store.load({
                        params: {start: 0, limit: this.tam_pag, id_funcionario: id},
                        callback: function (r) {
                            this.Cmp.id_responsable.setValue(r[0].data.id_funcionario);
                            this.Cmp.id_responsable.fireEvent('select', this.Cmp.id_responsable, r[0]);
                            this.Cmp.id_responsable.collapse();
                        }, scope: this
                    });
                }
            },
            addBotonesGantt: function () {
                this.menuAdqGantt = new Ext.Toolbar.SplitButton({
                    id: 'b-diagrama_gantt-' + this.idContenedor,
                    text: 'Gantt',
                    disabled: true,
                    grupo: [0, 1, 2],
                    iconCls: 'bgantt',
                    handler: this.diagramGanttDinamico,
                    scope: this,
                    menu: {
                        items: [{
                            id: 'b-gantti-' + this.idContenedor,
                            text: 'Gantt Imagen',
                            tooltip: '<b>Muestra un reporte gantt en formato de imagen</b>',
                            handler: this.diagramGantt,
                            scope: this
                        }, {
                            id: 'b-ganttd-' + this.idContenedor,
                            text: 'Gantt Dinámico',
                            tooltip: '<b>Muestra el reporte gantt facil de entender</b>',
                            handler: this.diagramGanttDinamico,
                            scope: this
                        }
                        ]
                    }
                });
                this.tbar.add(this.menuAdqGantt);
            },
            diagramGantt: function () {
                var data = this.sm.getSelected().data.id_proceso_wf;
                Phx.CP.loadingShow();
                Ext.Ajax.request({
                    url: '../../sis_workflow/control/ProcesoWf/diagramaGanttTramite',
                    params: {'id_proceso_wf': data},
                    success: this.successExport,
                    failure: this.conexionFailure,
                    timeout: this.timeout,
                    scope: this
                });
            },
            onSiguiente: function () {
                Phx.CP.loadingShow();
                const rec = this.sm.getSelected(); //obtine los datos selecionado en la grilla
                if (confirm('¿Enviar solicitud a ' + rec.data.responsable + '?')) {
                    Ext.Ajax.request({
                        url: '../../sis_asistencia/control/TeleTrabajo/aprobarEstado',
                        params: {
                            id_proceso_wf: rec.data.id_proceso_wf,
                            id_estado_wf: rec.data.id_estado_wf,
                            evento: 'siguiente',
                            obs: ''
                        },
                        success: this.successWizard,
                        failure: this.conexionFailure,
                        timeout: this.timeout,
                        scope: this
                    });
                } else {
                    Phx.CP.loadingHide();
                }
            },
            successWizard: function (resp) {
                Phx.CP.loadingHide();
                const reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
                console.log(reg.ROOT.datos.id_proceso_wf)
                this.load({params: {start: 0, limit: this.tam_pag}});
                this.reload();
            },
            iniciarEvento: function () {
                this.Cmp.tipo_teletrabajo.on('select', function (combo, record, index) {
                    if (record.data.field1 === 'Permanente') {
                        this.mostrarComponente(this.Cmp.fecha_inicio);
                        this.ocultarComponente(this.Cmp.fecha_fin);
                        this.ocultarComponente(this.Cmp.tipo_temporal);
                        this.ocultarComponente(this.Cmp.lunes);
                        this.ocultarComponente(this.Cmp.martes);
                        this.ocultarComponente(this.Cmp.miercoles);
                        this.ocultarComponente(this.Cmp.jueves);
                        this.ocultarComponente(this.Cmp.viernes);
                    }
                    if (record.data.field1 === 'Temporal') {
                        this.ocultarComponente(this.Cmp.fecha_inicio);
                        this.ocultarComponente(this.Cmp.fecha_fin);
                        this.mostrarComponente(this.Cmp.tipo_temporal);
                        this.ocultarComponente(this.Cmp.lunes);
                        this.ocultarComponente(this.Cmp.martes);
                        this.ocultarComponente(this.Cmp.miercoles);
                        this.ocultarComponente(this.Cmp.jueves);
                        this.ocultarComponente(this.Cmp.viernes);
                    }
                }, this);

                this.Cmp.tipo_temporal.on('select', function (combo, record, index) {
                    if (record.data.field1 === 'Mixto') {
                        this.mostrarComponente(this.Cmp.fecha_inicio);
                        this.mostrarComponente(this.Cmp.fecha_fin);
                        this.mostrarComponente(this.Cmp.lunes);
                        this.mostrarComponente(this.Cmp.martes);
                        this.mostrarComponente(this.Cmp.miercoles);
                        this.mostrarComponente(this.Cmp.jueves);
                        this.mostrarComponente(this.Cmp.viernes);

                        this.Cmp.lunes.setValue(false);
                        this.Cmp.martes.setValue(false);
                        this.Cmp.miercoles.setValue(false);
                        this.Cmp.jueves.setValue(false);
                        this.Cmp.viernes.setValue(false);
                    }
                    if (record.data.field1 === 'Alterno') {
                        this.mostrarComponente(this.Cmp.fecha_inicio);
                        this.mostrarComponente(this.Cmp.fecha_fin);
                        this.mostrarComponente(this.Cmp.lunes);
                        this.mostrarComponente(this.Cmp.martes);
                        this.mostrarComponente(this.Cmp.miercoles);
                        this.mostrarComponente(this.Cmp.jueves);
                        this.mostrarComponente(this.Cmp.viernes);

                        this.Cmp.lunes.setValue(true);
                        this.Cmp.martes.setValue(true);
                        this.Cmp.miercoles.setValue(true);
                        this.Cmp.jueves.setValue(true);
                        this.Cmp.viernes.setValue(true);
                    }
                }, this);
            },
            loadCheckDocumentosRecWf: function () {
                var rec = this.sm.getSelected();
                rec.data.nombreVista = this.nombreVista;
                Phx.CP.loadWindows('../../../sis_workflow/vista/documento_wf/DocumentoWf.php',
                    'Chequear documento del WF',
                    {
                        width: '90%',
                        height: 500
                    },
                    rec.data,
                    this.idContenedor,
                    'DocumentoWf'
                )
            },
        }
    )
</script>
        
        