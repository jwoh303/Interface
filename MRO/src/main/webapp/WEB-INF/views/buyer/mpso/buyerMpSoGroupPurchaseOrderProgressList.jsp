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
<script src="/resources/js/kep_buyer.js"></script>
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
	String userType         = CommonUtil.nvl((String)sessionInfo.getUserType());
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
		<h3>공동구매 신청내역</h3>
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
			<input type="hidden" name="st_user_type"	 value="<%=userType%>">
			
			<input type="hidden" name="st_ref_no" />
			<input type="hidden" name="st_status" value="ALL"/>

			<input type="hidden" name="currentDate" size="10" maxlength="10" value="<%= toDate %>">
			<input type="hidden" name="ToDateTemp" size="10" value="<%=CommonUtil.formatStrinigDate(new Date(),1)%>">
			<input type="hidden" name="userID" value="<%=SessionUserId%>">
			<input type="hidden" name="userDept" value="${sessionInfo.department }">
			<input type="hidden" name="st_add_user_tel" value="${sessionInfo.tel }">
			<input type="hidden" name="st_sum_price" value="" />
			
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
						<th>
							<select name = "st_search_type" class="TitSelect">
								<option <%=(search_type.equals("BC")? "selected" : "")%> value = "BC">품목코드</option>
								<option <%=(search_type.equals("DE")? "selected" : "")%> value = "DE">품목명</option>
								<option <%=(search_type.equals("SP")? "selected" : "")%> value = "SP">규격</option>
							</select>
						</th>
						<td>
							<input type="text" class="input_type_text" name="st_search_no" style="width:87%" value = "<%=(search_no.equals("ALL") ? "" : search_no)%>" onKeyDown="kepEnter()" />
							<input type="hidden" name="st_unit_part" value ="ALL">
<!-- 							<input type="hidden" name="st_unit_part" value ="ST_USER_ID"> -->
						</td>
						<th></th>
						<td>
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
			<input type="hidden" name="st_po_create_date" size="10" value="<%=toDate%>">
			<input type="hidden" name="st_update" id="st_update" value=""/>
			<table id="table_list" class="cont_t_list02" style="width:100%">
				<colgroup>
					<col width="*" />
					<col width="18%" />
					<col width="8%" />
					<col width="8%" />
					<col width="10%" />
					<col width="10%" />
					<col width="10%" />
					<col width="5%" />
				</colgroup>
				<thead>
					<tr>
						<th scope="col" >품목</th>
						<th scope="col">소속</th>
						<th scope="col" >이름</th>
						<th scope="col" >수량</th>
						<th scope="col" >단가</th>
						<th scope="col" >공급금액</th>
						<th scope="col" >요청일</th>
						<th scope="col" ></th>
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
		String tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
		
	%> 
	 
					<tr align="center" bgcolor="<%=tclass%>">
						<td class="left" title="품목">
							<%=rowData.get("DESCRIPTION")%><br>
							<%=rowData.get("SPECIFICATION")%>
							<input type="hidden" value="<%=rowData.get("BUYER_ITEM_NO")%>"/>
							<input type="hidden" id="st_buyer" name="st_buyer"  value="<%=rowData.get("BUYER")%>"/>
							<input type="hidden" id="st_contract_no" name="st_contract_no"  value="<%=rowData.get("CONTRACT_NO")%>"/>
							<input type="hidden" id="st_contract_seq" name="st_contract_seq"  value="<%=rowData.get("CONTRACT_SEQ")%>"/>
							<input type="hidden" id="st_seq" name="st_seq"  value="<%=rowData.get("SEQ")%>"/>
							<input type="hidden" id="st_coway_cart_id" name="st_coway_cart_id"  value="<%=rowData.get("COWAY_CART_ID")%>"/>
							<input type="hidden" id="st_chk_cancle_yn" name="st_chk_cancle_yn"  value="<%=rowData.get("CHK_YN")%>"/>
						</td>
						<td title="소속" align="left">
							<%=rowData.get("DEPARTMENT_NAME")%>
						</td>
						<td title="이름">
							<%=rowData.get("ADD_USER_NAME")%><br>
							(<%=rowData.get("ADD_LEGACY_USER_ID")%>)
							<input type="hidden" value="<%=rowData.get("ADD_USER_ID")%>"/>
						</td>
						<td title="수량">
							<input type="hidden" name="db_qty" value="<%=rowData.get("TARGET_QTY")%>"/>
							<%=CommonUtil.formatNumber(rowData.get("TARGET_QTY"),true,0,3)%>
						</td>
						<td class="right" title="단가">
							<input type="hidden" name="item_amt" value='rowData.get("UNIT_PRICE")' />
							<%=CommonUtil.formatNumber(rowData.get("UNIT_PRICE"),true,0,3)%>
						</td>
						<td class="right" title="공급금액">
							<input type="hidden" name="db_price" value="<%=rowData.get("ITEM_AMT")%>"/>
							<%=CommonUtil.formatNumber(rowData.get("ITEM_AMT"),true,0,3)%>
						</td>
						<td title="요청일">
							<%=CommonUtil.formatStrinigDate(rowData.get("ADD_DATE"))%><br>
						</td>
						<td title="취소">
							<a href="javascript:doAction('del', '<%=j %>');">
								<font color='red'>[취소]</font></a>
						</td>
					</tr>
	<%
		}//end for
	}//end if
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
	<%
	if (!(_gridList == null || _gridList.size() == 0)){
	%>
			<div class="btnArea">
				<div class="fr">
					<span class="btn_04 mr04">
						<a href="javascript:doAction('excelDown');">엑셀다운로드</a>
					</span>
				 
				</div>
			</div>
	<%} %>
		</form>
		<form name="processForm" id="processForm" method="post">
			<input type="hidden" name="st_update" id="st_update" value=""/>
			<input type="hidden" id="upperId" name="upperId" value="<c:out value="${param.upperId}"/>">
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
function doAction(str, row) {
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

		document.forms.searchForm.st_pr_no.value = "";
		document.forms.searchForm.st_ref_no.value = "";
		document.forms.searchForm.st_search_type.value = "BC";
		document.forms.searchForm.st_search_no.value = "";
		
		jspTableClean("table_list");
		break;

	case "excelDown": // 엑셀다운로드
		document.forms.searchForm.action = "/mpso/excelBuyerMpSoGroupPurchaseOrderProgressList.do";
		document.forms.searchForm.submit();
		break
	case "del": // 엑셀다운로드
		var tot_cnt = $("#display_item_cnt").val(); 
		if(!confirm("삭제 하시겠습니까?")){ 
			return;
		} 
		var userType = document.forms.searchForm.st_user_type.value;
		var query	= "";
		if(eval(tot_cnt) < 2){
			var st_coway_cart_id	= document.forms.contentForm.st_coway_cart_id.value;
			var st_contract_no = document.forms.contentForm.st_contract_no.value;
			var st_contract_seq = document.forms.contentForm.st_contract_seq.value;
			var st_seq = document.contentForm.st_seq.value;
			var st_chk_cancle_yn = document.contentForm.st_chk_cancle_yn.value;
			if(userType == "U"){
				if(st_chk_cancle_yn == "N"){
					alert("구매요청 후 한달이 지났기 때문에 취소가 불가능합니다.");
					return;
				}
			}
			query = st_coway_cart_id + "@@" + st_contract_no + "@@" + st_contract_seq + "@@" + st_seq + "&&";
		} else {
			var st_coway_cart_id	= document.forms.contentForm.st_coway_cart_id[row].value;
			var st_contract_no = document.forms.contentForm.st_contract_no[row].value;
			var st_contract_seq = document.forms.contentForm.st_contract_seq[row].value;
			var st_seq = document.contentForm.st_seq[row].value;
			var st_chk_cancle_yn = document.contentForm.st_chk_cancle_yn[row].value;
			if(userType == "U"){
				if(st_chk_cancle_yn == "N"){
					alert("구매요청 후 한달이 지났기 때문에 취소가 불가능합니다.");
					return;
				}
			}			
			query = st_coway_cart_id + "@@" + st_contract_no + "@@" + st_contract_seq + "@@" + st_seq + "&&";
		}
		document.forms.processForm.st_update.value = query; 
		kepAjaxFormCall("/mpso/delBuyerMpsoCowayCart.do","processForm","regOrder");
		break;;

	}
}
function setRowChecked(row){
	var tot_cnt = $("#display_item_cnt").val(); 
	for(var k = 0; k < tot_cnt; k++){
		var box =  eval("document.forms.contentForm.lnCheck" + k);
		box.checked = false;
	}
	var checkBox =eval("document.forms.contentForm.lnCheck" + row);
	checkBox.checked = true;
}


// 조회
function kepSearch(curPage){

	if (kep_dateSearchCheck($("#fromDate").val(),$("#toDate").val()) == false) return; 
	document.forms.searchForm.curPage.value = curPage;
	$('#searchForm').attr("action", "/mpso/getBuyerMpSoGroupPurchaseOrderProgressList.do").submit();
}

function kepAjaxSuccess(pMethod , response){
	if(pMethod="regOrder"){
		alert("삭제 처리가 되었습니다.");
 		kepSearch($("#curPage").val());
	}
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	alert("시스템 오류입니다. 관리자에게 문의하시기 바랍니다.");
} 

</script>
</html>
