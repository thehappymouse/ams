<?php

class Charge extends \Phalcon\Mvc\Model
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
    public $CustomerNumber;

    /**
     *
     * @var integer
     */
    public $YearMonth;

    /**
     *
     * @var double
     */
    public $Money;

    /**
     *
     * @var integer
     */
    public $UserID;

    /**
     *
     * @var string
     */
    public $UserName;

    /**
     *
     * @var string
     */
    public $Time;

    /**
     *
     * @var string
     */
    public $IsRent;

    /**
     *
     * @var string
     */
    public $LandlordPhone;

    /**
     * @var string
     */
    public $IsControl;

    /**
     * @var string
     */
    public $Year;

    /**
     *
     * @var string
     */
    public $RenterPhone;
    /**
     *
     * @var string
     */
    public $Segment;
    /**
     *
     * @var string
     */
    public $SegUser;

    /**
     * @var integer
     */
    public $ChargeTeam;

    /**
     * @var integer
     */
    public $ManageTeam;

    /**
     * Initialize method for model.
     */
    public function initialize()
    {
        $this->setSource('Charge');
    }

    /**
     * @param null $parameters
     * @return Arrears
     */
    public static function findFirst($parameters=null){
        return parent::findFirst($parameters);
    }

    /**
     * Independent Column Mapping.
     */
    public function columnMap()
    {
        return array(
            'ID' => 'ID', 
            'CustomerNumber' => 'CustomerNumber', 
            'YearMonth' => 'YearMonth', 
            'Money' => 'Money', 
            'UserID' => 'UserID', 
            'UserName' => 'UserName', 
            'Time' => 'Time', 
            'IsRent' => 'IsRent', 
            'IsControl' => 'IsControl',
            'ChargeTeam' => 'ChargeTeam',
            'ManageTeam' => 'ManageTeam',
            'Segment' => 'Segment',
            'Year' => 'Year',
            'SegUser' => 'SegUser',
            'LandlordPhone' => 'LandlordPhone',
            'RenterPhone' => 'RenterPhone'
        );
    }

}
