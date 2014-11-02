<?php

class Arrears extends \Phalcon\Mvc\Model
{

    /**
     * 获取欠费的最早年月
     */
    public static  function getStartDate()
    {
        $model = Arrears::findFirst("1=1 ORDER BY YearMonth ASC");
        return $model->YearMonth;
    }

    /**
     *
     * @var integer
     */
    public $ID;

    /**
     *
     * @var string
     */
    public $YearMonth;

    /**
     *
     * @var string
     */
    public $CustomerNumber;

    /**
     *
     * @var string
     */
    public $CustomerName;

    /**
     *
     * @var double
     */
    public $Money;

    /**
     *
     * @var integer
     */
    public $PressCount;


    /**
     *
     * @var string
     */
    public $Charge;

    /**
     *
     * @var string
     */
    public $IsClean;

    /**
     *
     * @var string
     */
    public $ChargeDate;

    /**
     * @var string
     */
    public $Segment;

    /**
     * @var string
     */
    public $SegUser;

    /**
     * Initialize method for model.
     */
    public function initialize()
    {
        $this->setSource('Arrears');
//        $this->belongsTo('CustomerNumber', 'Customer', 'Number');
        $this->hasOne('ID', 'Cutinfo', 'Arrear');

        $this->PressCount = 0;
        $this->IsClean = 0;
        $this->IsCut = 0;
    }


    var  $customer;

    public function __get($name)
    {
        if($name == "Customer"){
            if(!$this->customer){
                $this->customer = Customer::findByNumber($this->CustomerNumber);
            }
            return $this->customer;
        }

        return parent::__get($name);
    }



    /**
     * @param null $parameters
     * @return Arrears
     */
    public static function findFirst($parameters=null){
        return parent::findFirst($parameters);
    }


    /**
     * 根据用户编号，查找其欠费信息
     * @param $customerNumber
     * @return \Phalcon\Mvc\Model\ResultsetInterface
     */
    public static function findByNumber($customerNumber)
    {
        return self::Find(array("CustomerNumber=:num:", "bind" => array("num" => $customerNumber)));
    }

    /**
     * Independent Column Mapping.
     */
    public function columnMap()
    {
        return array(
            'ID' => 'ID', 
            'YearMonth' => 'YearMonth', 
            'CustomerNumber' => 'CustomerNumber', 
            'CustomerName' => 'CustomerName', 
            'Money' => 'Money', 
            'PressCount' => 'PressCount', 
            'Charge' => 'Charge',
            'IsClean' => 'IsClean', 
            'IsCut' => 'IsCut',
            'Segment' => 'Segment',
            'SegUser' => 'SegUser',
            'ChargeDate' => 'ChargeDate'
        );
    }
}
