<?php
/**
*@package pXP
*@file gen-ACTMesTrabajoDet.php
*@author  (miguel.mamani)
*@date 31-01-2019 16:36:51
 * HISTORIAL DE MODIFICACIONES:
 * #ISSUE				FECHA				AUTOR				DESCRIPCION
 * #4	ERT			17/06/2019 				 MMV			corrección bug botón subir excel
 * #11	ERT			23/07/2019 				 MMV			Validar colmna sin datos al subir excel
 * #12	ERT			21/08/2019 				 MMV			Nuevo campo COMP detalle hoja de trabajo
 * #18	ERT			26/09/2019 				 MMV			Modificar centros de costo
 * #19	ERT			26/09/2019 				 MMV			Validar Archivo de nombre HT
 */
include_once(dirname(__FILE__).'/../../lib/lib_general/ExcelInput.php');
class ACTMesTrabajoDet extends ACTbase{    
			
	function listarMesTrabajoDet(){
		$this->objParam->defecto('ordenacion','id_mes_trabajo_det');
		$this->objParam->defecto('dir_ordenacion','asc');
        if($this->objParam->getParametro('id_mes_trabajo') != '') {
            $this->objParam->addFiltro("mtd.id_mes_trabajo = " . $this->objParam->getParametro('id_mes_trabajo'));
        }
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODMesTrabajoDet','listarMesTrabajoDet');
		} else{
			$this->objFunc=$this->create('MODMesTrabajoDet');
			
			$this->res=$this->objFunc->listarMesTrabajoDet($this->objParam);
		}
        $temp = Array();
        $temp['total_comp'] = $this->res->extraData['suma_comp']; //#12
        $temp['total_normal'] = $this->res->extraData['suma_normal'];
        $temp['total_extra'] = $this->res->extraData['suma_extra'];
        $temp['total_nocturna'] = $this->res->extraData['suma_nocturna'];
        $temp['extra_autorizada'] = $this->res->extraData['suma_autorizada'];
        $temp['estado_reg'] = 'summary';
        $temp['id_mes_trabajo_det'] = 0;
        $this->res->total++;
        $this->res->addLastRecDatos($temp);
        $this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarMesTrabajoDet(){
		$this->objFunc=$this->create('MODMesTrabajoDet');	
		if($this->objParam->insertar('id_mes_trabajo_det')){
			$this->res=$this->objFunc->insertarMesTrabajoDet($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarMesTrabajoDet($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarMesTrabajoDet(){
			$this->objFunc=$this->create('MODMesTrabajoDet');	
		$this->res=$this->objFunc->eliminarMesTrabajoDet($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
    function subirArchivoExcel(){
        //validar extnsion del archivo
        if($this->objParam->getParametro('periodo') < 10){ //#19
            $mes = '0'.$this->objParam->getParametro('periodo');
        }else{
            $mes = $this->objParam->getParametro('periodo'); //19
        }
        $codigoPeriodoGestion = $this->objParam->getParametro('desc_codigo').'_'.$mes.$this->objParam->getParametro('gestion');

        $arregloFiles = $this->objParam->getArregloFiles();
        if ($arregloFiles['archivo']['name'] == "") {
            throw new Exception("El archivo no puede estar vacio");
        }
        $ext = pathinfo($arregloFiles['archivo']['name']);
        if($ext['filename'] != $codigoPeriodoGestion){
            throw new Exception("Verifica tu archivo  esta incorrecto (".$ext['filename'].") lo que tiene que subir es (".$codigoPeriodoGestion.")");
        }
        $extension = $ext['extension'];
        $error = 'no';
        $mensaje_completo = '';
        //validar errores unicos del archivo: existencia, copia y extension
        if(isset($arregloFiles['archivo']) && is_uploaded_file($arregloFiles['archivo']['tmp_name'])){

            if ($extension != 'xls' && $extension != 'XLS') {
                $mensaje_completo = "La extensión del archivo debe ser xlsx";
                $error = 'error_fatal';
            }
            //upload directory
            $upload_dir = "/tmp/";
            //create file name
            $file_path = $upload_dir . $arregloFiles['archivo']['name'];
            //move uploaded file to upload dir
            if (!move_uploaded_file($arregloFiles['archivo']['tmp_name'], $file_path)) {
                //error moving upload file
                $mensaje_completo = "Error al guardar el archivo csv en disco";
                $error = 'error_fatal';
            }
        }else {
            $mensaje_completo = "No se subio el archivo";
            $error = 'error_fatal';
        }
        //armar respuesta en error fatal
        if ($error == 'error_fatal') {

            $this->mensajeRes=new Mensaje();
            $this->mensajeRes->setMensaje('ERROR','ACTColumnaCalor.php',$mensaje_completo,
                $mensaje_completo,'control');
            //si no es error fatal proceso el archivo
        }else {
            $ubicacion = $file_path;

            $archivoExcel = new ExcelInput($ubicacion, "HT");
            $res = $archivoExcel->recuperarColumnasExcel();
            $arrayArchivo = $archivoExcel->leerColumnasArchivoExcel();
            $arra_excel_detalle = array();

            foreach ($arrayArchivo as $fila) {
                if($fila["total_nocturna"] == '=NocturnalHours(A11,B11,C11,F11,G11)'){
                    $noctruno = 0;
                }else{
                    $noctruno = $fila["total_nocturna"];
                }
                if($fila["dia"] != 'Totales'){
                    if ($fila["dia"] != 'Total Hrs.') {
                        if ($fila["dia"] != 'Cálc. de hrs extras y rec noct en periodo de vacación/Recon turno cerrado:') {
                            // jornada mañana #11
                            // Ingreos
                            if (preg_replace('/\s+/', '', (string)$fila["ingreso_manana"]) == null){
                                $entradaMm = '00:00';
                            }else{
                                $entradaMm = $fila["ingreso_manana"];
                            }
                            // Salida
                            if (preg_replace('/\s+/', '', (string)$fila["salida_manana"]) == null){
                                $salidaMm = '00:00';
                            }else{
                                $salidaMm = $fila["salida_manana"];
                            }

                            // jornada tarde
                            // Ingreos
                            if (preg_replace('/\s+/', '', (string)$fila["ingreso_tarde"]) == null){
                                $entradaTa = '00:00';
                            }else{
                                $entradaTa = $fila["ingreso_tarde"];
                            }
                            // Salida
                            if (preg_replace('/\s+/', '', (string)$fila["salida_tarde"]) == null){
                                $salidaTa = '00:00';
                            }else{
                                $salidaTa = $fila["salida_tarde"];
                            }
                            // jornada Noche
                            // Ingreos
                            if (preg_replace('/\s+/', '', (string)$fila["ingreso_noche"]) == null){
                                $entradaNo = '00:00';
                            }else{
                                $entradaNo = $fila["ingreso_noche"];
                            }
                            // Salida
                            if ( preg_replace('/\s+/', '', (string)$fila["salida_noche"]) == null){
                                $salidaNo = '00:00';
                            }else{
                                $salidaNo = $fila["salida_noche"];
                            }
                            $arra_excel_detalle[] = array(
                                "dia" => (string)$fila["dia"],
                                "ingreso_manana" => (string)$entradaMm,
                                "salida_manana" => (string)$salidaMm,
                                "ingreso_tarde" => (string)$entradaTa,
                                "salida_tarde" => (string)$salidaTa,
                                "ingreso_noche" => (string)$entradaNo,
                                "salida_noche" => (string)$salidaNo,
                                "comp" => (float)$fila["comp"],  //#12
                                "total_normal" => (float)$fila["total_normal"],
                                "total_extra" => (float)$fila["total_extra"],
                                "total_nocturna" => (float)$noctruno,
                                "codigo" => (string)$fila["codigo"],
                                "orden" => (string)$fila["orden"],
                                "pep" => (string)$fila["pep"],
                                "extras_autorizadas" => (float)$fila["extras_autorizadas"],
                                "justificacion_extra" => (string)$fila["justificacion_extras"]
                            );
                        }
                    }
                } //#11
            }
           // var_dump($arra_excel_detalle);exit;
            $json = json_encode($arra_excel_detalle);
            $this->objParam->addParametro('mes_trabajo_json',$json);
            $this->objFunc=$this->create('MODMesTrabajoDet');
            $this->res=$this->objFunc->insertarMesTrabajoSon($this->objParam);

        }
        //armar respuesta en caso de exito o error en algunas tuplas
        if ($error == 'error') {
            $this->mensajeRes=new Mensaje();
            $this->mensajeRes->setMensaje('ERROR','ACTPlanillaSigma.php','Ocurrieron los siguientes errores : ' . $mensaje_completo,
                $mensaje_completo,'control');
            $this->mensajeRes->imprimirRespuesta($this->mensajeRes->generarJson());
        } else if ($error == 'no') {
            $this->mensajeRes=new Mensaje();
            $this->mensajeRes->setMensaje('EXITO','ACTPlanillaSigma.php','El archivo fue ejecutado con éxito',
                'El archivo fue ejecutado con éxito','control');
            $this->res->imprimirRespuesta($this->res->generarJson());
        }

        //devolver respuesta

    }
    //#4
    function eliminarTotoMesTrabajoDet(){
        $this->objFunc=$this->create('MODMesTrabajoDet');
        $this->res=$this->objFunc->eliminarTotoMesTrabajoDet($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function subirArchivoExcelCc(){ //#18
        //validar extnsion del archivo
        if($this->objParam->getParametro('periodo') <= 9){
            $mes = '0'.$this->objParam->getParametro('periodo');
        }else{
            $mes = '0'.$this->objParam->getParametro('periodo');
        }
        $codigoPeriodoGestion = $this->objParam->getParametro('desc_codigo').'_'.$mes.$this->objParam->getParametro('gestion');

        $arregloFiles = $this->objParam->getArregloFiles();
        if ($arregloFiles['archivo']['name'] == "") {
            throw new Exception("El archivo no puede estar vacio");
        }
        $ext = pathinfo($arregloFiles['archivo']['name']);
        if($ext['filename'] != $codigoPeriodoGestion){
            throw new Exception("Verifica tu archivo  esta incorrecto (".$ext['filename'].") lo que tiene que subir es (".$codigoPeriodoGestion.")");
        }
        $extension = $ext['extension'];
        $error = 'no';
        $mensaje_completo = '';
        //validar errores unicos del archivo: existencia, copia y extension
        if(isset($arregloFiles['archivo']) && is_uploaded_file($arregloFiles['archivo']['tmp_name'])){

            if ($extension != 'xls' && $extension != 'XLS') {
                $mensaje_completo = "La extensión del archivo debe ser xlsx";
                $error = 'error_fatal';
            }
            //upload directory
            $upload_dir = "/tmp/";
            //create file name
            $file_path = $upload_dir . $arregloFiles['archivo']['name'];
            //move uploaded file to upload dir
            if (!move_uploaded_file($arregloFiles['archivo']['tmp_name'], $file_path)) {
                //error moving upload file
                $mensaje_completo = "Error al guardar el archivo csv en disco";
                $error = 'error_fatal';
            }
        }else {
            $mensaje_completo = "No se subio el archivo";
            $error = 'error_fatal';
        }
        //armar respuesta en error fatal
        if ($error == 'error_fatal') {

            $this->mensajeRes=new Mensaje();
            $this->mensajeRes->setMensaje('ERROR','ACTColumnaCalor.php',$mensaje_completo,
                $mensaje_completo,'control');
            //si no es error fatal proceso el archivo
        }else {
            $ubicacion = $file_path;

            $archivoExcel = new ExcelInput($ubicacion, "HT");
            $res = $archivoExcel->recuperarColumnasExcel();
            $arrayArchivo = $archivoExcel->leerColumnasArchivoExcel();
            $arra_excel_detalle = array();

            foreach ($arrayArchivo as $fila) {
                if($fila["dia"] != 'Totales') {
                    if ($fila["dia"] != 'Total Hrs.') {
                        if ($fila['comp'] > 0 ||
                            $fila['total_normal'] > 0 ||
                            $fila['total_extra'] > 0 ||
                            $fila['total_nocturna'] > 0 ||
                            $fila['extras_autorizadas'] > 0) {
                            if ($fila["total_nocturna"] == '=NocturnalHours(A11,B11,C11,F11,G11)') {
                                $noctruno = 0;
                            } else {
                                $noctruno = $fila["total_nocturna"];
                            }
                            // Ingreos
                            if (preg_replace('/\s+/', '', (string)$fila["ingreso_manana"]) == null) {
                                $entradaMm = '00:00';
                            } else {
                                $entradaMm = $fila["ingreso_manana"];
                            }
                            // Salida
                            if (preg_replace('/\s+/', '', (string)$fila["salida_manana"]) == null) {
                                $salidaMm = '00:00';
                            } else {
                                $salidaMm = $fila["salida_manana"];
                            }

                            // jornada tarde
                            // Ingreos
                            if (preg_replace('/\s+/', '', (string)$fila["ingreso_tarde"]) == null) {
                                $entradaTa = '00:00';
                            } else {
                                $entradaTa = $fila["ingreso_tarde"];
                            }
                            // Salida
                            if (preg_replace('/\s+/', '', (string)$fila["salida_tarde"]) == null) {
                                $salidaTa = '00:00';
                            } else {
                                $salidaTa = $fila["salida_tarde"];
                            }
                            // jornada Noche
                            // Ingreos
                            if (preg_replace('/\s+/', '', (string)$fila["ingreso_noche"]) == null) {
                                $entradaNo = '00:00';
                            } else {
                                $entradaNo = $fila["ingreso_noche"];
                            }
                            // Salida
                            if (preg_replace('/\s+/', '', (string)$fila["salida_noche"]) == null) {
                                $salidaNo = '00:00';
                            } else {
                                $salidaNo = $fila["salida_noche"];
                            }

                            $arra_excel_detalle[] = array(
                                "dia" => (string)$fila["dia"],
                                "ingreso_manana" => (string)$entradaMm,
                                "salida_manana" => (string)$salidaMm,
                                "ingreso_tarde" => (string)$entradaTa,
                                "salida_tarde" => (string)$salidaTa,
                                "ingreso_noche" => (string)$entradaNo,
                                "salida_noche" => (string)$salidaNo,
                                "comp" => (float)$fila["comp"],  //#12
                                "total_normal" => (float)$fila["total_normal"],
                                "total_extra" => (float)$fila["total_extra"],
                                "total_nocturna" => (float)$noctruno,
                                "codigo" => (string)$fila["codigo"],
                                "orden" => (string)$fila["orden"],
                                "pep" => (string)$fila["pep"],
                                "extras_autorizadas" => (float)$fila["extras_autorizadas"],
                                "justificacion_extra" => (string)$fila["justificacion_extras"]
                            );
                        }
                    }
                }
            }
            $json = json_encode($arra_excel_detalle);
            $this->objParam->addParametro('mes_trabajo_json',$json);
            $this->objFunc=$this->create('MODMesTrabajoDet');
            $this->res=$this->objFunc->validarCcJson($this->objParam);

        }
        //armar respuesta en caso de exito o error en algunas tuplas
        if ($error == 'error') {
            $this->mensajeRes=new Mensaje();
            $this->mensajeRes->setMensaje('ERROR','ACTPlanillaSigma.php','Ocurrieron los siguientes errores : ' . $mensaje_completo,
                $mensaje_completo,'control');
            $this->mensajeRes->imprimirRespuesta($this->mensajeRes->generarJson());
        } else if ($error == 'no') {
            $this->mensajeRes=new Mensaje();
            $this->mensajeRes->setMensaje('EXITO','ACTPlanillaSigma.php','El archivo fue ejecutado con éxito',
                'El archivo fue ejecutado con éxito','control');
            $this->res->imprimirRespuesta($this->res->generarJson());
        }

    }//#18

    }

?>