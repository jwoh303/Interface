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
String pass_add = CommonUtil.nvl((String)ht.get("pass_add"),"");  // 결재자의견
String approval_user_id = CommonUtil.nvl((String)ht.get("approval_user_id"),"");  // 현재 결재할 사용자
String DOCU_TITLE = CommonUtil.nvl((String)ht.get("subject"),"");  // 제목
String approval_yn = CommonUtil.nvl((String)ht.get("approval_yn"),"N");  // 대신 결재할 수 있는 아이디 여부

String key_1 = CommonUtil.nvl((String)ht.get("key_1"),"");  // key_1 -- PrNo
String key_2 = CommonUtil.nvl((String)ht.get("key_2"),"");  // key_2
String key_3 = CommonUtil.nvl((String)ht.get("key_3"),"");  // key_3
String extif_tp = CommonUtil.nvl((String)ht.get("extif_tp"),"");  // extif_tp

String PASS_TP = CommonUtil.nvl((String) request.getParameter("PASS_TP"),"");  //  (조회조건)
String RECV_FLAG = CommonUtil.nvl((String) request.getParameter("RECV_FLAG"),"");  //  (조회조건)
String dt_displaly =CommonUtil.nvl((String) request.getParameter("DT_DISPLAY"),"");  

String content = CommonUtil.nvl((String)ht.get("content"),""); // 내용
content = content.replaceAll("&lt;br&gt;", "\n");
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

 //SLOGIC-BEGIN(P06-0000050)
String reportText= "품의서출력"; // default 버튼명 
String reportid = "RD_06_S_003_03";  //default
Map<String, String> p060000050 = CommonUtil.getSpecialCheckReturnMap(buyer,"P06-0000050");   // com_code , 특수로직아이디
if (p060000050 != null){
	reportText= CommonUtil.nvl(p060000050.get("COL01_DATA"),reportText); // 레포트 버튼명
	reportid = CommonUtil.nvl(p060000050.get("COL02_DATA"),reportid); // 레포트아이디
	if (extif_tp.equals("NS")){	// 소싱합의  
		reportid = CommonUtil.nvl(p060000050.get("COL04_DATA"),reportid);	// 레포트아이디
	}
	else if(extif_tp.equals("PX")){ //구매발주
		reportid = CommonUtil.nvl(p060000050.get("COL05_DATA"),reportid);	// 레포트아이디
	}
}     
//SLOGIC-END


boolean editYn = false;

%>
<script type="text/javascript"> 


function  attach_popup(img_key){	
	
	var type = "<%=extif_tp%>";
	var viewType = "R";
	 
	kepFileUploadOpenPopup(img_key,type,viewType); 
}
function  approvalDetailPop(){	

	var url = "<%=biz_url%>?";
	url +=  "COMPANY=<%=COMPANY%>&";
	url +=  "DOCU_NO=<%=key_1%>&";
	url +=  "KEY_2=<%=key_2%>&";
	url +=  "KEY_3=<%=key_3%>&";
	url +=  "RECV_FLAG=<%=RECV_FLAG%>&";
	url +=  "POP_FLAG=Y&";
	url +=  "DOCU_TITLE=<%=CommonUtil.formatHTMLCode(DOCU_TITLE)%>&"
	url +=  "REJECT_YN=N&";
	url = encodeURI(url);		
	window.open(url,"DraftSentenceView","width=700,height=700,resizable=YES,scrollbars=YES,top=0,left=0"); 
}

function captureReturnKey(e) {   
    if(e.keyCode==13 && e.srcElement.type != 'textarea')   
    return false;   
}   

function excelDown() {
	
	document.forms.buyerCommonMyPagePop.action = "/common/approval/excelDownCamListPop.do";
	document.forms.buyerCommonMyPagePop.submit();
	
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
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:100%">
    	<div id="popHeader" >
        	<h1 class="title">결재문서 상세</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
      	</div>
	<!--팝업내용입니다-->
	<div id="popContainer">
	<h4 class="b">[ 결재/참조자 정보 ]</h4>	
	<%
		if(dt_displaly.equals("Y")){
	%>
	<div style="display:none">
	<%
		}else{
	%>
	<div>
	<%
		}
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
			<div id="kto" class="scrollArea" style="height:110px"><%=(String)ht.get("toHtmlContent")%></div>   
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
    	  <tr>
			<th scope="row">결재제목</th>
			<td scope="row"  colspan="3">&nbsp;<%=(String)ht.get("subject")%></td>
		  </tr> 
    	  <tr>
			<th scope="row">기안자</th>
			<td scope="row" >&nbsp;<%=(String)ht.get("user_nm")%>(<%=(String)ht.get("user_id")%>)
				&nbsp;&nbsp;
				<% if ("".equals(CommonUtil.nvl((String)ht.get("image_key")))) { %>
				<img src="/resources/images/ico_file.gif" name="MasterImage" width="14" height="14" border="0"> 
				<%}else{ %>
					<a href="javascript:attach_popup('<%=CommonUtil.nvl((String)ht.get("image_key"))%>');"> <img src="/resources/images/disk_on.gif" name="MasterImage" width="14" height="14" border="0"> </a>
				<%} %>
			</td>
			<th scope="row">기안일시</th>
			<td scope="row" >&nbsp;<%=(String)ht.get("start_date")%></td>			
		  </tr> 		  
    	  <tr>
			<th scope="row">내용</th>
			<td scope="row"  colspan="3">
				<textarea name="DOCU_CONT" id="DOCU_CONT" style="width:580px; height:80px;"><%=content%><%=(String)ht.get("pass_add")%></textarea> 
			</td>	
		  </tr> 
     	  <tr>
			<th scope="row">결재자의견</th>
			<td scope="row" colspan="3">
			<% if ("RECV".equals(FLAG) && "0".equals(pass_status)  && userid.equals(approval_user_id)){ %> 
				<input type=text maxlength="200" style="width:95%"  class="input_type_text" name="PASS_ADD"  id="PASS_ADD" value="">
			<% } else {%>
				<input type=text maxlength="200" style="width:95%"  class="input_type_text" name="PASS_ADD"  id="PASS_ADD" value="" readonly>
			<%} %>  	
			</td>
		  </tr> 	  
    	</tbody>
    </table>
    </div>
	
 

    <!--버튼영역-->   
 <div class="btnArea" align="right">  
  	<%if(biz_jsp.equals("/common/popup/approval/approvalCamListPop")){ // 카탈로그계약변경 일괄수정%> 
 		<span class="btn_04 mr04 fl"  title="결재지정/변경"><a href="javascript:excelDown()">엑셀다운로드</a></span>
 <%} %>
 
 <% if (!"2".equals(PASS_TP)) { %>
 
 
 <% if ("SEND".equals(FLAG) && "0".equals(pass_status)){ %>
		<span class="btn_04 mr04"  title="결재지정/변경"><a href="javascript:approvalLine('<%=COMPANY%>','<%=DOCU_NO%>')">결재지정/변경</a></span>  
<%} %>  		  		 
<%
	if ("RECV".equals(FLAG) && "0".equals(pass_status)){
 		if ("Y".equals(approval_yn)){
%>
	    	<span class="btn_04 mr04"  title="결재"><a href="javascript:approvalProcess('approval')">결재</a></span>
	  		<span class="btn_04 mr04"  title="반려"><a href="javascript:approvalProcess('reject')">반려</a></span>
<%
		}else{
			if(userid.equals(approval_user_id)){
%>
				<span class="btn_04 mr04"  title="결재"><a href="javascript:approvalProcess('approval')">결재</a></span> 
		  		<span class="btn_04 mr04"  title="반려"><a href="javascript:approvalProcess('reject')">반려</a></span>
<%
			}
		}
	}
%>  		
 <% if ("SEND".equals(FLAG) && "0".equals(pass_status)){ %> 
	 <% if (!"NG".equals(extif_tp)) { %>
	  		<span class="btn_04 mr04"  title="상신취소"><a href="javascript:approvalProcess('cancel')">상신취소</a></span>     
	<%}%>
<%} %>  		  		

<% if ("SEND".equals(FLAG) && "0".equals(pass_status)){ %> 
  		<span class="btn_04 mr04"  title="수정/적용"><a href="javascript:approvalProcess('modify')">수정/적용</a></span>  
  		<% editYn = true;  %>
<%} %>  	
<%} %>  		  			
  		<span class="btn_04 mr04"  title="결재내역상세">
  		<a href="javascript:approvalDetailPop()">
  		결재내역상세
  		</a>
  		</span>  
  		<span class="btn_04 mr04"  title="결재현황">
  		<a href="javascript:openSearchPopup('/common/popup/approval/buyerCommonPassStatusPop.do','?COMPANY=<%= COMPANY%>&DOCU_NO=<%=DOCU_NO%>', '800,400,no')">                    	
  		결재현황
  		</a>
  		</span>  
	
	
					<% if (!"NONE".equals(reportText)) {  
				%>
		  		<span class="btn_04 mr04"  title="<%=reportText%>"><a href="javascript:DraftSentenceView();"><%=reportText%></a></span>  
		  		<%} %>		   
		  	<%if(biz_jsp.equals("/common/popup/approval/approvalPxListPop")){%>
	           	<span class="btn_order"  title="상세확대"><a  href="javascript:openSearchPopup('/common/approval/getBuyerCommonMyPagePop.do','?COMPANY=<%=COMPANY%>&DOCU_NO=<%=DOCU_NO%>&PASS_TP=<%=PASS_TP %>&FLAG=<%=FLAG %>&DT_DISPLAY=Y' ,'1200,700,no')">상세확대</a></span>
				<span class="btn_order"  title="상세축소"><a  href="javascript:openSearchPopup('/common/approval/getBuyerCommonMyPagePop.do','?COMPANY=<%=COMPANY%>&DOCU_NO=<%=DOCU_NO%>&PASS_TP=<%=PASS_TP %>&FLAG=<%=FLAG %>' ,'1200,700,no')">상세축소</a></span>
	         <%} %>
  		<!-- <span class="btn_04 mr04"  title="다시작성"><a href="javascript:location.reload();">다시작성</a></span> -->  
    	
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
<c:import charEncoding="utf-8" url="<%=biz_url%>" >
<c:param name="page" value="<%=biz_jsp%>"/>
<c:param name="COMPANY" value="<%=COMPANY%>"/>
<c:param name="DOCU_NO" value="<%=key_1%>"/>
<c:param name="KEY_2" value="<%=key_2%>"/>
<c:param name="KEY_3" value="<%=key_3%>"/>
<c:param name="RECV_FLAG" value="<%=RECV_FLAG%>"/>
<c:param name="DOC_TYPE" value="<%=extif_tp%>"/>
<c:param name="FLAG" value="<%=FLAG%>"/> 
<c:param name="approval_user_id" value="<%=approval_user_id%>"/>
<c:param name="pass_status" value="<%=pass_status%>"/>  
</c:import> 
</div>       
</form>  
</body>
<script type="text/javascript">

function approvalLine(COMPANY,DOCU_NO){
	var option = "?COMPANY="+ COMPANY;
	option = option + "&DOCU_NO="+ DOCU_NO;
	option = option + "&toContent="+ $("#toContent").val();
	openSearchPopup('/common/popup/approval/approvalHumanEditPop.do',option, "1000,470,no"); 
}


function kep_onload_view(){ 
	 $("#DOCU_CONT").focus(); 
	 <% if (editYn == false){ %>
	 	$("#DOCU_CONT").attr("readonly",true);
	 <%}%> 
}

/**
 * 메일 재발송기능
 */
function doMailSend(ordr_no, docu_user_id) {  	 
	var st_user_id = document.forms.buyerCommonMyPagePop.st_user_id.value;
	if(docu_user_id != st_user_id){
		alert("결재 상신자만 결재요청 메일 재발송이 가능 합니다.");
		return;
	}
	var pMethod ="mailSend";
	document.forms.buyerCommonMyPagePop.CUR_ORDER_NO.value  = ordr_no;
	kepAjaxFormCall("/common/approval/CommonApprovalMailSend.do","buyerCommonMyPagePop",pMethod); 
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
		/*
		if (kepIsEmpty("PASS_ADD")==true){
			alert("결재자의견 입력하세요.");
			$("#PASS_ADD").focus();
			return;
		} 			
		*/
		var passAddLen	= kepGetByteLength('PASS_ADD');
		if ( passAddLen > 200 )
		{
			alert("결재자의견은 "+passAddLen+"바이트 입니다.\n결재자의견은 200바이트 이상 입력할 수 없습니다.");
			return ;
		}
		
		url = "<%=action_base%>Approval.do";
	}else if (pMethod == "reject"){
		if (kepIsEmpty("PASS_ADD") == true){
			if (confirm("결재자의견에 반려사유가 입력되지 않았습니다.\n이대로 반려 진행하시겠습니까?")==false){
				$("#PASS_ADD").focus();
				return;	
			}
		}else{
			if (confirm("반려 진행하시겠습니까?")==false) return;
		}
		
		$("#PASS_KN").val("3"); 
		
		var passAddLen	= kepGetByteLength('PASS_ADD');
		if ( passAddLen > 200 )
		{
			alert("결재자의견은 "+passAddLen+"바이트 입니다.\n결재자의견은 200바이트 이상 입력할 수 없습니다.");
			return ;
		}
		
		url =  "<%=action_base%>Approval.do";
	}else if (pMethod == "cancel"){
		if (confirm("취소 진행하시겠습니까?")==false) return;
		$("#PASS_KN").val("4"); 
		url = "<%=action_base%>Cancel.do";
	} else if (pMethod == "modify"){
		var apprId = "<%=apprId%>";
		var st_company = document.forms.buyerCommonMyPagePop.COMPANY.value;
		var to = document.forms.buyerCommonMyPagePop.to.value;
		var st_process_flag = "N";
		var chk_to = to.split(",");
		if(st_company == "KRKORE0001"){
			if(apprId ==""){
				alert("해당팀 체크 할 결재자정보가 없습니다.");
				return;			
			}
			if(apprId == "NO_APPR"){
				st_process_flag  = "Y";
			}else{
				for(var z=0; z<chk_to.length; z++){
					//각부장 결재선 체크
					if(chk_to[z] ==apprId){
						st_process_flag = "Y";
					}
				}			
			}
			if(st_process_flag == "N"){
				alert("품의 상신시 각 부서 팀장님 결재가 필요합니다.");
				return;			
			}
		}
		if (confirm("수정 진행하시겠습니까?")==false) return;
		$("#PASS_KN").val(""); 
		url = "/common/approval/updateContent.do";
	} else if (pMethod == "request"){
		if (confirm("결재상신 진행하시겠습니까?")==false) return; 
		url = "<%=action_base%>Request.do";
	} 
	
	kepAjaxFormCall(url,"buyerCommonMyPagePop",pMethod); 
}


function DraftSentenceView()
{
    var f = document.forms.buyerCommonMyPagePop;
    var docu_no = f.DOCU_NO.value;
    var company = f.COMPANY.value;
    var str = "<%=(String)ht.get("string_no")%>";
    var pr_no = "<%=key_1%>";
    var doc_title = "<%=CommonUtil.formatHTMLCode((String)ht.get("subject"))%>";
    var user_name = "<%=(String)ht.get("user_nm")%>";
    var buyer = "<%=COMPANY%>";
 
    reportOpen("<%=reportid%>","["+pr_no+"]["+buyer+"]["+docu_no+"]["+company+"]["+doc_title+"]["+user_name+"]");
 
   // window.open(loc,"DraftSentenceView","width=700,height=700,resizable=YES,scrollbars=YES,top=0,left=0");
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
	}else if (pMethod == "cancel"){
		alert("상신취소가 성공적으로 이루어 졌습니다. ");
	} else if (pMethod == "modify"){
		alert("수정이 성공적으로 이루어 졌습니다. ");
		closeflag = false;
	} else if (pMethod == "request"){
		alert("결재상신이 성공적으로 이루어 졌습니다. ");
	} else if (pMethod == "SAVE"){
		alert("반려가 성공적으로 이루어 졌습니다. ");	
		openSearchPopup("/common/approval/getBuyerCommonMyPagePop.do","?COMPANY=<%=COMPANY%>&DOCU_NO=<%=DOCU_NO%>&PASS_TP=<%=PASS_TP %>&FLAG=<%=FLAG %>" ,"1200,700,no");
		closeflag = false;
	} else if (pMethod == "mailSend"){
		alert("결재요청 메일을 재전송 하였습니다.");
		closeflag = false; 
	} else if (pMethod == "runlWmReListPop"){
		alert("재실행 처리했습니다 .");
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
	}else if (pMethod == "return"){
		alert("반려가 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
	}else if (pMethod == "cancel"){
		alert("상신취소가 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
	} else if (pMethod == "modify"){
		alert("수정이 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
	} else if (pMethod == "request"){
		alert("결재상신이 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
	} else if (pMethod == "SAVE"){
		alert("반려가 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  ");
	} else if (pMethod == "mailSend"){
		alert("메일 재발송에 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  ");
	} 
} 
</script>
</html>
