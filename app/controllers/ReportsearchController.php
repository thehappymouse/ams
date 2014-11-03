<?php


class  ReportsearchController extends ControllerBase
{

    public function initialize()
    {
        $this->view->disable();
        parent::initialize();
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
        list($years, $result, $total) = ReportNewHelper::Electricity($this->request->get());
        echo json_encode(array("total" => $total, "rows" => $result, "h_rows" => $years));
        exit;
        $this->ajax->flushData(array("years" => $years, "result" => $result));
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
            $seg = DataUtil::GetSegmentsByUid($user->ID);
            if (count($seg) == 0) {
                continue;
            }

            $build = $this->getBuilder("Charge", $seg);
            $build->columns("SUM(Money) AS Money");

            $r = $build->getQuery()->execute()->getFirst();
            $data["name"] = $user->Name;
            $data["views"] = (int)$r->Money;
            $uData[] = $data;
        }
        $this->ajax->flushData($uData);
    }

    /**
     * 按照回收率进行排名
     * @param $data
     */
    private function sortByRate($data)
    {
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
            $seg = DataUtil::GetSegmengsByTid($mt->ID);

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
        }

        echo json_encode(array("total" => count($mTeams), "rows" => $teamdata));
        exit;
    }

    public function TeamWorkAction()
    {
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
