<?php

class ManagerController extends ControllerBase
{
    //用户呈现页面
    public function indexAction()
    {
    }

    /**
     * 根据ID，获取角色名称
     * @param $id
     * @return string
     */
    private function getRoleName($id)
    {
        $role = ARole::findFirst($id);
        if ($role != null) {
            return $role->Name;
        } else {
            return "";
        }
    }

    /**
     * 显示用户列表
     */
    public function UserListAction()
    {

        $start = $this->request->get("start");
        $limit = $this->request->get("limit");
        $users = User::find("Name!='admin' ORDER BY TeamID, Role DESC, ID limit $start, $limit");
        $data = array();
        foreach ($users as $u) {



            $row = $u->dump();
            if ($u->Team) {

                $row["TeamName"] = $u->Team->Name;
            }
            else {
                $row["TeamName"] = "";
            }
            $data[] = $row;
        }

        $this->ajax->total = User::count("Name!='admin'");
        $this->ajax->flushData($data);
    }

    /**
     * Ajax
     * 班组数据
     */
    public function GroupListAction()
    {
        $start = $this->request->get("start");
        $limit = $this->request->get("limit");
        $gs = Team::find("1=1 limit $start, $limit");
        $data = array();
        foreach ($gs as $g) {
            $data[] = $g->dump();
        }
        $this->ajax->total = Team::count();
        $this->ajax->flushData($data);
    }

    /**
     * 删除 班组
     */
    public function GroupDelAction()
    {
        $this->ajax->logData->Action = "删除班组";
        $id = $this->request->get("ID");

        if ($id && (($u = Team::findFirst($id)) != null)) {

            $user = User::findFirst("TeamID=$id");
            if($user){
                $this->ajax->flushError("班组下存在用户，无法删除");
            }

            $this->ajax->logData->Data =  $u->Name;
            $u->delete();
            $this->ajax->flushOk("班组信息已删除");
        } else {
            $this->ajax->flushError("没有这个班组");
        }

    }

    /**
     * 删除用户 Ajax
     */
    public function UserDelAction()
    {
        $this->ajax->logData->Action = "删除用户";
        $id = $this->request->get("ID");
        if ($id && (($u = User::findFirst($id)) != null)) {
            $this->ajax->logData->Data =  $u->Name;
            $u->delete();
            $this->ajax->flushOk("用户已删除");
        } else {
            $this->ajax->flushError("没有这个用户");
        }
    }

    //用户创建页面
    public function buildAction()
    {

    }

    /**
     * 用户创建提交
     */
    public function BuildAjaxAction()
    {
        $this->ajax->logData->Action="创建用户";
        $name = $this->request->get("UserName");
        $this->ajax->logData->Data = $name;
        if (User::findFirst(array("Name=:name:", "bind" => array("name" => $name)))) {
            $this->ajax->flushError("用户名已存在");
        }
        $u = new User();
        $u->Name = $name;
        $u->Pass = sha1($this->request->get("Password"));
        $u->Role = $this->request->get("Duty");
        $u->RoleName = $this->getRoleName($u->Role);
        $u->CreateTime = $this->getDateTime();
        $u->TeamID = $this->request->get("Group");
        $r = $u->save();
        if ($r) {
            $this->ajax->flushOk("创建成功");
        } else {
            $ms = $u->getMessages();
            $this->ajax->flushError($ms[0]->getMessage());
        }
    }


    //用户管理
    public function UserAction()
    {

    }

    //班组管理
    public function GroupAction()
    {

    }

    //班组创建
    public function GroupBuildAction()
    {

    }

    public function SystemlogAction()
    {

    }

    /**
     * 修改用户密码
     */
    public function ChangePasswordAction()
    {
        $uid = $this->loginUser["ID"];
        $user = User::findFirst($uid);

        $newpass = $this->request->get("newPassWord");
        $oldpass = $this->request->get("oldPassWord");

        if($user->Pass == sha1($oldpass)){

            $user->Pass = sha1($newpass);
            if($user->save()){
                $this->ajax->flushOk("操作已成功");
            }
            else {
                var_dump($user->getMessages());
            }

        }
        else {
            $this->ajax->flushError("原始密码不正确");
        }

    }

    /**
     * 用户修改提交
     */
    public function UserEditAction()
    {
        $this->ajax->logData->Action = "修改用户";

        $id = $this->request->get("ID");
        $pass = $this->request->get("Password");

        $u = User::findFirst($id);
        if ($pass != "") {
            $u->Pass = sha1($pass);
        }

        if(($g = $this->request->get("TeamID")) != null){
            $u->TeamID = $this->request->get("TeamID");
        }

        $this->ajax->logData->Data = $u->Name;

        if ($u->save()) {
            $this->ajax->flushOk("修改成功");
        } else {
            var_dump($u->getMessages());
            $this->ajax->flushError("修改失败");
        }

    }

    /**
     * 根据类型 返回不同班组
     * @param $type
     */
    public function GetGroupAction()
    {

        $Duty = $this->request->get("Duty");
        $ts = Team::find("Type=$Duty");
        $data = array();
        foreach ($ts as $a) {
            $data[] = $a->dump();
        }
        $this->ajax->flushData($data);
    }

    /**
     * 提交班组创建
     */
    public function GroupBuildAjaxAction()
    {
        $this->ajax->logData->Action="创建班组";
        $team = new Team();
        $team->Name = $this->request->get("Team");
        $team->Type = $this->request->get("Duty");
        if (1 == $team->Type) {
            $team->TypeName = "抄表";
        } else if (2 == $team->Type) {
            $team->TypeName = "收费";
        }

        $this->ajax->logData->Data = $team->Name . "|" . $team->TypeName;
        $r = $team->save();
        if ($r) {
            $this->ajax->flushOk("创建成功");
        } else {
            $ms = $team->getMessages();
            $this->ajax->flushError($ms[0]);
        }
    }
}

