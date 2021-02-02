<?php
/**
 *@package pXP
 *@file SolTeleTrabajo.php
 *@author  MAM
 *@date 27-12-2016 14:45
 *@Interface para el inicio de solicitudes de materiales
 */
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
    Phx.vista.SolTeleTrabajo = {
        require:'../../../sis_asistencia/vista/tele_trabajo/TeleTrabajo.php', // direcion de la clase que va herrerar
        requireclase:'Phx.vista.TeleTrabajo', // nombre de la calse
        title:'Solicitud Teletrabajo', // nombre de interaz
        nombreVista: 'SolTeleTrabajo',
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
            {name:'registro',title:'<h1 align="center"><i></i>Solicitud</h1>',grupo:0,height:0},
            {name:'vobo',title:'<h1 align="center"><i></i>VoBo</h1>',grupo:1,height:0},
            {name:'aprobado',title:'<h1 align="center"><i></i>Aprobado</h1>',grupo:1,height:0},
            {name:'cancelado',title:'<h1 align="center"><i></i>Cancelado</h1>',grupo:1,height:0}
        ],
        bnewGroups:[0],
        bactGroups:[0,1,2],
        bdelGroups:[0],
        beditGroups:[0],
        bexcelGroups:[0,1,2],
        constructor: function(config) {
            Phx.vista.SolTeleTrabajo.superclass.constructor.call(this, config);
            this.store.baseParams = {tipo_interfaz: this.nombreVista};

            this.store.baseParams.pes_estado = 'registro';
            this.finCons = true;
            this.addButton('btn_siguiente',{grupo:[0,3],
                text:'Enviar Solicitud',
                iconCls: 'bemail',
                disabled:true,
                handler:this.onSiguiente
            });
            this.addBotonesGantt();
            this.load({params: {start: 0, limit: this.tam_pag}});
        },
        preparaMenu:function(n){
            Phx.vista.TeleTrabajo.superclass.preparaMenu.call(this, n);
            this.getBoton('diagrama_gantt').enable();
            this.getBoton('btn_siguiente').enable();
        },
        liberaMenu:function() {
            var tb = Phx.vista.TeleTrabajo.superclass.liberaMenu.call(this);
            if (tb) {
                this.getBoton('diagrama_gantt').disable();
                this.getBoton('btn_siguiente').disable();
            }
        },
    };
</script>

