<script>
Ext.onReady(function(){
    var msgTip = new Ext.LoadMask(Ext.getBody(),{
        msg:'Excel正在生成中',
        removeMask : true
    });
    /*二个动态框*/
    var teamCombox = new SettCombbox({
        url:'/ams/Info/TeamList?ID=1&Type=2&All=1',
        fieldLabel: '营业班组',
        anchor:'55%',
        id:'team',
        hiddenName:'Team',
        autoLoad:true
    });
    var peopleCombox = new SettCombbox({
        url:'/ams/Info/UserList',
        fieldLabel: '营业员',
        anchor:'95%',
        hiddenName:'Name',
        id:'people'
    });


    //监听store加载
    function comboxLoad(aCombox, bCombox, url)
    {
        aCombox.store.on('load',function(){
            bCombox.store.load({
                url: url,
                params: {
                    ID: aCombox.store.getAt(0).data.ID
                }
            });
        });
    }
    //监听combox选择事件
    function comSelect(aCombox, bCombox, url)
    {
        aCombox.on("select",function(combo){
            bCombox.reset();
            bCombox.store.load({
                url: url,
                params: {
                    ID: combo.value
                }
            });
        })
    }
    comboxLoad(teamCombox, peopleCombox, "/ams/Info/UserList");
    comSelect(teamCombox, peopleCombox, "/ams/Info/SegmentList");
    var infoSearch = new Ext.FormPanel({
        title: '查询条件',
        defaults:{
            border: false
        },
        labelAlign: 'right',
        style: 'padding-top:10px',
        url:'/ams/Charges/SearchFee',
        layout:'column',
        items: [{
            columnWidth:.40,
            layout: 'form',
            defaults:{
                xtype: 'textfield'
            },
            items: [
                teamCombox
                ,{
                    xtype: 'compositefield',
                    fieldLabel: '收费时间',
                    defaults:{
                        xtype: 'datefield'
                    },
                    items:[
                        {
                            xtype:'datetimefield',
                            format: 'Y-m-d H:i',
                            value:currentDate,
                            name:'FromData',
                            width: 140
                        },{
                            xtype: 'displayfield',
                            value: '至: '
                        },{
                            xtype:'datetimefield',
                            format: 'Y-m-d H:i',
                            name:'ToData',
                            value:new Date().format('Y-m-d H:i:s'),
                            width: 150
                        }]
                }]
        },{
            columnWidth:.25,
            layout: 'form',
            defaults:{
                xtype: 'textfield'
            },
            items: [
                peopleCombox
                ,{
                    xtype: 'compositefield',
                    items:[
                        {
                            xtype: 'hidden'
                        },{
                            width:100,
                            xtype:'button',
                            text:'查询',
                            handler:function(){
                                //var number = Ext.getCmp('searchNumber').getValue();
                                var data = infoSearch.getForm().getValues();
                                listView.store.load({
                                    params : data,
                                    callback:function(v){
                                        if (v.length == 0) {
                                            Ext.MessageBox.alert('提示',"没有收费明细数据");
                                            listView.store.removeAll();
                                            totalView.store.removeAll();
                                        }
                                    },
                                    add: false
                                });
                                totalView.store.load({
                                    params : data,
                                    callback:function(v){
                                        if (v.length == 0) {
                                            Ext.MessageBox.alert('提示',"没有收费员信息汇总");
                                            totalView.store.removeAll();
                                        }
                                    },
                                    add: false
                                });
                                sfView.store.load({
                                    params : data,
                                    callback:function(v){
                                        if (v.length == 0) {
                                            Ext.MessageBox.alert('提示',"没有汇总信息");
                                            sfView.store.removeAll();
                                        }
                                    },
                                    add: false
                                });
                            }
                        }]
                }]
        }]
    });
    var searchPanel = new Ext.TabPanel({
        labelWidth: 85,
        activeTab: 0,
        height:100,
        plain:true,
        defaults:{autoScroll: true},
        items:[
            infoSearch
        ]
    });

    var store = new Ext.data.JsonStore(
            {
                id: 'tvliststore',
                url: '/ams/CountSearch/ReconciliationInquiry',
                root: 'data',
                fields: chargesMoneyFields
            });

    var listView = new Ext.grid.GridPanel(
            {
                store: store,
                multiSelect: true,
                title: '收费明细',
                stripeRows: true,
                region: 'center',
                autoHeight:true,
                emptyText: '没有节目',
                reserveScrollOffset: true,
                viewConfig: {forceFit:true},
                columns: [
                    {
                        header: '收费时间',
                        sortable: true,
                        align:"center",

                        width:110,
                        dataIndex: 'Time'
                    }, {
                        header: '用户编号',
                        dataIndex: 'CustomerNumber',
                        align:"center",
                        sortable: true,
                        renderer:function(v){
                            return "<a href='#'>"+v+"</a>";
                        }
                    }, {
                        header: '用户名称',
                        sortable: true,
                        align:"center",
                        dataIndex: 'CustomerName'
                    }, {
                        header: '电费年月',
                        sortable: true,
                        width:60,
                        align:"center",
                        dataIndex: 'YearMonth'
                    }, {
                        header: '金额',
                        sortable: true,
                        width:50,
                        align:"center",
                        dataIndex: 'Money'
                    },{
                        header: '收费人',
                        sortable: true,
                        align:"center",
                        dataIndex: 'UserName'
                    },
                    {
                        header: '解款状态',
                        sortable: true,
                        align: "center",
                        width: 70,
                        dataIndex: 'PayState',
                        renderer: function (v) {
                            if (v == 1) return '<span style="color:green;">已解款</span>';
                            else if(v == 2) return '<span style="color:red;">已二次解款</span>'
                            else return "-";
                        }
                    },{
                        header: '交费登记电话',
                        sortable: true,
                        align:"center",
                        dataIndex: 'LandlordPhone'
                    },{
                        header: '登记租房户信息',
                        sortable: true,
                        align:"center",
                        dataIndex: 'IsRent'
                    },{
                        header: '签订费控',
                        sortable: true,
                        align:"center",
                        width:50,
                        dataIndex: 'IsControl',
                        renderer:function(v) {
                            if (v == 1) {
                                return '是';
                            } else {
                                return '否';
                            }
                        }
                    }],
                bbar: [{
                    text: 'excel',
                    ref:'../canCel',
                    iconCls: 'excel',
                    handler: function(btn, pressed){
                        if (listView.getStore().data.length == 0) {
                            Ext.MessageBox.alert('提示','请先查询数据');
                            return;
                        }
                        msgTip.show();
                        infoSearch.getForm().submit({
                            url:'/ams/export/AccountCheck',
                            success:function(v,action){
                                var re = Ext.decode(action.response.responseText);
                                msgTip.hide();
                                Ext.MessageBox.alert('提示',"<a target='_blank' href='"+re.msg+"'>下载</a>");
                            },
                            failure:function(v,action) {
                                msgTip.hide();
                                Ext.MessageBox.alert('提示','创建失败');
                            }
                        })
                    }
                }]
            });

    listView.on('cellclick', function (grid, rowIndex, columnIndex, e) {
        var record = grid.getStore().getAt(rowIndex);
        var columnName = grid.getColumnModel().getDataIndex(columnIndex);
        if( columnName == 'CustomerNumber'){
            lookInfo(record.data.CustomerNumber,0)
        }
    })
    var totalStore = new Ext.data.JsonStore(
            {
                id: 'tvliststore',
                url: '/ams/CountSearch/ReconciliationInquiryList',
                root: 'data',
                fields: chargesMoneyFields
            });

    var totalView = new Ext.grid.GridPanel(
            {
                store: totalStore,
                multiSelect: true,
                title: '汇总信息',
                stripeRows: true,
                region: 'center',
                autoHeight:true,
                emptyText: '没有节目',
                reserveScrollOffset: true,
                viewConfig: {forceFit:true},
                columns: [
                    {
                        header: '电费年份',
                        sortable: true,
                        align:"center",
                        dataIndex: 'Year'
                    }, {
                        header: '管理班组',
                        dataIndex: 'Team',
                        align:"center",
                        sortable: true
                    }, {
                        header: '收费笔数',
                        sortable: true,
                        align:"center",
                        dataIndex: 'ChargeCount'
                    }, {
                        header: '收费金额',
                        sortable: true,
                        align:"center",
                        dataIndex: 'Money'
                    }, {
                        header: '解款金额',
                        sortable: true,
                        align:"center",
                        dataIndex: 'PayIn'
                    }, {
                        header: '签订费控数',
                        sortable: true,
                        align:"center",
                        dataIndex: 'ControlCount'
                    },{
                        header: '登记电话',
                        sortable: true,
                        align:"center",
                        dataIndex: 'PhoneCount'
                    }]
            });

    var  sfStore = new Ext.data.JsonStore(
            {
                id: 'tvliststore',
                url: '/ams/CountSearch/ChargeCount',
                root: 'data',
                fields: ['UserName', 'ControlCount', 'Count', 'Money', 'PayIn']
            });

    var   sfView = new Ext.grid.GridPanel(
            {
                store: sfStore,
                multiSelect: true,
                title: '收费员信息汇总',
                stripeRows: true,
                region: 'center',
                autoHeight:true,
                emptyText: '没有节目',
                reserveScrollOffset: true,
                viewConfig: {forceFit:true},
                columns: [
                    {
                        header: '收费员',
                        sortable: true,
                        align:"center",
                        dataIndex: 'UserName'
                    },  {
                        header: '收费笔数',
                        sortable: true,
                        align:"center",
                        dataIndex: 'Count'
                    }, {
                        header: '收费金额',
                        sortable: true,
                        align:"center",
                        dataIndex: 'Money'
                    }, {
                        header: '解款金额',
                        sortable: true,
                        align:"center",
                        dataIndex: 'PayIn'
                    }, {
                        header: '签订费控数',
                        sortable: true,
                        align:"center",
                        dataIndex: 'ControlCount'
                    }]
            });
    var moneyTab = new Ext.TabPanel({
        labelWidth: 85,
        activeTab: 0,
        plain:true,
        style: 'margin-top:15px',
        defaults:{autoScroll: true},
        items:[
            listView
        ]
    });

    var totalTab = new Ext.TabPanel({
        labelWidth: 85,
        activeTab: 0,
        plain:true,
        style: 'margin-top:15px',
        defaults:{autoScroll: true},
        items:[
            totalView
        ]
    });

    var sfTab = new Ext.TabPanel({
        labelWidth: 85,
        activeTab: 0,
        plain:true,
        style: 'margin-top:15px',
        defaults:{autoScroll: true},
        items:[
            sfView
        ]
    });

    var allPanel = new Ext.Panel({
        region: 'center',
        fileUpload: true,
        autoScroll: true,
        bodyStyle: "padding:20px;",
        items: [
            searchPanel,
            moneyTab,
            sfTab,
            totalTab
        ]
    });
    new Ext.Viewport(
    {
        layout: 'border',
        items: [
            allPanel
        ]
    });
})
</script>