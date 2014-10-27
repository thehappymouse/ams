<?php

class  PopPageController extends ControllerBase
{
    public function initialize()
    {
        parent::initialize();

        $this->view->setTemplateAfter("pop");
    }

    public function ReminderFeeAction()
    {
        $number = $this->request->get("Number");
        $s = Press::find(array("CustomerNumber=$number"));
        $data = array();
        foreach($s as $c){
            $data[] = $c->dump();
        }
        $this->ajax->flushData($data);
    }

    /**
     * @param $id
     * @param $number
     * @param $year
     */
    public function CancelAction()
    {
        $number = $this->request->get("Number");
        $s = Charge::find("CustomerNumber=$number");
        $data = array();
        foreach($s as $c){
            $data[] = $c->dump();
        }
        $this->ajax->flushData($data);
        exit;
    }

    /**
     * 停电次数
     */
    public function PowerCutAction()
    {
        $number = $this->request->get("Number");
        $s = Cutinfo::find("CustomerNumber=$number");
        $data = array();
        foreach($s as $c){
            $data[] = $c->dump();
        }
        $this->ajax->flushData($data);
    }

    /**
     * 客户详细信息
     */
    public function InfoAction()
    {
        $number = $this->request->get("Number");
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
        $this->ajax->flushData($c);
        $this->view->customer = $c;
        $this->view->arrears = $c->Arrears;
    }

    /**
     * 客户信息
     */
    public function userInfoAction()
    {
        $number = $this->request->get("Number");

        $Arrears = Arrears::find("CustomerNumber=$number");
        $n = Arrears::count("CustomerNumber=$number");
        $data = array();
        foreach($Arrears as $c){
            $data[] = $c->dump();
        }
        $this->ajax->total = $n;
        $this->ajax->flushData($data);
    }

     //用户修改页面
    public function ModifyUserAction()
    {
        $user = User::findFirst($this->request->get("ID"));
        $this->view->user = $user;

        $ttype = 0;
        if($user->Role <= 2) $ttype = 1;
        else if($user->Role <=4) $ttype = 2;

        $ts = Team::find("Type=$ttype");
        $this->ajax->flushData($user->dump());

    }
}
