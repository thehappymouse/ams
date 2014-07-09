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
        }
        else {
            $this->ajax->flushError("no progress key");
        }
    }

    /**
     * 上传预期费用
     */
    public function AdvanceUploadAction()
    {
        if ($this->request->hasFiles()) {

            $file = $this->request->getUploadedFiles();
            $file = $file[0];

            $this->ajax->logData->Action = "导入预存数据";

            $dir = str_replace("/app/controllers", "/public/upload/", __DIR__);

            $savefile = $dir . $file->getName();

            if (move_uploaded_file($file->getTempName(), $savefile)) {

                try {
                    ExcelImportUtils::importAdvance($savefile);
                } catch (Exception $e) {
                    $this->ajax->flushError($e->getMessage());
                }


                $this->ajax->flushOk("数据已更新");

            } else {

                $this->ajax->flushError("文件上传失败");
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
        if ($this->request->hasFiles()) {

            $file = $this->request->getUploadedFiles();
            $file = $file[0];

            $this->ajax->logData->Action = "欠费数据更新";
            $dir = str_replace("/app/controllers", "/public/upload/", __DIR__);

            $savefile = $dir . $file->getName();

            if (move_uploaded_file($file->getTempName(), $savefile)) {

                try {
                    ExcelImportUtils::importArrears($savefile);
                } catch (Exception $e) {
                    $this->ajax->flushError($e->getMessage());
                }

                $this->ajax->flushOk("数据已更新");
            } else {
                $this->ajax->flushError("文件上传失败");
            }
        } else {
            $this->ajax->flushError("没有文件");
        }
    }
}
