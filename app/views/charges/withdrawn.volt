<script>

var startdate = {{startdate}};

Ext.onReady(function () {
    _pageSize = 50;

    /*三个动态框*/
    var teamCombox = new SettCombbox({
        fieldLabel: '管理班组',
        url: '../Info/TeamList?ID=1&Type=1&All=1',
        anchor: '95%',
        id: 'team',
        hiddenName: 'Team',
        autoLoad: true
    });
    var peopleCombox = new SettCombbox({
        url: '../Info/UserList',
        fieldLabel: '抄表员',
        anchor: '95%',
        hiddenName: 'Name',
        id: 'people'
    });
    var NumberCombox = new SettCombbox({
        url: '../Info/SegmentList',
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

    comboxLoad(teamCombox, peopleCombox, "../Info/UserList");
    comboxLoad(peopleCombox, NumberCombox, "../Info/SegmentList");
    comSelect(teamCombox, peopleCombox, "../Info/UserList");
    comSelect(peopleCombox, NumberCombox, "../Info/SegmentList");


    var infoSearch = new Ext.FormPanel({
        title: '查询条件',
        defaults: {
            border: false
        },
        labelAlign: 'right',
        style: 'padding-top:10px',
        url: '/ams/Charges/SearchFee',
        layout: 'column',
        items: [
            {
                columnWidth: .25,
                layout: 'form',
                defaults: {
                    xtype: 'textfield'
                },
                items: [
                    teamCombox
                    , {
                        xtype: 'compositefield',
                        fieldLabel: '电费年月',
                        defaults: {
                            xtype: 'datefield'
                        },
                        items: [
                            new Ext.form.DateField({
                                plugins: 'monthPickerPlugin',
                                name: 'FromData',
                                value: startdate,
                                width: 82,
                                format: 'Ym'
                            }), {
                                xtype: 'displayfield',
                                value: '至: '
                            }, new Ext.form.DateField({
                                plugins: 'monthPickerPlugin',
                                name: 'ToData',
                                width: 82,
                                value: new Date().format('Ym'),
                                format: 'Ym'
                            })]
                    },
                    new QuietCombox({
                        fieldLabel: '电话有效',
                        displayField: 'Text',
                        valueField: 'PhoneEffective',
                        hiddenName: 'PhoneEffective',
                        fields: ['Text', 'PhoneEffective'],
                        data: [
                            ['全部', '2'],
                            ['是', '1'],
                            ['否', '0']
                        ],
                        anchor: '95%'
                    }),
                    new QuietCombox({
                        fieldLabel: '费控标志',
                        displayField: 'Text',
                        valueField: 'IsControl',
                        hiddenName: 'IsControl',
                        fields: ['Text', 'IsControl'],
                        data: [
                            ['全部', '2'],
                            ['是', '1'],
                            ['否', '0']
                        ],
                        anchor: '95%'
                    })]
            },
            {
                columnWidth: .25,
                layout: 'form',
                defaults: {
                    xtype: 'textfield'
                },
                items: [
                    peopleCombox
                    , {
                        xtype: 'compositefield',
                        fieldLabel: '欠费金额',
                        anchor: '95%',
                        items: [
                            new QuietCombox({
                                width: 40,
                                displayField: 'Text',
                                valueField: 'Arrears',
                                hiddenName: 'Arrears',
                                fields: ['Text', 'Arrears'],
                                data: [
                                    ['≥', '1'],
                                    ['<', '0']
                                ]
                            }), {
                                name: 'ArrearsValue',
                                xtype: 'textfield',
                                width: 95
                            }]
                    }, {
                        xtype: 'compositefield',
                        fieldLabel: '欠费笔数',
                        items: [
                            new QuietCombox({
                                width: 40,
                                displayField: 'Text',
                                valueField: 'ArrearsItems',
                                hiddenName: 'ArrearsItems',
                                fields: ['Text', 'ArrearsItems'],
                                data: [
                                    ['≥', '1'],
                                    ['<', '0']
                                ]
                            }), {
                                name: 'ArrearsItemsValue',
                                xtype: 'textfield',
                                width: 95
                            }],
                        anchor: '95%'
                    },
                    new QuietCombox({
                        fieldLabel: '租房客户',
                        displayField: 'Text',
                        valueField: 'IsRent',
                        hiddenName: 'IsRent',
                        fields: ['Text', 'IsRent'],
                        data: [
                            ['全部', '2'],
                            ['是', '1'],
                            ['否', '0']
                        ],
                        anchor: '95%'
                    })]
            },
            {
                columnWidth: .25,
                layout: 'form',
                defaults: {
                    xtype: 'textfield'
                },
                items: [
                    NumberCombox
                    , {
                        xtype: 'compositefield',
                        fieldLabel: '催费次数',
                        items: [
                            new QuietCombox({
                                width: 40,
                                displayField: 'Text',
                                valueField: 'ReminderFee',
                                hiddenName: 'ReminderFee',
                                fields: ['Text', 'ReminderFee'],
                                data: [
                                    ['≥', '1'],
                                    ['<', '0']
                                ]
                            }), {
                                name: 'ReminderFeeValue',
                                xtype: 'textfield',
                                width: 95
                            }],
                        anchor: '95%'
                    },
                    new QuietCombox({
                        fieldLabel: '停电标志',
                        displayField: 'Text',
                        valueField: 'PowerCutLogo',
                        hiddenName: 'PowerCutLogo',
                        fields: ['Text', 'PowerCutLogo'],
                        data: [
                            ['全部', '2'],
                            ['是', '1'],
                            ['否', '0']
                        ],
                        anchor: '95%'
                    }), {
                        xtype: 'compositefield',
                        fieldLabel: '停电次数',
                        items: [
                            new QuietCombox({
                                width: 40,
                                displayField: 'Text',
                                valueField: 'PowerOutages',
                                hiddenName: 'PowerOutages',
                                fields: ['Text', 'PowerOutages'],
                                data: [
                                    ['≥', '1'],
                                    ['<', '0']
                                ]
                            }), {
                                name: 'PowerOutagesValue',
                                xtype: 'textfield',
                                width: 95
                            }],
                        anchor: '95%'
                    }]
            },
            {
                columnWidth: .25,
                layout: 'form',
                items: [
                    {
                        fieldLabel: '用户编号',
                        xtype: 'textfield',
                        name: 'CustomerNumber',
                        anchor: '95%'
                    },
                    {
                        html: '&nbsp;'
                    },
                    {
                        html: '&nbsp;'
                    },
                    {
                        html: '&nbsp;'
                    },
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
                                                listView.store.removeAll();
                                                listView.store.loadData(text);
                                                Ext.apply(listView.store.baseParams, infoSearch.getForm().getValues());
                                                return;
                                            }
                                        },
                                        failure: function (action, msg) {
                                            var text = Ext.decode(msg.response.responseText);
                                            if (!text.success) {
                                                listView.store.removeAll();
                                                Ext.getCmp('bbar').updateInfo();
                                                Ext.Msg.alert('提示', text.msg);
                                                return;
                                            }
                                        }
                                    })
                                }
                            }
                        ]

                    }
                ]
            }
        ]
    });
    var searchTab = new Ext.TabPanel({
        labelWidth: 85,
        activeTab: 0,
        height: 150,
        plain: true,
        defaults: {autoScroll: true},
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
            fields: ArrarsinfoFields
        });

    var singlem = new Ext.grid.CheckboxSelectionModel({singleSelect: true});
    var listView = new Ext.grid.EditorGridPanel(
        {
            store: store,
            multiSelect: true,
            title: '用户基本信息',
            stripeRows: true,
            region: 'center',
            sm: singlem,
            autoHeight: true,
            emptyText: '没有数据',
            viewConfig: {forceFit: true},
            reserveScrollOffset: true,
            tbar: [
                {
                    text: '撤销收费',
                    ref: '../canCel',
                    iconCls: 'del'
                }
            ],
            columns: [
                singlem,
                {
                    header: '抄表段编号',
                    align: "center",
                    sortable: true,
                    dataIndex: 'Segment'
                }, {
                    header: '用户编号',
                    dataIndex: 'CustomerNumber',
                    align: "center",
                    sortable: true,
                    /*editor:new Ext.form.TextField({
                     allowBlank:false
                     })*/
                    renderer: function (v) {
                        return "<a href='#'>" + v + "</a>";
                    }
                }, {
                    header: '用户名称',
                    sortable: true,
                    align: "center",
                    width: 130,
                    dataIndex: 'CustomerName'
                }, {
                    header: '用电地址',
                    sortable: true,
                    align: "center",
                    width: 200,
                    dataIndex: 'Address'
                }, {
                    header: '电费金额',
                    sortable: true,
                    align: "center",
                    dataIndex: 'Money'
                }, {
                    header: '结清标志',
                    sortable: true,
                    align: "center",
                    dataIndex: 'IsClean',
                    renderer: function (v) {
                        if (v == 1) {
                            return '已结清';
                        } else if (v == 0) {
                            return "<a style='color:#804000'>未结清</a>";
                        } else {
                            return '预收转逾期';
                        }
                    }
                }, {
                    header: '停电标志',
                    sortable: true,
                    align: "center",
                    dataIndex: 'IsCut',
                    renderer: function (v) {
                        if (v == 1) {
                            return "<a style='color:blue'>已停电</a>";
                        } else {
                            return "未停电";
                        }
                    }
                }, {
                    header: '催费次数',
                    sortable: true,
                    align: "center",
                    dataIndex: 'PressCount',
                    renderer: function (v) {
                        return "<a href='#'>" + v + "</a>";
                    }
                }, {
                    header: '停电次数',
                    sortable: true,
                    align: "center",
                    dataIndex: 'CutCount',
                    renderer: function (v) {
                        return "<a href='#'>" + v + "</a>";
                    }
                }],
            getSelectedIds: function () {
                var ids = [];
                Ext.each(this.getSelectionModel().getSelections(), function (node) {
                    ids.push(node.get("ID"));
                });

                return ids.join(",");
            },
            bbar: new Ext.PagingToolbar({
                pageSize: _pageSize,
                id: 'bbar',
                store: store,
                displayMsg: "显示{0}条到{1}条记录，总共{2}条记录",
                emptyMsg: "没有数据记录",
                displayInfo: true
            })
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
    })
    listView.on("render", function (p, e) {

        p.canCel.setHandler(function (b, e) {
            //var SegmentNumber =listView.getSelectedIds();listView.getSelectionModel().getSelections()
            if (p.getSelectionModel().getSelections().length == 0) {
                Ext.Msg.alert('提示', '请选择要撤销的条目！');
                return;
            }
            var SegmentNumber = p.getSelectionModel().getSelections()[0].data.CustomerNumber;
            freeView.store.load({
                params: {Number: SegmentNumber },
                add: false
            })
            win.show();
        })
    })

    var sm = new Ext.grid.CheckboxSelectionModel();
    var freeView = new Ext.grid.GridPanel({
        store: new Ext.data.JsonStore({
            url: '/ams/PopPage/Cancel',
            root: 'data',
            fields: arrarsFreeFields
        }),
        multiSelect: true,
        stripeRows: true,
        region: 'center',
        sm: sm,
        height: 300,
        emptyText: '没有数据',
        reserveScrollOffset: true,
        tbar: [
            {
                text: '撤销',
                ref: '../del',
                iconCls: 'del'
            }
        ],
        columns: [
            sm,
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
                header: '房东电话',
                sortable: true,
                align: "center",
                dataIndex: 'LandlordPhone'
            }, {
                header: '房客电话',
                sortable: true,
                align: "center",
                dataIndex: 'RenterPhone'
            }]
    });
    freeView.on("render", function (p, e) {

        p.del.setHandler(function (b, e) {
            var ids = [];
            Ext.each(freeView.getSelectionModel().getSelections(), function (node) {
                ids.push(node.get("ID"));
            });
            var idString = ids.join(",");
            if (ids.length == 0) {
                Ext.Msg.alert('提示', '请选择要撤销的条目！');
                return;
            }
            var number = freeView.store.getAt(0).get("CustomerNumber")
            Ext.Msg.confirm("操作提示", "确定撤销收费吗?", function(v){
                if("yes" != v) return;

                Ext.Ajax.request({
                    url: '/ams/Charges/Cancel',
                    params: {ID: idString, Number: number},
                    success: function (resp, b, c) {
                        var r = Ext.util.JSON.decode(resp.responseText);
                        if (r.success) {
                            Ext.Msg.alert('提示', '撤销成功！');
                        }
                        else if (r.msg) {
                            Ext.Msg.alert('操作提示', r.msg);
                        }
                        else {
                            Ext.Msg.alert('提示', '撤销失败！');
                        }

                        listView.store.reload();

                        freeView.store.reload();

                    }
                })
            });

        })
    })
    var win = new Ext.Window({
        layout: 'fit',
        width: 670,
        height: 300,
        closeAction: 'hide',
        plain: true,
        items: [freeView],
        buttons: [
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
