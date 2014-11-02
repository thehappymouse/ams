<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<TITLE>欠费信息管理系统</TITLE>

{{ stylesheet_link('css/ext-all.css') }}
{{ javascript_include('js/ext/ext-base.js') }} 
{{ javascript_include('js/ext/ext-all.js') }}
{{ javascript_include('js/ext/Date.js') }}
{{ javascript_include('js/ext/ext-lang-zh_CN.js') }}
{{ javascript_include('js/ext/ux/fileuploadfield/FileUploadField.js') }}
{{ javascript_include('js/ext/ux/ColumnHeaderGroup.js') }}
{{ stylesheet_link('js/ext/ux/css/ColumnHeaderGroup.css') }}
{{ javascript_include('js/jquery.1.10.2.min.js') }}
{{ stylesheet_link('css/xtheme-green.css') }}

{{ javascript_include('js/ext/date/Spinner.js') }}
{{ javascript_include('js/ext/date/SpinnerField.js') }}
{{ javascript_include('js/ext/date/DateTimeField.js') }}
{{ javascript_include('js/plugin.js') }}
{{ javascript_include('js/win.js') }}
{{ javascript_include('js/field.js') }}
{{ stylesheet_link('css/modifyCss.css') }}

{{ stylesheet_link('js/ext/ux/fileuploadfield/css/fileuploadfield.css') }}


 <script>
Ext.onReady(function(){
messageaAlert = function(){
    messageWin.show();
}
passWinAlert = function(){
    passWin.show();
}

    var store = new Ext.data.JsonStore(
            {
                url: '/ams/message/list',
                root: 'data',
                totalProperty: 'total',
                baseParams: {
                    start: 0,
                    limit: 50
                },
                autoLoad:true,
                fields: ['Content', 'Sender', 'SendTime']
            });

        var listView = new Ext.grid.GridPanel(
            {
                store: store,
                multiSelect: true,
                stripeRows: true,
                region: 'center',
                height: 300,
                emptyText: '没有数据',
                viewConfig: {forceFit:true},
                reserveScrollOffset: true,
                columns: [
                    {
                        header: '内容',
                        align:"center",
                        sortable: true,
                        dataIndex: 'Content'
                    }, {
                        header: '发件人',
                        dataIndex: 'Sender',
                        align:"center",
                        sortable: true,
                        editor:new Ext.form.TextField({
                            allowBlank:false
                        })
                    }, {
                        header: '时间',
                        sortable: true,
                        align:"center",
                        dataIndex: 'SendTime'
                    }],
                bbar: new Ext.PagingToolbar({
                    pageSize: 50,
                    store: store,
                    displayMsg: "显示{0}条到{1}条记录，总共{2}条记录",
                    emptyMsg: "没有数据记录",
                    displayInfo: true
                })
            });
            var messageWin =new Ext.Window({
                layout:'fit',
                width:500,
                height:300,
                closeAction:'hide',
                plain: true,
                title:'消息提醒',
                items:[listView],
                buttons: [{
                    text: '关闭',
                    handler: function(){
                        messageWin.hide();
                    }
                }]
            })

            var passForm = new Ext.FormPanel({
                    labelWidth: 75,
                    frame:true,
                    labelAlign: 'right',
                    style: 'padding-top:10px',
                    url:'/ams/Manager/changePassword',
                    defaultType: 'textfield',
                    items: [{
                            fieldLabel: '旧密码',
                            name: 'oldPassWord',
                            inputType: 'password',
                            allowBlank:false
                        },{
                            fieldLabel: '新密码',
                            name: 'newPassWord',
                            id: 'newPassWord',
                            inputType: 'password',
                            allowBlank:false,
                        },{
                            fieldLabel: '确认密码',
                            name: 'aginPassWord',
                            inputType: 'password',
                            allowBlank:false,
                            id: 'aginPassWord',
                            listeners:{
                                blur:function(v){
                                    var pass = Ext.getCmp('newPassWord').getValue();
                                    var twoPass = Ext.getCmp('aginPassWord').getValue();
                                    if (pass != twoPass) {
                                        Ext.MessageBox.alert('提示','两次密码输入不一样');
                                    }
                                }
                            }
                        }
                    ]
                });

                var passWin =new Ext.Window({
                        layout:'fit',
                        width:300,
                        height:170,
                        closeAction:'hide',
                        plain: true,
                        title: '修改密码',
                        items:[passForm],
                        buttons: [{
                            text: '确定',
                            handler: function(){
                                if(passForm.getForm().isValid()){
                                    passForm.getForm().submit({
                                        success: function(v,action){
                                            Ext.MessageBox.alert("提示",action.result.msg);
                                            passForm.getForm().reset();
                                            passWin.hide();
                                        },
                                        failure: function(v,action){
                                            Ext.MessageBox.alert("提示",action.result.msg);
                                        }
                                    })
                                }
                            }
                        },{
                            text: '关闭',
                            handler: function(){
                                passForm.getForm().reset();
                                passWin.hide();
                            }
                        }]
                })
 })
 </script>

<div id="wrap">
    <div class="container">
        {{ content() }}
    </div>
</div>
 <style>
            .x-grid-record-red table{
                background-color: #ff7b7b;
            }
            .x-grid-record-blue table{
                background-color: #7bff7b;
            }
        </style>

