<?php

class CountsearchController extends ControllerBase
{

    public function initialize()
    {
        $this->view->disable();
        parent::initialize();
    }


    /**
     * 对账查询
     * 参数： Team, Name
     */
    public function ReconciliationInquiryAction()
    {
        list($data, $total) = CountHelper::AccountCheck($this->request->get());

        $this->ajax->flushData($data);
    }

    /**
     * 对账查询
     * 参数： Team, Name
     */
    public function ReconciliationInquiryListAction()
    {
        list($data, $total) = CountHelper::AccountCheck($this->request->get());

        $this->ajax->flushData($total);
    }

    /**
     * 对账查询 子表  显示 收费员的收费情况
     */
    public function ChargeCountAction()
    {
        $uid = $this->request->get("Name");
        $start = $this->request->get("FromData");
        $end = $this->request->get("ToData");


        if(($tid = User::IsAllUsers($uid))){
            if($tid == -1){
                $users = User::find("Role=" . ROLE_TOLL);
            }
            else {
                $users = User::find("TeamID=$tid AND Role=" . ROLE_TOLL);
            }
        }
        else {
            $users = User::find("ID=$uid");
        }

        $data = array();
        foreach($users as $user){

            $b = $this->getBuilder("Charge");
            $c = $b->columns(array("UserID", "SUM(Money) AS Money", "count(ID) as Count", "Sum(IsControl) as ControlCount "))
                ->andWhere("UserID=$user->ID")
                ->andWhere("Time BETWEEN :start: AND :end:")
                ->getQuery()->execute(array("start" => $start, "end" => $end))->getFirst();
            if($c){
                $row = array();
                $row["UserName"] = $user->Name;
                $row["Money"] = (int)$c->Money;
                $row["Count"] = (int)$c->Count;
                $row["ControlCount"] = (int)$c->ControlCount;
                $data[] = $row;
            }
        }
        $this->ajax->flushData($data);
    }

    /**
     * 对账查询--》 财务
     */
    public function ReconciliationAction()
    {
        $total = CountHelper::Reconciliation($this->request->get());

        $this->ajax->flushData($total);
    }

    /**
     * 电费回收明细查询
     */
    public function ChargesAction()
    {
        list($totaldata, $data) = CountHelper::Charges($this->request->get());

        $this->ajax->total = $totaldata["Count"];
        $this->ajax->TotalData = $totaldata;
        $this->ajax->flushData($data);//array("Data" => $data, "TotalData" => $totaldata));
    }

    /**
     * 催费统计查询
     */
    public function pressAction()
    {
        list($totalData, $data) = CountHelper::DetailsFee($this->request->get());

        $this->ajax->total = $totalData["Count"];
        $this->ajax->TotalData = $totalData;
        $this->ajax->flushData($data);
    }

    /**
     * 停电数据查询
     */
    public function CutAction()
    {
        list($data, $d2, $total) = CountHelper::Cut($this->request->get());

        if ($data == null && $d2 == null) {
            $this->ajax->flushData($data);
        }
        $str  = "";
        foreach($d2 as $key => $v){
            $str .= "$key 年，停电 $v[Count] 笔，金额为 $v[Money]；";
        }
        $this->ajax->data2 = $str;
        $this->ajax->total = $total["Count"];
        $this->ajax->flushData($data);
    }

    /**
     * 复电查询
     */
    public function ResetAction()
    {
        list($data, $d2, $total) = CountHelper::Reset($this->request->get());
        if ($data == null && $d2 == null) {
            $this->ajax->flushData($data);
        }

        $str  = "";
        foreach($d2 as $key => $v){
            $str .= "$key 年，复电 $v[Count] 笔，金额为 $v[Money]；";
        }

        $this->ajax->data2 = $str;
        $this->ajax->total = $total["Count"];
        $this->ajax->flushData($data);

    }

    /**
     * 客户分类统计，和催费查询一样
     */
    public function customerAction()
    {
        $params = $this->request->get();

        list($total, $data, $countInfo) = CustomerHelper::Customers($params);
//        list($total, $data) = CustomerHelper::ArrearsInfo($params);


        $this->ajax->total = $total;
        $this->ajax->countInfo = $countInfo;
        $this->ajax->flushData($data);
    }

}

