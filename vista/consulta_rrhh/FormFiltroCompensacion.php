<?php
/*
*/

header("content-type: text/javascript; charset=UTF-8");
?>

<script>
    Phx.vista.FormFiltroCompensacion=Ext.extend(Phx.frmInterfaz,{

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

            Phx.vista.FormFiltroCompensacion.superclass.constructor.call(this,config);
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
                    baseParams: {gerencia: 'si'},
                    allowBlank:true
                },
                type:'ComboRec',
                id_grupo:0,
                form:true
            },
        ],
        labelSubmit: '<i class="fa fa-check"></i> Aplicar Filtro',
        title: 'Filtro',
        autoScroll: true,
        onSubmit:function(){
            const me = this;
            if (this.form.getForm().isValid()) {
                const parametros = me.getValForm();
                this.fireEvent('beforesave',this,this.getValues());
                this.getValues();
                this.onEnablePanel(me.idContenedorPadre, parametros);
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
            Phx.vista.FormFiltroCompensacion.superclass.loadValoresIniciales.call(this);
        },
        onReloadPage:function(){}
    })
</script>
