<?php use Phalcon\Tag as Tag;

?>

{{content()}}

<div class="panel panel-default">
    <!-- Default panel contents -->
    <div class="panel-heading">
        <h3>{{customer.Name}}：
            <small>用户列表</small>

            {{ link_to('customer/createuser', '<i class="glyphicon glyphicon-check"></i>添加', "class":"btn btn-link pull-right" ) }}

        </h3>
    </div>

    <table class="table table-bordered table-striped">
        <thead>
        <tr>
            <th>#</th>
            <th>用户名称</th>
            <th>加入时间</th>
            <th>状态</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <?php
        if(isset($us)){
            $index = 0;
            foreach($us as $products){ ?>
                <tr>
                    <td><?php echo ++$index ?></td>
                    <td><?php echo $products->Name ?></td>

                    <td><?php echo $products->CreateTime ?></td>
                    <td>正常</td>
                    <td width="12%">
                        <?php echo Tag::linkTo(array(
                            "customer/edituser/".$products->ID,
                            '<i class="glyphicon glyphicon-edit"></i>',
                            "class" => "btn-default")) ?>

                        <a class="btn-link" onclick="test()"><i class="glyphicon glyphicon-edit"></i></a>

                        <?php echo Tag::linkTo(array(
                            "user/delete/". $products->ID,
                            '<i class="glyphicon glyphicon-remove"></i>',
                            "data-target" => "#myModal",
                            "class" => "btn-default")) ?>
                    </td>
                </tr>
            <?php }
        } ?>
        </tbody>
    </table>

</div>

<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="myModalLabel">编辑用户</h4>
            </div>
            <div class="modal-body">
                {{ form('customer/createuser', 'method': 'post', 'role':'form') }}
                <div class="form-group">
                    <label for="exampleInputEmail1">用户名</label>
                    {{ text_field("Name", "size": 32, "value":"123r", "class":"form-control") }}
                </div>
                <div class="form-group">
                    <label for="exampleInputPassword1">密码</label>
                    {{ password_field("Password", "size": 32, "class":"form-control") }}

                </div>
                <div class="form-group">
                    <label for="exampleInputFile">选择管理酒店</label>

                    <p class="help-block">Example block-level help text here.</p>
                </div>

                {{ end_form() }}

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary">Save changes</button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<script type="text/javascript">
    var test = function(){
        $('#myModal').modal({
            keyboard: false,
            backdrop: "static",
            show: true
        })
    }
    window.onload = function(){

        $('#myModal').on('hidden.bs.modal', function (e) {
//            alert($('#myModal').uid);
        })

    }



</script>


