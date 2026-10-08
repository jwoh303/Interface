<%--
**********************************************
* 메뉴 : 출고지시
* 화면 : 
* 기능 : 
* 프로그램 ID : 
* 담당자 : 
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="../../common/include/head.jspf"%>
</head>
<%
	String row_cnt = "";
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	if (sessionInfo != null){ 
		row_cnt = CommonUtil.nvl((String)sessionInfo.getRowCnt()); //20070704 추가 페이지 기본 개수
	}  
	String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),row_cnt);  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
%>
<body onload="kep_onload_view()">
	<div id="wrapper">
		<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp"%>
		
			<c:import charEncoding="utf-8" url="/menu/menu.do">
				<c:param name="page" value="buyerLeft" />
				<c:param name="part" value="${param.upperId}" />
			</c:import>
			<c:set var="total_cnt" value='0' />
			<c:set var="CheckDate" value='<%=CommonUtil.addDate(new Date(), "D", 1, 1) %>' />
			<c:forEach items="${data }" var="_gridList" begin="1" end="1">
				<c:set var="total_cnt" value='${_gridList.TOTNUM }' />
			</c:forEach>
			<c:set var="curPage" value='${(curPage==null)?"1":curPage }' />
			<c:set var="fromDate" value='' />
			<c:set var="toDate" value='' />
			<c:set var="st_from_date" value='${st_fromDate }' />
			<c:set var="st_to_date" value='${st_to_date }' />
			<c:if test='${st_from_date == null || st_from_date == "" }'>
				<c:set var="fromDate" value='<%=CommonUtil.addDate(new Date(), "M", -1, 1) %>' />
				<c:set var="toDate" value='<%=CommonUtil.getCurrentDay_Time("yyyyMMdd") %>' />
			</c:if>
			<c:if test='${!(st_from_date == null || st_from_date == "") }'>
				<c:set var="toDate" value='${st_to_date }' />
			</c:if>
			<c:set var="rowNumber" value='0' />
			<div id="container2">
			<div id="ContArea">
				<h3>출고지시(코웨이)</h3>
				<div id="searchBtnA">
					<span class="btn_search"><a href="javascript:doAction('search');">조회</a></span>
					<span class="btn_reset"><a href="javascript:doAction('reload');">초기화</a></span>
				</div>
				<form name="searchForm" id="searchForm" method="post">
					<input type="hidden" id="upperId" name="upperId" value="<c:out value="${param.upperId}"/>">
					<input type="hidden" id="curPage" name="curPage" value="${curPage }" />
					<input type="hidden" id="st_com_code" name="st_com_code" value="${sessionInfo.comCode}">
					<input type="hidden" id="st_dept" name="st_dept" value="${sessionInfo.department}">
					<input type="hidden" id="st_user_id" name="st_user_id" value="${sessionInfo.userId}">
					<input type="hidden" id="moveToMaster" name="moveToMaster" value="${moveToMaster }">
					<input type="hidden" id="st_from_date" name="st_from_date" value="">
					<input type="hidden" id="st_to_date" name="st_to_date" value="">
					<input type="hidden" id="st_screen_id" name="st_screen_id" value="1">
					<input type="hidden" id="I_KEY" name="I_KEY" value="D" />
					<div id="cont_searchA">
						<table class="cont_t_list01">
							<caption>조회</caption>
							<colgroup>
								<col width="20%" />
								<col width="30%" />
								<col width="20%" />
								<col width="30%" />
							</colgroup>
							<tbody>
								<tr>
									<th>요청승인일자</th>
									<td>
										<input type="text" size="11" id="from_date" name="from_date" value="" readonly="readonly" />
										 ~ 
										<input type="text" size="11" id="to_date" name="to_date" value="" readonly="readonly" />
									</td>
									<th>조직명</th>
									<td colspan="3">
										<input type="text" name="I_ORGEH" id="I_ORGEH" style="width:90%" value="" />
									</td>
								</tr>
								<tr>
									<th>요청코드</th>
									<td>
										<input type="text" name="I_RE_MBLNR" id="I_RE_MBLNR" style="width:75%" value="" />
									</td>
									<th>처리상태</th>
									<td>
										<select name="I_RESTATUS" id="I_RESTATUS" >
											<option <c:out value='${(I_RESTATUS == "N") ? "selected" : "" }' /> value="N">미처리</option>
											<option <c:out value='${(I_RESTATUS == "Y") ? "selected" : "" }' /> value="Y">처리</option>
										</select>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top: 3px;" />
						<label for="b_no02" class="hidden">정렬개수선택</label>
						<select name="onepagerow">
						<option <%=("50".equals(onepagerow) ? "selected" : "")%> value = "50">50건</option>
						<option <%=("100".equals(onepagerow) ? "selected" : "")%> value = "100">100건</option>
						<option <%=("1000".equals(onepagerow) ? "selected" : "")%> value = "1000">1000건</option>
						</select> 
					</span>
					<br/>
				</form>
				<form name="contentForm" id="contentForm" method="post">
					<input type="hidden" name="curPage" id="curPage" value="${curPage }" />
					<input type="hidden" name="st_selected_row" id="st_selected_row" value="" />
					<table id="table_list" class="cont_t_list02" style="width: 100%">
						<colgroup>
							<col width="3%" />
							<col width="20%" />
							<col width="10%" />
							<col width="10%" />
							<col width="20%" />
							<col width="20%" />
							<col width="20%" />
						</colgroup>
						<thead>
							<tr>
								<th scope="col"><input type="checkbox" name="checkAll" id="checkAll" value="" onclick="javascript:checkAll1();" /></th>
								<th scope="col">요청번호</th>
								<th scope="col">구분</th>
								<th scope="col">요청일</th>
								<th scope="col">조직장</th>
								<th scope="col">조직명</th>
								<th scope="col">KEP주문번호</th>
							</tr>
						</thead>
						<tbody>
							<c:choose>
								<c:when test="${data == null || fn:length(data) == 0}">
									<tr>
										<td colspan="15" align="center" height="50">
											<span>조회된 데이타가 없습니다.</span>
										</td>
									</tr>
								</c:when>
								<c:when test="${fn:length(data) > 0}">
									<c:set var="tclass" value='#FFFFFF' />
									<c:forEach items="${data}" var="_gridList" varStatus="status">
										<c:set var="total_cnt" value='${_gridList.TOTNUM }' />
										<c:set var="rowNumber" value='${status.index }' />
										<c:if test='${rowNumber % 2 != 0 }' >
											<c:set var="tclass" value="#FAFAFA"/>
										</c:if>
										<c:if test='${rowNumber % 2 == 0 }' >
											<c:set var="tclass" value="#FFFFFF"/>
										</c:if>
										<tr align="center" bgcolor="${tclass }" height="25" >
											<td title="체크박스" width="7%">
												<input type="checkbox" name="checkbox${rowNumber }" id="check" value="${_gridList.MBLNR }" />
											</td>
											<td title="요청번호" width="24%">
												<c:choose>
													<c:when test="${_gridList.PR_NO != ''}">
														<a href="#" onClick="doPop('','getBuyerMdAmGiCowayDetailPop', '${rowNumber}', '${_gridList.MBLNR }', '${_gridList.MATNR }', '${_gridList.ORGEH }');">
																<c:out value="${_gridList.MBLNR }"/>(<c:out value="${_gridList.MATNR }"/>)
														</a>
													</c:when>
													<c:otherwise>
															<c:out value="${_gridList.MBLNR }"/>
													</c:otherwise>
												</c:choose>
											</td>
											<td title="구분" class="center">
												<c:out value="지급"/>
											</td>
											<td title="요청일" class="center">
												${_gridList.ERSDA }
											</td>
											<td title="조직장" class="center">
												${_gridList.ENAME }
											</td>
											<td title="조직명" class="left">
												${_gridList.STEXT }
											</td>
											<td title="KEP요청번호" class="left">
												<c:choose>
													<c:when test="${_gridList.MBLNR_PREFIX != '20' }">
														<a href="#" onClick="getPrDisplayPop('${_gridList.BUYER }','${_gridList.PR_NO }' ,'','PR_LIST_IN');">
															${_gridList.PR_NO }
														</a>
													</c:when>
													<c:otherwise>
														<a href="#" onClick="javascript:alert('이전 시스템에서 넘어온 요청번호입니다.')">
															<c:out value="-" />
														</a>
													</c:otherwise>
												</c:choose>
											</td>
										</tr>
									</c:forEach>
								</c:when>
							</c:choose>
						</tbody>
					</table>
				<%	if (_gridList != null && _gridList.size() > 0){	%>
							 <input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=_gridList.size() %>" >
				<%	}	%>
					<p id="paging" class="paging">
						<%=CommonUtil.getPageView("kepSearch", Integer.parseInt(pageContext.getAttribute("total_cnt").toString()), (pageContext.getAttribute("curPage") == null) ? "0" : (String) pageContext.getAttribute("curPage"),onepagerow)%>
						<span class="cl">[ 총 <c:out value="${total_cnt }" /> 건 ]</span>
					</p>
					<div class="btnArea">
						<div class="fr">
							<span class="btn_04" id="btnGi" style="display:"> 
								<a href="javascript:doAction('insertGI');">출고확정</a>
							</span>
							<span class="btn_04" id="btnExcelDown" style="display:">
								<a href="javascript:doAction('excelDown');">엑셀다운로드</a>
							</span>
						</div>
					</div>
				</form>
				<form name="processForm" id="processForm" method="post">
					<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" />
					<input type="hidden" name="total_cnt" id="total_cnt" value="${total_cnt }" />
					<input type="hidden" name="curPage" id="curPage" value="${curPage }" />
					<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode }" />
					<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId }" />
					<input type="hidden" name="st_buyer_code" id="st_buyer_code" value="" />
					<input type="hidden" name="st_mblnr" id="st_mblnr" value="">
					<input type="hidden" name="st_key" id="st_key" value="">
					<input type="hidden" name="st_from_date" id="st_from_date" value="">
					<input type="hidden" name="st_to_date" id="st_to_date" value="">
					<input type="hidden" name="st_screen_id" id="st_screen_id" value="1">
				</form>
				
				<form name="popForm" id="popForm" method="post">
					<input type="hidden" name="st_pop_user_id" id="st_pop_user_id" value="${sessionInfo.userId }">
					<input type="hidden" name="st_pop_mblnr" id="st_pop_mblnr" value="">
					<input type="hidden" name="st_pop_matnr" id="st_pop_matnr" value="">
					<input type="hidden" name="st_pop_orgeh" id="st_pop_orgeh" value="">
				</form>
			</div>
		</div>
	</div>
</body>
<script type="text/javascript">
var popupSel = "";
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";

$(document).ready(function(){
	
	$('#I_RESTATUS').change(function(){
		$('#I_RESTATUS option:selected').each(function(){
			if ( $(this).val() == "Y" ) {
				$('#btnGi').css("display","none");
				$('#btnExcelDown').css("display","none");
			} else {
				$('#btnGi').css("display","");
				$('#btnExcelDown').css("display","");
			}
		});
	});
});

// 최초 화면 함수 
function kep_onload_view(){
	//조회조건 초기화(기존값 재설정)
	initSearchCondition("searchForm", "from_date", "${from_date}");
	initSearchCondition("searchForm", "to_date", "${to_date}");
	initSearchCondition("searchForm", "I_ORGEH", "${I_ORGEH}");
	initSearchCondition("searchForm", "I_RE_MBLNR", "${I_RE_MBLNR}");
	initSearchCondition("searchForm", "I_RESTATUS", "${I_RESTATUS}");
	initSearchCondition("searchForm", "I_KEY", "${I_KEY}");
	
	kepSetCalender("from_date");
	kepSetCalender("to_date");
	if('${from_date}' == '')
		$("#from_date").val( kepToMonthAdd("1","M"));
	if('${to_date}' == '')
	$("#to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
	$("#I_ORGEH").val('${I_ORGEH }');
	$("#I_RE_MBLNR").val('${I_RE_MBLNR }');
	
}

var st;
//기능함수
function doAction(str) {
	var btnEvent = str;
	switch (str) {
	case "search":	 //조회
		checkDate();
		kepSearch($("#curPage").val());
		break;
		
	case "reload":	//초기화
		initSearchCondition("searchForm", "from_date", "${from_date}");
		initSearchCondition("searchForm", "to_date", "${to_date}");
		initSearchCondition("searchForm", "I_ORGEH", "${I_ORGEH}");
		initSearchCondition("searchForm", "I_RE_MBLNR", "${I_RE_MBLNR}");
		initSearchCondition("searchForm", "I_RESTATUS", "${I_RESTATUS}");
		initSearchCondition("searchForm", "I_KEY", "${I_KEY}");
		
		kepSetCalender("from_date");
		kepSetCalender("to_date");
		$("#from_date").val( kepToMonthAdd("1","M"));
		$("#to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
		$("#I_ORGEH").val('${I_ORGEH }');
		$("#I_RE_MBLNR").val('${I_RE_MBLNR }');
		break;

	case "excelDown": // 엑셀다운로드
		giExcelDownload();
		break; 

	case "insertGI" :
		var v_check_value = "";
		var rCnt = 0;
		var totalCnt = $('#display_item_cnt').val();
		for(var i=0; i<totalCnt; i++){
			var i_checked = eval("document.contentForm.checkbox"+i+".checked");
			var i_check_value = eval("document.contentForm.checkbox"+i+".value");
			if(i_checked==true){
				if(v_check_value.indexOf(i_check_value)<0){
					v_check_value = i_check_value +"@@"+v_check_value;
				}
				rCnt++;
			}
		}
		if(rCnt > 0){
			document.processForm.st_key.value = 'D';
			document.processForm.st_mblnr.value = v_check_value;
			kepAjaxFormCall("/mdam/saveBuyerMdAmGiCowayList.do","processForm","SaveInfo");
		} else {
			alert('출고확정건을 선택하세요.');
			return;
		} 
		break;
	}
}

// 조회
function kepSearch(curPage){
	checkDate();
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mdam/getBuyerMdAmGiCowayList.do").submit();   
}
  
// 팝업 함수호출
var gridIndex = 0;
var grbRow = "";
function doPop(idx, str, value1, value2, value3, value4, value5) {
	popupSel = str;
	gridIndex =idx;
	
	switch (str) {
	case "getBuyerMdAmGiCowayDetailPop": // 비고

		document.forms.popForm.st_pop_mblnr.value = value2;
		document.forms.popForm.st_pop_matnr.value = value3;
		document.forms.popForm.st_pop_orgeh.value = value4;
		
		openSearchPopupPost("/mdam/getBuyerMdAmGiCowayDetailPop.do", 'popForm', 'getBuyerMdAmGiCowayDetailPop', "width=700,height=800,resizable=no,scrollbars=no, top=0, left=0");
		break;
	}
}

// 콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2,value3,value4,value5){
//  	alert(gridIndex+"::"+value1+"::"+value2+"::"+value3+"::"+value4+"::"+value5);
	if (popupSel == "icomcmpyPop"){
		$("#st_buyer").val(value1);
		$("#st_buyer_name").val(value2);
		$("#st_dept_code").val('');
		$("#st_dept_name").val('');
	}else if(popupSel == "remarkReturn2Pop"){
		 $("input[name=st_remark]").eq(gridIndex).val(value1);
		 if(value1 ==""){
	 		$("img[id=st_remark_img]").eq(gridIndex).attr("src",remarkOff);
	 	 }else{
	 		$("img[id=st_remark_img]").eq(gridIndex).attr("src",remarkOn);
	 	 }
	}
}

// ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	var msg = response.rfcMsg.MESSAGE;
	var code = response.rfcMsg.MSGTYPE;
	
	if(code == 'S')
		alert('촐고확정처리에 성공하였습니다.\n'+msg);
	else if (code == 'T') {
		excelDown();
		
		return;
	}
	else 
		if(msg == 'NO RESULT')
			alert('출고처리대상 데이터가 SAP에 존재하지 않습니다.');
		else
			alert('작업(SAP)에 실패 하였습니다.\n'+msg);
	// 처리후 재조회
	kepSearch($("#curPage").val());
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	if(pMethod != 'excelDown') {
		alert("처리중 오류가 발생 하였습니다.\n\n확인 후 다시 시도하여 주십시요");
	}
} 
function checkDate(){
	var v_f_date = document.searchForm.from_date.value;
	var v_t_date = document.searchForm.to_date.value;
	v_f_date = v_f_date.replace("-","");
	v_f_date = v_f_date.replace("-","");
	v_t_date = v_t_date.replace("-","");
	v_t_date = v_t_date.replace("-","");
	document.searchForm.st_from_date.value = v_f_date;
	document.searchForm.st_to_date.value = v_t_date;
}

function getPrDisplayPop(BUYER,PR_NO,RECV_FLAG,VALUE2){ 
	openSearchPopup('/mpiv/showCommonMpIvOdrreqDetailPop.do','?openYn=Y&PR_NO='+PR_NO+'&RECV_FLAG='+RECV_FLAG , "800,600,no"); 
}

function giExcelDownload(){
	checkDate();
	var v_check_value = "";
	var totalCnt = $('#display_item_cnt').val();
	var checkCnt = 0;
	for(var i=0; i<totalCnt; i++){
		var i_checked = eval("document.contentForm.checkbox"+i+".checked");
		var i_check_value = eval("document.contentForm.checkbox"+i+".value");
		if(i_checked==true){
			if(v_check_value.indexOf(i_check_value)<0){
				v_check_value = i_check_value +"@@"+v_check_value;
			}
			checkCnt++;
		}
	}
	if(checkCnt > 0){
		document.processForm.st_mblnr.value = v_check_value;
		document.processForm.st_from_date.value = document.searchForm.st_from_date.value;
		document.processForm.st_to_date.value = document.searchForm.st_to_date.value;
		kepAjaxFormCall("/mdam/getBuyerMdAmGiCowayExcelInfo.do","processForm","ExcelInfo");
	} else {
		alert('데이터를 선택하세요.');
		return;
	}
}

function excelDown() {
	
	document.processForm.st_from_date.value = document.searchForm.st_from_date.value;
	document.processForm.st_to_date.value = document.searchForm.st_to_date.value;
	document.forms.processForm.action = "/mdam/getExcelBuyerMdAmGiCowayList.do";
	document.forms.processForm.submit();
}

function checkAll1(){
	var checkAllFlag = $('input:checkbox[id="checkAll"]').is(":checked");
	$('input:checkbox[id="check"]').each(function(){
		this.checked = checkAllFlag;
	});
}
</script>
</html>
