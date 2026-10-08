<%--
**********************************************
* 메뉴 : 재고관리>공구자재 재고현황>공구자재 재고현황
* 화면 : 공구자재 재고현황
* 기능 : 
* 프로그램 ID : PG_08_A_602_00
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
	//--Test Setting Start
// 	String st_buyer_code = CommonUtil.nvl((String) request.getParameter("st_buyer_code"),"KRDOOD0001");  // 구매회사코드
// 	String st_buyer_name = CommonUtil.nvl((String) request.getParameter("st_buyer_name"),"두산중공업(주)");  // 구매회사명
	//--Test Setting End
	String st_buyer_code = CommonUtil.nvl((String) request.getParameter("st_buyer_code"),"");  // 구매회사코드
	String st_buyer_name = CommonUtil.nvl((String) request.getParameter("st_buyer_name"),"");  // 구매회사명
	String st_buyer_item_no = CommonUtil.nvl((String) request.getParameter("st_buyer_item_no"),"");  // 자재코드
	String st_description = CommonUtil.nvl((String) request.getParameter("st_description"),"");  // 품목명 
	String st_specification = CommonUtil.nvl((String) request.getParameter("st_specification"),"");  // 규격
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
	<h3>공구자재 재고현황</h3>
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
					<col width="26%" />
					<col width="8%" />
					<col width="14%" />
					<col width="8%" />
                    <col width="14%" />
					<col width="8%" />
                    <col width="14%" />
				</colgroup>
				
				<tbody>
					<tr>
						<th><font color="#FF6600">*</font>고객사</th>
						<td>
							<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:65%;ime-mode:active" value="<%=st_buyer_name%>" readOnly>
							<input type="hidden" name="st_buyer_code" id="st_buyer_code" value="<%=st_buyer_code%>">
							<a href="javascript:doPop('sellerMpStToolStockStatePop');"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
							<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
					    </td>
						<td>품목코드</td>
						<td>
							<input type="text" class="input_type_text" name="st_buyer_item_no" id="st_buyer_item_no" style="width:80%;" value="<%=st_buyer_item_no%>" onKeyDown="kepEnter()">
						</td>
						<td>품목명</td>
						<td>
							<input type="text" class="input_type_text" name="st_description" id="st_description" style="width:80%;" value="<%=st_description%>" onKeyDown="kepEnter()">
						</td>
						<td>규격</td>
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
	  	
		<table id="table_list"  class="cont_t_list02" style="width:100%">
			<colgroup>
	            <col width="2%" />
	            <col width="10%" />
	            <col width="12%" />
	            <col width="15%" />
	            <col width="*" />
	            <col width="8%" />
	            <col width="11%" />
	            <col width="11%" />
	        </colgroup>
	        <thead>
				<tr>
					<th scope="col">
						<input type="checkbox" name="check_status" id="check_status" value="선택"  style="cursor:hand;" onclick="javascript:kepCheckAll('<%=grid_cnt %>',document.forms.contentForm.check_status,'document.forms.contentForm.checkbox')">
					</th>
	                <th scope="col">고객사</th>
	                <th scope="col">품목코드</th>
	                <th scope="col">품목명</th>
	                <th scope="col">규격</th>
	                <th scope="col">단위</th>
	                <th scope="col">최종수정일</th>
	                <th scope="col">총재고수량</th>
				</tr>
			</thead>
			<tbody>
<%
	if ( _gridList == null || _gridList.size() == 0) {
%>
				<tr>
		            <td colspan="8" align="center" height = "50">
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
		                <input type="hidden" name="st_buyer" value="<%=rowData.get("BUYER")%>">
		                <input type="hidden" name="st_buyer_item_no" value="<%=rowData.get("BUYER_ITEM_NO")%>">
		                <input type="hidden" name="st_contract_no" value="<%=rowData.get("CONTRACT_NO")%>">
		                <input type="hidden" name="st_contract_seq" value="<%=rowData.get("CONTRACT_SEQ")%>">
		            </td>
		            <td class="left pl05" title="고객사">
		                <%=rowData.get("BUYER_NAME")%>
					</td>
		            <td class="left pl05" title="자재코드">
		                <%=rowData.get("BUYER_ITEM_NO")%>
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
					<td title="최종수정일">
		                <%=rowData.get("CHANGE_DATE")%>
					</td>
					<td class="right pr05" title="총재고수량">
						<input type="text" name="st_stock_qty_text" style="width:98%; text-align:right;" value="<%=CommonUtil.formatNumber(rowData.get("STOCK_QTY"),true,0,3)%>" onChange="checkNum(<%=j%>)" >
						<input type="hidden" name="st_stock_qty" value="<%=rowData.get("STOCK_QTY")%>">
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
        		<span class="btn_04">
					<a href="javascript:doAction('excelDown');">엑셀다운로드</a>
				</span>
			</div>
			<div class="fr">
				<span class="btn_04 mr04">
					<a href="javascript:doAction('save');">재고수량 저장</a>
				</span>	
				<span class="btn_04">
					<a href="javascript:doAction('delete');">재고품목 삭제</a>
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
			// 조회조건 체크
			if ( !searchValidate() )
				return;
			kepSearch($("#curPage").val());
			break;
			
		case "reload": //초기화
			kepReload("searchForm");
			// 구매회사 초기 셋팅
			$("#st_buyer_code").val("");
// 			kepSearch(-1);
			jspTableClean("table_list");
			break;
	
		case "save": // 저장	
			var btnEvent = "save";
			// 그리드 데이터 셋팅
			if ( setGridData(btnEvent) ) {
				if ( !confirm("입력된 재고수량으로 저장하시겠습니까?") ) { 
					return;
				} 
				kepAjaxFormCall("/mpst/saveSellerMpStToolStockStateList.do","processForm",btnEvent); 	
			}
			break;
	
		case "delete": // 삭제	
			var btnEvent = "delete";
			// 그리드 데이터 셋팅
			if ( setGridData(btnEvent) ) {
				if ( !confirm("해당 품목을 재고품목에서 삭제하시겠습니까?") ) {
					return;
				} 
				kepAjaxFormCall("/mpst/delSellerMpStToolStockStateList.do","processForm",btnEvent); 	
			}
			break;
		
		case "excelDown": // 엑셀다운로드
			document.forms.searchForm.action = "/mpst/excelSellerMpStToolStockStateList.do";
			document.forms.searchForm.submit();
// 			$('#searchForm').attr("action", "/mpst/excelSellerMpStToolStockStateList.do").submit();
			break;
	
	}
}

// 조회조건 체크
function searchValidate() {
	if ( kepTrim("st_buyer_code") == '' ) {
		alert("고객사를 선택해 주십시오");
		return false;
	}

	return true;
}

// 조회
function kepSearch(curPage) {
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mpst/getSellerMpStToolStockStateList.do").submit();   
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

	var st_stock_qty_text = kepTrimStr(kepFilterNum($("form[name=contentForm]").find("input[name=st_stock_qty_text]").eq(rowIndex).val()));
	var st_stock_qty = kepTrimStr(kepFilterNum($("form[name=contentForm]").find("input[name=st_stock_qty]").eq(rowIndex).val()));

	if ( kepIsValueNull(st_stock_qty_text) || !IsNumber3(st_stock_qty_text) ) {
		alert("재고등록 수량에 숫자를 입력해 주십시요");
		$("form[name=contentForm]").find("input[name=st_stock_qty_text]").eq(rowIndex).val('0');
		return;
	} else {
		$("form[name=contentForm]").find("input[name=st_stock_qty_text]").eq(rowIndex).val(kepCommaNum(st_stock_qty_text));
		$("form[name=contentForm]").find("input[name=st_stock_qty]").eq(rowIndex).val(st_stock_qty_text);
	}
}
  
// 팝업 함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "sellerMpStToolStockStatePop": // 거래고객사
			openSearchPopup("/mpst/showSellerMpStToolStockStatePop.do", '?agent='+$("#st_com_code").val(), "500,260,no");
			break;
	}
}

// 콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text){
	if ( popupSel = "sellerMpStToolStockStatePop" ) {
		$("#st_buyer_code").val(code);
		$("#st_buyer_name").val(text);
	}
}

// 선택된 그리드 값을 셋팅
function setGridData(btnEvent){
	var returnValue = true;
	var chkGridValue = {};
	var tot_cnt  = $("#display_item_cnt").val();
	
	if ( btnEvent == "save" ) { // 저장
		for ( var k = 0; k < tot_cnt; k++) {
			var box = eval("document.forms.contentForm.checkbox" + k + "");

            if ( box != null && box.checked == true ) {
				var chul_qty = kepTrimStr($("form[name=contentForm]").find("input[name=st_chul_qty]").eq(k).val());
				var tot_qty = kepTrimStr($("form[name=contentForm]").find("input[name=st_tot_qty]").eq(k).val());

				if ( chul_qty == "0" || ( chul_qty == null || chul_qty == "" ) ) {
					alert((k+1) + "번째 줄에 재고등록 수량이 입력되지 않았습니다.");
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
	
	if (msg != ""){
		alert(msg);
	}
	// 처리후 재조회
	kepSearch($("#curPage").val());
}


</script>
</html>
