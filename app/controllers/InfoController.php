<?php


class InfoController extends ControllerBase
{
    var $role;

    public function initialize()
    {
        $this->view->disable();

        parent::initialize();

        $this->role = $this->loginUser["Role"];
    }

    /**
     * 班组信息
     */
    public function  TeamListAction()
    {
        if ($this->role == ROLE_MATER || $this->role == ROLE_MATER_LEAD || $this->role == ROLE_TOLL || $this->role == ROLE_TOLL_LEAD) { //抄表员
            $teams = Team::find("ID=" . $this->loginUser["TeamID"]);
        } else {
            $type = $this->request->get("Type");
            if (!$type) {
                $teams = Team::find();
            } else {
                $teams = Team::find("Type=$type");
            }
        }

        if (($all = $this->request->get("All") == 1) && count($teams) > 1) {
            $arr[] = array("ID" => -1, "Name" => "全部");
        }

        foreach ($teams as $team) {
            $arr[] = $team->dump();
        }

        $this->ajax->flushData($arr);
    }

    /**
     * 根据TeamID，返回用户信息
     */
    public function UserListAction()
    {
        $tid = $this->request->get("ID");


        if ($this->role == ROLE_MATER) { //抄表员 只能查看自己
            $users = User::find("ID=" . $this->loginUser["ID"]);
        } else if ($this->role == ROLE_MATER_LEAD) {    //班长, 添加全部字段
            $users = User::find(array("Role = 1 AND TeamID = :TID:", "bind" => array("TID" => $tid)));
        } else {
            $users = User::find(array("(Role = 1 OR Role = 3) AND TeamID = :TID:", "bind" => array("TID" => $tid)));
        }

        if($this->role != ROLE_MATER){
            $arr[] = array("ID" => "tid_$tid", "Name" => "全部");
        }

        foreach ($users as $u) {
            $arr[] = $u->dump();
        }

        $this->ajax->flushData($arr);
    }


    /**
     * 根据用户ID，得到该用户的抄表段
     */
    public function SegmentListAction()
    {
        $uid = $this->request->get("ID");


        if(($tid = User::IsAllUsers($uid))){

            $seg = DataUtil::GetSegmentDataByTid($tid);
        }
        else {
            $seg = DataUtil::GetSegmentsDataByUid($uid);
        }

//        $all = array("ID" => "-1", "Name" => "全部");
        $all = array("ID" => "全部", "Name" => "全部");
        $arr[] = $all;
        foreach ($seg as $s) {
            $a["ID"]  = $s["Number"];
            $a["Name"] = $s["Number"];

            $arr[] = $a;
        }

        $this->ajax->flushData($arr);
    }
}

