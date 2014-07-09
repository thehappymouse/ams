<?php

class Team extends \Phalcon\Mvc\Model
{
    /**
     * @param null $parameters
     * @return Arrears
     */
    public static function findFirst($parameters=null){
        return parent::findFirst($parameters);
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
    public $Name;

    /**
     *
     * @var integer
     */
    public $Type;

    /**
     *
     * @var string
     */
    public $TypeName;

    /**
     * Initialize method for model.
     */
    public function initialize()
    {
        $this->setSource('Team');
    }

    /**
     * Independent Column Mapping.
     */
    public function columnMap()
    {
        return array(
            'ID' => 'ID', 
            'Name' => 'Name', 
            'Type' => 'Type', 
            'TypeName' => 'TypeName'
        );
    }

}
