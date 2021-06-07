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
        fheight: '25%',
        constructor: function (config) {
            Phx.vista.CompensacionDetComSol.superclass.constructor.call(this, config);
        },
        onReloadPage: function (m) {
            this.maestro = m;
            this.store.baseParams = {id_compensacion_det: this.maestro.id_compensacion_det};
            console.log(this.maestro.fecha_fin)
            var social = Boolean(this.maestro.social_forestal);
            var minDate = new Date(this.maestro.fecha);
            var minDateSocial = new Date(this.maestro.fecha_fin);

            if (!social) {
                if (minDate.getDay() === 6) {
                    this.Cmp.fecha_comp.setMinValue(this.sumarDias(minDate, +2));
                    this.Cmp.fecha_comp.setMaxValue(this.sumarDias(this.maestro.fecha, 11));
                }else {
                    this.Cmp.fecha_comp.setMinValue(this.sumarDias(minDate, + 1));
                    this.Cmp.fecha_comp.setMaxValue(this.sumarDias(this.maestro.fecha, 10));
                }
                if (minDate.getDay() === 0) {
                    this.Cmp.fecha_comp.setMinValue(this.sumarDias(minDate, +1));
                    this.Cmp.fecha_comp.setMaxValue(this.sumarDias(this.maestro.fecha, 10));
                }else {
                    this.Cmp.fecha_comp.setMinValue(this.sumarDias(minDate, + 1));
                    this.Cmp.fecha_comp.setMaxValue(this.sumarDias(this.maestro.fecha, 10));
                }
            } else {
                this.Cmp.fecha_comp.setMinValue(minDateSocial);
                this.Cmp.fecha_comp.setMaxValue(this.sumarDias(this.maestro.fecha_fin, +7));
            }
            this.load({params: {start: 0, limit: 50}})
        },
        preparaMenu: function (n) {
            Phx.vista.CompensacionDetComSol.superclass.preparaMenu.call(this, n);
            if (this.maestro.social_forestal) {
                this.getBoton('new').disable();
                this.getBoton('del').disable();
                this.getBoton('edit').disable();
            } else {
                this.getBoton('new').enable();
                this.getBoton('del').enable();
                this.getBoton('edit').enable();
            }

        },
        liberaMenu: function () {
            var tb = Phx.vista.CompensacionDetComSol.superclass.liberaMenu.call(this);
            if (tb) {
                if (this.maestro.social_forestal) {
                    this.getBoton('new').disable();
                    this.getBoton('del').disable();
                    this.getBoton('edit').disable();
                } else {
                    this.getBoton('new').enable();
                    this.getBoton('del').enable();
                    this.getBoton('edit').enable();
                }

            }
        },
        onButtonNew: function () {
            Phx.vista.CompensacionDetComSol.superclass.onButtonNew.call(this);
        },
        sumarDias: function (fecha, dias) {
            fecha.setDate(fecha.getDate() + dias);
            return new Date(fecha);
        },
        loadValoresIniciales: function () {
            Phx.vista.CompensacionDet.superclass.loadValoresIniciales.call(this);
            this.Cmp.id_compensacion_det.setValue(this.maestro.id_compensacion_det);
        },
        successSave: function (resp) {
            this.store.rejectChanges();
            Phx.CP.loadingHide();
            if (resp.argument && resp.argument.news) {
                if (resp.argument.def === 'reset') {
                    this.onButtonNew();
                }
            } else {
                this.window.hide();
            }
            this.reload();
            Phx.CP.getPagina(this.idContenedorPadre).reload();
        },
        successDel: function (resp) {
            Phx.CP.loadingHide();
            this.reload();
            Phx.CP.getPagina(this.idContenedorPadre).reload();
        }
    };
</script>

