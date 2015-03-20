<?php
/**
 * Created by PhpStorm.
 * User: ww
 * Date: 15-3-20
 * Time: 16:54
 */

class Tool {

    /**
     * 格式化显示金额
     * @param $money
     * @return string
     */
    public static function FormatMoney($money){

        return sprintf("%.2f", (float)$money);
    }
} 