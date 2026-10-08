<%--
**********************************************
* 메뉴 : 납품관리>납품현황>납품 진행현황
* 화면 : 납품 진행현황
* 기능 : 납품진행현황을 조회 할 수 있다.
* 프로그램 ID : PG_07_A_008_00
* 담당자 : 개발3 ( 설계 : 김지현 )
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

<%
	// 공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = (String) request.getParameter("onepagerow");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
    
	String pg_row           = CommonUtil.nvl((String)request.getParameter("st_pg_row"), "10");
    String pg_no            = CommonUtil.nvl((String)request.getParameter("st_page"), "1");
	String tot_cnt_string   = "";
    int tot_cnt = 0;                                    //전체데이타row수
    int rec_cnt = 0;
    int page_display_cnt = 0;
%> 

<script type="text/javascript">

//최초 화면 함수 
function kep_onload_view(){
	
	var from_date = "${st_from_date}";
	var to_date = "${st_to_date}";
	
	if(kepIsValueNull("${st_from_date}")){
		
		//from_date = "20140601";
		from_date = kepToMonthAdd("1","M","noslash");
		to_date = kepGetNowTimeStr("YYYYMMDD","");
	}
	
	//조회조건 초기화(기존값 재설정)
	initSearchCondition("searchForm", "st_from_date", from_date);	//발주일 시작일자
	initSearchCondition("searchForm", "st_to_date", to_date);		//발주일 종료일자
	
	initSearchCondition("searchForm", "st_buyer_name", "${st_buyer_name}");	//구매회사명
	initSearchCondition("searchForm", "st_buyer_code", "${st_buyer_code}");	//구매회사코드
	
	initSearchCondition("searchForm", "st_po_no", "${st_po_no}");	//발주번호
	initSearchCondition("searchForm", "st_legacy_po_no", "${st_legacy_po_no}");	//고객사발주번호
	initSearchCondition("searchForm", "st_buyer_item_no", "${st_buyer_item_no}");	//품목코드
	
	initSearchCondition("searchForm", "st_order_by", "${st_order_by}");	//정렬기준
	
	var status = "${st_status}";
	
	if(isEmpty(status)){
		status = "ALL";
	}
	
	initSearchCondition("searchForm", "st_status", status);	// 상태
	
	kepSetCalender('st_from_date');
	kepSetCalender('st_to_date');
	
	initSearchCondition("searchForm", "onepagerow", "${onepagerow}");	//페이징단위
}

function doAction(str) {
	switch (str) {
		case "search":	 //조회
			if (kepGetDateDiff('st_from_date','st_to_date','D') > 62 ){
				alert("조회기간은 2개월 단위로 조회가 가능합니다.");
				return ;
			}
			kepSearch("1");
			break;
			
		case "reload":	//초기화
			kepReload("searchForm");
			
			// hidden값은 공통에서 처리안됨.
			$("#st_buyer_code").val("");
			$("#st_from_date").val(kepToMonthAdd("1","M",""));
			$("#st_to_date").val(kepGetNowTimeStr("YYYYMMDD","/"));
// 			kepSearch("-1");
			jspTableClean("table_list");
			break;
			
		case "excelDown": // 엑셀다운로드
			document.forms.searchForm.action = "/mpiv/excelSellerMpIvDeliveryProgressStateList.do";
			document.forms.searchForm.submit();
			break;
			
		case "request":	// 납품예정일 변경요청
			setDsDateChangeRequest();
			break;
			
		case "request2": // 수주접수 초기화요청
			setIvInfoChangeRequest();
			break;
	}
}

/*
 * FORM 을 이용한조회
 */
function kepSearch(curPage){
	if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
	
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mpiv/getSellerMpIvDeliveryProgressStateList.do").submit();
}
 
// 팝업 함수호출
function doPop(str,value1, value2, value3, value4) {
	switch (str) {
		case "agent": // 고객사정보
			openSearchPopup("/common/agentInfoDisplayPop.do", "?st_com_code="+value1, "800,550,no");
			break;
			
		case "commonMpIvTranBuyerChoicePop": // 고객사선택
			openSearchPopup("/mpiv/getCommonMpIvTranBuyerChoicePop.do", "?st_com_code="+$("#st_com_code").val(), "720,505,no");
			break;
			
		case "commonMpIvOrderInfoPop": // 발주번호 click시 발주정보 팝업
			openSearchPopup("/mpiv/getCommonMpIvOrderInfoPop.do", "?st_buyer="+value1+"&st_po_no="+value2, "930,600,no");
			break;
			
		case "catalogDetailPop": // 품목상세정보
			getBuyerCatalogDisplayPop(value1, value2, value3, value4);
			break;
			
		case "ivInfoChange": // 수주접수 초기화요청
			openSearchPopup("/mpiv/showSellerMpIvIvInfoChangePop.do", "?value1="+value1, "600,350,no");
			break;
	}
}

function setBuyerChoiceReturn(buyer, com_name){
	$("#st_buyer_code").val(buyer);
	$("#st_buyer_name").val(com_name);
}

//납품예정일 calender callback event
function calenderChange(dateText,num){
	var org_date = $("#st_org_ds_date"+num).val();
	var org_date_slash = kepGetDateStr(org_date, "/");
	$("#st_org_ds_date_text"+num).val(org_date_slash);
	
	var cur_date = kepGetNowTimeStr("YYYYMMDD","");
	var cur_date_slash = kepGetNowTimeStr("YYYYMMDD","/");
	$("#st_cur_date_text"+num).val(cur_date_slash);
	
	var req_cnt = $("#st_req_cnt"+num).val();
	
	var org_date_day = new Date(org_date_slash).getDay();
	var term = 0;
	
	if(org_date_day == 1){ // 기존 납품예정일이 월요일(1)이면 전주 금요일(D-4)도 불가
		term = 4;
	}else{ // 이 외 전일 체크
		term = 2;
	}
	
	if(kepGetDateDiff('st_cur_date_text'+num,'st_org_ds_date_text'+num,'D') < term){
		$("#st_ds_date_text"+num).val(org_date_slash);
		$("#st_ds_date"+num).val(org_date);
		alert("영업일 기준 2일전까지만 변경요청이 가능합니다.");
		return;
	}

	if(req_cnt > 0){
		$("#st_ds_date_text"+num).val(org_date_slash);
		$("#st_ds_date"+num).val(org_date);
		alert("납품예정일은 승인 기준 1회만 변경 가능합니다.");
		return;
	}
	
	if(isEmpty(dateText)){
        $("#st_ds_date"+num).val(cur_date);
	} else {
		var input_date_slash = dateText;
		var input_date = dateText.replace(/[/]/gi,"");
		var st_ds_date_text = $.trim($("#st_ds_date_text"+num).val());
		$("#st_ds_date"+num).val(input_date);
	}
	
	if(org_date < input_date){
		setDelayReason(num);
	}
}

//지연사유 팝업 호출
function setDelayReason(x){
	var disp_cnt = $("#display_item_cnt").val();
	$("#x").val(x);
	
	openSearchPopup("/mpiv/showSellerMpIvDeliveryDelayReasonPop.do", "?st_pop_type=one", "520,410,no");
}

//지연사유 팝업 리턴
function setReason(value,flag){
	var x = $("#x").val();
	
	$("#st_delay_reason"+x).val(value);
	
	// 자동 체크
	var box = eval("document.contentForm.checkbox" + x);

	if(box.checked == false){
		box.checked = true;
	}
}

//지연사유 팝업 내에서 호출
function getDelayReason(){
    var disp_cnt = $("#display_item_cnt").val();
    var x        = $("#x").val();
    var reason_text = "";

    if(eval(disp_cnt) < 2){
        reason_text = $("#st_delay_reason"+x).val();
    }else{
        reason_text = $("#st_delay_reason"+x).val();
    }
    
    return reason_text;
}

//전체선택/해제
function checkAll(){
	var tot_cnt      = document.contentForm.display_item_cnt.value;
	var check_status = $("#check_status").html();
	
	if(check_status == "전체"){
		for(var j = 0; j < tot_cnt; j++){
			var box = eval("document.contentForm.checkbox" + j);
			var check_status = "해제";

			if(box.checked == false) box.checked = true;
			$("#check_status").html(check_status);
		}
	}else{
		for(var j = 0; j < tot_cnt; j++){
			var box = eval("document.contentForm.checkbox" + j);
			var check_status = "전체";
			
			if(box.checked == true) box.checked = false;
			$("#check_status").html(check_status);
		}
	}
}

// 납품예정일 변경요청
function setDsDateChangeRequest(){
	var tot_cnt  = $("#display_item_cnt").val();
	var query   = "";
	var chk_cnt = 0;    // 선택건 체크
	
	var buyer			= "";
	var po_no			= "";
	var po_seq			= "";
	var pr_no			= "";
	var pr_seq			= "";
	var ds_seq			= "";
	var agent			= "";
	var status			= "";
	var re_ds_date		= "";
	var ch_ds_date		= "";
	var delay_reason	= "";
	var info_change_req_yn	= "";
	
	if(eval(tot_cnt) == 0) {
		alert("조회한 데이타가 없습니다.");
		return;
	}
	
	if(eval(tot_cnt) < 2){
		var box = eval("document.contentForm.checkbox"+0);
		
		if(box.checked == true){
			chk_cnt++;
			
			buyer           = document.contentForm.db_buyer.value;
			po_no           = document.contentForm.db_po_no.value;
			po_seq          = document.contentForm.db_po_seq.value;
			pr_no			= document.contentForm.db_pr_no.value;
			pr_seq			= document.contentForm.db_pr_seq.value;
			ds_seq			= document.contentForm.db_ds_seq.value;
			agent			= document.contentForm.db_agent.value;
			status			= document.contentForm.st_status_text.value;
			re_ds_date		= document.contentForm.st_org_ds_date.value;
			ch_ds_date		= document.contentForm.st_ds_date.value;
			delay_reason	= document.contentForm.st_delay_reason.value;
			info_change_req_yn		= document.contentForm.st_info_change_req_yn.value;
			
			if(info_change_req_yn == "Y"){
				alert("이미 수주접수 초기화요청건으로 현재 KEP에서 확인중입니다.");
				return;
			}
			
			if(status != "발주" && status != "수주접수"){
				alert("발주 및 수주접수 상태에서만 가능합니다.");
				return;
			}
			
			if(re_ds_date == ch_ds_date){
				alert("납품예정일 변경건만 가능합니다.");
				return;
			}else if(re_ds_date < ch_ds_date){
				if(delay_reason == ""){
					alert("변경일자를 눌러 지연사유를 다시 선택하여 주십시요.");
					return;
				}
			}
			
			query +=  buyer			+ "@@";
			query +=  po_no			+ "@@";
			query +=  po_seq		+ "@@";
			query +=  ds_seq		+ "@@";
			query +=  pr_no			+ "@@";
			query +=  pr_seq		+ "@@";
			query +=  agent			+ "@@";
			query +=  re_ds_date	+ "@@";
			query +=  ch_ds_date	+ "@@";
			query +=  delay_reason;
			query +=  "^||^" ;
		}
	}else{
		for(var k = 0; k < tot_cnt; k++){
			var box = eval("document.contentForm.checkbox"+k);

			if(box.checked == true){
				chk_cnt++;
				
				buyer           = document.contentForm.db_buyer[k].value;
				po_no           = document.contentForm.db_po_no[k].value;
				po_seq          = document.contentForm.db_po_seq[k].value;
				pr_no			= document.contentForm.db_pr_no[k].value;
				pr_seq			= document.contentForm.db_pr_seq[k].value;
				ds_seq			= document.contentForm.db_ds_seq[k].value;
				agent			= document.contentForm.db_agent[k].value;
				status			= document.contentForm.st_status_text[k].value;
				re_ds_date		= document.contentForm.st_org_ds_date[k].value;
				ch_ds_date		= document.contentForm.st_ds_date[k].value;
				delay_reason	= document.contentForm.st_delay_reason[k].value;
				info_change_req_yn		= document.contentForm.st_info_change_req_yn[k].value;
				
				if(info_change_req_yn == "Y"){
					alert("이미 수주접수 초기화요청건으로 현재 KEP에서 확인중입니다.");
					return;
				}
				
				if(status != "발주" && status != "수주접수"){
					alert("발주 및 수주접수 상태에서만 가능합니다.");
					return;
				}
				
				if(re_ds_date == ch_ds_date){
					alert("납품예정일 변경건만 가능합니다.");
					return;
				}else if(re_ds_date < ch_ds_date){
					if(delay_reason == ""){
						alert("변경일자를 눌러 지연사유를 다시 선택하여 주십시요.");
						return;
					}
				}
				
				query +=  buyer			+ "@@";
				query +=  po_no			+ "@@";
				query +=  po_seq		+ "@@";
				query +=  ds_seq		+ "@@";
				query +=  pr_no			+ "@@";
				query +=  pr_seq		+ "@@";
				query +=  agent			+ "@@";
				query +=  re_ds_date	+ "@@";
				query +=  ch_ds_date	+ "@@";
				query +=  delay_reason;
				query +=  "^||^" ;
			}
		}
	}
	
	if(chk_cnt == 0){
		alert("변경요청 항목을 선택하여 주십시요");
		return;
	}
	
	if(!confirm("1. 납품예정일은 승인 기준 1회만 변경 가능\n2. 영업일 기준 2일전까지 변경 요청 가능\n\n납품예정일 변경요청을 하시겠습니까?")) return;

	document.searchForm.st_query.value = query;
	
	kepAjaxFormCall("/mpiv/saveSellerMpIvDsDateChangeReqList.do","searchForm","btnCreate");
}

// 수주접수 초기화요청
function setIvInfoChangeRequest(){
	var tot_cnt  = $("#display_item_cnt").val();
	var query   = "";
	var chk_cnt = 0;    // 선택건 체크
	
	var buyer			= "";
	var po_no			= "";
	var agent			= "";
	var status			= "";
	var init_able		= "";
	var info_change_req_yn = "";

	if(eval(tot_cnt) == 0) {
		alert("조회한 데이타가 없습니다.");
		return;
	}
	
	if(eval(tot_cnt) < 2){
		var box = eval("document.contentForm.checkbox"+0);
		
		if(box.checked == true){
			chk_cnt++;
			
			buyer           = document.contentForm.db_buyer.value;
			po_no           = document.contentForm.db_po_no.value;
			agent			= document.contentForm.db_agent.value;
			status			= document.contentForm.st_status_text.value;
			init_able		= document.contentForm.st_init_able.value;
			info_change_req_yn		= document.contentForm.st_info_change_req_yn.value;
			
			if(info_change_req_yn == "Y"){
				alert("이미 수주접수 초기화요청건으로 현재 KEP에서 확인중입니다.");
				return;
			}
			
			if(init_able == "N" || status != "수주접수"){
				alert("발주번호 내 모든 항목이 수주접수 상태에서만 가능합니다.");
				return;
			}
			
			query +=  buyer			+ "@@";
			query +=  po_no			+ "@@";
			query +=  agent;
			query +=  "^||^" ;
		}
	}else{
		for(var k = 0; k < tot_cnt; k++){
			var box = eval("document.contentForm.checkbox"+k);

			if(box.checked == true){
				chk_cnt++;
				
				buyer           = document.contentForm.db_buyer[k].value;
				po_no           = document.contentForm.db_po_no[k].value;
				agent			= document.contentForm.db_agent[k].value;
				status			= document.contentForm.st_status_text[k].value;
				init_able		= document.contentForm.st_init_able[k].value;
				info_change_req_yn		= document.contentForm.st_info_change_req_yn[k].value;
				
				if(info_change_req_yn == "Y"){
					alert("이미 수주접수 초기화요청건으로 현재 KEP에서 확인중입니다.");
					return;
				}
				
				if(init_able == "N" || status != "수주접수"){
					alert("발주번호 내 모든 항목이 수주접수 상태에서만 가능합니다.");
					return;
				}
				
				query +=  buyer			+ "@@";
				query +=  po_no			+ "@@";
				query +=  agent;
				query +=  "^||^" ;
			}
		}
	}
	
	if(chk_cnt == 0){
		alert("변경요청 항목을 선택하여 주십시요");
		return;
	}
	
	doPop('ivInfoChange', query);
	//kepAjaxFormCall("/mpiv/saveSellerMpIvDsDateChangeReqList.do","searchForm","btnCreate");
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	if(pMethod == "btnCreate"){
		alert("변경요청이  정상적으로 완료 되었습니다.");
		doAction("search");
	}
	
	return;
}

//ajax 공통 호출후 실패시 처리 함수
function kepAjaxError(pMethod , response){
	var msg = response.Message;
	
	if (!isEmpty(msg)){
		alert(msg);
	}
	
	return;
}
</script>
</head>
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
	<h3>납품 진행현황</h3>
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
		<input type="hidden" name="st_query" value ="">
		
		<div id="cont_searchA">	
			<table class="cont_t_list01">
				<caption>조회</caption>
				<colgroup>
					<col width="8%" />
					<col width="25%" />
					<col width="8%" />
					<col width="25%" />
					<col width="10%" />
					<col width="*" />
				</colgroup>
				<tbody>
					<tr>
						<td>발주일</td>
						<td colspan="3">
							<input type="text"   name="st_from_date" size="10" id="st_from_date" class="input_type_text"  value="" readonly>
							&nbsp;~&nbsp;
							<input type="text"   name="st_to_date" size="10" id="st_to_date" class="input_type_text"  value="" readonly>
							
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span> 
						</td>
						<td>고객사</td>
						<td>
							<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:65%;ime-mode:active" value="" READONLY>
							<input type="hidden" name="st_buyer_code" id="st_buyer_code" value="">
							<a href="javascript:doPop('commonMpIvTranBuyerChoicePop');"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
							<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
						</td>
					</tr>
					<tr>
						<td>상태</td>
						<td>
							<select id="st_status" name="st_status">
								<option value="ALL">전체</option>
								<option value="발주">발주</option>
								<option value="수주접수">수주접수</option>
								<option value="거래명세서생성">거래명세서생성</option>
								<option value="납품완료">납품완료</option>
							</select>
						</td>
						<td>발주번호</td>
						<td>
							<input type="text" class="input_type_text" name="st_po_no" id="st_po_no" style="width:80%;" onKeyDown="kepEnter();">
						</td>
						<td>고객사발주번호</td>
						<td>
							<input type="text" class="input_type_text" name="st_legacy_po_no" id="st_legacy_po_no" style="width:80%;" onKeyDown="kepEnter();">
						</td>
					</tr>
					<tr>
						<td>품목코드</td>
						<td>
							<input type="text" class="input_type_text" name="st_buyer_item_no" id="st_buyer_item_no" style="width:80%;" onKeyDown="kepEnter();">
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
				<select name="st_order_by" id="st_order_by">
					<option value = "1">발주일</option>
					<option value = "2">발주번호</option>
					<option value = "3">납품예정일</option>
					<option value = "4">거래명세서번호</option>
					<option value = "5">납품확정일</option>
					<option value = "6">품목코드</option>
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
	            <col width="3%" />
	            <col width="*" />
	            <col width="10%" />
	            <col width="10%" />
	            <col width="10%" />
	            <col width="*" /> <!-- 원래 23 인데 좀 줄임 -->
	            <col width="5%" /> <!-- 새로 추가 -->
	            <col width="*" />
	            <col width="*" />
	            <col width="*" />
	        </colgroup>
	        <thead>
                <tr>
	                <th scope="col" rowspan="2">
	                	<a href="javascript:checkAll();" id="check_status">전체</a>
			        </th>
                    <th scope="col">고객사</th>
                    <th scope="col">발주일</th>
                    <th scope="col">납품예정일</th>
                    <th scope="col">납품확정일</th>
                    <th scope="col">품목명</th>
                    <th scope="col">제조사</th>
                    <th scope="col">발주수량</th>
                    <th scope="col">납품확정수량</th>
                    <th scope="col">단가/단위</th>
                </tr>
                <tr>
                    <th scope="col">상태</th>
                    <th scope="col">발주번호</th>
                    <th scope="col">거래명세서번호</th>
                    <th scope="col">품목코드</th>
                    <th scope="col">규격</th>
                    <th scope="col">모델번호</th>
                    <th scope="col">납품예정수량</th>
                    <th scope="col">고객사발주번호</th>
                    <th scope="col">납품현황</th>
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
				++page_display_cnt;
				Map<String,String> rowData = _gridList.get(j);
				String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
				
		%>
				<!-- hidden -->
				<input type="hidden" name="db_buyer" id="db_buyer<%=j%>" value='<%=CommonUtil.nvl(rowData.get("BUYER_CODE"))%>'>
				<input type="hidden" name="db_po_no" id="db_po_no<%=j%>" value='<%=CommonUtil.nvl(rowData.get("PO_NO"))%>'>
				<input type="hidden" name="db_po_seq" id="db_po_seq<%=j%>" value='<%=CommonUtil.nvl(rowData.get("PO_SEQ"))%>'>
				<input type="hidden" name="db_pr_no" id="db_pr_no<%=j%>" value='<%=CommonUtil.nvl(rowData.get("PR_NO"))%>'>
				<input type="hidden" name="db_pr_seq" id="db_pr_seq<%=j%>" value='<%=CommonUtil.nvl(rowData.get("PR_SEQ"))%>'>
				<input type="hidden" name="db_ds_seq" id="db_ds_seq<%=j%>" value='<%=CommonUtil.nvl(rowData.get("DS_SEQ"))%>'>
				<input type="hidden" name="db_agent" id="db_agent<%=j%>" value='<%=CommonUtil.nvl(rowData.get("AGENT"))%>'>

				<tr bgcolor="<%=tclass%>">
					<td rowspan="2">
			            <input type="checkbox" name="checkbox<%=j%>" value="" id="check">
			        </td>
					<td class="left">
						<a href="javascript:doPop('agent','<%=CommonUtil.nvl(rowData.get("BUYER_CODE2"))%>');" class="hyperLink" >
							<%=CommonUtil.nvl(rowData.get("BUYER_NAME"))%>
						</a>
					</td>
					<td>
						<%=CommonUtil.formatStrinigDate(rowData.get("PO_CREATE_DATE"))%>
					</td>
					<td>
						<%if(rowData.get("DS_DATE") != ""){ %>
							<input type="text"   name="st_ds_date_text" size="8" id="st_ds_date_text<%=j%>" class="input_type_text"  value='<%=CommonUtil.formatStrinigDate(CommonUtil.nvl(rowData.get("DS_DATE")))%>' readonly>
						<%}%>
						<input type="hidden" name="st_org_ds_date" size="10" id="st_org_ds_date<%=j%>" value='<%=CommonUtil.nvl(rowData.get("DS_DATE"))%>' >
						<input type="hidden" name="st_ds_date" size="10" id="st_ds_date<%=j%>" value='<%=CommonUtil.nvl(rowData.get("DS_DATE"))%>' >
						<input type="hidden" name="st_cur_date_text" size="10" id="st_cur_date_text<%=j%>" value='<%=j%>' >
						<input type="hidden" name="st_org_ds_date_text" size="10" id="st_org_ds_date_text<%=j%>" value='<%=j%>' >
						<input type="hidden" name="st_delay_reason" id="st_delay_reason<%=j%>" value="<%=CommonUtil.nvl(rowData.get("DS_DELAY_REASON"))%>">
						<input type="hidden" name="st_req_cnt" id="st_req_cnt<%=j%>" value='<%=CommonUtil.nvl(rowData.get("REQ_CNT"))%>'>
						<input type="hidden" name="st_init_able" id="st_init_able<%=j%>" value='<%=CommonUtil.nvl(rowData.get("INIT_ABLE_YN"))%>'>
						<input type="hidden" name="st_info_change_req_yn" id="st_info_change_req_yn<%=j%>" value='<%=CommonUtil.nvl(rowData.get("INFO_CHANGE_REQ_YN"))%>'>
					</td>
					<td>
						<%=CommonUtil.formatStrinigDate(rowData.get("DELIVERY_DATE"))%>
					</td>
					<td class="left">
						<%=CommonUtil.nvl(rowData.get("DESCRIPTION"))%>
					</td>
					<td>
						<%=CommonUtil.nvl(rowData.get("MAKER_NAME"))%>
					</td>
					<td class="right">
						<%=CommonUtil.formatNumber(rowData.get("ITEM_QTY"),true,0,3)%>
					</td>
					<td class="right">
						<%=CommonUtil.formatNumber(rowData.get("DELIVERY_QTY"),true,0,3)%>
					</td>
					<td class="right">
						<%=CommonUtil.formatNumber(rowData.get("AGENT_PRICE"),true,0,3)%>/<%=CommonUtil.nvl(rowData.get("UNIT_MEASURE"))%>
					</td>
                </tr>

                <tr bgcolor="<%=tclass%>">
                	<td>
						<%=CommonUtil.nvl(rowData.get("STATUS"))%><%=CommonUtil.nvl(rowData.get("PMNG_STATUS"))%> 
						<input type="hidden"   id="st_status_text<%=j%>" name="st_status_text"   value="<%=CommonUtil.nvl(rowData.get("STATUS"))%>">
					</td>
					<td>
						<a href="javascript:doPop('commonMpIvOrderInfoPop','<%=CommonUtil.nvl(rowData.get("BUYER_CODE"))%>' ,'<%=CommonUtil.nvl(rowData.get("PO_NO"))%>')" class="hyperLink" >
							<%=CommonUtil.nvl(rowData.get("PO_NO"))%>
						</a>
					</td>
					<td>
						<%=CommonUtil.nvl(rowData.get("INV_NO"))%>
					</td>
					<td>
						<a href="javascript:doPop('catalogDetailPop','<%=CommonUtil.nvl(rowData.get("BYIT_COMORG_CODE"))%>','<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>','<%=CommonUtil.nvl(rowData.get("CONTRACT_NO"))%>','<%=CommonUtil.nvl(rowData.get("CONTRACT_SEQ"))%>');" class="hyperLink" >
							<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>
						</a>
					</td>
					<td class="left">
						<%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%>
					</td>
					<td>
						<%=CommonUtil.nvl(rowData.get("MAKER_PART_NO"))%>
					</td>
					<td class="right">
						<%=CommonUtil.formatNumber(rowData.get("CD_QTY"),true,0,3)%>
					</td>
					<td>
						<%=CommonUtil.nvl(rowData.get("LEGACY_PO_NO"))%>
					</td>
					<td>
						<%=CommonUtil.nvl(rowData.get("DELIVERY_STATUS"))%>
					</td>
                </tr>                
            <%
                        } 
        			}
            %>
           		</tbody>
            </table>
            <input type="hidden" id="display_item_cnt" name="display_item_cnt" value="<%=page_display_cnt%>">
		<!-- 페이징 -->
		<p id="paging" class="paging">
			<%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow) %> 
		</p>  
		
		<!-- 버튼영역 -->
		<div class="btnArea">
        	<div class="fl">
			</div>
			<div class="fr">
				<span class="btn_08">
					<a href="javascript:doAction('request');">납품예정일 변경요청</a>
				</span>
				
				<span class="btn_08">
					<a href="javascript:doAction('request2');">수주접수 초기화요청</a>
				</span>
				
				<span class="btn_04">
					<a href="javascript:doAction('excelDown');">엑셀다운로드</a>
				</span>
			</div>
        </div>
</form>

<form name="processForm" id="processForm" method="post">	
	<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" />
	<input type="hidden" name="total_cnt" id="total_cnt"  value="<%=total_cnt %>"/>
	<input type="hidden" name="curPage" id="curPage"  value="<%=curPage %>"/>
	<input type="hidden" name="onepagerow" id="onepagerow"  value="<%=onepagerow %>"/>
	<input type="hidden" name="x" id="x" value="">
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
<script>
$(document).ready(function() {
<% 
			if (_gridList == null || _gridList.size() == 0){
			}else{
				for (int j=0; j<_gridList.size(); j++) {
					String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
%>
					if($("#st_status_text"+<%=j%>).val() == "발주" || $("#st_status_text"+<%=j%>).val() == "수주접수"){
						kepSetCalender('st_ds_date_text<%=j%>',"1","Y","<%=j%>");
					}else{
						$("#st_ds_date_text"+<%=j%>).css({"border":"0px", "backgroundColor":"<%=tclass%>"});
					}
<%
				}
			}
%>
		});
</script>