<?php

/**
 * Created by PhpStorm.
 * User: ww
 * Date: 14-10-30
 * Time: 10:53
 */
class SystemController extends ControllerBase
{
    public function indexAction()
    {
//        $this->view->setTemplateAfter("empty");
        $this->view->pick("system/config");
    }

    public function configAction()
    {
    }
} 