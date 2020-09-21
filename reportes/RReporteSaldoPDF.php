<?php
/**
 *@package pXP
 *@file RMarcadoGral
 *@author  SAZP
 *@date 19-08-2019 15:28:39
 *@description Clase que genera el reporte de No conformidades
 * HISTORIAL DE MODIFICACIONES:

 */
class RReporteSaldoPDF extends  ReportePDF
{
    private $total_horas = '00:00:00';
    function Header(){
        $this->Ln(8);
        $this->MultiCell(40, 25, '', 0, 'C', 0, '', '');
        $this->SetFontSize(12);
        $this->SetFont('', 'B');
        $this->MultiCell(105, 25, "\n" . 'SALDO DE VACACIONES'. "\n".'Gestion:'.$this->objParam->getParametro('id_gestion'), 0, 'C', 0, '', '');
        $this->SetFont('times', '', 10);
        $this->MultiCell(0, 25,'', 0, 'C', 0, '', '');
        $this->Image(dirname(__FILE__) . '/../../pxp/lib' . $_SESSION['_DIR_LOGO'], 17, 15, 36);

    }
    function reporteRequerimiento(){

        $table = '
             <table cellspacing="0" cellpadding="1" >
                  <tr>
                        <th width="15%" style="border-top: 1px solid black; border-bottom: 1px solid black;" align="center"><b>Código</b></th>
                        <th width="40%" style="border-top: 1px solid black; border-bottom: 1px solid black;" align="center"><b>Empleado</b></th>
                        <th width="15%" style="border-top: 1px solid black; border-bottom: 1px solid black;" align="center"><b>Fecha ingreso</b></th>
                        <th width="15%" style="border-top: 1px solid black; border-bottom: 1px solid black;" align="center"><b>Gestion</b></th>
                        <th width="15%" style="border-top: 1px solid black; border-bottom: 1px solid black;" align="center"><b>Dias</b></th>
                  </tr>
                  
                  ';

        $titulo = '';
        $subtitulo = '';
        $codigo = '';
        $funcionario = '';
        $fecha= '';
        $imprimir = true;

        foreach ($this->datos as $value){

            if($titulo != $value['gerencia']){
                $titulo = $value['gerencia'];
                $table .=' <tr>
                                <th colspan="5" align="left"><b>'. $value['gerencia'].'</b></th>
                          </tr>';
            }
            if($subtitulo != $value['departamento']){
                $subtitulo = $value['departamento'];
                $table .=' <tr>
                                <th colspan="5" align="left"><b>'. $value['departamento'].'</b></th>
                          </tr>';
            }

            $table .= '<tr>';
            if ($codigo != $value['codigo']){
                $table .= ' <td width="15%" align="center" >'.$value['codigo'].'</td>';
                $codigo = $value['codigo'];
                $imprimir = false;
            }
            if($imprimir){
                $table .= ' <td width="15%" align="center" > </td>';
            }
            if ($funcionario != $value['desc_funcionario1']){
                $table .= '<td  width="40%" align="left" >'.ucwords(strtolower($value['desc_funcionario1'])).'</td>';
                $funcionario = $value['desc_funcionario1'];
                $imprimir = false;
            }

            if($imprimir){
                $table .= ' <td width="40%" align="center" > </td>';
            }


            if ($fecha != $value['fecha_contrato']){
                $table .= '<td  width="15%" align="left" >'.ucwords(strtolower($value['fecha_contrato'])).'</td>';
                $fecha = $value['fecha_contrato'];
                $imprimir = false;
            }

            if($imprimir){
                $table .= ' <td width="15%" align="center" > </td>';
            }

            if ($value['gestion'] == 0){
                $table .= ' <td  width="15%" align="center"><b>TOTAL</b></td>
                           <td  width="15%" align="center"><b>'.number_format($value['saldo'], 1, ',', ' ').'</b></td>';
            }else{
                $table .= ' <td  width="15%" align="center">'.$value['gestion'].'</td>
                           <td  width="15%" align="center">'. number_format($value['saldo'], 1, ',', ' ').'</td>';
            }

            $table .= '</tr>';
            $imprimir= true;
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

