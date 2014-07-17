<?php


class InfoController extends ControllerBase
{

    public function initialize()
    {
        $this->view->disable();

        parent::initialize();
    }

    /**
     * 班组信息
     */
    public function  TeamListAction()
    {
        $role = $this->loginUser["Role"];

        if ($role == ROLE_MATER || $role == ROLE_MATER_LEAD) { //抄表员
            $teams = Team::find("ID=" . $this->loginUser["TeamID"]);
        } else {

            $type = $this->request->get("Type");
            if (!$type) {
                $teams = Team::find();
            } else {
                $teams = Team::find("Type=$type");
            }
        }

        foreach ($teams as $team) {
            $arr["Team"][] = $team->dump();
        }
        if (($all = $this->request->get("All") == 1) && count($arr) > 1) {
            $arr["Team"][] = array("ID" => -1, "Name" => "全部");
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
        $role = $this->loginUser["Role"];
        if ($role == ROLE_MATER) { //抄表员
            $users = User::find("ID=" . $this->loginUser["ID"]);
        } else if ($role == ROLE_MATER_LEAD) {
            $users = User::find(array("Role = 1 AND TeamID = :TID:", "bind" => array("TID" => $tid)));
        } else {
            $users = User::find(array("(Role = 1 OR Role = 3) AND TeamID = :TID:", "bind" => array("TID" => $tid)));
        }
        foreach ($users as $u) {
            $arr["Name"][] = $u->dump();
        }

        //第一个用户的操表段
        if (($user = $users->getFirst()) != null) {
            $this->AddSegment($users->getFirst()->ID, $arr);
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
        $seg = Segment::find(array("UserID = :ID: ORDER BY Number", "bind" => array("ID" => $uid)));

        $all = array("ID" => "-1", "Number" => "全部");
        $arr["Number"][] = $all;

        foreach ($seg as $s) {
            $arr["Number"][] = $s->dump();
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

