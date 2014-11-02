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
        //TODO 用户排名没有计算
        list($years, $result, $total) = ReportNewHelper::Electricity($this->request->get());
        echo json_encode(array("total" => $total, "rows" => $result, "h_rows" => $years));exit;
        $this->ajax->flushData(array("years" => $years, "result" => $result));
    }

    public function UserAction($tid)
    {
        $id = $tid;

        $result = array();
        $years = array();

        if ($id == -1) {
            $sql = "SELECT  * from User WHERE Role = ". ROLE_MATER ." AND TeamID in (SELECT ID FROM Team WHERE Type = 1)";
            $u = new User();
            $users = new Phalcon\Mvc\Model\Resultset\Simple(null, $u, $u->getReadConnection()->query($sql));
        } else {
            $users = User::find("TeamID=$id AND Role = " . ROLE_MATER);
        }

        $uData = array();
        foreach ($users as $user) {
            $oneRes = array("User" => $user->Name);
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
        ImgHelper::BarChart($uData, "综合排名");
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
        list($years, $teams, $users) = ReportNewHelper::Press($this->request->get());

        echo json_encode(array("total" => 6, "rows" => $users, "h_rows" => $teams));exit;

//        $this->ajax->flushData(array("years" => $years, "result" => $teams, "userdata" => $users));
    }


    /**
     * 每日工作报表
     * 1,根据班组，查询出抄表段
     * 2，根据抄表段，电费日期，统计催费次数（电话与通知单分离），统计停电次数，复电次数，回收电费次数，欠费用户个数
     * 3，上述字段所对应的金额。
     */
    public function WorkAction()
    {

        list($teams, $users) = ReportHelper::Work($this->request->get());


        $this->ajax->flushData(array("team" => $teams, "user" => $users));
    }


}
