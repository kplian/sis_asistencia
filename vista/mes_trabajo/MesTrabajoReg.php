<?php
/**
 *@package pXP
 *@file RegistroSolicitud.php
 *@author  MAM
 *@date 27-12-2016 14:45
 *@Interface para el inicio de solicitudes de materiales
 */
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
    Phx.vista.MesTrabajoReg = {
        require:'../../../sis_asistencia/vista/mes_trabajo/MesTrabajo.php',
        requireclase:'Phx.vista.MesTrabajo',
        title:'Mes trabajo VoBo',
        nombreVista: 'Reg',
        gruposBarraTareas:[
            {name:'borrador',title:'<h1 align="center"><i></i>Borrador</h1>',grupo:0,height:0},
            {name:'asignado',title:'<h1 align="center"><i></i>Asignado</h1>',grupo:1,height:0},
            {name:'aprobado',title:'<h1 align="center"><i></i>Aprobado</h1>',grupo:2,height:0}
        ],
        tam_pag:50,
        actualizarSegunTab: function(name, indice){
            if(!this.validarFiltros() && name != 'borrador'){
                alert('Especifique el año y el mes antes')
            }else {
                if (this.finCons) {
                    this.store.baseParams.pes_estado = name;
                    this.load({params: {start: 0, limit: this.tam_pag}});
                }
            }
        },
        bnewGroups:[0],
        bactGroups:[0,1,2],
        bdelGroups:[0],
        beditGroups:[0],
        bexcelGroups:[0,1,2],
        constructor: function(config) {
            this.initButtons=[this.cmbGestion, this.cmbPeriodo];
            Phx.vista.MesTrabajoReg.superclass.constructor.call(this,config);
            this.store.baseParams = {tipo_interfaz: this.nombreVista};
            this.store.baseParams.pes_estado = 'borrador';
            this.getBoton('ant_estado').setVisible(false);
        },
        onButtonAct:function(){
            if(!this.validarFiltros()){
                alert('Especifique el año y el mes antes')
            }
            else{
                this.store.baseParams.id_gestion=this.cmbGestion.getValue();
                this.store.baseParams.id_periodo = this.cmbPeriodo.getValue();
                Phx.vista.MesTrabajoReg.superclass.onButtonAct.call(this);
            }
        }

    };
</script>

