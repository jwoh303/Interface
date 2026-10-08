<%--
**********************************************
* 메뉴 : 마감관리 > 물류 수수료율 등록 > 예외기준 팝업
* 화면 : 물류 수수료율 등록 화면
* 기능 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ page import="java.text.SimpleDateFormat"%> 
<%@ page import="java.util.Date"%> 
<%@ page import="java.util.Locale"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
<script src="/resources/js/common.js"></script>
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>

<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("_data"); // 조회된 결과 
SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String st_user_id = "";
if (sessionInfo != null){
	st_user_id = sessionInfo.getUserId();
}
String st_agent = request.getParameter("st_agent");
String st_buyer = request.getParameter("st_buyer");
String st_exp_flag = request.getParameter("st_exp_flag");

%>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [					 
			 { Align:"Center",	Width:60,	Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",		Header:"상태",		SaveName:"sStatus"}			
			,{ Align:"Left",	Width:170,	Edit:false,	EditLen:170,	Hidden:true,	Type:"Text",		Header:"고객사코드",		SaveName:"BUYER"}
			,{ Align:"Left",	Width:170,	Edit:false,	EditLen:170,	Hidden:false,	Type:"Text",		Header:"고객사",		SaveName:"BUYER_NAME"}
			,{ Align:"Center",	Width:110,	Edit:false,	EditLen:170,	Hidden:false,	Type:"Text",		Header:"품목코드",		SaveName:"BUYER_ITEM_NO"}
			,{ Align:"Center",	Width:60,	Edit:false,	EditLen:170,	Hidden:false,	Type:"Text",		Header:"수수료율",		SaveName:"LOGISTICS_FEE"}
			,{ Align:"Center",	Width:70,	Edit:false,	EditLen:170,	Hidden:false,	Type:"Text",		Header:"기한",		SaveName:"END_DATE"}			
			,{ Align:"Center",	Width:70,	Edit:false,	EditLen:170,	Hidden:false,	Type:"Text",		Header:"사유",		SaveName:"REASON"}
			,{ Align:"Center",	Width:90,	Edit:false,	EditLen:170,	Hidden:false,	Type:"Text",		Header:"등록자",		SaveName:"ADD_USER_NAME"}
			,{ Align:"Center",	Width:80,	Edit:false,	EditLen:170,	Hidden:false,	Type:"Text",		Header:"등록일시",		SaveName:"ADD_DATE"}
			,{ Align:"Center",	Width:60,	Edit:false,	EditLen:170,	Hidden:false,	Type:"Text",		Header:"사유코드",		SaveName:"LOGIS_RATE_STATUS"}
			,{ Align:"Center",	Width:130,	Edit:false,	EditLen:170,	Hidden:false,	Type:"Text",		Header:"사유명",		SaveName:"LOGIS_RATE_STATUS_TEXT"}
			
					
					
	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly};
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	kepSearch(document.searchCondition, mySheet, "/cmcl/getMasterCmClLogisRateMngFeePop.do", pagingMode );
	
}

var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");
	

	switch (str) {
		case "search":	 // 조회
			current_page = -1;
			kepSearch(document.searchCondition, mySheet, "/cmcl/getMasterCmClLogisRateMngFeePop.do" , pagingMode );
			break;
	}
}


//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  ");
}


function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
}



</script>
</head>
<body onload="kep_onload_view()">
<form name = "searchCondition" method = "post" onsubmit="return false" >
<input type="hidden" name="s_SAVENAME">
<input type="hidden" id="st_agent" name="st_agent" value="<%=st_agent%>">
<input type="hidden" id="st_buyer" name="st_buyer" value="<%=st_buyer%>">
<input type="hidden" id="st_exp_flag" name="st_exp_flag" value="<%=st_exp_flag%>">
	<div id="popWrapper" style="height:250px;">
    	<div id="popHeader">
        	<h1 class="title">예외기준 조회 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer"> 
            <!--조회영역-->
            <div id="cont_searchA" class="mt10">
            	<table class="cont_t_list01" style="width:100%">
						<caption>예외기준 조회 </caption>
						<colgroup>
							<col width="10%" />
							<col width="30%" />
                            <col width="10%" />
                            <col width="30%" />
                            <col width="*" />
						</colgroup>
						<tbody>						
						<tr>
							<td>품목코드</td>						 
							<td> 
								<input type=text name="st_buyer_item_no" id="st_buyer_item_no" style="width:90%; value="" class="input_type_text" onKeyDown="kepEnter();"> 
							</td>
							<td>등록자</td>
							<td>
								<input type=text name="st_add_user_name" id="st_add_user_name" style="width:90%; value="" class="input_type_text" onKeyDown="kepEnter();">
							</td>
							<td><span class="btn_search fr"><a href="javascript:doAction('search');">조회</a></span></td>
						</tr>
						
					</tbody>
				</table>
            </div>
            <!--grid-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "300px");
				</script>
			</div>      
          
    </div>        
</div>   
</form>              
</body>
</html>
