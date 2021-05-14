<?php
class RRetrasosMensualesXls{
    private $docexcel;
    private $objWriter;
    public $fila_aux = 0;
    private $equivalencias=array();
    private $objParam;
    public  $url_archivo;
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
        $this->docexcel->getActiveSheet()->setTitle('retrasos');
        $this->docexcel->setActiveSheetIndex(0);
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
        //modificacionw
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,2,'DETALLE MENSUAL DE RETRASOS');
        $this->docexcel->getActiveSheet()->getStyle('A2:F2')->applyFromArray($styleTitulos1);
        $this->docexcel->getActiveSheet()->mergeCells('A2:F2');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,3,'Del: '.$this->objParam->getParametro('fecha_ini').' al '.$this->objParam->getParametro('fecha_fin'));
        $this->docexcel->getActiveSheet()->getStyle('A3:F3')->applyFromArray($styleTitulos3);
        $this->docexcel->getActiveSheet()->mergeCells('A3:F3');
        $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(40);
        $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(40);
        $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(25);
        $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(25);

        $this->docexcel->getActiveSheet()->getStyle('A5:F5')->getAlignment()->setWrapText(true);
        $this->docexcel->getActiveSheet()->getStyle('A5:F5')->applyFromArray($styleTitulos2);

        $this->docexcel->getActiveSheet()->setCellValue('A5','COD. EMP');
        $this->docexcel->getActiveSheet()->setCellValue('B5','NOMBRE');
        $this->docexcel->getActiveSheet()->setCellValue('C5','ÁREA');
        $this->docexcel->getActiveSheet()->setCellValue('D5','FECHA');
        $this->docexcel->getActiveSheet()->setCellValue('E5','HORA DE INGRESO');
        $this->docexcel->getActiveSheet()->setCellValue('F5','MINUTOS DE RETRASO');

    }
    function generarDatos(){
        $this->imprimeCabecera();
        $styleTitulos3 = array(
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
        );
        $styleTitulos_right = array(
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_RIGHT ,
                'vertical' => PHPExcel_Style_Alignment::HORIZONTAL_RIGHT ,
            ),
        );
        $styleTitulos_bold = array(
            'font'  => array(
                'bold'  => true,
            )
        );
        $styleArray = array(
            'borders' => array(
                'allborders' => array(
                    'style' => PHPExcel_Style_Border::BORDER_THIN
                )
            )
        );
        $styleTitulos = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 11,
                'name'  => 'Calibri'
            ));

        $red = array(
            'font'  => array(
                'color' => array(
                    'rgb' => 'FA0808'
                )
            ));

        $fila = 6;
        $dep = '';
        $codigo_funcionario = '';
        $funcionario = '';
        $area = '';

        $datos = $this->objParam->getParametro('datos');
        foreach ($datos as $value) {
            if ($value['departamento'] != $dep ){
                $this->imprimeSubtituloDep($fila,$value['departamento']);
                $dep = $value['departamento'];
                $fila++;
            }
            if ($value['codigo_funcionario'] != $codigo_funcionario ){
                $codigo_funcionario = $value['codigo_funcionario'];
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $value['codigo_funcionario']);
            }
            if ($value['funcionario'] != $funcionario ){
                $funcionario = $value['funcionario'];
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(1, $fila, $value['funcionario']);
            }
            if ($value['hora'] != '' || $value['hora']!= null){
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['departamento']);
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(3, $fila, $value['fecha']);
            }
            if ($value['hora'] != '' || $value['hora']!= null){
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, $value['hora']);
                $this->docexcel->getActiveSheet()->getStyle("E$fila:E$fila")->applyFromArray($styleTitulos3);
            }else{
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, 'Total minutos de retraso');
                $this->docexcel->getActiveSheet()->getStyle("E$fila:E$fila")->applyFromArray($styleTitulos_right);
                $this->docexcel->getActiveSheet()->getStyle("E$fila:F$fila")->applyFromArray($styleTitulos_bold);
            }

            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, $value['hora_cal']);
            $this->docexcel->getActiveSheet()->getStyle("A$fila:A$fila")->applyFromArray($styleTitulos3);
            $this->docexcel->getActiveSheet()->getStyle("A$fila:A$fila")->applyFromArray($styleTitulos3);
            $this->docexcel->getActiveSheet()->getStyle("F$fila:F$fila")->applyFromArray($styleTitulos3);
            $fila++;
        }
    }
    function imprimeSubtituloDep($fila, $valor) {
        $styleTitulos = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 9,
                'name'  => 'Arial'
            ));

        $this->docexcel->getActiveSheet()->getStyle("A$fila:A$fila")->applyFromArray($styleTitulos);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $valor);

    }
    function generarReporte(){
        $this->objWriter = PHPExcel_IOFactory::createWriter($this->docexcel, 'Excel5');
        $this->objWriter->save($this->url_archivo);

    }

}
?>

