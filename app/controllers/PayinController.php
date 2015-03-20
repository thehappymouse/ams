<?php

/**
 * Class PayinController 解款相关的
 */
class PayinController extends ControllerBase
{

    public function indexAction()
    {
    }

    public function unindexAction()
    {
    }

    public function headerAction()
    {
    }

    public function userListAction()
    {
        $users = array();
        $arr = array();
        $role = $this->loginUser["Role"];
        if ($role == ROLE_TOLL) { //抄表员 只能查看自己
            $users = User::find("ID=" . $this->loginUser["ID"]);
        } else if ($role == ROLE_TOLL_LEAD) {    //班长, 添加全部字段
            $users = User::find(array("Role = 2 AND TeamID = :TID:", "bind" => array("TID" => $this->loginUser["TeamID"])));
        }
        else {
            $this->ajax->flushError("非收费角色不能查询");
        }

        foreach ($users as $u) {
            $arr[] = $u->dump();
        }

        $this->ajax->flushData($arr);
    }

    /**
     * 查询已解款的项目
     */
    public function unlistAction()
    {
        $startdate = $this->request->get("StartDate");
        $enddate = $this->request->get("EndDate");

        $style = $this->request->get("PayStyle");
        $uid = $this->request->get("Number");


        $condation = "(PayinTime between :date1: and :date2:) ";
        $params = array("date1" => $startdate . " 00:00", "date2" => $enddate . " 23:50");

        $condation .= "AND PayUserID=:uid:";
        $params["uid"] = $uid;

//        if(ROLE_TOLL == $this->loginUser["Role"]){
////            $condation .= "AND UserID=:uid: ";
////            $params["uid"] = $this->loginUser["ID"];
//        }
//        else if(ROLE_TOLL_LEAD == $this->loginUser["Role"]){
//            //查询其班下的
//            $condation .= "ChargeTeam ＝:tid:";
//            $params["tid"] = $this->loginUser["Team"];
//        }

        if(-1 != $style){
            $condation .= "AND PayStyle=:style:";
            $params["style"] = $style;
        }


        $out = array();
        $datas = Charge::find(array($condation, "bind" => $params));
        $allmoney = 0;
        $allpay = 0;
        $allpaycount = 0;
        foreach($datas as $d){
            $allmoney += $d->Money;
            if($d->PayState){
                $allpay += $d->Money;
                $allpaycount++;
            }
            $out[] = $d->dump();
        }
        $total = "总笔数:%s, 总金额:%s, 解款笔数:%s, 解款金额:%s";
        $this->ajax->total = sprintf($total, count($datas), $allmoney, $allpaycount, $allpay);
        //总笔数，总金额，解款笔数，解款金额
        $this->ajax->flushData($out);
        $this->view->disable();
    }

    /**
     * 查询 收费及解款信息。 仅查询当前账户相关的
     */
    public function listAction()
    {
        $date = $this->request->get("Date");
        $style = $this->request->get("PayStyle");
        $state = $this->request->get("PayState");


        $condation = "(Time between :date1: and :date2:) ";

        $params = array("date1" => $date . " 00:00", "date2" => $date . " 23:50");

        if(ROLE_TOLL == $this->loginUser["Role"]){
            $condation .= "AND UserID=:uid: ";
            $params["uid"] = $this->loginUser["ID"];
        }
        else if(ROLE_TOLL_LEAD == $this->loginUser["Role"]){
            //查询其班下的
            $condation .= " AND ChargeTeam=:tid: ";
            $params["tid"] = $this->loginUser["TeamID"];
        }

        if(-1 != $style){
            $condation .= "AND PayStyle=:style:";
            $params["style"] = $style;
        }

        if(-1 != $state){
            if(0 == $state){
                $condation .= "AND (PayState=:state: OR PayState IS NULL)";
                $params["state"] = $state;
            }
            else {
                $condation .= "AND PayState=:state:";
                $params["state"] = $state;
            }
        }

        $out = array();
        $datas = Charge::find(array($condation, "bind" => $params));
        $allmoney = 0;
        $allpay = 0;
        $allpaycount = 0;
        foreach($datas as $d){
            $allmoney += $d->Money;
            if($d->PayState){
                $allpay += $d->Money;
                $allpaycount++;
            }
            $out[] = $d->dump();
        }
        $total = "总笔数:%s, 总金额:%s, 解款笔数:%s, 解款金额:%s  &nbsp;&nbsp;";
        $this->ajax->total = sprintf($total, count($datas), $allmoney, $allpaycount, $allpay);
        //总笔数，总金额，解款笔数，解款金额
        $this->ajax->flushData($out);
        $this->view->disable();
    }

    /**
     *  解款撤还
     */
    public function undoAction()
    {
        $ids = $this->request->get("ids");
        $charges = Charge::find("ID IN ($ids)");

        $errorcount = 0;
        foreach($charges as $c){
            if(2 == $c->PayState) {
                $errorcount++;
                continue;
            }

            $c->PayState = 0;
            $c->PayinTime = "";
            $c->PayUserID = "";
            $c->PayUserName = "";
            $r = $c->save();

            if(!$r){
                $errorcount++;
            }
        }
        if(0 == $errorcount) {
            $this->ajax->flushOk("操作已成功");
        }
        else {
            $this->ajax->flushError("部分记录操作失败");
        }
    }

    /**
     * 班长二级解款
     */
    public function headerdoAction()
    {
        $ids = $this->request->get("ids");
        $charges = Charge::find("ID IN ($ids)");

        $errorcount = 0;
        foreach($charges as $c){

            $c->PayState = 2;
            $c->PayinTime = $this->getDateTime();
            $r = $c->save();
            if(!$r){
                $errorcount++;
            }
        }
        if(0 == $errorcount) {
            $this->ajax->flushOk("操作已成功");
        }
        else {
            $this->ajax->flushError("部分记录操作失败");
        }
    }

    /**
     * 解款
     */
    public function doAction()
    {
        $ids = $this->request->get("ids");
        $charges = Charge::find("ID IN ($ids)");

        $errorcount = 0;
        foreach($charges as $c){
            $c->PayState = 1;
            $c->PayinTime = $this->getDateTime();
            $c->PayUserID = $this->loginUser["ID"];
            $c->PayUserName = $this->loginUser["Name"];
            $r = $c->save();

            if(!$r){
                $errorcount++;
            }
        }
        if(0 == $errorcount) {
            $this->ajax->flushOk("操作已成功");
        }
        else {
            $this->ajax->flushError("部分记录操作失败");
        }
    }

}

