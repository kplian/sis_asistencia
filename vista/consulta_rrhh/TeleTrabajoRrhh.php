<?php
/**
 *@package pXP
 *@file TeleTrabajoRrhh.php
 *@author  MAM
 *@date 27-12-2016 14:45
 *@Interface para el inicio de solicitudes de materiales
 */
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
    Phx.vista.TeleTrabajoRrhh = {
        require:'../../../sis_asistencia/vista/tele_trabajo/TeleTrabajo.php', // direcion de la clase que va herrerar
        requireclase:'Phx.vista.TeleTrabajo', // nombre de la calse
        title:'Solicitud TeleTrabajo', // nombre de interaz
        nombreVista: 'TeleTrabajoRrhh',
        bnew:false,
        bedit:true,
        bdel:false,
        tam_pag:50,
        actualizarSegunTab: function(name, indice){
            if (this.finCons) {
                this.store.baseParams.pes_estado = name;
                this.load({params: {start: 0, limit: this.tam_pag}});
            }
        },
        gruposBarraTareas:[
            {name:'registro',title:'<h1 align="center"><i></i>Borrador</h1>',grupo:1,height:0},
            {name:'vobo',title:'<h1 align="center"><i></i>VoBo</h1>',grupo:2,height:0},
            {name:'aprobado',title:'<h1 align="center"><i></i>Aprobado</h1>',grupo:5,height:0},
            {name:'rechazado',title:'<h1 align="center"><i></i>Rechazados</h1>',grupo:4,height:0},
            {name:'cancelado',title:'<h1 align="center"><i></i>Cancelados</h1>',grupo:4,height:0}
        ],
        bnewGroups:[0,3],
        bactGroups:[0,1,2,3,4,5],
        bdelGroups:[0],
        beditGroups:[1,2,5],
        bexcelGroups:[0,1,2,3,4,5],
        grupoDateFin: [2,4,5],
        constructor: function(config) {
            Phx.vista.TeleTrabajoRrhh.superclass.constructor.call(this, config);
            this.store.baseParams.tipo_interfaz = this.nombreVista;
            this.store.baseParams.pes_estado = 'registro';

            this.addButton('btn_para_giles',{grupo:[1],
                text:'Enviar Solicitud',
                iconCls: 'bemail',
                disabled:true,
                handler:this.onGiles});

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
                iconCls: 'bdel',
                disabled:true,
                handler:this.onCancelar,
                tooltip: '<b>Cancelar</b><p>el vacacion en caso que no tomara </p>'});
            this.addBotonesGantt();
            this.getBoton('btn_cancelar').setVisible(false);
            this.getBoton('btn_siguiente').setVisible(false);
            this.getBoton('btn_atras').setVisible(false);

            this.load({params: {start: 0, limit: this.tam_pag}});
        },
        onReloadPage:function(param){
            this.initFiltro(param);
        },
        initFiltro: function(param){
            this.store.baseParams.param = 'si';
            this.store.baseParams.desde = param.desde;
            this.store.baseParams.hasta = param.hasta;
            this.store.baseParams.id_uo = param.id_uo;
            this.load( { params: { start:0, limit: this.tam_pag } });
        },
        preparaMenu:function(n){
            Phx.vista.TeleTrabajoRrhh.superclass.preparaMenu.call(this, n);
            this.getBoton('btn_atras').enable();
            this.getBoton('diagrama_gantt').enable();
            this.getBoton('btn_siguiente').enable();
            this.getBoton('btn_cancelar').enable();
        },
        liberaMenu:function() {
            const tb = Phx.vista.TeleTrabajoRrhh.superclass.liberaMenu.call(this);
            if (tb) {
                this.getBoton('btn_atras').disable();
                this.getBoton('diagrama_gantt').disable();
                this.getBoton('btn_siguiente').disable();
                this.getBoton('btn_cancelar').disable();
            }
        },
        onSiguiente :function () {
            Phx.CP.loadingShow();
            const rec = this.sm.getSelected(); //obtine los datos selecionado en la grilla
            if(confirm('Aprobar solicitud?')) {
                Ext.Ajax.request({
                    url: '../../sis_asistencia/control/TeleTrabajo/aprobarEstado',
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
            } else{
                Phx.CP.loadingHide();
            }
        },
        onAtras :function (res) {
            var rec=this.sm.getSelected();
            Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/AntFormEstadoWf.php',
                'Estado de Wf',
                {
                    modal:true,
                    width:450,
                    height:250
                }, { data:rec.data, estado_destino: res.argument.estado}, this.idContenedor,'AntFormEstadoWf',
                {
                    config:[{
                        event:'beforesave',
                        delegate: this.onAntEstado
                    }
                    ],
                    scope:this
                })
        },
        onAntEstado: function(wizard,resp){
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                url: '../../sis_asistencia/control/TeleTrabajo/aprobarEstado',
                params: {
                    id_proceso_wf: resp.id_proceso_wf,
                    id_estado_wf:  resp.id_estado_wf,
                    evento : 'rechazado',
                    obs: resp.obs
                },
                argument:{wizard:wizard},
                success:this.successEstadoSinc,
                failure: this.conexionFailure,
                timeout:this.timeout,
                scope:this
            });
        },
        successEstadoSinc:function(resp){
            Phx.CP.loadingHide();
            resp.argument.wizard.panel.destroy();
            this.reload();
        },
        onCancelar :function () {
            Phx.CP.loadingShow();
            const rec = this.sm.getSelected(); //obtine los datos selecionado en la grilla
            if(confirm('¿Desea Cancelar?')) {
                Ext.Ajax.request({
                    url: '../../sis_asistencia/control/TeleTrabajo/aprobarEstado',
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
            }else{
                Phx.CP.loadingHide();
            }
        },
        onGiles :function () {
            Phx.CP.loadingShow();
            const rec = this.sm.getSelected(); //obtine los datos selecionado en la grilla
            if(confirm('¿Enviar solicitud a '+rec.data.responsable+'?')) {
                Ext.Ajax.request({
                    url: '../../sis_asistencia/control/TeleTrabajo/aprobarEstado',
                    params: {
                        id_proceso_wf:  rec.data.id_proceso_wf,
                        id_estado_wf:  rec.data.id_estado_wf,
                        evento : 'siguiente',
                        obs : ''
                    },
                    success: this.successWizard,
                    failure: this.conexionFailure,
                    timeout: this.timeout,
                    scope: this
                });
            }else{
                Phx.CP.loadingHide();
            }

        },
    }
</script>

