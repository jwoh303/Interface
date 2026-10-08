<%--
**********************************************
* 메뉴 : 재고관리>수불관리>수불리스트
* 화면 : 수불리스트
* 기능 : 
* 프로그램 ID : PG_08_B_501_00
* 담당자 : 최명진 ( 설계 : 김상근 )
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
	List<Map<String,String>> _userList = (List<Map<String,String>>) request.getAttribute("userList"); // 사용자 리스트
	List<Map<String,String>> _deptList = (List<Map<String,String>>) request.getAttribute("deptList"); // 부서 리스트
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = (String) request.getParameter("onepagerow");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
    
	// 조회조건 S
	String st_from_date = CommonUtil.nvl((String) request.getParameter("st_from_date"),"");  // 조회일(From)
	String st_to_date = CommonUtil.nvl((String) request.getParameter("st_to_date"),"");  // 조회일(To)
	String st_job_type = CommonUtil.nvl((String) request.getParameter("st_job_type"),"");  // 수불명
	String st_buyer_item_no = CommonUtil.nvl((String) request.getParameter("st_buyer_item_no"),"");  // 품목코드
	String st_job_user_id = CommonUtil.nvl((String) request.getParameter("st_job_user_id"),"");  // 작업자명
	String st_job_dept_cd = CommonUtil.nvl((String) request.getParameter("st_job_dept_cd"),"");  // 작업자부서명
	String st_description = CommonUtil.nvl((String) request.getParameter("st_description"),"");  // 품목명
	String st_specification = CommonUtil.nvl((String) request.getParameter("st_specification"),"");  // 규격
	// 조회조건 E
%> 

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
	<h3>수불리스트</h3>
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
			<table class="cont_t_list01" >
				<caption>조회</caption>
				<colgroup>
					<col width="9%" />
					<col width="18%" />
					<col width="9%" />
					<col width="18%" />
					<col width="8%" />
                    <col width="15%" />
					<col width="8%" />
                    <col width="15%" />
				</colgroup>
				
				<tbody>
					<tr>
						<th>수불일자</th>
						<td colspan="3">
							<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:90px; text-align:center;" value="<%=st_from_date%>">
							&nbsp;~&nbsp;
							<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:90px; text-align:center;" value="<%=st_to_date%>">
						</td>
						<th>수불명</th>
						<td>
							<select id="st_job_type" name="st_job_type" style="width:80%;height:20px">
								<option <%=(st_job_type.equals("")? "selected" : "")%> value="">전체</option>
								<option <%=(st_job_type.equals("GR")? "selected" : "")%> value="GR">입고</option>
								<option <%=(st_job_type.equals("CHUL")? "selected" : "")%> value="CHUL">출고</option>
								<option <%=(st_job_type.equals("JO")? "selected" : "")%> value="JO">조정</option>
							</select>
						</td>
						<th>품목코드</th>
						<td>
							<input type="text" class="input_type_text" name="st_buyer_item_no" id="st_buyer_item_no" style="width:80%" value="<%=st_buyer_item_no%>"  onKeyDown="kepEnter()">
						</td>
					</tr>
					<tr>
						<th>작업자명</th>
						<td>
							<select id="st_job_user_id" name="st_job_user_id" style="width:80%;height:20px">
								<option value="">전체</option>
<%
			for ( int k=0; k < _userList.size(); k++ ) {
%>
								<option value="<%=_userList.get(k).get("USER_ID") %>" <%=(_userList.get(k).get("USER_ID").equals(st_job_user_id) ? "selected" : "")%>><%=_userList.get(k).get("USER_NAME") %> : <%=_userList.get(k).get("LEGACY_USER_ID") %></option>
<%
			}
%>
							</select>
						</td>
						<th>작업자부서명</th>
						<td>
							<select id="st_job_dept_cd" name="st_job_dept_cd" style="width:80%;height:20px">
								<option value="">전체</option>
<%
			for ( int k=0; k < _deptList.size(); k++ ) {
%>
								<option value="<%=_deptList.get(k).get("CODE") %>" <%=(_deptList.get(k).get("CODE").equals(st_job_dept_cd) ? "selected" : "")%>><%=_deptList.get(k).get("TEXT1") %></option>
<%
			}
%>
							</select>
						</td>
						<th>품목명</th>
						<td>
							<input type="text" class="input_type_text" name="st_description" id="st_description" style="width:80%;" value="<%=st_description%>" onKeyDown="kepEnter()">
						</td>
						<th>규격</th>
						<td>
							<input type="text" class="input_type_text" name="st_specification" id="st_specification" style="width:80%;" value="<%=st_specification%>" onKeyDown="kepEnter()">
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
	  	
		<table class="cont_t_list02" style="width:100%">
			<colgroup>
	            <col width="10%" />
	            <col width="15%" />
	            <col width="*" />
	            <col width="10%" />
	            <col width="18%" />
	            <col width="18%" />
	        </colgroup>
	        <thead>
			<tr>
                <th scope="col">수불명</th>
                <th scope="col">수불번호<br>품목코드</th>
                <th scope="col">품목명<br>규격</th>
                <th scope="col">제조사<br>단위</th>
                <th scope="col">작업 일시<br>작업 수량</th>
                <th scope="col">작업자명 / 작업부서명<br>비고</th>
			</tr>
		</thead>
		<tbody>
<%
	if ( _gridList == null || _gridList.size() == 0) {
%>
				<tr>
		            <td colspan="6" align="center" height = "50">
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
		            <td rowspan="2" title="수불명">
		                <%=rowData.get("JOB_TYPE_TEXT")%>
		            </td>
		            <td title="수불번호">
		            	<%=rowData.get("JOB_NO")%>
					</td>
		            <td class="left pl05" title="품목명">
		                <%=rowData.get("DESCRIPTION")%>
		            </td>
		            <td class="left pl05" title="제조사">
		                <%=rowData.get("MAKER_NAME")%>
					</td>
					<td class="left pl05" title="작업일시">
		                <%=rowData.get("JOB_DAY")%>
					</td>
					<td class="left pl05" title="작업자명/작업부서명">
		                <%=rowData.get("JOB_USER_NAME") + " / " + rowData.get("JOB_DEPT_NAME")%>
					</td>
				</tr>
	            <tr align="center" bgcolor="<%=tclass%>">
		        	<td title="품목코드">
		            	<a class="hyperLink" href="javascript:getBuyerCatalogDisplayPop('<%=rowData.get("BYCA_COMORG_CODE")%>','<%=rowData.get("ITEM_NO")%>','<%=rowData.get("CONTRACT_NO")%>','<%=rowData.get("CONTRACT_SEQ")%>');">
							<%=rowData.get("ITEM_NO")%>
						</a>
		            </td>
		            <td class="left pl05" title="규격">
		                <%=rowData.get("SPECIFICATION")%>
		            </td>
		            <td class="left pl05" title="단위">
		                <%=rowData.get("UNIT_MEASURE")%>
					</td>
					<td class="right pr05" title="작업수량">
		                <%=rowData.get("ITEM_QTY")%>
					</td>
					<td class="left pl05" widthtitle="비고">
		                <%=rowData.get("JOB_NOTE")%>
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
        	<div class="fl">
        		<span class="btn_04 mr04">
					<a href="javascript:doAction('excelDown');">엑셀다운로드</a>
				</span>
			</div>
        </div>
	</form>
</div>

<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>   
</div>
</body>

<script type="text/javascript">
var popupSel = "";

// 최초 화면 함수 
function kep_onload_view(){
	
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
<%if("".equals(st_from_date)){%>
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
<%}%>
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
			// 조회일 초기 셋팅
			kepSetCalender("st_from_date");
			kepSetCalender("st_to_date");
			
			$("#st_from_date").val( kepToMonthAdd("1","M"));
			$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));   
			break;
	
		case "excelDown": // 엑셀다운로드
			if (kepGetDateDiff('st_from_date','st_to_date','D') > 93 ){
				//조회기간을 3개월 단위로 조회가 가능합니다.
				alert("<%=CommonLang.msg("MSG95")%>");
				return;
			}
			document.forms.searchForm.action = "/mpst/excelBuyerMpStRecinpayListList.do";
			document.forms.searchForm.submit();
// 			$('#searchForm').attr("action", "/mpst/excelBuyerMpStRecinpayListList.do").submit();
			break;
	}
}

// 조회
function kepSearch(curPage) {
	document.forms.searchForm.curPage.value = curPage; 
	if (kepGetDateDiff('st_from_date','st_to_date','D') > 93 ){
		//조회기간을 3개월 단위로 조회가 가능합니다.
		alert("<%=CommonLang.msg("MSG95")%>");
		return;
	}
	$('#searchForm').attr("action", "/mpst/getBuyerMpStRecinpayListList.do").submit();   
}
</script>
</html>
