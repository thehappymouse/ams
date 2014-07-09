<?php

class Cutinfo extends \Phalcon\Mvc\Model
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
    public $CutStyle;

    /**
     *
     * @var string
     */
    public $CutTime;

    /**
     *
     * @var integer
     */
    public $CutUser;

    /**
     *
     * @var string
     */
    public $ResetTime;

    /**
     *
     * @var integer
     */
    public $ResetUser;

    /**
     *
     * @var string
     */
    public $ResetPhone;

    /**
     * @var string
     */
    public $CutUserName;

    /**
     * @var string
     */
    public $ResetStyle;

    /**
     * @var string
     */
    public $CustomerNumber;
    /**
     * @var string
     */
    public $Segment;
    /**
     * @var string
     */
    public $YearMonth;

    /**
     * @param null $parameters
     * @return Arrears
     */
    public static function findFirst($parameters=null){
        return parent::findFirst($parameters);
    }

    /**
     * @var float
     */
    public $Money;

    /**
     * Initialize method for model.
     */
    public function initialize()
    {
        $this->setSource('CutInfo');
    }

    /**
     * Independent Column Mapping.
     */
    public function columnMap()
    {
        return array(
            'ID' => 'ID', 
            'Arrear' => 'Arrear',
            'CutStyle' => 'CutStyle', 
            'CutTime' => 'CutTime', 
            'CutUser' => 'CutUser', 
            'CutUserName' => 'CutUserName',
            'ResetTime' => 'ResetTime',
            'ResetUser' => 'ResetUser', 
            'ResetStyle' => 'ResetStyle',
            'Segment' => 'Segment',
            'CustomerNumber' => 'CustomerNumber',
            'YearMonth' => 'YearMonth',
            'Money' => 'Money',
            'ResetPhone' => 'ResetPhone'
        );
    }
}
