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
        bedit:false,
        bdel:false,
        bsave:false,
        constructor: function(config) {
            this.Atributos[this.getIndAtributo('id_responsable')].grid=false;
            Phx.vista.VacacionRrhh.superclass.constructor.call(this, config);
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
                    url: '../../sis_asistencia/control/Vacacion/aprobarEstado',
                    params: {
                        id_proceso_wf:  rec.data.id_proceso_wf,
                        id_estado_wf:  rec.data.id_estado_wf
                    },
                    success: this.successWizard,
                    failure: this.conexionFailure,
                    timeout: this.timeout,
                    scope: this
                });
            }
            Phx.CP.loadingHide();
        },
        south:{
            url:'../../../sis_asistencia/vista/vacacion_det/VacacionDetVoBo.php',
            title:'Detalle',
            height:'50%',
            cls:'VacacionDetVoBo'
        }
    };
</script>

