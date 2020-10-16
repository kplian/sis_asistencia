<?php
class RReporteSaldoXLSX{
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
        $this->docexcel->getActiveSheet()->setTitle('Saldo Vacaciones');
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
                'size'  => 9,
                'name'  => 'Arial',
                'color' => array(
                    'rgb' => '0000'
                )
            ),
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ));
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
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,2,'SALDO DE VACACIONES');
        $this->docexcel->getActiveSheet()->getStyle('A2:F2')->applyFromArray($styleTitulos1);
        $this->docexcel->getActiveSheet()->mergeCells('A2:F2');
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0,3,'Gestion:'.$this->objParam->getParametro('id_gestion'));
        $this->docexcel->getActiveSheet()->getStyle('A3:F3')->applyFromArray($styleTitulos3);
        $this->docexcel->getActiveSheet()->mergeCells('A3:F3');
        $this->docexcel->getActiveSheet()->getColumnDimension('A')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('B')->setWidth(10);
        $this->docexcel->getActiveSheet()->getColumnDimension('C')->setWidth(40);
        $this->docexcel->getActiveSheet()->getColumnDimension('D')->setWidth(20);
        $this->docexcel->getActiveSheet()->getColumnDimension('E')->setWidth(15);
        $this->docexcel->getActiveSheet()->getColumnDimension('F')->setWidth(10);
        $this->docexcel->getActiveSheet()->getColumnDimension('G')->setWidth(10);
        $this->docexcel->getActiveSheet()->getStyle('A5:G5')->getAlignment()->setWrapText(true);
        $this->docexcel->getActiveSheet()->getStyle('A5:G5')->applyFromArray($styleTitulos2);

        $this->docexcel->getActiveSheet()->setCellValue('A5','CODIGO');
        $this->docexcel->getActiveSheet()->setCellValue('B5','');
        $this->docexcel->getActiveSheet()->setCellValue('C5','EMPLEADO');
        $this->docexcel->getActiveSheet()->setCellValue('D5','');
        $this->docexcel->getActiveSheet()->setCellValue('E5','FECHA INGRESO');
        $this->docexcel->getActiveSheet()->setCellValue('F5','GESTION');
        $this->docexcel->getActiveSheet()->setCellValue('G5','DIAS');


    }
    function generarDatos(){
        $this->imprimeCabecera();
        $styleTitulos3 = array(
            'alignment' => array(
                'horizontal' => PHPExcel_Style_Alignment::HORIZONTAL_CENTER,
                'vertical' => PHPExcel_Style_Alignment::VERTICAL_CENTER,
            ),
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
        $this->numero = 1;
        $fila = 6;
        $datos = $this->objParam->getParametro('datos');

        $ger = '';
        $dep = '';
        $codigo = '';
        $funcionario = '';
        $fecha = '';
        foreach ($datos as $value) {
           if ($value['gerencia'] != $ger) {
                $this->imprimeSubtitulo($fila,$value['gerencia']);
                $ger = $value['gerencia'];
                $fila++;
            }
            if ($value['departamento'] != $dep && $value['departamento'] != $value['gerencia']){
                $this->imprimeSubtituloDep($fila,$value['departamento']);
                $dep = $value['departamento'];
                $fila++;
            }
            if( $value['codigo'] != $codigo){
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $value['codigo']);
                $codigo=  $value['codigo'];
            }
            if( $value['desc_funcionario1'] != $funcionario){
               $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(2, $fila, $value['desc_funcionario1']);
               $funcionario=  $value['desc_funcionario1'];
            }
            if( $value['fecha_contrato'] != $fecha){
               $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(4, $fila, $value['fecha_contrato']);
                $fecha=  $value['fecha_contrato'];
            }
            if ($value['gestion'] == 0){
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, 'TOTAL');
                $this->docexcel->getActiveSheet()->getStyle("F$fila:G$fila")->applyFromArray($styleTitulos);

            }else{
                $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(5, $fila, $value['gestion']);
            }
            $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(6, $fila, $value['saldo']);
            $this->docexcel->getActiveSheet()->getStyle("A$fila:A$fila")->applyFromArray($styleTitulos3);
            $this->docexcel->getActiveSheet()->getStyle("E$fila:E$fila")->applyFromArray($styleTitulos3);
            $fila++;
        }
    }
    function imprimeSubtitulo($fila, $valor) {
        $styleTitulos = array(
            'font'  => array(
                'bold'  => true,
                'size'  => 11,
                'name'  => 'Arial'
            ));

        $this->docexcel->getActiveSheet()->getStyle("A$fila:A$fila")->applyFromArray($styleTitulos);
        $this->docexcel->getActiveSheet()->setCellValueByColumnAndRow(0, $fila, $valor);

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

