{{ content() }}

<div class="center-block" style="width: 60%">

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


    <button type="submit" class="btn btn-success" >提交</button>
    {{ link_to('customer/user', "cancel", "class":"btn btn-default pull-right" ) }}

{{ end_form() }}

</div>