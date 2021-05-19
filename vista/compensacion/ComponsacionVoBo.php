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
    Phx.vista.ComponsacionVoBo = {
        require: '../../../sis_asistencia/vista/compensacion/Compensacion.php', // direcion de la clase que va herrerar
        requireclase: 'Phx.vista.Compensacion', // nombre de la calse
        title: 'Compensacion', // nombre de interaz
        nombreVista: 'ComponsacionVoBo',
        bsave: false,
        bnew: false,
        bedit: false,
        bdel: false,
        fwidth: '35%',
        fheight: '70%',
        constructor: function (config) {
            this.Atributos[this.getIndAtributo('id_responsable')].grid = false;
            Phx.vista.ComponsacionVoBo.superclass.constructor.call(this, config);
            this.addButton('btn_siguiente', {
                grupo: [0, 3],
                text: 'Aprobar',
                iconCls: 'bok',
                disabled: true,
                handler: this.onSiguiente
            });

            this.addButton('btn_atras', {
                grupo: [3],
                argument: {estado: 'anterior'},
                text: 'Rechazar',
                iconCls: 'bdel',
                disabled: true,
                handler: this.onAtras
            });
            this.store.baseParams = {tipo_interfaz: this.nombreVista};
            this.load({params: {start: 0, limit: this.tam_pag}});
        },
        preparaMenu: function (n) {
            Phx.vista.ComponsacionVoBo.superclass.preparaMenu.call(this, n);
            this.getBoton('btn_atras').enable();
            this.getBoton('btn_siguiente').enable();
        },
        liberaMenu: function () {
            var tb = Phx.vista.ComponsacionVoBo.superclass.liberaMenu.call(this);
            if (tb) {
                this.getBoton('btn_atras').disable();
                this.getBoton('btn_siguiente').disable();
            }
        },
        onSiguiente :function () {
            Phx.CP.loadingShow();
            const rec = this.sm.getSelected(); //obtine los datos selecionado en la grilla
            if(confirm('Aprobar solicitud?')) {
                Ext.Ajax.request({
                    url: '../../sis_asistencia/control/Compensacion/cambiarEstado',
                    params: {
                        id_proceso_wf:  rec.data.id_procesos_wf,
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
                url: '../../sis_asistencia/control/Compensacion/cambiarEstado',
                params: {
                    id_proceso_wf: resp.id_procesos_wf,
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
        successWizard: function (resp) {
            Phx.CP.loadingHide();
            this.load({params: {start: 0, limit: this.tam_pag}});
        },
        successEstadoSinc:function(resp){
            Phx.CP.loadingHide();
            resp.argument.wizard.panel.destroy();
            this.reload();
        },
        south: {
            url: '../../../sis_asistencia/vista/compensacion_det/CompensacionDetVobo.php',
            title: 'Detalle',
            height: '50%',
            cls: 'CompensacionDetVobo'
        }
    };
</script>

