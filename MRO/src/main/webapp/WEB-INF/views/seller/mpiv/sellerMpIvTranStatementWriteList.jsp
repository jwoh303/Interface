<%--
**********************************************
* 메뉴 : 납품관리>거래명세서>거래명세서 작성
* 화면 : 거래명세서 작성
* 기능 : 수주접수 내역을 조회하고 거래명세서를 생성하기 위한 화면
* 프로그램 ID : PG_07_A_002_00
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
	//공통
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
var today = kepGetNowTimeStr("YYYYMMDD","");
var fromDate = kepToDateAdd("7","M","noslash");
var toDate = kepToDateAdd("7","P","noslash");

//최초 화면 함수 
function kep_onload_view(){
	
	var from_date = "${st_from_date}";
	
	var to_date = "${st_to_date}";
	
	var onepagerow = "${onepagerow}";
	
	if(kepIsValueNull("${st_from_date}")){
		
		
		from_date = kepToMonthAdd("3","M","noslash");
		to_date = kepGetNowTimeStr("YYYYMMDD","");
	}
	
	if(kepIsValueNull("${onepagerow}")){
		onepagerow = 50;
	}
	
	//조회조건 초기화(기존값 재설정)
	initSearchCondition("searchForm", "st_buyer_name", "${st_buyer_name}");	//구매회사명
	initSearchCondition("searchForm", "st_buyer_code", "${st_buyer_code}");	//구매회사코드
	initSearchCondition("searchForm", "st_po_no", "${st_po_no}");	//발주번호
	initSearchCondition("searchForm", "st_req_user_info", "${st_req_user_info}");	//요청정보
	initSearchCondition("searchForm", "st_from_date", from_date);	//발주일 시작일자
	initSearchCondition("searchForm", "st_to_date", to_date);		//발주일 종료일자
	
	// initSearchCondition("searchForm", "st_gr_flag", "${st_gr_flag}");	//입고완료제외 hidden값
	
	/* if(kepIsValueNull("${st_gr_flag}") ||  "${st_gr_flag}" == "GR"){
		$("#st_gr_flag").val("GR");
		$("#st_gr_flag_check").attr("checked", "checked");
	} else {
		$("#st_gr_flag_check").removeAttr("checked");
	} */
	
	initSearchCondition("searchForm", "onepagerow", onepagerow);	//페이징단위
	
	kepSetCalender('st_from_date');
	kepSetCalender('st_to_date');
	
	var searchYn = "${initSearchYn}";
	
	// 초기 화면호출시 자동조회
	if(searchYn != "N"){
		doAction("search");	
	}
}

function doAction(str) {
	switch (str) {
	case "search":	 //조회		
		kepSearch("1");
		break;
		
	case "reload":	//초기화
		kepReload("searchForm");
	
		// hidden값은 공통에서 처리안됨.
		$("#st_buyer_code").val("");
		$("#st_from_date").val(kepToMonthAdd("3","M",""));
		$("#st_to_date").val(kepGetNowTimeStr("YYYYMMDD","/"));
		
		/* $("#st_gr_flag").val("GR");
		$("#st_gr_flag_check").attr("checked", "checked"); */
		
// 		kepSearch("-1");
		jspTableClean("table_list");
		break;

	case "excelDown": // 엑셀다운로드
		//$('#searchForm').attr("action", "/mpiv/getExcelSellerMpIvTranStatementWriteList.do").submit();
		document.forms.searchForm.action = "/mpiv/excelSellerMpIvTranStatementWriteList.do";
		document.forms.searchForm.submit();
		break;
	}
}

/*
 * FORM 을 이용한조회
 */
function kepSearch(curPage){
	if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
	
	
	var diff = kepGetDateDiff('st_from_date','st_to_date','D');
	if (kepGetDateDiff('st_from_date','st_to_date','D') > 366){
		alert("12개월내 조회만 가능합니다.");
		return;
	}
	
	document.forms.searchForm.curPage.value = curPage;	
	$('#searchForm').attr("action", "/mpiv/getSellerMpIvTranStatementWriteList.do").submit();
}	
 
// 팝업 함수호출
function doPop(str,value1, value2) {
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
	}
}

/* function setCheckBox(){
	
	if($("#st_gr_flag_check").is(":checked")){
		$("#st_gr_flag").val("GR");
		
	} else {
		$("#st_gr_flag").val("ALL");
		
	}
} */

//거래명세서 작성
function setInvoiceCreate(num){
	//var agent = $("#st_com_code").val(); 
	
  
	var user_id = $("#st_user_id").val();
	
	var buyer 				= $("input[name=li_buyer]").eq(num).val();
	var po_no 				= $("input[name=li_po_no]").eq(num).val();
	var ds_date 			= $("input[name=li_ds_date]").eq(num).val();
	var rd_date 			= $("input[name=li_rd_date]").eq(num).val();
	var seller 				= $("input[name=li_seller]").eq(num).val();
	var process_type 		= $("input[name=li_process_type]").eq(num).val();
	var legacy_po_no 		= $("input[name=li_legacy_po_no]").eq(num).val();
	var tr_buyer 			= $("input[name=li_tr_buyer]").eq(num).val();
	var dely_to_location	= $("input[name=li_dely_to_location]").eq(num).val();
	var add_user_id 		= $("input[name=li_add_user_id]").eq(num).val();
	var ref_pr_no 			= $("input[name=li_ref_pr_no]").eq(num).val();
	var ds_flag 			= $("input[name=li_ds_flag]").eq(num).val();
	var agent 				= $("input[name=li_agent]").eq(num).val();
	var buyer_name 			= $("input[name=li_buyer_name]").eq(num).val();

	var pop_up_url 			= $("input[name=li_pop_up_url]").eq(num).val();
	var pop_up_type 		= $("input[name=li_pop_up_type]").eq(num).val();
	var buyer_slg 			= $("input[name=li_buyer_slg]").eq(num).val();
	
	var legacy_po_no_delimeter = legacy_po_no.substring(0,2);
	// var gr_flag = $("#st_gr_flag").val();

	// test id : MOOHAN
	// PO_NO : PO14002026
	//SLOGIC-BEGIN(P07-0000015) - 거래명세서 작성작업에 기한을 둠
	if(!isEmpty(buyer_slg)){

		var dateArr   =  setDateMsg( rd_date, num ); 
		 
		var msg = "고객사 납품요구일이 " + dateArr[0] +" 입니다.\n\n"
				+ dateArr[1] + " ~ " + dateArr[2] + " 기간내에만 작업이 가능합니다.\n\n"
				+ "(문의사항: 변상남 대리, 055-270-6208 / 010-2058-4564)" ;  
			
		var from_date = dateArr[1].replace(/[/]/gi,"");
		var to_date = dateArr[2].replace(/[/]/gi,"");
		
		if( eval(today) < eval(from_date) || eval(today) > eval(to_date) ){
			alert(msg);
			return;
		}
	}
	//SLOGIC-END
	
	var option = buildOption('930,600,no'); //width, height, scroll
 	
 	var url = "";
 	var param = "";
 	//var win = window.open("about:blank", "sellerMpIvTranStatementWritePop", option);
 	
 	//SLOGIC-BEGIN(P06-0000003) - 팝업이 상이한 특수로직
 	if(pop_up_type == "TYPE1" && TrimCommon(legacy_po_no_delimeter) == "20" && !isEmpty(pop_up_url)){
 		
 		// test id : DDTOOL 
 		// PO_NO : PO11000324
 		// 입고완료제외 체크 안하고 조회
 		
 		// DB pop_up_url data =->>  "http://ez-van.doosandst.co.kr/dhivan2/kep/index.asp?kepvndno="
 		url = pop_up_url;
 		param = agent;
 	} else if (pop_up_type == "TYPE2" && !isEmpty(pop_up_url)) {			// 두산인프라코어용..

 		
 		// DB pop_up_url data =->>  "/kr/agent/invoice/agent_invoice_di_pop.jsp"
 		// /mpiv/sellerMpIvTranStatementWriteDirectPop.do
 		url = pop_up_url;
 		
 		// test id : DMT0115	동명엠티에스
 		// 고객사 : 두산인프라코어(주)창원 
 	
		// test용 DB데이터 변경후 삭제
 		//url = "/mpiv/getSellerMpIvTranStatementWriteDiPop.do";
 		
 		document.forms.postPopForm.st_buyer.value=buyer;
		//document.forms.postPopForm.st_gr_flag.value=gr_flag;
		document.forms.postPopForm.st_process_type.value=process_type;
		document.forms.postPopForm.st_buyer_name.value=buyer_name;
		document.forms.postPopForm.st_com_code.value=$("#st_com_code").val();
		
		
 	} else if ( pop_up_type == "TYPE3" || ds_flag == "Y" ) {		// 분할납품 가능
 		
 	 	// test id : DMT0115	동명엠티에스 
 	 	//KRDONG0596	동명엠티에스주식회사	
 	 	
		// DB pop_up_url data =->>  "/kr/agent/invoice/agent_invoice_cre_doosanmeca_pop.jsp"
		
		// /mpiv/getSellerMpIvTranStatementWriteDoosanmecaPop.do
			
		//url = pop_up_url;
		
		url = "/mpiv/getSellerMpIvTranStatementWriteDoosanmecaPop.do";

		document.postPopForm.st_buyer.value=buyer;
		document.postPopForm.st_po_no.value=po_no;
		document.postPopForm.st_ds_date.value=ds_date;
		document.postPopForm.st_seller.value=seller;
		document.postPopForm.st_process_type.value=process_type;
		document.postPopForm.st_legacy_po_no.value=legacy_po_no;
		document.postPopForm.st_tr_buyer.value=tr_buyer;
		document.postPopForm.st_dely_to_location.value=dely_to_location;
		document.postPopForm.st_add_user_id.value=add_user_id;
		document.postPopForm.st_ref_pr_no.value=ref_pr_no;
		document.postPopForm.st_user_id.value=user_id;
		document.postPopForm.st_agent.value=agent;

 	} else {
 		// test id : YUHANADS
 		// po_no : PO14003184
		
		// default
		url = "/mpiv/getSellerMpIvTranStatementWritePop.do";
		//url = "/kr/agent/invoice/agent_invoice_cre_pop.jsp";
		
		document.forms.postPopForm.st_buyer.value=buyer;
		document.forms.postPopForm.st_po_no.value=po_no;
		document.forms.postPopForm.st_ds_date.value=ds_date;
		document.forms.postPopForm.st_seller.value=seller;
		document.forms.postPopForm.st_process_type.value=process_type;
		document.forms.postPopForm.st_legacy_po_no.value=legacy_po_no;
		document.forms.postPopForm.st_tr_buyer.value=tr_buyer;
		document.forms.postPopForm.st_dely_to_location.value=dely_to_location;
		document.forms.postPopForm.st_add_user_id.value=add_user_id;
		document.forms.postPopForm.st_ref_pr_no.value=ref_pr_no;
		document.forms.postPopForm.st_user_id.value=user_id;
		
 	}
	//SLOGIC-END

	/*
 	console.log("=========== 거래명세서 팝업 정보 START =======");
 	console.log("pop_up_type ==>> " + pop_up_type);
 	console.log("legacy_po_no_delimeter ==>> " + TrimCommon(legacy_po_no_delimeter));
 	console.log("process_type ==>> " + process_type);
 	console.log("ds_flag ==>> " + ds_flag);
 	console.log("url ==>> " + url);
 	console.log("param ==>> " + param);
 	console.log("=========== 거래명세서 팝업 정보 END =======");
 	*/
//  	var win = window.open(url+param, "sellerMpIvTranStatementWritePop", option);
 	openSearchPopupPost(url, "postPopForm", "sellerMpIvTranStatementWrite",option);
}

function setDateMsg(date, num){  

	var fRdDate = kepDateSlashAdd(date);
	var fFromDate = kepDateAdd("li_rd_date"+num, 7, "M");
	var fToDate = kepDateAdd("li_rd_date"+num, 7, "P");
	
	dateForm = new Array(fRdDate, fFromDate, fToDate );
	return dateForm;
	
}


function setBuyerChoiceReturn(buyer, com_name){
	$("#st_buyer_code").val(buyer);
	$("#st_buyer_name").val(com_name);
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
	<h3>거래명세서 작성</h3>
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
		<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">
		<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
		<input type="hidden" name="initSearchYn" id="initSearchYn" value="N" />
		
		<div id="cont_searchA">	
			<table class="cont_t_list01">
				<caption>조회</caption>
				<colgroup>
					<col width="7%" />
					<col width="20%" />
					<col width="6%" />
					<col width="20%" />
					<col width="6%" />
                    <col width="20%" />
                    <col width="6%" />
                    <col width="*" />
				</colgroup>
				
				<tbody>
					<tr>
						<td>수주접수일</td>
						<td colspan="3">
							<input type="text"   name="st_from_date" size="10" id="st_from_date" class="input_type_text"  value="" readonly>
							&nbsp;~&nbsp;
							<input type="text"   name="st_to_date" size="10" id="st_to_date" class="input_type_text"  value="" readonly>
							
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','6')">6개월</a></span> 
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','12')">12개월</a></span> 
						</td>
						<td>고객사</td>
						<td>
							<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:65%;ime-mode:active" value="" READONLY>
							<input type="hidden" name="st_buyer_code" id="st_buyer_code" value="">
							<a href="javascript:doPop('commonMpIvTranBuyerChoicePop');"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
							<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
						</td>
						<td></td>
						<td></td>
						<td></td>
					   
						<%-- <td>
							<input class="Noborder" type="checkbox" id="st_gr_flag_check" name="st_gr_flag_check"  value="" onChange="setCheckBox();" =(pGrFlag.equals("GR") ? "checked" : "")>
							<input type="hidden"   id="st_gr_flag" name="st_gr_flag" value="" />
							<b><font color="#333333">입고완료제외</font></b>
						</td> --%>
					</tr>
					<tr>
						<td>발주번호</td>
							<td>
							   <input type="text" class="input_type_text" name="st_po_no" id="st_po_no" style="width:80%;" value="" onKeyDown="kepEnter();">
							</td>					
							<td>요청정보</td>
							<td>
								<input type="text" class="input_type_text" name="st_req_user_info" id="st_req_user_info" style="width:80%;" value="" onKeyDown="kepEnter();">
							</td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
					</tr>
				</tbody>
			</table>
		</div>
		<span>※ [거래명세서 생성] 버튼을 클릭하면, 거래명세서 작성이 가능합니다.</span> 
		<br>
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
	  	
		<table  id="table_list" class="cont_t_list02" style="width:100%">
			<colgroup>
	            <col width="13%" />
	            <col width="*" />
	            <col width="7%" />
	            <col width="10%" />
	            <col width="13%" />
	            <col width="13%" />
	            <col width="10%" />
	            <col width="13%" />
	        </colgroup>
	        <thead>
			<tr>
                <th scope="col">발주번호</th>
                <th scope="col">고객사</th>
            	<th scope="col">품목 수</th>				
                <th scope="col">총 금액</th>
                <th scope="col">납기요청일</th>
                <th scope="col">납품예정일</th>
                <th scope="col">거래명세서</th>
                <th scope="col">KeP담당자</th>
			</tr>
		</thead>
		<tbody>
 		<%
        if (_gridList == null || _gridList.size() == 0){
        %>
                    <tr>
                        <td colspan="11" align="center" height = "50"> 
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
                    <td title="발주번호">
                    	<a class="hyperLink" style="color:#0066cc;" href="javascript:doPop('commonMpIvOrderInfoPop','<%=String.valueOf(rowData.get("BUYER"))%>','<%=String.valueOf(rowData.get("PO_NO"))%>');">
	                    	<%=String.valueOf(CommonUtil.nvl(rowData.get("PO_NO")))%>
                    </td>
                    <td title="고객사" class="left">
                   		<a class="hyperLink" href="javascript:doPop('agent','<%=String.valueOf(rowData.get("BUYER2"))%>');">
                   			<%=String.valueOf(CommonUtil.nvl(rowData.get("BUYER_NAME")))%>
                   		</a>
                   	</td>
                    <td title="품목 수" class="right"><%=CommonUtil.formatNumber(rowData.get("DS_ITEM_QTY"),true,0,0)%></td>
                    <td title="총 금액" class="right"><%=CommonUtil.formatNumber(rowData.get("AGENT_SUM_PRICE"),true,0,3)%></td>
                    <td title="납기요청일"><%=CommonUtil.formatStrinigDate(CommonUtil.nvl(rowData.get("RD_DATE")))%></td>

                    <td title="납품예정일">
                    	<input type="hidden" name="li_buyer" value="<%=CommonUtil.nvl(rowData.get("BUYER"))%>" />
                    	<input type="hidden" name="li_po_no" value="<%=CommonUtil.nvl(rowData.get("PO_NO"))%>" />
                    	<input type="hidden" name="li_ds_date" value="<%=CommonUtil.nvl(rowData.get("DS_DATE"))%>" />
                    	<input type="hidden" name="li_rd_date" id="li_rd_date<%=j%>" value="<%=CommonUtil.nvl(rowData.get("RD_DATE"))%>" />
                    	<input type="hidden" name="li_seller" value="<%=CommonUtil.nvl(rowData.get("SELLER"))%>" />
                    	<input type="hidden" name="li_process_type" value="<%=CommonUtil.nvl(rowData.get("PROCESS_TYPE"))%>" />
                    	<input type="hidden" name="li_legacy_po_no" value="<%=CommonUtil.nvl(rowData.get("LEGACY_PO_NO"))%>" />
                    	<input type="hidden" name="li_tr_buyer" value="<%=CommonUtil.nvl(rowData.get("TR_BUYER"))%>" />
                    	<input type="hidden" name="li_dely_to_location" value="<%=CommonUtil.nvl(rowData.get("DELY_TO_LOCATION"))%>" />
                    	<input type="hidden" name="li_add_user_id" value="<%=CommonUtil.nvl(rowData.get("ADD_USER_ID"))%>" />
                    	<input type="hidden" name="li_ref_pr_no" value="<%=CommonUtil.nvl(rowData.get("REF_PR_NO"))%>" />
                    	<input type="hidden" name="li_ds_flag" value="<%=CommonUtil.nvl(rowData.get("H_DS_FLAG"))%>" />
                    	<input type="hidden" name="li_agent" value="<%=CommonUtil.nvl(rowData.get("AGENT"))%>" />
                    	<input type="hidden" name="li_buyer_name" value="<%=CommonUtil.nvl(rowData.get("BUYER_NAME"))%>" />
                    	
                    	<!-- 특수로직 -->
                    	<input type="hidden" name="li_pop_up_url" value="<%=CommonUtil.nvl(rowData.get("POP_UP_URL"))%>" />
                    	<input type="hidden" name="li_pop_up_type" value="<%=CommonUtil.nvl(rowData.get("POP_UP_TYPE"))%>" />
                    	<input type="hidden" name="li_buyer_slg" value="<%=CommonUtil.nvl(rowData.get("BUYER_SLG"))%>" />
                    	
	                    <%=CommonUtil.formatStrinigDate(CommonUtil.nvl(rowData.get("DS_DATE")))%>
                    </td>
                    <td title="거래명세서">
                    	<span class="btn_03">
		                    <a style="font-size:9px;" href="javascript:setInvoiceCreate(<%=j%>);">
		                    	거래명세서 생성
			                </a>
		                </span>
					</td>
                     <td title="KeP담당자"><%=CommonUtil.nvl(rowData.get("KEP_USER_INFO"))%></td>
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
	<div id="process">
	
	</div>
</form>
<form name="postPopForm" id="postPopForm" method="post" action ="">
	<input type="hidden" name="st_com_code"  id="st_com_code" value="">
    <input type="hidden" name="st_buyer"  id="st_buyer" value="">
    <input type="hidden" name="st_buyer_name"  id="st_buyer_name" value="">
    <input type="hidden" name="st_po_no"  id="st_po_no" value="">
    <input type="hidden" name="st_ds_date"  id="st_ds_date" value="">
    <input type="hidden" name="st_seller"  id="st_seller" value="">
    <input type="hidden" name="st_process_type"  id="st_process_type" value="">
    <input type="hidden" name="st_legacy_po_no"  id="st_legacy_po_no" value="">
    <input type="hidden" name="st_tr_buyer"  id="st_tr_buyer" value="">
    <input type="hidden" name="st_dely_to_location"  id="st_dely_to_location" value="">
    <input type="hidden" name="st_add_user_id"  id="st_add_user_id" value="">
    <input type="hidden" name="st_ref_pr_no"  id="st_ref_pr_no" value="">
    <input type="hidden" name="st_user_id"  id="st_user_id" value="">    
    <input type="hidden" name="st_agent"  id="st_agent" value="">    
    <!-- <input type="hidden" name="st_gr_flag"  id="st_gr_flag" value=""> -->
</form>			 
</div>

<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/sellerFooter.jsp" %>   
</div>
</body>
</html>
