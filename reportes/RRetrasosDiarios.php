<?php
/**
 *@package pXP
 *@file RMarcadoGral
 *@author  SAZP
 *@date 19-08-2019 15:28:39
 *@description Clase que genera el reporte de No conformidades
 * HISTORIAL DE MODIFICACIONES:

 */
class RRetrasosDiarios extends  ReportePDF{

    public $titulo_reporte;
    function Header(){
        $this->Ln(5);
        $url_imagen = dirname(__FILE__) . '/../../pxp/lib' . $_SESSION['_DIR_LOGO'];
        $f_actual = $this->objParam->getParametro('fecha');// date("d/m/Y");//date_format(date_create($this->datos[0]["fecha_solicitud"]), 'd/m/Y');
        $this->titulo_reporte = 'REPORTE DIARIO DE RETRASOS';

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
            	<th style="width: 60%;vertical-align:middle;" align="center" rowspan="2"><br/><br/><h2>$this->titulo_reporte</h2></th>
            	<th style="width: 20%;" align="center" colspan="2"><div style="padding:10px 10px 10px 10px;">&nbsp;&nbsp;&nbsp;&nbsp;</div></th>
        	</tr>
        	<tr>
        	      <th style="width: 20%;" align="center" colspan="2"><div style="padding:10px 10px 10px 10px;"><b>Fecha: </b>$f_actual</div></th>
        	</tr>
        </table>
<br/>
EOF;
        $this->writeHTML ($html);

        $hader = '<table cellspacing="0" cellpadding="1">
                      <tr>
                            <th style="border-top: 1px solid black; border-bottom: 1px solid black; width: 10%;" align="center"><b>Cod. Emp.</b></th>
                            <th style="border-top: 1px solid black; border-bottom: 1px solid black; width: 35%;" align="center"><b>Nombre</b></th>
                            <th style="border-top: 1px solid black; border-bottom: 1px solid black; width: 35%;" align="center"><b>Cargo</b></th>
                            <th style="border-top: 1px solid black; border-bottom: 1px solid black; width: 10%;" align="center"><b>Hora de ingreso</b></th>
                            <th style="border-top: 1px solid black; border-bottom: 1px solid black; width: 10%;" align="center"><b>Minutos de retraso</b></th>
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

        foreach ($this->datos as $value){

            $codigo_funcionario = $value['codigo_funcionario'];
            $funcionario = $value['funcionario'];
            $cargo = $value['cargo'];
            $hora = $value['hora'];
            $hora_cal = $value['hora_cal'];

            $retraso = $value['retraso'];

            $color = '';

            if($retraso == 'si' &&  $this->objParam->getParametro('tipo_filtro') != 'retraso'){
                $color = 'color: red';
            }

            if($subtitulo != $value['departamento']){
                $subtitulo = $value['departamento'];
                $table .=' <tr>
                                <th colspan="5" align="left"><p style="size: 5px;"><b>'.$value['departamento'].'</b></p></th>
                          </tr>';
            }

            $table .= '<tr>';
            $table .= ' <td style="width: 10%; '.$color.' " align="center" >' . $codigo_funcionario . '</td>
                            <td style="width: 35%; '.$color.' ">' . $funcionario . '</td>
                            <td style="width: 35%; '.$color.' ">' . $cargo . '</td>
                            <td style="width: 10%; '.$color.' " align="center" >' . $hora .   '</td>
                            <td style="width: 10%; '.$color.' " align="center" >' . $hora_cal . '</td>';
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
        $this->SetMargins(15,45,15);
        $this->setFontSubsetting(false);
        $this->AddPage();
        $this->SetMargins(15,45,15);
        $this->reporteRequerimiento();
    }
}
?>
