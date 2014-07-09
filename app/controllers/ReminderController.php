<?php

class ReminderController extends ControllerBase
{

    public function ReminderAction()
    {
        //催费
    }

    public function PowerFailureAction()
    {
        //停电
    }

    public function cancelAction()
    {
        //撤销催费
    }


    public function restorationAction()
    {
        //复电
    }

    public function ReceiptsAction()
    {
        //预收转逾期
    }


    /**
     * 查询欠费信息. 供催费和停电查询
     */
    public function SearchFeeAction()
    {
        $this->view->disable();

        $params = $this->request->get();

        list($total, $data) = CustomerHelper::ArrearsInfo($params);

        $this->ajax->total = $total;
        $this->ajax->flushData($data);
    }

    /**
     * 撤销催费查询
     */
    public function searchpressAction()
    {
        $this->view->disable();
        $params = $this->request->get();
        $params["OnlyHasPress"] = "true";

        list($total, $data) = CustomerHelper::ArrearsInfo($params);

        $this->ajax->total = $total;
        $this->ajax->flushData($data);
    }

    /**
     * 复电时查询。只能查询已停电的。 时间条件则为停电时间
     */
    public function SearchResetAction()
    {
        $params = $this->request->get();
        $params["OnlyAlreadyCut"] = "true";

        $start = $params["FromData"];
        $end = $params["ToData"];

        unset($params["FromData"]);
        unset($params["ToData"]);


        list($total, $data) = CustomerHelper::ArrearsInfo($params);
        $result = array();
        foreach ($data as $key => $row) {

            $cut = Cutinfo::findFirst("Arrear = " . $row["ID"]);
            if ($cut->CutTime > $end || $cut->CutTime < $start) {
                continue;
            }
            //添加停电信息到数据中
            if ($cut) {
                $row["CutStyle"] = $cut->CutStyle;
                $row["CutTime"] = $cut->CutTime;
            }

            $result[] = $row;
        }

        $this->ajax->total = $total;
        $this->ajax->flushData($result);
    }


    /**
     * 操作停电。
     * 1，插入停电信息
     * 2，将用户停电状态改为已停
     */
    public function CutAction()
    {
        $this->view->disable();
        $this->ajax->logData->Action = "停电";

        list($r, $cut, $arrear) = CustomerHelper::Cut($this->request->get());

        if ($r) {
            $this->ajax->logData->Data = $arrear->CustomerName . "|" . $arrear->CustomerNumber . "|(￥)" . $arrear->Money;

            $this->ajax->flushOk();
        } else {
            $this->ajax->flushError("操作失败");
        }
    }

    /**
     * 执行撤销催费
     */
    public function cancelpressAction()
    {
        $id = $this->request->get("ID");
        $this->ajax->logData->Action = "撤销催费";

        $arrear = Arrears::findFirst("ID=$id");
        if ($arrear->PressCount > 0) {
            $arrear->PressCount--;
            $arrear->save();
        }

        $press = Press::findFirst("Arrear=$id ORDER BY PressTime DESC");

        if ($press->PressStyle == "通知单催费") { //删除文件
            $root = "/opt/lampp/htdocs/ams";
            $filename = $root . $press->Photo;
            if (is_file($filename)) {
                unlink($root . $press->Photo);
            }
        }

        $r = $press->delete();

        $this->ajax->logData->Data = sprintf("撤销(%s)于(%s)的(%s)", $press->UserName, $press->PressTime, $press->PressStyle);

        $this->ajax->flushOk();
    }

    /**
     * 进行一个催费动作
     * 1，接收表单： 欠费信息ID, 房东电话，时间，照片，催费方式
     * 2，欠费记录中，催费次数加1
     */
    public function PressAction()
    {
        $this->view->disable();

        $press = new Press();
        $press->Arrear = $this->request->get("ID");
        if (!$press->Arrear) {
            $this->ajax->flushError("没有传入数据ID");
        }

        $press->PressTime = $this->request->get("PressTime");

        $ar = Arrears::findFirst($press->Arrear);

//        $press->UserID = ""
        $press->UserName = $ar->Customer->SegUser;
        $press->CustomerNumber = $ar->Customer->Number;
        $press->Segment = $ar->Segment;
        $press->YearMonth = $ar->YearMonth;
        $press->Money = $ar->Money;

        if ($this->request->hasFiles()) {
            $press->PressStyle = "通知单催费";

            $files = $this->request->getUploadedFiles("Photo");
            $file = $files[0];

            $dir = str_replace("/app/controllers", "/public/images/", __DIR__);
            $root = "/opt/lampp/htdocs/ams";
            $savefile = $dir . $file->getName();

            if (move_uploaded_file($file->getTempName(), $savefile)) {

                $press->Photo = str_replace($root, "", $savefile);
            } else {
                var_dump("文件上传失败" . $savefile);
            }
        } else {
            $press->PressStyle = "电话催费";
        }

        $r = $press->save();

        $this->ajax->logData->Action = $press->PressStyle;
        $this->ajax->logData->Data = $ar->CustomerName . "|" . $ar->CustomerNumber . "|$ar->YearMonth|￥$ar->Money";
        if ($r) {
            $ar->PressCount = (int)$ar->PressCount + 1;
            $ar->save();
        } else {
            var_dump($press->getMessages());
        }
        $this->ajax->flushOk();
    }

    /**
     * 预收转逾期查询
     */
    public function AdvanceAction()
    {
        $data = CustomerHelper::Advances($this->request->get());

        $this->ajax->flushData($data);
    }


    /**
     * 复电操作
     *  复电操作在复电信息表 同时客户状态改变
     */
    public function ResetAction()
    {

        $this->ajax->logData->Action = "复电";


        $param = $this->request->get();
        $param["User"] = $this->loginUser["Name"]; //复电用户

        list($r, $cut, $arrear) = CustomerHelper::Reset($param);
        if ($r) {

            $this->ajax->logData->Data = $arrear->CustomerName . "|" . $arrear->CustomerNumber;

            $this->ajax->flushOk();
        } else {
            var_dump($cut->getMessages());
            $this->ajax->flushError("信息保存失败");
        }
    }
}
