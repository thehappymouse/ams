<?php

class CountsearchController extends ControllerBase
{

    public function initialize()
    {
        $this->view->disable();
        parent::initialize();
    }


    /**
     * 对账查询
     * 参数： Team, Name
     */
    public function ReconciliationInquiryAction()
    {
        list($data, $total) = CountHelper::AccountCheck($this->request->get());

        $this->ajax->flushData(array("charges" => $data, "Total" => $total));
    }

    /**
     * 对账查询--》 财务
     */
    public function ReconciliationAction()
    {
        $total = CountHelper::Reconciliation($this->request->get());

        $this->ajax->flushData($total);
    }

    /**
     * 电费回收明细查询
     */
    public function ChargesAction()
    {
        list($totaldata, $data) = CountHelper::Charges($this->request->get());

        $this->ajax->flushData(array("Data" => $data, "TotalData" => $totaldata));
    }

    /**
     * 催费统计查询
     */
    public function pressAction()
    {
        list($totalData, $data) = CountHelper::DetailsFee($this->request->get());

        $this->ajax->flushData(array("Data" => $data, "TotalData" => $totalData));
    }

    /**
     * 停电数据查询
     */
    public function CutAction()
    {
        list($data, $d2, $total) = CountHelper::Cut($this->request->get());

        if($data == null && $d2 == null){
            $this->ajax->flushData($data);
        }

        $this->ajax->flushData(array("data" => $data, "data2" => $d2, "TotalData" => $total));
    }

    /**
     * 复电查询
     */
    public function ResetAction()
    {
        list($data, $d2, $total) = CountHelper::Reset($this->request->get());
        if($data == null && $d2 == null){
            $this->ajax->flushData($data);
        }

        $this->ajax->flushData(array("data" => $data, "data2" => $d2, "TotalData" => $total));
    }

    /**
     * 客户分类统计，和催费查询一样
     */
    public function customerAction()
    {
        $params = $this->request->get();

        list($total, $data) = CustomerHelper::ArrearsInfo($params);
        $this->ajax->total = $total;
        $this->ajax->flushData($data);
    }

}

