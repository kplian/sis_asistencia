<?php
/**
 *@package pXP
 *@file RMarcadoGral
 *@author  SAZP
 *@date 19-08-2019 15:28:39
 *@description Clase que genera el reporte de No conformidades
 * HISTORIAL DE MODIFICACIONES:

 */
class RReporteBajaMedica extends  ReportePDF
{
    function Header(){

        $this->Ln(5);
        $url_imagen = dirname(__FILE__) . '/../../pxp/lib' . $_SESSION['_DIR_LOGO'];
        $f_actual = date("d/m/Y");//date_format(date_create($this->datos[0]["fecha_solicitud"]), 'd/m/Y');

        $fecha_inicio = date_format(date_create($this->objParam->getParametro('fecha_inicio')), 'd/m/Y');
        $fecha_fin = date_format(date_create($this->objParam->getParametro('fecha_fin')), 'd/m/Y') ;

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
            	<th style="width: 60%;vertical-align:middle;" align="center" rowspan="2"><h2>INCAPACIDAD TEMPRAL DEL PERSONAL</h2>
            	<h3>$fecha_inicio a $fecha_fin</h3>
            
            	</th>
            	<th style="width: 20%;" align="center" colspan="2"><div style="padding:10px 10px 10px 10px;">&nbsp;&nbsp;&nbsp;&nbsp;</div></th>
        	</tr>
        	<tr>
        	      <th style="width: 20%;" align="center" colspan="2"><div style="padding:10px 10px 10px 10px;"></div></th>
        	</tr>
        </table>
EOF;
        $this->writeHTML ($html);

        $hader = '<table style="border-collapse: collapse; width: 100%;">
                    <tbody>
                        <tr>
                            <td style="width: 5%; border-top: 1px solid black; border-bottom: 1px solid black;"  align="center"><b>N°</b></td>
                            <td style="width: 15%; border-top: 1px solid black; border-bottom: 1px solid black;" align="center"><b>Nombre</b></td>
                            <td style="width: 10%; border-top: 1px solid black; border-bottom: 1px solid black;"  align="center"><b>Centro</b></td>
                            <td style="width: 10%; border-top: 1px solid black; border-bottom: 1px solid black;"  align="center"><b>Gerencia</b></td>
                            <td style="width: 10%; border-top: 1px solid black; border-bottom: 1px solid black;" align="center"><b>Inicio</b></td>
                            <td style="width: 10%; border-top: 1px solid black; border-bottom: 1px solid black;" align="center"><b>Fin</b></td>
                            <td style="width: 10%; border-top: 1px solid black; border-bottom: 1px solid black;" align="center"><b>Días Incapacidad</b></td>
                            <td style="width: 10%; border-top: 1px solid black; border-bottom: 1px solid black;" align="center"><b>Tipo Incapacidad</b></td>
                            <td style="width: 20%; border-top: 1px solid black; border-bottom: 1px solid black;" align="center"><b>Observaciones</b></td>
                        </tr>
                    </tbody>
                    </table> ';
        $this->writeHTML($hader);
    }
    function reporteRequerimiento(){
        $this->ln();
        $table = ' <table style="border-collapse: collapse; width: 100%;">';
        $numero = 1;
        foreach ($this->datos as $value){

            $nombre = $value['nombre'];
            $centro = $value['centro'];
            $gerencia = $value['gerencia'];
            $fecha_inicio = $value['fecha_inicio'];
            $fecha_fin = $value['fecha_fin'];
            $dias_efectivo = $value['dias_efectivo'];
            $tipo_baja = $value['tipo_baja'];
            $observaciones = $value['observaciones'];

            $table .= '<tr>';
            $table .= ' <td style="width: 5%"  align="center">'.$numero.'</td>
                            <td style="width: 15%" align="center">'.$nombre.'</td>
                            <td style="width: 10%"  align="center">'.$centro.'</td>
                            <td style="width: 10%"  align="center">'.$gerencia.'</td>
                            <td style="width: 10%" align="center">'.$fecha_inicio.'</td>
                            <td style="width: 10%" align="center">'.$fecha_fin.'</td>
                            <td style="width: 10%" align="center">'.$dias_efectivo.'</td>
                            <td style="width: 10%" align="center">'.$tipo_baja.'</td>
                            <td style="width: 20%" align="center">'.$observaciones.'</td>';
            $table .= '</tr>';
            $numero++;
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
        $this->SetMargins(15,53,15);
        $this->setFontSubsetting(false);
        $this->AddPage();
        $this->SetMargins(15,53,15);
        $this->reporteRequerimiento();

    }
}
?>

<?php
