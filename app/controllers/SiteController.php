<?php

class SiteController extends ControllerBase
{
    //Home 个人排名指标柱形图
    public function getSingleBar()
    {
        $users = User::find("Role=1");

        $uData = array();
        $data = array();
        foreach ($users as $user) {
            $seg = DataUtil::GetSegmentsByUid($user->ID);
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
        $seg = DataUtil::GetSegmentsByUid($this->loginUser["ID"]);

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
        $seg = DataUtil::GetSegmentsByUid($this->loginUser["ID"]);

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

        $seg = DataUtil::GetSegmentsByUid($this->loginUser["ID"]);
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

    /**
     * 催费员登录，个人情况统计.
     * 个人排名，需要统计所有抄表员的收费情况后得到排名
     */
    public function indexAction()
    {
        $data = array("CustomerCount" => 0, "ArrearCount" => 0, "Money" => 0, "Rate" => 0, "CountRate" => 0, "UserIndex" => 0);

        $seg = DataUtil::GetSegmentsByUid($this->loginUser["ID"]);
        $data = array("Rate" => 0, "CountRate" => 0, "UserIndex" => 0, "CustomerCount" => 0, "ArrearCount" => 0, "Money" => 0);

        $press = array("Rate" => 0, "NoPressCustomer" => 0, "NoPressMoney" => 0);
        $yestarday = array("Count" => 0, "Money" => 0);
        if (count($seg) > 0) {
            $builder = $this->getBuilder("Arrears", $seg);
            $builder->columns(array("COUNT(DISTINCT CustomerNumber) AS CustomerCount", "COUNT(ID) AS ArrearCount", "SUM(Money) AS Money"));
            $result = $builder->getQuery()->execute()->getFirst();
            $data = array_merge($data, (array)$result);

            $builder = $this->getBuilder("Arrears", $seg);
            $builder->columns("COUNT( DISTINCT CustomerNumber) as count, SUM(Money) as Money");
            $builder->andWhere("IsClean = 1");
            $r = $builder->getQuery()->execute()->getFirst();

            $data["Rate"] = number_format((100 * $r->Money / $data["Money"]), 2, ".", "") . "%";
            $data["CountRate"] = number_format((100 * $r->Count / $data["CustomerCount"]), 2, ".", "") . "%";


            $data["UserIndex"] = $r->Money;

            $builder = $this->getBuilder("Charge", $seg);
            $builder->columns("COUNT( DISTINCT CustomerNumber) as Count, SUM(Money) as Money");
            $builder->andWhere("Time BETWEEN :yd: AND :today:");

            $r = $builder->getQuery()->execute(array("yd" => $this->getDate(time() - 24 * 3600), "today" => $this->getDate()))->getFirst();

            $yestarday = (array)$r;

            $press = array();
            //抄表段 催费统计信息
            $r = $this->getPressRate($seg);
            $press["Rate"] = number_format((100 - (100 * $r->NoPressCount / $data["CustomerCount"])), 2, ".", "") . "%";

            $press["NoPressCustomer"] = $r->NoPressCustomer;
            $press["NoPressMoney"] = $r->NoPressMoney;
        }

        $this->view->arrear = $data;
        $this->view->press = $press;
        $this->view->cutinfo = $this->getCut();
        $this->view->arrcount = $this->getArrarsCount();
        $this->view->sig = $this->getSingleBar();
        $this->view->yy = $this->getArrarsMonth();

        $this->view->yesterday = $yestarday;
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

