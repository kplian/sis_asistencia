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
    public $titulo_reporte;
    function Header(){
        $this->Ln(5);
        $url_imagen = dirname(__FILE__) . '/../../pxp/lib' . $_SESSION['_DIR_LOGO'];
        $f_actual = $this->objParam->getParametro('fecha');// date("d/m/Y");//date_format(date_create($this->datos[0]["fecha_solicitud"]), 'd/m/Y');

        if ($this->objParam->getParametro('tipo') == 'General'){
            $this->titulo_reporte = 'REPORTE ASISTENCIA';
        }else{
            $this->titulo_reporte = 'RESUMEN ASISTENCIA';
        }

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
                            <th style="border-top: 1px solid black; border-bottom: 1px solid black; width: 10%;" align="center"><b>Codigo</b></th>
                            <th style="border-top: 1px solid black; border-bottom: 1px solid black; width: 35%;" align="center"><b>Nombre</b></th>
                            <th style="border-top: 1px solid black; border-bottom: 1px solid black; width: 35%;" align="center"><b>Cargo</b></th>
                            <th style="border-top: 1px solid black; border-bottom: 1px solid black; width: 20%;" align="center"><b>Observación</b></th>
                      </tr>
                </table>';


        if ($this->objParam->getParametro('tipo') == 'General'){
            $this->writeHTML($hader);
        }

    }
    function reporteRequerimiento(){

        // var_dump($this->objParam->getParametro('tipo_filtro'));exit;
        //  retraso
        $this->ln();
        if($this->objParam->getParametro('tipo_filtro') == 'todo'){
            $departamento = '';
            $table = ' <table cellspacing="0" cellpadding="1">';
            foreach ($this->datos as $value){
                $codigo_funcionario = $value['codigo_funcionario'];
                $cargo = $value['cargo'];
                $funcionario = $value['funcionario'];
                $observacion = $value['observacion'];
                if($departamento != $value['departamento']){
                    $departamento = $value['departamento'];
                    $table .=' <tr>
                            <td colspan="4" align="left"><b>'. $value['departamento'].'</b></td>
                    </tr>';
                }
                $color = '';
                $retraso = $value['retraso'];
                if($retraso == 'si' ){
                    $color = 'color: #d55906';
                }
                $ausente = $value['ausente'];
                if($ausente == 'si' ){
                    $color = 'color: red';
                }
                $table .= '<tr>';
                $table .= '     <td  style="width: 10%; '.$color.'"  align="center" >' . $codigo_funcionario . '</td>
                                <td  style="width: 35%; '.$color.'"  align="left" >' . $funcionario . '</td>
                                <td  style="width: 35%; '.$color.'"  align="left" >' . $cargo .  '</td>
                                <td  style="width: 20%; '.$color.'"  align="center" >' . $observacion .   '</td>';
                $table .= '</tr>';

            }
            $table .= '</table>';
        }else{
            $departamento = '';
            $table = ' <table cellspacing="0" cellpadding="1">';
            foreach ($this->datos as $value){
                if ($value['observacion'] != 'En oficina'){
                    $codigo_funcionario = $value['codigo_funcionario'];
                    $cargo = $value['cargo'];
                    $funcionario = $value['funcionario'];
                    $observacion = $value['observacion'];
                    if($departamento != $value['departamento']){
                        $departamento = $value['departamento'];
                        $table .=' <tr>
                                <td colspan="4" align="left"><b>'. $value['departamento'].'</b></td>
                        </tr>';
                    }

                    $table .= '<tr>';
                    $table .= '     <td  style="width: 10%;"  align="center" >' . $codigo_funcionario . '</td>
                                    <td  style="width: 35%;"  align="left" >' . $funcionario . '</td>
                                    <td  style="width: 35%;"  align="left" >' . $cargo .  '</td>
                                    <td  style="width: 20%;"  align="center" >' . $observacion .   '</td>';
                    $table .= '</tr>';
                }

            }
            $table .= '</table>';
        }

        $this->SetFont('times', '', 10);
        $this->writeHTML($table);
        $this->ln();

    }
    function setDatos($datos) {
        $this->datos = $datos;
    }
    function resumen(){
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
        }
        $general = '
        <table style="border-collapse: collapse; width: 100%; margin: 0 auto;" border="1">
            <tbody>
            <tr>
                <td style="width: 40%"align="center"><h4><b>OFICINA CENTRAL</b></h4></td>
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
            $gerencias .= ' <table style="border-collapse: collapse; width: 100%;" border="1">
                            <tr>
                              <td style="width: 40%" align="center"><h4><b>'.$key.'</b></h4></td>
                              <td style="width: 15%" align="center"><h4><b>Total</b></h4></td>
                              <td style="width: 15%" align="center"><h4><b>Porcentaje</b></h4></td>
                              <td style="width: 30%"align="center"><h4><b>Observaciones</b></h4></td>
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
                            <td style="width: 40%">'.$key2.'</td>
                            <td style="width: 15%" align="center">'.$value2.'</td>
                            <td style="width: 15%" align="center">'.$calcular.'</td>
                            <td style="width: 30%" align="center"> </td>
                     </tr>';

                $total = $total + $value2;
                $porce = $porce + $calcular;

            }

            $gerencias.=' <tr>
                            <td style="width: 40%"> <b>Totales</b></td>
                            <td style="width: 15%" align="center"><b>'.$total.'</b></td>
                            <td style="width: 15%" align="center"><b>'.round($porce).'</b></td>
                            <td style="width: 30%" align="center"> </td>
                     </tr>
                        </table> ';
            $gerencias.='<br/><br/>';
        }

        $this->writeHTML($gerencias);
        /**/
    }
    function generarReporte() {

        if ($this->objParam->getParametro('tipo') == 'General'){
            $this->SetMargins(15,39,15);
            $this->setFontSubsetting(false);
            $this->AddPage();
            $this->SetMargins(15,39,15);
            $this->reporteRequerimiento();
        }else{
            $this->SetMargins(35,39,35);
            $this->setFontSubsetting(false);
            $this->AddPage();
            $this->SetMargins(35,39,35);
            $this->resumen();
        }
    }
}
?>

