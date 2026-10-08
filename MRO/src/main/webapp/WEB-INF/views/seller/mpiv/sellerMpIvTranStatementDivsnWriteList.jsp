<%--
**********************************************
* 메뉴 : 납품관리>거래명세서>거래명세서 작성(일괄)
* 화면 : 거래명세서 작성(일괄)
* 기능 : 발주 단위가 아닌 분할 거래명세서를 생성하는 경우 사용
* 프로그램 ID : PG_07_A_003_00
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
	
	String total_cnt = "0";
	if(_gridList != null && _gridList.size() > 0){
		total_cnt = _gridList.size()+"";	
	}
	
	//String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
	
	// 조회조건 S
	String p_buyer			= CommonUtil.nvl((String)request.getAttribute("st_buyer"));
	String p_tr_buyer = "";
	
	
	String stx_rpt = "";
	String dsn_rpt = "";
	
	
	/*
	String st_search_type = CommonUtil.nvl((String) request.getParameter("st_search_type"),"");  // 조회필드콤보
	String st_search_code = CommonUtil.nvl((String) request.getParameter("st_search_code"),"");  // 
	String st_btoa_user_dept_code = CommonUtil.nvl((String) request.getParameter("st_btoa_user_dept_code"),"");  // 요청부서코드
	String st_btoa_user_dept_name = CommonUtil.nvl((String) request.getParameter("st_btoa_user_dept_name"),"");  // 요청부서명
	String st_sourcing_status = CommonUtil.nvl((String) request.getParameter("st_sourcing_status"),"");  // 진행상태
	String st_quotation_no = CommonUtil.nvl((String) request.getParameter("st_quotation_no"),"");  // 견적번호
	*/
	// 조회조건 E
	
	int page_display_cnt = 0;
%> 
<script type="text/javascript">
var popupSel = "";

// 최초 화면 함수 
function kep_onload_view(){
	
	//initSearchCondition("searchForm", "st_buyer_name", "두산디에스티주식회사");	//구매회사명
	//initSearchCondition("searchForm", "st_buyer_code", "KRDOOS0036");	//구매회사코드
	
	initSearchCondition("searchForm", "st_buyer_name", "${st_buyer_name}");	//구매회사명
	initSearchCondition("searchForm", "st_buyer_code", "${st_buyer_code}");	//구매회사코드
	initSearchCondition("searchForm", "st_req_user_info", "${st_req_user_info}");	//요청정보
	initSearchCondition("searchForm", "st_gr_flag", "${st_gr_flag}");	//입고완료제외 hidden값
	
	if(kepIsValueNull("${st_gr_flag}") ||  "${st_gr_flag}" == "GR"){
		$("#st_gr_flag").val("GR");
		$("#st_gr_flag_check").attr("checked", "checked");
	} else {
		$("#st_gr_flag").val("ALL");
		$("#st_gr_flag_check").removeAttr("checked");
	}
	
	kepSetCalender('st_invoice_date_text');	
}

//기능함수
function doAction(str) {
	switch (str) {
		case "search":	 //조회
			kepSearch("1");
			break;
			
		case "reload":	//초기화
			kepReload("searchForm");
			
			// hidden값은 공통에서 처리안됨.
			$("#st_buyer_code").val("");
			
			$("#st_gr_flag").val("GR");
			$("#st_gr_flag_check").attr("checked", "checked");
			
// 			kepSearch("-1");
			jspTableClean("table_list");
			
			break;
			
		case "create":	// 거래명세서 생성
			
			var buyer = "${st_buyer_code}";
			var req_user_info = "${st_req_user_info}";
			var gr_flag = "${st_gr_flag}";

			var query       = "";
			var tot_cnt      = document.contentForm.display_item_cnt.value;
			var chk_cnt = 0;
			
			var itemValChk = false;
			var invValChk = false;
			var buyCloseDateChk = false;
			var invVal = "";
			var valSeq = 0;
			
			// MSDS 진행 통제
			var msds_query = ""; // MSDS 등록용
			var cod_check	= ""; //ICOMCOD1 에 있는지 체크하는 변수
			var msds_check	= ""; //BYIT.MSDS_NO의 null여부
			var req_check   = ""; //KEP_CMC_REQ 의 상태 체크
			var msds_po_no = "";
			var msds_po_no_bef = ""; // 동일 발주번호 중복 제출요청 방지용
			var buyer_item_no_arr = []; //등록해야할 품목코드
			var msds_no_reg_buyer_item_no_arr = []; //카탈로그에 MSDS 미등록 품목코드
			
			// 매입단가유효일 진행 통제
			var buy_close_date_chk = ""; // 매입단가유효일 체크
			
			// 일괄 거래명세서 작성 막기(아모레, 중외) 보관조건에 따라 납품방법 통제 등이 까다로워 빠른 오픈 위해 임시방편 하드코딩 2025.06.27 HSJ(아이디어 있는 사람이 수정해보세요)
			if(buyer == "KRAMOR0003" || buyer == "KRAMOR0004" || buyer == "KRAMOR0005" || buyer == "KRAMOS0006" || buyer == "KRESPO0003" || buyer == "KRETUD0002" ||
					buyer == "KRINNI0002" || buyer == "KRJW-L0001" || buyer == "KRJWPH0001" || buyer == "KROSUL0002"){
				alert("해당 고객사는 일괄 거래명세서 작성을 사용할 수 없습니다.");
				return;
			}
			
			for(var i = 0 ; i < tot_cnt ; i++){
				var box = eval("document.contentForm.checkbox" + i);
				
				if(box.checked == true){
					++chk_cnt;
					var pop_key = $("input[name='pop_key']").eq(i).val();
					
					var item_qty = $("input[name='item_qty']").eq(i).val();	// 발주수량
					var cd_qty = $("input[name='cd_qty']").eq(i).val();		// 납품수량
					var inv_poss_qty = $("input[name='inv_poss_qty']").eq(i).val();		// 납품가능수량
					
					// MSDS 진행 통제 체크
					cod_check = $("input[name='st_cod_check']").eq(i).val();
			    	msds_check = $("input[name='st_msds_check']").eq(i).val();
			    	req_check = $("input[name='st_req_check']").eq(i).val();
			    	msds_po_no = $("input[name='st_po_no']").eq(i).val();
					
			    	if(i > 0){
			    		msds_po_no_bef = $("input[name='st_po_no']").eq(i-1).val();
					}
			    	
			    	if(cod_check=="Y" && msds_check=="Y" && req_check=="N"){ //물질정보등록 대상이면서 msds미매핑 건 이면서 입력요청 외에 다른 상태 건 이 없는 경우 거래명세서 작성 통제
			     		buyer_item_no_arr.push($("input[name='st_buyer_item_no']").eq(i).val());
			    	
			     		if(msds_po_no != msds_po_no_bef){ // 중복 발주번호는 전송하지 않음, 대상 품목 있는 발주번호만 전송
							msds_query +=  buyer      + "@@";
							msds_query +=  msds_po_no + "@@";
							msds_query +=  "^||^";	
						}
			     	}
			    	
			    	if(cod_check=="Y" && msds_check=="Y"){ // MSDS 대상 표준카테고리에 해당하고 카탈로그 MSDS 미매핑 품목 리스트 - 통제 2024.07.19 HSJ
			    		msds_no_reg_buyer_item_no_arr.push($("input[name='st_buyer_item_no']").eq(i).val());	
			     	}
					
			    	// 매입단가유효일 진행 통제
			    	buy_close_date_chk = $("input[name='st_buy_close_date_chk']").eq(i).val();
					if(buy_close_date_chk == "Y"){
						buyCloseDateChk = true;
						valSeq = i;
						break;
						
					}
					
					if(parseInt(cd_qty) > parseInt(item_qty)){
						itemValChk = true;
						valSeq = i;
						break;
					}
					
					if(parseInt(cd_qty) > parseInt(inv_poss_qty)){
						invValChk = true;
						invVal = inv_poss_qty;
						valSeq = i;
						break;
					}
					
					query +=  pop_key + "@@";
					query +=  cd_qty;                
					query +=  "^||^";
				}
			}
			
			if(itemValChk){
				alert("납품수량이 발주수량보다 클 수 없습니다.");
				$("input[name='cd_qty']").eq(valSeq).focus();		// 납품수량
				return;
			}
			
			if(invValChk){
				alert("납품가능수량(" + invVal + ") 이하로 입력해주십시오.");
				$("input[name='cd_qty']").eq(valSeq).focus();		// 납품수량
				return;
			}
			
			if(buyCloseDateChk){
				alert("해당 발주(" + msds_po_no + ") 건 진행할 수 없습니다.\n화면에 표기된 KeP담당자에게 문의하시기 바랍니다.");
				return;
			}
			
			//console.log("query ==>> " + query);
			$("#st_query").val(query);
			
			if(chk_cnt == 0){
				alert("거래명세서 생성할 건을 선택해주십시오.");
				return;
			}
			
			if(buyer_item_no_arr.length != 0){ //수주접수 통제해야되는 건이 있는 경우
				if(confirm("해당 품목 ("+buyer_item_no_arr+") 은 산업안전보건법 상 MSDS 제공 대상입니다.\n\n카탈로그 관리 > 물질정보 제출 화면으로 이동하셔서 MSDS 및 물질정보 제출 후 KEP에서 MSDS매핑이 완료되면 거래명세서 작성하시기 바랍니다.\n\n확인을 누르면 물질정보 제출 요청이 됩니다.\n원하지 않으면 취소를 누르세요.\n\n*문의사항은 거래명세서 작성 화면에 있는 KeP담당자 통해서 하시길 바랍니다.")){
					//KEP_CMC_REQ insert 코드
					$("#st_msds_query").val(msds_query);
					kepAjaxFormCall("/mpiv/saveSellerMpIvTranStatementWriteChemicalInfo.do","contentForm","saveChemInfo");
				}
				return;
			}
			
			if(msds_no_reg_buyer_item_no_arr.length != 0){
				alert("해당 품목 ("+msds_no_reg_buyer_item_no_arr+") 은 산업안전보건법 상 MSDS 제공 대상입니다.\n현재 MSDS가 매핑되어 있지 않아 진행이 불가하니 확인하여 주시기 바랍니다.\n*문의사항은 거래명세서 작성 화면에 있는 KeP담당자 통해서 하시길 바랍니다.");
				return;
			}
			
			window.open("", "sellerMpIvTranStatementDivsnWritePop", buildOption('1000,600,no'));
			//win.location.href = "/mpiv/getSellerMpIvTranStatementDivsnWritePop.do";
			
			var hdnKey = "st_buyer_code|st_req_user_info|st_gr_flag|st_com_code";
			var hdnVal = "${st_buyer_code}|${st_req_user_info}|${st_gr_flag}|${sessionInfo.comCode}";
			
			$("#contentForm").append(kepHiddenString(hdnKey, hdnVal));
			
			$("#st_seller").val($("input[name='li_seller']").eq(0).val()); 
			
			//console.log("============ create start =============");
			//console.log($("#contentForm").serialize());
			//console.log("============ create end =============");
			
			document.forms.contentForm.target = "sellerMpIvTranStatementDivsnWritePop";
			document.forms.contentForm.action = "/mpiv/getSellerMpIvTranStatementDivsnWritePop.do";
			document.forms.contentForm.submit();
			
			//inSetInvoiceCreate();
			break;
	}
}

// 조회
function kepSearch(curPage){
	if(curPage == "1"){
		if(kepIsEmpty("st_buyer_code")){
			alert("고객사를 선택해주십시오.");
			return;
		}
		
		var buyer = "${st_buyer_code}";
		
		// 일괄 거래명세서 작성 막기(아모레, 중외) 보관조건에 따라 납품방법 통제 등이 까다로워 빠른 오픈 위해 임시방편 하드코딩 2025.06.27 HSJ(아이디어 있는 사람이 수정해보세요)
		if(buyer == "KRAMOR0003" || buyer == "KRAMOR0004" || buyer == "KRAMOR0005" || buyer == "KRAMOS0006" || buyer == "KRESPO0003" ||
				buyer == "KRETUD0002" || buyer == "KRINNI0002" || buyer == "KRJW-L0001" || buyer == "KRJWPH0001" || buyer == "KROSUL0002"){
			alert("해당 고객사는 일괄 거래명세서 작성을 사용할 수 없습니다.");
			return;
		}
	}
	
	$('#searchForm').attr("target","_self");
	$('#searchForm').attr("action", "/mpiv/getSellerMpIvTranStatementDivsnWriteList.do").submit();   
}

// 팝업 함수호출
function doPop(str,value1, value2, value3, value4, value5) {
	switch (str) {
		case "agent": // 고객사정보
			openSearchPopup("/common/agentInfoDisplayPop.do", "?st_com_code="+value1, "800,550,no");
			break;
			
		case "commonMpIvTranBuyerChoicePop": // 고객사선택
			openSearchPopup("/mpiv/getCommonMpIvTranBuyerChoicePop.do", "?invoice_flag=Y&st_com_code="+$("#st_com_code").val(), "720,505,no");
			break;
			
		case "commonMpIvOrderInfoPop": // 발주번호 click시 발주정보 팝업
			openSearchPopup("/mpiv/getCommonMpIvOrderInfoPop.do", "?st_buyer="+value1+"&st_po_no="+value2, "930,600,no");
			break;
			
		case "catalogDetailPop": // 품목상세정보
			getBuyerCatalogDisplayPop(value1, value2, value3, value4);
			break;
		case "msdsDetailPop": //msds
			openSearchPopup("/coco/showCommonCoCoMsdsDetailPop.do","?st_msds_no="+value1+"&st_btn_yn=N",'750,580,no');
			break;
	}
}

function setCheckBox(){
	
	if($("#st_gr_flag_check").is(":checked")){
		$("#st_gr_flag").val("GR");
		
	} else {
		$("#st_gr_flag").val("ALL");
		
	}
}

function checkRemark(){
	
    if(kepGetByteLength("st_remark")>120){
        alert("비고란에 입력한 내용이 입력가능한 크기를 초과하였습니다.\n\n※한글(2byte) 영문,숫자,특수문자(1byte)로 120byte를 초과할 수 없습니다.")
        document.forms[0].st_remark.focus();
        return ;
    }   
}

//전체선택/해제
function checkAll(){
	var tot_cnt      = document.contentForm.display_item_cnt.value;
	//var check_status = document.forms[0].check_status.value;
	var check_status = $("#check_status").html();
	
	if(check_status == "전체"){
		for(var j = 0; j < tot_cnt; j++){
			var box = eval("document.contentForm.checkbox" + j);
			var check_status = "해제";
			
			if(box.checked == false) box.checked = true;
			
			//document.forms[0].check_status.value = check_status;
			$("#check_status").html(check_status);
		}
	} else {
		for(var j = 0; j < tot_cnt; j++){
			var box = eval("document.contentForm.checkbox" + j);
			var check_status = "전체";
			
			if(box.checked == true) box.checked = false;
			
			//document.forms[0].check_status.value = check_status;
			$("#check_status").html(check_status);
		}
	}
}

function setBuyerChoiceReturn(buyer, com_name){
	$("#st_buyer_code").val(buyer);
	$("#st_buyer_name").val(com_name);
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	if(pMethod == "saveChemInfo"){
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
	<h3>거래명세서 작성(일괄)</h3>
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
		<!-- 화면 내 정의 -->
		<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
		
		<div id="cont_searchA">	
			<table class="cont_t_list01">
				<caption>조회</caption>
				<colgroup>
					<col width="8%" />
					<col width="25%" />
					<col width="9%" />
					<col width="*%" />
				</colgroup>
				
				<tbody>
					<tr>
						<td><font color="red">*</font> 고객사</td>
						<td>
							<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:65%;ime-mode:active" value="" READONLY>
							<input type="hidden" name="st_buyer_code" id="st_buyer_code" value="">
							<a href="javascript:doPop('commonMpIvTranBuyerChoicePop');"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
							<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
						</td>
						<td>요청정보</td>
						<td>
							<input type="text" class="input_type_text" name="st_req_user_info" id="st_req_user_info" style="width:90%;" value="" onKeyDown="kepEnter();">
						</td>
					</tr>
					<tr>
						<td class="right" colspan="4">
							<input type="checkbox" class="Noborder" id="st_gr_flag_check" name="st_gr_flag_check"  value="" onChange="setCheckBox();" <%--=(pGrFlag.equals("GR") ? "checked" : "")--%>>
							<input type="hidden"   id="st_gr_flag" name="st_gr_flag" value="" />
							<b><font color="#333333">입고완료제외</font></b>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<span class="fr">총건수 <%=total_cnt %></span>
       	<br>
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<input type="hidden" id="st_query" name="st_query" value="" />
		<input type="hidden" id="st_seller" name="st_seller" value="" />
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
		<!-- 공통 -->
		<table id="table_list"  class="cont_t_list02" style="width:100%">
			<colgroup>
	            <col width="2%" />
	            <col width="6%" />
	            <col width="7%" />
	            <col width="7%" />
	            <col width="8%" />
	            <col width="5%" />
	            <col width="7%" />
	            <col width="15%" />
	            <col width="8%" />
	            <col width="6%" />
	            <col width="10%" />
	            <col width="6%" />
	            <col width="*" />
	        </colgroup>
	        <thead>
				<tr>
					<th scope="col" rowspan="2">
						<a href="javascript:checkAll();" id="check_status">전체</a>
					</th>
	                <th scope="col" rowspan="2">발주일</th>
	                <th scope="col">주문번호</th>
	                <th scope="col" rowspan="2">납품총금액</th>
	                <th scope="col">납기요청일</th>
	                <th scope="col" rowspan="2">발주비고</th>
	                <th scope="col" rowspan="2">품목코드</th>
	                <th scope="col">품목명/제조사</th>
	                <th scope="col">발주수량</th>
	                <th scope="col">단가</th>
	                <th scope="col">요청자</th>
	                <th scope="col" rowspan="2">선입고여부</th>
	                <th scope="col" rowspan="2">비고</th>
				</tr>
				<tr>
	                <th scope="col">발주번호</th>
	                <th scope="col">납기예정일</th>
	                <th scope="col">규격</th>
	                <th scope="col">납품수량/단위</th>
	                <th scope="col">공급가</th>
	                <th scope="col">도착지정보</th>
				</tr>
		</thead>
		<tbody>
 		<%
        if (_gridList == null || _gridList.size() == 0){
        %>
                    <tr>
                        <td colspan="13" align="center" height = "50"> 
                        <span>조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
        <%
        }else{
        	
        	String po_no = "";
        	String pre_po_no = "";
        	String  tclass = "#FAFAFA";
			for (int j=0; j<_gridList.size(); j++) {
				page_display_cnt++;
				Map<String,String> rowData = _gridList.get(j);
				//String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
				
				po_no = CommonUtil.nvl(rowData.get("PO_NO"));
				if(!pre_po_no.equals(po_no)){
					if(tclass.equals("#FFFFFF")){
						tclass = "#FAFAFA";
					} else {
						tclass = "#FFFFFF";	
					}	
				}
				
		%> 
				<tr bgcolor="<%=tclass%>">
					<!-- HIDDEN 공통 -->
          			<td rowspan ="2">
  						<input type="checkbox" name="checkbox<%=j%>" value="<%=CommonUtil.nvl(rowData.get("POP_KEY"))%>"/>
  						<input type="hidden" name="pop_key" value="<%=CommonUtil.nvl(rowData.get("POP_KEY"))%>" />
  						<input type="hidden" name="li_seller" value="<%=CommonUtil.nvl(rowData.get("SELLER"))%>" />
  						
  						<input type="hidden" name="st_cod_check" value="<%=CommonUtil.nvl(rowData.get("COD_CHECK"))%>">
						<input type="hidden" name="st_msds_check" value="<%=CommonUtil.nvl(rowData.get("MSDS_CHECK"))%>">
						<input type="hidden" name="st_req_check" value="<%=CommonUtil.nvl(rowData.get("REQ_CHECK"))%>">
						<input type="hidden" name="st_buyer_item_no" value="<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>">
						<input type="hidden" name="st_po_no" value="<%=CommonUtil.nvl(rowData.get("PO_NO"))%>">
						<input type="hidden" id="st_msds_query" name="st_msds_query" value="" />
						<input type="hidden" name="st_buy_close_date_chk" value="<%=CommonUtil.nvl(rowData.get("BUY_CLOSE_DATE_CHK"))%>">
	  				</td>
					<td title="발주일" rowspan ="2">
						<%=CommonUtil.formatStrinigDate(rowData.get("PO_CREATE_DATE"))%>
					</td>
					<td title="주문번호"><%=CommonUtil.nvl(rowData.get("PX_NO"))%></td>
	                <td title="납품총금액" class="right pr10" rowspan="2"><%=CommonUtil.formatNumber(rowData.get("AGENT_TOT_AMT"),true,0,3)%></td>
	                <td title="납기요청일"><%=CommonUtil.formatStrinigDate(rowData.get("RD_DATE"))%></td>
	                <td rowspan="2">
	                	<!-- 발주비고 -->
	                	<a class="tip">
	                	<img src="/resources/images/icon2.gif" />
	                	<span><%=CommonUtil.nvl(rowData.get("PO_REMARK"))%></span>
	                	</a>
	                	
	                	
	                </td>
	                <td title="품목코드" rowspan="2">
	                	<a class="hyperLink" href="javascript:doPop('catalogDetailPop','<%=CommonUtil.nvl(rowData.get("BYIT_COMORG_CODE"))%>','<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>','<%=CommonUtil.nvl(rowData.get("CONTRACT_NO"))%>','<%=CommonUtil.nvl(rowData.get("CONTRACT_SEQ"))%>');">
	                		<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>
	                	</a><br>
						<%
							if(!CommonUtil.nvl(rowData.get("MSDS_NO")).equals("")) { 
						%>  
								<a class="hyperLink" href="javascript:doPop('msdsDetailPop','<%=CommonUtil.nvl(rowData.get("MSDS_NO"))%>');">
									<font color=red><b>(MSDS)</b></font>
								</a>
						<%
							} 
						%>  
	                </td>
	                <td title="품명/제조사" class="left pl05" ><%=CommonUtil.nvl(rowData.get("MAKER_NAME"))%></td>
	                <td title="발주수량" class="right" ><%=CommonUtil.formatNumber(rowData.get("ITEM_QTY"),true,0,3)%></td>
	                <td title="단가" class="right pr10" ><%=CommonUtil.formatNumber(rowData.get("AGENT_PRICE"),true,0,3)%></td>
	                <td title="요청자" class="left pl05" ><%=CommonUtil.nvl(rowData.get("PURCHASER_NAME"))%></td>
	                <td title="선입고여부"  rowspan="2"><%=CommonUtil.nvl(rowData.get("BFRE_STCK_YN"))%></td>
	                <td title="품목별비고" class="left" rowspan="2"><%=CommonUtil.nvl(rowData.get("ITEM_PO_REMARK"))%></td>
				</tr>
				<tr bgcolor="<%=tclass%>">
                    <td title="발주번호">
						<a class="hyperLink" href="javascript:doPop('commonMpIvOrderInfoPop','<%=String.valueOf(rowData.get("BUYER"))%>','<%=String.valueOf(rowData.get("PO_NO"))%>');">
                    		<%=CommonUtil.nvl(rowData.get("PO_NO"))%>
                    	</a>
                    </td>
	                <td title="납기예정일"><%=CommonUtil.formatStrinigDate(rowData.get("DS_DATE"))%></td>
	                <td title="규격" class="left pl05" ><%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%></td>
	                <td title="납품수량/단위" class="right" >
	                	<div class="fl" style="width:65%;">
                	<%
                		if(CommonUtil.nvl(rowData.get("DS_FLAG")).equals("Y") && CommonUtil.nvl(rowData.get("DS_YN")).equals("Y")){
                	%>
                			<input type="hidden" name="ds_flag" value="<%=CommonUtil.nvl(rowData.get("DS_YN"))%>" />
                			<input type="hidden" name="inv_poss_qty" value="<%=CommonUtil.nvl(rowData.get("INV_POSS_QTY"))%>">
                			<input type="hidden" name="item_qty" value="<%=CommonUtil.nvl(rowData.get("ITEM_QTY"))%>">
                			<input type="text" name="cd_qty" value="<%=CommonUtil.nvl(rowData.get("INV_POSS_QTY"))%>" style="width:100%;text-align:right;">
                	<%
                		} else {
                	%>
	                		<%=CommonUtil.nvl(rowData.get("CD_QTY"))%>
	                		<input type="hidden" name="cd_qty" value="<%=CommonUtil.nvl(rowData.get("CD_QTY"))%>">
	                		<input type="hidden" name="item_qty" value="<%=CommonUtil.nvl(rowData.get("ITEM_QTY"))%>">
	                		<input type="hidden" name="inv_poss_qty" value="<%=CommonUtil.nvl(rowData.get("INV_POSS_QTY"))%>">
                	<%
                		}
                	%>
                		</div>
                		<div class="fr">
	                		/<%=CommonUtil.nvl(rowData.get("UNIT_MEASURE"))%>
	                	</div>
	                </td>
	                <td title="공급가" class="right pr10" ><%=CommonUtil.formatNumber(rowData.get("SUPP_PRICE"),true,0,3)%></td>
	                <td title="도착지정보" class="left pl05" ><%=CommonUtil.nvl(rowData.get("DELY_TO_LOCATION"))%></td>
				</tr>
            <%
            				pre_po_no = po_no;
                        } 
        			}
            %>
           		</tbody>
            </table>
          	<input type="hidden" id="display_item_cnt" 	name="display_item_cnt"    value="<%=page_display_cnt%>">
		
		<!-- 버튼영역 -->
		<div class="btnArea" style="valign:middel;">
			<div class="am fr">
				납품 비고 : <input type="text" id="st_remark" name="st_remark" size="90" maxlength="120" value="" onChange="checkRemark()">
				&nbsp;&nbsp;
				 납품일 : <input type="text"   name="st_invoice_date_text" size="10" id="st_invoice_date_text" class="input_type_text"  value='<%=CommonUtil.getCurrentDay_Time("yyMMdd")%>' readonly>
				&nbsp;&nbsp;
			
				<span class="btn_08">
					<a href="javascript:doAction('create');">거래명세서생성</a>
				</span>
            </div>
        </div>
</form>
</div>

<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/sellerFooter.jsp" %>   
</div>
</body>
</html>
