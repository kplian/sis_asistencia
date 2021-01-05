<?php
/**
 *@package pXP
 *@file VacacionRrhh.php
 *@author  MAM
 *@date 27-12-2016 14:45
 *@Interface para el inicio de solicitudes de materiales
 */
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
    Phx.vista.VacacionRrhh = {
        require:'../../../sis_asistencia/vista/vacacion/Vacacion.php', // direcion de la clase que va herrerar
        requireclase:'Phx.vista.Vacacion', // nombre de la calse
        title:'VoBo Vacaciones', // nombre de interaz
        nombreVista: 'VacacionRrhh',
        bnew:false,
        bedit:true,
        bdel:false,
        bsave:false,
        tam_pag:50,
        sortInfo:{
            field: 'departamento',
            direction: 'ASC'
        },
        tipoStore: 'GroupingStore',//GroupingStore o JsonStore #
        remoteGroup: true,
        groupField: 'departamento',
        viewGrid: new Ext.grid.GroupingView({
            forceFit: false
        }),
        actualizarSegunTab: function(name, indice){
            if (this.finCons) {
                this.store.baseParams.pes_estado = name;
                this.load({params: {start: 0, limit: this.tam_pag}});
            }
        },
        // tab
        gruposBarraTareas:[
            {name:'vobo',title:'<h1 align="center"><i></i>VoBo</h1>',grupo:2,height:0},
            {name:'aprobado',title:'<h1 align="center"><i></i>Aprobado</h1>',grupo:5,height:0},
            {name:'rechazado',title:'<h1 align="center"><i></i>Rechazados</h1>',grupo:4,height:0},
            {name:'cancelado',title:'<h1 align="center"><i></i>Cancelados</h1>',grupo:4,height:0}
        ],
        bnewGroups:[0,3],
        bactGroups:[0,1,2,3,4,5],
        bdelGroups:[0],
        beditGroups:[2,5],
        bexcelGroups:[0,1,2,3,4,5],
        grupoDateFin: [2,4,5],

        constructor: function(config) {
            this.initButtons=[];
            Phx.vista.VacacionRrhh.superclass.constructor.call(this, config);
            this.store.baseParams.tipo_interfaz = this.nombreVista;
            this.store.baseParams.pes_estado = 'vobo';
            this.addButton('btn_siguiente',{grupo:[0,2,3],
                text:'Aprobar',
                iconCls: 'bok',
                disabled:true,
                handler:this.onSiguiente});

            this.addButton('btn_atras',{grupo:[2,3],
                argument: { estado: 'anterior'},
                text:'Rechazar',
                iconCls: 'bdel',
                disabled:true,
                handler:this.onAtras});

            this.addButton('btn_cancelar',{grupo:[5],
                text:'Cancelar',
                iconCls: 'bassign',
                disabled:true,
                handler:this.onCancelar,
                tooltip: '<b>Cancelar</b><p>el vacacion en caso que no tomara </p>'});

            this.addButton('btn_reenviar',{grupo:[2],
                text:'Reenviar correo',
                iconCls: 'bemail',
                disabled:true,
                handler:this.onReenviar,
                tooltip: '<b>Reenviar</b><p>al responsable asignado de la solicitud</p>'
            });

            this.campo_fecha = new Ext.form.DateField({
                name: 'fecha_reg',
                grupo: this.grupoDateFin,
                fieldLabel: 'Fecha',
                allowBlank: false,
                anchor: '70%',
                gwidth: 100,
                format: 'd/m/Y',
                hidden : false
            });

            this.campo_uo =  new Ext.form.ComboRec({
                name:'id_uo',
                hiddenName: 'id_uo',
                grupo: this.grupoDateFin,
                origen:'UO',
                fieldLabel:'UO',
                gdisplayField:'desc_uo',//mapea al store del grid
                gwidth:200,
                emptyText:'Dejar blanco para toda la empresa...',
                width : 230,
                baseParams: {nivel: '0,1,2'},
                allowBlank:true

            })

            this.getBoton('btn_cancelar').setVisible(false);
            this.tbar.addField(this.campo_fecha);
            this.tbar.addField(this.campo_uo);
            this.campo_fecha.setValue(new Date());
            this.store.baseParams.fecha = this.campo_fecha.getValue().dateFormat('Ymd');

            this.campo_fecha.on('select',function(value){
                this.store.baseParams.fecha = this.campo_fecha.getValue().dateFormat('Ymd');
                this.load();
            },this);

            this.campo_uo.on('select',function(value){
                this.store.baseParams.id_uo = this.campo_uo.getValue();
                this.load();
            },this);

            this.load({params: {start: 0, limit: this.tam_pag}});
        },
        onReloadPage:function(param){
            this.initFiltro(param);
        },
        initFiltro: function(param){
            this.store.baseParams.param = 'si';
           //  this.store.baseParams.desde = param.desde;
           //  this.store.baseParams.hasta = param.hasta;
           //  this.store.baseParams.id_uo = param.id_uo;
            this.load( { params: { start:0, limit: this.tam_pag } });
        },
        preparaMenu:function(n){
            Phx.vista.VacacionRrhh.superclass.preparaMenu.call(this, n);
            this.getBoton('btn_atras').enable();
            this.getBoton('diagrama_gantt').enable();
            this.getBoton('btn_siguiente').enable();
            this.getBoton('btn_cancelar').enable();
            this.getBoton('btn_reenviar').enable();
        },
        liberaMenu:function() {
            var tb = Phx.vista.VacacionRrhh.superclass.liberaMenu.call(this);
            if (tb) {
                this.getBoton('btn_atras').disable();
                this.getBoton('diagrama_gantt').disable();
                this.getBoton('btn_siguiente').disable();
                this.getBoton('btn_cancelar').disable();
                this.getBoton('btn_reenviar').disable();
            }
        },
        onSiguiente :function () {
            Phx.CP.loadingShow();
            const rec = this.sm.getSelected(); //obtine los datos selecionado en la grilla
            if(confirm('Aprobar solicitud?')) {
                Ext.Ajax.request({
                    url: '../../sis_asistencia/control/Vacacion/aprobarEstado',
                    params: {
                        id_proceso_wf:  rec.data.id_proceso_wf,
                        id_estado_wf:  rec.data.id_estado_wf,
                        evento : 'aprobado',
                        obs : ''

                    },
                    success: this.successWizard,
                    failure: this.conexionFailure,
                    timeout: this.timeout,
                    scope: this
                });
            }
            Phx.CP.loadingHide();
        },
        onCancelar :function () {
            Phx.CP.loadingShow();
            const rec = this.sm.getSelected(); //obtine los datos selecionado en la grilla
            if(confirm('¿Desea Cancelar?')) {
                Ext.Ajax.request({
                    url: '../../sis_asistencia/control/Vacacion/aprobarEstado',
                    params: {
                        id_proceso_wf:  rec.data.id_proceso_wf,
                        id_estado_wf:  rec.data.id_estado_wf,
                        evento : 'cancelado',
                        obs : ''
                    },
                    success: this.successWizard,
                    failure: this.conexionFailure,
                    timeout: this.timeout,
                    scope: this
                });
            }
            Phx.CP.loadingHide();
        },
        onReenviar:function () {
            Phx.CP.loadingShow();
            const rec = this.sm.getSelected(); //obtine los datos selecionado en la grilla
            if(confirm('¿Desea Reenviar el correo?')) {
                Ext.Ajax.request({
                    url: '../../sis_asistencia/control/Vacacion/reenviarCorreo',
                    params: {
                        id_vacacion:  rec.data.id_vacacion
                    },
                    success: this.successWizard,
                    failure: this.conexionFailure,
                    timeout: this.timeout,
                    scope: this
                });
            }
            Phx.CP.loadingHide();
        },
        east:{
            url:'../../../sis_asistencia/vista/vacacion_det/VacacionDet.php',
            title:'Detalle',
            // height:'50%',
            width:'35%',
            cls:'VacacionDet'
        }
    };
</script>

