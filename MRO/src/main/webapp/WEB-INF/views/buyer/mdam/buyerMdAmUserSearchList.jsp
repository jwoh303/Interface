<%--
**********************************************
* 메뉴 : 관리자>사용자관리>사용자조회
* 화면 : 사용자조회
* 기능 : 고객사별 등록사용자 관리
* 프로그램 ID : PG_01_B_002_00
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
String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
String onepagerow = (String) request.getParameter("onepagerow");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
   
// 조회조건 S
String st_search_user_id = CommonUtil.nvl((String) request.getParameter("st_search_user_id"),"");  // 아이디
String st_search_user_name = CommonUtil.nvl((String) request.getParameter("st_search_user_name"),"");  // 사용자명
String st_btoa_user_dept_code = CommonUtil.nvl((String) request.getParameter("st_btoa_user_dept_code"),"");  // 요청부서코드
String st_btoa_user_dept_name = CommonUtil.nvl((String) request.getParameter("st_btoa_user_dept_name"),"");  // 요청부서명
String st_com_code = CommonUtil.nvl((String) request.getParameter("st_com_code"),"");  // 계열사정보
String st_del_yn = CommonUtil.nvl((String) request.getParameter("st_del_yn"),"N"); // 조회조건

// 조회조건 E
String SessionUserId            = "";
SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
if (sessionInfo != null){ 
	SessionUserId            = sessionInfo.getUserId();
}
boolean getCodeTGCM = CommonUtil.getCode3CheckReturn("TGCM", SessionUserId, com_code);
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

//p01101101 사용자명 링크 활성화(개인정보 수정 팝업, 조건: user_tyer=A)
boolean p01101101= CommonUtil.getSpecialCheckReturn(com_code,"P01-1011-01");
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
// 			kepSearch(-1);
			jspTableClean("table_list");
			break;
		case "delete": // 삭제	
			$("#st_status").val("D");
			if (checkData(str)) {
				kepAjaxFormCall("/mdam/saveBuyerMdAmUserSearchList.do","contentForm",str);
			}
			break;
		case "restoration": // 복원
			$("#st_status").val("R");
			if (checkData(str)) {
				kepAjaxFormCall("/mdam/saveBuyerMdAmUserSearchList.do","contentForm",str);
			}
			break;
		case "excelDown": // 엑셀다운로드
			//조회그룹으로 추가.
			var st_com_code =document.forms.searchForm.st_com_code.value;
			if(st_com_code.indexOf("GROUP") >=0){
				document.forms.searchForm.st_group_info.value = st_com_code; 
			}
			document.forms.searchForm.action = "/mdam/excelBuyerMdAmUserSearchList.do";
			document.forms.searchForm.submit();
			break;
	}
}

// 조회
function kepSearch(curPage) {
	//조회그룹으로 추가.
	var st_com_code =document.forms.searchForm.st_com_code.value;
	if(st_com_code.indexOf("GROUP") >=0){
		document.forms.searchForm.st_group_info.value = st_com_code; 
	}
	if(document.forms.searchForm.st_checkbox_appr.checked == true){
		$("#st_del_yn").val("Y");
	}else{
		$("#st_del_yn").val("N");
	}
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mdam/getBuyerMdAmUserSearchList.do").submit();   
}

// 팝업 함수호출
function doPop(str, val) {
	popupSel = str;
	switch (str) {
		case "dept": // 요청부서
			openSearchPopup("/common/deptCodeAdminPop.do", "?com_code="+val + "&open=Y", "500,500,no");
			break;
		case "user": // 사용자정보
			openSearchPopup("<%=st_httpsurl%>/mdcp/showMasterMdCpUserDetailViewPop.do","?st_user_id="+val+"&callType=","800,600,no");
			break;
		case "user_mod": // 사용자정보
			openSearchPopup("<%=st_httpsurl%>/mdam/showBuyerMdAmPrivateInfoAlterPop.do","?st_user_id="+val,"900,700,no");
			break;	
	}
}

// 콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text) {
	if (popupSel == "dept") {
		$("#st_btoa_user_dept_code").val(code);
		$("#st_btoa_user_dept_name").val(text);
	}  else if (popupSel == "user_mod") {
		// 처리후 재조회
		kepSearch($("#curPage").val());
	}
}

// ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	var sMsg = response.msg;
	var flag = "";
	if (pMethod == "delete") {
		flag = "삭제";
	} else {
		flag = "복원";
	}
	
	if (sMsg == 'OK') {
		alert("사용자가 "+flag+" 되었습니다.");
	} else {
		alert("사용자 " + flag + "이 실패하였습니다. \n\n담당자에게 전화해 주십시요.");
	}

	// 처리후 재조회
	kepSearch($("#curPage").val());
}

function checkData(str) {
	var cnt   = 0;
	var msg = "";
	var checkId = "";
	
	if (str == "delete") {
		msg = "삭제";
	} else {
		msg = "복원";
	}
	for (var i=0; i< $('input:checkbox[name=chkItem]').length;i++) {      

        if ($('input:checkbox[name=chkItem]').eq(i).is(':checked')) {
			cnt++;
			checkId = checkId + $('input:checkbox[name=chkItem]').eq(i).val() +  "|";
        }
    }

    if (cnt==0) {
        alert(msg + "할 사용자를 선택하여 주십시요");
        return false;
    } else {
    	$("#st_checked_id").val(checkId);
    	if (!confirm("현재 선택한 사용자를 " + msg + "하겠습니까?")) {
            return false;
        }
    }
    
    return true;
}
</script> 
<body onload="">
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
	<h3><%=CommonLang.get("HTITLE327") %><!-- 사용자조회 --></h3>
	<!--버튼영역-->
     <div id="searchBtnA">
     	<span class="btn_search"><a href="javascript:doAction('search');"><%=CommonLang.get("HTITLE7") %><!-- 조회 --></a></span> 
		<span class="btn_reset"><a href="javascript:doAction('reload');"><%=CommonLang.get("HTITLE8") %><!-- 초기화 --></a></span>
     </div>
	<!--조회영역-->
	<form name = "searchForm" id="searchForm" method = "post">
		<!--HIDDEN-->
		<!-- 공통 -->
		<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
		<!-- 화면 내 정의 -->
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
		<input type="hidden" name="st_group_mng_flag" id="st_group_mng_flag" value="<%=group_mng_flag%>">
		<input type="hidden" name="st_group_info" id="st_group_info" value="">
		<input type="hidden" name="st_del_yn"  id="st_del_yn" value="<%=st_del_yn%>">
		<div id="cont_searchA">	
			<table class="cont_t_list01" >
				<caption><%=CommonLang.get("MSG7") %><!-- 조회 --></caption>
				<colgroup>
					<col width="8%" />
					<col width="25%" />
					<col width="9%" />
					<col width="25%" />
					<col width="8%" />
                    <col width="25%" />
				</colgroup>
				
				<tbody>
					<tr>
						<td>ID</td>
						<td>
								<input type="text" class="input_type_text" name="st_search_user_id" id="st_search_user_id" style="width:80%;" value="<%=st_search_user_id%>" onkeyup="kepToUpper('st_search_user_id')" onKeyDown="kepEnter()">
						</td>
						<td><%=CommonLang.get("HTITLE322") %><!-- 사용자명 --></td>						
						<td>
								<input type="text" class="input_type_text" name="st_search_user_name" id="st_search_user_name" style="width:80%;" value="<%=st_search_user_name%>"  onKeyDown="kepEnter()">
						</td>
						<td><%=CommonLang.get("HTITLE323") %><!-- 부서명 --></td>
						<td>
							<input type="text" class="input_type_text" name="st_btoa_user_dept_name" id="st_btoa_user_dept_name" style="width:65%;ime-mode:active" value="<%=st_btoa_user_dept_name%>"  readonly />
							<input type="hidden" name="st_btoa_user_dept_code" id="st_btoa_user_dept_code" value="<%=st_btoa_user_dept_code%>" />
							<a href="javascript:doPop('dept', '<%=com_code%>');"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
							<a href="javascript:kepEraser('st_btoa_user_dept_code','st_btoa_user_dept_name');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
						</td>
					</tr>
					<tr>
						<td><%=CommonLang.get("HTITLE936") %><!-- 삭제포함 조회 --></td>						
						<td><input type="checkbox"  class="Noborder" name="st_checkbox_appr" id="st_checkbox_appr"  <%=st_del_yn.equals("Y")?"checked":"" %>>&nbsp;</td>
					<%if(group_mng_flag.equals("Y")){%>
						<td><%=CommonLang.get("HTITLE604") %><!-- 고객사 --></td>
				      	<td>
					        <select name="st_com_code" id="st_com_code" style="width:90%;height:20px;" onchange="buyerChange()">
					        	<%= CommonUtil.getCode3ComboList(_sessionInfo.getComCode(), "ALL", "TGCM",_sessionInfo.getUserId(), "ICOMCOD3", st_com_code, "") %>
					        </select>
				      	</td>
					<%}else{%>
						<td><input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}"></td><td></td>
					<%}%>
						<td></td>
						<td></td>
					</tr>
				</tbody>
			</table>
		</div>
 		
 		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
	      	<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow">
				<option value = "10" <%if ("10".equals(onepagerow)) {%>selected<%} %>>10<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
				<option value = "20" <%if ("20".equals(onepagerow)) {%>selected<%} %>>20<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
				<option value = "30" <%if ("30".equals(onepagerow)) {%>selected<%} %>>30<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
				<option value = "40" <%if ("40".equals(onepagerow)) {%>selected<%} %>>40<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
				<option value = "50" <%if ("50".equals(onepagerow)) {%>selected<%} %>>50<%=CommonLang.get("HTITLE595") %><!-- 건 --></option> 
			</select>
      	</span>      
       <span class="fr"><%=CommonLang.get("HTITLE608") %><!-- 총건수 --> <%=total_cnt %></span>
       	<br>
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<!-- 공통 -->
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}" />
		<input type="hidden" name="st_checked_id" id="st_checked_id" value="" />
		<input type="hidden" name="st_status" id="st_status" value="" />
		
		<table id="table_list" class="cont_t_list02" style="width:100%">
			<colgroup>
	            <col width="4%" />
	            <col width="6%" />
	            <col width="25%" />
	            <col width="10%" />
	            <col width="*" />
	            <col width="10%" />
	            <col width="18%" />
	        </colgroup>
	        <thead>
			<tr>
                <th scope="col"><%=CommonLang.get("HTITLE178") %><!-- 선택 --></th>
                <th scope="col"><%=CommonLang.get("HTITLE255") %><!-- 상태 --></th>
			<%if(group_mng_flag.equals("Y")){%>
                <th scope="col"><%=CommonLang.get("HTITLE604") %><!-- 고객사 --> / ID</th>
            <%}else{%>
            	<th scope="col">ID</th>
            <%}%>
                <th scope="col"><%=CommonLang.get("HTITLE325") %><!-- 이름 --></th>
                <th scope="col"><%=CommonLang.get("HTITLE329") %><!-- 부서 --></th>
                <th scope="col"><%=CommonLang.get("HTITLE326") %><!-- 전화번호 --></th>
                <th scope="col"><%=CommonLang.get("HTITLE41") %><!-- 이메일 --></th>
			</tr>
		</thead>
		<tbody>
 		<% if (_gridList == null || _gridList.size() == 0) { %>
			<tr>
				<td colspan="15" align="center" height = "50"> 
					<span><%=CommonLang.msg("MSG347") %><!-- 조회된 데이타가 없습니다. --></span>
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
						<input type="checkbox" name="chkItem" value="<%=String.valueOf(CommonUtil.nvl(rowData.get("USER_ID")))%>">
	                    <input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=_gridList.size() %>" >
					</td>
                    <td title="상태"><%=String.valueOf(CommonUtil.nvl(rowData.get("STATUS_TEXT")))%></td>
                    <td title="ID" class="left">
                    	<% if (CommonUtil.nvl(rowData.get("STATUS")).equals("D")) { %>
                    		<%if(group_mng_flag.equals("Y")){%>
                    			<%=String.valueOf(CommonUtil.nvl(rowData.get("COM_NAME_LOC")))%> / <%=String.valueOf(CommonUtil.nameMasking(CommonUtil.nvl(rowData.get("USER_ID"))))%>
                    		<%}else{%>
                    			<%=String.valueOf(CommonUtil.nameMasking(CommonUtil.nvl(rowData.get("USER_ID"))))%>
                    		<%}%>
                    	<% } else { %>
                    		<%if(group_mng_flag.equals("Y")){%>
                    			<%if (p01101101==true) { %>
                    				<%=String.valueOf(CommonUtil.nvl(rowData.get("COM_NAME_LOC")))%> / <a class="hyperLink" href="javascript:doPop('user_mod','<%=String.valueOf(rowData.get("USER_ID"))%>');"><%=String.valueOf(CommonUtil.nameMasking(CommonUtil.nvl(rowData.get("USER_ID"))))%></a>
                    			<% } else { %>
                    				<%=String.valueOf(CommonUtil.nvl(rowData.get("COM_NAME_LOC")))%> / <a class="hyperLink" href="javascript:doPop('user','<%=String.valueOf(rowData.get("USER_ID"))%>');"><%=String.valueOf(CommonUtil.nameMasking(CommonUtil.nvl(rowData.get("USER_ID"))))%></a>
                    			<% }%>
                    		<%}else{%>
			                    <%if (p01101101==true) { %>
			                    	<a class="hyperLink" href="javascript:doPop('user_mod','<%=String.valueOf(rowData.get("USER_ID"))%>');"><%=String.valueOf(CommonUtil.nameMasking(CommonUtil.nvl(rowData.get("USER_ID"))))%></a>
								<% } else { %>                    		
                    				<a class="hyperLink" href="javascript:doPop('user','<%=String.valueOf(rowData.get("USER_ID"))%>');"><%=String.valueOf(CommonUtil.nameMasking(CommonUtil.nvl(rowData.get("USER_ID"))))%></a>
                    			<% }%>
                    		<%}%>
                    	<% } %>
                    </td>
                    <td title="이름" class="left">
                    <%
					if (p01101101==true) {
						if (!CommonUtil.nvl(rowData.get("STATUS")).equals("D")) { 
					%>
                    	<a class="hyperLink" href="javascript:doPop('user_mod','<%=String.valueOf(rowData.get("USER_ID"))%>');"><%=String.valueOf(CommonUtil.nameMasking(CommonUtil.nvl(rowData.get("USER_NAME_LOC"))))%></a>
                    <% } else { %>
							<%=String.valueOf(CommonUtil.nameMasking(CommonUtil.nvl(rowData.get("USER_NAME_LOC"))))%>
					<% } %>
                    <% } else { %>	
                    		<%=String.valueOf(CommonUtil.nameMasking(CommonUtil.nvl(rowData.get("USER_NAME_LOC"))))%>
                     <% } %>
                    </td>
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
		<div class="btnArea">
			<!-- 엑셀다운로드 금지 ISMS 지적사항 20230630 -->
			<div class="fr">
				<!--  span class="btn_04">
					<a href="javascript:doAction('restoration');"><%=CommonLang.get("HTITLE328") %> <!-- 복원 --></a>
				</span-->	
				<span class="btn_04">
					<a href="javascript:doAction('delete');"><%=CommonLang.get("HTITLE25") %><!-- 삭제 --></a>
				</span>	
            </div>
        </div>
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
