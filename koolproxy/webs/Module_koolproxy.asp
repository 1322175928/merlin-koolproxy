﻿<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
<meta HTTP-EQUIV="Expires" CONTENT="-1"/>
<link rel="shortcut icon" href="images/favicon.png"/>
<link rel="icon" href="images/favicon.png"/>
<title>软件中心 - koolproxy</title>
<link rel="stylesheet" type="text/css" href="index_style.css"/>
<link rel="stylesheet" type="text/css" href="form_style.css"/>
<link rel="stylesheet" type="text/css" href="usp_style.css"/>
<link rel="stylesheet" type="text/css" href="ParentalControl.css">
<link rel="stylesheet" type="text/css" href="css/icon.css">
<link rel="stylesheet" type="text/css" href="css/element.css">
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script type="text/javascript" src="/dbconf?p=koolproxy_&v=<% uptime(); %>"></script>
<script type="text/javascript" src="/res/softcenter.js"></script>
<script language="JavaScript" type="text/javascript" src="/client_function.js"></script>
<style>
    .cloud_main_radius h2 { border-bottom:1px #AAA dashed;}
	.cloud_main_radius h3 { font-size:12px;color:#FFF;font-weight:normal;font-style: normal;}
	.cloud_main_radius h4 { font-size:12px;color:#FC0;font-weight:normal;font-style: normal;}
	.cloud_main_radius h5 { color:#FFF;font-weight:normal;font-style: normal;}
</style>

<script>
function init(menu_hook) {
	show_menu();
	get_status();
	buildswitch();
	generate_options();
	conf2obj();
	update_visibility();
	update_visibility1();
    var rrt = document.getElementById("switch");
    if (document.form.koolproxy_enable.value != "1") {
        rrt.checked = false;
    } else {
        rrt.checked = true;
    }
    notice_show();
}

function generate_options(){
	for(var i = 0; i < 24; i++) {
		$j("#koolproxy_update_hour").append("<option value='"  + i + "'>" + i + "点</option>");
		$j("#koolproxy_reboot_hour").append("<option value='"  + i + "'>" + i + "点</option>");
		$j("#koolproxy_update_hour").val(3);
		$j("#koolproxy_reboot_hour").val(3);
	}
	for(var i = 1; i < 73; i++) {
		$j("#koolproxy_reboot_inter_hour").append("<option value='"  + i + "'>" + i + "时</option>");
		$j("#koolproxy_update_inter_hour").append("<option value='"  + i + "'>" + i + "时</option>");
		$j("#koolproxy_reboot_inter_hour").val(72);
		$j("#koolproxy_update_inter_hour").val(24);
	}
	for(var i = 0; i < 60; i++) {
		$j("#koolproxy_update_min").append("<option value='"  + i + "'>" + i + "分</option>");
		$j("#koolproxy_update_inter_min").append("<option value='"  + i + "'>" + i + "分</option>");
		$j("#koolproxy_reboot_min").append("<option value='"  + i + "'>" + i + "分</option>");
		$j("#koolproxy_reboot_inter_min").append("<option value='"  + i + "'>" + i + "分</option>");
		$j("#koolproxy_update_min").val(30);
		$j("#koolproxy_update_inter_min").val(0);
		$j("#koolproxy_reboot_min").val(30);
		$j("#koolproxy_reboot_inter_min").val(0);
	}
}

function get_status() {
    $j.ajax({
        url: 'apply.cgi?current_page=Module_koolproxy.asp&next_page=Module_koolproxy.asp&group_id=&modified=0&action_mode=+Refresh+&action_script=&action_wait=&first_time=&preferred_lang=CN&SystemCmd=koolproxy_status.sh&firmver=3.0.0.4',
        dataType: 'html',
        error: function(xhr) {
	        alert("error");
	        },
        success: function(response) {
    		checkCmdRet2();
        	}
    });
}

function checkCmdRet2(){
	$j.ajax({
		url: '/res/koolproxy_check.htm',
		dataType: 'html',
		
		error: function(xhr){
			setTimeout("checkCmdRet2();", 1000);
		},
		success: function(response){
			var _cmdBtn = document.getElementById("cmdBtn");
			if(response.search("XU6J03M6") != -1){
				kp_status = response.replace("XU6J03M6", " ");
				document.getElementById("status").innerHTML = kp_status;
				return true;
			}
			
			if(_responseLen == response.length){
				noChange++;
			}else{
				noChange = 0;
			}

			if(noChange > 100){
				noChange = 0;
				refreshpage();
			}else{
				setTimeout("checkCmdRet2();", 400);
			}
			_responseLen = response.length;
		}
	});
}

function done_validating(action) {
	return true;
}


var enable_ss = "<% nvram_get("enable_ss"); %>";
var enable_soft = "<% nvram_get("enable_soft"); %>";
function menu_hook(title, tab) {
	if(enable_ss == "1" && enable_soft == "1"){
		tabtitle[17] = new Array("", "koolproxy");
		tablink[17] = new Array("", "Module_koolproxy.asp");
	}else{
		tabtitle[16] = new Array("", "koolproxy");
		tablink[16] = new Array("", "Module_koolproxy.asp");
	}
}

function buildswitch(){
	$j("#switch").click(
	function(){
		if(document.getElementById('switch').checked){
			document.form.koolproxy_enable.value = 1;
			document.getElementById("debug_tr").style.display = "";
			document.getElementById("policy_tr").style.display = "";
			document.getElementById("kp_status").style.display = "";
			document.getElementById("rule_update_switch").style.display = "";
			document.getElementById("lan_control").style.display = "";
			document.getElementById("log_content").style.display = "none";
			document.getElementById("auto_reboot_switch").style.display = "";
			
			
			
		}else{
			document.form.koolproxy_enable.value = 0;
			document.getElementById("debug_tr").style.display = "none";
			document.getElementById("policy_tr").style.display = "none";
			document.getElementById("kp_status").style.display = "none";
			document.getElementById("rule_update_switch").style.display = "none";
			document.getElementById("lan_control").style.display = "none";
			document.getElementById("log_content").style.display = "none";
			document.getElementById("auto_reboot_switch").style.display = "none";
		}
	});
}

function onSubmitCtrl(o, s) {
		document.form.action_mode.value = s;
		document.form.SystemCmd.value = "koolproxy_config.sh";
		if(document.form.koolproxy_enable.value == 1){
			showLoading(10);
			refreshpage(10);
		}else{
			showLoading(4);
			refreshpage(4);
		}
		document.form.submit();
}

function conf2obj(){
    for (var field in db_koolproxy_) {
        $j('#'+field).val(db_koolproxy_[field]);
    }
}

function reload_Soft_Center(){
location.href = "/Main_Soft_center.asp";
}

function update_visibility1(){
	showhide("koolproxy_policy_read1", (document.form.koolproxy_policy.value == 1));
	showhide("koolproxy_policy_read2", (document.form.koolproxy_policy.value == 2));
	showhide("koolproxy_black_lan", (document.form.koolproxy_lan_control.value == 1));
	showhide("koolproxy_white_lan", (document.form.koolproxy_lan_control.value == 2));
	showhide("koolproxy_debug1", (document.form.koolproxy_debug.value == 1));
	showhide("koolproxy_update_hour_span", (document.form.koolproxy_update.value == 1));
	showhide("koolproxy_update_interval_span", (document.form.koolproxy_update.value == 2));
	showhide("koolproxy_reboot_hour_span", (document.form.koolproxy_reboot.value == 1));
	showhide("koolproxy_reboot_interval_span", (document.form.koolproxy_reboot.value == 2));
}

function update_visibility(){
	if(db_koolproxy_["koolproxy_enable"] == "1"){
		document.getElementById("debug_tr").style.display = "";
		document.getElementById("policy_tr").style.display = "";
		document.getElementById("rule_update_switch").style.display = "";
		document.getElementById("kp_status").style.display = "";
		document.getElementById("lan_control").style.display = "";
		document.getElementById("log_content").style.display = "none";
		document.getElementById("auto_reboot_switch").style.display = "";
	}else{
		document.getElementById("debug_tr").style.display = "none";
		document.getElementById("policy_tr").style.display = "none";
		document.getElementById("rule_update_switch").style.display = "none";
		document.getElementById("kp_status").style.display = "none";
		document.getElementById("lan_control").style.display = "none";
		document.getElementById("log_content").style.display = "none";
		document.getElementById("auto_reboot_switch").style.display = "none";
	}
}

function start_update() {
	document.getElementById("log_content").style.display = "";
	document.form.action_mode.value = ' Refresh ';
	document.form.action = "/applydb.cgi?p=koolproxy";
    document.form.SystemCmd.value = "koolproxy_rule_update.sh";
	document.form.submit();
	document.getElementById("cmdBtn").disabled = true;
	document.getElementById("cmdBtn").style.color = "#666";
	setTimeout("checkCmdRet();", 500);
}


var _responseLen;
var noChange = 0;
function checkCmdRet(){

	$j.ajax({
		url: '/cmdRet_check.htm',
		dataType: 'html',
		
		error: function(xhr){
			setTimeout("checkCmdRet();", 1000);
		},
		success: function(response){
			var retArea = $G("log_content1");
			var _cmdBtn = document.getElementById("cmdBtn");
			if(response.search("XU6J03M6") != -1){
				retArea.value = response.replace("XU6J03M6", " ");
				setTimeout("refreshpage();", 3000);
				return false;
			}
			if(_responseLen == response.length){
				noChange++;
			}else{
				noChange = 0;
			}
			if(noChange > 100){
				document.getElementById("log_content").style.display = "none";
				noChange = 0;
				refreshpage();
			}else{
				setTimeout("checkCmdRet();", 500);
			}
			retArea.value = response;
			retArea.scrollTop = retArea.scrollHeight;
			_responseLen = response.length;
		}
	});
}

function notice_show(){
    $j.ajax({
        url: 'https://rules.ngrok.wang/config.json.js',
        type: 'GET',
        dataType: 'jsonp',
        success: function(res) {
			$j("#rule_date_web").html(res.rules_date);
			$j("#video_date_web").html(res.video_date);
        }
    });
}

</script>
</head>
<body onload="init();">
	<div id="TopBanner"></div>
	<div id="Loading" class="popup_bg"></div>
	<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
	<form method="POST" name="form" action="/applydb.cgi?p=koolproxy_" target="hidden_frame">
	<input type="hidden" name="current_page" value="Module_koolproxy_.asp"/>
	<input type="hidden" name="next_page" value="Module_koolproxy_.asp"/>
	<input type="hidden" name="group_id" value=""/>
	<input type="hidden" name="modified" value="0"/>
	<input type="hidden" name="action_mode" value=""/>
	<input type="hidden" name="action_script" value=""/>
	<input type="hidden" name="action_wait" value=""/>
	<input type="hidden" name="first_time" value=""/>
	<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>"/>
	<input type="hidden" name="SystemCmd" onkeydown="onSubmitCtrl(this, ' Refresh ')" value="koolproxy_config.sh"/>
	<input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>"/>
	<input type="hidden" id="koolproxy_enable" name="koolproxy_enable" value='<% dbus_get_def("koolproxy_enable", "0"); %>'/>
	<table class="content" align="center" cellpadding="0" cellspacing="0">
		<tr>
			<td width="17">&nbsp;</td>
			<td valign="top" width="202">
				<div id="mainMenu"></div>
				<div id="subMenu"></div>
			</td>
			<td valign="top">
				<div id="tabMenu" class="submenuBlock"></div>
				<table width="98%" border="0" align="left" cellpadding="0" cellspacing="0">
					<tr>
						<td align="left" valign="top">
							<table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3" class="FormTitle" id="FormTitle">
								<tr>
									<td bgcolor="#4D595D" colspan="3" valign="top">
										<div>&nbsp;</div>
											<table width="100%" height="150px" style="border-collapse:collapse;">
                                            <tr >
                                                <td colspan="5" class="cloud_main_radius">
                                                    <div style="padding:10px;width:95%;font-style:italic;font-size:14px;">
                                                        <br/><br/>
                                                        <table width="100%" >
                                                            <tr>
                                                                <td>
                                                                    <ul style="margin-top:-70px;padding-left:15px;" >
                                                                        <li style="margin-top:-5px;">
                                                                            <h2 id="push_titile"><em>koolproxy <% dbus_get_def("koolproxy_version", "1.7"); %></em></h2>
                                                                            <div style="float:auto; width:15px; height:25px;margin-top:-40px;margin-left:680px"><img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img></div>
                                                                        </li>
                                                                        <li style="margin-top:-5px;">
                                                                            <h3 id="push_content1" >koolproxy是能识别adblock规则的代理软件，可以用于去除网页静广告和视频广告，目前暂时不支持https。
                                                                            </h3>
                                                                        </li>
                                                                        <li  style="margin-top:-5px;">
                                                                            <h3 id="push_content2">
	                                                                            <i>koolproxy静态规则：</i>
	                                                                            <% dbus_get_def("koolproxy_rule_info", "0"); %>
	                                                                            <span style="float: right;margin-right: 200px;" id="rule_date_web"></span>
	                                                                            <font style="float: right;" color="#66FF66">在线版本：</font>
	                                                                         </h3>
                                                                        </li>
                                                                        <li id="push_content3_li" style="margin-top:-5px;">
                                                                            <h3 id="push_content3">
	                                                                            <i>koolproxy视频规则：</i>
	                                                                            <% dbus_get_def("koolproxy_video_info", "0"); %>
                                                                            	<span style="float: right;margin-right: 200px;" id="video_date_web"></span>
                                                                            	<font style="float: right;" color="#66FF66">在线版本：</font>
                                                                            </h3>
                                                                        </li>
                                                                        <li id="push_content4_li" style="margin-top:-5px;display: block;">
                                                                            <h3 id="push_content4"></h3>
                                                                        </li>
                                                                    </ul>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr height="10px">
                                                <td colspan="3"></td>
                                            </tr>
                                        </table>
										<table style="margin:-20px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="routing_table">
											<thead>
											<tr>
												<td colspan="2">开关设置</td>
											</tr>
											</thead>
											<tr id="switch_tr">
												<th>
													<label>开启koolproxy</label>
												</th>
												<td colspan="2">
													<div class="switch_field" style="display:table-cell">
														<label for="switch">
															<input id="switch" class="switch" type="checkbox" style="display: none;">
															<div class="switch_container" >
																<div class="switch_bar"></div>
																<div class="switch_circle transition_style">
																	<div></div>
																</div>
															</div>
														</label>
													</div>
													<div id="koolproxy_install_show" style="padding-top:5px;margin-left:80px;margin-top:-30px;float: left;"></div>	
												</td>
											</tr>
											<tr id="kp_status">
												<th>koolproxy运行状态</th>
												<td><span id="status"></span></td>
											</tr>
		
											<tr id="policy_tr">
												<th>选择过滤模式</th>
												<td>
													<select name="koolproxy_policy" id="koolproxy_policy" class="input_option" onchange="update_visibility1();" style="width:auto;margin:0px 0px 0px 2px;">
														<option value="1" selected>全局过滤</option>
														<option value="2">黑名单模式</option>
													</select>
														<span id="koolproxy_policy_read1" style="display: none;">全局模式下，所有80端口的流量都会走koolproxy过，过滤效果最好。</span>
														<span id="koolproxy_policy_read2" style="display: none;">黑名单模式下只有黑名单内的域名走koolproxy过，效果不及全局模式。</span>
												</td>
											</tr>
											<tr id="rule_update_switch">
												<th>规则自动更新</th>
												<td>
													<select name="koolproxy_update" id="koolproxy_update" class="input_option" style="width:auto;margin:0px 0px 0px 2px;" onchange="update_visibility1();">
														<option value="1" selected>定时</option>
														<option value="2">间隔</option>
														<option value="0">关闭</option>
													</select>
													<span id="koolproxy_update_hour_span">
														&nbsp;&nbsp;&nbsp;&nbsp;
														每天
														<select id="koolproxy_update_hour" name="koolproxy_update_hour" class="ssconfig input_option" >
														</select>
														<select id="koolproxy_update_min" name="koolproxy_update_min" class="ssconfig input_option" >
														</select>
														更新
														&nbsp;&nbsp;&nbsp;&nbsp;
													</span>

													<span id="koolproxy_update_interval_span">
														&nbsp;&nbsp;&nbsp;&nbsp;
														每隔
														<select id="koolproxy_update_inter_hour" name="koolproxy_update_inter_hour" class="ssconfig input_option" >
														</select>
														<select id="koolproxy_update_inter_min" name="koolproxy_update_inter_min" class="ssconfig input_option" >
														</select>
														更新
														&nbsp;&nbsp;&nbsp;&nbsp;
													</span>
													
													<input id="update_now" onclick="start_update()" style="font-family:'Courier New'; Courier, mono; font-size:11px;" type="submit" value="手动更新" />
													<span>
														<a style="margin-left: 20px;" href="https://github.com/koolproxy/koolproxy_rules" target="_blank"><i><u>规则反馈</u></i></a>
													</span>
												</td>
											</tr>

											<tr id="auto_reboot_switch">
												<th>插件自动重启</th>
												<td>
													<select name="koolproxy_reboot" id="koolproxy_reboot" class="input_option" style="width:auto;margin:0px 0px 0px 2px;" onchange="update_visibility1();">
														<option value="1">定时</option>
														<option value="2">间隔</option>
														<option value="0" selected>关闭</option>
													</select>
													<span id="koolproxy_reboot_hour_span">
														&nbsp;&nbsp;&nbsp;&nbsp;
														每天
														<select id="koolproxy_reboot_hour" name="koolproxy_reboot_hour" class="ssconfig input_option" >
														</select>
														<select id="koolproxy_reboot_min" name="koolproxy_reboot_min" class="ssconfig input_option" >
														</select>
														重启
														&nbsp;&nbsp;&nbsp;&nbsp;
													</span>
													
													<span id="koolproxy_reboot_interval_span">
														&nbsp;&nbsp;&nbsp;&nbsp;
														每隔
														<select id="koolproxy_reboot_inter_hour" name="koolproxy_reboot_inter_hour" class="ssconfig input_option" >
														</select>
														<select id="koolproxy_reboot_inter_min" name="koolproxy_reboot_inter_min" class="ssconfig input_option" >
														</select>
														重启koolproxy
														&nbsp;&nbsp;&nbsp;&nbsp;
													</span>
												</td>
											</tr>

											
											<tr id="debug_tr">
												<th>日志显示</th>
												<td>
													<select name="koolproxy_debug" id="koolproxy_debug" class="input_option" onchange="update_visibility1();" style="width:auto;margin:0px 0px 0px 2px;">
														<option value="0" selected>不启用</option>
														<option value="1">启用</option>
													</select>
														<span id="koolproxy_debug1" style="display: none;">开启日志显示后，在<a style="margin-left: 3px;margin-right: 3px" href="Main_LogStatus_Content.asp" target="_blank"><font color="#66FFCC"><u>系统日志</u></font></i></a>就能看到规则命中日志。</span>
												</td>
											</tr>
											<tr id="lan_control">
												<th width="35%">
													<a>局域网客户端控制</a>
													&nbsp;&nbsp;&nbsp;&nbsp;
													<select id="koolproxy_lan_control" name="koolproxy_lan_control" class="input_ss_table" style="width:auto;height:25px;margin-left: 0px;background-color:#1F2D35;" onchange="update_visibility1();">
														<option value="0">禁用</option>
														<option value="1">黑名单模式</option>
														<option value="2">白名单模式</option>
													</select>
												</th>
												<td>
													<textarea placeholder="填入需要走koolproxy的客户端IP如:192.168.1.2,192.168.1.3，每个ip之间用英文逗号隔开" rows=2 style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;border:1px solid gray;display:none" id="koolproxy_black_lan" name="koolproxy_black_lan" title=""></textarea>
													<textarea placeholder="填入不需要走koolproxy的客户端IP如:192.168.1.2,192.168.1.3，每个ip之间用英文逗号隔开" rows=2 style="width:99%; font-family:'Courier New', 'Courier', 'mono'; font-size:12px;background:#475A5F;color:#FFFFFF;border:1px solid gray;display:none" id="koolproxy_white_lan" name="koolproxy_white_lan" title=""></textarea>
												</td>
											</tr>
                                    	</table>
                                    	<div id="log_content" style="margin-top:10px;display: none;">
											<textarea cols="63" rows="21" wrap="off" readonly="readonly" id="log_content1" style="width:99%; font-family:'Courier New', Courier, mono; font-size:11px;background:#475A5F;color:#FFFFFF;">
												<% nvram_dump("syscmd.log","syscmd.sh"); %>
											</textarea>
										</div>
                                    	
										<div class="apply_gen">
											<button id="cmdBtn" class="button_gen" onclick="onSubmitCtrl(this, ' Refresh ')">提交</button>
										</div>
										<div style="margin-left:5px;margin-top:10px;margin-bottom:10px"><img src="/images/New_ui/export/line_export.png"></div>

									</td>
								</tr>
							</table>
						</td>
						<td width="10" align="center" valign="top"></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	</form>
	</td>
	<div id="footer"></div>
</body>
</html>



