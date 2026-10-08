<%--
**********************************************
* 메뉴 : 
* 화면 : 일진전기 관리 항목 추가
* 기능 : 일진전기 관리 항목 선택 팝업
* 담당자 : 현명환
* 착수일 : 2015-10-05
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/buyer_layout.css" type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
</head>
<%
 
SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");

String st_buyer			= CommonUtil.nvl((String) request.getParameter("st_buyer"), _sessionInfo.getComCode()); 
String st_group			= CommonUtil.nvl((String) request.getParameter("st_group"),"");
String st_center		= CommonUtil.nvl((String) request.getParameter("st_center"),"");
String st_acount		= CommonUtil.nvl((String) request.getParameter("st_acount"),"");
String st_acount_nm		= CommonUtil.nvl((String) request.getParameter("st_acount_nm"),"");
String st_project		= CommonUtil.nvl((String) request.getParameter("st_project"),"");
String st_project_nm	= CommonUtil.nvl((String) request.getParameter("st_project_nm"),"");
String st_task			= CommonUtil.nvl((String) request.getParameter("st_task"),"");
String st_item_no		= CommonUtil.nvl((String) request.getParameter("st_item_no"),"");
String st_requester		= CommonUtil.nvl((String) request.getParameter("st_requester"),"");
String st_requester_nm	= CommonUtil.nvl((String) request.getParameter("st_requester_nm"),"");
String st_emp_no		= CommonUtil.nvl(_sessionInfo.getEmpNo(),"");
String st_emp_nm		= CommonUtil.nvl(_sessionInfo.getUserNameLoc(),"");
String st_dept_nm		= CommonUtil.nvl(_sessionInfo.getDepartmentName(),"");

if ( "".equals(st_requester) ) {
	st_requester	= st_emp_no;
	st_requester_nm	= st_emp_nm + " / "+st_dept_nm;
}

Map<String, String> item_info = (Map<String, String>)request.getAttribute("item_info"); // 특수로직 조회된 결과

String st_inventory_flag = "N";
String st_org_cnt	= "0";

if ( item_info != null ) {
	st_inventory_flag	= item_info.get("INVENTORY_FLAG");
	st_org_cnt			= String.valueOf(item_info.get("ORG_CNT"));
}

String st_delivery_text = "";

//조직&조직명&창고&비용유형코드&비용유형명&프로젝트코드&프로젝트명&태스크
%>

<script type="text/javascript">

function kep_onload(){  
	var st_buyer = "<%=st_buyer%>";
	var st_item_no	= "<%=st_item_no%>";
	//조직
	var st_type   = "C020"; //조직
	var st_type_1 = "C021"; //납품처
	var st_type_2 = "C022"; //창고
	var st_type_3 = "C026"; // Task
	var st_type_4 = "C023";	// Account
	var st_type_5 = "C025"; // Task
	var st_group ="<%=st_group%>";
	var st_center ="<%=st_center%>";
	var st_acount ="<%=st_acount%>";
	var st_project ="<%=st_project%>";
	var st_task = "<%=st_task%>";
	var st_emp_no = "<%=st_emp_no%>";
	
	var st_org_cnt	= "<%=st_org_cnt%>";
	var st_inventory_flag	= "<%=st_inventory_flag%>";
	
	if ( st_org_cnt == "0" ) {
		kepAjaxCommonQueryIdSearchThreeCombo('st_group','iljin_org_list',st_buyer,st_type,st_item_no,'SEL',st_group);
	} else {
		kepAjaxCommonQueryIdSearchThreeCombo('st_group','comCodeIljinPopSearchOrg',st_buyer,st_type,st_item_no,'SEL',st_group);	
	}
	
	kepAjaxCommonQueryIdSearchThreeCombo('st_acount','comCodeIljinPopSearchAct',st_buyer,st_type_4,st_emp_no,'SEL',st_acount);	
	
	if(st_group != ""){
		kepAjaxCommonQueryIdSearchThreeCombo('st_center','comCodeIljinPopSearch2',st_buyer,st_type_2,st_group,'ALL',st_center);
	}
	if(st_project != ""){
		kepAjaxCommonQueryIdSearchThreeCombo('st_task','comCodeIljinPopSearch2',st_buyer,st_type_3,st_project,'ALL',st_task);
	}
	if(st_acount != "") {
		var acount_type	= "";
		var st_acount_nm = document.forms.buyerMpsoILJINChoPop.st_acount.options[document.forms.buyerMpsoILJINChoPop.st_acount.selectedIndex].text;
	}
}


function kepSearch()
{  
	$('#buyerMpsoILJINChoPop').attr("action", "/mpso/getBuyerMpSoILJINchoPop.do").submit();
}

//장바구니 화면에 반영
function setRefList(){
	 
}

function changeMgnote(value, gbn){
	if (value == "st_acount") {
		var st_center = document.forms.buyerMpsoILJINChoPop.st_center.value;
		if (st_center != "" || st_center == null) {
			alert("비용유형을 입력할 경우 경우 창고를 입력할 수 없습니다.");
			document.forms.buyerMpsoILJINChoPop.st_center.value	= "";
		}
	} 
	else if (value == "st_group") {
		if( "<%=st_inventory_flag%>" == "Y" ) {
			var st_group = document.forms.buyerMpsoILJINChoPop.st_group.value;
			
			if (st_group == "141") {
				alert("마스터 플랜트의 경우 비용성 품목만 선택가능합니다.");
				document.forms.buyerMpsoILJINChoPop.st_group.value = "";
			}
		}
	}
	kepSearch();
}

function checkCenter() {
	var acount	= document.forms.buyerMpsoILJINChoPop.st_acount.value;
	if ( acount != "" ) {
		alert("창고를 선택할 경우 비용유형을 입력할 수 없습니다.");
		document.forms.buyerMpsoILJINChoPop.st_acount.value = "";
	}
}

function submit(){
	var st_group = document.forms.buyerMpsoILJINChoPop.st_group.value;
	var st_group_nm = document.forms.buyerMpsoILJINChoPop.st_group.options[document.forms.buyerMpsoILJINChoPop.st_group.selectedIndex].text;
	var st_center = document.forms.buyerMpsoILJINChoPop.st_center.value;
	var st_acount_nm = "";
	var st_acount = "";
	
	if (document.forms.buyerMpsoILJINChoPop.st_acount.selectedIndex > -1 ) {
		st_acount_nm = document.forms.buyerMpsoILJINChoPop.st_acount.options[document.forms.buyerMpsoILJINChoPop.st_acount.selectedIndex].text;
		st_acount = document.forms.buyerMpsoILJINChoPop.st_acount.value;
	}
	var st_acount_type = document.forms.buyerMpsoILJINChoPop.st_acount_type.value;
	var st_project = document.forms.buyerMpsoILJINChoPop.st_project.value;
	var st_project_nm = document.forms.buyerMpsoILJINChoPop.st_project_nm.value;
	var st_task = document.forms.buyerMpsoILJINChoPop.st_task.value;
	
	if(st_group == "SEL"|| st_group == ""|| st_group==null){
		alert("조직을 선택 하세요.");
		document.forms.buyerMpsoILJINChoPop.st_group.focus();
		return;
	}
	if( "<%=st_inventory_flag%>" == "Y" && (st_center == "" || st_center == null)  && (st_acount == ""  || st_acount == null ) ) {
		alert("비용유형 혹은 창고를 선택하세요.");
		document.forms.buyerMpsoILJINChoPop.st_center.focus();
		return;
	}
	if( "<%=st_inventory_flag%>" == "N" && (st_acount == ""|| st_acount==null)){
		document.forms.buyerMpsoILJINChoPop.st_acount.focus();
		alert("비용유형을 선택 하세요.");
		return;
	}
	if(st_project != "") {
		if (st_task == "" || st_task == null) {
			document.forms.buyerMpsoILJINChoPop.st_task.focus();
			alert("프로젝트 입력시 태스크를 선택하세요.");
			return;	
		}
	}
	
	// 요청자 정보 추가
	var st_requester	= document.forms.buyerMpsoILJINChoPop.st_requester.value;
	var st_requester_nm	= document.forms.buyerMpsoILJINChoPop.st_requester_nm.value;
	
	if ( st_requester == "" || st_requester == null || st_requester == undefined || st_requester == "undefined" ) {
		document.forms.buyerMpsoILJINChoPop.st_requester_nm.focus();
		alert("요청자를 선택하세요.");
		return;	
	}
	
	//조직&조직명&창고&비용유형코드&비용유형명&프로젝트코드&프로젝트명&태스크&요청자ID&요청자정보
	var mg_note =st_group+"^"+st_group_nm+"^"+st_center+"^"+st_acount+"^"+st_acount_nm+"^"+st_project+"^"+st_project_nm+"^"+st_task+"^"+st_requester+"^"+st_requester_nm;
	opener.setMgnoteReturn(st_group_nm,mg_note);
	this.close();
	
}
function filterChar(value){
	if(value == "" ||value == null){
		value = "^";
	} 
	return value;
}

// 프로젝트 검색 팝업
function getIljinProjectPop(){
	var st_buyer = "<%=st_buyer%>";
	var st_gbn = "프로젝트";
	var st_type = "C025";
	var st_code = "";
	var st_text = "";
	var st_text4 = document.forms.buyerMpsoILJINChoPop.st_group.value;
	
	if(document.forms.buyerMpsoILJINChoPop.st_group.value == ""){
		alert("조직을 선택 하세요.");
		return;
	}else if(document.forms.buyerMpsoILJINChoPop.st_acount.value == ""){
		if(document.forms.buyerMpsoILJINChoPop.st_center.value == ""){
			alert("비용유형을 선택 하세요.");
			return;			
		}
	}
	openSearchPopup("/mpso/getIljinProjectPop.do","?st_buyer="+st_buyer+"&st_gbn="+st_gbn+"&st_type="+st_type+"&st_code="+st_code+"&st_text="+st_text+"&st_text4="+st_text4, "600,500,no");
}

//요청자 검색 팝업
function getIljinRequesterPop(){
	var st_buyer = "<%=st_buyer%>";
	var st_gbn = "요청자";
	var st_type = "C029";
	var st_code = document.forms.buyerMpsoILJINChoPop.st_requester.value;
	var st_text = "";
    openSearchPopup("/common/getCode2PopSearchPop.do","?st_buyer="+st_buyer+"&st_gbn="+st_gbn+"&st_type="+st_type+"&st_code="+st_code+"&st_text="+st_text, "600,450,no");	
}

function setPopupReturn(type,value1,value2,value3,value4){
	if(type == "C025"){
		document.forms.buyerMpsoILJINChoPop.st_project.value = value1;
		document.forms.buyerMpsoILJINChoPop.st_project_nm.value = value2;
		changeMgnote('st_project');
	} else if (type == "C029") {
		document.forms.buyerMpsoILJINChoPop.st_requester.value = value1;
		document.forms.buyerMpsoILJINChoPop.st_requester_nm.value = value2;
	}
}

</script> 
<body onload="kep_onload()">
<form name="buyerMpsoILJINChoPop" id="buyerMpsoILJINChoPop" method=post >

	<input type="hidden" id="st_item_no" name="st_item_no" value="<%=st_item_no%>">
	<input type="hidden" id="st_acount_type" name="st_acount_type" value="">
	<input type="hidden" id="st_inventory_flag" name="st_inventory_flag" value="<%=st_inventory_flag%>">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:494px;">
    	<div id="popHeader">
        	<h1 class="title">MRO 구매품목 관리항목 등록 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
 
 
 
 <table  class="board_write"  style="width:100%">
      <colgroup>
      <col width="15%" />
      <col width="35%" />
      <col width="15%" />
      <col width="35%" />
      </colgroup>
      <tr>
        <th scope="row">* 조직</th>
        <td>
			<select id="st_group" name="st_group"  style="width:90%" onchange="javascript:changeMgnote('st_group');"></select>
		</td>
        <th scope="row"> 창고</th>
        <td>
			<select id="st_center" name="st_center"  style="width:90%;<%if("N".equals(st_inventory_flag)) out.print("display: none;");%>" onchange="javascript:checkCenter();"></select>
		</td>
      </tr>
      <tr>
        <th scope="row"><% if ("N".equals(st_inventory_flag)) out.print("*"); %> 비용유형</th>
        <td colspan="3" >
			<select id="st_acount" name="st_acount"  style="width:97%;" onchange="javascript:changeMgnote('st_acount');"></select>
		</td>
      </tr>
      <tr>
        <th scope="row">프로젝트</th>
        <td>
			<input type="hidden" name="st_project" id="st_project" value="<%=st_project%>">
			<input type="text" name="st_project_nm" id="st_project_nm" value="<%=st_project_nm%>" style="width:70%;">
			<a href="javascript:getIljinProjectPop();"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
			<a href="javascript:kepEraser('st_project','st_project_nm');javascript:changeMgnote('st_project');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
		</td>
        <th scope="row">태스크</th>
        <td>
			<select id="st_task" name="st_task"  style="width:90%"></select>
		</td>
      </tr>
      <tr>
        <th scope="row">* 요청자</th>
        <td>
			<input type="hidden" name="st_requester" id="st_requester" value="<%=st_requester%>">
			<input type="text" name="st_requester_nm" id="st_requester_nm" value="<%=st_requester_nm%>" style="width:70%;">
			<a href="javascript:getIljinRequesterPop();"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
			<a href="javascript:kepEraser('st_requester','st_requester_nm');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
		</td>
        <th scope="row">&nbsp;</th>
        <td>&nbsp;</td>
      </tr>
	</table>
    <div class="btnArea">
		<div class="fr">
			<span class="btn_03 mr04"><a href="javascript:submit();">확인</a>
			</span>
		</div>
	</div>
</div>
</form> 
</body>
</html>
