<%--
**********************************************
* 메뉴 : 주문관리>주문진행현황>반품신청
* 화면 : 반품신청
* 기능 : 
* 프로그램 ID : PG_06_B_014_01
* 담당자 : 개발5 ( 설계 : 김상근 )
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
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = (String) request.getParameter("onepagerow");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
    
	// 조회조건 S
	String st_from_date = CommonUtil.nvl((String) request.getParameter("st_from_date"),"");  // 조회일(From)
	String st_to_date = CommonUtil.nvl((String) request.getParameter("st_to_date"),"");  // 조회일(To)
	String st_search_type = CommonUtil.nvl((String) request.getParameter("st_search_type"),"");  // 조회필드콤보
	String st_search_code = CommonUtil.nvl((String) request.getParameter("st_search_code"),"");  // 
	String st_btoa_user_dept_code = CommonUtil.nvl((String) request.getParameter("st_btoa_user_dept_code"),"");  // 요청부서코드
	String st_btoa_user_dept_name = CommonUtil.nvl((String) request.getParameter("st_btoa_user_dept_name"),"");  // 요청부서명
	String st_sourcing_status = CommonUtil.nvl((String) request.getParameter("st_sourcing_status"),"");  // 진행상태
	String st_quotation_no = CommonUtil.nvl((String) request.getParameter("st_quotation_no"),"");  // 견적번호
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
	<h3>반품신청</h3>
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
					<col width="8%" />
					<col width="25%" />
					<col width="9%" />
					<col width="25%" />
					<col width="8%" />
                    <col width="25%" />
				</colgroup>
				
				<tbody>
				<tr>
					<td>조회일</td>
					<td colspan="3">
						<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:100px; text-align:center;" value="<%=st_from_date%>">
							<a href="javascript:kepCalendar('st_from_date')"></a>
						&nbsp;~&nbsp;
						<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:100px; text-align:center;" value="<%=st_to_date%>">
							<a href="javascript:kepCalendar('st_to_date')"></a>
							&nbsp;&nbsp;
						<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
						<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span> 
						<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>
						<span class="btn_month"><a href="javascript:setCurMonth('st_from_date','st_to_date')">당월</a></span>							
					</td>
                       
				    <td>
                        <label for="b_code" class="hidden">품목명선택</label>
			  			<select name = "st_search_type" id="st_search_type" style="height:20px;">
				      		<option value="DE" <%if ("DE".equals(st_search_type)) {%>selected<%} %>>품목명</option>
				      		<option value="SP" <%if ("SP".equals(st_search_type)) {%>selected<%} %>>규격</option>
				      		<option value="BC" <%if ("BC".equals(st_search_type)) {%>selected<%} %>>품목코드</option>
                          </select>
                       </td>
					<td><input type="text" class="input_type_text" name="st_search_code" id="st_search_code" style="width:80%;" value="<%=st_search_code%>"/></td>
				</tr>
				<tr>
					<td>요청부서</td>
					<td>
						<input type="text" class="input_type_text" name="st_btoa_user_dept_name" id="st_btoa_user_dept_name" style="width:65%;ime-mode:active" value="<%=st_btoa_user_dept_name%>" READONLY>
						<input type="hidden" name="st_btoa_user_dept_code" id="st_btoa_user_dept_code" value="<%=st_btoa_user_dept_code%>">
						<a href="javascript:doPop('dept');"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
						<a href="javascript:kepEraser('st_btoa_user_dept_code','st_btoa_user_dept_name');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
					</td>
					<td>진행상태</td>
						<td>
                      <label for="b_delivery" class="hidden">진행상태선택</label>
                     	<select name="st_sourcing_status" id="st_sourcing_status" style="width:83%;height:20px;">
						          <option value="" <%if ("".equals(st_sourcing_status)) {%>selected<%} %>>전체</option>
						          <option value="의뢰결재중" <%if ("의뢰결재중".equals(st_sourcing_status)) {%>selected<%} %>>의뢰결재중</option>
						          <option value="의뢰반려" <%if ("의뢰반려".equals(st_sourcing_status)) {%>selected<%} %>>의뢰반려</option>
						          <option value="견적의뢰" <%if ("견적의뢰".equals(st_sourcing_status)) {%>selected<%} %>>견적의뢰</option>
						          <option value="견적진행중" <%if ("견적진행중".equals(st_sourcing_status)) {%>selected<%} %>>견적진행중</option>
						          <option value="단가합의대상" <%if ("단가합의대상".equals(st_sourcing_status)) {%>selected<%} %>>단가합의대상</option>
						          <option value="Nego견적의뢰" <%if ("Nego견적의뢰".equals(st_sourcing_status)) {%>selected<%} %>>Nego견적의뢰</option>
						          <option value="Nego진행중" <%if ("Nego진행중".equals(st_sourcing_status)) {%>selected<%} %>>Nego진행중</option>
						          <option value="Nego합의대상" <%if ("Nego합의대상".equals(st_sourcing_status)) {%>selected<%} %>>Nego합의대상</option>
						          <option value="결재진행중" <%if ("결재진행중".equals(st_sourcing_status)) {%>selected<%} %>>결재진행중</option>
						          <option value="결재반려" <%if ("결재반려".equals(st_sourcing_status)) {%>selected<%} %>>결재반려</option>
						          <option value="코드부여중" <%if ("코드부여중".equals(st_sourcing_status)) {%>selected<%} %>>코드부여중</option>
						          <option value="합의완료" <%if ("합의완료".equals(st_sourcing_status)) {%>selected<%} %>>합의완료</option>
						          <option value="장바구니" <%if ("장바구니".equals(st_sourcing_status)) {%>selected<%} %>>장바구니</option>
						          <option value="발주" <%if ("발주".equals(st_sourcing_status)) {%>selected<%} %>>발주</option>
						          <option value="견적취소" <%if ("견적취소".equals(st_sourcing_status)) {%>selected<%} %>>견적취소</option>
					        	</select>
                           </td>
						<td>견적번호</td>
						<td>
							<input type="text" class="input_type_text" name="st_quotation_no" id="st_quotation_no" style="width:80%;" value="<%=st_quotation_no%>" onkeyup="kepToUpper('st_quotation_no')" onKeyDown="kepEnter()">
						</td>
					</tr>
				</tbody>
			</table>
		</div>
 		
 		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
	      	<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow">
				<option value = "5" <%if ("5".equals(onepagerow)) {%>selected<%} %>>5건</option>
				<option value = "10" <%if ("10".equals(onepagerow)) {%>selected<%} %>>10건</option>
				<option value = "20" <%if ("20".equals(onepagerow)) {%>selected<%} %>>20건</option>
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
	            <col width="2%" />
	            <col width="4%" />
	            <col width="12%" />
	            <col width="8%" />
	            <col width="11%" />
	            <col width="*" />
	            <col width="7%" />
	            <col width="6%" />
	            <col width="8%" />
	            <col width="9%" />
	            <col width="8%" />
	        </colgroup>
	        <thead>
			<tr>
				<th scope="col">
					<input type="checkbox" name="check_status" id="check_status" value="선택"  style="cursor:hand;" onclick="kepCheckAll(document.forms.contentForm.display_item_cnt.value,document.forms.contentForm.check_status,'document.forms.contentForm.checkbox')">
				</th>
                <th scope="col">번호</th>
                <th scope="col">견적번호<br>진행상태</th>
                <th scope="col">순번<br>품목코드</th>
                <th scope="col">견적의뢰일<br>회신요청일</th>
                <th scope="col">품목명<br>규격</th>
                <th scope="col">단위<br>수량</th>
                <th scope="col">제조사<br>원산지</th>
                <th scope="col">견적단가<br>Nego단가</th>
                <th scope="col">협력사<br>KeP담당자</th>
                <th scope="col">요청자<br>요청부서</th>
			</tr>
		</thead>
		<tbody>
 		<%
        if (_gridList == null || _gridList.size() == 0){
        %>
                    <tr>
                        <td colspan="15" align="center" height = "50"> 
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
					<!-- HIDDEN 공통 -->
          
                     
  					<td rowspan ="2" class="font1_black1"  align="center"><input type="checkbox" name="checkbox">
					          <input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=_gridList.size() %>" >
	  				</td>
					<td rowspan ="2" class="font1_black1"  align="center"><%=((Integer.parseInt(curPage)-1)*Integer.parseInt(onepagerow))+(j+1) %></td>
                     
                    <td title="견적번호">
                     	<a class="hyperLink" href="javascript:doPop('quotationReDetailPop','<%=String.valueOf(rowData.get("R"))%>', '<%=String.valueOf(rowData.get("A"))%>', '<%=String.valueOf(rowData.get("S"))%>');"><b><%=String.valueOf(CommonUtil.nvl(rowData.get("A")))%></b></a>
                    </td>
                    <td title="순번"><%=String.valueOf(CommonUtil.nvl(rowData.get("B")))%></td>
                    <td title="견적의뢰일"><%=CommonUtil.formatStrinigDate(rowData.get("C"))%></td>
                    <td title="품목명"><%=String.valueOf(CommonUtil.nvl(rowData.get("D")))%></td>
                    <td title="단위"><%=String.valueOf(CommonUtil.nvl(rowData.get("E")))%></td>
                    <td title="제조사"><%=CommonUtil.formatStrinigDate(rowData.get("G"))%></td>
                    <td title="견적단가"><%=CommonUtil.formatNumber(String.valueOf(rowData.get("F")),true,0,3)%></td>
                    <td title="협력사"><a class="hyperLink" href="javascript:doPop('agent','<%=String.valueOf(rowData.get("T"))%>');"><%=String.valueOf(CommonUtil.nvl(rowData.get("U")))%></a></td>
                    <td title="요청자"><%=String.valueOf(CommonUtil.nvl(rowData.get("I")))%></td>
				</tr>
				<tr bgcolor="<%=tclass%>">
                    <td title="진행상태"><%=String.valueOf(CommonUtil.nvl(rowData.get("J")))%></td>
                    <td title="품목코드">
 	 				<a class="hyperLink" href="javascript:doPop('quotation_print','<%=String.valueOf(CommonUtil.nvl(rowData.get("L")))%>','<%=String.valueOf(rowData.get("M"))%>','<%=CommonUtil.nvl(String.valueOf(rowData.get("N")))%>','<%=String.valueOf(CommonUtil.nvl(rowData.get("O")))%>','<%=String.valueOf(CommonUtil.nvl(rowData.get("P")))%>');"><%=String.valueOf(CommonUtil.nvl(rowData.get("D")))%></a>
                    </td>
                    <td title="회신요청일">
                        <b><%=CommonUtil.formatStrinigDate(rowData.get("L"))%></b>
                    </td>
                    <td title="규격"><%=String.valueOf(CommonUtil.nvl(rowData.get("M")))%></td>
                    <td title="수량"><%=CommonUtil.formatNumber(String.valueOf(rowData.get("N")),true,0,0)%></td>
                    <td title="원산지"><%=String.valueOf(CommonUtil.nvl(rowData.get("Y")))%></td>
                    <td title="Nego단가"><%=CommonUtil.formatNumber(String.valueOf(rowData.get("O")),true,0,3)%></td>
                    <td title="KeP담당자"><a class="hyperLink" href="javascript:doPop('kepManagerPop','<%=String.valueOf(rowData.get("V"))%>');"><%=String.valueOf(CommonUtil.nvl(rowData.get("W")))%></a></td>
                    <td title="요청부서"><%=String.valueOf(CommonUtil.nvl(rowData.get("Q")))%></td>
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
				<span class="btn_03 mr04">
					<a href="javascript:doAction('printPum');">견적서출력</a>
				</span>
			</div>
			<div class="fr">
				<span class="btn_04">
					<a href="javascript:doAction('cartCheck');">저장</a>
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
//기능함수
function doAction(str) {
	switch (str) {
	case "search":	 //조회
		kepSearch($("#curPage").val());
		break;
		
	case "reload":	//초기화
		kepReload("searchForm");
		// 조회일 초기 셋팅
		kepSetCalender("st_from_date");
		kepSetCalender("st_to_date");
		
		$("#st_from_date").val( kepToMonthAdd("1","M"));
		$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));   
		break;

	case "excelDown": // 엑셀다운로드
		document.forms.searchForm.action = "/mpso/excelBuyerMpSoReturnReqList.do";
		document.forms.searchForm.submit();
// 		$('#searchForm').attr("action", "/mpso/excelBuyerMpSoReturnReqList.do").submit();
		break;

	case "cartCheck": // 저장	
		var btnEvent = "cartCheck";
		// 그리드 데이터 셋팅
		if(setGridData(btnEvent)){
			if(!confirm("이동 하시겠습니까?")){ 
				return;
			} 
			kepAjaxFormCall("/mpso/saveBuyerMpSoReturnReqList.do","processForm",btnEvent); 	
		}
		break;
	
	case "printPum": // 견적서 출력
		alert("견적서 출력");
		break;
	
	}
}

// 조회
function kepSearch(curPage){
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mpso/getBuyerMpSoReturnReqList.do").submit();   
}
  
// 팝업 함수호출
function doPop(str,value1, value2, value3, value4, value5) {
	switch (str) {
	case "dept": // 요청부서
		popupSel = "dept";
		openSearchPopup("/common/deptCodeAdminPop.do");
		break;
	case "quotationReDetailPop": // 견적번호
		openSearchPopup("/common/mprq/quotationReDetailPop.do", "?buyer="+value1+"&quotation_no="+value2+"&revision="+value3, "1020,500,no");
		break;
	case "agent": // 협력사
		openSearchPopup("/common/agentInfoDisplayPop.do", "?st_com_code="+value1, "800,550,no");
		break;
	case "kepManagerPop": // KeP담당자
		openSearchPopup("/common/kepManagerPop.do", "?st_user_id="+value1, "430,194,no");
		break;
	case "quotation_print": // 품목코드 클릭시 출력물 연결
		alert("출력물 연결 필요");
		break;
	}
}

// 콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text){
	if (popupSel = "dept") {
		$("#st_btoa_user_dept_code").val(code);
		$("#st_btoa_user_dept_name").val(text);
	}
}

// 선택된 그리드 값을 셋팅
function setGridData(btnEvent){
	var returnValue = true;

	var chkGridValue = {
			keys : ["st_status"] ,
			value0 : ["합의완료", "장바구니"],
			msg0 : ["합의완료된 품목들만 장바구니에 담을수 있습니다."]
	};

	var formArr = getFormToArr("document.forms.contentForm",true, chkGridValue );
	if(formArr != null && formArr !=""){
		document.forms.processForm.s_SAVENAME.value =formArr[0];
		$("#process").html(formArr[1]);
	}else{
		alert("그리드 데이터 변환에 실패하였습니다.[getFormToArr]");
		returnValue = false;
	}

	return returnValue;
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
