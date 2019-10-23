<?php
/**
 *@package pXP
 *@file RMarcacionFunc
 *@author  SAZP
 *@date 19-08-2019 15:28:39
 *@reporte marcacion de un funcionario 
 * HISTORIAL DE MODIFICACIONES:
 
 
 * este es el original 

 */
class RTusMarcados{
    private $docexcel;
    private $objWriter;
    public $fila_aux = 0;
    private $equivalencias=array();
    private $objParam;
    public  $url_archivo;
    private $fill = 0;
    function __construct(CTParametro $objParam)
    {
        $this->objParam = $objParam;
        $this->url_archivo = "../../../reportes_generados/".$this->objParam->getParametro('nombre_archivo');
        set_time_limit(400);
        $cacheMethod = PHPExcel_CachedObjectStorageFactory:: cache_to_phpTemp;
        $cacheSettings = array('memoryCacheSize'  => '10MB');
        PHPExcel_Settings::setCacheStorageMethod($cacheMethod, $cacheSettings);

        $this->docexcel = new PHPExcel();
        $this->docexcel->getProperties()->setCreator("PXP")
            ->setLastModifiedBy("PXP")
            ->setTitle($this->objParam->getParametro('titulo_archivo'))
            ->setSubject($this->objParam->getParametro('titulo_archivo'))
            ->setDescription('Reporte "'.$this->objParam->getParametro('titulo_archivo').'", generado por el framework PXP')
            ->setKeywords("office 2007 openxml php")
            ->setCategory("Report File");
        $this->equivalencias=array( 0=>'A',1=>'B',2=>'C',3=>'D',4=>'E',5=>'F',6=>'G',7=>'H',8=>'I',
            9=>'J',10=>'K',11=>'L',12=>'M',13=>'N',14=>'O',15=>'P',16=>'Q',17=>'R',
            18=>'S',19=>'T',20=>'U',21=>'V',22=>'W',23=>'X',24=>'Y',25=>'Z',
            26=>'AA',27=>'AB',28=>'AC',29=>'AD',30=>'AE',31=>'AF',32=>'AG',33=>'AH',
            34=>'AI',35=>'AJ',36=>'AK',37=>'AL',38=>'AM',39=>'AN',40=>'AO',41=>'AP',
            42=>'AQ',43=>'AR',44=>'AS',45=>'AT',46=>'AU',47=>'AV',48=>'AW',49=>'AX',
            50=>'AY',51=>'AZ',
            52=>'BA',53=>'BB',54=>'BC',55=>'BD',56=>'BE',57=>'BF',58=>'BG',59=>'BH',
            60=>'BI',61=>'BJ',62=>'BK',63=>'BL',64=>'BM',65=>'BN',66=>'BO',67=>'BP',
            68=>'BQ',69=>'BR',70=>'BS',71=>'BT',72=>'BU',73=>'BV',74=>'BW',75=>'BX',
            76=>'BY',77=>'BZ');
    }

    function imprimeCabecera() {
        $this->docexcel->createSheet();
        $this->docexcel->getActiveSheet()->setTitle('transacciones');
        $this->docexcel->setActiveSheetIndex(0);
		
		$objDrawing = new PHPExcel_Worksheet_Drawing(); 
		$objDrawing->setName('test_img'); 
		$objDrawing->setDescription('test_img'); 
		$objDrawing->setPath(dirname(__FILE__) . '/../../pxp/lib' . $_SESSION['_DIR_LOGO']); 
		$objDrawing->setCoordinates('A1'); //setOffsetX works properly 
		$objDrawing->setOffsetX(5); 
		$objDrawing->setOffsetY(5); //set width, height 
		$objDrawing->setWidth(250); 
		$objDrawing->setHeight(87); 
		$objDrawing->setWorksheet($this->docexcel->getActiveSheet()); 

        $tituloscabezera = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 12,
                'name'  => 'Arial'
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER
            )
        );
        $titulossubcabezera = array(
            'font'  => array(
                'bold'  => true, 
                'size'  => 10,
                'name'  => 'Arial'
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER
            )
        );

        $styleTitulos3 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 10,
                'name'  => 'Arial',
                'color' => array(
                    'rgb' => 'FFFFFF'
                )
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => '000000'
                )
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN,
                    'color' => array('rgb' => 'AAAAAA')
                )
            )
        );
		
		$styleTitulos4 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 12,
                'name'  => 'Arial'
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER
            )
        );

        //modificacionw
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,2,'REPORTE DE MARCACION FUNCIONARIO' );
        $this->docexcel->getActiveSheet()->getStyle('A2:L2')->applyFromArray($tituloscabezera);
        $this->docexcel->getActiveSheet()->mergeCells('A2:L2');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3,3,'Funcionario: '.$this->objParam->getParametro('datos')[0]['nombre']);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5,3,'Periodo: '.$this->objParam->getParametro('id_periodo'));
        //$this->docexcel->getActiveSheet()->getStyle('A3:H3')->applyFromArray($titulossubcabezera);
        //$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3,4,($this->objParam->getParametro('modo_verif') == '' ) ? 'Modo Verificación: Todos' : 'Modo Verificación: '.$this->objParam->getParametro('modo_verif'));
        //$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4,4,'Agrupar Por: '.$this->objParam->getParametro('agrupar_por'));
        //$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5,4,($this->objParam->getParametro('eventodesc') == '' ) ? 'Evento: Todos' : 'Evento: '.$this->objParam->getParametro('eventodesc'));
        $this->docexcel->getActiveSheet()->getStyle('A3:L3')->applyFromArray($titulossubcabezera);
        $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(8);
        $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(10);
        $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(12);
        $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(35);
        $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(25);
		$this->docexcel->getActiveSheet()->getColumnDimension('I')->setWidth(15);
		$this->docexcel->getActiveSheet()->getColumnDimension('J')->setWidth(10);
		$this->docexcel->getActiveSheet()->getColumnDimension('K')->setWidth(10);
		$this->docexcel->getActiveSheet()->getColumnDimension('L')->setWidth(25);
		
        $this->docexcel->getActiveSheet()->setCellValue('A6','Diaº');
        $this->docexcel->getActiveSheet()->setCellValue('B6','Hora');
        $this->docexcel->getActiveSheet()->setCellValue('C6','Evento');
        $this->docexcel->getActiveSheet()->setCellValue('D6','Tipo verificacion');
        $this->docexcel->getActiveSheet()->setCellValue('E6','Acceso');
        $this->docexcel->getActiveSheet()->setCellValue('F6','Rango');
        $this->docexcel->getActiveSheet()->setCellValue('G6','Area');
        $this->docexcel->getActiveSheet()->setCellValue('H6','Obs.');
		$this->docexcel->getActiveSheet()->setCellValue('I6','Fecha Marcado');
		$this->docexcel->getActiveSheet()->setCellValue('J6','Estado Reg.');
		$this->docexcel->getActiveSheet()->setCellValue('K6','Creado por');
		$this->docexcel->getActiveSheet()->setCellValue('L6','Fecha creacion');
		
		
		

        $this->docexcel->getActiveSheet()->getStyle('A6:L6')->getAlignment()->setWrapText(true);
        $this->docexcel->getActiveSheet()->getStyle('A6:L6')->applyFromArray($styleTitulos3);

    }
    function generarDatos(){
        $this->imprimeCabecera();
        $border = array(
            'borders' => array(
                'vertical' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            )
        );
        $style3 = array(
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
        );
		$style4 = array(
            'alignment' => array(
                //'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
				'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
        );
        $this->numero = 1;
		$fini = 1;
        $fila = 7;
        $datos = $this->objParam->getParametro('datos');
		$fechaanterior = '';

		//$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, 'Fecha Marcado: '.$value['fecha_marcado']);

        foreach ($datos as $value) {
			//var_dump($contadia, $value['dia'], $value['hora'], $primero);
			if ($value['fecha_marcado'] != $fechaanterior) {
                $this->imprimeSubtitulo($fila,$value['fecha_marcado']);
                $fechaanterior = $value['fecha_marcado'];
				$fila++;
				$fini = $fila;
            }
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $value['dia']);
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['hora']);
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['evento']);
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, $value['tipo_verificacion']);
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, $value['acceso']);              
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, $value['rango']);
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, $value['area']);
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila, $value['obs']);
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila, $value['fecha_marcado']);
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila, $value['estado_reg']);
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10, $fila, $value['id_usuario_reg']);
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11, $fila, $value['fecha_reg']);
			
			$this->docexcel->getActiveSheet()->getStyle("A$fila:M$fila")->applyFromArray($border);
			$this->docexcel->getActiveSheet()->getStyle("A$fila:L$fila")->applyFromArray($style3);
			//$this->docexcel->getActiveSheet()->getStyle("H$fila:H$fila")->applyFromArray($style3);

			$this->docexcel->getActiveSheet()->getStyle("A$fini:A$fila")->applyFromArray($style4);
			$this->docexcel->getActiveSheet()->mergeCells("A$fini:A$fila");


			$fila++;
			//$this->numero++;

        }
    }

    function imprimeSubtitulo($fila, $valor) {
        $styleTitulos = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 12,
                'name'  => 'Arial'
            ));

        $this->docexcel->getActiveSheet()->getStyle("A$fila:A$fila")->applyFromArray($styleTitulos);
		$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, 'Fecha Marcado: '.$valor);
        //$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $valor);

    }	
	
    function eliminar_tildes($cadena){

        //Codificamos la cadena en formato utf8 en caso de que nos de errores
        $cadena = utf8_encode($cadena);

        //Ahora reemplazamos las letras
        $cadena = str_replace(
            array('á', 'à', 'ä', 'â', 'ª', 'Á', 'À', 'Â', 'Ä'),
            array('a', 'a', 'a', 'a', 'a', 'A', 'A', 'A', 'A'),
            $cadena
        );

        $cadena = str_replace(
            array('é', 'è', 'ë', 'ê', 'É', 'È', 'Ê', 'Ë'),
            array('e', 'e', 'e', 'e', 'E', 'E', 'E', 'E'),
            $cadena );

        $cadena = str_replace(
            array('í', 'ì', 'ï', 'î', 'Í', 'Ì', 'Ï', 'Î'),
            array('i', 'i', 'i', 'i', 'I', 'I', 'I', 'I'),
            $cadena );

        $cadena = str_replace(
            array('ó', 'ò', 'ö', 'ô', 'Ó', 'Ò', 'Ö', 'Ô'),
            array('o', 'o', 'o', 'o', 'O', 'O', 'O', 'O'),
            $cadena );

        $cadena = str_replace(
            array('ú', 'ù', 'ü', 'û', 'Ú', 'Ù', 'Û', 'Ü'),
            array('u', 'u', 'u', 'u', 'U', 'U', 'U', 'U'),
            $cadena );

        $cadena = str_replace(
            array('ñ', 'Ñ', 'ç', 'Ç'),
            array('n', 'N', 'c', 'C'),
            $cadena
        );

        return $cadena;
    }

    function generarReporte(){
        $this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
        $this->objWriter->save($this->url_archivo);

    }

}
?>

