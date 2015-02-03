<?php

/**
 * Created by PhpStorm.
 * excel导出使用
 * User: ww
 * Date: 14-6-24
 * Time: 10:57
 */
class ExportController extends ControllerBase
{
    public function initialize()
    {
        parent::initialize();
        $this->view->disable();
        include_once(__DIR__ . "/../../app/library/PHPExcel/Classes/PHPExcel.php");
    }

    private $headArrear = array(
        "Segment" => "抄表段编号",
        "CustomerNumber" => "用户编号",
        "CustomerName" => "用户名称",
        "Address" => "用电地址",
//        "YearMonth" => "电费年月",
        "Money" => "电费金额",
        "IsClean" => "结清标志",
        "IsCut" => "停电标志",
        "PressCount" => "催费次数",
        "CutCount" => "停电次数");

    private $headCount = array("Segment" => "抄表段编号",
        "CustomerNumber" => "用户编号",
        "Name" => "用户名称",
        "Address" => "用电地址",
        "YearMonth" => "电费年月",
        "Money" => "电费金额");

    /**
     * 拼接列，因为超过Z，使用AA,AB的形式
     * @param int $v
     */
    private function getCol($col)
    {
        if ($col > ord("Z")) {
            $j = (int)(($col - 65) / 26);
            $two = $col - 26 * $j;
            $one = ord("A") + $j - 1;

            $v = chr($one) . chr($two);

        } else {
            $v = chr($col);
        }
        return $v;
    }

    private function onePress($objActSheet, $years, $data)
    {
        $objActSheet->setCellValue("A1", "抄表员");
        $objActSheet->setCellValue("A2", "欠费年月");

        $yearRow = array();
        $row = 3;
        foreach ($years as $year) {
            $objActSheet->setCellValue("A" . $row++, $year);
            $yearRow[$year] = $row - 1;
        }


        $allInfoRow = $row;
        $objActSheet->setCellValue("A" . $row++, "汇总");
        $indexRow = $row;
        $objActSheet->setCellValue("A" . $row++, "排名");
        $col = ord("B");
        $index = 0;
        foreach ($data as $user) {

            $one = $this->getCol($col);
            $two = $this->getCol($col + 1);
            $end = $this->getCol($col + 2);


            $objActSheet->getStyle($one . "1")->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
            $objActSheet->setCellValue($one . "1", $user["Name"]);
            $objActSheet->mergeCells(sprintf("%s1:%s1", $one, $end));

            $objActSheet->setCellValue($one . "2", "催费完成率");
            $objActSheet->setCellValue($two . "2", "未催费户数");
            $objActSheet->setCellValue($end . "2", "未催费金额");

            if (isset($user["Data"])) {
                $userinfo = $user["Data"];

                foreach ($userinfo as $yearmonth => $info) {

                    if (isset($yearRow[$yearmonth])) {

                        $row = $yearRow[$yearmonth];
                        $objActSheet->setCellValue($one . $row, $info["Rate"]);
                        $objActSheet->setCellValue($two . $row, $info["NoPressCount"]);
                        $objActSheet->setCellValue($end . $row, $info["NoPressMoney"]);
                    }
                }
            }

            //汇总数据
            if (isset($user["AllData"])) {
                $rd = $user["AllData"];
                $objActSheet->setCellValue($one . $allInfoRow, $rd["Rate"]);
                $objActSheet->setCellValue($two . $allInfoRow, $info["NoPressCount"]);
                $objActSheet->setCellValue($end . $allInfoRow, $info["NoPressMoney"]);
            }
            ++$index;

            //排名信息
            $objActSheet->mergeCells(sprintf("%s%s:%s%s", $one, $indexRow, $end, $indexRow));
            $objActSheet->setCellValue($one . $indexRow, $index);
            $col = ord($end) + 1;

        }
    }

    /**
     * 催费情况报表
     */
    public function ReportPressAction()
    {
        list($years, $teams, $data) = ReportHelper::Press($this->request->get());

        $objPHPExcel = new PHPExcel();
        $objProps = $objPHPExcel->getProperties();

        $objActSheet = $objPHPExcel->getActiveSheet();
        $objActSheet->setTitle("抄表员");
        $this->onePress($objActSheet, $years, $data);

        $objActSheet = $objPHPExcel->createSheet(1);
        $objActSheet->setTitle("班组情况");
        $this->onePress($objActSheet, $years, $teams);

        $objPHPExcel->setActiveSheetIndex(0);
        $objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, 'Excel2007');

        $filename = "xls/催费情况报表.xls";
        $objWriter->save($filename);
        $this->ajax->flushOk("/ams/public/" . $filename);
    }

    /**
     * 工作报表
     */
    public function ReportWorkAction()
    {
        list($teams, $users) = ReportHelper::Work($this->request->get());

        $objPHPExcel = new PHPExcel();
        $objProps = $objPHPExcel->getProperties();

        $objActSheet = $objPHPExcel->getActiveSheet();
        $objActSheet->setTitle("抄表员");


        $head = array(
            "班组", "抄表员", "项目",
            "Phone" => "电话催费",
            "Notify" => "通知单催费",
            "Cut" => "停电", "Reset" => "复电", "Charge" => "回收电费", "Customer" => "目前欠费"
        );
        $col = ord("A");
        foreach ($head as $h) {
            $objActSheet->setCellValue(chr($col++) . 1, $h);
        }

        $teamYstart = 2;
        foreach ($users as $key => $user) {
            $objActSheet->mergeCells("A$teamYstart:A" . ((count($user) * 2) + $teamYstart - 1));
            $objActSheet->setCellValue("A$teamYstart", $key);

            $y_start = $teamYstart;
            foreach ($user as $uKey => $u) {
                $objActSheet->mergeCells("B" . $y_start . ":B" . ($y_start + 1));
                $objActSheet->setCellValue("B" . $y_start, $uKey);
                $objActSheet->setCellValue("C" . $y_start, "笔数");
                $objActSheet->setCellValue("C" . ($y_start + 1), "金额");

                $rowIndex = 0;
                foreach ($u as $typeKey => $ud) {
                    $col = ord("D");
                    foreach ($head as $hKey => $h) {
                        if (is_string($hKey)) {
                            $objActSheet->setCellValue(chr($col++) . ($y_start + $rowIndex), $ud[$hKey]);
                        }
                    }
                    $rowIndex++;
                }
                $y_start += 2;
            }
            $teamYstart += count($user) * 2;
        }


        $objActSheet = $objPHPExcel->createSheet(1);
        $objActSheet->setTitle("班组情况");

        $head = array(
            "班组", "项目",
            "Phone" => "电话催费",
            "Notify" => "通知单催费",
            "Cut" => "停电", "Reset" => "复电", "Charge" => "回收电费", "Customer" => "目前欠费"
        );
        $col = ord("A");
        foreach ($head as $h) {
            $objActSheet->setCellValue(chr($col++) . 1, $h);
        }
        $y_start = 2;
        foreach ($teams as $key => $user) {

            $objActSheet->mergeCells("A$y_start:A" . ((count($user)) + $y_start - 1));

            $objActSheet->setCellValue("A$y_start", $key);

            $objActSheet->setCellValue("B" . $y_start, "笔数");
            $objActSheet->setCellValue("B" . ($y_start + 1), "金额");


            $rowIndex = 0;
            foreach ($user as $typeKey => $ud) {
                $col = ord("C");
                foreach ($head as $hKey => $h) {
                    if (is_string($hKey)) {
                        $objActSheet->setCellValue(chr($col++) . ($y_start + $rowIndex), $ud[$hKey]);
                    }
                }
                $rowIndex++;
            }
            $y_start += 2;
        }

        $objPHPExcel->setActiveSheetIndex(0);
        $objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, 'Excel2007');

        $filename = "xls/每日工作报表.xls";
        $objWriter->save($filename);
        $this->ajax->flushOk("/ams/public/" . $filename);
    }

    /**
     * 预收转逾期 下载
     */
    public function AdvanceAction()
    {


        $data = CustomerHelper::Advances($this->request->get());

        $head = array(
            "CustomerNumber" => "用户编号",
            "CustomerName" => "用户名称",
            "Address" => "用电地址",
            "Balance" => "预收金额",
            "Money" => "电费金额");

        $floor = "  共计：预收转逾期电费%s笔，%s元。";

        $count = 0;
        $money = 0;

        foreach ($data[1] as $d) {
            $count++;
            $money += (int)$d["Money"];
        }
        $floor = sprintf($floor, $count, $money);



        try {
            $filename = ExcelImportUtils::arrayToExcel("预收转逾期", $head, $data[1], $floor, true);
            $this->ajax->flushOk("/ams/public/" . $filename);
        } catch (Exception $e) {
            $this->ajax->flushError($e->getMessage());
        }

    }

    /**
     * 电费回收报表
     */
    public function ReportChargeAction()
    {
        list($years, $data) = ReportHelper::Electricity($this->request->get());

        $objPHPExcel = new PHPExcel();
        $objProps = $objPHPExcel->getProperties();

        $objActSheet = $objPHPExcel->getActiveSheet();
        $objActSheet->setTitle("综合排名");

        $objActSheet->setCellValue("A1", "抄表员");
        $objActSheet->setCellValue("A2", "欠费年月");

        $yearRow = array();
        $row = 3;
        foreach ($years as $year) {
            $objActSheet->setCellValue("A" . $row++, $year);
            $yearRow[$year] = $row - 1;
        }

        $allInfoRow = $row;
        $objActSheet->setCellValue("A" . $row++, "汇总");
        $indexRow = $row;
        $objActSheet->setCellValue("A" . $row++, "排名");

        $col = ord("B");
        $index = 0;
        foreach ($data as $user) {
            $one = $this->getCol($col);
            $two = $this->getCol($col + 1);
            $end = $this->getCol($col + 2);

            $objActSheet->getStyle($one . "1")->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
            $objActSheet->setCellValue($one . "1", $user["User"]);
            $objActSheet->mergeCells(sprintf("%s1:%s1", $one, $end));

            $objActSheet->setCellValue($one . "2", "应收电费");
            $objActSheet->setCellValue($two . "2", "欠费余额");
            $objActSheet->setCellValue($end . "2", "回收率");

            $userinfo = $user["Data"];
            foreach ($userinfo as $yearmonth => $info) {
                $row = $yearRow[$yearmonth];
                $objActSheet->setCellValue($one . $row, $info["Money"]);
                $objActSheet->setCellValue($two . $row, $info["NoChargeMoney"]);
                $objActSheet->setCellValue($end . $row, $info["Rate"]);
            }

            //汇总数据
            $rd = $user["AllData"];
            $objActSheet->setCellValue($one . $allInfoRow, $rd["Money"]);
            $objActSheet->setCellValue($two . $allInfoRow, $info["NoChargeMoney"]);
            $objActSheet->setCellValue($end . $allInfoRow, $info["Rate"]);


            //排名信息
            $objActSheet->mergeCells(sprintf("%s%s:%s%s", $one, $indexRow, $end, $indexRow));
            $objActSheet->setCellValue($one . $indexRow, ++$index);
            $col = ord($end) + 1;
        }


        $objSheet2 = $objPHPExcel->createSheet(1);
        $objSheet2->setTitle("户数回收率排名");

        $objSheet2->setCellValue("A1", "抄表员");
        $objSheet2->setCellValue("A2", "欠费年月");

        $yearRow = array();
        $row = 3;
        foreach ($years as $year) {
            $objSheet2->setCellValue("A" . $row++, $year);
            $yearRow[$year] = $row - 1;
        }

        $allInfoRow = $row;
        $objSheet2->setCellValue("A" . $row++, "汇总");
        $indexRow = $row;
        $objSheet2->setCellValue("A" . $row++, "排名");

        $col = ord("B");
        $index = 0;
        foreach ($data as $user) {
            $one = $this->getCol($col);
            $two = $this->getCol($col + 1);
            $end = $this->getCol($col + 2);

            $objSheet2->getStyle($one . "1")->getAlignment()->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);
            $objSheet2->setCellValue($one . "1", $user["User"]);
            $objSheet2->mergeCells(sprintf("%s1:%s1", $one, $end));

            $objSheet2->setCellValue($one . "2", "应收户数");
            $objSheet2->setCellValue($two . "2", "欠费户数");
            $objSheet2->setCellValue($end . "2", "回收率");

            $userinfo = $user["Data"];
            foreach ($userinfo as $yearmonth => $info) {
                $row = $yearRow[$yearmonth];
                $objSheet2->setCellValue($one . $row, $info["ArrearCount"]);
                $objSheet2->setCellValue($two . $row, $info["NoChargeCount"]);
                $objSheet2->setCellValue($end . $row, $info["CountRate"]);
            }

            //汇总数据
            $rd = $user["AllData"];
            $objSheet2->setCellValue($one . $allInfoRow, $rd["ArrearCount"]);
            $objSheet2->setCellValue($two . $allInfoRow, $info["NoChargeCount"]);
            $objSheet2->setCellValue($end . $allInfoRow, $info["CountRate"]);


            //排名信息
            $objSheet2->mergeCells(sprintf("%s%s:%s%s", $one, $indexRow, $end, $indexRow));
            $objSheet2->setCellValue($one . $indexRow, ++$index);
            $col = ord($end) + 1;
        }

        $objPHPExcel->setActiveSheetIndex(0);
        $objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, 'Excel2007');

        $filename = "xls/电费回收报表.xls";
        $objWriter->save($filename);
        $this->ajax->flushOk("/ams/public/" . $filename);
    }

    /**
     * 对账查询
     */
    public function AccountCheckAction()
    {

        list($data, $total) = CountHelper::AccountCheck($this->request->get());


        $head = array("Time" => "收费时间",
            "CustomerNumber" => "用户编号",
            "CustomerName" => "用户名称",
            "YearMonth" => "电费年月",
            "Money" => "电费金额",
            "UserName" => "收费员",
            "PayState" => "解款状态",
            "LandlordPhone" => "交费登记电话",
            "IsRent" => "登记租房户信息",
            "IsControl" => "签订费控");

        foreach ($data as $key => $d) {
            $d["IsControl"] = $d["IsControl"] == 1 ? "是" : "否";
            $d["IsRent"] = $d["IsRent"] == 1 ? "是" : "否";
            if(1 == $d["PayState"]) $d["PayState"] = "已解款";
            else if(2 == $d["PayState"]) $d["PayState"] = "已二次解款";
            else $d["PayState"] = "-";

            $data[$key] = $d;
        }
        try {

            $filename = ExcelImportUtils::arrayToExcel("对账查询", $head, $data, null, true);
            $this->ajax->flushOk("/ams/public/" . $filename);
        } catch (Exception $e) {
            $this->ajax->flushError($e->getMessage());
        }
    }

    /**
     * 对账查询（财务）
     */
    public function reconciliationAction()
    {
        $param = $this->request->get();
        $data = CountHelper::Reconciliation($param);

        $head = array(
            "ChargeTeam" => "收费班组",
            "Team" => "管理班组",
            "Year" => "电费年份",
            "ChargeCount" => "收费笔数",
            "Money" => "收费金额");

        $floor = "共计:%s条，金额%s元";
        $count = 0;
        $money = 0;
        foreach ($data as $d) {
            $count += $d["ChargeCount"];
            $money += $d["Money"];
        }

        $floor = sprintf($floor, $count, $money);
        try {
            $filename = ExcelImportUtils::arrayToExcel("财务对账查询", $head, $data, $floor, true);

            $this->ajax->flushOk("/ams/public/" . $filename);
        } catch (Exception $e) {
            $this->ajax->flushError($e->getMessage());
        }
    }

    /**
     * 催费明细查询
     */
    public function countPressAction()
    {
        $param = $this->request->get();
        $param["start"] = 0;
        $param["limit"] = 10000;

        list($totalData, $data) = CountHelper::DetailsFee($param);
        foreach ($data as $key => $d) {
            $d["IsClean"] = $d["IsClean"] ? "是" : "否";
            $data[$key] = $d;
        }

        $head = array_merge($this->headCount, array(
            "PressTime" => "催费时间",
            "PressStyle" => "催费方式",
            "IsClean" => "结清标志",
        ));

        $floor = "共计：电话催费%s笔，通知单催费%s笔，共%s元。";


        $floor = sprintf($floor, $totalData["Phone"], $totalData["Notify"], $totalData["Money"]);

        try {
            $filename = ExcelImportUtils::arrayToExcel("催费明细查询", $head, $data, $floor, true);

            $this->ajax->flushOk("/ams/public/" . $filename);
        } catch (Exception $e) {
            $this->ajax->flushError($e->getMessage());
        }
    }

    /**
     * 复电统计
     */
    public function ResetAction()
    {

        $param = $this->request->get();
        $param["limit"] = 10000;
        $param["start"] = 0;
        list($data, $d2) = CountHelper::Reset($param);

        $head = array_merge($this->headCount, array(
            "IsClean" => "结清标志",
            "ResetTime" => "复电时间",
            "ResetPhone" => "复电电话"
        ));

        $f = "%s年复电:%s笔，%s元。";
        $floor = "共计:";

        foreach ($d2 as $d) {
            $floor .= sprintf($f, $d["Year"], $d["Count"], $d["Money"]);
        }
        try {
            $filename = ExcelImportUtils::arrayToExcel("复电统计", $head, $data, $floor, true);
            $this->ajax->flushOk("/ams/public/" . $filename);

        } catch (Exception $e) {
            $this->ajax->flushError($e->getMessage());
        }
    }

    /**
     * 停电统计
     */
    public function CountCutAction()
    {
        $param = $this->request->get();
        $param["limit"] = 10000;
        $param["start"] = 0;

        list($data, $d2) = CountHelper::Cut($param);
        $f = "%s年停电:%s笔，%s元。";
        $floor = "共计:";

        $head = $this->headCount;

        $head["CutTime"] = "停电时间";
        $head["CutStyle"] = "停电方式";

        foreach ($d2 as $d) {
            $floor .= sprintf($f, $d["Year"], $d["Count"], $d["Money"]);
        }

        try {
            $filename = ExcelImportUtils::arrayToExcel("停电统计", $head, $data, $floor, true);
            $this->ajax->flushOk("/ams/public/" . $filename);
        } catch (Exception $e) {
            $this->ajax->flushError($e->getMessage());
        }
    }

    /**
     * 电费回收明细
     */
    public function CountChargesAction()
    {
        $param = $this->request->get();
        $param["start"] = 0;
        $param["limit"] = 10000;
        list($total, $data) = CountHelper::Charges($param);

        $head = array_merge($this->headCount, array(
            "Time" => "收费时间",
            "UserName" => "收费员",
            "LandlordPhone" => "交费电话",
            "IsRent" => "是否租房"
        ));

        foreach ($data as $key => $d) {
            $d["IsRent"] = $d["IsRent"] ? "是" : "否";
            $data[$key] = $d;
        }

        $floor = "共计%s笔，金额%s元";
        $floor = sprintf($floor, $total["Count"], $total["Money"]);

        try {
            $filename = ExcelImportUtils::arrayToExcel("电费回收明细", $head, $data, $floor, true);

            $this->ajax->flushOk("/ams/public/" . $filename);
        } catch (Exception $e) {
            $this->ajax->flushError($e->getMessage());
        }
    }

    /**
     * 已停电用户信息导出。 停电界面使用
     */
    public function CutAction()
    {
        $params = $this->request->get();
        $params["OnlyAlreadyCut"] = "true";

        $headArr = array_merge($this->headArrear, array(
            "CutStyle" => "停电方式",
            "CutTime" => "停电时间",
            "AssetNumber" => "电能表号"
        ));

        list($total, $data) = CustomerHelper::ArrearsInfo($params);

        foreach ($data as $key => $row) {
            $cut = Cutinfo::findFirst("Arrear = " . $row["ID"]);

            //添加停电信息到数据中
            if ($cut) {
                $row["CutStyle"] = $cut->CutStyle;
                $row["CutTime"] = $cut->CutTime;
            }
            $data[$key] = $row;
        }

        $filename = ExcelImportUtils::arrayToExcel("客户分类统计", $headArr, $data, null, true);
        $this->ajax->flushOk("/ams/public/xls/" . $filename);
    }

    /**
     * 导出客户的欠费明细
     * 1, 查出
     * 2，查出关联欠费数据
     */
    public function arrearsAction()
    {
        $params = $this->request->get();


        $params["start"] = 0;
        $params["limit"] = 100000; //不再需要分页


        list($total, $data, $countinfo) = CustomerHelper::Customers($params);

        $customers = array();
        $address = array();
        $asss = array();
        foreach ($data as $d) {
            $customers[] = $d["Number"];
            $address[$d["Number"]] = $d["Address"];
            $asss[$d["Number"]] = $d["AssetNumber"];
        }
        $customers = "'" . implode("','", $customers) . "'";
        $cu = Arrears::find("CustomerNumber IN ($customers) AND IsClean=0 ORDER BY CustomerNumber");
        $data = array();
        foreach ($cu as $c) {
            $row = $c->dump();
            $row["Name"] = $c->CustomerName;
            $row["Address"] = $address[$c->CustomerNumber];
            $row["AssetNumber"] = $asss[$c->CustomerNumber];
            $data[] = $row;
        }

        $headArr = $this->headCount;

        $headArr["AssetNumber"] = "电能表号";
        $headArr["IsClean"] = "结清标志";

        $floor = "共：%s条记录，欠费用户：%s 位，停电用户：%s位，特殊用户：%s位";
        $floor = sprintf($floor, count($data), $countinfo["allCustomer"], $countinfo["cutCount"], $countinfo["specialCount"]);

        $filename = ExcelImportUtils::arrayToExcel("欠费详情", $headArr, $data, $floor, true);
        $this->ajax->flushOk("/ams/public/" . $filename);
    }

    /**
     * 催费模板，停电
     */
    public function powerfailureAction()
    {
        $params = $this->request->get();
        $params["limit"] = 100000;
        $params["start"] = 0;
        list($total, $data, $conditions, $param) = CustomerHelper::ArrearsInfo($params);

        $headArr = $this->headArrear;

        $filename = ExcelImportUtils::arrayToExcel("停电", $headArr, $data, false, true);
        $this->ajax->flushOk("/ams/public/" . $filename);

    }

    /**
     * 欠费用户信息导出 (催费、停电、客户分类统计 界面查询）
     */
    public function reminderAction()
    {
        $params = $this->request->get();
        $headArr = $this->headArrear;

        $params["start"] = 0;
        $params["limit"] = 100000; //不再需要分页

        list($total, $data, $countinfo) = CustomerHelper::Customers($params);

        foreach ($data as $key => $d) {
            $d["IsClean"] = $d["IsClean"] ? "是" : "否";
            $d["IsCut"] = $d["IsCut"] ? "是" : "否";
            $data[$key] = $d;
        }

        $floor = "共：%s条记录，欠费用户：%s 位，停电用户：%s位，特殊用户：%s位";
        $floor = sprintf($floor, count($data), $countinfo["allCustomer"], $countinfo["cutCount"], $countinfo["specialCount"]);

        $filename = ExcelImportUtils::arrayToExcel("客户分类统计", $headArr, $data, $floor, true);
        $this->ajax->flushOk("/ams/public/" . $filename);
    }
} 