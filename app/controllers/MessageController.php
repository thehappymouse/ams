<?php

class MessageController extends ControllerBase
{

    public function indexAction()
    {

    }

    /**
     * 消息列表
     */
    public function listAction()
    {
        $this->view->disable();
        $conditions = "1=1";
        $conditions = "ToUserID=" . $this->loginUser["ID"];
        $total = Message::count($conditions);

        $conditions .= " ORDER BY SendTime DESC";
        $conditions = HelperBase::addLimit($conditions, $this->request->get("start"), $this->request->get("limit"));

        $md = Message::find($conditions);
        $data = array();
        foreach ($md as $m) {
            $row = $m->dump();

            $row["Content"] = "[$m->RefCustomer] $m->Content";

            $data[] = $row;
            $m->IsRead = 1;
            $m->save();
        }

        $this->ajax->total = $total;
        $this->ajax->flushData($data);
    }

    /**
     * 消息数量
     */
    public function countAction()
    {

        $today = $this->getDateOnly();
        $tomo = $this->getDateOnly(time() + 3600 * 24);
//
        $count = Message::count(array(" SendTime between :today: and :tomo: and (IsRead <> 1 OR IsRead IS NULL) AND ToUserID=:id:",
            "bind" => array("id" => $this->loginUser["ID"], "today" => $today, "tomo" => $tomo)));
        $this->ajax->flushData($count);

    }

    /**
     * 读消息
     */
    public function readAction()
    {

    }

    /**
     * 删除消息
     */
    public function removeAction()
    {

    }

}

