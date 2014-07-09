<?php

/**
 * Created by PhpStorm. 各种复杂的元数组查询
 * User: ww
 * Date: 14-6-13
 * Time: 09:50
 */
class DataUtil
{
    /**
     * 获取 管理员名下的抄表段
     * @param $uid
     * @return array
     */
    public static function GetSegmentsByUid($uid)
    {
        $data = array();
        $ss = Segment::find("UserID=$uid");
        foreach ($ss as $s) {
            $data[] = $s->Number;
        }
        return $data;
    }

    /**
     * 查找管理班组用户的抄表段集合, 并以sql拼接
     * @param $uid
     * @return string
     */
    public static  function GetSegmentsStrByUid($uid)
    {
        $segs = Segment::find("UserID = $uid");
        $ss = array();
        foreach ($segs as $s) {
            $ss[] = $s->Number;
        }

        $ss = "'" . implode("','", $ss) . "'";
        return $ss;
    }

    /**
     * 获取 班组 下，所有的抄表段
     * @param $tid
     * @return array
     */
    public static function GetSegmengsByTid($tid)
    {
        $data = array();
        $sql = "SELECT DISTINCT * from Segment WHERE UserID in (SELECT ID FROM User WHERE TeamID = ?)";
        $param = array($tid);


        $segment = new Segment();

        $rs = new Phalcon\Mvc\Model\Resultset\Simple(null, $segment, $segment->getReadConnection()->query($sql, $param));
        foreach($rs as $r){
            $data[] = $r->Number;
        }

        return $data;
    }

} 