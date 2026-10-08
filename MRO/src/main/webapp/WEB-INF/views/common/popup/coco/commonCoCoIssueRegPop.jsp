<%--
**********************************************
* 메뉴 : 
* 화면 : 운영이슈 등록
* 기능 : 발주데이터별 운영이슈를 등록한다.
* 프로그램 ID : 납기관리
* 담당자 : 
* 착수일 : 20231107
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../../common/include/head.jspf"  %>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script> 
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<%
String buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");  //  (조회조건)
String po_no = CommonUtil.nvl((String) request.getParameter("st_po_no"),"");  //  (조회조건)
String po_seq = CommonUtil.nvl((String) request.getParameter("st_po_seq"),"");  //  (조회조건)
%>

<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤

function kep_onload_view(){
	var today = kepGetNowTimeStr("YYYYMMDD");
	document.getElementById('st_notice_date').value=today;
	
	// mySheet1 업무처리 내역 목록
	var initsheet = {};
	initsheet.Cols = [ 
		 { Align:"Center",	Width:90,	Edit:false,	Hidden:false,	Type:"Date",		Header:"이슈등록일",		SaveName:"ADD_DATE"}
		,{ Align:"Center",	Width:120,	Edit:false,	Hidden:false,	Type:"Text",		Header:"이슈상태",			SaveName:"TYPE_NAME"}
		,{ Align:"Center",	Width:60,	Edit:false,	Hidden:false,	Type:"Text",		Header:"진행상태",			SaveName:"STATUS_TEXT"}
		,{ Align:"Left",	Width:170,	Edit:false,	Hidden:false,	Type:"Text",		Header:"상세사유",			SaveName:"AGENT_REMARK"}
		,{ Align:"Left",	Width:180,	Edit:false,	Hidden:false,	Type:"Text",		Header:"협력사전달사항",	SaveName:"KEP_REMARK"}
		,{ Align:"Left",	Width:180,	Edit:false,	Hidden:false,	Type:"Text",		Header:"운영자처리내용",	SaveName:"ATOA_REMARK"}
		,{ Align:"Center",	Width:80,	Edit:false,	Hidden:false,	Type:"Text",		Header:"작성자",			SaveName:"ADD_USER"}
		,{ Align:"Center",	Width:60,	Edit:false,	Hidden:false,	Type:"Text",		Header:"처리자",			SaveName:"CONFIRM_USER"}
		,{ Align:"Center",	Width:90,	Edit:false,	Hidden:false,	Type:"Date",		Header:"운영자처리일",		SaveName:"CONFIRM_DATE"}
		,{ Align:"Center",	Width:90,	Edit:false,	Hidden:false,	Type:"Date",		Header:"재확인일자",		SaveName:"NOTICE_DATE"}
	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	
	kepSearchNoBar(document.commonCoCoPop,  mySheet , "/coco/getCommonCoCoIssueHistList.do" , pagingMode );
}

function mySheet_OnSearchEnd(code, msg) {
	loader_obj("N");

	if (msg != "") {
		alert(msg);
	}
}

function regRemark(){
	if($("#st_reg_remark").val().trim()== ""){
		alert("이슈 등록 사유를 입력해주시기 바랍니다.");
		return;
	}
	
	$("#st_remark").val($("#st_reg_remark").val());
	if($('input[id="st_po_multi"]').is(":checked")){
		document.getElementById('st_po_multiYN').value="Y";
	}else{
		document.getElementById('st_po_multiYN').value="N";
	}
	
	if(!confirm("운영이슈로 등록하시겠습니까?")){
		return;
	}
	
	kepAjaxFormCall("/coco/saveCommonCoCoIssueRegPop.do","commonCoCoPop","btnSave");
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	var msg = response.msg;
	
	if (isEmpty(msg)){
		alert("운영이슈로 등록되었습니다.");
		opener.doAction("search");
		window.close();
	}
	return;
}

//ajax 공통 호출후 실패시 처리 함수
function kepAjaxError(pMethod , response){
	var msg = response.Message;
	
	if (!isEmpty(msg)){
		alert(msg);
	}
	return;
}

</script> 
</head>
<body onload="kep_onload_view()">
<form name="commonCoCoPop" id="commonCoCoPop" method=post >
	<input type="hidden" id="s_SAVENAME" name="s_SAVENAME" value="">
	<input type="hidden" id="st_buyer" name="st_buyer" value="<%=buyer%>" />
	<input type="hidden" id="st_po_no" name="st_po_no" value="<%=po_no%>" />
	<input type="hidden" id="st_po_seq" name="st_po_seq" value="<%=po_seq%>" />
	<input type="hidden" id="st_user_id" name="st_user_id"	value="<%=_sessionInfo.getUserId()%>">
	<input type="hidden" id="st_notice_date" name="st_notice_date" value="">
	<input type="hidden" id="st_remark" name="st_remark" value="">
	<input type="hidden" id="st_po_multiYN" name="st_po_multiYN" value="N">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper">
		<div id="popHeader">
		   	<h1 class="title">운영 이슈</h1>
		    <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
		</div>
        <!--팝업내용입니다-->
        <div id="popContainer" >
			<div style="border-top:2px solid #3c639c; left:0;">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "200px");
  				</script>
			</div>
        </div>
        
        <br>
		
		<!--팝업내용입니다-->
		<div id="popContainer">
			<div id="ContArea" style="height:30px;margin-left:10px;">
   				<h3 style="width:100%;font-size:15px;">이슈 등록</h3>
   				<textarea rows="5" placeholder="최대 50자 작성" id="st_reg_remark" style="width:100%"></textarea>
   				<div class="btnArea mt05">
					<span class="fr">
						<label><input style="vertical-align: middle;" type="checkbox" id="st_po_multi" name="st_po_multi"> 동일발주 일괄 적용</label>
						&nbsp;&nbsp;&nbsp;
						<span class="btn_02 mr04"><a href="javascript:regRemark();">등록</a></span>
					</span> 
				</div>
			</div>
		</div>
	</div>
</form> 
</body>
</html>
