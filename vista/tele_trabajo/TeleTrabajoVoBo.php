<?php
/**
 *@package pXP
 *@file TeleTrabajoVoBo.php
 *@author  MAM
 *@date 27-12-2016 14:45
 *@Interface para el inicio de solicitudes de materiales
 */
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
    Phx.vista.TeleTrabajoVoBo = {
        require:'../../../sis_asistencia/vista/tele_trabajo/TeleTrabajo.php', // direcion de la clase que va herrerar
        requireclase:'Phx.vista.TeleTrabajo', // nombre de la calse
        title:'VoBo Vacaciones', // nombre de interaz
        nombreVista: 'TeleTrabajoVoBo',
        bnew:false,
        bedit:false,
        bdel:false,
        bsave:false,
        constructor: function(config) {
            this.Atributos[this.getIndAtributo('id_responsable')].grid=false;
            Phx.vista.TeleTrabajoVoBo.superclass.constructor.call(this, config);
            this.store.baseParams = {tipo_interfaz: this.nombreVista};

            this.addButton('btn_siguiente',{grupo:[0,3],
                text:'Aprobar',
                iconCls: 'bok',
                disabled:true,
                handler:this.onSiguiente});

            this.addButton('btn_atras',{grupo:[3],
                argument: { estado: 'anterior'},
                text:'Rechazar',
                iconCls: 'bdel',
                disabled:true,
                handler:this.onAtras});

            this.load({params: {start: 0, limit: this.tam_pag}});
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
            }else{
                Phx.CP.loadingHide();
            }
        },
        preparaMenu:function(n){
            Phx.vista.TeleTrabajoVoBo.superclass.preparaMenu.call(this, n);
            this.getBoton('btn_siguiente').enable();
            this.getBoton('btn_atras').enable();
        },
        liberaMenu:function() {
            var tb = Phx.vista.TeleTrabajoVoBo.superclass.liberaMenu.call(this);
            if (tb) {
                this.getBoton('btn_siguiente').disable();
                this.getBoton('btn_atras').disable();
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
    };
</script>

