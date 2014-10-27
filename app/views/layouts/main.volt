<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<TITLE>电力营销业务应用系统</TITLE>

{{ stylesheet_link('css/ext-all.css') }}
{{ javascript_include('js/ext/ext-base.js') }}
{{ javascript_include('js/ext/ext-all.js') }}
{{ javascript_include('js/ext/Date.js') }}
{{ javascript_include('js/ext/ext-lang-zh_CN.js') }}
{{ javascript_include('js/ext/ux/fileuploadfield/FileUploadField.js') }}
{{ javascript_include('js/ext/ux/ColumnHeaderGroup.js') }}
{{ javascript_include('js/ext/date/DateTimeField.js') }}
{{ javascript_include('js/ext/date/Spinner.js') }}
{{ javascript_include('js/ext/date/SpinnerField.js') }}
{{ javascript_include('js/jquery.1.10.2.min.js') }}
{{ stylesheet_link('css/xtheme-green.css') }}
{{ javascript_include('js/plugin.js') }}
{{ javascript_include('js/win.js') }}
{{ javascript_include('js/field.js') }}
{{ stylesheet_link('css/modifyCss.css') }}
{{ stylesheet_link('js/ext/ux/css/ColumnHeaderGroup.css') }}


 <script>
Ext.onReady(function(){
messageaAert = function(){
    messageWin.show();
}
    var store = new Ext.data.JsonStore(
            {
                url: '/ams/Charges/SearchFee',
                root: 'data',
                totalProperty: 'total',
                baseParams: {
                    start: 0,
                    limit: 5
                },
                fields: ArrarsinfoFields
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
                        header: '抄表段编号',
                        align:"center",
                        sortable: true,
                        dataIndex: 'Segment'
                    }, {
                        header: '用户编号',
                        dataIndex: 'CustomerNumber',
                        align:"center",
                        sortable: true,
                        editor:new Ext.form.TextField({
                            allowBlank:false
                        })
                    }, {
                        header: '用户名称',
                        sortable: true,
                        align:"center",
                        dataIndex: 'CustomerName'
                    }, {
                        header: '用电地址',
                        sortable: true,
                        align:"center",
                        dataIndex: 'Address'
                    }, {
                        header: '电费年月',
                        sortable: true,
                        align:"center",
                        dataIndex: 'YearMonth'
                    }],
                bbar: new Ext.PagingToolbar({
                    pageSize: 5,
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
 })
 </script>

<div id="wrap">
    <div class="container">
        {{ content() }}
    </div>
</div>

