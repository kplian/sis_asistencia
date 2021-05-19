<?php
/**
 * @package pXP
 * @file ComponsacionSol.php
 * @author  MAM
 * @date 27-12-2016 14:45
 * @Interface para el inicio de solicitudes de materiales
 */
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
    Phx.vista.ComponsacionSol = {
        require: '../../../sis_asistencia/vista/compensacion/Compensacion.php', // direcion de la clase que va herrerar
        requireclase: 'Phx.vista.Compensacion', // nombre de la calse
        title: 'Compensacion', // nombre de interaz
        nombreVista: 'ComponsacionSol',
        bsave: false,
        fwidth: '35%',
        fheight: '70%',
        tam_pag: 50,
        //funcion para mandar el name de tab
        actualizarSegunTab: function (name, indice) {
            if (this.finCons) {
                this.store.baseParams.pes_estado = name;
                this.load({params: {start: 0, limit: this.tam_pag}});
            }
        },
        // tab
        gruposBarraTareas: [
            {name: 'registro', title: '<h1 align="center"><i></i>Solicitud</h1>', grupo: 0, height: 0},
            {name: 'vobo', title: '<h1 align="center"><i></i>VoBo</h1>', grupo: 1, height: 0},
            {name: 'aprobado', title: '<h1 align="center"><i></i>Aprobado</h1>', grupo: 1, height: 0},
            {name: 'cancelado', title: '<h1 align="center"><i></i>Cancelado</h1>', grupo: 1, height: 0}

        ],
        bnewGroups: [0],
        bactGroups: [0, 1, 2],
        bdelGroups: [0],
        beditGroups: [0],
        bexcelGroups: [0, 1, 2],
        constructor: function (config) {
            Phx.vista.ComponsacionSol.superclass.constructor.call(this, config);
            this.addButton('btn_siguiente', {
                grupo: [0, 3],
                text: 'Enviar Solicitud',
                iconCls: 'bemail',
                disabled: true,
                handler: this.onSiguiente
            });
            this.iniciarEventos();
           // this.iniciarEventosCom();
            this.addBotonesGantt();
            this.store.baseParams = {tipo_interfaz: this.nombreVista};
            this.store.baseParams.pes_estado = 'registro';
            this.load({params: {start: 0, limit: this.tam_pag}});
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
            var data = this.sm.getSelected().data.id_procesos_wf;
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
            const data = this.sm.getSelected().data.id_procesos_wf;
            window.open('../../../sis_workflow/reportes/gantt/gantt_dinamico.html?id_proceso_wf=' + data)
        },
        east: {
            url: '../../../sis_asistencia/vista/compensacion_det/CompensacionDet.php',
            title: 'Detalle',
            width: '40%',
            cls: 'CompensacionDet'
        },
        onButtonNew: function () {
            Phx.vista.ComponsacionSol.superclass.onButtonNew.call(this);//habilita el boton y se abre
            const less = this;
            this.Cmp.id_funcionario.store.load({
                params: {start: 0, limit: this.tam_pag, es_combo_solicitud: 'si'},
                callback: function (r) {
                    if (r.length > 0) {
                        this.Cmp.id_funcionario.setValue(r[0].data.id_funcionario);
                        this.Cmp.id_funcionario.fireEvent('select', less.Cmp.id_funcionario, r[0]);
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
            // this.onPermisoRol();
        },
        onButtonEdit: function () {
            Phx.vista.ComponsacionSol.superclass.onButtonEdit.call(this);
            this.onCargarResponsable(this.Cmp.id_funcionario.getValue(), false);
            this.Cmp.id_funcionario.on('select', function (combo, record, index) {
                this.Cmp.id_responsable.reset();
                this.Cmp.id_responsable.store.baseParams = Ext.apply(this.Cmp.id_responsable.store.baseParams,
                    {id_funcionario: record.data.id_funcionario});
                this.onCargarResponsable(record.data.id_funcionario, true);
                this.Cmp.id_responsable.modificado = true;
            }, this);
            // this.onPermisoRol();
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
        iniciarEventos: function () {
            this.Cmp.desde.on('select', function (Fecha, dato) {
                Ext.Ajax.request({
                    url: '../../sis_asistencia/control/Compensacion/getDias', //llamando a la funcion getDias.
                    params: {
                        'fecha_fin': this.Cmp.hasta.getValue(),
                        'fecha_inicio': Fecha.getValue(),
                        'id_funcionario': this.Cmp.id_funcionario.getValue(),
                        'fin_semana': 'no'

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
                        'fin_semana': 'no'
                    },
                    success: this.respuestaValidacion,
                    failure: this.conexionFailure,
                    timeout: this.timeout,
                    scope: this
                });
            }, this);

            this.Cmp.desde.on('change', function (Fecha, dato) {
                Ext.Ajax.request({
                    url: '../../sis_asistencia/control/Compensacion/getDias', //llamando a la funcion getDias.
                    params: {
                        'fecha_fin': this.Cmp.hasta.getValue(),
                        'fecha_inicio': Fecha.getValue(),
                        'id_funcionario': this.Cmp.id_funcionario.getValue(),
                        'fin_semana': 'no'
                    },
                    success: this.respuestaValidacion,
                    failure: this.conexionFailure,
                    timeout: this.timeout,
                    scope: this
                });
            }, this);

            this.Cmp.hasta.on('change', function (Fecha, dato) {
                Ext.Ajax.request({
                    url: '../../sis_asistencia/control/Compensacion/getDias', //llamando a la funcion getDias.
                    params: {
                        'fecha_fin': Fecha.getValue(),
                        'fecha_inicio': this.Cmp.desde.getValue(),
                        'id_funcionario': this.Cmp.id_funcionario.getValue(),
                        'fin_semana': 'no'
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
        iniciarEventosCom: function () {
            this.Cmp.desde_comp.on('select', function (Fecha, dato) {
                Ext.Ajax.request({
                    url: '../../sis_asistencia/control/Compensacion/getDias', //llamando a la funcion getDias.
                    params: {
                        'fecha_fin': this.Cmp.hasta_comp.getValue(),
                        'fecha_inicio': Fecha.getValue(),
                        'id_funcionario': this.Cmp.id_funcionario.getValue(),
                        'fin_semana': 'si'

                    },
                    success: this.respuestaValidacionCom,
                    failure: this.conexionFailure,
                    timeout: this.timeout,
                    scope: this
                });
            }, this);
            this.Cmp.hasta_comp.on('select', function (Fecha, dato) {
                Ext.Ajax.request({
                    url: '../../sis_asistencia/control/Compensacion/getDias', //llamando a la funcion getDias.
                    params: {
                        'fecha_fin': Fecha.getValue(),
                        'fecha_inicio': this.Cmp.desde_comp.getValue(),
                        'id_funcionario': this.Cmp.id_funcionario.getValue(),
                        'fin_semana': 'si'
                    },
                    success: this.respuestaValidacionCom,
                    failure: this.conexionFailure,
                    timeout: this.timeout,
                    scope: this
                });
            }, this);

            this.Cmp.desde_comp.on('change', function (Fecha, dato) {
                Ext.Ajax.request({
                    url: '../../sis_asistencia/control/Compensacion/getDias', //llamando a la funcion getDias.
                    params: {
                        'fecha_fin': this.Cmp.hasta_comp.getValue(),
                        'fecha_inicio': Fecha.getValue(),
                        'id_funcionario': this.Cmp.id_funcionario.getValue(),
                        'fin_semana': 'si'
                    },
                    success: this.respuestaValidacionCom,
                    failure: this.conexionFailure,
                    timeout: this.timeout,
                    scope: this
                });
            }, this);

            this.Cmp.hasta_comp.on('change', function (Fecha, dato) {
                Ext.Ajax.request({
                    url: '../../sis_asistencia/control/Compensacion/getDias', //llamando a la funcion getDias.
                    params: {
                        'fecha_fin': Fecha.getValue(),
                        'fecha_inicio': this.Cmp.desde_comp.getValue(),
                        'id_funcionario': this.Cmp.id_funcionario.getValue(),
                        'fin_semana': 'si'
                    },
                    success: this.respuestaValidacionCom,
                    failure: this.conexionFailure,
                    timeout: this.timeout,
                    scope: this
                });
            }, this);
        },
        arrayStoreComp: {
            'Selección': [
                ['', ''],
            ],
            'Selección2': [],
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
        respuestaValidacionCom: function (s, m) {
            this.maestro = m;
            const respuesta_valid = s.responseText.split('%');
            this.arrayStoreComp.Selección = [];
            this.arrayStoreComp.Selección = ['', ''];
            for (var i = 0; i <= parseInt(respuesta_valid[1]); i++) {
                this.arrayStoreComp.Selección[i] = ["ID" + (i), (i)];
            }
            this.Cmp.dias_comp.reset();
            this.Cmp.dias_comp.setValue(respuesta_valid[1]);
        },
        preparaMenu: function (n) {
            Phx.vista.ComponsacionSol.superclass.preparaMenu.call(this, n);
            this.getBoton('diagrama_gantt').enable();
            this.getBoton('btn_siguiente').enable();
        },
        liberaMenu: function () {
            var tb = Phx.vista.ComponsacionSol.superclass.liberaMenu.call(this);
            if (tb) {
                this.getBoton('diagrama_gantt').disable();
                this.getBoton('btn_siguiente').disable();
            }
        },
        onSiguiente: function () {
            Phx.CP.loadingShow();
            const rec = this.sm.getSelected(); //obtine los datos selecionado en la grilla
            console.log(rec.data);//5645645
            if (confirm('¿Enviar solicitud a ' + rec.data.responsable + '?')) {
                Ext.Ajax.request({
                    url: '../../sis_asistencia/control/Compensacion/cambiarEstado',
                    params: {
                        id_proceso_wf: rec.data.id_procesos_wf,
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
    };
</script>

