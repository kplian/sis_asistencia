<?php
/**
 *@package pXP
 *@file MesTrabajoDetExtra.php
 *@author  MAM
 *@date 27-12-2016 14:45
 *@Interface para el inicio de solicitudes de materiales
 */
header("content-type: text/javascript; charset=UTF-8");
?>

<script>
    Phx.vista.MesTrabajoDetExtra = {
        bedit:false,
        bnew:false,
        bsave:false,
        bdel:false,
        require:'../../../sis_asistencia/vista/mes_trabajo_det/MesTrabajoDet.php',
        requireclase:'Phx.vista.MesTrabajoDet',
        title:'Detalle Consulta',
        nombreVista: 'MesTrabajoDetExtra',

        id_proceso:null,
        id_estado:null,
        id_mes_trabajo:null,

        constructor: function(config) {
            this.idContenedor = config.idContenedor;
            this.maestro = config;
            console.log(this.maestro.data)
            this.id_proceso = this.maestro.data.id_proceso_wf;
            this.id_estado = this.maestro.data.id_estado_wf;
            this.id_mes_trabajo = this.maestro.data.id_mes_trabajo;
            this.Atributos.unshift({
                config: {
                    name: 'extra',
                    fieldLabel: 'Autorizar',
                    allowBlank: true,
                    anchor: '50%',
                    gwidth: 80,
                    maxLength: 3,
                    renderer: function (value, p, record, rowIndex, colIndex) {

                        if(record.data.estado_reg != 'summary'){
                                //check or un check row
                                var checked = '',
                                    momento = 'no';
                                if (value == 'si') {
                                    checked = 'checked';
                                }
                                return String.format('<div style="vertical-align:middle;text-align:center;"><input style="height:20px;width:20px;" type="checkbox"  {0}></div>', checked);
                        }
                    }
                },
                type: 'TextField',
                id_grupo: 0,
                grid: true,
                form: false
            });
            this.Atributos[this.getIndAtributo('ingreso_noche')].grid=false;
            this.Atributos[this.getIndAtributo('salida_noche')].grid=false;
            Phx.vista.MesTrabajoDetExtra.superclass.constructor.call(this,config);
            this.addButton('btnSig',{ grupo:[1],
                text:'Siguiente',
                iconCls: 'badelante',
                disabled:false,
                handler:this.fin_registro,
                tooltip: '<b>Siguiente</b><p>Pasa al siguiente estado</p>'});
            this.store.baseParams = {tipo_interfaz: this.nombreVista , id_mes_trabajo:this.id_mes_trabajo};

            this.load({params:{start:0, limit:this.tam_pag}});
            this.grid.addListener('cellclick', this.oncellclick,this); /// revisar

        },
        oncellclick : function(grid, rowIndex, columnIndex, e) {/// revisar
            const record = this.store.getAt(rowIndex),
                fieldName = grid.getColumnModel().getDataIndex(columnIndex); // Get field name
            if (fieldName == 'extra')
                this.autorizarHoras(record,fieldName);
        },
        autorizarHoras: function(record,name){
            Phx.CP.loadingShow();
            var d = record.data;
            Ext.Ajax.request({
                url:'../../sis_asistencia/control/MesTrabajoDet/autorizarHorasExtras',
                params:{ id_mes_trabajo_det: d.id_mes_trabajo_det},
                success: this.successRevision,
                failure: this.conexionFailure,
                timeout: this.timeout,
                scope: this
            });
            this.reload();
        },
        successRevision: function(resp){
            Phx.CP.loadingHide();
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
        },
        fin_registro: function(){

            this.objWizard = Phx.CP.loadWindows('../../../sis_workflow/vista/estado_wf/FormEstadoWf.php',
                'Estado de Wf',
                {
                    modal: true,
                    width: 700,
                    height: 450
                },
                {
                    data: {
                        id_estado_wf: this.id_estado,
                        id_proceso_wf: this.id_proceso
                    }
                }, this.idContenedor, 'FormEstadoWf',
                {
                    config: [{
                        event: 'beforesave',
                        delegate: this.onSaveWizard
                    }],
                    scope: this
                }
            );

        },
        onSaveWizard:function(wizard,resp){
            var reg = Ext.util.JSON.decode(Ext.util.Format.trim(resp.responseText));
            Phx.CP.loadingShow();
            Ext.Ajax.request({
                url:'../../sis_asistencia/control/MesTrabajo/siguienteEstado',
                params:{
                    id_proceso_wf_act:  resp.id_proceso_wf_act,
                    id_estado_wf_act:   resp.id_estado_wf_act,
                    id_tipo_estado:     resp.id_tipo_estado,
                    id_funcionario_wf:  resp.id_funcionario_wf,
                    id_depto_wf:        resp.id_depto_wf,
                    obs:                resp.obs,
                    json_procesos:      Ext.util.JSON.encode(resp.procesos)
                },
                success:this.successWizard,
                failure: this.conexionFailure,
                argument:{wizard:wizard},
                timeout:this.timeout,
                scope:this
            });
        },
        successWizard:function(resp){
            Phx.CP.loadingHide();
            resp.argument.wizard.panel.destroy();
            Phx.CP.getPagina(this.idContenedor).close();
            this.reload();
        }
    };
</script>

