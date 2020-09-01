<?php
/**
 *@package pXP
 *@file MesTrabajoDetReg.php
 *@author  MAM
 *@date 27-12-2016 14:45
 *@Interface para el inicio de solicitudes de materiales
 */
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
    Phx.vista.MesTrabajoDetReg = {
        bedit:true,
        bnew:false,
        bsave:false,
        bdel:false,
        require:'../../../sis_asistencia/vista/mes_trabajo_det/MesTrabajoDet.php',
        requireclase:'Phx.vista.MesTrabajoDet',
        title:'Detalle VoBo',
        nombreVista: 'MesTrabajoDetReg',
        constructor: function(config) {
            // this.Atributos[this.getIndAtributo('id_centro_costo')].disabled = true;
            // this.Atributos[this.getIndAtributo('justificacion_extra')].form = true;
            // this.Atributos[this.getIndAtributo('extra_autorizada')].form = true;
            Phx.vista.MesTrabajoDetReg.superclass.constructor.call(this,config);
            // this.store.baseParams = {tipo_interfaz: this.nombreVista};
            // this.getBoton('btnTransaccionesUpload').setVisible(false);
        },
        onReloadPage:function(m){
            this.maestro=m;
            this.store.baseParams = {id_mes_trabajo: this.maestro.id_mes_trabajo};
            Ext.apply(this.Cmp.id_centro_costo.store.baseParams,{id_gestion: this.maestro.id_gestion});
            this.load({params:{start:0, limit:50}})
        },
        loadValoresIniciales: function () {
            this.Cmp.id_mes_trabajo.setValue(this.maestro.id_mes_trabajo);
            Phx.vista.MesTrabajoDetReg.superclass.loadValoresIniciales.call(this);
        }
       /* preparaMenu:function(n){
            var tb =this.tbar;
            Phx.vista.MesTrabajoDet.superclass.preparaMenu.call(this,n);
            if( this.maestro.estado == 'asignado'){
                this.getBoton('edit').enable();
            }else{
                this.getBoton('edit').disable();
            }
            return tb;
        },
        liberaMenu: function() {
            var tb = Phx.vista.MesTrabajoDet.superclass.liberaMenu.call(this);
            if(tb){
                this.getBoton('edit').disable();
            }
            return tb;
        }*/

    };
</script>

