<?php
/**
 * Created by PhpStorm.
 * User: ww
 * Date: 14-3-12
 * Time: 16:29
 */
use Phalcon\Events\Event,
    Phalcon\Mvc\User\Plugin,
    Phalcon\Mvc\Dispatcher,
    Phalcon\Acl,
    Phalcon\Acl\Role;

class Security extends Phalcon\Mvc\User\Plugin
{

    public function __construct($dependencyInjector)
    {
        $this->_dependencyInjector = $dependencyInjector;
    }

    /**
     * 将资源添加到控制列表
     * @param $acl
     * @param $rs
     */
    private function  addAlcResource($acl, $rs)
    {
        foreach ($rs as $resource => $actions) {
            $acl->addResource(new Phalcon\Acl\Resource($resource), $actions);
        }
    }

    /**
     * 详细的控制规则
     * @param $acl
     * @param $rs
     * @param $role
     */
    private function addAclAllow($acl, $rs, $role)
    {
        foreach ($rs as $resource => $actions) {
            foreach ($actions as $action) {
                $acl->allow($role, $resource, $action);
            }
        }
    }

    public function getAcl()
    {
//        if (!isset($this->persistent->acl)) {

            $acl = new Phalcon\Acl\Adapter\Memory();

            $acl->setDefaultAction(Phalcon\Acl::DENY);

            //Register roles
            $roles = array(
                '1' => new Role('抄表员'), //抄表员
                '2' => new Role('抄表员班长'),
                '3' => new Role('收费员'),
                '4' => new Role('收费员班长'),
                '5' => new Role('对账员'),
                '6' => new Role('管理人员'),
                'guests' => new Role('Guests') //来宾，未登录
            );

            foreach ($roles as $role) {
                $acl->addRole($role);
            }

            $adminResource = array(
                "index" => array("index","logout","login","logincheck"),
                "site" => array("index","error","index2"),
                "charges" => array("charges","withdrawn","index","chargeinfo","customer","create","cancel"),
                "reminder" => array("reminder","powerfailure","cancel","restoration","receipts","searchfee","searchpress","searchreset","cut","cancelpress","press","advance","reset"),
                "import" => array("arrears","advance","progress","advanceupload","arrearsupload"),
                "report" => array("electricity","press","work"),
                "reportsearch" => array("electricity","user","press","work"),
                "info" => array("teamlist","userlist","segmentlist"),
                "count" => array("singleinquiries","reconciliationinquiry","reconciliation","charges","press","cut","reset","customer"),
                "countsearch" => array("reconciliationinquiry","reconciliation","charges","press","cut","reset","customer"),
                "jpg" => array("singlebar","arrarscount","cutcount","arrarsmonth","bar","line","pie"),
                "systemlog" => array("index","list"),
                "poppage" => array("reminder","powercut","info","modifyuser", "reminderfee"),
                "manager" => array("index","userlist","grouplist","groupdel","userdel","build","buildajax","user","group","groupbuild","systemlog","useredit","getgroup","groupbuildajax"),
                "customer" => array("index","update"),
                "export" => array("reportpress","reportwork","advance","reportcharge","accountcheck","reconciliation","press","reset","countcut","countcharges","cut","reminder")
            );

            //抄表员
            $materResource = array(
                "site" => array("index", "index2"),

                "poppage" => array("reminder","powercut","info", "reminderfee"),
                "info" => array("teamlist", "userlist", "segmentlist"),
                "export" => array("reportpress", "reportwork", "advance", "reportcharge", "accountcheck", "reconciliation", "press", "reset", "countcut", "countcharges", "cut", "reminder"),
                "count" => array("press", "cut", "reset", "customer"),
                "countsearch" => array("reconciliationinquiry", "reconciliation", "charges", "press", "cut", "reset", "customer"),
                "jpg" => array("singlebar", "arrarscount", "cutcount", "arrarsmonth", "bar", "line", "pie"),
                "reminder" => array("reminder", "powerfailure", "cancel", "restoration", "searchfee", "searchpress", "searchreset", "cut", "cancelpress", "press", "reset"),
                "countsearch" => array("reconciliationinquiry", "reconciliation", "charges", "press", "cut", "reset", "customer"),
            );

            //抄表员班长
            $role_mater_leadResource = array_merge($materResource, array(
                "reminder" => array("reminder", "powerfailure", "cancel", "restoration", "searchfee", "searchpress",
                    "searchreset", "cut", "cancelpress", "press", "advance", "reset", "receipts"),
                "report" => array("work", "electricity","press"),
                "reportsearch" => array("work","electricity","press"),
                "count" => array("press", "cut", "reset", "customer", "singleinquiries", "charges"),

                "export" => array("reportpress", "reportwork", "advance", "reportcharge", "accountcheck", "reconciliation", "press", "reset", "countcut", "countcharges", "cut", "reminder"),
                "import" => array("advance", "progress", "advanceupload", "arrears", "arrearsupload"),
            ));

            //收费员
            $role_tollResource = array(
                "site" => array("index", "index2"),"index" => array("index"),
                "poppage" => array("info"),
                "charges" => array("charges", "withdrawn", "index", "chargeinfo", "customer", "create", "cancel"),
            );

            //收费员班长
            $role_toll_leadResource = array_merge($role_tollResource, array(
                "count" => array("customer", "reconciliationinquiry", "singleinquiries"),
                "countsearch" => array("customer", "reconciliationinquiry"),
                "info" => array("teamlist", "userlist", "segmentlist"),
                "export" => array("reportpress", "reportwork", "advance", "reportcharge", "accountcheck", "reconciliation", "press", "reset", "countcut", "countcharges", "cut", "reminder"),
                "export" => array("reportpress", "reportwork", "advance", "reportcharge", "accountcheck", "reconciliation", "press", "reset", "countcut", "countcharges", "cut", "reminder"),
            ));

            //对账员
            $role_financeResource = array(
                "site" => array("index", "index2"),
                "info" => array("teamlist", "userlist", "segmentlist"),
                "poppage" => array("info"),
                "count" => array("singleinquiries", "reconciliationinquiry", "reconciliation", "customer"),
                "countsearch" => array("reconciliationinquiry", "reconciliation", "customer"),
                "export" => array("reportpress", "reportwork", "advance", "reportcharge", "accountcheck", "reconciliation", "press", "reset", "countcut", "countcharges", "cut", "reminder"),
            );

            //管理员
            $role_managerResource = array(
                "site" => array("index", "index2"),
                "info" => array("teamlist", "userlist", "segmentlist"),
                "reminder" => array("cancel", "restoration", "searchfee", "searchpress", "searchreset", "advance"),
                "countsearch" => array("reconciliationinquiry", "reconciliation", "charges", "press", "cut", "reset", "customer"),
                "count" => array("singleinquiries", "reconciliationinquiry", "reconciliation", "charges", "press", "cut", "reset", "customer"),
                "export" => array("reportpress", "reportwork", "advance", "reportcharge", "accountcheck", "reconciliation", "press", "reset", "countcut", "countcharges", "cut", "reminder"),
                "systemlog" => array("index", "list"),
                "report" => array("electricity", "press", "work"),
                "poppage" => array("reminder","powercut","info","modifyuser"),
                "reportsearch" => array("electricity", "user", "press", "work"),
                "manager" => array("index", "userlist", "grouplist", "groupdel", "userdel", "build", "buildajax", "user", "group", "groupbuild", "systemlog", "useredit", "getgroup", "groupbuildajax"),
                "import" => array("arrears", "progress", "arrearsupload"),
            );

            $publicResources = array(
                "index" => array("logout", "index", "login", "logincheck"),
                'site' => array('error')
            );

            $this->addAlcResource($acl, $adminResource);
//            $this->addAlcResource($acl, $publicResources);

            //应用公共权限到所有角色
            foreach ($roles as $role) {
                foreach ($publicResources as $resource => $actions) {
//                    $acl->allow($role->getName(), $resource, '*');
                    $acl->allow($role->getName(), $resource, $actions);
                }
            }

            $this->addAclAllow($acl, $materResource, "抄表员");
            $this->addAclAllow($acl, $role_mater_leadResource, "抄表员班长");
            $this->addAclAllow($acl, $role_tollResource, "收费员");
            $this->addAclAllow($acl, $role_toll_leadResource, "收费员班长");
            $this->addAclAllow($acl, $role_financeResource, "对账员");
            $this->addAclAllow($acl, $role_managerResource, "管理人员");

            //The acl is stored in session, APC would be useful here too
            $this->persistent->acl = $acl;
//        }

        return $this->persistent->acl;
    }

    /**
     * This action is executed before execute any action in the application
     */
    public function beforeDispatch(Event $event, Dispatcher $dispatcher)
    {
        $auth = $this->session->get('auth');

        if (!$auth) {
            $role = 'Guests';
        } else {
            $role = $auth["Role"];

            $role = ARole::findFirst($role)->Name;
            if ($role == "Admin") return true;
        }

        $controller = strtolower($dispatcher->getControllerName());
        $action = strtolower($dispatcher->getActionName());

        $acl = $this->getAcl();
        $allowed = $acl->isAllowed($role, $controller, $action);

        if ($allowed != Acl::ALLOW) {
            if ($role == 'Guests') {
                $dispatcher->forward(
                    array(
                        'controller' => 'index',
                        'action' => 'login'
                    )
                );
            } else {
                $this->flash->error("对不起，您没有权限访问这个模块");
                $dispatcher->forward(
                    array(
                        'controller' => 'site',
                        'action' => 'error'
                    )
                );
            }
            return false;
        }
        return true;
    }
}