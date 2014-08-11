$(document).ready(function(){

			Date.prototype.format = function(fmt)
			{ //author: meizz
			  var o = {
			    "M+" : this.getMonth()+1,                 //月份
			    "d+" : this.getDate(),                    //日
			    "h+" : this.getHours(),                   //小时
			    "m+" : this.getMinutes(),                 //分
			    "s+" : this.getSeconds(),                 //秒
			    "q+" : Math.floor((this.getMonth()+3)/3), //季度
			    "S"  : this.getMilliseconds()             //毫秒
			  };
			  if(/(y+)/.test(fmt))
			    fmt=fmt.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));
			  for(var k in o)
			    if(new RegExp("("+ k +")").test(fmt))
			  fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length)));
			  return fmt;
			}

			PageSize = 30;

			width = window.screen.width/2;
			height = window.screen.height/2;
			
			UserDuty =  {"1":"抄表员", "2":"抄表员班长", "3":"收费员", "4":"收费员班长", "5":"对账", "6":"管理人员"};

			$("#Arrears").on("dblclick","#PressCount",function(v){

				var value = v.currentTarget.title;
		
				window.open("/ams/PopPage/ReminderFee/"+value,"cuifei","height="+height*1.5+", width="+width*1.5);
			})

			$("#Arrears").on("dblclick","#CutCount",function(v){
				var value = v.currentTarget.title;
			
		
				window.open("/ams/PopPage/PowerCut/"+value,"tingdian","height="+height*1.5+", width="+width*1.5);
			})

			
			$("#Arrears").on("dblclick","#CustomerNumber",function(v){
			
				var value = v.currentTarget.title;
	
				window.open("/ams/PopPage/Info/"+value,"info","height="+height*1.5+", width="+width*1.5);
			})

	
	
	 		/*设置input value 的时间日期*/

			myDate = new Date();
			Year = myDate.getFullYear();

			var Month = myDate.getMonth()>9?myDate.getMonth().toString():'0' + (parseInt(myDate.getMonth())+1); 
			var Dath = myDate.getDate()>9?myDate.getDate().toString():'0' + myDate.getDate();
			var Ago7day = getDate(6);
		
		
			var Hour = myDate.getHours()
			 Hour = Hour>9?Hour:'0' + Hour;
			var Minute = myDate.getMinutes(); 
			Minute = Minute>9?Minute:'0' + Minute;
			
			var TreeAgoMonth =  (parseInt(myDate.getMonth())-3)>9?myDate.getMonth().toString():'0' + (parseInt(myDate.getMonth())-3); 
			
			CurrentTime = Year+"-"+Month+"-"+Dath+" "+Hour+":"+Minute;
	 		AgoTime = Ago7day+" "+Hour+":"+Minute;

	 		var Currentday = Year+"-"+Month+"-"+Dath;
			var Agoday = Ago7day;
	 	
			$("#time").val(Currentday);
			$("[name=FromData]").val(Agoday);
			$("[name=ToData]").val(Currentday);

			var CurrentMonth = Year+Month;

			$("[name=Fromdata]").val(CurrentMonth);
			$("[name=Todata]").val(CurrentMonth);
			
			var treemonth =  Year+TreeAgoMonth;
			var YearMonth =  Year+Month;
			$("#from").val(treemonth);
			$("#to").val(YearMonth);

			function getDate(day){
			    var zdate=new Date();
			    var sdate=zdate.getTime()-(1*24*60*60*1000);
			    var edate=new Date(sdate-(day*24*60*60*1000)).format("yyyy-MM-dd");;
			    return edate;
			 
			}
			
			//ajax请求，type代表http请求类型,url请求链接，data数据，func成功后调用的方法---非必需
			AjaxFun = function ()
			{
				var that = this;
				this.SubmitData = function (value)
				{	
				
						//alert(value);
						popupDiv('pop-div',value);
				}
				this.is_alert = true;

				this.GetAjax = function (type, url, data, func, is_alert) 
				{		
				
					is_alert = arguments[4]?arguments[4]:false ;
					
					$.ajax({
							url:url,
							data:data,
							dataType:"json",
							type:type,
							success:function(response)
							{

									if (response.success) {
										if (func != null ) {
											func(response.data, response.total);
										} else {
											if (response.msg){
												that.SubmitData(response.msg);
											} else {
												that.SubmitData('提交成功');
											}
										}
									} else {
										if (!is_alert) {//is_alert为false则调用AjaxFun的SubmitData方法
											that.SubmitData(response.msg);
										} else {
											if (func != null){//is_alert为true并且穿了方法则调用此方法
												func();
											}
										}
										

									}
	                                   
							},
							error:function(XMLHttpRequest, textStatus, errorThrown)
							{
								console.log(errorThrown);
							}
					})
				}

				
			}


			DropDownBox = function ()
			{
				var that = this;
				this.select = {"Name":"", "Team":"", "Number":""};
				//array数据源，select是jquery选择器的选择元素，name是select name属性的值
				this.SetAllSelect = function(array)
				{
					var  select;
					array = arguments[0]?arguments[0]:false ;

					if (!array) {
							
							var name = document.activeElement.name;
							if (name == "Team") {
								var  selectOne = that.select["Name"];
								select = that.select["Number"];
								that.SetSelect(" ",selectOne);

							} else {
								select = that.select["Number"];

							}
							that.SetSelect(" ",select);
							return;
					}
					for (var i in array) 
					{
						switch (i){
							case "Team" : select = that.select["Team"]; name = "Team" ;break;
							case "Name" : select = that.select["Name"]; name = "Name" ;break;
							case "Number" : select = that.select["Number"]; name = "Number" ;break;
						}
						that.SetSelect(name,select,array[name]);
					}
				}

				//name是select name属性的值，select是jquery选择器的选择元素，value是数据源需拥有ID和Value两个字段
				this.SetSelect = function(name,select,value)
				{	
				
					var tpl = '<select name="'+name+'" id="'+name+'" style="width:120px;"> ';
				
					for (var i in value) {
						if (name == "Number") {
							tpl += '<option value="'+value[i].Number+'">'+value[i].Number+'</option>';
						} else {
							tpl += '<option value="'+value[i].ID+'">'+value[i].Name+'</option>';
						}
					}
			    	 	
				    tpl +='</select>';
				    $(select+' select').remove();
				    $(select).append(tpl);
				}
			}
			

		/*	$("#Arrears").on("click","input:checkbox:eq(0)",function(){

					//SelectChexkBox();
			})


			function SelectChexkBox()
			{
				
				if ($("input:checkbox:eq(0)")[0].checked == true) {

					EachChexBox(true);
				} else {
					EachChexBox(false)
				}
			}

			function EachChexBox(v)
			{
				$("input:checkbox").each(function(){
						$(this).attr("checked", v); 
				})
			}
		*/
			checkbox = function (v)
			{
				var value = "";
				var fp = true;
				var arr = Array();
			
				$("input:checkbox").each(function(v){
					if ($(this)[0].checked) {
						fp = false;
						
						if ($(this).attr("value") != undefined) {
							arr.push($(this).attr("value"));
						}
					}
				})
				value =  arr.join();
				if (fp) {
					value = 0;
				}
				return value;
			}

			//判断是不是数组
			isArray = function (o) 
			{  
			  return Object.prototype.toString.call(o) === '[object Array]';   
			}  
			
			//处理数据中的空白或者null
			ReplaceArray = function (v , is_for)
			{
				if (is_for) {
					for (var i in v) {
						for (var s in v[i]) {
							if (v[i][s] == null || v[i][s] == "undefined") {
									v[i][s] = " ";
								}
						}
					}
				} else {
					for (var i in v) {
					
						if (v[i] == null || v[i] == "undefined") {
							v[i] = " ";
						}
					}
				}
				return v;
			}

			showselect = function (value)
	      	{
		          var head = '<div><label class="control-label" for="inputPassword">班组：</label><div id="select" class="controls"><select name="Group">';
		          var foot = '</select></div></div>'
		          var body = "";
		          for (var i in value) {
		              body +='<option value="'+value[i].ID+'">'+value[i].Name+'</option>';
		          }

		          var tpl = head + body + foot;
		          $("#Group div").remove();
		          $("#Group").append(tpl);
	      	}

	      	reload =  function ()
	        {
		        location.reload();
	        }

	        var Reload = false;
	        popupDiv = function(div_id,content,dishid,isload) 
	        {   
                        var div_obj = $("#" + div_id);  
                        var posLeft = ($(window).width() - div_obj.width()) / 2;
                        var posTop = ($(window).height() - div_obj.height()) / 2;
                    
                        //添加并显示遮罩层   
                        $("<div id='mask'></div>").addClass("mask")     
                                                  .appendTo("body")   
                                                  .fadeIn(200); 
                                                  
                        div_obj.css({"top": posTop , "left": posLeft}).fadeIn();
                        var tpl = "<div>"+content+"</div>"
                        $("#text div").remove();
                        $("#text").append(tpl);
                        $("#hide").val(dishid);
                       
                         Reload =   isload       
			}   
			                      
			hideDiv = function(div_id) 
			{
			    $("#mask").remove();
			    $("#" + div_id).fadeOut(); 
			    if (Reload) 
			    {
                     reload();
                } 
             	Reload = false;
			} 

		setTimeout(function(){$("td[name='one']").css("width","100px")},1)
		
		ClickPage = function(G,ShowTable)
		{
			var that =this;
			this.Data;
			this.Page = 1;
			this.SearchUrl;

			this.PageClick = function() {
				$("#Arrears").on("click","#next",function(){
					var NextPage = parseInt(that.Page)+1;

					var SearchData = that.Data+"&Page="+NextPage+"&PageSize="+PageSize;
					that.Page = NextPage;
					G.GetAjax('get',that.SearchUrl,SearchData,ShowTable);
					that.SetDisable();
				})

				$("#Arrears").on("click","#prev",function(){
					var PrevPage = parseInt(that.Page)-1;
					var SearchData = that.Data+"&Page="+PrevPage+"&PageSize="+PageSize;
					that.Page = PrevPage;
					G.GetAjax('get',that.SearchUrl,SearchData,ShowTable);
					that.SetDisable();
				})

				$("#Arrears").on("click","#end",function(){
					var SearchData = that.Data+"&Page="+PageNumber+"&PageSize="+PageSize;
					that.Page =PageNumber;
					G.GetAjax('get',that.SearchUrl,SearchData,ShowTable);
					that.SetDisable();
				})

				$("#Arrears").on("click","#start",function(){
					var SearchData = that.Data+"&Page=1&PageSize="+PageSize;
					that.Page =1;
					G.GetAjax('get',that.SearchUrl,SearchData,ShowTable);
					that.SetDisable();
				})
			}

			this.ReturnPage = function() 
			{
				return that.Page;
			}
			this.SetDisable = function() 
			{
				$("button:eq(1)").attr("disabled","true");
			}
		}

		ExportExcel = function() 
		{
			var that = this;
			this.Todata;
			this.url;
			this.exportTo = function()
			{
				$("#Arrears").on("click","#excel",function(){
					var url = that.url+"?"+that.Todata;
					document.forms["excelform"].action = url;
					document.forms["excelform"].submit(); 
				})
			}
		}

		//获取用户名字所显示的名字。特殊客户是红色，欠费客户是棕色，已停电用户用蓝色
		color = function(isOk, source, realColor, tmpColor) 
		{
			if (isOk == source) {
				return realColor;
			} else {
				return tmpColor;
			}
		}
				
})