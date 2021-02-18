<?php
/**
 *@package pXP
 *@file RMarcadoGral
 *@author  SAZP
 *@date 19-08-2019 15:28:39
 *@description Clase que genera el reporte de No conformidades
 * HISTORIAL DE MODIFICACIONES:

 */
class RAsistenciaPDF extends  ReportePDF{
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
<br/>
EOF;
        $this->writeHTML ($html);


        $hader = '<table cellspacing="0" cellpadding="1">
                      <tr>
                            <th style="border: 1px solid black; width: 15%" align="center"><b>Codigo</b></th>
                            <th style="border: 1px solid black; width: 15%" align="center"><b>Gerencia</b></th>
                            <th style="border: 1px solid black; width: 50%" align="center"><b>Nombre</b></th>
                            <th style="border: 1px solid black; width: 20%" align="center"><b>Observación</b></th>
                      </tr>
                </table>';
        $this->writeHTML($hader);
    }

    function reporteRequerimiento(){
        $this->ln();
        $table = ' <table cellspacing="0" cellpadding="1">';
        foreach ($this->datos as $value){

            $codigo_funcionario = $value['codigo_funcionario'];
            $codigo = $value['codigo'];
            $funcionario = $value['funcionario'];
            $observacion = $value['observacion'];


                $table .= '<tr>';
                $table .= ' <td  style="border: 1px solid black; width: 15%"  align="center" >' . $codigo_funcionario . '</td>
                            <td  style="border: 1px solid black; width: 15%"  align="center" >' . $codigo . '</td>
                            <td  style="border: 1px solid black; width: 50%"  align="left" >&nbsp; &nbsp;&nbsp; &nbsp;' . $funcionario .  '</td>
                            <td  style="border: 1px solid black; width: 20%"  align="center" >' . $observacion .   '</td>';
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
        $this->SetMargins(15,50,15);
        $this->setFontSubsetting(false);
        $this->AddPage();
        $this->SetMargins(15,50,15);
        $this->reporteRequerimiento();

    }
}
?>

