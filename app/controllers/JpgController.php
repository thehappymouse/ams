<?php

require_once(__DIR__ . "/../library/jpgraph/jpgraph.php");
require_once(__DIR__ . "/../library/jpgraph/jpgraph_bar.php");
require_once(__DIR__ . "/../library/jpgraph/jpgraph_line.php");
require_once(__DIR__ . "/../library/jpgraph/jpgraph_pie.php");

//生成图片
class  JpgController extends ControllerBase
{
    public function Iconv($value, $is_Arr = false)
    {
        if ($is_Arr) {
            foreach ($value as $v) {
                $title[] = iconv("UTF-8", "gb2312", $v);
            }


        } else {
            $title = iconv("UTF-8", "gb2312", $value);

        }

        return $title;
    }

    //Home 个人排名指标柱形图
    public function SingleBarAction()
    {
        $users = User::find("Role=1");

        $uData = array();
        foreach ($users as $user) {
            $oneRes = array("User" => $user->Name);
            $seg = DataUtil::GetSegmentsByUid($user->ID);
            if (count($seg) == 0) {
                $uData[$user->Name] = 0;
                continue;
            }

            $build = $this->getBuilder("Charge", $seg);
            $build->columns("SUM(Money) AS Money");

            $r = $build->getQuery()->execute()->getFirst();
            $uData[$user->Name] = (int)$r->Money;
        }

        $datay = array();
        $name = array();
        $datay1 = array();
        $datay2 = array();
        foreach ($uData as $key => $ud) {
            $datay[] = $ud;
            $name[] = $key;
            $datay1[] = 55;
            $datay2[] = 60;
        }

//        $datay = array(62, 105, 85, 50, 10, 100); //y轴坐标数据
//        $name = array('人', 'B', 'C', 'D', 'E', 'D'); //x轴坐标数据--人名
//        $datay1 = array(55, 55, 55, 55, 55, 55, 55);
//        $datay2 = array(48, 48, 48, 48, 48, 48, 48);

        //计算图片总宽度
        $n = (count($datay) + 1) * 2;
        $siglewidth = 35; //--单一宽度
        $TotalWidth = $siglewidth * $n;


        // Create the graph. These two calls are always required
        $graph = new Graph($TotalWidth, 360, 'auto');
        $graph->SetScale("textlin");


        $graph->SetBox(false);


        $graph->ygrid->SetFill(false);
        $name = $this->Iconv($name, true);
        $graph->xaxis->SetTickLabels($name);
        $graph->xaxis->SetFont(FF_SIMSUN, FS_BOLD, 11);
        $graph->yaxis->HideLine(false);
        $graph->yaxis->HideTicks(false, false);


        //设置y轴名字

        $xtitle = $this->Iconv('综合指标');
        $graph->yaxis->title->Set($xtitle);
        $graph->yaxis->title->SetFont(FF_SIMSUN, FS_BOLD);
        $graph->yaxis->title->SetColor('black');

        // Create the bar plots
        $b1plot = new BarPlot($datay);

        $p1 = new LinePlot($datay1);
        $p2 = new LinePlot($datay2);


        // ...and add it to the graPH
        $graph->Add($b1plot);
        $graph->Add($p1);
        $graph->Add($p2);

        $p1->SetColor("blue");
        $Legend1 = "平均线";
        $Legend1 = $this->Iconv($Legend1);
        $p1->SetLegend($Legend1);

        $p2->SetColor("red");
        $Legend2 = "指标线";
        $Legend2 = $this->Iconv($Legend2);
        $p2->SetLegend($Legend2);

        $b1plot->SetColor("white");
        $b1plot->SetFillColor("#000000");
        $b1plot->SetWidth($siglewidth);
        $title = "个人排名";
        $title = $this->Iconv($title);

        $graph->legend->SetFont(FF_SIMSUN, FS_BOLD, 11);
        $graph->legend->SetFrameWeight(10);
        $graph->title->Set($title);
        $graph->title->SetFont(FF_SIMSUN, FS_BOLD, 11);


        // Display the graph
        $graph->Stroke();
        exit;

    }

    //home 欠费客户催费次数统计
    public function ArrarsCountAction()
    {
        $seg = DataUtil::GetSegmentsByUid($this->loginUser["ID"]);

        $dataLegend = array();
        $data = array();
        for ($i = 0; $i < 4; $i++) {
            if (count($seg) == 0) {
                $builder = $this->getBuilder("Arrears");
                $builder->andWhere("1 > 2");
            } else {
                $builder = $this->getBuilder("Arrears", $seg);
            }
            $builder->columns("COUNT(*) as Count");

            if ($i == 3) {
                $builder->andWhere("PressCount >=$i");
                $dataLegend[] = "3次以上";
            } else if ($i == 0) {
                $builder->andWhere("PressCount=$i OR PressCount IS NULL");
                $dataLegend[] = $i . "次";
            } else {
                $builder->andWhere("PressCount=$i");
                $dataLegend[] = $i . "次";
            }
            $r = $builder->getQuery()->execute()->getFirst();
            $data[] = $r->Count;
        }

        if ($data[0] == 0 && $data[1] == 0 && $data[2] == 0 && $data[3] == 0) {
            $data[0] = 1;
        }


//        $dataLegend = array(0,1,2,3,4,5);

//        $data = array(40, 21, 17, 14, 23);
        $dataLegend = $this->Iconv($dataLegend, true);
        // Create the Pie Graph. 
        $graph = new PieGraph(350, 350);

        $theme_class = "DefaultTheme";
        //$graph->SetTheme(new $theme_class());

        // Set A title for the plot
        $title = "欠费客户催费次数统计";
        $title = $this->Iconv($title);
        $graph->title->Set($title);
        $graph->title->SetFont(FF_SIMSUN, FS_BOLD, 11);
        $graph->SetBox(true);
        //$graph->legend->Pos(0.05,0.5,"left","center");   
        // Create
        // $data = $this->Iconv($data,true);
        $p1 = new PiePlot($data);

        $graph->Add($p1);


        $p1->ShowBorder();
        $p1->SetColor('black');

        $p1->SetSliceColors(array('#1E90FF', '#2E8B57', '#ADFF2F', '#DC143C', '#BA55D3'));
        $graph->legend->SetFont(FF_SIMSUN, FS_BOLD, 11);
        $p1->SetLegends($dataLegend);
        //
        $graph->Stroke();
        exit;
    }

    //
    /**
     * 停电统计 ? 针对欠费统计，还是针对客户统计？
     * select COUNT(IsCut) from Arrears 停电的
     *
     * select COUNT(ID) from Arrears Where PressCount >= 2 and IsCut != 1 可停电的
     *
     * select COUNT(*) as count from CutInfo where ResetTime is not null   复电的
     */
    public function CutCountAction()
    {
        $seg = DataUtil::GetSegmentsByUid($this->loginUser["ID"]);

        $data = array(0, 0, 0, 0);
        $dataLegend = array("已停电", "可停电", "已复电", "无");

        if ($seg) {

            $r = $this->getBuilder("Arrears", $seg)->columns("COUNT(*) as Count")->andWhere("IsCut =1")->getQuery()->execute()->getFirst();
            $data[0] = $r->Count;

            $r = $this->getBuilder("Arrears", $seg)->columns("COUNT(*) as Count")->andWhere("PressCount >= 2 and IsCut != 1")->getQuery()->execute()->getFirst();
            $data[1] = $r->Count;

            $r = $this->getBuilder("Cutinfo", $seg)->columns("COUNT(*) as Count")->andWhere("ResetTime is not null")->getQuery()->execute()->getFirst();
            $data[2] = $r->Count;
        }

        if(!$data[0] && !$data[1] && !$data[2]) $data[3] = 1;

//        $data = array(40, 21, 17, 14, 23);
        $dataLegend = $this->Iconv($dataLegend, true);
        // Create the Pie Graph. 
        $graph = new PieGraph(350, 350);

        $theme_class = "DefaultTheme";
        //$graph->SetTheme(new $theme_class());

        // Set A title for the plot
        $title = "停电统计";
        $title = $this->Iconv($title);
        $graph->title->Set($title);
        $graph->title->SetFont(FF_SIMSUN, FS_BOLD, 11);
        $graph->SetBox(true);
        //$graph->legend->Pos(0.05,0.5,"left","center");   
        // Create
        // $data = $this->Iconv($data,true);
        $p1 = new PiePlot($data);

        $graph->Add($p1);


        $p1->ShowBorder();
        $p1->SetColor('black');

        $p1->SetSliceColors(array('#1E90FF', '#2E8B57', '#ADFF2F', '#DC143C', '#BA55D3'));
        $graph->legend->SetFont(FF_SIMSUN, FS_BOLD, 11);
        $p1->SetLegends($dataLegend);
        //
        $graph->Stroke();
        exit;
    }


    /**
     * 当年 各月欠费户数. 如果是1月，怎么办？
     */
    public function ArrarsMonthAction()
    {

        $seg = DataUtil::GetSegmentsByUid($this->loginUser["ID"]);
        $rs = array();
        if ($seg) {
            $builder = $this->getBuilder("Arrears", $seg);

            $builder->from("Arrears")->columns("YearMonth, count(DISTINCT CustomerNumber) AS Count");

            $builder->groupBy("YearMonth");
//            $builder->andWhere("YearMonth > '20140101'");
            $rs = $builder->getQuery()->execute();
        } else {

        }
        $dataX = array();
        $dataY = array();


        for ($i = 1; $i <= (int)date('m'); $i++) {
            $ym = date('Y') . str_pad($i, 2, "0", STR_PAD_LEFT);
            $dataX[] = $ym;
            $count = 0;
            if ($rs) {
                foreach ($rs as $r) {

                    if ($r->YearMonth == $ym && in_array($r->YearMonth, $dataX)) {
                        $count += $r->Count;
                    }
                }

            }
            $dataY[] = $count;
        }

        //将年份的20去掉
        foreach($dataX as $key => $value){
            $value = substr($value, 2);
            $dataX[$key] = $value;
        }

        if (count($dataX) < 2) {
            if (!isset($dataX[0])) $dataX[0] = 0;
            $dataX[1] = $dataX[0];

            if (!isset($dataY[0])) $dataY[0] = 0;
            $dataY[] = $dataY[0];
        }

        // Setup the graph
        $graph = new Graph(1760, 250);
        $graph->SetScale("textlin");

        $theme_class = new UniversalTheme;

        $graph->SetTheme($theme_class);
        $graph->img->SetAntiAliasing(false);
        $title = "欠费月份户数及金额分布";
        $title = $this->Iconv($title);

        $graph->SetBox(false);

        $graph->img->SetAntiAliasing();

        $graph->yaxis->HideZeroLabel();
        $graph->yaxis->HideLine(false);
        $graph->yaxis->HideTicks(false, false);

        $graph->xgrid->Show();
        $graph->xgrid->SetLineStyle("solid");
        $graph->xaxis->SetTickLabels($dataX);
        $graph->xgrid->SetColor('#E3E3E3');

        // Create the first line
        $p1 = new LinePlot($dataY);
        $graph->Add($p1);
        $p1->SetColor("#6495ED");

        //设置x轴名字

        $xtitle = $this->Iconv('电费年月');
        $graph->xaxis->title->Set($xtitle);
        $graph->xaxis->title->SetFont(FF_SIMSUN, FS_BOLD, 11);
        $graph->xaxis->title->SetColor('black');

        //设置y轴名字

        $xtitle = $this->Iconv('户数');
        $graph->yaxis->title->Set($xtitle);
        $graph->yaxis->title->SetFont(FF_SIMSUN, FS_BOLD);
        $graph->yaxis->title->SetColor('black');

        $graph->legend->SetFrameWeight(1);
        $graph->title->Set($title);
        $graph->title->SetFont(FF_SIMSUN, FS_BOLD, 11);

        // Output line
        $graph->Stroke();
        exit;
    }

//例子
    public function barAction()
    {


        $data1y = array(47, 80, 40, 116);
        $data2y = array(61, 30, 82, 105);
        $data3y = array(115, 50, 70, 93);


        // Create the graph. These two calls are always required
        $graph = new Graph(350, 200, 'auto');
        $graph->SetScale("textlin");

        $theme_class = new UniversalTheme;
        $graph->SetTheme($theme_class);

        $graph->yaxis->SetTickPositions(array(0, 30, 60, 90, 120, 150), array(15, 45, 75, 105, 135));
        $graph->SetBox(false);

        $graph->ygrid->SetFill(false);
        $graph->xaxis->SetTickLabels(array('A', 'B', 'C', 'D'));
        $graph->yaxis->HideLine(false);
        $graph->yaxis->HideTicks(false, false);

        // Create the bar plots
        $b1plot = new BarPlot($data1y);
        $b2plot = new BarPlot($data2y);
        $b3plot = new BarPlot($data3y);

        // Create the grouped bar plot
        $gbplot = new GroupBarPlot(array($b1plot, $b2plot, $b3plot));
        // ...and add it to the graPH
        $graph->Add($gbplot);


        $b1plot->SetColor("white");
        $b1plot->SetFillColor("#cc1111");

        $b2plot->SetColor("white");
        $b2plot->SetFillColor("#11cccc");

        $b3plot->SetColor("white");
        $b3plot->SetFillColor("#1111cc");

        $graph->title->Set("Bar Plots");

        // Display the graph
        $graph->Stroke();
        exit;

    }


    public function lineAction()
    {
        $datay1 = array(20, 15, 23, 15);
        $datay2 = array(12, 9, 42, 8);
        $datay3 = array(5, 17, 32, 24);

        // Setup the graph
        $graph = new Graph(300, 250);
        $graph->SetScale("textlin");

        $theme_class = new UniversalTheme;

        $graph->SetTheme($theme_class);
        $graph->img->SetAntiAliasing(false);
        $graph->title->Set('Filled Y-grid');
        $graph->SetBox(false);

        $graph->img->SetAntiAliasing();

        $graph->yaxis->HideZeroLabel();
        $graph->yaxis->HideLine(false);
        $graph->yaxis->HideTicks(false, false);

        $graph->xgrid->Show();
        $graph->xgrid->SetLineStyle("solid");
        //$graph->xaxis->SetTickLabels(array('A','B','C','D'));
        $graph->xgrid->SetColor('#E3E3E3');

        // Create the first line
        $p1 = new LinePlot($datay1);
        $graph->Add($p1);
        $p1->SetColor("#6495ED");
        $p1->SetLegend('Line 1');

        // Create the second line
        $p2 = new LinePlot($datay2);
        $graph->Add($p2);
        $p2->SetColor("#B22222");
        $p2->SetLegend('Line 2');

        // Create the third line
        $p3 = new LinePlot($datay3);
        $graph->Add($p3);
        $p3->SetColor("#FF1493");
        $p3->SetLegend('Line 3');

        $graph->legend->SetFrameWeight(1);

        // Output line
        $graph->Stroke();
        exit;
    }

    public function pieAction()
    {
        $dataLegend = array("Jan 份", "Feb", "Mar", "Apr", "May");
        $data = array(40, 21, 17, 14, 23);

        // Create the Pie Graph. 
        $graph = new PieGraph(450, 350);

        $theme_class = "DefaultTheme";
        //$graph->SetTheme(new $theme_class());

        // Set A title for the plot
        $graph->title->Set("A Simple Pie Plot");
        $graph->SetBox(true);
        //$graph->legend->Pos(0.05,0.5,"left","center");   
        // Create
        $p1 = new PiePlot($data);

        $graph->Add($p1);


        $p1->ShowBorder();
        $p1->SetColor('black');
        $p1->SetSliceColors(array('#1E90FF', '#2E8B57', '#ADFF2F', '#DC143C', '#BA55D3'));
        $p1->SetLegends($dataLegend);

        $graph->Stroke();
        exit;
    }
}