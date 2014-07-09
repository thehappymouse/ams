<?php

class Arrears extends \Phalcon\Mvc\Model
{

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
     * @var integer
     */
    public $CutCount;

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
     * @var string
     */
    public $IsCut;

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
     * Initialize method for model.
     */
    public function initialize()
    {
        $this->setSource('Arrears');
        $this->belongsTo('CustomerNumber', 'Customer', 'Number');
        $this->hasOne('ID', 'Cutinfo', 'Arrear');

        $this->PressCount = 0;
        $this->IsClean = 0;
        $this->CutCount = 0;
        $this->IsCut = 0;
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
            'CutCount' => 'CutCount', 
            'Charge' => 'Charge', 
            'IsClean' => 'IsClean', 
            'IsCut' => 'IsCut',
            'Segment' => 'Segment',
            'Segment' => 'Segment',
            'ChargeDate' => 'ChargeDate'
        );
    }
}
