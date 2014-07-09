<?php

class CustomerController extends ControllerBase
{


    public function indexAction()
    {
        $hs = Hotel::find("CustomerID=" . $this->CustomerID);

        $this->view->hs = $hs;
    }

    /**
     * 更新用户档案
     * 可以修改的项目：用电地址，用户名称，电表资产号，费控标识，是否出租，房客电话，房东电话，欠费原因，备注
     */
    public function updateAction()
    {
        $customer = Customer::findFirst($this->request->get("ID"));
        $customer->Name = $this->request->get("Name");
        $customer->Address = $this->request->get("Address");
        $customer->IsControl = $this->request->get("IsControl");
        $customer->IsRent = $this->request->get("IsRent");
        $customer->LandlordPhone = $this->request->get("LandlordPhone");
        $customer->RenterPhone = $this->request->get("RenterPhone");
        $customer->Cause = $this->request->get("Cause");
        $customer->IsSpecial = $this->request->get("IsSpecial");
        $customer->Desc = $this->request->get("Desc");
        $customer->AssetNumber = $this->request->get("AssetNumber");

        if($customer->save()){
            $this->ajax->flushOk("操作已成功");
        }
        else {
            var_dump($customer->getMessages());
        }
    }

    public function  initialize()
    {
        $cid = $this->CustomerID;
        //var_dump($this->CustomerID);
        $this->customer = Customer::findFirst('38');
        //var_dump($this->customer);
        $this->view->customer = $this->customer;

        parent::initialize();
    }
}

