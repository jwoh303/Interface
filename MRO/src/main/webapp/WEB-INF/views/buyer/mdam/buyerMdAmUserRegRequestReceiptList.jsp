<%--
**********************************************
* 메뉴 : 관리자>사용자관리>사용자등록요청접수
* 화면 : 사용자등록요청접수
* 기능 : 사용자등록요청접수 목록 조회 및 관리
* 프로그램 ID : PG_01_B_003_00
* 담당자 : 이수영 ( 설계 : 권우재 )
* 착수일 : 2014-06-11
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
</head>
<%
// 공통
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
String user_type = _sessionInfo.getUserType();
String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"), "10");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
String userID = _sessionInfo.getUserId();
   
// 조회조건 S
String st_search_user_name = CommonUtil.nvl((String) request.getParameter("st_search_user_name"),"");  // 사용자명
String st_btoa_user_dept_code = CommonUtil.nvl((String) request.getParameter("st_btoa_user_dept_code"),"");  // 요청부서코드
String st_btoa_user_dept_name = CommonUtil.nvl((String) request.getParameter("st_btoa_user_dept_name"),"");  // 요청부서명
String st_buyer_select = CommonUtil.nvl((String) request.getParameter("st_buyer_select"),"");  // 계열사정보

boolean getCodeTGCM = CommonUtil.getCode3CheckReturn("TGCM", userID, com_code);
String group_mng_flag = "N";

if(getCodeTGCM == true){
	group_mng_flag = "Y"; 
}

String st_flag = CommonUtil.getDevRealLocalFlag(request);

String st_httpsurl ="";

if(st_flag.equals("2")){
	//st_httpsurl = "https"+ "://" + request.getServerName() ;
	st_httpsurl = "" ;	
}else{
	st_httpsurl = "" ;		
}
%> 

<script type="text/javascript">
var popupSel = "";

// 최초 화면 함수 
function kep_onload_view() {
}

var st;
//기능함수
function doAction(str) {
	switch (str) {
	case "search":	 //조회
		kepSearch(1);
		break;
	case "reload":	//초기화
		kepReload("searchForm");
		$("#st_btoa_user_dept_code").val("");
// 		kepSearch(-1);
		jspTableClean("table_list");
		break;
	case "reject": // 거절	
		$("#st_status").val("D");
		checkData(str);
		break;
	case "confirm": // 승인
		$("#st_status").val("C");
		if (checkData(str)) {
			//현재 선택한 사용자를 승인 하겠습니까?
			if (!confirm("<%=CommonLang.msg("MSG268")%>")) {
		    	return false;
			}
			kepAjaxFormCall("/mdam/saveBuyerMdAmUserRegRequestReceiptList.do","contentForm",str);
		}
		break;
	
	}
}

// 조회
function kepSearch(curPage){
	//조회그룹으로 추가.
	var st_com_code =document.forms.searchForm.st_buyer_select.value;
	if(st_com_code.indexOf("GROUP") >=0){
		document.forms.searchForm.st_group_info.value = st_com_code; 
	}else{
		document.forms.searchForm.st_group_info.value = ""; 	
	}
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mdam/getBuyerMdAmUserRegRequestReceiptList.do").submit();   
}
  
// 팝업 함수호출
function doPop(str, val, val1) {
	popupSel = str;
	switch (str) {
		case "dept": // 요청부서
			openSearchPopup("/common/deptCodeAdminPop.do", "?com_code="+val + "&open=Y", "500,500,no");
			break;
		case "user": // 사용자정보
			openSearchPopup("<%=st_httpsurl%>/mdam/showBuyerMdAmPrivateInfoAlterPop.do", "?st_user_id="+val+"&com_code="+val1, "900,700,no");
			break;
		case "reject": // 거절사유등록
			openSearchPopup("/common/remarkCancelPop.do", "?viewType=reject", "500,230,no");
			break;
	}
}

// 콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text) {
	if (popupSel == "dept") {
		$("#st_btoa_user_dept_code").val(code);
		$("#st_btoa_user_dept_name").val(text);
	} else if (popupSel == "reject") {
		$("#st_reject_reason").val(code);
		checkReject();
	} else if (popupSel == "user") {
		// 처리후 재조회
		kepSearch($("#curPage").val());
	}
}

// ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	var sMsg = response.msg;
	var flag = "";
	if (pMethod == "confirm") {
		flag = "<%=CommonLang.get("HTITLE321")%>";	//승인
	} else {
		flag = "<%=CommonLang.get("HTITLE320")%>";	//거절
	}
	
	if (sMsg == 'OK') {
		alert("<%=CommonLang.msg("MSG262")%> "+flag+" <%=CommonLang.msg("MSG392")%>");	//사용자가	되었습니다.
	} else {
		alert("<%=CommonLang.msg("MSG263")%> " + flag + "<%=CommonLang.msg("MSG393")%>");	//사용자 이 실패하였습니다. \n\n담당자에게 전화해 주십시요.
	}
	
	// 처리후 재조회
	kepSearch($("#curPage").val());
}

function checkData(str) {
	var cnt   = 0;
	var msg = "";
	var checkId = "";
	
	if (str == "confirm") {
		msg = "<%=CommonLang.get("HTITLE321")%>";	//승인
	} else {
		msg = "<%=CommonLang.get("HTITLE320")%>";	//거절
	}
	
	for (var i=0; i< $('input:checkbox[name=chkItem]').length;i++) {      

        if ($('input:checkbox[name=chkItem]').eq(i).is(':checked')) {
			cnt++;
			checkId = checkId + $('input:checkbox[name=chkItem]').eq(i).val() +  "|";
        }
    }

    if (cnt == 0) {
        alert(msg + "<%=CommonLang.msg("MSG264")%>");	//할 사용자를 선택하여 주십시요
        return false;
    }
    
    if (str == "reject") {
	    if (cnt > 1) {
	    	alert("<%=CommonLang.msg("MSG265")%>");	//사용자 거절은 한명씩만 가능합니다.
	    	return false;
	    }
	    doPop('reject');
    }

    $("#st_checked_id").val(checkId);
    return true;
}

function checkReject() {
	if ($("#st_reject_reason").val() == "") {
		alert("<%=CommonLang.msg("MSG266")%>");	//거절 사유가 입력되지 않았습니다.
		return;
	 }
	
	$("#confirmMsgDiv").text("<%=CommonLang.msg("MSG267")%>"); <%-- 		Confirm 문구 입력 --%>
	$("#confirmAreaDiv").show(); //Confirm 창 확인.
}

//Confirm창 확인처리
function confirmAreaDivSearch(){
	$("#confirmAreaDiv").hide();
	kepAjaxFormCall("/mdam/saveBuyerMdAmUserRegRequestReceiptList.do","contentForm","reject");
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	alert(response.Message);
	return;
}
	

</script>
<body onload="kep_onload_view()">
<div id="wrapper"> 
<!-- 메뉴 S --> 
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   

<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>
<!-- 메뉴 E -->
<!--내용 시작-->
<div id="container2">
<div id="ContArea">
	<h3><%=CommonLang.get("HTITLE319")%><!-- 사용자등록요청접수 --></h3>
	<!--버튼영역-->
     <div id="searchBtnA">
     	<span class="btn_search"><a href="javascript:doAction('search');"><%=CommonLang.get("HTITLE7")%><!-- 조회 --></a></span> 
		<span class="btn_reset"><a href="javascript:doAction('reload');"><%=CommonLang.get("HTITLE8")%><!-- 초기화 --></a></span>
     </div>
	<!--조회영역-->
	<form name = "searchForm" id="searchForm" method = "post">
		<!--HIDDEN-->
		<!-- 공통 -->
		<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
		<!-- 화면 내 정의 -->
		<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
		<input type="hidden" name="st_group_mng_flag" id="st_group_mng_flag" value="<%=group_mng_flag%>">
		<input type="hidden" name="st_group_info" id="st_group_info" value="">
		<div id="cont_searchA">	
			<table class="cont_t_list01" >
				<caption><%=CommonLang.get("HTITLE7")%><!-- 조회 --></caption>
				<colgroup>
					<col width="8%" />
					<col width="25%" />
					<col width="8%" />
					<col width="25%" />
					<col width="8%" />
					<col width="26%" />
				</colgroup>
				
				<tbody>
					<tr>
						<td><%=CommonLang.get("HTITLE322")%><!-- 사용자명 --></td>						
						<td>
								<input type="text" class="input_type_text" name="st_search_user_name" id="st_search_user_name" style="width:80%;" value="<%=st_search_user_name%>"  onKeyDown="kepEnter();" />
						</td>
						<td><%=CommonLang.get("HTITLE323")%><!-- 부서명 --></td>
						<td>
							<input type="text" class="input_type_text" name="st_btoa_user_dept_name" id="st_btoa_user_dept_name" style="width:65%;ime-mode:active" value="<%=st_btoa_user_dept_name%>"  readonly />
							<input type="hidden" name="st_btoa_user_dept_code" id="st_btoa_user_dept_code" value="<%=st_btoa_user_dept_code%>">
							<a href="javascript:doPop('dept', '<%=com_code%>');"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
							<a href="javascript:kepEraser('st_btoa_user_dept_code','st_btoa_user_dept_name');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
						</td>
					<%if(group_mng_flag.equals("Y")){%>
						<td><%=CommonLang.get("HTITLE604")%><!-- 고객사 --></td>
				      	<td>
					        <select name="st_buyer_select" id="st_buyer_select" style="width:90%;height:20px;">
					        	<%= CommonUtil.getCode3ComboList(_sessionInfo.getComCode(), "ALL", "TGCM",_sessionInfo.getUserId(), "ICOMCOD3", st_buyer_select, "") %>
					        </select>
				      	</td>
					<%}else{%>
						<input type="hidden" name="st_buyer_select" id="st_buyer_select" value="">
					<%}%>
					</tr>
				</tbody>
			</table>
		</div>
 		
 		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
	      	<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow">
				<option value = "10" <%if ("10".equals(onepagerow)) {%>selected<%} %>>10<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
				<option value = "20" <%if ("20".equals(onepagerow)) {%>selected<%} %>>20<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
				<option value = "30" <%if ("30".equals(onepagerow)) {%>selected<%} %>>30<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
				<option value = "40" <%if ("40".equals(onepagerow)) {%>selected<%} %>>40<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
				<option value = "50" <%if ("50".equals(onepagerow)) {%>selected<%} %>>50<%=CommonLang.get("HTITLE595")%><!-- 건 --></option> 
			</select>
      	</span>      
       <span class="fr"><%=CommonLang.get("HTITLE608")%><!-- 총건수 --> <%=total_cnt %></span>
       	<br>
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<!-- 공통 -->
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
	  	<input type="hidden" name="st_reject_reason" id="st_reject_reason" value="" />
	  	<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}" />
	  	<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_checked_id" id="st_checked_id" value="" />
		<input type="hidden" name="st_status" id="st_status" value="" />
	  	<input type="hidden" name="st_group_mng_flag" id="st_group_mng_flag" value="<%=group_mng_flag%>">
	  	
		<table id="table_list" class="cont_t_list02" style="width:100%">
			<colgroup>
				<col width="4%" />
			<%if(group_mng_flag.equals("Y")){%>
				<col width="16%" />
			<%}%>
	            <col width="16%" />
	            <col width="14%" />
	            <col width="*" />
	            <col width="12%" />
	            <col width="18%" />
	        </colgroup>
	        <thead>
			<tr>
                <th scope="col"><%=CommonLang.get("HTITLE178")%><!-- 선택 --></th>
			<%if(group_mng_flag.equals("Y")){%>
				<th scope="col"><%=CommonLang.get("HTITLE291")%><!-- 고객사명 --></th>
			<%}%>
                <th scope="col">ID</th>
                <th scope="col"><%=CommonLang.get("HTITLE325")%><!-- 이름 --></th>
                <th scope="col"><%=CommonLang.get("HTITLE329")%><!-- 부서 --></th>
                <th scope="col"><%=CommonLang.get("HTITLE326")%><!-- 전화번호 --></th>
                <th scope="col"><%=CommonLang.get("HTITLE41")%><!-- 이메일 --></th>
			</tr>
		</thead>
		<tbody>
 		<% if (_gridList == null || _gridList.size() == 0) { %>
			<tr>
			    <td colspan="15" align="center" height = "50"> 
			    <span><%=CommonLang.msg("MSG347")%><!-- 조회된 데이타가 없습니다. --></span>
			    </td> 
			</tr>
        <%
        } else {
			for (int j=0; j<_gridList.size(); j++) {
				Map<String,String> rowData = _gridList.get(j);
				String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
				
		%> 
				<tr align="center" bgcolor="<%=tclass%>">
					<td class="font1_black1"  align="center">
						<input type="checkbox" name="chkItem" value="<%=String.valueOf(CommonUtil.nvl(rowData.get("USER_ID"))) + "@@" + String.valueOf(CommonUtil.nvl(rowData.get("COM_CODE")))%>">
	                    <input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=_gridList.size() %>" >
					</td>
				<%if(group_mng_flag.equals("Y")){%>
					<td title="고객사명" class="left"><%=String.valueOf(CommonUtil.nvl(rowData.get("BUYER_NAME")))%></td>
				<%}%>
                    <td title="ID" class="left"><a class="hyperLink" href="javascript:doPop('user', '<%=String.valueOf(rowData.get("USER_ID"))%>', '<%=String.valueOf(rowData.get("COM_CODE"))%>');"><%=String.valueOf(CommonUtil.nameMasking(CommonUtil.nvl(rowData.get("USER_ID"))))%></a></td>
                    <td title="이름" class="left"><%=String.valueOf(CommonUtil.nameMasking(CommonUtil.nvl(rowData.get("USER_NAME_LOC"))))%></td>
                    <td title="부서" class="left"><%=String.valueOf(CommonUtil.nvl(rowData.get("DEPT_NAME")))%></td>
                    <td title="전화" class="left"><%=String.valueOf(CommonUtil.phoneMasking(CommonUtil.nvl(rowData.get("PHONE_NUMBER"))))%></td>
                    <td title="이메일" class="left"><%=String.valueOf(CommonUtil.emailMasking(CommonUtil.nvl(rowData.get("EMAIL"))))%></td>
				</tr>
            <%
                        } 
        			}
            %>
           		</tbody>
            </table>
		<!-- 페이징 -->
		<p id="paging" class="paging">
			<%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow) %> 
		</p>  
		
		<!-- 버튼영역 -->
		<% if ("A".equals(user_type)) {  %>
		<div class="btnArea">
			<div class="fr">
				<span class="btn_04">
					<a href="javascript:doAction('reject');"><%=CommonLang.get("HTITLE320")%><!-- 거절 --></a>
				</span>	
				<span class="btn_04">
					<a href="javascript:doAction('confirm');"><%=CommonLang.get("HTITLE321")%><!-- 승인 --></a>
				</span>	
            </div>
        </div>
        <% } %>
</form>

<form name="processForm" id="processForm" method="post">	
	<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" />
	<input type="hidden" name="total_cnt" id="total_cnt"  value="<%=total_cnt %>"/>
	<input type="hidden" name="curPage" id="curPage"  value="<%=curPage %>"/>
	<input type="hidden" name="onepagerow" id="onepagerow"  value="<%=onepagerow %>"/>
	<div id="process">
	
	</div>
</form>
</div>

<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>   
</div>
</body>

</html>
