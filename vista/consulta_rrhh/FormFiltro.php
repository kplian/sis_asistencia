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
                    allowBlank: false,
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
                    allowBlank: false,
                    format: 'd/m/Y',
                    width: 180
                },
                type: 'DateField',
                id_grupo: 0,
                form: true
            },
            {
                config:{
                    name:'id_uo',
                    hiddenName: 'id_uo',
                    origen:'UO',
                    fieldLabel:'UO',
                    gdisplayField:'desc_uo',//mapea al store del grid
                    gwidth:200,
                    emptyText:'Dejar blanco para toda la empresa...',
                    width : 180,
                    baseParams: {nivel: '0,1,2'},
                    allowBlank:true
                },
                type:'ComboRec',
                id_grupo:0,
                form:true
            },

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

        onSubmit:function(o){
            const me = this;
            if (this.form.getForm().isValid()) {
                const parametros = me.getValForm();

                const desde = this.Cmp.desde.getValue();
                const hasta = this.Cmp.hasta.getValue();
                const id_tipo_estado = null;
                const id_uo = this.Cmp.id_uo.getValue();
                this.onEnablePanel(this.idContenedor + '-east',
                    Ext.apply(parametros,{
                        'desde': desde,
                        'hasta': hasta,
                        'id_tipo_estado': id_tipo_estado,
                        'id_uo': id_uo
                    }));
            }
        },

        getValues:function(){
            return {
                desde: this.Cmp.desde.getValue(),
                hasta: this.Cmp.hasta.getValue(),
                id_uo: this.Cmp.id_uo.getValue()
            };
        },
        loadValoresIniciales: function(){
            Phx.vista.FormFiltro.superclass.loadValoresIniciales.call(this);
        }

    })
</script>
