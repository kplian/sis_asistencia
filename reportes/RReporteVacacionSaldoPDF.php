<?php
/**
 *@package pXP
 *@file RMarcadoGral
 *@author  SAZP
 *@date 19-08-2019 15:28:39
 *@description Clase que genera el reporte de No conformidades
 * HISTORIAL DE MODIFICACIONES:

 */
class RReporteVacacionSaldoPDF extends  ReportePDF
{
    private $total_horas = '00:00:00';
    function Header(){
        $this->Ln(8);
        $this->MultiCell(40, 25, '', 0, 'C', 0, '', '');
        $this->SetFontSize(15);
        $this->SetFont('', 'B');
        $this->MultiCell(105, 25, "\n" . 'PERSONAL EN VACACIÓN', 0, 'C', 0, '', '');
        $this->SetFont('times', '', 10);
        $this->MultiCell(0, 25,'', 0, 'C', 0, '', '');
        $this->Image(dirname(__FILE__) . '/../../pxp/lib' . $_SESSION['_DIR_LOGO'], 17, 15, 36);

    }
    function reporteRequerimiento(){

        $table = '
             <table cellspacing="0" cellpadding="1" >
                  <tr>
                        <th width="10%" style="border-top: 1px solid black; border-bottom: 1px solid black;" align="center"><b>CÓDIGO</b></th>
                        <th width="40%" style="border-top: 1px solid black; border-bottom: 1px solid black;" align="center"><b>EMPLEADO</b></th>
                        <th width="20%" style="border-top: 1px solid black; border-bottom: 1px solid black;" align="center"><b>DÍAS</b></th>
                        <th width="20%" style="border-top: 1px solid black; border-bottom: 1px solid black;" align="center"><b>FEC. INICIO</b></th>
                        <th width="20%" style="border-top: 1px solid black; border-bottom: 1px solid black;" align="center"><b>FEC. FIN</b></th>
                  </tr>
                  
                  
                  ';

        $titulo = '';
        $subtitulo = '';
        foreach ($this->datos as $value){

            if($titulo != $value['gerencia']){
                $titulo = $value['gerencia'];
                $table .=' <tr>
                                <th  colspan="5" align="left"><b>'. $value['gerencia'].'</b></th>
                          </tr>';
            }
            if($subtitulo != $value['departamento']){
                $subtitulo = $value['departamento'];
                $table .=' <tr>
                        <th colspan="5" align="left"><b>'. $value['departamento'].'</b></th>
                  </tr>';
            }

            $table .= '<tr>';
            $table .= '<td  align="center" >'.$value['codigo'].'</td>
                        <td  align="left" >'. $value['desc_funcionario1'].'</td>
                        <td  align="center" >'.$value['dia'].' </td>
                        <td  align="center" >'.$value['desde'].'</td>
                        <td  align="center" >'.$value['hasta'].'</td>';
            $table .= '</tr>';
        }
        $table .= '</table>';

        $this->SetFont('times', '', 10);
        $this->writeHTML($table, true, false, false, false, '');
        $this->ln();

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

