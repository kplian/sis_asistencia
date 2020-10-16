<?php
/**
 *@package pXP
 *@file RMarcadoGral
 *@author  SAZP
 *@date 19-08-2019 15:28:39
 *@description Clase que genera el reporte de No conformidades
 * HISTORIAL DE MODIFICACIONES:

 */
class RReporteTotalPDF extends  ReportePDF
{
    private $total_horas = '00:00:00';
    function Header(){
        $this->ln(8);
        $height = 50;
        //cabecera del reporte
        $this->Cell(70, $height, '', 0, 0, 'C', false, '', 0, false, 'T', 'C');
        $this->SetFontSize(15);
        $this->SetFont('', 'B');
        $this->MultiCell(105, $height,  "REPORTE DE TOTAL HORAS TRABAJADAS", 0, 'C', 0, '', '');

        $this->Image(dirname(__FILE__) . '/../../pxp/lib' . $_SESSION['_DIR_LOGO'], 17, 10, 36);

    }

    function Footer() {
        $this->setY(-15);
        $ormargins = $this->getOriginalMargins();
        $this->SetTextColor(0, 0, 0);
        //set style for cell border
        $line_width = 0.85 / $this->getScaleFactor();
        $this->SetLineStyle(array('width' => $line_width, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)));
        $ancho = round(($this->getPageWidth() - $ormargins['left'] - $ormargins['right']) / 3);
        $this->Ln(2);
        $cur_y = $this->GetY();
        //$this->Cell($ancho, 0, 'Generado por XPHS', 'T', 0, 'L');
        $this->Cell($ancho, 0, 'Usuario: '.$_SESSION['_LOGIN'], '', 0, 'L');
        $pagenumtxt = 'Página'.' '.$this->getAliasNumPage().' de '.$this->getAliasNbPages();
        $this->Cell($ancho, 0, $pagenumtxt, '', 0, 'C');
        $this->Cell($ancho, 0, $_SESSION['_REP_NOMBRE_SISTEMA'], '', 0, 'R');
        $this->Ln();
        //   $fecha_rep = date("d-m-Y H:i:s");
        //  $this->Cell($ancho, 0, "Fecha : ".$fecha_rep, '', 0, 'L');
        $this->Ln($line_width);
        $this->Ln();
        $barcode = $this->getBarcode();
        $style = array(
            'position' => $this->rtl?'R':'L',
            'align' => $this->rtl?'R':'L',
            'stretch' => false,
            'fitwidth' => true,
            'cellfitalign' => '',
            'border' => false,
            'padding' => 0,
            'fgcolor' => array(0,0,0),
            'bgcolor' => false,
            'text' => false,
            'position' => 'R'
        );
        $this->write1DBarcode($barcode, 'C128B', $ancho*2, $cur_y + $line_width+5, '', (($this->getFooterMargin() / 3) - $line_width), 0.3, $style, '');

    }
    function reporteRequerimiento(){

        $this->SetFont('times', 'B', 11);
        $this->Cell(0, 7, 'Nombre Funcionario: '. $this->datos[0]['funcionario'], 0, 0, 'L', 0, '', 0);
        $this->ln();

        $this->SetFont('times', 'B', 11);
        $this->Cell(80, 7, 'Periodo desde el  : '.$this->datos[0]['fecha_ini'], 0, 0, 'L', 0, '', 0);
        $this->Cell(106, 7, 'Hasta el: '.$this->datos[0]['fecha_fin'], 0, 0, 'L', 0, '', 0);
        $this->ln();
        $this->ln();

        $numero = 1;
        $tb = <<<EOD
            <table cellspacing="0" cellpadding="1" border="1"  bgcolor="#6478D5" >
          
                <tr>
                    <td width="20" align="center"><font color ="#ffffff"> <b>N°</b></font></td>
                    <td width="70" align="center"><font color ="#ffffff"> <b>Fecha</b></font></td>
                    <td width="88" align="center"><font color ="#ffffff"> <b>Ingreso 1</b></font></td>
                    <td width="89" align="center"><font color ="#ffffff"> <b>Salida 1</b></font></td>
                    <td width="70" align="center"><font color ="#ffffff"> <b>Total 1</b></font></td>
                    <td width="88" align="center"><font color ="#ffffff"> <b>Ingreso 2</b></font></td>
                    <td width="88" align="center"><font color ="#ffffff"> <b>Salida 2</b></font></td>
                    <td width="70" align="center"><font color ="#ffffff"> <b>Total 2</b></font></td> 
                    <td width="70" align="center"><font color ="#ffffff"> <b>Total</b></font></td>
                </tr>
            </table>
EOD;
        $this->SetFont('times', '', 10);
        $this->writeHTML($tb, false, false, false, false, '');
        foreach ($this->datos as $Row) {
            $fecha = $Row['fecha'];
            $inicio_one = $Row['inicio_one'];
            $fin_one = $Row['fin_one'];
            $result_one = $Row['result_one'];

            $inicio_two = $Row['inicio_two'];
            $fin_two = $Row['fin_two'];

            if ($Row['inicio_two'] == null){
                $inicio_two = '-';
            }
            if ($Row['inicio_two'] == null){
                $fin_two = '-';
            }

            $result_two = $Row['result_two'];
            $total = $Row['total'];
            $tbl = <<<EOD
            <table cellspacing="0" cellpadding="1" border="1" >
          
                <tr>
                    <td width="20" align="center">$numero</td>
                    <td width="70" align="center">$fecha</td>
                    <td width="88" align="center">$inicio_one</td>
                    <td width="89" align="center">$fin_one</td>
                    <td width="70" align="center">$result_one</td>
                    <td width="88" align="center">$inicio_two</td>
                    <td width="88" align="center">$fin_two</td>
                    <td width="70" align="center">$result_two</td> 
                    <td width="70" align="center">$total</td>
                </tr>
            </table>
EOD;
            $this->SetFont('times', '', 9);
            $this->writeHTML($tbl, false, false, false, false, '');
            $numero++;
        }

    }
    function setDatos($datos) {
        $this->datos = $datos;
    }

    function generarReporte() {
        $this->SetMargins(15,40,15);
        $this->setFontSubsetting(false);
        $this->AddPage();
        $this->SetMargins(15,40,15);
        $this->reporteRequerimiento();
    }
}
?>