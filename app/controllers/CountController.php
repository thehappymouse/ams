<?php

class CountController extends ControllerBase
{
    public function singleInquiriesAction()
    {
        $number = $this->request->get("Number");

        if ($number != null) {
            $c = Customer::findByNumber($number);
            if(!$c) {
                $this->ajax->flushError("没有这个客户");
            }

            //查询客户的管理班组
            $user = User::findFirst(array("Name=:name:", "bind" => array("name" => $c->SegUser)));
            if ($user) {
                $team = Team::findFirst($user->TeamID);
                if ($team) {
                    $c->Team = $team->Name;
                }
            }

            //如果停电，则查询停电方式
            if ($c->IsCut) {
                $cut = Cutinfo::findFirst(array("CustomerNumber=:num:", "bind" => array("num" => $c->Number)));
                $c->CutStyle = $cut->CutStyle;
            }

            $arr = $c->Arrears;
            $list = array();

            foreach ($arr as $a) {
                $list[] = $a->dump();
            }

            $data =  $c->dump();// "List" => $list);
            $this->ajax->flushData($data);
        } else {
            //输界面
        }
    }

    public function singleInquiriesListAction()
    {
        $number = $this->request->get("Number");
        $isClean = $this->request->get("IsClean");

        if ($number != null) {
            $c = Customer::findByNumber($number);
            if(!$c) {
                $this->ajax->flushError("没有这个客户");
            }

            //查询客户的管理班组
            $user = User::findFirst(array("Name=:name:", "bind" => array("name" => $c->SegUser)));
            if ($user) {
                $team = Team::findFirst($user->TeamID);
                if ($team) {
                    $c->Team = $team->Name;
                }
            }

            //如果停电，则查询停电方式
            if ($c->IsCut) {
                $cut = Cutinfo::findFirst(array("CustomerNumber=:num: ORDER BY  CutTime Desc", "bind" => array("num" => $c->Number)));
                $c->CutStyle = $cut->CutStyle;
            }

            $arr = $c->Arrears;
            $list = array();

            foreach ($arr as $a) {
                if($isClean == 1){
                    if($a->IsClean != 1) continue;
                }
                else {
                    if($a->IsClean == 1) continue;
                }
                $list[] = $a->dump();
            }

            $data =  $list;
            $this->ajax->flushData($data);
        } else {
            //输界面
        }
    }

    /**
     * 对账信息
     */
    public function reconciliationInquiryAction()
    {

    }

    public function reconciliationAction()
    {

    }

    public function chargesAction()
    {

    }

    public function pressAction()
    {

    }

    public function cutAction()
    {

    }

    public function resetAction()
    {

    }

    public function customerAction()
    {
        $this->view->startdate = Arrears::getStartDate();
    }
}