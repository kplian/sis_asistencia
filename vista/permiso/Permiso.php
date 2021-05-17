<?php
/**
 * @package pXP
 * @file gen-Permiso.php
 * @author  (miguel.mamani)
 * @date 16-10-2019 13:14:05
 * @description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 * HISTORIAL DE MODIFICACIONES:
 * #ISSUE                FECHA                AUTOR                DESCRIPCION
 * #0                16-10-2019                 (miguel.mamani)                CREACION
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.Permiso = Ext.extend(Phx.gridInterfaz, {
            constructor: function (config) {
                this.maestro = config.maestro;
                //llama al constructor de la clase padre
                Phx.vista.Permiso.superclass.constructor.call(this, config);
                this.init();
                this.finCons = true;

                this.addButton('btn_siguiente', {
                    grupo: [0, 2, 3],
                    text: 'Enviar Solicitud',
                    iconCls: 'bemail',
                    disabled: true,
                    handler: this.onSiguiente
                });

                this.addButton('btn_atras', {
                    grupo: [2, 3],
                    argument: {estado: 'anterior'},
                    text: 'Anterior',
                    iconCls: 'batras',
                    disabled: true,
                    handler: this.onAtras,
                    tooltip: '<b>Pasar al Anterior Estado</b>'
                });

                this.addButton('btnChequeoDocumentosWf', {
                    grupo: [0, 1, 2, 3, 4, 5],
                    text: 'Documentos',
                    iconCls: 'bchecklist',
                    disabled: true,
                    handler: this.loadCheckDocumentosRecWf,
                    tooltip: '<b>Documentos </b><br/>Subir los documetos requeridos.'
                });
                this.addBotonesGantt();
                this.onFormulario();
                this.iniciarEventos();
                this.load({params: {start: 0, limit: this.tam_pag}})
            },
            iniciarEventos: function () {

                this.Cmp.fecha_inicio.on('select', function (Fecha, dato) {
                    Ext.Ajax.request({
                        url: '../../sis_asistencia/control/Vacacion/getDias', //llamando a la funcion getDias.
                        params: {
                            'fecha_fin': this.Cmp.fecha_fin.getValue(),
                            'fecha_inicio': Fecha.getValue(),
                            'dias': 0,

                            'medios_dias': '',
                            'id_funcionario': this.Cmp.id_funcionario.getValue()

                        },
                        success: this.respuestaValidacion,
                        failure: this.conexionFailure,
                        timeout: this.timeout,
                        scope: this
                    });
                }, this);

                this.Cmp.fecha_fin.on('select', function (Fecha, dato) {
                    Ext.Ajax.request({
                        url: '../../sis_asistencia/control/Vacacion/getDias', //llamando a la funcion getDias.
                        params: {
                            'fecha_fin': Fecha.getValue(),
                            'fecha_inicio': this.Cmp.fecha_inicio.getValue(),
                            'dias': 0,

                            'medios_dias': '',
                            'id_funcionario': this.Cmp.id_funcionario.getValue()


                        },
                        success: this.respuestaValidacion,
                        failure: this.conexionFailure,
                        timeout: this.timeout,
                        scope: this
                    });
                }, this);

                this.Cmp.fecha_inicio.on('change', function (Fecha, dato) {
                    Ext.Ajax.request({
                        url: '../../sis_asistencia/control/Vacacion/getDias', //llamando a la funcion getDias.
                        params: {
                            'fecha_fin': this.Cmp.fecha_fin.getValue(),
                            'fecha_inicio': Fecha.getValue(),
                            'dias': 0,

                            'medios_dias': '',
                            'id_funcionario': this.Cmp.id_funcionario.getValue()

                        },
                        success: this.respuestaValidacion,
                        failure: this.conexionFailure,
                        timeout: this.timeout,
                        scope: this
                    });
                }, this);

                this.Cmp.fecha_fin.on('change', function (Fecha, dato) {
                    Ext.Ajax.request({
                        url: '../../sis_asistencia/control/Vacacion/getDias', //llamando a la funcion getDias.
                        params: {
                            'fecha_fin': Fecha.getValue(),
                            'fecha_inicio': this.Cmp.fecha_inicio.getValue(),
                            'dias': 0,

                            'medios_dias': '',
                            'id_funcionario': this.Cmp.id_funcionario.getValue()


                        },
                        success: this.respuestaValidacion,
                        failure: this.conexionFailure,
                        timeout: this.timeout,
                        scope: this
                    });
                }, this);
            },
            arrayStore: {
                'Selección': [
                    ['', ''],
                ],
                'Selección2': [],
            },
            respuestaValidacion: function (s, m) {

                this.maestro = m;
                // console.log('Prueba de parametros1', s.responseText);
                var respuesta_valid = s.responseText.split('%');
                //console.log('Prueba de parametros2', respuesta_valid[1]);
                // this.Cmp.dias_efectivo.setValue(respuesta_valid[1]); //dias

                this.arrayStore.Selección = [];
                this.arrayStore.Selección = ['', ''];
                for (var i = 0; i <= parseInt(respuesta_valid[1]); i++) {
                    this.arrayStore.Selección[i] = ["ID" + (i), (i)];
                }
                console.log(this.arrayStore);
                // this.Cmp.medio_dia.reset(); /// restablecer el campo evento_medios_dias, cada que se cambia el rango de fechas.
                // this.Cmp.medio_dia.store.loadData(this.arrayStore.Selección);
                this.Cmp.dias.reset(); /// dias_efectivo
                this.Cmp.dias.setValue(respuesta_valid[1]); //diasdias_efectivo; dias


            },
            Atributos: [
                {
                    //configuracion del componente
                    config: {
                        labelSeparator: '',
                        inputType: 'hidden',
                        name: 'id_permiso'
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
                    //configuracion del componente
                    config: {
                        labelSeparator: '',
                        inputType: 'hidden',
                        name: 'asignar_rango'
                    },
                    type: 'Field',
                    form: true
                },
                {
                    config: {
                        name: 'nro_tramite',
                        fieldLabel: 'Nro Tramite',
                        allowBlank: true,
                        width: 250,
                        gwidth: 150
                    },
                    type: 'TextField',
                    filters: {pfiltro: 'pmo.nro_tramite', type: 'string'},
                    id_grupo: 0,
                    grid: true,
                    form: false
                },
                {
                    config: {
                        name: 'estado',
                        fieldLabel: 'Estado',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 80,
                        maxLength: 50,
                        renderer: function (value, p, record) {
                            if (value === 'rechazado') {
                                return String.format('<b><font color="#a52a2a">{0}</font></b>', value)
                            }
                            return String.format('<b><font>{0}</font></b>', value)
                        }
                    },
                    type: 'TextField',
                    filters: {pfiltro: 'pmo.estado', type: 'string'},
                    id_grupo: 0,
                    grid: true,
                    form: false
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
                            fields: ['id_funcionario', 'desc_funcionario', 'numero_nivel', 'codigo'],
                            remoteSort: true,
                            baseParams: {par_filtro: 'fun.desc_funcionario1#fun.codigo'}
                        }),
                        valueField: 'id_funcionario',
                        displayField: 'desc_funcionario',
                        gdisplayField: 'responsable',
                        hiddenName: 'id_responsable',
                        tpl: '<tpl for="."><div class="x-combo-list-item"><p><b>{desc_funcionario}</b></p><p>{desc_funcionario_cargo}</p></div></tpl>',
                        forceSelection: true,
                        typeAhead: false,
                        disableKeyFilter: true,
                        editable: false,
                        triggerAction: 'all',
                        lazyRender: true,
                        mode: 'remote',
                        pageSize: 15,
                        queryDelay: 1000,
                        width: 300,
                        gwidth: 280,
                        minChars: 2,
                        renderer: function (value, p, record) {
                            return String.format('{0}', record.data['responsable']);
                        }
                    },
                    type: 'ComboBox',
                    id_grupo: 0,
                    grid: true,
                    form: true
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
                            baseParams: {par_filtro: 'pe.nombre_completo1#fun.codigo'}
                        }),
                        valueField: 'id_funcionario',
                        displayField: 'desc_funcionario',
                        gdisplayField: 'desc_funcionario',
                        hiddenName: 'Funcionario',
                        tpl: '<tpl for="."><div class="x-combo-list-item"><p><b>{desc_funcionario}</b></p><p>{codigo}</p><p>{cargo}</p><p>{departamento}</p><p>{oficina}</p> </div></tpl>',
                        forceSelection: true,
                        typeAhead: false,
                        triggerAction: 'all',
                        lazyRender: true,
                        mode: 'remote',
                        pageSize: 15,
                        queryDelay: 1000,
                        width: 300,
                        gwidth: 250,
                        minChars: 2,
                        renderer: function (value, p, record) {
                            if (record.data['funcionario_sol'] !== '') {
                                return '<tpl for="."><div><p><b>Registro: </b> ' + record.data['funcionario_sol'] + '</p>' +
                                    '<p><b>Para: </b> ' + record.data['desc_funcionario'] + '</p>' +
                                    '</div></tpl>';
                            } else {
                                return '<tpl for="."><div><p>' + record.data['desc_funcionario'] + '</p></div></tpl>';
                            }
                        }
                    },
                    type: 'ComboBox',
                    filters: {pfiltro: 'fun.desc_funcionario1', type: 'string'},
                    id_grupo: 1,
                    grid: true,
                    form: true,
                    bottom_filter: true
                },
                {
                    config: {
                        name: 'observaciones',
                        fieldLabel: 'Obs, ',
                        allowBlank: false,
                        width: 300,
                        gwidth: 300,
                        renderer: function (value, metaData, record, rowIndex, colIndex, store) {
                            metaData.css = 'multilineColumn';
                            return String.format('<div class="gridmultiline"><font color="#a52a2a">{0}</font></div>', value);//#4
                        }
                    },
                    type: 'TextArea',
                    filters: {pfiltro: 'pmo.observaciones', type: 'string'},
                    id_grupo: 0,
                    grid: true,
                    form: false
                },
                {
                    config: {
                        name: 'id_tipo_permiso',
                        fieldLabel: 'Tipo Permiso',
                        allowBlank: false,
                        emptyText: 'Elija una opción...',
                        store: new Ext.data.JsonStore({
                            url: '../../sis_asistencia/control/TipoPermiso/listarTipoPermiso',
                            id: 'id_tipo_permiso',
                            root: 'datos',
                            sortInfo: {
                                field: 'nombre',
                                direction: 'ASC'
                            },
                            totalProperty: 'total',
                            fields: ['id_tipo_permiso', 'nombre', 'codigo',
                                'documento', 'reposcion', 'tiempo', 'rango',
                                'detalle', 'rango_fecha','compensacion_fecha'],
                            remoteSort: true,
                            baseParams: {par_filtro: 'tpo.nombre#tpo.codigo'}
                        }),
                        valueField: 'id_tipo_permiso',
                        displayField: 'nombre',
                        gdisplayField: 'desc_tipo_permiso',
                        hiddenName: 'id_tipo_permiso',
                        forceSelection: true,
                        typeAhead: false,
                        triggerAction: 'all',
                        lazyRender: true,
                        mode: 'remote',
                        pageSize: 15,
                        queryDelay: 1000,
                        width: 300,
                        gwidth: 200,
                        minChars: 2,
                        renderer: function (value, p, record) {
                            return String.format('{0}', record.data['desc_tipo_permiso']);
                        }
                    },
                    type: 'ComboBox',
                    id_grupo: 0,
                    filters: {pfiltro: 'movtip.nombre', type: 'string'},
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'id_tipo_licencia',
                        fieldLabel: 'Tipo de licencia',
                        allowBlank: false,
                        emptyText: 'Elija una opción...',
                        store: new Ext.data.JsonStore({
                            url: '../../sis_asistencia/control/DetalleTipoPermiso/listarDetalleTipoPermiso',
                            id: 'id_detalle_tipo_permiso',
                            root: 'datos',
                            sortInfo: {
                                field: 'nombre',
                                direction: 'ASC'
                            },
                            totalProperty: 'total',
                            fields: ['id_detalle_tipo_permiso', 'nombre', 'descripcion', 'dias'],
                            remoteSort: true,
                            baseParams: {par_filtro: 'tpo.nombre#tpo.codigo'}
                        }),
                        valueField: 'id_detalle_tipo_permiso',
                        displayField: 'nombre',
                        gdisplayField: 'desc_tipo_licencia',
                        hiddenName: 'id_detalle_tipo_permiso',
                        tpl: '<tpl for="."><div class="x-combo-list-item"><p>{nombre}: <b>Permiso de {dias} días</b></p></div></tpl>',
                        forceSelection: true,
                        typeAhead: false,
                        triggerAction: 'all',
                        lazyRender: true,
                        mode: 'remote',
                        pageSize: 15,
                        queryDelay: 1000,
                        width: 300,
                        gwidth: 200,
                        minChars: 2,
                        renderer: function (value, p, record) {
                            return String.format('{0}', record.data['desc_tipo_licencia']);
                        }
                    },
                    type: 'ComboBox',
                    id_grupo: 0,
                    filters: {pfiltro: 'movtip.nombre', type: 'string'},
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'fecha_inicio',
                        fieldLabel: 'Fecha Inicio',
                        allowBlank: false,
                        anchor: '70%',
                        gwidth: 100,
                        format: 'd/m/Y',
                        disabledDays: [0, 6],
                        renderer: function (value, p, record) {
                            return value ? value.dateFormat('d/m/Y') : ''
                        }
                    },
                    type: 'DateField',
                    filters: {pfiltro: 'vac.fecha_inicio', type: 'date'},
                    id_grupo: 1,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'fecha_fin',
                        fieldLabel: 'Fecha Fin',
                        allowBlank: false,
                        anchor: '70%',
                        gwidth: 100,
                        format: 'd/m/Y',
                        disabledDays: [0, 6],
                        renderer: function (value, p, record) {
                            return value ? value.dateFormat('d/m/Y') : ''
                        }
                    },
                    type: 'DateField',
                    filters: {pfiltro: 'vac.fecha_fin', type: 'date'},
                    id_grupo: 1,
                    grid: true,
                    form: true
                },
                {

                    config: {
                        name: 'dias',
                        fieldLabel: 'Dias Efectivos',
                        allowBlank: true,
                        anchor: '50%',
                        gwidth: 100,
                        style: 'background-image: none;',
                        disabled: true,
                    },
                    type: 'NumberField',
                    filters: {pfiltro: 'vac.dias', type: 'numeric'},
                    id_grupo: 1,
                    grid: true,
                    form: true,
                },
                {
                    config: {
                        name: 'fecha_solicitud',
                        fieldLabel: 'Fecha Permiso',
                        allowBlank: false,
                        width: 130,
                        gwidth: 100,
                        format: 'd/m/Y',
                       // disabledDays: [1,2,3,4,5],
                       // disabledDates: ['^02'],
                        renderer: function (value, p, record) {
                            return value ? value.dateFormat('d/m/Y') : ''
                        }
                    },
                    type: 'DateField',
                    filters: {pfiltro: 'pmo.fecha_solicitud', type: 'date'},
                    id_grupo: 0,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'hro_desde',
                        fieldLabel: 'Desde',
                        allowBlank: true,
                        increment: 10,
                        minValue: '00:00:00',
                        maxValue: '23:55:00',
                        width: 100,
                        format: 'H:i:s',
                        anchor: '50%',
                        renderer: function (value, p, record) {
                            return value ? value.dateFormat('H:i:s') : ''
                        }
                    },
                    type: 'TimeField',
                    id_grupo: 0,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'hro_hasta',
                        fieldLabel: 'Hasta',
                        allowBlank: true,
                        increment: 10,
                        minValue: '00:00:00',
                        maxValue: '23:55:00',
                        width: 100,
                        format: 'H:i:s',
                        anchor: '50%',
                        renderer: function (value, p, record) {
                            return value ? value.dateFormat('H:i:s') : ''
                        }
                    },
                    type: 'TimeField',
                    id_grupo: 0,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'hro_total_permiso',
                        fieldLabel: 'Total Horas',
                        allowBlank: true,
                        anchor: '50%',
                        gwidth: 100,
                        readOnly: true,
                        format: 'H:i:s',
                        style: 'background-image: none;',
                        renderer: function (value, p, record) {
                            return String.format('<b><font size=2>{0}</font></b>', value ? value.dateFormat('H:i:s') : '')
                        }

                    },
                    type: 'TimeField',
                    id_grupo: 0,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'inicio_comp',
                        fieldLabel: 'Inicio compensación',
                        allowBlank: false,
                        anchor: '70%',
                        gwidth: 100,
                        format: 'd/m/Y',
                        disabledDays: [1,2,3,4,5],
                        renderer: function (value, p, record) {
                            return value ? value.dateFormat('d/m/Y') : ''
                        }
                    },
                    type: 'DateField',
                    filters: {pfiltro: 'vac.fecha_inicio', type: 'date'},
                    id_grupo: 1,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'fin_comp',
                        fieldLabel: 'Fin Compensación',
                        allowBlank: false,
                        anchor: '70%',
                        gwidth: 100,
                        format: 'd/m/Y',
                        disabledDays: [1,2,3,4,5],
                        renderer: function (value, p, record) {
                            return value ? value.dateFormat('d/m/Y') : ''
                        }
                    },
                    type: 'DateField',
                    filters: {pfiltro: 'vac.fecha_fin', type: 'date'},
                    id_grupo: 1,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'motivo',
                        fieldLabel: 'Justificativo ',
                        allowBlank: false,
                        width: 300,
                        gwidth: 250
                    },
                    type: 'TextArea',
                    filters: {pfiltro: 'pmo.motivo', type: 'string'},
                    id_grupo: 0,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'fecha_reposicion',
                        fieldLabel: 'Fecha Reposicion',
                        allowBlank: false,
                        width: 130,
                        gwidth: 100,
                        readOnly: false,
                        format: 'd/m/Y',
                        renderer: function (value, p, record) {
                            return String.format('<b><font size=2>{0}</font></b>', value ? value.dateFormat('d/m/Y') : '')
                        }
                    },
                    type: 'DateField',
                    filters: {pfiltro: 'pmo.fecha_solicitud', type: 'date'},
                    id_grupo: 1,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'hro_desde_reposicion',
                        fieldLabel: 'Desde',
                        allowBlank: false,
                        increment: 10,
                        width: 100,
                        format: 'H:i:s',
                        anchor: '50%',
                        renderer: function (value, p, record) {
                            return value ? value.dateFormat('H:i:s') : ''
                        }

                    },
                    type: 'TimeField',
                    id_grupo: 1,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'hro_hasta_reposicion',
                        fieldLabel: 'Hasta',
                        allowBlank: false,
                        increment: 10,
                        width: 100,
                        format: 'H:i:s',
                        anchor: '50%',
                        renderer: function (value, p, record) {
                            return value ? value.dateFormat('H:i:s') : ''
                        }

                    },
                    type: 'TimeField',
                    id_grupo: 1,
                    grid: true,
                    form: true
                },

                {
                    config: {
                        name: 'hro_total_reposicion',
                        fieldLabel: 'Total Horas Reponer',
                        gwidth: 100,
                        readOnly: true,
                        format: 'H:i:s',
                        style: 'background-image: none;',
                        anchor: '50%',
                        renderer: function (value, p, record) {
                            return value ? value.dateFormat('H:i:s') : ''
                        }
                    },
                    type: 'TimeField',
                    id_grupo: 1,
                    grid: false,
                    form: true
                },
                {
                    config: {
                        name: 'usr_reg',
                        fieldLabel: 'Creado por',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 200,
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
                    filters: {pfiltro: 'pmo.estado_reg', type: 'string'},
                    id_grupo: 1,
                    grid: true,
                    form: false
                }, {
                    config: {
                        name: 'departamento',
                        fieldLabel: '',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength: 10
                    },
                    type: 'TextField',
                    id_grupo: 1,
                    grid: true,
                    form: false

                },
                {
                    config: {
                        name: 'id_usuario_ai',
                        fieldLabel: '',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength: 4
                    },
                    type: 'Field',
                    filters: {pfiltro: 'pmo.id_usuario_ai', type: 'numeric'},
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
                    filters: {pfiltro: 'pmo.usuario_ai', type: 'string'},
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
                    filters: {pfiltro: 'pmo.fecha_reg', type: 'date'},
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
                    filters: {pfiltro: 'pmo.fecha_mod', type: 'date'},
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
                }
            ],
            tam_pag: 50,
            title: 'Permiso',
            ActSave: '../../sis_asistencia/control/Permiso/insertarPermiso',
            ActDel: '../../sis_asistencia/control/Permiso/eliminarPermiso',
            ActList: '../../sis_asistencia/control/Permiso/listarPermiso',
            id_store: 'id_permiso',
            fields: [
                {name: 'id_permiso', type: 'numeric'},
                {name: 'nro_tramite', type: 'string'},
                {name: 'id_funcionario', type: 'numeric'},
                {name: 'id_estado_wf', type: 'numeric'},
                {name: 'fecha_solicitud', type: 'date', dateFormat: 'Y-m-d'},
                {name: 'id_tipo_permiso', type: 'numeric'},
                {name: 'motivo', type: 'string'},
                {name: 'estado_reg', type: 'string'},
                {name: 'estado', type: 'string'},
                {name: 'id_proceso_wf', type: 'numeric'},
                {name: 'id_usuario_ai', type: 'numeric'},
                {name: 'id_usuario_reg', type: 'numeric'},
                {name: 'usuario_ai', type: 'string'},
                {name: 'fecha_reg', type: 'date', dateFormat: 'Y-m-d H:i:s.u'},
                {name: 'fecha_mod', type: 'date', dateFormat: 'Y-m-d H:i:s.u'},
                {name: 'id_usuario_mod', type: 'numeric'},
                {name: 'usr_reg', type: 'string'},
                {name: 'usr_mod', type: 'string'},

                {name: 'desc_tipo_permiso', type: 'string'},
                {name: 'desc_funcionario', type: 'string'},
                {name: 'hro_desde', type: 'date', dateFormat: 'H:i:s'},
                {name: 'hro_hasta', type: 'date', dateFormat: 'H:i:s'},
                {name: 'asignar_rango', type: 'string'},
                {name: 'documento', type: 'string'},

                {name: 'fecha_reposicion', type: 'date', dateFormat: 'Y-m-d'},
                {name: 'hro_desde_reposicion', type: 'date', dateFormat: 'H:i:s'},
                {name: 'hro_hasta_reposicion', type: 'date', dateFormat: 'H:i:s'},
                {name: 'hro_total_permiso', type: 'date', dateFormat: 'H:i:s'},
                {name: 'hro_total_reposicion', type: 'date', dateFormat: 'H:i:s'},
                {name: 'id_responsable', type: 'numeric'},
                {name: 'responsable', type: 'string'},

                {name: 'funcionario_sol', type: 'string'},
                {name: 'observaciones', type: 'string'},
                {name: 'id_uo', type: 'numeric'},
                {name: 'departamento', type: 'string'},

                {name: 'id_tipo_licencia', type: 'numeric'},
                {name: 'fecha_inicio', type: 'date', dateFormat: 'Y-m-d'},
                {name: 'fecha_fin', type: 'date', dateFormat: 'Y-m-d'},
                {name: 'dias', type: 'numeric'},
                {name: 'desc_tipo_licencia', type: 'string'},
                {name: 'inicio_comp', type: 'date', dateFormat: 'Y-m-d'},
                {name: 'fin_comp', type: 'date', dateFormat: 'Y-m-d'},
            ],
            sortInfo: {
                field: 'id_permiso',
                direction: 'DESC'
            },
            bdel: true,
            bsave: false,
            fwidth: '32%',
            fheight: '70%',
            onFormulario: function () {
                this.ocultarComponente(this.Cmp.fecha_reposicion);
                this.ocultarComponente(this.Cmp.hro_desde_reposicion);
                this.ocultarComponente(this.Cmp.hro_hasta_reposicion);
                this.ocultarComponente(this.Cmp.hro_total_reposicion);
                this.ocultarComponente(this.Cmp.hro_desde);
                this.ocultarComponente(this.Cmp.hro_hasta);
                this.ocultarComponente(this.Cmp.hro_total_permiso);
                this.ocultarComponente(this.Cmp.motivo);

                this.ocultarComponente(this.Cmp.id_tipo_licencia);
                this.ocultarComponente(this.Cmp.fecha_inicio);
                this.ocultarComponente(this.Cmp.fecha_fin);
                this.ocultarComponente(this.Cmp.dias);
                this.ocultarComponente(this.Cmp.inicio_comp);
                this.ocultarComponente(this.Cmp.fin_comp);
            },
            addBotonesGantt: function () {
                this.menuAdqGantt = new Ext.Toolbar.SplitButton({
                    id: 'b-diagrama_gantt-' + this.idContenedor,
                    text: 'Gantt',
                    disabled: true,
                    grupo: [0, 1, 2, 4, 5],
                    iconCls: 'bgantt',
                    handler: this.diagramGantt,
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
            diagramGanttDinamico: function () {
                const data = this.sm.getSelected().data.id_proceso_wf;
                window.open('../../../sis_workflow/reportes/gantt/gantt_dinamico.html?id_proceso_wf=' + data)
            },
            preparaMenu: function (n) {
                Phx.vista.Permiso.superclass.preparaMenu.call(this, n);
                const rec = this.getSelectedData();
                this.getBoton('btn_atras').enable();
                this.getBoton('diagrama_gantt').enable();
                this.getBoton('btn_siguiente').enable();
                this.getBoton('btnChequeoDocumentosWf').enable();
            },
            liberaMenu: function () {
                const tb = Phx.vista.Permiso.superclass.liberaMenu.call(this);
                if (tb) {
                    this.getBoton('btn_atras').disable();
                    this.getBoton('diagrama_gantt').disable();
                    this.getBoton('btn_siguiente').disable();
                    this.getBoton('btnChequeoDocumentosWf').disable();
                }
            },
            onButtonNew: function () {
                Phx.vista.Permiso.superclass.onButtonNew.call(this);
                this.Cmp.fecha_solicitud.setValue(new Date());
                this.Cmp.fecha_solicitud.fireEvent('change');
                this.Cmp.id_tipo_permiso.on('select', function (combo, record, index) {
                    this.mostrarComponente(this.Cmp.hro_desde);
                    this.mostrarComponente(this.Cmp.hro_hasta);
                    this.mostrarComponente(this.Cmp.hro_total_permiso);
                    this.mostrarComponente(this.Cmp.motivo);
                    if (record.data.reposcion === 'si') {
                        this.window.setSize(490, 600);
                        this.mostrarComponente(this.Cmp.fecha_reposicion);
                        this.mostrarComponente(this.Cmp.hro_desde_reposicion);
                        this.mostrarComponente(this.Cmp.hro_hasta_reposicion);
                        this.mostrarComponente(this.Cmp.hro_total_reposicion);

                        this.ocultarComponente(this.Cmp.id_tipo_licencia);
                        this.ocultarComponente(this.Cmp.fecha_inicio);
                        this.ocultarComponente(this.Cmp.fecha_fin);
                        this.ocultarComponente(this.Cmp.dias);
                        this.Cmp.hro_desde.allowBlank = false;
                        this.Cmp.hro_hasta.allowBlank = false;
                        this.ocultarComponente(this.Cmp.inicio_comp);
                        this.ocultarComponente(this.Cmp.fin_comp);
                    } else if (record.data.detalle === 'si') {
                        this.window.setSize(490, 500);
                        this.ocultarComponente(this.Cmp.hro_desde);
                        this.ocultarComponente(this.Cmp.hro_hasta);
                        this.ocultarComponente(this.Cmp.hro_total_permiso);
                        this.ocultarComponente(this.Cmp.fecha_solicitud);
                        this.ocultarComponente(this.Cmp.fecha_reposicion);
                        this.ocultarComponente(this.Cmp.hro_desde_reposicion);
                        this.ocultarComponente(this.Cmp.hro_hasta_reposicion);
                        this.ocultarComponente(this.Cmp.hro_total_reposicion);
                        // licencias
                        this.mostrarComponente(this.Cmp.id_tipo_licencia);
                        this.mostrarComponente(this.Cmp.fecha_inicio);
                        this.mostrarComponente(this.Cmp.fecha_fin);
                        this.mostrarComponente(this.Cmp.dias);
                        this.Cmp.hro_desde.allowBlank = false;
                        this.Cmp.hro_hasta.allowBlank = false;
                        this.ocultarComponente(this.Cmp.inicio_comp);
                        this.ocultarComponente(this.Cmp.fin_comp);

                    } else if (record.data.rango_fecha === 'si') {
                        this.window.setSize(490, 600);
                        this.mostrarComponente(this.Cmp.fecha_inicio);
                        this.mostrarComponente(this.Cmp.fecha_fin);
                        this.mostrarComponente(this.Cmp.dias);

                        this.ocultarComponente(this.Cmp.fecha_solicitud);
                        this.ocultarComponente(this.Cmp.fecha_reposicion);
                        this.ocultarComponente(this.Cmp.hro_desde_reposicion);
                        this.ocultarComponente(this.Cmp.hro_hasta_reposicion);
                        this.ocultarComponente(this.Cmp.hro_total_reposicion);
                        this.ocultarComponente(this.Cmp.id_tipo_licencia);

                        this.Cmp.hro_desde.allowBlank = true;
                        this.Cmp.hro_hasta.allowBlank = true;
                        this.ocultarComponente(this.Cmp.inicio_comp);
                        this.ocultarComponente(this.Cmp.fin_comp);
                    }else if (record.data.compensacion_fecha === 'si') {
                        this.window.setSize(490, 600);
                        this.mostrarComponente(this.Cmp.fecha_inicio);
                        this.mostrarComponente(this.Cmp.fecha_fin);
                        this.mostrarComponente(this.Cmp.dias);
                        this.mostrarComponente(this.Cmp.inicio_comp);
                        this.mostrarComponente(this.Cmp.fin_comp);


                        this.ocultarComponente(this.Cmp.fecha_solicitud);
                        this.ocultarComponente(this.Cmp.fecha_reposicion);
                        this.ocultarComponente(this.Cmp.hro_desde_reposicion);
                        this.ocultarComponente(this.Cmp.hro_hasta_reposicion);
                        this.ocultarComponente(this.Cmp.hro_total_reposicion);
                        this.ocultarComponente(this.Cmp.id_tipo_licencia);
                        this.ocultarComponente(this.Cmp.hro_desde);
                        this.ocultarComponente(this.Cmp.hro_hasta);
                        this.ocultarComponente(this.Cmp.hro_total_permiso);
                    }
                    else {
                        this.window.setSize(490, 400);
                        this.ocultarComponente(this.Cmp.fecha_reposicion);
                        this.ocultarComponente(this.Cmp.hro_desde_reposicion);
                        this.ocultarComponente(this.Cmp.hro_hasta_reposicion);
                        this.ocultarComponente(this.Cmp.hro_total_reposicion);

                        this.ocultarComponente(this.Cmp.id_tipo_licencia);
                        this.ocultarComponente(this.Cmp.fecha_inicio);
                        this.ocultarComponente(this.Cmp.fecha_fin);
                        this.ocultarComponente(this.Cmp.dias);
                        this.Cmp.hro_desde.allowBlank = false;
                        this.Cmp.hro_hasta.allowBlank = false;

                        this.ocultarComponente(this.Cmp.inicio_comp);
                        this.ocultarComponente(this.Cmp.fin_comp);
                    }
                }, this);
                this.onCalcularRango();
                this.Cmp.id_funcionario.store.load({
                    params: {start: 0, limit: this.tam_pag, es_combo_solicitud: 'si'},
                    callback: function (r) {
                        if (r.length > 0) {
                            this.Cmp.id_funcionario.setValue(r[0].data.id_funcionario);
                            this.Cmp.id_funcionario.fireEvent('select', this.Cmp.id_funcionario, r[0]);
                            this.Cmp.id_funcionario.modificado = true;
                            this.Cmp.id_funcionario.collapse();
                            this.onCargarResponsable(r[0].data.id_funcionario);
                        }
                    }, scope: this
                });
                this.Cmp.id_funcionario.on('select', function (combo, record, index) {
                    this.Cmp.id_responsable.reset();
                    this.Cmp.id_responsable.store.baseParams = Ext.apply(this.Cmp.id_responsable.store.baseParams, {id_funcionario: record.data.id_funcionario});
                    this.Cmp.id_responsable.modificado = true;
                }, this);

                this.onPermisoRol();

            },
            onCargarResponsable: function (id) {
                this.Cmp.id_responsable.store.baseParams = Ext.apply(this.Cmp.id_responsable.store.baseParams, {id_funcionario: id});
                this.Cmp.id_responsable.modificado = true;
                this.Cmp.id_responsable.store.load({
                    params: {start: 0, limit: this.tam_pag, id_funcionario: id},
                    callback: function (r) {
                        this.Cmp.id_responsable.setValue(r[0].data.id_funcionario);
                        this.Cmp.id_responsable.fireEvent('select', this.Cmp.id_responsable, r[0]);
                        this.Cmp.id_responsable.collapse();
                    }, scope: this
                });
            },
            onButtonEdit: function () {
                Phx.vista.Permiso.superclass.onButtonEdit.call(this);
                var me = this;
                this.Cmp.id_tipo_permiso.store.load({
                    params: {start: 0, limit: 50, id_tipo_permiso: this.Cmp.id_tipo_permiso.getValue()},
                    callback: function (r) {
                        for (const value of r) {
                            this.mostrarComponente(me.Cmp.hro_desde);
                            this.mostrarComponente(me.Cmp.hro_hasta);
                            this.mostrarComponente(me.Cmp.hro_total_permiso);
                            this.mostrarComponente(me.Cmp.motivo);
                            if (record.data.reposcion === 'si') {
                                this.window.setSize(490, 600);
                                this.mostrarComponente(me.Cmp.fecha_reposicion);
                                this.mostrarComponente(me.Cmp.hro_desde_reposicion);
                                this.mostrarComponente(me.Cmp.hro_hasta_reposicion);
                                this.mostrarComponente(me.Cmp.hro_total_reposicion);

                                this.ocultarComponente(me.Cmp.id_tipo_licencia);
                                this.ocultarComponente(me.Cmp.fecha_inicio);
                                this.ocultarComponente(me.Cmp.fecha_fin);
                                this.ocultarComponente(me.Cmp.dias);
                                me.Cmp.hro_desde.allowBlank = false;
                                me.Cmp.hro_hasta.allowBlank = false;
                                this.ocultarComponente(mes.Cmp.inicio_comp);
                                this.ocultarComponente(mes.Cmp.fin_comp);
                            } else if (record.data.detalle === 'si') {
                                this.window.setSize(490, 500);
                                this.ocultarComponente(me.Cmp.hro_desde);
                                this.ocultarComponente(me.Cmp.hro_hasta);
                                this.ocultarComponente(me.Cmp.hro_total_permiso);
                                this.ocultarComponente(me.Cmp.fecha_solicitud);
                                this.ocultarComponente(me.Cmp.fecha_reposicion);
                                this.ocultarComponente(me.Cmp.hro_desde_reposicion);
                                this.ocultarComponente(me.Cmp.hro_hasta_reposicion);
                                this.ocultarComponente(me.Cmp.hro_total_reposicion);
                                // licencias
                                this.mostrarComponente(me.Cmp.id_tipo_licencia);
                                this.mostrarComponente(me.Cmp.fecha_inicio);
                                this.mostrarComponente(me.Cmp.fecha_fin);
                                this.mostrarComponente(me.Cmp.dias);
                                me.Cmp.hro_desde.allowBlank = false;
                                me.Cmp.hro_hasta.allowBlank = false;
                                this.ocultarComponente(me.Cmp.inicio_comp);
                                this.ocultarComponente(me.Cmp.fin_comp);

                            } else if (record.data.rango_fecha === 'si') {
                                this.window.setSize(490, 600);
                                this.mostrarComponente(me.Cmp.fecha_inicio);
                                this.mostrarComponente(me.Cmp.fecha_fin);
                                this.mostrarComponente(me.Cmp.dias);

                                this.ocultarComponente(me.Cmp.fecha_solicitud);
                                this.ocultarComponente(me.Cmp.fecha_reposicion);
                                this.ocultarComponente(me.Cmp.hro_desde_reposicion);
                                this.ocultarComponente(me.Cmp.hro_hasta_reposicion);
                                this.ocultarComponente(me.Cmp.hro_total_reposicion);
                                this.ocultarComponente(me.Cmp.id_tipo_licencia);

                                me.Cmp.hro_desde.allowBlank = true;
                                me.Cmp.hro_hasta.allowBlank = true;
                                this.ocultarComponente(me.Cmp.inicio_comp);
                                this.ocultarComponente(me.Cmp.fin_comp);
                            }else if (record.data.compensacion_fecha === 'si') {
                                this.window.setSize(490, 600);
                                this.mostrarComponente(me.Cmp.fecha_inicio);
                                this.mostrarComponente(me.Cmp.fecha_fin);
                                this.mostrarComponente(me.Cmp.dias);
                                this.mostrarComponente(me.Cmp.inicio_comp);
                                this.mostrarComponente(me.Cmp.fin_comp);


                                this.ocultarComponente(me.Cmp.fecha_solicitud);
                                this.ocultarComponente(me.Cmp.fecha_reposicion);
                                this.ocultarComponente(me.Cmp.hro_desde_reposicion);
                                this.ocultarComponente(me.Cmp.hro_hasta_reposicion);
                                this.ocultarComponente(me.Cmp.hro_total_reposicion);
                                this.ocultarComponente(me.Cmp.id_tipo_licencia);
                                this.ocultarComponente(me.Cmp.hro_desde);
                                this.ocultarComponente(me.Cmp.hro_hasta);
                                this.ocultarComponente(me.Cmp.hro_total_permiso);
                            }
                            else {
                                this.window.setSize(490, 400);
                                this.ocultarComponente(me.Cmp.fecha_reposicion);
                                this.ocultarComponente(me.Cmp.hro_desde_reposicion);
                                this.ocultarComponente(me.Cmp.hro_hasta_reposicion);
                                this.ocultarComponente(me.Cmp.hro_total_reposicion);

                                this.ocultarComponente(me.Cmp.id_tipo_licencia);
                                this.ocultarComponente(me.Cmp.fecha_inicio);
                                this.ocultarComponente(me.Cmp.fecha_fin);
                                this.ocultarComponente(me.Cmp.dias);
                                me.Cmp.hro_desde.allowBlank = false;
                                me.Cmp.hro_hasta.allowBlank = false;

                                this.ocultarComponente(me.Cmp.inicio_comp);
                                this.ocultarComponente(me.Cmp.fin_comp);
                            }
                        }
                    }, scope: this
                });
                this.Cmp.id_tipo_permiso.on('select', function (combo, record, index) {
                    this.mostrarComponente(this.Cmp.hro_desde);
                    this.mostrarComponente(this.Cmp.hro_hasta);
                    this.mostrarComponente(this.Cmp.hro_total_permiso);
                    this.mostrarComponente(this.Cmp.motivo);
                    if (record.data.reposcion === 'si') {
                        this.window.setSize(490, 600);
                        this.mostrarComponente(this.Cmp.fecha_reposicion);
                        this.mostrarComponente(this.Cmp.hro_desde_reposicion);
                        this.mostrarComponente(this.Cmp.hro_hasta_reposicion);
                        this.mostrarComponente(this.Cmp.hro_total_reposicion);

                        this.ocultarComponente(this.Cmp.id_tipo_licencia);
                        this.ocultarComponente(this.Cmp.fecha_inicio);
                        this.ocultarComponente(this.Cmp.fecha_fin);
                        this.ocultarComponente(this.Cmp.dias);
                        this.Cmp.hro_desde.allowBlank = false;
                        this.Cmp.hro_hasta.allowBlank = false;
                        this.ocultarComponente(this.Cmp.inicio_comp);
                        this.ocultarComponente(this.Cmp.fin_comp);
                    } else if (record.data.detalle === 'si') {
                        this.window.setSize(490, 500);
                        this.ocultarComponente(this.Cmp.hro_desde);
                        this.ocultarComponente(this.Cmp.hro_hasta);
                        this.ocultarComponente(this.Cmp.hro_total_permiso);
                        this.ocultarComponente(this.Cmp.fecha_solicitud);
                        this.ocultarComponente(this.Cmp.fecha_reposicion);
                        this.ocultarComponente(this.Cmp.hro_desde_reposicion);
                        this.ocultarComponente(this.Cmp.hro_hasta_reposicion);
                        this.ocultarComponente(this.Cmp.hro_total_reposicion);
                        // licencias
                        this.mostrarComponente(this.Cmp.id_tipo_licencia);
                        this.mostrarComponente(this.Cmp.fecha_inicio);
                        this.mostrarComponente(this.Cmp.fecha_fin);
                        this.mostrarComponente(this.Cmp.dias);
                        this.Cmp.hro_desde.allowBlank = false;
                        this.Cmp.hro_hasta.allowBlank = false;
                        this.ocultarComponente(this.Cmp.inicio_comp);
                        this.ocultarComponente(this.Cmp.fin_comp);

                    } else if (record.data.rango_fecha === 'si') {
                        this.window.setSize(490, 600);
                        this.mostrarComponente(this.Cmp.fecha_inicio);
                        this.mostrarComponente(this.Cmp.fecha_fin);
                        this.mostrarComponente(this.Cmp.dias);

                        this.ocultarComponente(this.Cmp.fecha_solicitud);
                        this.ocultarComponente(this.Cmp.fecha_reposicion);
                        this.ocultarComponente(this.Cmp.hro_desde_reposicion);
                        this.ocultarComponente(this.Cmp.hro_hasta_reposicion);
                        this.ocultarComponente(this.Cmp.hro_total_reposicion);
                        this.ocultarComponente(this.Cmp.id_tipo_licencia);

                        this.Cmp.hro_desde.allowBlank = true;
                        this.Cmp.hro_hasta.allowBlank = true;
                        this.ocultarComponente(this.Cmp.inicio_comp);
                        this.ocultarComponente(this.Cmp.fin_comp);
                    }else if (record.data.compensacion_fecha === 'si') {
                        this.window.setSize(490, 600);
                        this.mostrarComponente(this.Cmp.fecha_inicio);
                        this.mostrarComponente(this.Cmp.fecha_fin);
                        this.mostrarComponente(this.Cmp.dias);
                        this.mostrarComponente(this.Cmp.inicio_comp);
                        this.mostrarComponente(this.Cmp.fin_comp);


                        this.ocultarComponente(this.Cmp.fecha_solicitud);
                        this.ocultarComponente(this.Cmp.fecha_reposicion);
                        this.ocultarComponente(this.Cmp.hro_desde_reposicion);
                        this.ocultarComponente(this.Cmp.hro_hasta_reposicion);
                        this.ocultarComponente(this.Cmp.hro_total_reposicion);
                        this.ocultarComponente(this.Cmp.id_tipo_licencia);
                        this.ocultarComponente(this.Cmp.hro_desde);
                        this.ocultarComponente(this.Cmp.hro_hasta);
                        this.ocultarComponente(this.Cmp.hro_total_permiso);
                    }
                    else {
                        this.window.setSize(490, 400);
                        this.ocultarComponente(this.Cmp.fecha_reposicion);
                        this.ocultarComponente(this.Cmp.hro_desde_reposicion);
                        this.ocultarComponente(this.Cmp.hro_hasta_reposicion);
                        this.ocultarComponente(this.Cmp.hro_total_reposicion);

                        this.ocultarComponente(this.Cmp.id_tipo_licencia);
                        this.ocultarComponente(this.Cmp.fecha_inicio);
                        this.ocultarComponente(this.Cmp.fecha_fin);
                        this.ocultarComponente(this.Cmp.dias);
                        this.Cmp.hro_desde.allowBlank = false;
                        this.Cmp.hro_hasta.allowBlank = false;

                        this.ocultarComponente(this.Cmp.inicio_comp);
                        this.ocultarComponente(this.Cmp.fin_comp);
                    }
                }, this);
                this.onCalcularRango();
                this.Cmp.id_funcionario.on('select', function (combo, record, index) {
                    this.Cmp.id_responsable.reset();
                    this.Cmp.id_responsable.store.baseParams = Ext.apply(this.Cmp.id_responsable.store.baseParams, {id_funcionario: record.data.id_funcionario});
                    this.Cmp.id_responsable.modificado = true;
                }, this);
                this.onPermisoRol();
            },
            onPermisoRol: function () {
                Ext.Ajax.request({
                    url: '../../sis_asistencia/control/Permiso/permisoRol',
                    params: {rol_asignado: 'ASIS - Rrhh'},
                    success: function (resp) {
                        const reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
                        if (Number(reg.ROOT.datos.rol) === 1) {
                            this.Cmp.id_funcionario.enable();

                        } else {
                            this.Cmp.id_funcionario.disable(true);

                        }
                    },
                    failure: this.conexionFailure,
                    timeout: this.timeout,
                    scope: this
                });
            },
            onCalcularRango: function () {
                this.Cmp.hro_desde.on('select', function (combo, record) {
                    if (this.Cmp.hro_hasta.getValue() !== '') {
                        this.Cmp.hro_total_permiso.reset();
                        Ext.Ajax.request({
                            url: '../../sis_asistencia/control/Permiso/calcularRango',
                            params: {
                                desde: record.data.field1,
                                hasta: this.Cmp.hro_hasta.getValue(),
                                contro: 'si'
                            },
                            success: function (resp) {
                                const reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
                                this.Cmp.hro_total_permiso.setValue(reg.ROOT.datos.resultado);
                            },
                            failure: this.conexionFailure,
                            timeout: this.timeout,
                            scope: this
                        });
                    }
                }, this);
                this.Cmp.hro_hasta.on('select', function (combo, record) {
                    if (this.Cmp.hro_desde.getValue() !== '') {
                        this.Cmp.hro_total_permiso.reset();
                        Ext.Ajax.request({
                            url: '../../sis_asistencia/control/Permiso/calcularRango',
                            params: {
                                desde: this.Cmp.hro_desde.getValue(),
                                hasta: record.data.field1,
                                contro: 'si'
                            },
                            success: function (resp) {
                                const reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));

                                console.log(reg.ROOT.datos.resultado);
                                this.Cmp.hro_total_permiso.setValue(reg.ROOT.datos.resultado);
                            },
                            failure: this.conexionFailure,
                            timeout: this.timeout,
                            scope: this
                        });
                    }
                }, this);
                this.Cmp.hro_desde_reposicion.on('select', function (combo, record, index) {
                    if (this.Cmp.hro_hasta_reposicion.getValue() !== '') {
                        this.Cmp.hro_total_reposicion.reset();
                        Ext.Ajax.request({
                            url: '../../sis_asistencia/control/Permiso/calcularRango',
                            params: {
                                desde: record.data.field1,
                                hasta: this.Cmp.hro_hasta_reposicion.getValue(),
                                contro: 'no'
                            },
                            success: function (resp) {
                                const reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
                                this.Cmp.hro_total_reposicion.setValue(reg.ROOT.datos.resultado);
                            },
                            failure: this.conexionFailure,
                            timeout: this.timeout,
                            scope: this
                        });
                    }
                }, this);
                this.Cmp.hro_hasta_reposicion.on('select', function (combo, record, index) {
                    if (this.Cmp.hro_desde_reposicion.getValue() !== '') {
                        this.Cmp.hro_total_reposicion.reset();
                        Ext.Ajax.request({
                            url: '../../sis_asistencia/control/Permiso/calcularRango',
                            params: {
                                desde: this.Cmp.hro_desde_reposicion.getValue(),
                                hasta: record.data.field1,
                                contro: 'no'
                            },
                            success: function (resp) {
                                const reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
                                this.Cmp.hro_total_reposicion.setValue(reg.ROOT.datos.resultado);
                            },
                            failure: this.conexionFailure,
                            timeout: this.timeout,
                            scope: this
                        });
                    }
                }, this);
            },
            onAtras: function (res) {
                var rec = this.sm.getSelected();
                Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/AntFormEstadoWf.php',
                    'Estado de Wf',
                    {
                        modal: true,
                        width: 450,
                        height: 250
                    }, {data: rec.data, estado_destino: res.argument.estado}, this.idContenedor, 'AntFormEstadoWf',
                    {
                        config: [{
                            event: 'beforesave',
                            delegate: this.onAntEstado
                        }
                        ],
                        scope: this
                    })
            },
            onAntEstado: function (wizard, resp) {
                Phx.CP.loadingShow();
                Ext.Ajax.request({
                    url: '../../sis_asistencia/control/Permiso/aprobarEstado',
                    params: {
                        id_proceso_wf: resp.id_proceso_wf,
                        id_estado_wf: resp.id_estado_wf,
                        evento: 'rechazado',
                        obs: resp.obs
                    },
                    argument: {wizard: wizard},
                    success: this.successEstadoSinc,
                    failure: this.conexionFailure,
                    timeout: this.timeout,
                    scope: this
                });
            },
            successEstadoSinc: function (resp) {
                Phx.CP.loadingHide();
                resp.argument.wizard.panel.destroy();
                this.reload();
            },
            onSiguiente: function () {
                Phx.CP.loadingShow();
                const rec = this.sm.getSelected(); //obtine los datos selecionado en la grilla 
                if (confirm('¿Enviar solicitud?')) {
                    Ext.Ajax.request({
                        url: '../../sis_asistencia/control/Permiso/aprobarEstado',
                        params: {
                            id_proceso_wf: rec.data.id_proceso_wf,
                            id_estado_wf: rec.data.id_estado_wf,
                            evento: 'aprobado',
                            obs: ''
                        },
                        success: this.successWizard,
                        failure: this.conexionFailure,
                        timeout: this.timeout,
                        scope: this
                    });
                }
                Phx.CP.loadingHide();
            },
            onSaveWizard: function (wizard, resp) {
                var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
                Phx.CP.loadingShow();
                Ext.Ajax.request({
                    url: '../../sis_asistencia/control/Permiso/siguienteEstado',
                    params: {
                        id_proceso_wf_act: resp.id_proceso_wf_act,
                        id_estado_wf_act: resp.id_estado_wf_act,
                        id_tipo_estado: resp.id_tipo_estado,
                        id_funcionario_wf: resp.id_funcionario_wf,
                        id_depto_wf: resp.id_depto_wf,
                        obs: resp.obs,
                        json_procesos: Ext.util.JSON.encode(resp.procesos)
                    },
                    success: this.successWizard,
                    failure: this.conexionFailure,
                    argument: {wizard: wizard},
                    timeout: this.timeout,
                    scope: this
                });
            },
            successWizard: function (resp) {
                Phx.CP.loadingHide();
                // resp.argument.wizard.panel.destroy();
                this.reload();
            },
        }
    )
</script>
