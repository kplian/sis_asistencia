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
        bedit:true,
        bdel:true,
        bsave:false,
        constructor: function(config) {
            this.initButtons=[this.cmbFuncionario];  // inicializando combo del funcionario.
            Phx.vista.MovVacListaFuncionario.superclass.constructor.call(this, config);
            this.getBoton('btnReporte').setVisible(false);
            this.store.baseParams = {tipo_interfaz: this.nombreVista};
            // this.load({params: {start: 0, limit: this.tam_pag}});
            this.cmbFuncionario.on('select', function( combo, record, index){
               // this.cmbFuncionario = record.data.id_funcionarioa;
                 this.capturaFiltros();
            },this);
            this.iniciarEventos();
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
            return !!this.cmbFuncionario.validate();
        },
        onButtonEdit:function(){
            Phx.vista.MovVacListaFuncionario.superclass.onButtonEdit.call(this);
            const rec = this.sm.getSelected();
            console.log(rec)
        },
        preparaMenu:function(n){
            Phx.vista.MovVacListaFuncionario.superclass.preparaMenu.call(this, n);
            const data = this.sm.getSelected().data;
            if (data.tipo !== 'TOMADA'){
                this.getBoton('edit').disable();
                this.getBoton('del').disable();
            }
        },
        iniciarEventos: function(){
            this.Cmp.desde.on('select', function (Fecha, dato) {
                Ext.Ajax.request({
                    url: '../../sis_asistencia/control/Vacacion/getDias', //llamando a la funcion getDias.
                    params: {
                        'fecha_fin': this.Cmp.hasta.getValue(),
                        'fecha_inicio': Fecha.getValue(),
                        'dias': 0,
                        'medios_dias':  '',
                        'id_funcionario': this.cmbFuncionario.getValue()

                    },
                    success: this.respuestaValidacion,
                    failure: this.conexionFailure,
                    timeout: this.timeout,
                    scope: this
                });
            }, this);

            this.Cmp.hasta.on('select', function (Fecha, dato) {
                Ext.Ajax.request({
                    url: '../../sis_asistencia/control/Vacacion/getDias', //llamando a la funcion getDias.
                    params: {
                        'fecha_fin': Fecha.getValue(),
                        'fecha_inicio': this.Cmp.desde.getValue(),
                        'dias': 0,
                        'medios_dias':  '',
                        'id_funcionario': this.cmbFuncionario.getValue()
                    },
                    success: this.respuestaValidacion,
                    failure: this.conexionFailure,
                    timeout: this.timeout,
                    scope: this
                });
            }, this);

            this.Cmp.desde.on('change', function (Fecha, dato) {
                Ext.Ajax.request({
                    url: '../../sis_asistencia/control/Vacacion/getDias', //llamando a la funcion getDias.
                    params: {
                        'fecha_fin': this.Cmp.hasta.getValue(),
                        'fecha_inicio': Fecha.getValue(),
                        'dias': 0,
                        'medios_dias':  '',
                        'id_funcionario': this.cmbFuncionario.getValue()
                    },
                    success: this.respuestaValidacion,
                    failure: this.conexionFailure,
                    timeout: this.timeout,
                    scope: this
                });
            }, this);

            this.Cmp.hasta.on('change', function (Fecha, dato) {
                Ext.Ajax.request({
                    url: '../../sis_asistencia/control/Vacacion/getDias', //llamando a la funcion getDias.
                    params: {
                        'fecha_fin': Fecha.getValue(),
                        'fecha_inicio': this.Cmp.desde.getValue(),
                        'dias': 0,
                        'medios_dias':  '',
                        'id_funcionario': this.cmbFuncionario.getValue()
                    },
                    success: this.respuestaValidacion,
                    failure: this.conexionFailure,
                    timeout: this.timeout,
                    scope: this
                });
            }, this);
        },
        arrayStore :{
            'Selección':[
                ['',''],
            ],
            'Selección2':[ ],
        },
        respuestaValidacion: function (s,m){
            this.maestro = m;
            var respuesta_valid = s.responseText.split('%');
            this.arrayStore.Selección=[];
            this.arrayStore.Selección=['',''];
            for(var i=0; i<=parseInt(respuesta_valid[1]); i++){
                this.arrayStore.Selección[i]=["ID"+(i),(i)];
            }
            this.Cmp.dias.reset();
            this.Cmp.dias.setValue(respuesta_valid[1]);
        },
        cmbFuncionario: new Ext.form.ComboBox({  //Listar funcionarios
            fieldLabel: 'funcionario',
            allowBlank: false,
            emptyText: 'Funcionario...',
            blankText: 'Funcionario',
            store: new Ext.data.JsonStore({
                url: '../../sis_asistencia/control/Vacacion/listarFuncionarioOficiales',
                id: 'id_funcionario',
                root: 'datos',
                totalProperty: 'total',
                fields: ['id_funcionario','desc_funcionario','codigo','cargo','departamento','oficina'],
                remoteSort: true,
                baseParams: {par_filtro: 'pe.nombre_completo1'}
            }),
            valueField: 'id_funcionario',
            displayField: 'desc_funcionario',
            gdisplayField: 'desc_funcionario1',
            hiddenName: 'Funcionario',
            tpl: '<tpl for="."><div class="x-combo-list-item"><p><b>{desc_funcionario}</b></p><p>{codigo}</p><p>{cargo}</p><p>{departamento}</p><p>{oficina}</p> </div></tpl>',
            mode:'remote',
            pageSize:50,
            triggerAction: 'all',
            queryDelay:500,
            listWidth:'280',
            width:250
        })
    };
</script>