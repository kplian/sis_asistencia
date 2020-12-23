<?php
/**
 *@package pXP
 *@file TransaccionBase.php
 *@author  (miguel.mamani)
 *@date 06-09-2019 13:08:03
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.TransaccionBase=Ext.extend(Phx.gridInterfaz, {
            constructor: function (config) {
                this.maestro = config.maestro;
                //llama al constructor de la clase padre
                Phx.vista.TransaccionBase.superclass.constructor.call(this, config);
                this.init();
            },

            Atributos: [
                {
                    //configuracion del componente
                    config: {
                        labelSeparator: '',
                        inputType: 'hidden',
                        name: 'id'
                    },
                    type: 'Field',
                    form: true
                },
                {
                    //configuracion del componente
                    config: {
                        labelSeparator: '',
                        inputType: 'hidden',
                        name: 'id_rango_horario'
                    },
                    type: 'Field',
                    form: true
                },
                {
                    //configuracion del componente
                    config: {
                        labelSeparator: '',
                        inputType: 'hidden',
                        name: 'periodo'
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
                        name: 'dia',
                        fieldLabel: 'Dia',
                        allowBlank: true,
                        anchor: '50%',
                        gwidth: 50
                    },
                    type: 'TextField',
                    id_grupo: 1,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'hora',
                        fieldLabel: 'Hora',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        renderer: function (value, p, record) {
                            var color;
                            if (record.data.id_rango_horario == null) {
                                color = '#b8271d';
                            } else {
                                color = '#000000';
                            }

                            return String.format('<b><font size = 1 color="' + color + '" >{0}</font></b>', value);
                        }
                    },
                    type: 'TextField',
                    filters: {pfiltro: 'bio.hora', type: 'string'},
                    id_grupo: 1,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'evento',
                        fieldLabel: 'Evento',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 210
                    },
                    type: 'TextField',
                    filters: {pfiltro: 'bio.evento', type: 'string'},
                    id_grupo: 1,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'verificacion',
                        fieldLabel: 'Tipo Verificacion',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength: 10
                    },
                    type: 'TextField',
                    filters: {pfiltro: 'bio.tipo_verificacion', type: 'string'},
                    id_grupo: 1,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'accion',
                        fieldLabel: 'Acceso',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        renderer: function (value, p, record) {
                            var color;
                            if (value === 'Salida') {
                                color = '#b8271d';
                            } else {
                                color = '#2e8e10';
                            }
                            return String.format('<b><font size = 1 color="' + color + '" >{0}</font></b>', value);
                        }
                    },
                    type: 'TextField',
                    filters: {pfiltro: 'bio.acceso', type: 'string'},
                    id_grupo: 1,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'nombre_area',
                        fieldLabel: 'Area',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 120
                    },
                    type: 'TextField',
                    filters: {pfiltro: 'bio.area', type: 'string'},
                    id_grupo: 1,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'descripcion',
                        fieldLabel: 'Rango Asignado',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 200
                    },
                    type: 'TextField',
                    id_grupo: 1,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'obs',
                        fieldLabel: 'Observación',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 200
                    },
                    type: 'TextField',
                    id_grupo: 1,
                    grid: true,
                    form: true
                }, {
                    config: {
                        name: 'reader_name',
                        fieldLabel: 'reader_name',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 200
                    },
                    type: 'TextField',
                    id_grupo: 1,
                    grid: true,
                    form: true
                },

                {
                    config: {
                        name: 'dispocitvo',
                        fieldLabel: 'Dispositivo',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 180
                    },
                    type: 'TextField',
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
                        gwidth: 200
                    },
                    type: 'TextField',
                    filters: {pfiltro: 'vfun.desc_funcionario', type: 'string'},
                    id_grupo: 1,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'fecha_registro',
                        fieldLabel: 'Fecha Marcado',
                        allowBlank: false,
                        anchor: '80%',
                        gwidth: 100
                    },
                    type: 'DateField',
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
                    filters: {pfiltro: 'bio.estado_reg', type: 'string'},
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
                        name: 'usuario_ai',
                        fieldLabel: 'Funcionaro AI',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength: 300
                    },
                    type: 'TextField',
                    filters: {pfiltro: 'bio.usuario_ai', type: 'string'},
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
                    filters: {pfiltro: 'bio.fecha_reg', type: 'date'},
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
                    filters: {pfiltro: 'bio.id_usuario_ai', type: 'numeric'},
                    id_grupo: 1,
                    grid: false,
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
                    filters: {pfiltro: 'bio.fecha_mod', type: 'date'},
                    id_grupo: 1,
                    grid: true,
                    form: false
                }
            ],
            tam_pag: 500,
            title: 'Transaccion',
            ActSave: '../../sis_asistencia/control/Transaccion/insertarTransaccion',
            ActDel: '../../sis_asistencia/control/Transaccion/eliminarTransaccion',
            ActList: '../../sis_asistencia/control/Transaccion/listarTransaccion',
            id_store: 'id',
            fields: [
                {name: 'id', type: 'numeric'},
                {name: 'id_funcionario', type: 'numeric'},
                {name: 'codigo_funcionario', type: 'string'},
                {name: 'nombre_area', type: 'string'},
                {name: 'verificacion', type: 'string'},
                {name: 'evento', type: 'string'},
                {name: 'pivot', type: 'numeric'},
                {name: 'rango', type: 'string'},
                {name: 'desc_funcionario1', type: 'string'},
                {name: 'periodo', type: 'numeric'},
                {name: 'fecha_registro', type: 'string'},
                {name: 'hora', type: 'string'},
                {name: 'dia', type: 'numeric'},
                {name: 'accion', type: 'string'},
                {name: 'dispocitvo', type: 'string'},
                {name: 'obs', type: 'string'},
                {name: 'descripcion', type: 'string'},
                {name: 'id_rango_horario', type: 'numeric'},
                {name: 'reader_name', type: 'string'}


            ],
            sortInfo: {
                field: 'dia',
                direction: 'ASC'
            },

            migrarMarcas: function () {
                if (this.validarFiltros()) {
                    Phx.CP.loadingShow();
                    var id;
                    if (Phx.CP.config_ini.id_funcionario !== '') {
                        id = Phx.CP.config_ini.id_funcionario;
                    } else {
                        id = null;
                    }

                    Ext.Ajax.request({
                        url: '../../sis_asistencia/control/Transaccion/migrarMarcadoFuncionario',
                        params: {
                            id_periodo: this.cmbPeriodo.getValue(),
                            id_funcionario: id
                        },
                        success: this.success,
                        failure: this.conexionFailure,
                        timeout: this.timeout,
                        scope: this
                    });
                    this.reload();
                } else {
                    alert('Seleccione la gestion y el periodo');
                }
            },
            success: function (resp) {
                Phx.CP.loadingHide();
                var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            },
            tipoStore: 'GroupingStore',//GroupingStore o JsonStore #
            remoteGroup: true,
            groupField: 'fecha_registro',
            viewGrid: new Ext.grid.GroupingView({
                forceFit: false
            }),
            //boton reporte de marcados
            onButtonReporte: function () {
                Phx.CP.loadingShow();
                Ext.Ajax.request({
                    url: '../../sis_asistencia/control/Transaccion/ReporteTusMarcados',
                    params: {
                        id_funcionario: Phx.CP.config_ini.id_funcionario, id_periodo: this.cmbPeriodo.getValue()
                    },
                    success: this.successExport,
                    failure: this.conexionFailure,
                    timeout: this.timeout,
                    scope: this
                });
            }
        }

    )
</script>