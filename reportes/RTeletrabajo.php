<?php

/**
 * @package pXP
 * @file RMarcadoGral
 * @author  SAZP
 * @date 19-08-2019 15:28:39
 * @description Clase que genera el reporte de No conformidades
 * HISTORIAL DE MODIFICACIONES:
 */
class RTeletrabajo extends ReportePDF
{
    private $total_horas = '00:00:00';

    function Header()
    {

        $this->Ln(5);
        $url_imagen = dirname(__FILE__) . '/../../pxp/lib' . $_SESSION['_DIR_LOGO'];
        $f_actual = date("d/m/Y");//date_format(date_create($this->datos[0]["fecha_solicitud"]), 'd/m/Y');
        $paginador = $this->getAliasNumPage() . '/' . $this->getAliasNbPages();
        $html = <<<EOF
		<style>
		table, th, td {		
   			font-family: "Calibri";
   			font-size: 9pt;	
		}
		
		</style>
		<table cellpadding="2" cellspacing = "0">
        	<tr>
            	<th style="width: 20%;vertical-align:middle;" align="center" rowspan="2"><img src="$url_imagen" ></th>
            	<th style="width: 60%;vertical-align:middle;" align="center" rowspan="2"><br/><br/><h2>SOLICITUD TELETRABAJO</h2></th>
            	<th style="width: 20%;" align="center" colspan="2"><div style="padding:10px 10px 10px 10px;">&nbsp;&nbsp;&nbsp;&nbsp;<b> </b></div></th>
        	</tr>
        	<tr>
        	      <th style="width: 20%;" align="center" colspan="2"><div style="padding:10px 10px 10px 10px;"><b> </b></div></th>
        	</tr>
        </table>
EOF;
        $this->writeHTML($html);
        $this->ln();
        $funcionario = $this->datos[0]['funcionario_solicitante'];
        $responsable = $this->datos[0]['responsable'];
        $departamento = $this->datos[0]['departamento'];
        $tipo_teletrabajo = $this->datos[0]['tipo_teletrabajo'];
        $tipo_temporal = '';
        if ($this->datos[0]['tipo_temporal'] != null or $this->datos[0]['tipo_temporal'] != '') {
            $tipo_temporal = ' - ' . $this->datos[0]['tipo_temporal'];
        }
        $fecha_inicio = $this->datos[0]['fecha_inicio'];
        $fecha_fin = $this->datos[0]['fecha_fin'];
        $motivo = $this->datos[0]['motivo'];
        $justificacion = $this->datos[0]['justificacion'];

        $html = <<<EOD

             <table cellspacing="0" cellpadding="1">
             <tr>
                        <th width="25%"><b>Funcionario: </b></th>
                        <td style="background: darkgray" width="75%">$funcionario</td>
                  </tr>
                  <tr>
                        <th width="25%"><b>Responsable: </b></th>
                        <td width="75%">$responsable</td>
                  </tr>
                  <tr>
                        <th width="25%"><b>Departamento: </b></th>
                        <td width="75%">$departamento</td>
                  </tr>
                 <tr>
                        <th width="25%"><b>Tipo Teletrabajo: </b></th>
                        <td width="75%">$tipo_teletrabajo $tipo_temporal</td>
                  </tr>
                   <tr>
                        <th width="25%"><b>Desde:</b></th>
                        <td width="25%" >$fecha_inicio</td>
                        <th width="25%"><b>Hasta:</b></th>
                        <td width="25%" >$fecha_fin</td>
                  </tr>
                   <tr>
                        <th width="25%"><b>Motivo: </b></th>
                        <td width="75%">$motivo</td>
                  </tr>
                   <tr>
                        <th width="15%"><b>Justificacion: </b></th>
                        <td width="85%">$justificacion</td>
                  </tr>
            </table>
EOD;
        $this->SetFont('times', '', 11);
        $this->writeHTML($html);

        $this->ln();
        $hader = '<table cellspacing="0" cellpadding="1" >
                      <tr>
                            <th  width="10%" style="border-top: 1px solid black; border-bottom: 1px solid black;" align="center"><b>Nro.</b></th>
                            <th  width="30%" style="border-top: 1px solid black; border-bottom: 1px solid black;" align="center"><b>Dia</b></th>
                            <th  width="30%" style="border-top: 1px solid black; border-bottom: 1px solid black;" align="center"><b>Fecha</b></th>
                            <th  width="30%" style="border-top: 1px solid black; border-bottom: 1px solid black;" align="center"><b>Observacion</b></th>
                      </tr>
                </table>';
        $this->SetFont('times', '', 11);
        $this->writeHTML($hader);

    }

    function reporteRequerimiento()
    {
        $this->ln();
        $numero = 1;
        $table = ' <table cellspacing="0" cellpadding="1">';
        foreach ($this->datos as $value) {

            $fecha_rango = $value['fecha_rango'];
            $dia_literal = $value['dia_literal'];
            $evento = $value['evento'];
            if($dia_literal != 'Sabado') {
                if($dia_literal != 'Domingo') {
                    $table .= '<tr>';
                    $table .= ' <td width="10%" align="center" >' . $numero . '</td>
                        <td width="30%" align="center" >' . $dia_literal . '</td>
                        <td width="30%" align="center" >' . $fecha_rango . '</td>
                        <td width="30%" align="center" >' . $evento . '</td>';
                    $table .= '</tr>';
                    $numero++;
                }
            }
        }
        $table .= '</table>';

        $this->SetFont('times', '', 11);
        $this->writeHTML($table);
        $this->ln();

    }

    function setDatos($datos)
    {
        $this->datos = $datos;
    }

    function generarReporte()
    {
        $this->SetMargins(15, 85, 15);
        $this->setFontSubsetting(false);
        $this->AddPage();
        $this->SetMargins(15, 85, 15);
        $this->reporteRequerimiento();

    }
}

?>

