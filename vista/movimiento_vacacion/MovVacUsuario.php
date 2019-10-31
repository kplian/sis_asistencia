<?php
/**
 *@package pXP
 *@file VacacionVoBo.php
 *@author  MAM
 *@date 27-12-2016 14:45
 *@Interface para el inicio de solicitudes de materiales
 */
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
    Phx.vista.MovVacUsuario = {
        require:'../../../sis_asistencia/vista/movimiento_vacacion/MovimientoVacacion.php', // direcion de la clase que va herredar
        requireclase:'Phx.vista.MovimientoVacacion', // nombre de la calse
        title:'Vacaciones', // nombre de interaz
        nombreVista: 'MovVacUsuario',
        bnew:false,
        bedit:false,
        bdel:false,
        bsave:false,
        constructor: function(config) {
            Phx.vista.MovVacUsuario.superclass.constructor.call(this, config);
            this.store.baseParams = {tipo_interfaz: this.nombreVista};

            var id;
            if (Phx.CP.config_ini.id_funcionario !== ''){
                id = Phx.CP.config_ini.id_funcionario;
            }else {
                id = null;
            }
            this.store.baseParams = {id_funcionario: id, interfaz:this.nombreVista};

            this.load({params: {start: 0, limit: this.tam_pag}});

        }
    };
</script>