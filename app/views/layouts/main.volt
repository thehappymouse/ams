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

    var tpl = "<span id='tpl' style='color:red'></span>";
    $("#message a").append(tpl);
    setT();
})
</script>
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

