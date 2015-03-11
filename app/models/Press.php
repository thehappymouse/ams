<?php

class Press extends \Phalcon\Mvc\Model
{

    /**
     *
     * @var integer
     */
    public $ID;

    /**
     *
     * @var integer
     */
    public $Arrear;

    /**
     *
     * @var string
     */
    public $PressTime;

    /**
     *
     * @var string
     */
    public $PressStyle;

    /**
     *
     * @var string
     */
    public $PhotoLocation;

    /**
     *
     * @var string
     */
    public $Photo;

    /**
     *
     * @var string
     */
    public $PhoneType;

    /**
     *
     * @var string
     */
    public $Phone;

    /**
     *
     * @var integer
     */
    public $UserID;

    /**
     *
     * @var string
     */
    public $SegUser;

    /**
     *
     * @var string
     */
    public $CustomerNumber;

    /**
     *
     * @var string
     */
    public $YearMonth;

    /**
     *
     * @var string
     */
    public $Desc;

    /**
     * @param null $parameters
     * @return Arrears
     */
    public static function findFirst($parameters=null){
        return parent::findFirst($parameters);
    }

    /**
     *
     * @var double
     */
    public $Money;

    /**
     * Initialize method for model.
     */
    public function initialize()
    {
        $this->setSource('Press');
    }

    /**
     * Independent Column Mapping.
     */
    public function columnMap()
    {
        return array(
            'ID' => 'ID', 
            'Arrear' => 'Arrear', 
            'PressTime' => 'PressTime', 
            'PressStyle' => 'PressStyle', 
            'PhotoLocation' => 'PhotoLocation', 
            'Photo' => 'Photo', 
            'PhoneType' => 'PhoneType', 
            'Phone' => 'Phone', 
            'UserID' => 'UserID', 
            'SegUser' => 'SegUser',
            'Segment' => 'Segment',
            'YearMonth' => 'YearMonth',
            'Desc' => 'Desc',
            'Money' => 'Money',
            'CustomerNumber' => 'CustomerNumber'
        );
    }

}
