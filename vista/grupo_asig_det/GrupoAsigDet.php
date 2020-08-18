<?php
/**
 *@package pXP
 *@file gen-GrupoAsigDet.php
 *@author  (miguel.mamani)
 *@date 20-11-2019 20:55:17
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
#0				20-11-2019				 (miguel.mamani)				CREACION

 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.GrupoAsigDet=Ext.extend(Phx.gridInterfaz,{

            constructor:function(config){
                this.maestro=config.maestro;
                //llama al constructor de la clase padre
                Phx.vista.GrupoAsigDet.superclass.constructor.call(this,config);
                this.init();
            },

            Atributos:[
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_id_grupo_asig_det'
                    },
                    type:'Field',
                    form:true
                },
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_grupo_asig'
                    },
                    type:'Field',
                    form:true
                },
                {
                    config:{
                        name:'id_funcionario',
                        hiddenName: 'id_funcionario',
                        origen:'FUNCIONARIOCAR',
                        fieldLabel:'Funcionario',
                        allowBlank:false,
                        anchor: '70%',
                        gwidth:300,
                        valueField: 'id_funcionario',
                        gdisplayField: 'desc_funcionario1',
                        baseParams: {par_filtro: 'id_funcionario#desc_funcionario1#codigo',es_combo_solicitud : 'si'},
                        renderer:function(value, p, record){return String.format('{0}', record.data['nombre_completo']);}
                    },
                    type:'ComboRec',//ComboRec
                    id_grupo:0,
                    filters:{pfiltro:'fun.desc_funcionario1',type:'string'},
                    bottom_filter:true,
                    grid:true,
                    form:true
                },
                {
                    config:{
                        name: 'codigo',
                        fieldLabel: 'Codigo',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:10
                    },
                    type:'TextField',
                    filters:{pfiltro:'fun.codigo',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },
                {
                    config:{
                        name: 'estado_reg',
                        fieldLabel: 'Estado Reg.',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:10
                    },
                    type:'TextField',
                    filters:{pfiltro:'grd.estado_reg',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },
                {
                    config:{
                        name: 'usr_reg',
                        fieldLabel: 'Creado por',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:4
                    },
                    type:'Field',
                    filters:{pfiltro:'usu1.cuenta',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },
                {
                    config:{
                        name: 'usuario_ai',
                        fieldLabel: 'Funcionaro AI',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:300
                    },
                    type:'TextField',
                    filters:{pfiltro:'grd.usuario_ai',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },
                {
                    config:{
                        name: 'fecha_reg',
                        fieldLabel: 'Fecha creación',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        format: 'd/m/Y',
                        renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
                    },
                    type:'DateField',
                    filters:{pfiltro:'grd.fecha_reg',type:'date'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },
                {
                    config:{
                        name: 'id_usuario_ai',
                        fieldLabel: 'Fecha creación',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:4
                    },
                    type:'Field',
                    filters:{pfiltro:'grd.id_usuario_ai',type:'numeric'},
                    id_grupo:1,
                    grid:false,
                    form:false
                },
                {
                    config:{
                        name: 'usr_mod',
                        fieldLabel: 'Modificado por',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:4
                    },
                    type:'Field',
                    filters:{pfiltro:'usu2.cuenta',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },
                {
                    config:{
                        name: 'fecha_mod',
                        fieldLabel: 'Fecha Modif.',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        format: 'd/m/Y',
                        renderer:function (value,p,record){return value?value.dateFormat('d/m/Y H:i:s'):''}
                    },
                    type:'DateField',
                    filters:{pfiltro:'grd.fecha_mod',type:'date'},
                    id_grupo:1,
                    grid:true,
                    form:false
                }
            ],
            tam_pag:50,
            title:'grupo detalle',
            ActSave:'../../sis_asistencia/control/GrupoAsigDet/insertarGrupoAsigDet',
            ActDel:'../../sis_asistencia/control/GrupoAsigDet/eliminarGrupoAsigDet',
            ActList:'../../sis_asistencia/control/GrupoAsigDet/listarGrupoAsigDet',
            id_store:'id_id_grupo_asig_det',
            fields: [
                {name:'id_id_grupo_asig_det', type: 'numeric'},
                {name:'estado_reg', type: 'string'},
                {name:'id_funcionario', type: 'numeric'},
                {name:'id_grupo_asig', type: 'numeric'},
                {name:'id_usuario_reg', type: 'numeric'},
                {name:'usuario_ai', type: 'string'},
                {name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
                {name:'id_usuario_ai', type: 'numeric'},
                {name:'id_usuario_mod', type: 'numeric'},
                {name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
                {name:'usr_reg', type: 'string'},
                {name:'usr_mod', type: 'string'},
                {name:'nombre_completo', type: 'string'},
                {name:'codigo', type: 'string'}

            ],
            sortInfo:{
                field: 'id_id_grupo_asig_det',
                direction: 'ASC'
            },
            bdel:true,
            bsave:false,
            onReloadPage:function(m){
                this.maestro=m;
                this.store.baseParams = {id_grupo_asig: this.maestro.id_grupo_asig};
                this.load({params:{start:0, limit:50}})
            },
            loadValoresIniciales: function () {
                this.Cmp.id_grupo_asig.setValue(this.maestro.id_grupo_asig);
                Phx.vista.GrupoAsigDet.superclass.loadValoresIniciales.call(this);
            }
        }
    )
</script>

