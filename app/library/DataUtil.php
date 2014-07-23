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
     * 获取 管理员名下的抄表段，仅抄表段
     * @param $uid
     * @return array
     */
    public static function GetSegmentsByUid($uid)
    {
        $data = array();
        $ss = Segment::find("UserID=$uid ORDER BY Number");
        foreach ($ss as $s) {
            $data[] = $s->Number;
        }
        return $data;
    }

    /**
     * 获取 管理员名下的抄表段集合
     * @param $uid
     * @return array
     */
    public static function GetSegmentsDataByUid($uid)
    {
        $data = array();
        $ss = Segment::find("UserID=$uid ORDER BY Number");
        foreach ($ss as $s) {
            $data[] = $s->dump();
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
        $segs = self::GetSegmentsByUid($uid);


        $ss = "'" . implode("','", $segs) . "'";
        return $ss;
    }

    /**
     * 查询一个抄表班下所有抄表段，拼接给sql查询
     * @param $tid
     * @return array|string
     */
    public static function GetSegmentsStrByTid($tid){
        $segs = self::GetSegmengsByTid($tid);

        $ss = "'" . implode("','", $segs) . "'";
        return $ss;
    }



    /**
     * 取班组下所有抄表段数据集合
     * @param $tid
     * @return array
     */
    public static function GetSegmentDataByTid($tid)
    {
        $data = array();
        $sql = "SELECT DISTINCT * from Segment WHERE UserID in (SELECT ID FROM User WHERE TeamID = ?) ORDER BY Number";
        $param = array($tid);


        $segment = new Segment();

        $rs = new Phalcon\Mvc\Model\Resultset\Simple(null, $segment, $segment->getReadConnection()->query($sql, $param));
        foreach($rs as $r){
            $data[] = $r->dump();
        }

        return $data;
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