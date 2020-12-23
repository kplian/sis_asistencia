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
    Phx.vista.MovVacListaFuncionario = {
        require:'../../../sis_asistencia/vista/movimiento_vacacion/MovimientoVacacion.php', // direcion de la clase que va heredar
        requireclase:'Phx.vista.MovimientoVacacion', // nombre de la calse
        title:'Vacaciones', // nombre de interaz
        nombreVista: 'MovVacListaFuncionario',
        bnew:false,
        bedit:false,
        bdel:false,
        bsave:false,
        constructor: function(config) {
            this.initButtons=[this.cmbFuncionario];  // inicializando combo del funcionario.
            Phx.vista.MovVacListaFuncionario.superclass.constructor.call(this, config);
            this.store.baseParams = {tipo_interfaz: this.nombreVista};
            this.load({params: {start: 0, limit: this.tam_pag}});
            this.cmbFuncionario.on('select', function( combo, record, index){
               // this.cmbFuncionario = record.data.id_funcionarioa;
                 this.capturaFiltros();
            },this);
        },
        capturaFiltros:function(combo, record, index){
            // this.desbloquearOrdenamientoGrid();
            if(this.validarFiltros()){
                this.store.baseParams.id_funcionarios = this.cmbFuncionario.getValue();
                this.load();
            }else {
                alert('Seleccione un funcionario');
            }

        },
        validarFiltros:function(){
            if(this.cmbFuncionario.validate()){
                console.log('bien');
                return true;
            } else{
                console.log('mal');
                return false;

            }
        },
        cmbFuncionario: new Ext.form.ComboBox({  //Listar funcionarios
            fieldLabel: 'funcionario',
            allowBlank: false,
            emptyText: 'Funcionario...',
            blankText: 'Funcionario',
            store:new Ext.data.JsonStore(
                {
                    url: '../../sis_organigrama/control/Funcionario/listarFuncionarioCargo',
                    id: 'id_uo',
                    root: 'datos',
                    sortInfo:{
                        field: 'desc_funcionario2',
                        direction: 'ASC'
                    },
                    totalProperty: 'total',
                    fields: ['id_funcionario','id_uo','codigo','nombre_cargo','desc_funcionario2'],
                    // turn on remote sorting
                    remoteSort: true,
                    baseParams:{par_filtro: 'id_funcionario#desc_funcionario2#codigo'}
                }),
            valueField: 'id_funcionario',
            triggerAction: 'all',
            displayField: 'desc_funcionario2',
            hiddenName: 'id_funcionario',
            mode:'remote',
            pageSize:50,
            queryDelay:500,
            listWidth:'280',
            width:250
        })
    };
</script>