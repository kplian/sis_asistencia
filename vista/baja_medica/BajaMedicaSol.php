<?php
/**
 *@package pXP
 *@file BajaMedicaSol.php
 *@author  MAM
 *@date 27-12-2016 14:45
 *@Interface para el inicio de solicitudes de materiales
 */
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
    Phx.vista.BajaMedicaSol = {
        require:'../../../sis_asistencia/vista/baja_medica/BajaMedica.php', // nueo
        requireclase:'Phx.vista.BajaMedica',
        title:'Solicitud Baja Medica',
        nombreVista: 'BajaMedica',
        bnew:true,
        bedit:true,
        bdel:true,
        tam_pag:50,
        //funcion para mandar el name de tab
        actualizarSegunTab: function(name, indice){
            if (this.finCons) {
                this.store.baseParams.pes_estado = name;
                this.load({params: {start: 0, limit: this.tam_pag}});
            }
        },
        // tab
        gruposBarraTareas:[
            {name:'registro',title:'<h1 align="center"><i></i>Solicitudes</h1>',grupo:0,height:0},
            {name:'enviado',title:'<h1 align="center"><i></i>Enviados</h1>',grupo:1,height:0}
        ],
        bnewGroups:[0],
        bactGroups:[0,1,2],
        bdelGroups:[0],
        beditGroups:[0],
        bexcelGroups:[0,1,2],
        constructor: function(config) {
            Phx.vista.BajaMedicaSol.superclass.constructor.call(this, config);
            this.store.baseParams = {tipo_interfaz: this.nombreVista};
            this.store.baseParams.pes_estado = 'registro';
            this.finCons = true;
            this.load({params: {start: 0, limit: this.tam_pag}});
        },
        preparaMenu:function(n){
            Phx.vista.BajaMedicaSol.superclass.preparaMenu.call(this, n);
            this.getBoton('diagrama_gantt').enable();
            this.getBoton('btn_siguiente').enable();
            this.getBoton('btnChequeoDocumentosWf').enable();
        },
        liberaMenu:function() {
            var tb = Phx.vista.BajaMedicaSol.superclass.liberaMenu.call(this);
            if (tb) {
                this.getBoton('diagrama_gantt').disable();
                this.getBoton('btn_siguiente').disable();
                this.getBoton('btnChequeoDocumentosWf').disable();
            }
        },
    };
</script>

