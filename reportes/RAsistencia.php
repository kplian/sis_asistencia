<?php
class RAsistencia{
    private $docexcel;
    private $objWriter;
    public  $fila_aux = 0;
    private $equivalencias = array();
    private $objParam;
    public  $url_archivo;
    private $resumen_general = array();
    private $resumen_gerecias = array();
    function __construct(CTParametro $objParam){
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
        $this->docexcel->getActiveSheet()->setTitle('Asistencia');
        $this->docexcel->setActiveSheetIndex(0);

        $styleTitulos2 = array(
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



        $this->imprimirTitulo();
        if ($this->objParam->getParametro('tipo') == 'General') {
            $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(20);
            $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(10);
            $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(45);
            $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(20);
            $this->docexcel->getActiveSheet()->getStyle('A5:D5')->getAlignment()->setWrapText(true);
            $this->docexcel->getActiveSheet()->getStyle('A5:D5')->applyFromArray($styleTitulos2);

            $this->docexcel->getActiveSheet()->setCellValue('A5', 'Codigo');
            $this->docexcel->getActiveSheet()->setCellValue('B5', 'Gerencia');
            $this->docexcel->getActiveSheet()->setCellValue('C5', 'Nombre');
            $this->docexcel->getActiveSheet()->setCellValue('D5', 'Observación');

        }
    }
    function generarDatos(){
        $this->imprimeCabecera();

        if ($this->objParam->getParametro('tipo') == 'General') {
            $style_center = array(
                'alignment' => array(
                    'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                    'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
                ),
            );
            $border = array(
                'borders' => array(
                    'allborders' => array(
                        'style' => PHPExcel_Style_Border::BORDER_THIN
                    )
                )
            );


            $ausente = array(
                'font'  => array(
                    'color' => array(
                        'rgb' => 'FA0808'
                    )
                )
            );

            $retraso= array(
                'font'  => array(
                    'color' => array(
                        'rgb' => 'A69128'
                    )
                )
            );
            $vacacion= array(
                'font'  => array(
                    'color' => array(
                        'rgb' => '0D89CE'
                    )
                )
            );
            $teletrabajo= array(
                'font'  => array(
                    'color' => array(
                        'rgb' => '0453B3'
                    )
                )
            );

            $arrayBuel = array(
                'font'  => array(
                    'bold'  => true
                ),
            );
            $bajaMedica= array(
                'font'  => array(
                    'color' => array(
                        'rgb' => '26CAC9'
                    )
                )
            );
            $viaticos= array(
                'font'  => array(
                    'color' => array(
                        'rgb' => '5D26CA'
                    )
                )
            );
            $datos = $this->objParam->getParametro('datos');
            // var_dump($datos);exit;
            $fila = 6;
            $gerencia = '';//$datos[0]['gerencia'];
            $departamento = '';
            $sheet = 1;
            foreach ($datos as $value) {
                if (!array_key_exists($value['evento'], $this->resumen_general)) {
                    $this->resumen_general[$value['evento']] = 1;
                } else {

                    $this->resumen_general[$value['evento']]++;
                }
                $this->resumen_general++;
                if (!array_key_exists($value['gerencia'], $this->resumen_gerecias) ||
                    !array_key_exists($value['evento'], $this->resumen_gerecias[$value['gerencia']])) {

                    $this->resumen_gerecias[$value['gerencia']][$value['evento']] = 1;
                } else {

                    $this->resumen_gerecias[$value['gerencia']][$value['evento']]++;
                }
                $this->resumen_gerecias++;

                if ($value['departamento'] != $departamento /*&& $value['departamento'] != $value['gerencia']*/) {
                    $this->imprimeSubtitulo($fila, $value['departamento']);
                    $departamento = $value['departamento'];
                    $fila++;
                }
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $value['codigo_funcionario']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['codigo']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['funcionario']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, $value['observacion']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, $value['cargo']);

                $this->docexcel->getActiveSheet()->getStyle("A$fila:B$fila")->applyFromArray($style_center);
                $this->docexcel->getActiveSheet()->getStyle("A$fila:D$fila")->applyFromArray($border);

                if($value['ausente'] == 'si'){
                    $this->docexcel->getActiveSheet()->getStyle("D$fila:D$fila")->applyFromArray($ausente);
                }
                if($value['retraso'] == 'si'){
                    $this->docexcel->getActiveSheet()->getStyle("D$fila:D$fila")->applyFromArray($retraso);
                }
                if($value['vacacion'] == 'si'){
                    $this->docexcel->getActiveSheet()->getStyle("D$fila:D$fila")->applyFromArray($vacacion);
                }
                if($value['teletrabajo'] == 'si'){
                    $this->docexcel->getActiveSheet()->getStyle("D$fila:D$fila")->applyFromArray($teletrabajo);
                }
                if($value['baje_medica'] == 'si'){
                    $this->docexcel->getActiveSheet()->getStyle("D$fila:D$fila")->applyFromArray($bajaMedica);
                }
                if($value['viatico'] == 'si'){
                    $this->docexcel->getActiveSheet()->getStyle("D$fila:D$fila")->applyFromArray($viaticos);
                }


                $this->docexcel->getActiveSheet()->getStyle("D$fila:D$fila")->applyFromArray($arrayBuel);
                $this->docexcel->getActiveSheet()->getStyle("D$fila:D$fila")->applyFromArray($style_center);

                $fila++;
            }
        }else{
            $datos = $this->objParam->getParametro('datos');
            foreach ($datos as $value) {
                if (!array_key_exists($value['evento'], $this->resumen_general)) {
                    $this->resumen_general[$value['evento']] = 1;
                } else {

                    $this->resumen_general[$value['evento']]++;
                }
                $this->resumen_general++;
                if (!array_key_exists($value['gerencia'], $this->resumen_gerecias) ||
                    !array_key_exists($value['evento'], $this->resumen_gerecias[$value['gerencia']])) {

                    $this->resumen_gerecias[$value['gerencia']][$value['evento']] = 1;
                } else {

                    $this->resumen_gerecias[$value['gerencia']][$value['evento']]++;
                }
                $this->resumen_gerecias++;
            }
            $styleTitulos = array(
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
                        'rgb' => '#69BFE1'
                    )
                ),
                'borders' => array(
                    'allborders' => array(
                        'style' => PHPExcel_Style_Border::BORDER_THIN
                    )
                ));
            $border = array(
                'borders' => array(
                    'allborders' => array(
                        'style' => PHPExcel_Style_Border::BORDER_THIN
                    )
                )
            );
            $style_totales = array('font'  => array(
                'bold'  => true,
                'size'  => 10,
                'name'  => 'Arial'
            ));
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,5,'Ofina Central');
            $this->docexcel->getActiveSheet()->getStyle('A5:A5')->applyFromArray($style_totales);

            $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(30);
            $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(22);
            $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(22);
            $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(22);

            $this->docexcel->getActiveSheet()->getStyle('A6:D6')->getAlignment()->setWrapText(true);
            $this->docexcel->getActiveSheet()->getStyle('B6:D6')->applyFromArray($styleTitulos);

            $this->docexcel->getActiveSheet()->setCellValue('A6','');
            $this->docexcel->getActiveSheet()->setCellValue('B6','Totales');
            $this->docexcel->getActiveSheet()->setCellValue('C6','Porcentaje');
            $this->docexcel->getActiveSheet()->setCellValue('D6','Observaciones');
            $fila = 7;
            ksort($this->resumen_general);
            $eventos = array();
            foreach ($this->resumen_general as $key => $value ){
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $key);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila,round($value/count($this->objParam->getParametro('datos')) *100,1) );
                $this->docexcel->getActiveSheet()->getStyle("B$fila:D$fila")->applyFromArray($border);
                array_push($eventos,$key);
                $fila++;
            }

            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,$fila,'Total');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1,$fila,'=SUM(B7:B' .($fila-1).')');
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2,$fila,'=SUM(C7:C' .($fila-1).')');
            $this->docexcel->getActiveSheet()->getStyle("A$fila:D$fila")->applyFromArray($style_totales);
            $this->docexcel->getActiveSheet()->getStyle("A$fila:D$fila")->applyFromArray($border);

            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,$fila + 4,'Por Gerencias');
            $this->docexcel->getActiveSheet()->getStyle('A'.($fila + 4).':A'.($fila + 4))->applyFromArray($style_totales);

            $columna = 1;
            $fila_titulo = $fila + 5;
            $fila_subtitulos = $fila + 6;
            $columna_style = 1;

            $this->docexcel->getActiveSheet()->getRowDimension($fila_titulo)->setRowHeight(30);
            foreach ($this->resumen_gerecias as $key => $value ){
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna, $fila_titulo, $key);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna, $fila_subtitulos, 'Totales');
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna + 1, $fila_subtitulos, 'Porcentaje');
                $this->docexcel->getActiveSheet()->mergeCells($this->equivalencias[$columna] . "$fila_titulo:" . $this->equivalencias[$columna +1] . "$fila_titulo");
                $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[$columna] . "$fila_titulo:" . $this->equivalencias[$columna +1] . "$fila_subtitulos")->getAlignment()->setWrapText(true);
                $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[$columna] . "$fila_titulo:" . $this->equivalencias[$columna +1] . "$fila_titulo")->applyFromArray($styleTitulos);
                $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[$columna] . "$fila_subtitulos:" . $this->equivalencias[$columna+ 1] . "$fila_subtitulos")->applyFromArray($styleTitulos);
                foreach ($eventos as $tipo){
                    if(!$value[$tipo]){
                        $value[$tipo] = 0;
                    }
                }
                ksort($value);
                $fila_detalle = $fila + 7;
                foreach ($value as $key2 => $value2 ){
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0 , $fila_detalle, $key2);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna, $fila_detalle, $value2);
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna +1, $fila_detalle, round($value2/array_sum($this->resumen_gerecias[$key])*100,1) );
                    $this->docexcel->getActiveSheet()->getColumnDimension($this->equivalencias[$columna_style])->setWidth(22);
                    $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[$columna - 1] . "$fila_detalle:" . $this->equivalencias[$columna+1] . "$fila_detalle")->applyFromArray($border);
                    $fila_detalle ++;
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna, $fila_detalle, '=SUM('.$this->equivalencias[$columna].'17:' . $this->equivalencias[$columna].$fila_detalle.')');
                    $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow($columna+1, $fila_detalle, '=SUM('.$this->equivalencias[$columna+1].'17:' . $this->equivalencias[$columna+1].$fila_detalle.')');
                    $columna_style ++;
                }
                $columna = $columna +1;
                $columna ++;
            }

            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,$fila_detalle,'Total');
            $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[0].$fila_detalle.':'.$this->equivalencias[$columna -1].$fila_detalle)->applyFromArray($style_totales);
            $this->docexcel->getActiveSheet()->getStyle($this->equivalencias[0].$fila_detalle.':'.$this->equivalencias[$columna -1].$fila_detalle)->applyFromArray($border);
        }
    }
    function imprimeSubtitulo($fila, $valor) {
        $styleTitulos = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 8,
                'name'  => 'Arial'
            ));
        $border = array(
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            )
        );
        //
        $this->docexcel->getActiveSheet()->getStyle("A$fila:D$fila")->applyFromArray($border);
        $this->docexcel->getActiveSheet()->getStyle("A$fila:A$fila")->applyFromArray($styleTitulos);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $valor);

    }
    function imprimirTitulo(){
        $styleTitulos1 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 12,
                'name'  => 'Arial'
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
        );
        $styleTitulos3 = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 11,
                'name'  => 'Arial'
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
        );
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,2,'REPORTE ASISTENCIA');
        $this->docexcel->getActiveSheet()->getStyle('A2:D2')->applyFromArray($styleTitulos1);
        $this->docexcel->getActiveSheet()->mergeCells('A2:D2');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,3,'Fecha: '.$this->objParam->getParametro('fecha'));
        $this->docexcel->getActiveSheet()->getStyle('A3:D3')->applyFromArray($styleTitulos3);
        $this->docexcel->getActiveSheet()->mergeCells('A3:D3');
    }
    function generarReporte(){
        $this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
        $this->objWriter->save($this->url_archivo);

    }

}
?>

