<%--
**********************************************
* 메뉴 : 재고관리>재고관리>재고조정
* 화면 : 재고조정
* 기능 : 
* 프로그램 ID : PG_08_B_503_00
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
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
	int grid_cnt = (_gridList != null )? _gridList.size() : 0;
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = (String) request.getParameter("onepagerow");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.

	// 조회조건 S
	String st_buyer_item_no = CommonUtil.nvl((String) request.getParameter("st_buyer_item_no"),"");  // 품목코드
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
	<h3>재고조정</h3>

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
		<input type="hidden" name="st_user_dept" id="st_user_dept" value="${sessionInfo.department}">

		<div id="cont_searchA">
			<table class="cont_t_list01" >
				<caption>조회</caption>
				<colgroup>
					<col width="8%" />
					<col width="25%" />
					<col width="8%" />
					<col width="25%" />
					<col width="8%" />
                    <col width="25%" />
				</colgroup>

				<tbody>
					<tr>
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
	            <col width="*" />
	            <col width="12%" />
	            <col width="12%" />
	            <col width="12%" />
	            <col width="20%" />
	        </colgroup>
	        <thead>
				<tr>
					<th scope="col">
						<input type="checkbox" name="check_status" id="check_status" value="선택"  style="cursor:hand;" onclick="javascript:kepCheckAll('<%=grid_cnt %>',document.forms.contentForm.check_status,'document.forms.contentForm.checkbox')">
					</th>
	                <th scope="col">품목코드</th>
	                <th scope="col">품목명<br>규격</th>
	                <th scope="col">제조사<br>단위</th>
	                <th scope="col">재고 + 조정수량<br>구매단가</th>
	                <th scope="col"><font color="#FF6600">*</font>조정수량<br>조정금액</th>
	                <th scope="col"><font color="#FF6600">*</font>조정자명<br>비고</th>
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
		            <td rowspan="2" title="체크박스">
		                <input type="checkbox" id="checkbox<%=j%>" name="checkbox">
		            </td>
		            <td rowspan="2" title="품목코드">
		                <a class="hyperLink" href="javascript:getBuyerCatalogDisplayPop('<%=rowData.get("BYCA_COMORG_CODE")%>','<%=rowData.get("ITEM_NO")%>','<%=rowData.get("CONTRACT_NO")%>','<%=rowData.get("CONTRACT_SEQ")%>');">
							<%=rowData.get("ITEM_NO")%>
							<input type="hidden" name="st_item_no" value="<%=rowData.get("ITEM_NO")%>">
						</a>
					</td>
		            <td class="left pl05" title="품목명">
		                <%=rowData.get("DESCRIPTION")%>
		            </td>
		            <td class="left pl05" title="제조사">
		                <%=rowData.get("MAKER_CODE")%>
		            </td>
		            <td class="right pr05" title="재고수량">
						<%=CommonUtil.formatNumber(rowData.get("TOT_QTY"),true,0,3)%>
						<input type="hidden" name="st_tot_qty" value="<%=rowData.get("TOT_QTY")%>">
					</td>
					<td class="right pr05" title="조정수량">
						<input type="text" name="st_view_chul_qty" style="width:98%; padding-right:1px; text-align:right;" value="" onChange="checkNum(<%=j%>)" >
						<input type="hidden" name="st_chul_qty" value="">
					</td>
					<td class="left pl05" title="조정자명">
						${sessionInfo.userNameLoc}
					</td>
				</tr>
	            <tr align="center" bgcolor="<%=tclass%>">
		        	<td class="left pl05" title="규격">
		            	<%=rowData.get("SPECIFICATION")%>
		            </td>
		            <td class="left pl05" title="단위">
		                <%=rowData.get("UNIT_MEASURE")%>
		            </td>
		            <td class="right pr05" title="구매단가">
						<%=CommonUtil.formatNumber(rowData.get("TARGET_PRICE"),true,0,3)%>
						<input type="hidden" name="st_unit_price" value="<%=rowData.get("TARGET_PRICE")%>">
					</td>
					<td class="right pr05" title="조정금액">
						<span id="st_chul_amt<%=j%>"></span>
					</td>
					<td class="left pl05" widthtitle="조정사유">
						<input type="text" name="st_remark" maxlength="50" style="width:98%;">
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
			kepSearch($("#curPage").val());
			break;

		case "reload": // 초기화
			kepReload("searchForm");
			break;

		case "save": // 저장
			var btnEvent = "save";

			// 그리드 데이터 셋팅
			if ( setGridData(btnEvent) ) {
				if ( !confirm("선택한 목록을 재고조정처리 하시겠습니까?") ) {
					return;
				}
				kepAjaxFormCall("/mpst/saveBuyerMpStStockAdjustList.do", "processForm", btnEvent);
			}
			break;
	}
}

// 조회
function kepSearch(curPage) {
	document.forms.searchForm.curPage.value = curPage;
	$('#searchForm').attr("action", "/mpst/getBuyerMpStStockAdjustList.do").submit();
}

// 숫자여부를 음수 입력가능하도록 검사.
function IsNumber3(num) {
	var i;
	pcnt = 0;
	pcnt2 = 0;

	if ( num.length == 1  && num.charAt(i) == '-' ) {
		return false;
	}

	for ( var i=0; i < num.length; i++) {
		if ( num.charAt(i) == '.' ) {
			pcnt ++;
		}
		if ( num.charAt(i) == '-' ) {
			pcnt2 ++;
		}

		if( (num.charAt(i) < '0' && num.charAt(i) != '-') || num.charAt(i) > '9' || num.charAt(i) == '.' ||  pcnt>1 ||  pcnt2>1 ) {
			return false;
		}
	}

 return true;
}

// Validation - 조정수량
function checkNum(rowIndex) {
	var cul_qty = 0;
	var unit_price = 0;
	var tot_cnt  = $("#display_item_cnt").val();

	var chul_qty = kepTrimStr(kepFilterNum($("form[name=contentForm]").find("input[name=st_view_chul_qty]").eq(rowIndex).val()));
	var unit_price = kepTrimStr(kepFilterNum($("form[name=contentForm]").find("input[name=st_unit_price]").eq(rowIndex).val()));

	if ( kepIsValueNull(chul_qty) || !IsNumber3(chul_qty) ) {
		alert("조정수량에 숫자를 입력해 주십시요");
		$("form[name=contentForm]").find("input[name=st_view_chul_qty]").eq(rowIndex).val('0');
		$("form[name=contentForm]").find("input[name=st_chul_qty]").eq(rowIndex).val('0');
		$("#st_chul_amt"+rowIndex).text('0');
		return;
	} else {
		$("form[name=contentForm]").find("input[name=st_view_chul_qty]").eq(rowIndex).val(kepCommaNum(chul_qty));
		$("form[name=contentForm]").find("input[name=st_chul_qty]").eq(rowIndex).val(chul_qty);
		$("#st_chul_amt"+rowIndex).text(kepCommaNum(Number(chul_qty)*Number(unit_price)));
	}
}

// 선택된 그리드 값을 셋팅
function setGridData(btnEvent) {
	var returnValue = true;
	var chkGridValue = {};
	var tot_cnt  = $("#display_item_cnt").val();

	if ( btnEvent == "save" ) { // 저장
		for ( var k = 0; k < tot_cnt; k++) {
			var box = eval("document.forms.contentForm.checkbox" + k + "");

            if ( box != null && box.checked == true ) {
				var chul_qty = kepTrimStr($("form[name=contentForm]").find("input[name=st_chul_qty]").eq(k).val());
				var tot_qty = kepTrimStr($("form[name=contentForm]").find("input[name=st_tot_qty]").eq(k).val());
// 				alert(tot_qty + " : " + chul_qty);

				if ( chul_qty == "0" || ( chul_qty == null || chul_qty == "" ) ) {
					alert((k+1) + "번째 줄에 조정수량이 입력되지 않았습니다.");
					return false;
				}

				if ( eval(chul_qty) > eval(tot_qty) ) {
					alert((k+1) + "번째 줄에 조정수량이 재고수량보다 많게 입력되었습니다.");
					return false;
				}
            }
		}
	}

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
