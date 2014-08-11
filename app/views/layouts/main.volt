<script>

$(document).ready(function(){
    getNum = function() {
        $.ajax({
            dataType:'json',
            url:'/ams/message/count',
            type:'POST',
            success:function(v) {
                if (v.success) {
                    if (v.data > 0) {
                        document.getElementById("tpl").innerHTML = v.data;
                    }
                }
            }
        })
    }

    setT = function() {
        var tpl = "<span id='tpl' style='color:red'></span>";
        $("#message a").append(tpl);
        getNum();
        setTimeout('setT()',50000);
    }
    window.onload = setT();
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

