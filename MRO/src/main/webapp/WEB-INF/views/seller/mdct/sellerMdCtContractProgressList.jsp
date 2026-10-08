<%--
**********************************************
* 메뉴 : 회원사관리>계약관리>계약진행조회
* 화면 : 계약진행조회
* 기능 : 협력사 계약진행상태 조회
* 프로그램 ID : PG_02_A_001_00
* 담당자 : 이수영 ( 설계 : 권우재 )
* 착수일 : 2014-08-08
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
String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
String onepagerow = (String) request.getParameter("onepagerow");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
   
// 조회조건 S
String st_from_date = CommonUtil.nvl((String) request.getParameter("st_from_date"),"");  // 조회일(From)
String st_to_date = CommonUtil.nvl((String) request.getParameter("st_to_date"),"");  // 조회일(To)
String st_cont_title = CommonUtil.nvl((String) request.getParameter("st_cont_title"),"");  // 조회필드콤보
String st_biz_type = CommonUtil.nvl((String) request.getParameter("st_biz_type"),"");  //
String st_cont_status = CommonUtil.nvl((String) request.getParameter("st_cont_status"),"");  //
// 조회조건 E
%> 

<body onload="kep_onload_view()">
<div id="wrapper"> 
<!-- 메뉴 S --> 
<c:import charEncoding="utf-8" url="/menu/menu.do" >
<c:param name="page" value="sellerHeader"/>
<c:param name="part" value="header"/>
</c:import>

<div id="container2">
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="sellerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>
<!-- 메뉴 E -->
<!--내용 시작-->
<div id="ContArea">
	<h3>계약진행조회</h3>
	<!--버튼영역-->
     <div id="searchBtnA">
     	<span class="btn_search"><a href="javascript:doAction('search');">조회</a></span> 
		<span class="btn_reset"><a href="javascript:doAction('reload');">초기화</a></span>
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
			
		<div id="cont_searchA">	
			<table class="cont_t_list01">
				<caption>조회</caption>
				<colgroup>
					<col width="8%" />
					<col width="20%" />
					<col width="9%" />
					<col width="20%" />
					<col width="8%" />
                    <col width="*" />
				</colgroup>
				
				<tbody>
				<tr>
					<td>계약명</td>
					<td><input type="text" class="input_type_text" id="st_cont_title" name="st_cont_title" style="width:80%;" value="<%=st_cont_title%>" onkeydown="kepEnter()" /></td>
                    <td>진행상태</td>
					<td>
						<select id="st_cont_status" name="st_biz_type" style="width:80%;height:20px">
							<option value="">전체</option>
							<option value="CS1" <%if ("CS1".equals(st_cont_status)) {%>selected<%} %>>회원사 서명대기</option>
							<option value="OS1" <%if ("OS1".equals(st_cont_status)) {%>selected<%} %>>운영사 서명대기</option>
							<option value="CS2" <%if ("CS2".equals(st_cont_status)) {%>selected<%} %>>회원사 취소 서명대기</option>
							<option value="OS2" <%if ("OS2".equals(st_cont_status)) {%>selected<%} %>>운영사 취소 서명대기</option>
							<option value="DRP" <%if ("DRP".equals(st_cont_status)) {%>selected<%} %>>진행취소</option>
							<option value="END" <%if ("END".equals(st_cont_status)) {%>selected<%} %>>계약완료</option>
							<option value="FNL" <%if ("FNL".equals(st_cont_status)) {%>selected<%} %>>계약종료</option>
						</select>
					</td>
					<td>계약기간</td>
					<td>
						<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:30%; text-align:center;" value="<%=st_from_date%>" />
						&nbsp;~&nbsp;
						<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:30%; text-align:center;" value="<%=st_to_date%>" />
					</td>
				</tr>
				</tbody>
			</table>
		</div>
 		
 		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
	      	<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow">
				<option value = "10" <%if ("10".equals(onepagerow)) {%>selected<%} %>>10건</option>
				<option value = "20" <%if ("20".equals(onepagerow)) {%>selected<%} %>>20건</option>
				<option value = "30" <%if ("30".equals(onepagerow)) {%>selected<%} %>>30건</option>
				<option value = "40" <%if ("40".equals(onepagerow)) {%>selected<%} %>>40건</option>
				<option value = "50" <%if ("50".equals(onepagerow)) {%>selected<%} %>>50건</option> 
			</select>
      	</span>      
       <span class="fr">총건수 <%=total_cnt %></span>
       	<br>
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<!-- 공통 -->
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
	  	
		<table id="table_list"  class="cont_t_list02" style="width:100%">
			<colgroup>
	            <col width="2%" />
	            <col width="8%" />
	            <col width="14%" />
	            <col width="8%" />
	            <col width="8%" />
	            <col width="8%" />
	            <col width="14%" />
	            <col width="6%" />
	            <col width="*" />
	            <col width="9%" />
	        </colgroup>
	        <thead>
				<tr>
	                <th scope="col">선택</th>
	                <th scope="col">순번<br/>/ 진행상태</th>
	                <th scope="col">계약서식명<br/>/ 계약일</th>
	                <th scope="col">회원사유형<br/>/ 사업구분</th>
	                <th scope="col">계약시작일<br/> 계약종류일</th>
	                <th scope="col">사업자등록번호<br/>/ 계약취소일</th>
	                <th scope="col">거래처명<br>/ 취소유형</th>
	                <th scope="col">계약번호<br/>/ 취소자</th>
	                <th scope="col">계약명<br/>/ 취소사유</th>
	                <th scope="col">담당부서<br/>담당자</th>
				</tr>
			</thead>
			<tbody>
 			<% if (_gridList == null || _gridList.size() == 0) { %>
				<tr>
					<td colspan="15" align="center" height = "50"> 
						<span>조회된 데이타가 없습니다.</span>
					</td> 
				</tr>
			<%
			} else {
				for (int j=0; j<_gridList.size(); j++) {
					Map<String,String> rowData = _gridList.get(j);
					String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
			%> 
				<tr align="center" bgcolor="<%=tclass%>">
					<td rowspan ="2" class="font1_black1"  align="center">
						<input type="checkbox" name="checkbox">
						<input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=_gridList.size() %>" >
					</td>
					<td title="순번" class="font1_black1"  align="center"><%=((Integer.parseInt(curPage)-1)*Integer.parseInt(onepagerow))+(j+1) %></td>
					<td title="계약서식명"><%=CommonUtil.nvl(rowData.get("FORM_NAME"))%></td>
					<td title="회원사유형"><%=CommonUtil.nvl(rowData.get("COMPANY_TYPE"))%></td>
					<td title="계약시작일"><%=CommonUtil.nvl(rowData.get("START_DATE"))%></td>
					<td title="사업자등록번호"><%=CommonUtil.nvl(rowData.get("BIZMN_REGST_NO"))%></td>
					<td title="거래처명"><%=CommonUtil.nvl(rowData.get("COMPANY_NAME"))%></td>
					<td title="계약번호"><a class="hyperLink" href="javascript:doPop('constract','<%=CommonUtil.nvl(rowData.get("CONT_NO_HID"))%>', '<%=CommonUtil.nvl(rowData.get("CONT_COUNT"))%>');"><%=CommonUtil.nvl(rowData.get("CONT_NO"))%></a></td>
					<td title="계약명"><%=CommonUtil.nvl(rowData.get("CONT_TITLE"))%></td>
					<td title="담당부서"><%=CommonUtil.nvl(rowData.get("COP_DEPT_NAME"))%></td>
				</tr>
				<tr bgcolor="<%=tclass%>">
					<td title="진행상태"><%=CommonUtil.nvl(rowData.get("CONT_STATUS_TEXT"))%></td>
					<td title="계약일"><%=CommonUtil.nvl(rowData.get("CONT_DATE"))%></td>
					<td title="사업구분"><%=CommonUtil.nvl(rowData.get("BIZ_TYPE"))%></td>
					<td title="계약종료일"><%=CommonUtil.nvl(rowData.get("END_DATE"))%></td>
					<td title="계약취소일"><%=CommonUtil.nvl(rowData.get("RJ_DATE"))%></td>
					<td title="취소유형"><%=CommonUtil.nvl(rowData.get("RJ_TYPE"))%></td>
					<td title="취소자"><%=CommonUtil.nvl(rowData.get("RJ_USER"))%></td>
					<td title="취소사유"><%=CommonUtil.nvl(rowData.get("RJ_REASON"))%></td>
					<td title="담당자"><%=CommonUtil.nvl(rowData.get("USER_NAME"))%></td>
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
<%@ include file="/WEB-INF/views/common/include/sellerFooter.jsp" %>   
</div>
</body>

<script type="text/javascript">
var popupSel = "";

// 최초 화면 함수 
function kep_onload_view() {
	
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
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
		$("#st_from_date").val("");
		$("#st_to_date").val("");
// 		kepSearch(-1);
		jspTableClean("table_list");
  		break;

	}
}

// 조회
function kepSearch(curPage){
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mdct/getSellerMdCtContractProgressList.do").submit();   
}
  
// 팝업 함수호출
function doPop(str, val1, val2) {
	popupSel = str;
	switch (str) {
		case "constract": // 고객사 M
			openSearchPopup('/mdct/showMasterMdCtContractProgressPop.do','?st_cont_no=' + val1 + '&st_cont_count=' + val2, '780,700,no');
			break;	
	}
}

// 콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text) {
	if (popupSel == "constract") {
		if (code == "OK") {
			doAction('search');
		}
	}
}

// ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	var msg = response.Message;
	
	if (msg != ""){
		alert(msg);
	}
	// 처리후 재조회
	kepSearch($("#curPage").val());
}

</script>
</html>
