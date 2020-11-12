<?php
/*
*/

header("content-type: text/javascript; charset=UTF-8");
?>

<script>
    Phx.vista.FormFiltro=Ext.extend(Phx.frmInterfaz,{

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

            Phx.vista.FormFiltro.superclass.constructor.call(this,config);
            this.init();

            if(config.detalle){
                //cargar los valores para el FormFiltro
                this.loadForm({data: config.detalle});
               /* var me = this;
                setTimeout(function(){
                    me.onSubmit()
                }, 1500);*/
            }
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
            },
            {
                config: {
                    name: 'id_tipo_estado',
                    fieldLabel: 'Estado',
                    allowBlank: true,
                    resizable:true,
                    emptyText: 'Elija una opción...',
                    store: new Ext.data.JsonStore({
                        url: '../../sis_auditoria/control/AuditoriaOportunidadMejora/listarEstados',
                        id: 'id_tipo_estado',
                        root: 'datos',
                        sortInfo: {
                            field: 'codigo',
                            direction: 'ASC'
                        },
                        totalProperty: 'total',
                        fields: ['id_tipo_estado', 'codigo','nombre_estado'],
                        remoteSort: true,
                        baseParams: {par_filtro: 'ts.codigo'}
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
            },
            {
                config: {
                    name: 'id_uo',
                    baseParams: {
                        estado_reg : 'activo'
                    },
                    origen:'UO',
                    allowBlank:true,
                    fieldLabel:'Area',
                    gdisplayField:'nombre_unidad', //mapea al store del grid
                    tpl:'<tpl for="."><div class="x-combo-list-item"><p>{nombre_unidad}</p> </div></tpl>',
                    gwidth: 250,
                    width: 180
                },
                type:'ComboRec',
                id_grupo:0,
                form:true
            }
        ],
        labelSubmit: '<i class="fa fa-check"></i> Aplicar Filtro',
        east: {
            url: '../../../sis_asistencia/vista/consulta_rrhh/PermisoRrhh.php',
            title: undefined,
            width: '70%',
            cls: 'PermisoRrhh'
        },
        title: 'Filtro',
        autoScroll: true,

        onSubmit:function(){

            var me = this;

            if (this.form.getForm().isValid()) {
                var parametros = me.getValForm();
                this.fireEvent('beforesave',this,this.getValues());
                this.getValues();
                this.onEnablePanel(me.idContenedorPadre, parametros)
            }
        },

        getValues:function(){
            var resp = {
                id_gestion : this.Cmp.id_gestion.getValue(),
                desde : this.Cmp.desde.getValue(),
                hasta : this.Cmp.hasta.getValue(),
            }
            return resp;
        },
        loadValoresIniciales: function(){
            Phx.vista.FormFiltro.superclass.loadValoresIniciales.call(this);
        },
        onReloadPage:function(){

        }

    })
</script>
