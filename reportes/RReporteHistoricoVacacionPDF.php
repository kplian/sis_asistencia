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

        $this->Ln(5);
        $url_imagen = dirname(__FILE__) . '/../../pxp/lib' . $_SESSION['_DIR_LOGO'];
        $f_actual = date("d/m/Y");//date_format(date_create($this->datos[0]["fecha_solicitud"]), 'd/m/Y');
        $paginador = $this->getAliasNumPage().'/'.$this->getAliasNbPages();
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
            	<th style="width: 60%;vertical-align:middle;" align="center" rowspan="2"><br/><br/><h2>HISTORIAL DE VACACIONES</h2></th>
            	<th style="width: 20%;" align="center" colspan="2"><div style="padding:10px 10px 10px 10px;">&nbsp;&nbsp;&nbsp;&nbsp;<b>Página: </b>$paginador</div></th>
        	</tr>
        	<tr>
        	      <th style="width: 20%;" align="center" colspan="2"><div style="padding:10px 10px 10px 10px;"><b>Fecha: </b>$f_actual</div></th>
        	</tr>
        </table>
EOF;
        $this->writeHTML ($html);
        $this->ln();
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
        $this->writeHTML($html);

        $this->ln();
        $hader = '<table cellspacing="0" cellpadding="1">
                      <tr>
                            <th style="border-top: 1px solid black; border-bottom: 1px solid black;" align="center"><b>EVENTO</b></th>
                            <th style="border-top: 1px solid black; border-bottom: 1px solid black;" align="center"><b>FECHA</b></th>
                            <th style="border-top: 1px solid black; border-bottom: 1px solid black;" align="center"><b>RANGO DE FECHAS</b></th>
                            <th style="border-top: 1px solid black; border-bottom: 1px solid black;" align="center"><b>DÍAS</b></th>
                            <th style="border-top: 1px solid black; border-bottom: 1px solid black;" align="center"><b>SALDO</b></th>
                      </tr>
                </table>';
        $this->writeHTML($hader);
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
        $pagenumtxt = '';
        $this->Cell($ancho, 0, $pagenumtxt, '', 0, 'C');
        $this->Cell($ancho, 0, $_SESSION['_REP_NOMBRE_SISTEMA'], '', 0, 'R');
        $this->Ln();
        $fecha_rep = date("d-m-Y H:i:s");
        $this->Cell($ancho, 0, "Fecha Impresion : ".$fecha_rep, '', 0, 'L');
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
        $this->ln();
        $table = ' <table cellspacing="0" cellpadding="1">';
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
        $this->writeHTML($table);
        $this->ln();

    }
    function setDatos($datos) {
        $this->datos = $datos;
    }

    function generarReporte() {
        $this->SetMargins(15,63,15);
        $this->setFontSubsetting(false);
        $this->AddPage();
        $this->SetMargins(15,63,15);
        $this->reporteRequerimiento();

    }
}
?>

