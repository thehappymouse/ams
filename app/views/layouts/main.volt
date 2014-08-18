<script>
$(document).ready(function(){
    getNum = function() {
        $.ajax({
            dataType:'json',
            url:'/ams/message/count',
            type:'POST',
            success:function(v) {
                var n="";
                if (v.success) {
                    if (v.data > 0) {
                        n = v.data;
                    }
                    document.getElementById("tpl").innerHTML = n;
                }
            }
        })
    }

    setT = function() {
        getNum();
        setTimeout('setT()',50000);
    }

    var tpl = "<span id='tpl' class='badge' style='color:white'></span>";
    $("#message a").append(tpl);
    setT();
})
</script>
<style>

    .badge {
        padding-right: 9px;
        padding-left: 9px;
        -webkit-border-radius: 9px;
        -moz-border-radius: 9px;
        border-radius: 9px;
        background-color:    red
       }
</style>
<div id="wrap">

    <!-- Begin page content -->
    <div class="container">
        <ul class="nav nav-tabs">
            {{ elements.getMenu() }}
        </ul>

        {{ elements.getBreadcrumbs() }}

        {{ content() }}
    </div>
</div>

