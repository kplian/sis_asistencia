<?php
/**
 * @package pXP
 * @file gen-TipoPermiso.php
 * @author  (miguel.mamani)
 * @date 16-10-2019 13:14:01
 * @description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 * HISTORIAL DE MODIFICACIONES:
 * #ISSUE                FECHA                AUTOR                DESCRIPCION
 * #0                16-10-2019                 (miguel.mamani)                CREACION
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.TipoPermiso = Ext.extend(Phx.gridInterfaz, {

            constructor: function (config) {
                this.maestro = config.maestro;
                //llama al constructor de la clase padre
                Phx.vista.TipoPermiso.superclass.constructor.call(this, config);
                this.init();
                this.load({params: {start: 0, limit: this.tam_pag}})
            },

            Atributos: [
                {
                    //configuracion del componente
                    config: {
                        labelSeparator: '',
                        inputType: 'hidden',
                        name: 'id_tipo_permiso'
                    },
                    type: 'Field',
                    form: true
                },
                {
                    config: {
                        name: 'codigo',
                        fieldLabel: 'Codigo',
                        allowBlank: false,
                        width: 250,
                        gwidth: 100
                    },
                    type: 'TextField',
                    filters: {pfiltro: 'tpo.codigo', type: 'string'},
                    id_grupo: 1,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'nombre',
                        fieldLabel: 'Nombre',
                        allowBlank: false,
                        width: 250,
                        gwidth: 250
                    },
                    type: 'TextField',
                    filters: {pfiltro: 'tpo.nombre', type: 'string'},
                    id_grupo: 1,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'tiempo',
                        fieldLabel: 'Tiempo',
                        increment: 1,
                        width: 150,
                        format: 'H:i:s',
                        renderer: function (value, p, record) {
                            return value ? value.dateFormat('H:i:s') : ''
                        }
                    },
                    type: 'TimeField',
                    filters: {pfiltro: 'tpo.tiempo', type: 'string'},
                    valorInicial: '00:00:00',
                    id_grupo: 0,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'documento',
                        fieldLabel: 'Exigir Documento',
                        allowBlank: false,
                        width: 80,
                        gwidth: 100,
                        typeAhead: true,
                        triggerAction: 'all',
                        lazyRender: true,
                        mode: 'local',
                        store: ['si', 'no']
                    },
                    type: 'ComboBox',
                    id_grupo: 1,
                    filters: {pfiltro: 'tpo.documento', type: 'string'},
                    valorInicial: 'no',
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'reposcion',
                        fieldLabel: 'Exigir Reposcion',
                        allowBlank: false,
                        width: 80,
                        gwidth: 100,
                        typeAhead: true,
                        triggerAction: 'all',
                        lazyRender: true,
                        mode: 'local',
                        store: ['si', 'no']
                    },
                    type: 'ComboBox',
                    id_grupo: 1,
                    filters: {pfiltro: 'tpo.reposcion', type: 'string'},
                    valorInicial: 'no',
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'rango',
                        fieldLabel: 'Controlar rango asignado funcionario',
                        allowBlank: false,
                        width: 80,
                        gwidth: 150,
                        typeAhead: true,
                        triggerAction: 'all',
                        lazyRender: true,
                        mode: 'local',
                        store: ['si', 'no']
                    },
                    type: 'ComboBox',
                    id_grupo: 1,
                    filters: {pfiltro: 'tpo.rango', type: 'string'},
                    valorInicial: 'no',
                    grid: false,
                    form: false
                },
                {
                    config: {
                        name: 'detalle',
                        fieldLabel: 'Detalle',
                        allowBlank: false,
                        width: 80,
                        gwidth: 150,
                        typeAhead: true,
                        triggerAction: 'all',
                        lazyRender: true,
                        mode: 'local',
                        store: ['si', 'no']
                    },
                    type: 'ComboBox',
                    id_grupo: 1,
                    filters: {pfiltro: 'tpo.rango', type: 'string'},
                    valorInicial: 'no',
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
                    filters: {pfiltro: 'tpo.estado_reg', type: 'string'},
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
                    filters: {pfiltro: 'tpo.fecha_reg', type: 'date'},
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
                    filters: {pfiltro: 'tpo.id_usuario_ai', type: 'numeric'},
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
                    filters: {pfiltro: 'tpo.usuario_ai', type: 'string'},
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
                    filters: {pfiltro: 'tpo.fecha_mod', type: 'date'},
                    id_grupo: 1,
                    grid: true,
                    form: false
                }
            ],
            tam_pag: 50,
            title: 'Tipo Permiso',
            ActSave: '../../sis_asistencia/control/TipoPermiso/insertarTipoPermiso',
            ActDel: '../../sis_asistencia/control/TipoPermiso/eliminarTipoPermiso',
            ActList: '../../sis_asistencia/control/TipoPermiso/listarTipoPermiso',
            id_store: 'id_tipo_permiso',
            fields: [
                {name: 'id_tipo_permiso', type: 'numeric'},
                {name: 'estado_reg', type: 'string'},
                {name: 'codigo', type: 'string'},
                {name: 'nombre', type: 'string'},
                {name: 'tiempo', type: 'date', dateFormat: 'H:i:s'},
                {name: 'id_usuario_reg', type: 'numeric'},
                {name: 'fecha_reg', type: 'date', dateFormat: 'Y-m-d H:i:s.u'},
                {name: 'id_usuario_ai', type: 'numeric'},
                {name: 'usuario_ai', type: 'string'},
                {name: 'id_usuario_mod', type: 'numeric'},
                {name: 'fecha_mod', type: 'date', dateFormat: 'Y-m-d H:i:s.u'},
                {name: 'usr_reg', type: 'string'},
                {name: 'usr_mod', type: 'string'},
                {name: 'documento', type: 'string'},
                {name: 'reposcion', type: 'string'},
                {name: 'rango', type: 'string'},
                {name: 'detalle', type: 'string'}

            ],
            sortInfo: {
                field: 'id_tipo_permiso',
                direction: 'ASC'
            },
            bdel: true,
            bsave: false,
            fwidth: '40%',
            fheight: '45%',
            south: {
                url: '../../../sis_asistencia/vista/detalle_tipo_permiso/DetalleTipoPermiso.php',
                title: 'Detalle',
                height: '50%',
                cls: 'DetalleTipoPermiso'
            },
        }
    )
</script>
