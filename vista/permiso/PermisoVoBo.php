<?php
/**
 *@package pXP
 *@file PermisoVoBo.php
 *@author  MAM
 *@date 27-12-2016 14:45
 *@Interface para el inicio de solicitudes de materiales
 */
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
    Phx.vista.PermisoVoBo = {
        require:'../../../sis_asistencia/vista/permiso/Permiso.php', // direcion de la clase que va herrerar
        requireclase:'Phx.vista.Permiso', // nombre de la calse
        title:'Solicitud Permiso', // nombre de interaz
        nombreVista: 'PermisoVoBo',
        bnew:false,
        bedit:false,
        bdel:false,
        tam_pag:50,
        //funcion para mandar el name de tab
        constructor: function(config) {
            this.Atributos[this.getIndAtributo('id_responsable')].grid=false;

            Phx.vista.PermisoVoBo.superclass.constructor.call(this, config);
            this.store.baseParams = {tipo_interfaz: this.nombreVista};
            this.store.baseParams.pes_estado = 'registro';

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
                    url: '../../sis_asistencia/control/Permiso/aprobarEstado',
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
    };
</script>
