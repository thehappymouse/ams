<script>
_pageSize = 50;

Ext.onReady(function () {

    var doSearch = function() {
        infoSearch.getForm().submit({
            method: 'GET',
            params: {
                start: 0,
                limit: _pageSize
            },
            success: function (action, msg) {
                var text = Ext.decode(msg.response.responseText);
                if (text.success) {
                    listView.store.removeAll();
                    listView.store.loadData(text);
                    Ext.apply(listView.store.baseParams, infoSearch.getForm().getValues());
                    Ext.getCmp("allcount").setValue(text.total);
                }
            },
            failure: function (action, msg) {
                var text = Ext.decode(msg.response.responseText);
                if (!text.success) {
                    listView.store.removeAll();
                    Ext.Msg.alert('提示', text.msg);
                    Ext.getCmp("allcount").setValue("");
                }
            }
        });
    }

    var infoSearch = new Ext.FormPanel({
        title: '查询条件',
        labelAlign: 'right',
        style: 'padding-top:10px',
        url: 'list',
        layout: 'column',
        defaults: {
            layout: 'form',
            border: false,
            columnWidth:.25
        },
        items: [
            {
                items: [
                    {
                        xtype: 'datefield',
                        fieldLabel: '收费日期',
                        format: 'Y-m-d',
                        name: 'Date',
                        value: new Date()
                    },
                    {
                        width: 100,
                        style: 'margin-left:50px;margin-top:20px;',
                        xtype: 'button',
                        text: '查询',
                        handler: doSearch
                    }
                ]
            },
            {
                items: [
                    new QuietCombox({
                        fieldLabel: '结算方式',
                        displayField: 'Text',
                        valueField: 'Value',
                        hiddenName: 'PayStyle',
                        fields: ['Text', 'Value'],
                        data: [
                            ['全部', '-1'],
                            ['现金', '1'],
                            ['POS', '2'],
                            ['支票', '3']
                        ],
                        width: 100
                    })
                ]
            },
            {
                items: [
                    new QuietCombox({
                        hidden: true,
                        fieldLabel: '解款状态',
                        displayField: 'Text',
                        valueField: 'Value',
                        hiddenName: 'PayState',
                        fields: ['Text', 'Value'],
                        data: [
                            ['已解款', '1'],
                            ['未解款', '0']
                        ],
                        width: 100
                    })
                ]
            }
        ]
    });
    var searchTab = new Ext.TabPanel({
        labelWidth: 85,
        activeTab: 0,
        height: 120,
        plain: true,
        items: [
            infoSearch
        ]
    });


    var store = new Ext.data.JsonStore(
        {
            url: '/ams/Charges/SearchFee',
            root: 'data',
            totalProperty: 'total',
            baseParams: {
                start: 0,
                limit: _pageSize
            },
            fields: chargesMoneyFields
        });

    var singlem = new Ext.grid.CheckboxSelectionModel({singleSelect: false});
    var listView = new Ext.grid.EditorGridPanel(
        {
            store: store,
            multiSelect: true,
            title: '查询结果',
            stripeRows: true,
            region: 'center',
            sm: singlem,
            autoHeight: true,
            emptyText: '没有数据',
            viewConfig: {forceFit: true},
            reserveScrollOffset: true,  //收费员，解款日期，结算方式，总金额 状态 ，复选框
            columns: [
                singlem,
                {
                    id: 'yearMonth',
                    header: '电费年月',
                    width: 80,
                    sortable: true,
                    align: "center",
                    dataIndex: 'YearMonth'
                }, {
                    header: '收费金额',
                    dataIndex: 'Money',
                    width: 80,
                    align: "center",
                    sortable: true
                }, {
                    header: '收费人',
                    sortable: true,
                    width: 70,
                    align: "center",
                    dataIndex: 'UserName'
                }, {
                    header: '收费时间',
                    sortable: true,
                    align: "center",
                    width: 148,
                    dataIndex: 'Time'
                }, {
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

                }, {
                    header: '结算方式',
                    sortable: true,
                    align: "center",
                    dataIndex: 'PayStyle',
                    renderer: function (v) {
                        if (v == 1) {
                            return "现金";
                        } else if (v == 2) {
                            return "POS";
                        } else if (v == 3) {
                            return "支票";
                        } else {
                            return v;
                        }
                    }
                }],
            getSelectedIds: function () {
                var ids = [];
                Ext.each(this.getSelectionModel().getSelections(), function (node) {
                    ids.push(node.get("ID"));
                });

                return ids.join(",");
            },
            bbar:[ {
                xtype: 'button',
                iconCls:'add',
                text: '点击二次解款',
                ref: '../action'
            }, '->',
                {
                    xtype: 'displayfield',
                    id: 'allcount',
                    style: 'margin-right:10px',
                    value: '汇总信息'
                }
            ]
//            bbar: new Ext.PagingToolbar({
//                pageSize: _pageSize,
//                id: 'bbar',
//                store: store,
//                displayMsg: "显示{0}条到{1}条记录，总共{2}条记录",
//                emptyMsg: "没有数据记录",
//                displayInfo: true
//            })
        });
    listView.on('cellclick', function (grid, rowIndex, columnIndex, e) {
        var record = grid.getStore().getAt(rowIndex);
        var columnName = grid.getColumnModel().getDataIndex(columnIndex);
        if (columnName == 'PressCount') {
            lookInfo(record.data.CustomerNumber, 1)
        } else if (columnName == 'CutCount') {
            lookInfo(record.data.CustomerNumber, 2)
        } else if (columnName == 'CustomerNumber') {
            lookInfo(record.data.CustomerNumber, 0)
        }
    });

    listView.action.setHandler(function(v){
        var ids = listView.getSelectedIds();
        if(!ids) {
            Ext.Msg.alert("操作提示", "未选择收费记录");return;
        }
        Ext.Msg.confirm("操作提示", "确定对选中项目进行操作吗?", function(v){
            if("yes" != v) return;

            Ext.Ajax.request({
                url: 'headerdo',
                params: {ids: ids},
                success: function (resp, b, c) {
                    var r = Ext.util.JSON.decode(resp.responseText);
                    if (r.success) {
                        Ext.Msg.alert('提示', '操作已成功！');
                    }
                    else if (r.msg) {
                        Ext.Msg.alert('操作提示', r.msg);
                    }
                    else {
                        Ext.Msg.alert('提示', '撤销失败！');
                    }
                    doSearch();
                }
            })
        });
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
            searchTab, infoPanel
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
