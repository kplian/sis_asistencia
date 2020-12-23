<?php
/**
 *@package pXP
 *@file gen-GrupoAsig.php
 *@author  (miguel.mamani)
 *@date 20-11-2019 20:00:15
 *@description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
HISTORIAL DE MODIFICACIONES:
#ISSUE				FECHA				AUTOR				DESCRIPCION
#0				20-11-2019				 (miguel.mamani)				CREACION

 */

header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.GrupoAsig=Ext.extend(Phx.gridInterfaz,{

            constructor:function(config){
                this.maestro=config.maestro;
                //llama al constructor de la clase padre
                Phx.vista.GrupoAsig.superclass.constructor.call(this,config);
                this.init();
                this.load({params:{start:0, limit:this.tam_pag}})
            },

            Atributos:[
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
                        name: 'codigo',
                        fieldLabel: 'Codigo',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:20
                    },
                    type:'TextField',
                    filters:{pfiltro:'gru.codigo',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:false
                },
                {
                    config:{
                        name: 'descripcion',
                        fieldLabel: 'Nombre',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 200,
                    },
                    type:'TextField',
                    filters:{pfiltro:'gru.descripcion',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:true
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
                    filters:{pfiltro:'gru.estado_reg',type:'string'},
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
                    filters:{pfiltro:'gru.usuario_ai',type:'string'},
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
                    filters:{pfiltro:'gru.fecha_reg',type:'date'},
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
                        name: 'id_usuario_ai',
                        fieldLabel: 'Creado por',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength:4
                    },
                    type:'Field',
                    filters:{pfiltro:'gru.id_usuario_ai',type:'numeric'},
                    id_grupo:1,
                    grid:false,
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
                    filters:{pfiltro:'gru.fecha_mod',type:'date'},
                    id_grupo:1,
                    grid:true,
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
                }
            ],
            tam_pag:50,
            title:'Grupo',
            ActSave:'../../sis_asistencia/control/GrupoAsig/insertarGrupoAsig',
            ActDel:'../../sis_asistencia/control/GrupoAsig/eliminarGrupoAsig',
            ActList:'../../sis_asistencia/control/GrupoAsig/listarGrupoAsig',
            id_store:'id_grupo_asig',
            fields: [
                {name:'id_grupo_asig', type: 'numeric'},
                {name:'codigo', type: 'string'},
                {name:'estado_reg', type: 'string'},
                {name:'descripcion', type: 'string'},
                {name:'usuario_ai', type: 'string'},
                {name:'fecha_reg', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
                {name:'id_usuario_reg', type: 'numeric'},
                {name:'id_usuario_ai', type: 'numeric'},
                {name:'fecha_mod', type: 'date',dateFormat:'Y-m-d H:i:s.u'},
                {name:'id_usuario_mod', type: 'numeric'},
                {name:'usr_reg', type: 'string'},
                {name:'usr_mod', type: 'string'},

            ],
            sortInfo:{
                field: 'id_grupo_asig',
                direction: 'ASC'
            },
            bdel:true,
            bsave:false,
            tabsouth:[
                {
                    url:'../../../sis_asistencia/vista/grupo_asig_det/GrupoAsigDet.php',
                    title:'Detalle',
                    height:'50%',
                    cls:'GrupoAsigDet'
                }
            ]
        }
    )
</script>

