<?php
/**
 *@package pXP
 *@file PermisoRRHH.php
 *@author  MAM
 *@date 27-12-2016 14:45
 *@Interface para el inicio de solicitudes de materiales
 */
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
    Phx.vista.PermisoRRHH = {
        require:'../../../sis_asistencia/vista/permiso/Permiso.php', // direcion de la clase que va herrerar
        requireclase:'Phx.vista.Permiso', // nombre de la calse
        title:'Solicitud Permiso', // nombre de interaz
        nombreVista: 'PermisoRRHH',
        bnew:false,
        bedit:false,
        bdel:false,
        tam_pag:50,
        //funcion para mandar el name de tab
        constructor: function(config) {
            this.Atributos[this.getIndAtributo('id_funcionario')].bottom_filter=true;
            Phx.vista.PermisoRRHH.superclass.constructor.call(this, config);
            this.store.baseParams = {tipo_interfaz: this.nombreVista};
            this.getBoton('btn_atras').setVisible(false);
            this.getBoton('btn_siguiente').setVisible(false);
            this.addButton('btnChequeoDocumentosWf',{
                text: 'Documentos',
                iconCls: 'bchecklist',
                disabled: true,
                handler: this.loadCheckDocumentosRecWf,
                tooltip: '<b>Documentos </b><br/>Subir los documetos requeridos.'
            });
            this.load({params: {start: 0, limit: this.tam_pag}});
        },
        loadCheckDocumentosRecWf:function() {
            var rec=this.sm.getSelected();
            rec.data.nombreVista = this.nombreVista;
            Phx.CP.loadWindows('../../../sis_workflow/vista/documento_wf/DocumentoWf.php',
                'Chequear documento del WF',
                {
                    width:'90%',
                    height:500
                },
                rec.data,
                this.idContenedor,
                'DocumentoWf'
            )
        },
        preparaMenu:function(n){
            Phx.vista.Permiso.superclass.preparaMenu.call(this, n);
            this.getBoton('diagrama_gantt').enable();
            var rec = this.getSelectedData();
            if (rec.documento === 'si'){
                this.getBoton('btnChequeoDocumentosWf').enable();
            }
        },
        liberaMenu:function() {
            var tb = Phx.vista.Permiso.superclass.liberaMenu.call(this);
            if (tb) {
                this.getBoton('diagrama_gantt').disable();
                this.getBoton('btnChequeoDocumentosWf').disable();
            }
        }
    };
</script>

