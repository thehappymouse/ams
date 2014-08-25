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
     * @var float
     */
    public $Balance;
     
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
     * @var integer
     */
    public $SegmentID;

    /**
     * @var string
     */
    public $Segment;

    /**
     * @var string
     */
    public $SegUser;

    /**
     * @var string
     */
    public $IsControl;

    /**
     * @var string
     */
    public $Desc;

    /**
     * @var string
     */
    public $IsSpecial;

    /**
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
     * @var string
     */
    public $Team;

    /**
     * 总停决次数
     * @var int
     */
    public $ArrearsCount;

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
            'IsRent' => 'IsRent', 
            'LandlordPhone' => 'LandlordPhone', 
            'RenterPhone' => 'RenterPhone', 
            'Cause' => 'Cause', 
            'IsCut' => 'IsCut', 
            'CanCut' => 'CanCut', 
            'IsClean' => 'IsClean',
            'SegmentID' => 'SegmentID',
            'Segment' => 'Segment',
            'IsControl' => 'IsControl',
            'SegUser' => 'SegUser',
            'IsSpecial' => 'IsSpecial',
            'AssetNumber' => 'AssetNumber',
            'Desc' => 'Desc',
            'ArrearsCount' => 'ArrearsCount',
        );
    }
}
