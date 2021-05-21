<?php
/**
 * @package pXP
 * @file CompensacionDetTrabajo.php
 * @author  MAM
 * @date 27-12-2016 14:45
 * @Interface para el inicio de solicitudes de materiales
 */
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
    Phx.vista.CompensacionDetComSol = {
        require: '../../../sis_asistencia/vista/compensacion_det_com/CompensacionDetCom.php', // direcion de la clase que va herrerar
        requireclase: 'Phx.vista.CompensacionDetCom', // nombre de la calse
        title: 'CompensacionDetCom', // nombre de interaz
        nombreVista: 'CompensacionDetComSol',
        bsave: false,
        fwidth: '30%',
        fheight: '20%',
        constructor: function (config) {
            Phx.vista.CompensacionDetComSol.superclass.constructor.call(this, config);
        },
        onReloadPage: function (m) {
            this.maestro = m;
            this.store.baseParams = {id_compensacion_det: this.maestro.id_compensacion_det};
            this.load({params: {start: 0, limit: 50}})
        },
        loadValoresIniciales: function () {
            Phx.vista.CompensacionDet.superclass.loadValoresIniciales.call(this);
            this.Cmp.id_compensacion_det.setValue(this.maestro.id_compensacion_det);
        },
    };
</script>

