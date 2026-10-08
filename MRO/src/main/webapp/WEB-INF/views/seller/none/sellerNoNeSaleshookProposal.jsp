<%--
**********************************************
* 메뉴 : HOME>판촉물제안하기
* 화면 : 판촉물제안하기
* 기능 : 
* 프로그램 ID : 
* 담당자 : 김경례 ( 설계 :  )
* 착수일 : 2014-10-06
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

<%
	// 공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = (String) request.getParameter("onepagerow");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	
	String search_yn = CommonUtil.nvl((String) request.getParameter("search_yn"),""); // 자동조회여부

%>
<script type="text/javascript">
//<!--

//최초 화면 함수 
function kep_onload_view(){
	//조회조건 초기화(기존값 재설정)
	initSearchCondition("searchForm", "st_list_description", "${st_list_description}");		// 상품명
	initSearchCondition("searchForm", "st_list_specification", "${st_list_specification}");	// 상품규격
	initSearchCondition("searchForm", "st_list_maker_name", "${st_list_maker_name}");		// 제조사
	initSearchCondition("searchForm", "st_list_item_no", "${st_list_item_no}");				// 상품코드
	initSearchCondition("searchForm", "st_list_status", "${st_list_status}");				// 상태
	
	$("input[name='st_list_item_flag']:radio[value='${st_list_item_flag}']").attr("checked",true);		// 구분
	
	initSearchCondition("searchForm", "onepagerow", "${onepagerow}");	//페이징단위
	
	var search_yn = "<%=search_yn%>";
	
	if(search_yn == "Y"){
		doAction("search");
	}
}


function doAction(str) {
	switch (str) {
		case "search":	 // 조회
			kepSearch("1");
			break;
			
		case "reload":	// 초기화
			kepReload("searchForm");
			kepSearch("-1");
			break;
	}
}

/*
 * FORM 을 이용한조회
 */
function kepSearch(curPage){
	document.forms.searchForm.curPage.value = curPage;
	$('#searchForm').attr("action", "/none/getSellerNoNeSaleshookProposalList.do").submit();   
}	

//-->
</script>
</head>
<body onload="kep_onload_view()">
<div id="wrapper"> 
<!-- 메뉴 S --> 
<c:import charEncoding="utf-8" url="/menu/menu.do" >
<c:param name="page" value="sellerHeader"/>
<c:param name="part" value="header"/>
</c:import>

<div id="container2" style="margin-right: 20px;">
<!-- c:import charEncoding="utf-8" url="/menu/menu.do"-->
<!-- c:param name="page" value="sellerLeft"/ -->
<!-- c:param name="part" value="${param.upperId}"/ -->
<!-- /c:import -->
<!-- 메뉴 E -->
<!--내용 시작-->
<div id="ContArea">
	<h3>자사등록 카탈로그 조회</h3>
	<!--버튼영역-->
	<div id="searchBtnA">
		<span class="btn_search"><a href="javascript:doAction('search');">조회</a></span> 
		<span class="btn_reset"><a href="javascript:doAction('reload');">초기화</a></span>
	</div>
	<!--조회영역-->
	<form name = "searchForm" id="searchForm" method = "post">
		<!--HIDDEN-->
		<!-- 공통 -->
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
		<input type="hidden" id="upperId"  name="upperId" value="${param.upperId}"/>    	
		<!-- 화면 내 정의 -->
		<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">

		<input type="hidden" name="st_detail_item_no" id="st_detail_item_no" value="">

		<div id="cont_searchA">	
			<table  class="cont_t_list01">
				<caption>카탈로그 조회</caption>
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
						<th scope="row">품목명</th>
						<td><input type="text" id="st_list_description" name="st_list_description" class="input_type_text" title="상품명" /></td>
						<th scope="row">품목규격</th>
						<td><input type="text" id="st_list_specification" name="st_list_specification" class="input_type_text" title="상품규격" /></td>
						<th scope="row">제조사</th>
						<td><input type="text" id="st_list_maker_name" name="st_list_maker_name" class="input_type_text" title="제조사" /></td>
					</tr>
					<tr>
						<th scope="row">품목코드</th>
						<td><input type="text" id="st_list_item_no" name="st_list_item_no" class="input_type_text" title="상품코드" /></td>
						<th scope="row">구분</th>
						<td>
							<input type="radio" name="st_list_item_flag" value="ALL" checked="checked" class="Noborder">전체&nbsp;
							<input type="radio" name="st_list_item_flag" value="N" class="Noborder">일반&nbsp;
							<input type="radio" name="st_list_item_flag" value="G" class="Noborder">기획
						</td>
						<th scope="row">상태</th>
						<td>
							<select name="st_list_status" id="st_list_status">
								<option value="ALL">전체</option>
								<option value="요청">요청</option>
								<option value="게시">게시</option>
								<option value="보관">보관</option>
								<option value="반려">반려</option>
								<option value="삭제">삭제</option>
								<option value="추천">추천</option>
							</select>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		
		
 		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
			<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow">
				<option value = "10" >10건</option>
				<option value = "20" >20건</option>
				<option value = "30" >30건</option>
				<option value = "40" >40건</option>
				<option value = "50" >50건</option> 
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
				<col width="10%" />
				<col width="25%" />
				<col width="*" />
				<col width="15%" />
			</colgroup>
			<thead>
				<tr>
					<th scope="col">상태</th>
					<th scope="col">구분</th>
					<th scope="col">품목명</th>
					<th scope="col">품목규격</th>
					<th scope="col">제조사</th>
				</tr>
			</thead>
			<tbody>
 		<%
			if (_gridList == null || _gridList.size() == 0){
		%>
				<tr>
					<td colspan="5" align="center" height = "50">
						<span>조회된 데이타가 없습니다.</span>
					</td> 
				</tr>
		<%
			}else{
				for (int j=0; j<_gridList.size(); j++) {
					Map<String,String> rowData = _gridList.get(j);
					String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
		%> 
				<tr align="center" bgcolor="<%=tclass%>">
					<td title="상태">
						<%=CommonUtil.nvl(rowData.get("STATUS"))%>
					</td>
					<td title="구분"><%=CommonUtil.nvl(CommonUtil.nvl(rowData.get("GUBUN")))%></td>
					<td title="품목명" class="left">
						<a class="hyperLink" href="/mdcm/showSellerMdCmBuyerCatalogAlterPop.do?st_item_no=<%=CommonUtil.nvl(rowData.get("ITEM_NO"))%>">
							<%=CommonUtil.nvl(rowData.get("DESCRIPTION"))%>
						</a>
						&nbsp;(<b><%=CommonUtil.nvl(rowData.get("ITEM_NO"))%></b>)
					</td>
					<td title="규격" class="left"><%=CommonUtil.nvl(String.valueOf(rowData.get("SPECIFICATION")))%></td>
					<td title="제조사" class="left"><%=CommonUtil.nvl(String.valueOf(rowData.get("MAKER_NAME")))%></td>
				</tr>
		<%
				}
			}
		%>

			</tbody>
		</table>   
		<!-- 페이징 -->
		<p class="paging">
			<%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow) %> 
		</p>
		
		<!-- 버튼영역 -->
		<div class="btnArea">
			<div class="fr">
				<span class="btn_05">
					<a href="/none/showSellerNoNeSaleshookProposalCreate.do">신규품목 제안</a>
				</span>	
			</div>
		</div>
	</form>
	
	<form name="processForm" id="processForm" method="post">	
		<div id="process">
		</div>
	</form>
</div>

<!--내용 종료-->
</div>
<%@ include file="/WEB-INF/views/common/include/sellerFooter.jsp" %>   
</div>
</body>
</html>
