<?php

/**
 * 日志记载辅助类
 * User: ww
 * Date: 14-8-18
 * Time: 15:17
 */
class LogHelper
{

    var $userid;
    var $username;
    var $ip;


    /**
     * @param Systemlog $obj
     */
    function __construct($obj = null)
    {
        if ($obj) {
            $this->userid = $obj->UserID;
            $this->username = $obj->UserName;
            $this->ip = $obj->IP;
        }
    }

    /*
     * 催费
     */
    public function Press($arrearid, $success, $style)
    {
        $log = new Systemlog();
        $arrear = Arrears::findFirst($arrearid);
        $log->Action = "催费";
        
        $log->Data = $arrear->CustomerName . "|" . $arrear->CustomerNumber . "|$arrear->YearMonth|￥$arrear->Money";

        $log->Success = $success;
        $log->Result = $success ? "操作成功" : "操作失败";
        $log->UserID = $this->userid;
        $log->UserName = $this->username;
        $log->IP = $this->ip;
        $log->Time = HelperBase::getDateTime();
        $r = $log->save();
        return $r;
    }

    /**
     * 根据欠费ID，填写停电日志信息
     * @param $arrearid 欠费ID
     */
    public function Cut($arrearid, $success)
    {
        $log = new Systemlog();
        $arrear = Arrears::findFirst($arrearid);
        $log->Action = "停电";
        $log->Data = $arrear->CustomerName . "|" . $arrear->CustomerNumber . "|(￥)" . $arrear->Money;
        $log->Success = $success;
        $log->Result = $success ? "操作成功" : "操作失败";
        $log->UserID = $this->userid;
        $log->UserName = $this->username;
        $log->IP = $this->ip;
        $log->Time = HelperBase::getDateTime();
        $r = $log->save();
        return $r;
    }
} 