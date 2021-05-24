<?php
/**
 *@package pXP
 *@file RMarcadoGral
 *@author  SAZP
 *@date 19-08-2019 15:28:39
 *@description Clase que genera el reporte de No conformidades
 * HISTORIAL DE MODIFICACIONES:

 */
class RRetrasosMensuales extends  ReportePDF{

    public $titulo_reporte;
    function Header(){
        $this->Ln(5);
        $url_imagen = dirname(__FILE__) . '/../../pxp/lib' . $_SESSION['_DIR_LOGO'];
        $f_desde = $this->objParam->getParametro('fecha_ini');
        $f_hasta = $this->objParam->getParametro('fecha_fin');
        $this->titulo_reporte = 'DETALLE MENSUAL DE RETRASOS';

        $html = <<<EOF
		<style>
		table, th, td {		
   			font-family: "Calibri";
   			font-size: 9pt;	
		}
		
		</style>
		<body>
		<table cellpadding="2" cellspacing = "0">
        	<tr>
            	<th style="width: 20%;vertical-align:middle;" align="center" rowspan="2"><img src="$url_imagen" ></th>
            	<th style="width: 60%;vertical-align:middle;" align="center" rowspan="2"><br/><br/><h2>$this->titulo_reporte</h2> <b>Del: $f_desde al $f_hasta </b></th>
            	<th style="width: 20%;" align="center" colspan="2"><div style="padding:10px 10px 10px 10px;">&nbsp;&nbsp;&nbsp;&nbsp;</div></th>
        	</tr>
        	<tr>
        	      <th style="width: 20%;" align="center" colspan="2"><div style="padding:10px 10px 10px 10px;"></div></th>
        	</tr>
        </table>
<br/>
EOF;
        $this->writeHTML ($html);

        $hader = '<table cellspacing="0" cellpadding="1">
                      <tr>
                            <th style="border-top: 1px solid black; border-bottom: 1px solid black; width: 10%;" align="center"><b>Cod. Emp.</b></th>
                            <th style="border-top: 1px solid black; border-bottom: 1px solid black; width: 25%;" align="center"><b>Nombre</b></th>
                            <th style="border-top: 1px solid black; border-bottom: 1px solid black; width: 25%;" align="center"><b>Área</b></th>
                            <th style="border-top: 1px solid black; border-bottom: 1px solid black; width: 10%;" align="center"><b>Fecha</b></th>
                            <th style="border-top: 1px solid black; border-bottom: 1px solid black; width: 10%;" align="center"><b>Hora de ingreso</b></th>
                            <th style="border-top: 1px solid black; border-bottom: 1px solid black; width: 10%;" align="center"><b>Minutos de retraso</b></th>
                            <th style="border-top: 1px solid black; border-bottom: 1px solid black; width: 10%;" align="center"><b>Motivo</b></th>

                      </tr>
                </table>';
        $this->SetFont('times', '', 9);
        $this->writeHTML($hader);

    }
    function reporteRequerimiento(){
        $this->ln();
        $table = ' <table cellspacing="0" cellpadding="1">';
        $titulo = '';
        $subtitulo = '';



        $funcionario = '';
        $codigo_funcionario = '';
        $departamento = '';

        foreach ($this->datos as $value){

            $hora = $value['hora'];
            $hora_cal = $value['hora_cal'];
            $retraso = $value['retraso'];
            $fecha = $value['fecha'];

            $color = '';


            if($subtitulo != $value['departamento']){
                $subtitulo = $value['departamento'];
                $table .=' <tr>
                                <th colspan="6" align="left"><b>'. $value['departamento'].'</b></th>
                          </tr>';
            }

            $table .= '<tr>';
            $imprimirCodigo = true;
            if($codigo_funcionario != $value['codigo_funcionario']){
                $codigo_funcionario = $value['codigo_funcionario'];
                $table .= ' <td style="width: 10%; '.$color.' " align="center" >' . $value['codigo_funcionario'] . '</td>';
                $imprimirCodigo = false;
            }
            if($imprimirCodigo){
                $table .= ' <td style="width: 10%; '.$color.' " align="center"> </td>';
            }

            $imprimir = true;
            if($funcionario != $value['funcionario']  ){
                $funcionario = $value['funcionario'];
                $table .= ' <td style="width: 25%; '.$color.' ">'.$value['funcionario'] .'</td>';
                $imprimir = false;
            }

            if($imprimir){
                $table .= ' <td style="width: 25%; '.$color.' "></td>';
            }

            if($value['nivel'] == 'b') {
                $table .='<td style="width: 10%; '.$color.' "> </td>';
            }else{
                $table .='<td style="width: 25%; '.$color.' ">'.$value['departamento'].'</td>';
            }

            if ($fecha != '' || $fecha != null){
                $table .= '<td style="width: 10%; '.$color.' ">' . $fecha . '</td>';
            }else {
                $table .= '<td style="width: 10%; '.$color.' ">' . $fecha . '</td>';
            }
            if ($hora != '' || $hora != null){
                $table .= '<td style="width: 10%; '.$color.' " align="center" >' . $hora .   '</td>';
            }else{
                $table .= '<td style="width: 25%; '.$color.' " align="right" > <b>Total minutos de retraso:</b></td>';
            }

            if($value['nivel'] == 'b') {
                $table .= ' <td style="width: 10%; '.$color.' " align="right" > <b>' . $hora_cal . '</b></td>';
            }else{
                $table .= ' <td style="width: 10%; '.$color.' " align="right" >' . $hora_cal . '</td>';
            }
            if($value['nivel'] == 'b') {
                $table .='<td style="width: 10%; '.$color.' "> </td>';
            }else{
                $table .='<td style="width: 10%; '.$color.' ">'.$value['departamento'].'</td>';
            }
            $table .= '</tr>';

        }
        $table .= '</table>';

        $this->SetFont('times', '', 9);
        $this->writeHTML($table);
        $this->ln();
    }
    function setDatos($datos) {
        $this->datos = $datos;
    }
    function generarReporte() {
        $this->SetMargins(15,50,15);
        $this->setFontSubsetting(false);
        $this->AddPage();
        $this->SetMargins(15,50,15);
        $this->reporteRequerimiento();
    }
}
?>

