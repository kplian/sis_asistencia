<?php
/****************************************************************************************
 * @package pXP
 * @file CompensacionDet.php
 * @author  (amamani)
 * @date 18-05-2021 14:14:47
 * @description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 *
 * HISTORIAL DE MODIFICACIONES:
 * #ISSUE                FECHA                AUTOR                DESCRIPCION
 * #0                18-05-2021 14:14:47    amamani            Creacion
 * #
 *******************************************************************************************/

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.CompensacionDet = Ext.extend(Phx.gridInterfaz, {

            constructor: function (config) {
                this.maestro = config.maestro;
                //llama al constructor de la clase padre
                Phx.vista.CompensacionDet.superclass.constructor.call(this, config);
                this.init();
                this.grid.addListener('cellclick', this.oncellclick, this); /// revisar

            },

            Atributos: [
                {
                    //configuracion del componente
                    config: {
                        labelSeparator: '',
                        inputType: 'hidden',
                        name: 'id_compensacion_det'
                    },
                    type: 'Field',
                    form: true
                },
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
                    config: {
                        name: 'tiempo',
                        fieldLabel: 'Tiempo',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 60,
                        renderer: function (value, p, record) {
                            var result;
                            result = String.format('{0}', "<div style='text-align:center'><img src = '../../../sis_asistencia/media/completo.png' align='center' width='45' height='45' title=''/></div>");

                            if (value == 'mañana') {
                                result = String.format('{0}', "<div style='text-align:center'><img src = '../../../sis_asistencia/media/medio.png' align='center' width='45' height='45' title=''/></div>");
                            }
                            if (value == 'tarde') {
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
                        name: 'tiempo',
                        fieldLabel: 'Jornada',
                        allowBlank: false,
                        anchor: '80%',
                        gwidth: 110,
                        renderer: function (value, p, record) {
                            if (value == 'completo') {
                                return String.format('<p class="text-align:center"><b>Tiempo Completo</b></p>', value)
                            }
                            if (value == 'mañana') {
                                return String.format('<p class="text-align:center"><b>Mañana</b></p>', value)
                            }
                            if (value == 'tarde') {
                                return String.format('<p class="text-align:center"><b>Tarde</b></p>', value)
                            }
                        }
                    },
                    type: 'NumberField',
                    filters: {pfiltro: 'vde.tiempo', type: 'numeric'},
                    id_grupo: 1,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'fecha',
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
                    filters: {pfiltro: 'cmd.fecha', type: 'date'},
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
                    filters: {pfiltro: 'cmd.estado_reg', type: 'string'},
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
                    filters: {pfiltro: 'cmd.fecha_reg', type: 'date'},
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
                    filters: {pfiltro: 'cmd.id_usuario_ai', type: 'numeric'},
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
                    filters: {pfiltro: 'cmd.usuario_ai', type: 'string'},
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
                    filters: {pfiltro: 'cmd.fecha_mod', type: 'date'},
                    id_grupo: 1,
                    grid: true,
                    form: false
                }
            ],
            tam_pag: 50,
            title: 'Compensacion Detalle',
            ActSave: '../../sis_asistencia/control/CompensacionDet/insertarCompensacionDet',
            ActDel: '../../sis_asistencia/control/CompensacionDet/eliminarCompensacionDet',
            ActList: '../../sis_asistencia/control/CompensacionDet/listarCompensacionDet',
            id_store: 'id_compensacion_det',
            fields: [
                {name: 'id_compensacion_det', type: 'numeric'},
                {name: 'estado_reg', type: 'string'},
                {name: 'fecha', type: 'date', dateFormat: 'Y-m-d'},
                {name: 'id_compensacion', type: 'numeric'},
                {name: 'tiempo', type: 'string'},
                {name: 'id_usuario_reg', type: 'numeric'},
                {name: 'fecha_reg', type: 'date', dateFormat: 'Y-m-d H:i:s.u'},
                {name: 'id_usuario_ai', type: 'numeric'},
                {name: 'usuario_ai', type: 'string'},
                {name: 'id_usuario_mod', type: 'numeric'},
                {name: 'fecha_mod', type: 'date', dateFormat: 'Y-m-d H:i:s.u'},
                {name: 'usr_reg', type: 'string'},
                {name: 'usr_mod', type: 'string'},

            ],
            sortInfo: {
                field: 'id_compensacion_det',
                direction: 'ASC'
            },
            bdel: true,
            bsave: false,
            bnew: false,
            bedit: false,
            onReloadPage: function (m) {
                this.maestro = m;
                this.store.baseParams = {id_compensacion: this.maestro.id_compensacion};
                this.load({params: {start: 0, limit: 50}})
            },
            loadValoresIniciales: function () {
                Phx.vista.CompensacionDet.superclass.loadValoresIniciales.call(this);
                this.Cmp.id_compensacion.setValue(this.maestro.id_compensacion);
            },
            oncellclick: function (grid, rowIndex, columnIndex, e) {/// revisar
                const record = this.store.getAt(rowIndex),
                    fieldName = grid.getColumnModel().getDataIndex(columnIndex); // Get field name
                if (fieldName === 'tiempo') {
                    this.cambiarAsignacion(record, fieldName);

                }
            },
            cambiarAsignacion: function (record, name) {
                Phx.CP.loadingShow();
                const d = record.data;
                Ext.Ajax.request({
                    url: '../../sis_asistencia/control/CompensacionDet/cambiarTiempo',
                    params: {
                        id_compensacion_det: d.id_compensacion_det,
                        field_name: name
                    },
                    success: this.successRevision,
                    failure: this.conexionFailure,
                    timeout: this.timeout,
                    scope: this
                });
                this.reload();
            },
            successRevision: function (resp) {
                Phx.CP.loadingHide();
                var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
                Phx.CP.getPagina(this.idContenedorPadre).reload();
            }

        }
    )
</script>
        
        