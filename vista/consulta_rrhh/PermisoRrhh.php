<?php
/**
 *@package pXP
 *@file PermisoRrhh.php
 *@author  MAM
 *@date 27-12-2016 14:45
 *@Interface para el inicio de solicitudes de materiales
 */
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
    Phx.vista.PermisoRrhh = {
        require:'../../../sis_asistencia/vista/permiso/Permiso.php', // direcion de la clase que va herrerar
        requireclase:'Phx.vista.Permiso', // nombre de la calse
        title:'Solicitud Permiso', // nombre de interaz
        nombreVista: 'PermisoRrhh',
        bnew:false,
        bedit:false,
        bdel:false,
        tam_pag:50,
        sortInfo:{
            field: 'departamento',
            direction: 'ASC'
        },
        tipoStore: 'GroupingStore',//GroupingStore o JsonStore #
        remoteGroup: true,
        groupField: 'departamento',
        viewGrid: new Ext.grid.GroupingView({
            forceFit: false
        }),
        actualizarSegunTab: function(name, indice){
            if (this.finCons) {
            //    this.store.baseParams.tipo_interfaz = this.nombreVista;
                this.store.baseParams.pes_estado = name;
                this.load({params: {start: 0, limit: this.tam_pag}});
            }
        },
        // tab
        gruposBarraTareas:[
            {name:'vobo',title:'<h1 align="center"><i></i>VoBo</h1>',grupo:2,height:0},
            {name:'aprobado',title:'<h1 align="center"><i></i>Aprobado</h1>',grupo:5,height:0},
            {name:'rechazado',title:'<h1 align="center"><i></i>Rechazados</h1>',grupo:4,height:0},
            {name:'cancelado',title:'<h1 align="center"><i></i>Cancelados</h1>',grupo:4,height:0}
        ],
        bnewGroups:[0,3],
        bactGroups:[0,1,2,3,4,5],
        bdelGroups:[0],
        beditGroups:[0],
        bexcelGroups:[0,1,2,3,4,5],
        //funcion para mandar el name de tab
        constructor: function(config) {
            // this.Atributos[this.getIndAtributo('observaciones')].grid=false;
            Phx.vista.PermisoRrhh.superclass.constructor.call(this, config);

            this.store.baseParams.tipo_interfaz = this.nombreVista;
            this.store.baseParams.pes_estado = 'vobo';

            this.addButton('btn_siguiente',{grupo:[0,2,3],
                text:'Aprobar',
                iconCls: 'bok',
                disabled:true,
                handler:this.onSiguiente});

            this.addButton('btn_atras',{grupo:[2,3],
                argument: { estado: 'anterior'},
                text:'Rechazar',
                iconCls: 'bdel',
                disabled:true,
                handler:this.onAtras});

            this.addButton('btn_cancelar',{grupo:[5],
                text:'Cancelar',
                iconCls: 'bassign',
                disabled:false,
                handler:this.onCancelar,
                tooltip: '<b>Cancelar</b><p>el permiso en caso que no tomara </p>'});

            this.load({params: {start: 0, limit: this.tam_pag}});
        },
        onReloadPage:function(param){
            this.initFiltro(param);
        },
        initFiltro: function(param){
            this.store.baseParams.param = 'si';
            this.store.baseParams.desde = param.desde;
            this.store.baseParams.hasta = param.hasta;
            this.store.baseParams.id_uo = param.id_uo;
            this.load( { params: { start:0, limit: this.tam_pag } });
        },
        onSiguiente :function () {
            Phx.CP.loadingShow();
            const rec = this.sm.getSelected(); //obtine los datos selecionado en la grilla
            if(confirm('Aprobar solicitud?')) {
                Ext.Ajax.request({
                    url: '../../sis_asistencia/control/Permiso/aprobarEstado',
                    params: {
                        id_proceso_wf:  rec.data.id_proceso_wf,
                        id_estado_wf:  rec.data.id_estado_wf,
                        evento : 'aprobado',
                        obs : ''


                    },
                    success: this.successWizard,
                    failure: this.conexionFailure,
                    timeout: this.timeout,
                    scope: this
                });
            }
            Phx.CP.loadingHide();
        },
        onCancelar :function () {
            Phx.CP.loadingShow();
            const rec = this.sm.getSelected(); //obtine los datos selecionado en la grilla
            if(confirm('¿Desea Cancelar?')) {
                Ext.Ajax.request({
                    url: '../../sis_asistencia/control/Permiso/aprobarEstado',
                    params: {
                        id_proceso_wf:  rec.data.id_proceso_wf,
                        id_estado_wf:  rec.data.id_estado_wf,
                        evento : 'cancelado',
                        obs : ''
                    },
                    success: this.successWizard,
                    failure: this.conexionFailure,
                    timeout: this.timeout,
                    scope: this
                });
            }
            Phx.CP.loadingHide();
        },
        preparaMenu:function(n){
            Phx.vista.PermisoRrhh.superclass.preparaMenu.call(this, n);
            this.getBoton('btn_atras').enable();
            this.getBoton('diagrama_gantt').enable();
            this.getBoton('btn_siguiente').enable();
            this.getBoton('btn_cancelar').enable();
        },
        liberaMenu:function() {
            var tb = Phx.vista.PermisoRrhh.superclass.liberaMenu.call(this);
            if (tb) {
                this.getBoton('btn_atras').disable();
                this.getBoton('diagrama_gantt').disable();
                this.getBoton('btn_siguiente').disable();
                this.getBoton('btn_cancelar').disable();
            }
        }
    };
</script>

