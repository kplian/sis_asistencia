<?php
/*
*/

header("content-type: text/javascript; charset=UTF-8");
?>

<script>
    Phx.vista.FormFiltroVacacion=Ext.extend(Phx.frmInterfaz,{

        constructor:function(config){
            this.panelResumen = new Ext.Panel({html:''});
            this.Grupos =
                [
                    {
                        xtype: 'fieldset',
                        border: true,
                        autoScroll: true,
                        layout: 'form',
                        items:
                            [
                            ],
                        id_grupo: 0
                    },
                    this.panelResumen
                ];

            Phx.vista.FormFiltroVacacion.superclass.constructor.call(this,config);
            this.init();
            this.inicialEvento();
            if(config.detalle){
                this.loadForm({data: config.detalle});
                const me = this;
                setTimeout(function(){
                    //  me.onSubmit()
                    console.log(12)
                }, 1000);
            }
        },
        inicialEvento:function(){
            this.Cmp.desde.setValue(new Date());
            this.Cmp.hasta.setValue(new Date());
        },
        //
        Atributos:[
            {
                config:{
                    name: 'desde',
                    fieldLabel: 'Fecha (Desde)',
                    allowBlank: true,
                    format: 'd/m/Y',
                    width: 180
                },
                type: 'DateField',
                id_grupo: 0,
                form: true
            },
            {
                config:{
                    name: 'hasta',
                    fieldLabel: 'Fecha (Hasta)',
                    allowBlank: true,
                    format: 'd/m/Y',
                    width: 180
                },
                type: 'DateField',
                id_grupo: 0,
                form: true
            }/*,
            {
                config: {
                    name: 'id_tipo_estado',
                    fieldLabel: 'Estado',
                    allowBlank: true,
                    resizable:true,
                    emptyText: 'Elija una opción...',
                    store: new Ext.data.JsonStore({
                        url: '../../sis_asistencia/control/Permiso/listarEstados',
                        id: 'id_tipo_estado',
                        root: 'datos',
                        sortInfo: {
                            field: 'codigo',
                            direction: 'ASC'
                        },
                        totalProperty: 'total',
                        fields: ['id_tipo_estado', 'codigo','nombre_estado'],
                        remoteSort: true,
                        baseParams: {par_filtro: 'ts.codigo', marco:'VAC',codigo:'VAC-PRO'}
                    }),
                    valueField: 'codigo',
                    displayField: 'nombre_estado',
                    gdisplayField: 'codigo',
                    hiddenName: 'id_tipo_estado',
                    forceSelection: true,
                    typeAhead: false,
                    triggerAction: 'all',
                    lazyRender: true,
                    mode: 'remote',
                    pageSize: 15,
                    queryDelay: 1000,
                    width: 180,
                    gwidth: 80,
                    minChars: 2
                },
                type: 'ComboBox',
                id_grupo: 0,
                form: true
            }*/
        ],
        labelSubmit: '<i class="fa fa-check"></i> Aplicar Filtro',
        east: {
            url: '../../../sis_asistencia/vista/consulta_rrhh/VacacionRrhh.php',
            title: undefined,
            width: '70%',
            cls: 'VacacionRrhh'
        },
        title: 'Filtro',
        autoScroll: true,

        onSubmit:function(o){
            const me = this;
            if (this.form.getForm().isValid()) {
                const parametros = me.getValForm();

                const desde = this.Cmp.desde.getValue();
                const hasta = this.Cmp.hasta.getValue();
                const id_tipo_estado = null;
                this.onEnablePanel(this.idContenedor + '-east',
                    Ext.apply(parametros,{
                        'desde': desde,
                        'hasta': hasta,
                        'id_tipo_estado': id_tipo_estado
                    }));
            }
        },

        getValues:function(){
            return {
                desde: this.Cmp.desde.getValue(),
                hasta: this.Cmp.hasta.getValue(),
                // id_tipo_estado: this.Cmp.id_tipo_estado.getValue()
            };
        },
        loadValoresIniciales: function(){
            Phx.vista.FormFiltroVacacion.superclass.loadValoresIniciales.call(this);
        }

    })
</script>
