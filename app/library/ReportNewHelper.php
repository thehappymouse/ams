<?php

/**
 * Created by PhpStorm.
 * User: ww
 * Date: 14-10-31
 * Time: 16:48
 * 给extjs界面使用的报表数据查询。原辅助类继续使用，供下载
 */
class ReportNewHelper extends HelperBase
{
    /**
     * 获取抄表段集合下的欠费总户数，总金额，欠费年月
     * @param array $seg
     * @return mixed
     */
    private static function getMonthArrears(array $seg, $start, $end)
    {
        $builder = parent::getModelManager()->createBuilder();
        $results = $builder->columns(array("SUM(Money) as Money", "count(Money) as Count", "YearMonth"))
            ->from("Arrears")
            ->andWhere("YearMonth between :start: and :end:")
            ->inWhere("Segment", $seg)
            ->groupBy("YearMonth")
            ->getQuery()->execute(array("start" => $start, "end" => $end));
        return $results;
    }

    /**
     * 获取抄表段下 指定 月份 结清的户数，金额
     * @param array $seg
     */
    public static function getMonthAlreadCleanArrears(array $seg, $yearmonth)
    {
        $builder = parent::getModelManager()->createBuilder();
        $results = $builder->columns(array("SUM(Money) as Money", "count(Money) as Count", "YearMonth"))
            ->from("Arrears")
            ->andWhere("IsClean=1")
            ->andWhere("YearMonth=\"$yearmonth\"")
            ->inWhere("Segment", $seg)
            ->getQuery()->execute();
        return $results[0];
    }

    /**
     * 电费回收报表、 综合排名和户回收排名
     */
    public static function Electricity(array $param)
    {
        $p = new RequestParams($param);
        $id = $p->get("Team");

        $pageStart = (int)$p->get("start");
        $limit = 5;

        $result = array();
        $hu_datas = array();

        if ($id == -1) {
            $sql = "SELECT  * from User WHERE Role = " . ROLE_MATER . " AND TeamID in (SELECT ID FROM Team WHERE Type = 1)";
            $u = new User();
            $users = new Phalcon\Mvc\Model\Resultset\Simple(null, $u, $u->getReadConnection()->query($sql));
        } else {
            $users = User::find("TeamID=$id AND Role = " . ROLE_MATER);
        }
        $start = $p->get("FromData");
        $end = $p->get("ToData");

        $total = count($users);

        //应收金额，欠费金额，应收户数，欠费户数
        $alldata = array("Money" => 0, "ArrearMoney" => 0, "Count" => 0, "ArrearCount" => 0);

        $usercount = $pageStart;
        $index = 0;
        foreach ($users as $user) {

            if (++$index <= $pageStart) continue;
            if (++$usercount - $pageStart > $limit) break;

            $data = array("Name" => $user->Name);
            $data["sort"] = $usercount;
            $data2 = array("Name" => $user->Name);
            $data2["sort"] = $usercount;

            $flag = false;
            $seg = DataUtil::GetSegmentsByUid($user->ID);
            if (count($seg) == 0) $seg = array("0");
            $results = self::getMonthArrears($seg, $start, $end);
            if (count($results) > 0) {
                $flag = true;
                foreach ($results as $rs) {
                    $clear = self::getMonthAlreadCleanArrears($seg, $rs->YearMonth);

                    //金额回收率统计
                    $data["YearMonth"] = $rs->YearMonth;

                    $data["Action"] = "欠费余额";
                    $data["Value"] = $rs->Money - $clear->Money;
                    $result[] = $data;
                    $alldata["ArrearMoney"] += $data["Value"];

                    $data["Action"] = "应收电费";
                    $data["Value"] = $rs->Money;
                    $result[] = $data;
                    $alldata["Money"] += (float)$rs->Money;

                    $data["Action"] = "回收率(%)";
                    $rate = 100 * $clear->Money / $rs->Money;
                    $data["Value"] = number_format($rate, 2);
                    $result[] = $data;

                    //户数回收率统计
                    $data2["YearMonth"] = $rs->YearMonth;

                    $data2["Action"] = "欠费户数";
                    $data2["Value"] = $rs->Count - $clear->Count;
                    $alldata["ArrearCount"] += $data2["Value"];
                    $hu_datas[] = $data2;


                    $data2["Action"] = "应收户数";
                    $data2["Value"] = $rs->Count;
                    $hu_datas[] = $data2;
                    $alldata["Count"] += (int)$rs->Count;

                    $data2["Action"] = "回收率(%)";
                    $rate = 100 * $clear->Count / $rs->Count;
                    $data2["Value"] = number_format($rate, 2);
                    $hu_datas[] = $data2;
                }
            } else {
                if (count($result) < $total) {
                    //金额回收率统计
                    $data["Action"] = "欠费余额";
                    $data["sort"] = $usercount;
                    $result[] = $data;

                    $data["Action"] = "应收电费";
                    $result[] = $data;

                    $data["Action"] = "回收率(%)";
                    $result[] = $data;

                    //户数回收率统计
                    $data2["Action"] = "欠费户数";
                    $data["sort"] = $usercount;
                    $hu_datas[] = $data2;

                    $data2["Action"] = "应收户数";
                    $hu_datas[] = $data2;

                    $data2["Action"] = "回收率(%)";
                    $hu_datas[] = $data2;
                }
            }
            if ($flag) {
                //汇总
                $data["Action"] = "欠费余额";
                $data["YearMonth"] = "汇总";
                $data["Value"] = $alldata["ArrearMoney"];
                $result[] = $data;


                $data["Action"] = "应收电费";
                $data["YearMonth"] = "汇总";
                $data["Value"] = $alldata["Money"];
                $result[] = $data;

                $data["Action"] = "回收率(%)";
                $data["YearMonth"] = "汇总";
                $rate = 100 - 100 * $alldata["ArrearMoney"] / $alldata["Money"];
                $data["Value"] = number_format($rate, 2);
                $result[] = $data;

                //户数汇总
                $data["Action"] = "欠费户数";
                $data["YearMonth"] = "汇总";
                $data["Value"] = $alldata["ArrearCount"];
                $hu_datas[] = $data;


                $data["Action"] = "应收户数";
                $data["YearMonth"] = "汇总";
                $data["Value"] = $alldata["Count"];
                $hu_datas[] = $data;

                $data["Action"] = "回收率(%)";
                $data["YearMonth"] = "汇总";
                $rate = 100 - 100 * $alldata["ArrearCount"] / $alldata["Count"];
                $data["Value"] = number_format($rate, 2);
                $hu_datas[] = $data;
            }
        }

        return array($hu_datas, $result, $total);
    }

    public static function getFeeStatementsBySeg($seg, $name, $start = null, $end = null)
    {
        $team = array();
        $years = array();

        $team["Name"] = $name;

        $allData = array("Rate" => 0, "count" => 0, "NoPressCount" => 0, "NoPressMoney" => 0); //汇总信息

        $builder = parent::getBuilder("Arrears", $seg, $start, $end);


        $results = $builder->columns(array("SUM(Money) as Money", "count(Money) as ArrearCount", "YearMonth"))
            ->groupBy("YearMonth")
            ->getQuery()->execute();

        foreach ($results as $rs) {
            $data = array("YearMonth" => $rs->YearMonth, "Rate" => 0, "NoPressCount" => $rs->ArrearCount, "NoPressMoney" => $rs->Money);

            $builder = parent::getBuilder("Arrears", $seg);
            $press = $builder->columns(array("SUM(Money) as Money", "count(Money) as Count", "YearMonth"))
                ->andWhere("PressCount > 0")
                ->andWhere("YearMonth=:ym:")
                ->groupBy("YearMonth")
                ->getQuery()->execute(array("ym" => $rs->YearMonth))->getFirst();

            if ($press) {

                $data["Rate"] = number_format((100 * $press->Count / $rs->ArrearCount), 2, ".", ""); // . "%";
                $data["NoPressCount"] = $rs->ArrearCount - $press->Count;
                $data["NoPressMoney"] = $rs->Money - $press->Money;
            }

            $team["Data"][$rs->YearMonth] = $data;
            $allData["NoPressCount"] += $data["NoPressCount"];
            $allData["NoPressMoney"] += $data["NoPressMoney"];
            $allData["count"] += $rs->ArrearCount;

            if (!in_array($rs->YearMonth, $years)) {
                $years[] = $rs->YearMonth;
            }
        }

        if ($allData["count"] > 0) {
            $allData["Rate"] = number_format((100 * ($allData["count"] - $allData["NoPressCount"]) / $allData["count"]), 2, ".", "") . "%";
            $team["AllData"] = $allData;
        }

        return array($team, $years);
    }

    /**
     * 催费报表  催费员 催费完成率    未催费户数    未催费金额
     */
    public static function Press(array $params)
    {
        $p = new RequestParams($params);

        $tid = $p->get("Team");

        if ($tid == -1) {
            $mTeams = Team::find("Type=1");
        } else {
            $mTeams = Team::find($tid);
        }

        $start = $p->get("1FromData");
        $end = $p->get("1ToData");
        $userdata = array();

        $pagestart = (int)$p->get("start");
        $index = $start + 1;

        $tids = array();
        //抄表员统计情况
        foreach ($mTeams as $mt) {
            $tids[] = $mt->ID;
        }
        $tids = implode(",", $tids);

        $mUsers = User::find("TeamID IN($tids) AND Role = " . ROLE_MATER . " limit $pagestart,5");

        foreach ($mUsers as $mU) {
            $seg = DataUtil::GetSegmentsByUid($mU->ID);
            if (count($seg) > 0) {
                list($uData, $a) = self::getFeeStatementsBySeg($seg, $mU->Name, $start, $end);
                $data = array("Name" => $mU->Name, "sort" => $index++);

                if (!isset($uData["Data"])) continue;
                //|| count($uData["Data"]) == 0) continue;

                foreach ($uData["Data"] as $d) {
                    $data["Action"] = "未催费金额";
                    $data["Value"] = $d["NoPressMoney"];
                    $data["YearMonth"] = $d["YearMonth"];
                    $userdata[] = $data;


                    $data["Action"] = "未催费户数";
                    $data["Value"] = $d["NoPressCount"];
                    $userdata[] = $data;

                    $data["Action"] = "催费完成率";
                    $data["Value"] = $d["Rate"];
                    $userdata[] = $data;
                }
            } else {
                $data = array("Name" => $mU->Name, "sort" => $index++);
                $data["Action"] = "未催费金额";
                $data["Value"] = "";
                $data["YearMonth"] = "";
                $userdata[] = $data;


                $data["Action"] = "未催费户数";
                $userdata[] = $data;

                $data["Action"] = "催费完成率";
                $userdata[] = $data;

            }
        }

        return array(User::count("TeamID IN($tids) AND Role = " . ROLE_MATER), $userdata);
    }

    private static function dayReportBySeg($seg, $start, $end)
    {
        $team = array(
            "Count" => array("Phone" => 0, "Notify" => 0, "Cut" => 0, "Reset" => 0, "Charge" => 0, "Customer" => 0),
            "Money" => array("Phone" => 0, "Notify" => 0, "Cut" => 0, "Reset" => 0, "Charge" => 0, "Customer" => 0),
        );
        //催费
        $builder = parent::getBuilder("Press", $seg);
        $builder->columns("PressStyle, COUNT(PressStyle) as Count, Sum(Money) as Money");
        $builder->groupBy("PressStyle");
        $builder->andWhere("PressTime BETWEEN '$start' AND '$end'");

        $result = $builder->getQuery()->execute();

        foreach ($result as $r) {
            if ($r->PressStyle == "电话催费") {
                $team["Count"]["Phone"] = $r->Count;
                $team["Money"]["Phone"] = $r->Money;
            } else {
                $team["Count"]["Notify"] = $r->Count;
                $team["Money"]["Notify"] = $r->Money;
            }
        }

        //停电
        $builder = parent::getBuilder("Cutinfo", $seg);
        $builder->columns("COUNT(*) as Count, Sum(Money) as Money");
        $builder->andWhere("CutTime BETWEEN '$start' AND '$end'");

        $r = $builder->getQuery()->execute()->getFirst();

        $team["Count"]["Cut"] = $r->Count;
        $team["Money"]["Cut"] = (int)$r->Money;

        //复电
        $builder = parent::getBuilder("Cutinfo", $seg);
        $builder->columns("COUNT(*) as Count, Sum(Money) as Money");
        $builder->andWhere("ResetTime BETWEEN '$start' AND '$end'");
        $builder->andWhere("ResetTime IS NOT NULL");

        $r = $builder->getQuery()->execute()->getFirst();
        $team["Count"]["Reset"] = $r->Count;
        $team["Money"]["Reset"] = (int)$r->Money;

        //收费，
        $builder = parent::getBuilder("Arrears", $seg);
        $builder->andWhere("ChargeDate BETWEEN '$start' AND '$end'");
        $builder->columns("SUM(Money) as Money, COUNT(Money) as Count,IsClean");
        $builder->andWhere("ChargeDate BETWEEN '$start' AND '$end'");
        $builder->andWhere("IsClean = 1");

        $r = $builder->getQuery()->execute()->getFirst();
        $team["Count"]["Charge"] = $r->Count;
        $team["Money"]["Charge"] = $r->Money;

        $builder = parent::getBuilder("Arrears", $seg);
        $builder->columns("SUM(Money) as Money, COUNT(Money) as Count,IsClean");
        $builder->andWhere("IsClean = 0");

        $r = $builder->getQuery()->execute()->getFirst();

        $team["Count"]["Customer"] = $r->Count;
        $team["Money"]["Customer"] = $r->Money;


        //欠费
        return $team;
    }

    /**
     * 每日工作报表
     * @param array $params
     * @return array
     */
    public static function Work(array $params)
    {

        $p = new RequestParams($params);
        $tid = $p->get("Team");

        if ($tid == "-1") {
            $mTeams = Team::find("Type=1");
        } else {
            $mTeams = Team::find($tid);
        }

        $start = $p->get("FromData");
        $end = $p->get("ToData") . "23:59:59";

        $teams = array();
        $users = array();

        //班组情况统计
        foreach ($mTeams as $mt) {

            $seg = DataUtil::GetSegmengsByTid($mt->ID);

            if (count($seg) == 0) continue;

            $team = self::dayReportBySeg($seg, $start, $end);

            $teams[$mt->Name] = $team;
        }

        //抄表员统计情况
        foreach ($mTeams as $mt) {
            $mUsers = User::find("TeamID = $mt->ID AND Role=" . ROLE_MATER);
            foreach ($mUsers as $mU) {
                $seg = DataUtil::GetSegmentsByUid($mU->ID);
                if (count($seg) > 0) {
                    $team = self::dayReportBySeg($seg, $start, $end);
                }
                $users[$mt->Name][$mU->Name] = $team;
            }
        }
        return array($teams, $users);
    }
} 