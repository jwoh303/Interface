<%--
**********************************************
* 메뉴 : 재고관리>재고관리>재고상품등록관리
* 화면 : 재고상품등록관리
* 기능 : 
* 프로그램 ID : PG_08_B_504_01
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
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
	int grid_cnt = (_gridList != null )? _gridList.size() : 0;
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = (String) request.getParameter("onepagerow");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.

	// 조회조건 S
	String st_item_gubun = CommonUtil.nvl((String) request.getParameter("st_item_gubun"),"");  // 품목구분
	String st_buyer_item_no = CommonUtil.nvl((String) request.getParameter("st_buyer_item_no"),"");  // 품목코드
	String st_description = CommonUtil.nvl((String) request.getParameter("st_description"),"");  // 품목명
	String st_specification = CommonUtil.nvl((String) request.getParameter("st_specification"),"");  // 규격
	// 조회조건 E
%>

<body onload="kep_onload_view()">
<div id="wrapper">

<!-- 메뉴 S -->
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   

<div id="container2">
<c:import charEncoding="utf-8" url="/menu/menu.do">
	<c:param name="page" value="buyerLeft"/>
	<c:param name="part" value="${param.upperId}"/>
</c:import>
<!-- 메뉴 E -->

<!--내용 시작-->
<div id="ContArea">
	<h3>재고상품등록관리</h3>

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
		<input type="hidden" name="st_comorg_code" id="st_comorg_code" value="${sessionInfo.bycaComorgCode}">
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
		<input type="hidden" name="st_user_dept" id="st_user_dept" value="${sessionInfo.department}">

		<div id="cont_searchA">
			<table class="cont_t_list01" >
				<caption>조회</caption>
				<colgroup>
					<col width="8%" />
					<col width="17%" />
					<col width="8%" />
					<col width="17%" />
					<col width="8%" />
                    <col width="17%" />
					<col width="8%" />
                    <col width="17%" />
				</colgroup>

				<tbody>
					<tr>
						<th>품목구분</th>
      					<td >
      						<select name="st_item_gubun" id="st_item_gubun">
								<option <%=(st_item_gubun.equals("T")? "selected" : "")%> value="T">전체</option>
								<option <%=(st_item_gubun.equals("N")? "selected" : "")%> value="N">일반</option>
								<option <%=(st_item_gubun.equals("S")? "selected" : "")%> value="S">재고</option>
							</select>
						</td>
						<th>품목코드</th>
						<td>
							<input type="text" class="input_type_text" name="st_buyer_item_no" id="st_buyer_item_no" style="width:80%;" value="<%=st_buyer_item_no%>" onKeyDown="kepEnter()">
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
		<input type="hidden" id="display_item_cnt" name="display_item_cnt" value="<%=grid_cnt %>" >

		<table class="cont_t_list02" style="width:100%">
			<colgroup>
	            <col width="3%" />
	            <col width="12%" />
	            <col width="12%" />
	            <col width="*" />
	            <col width="15%" />
	            <col width="10%" />
	            <col width="15%" />
	            <col width="13%" />
	        </colgroup>
	        <thead>
				<tr>
					<th scope="col">
						<input type="checkbox" name="check_status" id="check_status" value="선택"  style="cursor:hand;" onclick="javascript:kepCheckAll('<%=grid_cnt %>',document.forms.contentForm.check_status,'document.forms.contentForm.checkbox')">
					</th>
	                <th scope="col"><font color="#FF6600">*</font><a href="javascript:setItemGubunCopy();">품목구분</a></th>
	                <th scope="col">품목코드</th>
	                <th scope="col">품목명</th>
	                <th scope="col">규격</th>
	                <th scope="col">단위</th>
	                <th scope="col">제조사</th>
	                <th scope="col">제고수량</th>
				</tr>
			</thead>
			<tbody>
<%
	if ( _gridList == null || _gridList.size() == 0) {
%>
				<tr>
		            <td colspan="7" align="center" height = "50">
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
		            <td title="체크박스">
		                <input type="checkbox" id="checkbox<%=j%>" name="checkbox">
		            </td>
		            <td title="품목구분">
						<select id="st_input_item_gubun" name="st_input_item_gubun">
							<option <%=("N".equals(rowData.get("ITEM_GUBUN"))? "selected" : "")%> value="N">&nbsp;&nbsp;&nbsp;일반&nbsp;&nbsp;&nbsp;</option>
							<option <%=("S".equals(rowData.get("ITEM_GUBUN"))? "selected" : "")%> value="S">&nbsp;&nbsp;&nbsp;재고&nbsp;&nbsp;&nbsp;</option>
						</select>
					</td>
		            <td title="품목코드">
		                <a class="hyperLink" href="javascript:getBuyerCatalogDisplayPop('<%=rowData.get("BUYER")%>','<%=rowData.get("BUYER_ITEM_NO")%>','<%=rowData.get("CONTRACT_NO")%>','<%=rowData.get("CONTRACT_SEQ")%>');">
							<%=rowData.get("BUYER_ITEM_NO")%>
							<input type="hidden" name="st_item_no" value="<%=rowData.get("BUYER_ITEM_NO")%>">
						</a>
		            </td>
		            <td class="left pl05" title="품목명">
		                <%=rowData.get("DESCRIPTION")%>
		            </td>
		            <td class="left pl05" title="규격">
		                <%=rowData.get("SPECIFICATION")%>
		            </td>
		            <td class="left pl05" title="단위">
		                <%=rowData.get("UNIT_MEASURE")%>
		            </td>
		            <td class="left pl05" title="제조사">
		                <%=rowData.get("MAKER_NAME")%>
		            </td>
		            <td class="right pr05" title="재고수량">
						<%=CommonUtil.formatNumber(rowData.get("STOCK_QTY"),true,0,3)%>
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
					<a href="javascript:doAction('save');">저장</a>
				</span>
            </div>
        </div>
	</form>

	<form name="processForm" id="processForm" method="post">
		<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" />
		<input type="hidden" name="total_cnt" id="total_cnt"  value="<%=total_cnt %>"/>
		<input type="hidden" name="curPage" id="curPage"  value="<%=curPage %>"/>
		<input type="hidden" name="onepagerow" id="onepagerow"  value="<%=onepagerow %>"/>
		<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
		<input type="hidden" name="st_user_dept" id="st_user_dept" value="${sessionInfo.department}">
		<div id="process">

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
	// TO-DO
}

var st;

// 기능함수
function doAction(str) {
	switch (str) {
		case "search": // 조회
			if ( !searchValidate() )
				return;
			kepSearch($("#curPage").val());
			break;

		case "reload": // 초기화
			kepReload("searchForm");
			break;

		case "save": // 저장
			var btnEvent = "save";

			// 그리드 데이터 셋팅
			if ( setGridData(btnEvent) ) {
				if ( !confirm("저장 하시겠습니까?") ) {
					return;
				}
				kepAjaxFormCall("/mpst/saveBuyerMpStStockGoodsList.do", "processForm", btnEvent);
			}
			break;
	}
}

// 조회
function kepSearch(curPage) {
	document.forms.searchForm.curPage.value = curPage;
	$('#searchForm').attr("action", "/mpst/getBuyerMpStStockGoodsList.do").submit();
}

// 조회조건 체크
function searchValidate() {
	var check_01 = $("#st_item_gubun").val();
	var check_02 = kepTrimStr($("#st_buyer_item_no").val());
	var check_03 = kepTrimStr($("#st_description").val());
	var check_04 = kepTrimStr($("#st_specification").val());
	
	if ( check_01 == 'T' && check_02 == '' && check_03 == '' && check_04 == '' ) {
		alert("조회 조건을 최소한 1개는 입력(선택)하여 주십시요.");
		return false;
	}

	return true;
}

// 상품구분 복사
function setItemGubunCopy() {
	var input_item_gubun = '';
	var tot_cnt = Number($("#display_item_cnt").val());
	var cnt = 0;

	if ( tot_cnt < 2 ) {
		return;
	} else {
		for ( var k = 0; k < tot_cnt; k++ ) {
			var box = eval("document.forms.contentForm.checkbox" + k);
			if ( box.checked == true ) {
				if ( cnt < 1 ) {
					input_item_gubun = document.forms.contentForm.st_input_item_gubun[k].value;
					cnt++;
				} else {
					document.forms.contentForm.st_input_item_gubun[k].value = input_item_gubun;
				}
			}
		}
	}
}

// 선택된 그리드 값을 셋팅
function setGridData(btnEvent) {
	var returnValue = true;
	var chkGridValue = {};

	var formArr = getFormToArr("document.forms.contentForm", true, chkGridValue);

	if ( formArr[0].length == 0 ) {
		alert("선택된 항목이 없습니다");
		returnValue = false;
	}

	if ( formArr != null && formArr != "" ) {
		document.forms.processForm.s_SAVENAME.value = formArr[0];
		$("#process").html(formArr[1]);
	} else {
		alert("그리드 데이터 변환에 실패하였습니다.[getFormToArr]");
		returnValue = false;
	}

	return returnValue;
}

// ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	var msg = response.msg;

	if ( msg != "" ) {
		alert(msg);
	}

	// 처리후 재조회
	kepSearch($("#curPage").val());
}
</script>
</html>
