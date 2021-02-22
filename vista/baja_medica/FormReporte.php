<?php
/**
 * @package pXP
 * @file FormReporte.php
 * @author  (mmv)
 * @date 29-01-2021 09:42:00
 * @description Permite la creacion de programacion
 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.FormReporte = Ext.extend(Phx.frmInterfaz, {
        nombreVista: 'FormReporte',
        tam_pag: 50,
        title: 'Nuevo Programación',
        autoScroll: true,
        bsubmit: true,
        bcancel: true,
        breset: false,
        Atributos: [
            {
                config: {
                    name: 'fecha_inicio',
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
                    name: 'estado',
                    fieldLabel: 'Estado',
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
                            ['registro', 'Registro'],
                            ['enviado', 'Enviado']
                        ]
                    }),
                    valueField: 'variable',
                    displayField: 'valor',
                },
                type: 'ComboBox',
                valorInicial: 'enviado',
                grid: true,
                form: true
            },
        ],
        fields: [
            {name: 'fecha_inicio', type: 'date', dateFormat: 'Y-m-d H:i:s'},
            {name: 'fecha_fin', type: 'date', dateFormat: 'Y-m-d H:i:s'},
            {name: 'estado', type: 'string'}
        ],
        constructor: function (config) {
            this.maestro = config;
            Phx.vista.FormReporte.superclass.constructor.call(this, config);
            this.init();
        },
        onSubmit: function (o, x, force) {
            const me = this;
            if (me.form.getForm().isValid() || force === true) {
                Phx.CP.loadingShow();
                Ext.Ajax.request({
                    url:'../../sis_asistencia/control/BajaMedica/listarBajaMedicaReporte',
                    params:{ 'fecha_inicio': this.Cmp.fecha_inicio.getValue(),
                             'fecha_fin': this.Cmp.fecha_fin.getValue(),
                             'estado':this.Cmp.estado.getValue()
                    },
                    success: this.successExport,
                    failure: this.conexionFailure,
                    timeout: this.timeout,
                    scope:this
                });
            }
        },
        successSave: function (resp) {
            Phx.CP.loadingHide();
        },
    })
</script>

