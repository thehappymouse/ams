<?php

class SiteController extends ControllerBase
{
    /**
     * 催费员登录，个人情况统计.
     * 个人排名，需要统计所有抄表员的收费情况后得到排名
     */
    public function indexAction()
    {
        $data = array("CustomerCount" => 0, "ArrearCount" => 0, "Money" => 0, "Rate" => 0, "CountRate" => 0, "UserIndex" => 0);

        $seg = DataUtil::GetSegmentsByUid($this->loginUser["ID"]);
        $data = array("Rate" => 0, "CountRate" => 0, "UserIndex" => 0, "CustomerCount" => 0, "ArrearCount" => 0, "Money" => 0);

        $press = array("Rate" => 0, "NoPressCustomer" => 0, "NoPressMoney"=>0);
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
        $data = array();
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

