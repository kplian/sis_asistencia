<?php
/****************************************************************************************
 * @package pXP
 * @file Compensacion.php
 * @author  (amamani)
 * @date 18-05-2021 14:14:39
 * @description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 *
 * HISTORIAL DE MODIFICACIONES:
 * #ISSUE                FECHA                AUTOR                DESCRIPCION
 * #0                18-05-2021 14:14:39    amamani            Creacion
 * #
 *******************************************************************************************/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.Compensacion = Ext.extend(Phx.gridInterfaz, {

            constructor: function (config) {
                this.maestro = config.maestro;
                //llama al constructor de la clase padre
                Phx.vista.Compensacion.superclass.constructor.call(this, config);
                this.init();
                this.finCons = true;
                this.load({params: {start: 0, limit: this.tam_pag}})
            },

            Atributos: [
                {
                    //configuracion del componente
                    config: {
                        labelSeparator: '',
                        inputType: 'hidden',
                        name: 'id_compensacion'
                    },
                    type: 'Field',
                    form: true
                },
                {
                    //configuracion del componente
                    config: {
                        labelSeparator: '',
                        inputType: 'hidden',
                        name: 'id_procesos_wf'
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
                        fieldLabel: 'Nro. Tramite',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 150
                    },
                    type: 'TextField',
                    filters: {pfiltro: 'cpm.nro_tramite', type: 'string'},
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
                        gwidth: 150,
                    },
                    type: 'TextField',
                    filters: {pfiltro: 'cpm.estado', type: 'string'},
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
                        hiddenName: 'Funcionario',
                        tpl: '<tpl for="."><div class="x-combo-list-item"><p><b>{desc_funcionario}</b></p><p>{codigo}</p><p>{cargo}</p><p>{departamento}</p><p>{oficina}</p> </div></tpl>',
                        forceSelection: true,
                        typeAhead: false,
                        triggerAction: 'all',
                        lazyRender: true,
                        mode: 'remote',
                        pageSize: 15,
                        queryDelay: 1000,
                        anchor: '85%',
                        gwidth: 300,
                        minChars: 2,
                        renderer: function (value, p, record) {
                            return String.format('{0}', record.data['funcionario']);

                            // return '<tpl for="."><div class="x-combo-list-item"><p>' + record.data['funcionario'] + '</p></div></tpl>';
                        }
                    },
                    type: 'ComboBox',
                    filters: {pfiltro: 'vf.desc_funcionario1', type: 'string'},
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
                        anchor: '85%',
                        gwidth: 300,
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
                        name: 'social_forestal',
                        fieldLabel: 'Gestión Social o Forestal ',
                        editable:false,
                        renderer: function (value, p, record) {
                            return record.data['social_forestal'] ? 'si' : 'no';
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
                        name: 'desde',
                        fieldLabel: 'Fecha inicio trabajo',
                        allowBlank: false,
                        anchor: '60%',
                        gwidth: 100,
                        format: 'd/m/Y',
                        editable:false,
                        // disabledDays: [1, 2, 3, 4, 5],
                        renderer: function (value, p, record) {
                            return value ? value.dateFormat('d/m/Y') : ''
                        }
                    },
                    type: 'DateField',
                    filters: {pfiltro: 'cpm.desde', type: 'date'},
                    id_grupo: 1,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'hasta',
                        fieldLabel: 'Fecha fin trabajo',
                        allowBlank: false,
                        anchor: '60%',
                        gwidth: 100,
                        format: 'd/m/Y',
                        editable:false,
                        //disabledDays: [1, 2, 3, 4, 5],
                        renderer: function (value, p, record) {
                            return value ? value.dateFormat('d/m/Y') : ''
                        }
                    },
                    type: 'DateField',
                    filters: {pfiltro: 'cpm.hasta', type: 'date'},
                    id_grupo: 1,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'dias',
                        fieldLabel: 'Dias efectivos trabajo',
                        allowBlank: true,
                        anchor: '40%',
                        gwidth: 100,
                        style: 'background-image: none;',
                        disabled: true,
                    },
                    type: 'NumberField',
                    filters: {pfiltro: 'cpm.dias', type: 'numeric'},
                    id_grupo: 1,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'desde_comp',
                        fieldLabel: 'Fecha inicio compensacaion',
                        allowBlank: true,
                        anchor: '60%',
                        gwidth: 100,
                        format: 'd/m/Y',
                        renderer: function (value, p, record) {
                            return value ? value.dateFormat('d/m/Y') : ''
                        }
                    },
                    type: 'DateField',
                    filters: {pfiltro: 'cpm.desde_comp', type: 'date'},
                    id_grupo: 1,
                    grid: false,
                    form: false
                },
                {
                    config: {
                        name: 'hasta_comp',
                        fieldLabel: 'Fecha fin compensacaion',
                        allowBlank: true,
                        anchor: '60%',
                        gwidth: 100,
                        format: 'd/m/Y',
                        renderer: function (value, p, record) {
                            return value ? value.dateFormat('d/m/Y') : ''
                        }
                    },
                    type: 'DateField',
                    filters: {pfiltro: 'cpm.hasta_comp', type: 'date'},
                    id_grupo: 1,
                    grid: false,
                    form: false
                },
                {
                    config: {
                        name: 'dias_comp',
                        fieldLabel: 'Dias efectivos compensacion',
                        allowBlank: true,
                        anchor: '40%',
                        gwidth: 100,
                        style: 'background-image: none;',
                        disabled: true,
                    },
                    type: 'NumberField',
                    filters: {pfiltro: 'cpm.dias_comp', type: 'numeric'},
                    id_grupo: 1,
                    grid: false,
                    form: false
                },
                {
                    config: {
                        name: 'justificacion',
                        fieldLabel: 'Justificacion',
                        allowBlank: false,
                        gwidth: 100,
                        anchor: '70%',
                    },
                    type: 'TextArea',
                    filters: {pfiltro: 'cpm.justificacion', type: 'string'},
                    id_grupo: 1,
                    grid: true,
                    form: true
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
                    filters: {pfiltro: 'cpm.estado_reg', type: 'string'},
                    id_grupo: 1,
                    grid: true,
                    form: false
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
                    filters: {pfiltro: 'cpm.fecha_reg', type: 'date'},
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
                    filters: {pfiltro: 'cpm.id_usuario_ai', type: 'numeric'},
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
                    filters: {pfiltro: 'cpm.usuario_ai', type: 'string'},
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
                    filters: {pfiltro: 'cpm.fecha_mod', type: 'date'},
                    id_grupo: 1,
                    grid: true,
                    form: false
                }
            ],
            tam_pag: 50,
            title: 'Compensacion',
            ActSave: '../../sis_asistencia/control/Compensacion/insertarCompensacion',
            ActDel: '../../sis_asistencia/control/Compensacion/eliminarCompensacion',
            ActList: '../../sis_asistencia/control/Compensacion/listarCompensacion',
            id_store: 'id_compensacion',
            fields: [
                {name: 'id_compensacion', type: 'numeric'},
                {name: 'estado_reg', type: 'string'},
                {name: 'id_funcionario', type: 'numeric'},
                {name: 'id_responsable', type: 'numeric'},
                {name: 'desde', type: 'date', dateFormat: 'Y-m-d'},
                {name: 'hasta', type: 'date', dateFormat: 'Y-m-d'},
                {name: 'dias', type: 'numeric'},
                {name: 'desde_comp', type: 'date', dateFormat: 'Y-m-d'},
                {name: 'hasta_comp', type: 'date', dateFormat: 'Y-m-d'},
                {name: 'dias_comp', type: 'numeric'},
                {name: 'justificacion', type: 'string'},
                {name: 'id_usuario_reg', type: 'numeric'},
                {name: 'fecha_reg', type: 'date', dateFormat: 'Y-m-d H:i:s.u'},
                {name: 'id_usuario_ai', type: 'numeric'},
                {name: 'usuario_ai', type: 'string'},
                {name: 'id_usuario_mod', type: 'numeric'},
                {name: 'fecha_mod', type: 'date', dateFormat: 'Y-m-d H:i:s.u'},
                {name: 'usr_reg', type: 'string'},
                {name: 'usr_mod', type: 'string'},
                {name: 'id_procesos_wf', type: 'numeric'},
                {name: 'id_estado_wf', type: 'numeric'},
                {name: 'estado', type: 'string'},
                {name: 'nro_tramite', type: 'string'},
                {name: 'funcionario', type: 'string'},
                {name: 'responsable', type: 'string'},
                {name: 'social_forestal', type: 'boolean'},
            ],
            sortInfo: {
                field: 'id_compensacion',
                direction: 'DESC'
            },
            bdel: true,
            bsave: true,


        }
    )
</script>
        
        