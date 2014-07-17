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
        $cut = Cutinfo::findFirst("Arrear = $p->ID");

        if ($cut == null) throw new Exception("未找到停电记录");

        $cut->ResetTime = $p->ResetTime;
        $cut->ResetStyle = $p->ResetType;
        $cut->ResetPhone = $p->ResetPhone;

        $cut->ResetUser = $p->User;
        if ($cut->save()) {
            $arrear = Arrears::findFirst($p->ID);
            $arrear->IsCut = 0;
            $arrear->save();

            $customer = Customer::findByNumber($arrear->CustomerNumber);
            $customer->IsCut = 0;
            $customer->save();
            $result = true;
        }
        return array($result, $cut, $arrear);
    }

    /**
     * 停电
     * @param array $params
     * @return bool
     */
    public static function Cut(array $params)
    {
        $success = false;
        $request = new RequestParams($params);

        $cut = new Cutinfo();
        $cut->CutStyle = $request->CutType;
        $cut->CutTime = $request->CutTime;
        $cut->Arrear = $request->ID;


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
        return array($success, $cut, $arrear);
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
     * 欠费用户信息，多个界面综合使用
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
        }

        if ($p->Number) {
            if ($p->Number == "全部") {
                $uid = $p->Name;
                $str = DataUtil::GetSegmentsStrByUid($uid);
                $conditions .= " AND Segment in ($str)";
            } else {
                $conditions .= " AND Segment = :segment:";
                $param["segment"] = $p->Number;
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
        if ($p->IsClean != NULL && $p->IsClean != 2){
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

            if ($p->IsControl && (int)$p->IsControl != 2) {
                if ($as->Customer->IsControl != $p->IsControl) {
                    continue;
                }
            }

            $row = $as->dump();
            $row["Address"] = $as->Customer->Address;
            $row["IsCut"] = (int)$as->Customer->IsCut;
            $row["Phone"] = $as->Customer->LandlordPhone;
            $row["IsControl"] = $as->Customer->IsControl;
            $row["AssetNumber"] = $as->Customer->AssetNumber;
            $row["IsSpecial"] = $as->Customer->IsSpecial;
            $data[] = $row;
        }

        return array($total, $data);
    }
} 