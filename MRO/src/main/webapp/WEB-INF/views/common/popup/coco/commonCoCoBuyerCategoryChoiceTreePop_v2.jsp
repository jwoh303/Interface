<%--
**********************************************
* 메뉴 : 
* 화면 : 구매사(고객사) 카테고리 선택 팝업 ( 트리형 )
* 기능 : 
* 프로그램 ID : 
* 담당자 :  고영일 ( 설계 : 공통 )
* 착수일 : 2014-06-24
**********************************************
--%>
<%@page import="com.ctc.wstx.util.StringUtil"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<%@ include file="../../include/head_v2.jspf"%>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
String root_category_name = CommonUtil.nvl((String) request.getAttribute("root_category_name"),"");  //  (조회조건)

String st_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");  //  (조회조건)
String nu_i = CommonUtil.nvl((String) request.getParameter("nu_i"),"");  //  (조회조건)
%>

<script type="text/javascript">
var icon_open = '/resources/images/tree/tree_open.gif';
var icon_close = '/resources/images/tree/tree_close.gif';
var icon_folder_uc = '/resources/images/tree/folder_uc.gif';
var icon_folder_se = '/resources/images/tree/folder_se.gif';
var icon_folder_item = '/resources/images/tree/folder_uc_item.gif';
var sel_categ_pid = "";

$(document).ready(function(){
	$('#tree_menu').find('li:last-child').addClass('end');
	
	function tree_init(status){
		if (status == 'close'){
			$('#tree_menu').find('ul').hide();
			$('a.control').find('img').attr('src', icon_open);
			$('a.folder_control').find('img').attr('src', icon_folder_uc);
		} else if (status == 'open'){
			$('#tree_menu').find('ul').show();
			$('a.control').find('img').attr('src', icon_close);
			$('a.folder_control').find('img').attr('src', icon_folder_se);
		}
	}
	tree_init('close');
	
	$('#css_use').toggle(function(){
		$('link').attr('href', '');
		$(this).text('CSS (O)');
	},function(){
		$('link').attr('href', 'tree.css');
		$(this).text('CSS (X)');
	});
	$('#all').toggle(function(){
		tree_init('open');
		$(this).text('ALL CLOSE');
	},function(){
		tree_init('close');
		$(this).text('ALL OPEN');
	});
});

function fn_control(std_categ_id){
	if(!$("#"+std_categ_id).find('>ul').is("ul")){
		sel_categ_pid = std_categ_id;
		var pData = { st_buyer : "<%=st_buyer%>", st_category_id : std_categ_id };
		kepAjaxCall("/coco/getCategoryTreeChildSelect.do",pData,"getCategoryTreeChildSelect");
	}else{
		tree_control(std_categ_id);
	}
}

function tree_control(std_categ_id){
	var temp_el = $("#"+std_categ_id).find('>ul');
	if ($(temp_el).css('display') == 'none'){
		$(temp_el).slideDown(100);
		$("#"+std_categ_id).find('.control:eq(0) img').attr('src', icon_close);
		$("#"+std_categ_id).find(".folder_control:eq(0) img").attr('src', icon_folder_se);
	} else {
		$(temp_el).slideUp(100);
		$("#"+std_categ_id).find('.control:eq(0) img').attr('src', icon_open);
		$("#"+std_categ_id).find(".folder_control:eq(0) img").attr('src', icon_folder_uc);
	}
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	if ( pMethod == "getCategoryTreeChildSelect" ) {
		
		if (response.data.length > 0){
			var addElementStr = "";
			addElementStr   = "<ul style=\"display : none;\">";
			
			for (var i=0; i<response.data.length; i++){ 
				var D_STD_CATEG_ID = $.trim(eval("response.data["+i+"].STD_CATEG_ID")); 
				var D_CATEG_NAME = $.trim(eval("response.data["+i+"].CATEG_NAME")); 
				var D_CATEG_SYS_CODE = $.trim(eval("response.data["+i+"].CATEG_SYS_CODE")); 
				var D_CATEG_TYPE = $.trim(eval("response.data["+i+"].CATEG_TYPE")); 
				var D_PID = $.trim(eval("response.data["+i+"].PID")); 
				var D_DEPTH = $.trim(eval("response.data["+i+"].DEPTH"));
				var D_CATEG_PATH = $.trim(eval("response.data["+i+"].CATEG_PATH"));
				
				if(D_CATEG_TYPE == "REG"){
					addElementStr += "<li id=\"" + D_STD_CATEG_ID + "\">";
					addElementStr += "<a href=\"javascript:fn_control('" + D_STD_CATEG_ID + "');\" class=\"control\"><img src=\"/resources/images/tree/tree_open.gif\" /></a>";
					addElementStr += "<a href=\"javascript:fn_control('" + D_STD_CATEG_ID + "');\" class=\"folder_control\"><img src=\"/resources/images/tree/folder_uc.gif\" width=\"16\"/></a>";
					addElementStr += "<a href=\"javascript:setSelectItemInfo('" + D_STD_CATEG_ID + "','" + D_CATEG_NAME + "','" + D_CATEG_TYPE + "','" + D_CATEG_SYS_CODE + "','" + D_DEPTH + "','" + D_PID + "','" + D_CATEG_PATH + "');\" >" + D_CATEG_NAME + "</a>";
					addElementStr += "</li>";
				} else {
					addElementStr += "<li id=\"" + D_STD_CATEG_ID + "\"><img src=\"/resources/images/tree/folder_uc_item.gif\" width=\"16\"/><a href=\"javascript:setSelectItemInfo('" + D_STD_CATEG_ID + "','" + D_CATEG_NAME + "','" + D_CATEG_TYPE + "','" + D_CATEG_SYS_CODE + "','" + D_DEPTH + "','" + D_PID + "','" + D_CATEG_PATH + "');\">" + D_CATEG_NAME + "</a></li>";
				}
			}
			
			addElementStr += "</ul>";
			$("#"+sel_categ_pid).append(addElementStr);
			$('#tree_menu').find('li:last-child').addClass('end');
			tree_control(sel_categ_pid);
		}

	}
}

function setSelectItemInfo(categ_id, categ_name, categ_type, categ_sys_code, depth, pid, categ_path){
	$("#st_category_no").val(categ_id);
	$("#st_category_text").val(categ_name);
	$("#st_categ_type").val(categ_type);
	$("#st_categ_sys_code").val(categ_sys_code);
	$("#st_depth").val(depth);
	$("#st_pid").val(pid);
	$("#st_categ_path").val(categ_path);
}

function setReturn(){
	if(isEmpty($("#st_category_no").val())){
		alert("카테고리를 선택하세요.");
		return;
	}
	var st_category_no = $("#st_category_no").val();
	var st_category_text = $("#st_category_text").val();
	var st_categ_type = $("#st_categ_type").val();
	var st_categ_sys_code = $("#st_categ_sys_code").val();
	var st_depth = $("#st_depth").val();
	var st_pid = $("#st_pid").val();
	var st_categ_path = $("#st_categ_path").val();
	var nu_i = $("#nu_i").val();
	
	opener.setPopupReturn(st_category_no,st_category_text,st_categ_type,st_categ_sys_code,st_depth,st_pid,st_categ_path,nu_i);
	this.close();
}
</script> 
<body onload="">
<form name="commonCoCoCmscatalogChangePop" id="commonCoCoCmscatalogChangePop" method=post >
	<input type="hidden" name="nu_i" id="nu_i" value="<%=nu_i%>"/>
	<input type="hidden" name="st_category_no" id="st_category_no" />
	<input type="hidden" name="st_categ_type" id="st_categ_type" />
	<input type="hidden" name="st_categ_sys_code" id="st_categ_sys_code" />
	<input type="hidden" name="st_depth" id="st_depth" />
	<input type="hidden" name="st_pid" id="st_pid" />
	<input type="hidden" name="st_categ_path" id="st_categ_path" />
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div class="wrapPopup"  >
		<div class="PopupTit">카테고리 선택</div>
        <!--팝업내용입니다-->
		<div class="PopupCate-tree">
           	<!--grid-->
           	<p><%=root_category_name %></p>
            <ul id="tree_menu">
<%
if (_dataList == null || _dataList.size() == 0){
%>
				<li><span class="font1">조회된 데이타가 없습니다.</span></li>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> _tmp = _dataList.get(j);
		if("REG".equals(_tmp.get("CATEG_TYPE"))){
%>
				<li id="<%=_tmp.get("STD_CATEG_ID")%>">
					<a href="javascript:fn_control('<%=_tmp.get("STD_CATEG_ID") %>');" class="control"><img src="/resources/images/tree/tree_open.gif" /></a>
					<a href="javascript:fn_control('<%=_tmp.get("STD_CATEG_ID") %>');" class="folder_control"><img src="/resources/images/tree/folder_uc.gif" width="16"/></a>
					<a href="javascript:setSelectItemInfo('<%=_tmp.get("STD_CATEG_ID") %>','<%=_tmp.get("CATEG_NAME") %>','<%=_tmp.get("CATEG_TYPE") %>','<%=_tmp.get("CATEG_SYS_CODE") %>','<%=CommonUtil.bnvl(_tmp.get("DEPTH")) %>','<%=_tmp.get("PID") %>','<%=_tmp.get("CATEG_PATH") %>');" ><%=_tmp.get("CATEG_NAME")%></a>
				</li>
<%
		} else {
%>
				<li id="<%=_tmp.get("STD_CATEG_ID")%>"><img src="/resources/images/tree/folder_uc_item.gif" width="16"/><a href="javascript:setSelectItemInfo('<%=_tmp.get("STD_CATEG_ID") %>','<%=_tmp.get("CATEG_NAME") %>','<%=_tmp.get("CATEG_TYPE") %>','<%=_tmp.get("CATEG_SYS_CODE") %>','<%=CommonUtil.bnvl(_tmp.get("DEPTH")) %>','<%=_tmp.get("PID") %>','<%=_tmp.get("CATEG_PATH") %>');"><%=_tmp.get("CATEG_NAME")%></a></li>
<% 	}
	} 
}%>
			</ul>
		</div>
	    <div class="Popup_GrayBox mt10" >
			<div class="tit mr15">카테고리 </div>
			<input class="input42" style="width:220px" id="st_category_text" name="st_category_text" type="text" readonly />
			<button class="ButPrimary_Medium"  style=" width:80px; float:right" onclick="javascript:setReturn();">확인</button> 
	   	</div>        
	</div>
</form> 
</body>
</html>
