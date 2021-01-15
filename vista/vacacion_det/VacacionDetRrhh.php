<?php
/**
 *@package pXP
 *@file VacacionDetRrhh.php
 *@author  MAM
 *@date 27-12-2016 14:45
 *@Interface para el inicio de solicitudes de materiales
 */
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
    Phx.vista.VacacionDetRrhh = {
        require:'../../../sis_asistencia/vista/vacacion_det/VacacionDet.php', // direcion de la clase que va herrerar
        requireclase:'Phx.vista.VacacionDet', // nombre de la calse
        title:'VoBo Vacaciones', // nombre de interaz
        nombreVista: 'VacacionDetRrhh',
        bnew:false,
        bedit:false,
        bdel:false,
        bsave:false,
        constructor: function(config) {
            Phx.vista.VacacionDetRrhh.superclass.constructor.call(this, config);
        },
        oncellclick : function(grid, rowIndex, columnIndex, e) {/// revisar
            const record = this.store.getAt(rowIndex),
                fieldName = grid.getColumnModel().getDataIndex(columnIndex); // Get field name
            if (fieldName === 'tiempo'){
                    this.cambiarAsignacion(record,fieldName);
            }
        },
    };
</script>

