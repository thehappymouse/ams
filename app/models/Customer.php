<?php

class Customer extends \Phalcon\Mvc\Model
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
    public $Name;

    /**
     *
     * @var string
     */
    public $CreateTime;

    /**
     *
     * @var string
     */
    public $Number;

    /**
     *
     * @var string
     */
    public $Address;

    /**
     *
     * @var double
     */
    public $Balance;

    /**
     *
     * @var double
     */
    public $Money;

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
     *
     * @var string
     */
    public $RenterPhone;

    /**
     *
     * @var string
     */
    public $Cause;

    /**
     *
     * @var string
     */
    public $IsSpecial;

    /**
     *
     * @var string
     */
    public $IsCut;

    /**
     *
     * @var string
     */
    public $CanCut;

    /**
     *
     * @var string
     */
    public $IsClean;

    /**
     *
     * @var string
     */
    public $Segment;

    /**
     *
     * @var integer
     */
    public $SegmentID;

    /**
     *
     * @var integer
     */
    public $ArrearsCount;

    /**
     *
     * @var string
     */
    public $SegUser;

    /**
     *
     * @var string
     */
    public $IsControl;

    /**
     *
     * @var string
     */
    public $Desc;

    /**
     *
     * @var string
     */
    public $AssetNumber;


    /**
     * Initialize method for model.
     */
    public function initialize()
    {
        $this->setSource('Customer');
        $this->hasMany("Number", "Arrears", "CustomerNumber");
        $this->hasMany("Number", "Charge", "CustomerNumber");

        $c = $this;
        $c->IsCut = 0;
        $c->ArrearsCount = 0;
        $c->CutCount = 0;
        $c->IsClean = 0;
        $c->IsControl = 0;
        $c->Money = 0;
        $c->IsRent = 0;
        $c->RenterPhone = "";

        $c->CanCut = 0;
        $c->IsSpecial = 0;
        $c->CutStyle="";
        $c->PressCount = 0;
    }

    /**
     * 管理班组
     * @var string
     */
    public $Team;
    /**
     * @var int
     */
    public $CutCount;

    /**
     *
     * @var integer
     */
    public $PressCount;

    /**
     *
     * @var string
     */
    public $FirstDate;
    /**
     *
     * @var string
     */
    public $LastDate;

    /**
     *
     * @var integer
     */
    public $AllArrearCount;

    public function getTeamName()
    {
        $user = User::findFirst(array("Name=:name:", "bind" => array("name" => $this->SegUser)));
        if($user) {
            $team = $user->Team;
            return $team->Name;
        }
        else {
            return "";
        }
    }

    /**
     * 根据编号查找客户
     * @param $number
     * @return Customer
     */
    public static  function findByNumber($number)
    {
        return self::findFirst(array("Number=:num:", "bind" => array("num" => $number)));
    }

    /**
     * Independent Column Mapping.
     */
    public function columnMap()
    {
        return array(
            'ID' => 'ID', 
            'Name' => 'Name', 
            'CreateTime' => 'CreateTime', 
            'Number' => 'Number', 
            'Address' => 'Address', 
            'Balance' => 'Balance', 
            'Money' => 'Money', 
            'IsRent' => 'IsRent', 
            'LandlordPhone' => 'LandlordPhone', 
            'RenterPhone' => 'RenterPhone', 
            'Cause' => 'Cause', 
            'IsSpecial' => 'IsSpecial', 
            'IsCut' => 'IsCut', 
            'CanCut' => 'CanCut', 
            'IsClean' => 'IsClean', 
            'Segment' => 'Segment', 
            'SegmentID' => 'SegmentID', 
            'SegUser' => 'SegUser', 
            'IsControl' => 'IsControl', 
            'Desc' => 'Desc', 
            'AssetNumber' => 'AssetNumber', 
            'ArrearsCount' => 'ArrearsCount', 
            'CutCount' => 'CutCount', 
            'LastDate' => 'LastDate',
            'FirstDate' => 'FirstDate',
            'AllArrearCount' => 'AllArrearCount',
            'PressCount' => 'PressCount'
        );
    }

}
