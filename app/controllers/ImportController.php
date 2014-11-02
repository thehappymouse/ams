<?php


class  ImportController extends ControllerBase
{
    public function  initialize()
    {
        include_once(__DIR__ . "/../../app/library/PHPExcel/Classes/PHPExcel.php");
        parent::initialize();
    }

    public function arrearsAction()
    {

    }

    public function advanceAction()
    {

    }

    public function editarrearAction()
    {

    }

    /**
     * 修改欠费信息的电费金额
     */
    public function updatemoneyAction()
    {
        $id = $this->request->get("ID");
        $money = $this->request->get("Money");

        $arrear = new Arrears();

        $arrear = Arrears::findFirst($id);
        if (!$arrear) {
            $this->ajax->flushError("没有相关的欠费信息");
        }
        $arrear->Money = $money;
        $r = $arrear->save();
        if($r){
            CustomerHelper::SyncCustomerByNumber($arrear->CustomerNumber);
            $this->ajax->flushOk("操作已成功");
        }
        else {
            var_dump($arrear->getMessages());exit;
        }

    }

    public function arrearslistAction()
    {
        $p = new RequestParams($this->request->get());
        $data = array();
        $param = array();

        $conditions = " 1=1 ";

        if ($p->CustomerNumber) {
            $conditions .= " AND CustomerNumber = :Customer:";
            $param["Customer"] = $p->CustomerNumber;
        } else {
            if ($p->Number) {
                if ($p->Number == "全部") { //选择了所有抄表段
                    if (($tid = User::IsAllUsers($p->Name))) { //选择了所有抄表员，则取其组下的抄表段
                        $str = DataUtil::GetSegmentsStrByTid($p->Team);
                    } else {
                        $str = DataUtil::GetSegmentsStrByUid($p->Name);
                    }
                    $conditions .= " AND Segment in ($str)";
                } else {
                    $conditions .= " AND Segment = :segment:";
                    $param["segment"] = $p->Number;
                }
            }
        }


        $conditions_mini = $conditions;
        $conditions .= " limit $p->start, $p->limit";

        $rs = Arrears::find(array($conditions, "bind" => $param));
        foreach ($rs as $r) {
            $d = $r->dump();
            $d["Address"] = $r->Customer->Address;
            $data[] = $d;
        }
        $this->ajax->total = Arrears::count(array($conditions_mini, "bind" => $param));
        $this->ajax->flushData($data);
    }


    /**
     * 文件上传进度
     */
    public function progressAction()
    {
        $this->view->disable();
        if (isset($_GET['progress_key'])) {
            $status = apc_fetch('upload_' . $_GET['progress_key']);

            if ($status['total'] != 0 && !empty($status['total'])) {
                echo json_encode($status);
            } else {
                echo json_encode(array("total" => 100, "current" => 0));
            }
        } else {
            $this->ajax->flushError("no progress key");
        }
    }

    /**
     * 上传预期费用
     */
    public function AdvanceUploadAction()
    {
        $this->ajax->logData->Action = "预存数据更新";
        $dir = str_replace("/app/controllers", "/public/upload/", __DIR__);

        if ($this->request->hasFiles()) {

            $files = $this->request->getUploadedFiles();
            foreach ($files as $file) {

                $savefile = $dir . $file->getName();
                if (!strpos($file->getType(), "excel")) {
                    $this->ajax->flushError("文件格式不正确，请选择excel文件再上传");
                }

                if (move_uploaded_file($file->getTempName(), $savefile)) {

                } else {
                    $this->ajax->flushError("文件上传失败");
                }

                if ($file->getKey() == "arrarsTpl") //模板文件
                {
                    $this->ajax->flushOk("模板文件已上传");

                } else if ($file->getKey() == "fileName") {
                    try {
                        ExcelImportUtils::importAdvance($savefile);
                    } catch (Exception $e) {
                        $this->ajax->flushError($e->getMessage());
                    }
                    $this->ajax->flushOk("数据已更新");
                }
            }
        } else {
            $this->ajax->flushError("没有文件");
        }
    }


    /**
     * 上传欠费数据
     */
    public function ArrearsUploadAction()
    {
        $this->ajax->logData->Action = "欠费数据更新";
        $dir = str_replace("/app/controllers", "/public/upload/", __DIR__);

        if ($this->request->hasFiles()) {

            $files = $this->request->getUploadedFiles();
            foreach ($files as $file) {

                $savefile = $dir . $file->getName();
                if (!strpos($file->getType(), "excel")) {
                    $this->ajax->flushError("文件格式不正确，请选择excel文件再上传");
                }

                if (move_uploaded_file($file->getTempName(), $savefile)) {

                } else {
                    $this->ajax->flushError("文件上传失败");
                }

                if ($file->getKey() == "arrarsTpl") //模板文件
                {
                    $this->ajax->flushOk("模板文件已上传");

                } else if ($file->getKey() == "fileName") {
                    try {
                        ExcelImportUtils::importArrears($savefile);
                    } catch (Exception $e) {
                        $this->ajax->flushError($e->getMessage());
                    }
                    $this->ajax->flushOk("数据已更新");
                }
            }
        } else {
            $this->ajax->flushError("没有文件");
        }
    }
}
