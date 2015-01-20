<?php

class ChargesController extends ControllerBase
{

    public function ChargesAction()
    {

//        $db = $this->getDI()->get("db");
//
//        try
//        {
//            // Start transaction
//            $db->begin();
//
//            $u = User::findFirst(110);
//            $u->Name = "21111";
//            $u->save();
//            $db->commit();
//
//            throw new \Phalcon\Http\Client\Exception("D");
//
//        }
//        catch (\Exception $e)
//        {
//            echo "Dx";
//            $db->rollback();
//
//        }
//
//
//        echo "D";exit;
        //收费界面
    }

    public function WithDrawnAction()
    {
        $this->view->startdate = Arrears::getStartDate();

        //撤销收费界面
    }

    public function indexAction()
    {
        $this->redirect("charges/charges");
    }

    /**
     * 用户基本信息，包含用户交费信息, 撤销收费使用
     */
    public function ChargeInfoAction()
    {
        $this->view->disable();
//
//        $params = $this->request->get();
//
//        list($total, $data) = CustomerHelper::ArrearsInfo($params);
//
//        $this->ajax->total = $total;
//        $this->ajax->flushData($data);

        $id = $this->request->get("ID");
        $data = null;


        if ($id) {
            $customer = Customer::findFirst(array("Number=:id:", "bind" => array("id" => $id)));

            if ($customer) { //查询其欠费信息表
                $manyData = array();
                foreach ($customer->Charge as $ea) {
                    $manyData[] = $ea->dump();
                }

                if ($customer->IsCut) {
                    $cut = Cutinfo::findFirst(array("CustomerNumber=:num:", "bind" => array("num" => $customer->Number)));
                    $customer->CutStyle = $cut->CutStyle;
                } else {
                    $customer->CutStyle = "";
                }

                $data = $customer->dump();
                $data["Charge"] = $manyData;

                $this->ajax->flushData($data);
            } else {
                $this->ajax->flushError("此编号不存在");
            }
        } else {
            $this->ajax->flushError("没有输入查询编号");
        }
    }

    /**
     * 用户基本信息,  包含欠费信息
     */
    public function CustomerAction()
    {
        $id = $this->request->get("ID");
        $data = null;
        $this->view->disable();
        if ($id) {
            $customer = Customer::findFirst(array("Number=:id:", "bind" => array("id" => $id)));

            //$seg = Segment::findFirst(array("ID=:id", "bind" => array("id" => $customer->SegmentID)));

            if ($customer) { //查询其欠费信息表
                $arrears = array();
                foreach ($customer->Arrears as $ea) {
                    if($ea->IsClean == 1) continue;
                    $arrears[] = $ea->dump();
                }

                $customer->Team = $customer->getTeamName();

                $customer->IsCut = (int)$customer->IsCut;


                if ($customer->IsCut) {
                    $cut = Cutinfo::findFirst(array("CustomerNumber=:num:", "bind" => array("num" => $customer->Number)));
                    $customer->CutStyle = $cut->CutStyle;
                } else {
                    $customer->CutStyle = "";
                }

                $data = $customer->dump();
//                $data["Arrears"] = $arrears;

                $this->ajax->flushData($data);
            } else {
                $this->ajax->flushError("此编号不存在");
            }
        } else {
            $this->ajax->flushError("没有输入查询编号");
        }
    }

    public function ArrearsAction()
    {
        $id = $this->request->get("ID");
        $data = null;
        $this->view->disable();
        if ($id) {
            $customer = Customer::findFirst(array("Number=:id:", "bind" => array("id" => $id)));

            if ($customer) { //查询其欠费信息表
                $arrears = array();
                foreach ($customer->Arrears as $ea) {
                    if ($ea->IsClean == "1") continue;
                    $arrears[] = $ea->dump();
                }

                $this->ajax->flushData($arrears);
            } else {
                $this->ajax->flushError("此编号不存在");
            }
        } else {
            $this->ajax->flushError("没有输入查询编号");
        }
    }

    /**
     * 收费动作。
     * 收费记录与欠费记录应一一对应。 每个月都有记录
     * 重新计算客户的欠费金额和笔数
     */
    public function CreateAction()
    {
        $this->view->disable();
        $ll = new LogHelper($this->ajax->logData);

        $ids = $this->request->get("ID");
        $money = $this->request->get("Money");
        $customer = $this->request->get("Number");

        if ($ids == null) { //id为空，表示交所有欠费，再查询一次数据库
            $ars = Arrears::find("CustomerNumber = '$customer'");
        } else {
            $ars = Arrears::find("ID IN ($ids)");
            if (count($ars) == 0) {
                $this->ajax->flushError("没有查找到欠费记录");
            }
        }

        //IsAgreement
        //TODO 校验金额
        if ($this->loginUser["Role"] != ROLE_TOLL) {
            $this->ajax->flushError("非收费员不允许进行收费操作");
        }

        //接收是否租房、是否费控协议字段，客户电话 保留到客户表中
        $customerModel = Customer::findByNumber($customer);
        $customerModel->IsControl = $this->request->get("IsControl");
        $customerModel->IsRent = $this->request->get("IsRent");
        if ($this->request->get("LandlordPhone")) {
            $customerModel->LandlordPhone = $this->request->get("LandlordPhone");
        }
        if ($this->request->get("RenterPhone")) {
            $customerModel->RenterPhone = $this->request->get("RenterPhone");
        }


        $userTeam = Team::findFirst($this->loginUser["TeamID"]);
        $manager = User::findFirst(array("Name=:name:", "bind" => array("name" => $ars[0]->SegUser)));

        $errorCount = 0;
        foreach ($ars as $a) {

            if(Charge::findFirst("Year=" . $a->YearMonth . " AND CustomerNumber=" . $customer)){
                $this->ajax->flushError($customer . "在" . $a->YearMonth . "已完成收费，请重新查询");
            }

            $c = new Charge();
            $c->Money = $a->Money;
            $c->YearMonth = $a->YearMonth;
            $c->Year = substr($a->YearMonth, 0, 4);
            $c->CustomerNumber = $customer;
            $c->Segment = $a->Segment;
            $c->SegUser = $a->SegUser;
            $c->UserID = $this->loginUser["ID"];
            $c->UserName = $this->loginUser["Name"];
            $c->IsRent = $this->request->get("IsRent");
            $c->LandlordPhone = $this->request->get("LandlordPhone");
            $c->RenterPhone = $this->request->get("RenterPhone");
            $c->IsControl = $this->request->get("IsControl");
            $c->Time = date("Y-m-d H:i:s");
            $c->ChargeTeam = $userTeam->ID;
            $c->ManageTeam = $manager->Team->ID;

            $r = $c->save();

            if (!$r) {
                var_dump($c->getMessages());
                $errorCount++;
            }

            $a->IsClean = 1;
            $a->Charge = $c->UserName;
            $a->ChargeDate = $c->Time;

            $r = $a->save();

            $ll->Charge($a->ID, $r);


            if (!$r) {
                var_dump($a->getMessages());
                $errorCount++;
            }
        }

        if (!$customerModel->save()) {
            var_dump($customerModel->getMessages());
        }

        try {
            //发送消息到对应的抄表员，以便去复电。 根据客户编码，查找抄表段->抄表员和班长，写信
            $msg = new Message();
            $msg->ToUserID = $manager->ID;
            $msg->FromUserID = $this->loginUser["ID"];
            $msg->SendTime = $this->getDateTime();
            $msg->Sender = $this->loginUser["Name"];
            $msg->Content = $customerModel->Name . "  已交费";
            $msg->RefCustomer = $customer;
            $msg->IsRead = 0;
            $msg->IsImportant = $customerModel->IsCut;
            $msg->save();

            $msg->ID = null;
            $teamamanager = User::findFirst("Role=2 AND TeamID = " . $manager->TeamID);
            if($teamamanager) {
                $msg->ToUserID = $teamamanager->ID;
                $msg->save();
            }
        } catch (Exception $e) {
            $log = new SystemLog();
            $log->Action = "收费后向管理员发信";
            $log->Result = "失败";
            $log->Time = $this->getDateTime();
            $log->save();
        }

        CustomerHelper::SyncCustomerInfo($customerModel);

        if ($errorCount == 0) {
            $this->ajax->flushOk();
        } else {
            $this->ajax->flushError($errorCount);
        }
    }

    /**
     * 撤销收费的查询
     */
    public function SearchFeeAction()
    {
        $this->view->disable();
        $params = $this->request->get();
//        $params["IsClean"] = 1;

        list($total, $data, $conditions, $param) = CustomerHelper::ArrearsInfo($params);
        $this->ajax->total = $total;
        $this->ajax->flushData($data);
    }

    /**
     * 撤消收费
     * 1，将收费记录删除
     * 2，将收费记录对应的欠费记录置为未结清
     * 将用户结清置为未结清
     */
    public function CancelAction()
    {
        $this->view->disable();
        $this->ajax->logData->Action = "撤销收费";

        $errorCount = 0;

        $ids = $this->request->get("ID");

        $customer = $this->request->get("Number");
        $chargs = Charge::find("ID in ($ids)");

        $name = "";
        $logd = "";
        foreach ($chargs as $c) {
            if ($c->delete()) { //删除收费
                $a = Arrears::findFirst(array(
                        "CustomerNumber=:num:    AND  YearMonth=:YM:",
                        "bind" => array("num" => $customer, "YM" => $c->YearMonth))
                );
                $name = $a->CustomerName;
                $a->IsClean = 0;
                $a->Charge = "";
                $a->ChargeDate = "";
                $r = $a->save();
                if (!$r) {
                    var_dump($r->getMessages());
                    $errorCount++;
                }
                $logd .= "|" . $a->YearMonth . "|￥" . $a->Money;
            }
        }

        CustomerHelper::SyncCustomerByNumber($customer);

        $this->ajax->logData->Data .= $name . "|" . $customer . $logd;

        if ($errorCount == 0) {
            $this->ajax->flushOk();
        } else {
            $this->ajax->flushError($errorCount);
        }
    }


}