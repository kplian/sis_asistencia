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
    private $resumen_general = array();
    private $resumen_gerecias = array();
    private $pag = array();
    function Header(){
        $this->Ln(5);
        $url_imagen = dirname(__FILE__) . '/../../pxp/lib' . $_SESSION['_DIR_LOGO'];
        $f_actual = $this->objParam->getParametro('fecha');// date("d/m/Y");//date_format(date_create($this->datos[0]["fecha_solicitud"]), 'd/m/Y');
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
            	<th style="width: 60%;vertical-align:middle;" align="center" rowspan="2"><br/><br/><h2>REPORTE ASISTENCIA  </h2></th>
            	<th style="width: 20%;" align="center" colspan="2"><div style="padding:10px 10px 10px 10px;">&nbsp;&nbsp;&nbsp;&nbsp;</div></th>
        	</tr>
        	<tr>
        	      <th style="width: 20%;" align="center" colspan="2"><div style="padding:10px 10px 10px 10px;"><b>Fecha: </b>$f_actual</div></th>
        	</tr>
        </table>
<br/>
EOF;
        $this->writeHTML ($html);

        /*$hader = '<table cellspacing="0" cellpadding="1">
                      <tr>
                            <th style="border-top: 1px solid black; border-bottom: 1px solid black; width: 15%;" align="center"><b>Codigo</b></th>
                            <th style="border-top: 1px solid black; border-bottom: 1px solid black; width: 15%;" align="center"><b>Gerencia</b></th>
                            <th style="border-top: 1px solid black; border-bottom: 1px solid black; width: 50%;" align="center"><b>Nombre</b></th>
                            <th style="border-top: 1px solid black; border-bottom: 1px solid black; width: 20%;" align="center"><b>Observación</b></th>
                      </tr>
                </table>';

            $this->writeHTML($hader);*/


    }
    function reporteRequerimiento(){
        // $this->SetMargins(15,45,15);

        $this->ln();
        $departamento = '';
        $table = ' <table cellspacing="0" cellpadding="1">';
        foreach ($this->datos as $value){

            if (!array_key_exists($value['evento'], $this->resumen_general)) {
                $this->resumen_general[$value['evento']] = 1;
            } else {

                $this->resumen_general[$value['evento']]++;
            }
            $this->resumen_general++;

            if (!array_key_exists($value['gerencia'], $this->resumen_gerecias) ||
                !array_key_exists($value['evento'], $this->resumen_gerecias[$value['gerencia']])) {

                $this->resumen_gerecias[$value['gerencia']][$value['evento']] = 1;
            } else {

                $this->resumen_gerecias[$value['gerencia']][$value['evento']]++;
            }
            $this->resumen_gerecias++;

            $codigo_funcionario = $value['codigo_funcionario'];
            $codigo = $value['codigo'];
            $funcionario = $value['funcionario'];
            $observacion = $value['observacion'];
            if($departamento != $value['departamento']){
                $departamento = $value['departamento'];
                $table .=' <tr>
                        <th colspan="5" align="left"><b>'. $value['departamento'].'</b></th>
                  </tr>';
            }

            $table .= '<tr>';
            $table .= ' <td  style="width: 15%;"  align="center" >' . $codigo_funcionario . '</td>
                            <td  style="width: 15%;"  align="center" >' . $codigo . '</td>
                            <td  style="width: 50%;"  align="left" >&nbsp; &nbsp;&nbsp; &nbsp;' . $funcionario .  '</td>
                            <td  style="width: 20%;"  align="center" >' . $observacion .   '</td>';
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
    function resumen(){

        // $this->SetPrintHeader(false);
        $this->AddPage();
        //  $this->AddPage('L', 'LETTER');

        $general = '
        <table style="border-collapse: collapse; width: 80%; margin: 0 auto;" border="1">
            <tbody>
            <tr>
                <td style="width: 40%"align="center"><h4><b>Oficina Central</b></h4></td>
                <td style="width: 15%"align="center"><h4><b>Totales</b></h4></td>
                <td style="width: 15%"align="center"><h4><b>Porcentaje</b></h4></td>
                <td style="width: 30%"align="center"><h4><b>Observaciones</b></h4></td>
            </tr>';
        ksort($this->resumen_general);
        $total = 0;
        $porcentaje = 0;
        $calcular = 0;
        $eventos = array();
        foreach ($this->resumen_general as $key => $value ){
            $calcular = round($value/count($this->datos) *100,2);
            $general .= '<tr>
            <td style="width: 40%" >'.$key.'</td>
            <td style="width: 15%" align="center">'.$value.'</td>
            <td style="width: 15%" align="center">'.$calcular.'</td>
            <td style="width: 30%" align="center">  &nbsp;</td>
            </tr>';
            $total = $total + $value;
            $porcentaje = $porcentaje + $calcular;
            array_push($eventos,$key);
        }
        $general .= '<tr>
            <td style="width: 40%" ><b>Totales</b></td>
            <td style="width: 15%" align="center"><b>'.$total.'</b></td>
            <td style="width: 15%" align="center"><b>'.round($porcentaje).'</b></td>
            <td style="width: 30%" align="center"> &nbsp;</td>
            </tr>';

        $general .= '</tbody>
                    </table>
                    <br/>';

        $this->writeHTML($general);

        //-----gerencias------///

        foreach ($this->resumen_gerecias as $key => $value ) {
            $gerencias .= ' <table style="border-collapse: collapse; width: 70%;" border="1">
                            <tr>
                              <td style="width: 50%" align="center"><h4><b>'.  ucwords(strtolower($key)).'</b></h4></td>
                              <td style="width: 25%" align="center"><h4><b>Total</b></h4></td>
                              <td style="width: 25%" align="center"><h4><b>Porcentaje</b></h4></td>
                             </tr>
                            ';
            $total = 0;
            $porce = 0;

            foreach ($eventos as $tipo){
                if(!$value[$tipo]){
                    $value[$tipo] = 0;
                }
            }
            ksort($value);

            foreach ($value as $key2 => $value2 ){
                $calcular = round($value2/array_sum($this->resumen_gerecias[$key])*100,2);
                $gerencias .= '
                      <tr>
                            <td style="width: 50%">'.$key2.'</td>
                            <td style="width: 25%" align="center">'.$value2.'</td>
                            <td style="width: 25%" align="center">'.$calcular.'</td>
                     </tr>';

                $total = $total + $value2;
                $porce = $porce + $calcular;

            }

            $gerencias.=' <tr>
                            <td style="width: 50%"> <b>Totales</b></td>
                            <td style="width: 25%" align="center"><b>'.$total.'</b></td>
                            <td style="width: 25%" align="center"><b>'.round($porce).'</b></td>
                     </tr>
                        </table> ';
            $gerencias.='<br/><br/>';
        }

        $this->writeHTML($gerencias);
        /**/
    }
    function generarReporte() {
        $this->SetMargins(15,35,15);
        $this->setFontSubsetting(false);

        $this->AddPage();
        $hader = '<table cellspacing="0" cellpadding="1">
                      <tr>
                            <th style="border-top: 1px solid black; border-bottom: 1px solid black; width: 15%;" align="center"><b>Codigo</b></th>
                            <th style="border-top: 1px solid black; border-bottom: 1px solid black; width: 15%;" align="center"><b>Gerencia</b></th>
                            <th style="border-top: 1px solid black; border-bottom: 1px solid black; width: 50%;" align="center"><b>Nombre</b></th>
                            <th style="border-top: 1px solid black; border-bottom: 1px solid black; width: 20%;" align="center"><b>Observación</b></th>
                      </tr>
                </table>';

        $this->writeHTML($hader);
        $this->SetMargins(15,35,15);

        $this->reporteRequerimiento();
        $this->resumen();
    }
}
?>

