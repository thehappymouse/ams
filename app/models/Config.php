<?php

class Config extends \Phalcon\Mvc\Model
{

    /**
     *
     * @var string
     */
    public $Key;

    /**
     *
     * @var string
     */
    public $Value;

    /**
     *
     * @var string
     */
    public $Desc;

    /**
     * Initialize method for model.
     */
    public function initialize()
    {
        $this->setSource('Config');
    }

    /**
     * 取属性值
     * @param $key
     * @return \Phalcon\Mvc\Model\Resultset|string
     */
    public static function getValue($key)
    {
        $v = self::findFirst(array("Key=:key:", "bind" => array("key" => $key)));
        if($v){
            return $v->Value;
        }
        else {
            return "";
        }
    }

    /**
     * 设置属性
     * @param $key
     * @param $value
     * @return bool
     */
    public static function setValue($key, $value)
    {
        $v = self::findFirst(array("Key=:key:", "bind" => array("key" => $key)));
        if(!$v){
            $v = new Config();
            $v->Key = $key;
        }
        $v->Value = $value;
        return $v->save();
    }

    /**
     * Independent Column Mapping.
     */
    public function columnMap()
    {
        return array(
            'Key' => 'Key', 
            'Desc' => 'Desc',
            'Value' => 'Value'
        );
    }

}
