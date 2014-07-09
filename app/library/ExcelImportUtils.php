<?php

/**
 * Created by PhpStorm.
 * User: chenxi
 * Date: 14-5-22
 * Time: 上午11:45
 */
class ExcelImportUtils
{

    /**
     * 预收表格。此时应计算欠费记录，进行预收转逾期
     * @param $filepath 文件路径
     */
    public static function importAdvance($filepath)
    {

        $data = ExcelImportUtils::readExcel($filepath);

        if (count($data[0]) != 12) {
            throw new Exception("数据格式不正确，请查正");
        }

        foreach ($data as $idx => $row) {
            $arr = array();
            $arr["Name"] = $row["C"];
            $arr["Number"] = $row["B"];
            $arr["Balance"] = $row["G"];
            $arr["Address"] = $row["D"];
            $arr["Segment"] = $row["E"];
            $arr["SegmentName"] = $row["F"];
            $arr["SegUser"] = $row["L"];
            $arr["Phone"] = "";


            self::saveCustomer($arr);
            self::saveSegment($arr);
            self::advancefee($arr);
        }
    }

    /**
     * 对一个客户进行预收转逾期计算。
     * 如果所有欠费之和小于预存款，将欠费记录和客户状态修改为预收转逾期。否则，不做任何操作
     * @param $data
     */
    public static function advancefee($data)
    {
        $arrears = Arrears::findByNumber($data["Number"]);
        $total = 0.0;
        foreach ($arrears as $a) {
            $total += (float)$a->Money;
        }

        if ($total < $data["Balance"]) {
            foreach ($arrears as $a) {
                $a->IsClean = 2;
                $a->save();
            }
        }
        $customer = Customer::findByNumber($data["Number"]);
        $customer->IsClean = 2;
        $customer->save();
    }

    /**
     * 保存一个抄表段
     * @param array $row
     */
    private static function saveSegment(array $row)
    {
        $s = Segment::findFirst("Number = '$row[Segment]'");

        if (null == $s) {
            $s = new Segment();
            $s->Number = $row["Segment"];
            $s->Name = $row["SegmentName"];
            $s->UserName = $row["SegUser"];

            $user = User::findFirst(array("Name=:name:", "bind" => array("name" => $s->UserName)));
            if ($user) {
                $s->UserID = $user->ID;
            }

            if (!$s->save()) {
                var_dump($s->getMessages());
            }
        }

    }

    /**
     * @param array $row
     * @return Customer|\Phalcon\Mvc\Model
     */
    private static function saveCustomer(array $row)
    {
        $c = Customer::findFirst("Number = '$row[Number]'");

        $now = date("Y-m-d H:i:s");
        if (null == $c) {
            $c = new Customer();
            $c->Name = $row["Name"];
            $c->Number = $row["Number"];
            $c->Address = $row["Address"];
            $c->Balance = $row["Balance"];
            $c->Segment = $row["Segment"];
            $c->SegUser = $row["SegUser"];
            $c->CreateTime = $now;
            $c->LandlordPhone = $row["Phone"];
            $c->IsClean = 0;
            $c->IsControl = 0;
            $c->IsRent = 0;
            $c->IsClean = 0;

            $c->save();
        }
        return $c;
    }


    /**
     * 欠费信息表
     * @param $filepath
     */
    public static function importArrears($filepath)
    {
        $data = ExcelImportUtils::readExcel($filepath);
        if (count($data[0]) != 8) {
            throw new Exception("数据格式不正确，请查正");
        }

        foreach ($data as $row) {
            $a = new Arrears();

            $a->YearMonth = $row["A"];
            $a->CustomerNumber = $row["B"];
            $a->CustomerName = $row["C"];
            $a->Money = $row["E"];
            $a->Segment = $row["F"];
            $a->IsClean = 0;
            $a->PressCount = 0;
            $a->CutCount = 0;
            $a->IsCut = 0;


            $arr = array(
                "Name" => $row["C"], "Segment" => $row["F"], "SegmentName" => "",
                "SegUser" => $row["G"], "Number" => $row["B"], "Phone" => $row["H"],
                "Balance" => 0, "Address" => $row["D"]);

            try {

                if (Arrears::findFirst("YearMonth = $row[A] AND CustomerNumber = $row[B]") == null) {
                    $r = $a->save();
                    if (!$r) {
                        var_dump($a->getMessages());
                    }
                }

                self::saveCustomer($arr);
                self::saveSegment($arr);

            } catch (PDOException $e) {
                var_dump($e->getMessage());
            }
        }
    }

    private static function readExcel($filepath)
    {
        $objPHPExcel = PHPExcel_IOFactory::load($filepath);
        $sheetData = $objPHPExcel->getSheet(0)->toArray(null, true, true, true);

        return array_slice($sheetData, 1);
    }


    /**
     * 将数组生成表格，并下载
     * @param $fileName
     * @param $headArr
     * @param $data
     * @param $floor 表格底部的统统信息
     */
    public static function arrayToExcel($fileName, $headArr, $data, $floor = false)
    {
        if (empty($data) || !is_array($data)) {
            die("没有数据，无法导出");
        }

        $date = date("Y_m_d", time());
        $fileName .= "_{$date}.xls";
        $fileName = iconv( "UTF-8", "gb2312" , $fileName);

        //创建新的PHPExcel对象
        $objPHPExcel = new PHPExcel();
        $objProps = $objPHPExcel->getProperties();
        PHPExcel_Shared_Font::setAutoSizeMethod(PHPExcel_Shared_Font::AUTOSIZE_METHOD_EXACT);
        //表头
        $start = ord("A");
        foreach ($headArr as $v) {
            $column = chr($start);
            $objPHPExcel->setActiveSheetIndex(0)->setCellValue($column . '1', $v);
            $start += 1;
            $objPHPExcel->getActiveSheet()->getColumnDimension($column)->setAutoSize(true);
        }

        $row = 2;
        $objActSheet = $objPHPExcel->getActiveSheet();

        foreach ($data as $rows) {
            $span = ord("A");
            foreach ($headArr as $key2 => $v) { //表头中含有对应数据索引
                $j = chr($span);
                //按照B2,C2,D2的顺序逐个写入单元格数据
                $cell = $objActSheet->getCell($j . $row);
                $cell->getStyle()->getNumberFormat()->setFormatCode(PHPExcel_Style_NumberFormat::FORMAT_TEXT);
                $cell->getStyle()->getNumberFormat()->setFormatCode("@");
                $cell->setValue((string)$rows[$key2]);

                //移动到当前行右边的单元格
                $span++;
            }
            //移动到excel的下一行
            $row++;
        }

        if ($floor) {
            $row++;
            $objPHPExcel->getActiveSheet()->mergeCells("A$row:". chr(count($headArr) -1 + ord("A")) ."$row" );
            $objActSheet->setCellValue("A". ($row), $floor);
        }

        $objPHPExcel->getActiveSheet()->setTitle('Simple');
        //设置活动单指数到第一个表,所以Excel打开这是第一个表
        $objPHPExcel->setActiveSheetIndex(0);

        $objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, 'Excel2007');
        //脚本方式运行，保存在当前目录
        //$objWriter->save($fileName);

        // 输出文档到页面
        header('Content-Type: application/vnd.ms-excel');
        header('Content-Disposition: attachment;filename="' . $fileName . '"');
        header('Cache-Control: max-age=0');
        $objWriter->save("php://output");
    }
} 