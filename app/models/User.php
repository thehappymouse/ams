<?php

class User extends \Phalcon\Mvc\Model
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
    public $Pass;

    /**
     *
     * @var integer
     */
    public $Role;

    /**
     *
     * @var string
     */
    public $CreateTime;

    /**
     * @var string
     */
    public $RoleName;

    /**
     *
     * @var integer
     */
    public $CreateUser;

    /**
     *
     * @var integer
     */
    public $TeamID;

    /**
     * Initialize method for model.
     */
    public function initialize()
    {
        $this->setSource('User');
        $this->belongsTo('TeamID', 'Team', 'ID');
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
            'Name' => 'Name', 
            'Pass' => 'Pass', 
            'Role' => 'Role', 
            'RoleName' => 'RoleName',
            'CreateTime' => 'CreateTime',
            'CreateUser' => 'CreateUser', 
            'TeamID' => 'TeamID'
        );
    }

}
