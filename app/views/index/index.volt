<!--header--><!-- import css-->
{{ stylesheet_link('css/navibar.css') }}

{{ stylesheet_link('css/infobar.css') }}
<STYLE type=text/css>
    BODY {
        MARGIN: 0px;
        BACKGROUND-COLOR: #eaeff5
    }

    .logo {
        BACKGROUND: url(/ams/public/images/logo_default.gif);
        HEIGHT: 54px;
        no-repeat: left
    }
</STYLE>
<script>
    $(document).ready(function () {
        var obj = {"#mainMenu_tab_1": "#mainMenu_menu_1", "#mainMenu_tab_2": "#mainMenu_menu_2", "#mainMenu_tab_3": "#mainMenu_menu_3", "#mainMenu_tab_4": "#mainMenu_menu_4", "#mainMenu_tab_5": "#mainMenu_menu_5", "#mainMenu_tab_6": "#mainMenu_menu_6"}
        $("UL:eq(0) LI").each(function (item) {
            var select = "#mainMenu_tab_" + (parseInt(item) + 1);
            $(select).click(function () {
                var id = obj[select];
                for (var i in obj) {
                    $(i + " a").removeClass("active");
                    if (obj[i] != id) {
                        $(obj[i]).css("display", "none");
                    }
                }
                $(select + " a").addClass("active");
                $(id).css("display", "block");
            })
        })

        $("#mainMenu_menu UL").each(function (item) {
            $(this).children().each(function (litem) {
                $(this).children().click(function (item) {
                    var parentText = $(".active").text();
                    var childrenText = $(this).text();
                    var str = "&nbsp;&nbsp;" + parentText + ">>" + childrenText;
                    $("#TitlePath").empty();
                    $("#TitlePath").append(str);
                });
            })
        })

        logout = function () {
            window.location.href = "/ams/index/logout";
        }

    })
</script>
<div id="main" style="height: 90px;">
    <TABLE id="navTab" cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR class=logo>
            <TD class=topRight id=navimenuTableID>

                <DIV class=naviBar>
                    <UL class=naviTabs id=mainMenu_NaviTabs><!--onclick=javascript:mainMenu.setTab(1)-->

                        {{ elements.getMenu() }}
                    </UL>
                </DIV>
                <DIV class=naviMenu id="mainMenu_menu">

                    {{ elements.getSubMenu() }}
                </DIV>
            </TD>
        </TR>
        </TBODY>
    </TABLE>

    <TABLE class=infobar style="margin-top:-2px;" cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR>
            <TD class="infopath">当前位置:&nbsp;<SPAN id="TitlePath">&nbsp;&nbsp;收费模块>>收费</SPAN></TD>
            <TD align="right" width=330>
                <TABLE class="buttonInfo" id="buttonInfo" cellSpacing="0" cellPadding="0"
                       border="0">
                    <TBODY>
                    <TR>
                        <TD width="160">
                            <DIV class="time" id="serverDateField"
                                 style="PADDING-RIGHT: 10px"></DIV>
                        </TD>

                        <TD class="issueRegisterButton" style="cursor:pointer;" onclick="messageaAert()"><A title=消息
                                                                                                            style="WIDTH: 100%; HEIGHT: 100%"></A>
                        </TD>
                        <TD class="logoutbutton" onclick="logout()" style="cursor:pointer;"><A title="退出"
                                                                                               style="WIDTH: 100%; HEIGHT: 100%"></A>
                        </TD>
                    </TR>
                    </TBODY>
                </TABLE>
            </TD>
        </TR>
        </TBODY>
    </TABLE>
</div>

<script type=text/javascript>

    var curDate = new Date();
    var serverTime = 1409644390152;
    var interval = serverTime - curDate.getTime();

    function setServerTime(getid) {
        localDate = new Date();
        serverDate = new Date(localDate.getTime() + interval);
        myweekday = serverDate.getDay();
        mymonth = parseInt(serverDate.getMonth() + 1) < 10 ? "0" + (serverDate.getMonth() + 1) : serverDate.getMonth() + 1;
        myday = serverDate.getDate();
        myday = parseInt(myday) < 10 ? "0" + myday : myday;
        myyear = serverDate.getFullYear();
        myHours = serverDate.getHours();
        myHours = parseInt(myHours) < 10 ? "0" + myHours : myHours;
        myMinutes = serverDate.getMinutes();
        myMinutes = parseInt(myMinutes) < 10 ? "0" + myMinutes : myMinutes;
        mySeconds = parseInt(serverDate.getSeconds()) < 10 ? "0" + serverDate.getSeconds() : serverDate.getSeconds();
        year = (myyear > 200) ? myyear : 1900 + myyear;
        document.getElementById(getid).innerText = year + "-" + mymonth + "-" + myday + " " + myHours + ":" + myMinutes + ":" + mySeconds;
        setTimeout("setServerTime('" + getid + "')", 1000);
    }
    setServerTime("serverDateField");
</script>


<script type="text/javascript">

    Ext.onReady(function () {
        var menu = new Ext.Panel({
            region: 'north',
            el: main
        });
        var p = new Ext.Panel({
            region: 'center',
            html: "<iframe name=PageFrame src='/ams/site/index' frameborder='no'  width='100%' scrolling='no' height='100%' />"
        });
        new Ext.Viewport(
            {
                layout: 'border',
                items: [menu, p]
            });
    });
</script>