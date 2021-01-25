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
    Phx.vista.ListaProgramacion = Ext.extend(Phx.gridInterfaz, {

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
                this.store.baseParams = {
                    fecha_programada: new Date()
                };
                this.load({params: {start: 0, limit: 50}});
            },
            Atributos: [
                {
                    //configuracion del componente
                    config: {
                        labelSeparator: '',
                        inputType: 'hidden',
                        name: 'id_programacion'
                    },
                    type: 'Field',
                    form: true
                },
                {
                    //configuracion del componente
                    config: {
                        labelSeparator: '',
                        inputType: 'hidden',
                        name: 'id_vacacion_det'
                    },
                    type: 'Field',
                    form: true
                },
                {
                    //configuracion del componente
                    config: {
                        labelSeparator: '',
                        inputType: 'hidden',
                        name: 'id_funcionario'
                    },
                    type: 'Field',
                    form: true
                },
                {
                    config: {
                        name: 'tiempo',
                        fieldLabel: 'Tiempo',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 60,
                        renderer: function (value, p, record) {
                            var result;
                            result = String.format('{0}', "<div style='text-align:center'><img src = '../../../sis_asistencia/media/completo.png' align='center' width='45' height='45' title=''/></div>");

                            if (value == 'M') {
                                result = String.format('{0}', "<div style='text-align:center'><img src = '../../../sis_asistencia/media/medio.png' align='center' width='45' height='45' title=''/></div>");
                            }
                            if (value == 'T') {
                                result = String.format('{0}', "<div style='text-align:center'><img src = '../../../sis_asistencia/media/tarde.png' align='center' width='39' height='39' title=''/></div>");
                            }

                            return result;
                        }
                    },
                    type: 'TextField',
                    id_grupo: 0,
                    grid: true,
                    form: false
                },
                {
                    config: {
                        name: 'fecha_programada',
                        fieldLabel: 'Fecha',
                        allowBlank: false,
                        anchor: '80%',
                        gwidth: 100,
                        format: 'd/m/Y',
                        renderer: function (value, p, record) {
                            return value ? value.dateFormat('d/m/Y') : ''
                        }
                    },
                    type: 'DateField',
                    filters: {pfiltro: 'prn.fecha_programada', type: 'date'},
                    id_grupo: 1,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'desc_funcionario1',
                        fieldLabel: 'Funcionario',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 300,
                        maxLength: 4
                    },
                    type: 'Field',
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
                        gwidth: 100,
                        maxLength: 50
                    },
                    type: 'TextField',
                    filters: {pfiltro: 'prn.estado', type: 'string'},
                    id_grupo: 1,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'tiempo',
                        fieldLabel: 'Tipo',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength: 50
                    },
                    type: 'TextField',
                    id_grupo: 1,
                    grid: true,
                    form: true
                },

                {
                    config: {
                        name: 'valor',
                        fieldLabel: 'Valor',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength: 10
                    },
                    type: 'NumberField',
                    filters: {pfiltro: 'prn.valor', type: 'numeric'},
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
                    filters: {pfiltro: 'prn.estado_reg', type: 'string'},
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
                    filters: {pfiltro: 'prn.fecha_reg', type: 'date'},
                    id_grupo: 1,
                    grid: true,
                    form: false
                }

            ],
            tam_pag: 31,
            title: 'Programacion',
            ActSave: '../../sis_asistencia/control/Programacion/insertarProgramacion',
            ActDel: '../../sis_asistencia/control/Programacion/eliminarProgramacion',
            ActList: '../../sis_asistencia/control/Programacion/listar',
            id_store: 'id_programacion',
            fields: [
                {name: 'id_programacion', type: 'numeric'},
                {name: 'estado_reg', type: 'string'},
                {name: 'fecha_programada', type: 'date', dateFormat: 'Y-m-d'},
                {name: 'id_funcionario', type: 'numeric'},
                {name: 'estado', type: 'string'},
                {name: 'tiempo', type: 'string'},
                {name: 'valor', type: 'numeric'},
                {name: 'id_vacacion_det', type: 'numeric'},
                {name: 'id_usuario_reg', type: 'numeric'},
                {name: 'fecha_reg', type: 'date', dateFormat: 'Y-m-d H:i:s.u'},
                {name: 'usr_reg', type: 'string'},
                {name: 'desc_funcionario1', type: 'string'}


            ],
            sortInfo: {
                field: 'id_programacion',
                direction: 'ASC'
            },
            bdel: true,
            bsave: false,
            bnew: false,
            bedit: false,
            capturaFiltros: function (combo, record, index) {
                if (this.validarFiltros()) {
                    this.store.baseParams.id_periodo = this.cmbPeriodo.getValue();
                    this.load({params: {start: 0, limit: 50}})
                }
            },
            validarFiltros: function () {
                return !!(this.cmbGestion.validate() && this.cmbPeriodo.validate());
            },
            onReloadPage: function (m) {
                this.maestro = m;
                this.store.baseParams = {
                    fecha_programada: this.maestro.programacion.fecha_programada
                };
                this.load({params: {start: 0, limit: 50}});
            },
        }
    )
</script>

