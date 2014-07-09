<?php

class SystemlogController extends ControllerBase
{

    public function indexAction()
    {

    }

    public function listAction()
    {
        $currentPage = (int)$this->request->get("Page");
        $size = (int)$this->request->get("PageSize");

        $robots = Systemlog::find(array(
            "Time BETWEEN :start: AND :end: Order By Time Desc",
            "bind" => array("start" => $this->request->get("FromData"), "end" => $this->request->get("ToData"))));

        $paginator = new Phalcon\Paginator\Adapter\Model(
            array(
                "data" => $robots,
                "limit" => $size,
                "page" => $currentPage
            )
        );

        $page = $paginator->getPaginate();

        //$as = Systemlog::find("1=1 Order By Time Desc");
        $data = array();
        foreach ($page->items as $s) {
            $data[] = $s->dump();
        }

        $this->ajax->total = count($robots);
        $this->ajax->flushData($data);
    }
}

