<?php
/**
 *@package pXP
 *@file RMarcadoGral
 *@author  SAZP
 *@date 19-08-2019 15:28:39
 *@description Clase que genera el reporte de No conformidades
 * HISTORIAL DE MODIFICACIONES:

 */
class RMarcadoGralPDF extends  ReportePDF
{
	private $total_horas = '00:00:00';
    function Header(){
        $this->ln(8);
        $height = 50;
        //cabecera del reporte
        $this->Cell(70, $height, '', 0, 0, 'C', false, '', 0, false, 'T', 'C');
        $this->SetFontSize(15);
        $this->SetFont('', 'B');
        $this->MultiCell(105, $height,  "REPORTE DE ACCESO GENERAL", 0, 'C', 0, '', '');

        $this->Image(dirname(__FILE__) . '/../../pxp/lib' . $_SESSION['_DIR_LOGO'], 17, 10, 36);
		
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
        $pagenumtxt = 'Página'.' '.$this->getAliasNumPage().' de '.$this->getAliasNbPages();
        $this->Cell($ancho, 0, $pagenumtxt, '', 0, 'C');
        $this->Cell($ancho, 0, $_SESSION['_REP_NOMBRE_SISTEMA'], '', 0, 'R');
        $this->Ln();
        //   $fecha_rep = date("d-m-Y H:i:s");
        //  $this->Cell($ancho, 0, "Fecha : ".$fecha_rep, '', 0, 'L');
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
	//**************************************
	function RestarHoras($horaini,$horafin){
		if (($horaini <> "") && ($horafin <> "")){
			$f1 = new DateTime($horaini);
			$f2 = new DateTime($horafin);
			$d = $f1->diff($f2);
			return $d->format('%H:%I:%S');
		}
	}
	//******************************
    function suma_horas($hora1,$hora2){
				
		if (($hora1 <> "") && ($hora2 <> "")){
			$hora1=explode(":",$hora1);
			$hora2=explode(":",$hora2);
			$temp=0;
		 
			//sumo segundos 
			$segundos=(int)$hora1[2]+(int)$hora2[2];
			while($segundos>=60){
				$segundos=$segundos-60;
				$temp++;
			}
			//sumo minutos 
			$minutos=(int)$hora1[1]+(int)$hora2[1]+$temp;
			$temp=0;
			while($minutos>=60){
				$minutos=$minutos-60;
				$temp++;
			}
			//sumo horas 
			$horas=(int)$hora1[0]+(int)$hora2[0]+$temp;
		 
			if($horas<10)
				$horas= '0'.$horas;
		 
			if($minutos<10)
				$minutos= '0'.$minutos;
		 
			if($segundos<10)
				$segundos= '0'.$segundos;
		 
			$sum_hrs = $horas.':'.$minutos.':'.$segundos;
			//var_dump($sum_hrs);exit;
			//return strtotime($sum_hrs);
			return $sum_hrs; 
		}
    }	
	
	function saber_dia($nombredia) {
		$dias = array('Domingo','Lunes','Martes','Miercoles','Jueves','Viernes','Sabado');
		$dia = $dias[date('N', strtotime($nombredia))];
		return $dia;
	}	
	
    function reporteRequerimiento(){
		$vector = explode ("|", $this->datos[0]['detalles']);
        //$this->SetFont('times', 'B', 11);
		$this->SetFont('times', '', 11);
        $this->Cell(80, 7, ' Empresa: ENDE TRANSMISION', 0, 0, 'L', 0, '', 0);
        $this->SetFont('times', '', 11);
        $this->Cell(106, 7, ' Area : ' . $vector[2], 0, 0, 'R', 0, '', 0);
		$this->ln();
		
        $this->Cell(0, 7, 'Nombre Funcionario: '. $vector[1], 0, 0, 'L', 0, '', 0);
        $this->ln();

        $this->SetFont('times', '', 11);
        //$this->Cell(40, 0, 'De: '.$this->datos[0]['fecha_solicitud'], 1, 0, 'C', 0, '', 0);
		$this->Cell(80, 7, 'Periodo desde el  : '.$this->objParam->getParametro('fecha_ini'), 0, 0, 'L', 0, '', 0);
        $this->Cell(106, 7, 'Hasta el: '.$this->objParam->getParametro('fecha_fin'), 0, 0, 'L', 0, '', 0);
		$this->ln();
		$this->ln();
		
		//$this->Cell(0, 0, 'Nro.: '.$this->datos[0]['nro_tramite'], 1, 1, 'C', 0, '', 0);
		$this->SetFont('times', 'B', 11);
		//$this->SetDrawColor(0, 50, 0, 0);
		//$this->SetFillColor('yellow','');
		//$this->SetFillColor(52, 21, 0, 76);
		$this->SetFillColor(200, 200, 200);
		$this->Cell(18, 0, 'Fecha', 1, 0, 'C', 0, '', 0);
		$this->Cell(63, 0, 'MAÑANA', 1, 0, 'C', 0, '', 1);
		$this->Cell(63, 0, 'TARDE', 1, 0, 'C', 0, '', 0);
		$this->Cell(21, 0, 'Total', 1, 0, 'C', 0, '', 0);
		$this->Cell(21, 0, 'Diferencia', 1, 0, 'C', 0, '', 0);
		
        $this->ln();
	
		$this->SetFont('times', 'B', 10);
		//$this->SetColor(0,100,100,0,false,'');
		//$this->SetFillColor(0,100,100,0,tue,'');
		
		$this->Cell(18, 0, 'Marcado', 1, 0, 'C', 0, '', 0);
		$this->Cell(21, 0, 'Hra. Entrada', 1, 0, 'C', 0, '', 0);
		$this->Cell(21, 0, 'Hra. Salida', 1, 0, 'C', 0, '', 0);
		$this->Cell(21, 0, 'Hras.', 1, 0, 'C', 0, '', 0);
		$this->Cell(21, 0, 'Hra. Entrada', 1, 0, 'C', 0, '', 0);
		$this->Cell(21, 0, 'Hra. Salida', 1, 0, 'C', 0, '', 0);
		$this->Cell(21, 0, 'Hras.', 1, 0, 'C', 0, '', 0);
		$this->Cell(21, 0, 'Hras. Dia', 1, 0, 'C', 0, '', 0);
		$this->Cell(21, 0, 'Hras.', 1, 0, 'C', 0, '', 0);

        $this->ln();		
        $numero = 1;
        $pagina = 0;
		$color = '';
		$difr ='';
		$color_fila='';
		$acum_hras='00:00:00';
		
        foreach ($this->datos as $Row) {

			$vector = explode ("|", $Row['detalles']);
            //echo " valor del vector".$vector[0];
            $fecha = $vector[0];
			//se pinta la nueva linea si el dia de la fecha es viernes
			if ($this->saber_dia($fecha) == 'Viernes'){
				$color_fila = 'aquamarine';
			}else{
				$color_fila = 'white';
			}
            $hra_ent_m = $Row['hra1'];
            $hra_sal_m = $Row['hra2'];
			$hras_man = $this->RestarHoras($Row['hra1'],$Row['hra2']); 
			$hra_ent_t = $Row['hra3'];
			$hra_sal_t = $Row['hra4'];
			$hras_tar = $this->RestarHoras($Row['hra3'],$Row['hra4']);
			//se verifica si es viernes para sacar el total horas dia 
			if ($this->saber_dia($fecha) == 'Viernes'){
				$hras_dia = $this->RestarHoras($Row['hra1'],$Row['hra2']);
			}else{
				$hras_dia = $this->suma_horas($hras_man,$hras_tar);
			}

			//$hras_dia = $this->suma_horas($hras_man,$hras_tar);
			//sacamos la diferncia de horas verificando si es viernes para que se tome en cuenta solo 6 hras.
			if ($this->saber_dia($fecha) == 'Viernes'){
				if (strtotime($hras_dia) > strtotime("6:00:00")) {
					$dif_hras = $this->RestarHoras('6:00:00',$hras_dia);
					$color = 'black';
					$difr = '(+)';
				}else{
					$dif_hras = $this->RestarHoras($hras_dia,'6:00:00');
					$color = 'red';
					$difr = '(-)';
				}
			}else{
				if (strtotime($hras_dia) > strtotime("8:00:00")) {
					$dif_hras = $this->RestarHoras('8:00:00',$hras_dia);
					$color = 'black';
					$difr = '(+)';
				}else{
					$dif_hras = $this->RestarHoras($hras_dia,'8:00:00');
					$color = 'red';
					$difr = '(-)';
				}
			}

            $tbl = '
<table cellspacing="0" cellpadding="1" border="1" >
	<tr style="background-color:'.$color_fila.'">
		<td width="63.5" align="center">'.$fecha.'</td>
		<td width="74.5" align="center">'.$hra_ent_m.'</td>
		<td width="74.5" align="center">'.$hra_sal_m.'</td>
		<td width="74.5" align="center">'.$hras_man.'</td>
		<td width="74.5" align="center">'.$hra_ent_t.'</td>
		<td width="74.5" align="center">'.$hra_sal_t.'</td>
		<td width="74.5" align="center">'.$hras_tar.'</td>
		<td width="74.5" align="center">'.$hras_dia.'</td>
		<td width="74.5" align="center"><font color="'.$color.'">'.$difr.$dif_hras.'</font></td>
	</tr>
</table>
';
			if ($hras_dia != ''){	
				//$this->total_horas= $this->suma_horas_total($this->total_horas,$hras_dia);
				$this->total_horas= $this->suma_horas($this->total_horas,$hras_dia);	
			}
            $this->SetFont('times', '', 9);
            $this->writeHTML($tbl, false, false, false, false, '');
            $numero++;
            $pagina++;
        }
		//var_dump($this->total_horas);exit;	
		//$this->ln();
		$this->SetFont('times', 'B', 10);
		$this->Cell(144, 0, 'TOTAL HORAS PERIODO', 1, 0, 'R', 0, '', 0);
		$this->Cell(21, 0, $this->total_horas, 1, 0, 'C', 0, '', 0);
		$this->Cell(21, 0, '', 1, 0, 'C', 0, '', 0);
		
    }
    function setDatos($datos) {
        $this->datos = $datos;
        // var_dump($this->datos);exit;
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