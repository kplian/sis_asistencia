<?php
/**
 *@package pXP
 *@file RMarcadoGral
 *@author  SAZP
 *@date 19-08-2019 15:28:39
 *@description Clase que genera el reporte de No conformidades
 * HISTORIAL DE MODIFICACIONES:

 */
class RReporteVacacionPDF extends  ReportePDF
{
    private $total_horas = '00:00:00';
    function Header(){

        $this->Ln(5);
        $url_imagen = dirname(__FILE__) . '/../../pxp/lib' . $_SESSION['_DIR_LOGO'];
        $f_actual = date("d/m/Y");//date_format(date_create($this->datos[0]["fecha_solicitud"]), 'd/m/Y');
        $paginador = $this->getAliasNumPage().'/'.$this->getAliasNbPages();
        $fecha_ini = $this->objParam->getParametro('fecha_ini');
        $fecha_fin = $this->objParam->getParametro('fecha_fin');
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
            	<th style="width: 60%;vertical-align:middle;" align="center" rowspan="2"><br/><br/>
            	<h3>PERSONAL EN VACACIÓN</h3>
            	<h3>DEL $fecha_ini AL $fecha_fin</h3>
            	</th>
            	<th style="width: 20%;" align="center" colspan="2"><div style="padding:10px 10px 10px 10px;">&nbsp;&nbsp;&nbsp;&nbsp;<b>Página: </b>$paginador</div></th>
        	</tr>
        	<tr>
        	      <th style="width: 20%;" align="center" colspan="2"><div style="padding:10px 10px 10px 10px;"><b>Fecha: </b>$f_actual</div></th>
        	</tr>
        </table>
EOF;
        $this->writeHTML ($html);
        $this->ln();
        $header = '<table cellspacing="0" cellpadding="1" >
                    <tr>
                        <th width="15%" style="border-top: 1px solid black; border-bottom: 1px solid black;" align="center"><b>CÓDIGO</b></th>
                        <th width="40%" style="border-top: 1px solid black; border-bottom: 1px solid black;" align="center"><b>EMPLEADO</b></th>
                        <th width="10%" style="border-top: 1px solid black; border-bottom: 1px solid black;" align="center"><b>DÍAS</b></th>      
                        <th width="15%" style="border-top: 1px solid black; border-bottom: 1px solid black;" align="center"><b>TIPO CONTRATO</b></th>
                        <th width="10%" style="border-top: 1px solid black; border-bottom: 1px solid black;" align="center"><b>FEC. INICIO</b></th>
                        <th width="10%" style="border-top: 1px solid black; border-bottom: 1px solid black;" align="center"><b>FEC. FIN</b></th>
                  </tr>
                  </table>';
        $this->writeHTML($header);
        $this->ln();
    }
    function reporteRequerimiento(){

        $table = '<table cellspacing="0" cellpadding="1" > ';
        $titulo = '';
        $subtitulo = '';
        $codigo = '';
        $funcionario = '';
        $imprimir = true;

        foreach ($this->datos as $value){

            if($titulo != $value['gerencia']){
                $titulo = $value['gerencia'];
                $table .=' <tr>
                                <th colspan="5" align="left"><b>'. $value['gerencia'].'</b></th>
                          </tr>';
            }
            if($subtitulo != $value['departamento'] && $value['departamento'] != $value['gerencia']){
                $subtitulo = $value['departamento'];
                $table .=' <tr>
                                <th colspan="5" align="left"><b>'. $value['departamento'].'</b></th>
                          </tr>';
            }

            $table .= '<tr>';
            if ($codigo != $value['codigo']){
                $table .= '<br/>';
                $table .= ' <td width="15%" align="center" >'.$value['codigo'].'</td>';
                $codigo = $value['codigo'];

                $imprimir = false;
            }
            if($imprimir){
                $table .= ' <td width="15%" align="center" > </td>';
            }
            if ($funcionario!= $value['desc_funcionario1']){
                $table .= '<td  width="40%" align="left" >'.  $value['desc_funcionario1'].'</td>';
                $funcionario = $value['desc_funcionario1'];

                $imprimir = false;
            }

            if($imprimir){
                $table .= ' <td width="40%" align="center" > </td>';
            }
            $table .= '  <td  width="10%" align="center" >'.$value['dia'].' </td>
                            <td  width="15%" align="center" >'.$value['tipo_contrato'].' </td>
                             <td  width="10%" align="center" >'.$value['desde'].'</td>
                            <td  width="10%" align="center" >'.$value['hasta'].'</td>';
            $table .= '</tr>';


            $imprimir= true;
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

