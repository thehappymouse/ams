<?php
use Phalcon\Tag as Tag;

$index = 0;
?>



<div class="panel panel-default">
    <!-- Default panel contents -->
    <div class="panel-heading">
        <h3>{{customer.Name}}：
            <small>酒店列表</small>
        </h3>
    </div>
    <div class="panel-body">
        您已加入TCL云的酒店
    </div>


    <table class="table  table-striped" align="center">
        <thead>
        <tr>
            <th>#</th>
            <th>酒店名称</th>
            <th>城市</th>
            <th>加入时间</th>
            <th>状态</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>


        {% if hs %}
        {% for products in hs %}

        <tr>
            <td><?php echo ++$index ?></td>
            <td>{{products.Name}}</td>
            <td>{{products.City}}</td>
            <td>{{products.CreateTime}}</td>
            <td>正常</td>
            <td width="12%">
                <?php echo Tag::linkTo(array("hotel/index/" . $products->ID, '管理', "class" => "btn-default")) ?>
            </td>
        </tr>

        {% endfor %}
        {% endif %}
        </tbody>
    </table>


</div>


{{content()}}



