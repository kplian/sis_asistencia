<?php
/**
 *@package pXP
 *@file RegistroSolicitud.php
 *@author  MAM
 *@date 27-12-2016 14:45
 *@Interface para el inicio de solicitudes de materiales
 *  * HISTORIAL DE MODIFICACIONES:
 * #ISSUE				FECHA				AUTOR				DESCRIPCION
 * #18	ERT			26/09/2019 				 MMV			Modificar centros de costo

 */
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
    Phx.vista.MesTrabajoDetCc = {
        bedit:false,
        bnew:false,
        bsave:false,
        bdel:false,
        require:'../../../sis_asistencia/vista/mes_trabajo_det/MesTrabajoDet.php',
        requireclase:'Phx.vista.MesTrabajoDet',
        title:'Detalle VoBo',
        nombreVista: 'MesTrabajoDetCc',
        constructor: function(config) {
            this.Atributos[this.getIndAtributo('id_centro_costo')].disabled = true;
            this.Atributos[this.getIndAtributo('justificacion_extra')].form = false;
            this.Atributos[this.getIndAtributo('extra_autorizada')].form = false;
            Phx.vista.MesTrabajoDetCc.superclass.constructor.call(this,config);
            this.store.baseParams = {tipo_interfaz: this.nombreVista};
            this.getBoton('btnTransaccionesUpload').setVisible(true);
            this.getBoton('btmBorrarTodo').setVisible(false);

        },
        SubirArchivo : function(rec) {
           Phx.CP.loadWindows('../../../sis_asistencia/vista/mes_trabajo_det/SubirArchivoCc.php',
                'Subir Transacciones desde Excel',
                {
                    modal:true,
                    width:450,
                    height:150
                },this.maestro,this.idContenedor,'SubirArchivoCc');
        },
        preparaMenu:function(n){
            var tb =this.tbar;
            Phx.vista.MesTrabajoDet.superclass.preparaMenu.call(this,n);
            return tb;
        },
        liberaMenu: function() {
            var tb = Phx.vista.MesTrabajoDet.superclass.liberaMenu.call(this);
            if(tb){
                console.log(tb);
            }
            return tb;
        }

    };
</script>

