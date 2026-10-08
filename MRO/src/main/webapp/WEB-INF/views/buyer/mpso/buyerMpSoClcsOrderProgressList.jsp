<%--
**********************************************
* 메뉴 : 주문관리>주문진행현황
* 화면 : 주문진행현황
* 기능 : 주문한 내역의 목록및 상태를 파악하고 상세정보를 확인할 수 있다.
* 프로그램 ID : PG_06_B_014_00
* 담당자 : CEJ ( 설계 : 김지현 )
* 착수일 : 2014-07-11
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf" %>
</head>
<%
	// 공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지 (필수) 
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");	
	String budget_flag		  = sessionInfo.getBudgetFlag();
	
	String fromDate = "";
	String toDate	= "";
	String sortType = CommonUtil.nvl(request.getParameter("st_sortType"),"DESC");
	if (sortType == null || "".equals(sortType)){
		sortType = "DESC";
	}
	fromDate		= CommonUtil.nvl((String) request.getParameter("fromDate"),"");
	if( fromDate.equals("")){
		toDate	 =  CommonUtil.formatDateNoDateGubun(new Date(),1);
		fromDate	= CommonUtil.addDate(new Date(),"M",-1,1);
	}else{
		toDate	= CommonUtil.nvl((String) request.getParameter("toDate"),"");
	}	
	fromDate = fromDate.replace("/", "");
	toDate = toDate.replace("/", "");  
	String from_year  = fromDate.substring(0,4);
	String from_month = fromDate.substring(4,6);
	String from_day	= fromDate.substring(6,8);
	String v_fromDate  = from_year+"/"+from_month+"/"+from_day;
	String to_year  = toDate.substring(0,4);
	String to_month = toDate.substring(4,6);
	String to_day	= toDate.substring(6,8);
	String v_toDate  = to_year+"/"+to_month+"/"+to_day;
	String SessionComCode		= sessionInfo.getComCode();
	String SessionUserId		 = sessionInfo.getUserId();
	String row_cnt = sessionInfo.getRowCnt();
	String img_view_flag = sessionInfo.getImgViewFlag(); // 20070704 이미지보기 우선여부
	String pr_no		 = CommonUtil.nvl((String) request.getParameter("st_pr_no"),"ALL"); 
	String legacy_po_no = CommonUtil.nvl((String) request.getParameter("st_legacy_po_no"),"ALL");
	String ref_no		= CommonUtil.nvl((String) request.getParameter("st_ref_no"),"ALL"); 
	String search_type  = CommonUtil.nvl((String) request.getParameter("st_search_type"),"");
	String search_no = CommonUtil.nvl((String) request.getParameter("st_search_no"),"");
	if(search_no.equals(""))
	{
	  search_type = "BC";
	  search_no = "ALL";
	}
	// 진행상태
	String status		= CommonUtil.nvl((String) request.getParameter("st_status"),"ALL");
 //파트유닛
	String unitPart		= CommonUtil.nvl((String) request.getParameter("st_unit_part"),"ALL");
	// HTML 리스트 조회시 공통사용
	String pg_row			 = CommonUtil.nvl((String) request.getParameter("st_pg_row"),""); 
	String st_check		  = CommonUtil.nvl((String) request.getParameter("st_check"),"SEARCH"); 
 
	String tot_cnt_string = "";
	int tot_cnt = 0;									//전체데이타row수
	int rec_cnt = 0;
 
	// HTML 리스트 조회시 공통사용
	//1개월
	String fromDate1 = "";
	String toDate1	= "";
	toDate1	 =  CommonUtil.formatDateNoDateGubun(new Date(),1);
	fromDate1	=	CommonUtil.addDate(new Date(),"M",-1,1);
	//System.out.println("fromDate1 "+fromDate1);
	String from_year1  = fromDate1.substring(0,4);
	String from_month1 = fromDate1.substring(4,6);
	String from_day1	= fromDate1.substring(6,8);
	String v_fromDate1  = from_year1+"/"+from_month1+"/"+from_day1;
	String to_year1  = toDate1.substring(0,4);
	String to_month1 = toDate1.substring(4,6);
	String to_day1	= toDate1.substring(6,8);
	String v_toDate1  = to_year1+"/"+to_month1+"/"+to_day1; 
	
	String buyer = sessionInfo.getComCode();
	String userid = sessionInfo.getUserId();	
	 if ("".equals(curPage)){ 
		 v_fromDate = v_fromDate1;
		 v_toDate = v_toDate1;

	 } 
	
	String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),row_cnt); // 정렬갯수 
	
	
	boolean p060000043 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000043"); // KRCOLL0001
	
	/*
		프로그램ID: PG_02_B_000834_008
		수정자: 현명환
		수정일: 2015.03.06
		펀치아웃 해당 내용 표시.
	*/
	boolean p060000052 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000052"); 
	
	boolean getCodeYn = CommonUtil.getCodeCheckReturn("M141",SessionUserId);
	
 
%> 
<body onLoad="kep_onload_view()">
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
		<h3>품목신청내역</h3>
		<!--버튼영역-->
		 <div id="searchBtnA">
		 	<span class="btn_search"><a href="javascript:doAction('search');">조회</a></span> 
			<span class="btn_reset"><a href="javascript:doAction('reload');">초기화</a></span>
		 </div>
		<!--조회영역-->
		<form name = "searchForm" id="searchForm" method = "post">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" id="upperId" name="upperId" value="<c:out value="${param.upperId}"/>">		
			<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
			<!-- 화면 내 정의 -->
			<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
			<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
	
			<input type="hidden" name="st_buyer"	value ="<%=buyer%>"> 
			<input type="hidden" name="st_userid"	value ="<%=userid%>"> 
			<input type="hidden" name="st_check"	value ="<%=st_check%>"> 
			<input type="hidden" name="page_type"  value ="">
			<input type="hidden" name="st_fromDate" value="<%=fromDate%>">
			<input type="hidden" name="st_toDate"  value="<%=toDate%>">
			<input type="hidden" name="SessionComCode"  value="<%=SessionComCode%>">
			<input type="hidden" name="SessionUserId"  value="<%=SessionUserId%>">
			<input type="hidden" name="st_sortType"	 value="<%=sortType%>">
			<input type="hidden" name="st_status" value="ALL"/>
				
			<div id="cont_searchA" >
				<table class="cont_t_list01">
					<caption>조회</caption>
					<colgroup>
						<col width="8%" />
						<col width="21%" />
						<col width="8%" />
						<col width="21%" />
						<col width="8%" />
						<col width="21%" />
					</colgroup>
					
					<tbody>
					<tr>
						<th>요청일</th>
						<td colspan="3">
							<input type="text" class="input_type_text" name="fromDate" id="fromDate" readOnly style="width:15%;text-align:center;" value="<%=v_fromDate%>"> - 
							<input type="text" class="input_type_text" name="toDate" id="toDate" readOnly style="width:15%;text-align:center;" value="<%=v_toDate%>"> 
							<span class="btn_month"><a href="javascript:kepMonth('fromDate','toDate','1')">1개월</a></span>
							<span class="btn_month"><a href="javascript:kepMonth('fromDate','toDate','3')">3개월</a></span>
							<span class="btn_month"><a href="javascript:kepMonth('fromDate','toDate','6')">6개월</a></span>
							<span class="btn_month"><a href="javascript:setCurMonth('fromDate','toDate')">당월</a></span>		
						</td>
					</tr>
					<tr>
						<th>요청번호</th>
						<td>
							<input type="text" class="input_type_text" name="st_ref_no" id="st_ref_no" style="width:87%" value="<%=(ref_no.equals("ALL") ? "" : ref_no)%>" onKeyDown="kepEnter()" />
						</td>
						<th>
							<select name="st_search_type" id="st_search_type" class="TitSelect">
								<option <%=(search_type.equals("BC")? "selected" : "")%> value = "BC">품목코드</option>
								<option <%=(search_type.equals("DE")? "selected" : "")%> value = "DE">품목명</option>
								<option <%=(search_type.equals("SP")? "selected" : "")%> value = "SP">규격</option>
							</select>
						</th>
						<td>
							<input type="text" class="input_type_text" name="st_search_no" id="st_search_no" style="width:87%" value = "<%=(search_no.equals("ALL") ? "" : search_no)%>" onKeyDown="kepEnter()" />
							<input type="hidden" name="st_unit_part" id="st_unit_part" value ="ST_USER_ID">
						</td>
					</tbody>
				</table>
			</div>
			<span class="fl">
				<img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
				<label for="b_no02" class="hidden">정렬개수선택</label>
				<select name="onepagerow" onChange="javascript:kepSearch(1);">
					<option value = "10" <%if ("10".equals(onepagerow)) {%>selected<%} %>>10건</option>
					<option value = "20" <%if ("20".equals(onepagerow)) {%>selected<%} %>>20건</option>
					<option value = "30" <%if ("30".equals(onepagerow)) {%>selected<%} %>>30건</option>
					<option value = "40" <%if ("40".equals(onepagerow)) {%>selected<%} %>>40건</option>
					<option value = "50" <%if ("50".equals(onepagerow)) {%>selected<%} %>>50건</option>
				</select>
			</span>
			<span class="fr">(기준 : 원) </span>
			<br>
		</form> 
		<form name = "contentForm" id="contentForm" method = "post">
			<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
			<table id="table_list" class="cont_t_list02" style="width:100%">
				<colgroup>
					<col width="20%" />
					<col width="*" />
					<col width="8%" />
					<col width="15%" />
					<col width="7%" />
					<col width="10%" />
					<col width="10%" />
				</colgroup>
				<thead>
					<tr>
						<th scope="col" >요청번호</th>
						<th scope="col" >품명</th>
						<th scope="col" >요청일</th>
						<th scope="col" >조직</th>
						<th scope="col" >금액</th>
						<th scope="col" >공제구분</th>
						<th scope="col" >전송상태</th>
					</tr>
					<tr>
						<th scope="col" >품목코드</th>
						<th scope="col" >규격</th>
						<th scope="col" >구분</th>
						<th scope="col" >대상자</th>
						<th scope="col" >부담금액</th>
						<th scope="col" >상태(지급상태)</th>
						<th scope="col" >택배송장번호</th>
					</tr>
				</thead>
				<tbody>
	<%
	if (_gridList == null || _gridList.size() == 0){
	%>
		<tr>
			<td colspan="7" align="center" height = "50"> 
			<span>조회된 데이타가 없습니다.</span>
			</td> 
		</tr>
	<%
	}else{
	for (int j=0; j<_gridList.size(); j++) {
	Map<String,String> rowData = _gridList.get(j);
	String tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
	
	%> 
	 
					<tr align="center" bgcolor="<%=tclass%>">
						<td title="요청번호">
							<a class="hyperLink" href="javascript:getPrDisplay('<%=rowData.get("BUYER")%>','<%=rowData.get("PR_NO")%>','<%=rowData.get("STATUS_TEXT")%>','<%=rowData.get("RECV_FLAG")%>','<%=rowData.get("REF_NO")%>')">
								<%=rowData.get("REF_PR_NO")%> (<%=rowData.get("BUYER_ITEM_NO")%>)
							</a>
						</td>
						<td title="품명">
							<%=rowData.get("DESCRIPTION")%>
						</td>
						<td title="요청일">
							<%=CommonUtil.formatStrinigDate(rowData.get("ADD_DATE"))%>
						</td>
						<td title="조직">
							<%=rowData.get("DEPT_NAME")%>
						</td>
						<td class="right" title="금액">
							<%=CommonUtil.formatNumber(rowData.get("ITEM_AMT"),true,0,3)%>
						</td>
						<td title="공제구분">
							<%=rowData.get("GONGJE")%>
						</td>
						<td class="center" title="전송상태">
							<%=rowData.get("IF_MSG")%>
						</td>
					</tr>
					<tr align="center" bgcolor="<%=tclass%>">
						<td title="품목코드">
							<%=rowData.get("BUYER_ITEM_NO")%>
						</td>
						<td title="규격">
							<%=rowData.get("SPECIFICATION")%>
						</td>
						<td title="구분">
							지급
						</td>
						<td title="대상자">
							<%=rowData.get("DAESANGJA_NM")%>
						</td>
						<td class="right" title="부담금액">
							<%=CommonUtil.formatNumber(rowData.get("BUDAM_AMT"),true,0,3)%>
						</td>
						<td class="center" title="상태(지급상태)">
							<%=rowData.get("STATUS_TEXT")%>(<%=rowData.get("ZSTATUS_NAME")%>)
						</td>
						<td class="center" title="택배송장번호">
							<a class="hyperLink" href="javascript:getShLogisTracking('<%=rowData.get("REF_IF_NO")%>')">
								<%=rowData.get("REF_IF_NO")%>
							</a>
						</td>
					</tr>
	<%
	}
	}
	%>
				</tbody>
			</table>
	<%	if (_gridList != null && _gridList.size() > 0){	%>
			<input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=_gridList.size() %>" >
	<%	}	%>
			<!-- 페이징 -->
			<p id="paging" class="paging">
				<%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow) %> 
				<span class="cl">[ 총 <%=total_cnt %> 건 ]</span> 
			</p> 
		</form>
		<form name="processForm" id="processForm" method="post">	
			<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" />
			<input type="hidden" name="total_cnt" id="total_cnt" value="<%=total_cnt %>"/>
			<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>"/>
			<input type="hidden" name="onepagerow" id="onepagerow" value="<%=onepagerow %>"/>
			<div id="process">	
			</div>
		</form>
		<form name="locationForm" id="locationForm" method="post">
			<input type="hidden" id="upperId" name="upperId" value="<c:out value="${param.upperId}"/>">
			<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
			<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
		</form>
	</div>
	</div>
	<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>
	</div>
</body>

<script type="text/javascript">
var popupSel = "";

// 최초 화면 함수 
function kep_onload_view(){
	
 
	kepSetCalender("fromDate");
	kepSetCalender("toDate"); 
}

var st;
//기능함수
function doAction(str) {
	switch (str) {
	case "search":	 //조회
		document.forms.searchForm.curPage.value = 1; 

		kepSearch($("#curPage").val());
		break;
		
	case "reload":	//초기화
	 
		// 조회일 초기 셋팅
		kepSetCalender("fromDate");
		kepSetCalender("toDate");		
		$("#fromDate").val( kepToMonthAdd("1","M"));
		$("#toDate").val( kepGetNowTimeStr('YYYYMMDD','/'));  		
		
		document.forms.searchForm.st_ref_no.value = "";
		document.forms.searchForm.st_search_type.value = "BC";
		document.forms.searchForm.st_search_no.value = "";	 		
		
		jspTableClean("table_list");
		break;

	case "excelDown": // 엑셀다운로드

	<%//펀치아웃 특수로직
		if((p060000052 == true)) {
	%>
		document.forms.searchForm.action = "/mpso/excelBuyerMpSoOrderPunchOutProgressList.do";
	<%
		}else{
	%>
		document.forms.searchForm.action = "/mpso/excelBuyerMpSoOrderProgressList.do";
	<%
		}
	%>
		document.forms.searchForm.submit();
		
		break;

	}
}

// 조회
function kepSearch(curPage){
	if (kep_dateSearchCheck($("#fromDate").val(),$("#toDate").val()) == false) return; 
	document.forms.searchForm.curPage.value = curPage;
	$('#searchForm').attr("action", "/mpso/getBuyerMpSoClcsOrderProgressList.do").submit();
}

function setDescriptionSort()
{
	var sort = document.forms.searchForm.st_sortType.value ;
	if(sort == "DESC" || sort == ""){
		document.forms.searchForm.st_sortType.value = "ASC";
	}else if (sort == "ASC"){
		document.forms.searchForm.st_sortType.value = "DESC";
	}
	kepSearch(1);

} 

function getPrDisplay(BUYER,PR_NO,STATUS_TEXT,RECV_FLAG,REF_NO){ 
	openSearchPopup('/mpiv/showCommonMpIvOdrreqDetailPop.do','?openYn=Y&PR_NO='+PR_NO+'&RECV_FLAG='+RECV_FLAG , "800,600,no"); 
} 


function setReturnReason(RETURN_REASON){ 
	
	 if(RETURN_REASON == "ALL")
	 {
		 return;
	 }else {
		 	openSearchPopup('/common/reasonPop.do','?openYn=Y&reason='+RETURN_REASON , "500,180,no"); 
			return;
	 }	
} 
function getPoDisplayPop(BUYER,PO_NO){ 
	openSearchPopup('/mpiv/getCommonMpIvBuyerOrderDetailInfoPop.do','?buyer='+BUYER+'&po_no='+PO_NO , "820,550,no"); 
} 
function cardBillPop(bill_no){ 
	var loc = 'https://admin8.kcp.co.kr/assist/bill.BillAction.do?cmd=card_bill&c_trade_no='+bill_no;
	var childWin1 = window.open(loc, "Navigate","width=470,height=815,resizable=no,scrollbars=no, top=0, left=0");
} 


function moveReturn(gubun, PO_NO, PO_SEQ,BUYER,PROCESS_TYPE){
	
	if(''== BUYER ){
		alert('고객사 코드가 조회 되지 않습니다.');
		return;
	}
	else if( '' == PO_NO ){
		
		alert('발주번호 정보가 없습니다. ');
		return;
		
	}else if(''==PO_SEQ){
		
		alert('발주번호순번 정보가 없습니다. ');
		return;
		
	}

	if('1' ==gubun ){
		
		openSearchPopup('/wmre/showMasterWmReReturnEntryForBuyerCancelPop.do','?st_po_no='+PO_NO+'&st_po_seq='+PO_SEQ+'&st_buyer_code='+BUYER , '900,380,no'); 
	
	}

	else if('2' ==gubun ){

		openSearchPopup('/wmre/showMasterWmReReturnEntryForBuyerPop.do','?st_po_no='+PO_NO+'&st_po_seq='+PO_SEQ+'&st_buyer_code='+BUYER , '900,380,no'); 
	 }
}

function getShLogisTracking(inv_no){
	var loc = 'http://www.shl1978.com/transport_num.asp?chk=s&inv_no='+inv_no;
	window.open(loc, "shLogisTracking","width=800,height=600,resizable=yes,scrollbars=yes, top=0, left=0");
}
</script>
</html>
