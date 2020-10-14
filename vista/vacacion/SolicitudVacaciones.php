<?php
/**
 *@package pXP
 *@file SolicitudVacaciones.php
 *@author  MAM
 *@date 27-12-2016 14:45
 *@Interface para el inicio de solicitudes de materiales
 */
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
    Phx.vista.SolicitudVacaciones = {
        require:'../../../sis_asistencia/vista/vacacion/Vacacion.php', // direcion de la clase que va herrerar
        requireclase:'Phx.vista.Vacacion', // nombre de la calse
        title:'Solicitud Vacaciones', // nombre de interaz
        nombreVista: 'SolicitudVacaciones',
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
            {name:'aprobado',title:'<h1 align="center"><i></i>Aprobado</h1>',grupo:2,height:0}
        ],
        bnewGroups:[0],
        bactGroups:[0,1,2],
        bdelGroups:[0],
        beditGroups:[0],
        bexcelGroups:[0,1,2],

        constructor: function(config) {
            Phx.vista.SolicitudVacaciones.superclass.constructor.call(this, config);
            this.store.baseParams = {tipo_interfaz: this.nombreVista};
            this.store.baseParams.pes_estado = 'registro';
            this.getBoton('btn_atras').setVisible(false);
            this.getBoton('btn_cancelar').setVisible(false);

            this.finCons = true;
            this.load({params: {start: 0, limit: this.tam_pag}});

        },
        tabeast:[
            {
                url:'../../../sis_asistencia/vista/vacacion_det/VacacionDet.php',
                title:'Detalle',
                width:'40%',
                cls:'VacacionDet'
            }
        ]
    };
</script>

