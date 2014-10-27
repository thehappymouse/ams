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
    public $ArrearsMoney;

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

        $this->IsRent = 0;
        $this->IsCut = 0;
        $this->IsClean = 0;
        $this->CanCut = 0;
        $this->IsControl = 0;
        $this->IsSpecial = 0;
        $this->CutStyle="";
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
            'ArrearsMoney' => 'ArrearsMoney', 
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
            'PressCount' => 'PressCount'
        );
    }

}
