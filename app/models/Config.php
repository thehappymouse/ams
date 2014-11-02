<?php

class Config extends \Phalcon\Mvc\Model
{

    /**
     *
     * @var string
     */
    public $Key;

    /**
     *
     * @var string
     */
    public $Value;

    /**
     * Initialize method for model.
     */
    public function initialize()
    {
        $this->setSource('Config');
    }

    /**
     * Independent Column Mapping.
     */
    public function columnMap()
    {
        return array(
            'Key' => 'Key', 
            'Value' => 'Value'
        );
    }

}
