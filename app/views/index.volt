<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>

    {{ get_title() }}
    {{ stylesheet_link('bootstrap/css/bootstrap.css') }}
    {{ stylesheet_link('css/style.css') }}

    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Your invoices">
    <meta name="author" content="Phalcon Team">
</head>
<body>

{{ javascript_include('js/jquery.1.10.2.min.js') }}
{{ javascript_include('bootstrap/js/bootstrap.js') }}
{{ javascript_include('js/plugin.js') }}
{{ javascript_include('js/apc.js') }}
<!-- Wrap all page content here -->

{{ content() }}


<style>
    .ui-widget-header .ui-icon {
        background-image: url(/ams/public/images/ui-icons_222222_256x240.png);
    }
    .length {
        width: 300px;
    }
</style>

<div id="pop-form">
    <div id='pop-div' class="pop-box" style="text-align:center">

        <div class="pop-box-body">

            <div style="background-color:white;width:200px;height:110px">
                <br/>

                <div id="text" align="center"></div>

                <br/>
                <input id="submit" class="btn " type="button" value="确定" onclick="hideDiv('pop-div');"
                       style="width:50px"/>
            </div>

        </div>
    </div>
</div>

</body>

</html>
