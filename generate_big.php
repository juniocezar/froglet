<?php // content="text/plain; charset=utf-8"
require_once ('JpGraph/jpgraph/src/jpgraph.php');
require_once ('JpGraph/jpgraph/src/jpgraph_line.php');
require_once ('JpGraph/jpgraph/src/jpgraph_scatter.php');
require_once ('JpGraph/jpgraph/src/jpgraph_utils.inc.php');

$datax = array('1');
$datay = array('1');
$i = 0;
$name;

$fp = fopen('in','r') or die("can't open file");
$csv_line = fgetcsv($fp,1024);
$name = $csv_line[0];

while($csv_line = fgetcsv($fp,1024)) {
  $datax[$i] = (float)($csv_line[0]/1000); // Divide por 1000 para passar o tamanho de bytes para KB
  $datay[$i] = (float)$csv_line[1];
  $i=$i+1;
}
fclose($fp) or die("can't close file");

$linreg = new LinearRegression($datax, $datay);
list( $stderr, $corr ) = $linreg->GetStat();
list( $xd, $yd ) = $linreg->GetY(0,$datax[sizeof($datax)-1]);


// Setup the graph
$graph = new Graph(450,330);
$graph->SetScale("linlin");

$theme_class=new UniversalTheme;

$graph->SetTheme($theme_class);
$graph->SetMargin(60,50,40,10);
$graph->img->SetAntiAliasing(false);
$graph->title->Set($name);
$graph->title->SetColor('darkred');
$graph->subtitle->Set('(standard error='.sprintf('%.4f',$stderr).', correlation coefficient='.sprintf('%.4f',$corr).')');
$graph->SetBox(false);
//$graph->img->SetAntiAliasing();

$graph->yaxis->HideZeroLabel();
$graph->yaxis->HideLine(false);
$graph->yaxis->HideTicks(true,false);
$graph->yaxis->SetTitle("time (milliseconds)","center");
$graph->yaxis->SetTitleMargin(35);

//$graph->xgrid->Show();
$graph->xgrid->SetLineStyle("solid");
//$graph->xaxis->SetTickLabels(array('A','B','C','D'));
$graph->xaxis->HideLine(false);
$graph->xaxis->HideTicks(true,false);
$graph->xgrid->SetColor('#E3E3E3');
$graph->xaxis->SetTitle("Bytecodes' size (KB)");;
$graph->xaxis->SetTitleMargin(15);

// Grafico de dispersao

$sp1 = new ScatterPlot($datay,$datax);
$graph->Add($sp1);
$sp1->SetLegend('Runtime');
$sp1->mark->SetType(MARK_FILLEDCIRCLE);
$sp1->mark->SetFillColor('red');
$sp1->mark->SetWidth(2);


// Gráfico de linhas

$p1 = new LinePlot($yd,$xd);
$graph->Add($p1);
$p1->SetColor('blue');
$p1->SetLegend('Linear Regression');
$graph->legend->SetFrameWeight(1);
$graph->legend->SetPos(0.5,0.9,'center','top');



// Output line
$graph->Stroke();


?>

