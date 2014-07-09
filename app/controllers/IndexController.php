<?php

class IndexController extends ControllerBase
{
    public function indexAction()
    {
        $rid = $this->loginUser["Role"];
        $role  = ARole::findFirst($rid);
        $page = $role->IndexPage;
        $page = $page ? $page : "site/index2";

        $this->redirect($page);
//
//        if (in_array($this->loginUser["Role"], array("1"))) {
//            $this->redirect("site/index");
//
//        } else {
//            $this->redirect("site/index2");
//        }
    }

    public function logoutAction()
    {
        $this->ajax->logData->Action = "退出系统";
        $this->ajax->logData->save();

        $this->loginUser = null;
        $this->session->remove("auth");
        $this->redirect("index/login");
    }

    public function loginAction()
    {
        $this->view->setTemplateAfter("empty");
    }

    /**
     * @param User $user
     */
    private function _registerSession($user)
    {
        $this->session->set('auth', $user->dump());
        $this->loginUser = $user->dump();
    }

    public function loginCheckAction()
    {
        $this->ajax->logData->Action = "登录";

        $name = $this->request->get("UserName");
        $pass = $this->request->get("Password");

        $r = User::findFirst(array("Name=:name: AND Pass=:pass:",
            "bind" => array("name" => $name, "pass" => sha1($pass))));

        $this->ajax->logData->UserName = $name;

        if ($r) {
            $this->ajax->logData->Result = "登录成功";
            $this->_registerSession($r);
            $this->ajax->flushData("index/index");

        } else {
            $this->ajax->flushError("用户名或密码错误");
        }
    }
}

