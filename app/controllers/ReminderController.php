<?php

class ReminderController extends ControllerBase
{


    public function ReminderAction()
    {
        $this->view->startdate = Arrears::getStartDate();
        //催费
    }

    public function PowerFailureAction()
    {
        $this->view->startdate = Arrears::getStartDate();
        //停电
    }

    public function cancelAction()
    {
        $this->view->startdate = Arrears::getStartDate();
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


        list($total, $data, $conditions, $param) = CustomerHelper::ArrearsInfo($params);

        $builder = $this->modelsManager->createBuilder();
        $result = $builder->columns(array("Count(*) as Count, SUM(Money) as Money "))
            ->from("Customer")
            ->andWhere($conditions)
            ->andWhere("IsClean=0")
            ->getQuery()->execute($param)->getFirst();

        $count = $result->Count;
        $money = $result->Money;
        $countinfo = array("arrearsCount" => $count, "arrearsMoney" => $money);

        $this->ajax->countInfo = $countinfo;

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
        $params["PowerCutLogo"] = 1;

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
     * 2014-08-08 一次可以停电多个
     */
    public function CutAction()
    {
        $this->view->disable();

        $ll = new LogHelper($this->ajax->logData);

        list($r, $ids) = CustomerHelper::Cut($this->request->get());

        foreach ($ids as $id) {
            $ll->Cut($id, $r);
        }

        if ($r) {
            $this->ajax->flushOk();
        } else {
            $this->ajax->flushError("操作失败");
        }
    }

    /**
     * 执行撤销催费
     * 2014-08-08 一次可以取消多个
     * 2014-10-27 id变更为催费ID
     */
    public function cancelpressAction()
    {
        $ids = $this->request->get("ID");
        $ids = explode(",", $ids);

        $this->ajax->logData->Action = "撤销催费";
        foreach ($ids as $id) {

            $press = Press::findFirst("ID=$id");
            $arrear = Arrears::findFirst($press->Arrear);

            if ($arrear->PressCount > 0) {
                $arrear->PressCount--;
                $arrear->save();
            }

            if ("通知单催费" == $press->PressStyle) { //删除文件
                $root = "/opt/lampp/htdocs/ams";
                $filename = $root . $press->Photo;
                if (is_file($filename)) {
                    unlink($root . $press->Photo);
                }
            }

            $r = $press->delete();

            if($r){
                $this->ajax->success = true;
            }
            else{
                var_dump($press->getMessages());
            }

            CustomerHelper::SyncCustomerInfo($arrear->Customer);
            $this->ajax->logData->Data .= sprintf("撤销(%s)于(%s)的(%s)", $press->UserName, $press->PressTime, $press->PressStyle);
        }
        $this->ajax->flush();
    }

    /**
     * 进行一个催费动作
     * 1，接收表单： 欠费信息ID, 房东电话，时间，照片，催费方式
     * 2，欠费记录中，催费次数加1
     * 20140824  多记录同时催费
     */
    public function PressAction()
    {
        $this->view->disable();

        $ids = explode(",", $this->request->get("ID"));

        $pressPhoto = "";
        $pressPhone = $this->request->get("Phone");


        if($this->request->get("reminderStyle") == 1){
            if(!$this->request->hasFiles()){
                $this->ajax->flushError("未上传通知单照片");
            }
        }

        if ($this->request->hasFiles()) {
            $pressStyle = "通知单催费";

            $files = $this->request->getUploadedFiles("Photo");
            $file = $files[0];

            $dir = str_replace("/app/controllers", "/public/upload/", __DIR__);
            $root = "/opt/lampp/htdocs/ams";
            $dir =  $dir . date("Ym") . "/";
            if(!is_dir($dir)){
                mkdir($dir);
            }

            $savefile = $dir . $this->loginUser["ID"] . "_" . time() . ".jpg"; // $file->getName();

            if (move_uploaded_file($file->getTempName(), $savefile)) {
                $pressPhoto = str_replace($root, "", $savefile);
            } else {
                var_dump("文件上传失败" . $savefile);
            }
        } else {
            $pressStyle = "电话催费";
        }

        $ll = new LogHelper($this->ajax->logData);

        foreach ($ids as $id) {
            $press = new Press();
            $press->Arrear = $id;
            if (!$press->Arrear) {
                $this->ajax->flushError("没有传入数据ID");
            }

            $press->PressTime = $this->request->get("PressTime");

            $ar = Arrears::findFirst($press->Arrear);

            //        $press->UserID = ""
            $press->SegUser = $ar->SegUser;
            $press->CustomerNumber = $ar->Customer->Number;
            $press->Segment = $ar->Segment;
            $press->YearMonth = $ar->YearMonth;
            $press->Money = $ar->Money;
            $press->PressStyle = $pressStyle;
            $press->Phone = $pressPhone;
            $press->PhoneType = $this->request->get("PhoneType");
            $press->Photo = $pressPhoto;
            $r = $press->save();

            $ll->Press($id, $r, $pressStyle);

            if ($r) {
                $ar->PressCount = (int)$ar->PressCount + 1;
                $ar->save();
            } else {
                var_dump($press->getMessages());
            }

            CustomerHelper::SyncCustomerInfo($ar->Customer);
        }


        $this->ajax->flushOk();
    }

    /**
     * 预收转逾期查询
     */
    public function AdvanceAction()
    {
        list($total, $data) = CustomerHelper::Advances($this->request->get());

        $this->ajax->TotalInfo = $total;
        $this->ajax->total = $total["Count"];
        $this->ajax->flushData($data);
    }


    /**
     * 复电操作
     *  复电操作在复电信息表 同时客户状态改变
     */
    public function ResetAction()
    {
        $ll = new LogHelper($this->ajax->logData);

        $param = $this->request->get();
        $param["User"] = $this->loginUser["Name"]; //复电用户

        list($r, $ids) = CustomerHelper::Reset($param);

        foreach($ids as $id){
            $ll->Reset($id, $r);
        }
        $this->ajax->flushOk();

    }
}
