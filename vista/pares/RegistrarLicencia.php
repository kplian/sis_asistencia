<?php
/**
 *@package pXP
 *@file FiltroFecha.php
 *@author  (mgarcia)
 *@date 24-09-2019 16:53:42
 *@description permites registrar licencias
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.FiltroFecha=Ext.extend(Phx.frmInterfaz,{
        constructor:function(config) {
            this.maestro = config;
            Phx.vista.FiltroFecha.superclass.constructor.call(this,config);
            this.init();
        },
        loadValoresIniciales:function() {
        },
        successSave:function(resp){
            Phx.CP.loadingHide();
            Phx.CP.getPagina(this.idContenedorPadre).reload();
            this.panel.close();
        },

        Atributos:[

            {
                config:{
                    name: 'fecha_solicitud',
                    fieldLabel: 'Fecha Solicitud',
                    allowBlank: false,
                    width: 130,
                    gwidth: 100,
                    format: 'd/m/Y',
                    renderer:function (value,p,record){return value?value.dateFormat('d/m/Y'):''}
                },
                type:'DateField',
                filters:{pfiltro:'pmo.fecha_solicitud',type:'date'},
                id_grupo:1,
                grid:true,
                form:true
            },
        ],
        tam_pag:50,
        title:'Permiso',

        id_store:'id_permiso',
        fields: [
            {name:'id_permiso', type: 'numeric'},
            {name:'nro_tramite', type: 'string'},
            {name:'id_funcionario', type: 'numeric'},
            {name:'id_estado_wf', type: 'numeric'},
            {name:'fecha_solicitud', type: 'date',dateFormat:'Y-m-d'},
            {name:'id_tipo_permiso', type: 'numeric'},
            {name:'motivo', type: 'string'},
            {name:'estado_reg', type: 'string'},
            {name:'estado', type: 'string'},
            {name:'id_proceso_wf', type: 'numeric'},
            {name:'id_usuario_ai', type: 'numeric'},
            {name:'id_usuario_reg', type: 'numeric'},
            {name:'usuario_ai', type: 'string'},
            {name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
            {name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
            {name:'id_usuario_mod', type: 'numeric'},
            {name:'usr_reg', type: 'string'},
            {name:'usr_mod', type: 'string'},

            {name:'desc_tipo_permiso', type: 'string'},
            {name:'desc_funcionario', type: 'string'},
            {name:'hro_desde',type: 'string'},
            {name:'hro_hasta',type: 'string'},
            {name:'asignar_rango', type: 'string'}

        ],
        sortInfo:{
            field: 'id_permiso',
            direction: 'ASC'
        },

        fwidth: '45%',
        fheight: '45%'
        }
    )

</script>