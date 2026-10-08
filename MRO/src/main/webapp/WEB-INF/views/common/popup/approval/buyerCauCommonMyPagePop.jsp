<%--
**********************************************
* 메뉴 :  결재
* 화면 : 결재문서 상세
* 기능 : 결재문서 상세
* 프로그램 ID : 
* 담당자 : CEJ  
* 착수일 : 2014-XX-XX
**********************************************
--%> 
<%@page import="uk.org.lidalia.sysoutslf4j.context.SysOutOverSLF4J"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!doctype html>
<html>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
Map<String, Object> ht = (Map<String, Object>) request.getAttribute("data"); // 조회된결과   
String COMPANY = CommonUtil.nvl((String) request.getParameter("COMPANY"),"");  //  (조회조건)
String DOCU_NO = CommonUtil.nvl((String) request.getParameter("DOCU_NO"),"");  //  (조회조건)
String FLAG = CommonUtil.nvl((String) request.getParameter("FLAG"),"");  //  (조회조건)
String biz_url = CommonUtil.nvl((String)ht.get("biz_url"),"");  // 공통테이블이서 가지고온 각업무별 url
String action_base = CommonUtil.nvl((String)ht.get("action_base"),"");  // 공통테이블이서 가지고온 각업무별 action url
String biz_jsp = CommonUtil.nvl((String)ht.get("biz_jsp"),""); // 공통테이블이서 가지고온 각업무별 jsp 파일명
String pass_status = CommonUtil.nvl((String)ht.get("pass_status"),"");  // 상태
String approval_user_id = CommonUtil.nvl((String)ht.get("approval_user_id"),"");  // 현재 결재할 사용자
String DOCU_TITLE = CommonUtil.nvl((String)ht.get("subject"),"");  // 제목

String key_1 = CommonUtil.nvl((String)ht.get("key_1"),"");  // key_1 -- PrNo
String key_2 = CommonUtil.nvl((String)ht.get("key_2"),"");  // key_2
String key_3 = CommonUtil.nvl((String)ht.get("key_3"),"");  // key_3
String extif_tp = CommonUtil.nvl((String)ht.get("extif_tp"),"");  // extif_tp

String PASS_TP = CommonUtil.nvl((String) request.getParameter("PASS_TP"),"");  //  (조회조건)
String RECV_FLAG = CommonUtil.nvl((String) request.getParameter("RECV_FLAG"),"");  //  (조회조건)
String dt_displaly =CommonUtil.nvl((String) request.getParameter("DT_DISPLAY"),"");  

String content = CommonUtil.nvl((String)ht.get("content"),""); // 내용
String pr_content = CommonUtil.nvl((String)ht.get("pr_content"),""); // 내용
content = content.replaceAll("&lt;br&gt;", "\n");
pr_content = pr_content.replaceAll("&lt;br&gt;", "\n");
Integer passUserSize = 35 * (Integer)ht.get("passUserSize"); // 결재자 수 비례하여 결재자 목록 높이 조절


//KRKORE0001 운영사 결재선 체크
String userDepartment = "";
String buyer = ""; 
String userid = ""; 
if (_sessionInfo != null){  
	userid =  CommonUtil.nvl((String)_sessionInfo.getUserId()); 
	buyer =  CommonUtil.nvl((String)_sessionInfo.getComCode());
	userDepartment    = CommonUtil.nvl((String)_sessionInfo.getDepartment());
} 
String apprId = CommonUtil.getCode3RoleReturn("APPR", userDepartment, COMPANY, "CODE2");

String reportText= "품의서출력"; // default 버튼명 
String reportid = "RD_06_S_003_03";  //default

boolean editYn = false;
%>

<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/buyer_layout.css" type="text/css" />
<link rel="stylesheet" type="text/css" media="screen"	href="/resources/libs/jquery/css/smoothness/jquery-ui.min.css"/>   
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.cookie.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
<script src="/resources/js/common.js"></script>

<script type="text/javascript"> 
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var mt;
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";
var g_buyer = "";
var g_pr_no = "";
var g_pr_seq = "";

function  attach_popup(img_key){	
	
	var type = "<%=extif_tp%>";
	var viewType = "R";
	 
	kepFileUploadOpenPopup(img_key,type,viewType); 
}

function captureReturnKey(e) {   
    if(e.keyCode==13 && e.srcElement.type != 'textarea')   
    return false;   
}   

</script> 
<body onload="kep_onload_view()">
<form name=buyerCommonMyPagePop id=buyerCommonMyPagePop method=post onkeydown="return captureReturnKey(event)">  
 
<input type=hidden name="PASS_KN" id="PASS_KN">
<input type=hidden name="PASS_TP" id="PASS_TP" value="<%=PASS_TP%>">
<input type=hidden name="COMPANY" value="<%=COMPANY%>">
<input type=hidden name="DOCU_NO" value="<%=DOCU_NO%>">
<input type=hidden name="CUR_ORDER_NO"  value=""> 
<input type=hidden name="to" id="to" value="<%=(String)ht.get("to")%>">
<input type=hidden name="cc" id="cc"  value="<%=(String)ht.get("cc")%>">
<input type=hidden name="ag" id="ag"  value="<%=(String)ht.get("ag")%>">
<input type=hidden name="att_fn" value="<%=(Integer)ht.get("attach_cnt")%>">
<input type=hidden name="url" value="<%=request.getRequestURI()%>"> 
<input type=hidden name="DOC_TYPE" value="<%=(String)ht.get("extif_tp")%>">  <!--  상신일경우에는 수정 필요 -->
<input type=hidden name="EXTIF_TP" value="<%=(String)ht.get("extif_tp")%>">  <!--  상신일경우에는 수정 필요 -->
<input type=hidden name="DOCU_KN" value="1">  <!--  상신일경우에는 수정 필요 문서종류(1:결재문서) -->
<input type=hidden name="DOCU_TITLE" id="DOCU_TITLE" value="<%=CommonUtil.nvl((String)ht.get("subject")).replace("\"", "&quot;")%>">  <!--  상신일경우에는 수정 필요 --> 
<input type=hidden name="KEY_1" value="<%=key_1%>">  <!--  key_1 업무에서 만들어진 키  -->
<input type=hidden name="KEY_2" value="<%=key_2%>">  <!--  key_2 업무에서 만들어진 키  -->
<input type=hidden name="KEY_3" value="<%=key_3%>">  <!--  key_3 업무에서 만들어진 키  -->
<input type=hidden name="toContent" id="toContent"  value=""> 
<input type="hidden" name="FLAG" id="FLAG"  value="<%=FLAG%>">
<input type="hidden" name="DT_DISPLAY" id="DT_DISPLAY"  value="<%=dt_displaly%>"> 
<input type="hidden" name="st_buyer" id="st_buyer"  value=""/>
<input type="hidden" name="st_pr_no" id="st_pr_no"  value=""/> 
<input type="hidden" name="st_pr_seq" id="st_pr_seq"  value=""/>
<input type="hidden" name="st_prrecv_flag" id="st_prrecv_flag"  value=""/>
<input type="hidden" name="st_return_reason" id="st_return_reason"  value=""/>  
<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">

<input type="hidden" name="s_SAVENAME">
<input type="hidden" id="pageflag" name="pageflag" value="1">
<input type="hidden" id="onepagerow" name="onepagerow" value="100">

	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper"  style="height:100%">
    	<div id="popHeader" >
        	<h1 class="title">결재문서 상세</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
      	</div>
      	<div class="scrollArea" style="height:700px">
	<!--팝업내용입니다-->
	<div id="popContainer">
	<h4 class="b">[ 결재/참조자 정보 ]</h4>	
	<%
		if(!dt_displaly.equals("Y")){
	%>
	<table  class="board_write" summary="결재/참조자 대한 정보입력">
		<caption>결재/참조자</caption>
			<colgroup>
				<col width="17%" /> 
				<col width="*" />
			</colgroup>
		<tbody> 
    	  <tr>
			<th scope="row">결재/참조자</th>
			<td scope="row" >
			<div id="kto" style="height:<%=passUserSize%>px"><%=(String)ht.get("toHtmlContent")%></div>
             </td>
		  </tr> 
    	</tbody>
    </table>      
	<table  class="board_write" summary="결재/참조자 대한 정보입력">
		<caption>결재/참조자</caption>
			<colgroup>
				<col width="17%" />
				<col width="35%" />
				<col width="17%" />
				<col width="*" />
			</colgroup>
		<tbody>
<%if("PX".equals((String)ht.get("extif_tp"))){%>
		<tr>
			<th scope="row">구매요청 제목</th>
			<td scope="row"  colspan="3">&nbsp;
				<%=(String)ht.get("pr_subject")%>
			</td>
		  </tr> 
    	  <tr>
			<th scope="row">요청자</th>
			<td scope="row" >&nbsp;<%=(String)ht.get("user_nm")%>(<%=(String)ht.get("user_id")%>)
				&nbsp;&nbsp;
				<% if ("".equals(CommonUtil.nvl((String)ht.get("pr_image_key")))) { %>
					<img src="/resources/images/ico_file.gif" name="MasterImage" width="14" height="14" border="0"> 
				<%}else{ %>
					<a href="javascript:attach_popup('<%=CommonUtil.nvl((String)ht.get("pr_image_key"))%>');"> <img src="/resources/images/disk_on.gif" name="MasterImage" width="14" height="14" border="0"> </a>
				<%} %>
			</td>
			<th scope="row">요청일시</th>
			<td scope="row" >&nbsp;<%=(String)ht.get("pr_start_date")%></td>			
		  </tr> 		  
    	  <tr>
			<th scope="row">내용</th>
			<td scope="row"  colspan="3">
				<pre><%=pr_content%></pre>
			</td>	
		  </tr> 
     	  <% if ("RECV".equals(FLAG) && "0".equals(pass_status)  && userid.equals(approval_user_id)){ %> 
				<input type="hidden" maxlength="200" style="width:95%"  class="input_type_text" name="PASS_ADD"  id="PASS_ADD" value="">
			<% } else {%>
				<input type="hidden" maxlength="200" style="width:95%"  class="input_type_text" name="PASS_ADD"  id="PASS_ADD" value="" readonly>
			<%} %>
<%}else{%>
    	  <tr>
			<th scope="row">구매요청 제목</th>
			<td scope="row"  colspan="3">&nbsp;
				<%=(String)ht.get("subject")%>
			</td>
		  </tr> 
    	  <tr>
			<th scope="row">요청자</th>
			<td scope="row" >&nbsp;<%=(String)ht.get("user_nm")%>(<%=(String)ht.get("user_id")%>)
				&nbsp;&nbsp;
				<% if ("".equals(CommonUtil.nvl((String)ht.get("image_key")))) { %>
					<img src="/resources/images/ico_file.gif" name="MasterImage" width="14" height="14" border="0"> 
				<%}else{ %>
					<a href="javascript:attach_popup('<%=CommonUtil.nvl((String)ht.get("image_key"))%>');"> <img src="/resources/images/disk_on.gif" name="MasterImage" width="14" height="14" border="0"> </a>
				<%} %>
			</td>
			<th scope="row">요청일시</th>
			<td scope="row" >&nbsp;<%=(String)ht.get("start_date")%></td>			
		  </tr> 		  
    	  <tr>
			<th scope="row">내용</th>
			<td scope="row"  colspan="3">
				<pre><%=content%></pre>
			</td>	
		  </tr> 
     	  <% if ("RECV".equals(FLAG) && "0".equals(pass_status)  && userid.equals(approval_user_id)){ %> 
				<input type="hidden" maxlength="200" style="width:95%"  class="input_type_text" name="PASS_ADD"  id="PASS_ADD" value="">
			<% } else {%>
				<input type="hidden" maxlength="200" style="width:95%"  class="input_type_text" name="PASS_ADD"  id="PASS_ADD" value="" readonly>
			<%} %>
<%}%>
    	</tbody>
    </table> 
	<%
		}
	%>
    <!--버튼영역-->   
 <div class="btnArea" align="right">  
 
 <% if (!"2".equals(PASS_TP)) { %>
 
 
 <% if ("RECV".equals(FLAG) && "0".equals(pass_status)  && userid.equals(approval_user_id)){ %>
    	<span class="btn_04 mr04"  title="일괄결재"><a href="javascript:approvalProcess('approval')">일괄결재</a></span> 
  		<span class="btn_04 mr04"  title="일괄반려"><a href="javascript:saveReject();">일괄반려</a></span>
  		<span class="btn_04 mr04"  title="부분반려"><a href="javascript:savePartReject();">부분반려</a></span>     	 
<%} %>  		
<%} %>  		  			
	
					<% if (!"NONE".equals(reportText)) {  
				%>
		  		<span class="btn_04 mr04"  title="<%=reportText%>"><a href="javascript:DraftSentenceView();"><%=reportText%></a></span>  
		  		<%} %>		   
    	
</div>     
    <!--grid-->
		<div class="ib_product" style="border-top:2px solid #3c639c">
			<script type="text/javascript">
				createIBSheet("mySheet", "100%", "280px");
			</script>
		</div>
    </div>
    
    
    
    
<%
/*

NG	견적의뢰
NS	소상합의
PA	단가승인
PR	구매요청
PX	구매발주

SELECT              
   A.*
   , TO_CHAR(SYSDATE,'YYYY/MM/DD HH:MM')   as CURDATE
FROM ICOMCOD1     A
WHERE 1=1   
	AND A.TYPE = 'APPR'
	
	TEXT2 =  biz_url
	TEXT3=  biz_jsp
TEXT4 =  action_base
	*/
%>




</div> 
</div>       
</form>  
</body>
<script type="text/javascript">

function kep_onload_view(){
	var initsheet = {};
	initsheet.Cfg = {FrozenCol:0};
	initsheet.Cols = [
		 { Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"고객사",		SaveName:"BUYER"}
		,{ Align:"Center",	Width:40,	Edit : true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED",ColMerge:0,Sort:1}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"요청번호",		SaveName:"PR_NO"}
		,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"순번",		SaveName:"PR_SEQ"}
		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목코드",		SaveName:"BUYER_ITEM_NO"}
		,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품명",		SaveName:"DESCRIPTION"}
		,{ Align:"Left",	Width:350,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"규격",		SaveName:"SPECIFICATION"}
		,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"단위",		SaveName:"UNIT_MEASURE"}
		,{ Align:"Right",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Int",		Header:"수량",		SaveName:"TARGET_QTY"}
		,{ Align:"Right",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Int",		Header:"단가",		SaveName:"TARGET_PRICE"}
		,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"AutoSum",	Header:"금액",		SaveName:"AMT"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"납기요청일",	SaveName:"RD_DATE"}
		,{ Align:"Left",	Width:600,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"예산부서",		SaveName:"BUDGET_DEPT_TEXT"}
		,{ Align:"Left",	Width:1200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"계정정보",		SaveName:"ACCOUNT_TYPE_TEXT"}
		,{ Align:"Left",	Width:1100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"도착지",		SaveName:"DELY_TO_LOCATION_TEXT"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"첨부파일",		SaveName:"IMAGE_KEY"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"첨부파일",		SaveName:"IMAGE_KEY_YN"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"부분반려",		SaveName:"REJECT"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"BYIT_COMORG_CODE",		SaveName:"BYIT_COMORG_CODE"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"CONTRACT_NO",		SaveName:"CONTRACT_NO"}
		,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"CONTRACT_SEQ",		SaveName:"CONTRACT_SEQ"}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	setLinkCol(mySheet, "IMAGE_KEY_YN");
	setLinkCol(mySheet, "REJECT");
	setLinkCol(mySheet, "BUYER_ITEM_NO");
	
	//파일첨부이미지설정
	mySheet.SetImageList(2, diskOff);
	mySheet.SetImageList(3, diskOn);
	
	current_page = -1;
	kepSearch(document.buyerCommonMyPagePop,  mySheet , "/common/approval/getBuyerCauCommonMyPagePopPrList.do" , pagingMode );
}

/**
 * FORM 을 넘기는 임시용
 * FORM 전체를 넘길는 submit 활용
 */
function approvalProcess(pMethod) {  	 

	var url = "";
	
	if (pMethod == "approval"){
		$("#PASS_KN").val("1"); // 결재
		if (confirm("결재 진행하시겠습니까?")==false) return;
		url = "<%=action_base%>Approval.do";
		kepAjaxFormCall(url,"buyerCommonMyPagePop",pMethod);
	}else if (pMethod == "reject"){
		$("#PASS_KN").val("3"); 
		url =  "<%=action_base%>Approval.do";
		kepAjaxFormCall(url,"buyerCommonMyPagePop",pMethod);
	}else if (pMethod == "seqReject"){
		//반려처리
		kepSave(document.buyerCommonMyPagePop ,  mySheet , "/common/popup/approval/rejectPrListMultiPop.do" , "SELECTED" );
	}
}

function DraftSentenceView(){
    var f = document.forms.buyerCommonMyPagePop;
    var docu_no = f.DOCU_NO.value;
    var company = f.COMPANY.value;
    var str = "<%=(String)ht.get("string_no")%>";
    var pr_no = "<%=key_1%>";
    var doc_title = "<%=CommonUtil.formatHTMLCode((String)ht.get("subject"))%>";
    var user_name = "<%=(String)ht.get("user_nm")%>";
    var buyer = "<%=COMPANY%>";
 
    reportOpen("<%=reportid%>","["+pr_no+"]["+buyer+"]["+docu_no+"]["+company+"]["+doc_title+"]["+user_name+"]");
}

function setPopupApprovalReturn(tmptmp1,tmptmp2,tmptmp3,tmptmp4,tmptmp5) {
	//alert(tmptmp1);
	//alert(tmptmp2);
	//alert(tmptmp3);
	$("#to").val(tmptmp1); // 결재
	$("#cc").val(tmptmp2); // 참조
	$("#ag").val(tmptmp5); // 합의
	$("#kto").html(tmptmp3); // 내용
	
	$("#toContent").val(tmptmp4); // 내용
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */
function kepAjaxSuccess(pMethod , response){
	
	var closeflag = true;
	if (pMethod == "approval"){
		alert("결재가 성공적으로 이루어 졌습니다. ");		
	}else if (pMethod == "reject"){
		alert("반려가 성공적으로 이루어 졌습니다. ");
	} else if (pMethod == "SAVE"){
		alert("반려가 성공적으로 이루어 졌습니다. ");	
		openSearchPopup("/common/approval/getBuyerCauCommonMyPagePop.do","?COMPANY=<%= buyer%>&DOCU_NO=<%=DOCU_NO%>&PASS_TP=<%=PASS_TP %>&FLAG=<%=FLAG %>" ,"1200,700,no");
		closeflag = false;
	}
	if (closeflag == true){ 
		opener.kepSearch("");
		self.close();
	}
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {

	if (pMethod == "approval"){
		alert("결재가 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
		opener.kepSearch("");
		self.close();
	}else if (pMethod == "return"){
		alert("반려가 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
	} 
}

//반려 사유
function saveReject(){
	var viewType="rejectPr";
	var cancel_remark = "";
	popupSel = "saveReject";
	openSearchPopup("/common/remarkCancelPop.do",'?cancel_remark='+cancel_remark+'&viewType='+viewType,"500,230,no");
}
//부분반려
function savePartReject(){
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow = selectedGrid.split("|");
	var st_gbn = "N";
	var st_cnt = 0;
	//조회건수가 한건일 때 처리 불가능.
	for (var i=0; i<arrRow.length; i++){
		st_cnt++;
		if(mySheet.GetCellValue(arrRow[i],"REJECT") == "부분반려"){
			st_gbn = "Y";
		} 
	}
	if(st_gbn == "N"){
		alert("반려 처리 대상 1건은 일괄반려로 처리 바랍니다.");
		return;
	}
	if(mySheet.RowCount() == st_cnt){
		alert("전체 반려 처리시 일괄반려 버튼 이용하여 처리 바랍니다.");
		return;		
	}
	//전체 선택 할 경우 처리 불가능.
	var viewType="rejectPr";
	var cancel_remark = "";
	popupSel = "seqReject";
	openSearchPopup("/common/remarkCancelPop.do",'?cancel_remark='+cancel_remark+'&viewType='+viewType,"500,230,no");	
}
//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text){
	 if (popupSel == "saveReject") {
		g_confirm_type = popupSel;
		document.forms.buyerCommonMyPagePop.PASS_ADD.value = code;
		$("#confirmMsgDiv").text("반려 진행하시겠습니까?"); //Confirm 문구 입력
		$("#confirmAreaDiv").show(); //Confirm 창 확인.
		return;
	}else if (popupSel == "seqReject") {
		g_confirm_type = popupSel;
		document.forms.buyerCommonMyPagePop.st_return_reason.value = code;
		document.forms.buyerCommonMyPagePop.st_prrecv_flag.value = "PR";
		$("#confirmMsgDiv").text("부분 반려 진행하시겠습니까?"); //Confirm 문구 입력
		$("#confirmAreaDiv").show(); //Confirm 창 확인.

	}
}
//Confirm창 확인처리
function confirmAreaDivSearch(){
	if(g_confirm_type == "saveReject"){//반려
		$("#confirmAreaDiv").hide();
		var passAddLen	= kepGetByteLength('PASS_ADD');
		if ( passAddLen > 200 ){
			alert("결재자의견은 "+passAddLen+"바이트 입니다.\n결재자의견은 200바이트 이상 입력할 수 없습니다.");
			return ;
		}
		approvalProcess('reject');	
	}else if(g_confirm_type == "seqReject"){//부분반려
		$("#confirmAreaDiv").hide();
		var passAddLen	= kepGetByteLength('PASS_ADD');
		if ( passAddLen > 200 ){
			alert("결재자의견은 "+passAddLen+"바이트 입니다.\n결재자의견은 200바이트 이상 입력할 수 없습니다.");
			return ;
		}
		approvalProcess('seqReject');		
	}
}

//그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}
	
// 조회 후처리
function mySheet_OnSearchEnd(code, msg) {
	loader_obj("N");
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH){
	if ( Row  < 1) return;
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	var column = mySheet.ColSaveName(Col);
	var reject_value = mySheet.GetCellValue(Row, "REJECT");
	
	if(column == "IMAGE_KEY_YN"){ // 파일첨부
		popupSel = "fileUpload";
		var type="PO";
		var viewType="R"; // 보기전용
		var image_key=mySheet.GetCellValue(Row, "IMAGE_KEY");
		if (image_key != "") {
			openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&type='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
		}
	}
	if(column == "REJECT" && reject_value == "부분반려"){
		var viewType="rejectPr";
		var cancel_remark = "";
		popupSel = "seqReject";
		g_buyer = mySheet.GetCellValue(Row, "BUYER");
		g_pr_no = mySheet.GetCellValue(Row, "PR_NO");
		g_pr_seq = mySheet.GetCellValue(Row, "PR_SEQ");
		openSearchPopup("/common/remarkCancelPop.do",'?cancel_remark='+cancel_remark+'&viewType='+viewType,"500,230,no");
	}
	if(column == "BUYER_ITEM_NO"){ // 품목코드
		var st_buyer = mySheet.GetCellValue(Row, "BYIT_COMORG_CODE");
		var st_buyer_item_no = mySheet.GetCellValue(Row, "BUYER_ITEM_NO");
		var st_contract_no = mySheet.GetCellValue(Row, "CONTRACT_NO");
		var st_contract_seq = mySheet.GetCellValue(Row, "CONTRACT_SEQ");
		openSearchPopup("/common/catalogDetailPop.do","?open=Y&BUYER="+st_buyer+"&BUYER_ITEM_NO="+escape(st_buyer_item_no)+"&CONTRACT_NO="+st_contract_no+"&CONTRACT_SEQ="+st_contract_seq,"800,300,no");
	}
}
//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if (msg != "") {
		alert(msg);
	}
	openSearchPopup("/common/approval/getBuyerCauCommonMyPagePop.do","?COMPANY=<%= buyer%>&DOCU_NO=<%=DOCU_NO%>&PASS_TP=<%=PASS_TP %>&FLAG=<%=FLAG %>" ,"1200,700,no");

}
</script>
</html>
