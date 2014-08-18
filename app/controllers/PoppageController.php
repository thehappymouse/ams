<?php

class  PopPageController extends ControllerBase
{
    public function initialize()
    {
        parent::initialize();

        $this->view->setTemplateAfter("pop");
    }

    public function ReminderFeeAction($id, $number, $yeaer)
    {
        $s = Press::find(array("Arrear=$id"));
        $this->view->ps = $s;
    }

    public function CancelAction($id, $number, $year)
    {
        $s = Charge::find("CustomerNumber=$number");

        $this->view->cs = $s;
        $this->view->customerid = $number;
    }

    /**
     * 停电次数
     */
    public function PowerCutAction($id, $number, $year)
    {
        $s = Cutinfo::find("Arrear=$id");

        $this->view->cs = $s;
    }

    /**
     * 客户信息
     */
    public function InfoAction($id, $number, $year)
    {
        $c = Customer::findByNumber($number);

        //查询客户的管理班组
        $user = User::findFirst(array("Name=:name:", "bind" => array("name" => $c->SegUser)));
        if($user){
            $team = Team::findFirst($user->TeamID);
            if($team) {
                $c->Team = $team->Name;
            }
        }

        $c->ArrearsCount = Arrears::count("CustomerNumber=$number");

        //停电方式
        if($c->IsCut == 1) {
            $cutInfo = Cutinfo::findFirst("CustomerNumber=$number");
            if($cutInfo){
                $c->CutStyle = $cutInfo->CutStyle;
            }
        }
        else {
            $c->CutStyle="";
        }

        $this->view->customer = $c;
        $this->view->arrears = $c->Arrears;
    }

     //用户修改页面
    public function ModifyUserAction($id)
    {
        $user = User::findFirst($id);
        $this->view->user = $user;

        $ttype = 0;
        if($user->Role <= 2) $ttype = 1;
        else if($user->Role <=4) $ttype = 2;

        $ts = Team::find("Type=$ttype");
        $this->view->ts = $ts;
    }

   
}
