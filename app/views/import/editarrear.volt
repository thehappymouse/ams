<script>
var startdate = "201401";
Ext.onReady(function () {
    _pageSize = 50;
    /*三个动态框*/
    var teamCombox = new SettCombbox({
        url: '/ams/Info/TeamList?ID=1&Type=1',
        fieldLabel: '管理班组',
        anchor: '95%',
        id: 'team',
        hiddenName: 'Team',
        autoLoad: true
    });
    var peopleCombox = new SettCombbox({
        url: '/ams/Info/UserList',
        fieldLabel: '抄表员',
        anchor: '95%',
        hiddenName: 'Name',
        id: 'people'
    });
    var NumberCombox = new SettCombbox({
        url: '/ams/Info/SegmentList',
        fieldLabel: '抄表段编号',
        anchor: '95%',
        hiddenName: 'Number',
        id: 'number'
    });

    //监听store加载
    function comboxLoad(aCombox, bCombox, url) {
        aCombox.store.on('load', function () {
            bCombox.store.load({
                url: url,
                params: {
                    ID: aCombox.store.getAt(0).data.ID
                }
            });
        });
    }

    //监听combox选择事件
    function comSelect(aCombox, bCombox, url) {
        aCombox.on("select", function (combo) {
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
    comboxLoad(peopleCombox, NumberCombox, "/ams/Info/SegmentList");
    comSelect(teamCombox, peopleCombox, "/ams/Info/UserList");
    comSelect(peopleCombox, NumberCombox, "/ams/Info/SegmentList");

    var infoSearch = new Ext.FormPanel({
        title: '查询条件',
        defaults: {
            border: false
        },
        labelAlign: 'right',
        url: '/ams/import/arrearslist',
        style: 'padding-top:10px',
        layout: 'column',
        items: [
            {
                columnWidth: .25,
                layout: 'form',
                items: [teamCombox,
                    {
                        fieldLabel: '用户编号',
                        xtype: 'textfield',
                        name: 'CustomerNumber',
                        anchor: '95%'
                    }
                ]
            },
            {
                columnWidth: .25,
                layout: 'form',
                items: [peopleCombox,
                    {
                        xtype: 'compositefield',
                        fieldLabel: '停电时间',
                        items:[
                        {
                            fieldLabel: '复电时间',
                            xtype:'datetimefield',
                            name:'FromData',
                            value:new Date().format('Y-m-d'),
                            width:82
                        },{
                            xtype: 'displayfield',
                            //   style: 'text-align:right;width:40px;',
                            value: '至: '
                        },{
                            fieldLabel: '复电时间',
                            xtype:'datetimefield',
                            value:new Date(),
                            name:'ToData',
                            width:82
                        }]
                    }
                ]
            },
            {
                columnWidth: .25,
                layout: 'form',
                items: [NumberCombox,
                {
                    xtype: 'compositefield',
                    items: [
                        {xtype: 'hidden'},
                        {
                            width: 100,
                            xtype: 'button',
                            text: '查询',
                            handler: function () {
                                infoSearch.getForm().submit({
                                    method: 'GET',
                                    params: {
                                        start: 0,
                                        limit: _pageSize
                                    },
                                    success: function (action, msg) {
                                        var text = Ext.decode(msg.response.responseText);
                                        if (text.success) {
                                            listView.store.loadData(text);
                                            Ext.apply(listView.store.baseParams, infoSearch.getForm().getValues());
                                        }
                                    },
                                    failure: function (action, msg) {
                                        var text = Ext.decode(msg.response.responseText);
                                        if (!text.success) {
                                            listView.store.removeAll();
                                            Ext.Msg.alert('提示', text.msg);
                                        }
                                    }
                                })
                            }
                        }
                    ]
                }]
            }
        ]
    });
    var searchTab = new Ext.TabPanel({
        labelWidth: 85,
        activeTab: 0,
        height: 100,
        plain: true,
        defaults: {autoScroll: true},
        items: [
            infoSearch
        ]
    });

    var store = new Ext.data.JsonStore(
        {
            url: '/ams/import/arrearslist',
            root: 'data',
            totalProperty: 'total',
            baseParams: {
                start: 0,
                limit: _pageSize
            },
            fields: ArrarsinfoFields
        });

    var sm = new Ext.grid.CheckboxSelectionModel({singleSelect: true});
    var listView = new Ext.grid.EditorGridPanel(
        {
            store: store,
            multiSelect: true,
            title: '欠费信息',
            stripeRows: true,
            region: 'center',
            sm: sm,
            autoHeight: true,
            emptyText: '没有数据',
            viewConfig: {forceFit: true},
            reserveScrollOffset: true,
            tbar: [
                {
                    text: '修改数据',
                    ref: '../del',
                    iconCls: 'del'
                }
            ],
            columns: [
                sm,
                {
                    header: '抄表段编号',
                    align: "center",
                    sortable: true,
                    dataIndex: 'Segment'
                }, {
                   header: '抄表员',
                   align: "center",
                   sortable: true,
                   dataIndex: 'SegUser'
               },{
                    header: '用户编号',
                    dataIndex: 'CustomerNumber',
                    align: "center",
                    sortable: true
                }, {
                    header: '用户名称',
                    sortable: true,
                    width: 130,
                    align: "center",
                    dataIndex: 'CustomerName'
                }, {
                    header: '用电地址',
                    width: 200,
                    sortable: true,
                    align: "center",
                    dataIndex: 'Address'
                }, {
                    header: '电费年月',
                    dataIndex: 'YearMonth',
                    sortable: true,
                    align: "center"
                },{
                    header: '电费金额',
                    sortable: true,
                    align: "center",
                    dataIndex: 'Money'
                }],
            bbar: new Ext.PagingToolbar({
                pageSize: _pageSize,
                store: store,
                displayMsg: "显示{0}条到{1}条记录，总共{2}条记录",
                emptyMsg: "没有数据记录",
                displayInfo: true
            })
        });

    listView.on("render", function (p, e) {

        p.del.setHandler(function (b, e) {
            if (p.getSelectionModel().getSelections().length == 0) {
                Ext.Msg.alert('提示', '请选择记录！');
                return;
            }
            var rd = p.getSelectionModel().getSelections()[0];
            var Money = rd.get("Money");
            var SegUser = rd.get("SegUser");
            Ext.getCmp("editMoney").setValue(Money);
            Ext.getCmp("editName").setValue(SegUser);
            Ext.getCmp("arrearID").setValue(rd.get("ID"));
            win.show();
        })
    });


    var win = new Ext.Window({
        layout: 'fit',
        width: 360,
        height: 200,
        closeAction: 'hide',
        title: '修改数据',
        bodyStyle:'padding-top:30px;background:white;',
        items: new Ext.FormPanel({
            labelAlign: 'right',
            url: '/ams/import/updatemoney',
            items: [
                {
                  xtype: 'textfield',
                  fieldLabel: '抄表员',
                  id: 'editName',
                  name: 'Name'
                },{
                    xtype: 'numberfield',
                    minValue: 0,
                    fieldLabel: '收费金额',
                    id: 'editMoney',
                    name: 'Money'
                },{
                    xtype: 'hidden',
                    id: 'arrearID',
                    name: 'ID'
                }
            ]
        }),
        buttons: [
            {
                text: '提交',
                handler: function () {
                    var fp = win.items.itemAt(0);
                    if(fp.getForm().isValid()){
                        fp.getForm().submit({
                            method: 'GET',
                            success: function (action, msg) {
                                var text = Ext.decode(msg.response.responseText);
                                if (text.success) {

                                    Ext.Msg.alert('提示', text.msg);
                                    win.hide();
                                    listView.store.reload();
                                }
                            },
                            failure: function (action, msg) {
                                var text = Ext.decode(msg.response.responseText);
                                if (!text.success) {
                                    listView.store.removeAll();
                                    Ext.Msg.alert('提示', text.msg);
                                }
                            }
                        })
                    }
                }
            },
            {
                text: '关闭',
                handler: function () {
                    win.hide();
                }
            }
        ]
    });


    var infoPanel = new Ext.TabPanel({
        labelWidth: 85,
        activeTab: 0,
        plain: true,
        style: 'margin-top:15px',
        defaults: {autoScroll: true},
        items: [
            listView
        ]
    });


    var formpanels = new Ext.Panel({
        region: 'center',
        fileUpload: true,
        autoScroll: true,
        bodyStyle: "padding:20px;",
        items: [
            searchTab,
            infoPanel
        ]
    });


    new Ext.Viewport(
        {
            layout: 'border',
            items: [
                formpanels
            ]
        });
})
</script>