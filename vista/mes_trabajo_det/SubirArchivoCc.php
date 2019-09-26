<?php
/**
 *@package pXP
 *@file gen-SubirArchivoCc.php
 *@author  (miguel.mamani)
 *@date 31-01-2019 16:36:51
 * HISTORIAL DE MODIFICACIONES:
 * #ISSUE				FECHA				AUTOR				DESCRIPCION
 * #18	ERT			26/09/2019 				 MMV			Modificar centros de costo

 */
header("content-type: text/javascript; charset=UTF-8");
?>
<script>
    Phx.vista.SubirArchivoCc=Ext.extend(Phx.frmInterfaz,{

            ActSave:'../../sis_asistencia/control/MesTrabajoDet/subirArchivoExcelCc',
            constructor:function(config) {
                Phx.vista.SubirArchivoCc.superclass.constructor.call(this,config);
                this.init();
                this.loadValoresIniciales();
            },

            loadValoresIniciales:function() {
                Phx.vista.SubirArchivoCc.superclass.loadValoresIniciales.call(this);
                this.getComponente('id_gestion').setValue(this.id_gestion);
                this.getComponente('id_mes_trabajo').setValue(this.id_mes_trabajo);
                this.getComponente('desc_codigo').setValue(this.desc_codigo);
                this.getComponente('periodo').setValue(this.periodo);
                this.getComponente('gestion').setValue(this.gestion);
            },

            successSave:function(resp) {
                Phx.CP.loadingHide();
                Phx.CP.getPagina(this.idContenedorPadre).reload();
                this.panel.close();
            },


            Atributos:[
                {
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_gestion'
                    },
                    type:'Field',
                    form:true
                },
                {
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'id_mes_trabajo'
                    },
                    type:'Field',
                    form:true
                },
                {
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'desc_codigo'
                    },
                    type:'Field',
                    form:true
                },
                {
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'periodo'
                    },
                    type:'Field',
                    form:true
                },
                {
                    config:{
                        labelSeparator:'',
                        inputType:'hidden',
                        name: 'gestion'
                    },
                    type:'Field',
                    form:true
                },
                {
                    config:{
                        fieldLabel: "Documento (archivo Excel Cc)",
                        gwidth: 130,
                        inputType: 'file',
                        name: 'archivo',
                        allowBlank: false,
                        buttonText: '',
                        maxLength: 150,
                        anchor:'100%'
                    },
                    type:'Field',
                    form:true
                }
            ],
            title:'Subir Archivo',
            fileUpload:true,


        }
    )
</script>
