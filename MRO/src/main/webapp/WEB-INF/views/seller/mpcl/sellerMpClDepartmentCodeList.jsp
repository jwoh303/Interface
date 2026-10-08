<%--
**********************************************
* 메뉴 : 관리자>코드관리>부서코드
* 화면 : 부서코드
* 기능 : 
* 프로그램 ID : 
* 담당자 : 최명진 ( 설계 : 공통 )
* 착수일 : 2014-
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
	int grid_cnt = (_gridList != null )? _gridList.size() : 0;
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = (String) request.getParameter("onepagerow");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
    
	// 조회조건 S
	String st_code = CommonUtil.nvl((String) request.getParameter("st_code"),"");  // 부서
	String st_name = CommonUtil.nvl((String) request.getParameter("st_name"),"");  // 부서명
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
	<h3>부서코드</h3>
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
		<input type="hidden" id="st_type" name="st_type"  value="C001">
			
		<div id="cont_searchA">	
			<table class="cont_t_list01">
				<caption>조회</caption>
				<colgroup>
					<col width="8%" />
					<col width="42%" />
					<col width="8%" />
					<col width="42%" />
				</colgroup>
				
				<tbody>
					<tr>
						<td>부서코드</td>
						<td>
							<input type="text" class="input_type_text" name="st_code" id="st_code" style="width:80%;" value="<%=st_code%>" onKeyDown="kepEnter()">
						</td>
						<td>부서명</td>
						<td>
							<input type="text" class="input_type_text" name="st_name" id="st_name" style="width:80%;" value="<%=st_name%>" onKeyDown="kepEnter()">
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
	            <col width="20%" />
	            <col width="40%" />
	            <col width="40%" />
	        </colgroup>
	        <thead>
				<tr>
	                <th scope="col">코드</th>
	                <th scope="col">부서명</th>
	                <th scope="col">부서명(영문)</th>
				</tr>
			</thead>
			<tbody>
<%
	if ( _gridList == null || _gridList.size() == 0) {
%>
				<tr>
		            <td colspan="3" align="center" height = "50">
		            	<span>조회된 데이타가 없습니다.</span>
		            </td>
		        </tr>
<%
	} else {
		for ( int j=0; j<_gridList.size(); j++ ) {
			Map<String,String> rowData = _gridList.get(j);
			String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
%>
				<tr align="center" bgcolor="<%=tclass%>">
		            <td title="코드">
		                <a class="hyperLink" href="javascript:doPop('update', '<%=CommonUtil.nvl(rowData.get("CODE"))%>')"><%=CommonUtil.nvl(rowData.get("CODE"))%></a>
					</td>
		            <td title="부서명">
		                <%=CommonUtil.nvl(rowData.get("TEXT1"))%>
		            </td>
		            <td title="부서명(영문)">
		                <%=CommonUtil.nvl(rowData.get("TEXT2"))%>
		            </td>
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
			<div class="fr">
				<span class="btn_04">
					<a href="javascript:doAction('add');">추가</a>
				</span>	
            </div>
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
function kep_onload_view(){
	// TO-DO
}

var st;

// 기능함수
function doAction(str) {
	switch (str) {
		case "search": //조회
			kepSearch($("#curPage").val());
			break;
			
		case "reload": //초기화
			kepReload("searchForm");
			jspTableClean("table_list");
			break;
			
		case "add": //추가
			doPop('insert', '');
			break;
	}
}

// 조회
function kepSearch(curPage) {
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mpcl/getSellerMpClDepartmentCodeList.do").submit();   
}

// 팝업 함수호출
function doPop(kind, code) {
	popupSel = "sellerMpClPositionCodePop";
	
	switch (kind) {
		case "insert": // 부서코드 추가
			openSearchPopup("/mpcl/showSellerMpClDepartmentCodePop.do",'?kind=insert', '500,260,no');
			break;
	
		case "update": // 부서코드 수정, 삭제
			openSearchPopup("/mpcl/showSellerMpClDepartmentCodePop.do",'?kind=update&st_type=C001&st_code='+code+'&st_com_code='+$("#st_com_code").val(),'500,260,no');
			break;
	}
}

// 콜백함수(파일명은 모두 동일)
function setPopupReturn(){
	if ( popupSel = "sellerMpClPositionCodePop" ) {
		// 재조회
		kepSearch($("#curPage").val());
	}
}
</script>
</html>
