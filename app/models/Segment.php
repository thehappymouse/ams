<?php

class Segment extends \Phalcon\Mvc\Model
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
    public $Number;

    /**
     *
     * @var string
     */
    public $Name;

    /**
     *
     * @var integer
     */
    public $UserID;

    /**
     * @param null $parameters
     * @return Arrears
     */
    public static function findFirst($parameters=null){
        return parent::findFirst($parameters);
    }

    /**
     * @var string
     */
    public $UserName;

    /**
     * Initialize method for model.
     */
    public function initialize()
    {
        $this->setSource('SegmentLog');
    }

    /**
     * Independent Column Mapping.
     */
    public function columnMap()
    {
        return array(
            'ID' => 'ID', 
            'Number' => 'Number', 
            'Name' => 'Name', 
            'UserID' => 'UserID',
            'UserName' => 'UserName'
        );
    }

}
