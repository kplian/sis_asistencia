<?php
class RHojaTiempo{
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
        $this->docexcel->getActiveSheet()->setTitle('Hoja De Tiempo');
        $this->docexcel->setActiveSheetIndex(0);

        $titulossubcabezera = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 9,
                'name'  => 'Arial'
            )
        );
        $centar = array('alignment' => array(
            'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
            'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
        ));
        $styleTitulos = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 9,
                'name'  => 'Arial',
                'color' => array(
                    'rgb' => 'FFF232'
                )
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => '062B61'
                )
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN,
                    'color' => array('rgb' => '062B61')
                )
            )
        );
        $styleSubTitulos = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 9,
                'name'  => 'Arial'
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => 'DCDCDC'
                )
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN,
                    'color' => array('rgb' => 'DCDCDC')
                )
            )
        );
        $datos = $this->objParam->getParametro('datos');
        $this->docexcel->getActiveSheet()->setCellValue('A1','PERIODO');
        $this->docexcel->getActiveSheet()->setCellValue('B1',$datos[0]['periodo'].'/'.$datos[0]['gestion']);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9,2,'HOJA DE TIEMPO');
        $this->docexcel->getActiveSheet()->getStyle('I2:J2')->applyFromArray($titulossubcabezera);
        $this->docexcel->getActiveSheet()->setCellValue('A2','CODIGO');
        $this->docexcel->getActiveSheet()->setCellValue('B2',$datos[0]['codigo']);
        $this->docexcel->getActiveSheet()->setCellValue('A3','NOMBRE');
        $this->docexcel->getActiveSheet()->setCellValue('B3',$datos[0]['nombre_funcionario']);
        $this->docexcel->getActiveSheet()->getStyle('A1:Q5')->applyFromArray($titulossubcabezera);
        $this->docexcel->getActiveSheet()->getStyle('A1:Q5')->applyFromArray($centar);
        $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(10);
        $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(10);
        $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(10);
        $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(10);
        $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(10);
        $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(10);
        $this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(10);
        $this->docexcel->getActiveSheet()->getColumnDimension('H')->setWidth(10);
        $this->docexcel->getActiveSheet()->getColumnDimension('I')->setWidth(10);
        $this->docexcel->getActiveSheet()->getColumnDimension('J')->setWidth(10);
        $this->docexcel->getActiveSheet()->getColumnDimension('K')->setWidth(10);
        $this->docexcel->getActiveSheet()->getColumnDimension('L')->setWidth(10);
        $this->docexcel->getActiveSheet()->getColumnDimension('M')->setWidth(10);
        $this->docexcel->getActiveSheet()->getColumnDimension('N')->setWidth(10);
        $this->docexcel->getActiveSheet()->getColumnDimension('O')->setWidth(10);
        $this->docexcel->getActiveSheet()->getColumnDimension('Q')->setWidth(10);

        $this->docexcel->getActiveSheet()->setCellValue('A4','D');
        $this->docexcel->getActiveSheet()->setCellValue('B4','HORARIO');
        $this->docexcel->getActiveSheet()->mergeCells('B4:G4');
        $this->docexcel->getActiveSheet()->setCellValue('H4','HORAS TRABAJADAS');
        $this->docexcel->getActiveSheet()->mergeCells('H4:K4');
        $this->docexcel->getActiveSheet()->setCellValue('L4','IMPUTACION CONTABLE');
        $this->docexcel->getActiveSheet()->mergeCells('L4:N4');
        $this->docexcel->getActiveSheet()->mergeCells('O4:Q4');
        $this->docexcel->getActiveSheet()->getStyle('A4:Q4')->applyFromArray($centar);
        $this->docexcel->getActiveSheet()->getStyle('A4:Q4')->applyFromArray($styleTitulos);
        $this->docexcel->getActiveSheet()->setCellValue('A5','I');
        $this->docexcel->getActiveSheet()->getStyle('A5')->applyFromArray($styleTitulos);
        $this->docexcel->getActiveSheet()->setCellValue('B5','Mañana');
        $this->docexcel->getActiveSheet()->mergeCells('B5:C5');
        $this->docexcel->getActiveSheet()->setCellValue('D5','Tarde');
        $this->docexcel->getActiveSheet()->mergeCells('D5:E5');
        $this->docexcel->getActiveSheet()->setCellValue('F5','Noche');
        $this->docexcel->getActiveSheet()->mergeCells('F5:G5');
        $this->docexcel->getActiveSheet()->setCellValue('A6','D');
        $this->docexcel->getActiveSheet()->getStyle('A6')->applyFromArray($styleTitulos);
        $this->docexcel->getActiveSheet()->setCellValue('B6','Ingreso');
        $this->docexcel->getActiveSheet()->setCellValue('C6','Salida');
        $this->docexcel->getActiveSheet()->setCellValue('D6','Ingreso');
        $this->docexcel->getActiveSheet()->setCellValue('E6','Salida');
        $this->docexcel->getActiveSheet()->setCellValue('F6','Ingreso');
        $this->docexcel->getActiveSheet()->setCellValue('G6','Salida');
        $this->docexcel->getActiveSheet()->setCellValue('H5','COMP');
        $this->docexcel->getActiveSheet()->mergeCells('H5:H6');
        $this->docexcel->getActiveSheet()->setCellValue('I5','Normales');
        $this->docexcel->getActiveSheet()->mergeCells('I5:I6');
        $this->docexcel->getActiveSheet()->setCellValue('J5','Extras');
        $this->docexcel->getActiveSheet()->mergeCells('J5:J6');
        $this->docexcel->getActiveSheet()->setCellValue('K5','Noct.');
        $this->docexcel->getActiveSheet()->mergeCells('K5:K6');
        $this->docexcel->getActiveSheet()->setCellValue('L5','Centro Costo');
        $this->docexcel->getActiveSheet()->mergeCells('L5:M6');
        $this->docexcel->getActiveSheet()->setCellValue('N5','Extras Autorizadas');
        $this->docexcel->getActiveSheet()->mergeCells('N5:O6');
        $this->docexcel->getActiveSheet()->setCellValue('P5','Justificación Extras');
        $this->docexcel->getActiveSheet()->mergeCells('P5:Q6');
        $this->docexcel->getActiveSheet()->getStyle('B5:Q5')->applyFromArray($styleSubTitulos);
        $this->docexcel->getActiveSheet()->getStyle('B6:Q6')->applyFromArray($styleSubTitulos);

    }
    function generarDatos(){
        $this->imprimeCabecera();
        $styleTitulos = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 9,
                'name'  => 'Arial',
                'color' => array(
                    'rgb' => 'FCFCFC'
                )
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => '062B61'
                )
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN,
                    'color' => array('rgb' => '062B61')
                )
            )
        );
        $styleTitulosI = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 9,
                'name'  => 'Arial',
                'color' => array(
                    'rgb' => 'FFF232'
                )
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => '062B61'
                )
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN,
                    'color' => array('rgb' => '062B61')
                )
            )
        );

        $style = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 9,
                'name'  => 'Arial'
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => 'DCDCDC'
                )
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN,
                    'color' => array('rgb' => 'DCDCDC')
                )
            )
        );

        $styleSubTitulos = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 9,
                'name'  => 'Arial'
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER
            ),
            'fill' => array(
                'type' => PHPExcel_Style_Fill::FILL_SOLID,
                'color' => array(
                    'rgb' => 'DCDCDC'
                )
            ),
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN,
                    'color' => array('rgb' => 'DCDCDC')
                )
            )
        );
        $border = array(
            'borders' => array(
                'vertical' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            )
        );
        $styleArrayCell = array(
            'font' => array(
                'name' => 'Arial',
                'size' => '8',
            ),
            'borders' => array(
                'left' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN,
                ),
                'right' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN,
                ),
                'bottom' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN,
                ),
                'top' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN,
                ),
            ),
        );
        $datos = $this->objParam->getParametro('datos');
        //var_dump($datos);exit;
        $fila = 7;
        $sumaTorales = 0;
        $sumaExtras = 0;
        $sumaNocturnas = 0;
        $sumaAutorizadas = 0;
        foreach ($datos as $value){
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $value['dia']);
            $this->docexcel->getActiveSheet()->getStyle("A$fila")->applyFromArray($styleTitulos);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['ingreso_manana']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['salida_manana']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, $value['ingreso_tarde']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, $value['salida_tarde']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, $value['ingreso_noche']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, $value['salida_noche']);

            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fila, $value['total_normal']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fila, $value['total_extra']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10, $fila, $value['total_nocturna']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11, $fila, $value['codigo_tcc']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(13, $fila, $value['extra_autorizada']);
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(15, $fila, $value['justificacion_extra']);
            $this->docexcel->getActiveSheet()->mergeCells("L$fila:M$fila");
            $this->docexcel->getActiveSheet()->mergeCells("N$fila:O$fila");
            $this->docexcel->getActiveSheet()->mergeCells("P$fila:Q$fila");
            $this->docexcel->getActiveSheet()->getStyle("B$fila:R$fila")->applyFromArray($border);

            $fila ++;
            $this->fill = $fila;
            $sumaTorales = $sumaTorales + $value['total_normal'];
            $sumaExtras = $sumaExtras + $value['total_extra'];
            $sumaNocturnas = $sumaNocturnas + $value['total_nocturna'];
            $sumaAutorizadas = $sumaAutorizadas + $value['extra_autorizada'] ;
        }

        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,  $this->fill, 'Totales');
        $this->docexcel->getActiveSheet()->getStyle("A$this->fill")->applyFromArray($styleTitulosI);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $this->fill,$sumaTorales);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $this->fill,$sumaExtras);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10,$this->fill,$sumaNocturnas);
        $this->docexcel->getActiveSheet()->getStyle("I$this->fill:K$this->fill")->applyFromArray($styleTitulos);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(14, $this->fill, $sumaAutorizadas);
        $this->docexcel->getActiveSheet()->getStyle("O$this->fill")->applyFromArray($styleTitulosI);
        $this->docexcel->getActiveSheet()->getStyle("Q$this->fill:R$this->fill")->applyFromArray($border);
        $this->docexcel->getActiveSheet()->getStyle("B$this->fill:Q$this->fill")->applyFromArray($styleArrayCell);

        $fill = $this->fill + 1;
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fill,'Total Hrs.');
        $this->docexcel->getActiveSheet()->getStyle("A$fill")->applyFromArray($styleTitulosI);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fill,$sumaTorales);
        $this->docexcel->getActiveSheet()->getStyle("B$fill")->applyFromArray($styleTitulos);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(11, $fill,'Centro Costo');
        $this->docexcel->getActiveSheet()->mergeCells("L$fill:M$fill");
        $this->docexcel->getActiveSheet()->getStyle("L$fill:M$fill")->applyFromArray($style);
        $this->docexcel->getActiveSheet()->getStyle("Q$fill:R$fill")->applyFromArray($border);
        $fil = $this->fill + 2;
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,$fil,'Cálc. de hrs extras y rec noct en periodo de vacación/Recon turno cerrado:');
        $this->docexcel->getActiveSheet()->mergeCells("A$fil:I$fil");
        $this->docexcel->getActiveSheet()->getStyle("A$fil:I$fil")->applyFromArray($styleTitulosI);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fil,$sumaNocturnas);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10,$fil,$sumaNocturnas);
        $this->docexcel->getActiveSheet()->getStyle("J$fil:K$fil")->applyFromArray($styleTitulos);
        $this->docexcel->getActiveSheet()->getStyle("L$fil:Q$fil")->applyFromArray($styleTitulosI);

        $fjp = $this->fill + 3;
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5,$fjp,'Totales finales:');
        $this->docexcel->getActiveSheet()->mergeCells("F$fjp:G$fjp");
        $this->docexcel->getActiveSheet()->getStyle("F$fjp:G$fjp")->applyFromArray($styleTitulosI);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fjp,0);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fjp,$sumaTorales);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fjp,$sumaExtras);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10,$fjp,$sumaNocturnas);
        $this->docexcel->getActiveSheet()->getStyle("H$fjp:K$fjp")->applyFromArray($styleTitulos);

        $fj = $this->fill + 4;
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(7, $fj,'COMP');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(8, $fj,'Normales');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(9, $fj,'Extras');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(10,$fj,'Noct.');
        $this->docexcel->getActiveSheet()->getStyle("H$fj:K$fj")->applyFromArray($styleSubTitulos);



    }
    function generarReporte(){
        $this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
        $this->objWriter->save($this->url_archivo);

    }

}
?>

