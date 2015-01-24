<?php

function cmp_rate($a, $b)
{
    $a1 = $a["AllData"]["MoneyRate"];
    $b1 = $b["AllData"]["MoneyRate"];
    if ($a1 <= $b1) {
        return 1;
    } else {
        return -1;
    }
}
function cmp_hrate($a, $b)
{
    $a1 = $a["AllData"]["CountRate"];
    $b1 = $b["AllData"]["CountRate"];
    if ($a1 <= $b1) {
        return 1;
    } else {
        return -1;
    }
}

class  ReportsearchController extends ControllerBase
{

    public function initialize()
    {
        $this->view->disable();
        parent::initialize();
    }


    public function echoElectricity($result, $start, $type = 0)
    {
        $limit = 5;
        usort($result, 'cmp_rate');
        for ($index = $start; $index < count($result) && $index < $limit + $start; $index++) {
            $user = $result[$index];

            $data = array("Name" => $user["Name"], "sort" => $index + 1);
            foreach ($user["MonthDatas"] as $key => $ym) {
                $data["YearMonth"] = $key;
                $data["Action"] = "欠费余额";
                $data["Value"] = $ym["ArrearMoney"];
                $row[] = $data;

                $data["Action"] = "应收电费";
                $data["Value"] = $ym["uMoney"];
                $row[] = $data;

                $data["Action"] = "回收率(%)";
                $data["Value"] = $ym["MoneyRate"];
                $row[] = $data;
            }

            $data["Action"] = "欠费余额";
            $data["YearMonth"] = "汇总";
            $data["Value"] = $user["AllData"]["ArrearMoney"];
            $row[] = $data;


            $data["Action"] = "应收电费";
            $data["YearMonth"] = "汇总";
            $data["Value"] = $user["AllData"]["AllMoney"];
            $row[] = $data;

            $data["Action"] = "回收率(%)";
            $data["YearMonth"] = "汇总";
            $data["Value"] = $user["AllData"]["MoneyRate"];
            $row[] = $data;

        }

        usort($result, 'cmp_hrate');
        for ($index = $start; $index < count($result) && $index < $limit + $start; $index++) {
            $user = $result[$index];

            $data = array("Name" => $user["Name"], "sort" => $index  + 1);
            foreach ($user["MonthDatas"] as $key => $ym) {

                $data["YearMonth"] = $key;
                $data["Action"] = "欠费户数";
                $data["Value"] = $ym["ArrearHouse"];
                $hrows[] = $data;

                $data["Action"] = "应收户数";
                $data["Value"] = $ym["uHouse"];
                $hrows[] = $data;

                $data["Action"] = "回收率(%)";
                $data["Value"] = $ym["HouseRate"];
                $hrows[] = $data;
            }

            $data["Action"] = "欠费户数";
            $data["YearMonth"] = "汇总";
            $data["Value"] = $user["AllData"]["ArrearCount"];
            $hrows[] = $data;


            $data["Action"] = "应收户数";
            $data["YearMonth"] = "汇总";
            $data["Value"] = $user["AllData"]["AllCount"];
            $hrows[] = $data;

            $data["Action"] = "回收率(%)";
            $data["YearMonth"] = "汇总";
            $data["Value"] = $user["AllData"]["CountRate"];
            $hrows[] = $data;

        }
        if($type){
            echo json_encode(array("total" => count($result), "rows" => $row));
        }
        else{
            echo json_encode(array("total" => count($result), "rows" => $hrows));
        }
        exit;
    }


    /**
     * 班组电费回收数组
     */
    public function TeamElectricityAction()
    {
        $result = ReportNewHelper::TeamElectricity($this->request->get());
        $start = (int)$this->request->get("start");

        $this->echoElectricity($result, $start, $this->request->get("Type"));
    }

    /**
     * 电费回收报表
     * 1, 取班组下用户
     * 2，取用户下所有的抄表段
     * 3，按电费年月分组查询这些抄表段对应的的总欠费记录
     * 4，按电费年月查询 收费信息中，这些抄表段的总收费记录
     * 5，计算比率
     */
    public function ElectricityAction()
    {
        list($result) = ReportNewHelper::Electricity($this->request->get());

        $start = (int)$this->request->get("start");
        $this->echoElectricity($result, $start, $this->request->get("Type"));
    }

    /**
     * 班组-欠费金额报表
     */
    public function TeamAction()
    {
        $id = $this->request->get("Team");

        if ($id == -1) {
            $teams = Team::find("Type=1");
        } else {
            $teams = Team::find("ID=$id");
        }

        $uData = array();
        foreach ($teams as $user) {
            $seg = DataUtil::getTeamSegNameArray($user->ID);
            if (count($seg) == 0) {
                continue;
            }

            $build = $this->getBuilder("Arrears", $seg);
            $build->columns("SUM(Money) AS Money")->andWhere("IsClean=0");

            $r = $build->getQuery()->execute()->getFirst();

            $data["name"] = $user->Name;
            $data["views"] = (int)$r->Money;
            $uData[] = $data;
        }
        $this->ajax->flushData($uData);
    }


    public function UserAction()
    {
        $id = $this->request->get("Team");

        if ($id == -1) {
            $sql = "SELECT  * from User WHERE Role = " . ROLE_MATER . " AND TeamID in (SELECT ID FROM Team WHERE Type = 1)";
            $u = new User();
            $users = new Phalcon\Mvc\Model\Resultset\Simple(null, $u, $u->getReadConnection()->query($sql));
        } else {
            $users = User::find("TeamID=$id AND Role = " . ROLE_MATER);
        }

        $uData = array();
        foreach ($users as $user) {
            $seg = DataUtil::getSegNameArray($user->ID);
            if (count($seg) == 0) {
                continue;
            }

            $build = $this->getBuilder("Arrears", $seg);
            $build->columns("SUM(Money) AS Money")->andWhere("IsClean=0");

            $r = $build->getQuery()->execute()->getFirst();

            $data["name"] = $user->Name;
            $data["views"] = (int)$r->Money;
            $uData[] = $data;
        }
        $this->ajax->flushData($uData);
    }

    /**
     * 催费完成率
     * 1，根据班组，取班组下所有的抄表段
     * 2，根据抄表段，取所有欠费记录，以电费时间分组
     * 3，根据时间分组，取催费记录
     * 4，将催费记录与欠费记录相比，得到结果。
     *
     * 二，以管理员取抄表段，进行第二个数据统计
     */
    public function PressAction()
    {
        list($total, $users) = ReportNewHelper::Press($this->request->get());


        echo json_encode(array("total" => $total, "rows" => $users));
        exit;

    }

    public function TeamPressAction()
    {

        $p = new RequestParams($this->request->get());

        $tid = $p->get("Team");
        if (!$tid) {
            echo json_encode(array("total" => 0, "rows" => array()));
            exit;
        }

        if ($tid == -1) {
            $mTeams = Team::find("Type=1");
        } else {
            $mTeams = Team::find($tid);
        }

        $start = $p->get("Fromdata");
        $end = $p->get("Todata");

        $teams = array();

        $teamdata = array();
        //班组情况统计
        foreach ($mTeams as $mt) {
            $seg = DataUtil::getTeamSegNameArray($mt->ID);

            list($team, $years) = ReportNewHelper::getFeeStatementsBySeg($seg, $mt->Name, $start, $end);
            $teams[] = $team;
        }

        $index = 1;
        foreach ($teams as $team) {


            $data = array("Name" => $team["Name"], "sort" => $index++);

            foreach ($team["Data"] as $d) {
                $data["Action"] = "未催费金额";
                $data["Value"] = $d["NoPressMoney"];
                $data["YearMonth"] = $d["YearMonth"];
                $teamdata[] = $data;


                $data["Action"] = "未催费户数";
                $data["Value"] = $d["NoPressCount"];
                $teamdata[] = $data;

                $data["Action"] = "催费完成率";
                $data["Value"] = $d["Rate"];
                $teamdata[] = $data;
            }

            //添加汇总信息
            $data["YearMonth"] = "汇总";
            $data["Action"] = "未催费金额";
            $data["Value"] = $team["AllData"]["NoPressMoney"];
            $teamdata[] = $data;


            $data["Action"] = "未催费户数";
            $data["Value"] = $team["AllData"]["NoPressCount"];
            $teamdata[] = $data;


            $data["Action"] = "催费完成率";
            $data["Value"] = $team["AllData"]["Rate"];
            $teamdata[] = $data;
        }

        echo json_encode(array("total" => count($mTeams), "rows" => $teamdata));
        exit;
    }

    public function TeamWorkAction()
    {
        if (!$this->request->get("Team")) {
            $this->ajax->flushData(array());
        }

        $result = array();
        list($teams, $users) = ReportNewHelper::Work($this->request->get());
        foreach ($teams as $key => $t) {
            $data = array("group" => $key, "year" => 2014);
            foreach ($t as $key2 => $td) {
                $data["action"] = ($key2 == "Count") ? "笔数" : "金额";

                $data["head"] = "电话催费";
                $data["value"] = $td["Phone"];
                $result[] = $data;

                $data["head"] = "通知单催费";
                $data["value"] = $td["Notify"];
                $result[] = $data;

                $data["head"] = "停电";
                $data["value"] = $td["Cut"];
                $result[] = $data;

                $data["head"] = "复电";
                $data["value"] = $td["Reset"];
                $result[] = $data;

                $data["head"] = "回收电费";
                $data["value"] = $td["Charge"];
                $result[] = $data;

                $data["head"] = "目前欠费";
                $data["value"] = $td["Customer"];
                $result[] = $data;

            }
        }

        $this->ajax->flushData($result);
        exit;
    }

    /**
     * 每日工作报表
     * 1,根据班组，查询出抄表段
     * 2，根据抄表段，电费日期，统计催费次数（电话与通知单分离），统计停电次数，复电次数，回收电费次数，欠费用户个数
     * 3，上述字段所对应的金额。
     */
    public function WorkAction()
    {

        $result = array();
        if (!$this->request->get("Team")) {
            $this->ajax->flushData($result);
        }

        list($teams, $users) = ReportNewHelper::Work($this->request->get());

        foreach ($users as $key => $t) {
            $data = array("group" => $key);
            foreach ($t as $name => $user) {
                $data["year"] = $name;
                foreach ($user as $key2 => $td) {
                    $data["action"] = ($key2 == "Count") ? "笔数" : "金额";

                    $data["head"] = "电话催费";
                    $data["value"] = $td["Phone"];
                    $result[] = $data;

                    $data["head"] = "通知单催费";
                    $data["value"] = $td["Notify"];
                    $result[] = $data;

                    $data["head"] = "停电";
                    $data["value"] = $td["Cut"];
                    $result[] = $data;

                    $data["head"] = "复电";
                    $data["value"] = $td["Reset"];
                    $result[] = $data;

                    $data["head"] = "回收电费";
                    $data["value"] = $td["Charge"];
                    $result[] = $data;

                    $data["head"] = "目前欠费";
                    $data["value"] = $td["Customer"];
                    $result[] = $data;
                }
            }

        }

        $this->ajax->flushData($result);
        exit;
    }


}
