<?php
/**
 *@package pXP
 *@file RMarcadoGral
 *@author  SAZP
 *@date 19-08-2019 15:28:39
 *@description Clase que genera el reporte de No conformidades
 * HISTORIAL DE MODIFICACIONES:

 */
class RReporteHistoricoVacacionPDF extends  ReportePDF
{
    private $total_horas = '00:00:00';
    function Header(){
        $this->Ln(8);
        $this->MultiCell(40, 25, '', 0, 'C', 0, '', '');
        $this->SetFontSize(15);
        $this->SetFont('', 'B');
        $this->MultiCell(105, 25, "\n" . 'HISTORIAL DE VACACIONES', 0, 'C', 0, '', '');
        $this->SetFont('times', '', 10);
        $this->MultiCell(0, 25,'', 0, 'C', 0, '', '');
        $this->Image(dirname(__FILE__) . '/../../pxp/lib' . $_SESSION['_DIR_LOGO'], 17, 15, 36);

    }
    function reporteRequerimiento(){

       /* $this->SetFont('times', 'B', 10);
        $this->Cell(80, 7, 'EMPLEADO:'.$this->datos[0]['desc_funcionario1'], 0, 0, 'L', 0, '', 0);
        $this->Cell(106, 7, 'CARGO: '.$this->datos[0]['descripcion_cargo'], 0, 0, 'L', 0, '', 0);
        $this->ln();

        $this->SetFont('times', 'B', 10);
        $this->Cell(80, 7, 'CÓDIGO: '.$this->datos[0]['codigo'], 0, 0, 'L', 0, '', 0);
        $this->Cell(106, 7, 'ÁREA: '.$this->datos[0]['nombre_unidad'], 0, 0, 'L', 0, '', 0);
        $this->ln();

        $this->SetFont('times', 'B', 10);
        $this->Cell(0, 7, 'FECHA INGRESO: '. $this->datos[0]['fecha_contrato'], 0, 0, 'L', 0, '', 0);*/
        $funcionario = $this->datos[0]['desc_funcionario1'];
        $descripcion_cargo= $this->datos[0]['descripcion_cargo'];
        $codigo= $this->datos[0]['codigo'];
        $nombre_unidad= $this->datos[0]['nombre_unidad'];
        $fecha_contrato= $this->datos[0]['fecha_contrato'];

        $html = <<<EOD
             <table cellspacing="0" cellpadding="1">
                  <tr>
                        <th width="15%"><b>EMPLEADO: </b></th>
                        <td width="35%">$funcionario</td>
                        <th width="15%"><b>CARGO: </b></th>
                        <td width="35%">$descripcion_cargo</td>
                  </tr>
                  <tr>
                        <th width="15%"><b>CÓDIGO: </b></th>
                        <td width="35%">$codigo</td>
                        <th width="15%"><b>ÁREA: </b></th>
                        <td width="35%">$nombre_unidad</td>
                  </tr>
                  <tr>
                        <th width="20%"><b>FECHA INGRESO: </b></th>
                        <td width="80%">$fecha_contrato</td>
                  </tr>
            </table>
EOD;
        $this->SetFont('times', '', 9);
        $this->writeHTML($html, true, false, false, false, '');
        $this->ln();

        $table = '
             <table cellspacing="0" cellpadding="1" >
                  <tr>
                        <th style="border-top: 1px solid black; border-bottom: 1px solid black;" align="center"><b>EVENTO</b></th>
                        <th style="border-top: 1px solid black; border-bottom: 1px solid black;" align="center"><b>FECHA</b></th>
                        <th style="border-top: 1px solid black; border-bottom: 1px solid black;" align="center"><b>RANGO DE FECHAS</b></th>
                        <th style="border-top: 1px solid black; border-bottom: 1px solid black;" align="center"><b>DÍAS</b></th>
                        <th style="border-top: 1px solid black; border-bottom: 1px solid black;" align="center"><b>SALDO</b></th>
                  </tr>';


        foreach ($this->datos as $value){

            $tipo = $value['tipo'];
            $fecha = $value['fecha'];
            $desde = $value['desde'];
            $hasta = $value['hasta'];
            $dia = $value['dia'];
            $saldo = $value['saldo'];
            $table .= '<tr>';
            $table .= '<td  align="center" >'.$tipo.'</td>
                        <td  align="center" >'.$fecha.'</td>
                        <td  align="center" >'.$desde.' - '.$hasta.'</td>
                        <td  align="center" >'.$dia.'</td>
                        <td  align="center" >'.$saldo.'</td>';
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

