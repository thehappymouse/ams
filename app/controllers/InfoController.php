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

        if ($this->role == ROLE_MATER || $this->role == ROLE_MATER_LEAD) { //抄表员
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
            $arr["Team"][] = array("ID" => -1, "Name" => "全部");
        }

        foreach ($teams as $team) {
            $arr["Team"][] = $team->dump();
        }

        $this->addUserWithSeg($teams->getFirst()->ID, $arr);

        $this->ajax->flushData($arr);
    }

    /**
     * 根据TeamID，返回用户信息
     */
    public function UserListAction()
    {
        $teamid = $this->request->get("ID");
        $this->addUserWithSeg($teamid, $arr);
        $this->ajax->flushData($arr);
    }

    /**
     * 根据班组ID，添加用户列表，同时添加抄表段
     */
    private function  addUserWithSeg($tid, &$arr)
    {
        if ($this->role == ROLE_MATER) { //抄表员
            $users = User::find("ID=" . $this->loginUser["ID"]);
        } else if ($this->role == ROLE_MATER_LEAD) {    //班长, 添加全部字段
            $users = User::find(array("Role = 1 AND TeamID = :TID:", "bind" => array("TID" => $tid)));
        } else {
            $users = User::find(array("(Role = 1 OR Role = 3) AND TeamID = :TID:", "bind" => array("TID" => $tid)));
        }

        if($this->role != ROLE_MATER){
            $arr["Name"][] = array("ID" => "tid_$tid", "Name" => "全部");
        }

        foreach ($users as $u) {
            $arr["Name"][] = $u->dump();
        }

        //第一个用户的操表段
        if ($arr["Name"][0] != null) {
            $this->AddSegment($arr["Name"][0]["ID"], $arr);
        }
    }

    /**
     * 根据用户Id，装载抄表段
     * @param $uid
     * @param $arr
     * @return mixed
     */
    private function AddSegment($uid, &$arr)
    {

        if(($tid = User::IsAllUsers($uid))){

            $seg = DataUtil::GetSegmentDataByTid($tid);
        }
        else {
            $seg = DataUtil::GetSegmentsDataByUid($uid);
        }

        $all = array("ID" => "-1", "Number" => "全部");
        $arr["Number"][] = $all;

        foreach ($seg as $s) {
            $arr["Number"][] = $s;
        }

        return $arr;
    }

    /**
     * 根据用户ID，得到该用户的抄表段
     */
    public function SegmentListAction()
    {
        $uid = $this->request->get("ID");

        $this->AddSegment($uid, $arr);

        $this->ajax->flushData($arr);
    }
}

