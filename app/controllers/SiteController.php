<?php

function cmp_rate($a, $b)
{
    $a1 = $a["Rate"];
    $b1 = $b["Rate"];
    if ($a1 <= $b1) {
        return 1;
    } else {
        return -1;
    }
}

class SiteController extends ControllerBase
{
    //Home 个人排名指标柱形图
    public function getSingleBar()
    {
        $users = User::find("Role=1");

        $uData = array();
        $data = array();
        foreach ($users as $user) {
            $seg = DataUtil::getSegNameArray($user->ID);
            if (count($seg) == 0) {
                $uData[$user->Name] = 0;
                continue;
            }

            $build = $this->getBuilder("Charge", $seg);
            $build->columns("SUM(Money) AS Money");

            $r = $build->getQuery()->execute()->getFirst();
            $uData[$user->Name] = (int)$r->Money;
        }

        foreach ($uData as $key => $ud) {

            $row = array();
            $row["name"] = $key;
            $row["value"] = $ud;
            $row["views"] = Config::getValue("IndexLine");
            $row["avge"] = 80;
            $data[] = $row;
        }
        return json_encode($data);
    }

    public function getArrarsCount()
    {
        $seg = DataUtil::getSegNameArray($this->loginUser["ID"]);

        $data = array();
        for ($i = 0; $i < 4; $i++) {
            $row = array();
            if (count($seg) == 0) {
                $builder = $this->getBuilder("Arrears");
                $builder->andWhere("1 > 2");
            } else {
                $builder = $this->getBuilder("Arrears", $seg);
            }
            $builder->columns("COUNT(*) as Count");

            if ($i == 3) {
                $builder->andWhere("PressCount >=$i");
                $row["season"] = "3次以上";
            } else if ($i == 0) {
                $builder->andWhere("PressCount=$i OR PressCount IS NULL");
                $row["season"] = $i . "次";
            } else {
                $builder->andWhere("PressCount=$i");
                $row["season"] = $i . "次";
            }
            $r = $builder->getQuery()->execute()->getFirst();
            $row["total"] = $r->Count;
            $data[] = $row;
        }
        return json_encode($data);
    }

    public function getCut()
    {
        $seg = DataUtil::getSegNameArray($this->loginUser["ID"]);

        $data = array(
            array("season" => "已停电", "total" => 0),
            array("season" => "可停电", "total" => 0),
            array("season" => "已复电", "total" => 0),
            array("season" => "无", "total" => 0));

        if ($seg) {

            $r = $this->getBuilder("Cutinfo", $seg)->columns("COUNT(*) as Count")->andWhere("ResetTime is null")->getQuery()->execute()->getFirst();
            $data[0]["total"] = $r->Count;

            $r = $this->getBuilder("Customer", $seg)->columns("COUNT(*) as Count")->andWhere("PressCount >= 2 and IsCut != 1")->getQuery()->execute()->getFirst();
            $data[1]["total"] = $r->Count;

            $r = $this->getBuilder("Cutinfo", $seg)->columns("COUNT(*) as Count")->andWhere("ResetTime is not null")->getQuery()->execute()->getFirst();
            $data[2]["total"] = $r->Count;
        }

        return json_encode($data);
    }

    /**
     * 当年 各月欠费户数. 如果是1月，怎么办？
     */
    public function getArrarsMonth()
    {

        $seg = DataUtil::getSegNameArray($this->loginUser["ID"]);
        $rs = array();
        if ($seg) {
            $builder = $this->getBuilder("Arrears", $seg);

            $builder->from("Arrears")->columns("YearMonth, count(DISTINCT CustomerNumber) AS Count");
            $builder->groupBy("YearMonth");
            $rs = $builder->getQuery()->execute();
        } else {

        }
        $dataX = array();
        $data = array();

        for ($i = 1; $i <= (int)date('m'); $i++) {
            $ym = date('Y') . str_pad($i, 2, "0", STR_PAD_LEFT);
            $dataX[] = $ym;
            $count = 0;
            if ($rs) {
                foreach ($rs as $r) {

                    if ($r->YearMonth == $ym && in_array($r->YearMonth, $dataX)) {
                        $count += $r->Count;
                    }
                }
            }
            $row = array();
            $row["name"] = $ym;
            $row["value"] = $count;
            $data[] = $row;
        }


        return json_encode($data);
    }

    private function teamindex($teamid)
    {
        $data = array();
        $teams = Team::find("Type=1");

        foreach ($teams as $u) {
            $seg = DataUtil::getTeamSegNameArray($u->ID);
            $d = $this->qianfeiqingkuangBySeg($seg);
            $d["key"] = $u->ID;
            $data[] = $d;
        }
        $sort = 1;
        foreach ($data as $d) {
            if ($teamid == $d["key"]) {
                break;
            }
            $sort++;
        }

        return $sort;
    }

    /**
     * 按电费回收率，计算用户排名
     * @param $uname
     * @return int
     */
    private function userindex($uname)
    {
        $data = array();
        $users = User::find("TeamID=1");
        foreach ($users as $u) {
            $seg = array($u->Name);
            $d = $this->qianfeiqingkuangBySeg($seg);
            $d["key"] = $u->ID;
            $data[] = $d;
        }
        $sort = 0;

        foreach ($data as $d) {
            if ($uname == $d["key"]) {
                break;
            }
            ++$sort;
        }
        return $sort;
    }

    private function qianfeiqingkuangBySeg($seg)
    {
        $data = array("Rate" => 0, "CountRate" => 0, "UserIndex" => 0, "CustomerCount" => 0, "ArrearCount" => 0, "Money" => 0);

        if (count($seg) > 0) {


            //按电费回收率进行排名
//            $data["UserIndex"] = $r->Money;

            $builder = $this->getBuilder("Arrears", $seg);
            $builder->columns(array("COUNT(DISTINCT CustomerNumber) AS CustomerCount", "COUNT(ID) AS ArrearCount", "SUM(Money) AS Money"));
            $result = $builder->getQuery()->execute()->getFirst();
            $data = array_merge($data, (array)$result);

            $builder = $this->getBuilder("Usermoney");
            $builder->columns(array("SUM(Money) as Money", "SUM(House) as Count"));
            $builder->inWhere("UserName", $seg);

            $udata = (array)$builder->getQuery()->execute()->getFirst();

            if ($udata["Money"]) {
                $data["Rate"] = number_format((100 * $data["Money"] / $udata["Money"]), 2, ".", "") . "%";
                $data["CountRate"] = number_format((100 * $data["CustomerCount"] / $udata["Count"]), 2, ".", "") . "%";
            }

        }
        return $data;
    }

    /**
     * 欠费情况 抄表员登录，统计个人情况。班长登录，统计班组情况
     */
    private function qianfeiqingkuang()
    {

        if (ROLE_MATER == $this->loginUser["Role"]) {
            $seg = DataUtil::getSegNameArray($this->loginUser["ID"]);
        } else if (ROLE_MATER_LEAD == $this->loginUser["Role"]) {

            $seg = DataUtil::getTeamSegNameArray($this->loginUser["TeamID"]);
        }

        $data = $this->qianfeiqingkuangBySeg($seg);

        if (ROLE_MATER == $this->loginUser["Role"]) {
            $seg = DataUtil::getSegNameArray($this->loginUser["ID"]);


            $data["UserIndex"] = $this->userindex($this->loginUser["ID"]);

        } else if (ROLE_MATER_LEAD == $this->loginUser["Role"]) {

            $seg = DataUtil::getTeamSegNameArray($this->loginUser["TeamID"]);
            $data["UserIndex"] = $this->teamindex($this->loginUser["TeamID"]);
        }


        return $data;
    }

    /**
     * 昨日檄费
     */
    private function yestoryday_jifei()
    {
        $yestarday = array("Count" => 0, "Money" => 0);

        if (ROLE_MATER == $this->loginUser["Role"]) {
            $seg = DataUtil::getSegNameArray($this->loginUser["ID"]);
        } else if (ROLE_MATER_LEAD == $this->loginUser["Role"]) {
            $seg = DataUtil::getTeamSegNameArray($this->loginUser["TeamID"]);
        }

        $builder = $this->getBuilder("Charge", $seg);
        $builder->columns("COUNT( DISTINCT CustomerNumber) as Count, SUM(Money) as Money");
        $builder->andWhere("Time BETWEEN :yd: AND :today:");

        $r = $builder->getQuery()->execute(array("yd" => $this->getDate(time() - 24 * 3600), "today" => $this->getDate()))->getFirst();

        $yestarday = (array)$r;
        return $yestarday;
    }

    /**
     * 催费员登录，个人情况统计.
     * 个人排名，需要统计所有抄表员的收费情况后得到排名
     */
    public function indexAction()
    {
        $this->qianfeiqingkuang();

        $seg = DataUtil::getSegNameArray($this->loginUser["ID"]);
        $data = array("Rate" => 0, "CountRate" => 0, "UserIndex" => 0, "CustomerCount" => 0, "ArrearCount" => 0, "Money" => 0);

        $press = array("Rate" => 0, "NoPressCustomer" => 0, "NoPressMoney" => 0);

        if (count($seg) > 0) {
            $builder = $this->getBuilder("Arrears", $seg);
            $builder->columns(array("COUNT(DISTINCT CustomerNumber) AS CustomerCount", "COUNT(ID) AS ArrearCount", "SUM(Money) AS Money"));
            $result = $builder->getQuery()->execute()->getFirst();
            $data = array_merge($data, (array)$result);

            $builder = $this->getBuilder("Arrears", $seg);
            $builder->columns("COUNT( DISTINCT CustomerNumber) as Count, SUM(Money) as Money");
            $builder->andWhere("IsClean = 1");
            $r = $builder->getQuery()->execute()->getFirst();
            $data["Rate"] = number_format((100 * $r->Money / $data["Money"]), 2, ".", "") . "%";
            $data["CountRate"] = number_format((100 * $r->Count / $data["CustomerCount"]), 2, ".", "") . "%";


            $builder = $this->getBuilder("Charge", $seg);
            $builder->columns("COUNT( DISTINCT CustomerNumber) as Count, SUM(Money) as Money");
            $builder->andWhere("Time BETWEEN :yd: AND :today:");

            $press = array();
            //抄表段 催费统计信息
            $r = $this->getPressRate($seg);
            $press["Rate"] = number_format((100 - (100 * $r->NoPressCount / $data["CustomerCount"])), 2, ".", "") . "%";

            $press["NoPressCustomer"] = $r->NoPressCustomer;
            $press["NoPressMoney"] = $r->NoPressMoney;
        }

        $data = $this->qianfeiqingkuang();
        $this->view->arrear = $data;
        $this->view->press = $press;
        $this->view->cutinfo = $this->getCut();
        $this->view->arrcount = $this->getArrarsCount();
        $this->view->sig = $this->getSingleBar();
        $this->view->yy = $this->getArrarsMonth();
        $this->view->lineshow = $this->loginUser["Role"] == ROLE_ADMIN;
        $this->view->yesterday = $this->yestoryday_jifei();
    }


    /**
     * 个人促费情况
     * 未催费户数，未催费金额，
     * @param array $seg
     * @return array
     */
    private function getPressRate(array $seg)
    {
        $builder = $this->getBuilder("Arrears", $seg);
        $builder->columns("COUNT(DISTINCT CustomerNumber) as NoPressCustomer, COUNT(Money) as NoPressCount, SUM(Money) as NoPressMoney");
        $builder->andWhere("IsClean != 1");
        $r = $builder->getQuery()->execute()->getFirst();

        return $r;
    }

    public function errorAction()
    {

    }

    public function index2Action()
    {
        $this->view->setTemplateAfter("empty");
        $rid = $this->loginUser["Role"];
        $role = ARole::findFirst($rid);
        $page = $role->IndexPage;
        $page = $page ? $page : "/site/index2";

        $page = substr($page, 1);
        $this->redirect($page);

        if (in_array($this->loginUser["Role"], array("1"))) {
            $this->redirect("site/index");

        }

    }
}

