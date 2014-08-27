<?php

/**
 * Created by PhpStorm.
 * User: ww
 * Date: 14-6-17
 * Time: 10:53
 */
class CustomerHelper extends HelperBase
{

    /**
     * 复电
     * @param array $params
     */
    public static function Reset(array $params)
    {
        $p = new RequestParams($params);
        $result = false;

        $ids = explode(",", $p->ID);
        foreach($ids as $id){
            $cut = Cutinfo::findFirst("Arrear = $id");
            if ($cut == null) {
                continue;
            }

            $cut->ResetTime = $p->ResetTime;
            $cut->ResetStyle = $p->ResetType;
            $cut->ResetPhone = $p->ResetPhone;

            $cut->ResetUser = $p->User;
            if ($cut->save()) {
                $arrear = Arrears::findFirst($id);
                $arrear->IsCut = 0;
                $arrear->save();

                $customer = Customer::findByNumber($arrear->CustomerNumber);
                $customer->IsCut = 0;
                $customer->save();
                $result = true;
            }
        }

        return array($result, $ids);
    }

    /**
     * 停电  20140808 多记录同时停止
     * @param array $params
     * @return bool
     */
    public static function Cut(array $params)
    {
        $success = false;
        $request = new RequestParams($params);

        $ids = explode(",", $request->ID);

        foreach ($ids as $id) {
            $cut = new Cutinfo();
            $cut->CutStyle = $request->CutType;
            $cut->CutTime = $request->CutTime;
            $cut->Arrear = $id;

            $arrear = Arrears::findFirst($cut->Arrear);

            $customer = Customer::findByNumber($arrear->CustomerNumber);

            $cut->CutUserName = $customer->SegUser;
            $cut->CustomerNumber = $customer->Number;
            $cut->Segment = $arrear->Segment;
            $cut->YearMonth = $arrear->YearMonth;
            $cut->Money = $arrear->Money;

            $r = $cut->save();


            if ($r) {
                $arrear->CutCount = (int)$arrear->CutCount + 1;
                $arrear->IsCut = 1;
                $arrear->save();

                $customer->IsCut = 1;
                $customer->save();
                $success = true;

            } else {
                var_dump($cut->getMessages());
            }
        }

        return array($success, $ids);
    }

    public static function Charge(array $params)
    {
        $r = new RequestParams($params);

        $ids = $r->ID; //欠费记录
        $money = $r->Money;
        $customer = $r->Number;

        $ars = array(); //欠费信息数组

        if ($ids == null) { //id为空，表示交所有欠费，再查询一次数据库
            $ars = Arrears::find("CustomerNumber = '$customer'");
        } else {
            $ars = Arrears::find("ID IN ($ids)");
        }
    }

    //预收转逾期查询
    public static function Advances(array $param)
    {
        $p = new RequestParams($param);

        $team = $p->get("Team");

        $seg = DataUtil::GetSegmengsByTid($team);

        $data = array();
        if (count($seg) > 0) {
            $builder = parent::getBuilder("Arrears", $seg);
            $builder->andWhere("IsClean=2");
            $rs = $builder->getQuery()->execute();
            foreach ($rs as $r) {
                $customer = Customer::findByNumber($r->CustomerNumber);
                $row = $r->dump();
                $row["Address"] = $customer->Address;
                $row["SegUser"] = $customer->SegUser;

                $data[] = $row;
            }
        }
        return $data;
    }

    /**
     * 客户统计数据。增加统计信息
     * @param array $params
     */
    public static function Customers(array $params)
    {
        list($total, $data, $conditions, $param) = self::ArrearsInfo($params);

        $builder = parent::getModelManager()->createBuilder();
        $result = $builder->columns(array("COUNT( DISTINCT CustomerNumber) as Count, SUM(IsCut) as CutCount"))
            ->from("Arrears")
            ->andWhere($conditions)
            ->getQuery()->execute($param)->getFirst();
        $allCustomer = $result->Count;
        $cutCount = $result->CutCount;


        $sql = "SELECT  * from User WHERE Role = " . ROLE_MATER . " AND TeamID in (SELECT ID FROM Team WHERE Type = 1)";
        $u = new User();
        $users = new Phalcon\Mvc\Model\Resultset\Simple(null, $u, $u->getReadConnection()->query($sql));

        $conditions = str_replace("AND (YearMonth BETWEEN :start: AND :end:)", "", $conditions);
        $builder = parent::getModelManager()->createBuilder();
        $result = $builder->columns("SUM(IsSpecial) as Count")
            ->from("Customer")
            ->andWhere("IsClean!=1")
            ->andWhere($conditions)
            ->getQuery()->execute($param)->getFirst();

        $specialCount = (int)$result->Count; //这个需要特殊处理

        $countinfo = array("allCustomer" => $allCustomer, "cutCount" => $cutCount, "specialCount" => $specialCount);

        return array($total, $data, $countinfo);
    }



    /**
     * 欠费用户信息，多个界面综合使用 客户分类统计中，增加统计数据
     * @param array $params
     * @return array
     */
    public static function ArrearsInfo(array $params)
    {
        $p = new RequestParams($params);

        $data = array();
        $param = array();
        $conditions = "1 = 1";

        if ($p->CustomerNumber) {
            $conditions .= " AND CustomerNumber = :Customer:";
            $param["Customer"] = $p->CustomerNumber;
        } else {
            if ($p->Number) {
                if ($p->Number == "全部") { //选择了所有抄表段
                    if (($tid = User::IsAllUsers($p->Name))) { //选择了所有抄表员，则取其组下的抄表段
                        $str = DataUtil::GetSegmentsStrByTid($p->Team);
                    } else {
                        $str = DataUtil::GetSegmentsStrByUid($p->Name);
                    }

                    $conditions .= " AND Segment in ($str)";
                } else {
                    $conditions .= " AND Segment = :segment:";
                    $param["segment"] = $p->Number;
                }
            }
        }


        //只棵催费
        if ($p->OnlyHasPress) {
            $conditions .= " AND PressCount > 0";
        }

        //只查停电
        if ($p->OnlyAlreadyCut) {
            $conditions .= " AND IsCut = 1";
        }

        //电费年月。其它条件应注意修改关键字
        if ($p->FromData && $p->ToData) {
            $conditions .= " AND (YearMonth BETWEEN :start: AND :end:)";
            $param["start"] = $p->FromData;
            $param["end"] = $p->ToData;
        }

        //是否结清
        if ($p->IsClean != NULL && $p->IsClean != 2) {
            $conditions .= " AND IsClean = $p->IsClean";
        }

        //欠费金额
        if ($p->ArrearsValue && $p->ArrearsValue > 0) {

            if ($p->Arrears == 1) {
                $word = " >= ";
            } else {
                $work = " < ";
            }
            $conditions .= " AND Money $word :money:";
            $param["money"] = $p->ArrearsValue;
        }

        //催费次数
        if ($p->ReminderFeeValue && (int)$p->ReminderFeeValue > 0) {
            if ($p->ReminderFee == 1) $word = ">=";
            else $word = "<";

            $conditions .= " AND PressCount $word :PressCount:";
            $param["PressCount"] = $p->ReminderFeeValue;
        }

        //停电次数
        if ($p->PowerOutagesValue && (int)$p->PowerOutagesValue > 0) {
            $word = ($p->PowerOutages == 1) ? ">=" : "<";

            $conditions .= " AND CutCount $word :CutCount:";
            $param["CutCount"] = $p->PowerOutagesValue;
        }


        $conditions_mini = $conditions;

        //排序
        if($p->numberSort) {
            $conditions .= " ORDER BY CustomerNumber " . ($p->numberSort == 1 ? "Desc ": "ASC ");
        }

        if($p->segmentSort) {
            $conditions .= " ORDER BY Segment " . ($p->segmentSort == 1 ? "Desc ": "ASC ");
        }

        //分页
        $total = Arrears::count(array($conditions, "bind" => $param));


        $conditions = self::addLimit($conditions, $p->Page, $p->PageSize);

        $arrears = Arrears::find(array($conditions, "bind" => $param));

        foreach ($arrears as $as) {
            //是否租房  2 全部。 1 租。0 非租
            if ($p->IsRent && (int)$p->IsRent != 2) {
                if ($as->Customer->IsRent != $p->IsRent) {
                    continue;
                }
            }

            //是否费控
            if ($p->IsControl && (int)$p->IsControl != 2) {
                if ($as->Customer->IsControl != $p->IsControl) {
                    continue;
                }
            }

            if ($p->CutType && $p->CutType != "全部") {
                if ($as->Cutinfo->CutStyle != $p->CutType) {
                    continue;
                }
            }

            $row = $as->dump();
            $row["Address"] = $as->Customer->Address;
            $row["IsCut"] = (int)$as->Customer->IsCut;
            $row["LandlordPhone"] = $as->Customer->LandlordPhone;
            $row["RenterPhone"] = $as->Customer->RenterPhone;
            $row["IsControl"] = $as->Customer->IsControl;
            $row["AssetNumber"] = $as->Customer->AssetNumber;
            $row["IsSpecial"] = $as->Customer->IsSpecial;
            $row["IsRent"] = $as->Customer->IsRent;
            $row["IsControl"] = $as->Customer->IsControl;

//            计算欠费次数和累计欠费次数
            //TODO 导出时，将ArrearsCount 增加
            $row["AllArrearCount"] = $as->Customer->ArrearsCount;
            //TODO 该字段需要优化
//            $row["ArrearCount"] = Arrears::count("IsClean!=1 AND CustomerNumber=$as->CustomerNumber");

            $data[] = $row;
        }

        return array($total, $data, $conditions_mini, $param);
    }
} 