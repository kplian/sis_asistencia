<?php
/**
 *@package pXP
 *@file RMarcadoGral
 *@author  SAZP
 *@date 19-08-2019 15:28:39
 *@description Clase que genera el reporte de No conformidades
 * HISTORIAL DE MODIFICACIONES:

 */
class RReporteVacacionResumenPDF extends  ReportePDF
{
    private $total_horas = '00:00:00';
    function Header(){
        $this->Ln(8);
        $this->MultiCell(40, 25, '', 0, 'C', 0, '', '');
        $this->SetFontSize(15);
        $this->SetFont('', 'B');
        $this->MultiCell(105, 25, "\n" . 'RESUMEN DE VACACIONES'. "\n".'Fecha: '.$this->objParam->getParametro('fecha_ini'), 0, 'C', 0, '', '');
        $this->SetFont('times', '', 10);
        $this->MultiCell(0, 25,'', 0, 'C', 0, '', '');
        $this->Image(dirname(__FILE__) . '/../../pxp/lib' . $_SESSION['_DIR_LOGO'], 17, 15, 36);

    }
    function reporteRequerimiento(){

        $table = '
             <table cellspacing="0" cellpadding="1" >
                  <tr>
                        <th width="10%"  style="border-top: 1px solid black; border-bottom: 1px solid black;" align="center"><b>CÓDIGO</b></th>
                        <th width="30%"  style="border-top: 1px solid black; border-bottom: 1px solid black;" align="center"><b>EMPLEADO</b></th>
                        <th width="10%"  style="border-top: 1px solid black; border-bottom: 1px solid black;" align="right"><b>ACUMUL</b></th>
                        <th width="10%"  style="border-top: 1px solid black; border-bottom: 1px solid black;" align="right"><b>TOMADOS</b></th>
                        <th width="10%"  style="border-top: 1px solid black; border-bottom: 1px solid black;" align="right"><b>CADUCAD</b></th>
                        <th width="10%"  style="border-top: 1px solid black; border-bottom: 1px solid black;" align="right"><b>ANTICIPOS</b></th>
                        <th width="10%"  style="border-top: 1px solid black; border-bottom: 1px solid black;" align="right"><b>PAGADOS</b></th>
                        <th width="10%"  style="border-top: 1px solid black; border-bottom: 1px solid black;" align="right"><b>SALDO</b></th>
                  </tr>';

        $titulo = '';
        $subtitulo = '';
        foreach ($this->datos as $value){

                $table .= '<tr>';
                // if($value['saldo'] != 0)
                 $table .= ' <td width="10%" align="center" >' . $value['codigo'] . '</td>
                        <td width="30%" align="left" >' . $value['desc_funcionario1'] . '</td>
                        <td width="10%"  align="right" >' . round($value['saldo_acumulado'], 1) . ' </td>
                        <td width="10%"  align="right" >' . round($value['saldo_tomada'], 1) . '</td>
                        <td width="10%"  align="right" >' . round($value['saldo_caducado'], 1) . ' </td>
                        <td width="10%"  align="right" >' . round($value['saldo_anticipo'], 1) . '</td>
                        <td width="10%"  align="right" >' . round($value['saldo_pagado'], 1) . '</td>
                        <td width="10%"  align="right" >' . round($value['saldo'], 1) . '</td>';
                $table .= '</tr>';

        }
        $table .= '</table>';

        $this->SetFont('times', '', 9);
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

