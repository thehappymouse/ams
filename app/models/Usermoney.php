<?php

class Usermoney extends \Phalcon\Mvc\Model
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
    public $Month;

    /**
     *
     * @var string
     */
    public $House;

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
        $this->setSource('UserMoney');
    }

    /**
     * Independent Column Mapping.
     */
    public function columnMap()
    {
        return array(
            'ID' => 'ID', 
            'UserID' => 'UserID', 
            'UserName' => 'UserName', 
            'Month' => 'Month',
            'House' => 'House',
            'Money' => 'Money'
        );
    }

}
