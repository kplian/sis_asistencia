<?php
/**
 *@package pXP
 *@file RegistrarLicencia.php
 *@author  (mgarcia)
 *@date 24-09-2019 16:53:42
 *@description permites registrar licencias
 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.RegistrarLicencia=Ext.extend(Phx.frmInterfaz,{

            constructor:function(config) {
                this.maestro = config;
                //llama al constructor de la clase padre
                Phx.vista.RegistrarLicencia.superclass.constructor.call(this,config);
                this.init();
                // this.loadValoresIniciales();
            },
            loadValoresIniciales:function() {
                Phx.vista.RegistrarLicencia.superclass.loadValoresIniciales.call(this);
                this.Cmp.fecha_solicitud.setValue(new Date());
                this.Cmp.fecha_solicitud.fireEvent('change');
                /*
                this.ocultarComponente(this.Cmp.hro_desde);
                this.ocultarComponente(this.Cmp.hro_hasta);
                this.Cmp.id_tipo_permiso.on('select', function(combo, record, index){

                    if (record.data.asignar_rango === 'si'){
                        this.mostrarComponente(this.Cmp.hro_desde);
                        this.mostrarComponente(this.Cmp.hro_hasta);
                    }
                    if (record.data.asignar_rango === 'no'){
                        this.ocultarComponente(this.Cmp.hro_desde);
                        this.ocultarComponente(this.Cmp.hro_hasta);
                    }
                },this);
                this.Cmp.hro_desde.on('select', function(combo, record, index){
                    console.log(record.data.field1)
                },this);
                this.Cmp.hro_hasta.on('select', function(combo, record, index){
                    console.log(record.data.field1);
                    this.calcularDiferenciaHora(this.Cmp.hro_desde.getValue(),record.data.field1);
                },this);
                this.getComponente('id_correspondencia').setValue(this.id_correspondencia);
                this.argumentExtraSubmit.version = this.version;
                this.argumentExtraSubmit.id_gestion = this.id_gestion;
                this.argumentExtraSubmit.numero = this.numero;
                this.getComponente('numeroCorres').setValue(this.numero);*/
            },
            successSave:function(resp){
                Phx.CP.loadingHide();
                Phx.CP.getPagina(this.idContenedorPadre).reload();
                this.panel.close();
            },
            Atributos:[
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_pares'
                    },
                    type:'Field',
                    form:true
                },
                {
                    //configuracion del componente
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_funcionario'
                    },
                    type:'Field',
                    form:true
                },
                {
                    config : {
                        name : 'evento',
                        fieldLabel : 'Evento',
                        emptyText : 'Seleccione Opcion...',
                        width : 250,
                        mode : 'local',
                        store : new Ext.data.ArrayStore({
                            fields : ['ID', 'valor'],
                            data : [
                                    ['0', 'Justificar'],
                                    ['1', 'Permiso'],
                                    ['2', 'Vacacion']
                            ]
                        }),
                        triggerAction : 'all',
                        valueField : 'ID',
                        displayField : 'valor'

                    },
                    type : 'ComboBox',
                    id_grupo : 2,
                    form : true
                },
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
                {
                    config:{
                        name: 'motivo',
                        fieldLabel: 'Motivo',
                        allowBlank: false,
                        width: 300,
                        gwidth: 300
                    },
                    type:'TextArea',
                    filters:{pfiltro:'pmo.motivo',type:'string'},
                    id_grupo:1,
                    grid:true,
                    form:true
                }
            ],
            tam_pag:50,
            title:'Permiso',
            ActSave:'../../sis_asistencia/control/Permiso/insertarPermiso',
            fields: [
                
            ],
            fwidth: '45%',
            fheight: '45%'
        }
    )

</script>