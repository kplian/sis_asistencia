<?php
/**
 *@package pXP
 *@file RMarcacionFunc
 *@author  SAZP
 *@date 19-08-2019 15:28:39
 *@reporte marcacion de un funcionario 
 * HISTORIAL DE MODIFICACIONES:

 */
class RMarcadoGral{
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

        //modificacionw
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,2,'REPORTE DE ACCESO GENERAL' );
        $this->docexcel->getActiveSheet()->getStyle('A2:L2')->applyFromArray($tituloscabezera);
        $this->docexcel->getActiveSheet()->mergeCells('A2:L2');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3,3,'Desde: '.$this->objParam->getParametro('fecha_ini'));
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5,3,'Hasta: '.$this->objParam->getParametro('fecha_fin'));
        //$this->docexcel->getActiveSheet()->getStyle('A3:L3')->applyFromArray($titulossubcabezera);
        //$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3,4,($this->objParam->getParametro('modo_verif') == '' ) ? 'Modo Verificación: Todos' : 'Modo Verificación: '.$this->objParam->getParametro('modo_verif'));
        //$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4,4,'Agrupar Por: '.$this->objParam->getParametro('agrupar_por'));
        //$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5,4,($this->objParam->getParametro('eventodesc') == '' ) ? 'Evento: Todos' : 'Evento: '.$this->objParam->getParametro('eventodesc'));
        //$this->docexcel->getActiveSheet()->getStyle('A4:L4')->applyFromArray($titulossubcabezera);
        $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(35);
        $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(45);
        $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(15);
		$this->docexcel->getActiveSheet()->getColumnDimension('I')->setWidth(15);
		$this->docexcel->getActiveSheet()->getColumnDimension('J')->setWidth(15);
		$this->docexcel->getActiveSheet()->getColumnDimension('K')->setWidth(15);
		$this->docexcel->getActiveSheet()->getColumnDimension('L')->setWidth(15);
        $this->docexcel->getActiveSheet()->setCellValue('A6','Fechaº');
        $this->docexcel->getActiveSheet()->setCellValue('B6','Empresa');
        $this->docexcel->getActiveSheet()->setCellValue('C6','Area');
        $this->docexcel->getActiveSheet()->setCellValue('D6','Funcionario');
        $this->docexcel->getActiveSheet()->setCellValue('E6','Hra. entrada mañana');
        $this->docexcel->getActiveSheet()->setCellValue('F6','Hra. salida mañana');
		$this->docexcel->getActiveSheet()->setCellValue('G6','Total Mañana');
        $this->docexcel->getActiveSheet()->setCellValue('H6','Hra. entrada tarde');
        $this->docexcel->getActiveSheet()->setCellValue('I6','Hra. salida tarde');
		$this->docexcel->getActiveSheet()->setCellValue('J6','Total Tarde');
		$this->docexcel->getActiveSheet()->setCellValue('K6','Total Dia');
		$this->docexcel->getActiveSheet()->setCellValue('L6','Diferencia');

        $this->docexcel->getActiveSheet()->getStyle('A6:L6')->getAlignment()->setWrapText(true);
        $this->docexcel->getActiveSheet()->getStyle('A6:L6')->applyFromArray($styleTitulos3);

    }
	/*
	function obtenerDetalle ($det){
		$detalle = explode("|", $det); 
		return $detalle;
	}
	*/
	
	function RestarHoras($horaini,$horafin){
		if (($horaini <> "") && ($horafin <> "")){
			$f1 = new DateTime($horaini);
			$f2 = new DateTime($horafin);
			
			$d = $f1->diff($f2);
			return $d->format('%H:%I:%S');
		}
	}
//******************************
    function suma_horas($hora1,$hora2){
		if (($horaini <> "") && ($horafin <> "")){
			$hora1=explode(":",$hora1);
			$hora2=explode(":",$hora2);
			$temp=0;
		 
			//sumo segundos 
			$segundos=(int)$hora1[2]+(int)$hora2[2];
			while($segundos>=60){
				$segundos=$segundos-60;
				$temp++;
			}
			//sumo minutos 
			$minutos=(int)$hora1[1]+(int)$hora2[1]+$temp;
			$temp=0;
			while($minutos>=60){
				$minutos=$minutos-60;
				$temp++;
			}
			//sumo horas 
			$horas=(int)$hora1[0]+(int)$hora2[0]+$temp;
		 
			if($horas<10)
				$horas= '0'.$horas;
		 
			if($minutos<10)
				$minutos= '0'.$minutos;
		 
			if($segundos<10)
				$segundos= '0'.$segundos;
		 
			$sum_hrs = $horas.':'.$minutos.':'.$segundos;
		 
			return ($sum_hrs);
		}
    }

//**************

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
        $this->numero = 1;
        $fila = 7;
        $datos = $this->objParam->getParametro('datos');
        $gerencias = '';
        $departamento = '';
		$sumhoras = 0.0;
        foreach ($datos as $value) {
			// var_dump(explode ("|", $value['detalles'][0]));exit;
			$vector = explode ("|", $value['detalles']);
			//var_dump((float)($this->RestarHoras($value['hra1'],$value['hra2']) + 1));//exit;
			$sumhoras = $this->suma_horas($this->RestarHoras($value['hra1'],$value['hra2']), $this->RestarHoras($value['hra4'],$value['hra3']));
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $vector[0]);
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, 'ETR');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $vector[2]);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, $vector[1]);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, $value['hra1']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, $value['hra2']);
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, $this->RestarHoras($value['hra1'],$value['hra2'])); //**
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fila, $value['hra3']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila, $value['hra4']);
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila, $this->RestarHoras($value['hra4'],$value['hra3'])); //**
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10, $fila, $sumhoras); //**
			$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11, $fila, $this->RestarHoras('8:00:00',$sumhoras));
			//$this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11, $fila, $this->RestarHoras($sumhoras,'8:00:00'));
            $this->docexcel->getActiveSheet()->getStyle("A$fila:I$fila")->applyFromArray($border);
            $this->docexcel->getActiveSheet()->getStyle("A$fila:C$fila")->applyFromArray($style3);
            $this->docexcel->getActiveSheet()->getStyle("H$fila:H$fila")->applyFromArray($style3);
            $fila++;
            $this->numero++; 
        }
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
    function imprimeSubtitulo($fila, $valor,$tamanhio) {
        $styleTitulos = array(
            'font'  => array(
                'bold'  => true,
                'size'  => $tamanhio,             #16
                'name'  => 'Arial'
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            )
            );
        $this->docexcel->getActiveSheet()->mergeCells("A$fila:H$fila");
        $this->docexcel->getActiveSheet()->getStyle("A$fila:H$fila")->applyFromArray($styleTitulos);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $valor);

    }
    function generarReporte(){
        $this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
        $this->objWriter->save($this->url_archivo);

    }

}
?>

