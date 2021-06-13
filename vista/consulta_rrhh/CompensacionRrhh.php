<?php
/**
 * @package pXP
 * @file CompensacionRrhh.php
 * @author  MAM
 * @date 27-12-2016 14:45
 * @Interface para el inicio de solicitudes de materiales
 */
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
    Phx.vista.CompensacionRrhh = {
        require: '../../../sis_asistencia/vista/compensacion/Compensacion.php', // direcion de la clase que va herrerar
        requireclase: 'Phx.vista.Compensacion', // nombre de la calse
        title: 'Compensacion RRHH', // nombre de interaz
        nombreVista: 'CompensacionRrhh',
        bnew: false,
        bedit: true,
        bdel: false,
        bsave: false,
        tam_pag: 50,
        bandera: 'fin_semana',
        actualizarSegunTab: function (name, indice) {
            if (this.finCons) {
                this.store.baseParams.pes_estado = name;
                this.load({params: {start: 0, limit: this.tam_pag}});
            }
        },
        gruposBarraTareas: [
            {name: 'registro', title: '<h1 align="center"><i></i>Borrador</h1>', grupo: 1, height: 0},
            {name: 'vobo', title: '<h1 align="center"><i></i>VoBo</h1>', grupo: 2, height: 0},
            {name: 'aprobado', title: '<h1 align="center"><i></i>Aprobado</h1>', grupo: 5, height: 0},
            {name: 'rechazado', title: '<h1 align="center"><i></i>Rechazados</h1>', grupo: 4, height: 0},
            {name: 'cancelado', title: '<h1 align="center"><i></i>Cancelados</h1>', grupo: 4, height: 0}
        ],
        bnewGroups: [0, 3],
        bactGroups: [0, 1, 2, 3, 4, 5],
        bdelGroups: [0],
        beditGroups: [1, 2, 5],
        bexcelGroups: [0, 1, 2, 3, 4, 5],
        grupoDateFin: [2, 4, 5],
        arrayStore: {
            'Selección': [
                ['', ''],
            ],
            'Selección2': [],
        },
        constructor: function (config) {
            Phx.vista.CompensacionRrhh.superclass.constructor.call(this, config);
            this.store.baseParams.tipo_interfaz = this.nombreVista;
            this.store.baseParams.pes_estado = 'registro';
            this.addButton('btn_para_giles', {
                grupo: [1],
                text: 'Enviar Solicitud',
                iconCls: 'bemail',
                disabled: true,
                handler: this.onGiles
            });
            this.addButton('btn_siguiente', {
                grupo: [0, 2, 3],
                text: 'Aprobar',
                iconCls: 'bok',
                disabled: true,
                handler: this.onSiguiente
            });

            this.addButton('btn_atras', {
                grupo: [2, 3],
                argument: {estado: 'anterior'},
                text: 'Rechazar',
                iconCls: 'bdel',
                disabled: true,
                handler: this.onAtras
            });

            this.addButton('btn_cancelar', {
                grupo: [5],
                text: 'Cancelar',
                iconCls: 'bassign',
                disabled: true,
                handler: this.onCancelar,
                tooltip: '<b>Cancelar</b><p>el vacacion en caso que no tomara </p>'
            });


            this.getBoton('btn_cancelar').setVisible(false);
            this.getBoton('btn_siguiente').setVisible(false);
            this.getBoton('btn_atras').setVisible(false);

            this.iniciarEventos();
            this.ocultarComponente(this.Cmp.social_forestal);
            Ext.Ajax.request({
                url: '../../sis_asistencia/control/Compensacion/getDiaDisable',
                params: {id_usuario: 0},
                success: function (resp) {
                    const reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
                    const data = JSON.stringify(reg.ROOT.datos.v_days_desible);
                    const one = data.replace('"{', '');
                    const two = one.replace('}"', '');
                    const arreglo = two.split(',');
                    const dayDisable = []
                    for (let value of arreglo) {
                        dayDisable.push(value)
                    }
                    this.Cmp.desde.setDisabledDates(dayDisable);
                    this.Cmp.hasta.setDisabledDates(dayDisable);
                },
                failure: this.conexionFailure,
                timeout: this.timeout,
                scope: this
            });
            this.load({params: {start: 0, limit: this.tam_pag}});
        },
        onReloadPage: function (param) {
            this.initFiltro(param);
        },
        initFiltro: function (param) {
            console.log(param)
            this.store.baseParams.param = 'si';
            this.store.baseParams.desde = param.desde;
            this.store.baseParams.hasta = param.hasta;
            this.store.baseParams.id_uo = param.id_uo;
            this.load({params: {start: 0, limit: this.tam_pag}});
        },
        preparaMenu: function (n) {
            Phx.vista.CompensacionRrhh.superclass.preparaMenu.call(this, n);
            this.getBoton('btn_atras').enable();
            this.getBoton('btn_siguiente').enable();
            this.getBoton('btn_cancelar').enable();
            this.getBoton('btn_para_giles').enable();
        },
        liberaMenu: function () {
            var tb = Phx.vista.CompensacionRrhh.superclass.liberaMenu.call(this);
            if (tb) {
                this.getBoton('btn_atras').disable();
                this.getBoton('btn_siguiente').disable();
                this.getBoton('btn_cancelar').disable();
                this.getBoton('btn_para_giles').disable();
            }
        },
        onSiguiente: function () {
            Phx.CP.loadingShow();
            const rec = this.sm.getSelected(); //obtine los datos selecionado en la grilla
            if (confirm('Aprobar solicitud?')) {
                Ext.Ajax.request({
                    url: '../../sis_asistencia/control/Compensacion/cambiarEstado',
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
            } else {
                Phx.CP.loadingHide();
            }
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
                url: '../../sis_asistencia/control/Compensacion/cambiarEstado',
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
        onCancelar: function () {
            Phx.CP.loadingShow();
            const rec = this.sm.getSelected(); //obtine los datos selecionado en la grilla
            if (confirm('¿Desea Cancelar?')) {
                Ext.Ajax.request({
                    url: '../../sis_asistencia/control/Compensacion/cambiarEstado',
                    params: {
                        id_proceso_wf: rec.data.id_proceso_wf,
                        id_estado_wf: rec.data.id_estado_wf,
                        evento: 'cancelado',
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
        onGiles: function () {
            Phx.CP.loadingShow();
            const rec = this.sm.getSelected(); //obtine los datos selecionado en la grilla
            if (confirm('¿Enviar solicitud a ' + rec.data.responsable + '?')) {
                Ext.Ajax.request({
                    url: '../../sis_asistencia/control/Compensacion/cambiarEstado',
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
            this.load({params: {start: 0, limit: this.tam_pag}});
        },
        onButtonEdit: function () {
            Phx.vista.CompensacionRrhh.superclass.onButtonEdit.call(this);
            this.Cmp.id_funcionario.on('select', function (combo, record, index) {
                if (record.data.departamento === 'GESTIÓN SOCIAL, FORESTAL, AMBIENTAL Y ARQ.') {
                    this.mostrarComponente(this.Cmp.social_forestal);
                } else {
                    this.ocultarComponente(this.Cmp.social_forestal);
                }
            }, this);
            this.onCargarResponsable(this.Cmp.id_funcionario.getValue(), false);
            this.Cmp.id_funcionario.on('select', function (combo, record, index) {
                this.Cmp.id_responsable.reset();
                this.Cmp.id_responsable.store.baseParams = Ext.apply(this.Cmp.id_responsable.store.baseParams,
                    {id_funcionario: record.data.id_funcionario});
                this.onCargarResponsable(record.data.id_funcionario, true);
                this.Cmp.id_responsable.modificado = true;
            }, this);
        },
        iniciarEventos: function () {
            this.Cmp.desde.on('select', function (Fecha, dato) {
                Ext.Ajax.request({
                    url: '../../sis_asistencia/control/Compensacion/getDias', //llamando a la funcion getDias.
                    params: {
                        'fecha_fin': this.Cmp.hasta.getValue(),
                        'fecha_inicio': Fecha.getValue(),
                        'id_funcionario': this.Cmp.id_funcionario.getValue(),
                        'fin_semana': this.bandera
                    },
                    success: this.respuestaValidacion,
                    failure: this.conexionFailure,
                    timeout: this.timeout,
                    scope: this
                });
            }, this);
            this.Cmp.hasta.on('select', function (Fecha, dato) {
                Ext.Ajax.request({
                    url: '../../sis_asistencia/control/Compensacion/getDias', //llamando a la funcion getDias.
                    params: {
                        'fecha_fin': Fecha.getValue(),
                        'fecha_inicio': this.Cmp.desde.getValue(),
                        'id_funcionario': this.Cmp.id_funcionario.getValue(),
                        'fin_semana': this.bandera
                    },
                    success: this.respuestaValidacion,
                    failure: this.conexionFailure,
                    timeout: this.timeout,
                    scope: this
                });
            }, this);
        },
        respuestaValidacion: function (s, m) {
            this.maestro = m;
            const respuesta_valid = s.responseText.split('%');
            this.arrayStore.Selección = [];
            this.arrayStore.Selección = ['', ''];
            for (var i = 0; i <= parseInt(respuesta_valid[1]); i++) {
                this.arrayStore.Selección[i] = ["ID" + (i), (i)];
            }
            this.Cmp.dias.reset();
            this.Cmp.dias.setValue(respuesta_valid[1]);
        },
        onCargarResponsable: function (id, filtro = true) {
            this.Cmp.id_responsable.store.baseParams = Ext.apply(this.Cmp.id_responsable.store.baseParams, {id_funcionario: id});
            this.Cmp.id_responsable.modificado = true;
            const less = this;
            if (filtro) {
                this.Cmp.id_responsable.store.load({
                    params: {start: 0, limit: this.tam_pag, id_funcionario: id},
                    callback: function (r) {
                        less.Cmp.id_responsable.setValue(r[0].data.id_funcionario);
                        less.Cmp.id_responsable.fireEvent('select', less.Cmp.id_responsable, r[0]);
                        less.Cmp.id_responsable.collapse();
                    }, scope: this
                });
            }
        },
        west: {
            url: '../../../sis_asistencia/vista/consulta_rrhh/FormFiltroCompensacion.php',
            width: '27%',
            title: 'Filtros',
            collapsed: false,
            cls: 'FormFiltroCompensacion'
        },
        east: {
            url: '../../../sis_asistencia/vista/compensacion_det/CompensacionDetTrabajo.php',
            title: 'Fecha Trabajo',
            width: '40%',
            cls: 'CompensacionDetTrabajo'
        }
    };
</script>

