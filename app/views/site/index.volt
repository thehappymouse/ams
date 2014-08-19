<style>
    table tr td {
        padding: 10px;
    }
</style>
<script>
    initImg = function(url) {
        if (!img){
            var img = new Image();
        }
        img.src = url;
        return img;
    }
    var img = initImg("/ams/Jpg/SingleBar");
    img.onload = function(){
        var BoredrWidth;
        if (img.width < 535) {
            BoredrWidth = "535px";
        } else {
            BoredrWidth = "675px";
        }

        var tpl = '<div style="border:1px solid #009966;width:675px;height:auto;overflow:scroll;overflow-y:hidden"><img style="margin-top:20px;margin-left:20px;width:'+BoredrWidth+';" src="'+img.src+'"  /></div>';
        $("#single").append(tpl);
    }

    var arrasImage = initImg("/ams/Jpg/ArrarsMonth");
    arrasImage.onload = function(){
        var BoredrWidth = arrasImage.width+"px";
        var tpl = '<img style="margin-top:20px;margin-left:20px;width:'+BoredrWidth+';height:250px;" src="'+arrasImage.src+'"/>';
        $("#arrasImage").append(tpl);
    }


</script>
<br/>
<div style="height:454px">
    <div style="float:left">
        <div class="TableCss" style="font-size:15px">
            <div class="line ClientInfo" style="width:100px;font-size:15px;">欠费情况</div>
            <table id="info" style="width:170px">
                <tr>
                    <td>欠费户数</td>
                    <td>{{arrear["CustomerCount"]}}</td>
                </tr>
                <tr class="InfoTr">
                    <td>欠费笔数</td>
                    <td>{{arrear["ArrearCount"]}}</td>
                </tr>
                <tr>
                    <td>欠费金额</td>
                    <td>{{arrear["Money"]}}</td>
                </tr>
                <tr class="InfoTr">
                    <td>电费回收率</td>
                    <td>{{arrear["Rate"]}}</td>
                </tr>
                <tr>
                    <td>户数回收率</td>
                    <td>{{arrear["CountRate"]}}</td>
                </tr>
                <tr class="InfoTr">
                    <td>个人排名</td>
                    <td>{{arrear["UserIndex"]}}</td>
                </tr>

            </table>
        </div>
        <br/>

        <div class="TableCss" style="font-size:15px">
            <div class="line ClientInfo" style="width:100px;font-size:15px;">昨日缴费情况</div>
            <table id="info" style="width:170px">
                <tr>
                    <td>&nbsp;&nbsp;交费户数</td>
                    <td>{{yesterday["Count"]}}</td>
                </tr>
                <tr>
                    <td>&nbsp;&nbsp;交费金额</td>
                    <td>{{yesterday["Money"]}}</td>
                </tr>


            </table>
        </div>
    </div>
    <div id="single" style="float:left;margin-left:80px">
        <div class="line ClientInfo" style="width:100px;font-size:15px;">个人排名</div>
        
    </div>

</div>
<div style="float:left;">
    <div class="line ClientInfo" style="width:100px;font-size:15px;">欠费客户分析</div>
    <br/>

    <div style="">
        催费完成率：{{press["Rate"]}}，未完成催费户数：{{press["NoPressCustomer"]}}户，未完成催费金额：{{press["NoPressMoney"]}}元。
    </div>
    <div>
        <div style="border:1px solid #009966;width:auto;height:auto;float:left">
            <img style="margin-top:20px;margin-left:20px" src="/ams/Jpg/ArrarsCount"/>
        </div>

        <div style="border:1px solid #009966;width:auto;height:auto;margin-left:195px;float:left">
            <img style="margin-top:20px;margin-left:20px" src="/ams/Jpg/CutCount"/>
        </div>
    </div>
    <div   id="arrasImage"  style="border:1px solid #009966;width:940px;float:left;margin-top:20px;overflow:scroll;overflow-y:hidden">
    </div>


</div>
<div style="height:20px;float:left;width:500px"></div>
