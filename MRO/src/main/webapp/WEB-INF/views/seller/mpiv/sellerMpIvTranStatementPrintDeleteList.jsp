<%--
**********************************************
* 메뉴 : 납품관리>거래명세서>거래명세서 출력 및 삭제
* 화면 : 거래명세서 출력 및 삭제
* 기능 : 기 생성된 거래명세서 목록을 조회하고 상세정보를 확인할 수 있다.
* 프로그램 ID : PG_07_A_004_00
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
    
	// 조회조건 S
	/*
	String st_from_date = CommonUtil.nvl((String) request.getParameter("st_from_date"),"");  // 조회일(From)
	String st_to_date = CommonUtil.nvl((String) request.getParameter("st_to_date"),"");  // 조회일(To)
	String st_search_type = CommonUtil.nvl((String) request.getParameter("st_search_type"),"");  // 조회필드콤보
	String st_search_code = CommonUtil.nvl((String) request.getParameter("st_search_code"),"");  // 
	String st_btoa_user_dept_code = CommonUtil.nvl((String) request.getParameter("st_btoa_user_dept_code"),"");  // 요청부서코드
	String st_btoa_user_dept_name = CommonUtil.nvl((String) request.getParameter("st_btoa_user_dept_name"),"");  // 요청부서명
	String st_sourcing_status = CommonUtil.nvl((String) request.getParameter("st_sourcing_status"),"");  // 진행상태
	String st_quotation_no = CommonUtil.nvl((String) request.getParameter("st_quotation_no"),"");  // 견적번호
	*/
	// 조회조건 E
	
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
		from_date = kepGetNowTimeStr("YYYYMMDD","");
		to_date = kepToMonthAdd("1","P","noslash");
	}
	
	var buyer_code = "${st_buyer_code}";
	
	if(buyer_code == "KRHANW0012"){
		$("#excel_down").show();
	} else {
		$("#excel_down").hide();
	}
	
	//조회조건 초기화(기존값 재설정)
	initSearchCondition("searchForm", "st_from_date", from_date);	//납품 시작일자
	initSearchCondition("searchForm", "st_to_date", to_date);	//납품 종료일자
	
	initSearchCondition("searchForm", "st_buyer_name", "${st_buyer_name}");	//구매회사명
	initSearchCondition("searchForm", "st_buyer_code", buyer_code);	//구매회사코드
	initSearchCondition("searchForm", "st_po_no", "${st_po_no}");	//발주번호
	
	
	
	var dely_type = "${st_dely_type}";
	
	if(isEmpty(dely_type)){
		dely_type = "ALL";
	}
	initSearchCondition("searchForm", "st_dely_type", dely_type);	// 납품완료유무
	
	kepSetCalender('st_from_date');
	kepSetCalender('st_to_date');
	
	initSearchCondition("searchForm", "onepagerow", "${onepagerow}");	//페이징단위
}


function doAction(str) {
	switch (str) {
		case "search":	 //조회
			var delyType = $("#st_dely_type").val();
			if(delyType == 'DELY_YES'){
	 			if (kepGetDateDiff('st_from_date','st_to_date','D') > 62 ){
					alert("납품완료의 경우 조회기간을 2개월 단위로 조회가 가능합니다.\n\n2개월 이상의 데이타는 S/R 요청 바랍니다.");
					return;
				}
			} else if(delyType == 'ALL'){
				if (kepGetDateDiff('st_from_date','st_to_date','D') > 186 ){
					alert("납품미완료의 경우 조회기간을 6개월 단위로 조회가 가능합니다.\n\n6개월 이상의 데이타는 S/R 요청 바랍니다.");
					return;
				}
			}
			kepSearch("1");
			break;
			
		case "reload":	//초기화
			kepReload("searchForm");

			$("#st_from_date").val(kepGetNowTimeStr("YYYYMMDD",""));
			$("#st_to_date").val(kepToMonthAdd("1","P","noslash"));

			// hidden값은 공통에서 처리안됨.
			$("#st_buyer_code").val("");
			$("#st_dely_type").val("ALL");
			
// 			kepSearch("-1");
			jspTableClean("table_list");
			
			break;
		case "excelDown": // 엑셀다운로드
			document.forms.searchForm.action = "/mpiv/excelSellerMpIvTranStatementPrintDeleteList.do";
			document.forms.searchForm.submit();
			break;
	}
}

/*
 * FORM 을 이용한조회
 */
function kepSearch(curPage){
	if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
	
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mpiv/getSellerMpIvTranStatementPrintDeleteList.do").submit();
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
		case "sellerMpIvTranStatementAlterPrintPop": // 거래명세서번호 click시 거래명세서 수정 및 출력 팝업

			var buyer 				= $("input[name=li_buyer]").eq(value1).val();
			var po_no 				= $("input[name=li_po_no]").eq(value1).val();
			var inv_no 				= $("input[name=li_inv_no]").eq(value1).val();
			var ds_date 			= $("input[name=li_ds_date]").eq(value1).val();
			var seller 				= $("input[name=li_seller]").eq(value1).val();
			var process_type 		= $("input[name=li_process_type]").eq(value1).val();
			var legacy_po_no 		= $("input[name=li_legacy_po_no]").eq(value1).val();
			var tr_buyer 			= $("input[name=li_tr_buyer]").eq(value1).val();
			var dely_to_location 	= $("input[name=li_dely_to_location]").eq(value1).val();
			var add_user_id 		= $("input[name=li_add_user_id]").eq(value1).val();
			var di_remain_qty 		= $("input[name=li_di_remain_qty]").eq(value1).val();
			var gr_remain_qty 		= $("input[name=li_gr_remain_qty]").eq(value1).val();
			var ref_pr_no 			= $("input[name=li_ref_pr_no]").eq(value1).val();
			var wms_gr_qty 			= $("input[name=li_wms_gr_qty]").eq(value1).val();
			var legacy_invoice_key	= $("input[name=li_legacy_invoice_key]").eq(value1).val();
			var user_id = $("#st_user_id").val();
		
			var param = "";
			param  = "?st_buyer="+buyer;
			param += "&st_po_no="+po_no
			param += "&st_inv_no="+inv_no
			param += "&st_ds_date="+ds_date
			param += "&st_seller="+seller
			param += "&st_process_type="+process_type
			param += "&st_legacy_po_no="+legacy_po_no
			param += "&st_tr_buyer="+tr_buyer
			param += "&st_dely_to_location="+dely_to_location
			param += "&st_add_user_id="+add_user_id
			param += "&st_di_remain_qty="+di_remain_qty
			param += "&st_gr_remain_qty="+gr_remain_qty
			param += "&st_ref_pr_no="+ref_pr_no
			param += "&st_wms_gr_qty="+wms_gr_qty
			param += "&st_legacy_iv_serial="+legacy_invoice_key;
			param += "&st_user_id="+user_id;
			
			openSearchPopup("/mpiv/getSellerMpIvTranStatementAlterPrintPop.do", param, "950,600,no");
			break;
	}
}

function setBuyerChoiceReturn(buyer, com_name){
	$("#st_buyer_code").val(buyer);
	$("#st_buyer_name").val(com_name);
	
	if(buyer =="KRHANW0012"){
		$("#excel_down").show();
	} else {
		$("#excel_down").hide();
	}
}

function buyerEraser(){
	kepEraser('st_buyer_code','st_buyer_name');
	$("#excel_down").hide();
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
	<h3>거래명세서 조회(출력) 및 삭제</h3>
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
		
		<!-- 화면 내 정의 -->
		<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
			
		<div id="cont_searchA">	
			<table class="cont_t_list01">
				<caption>조회</caption>
				<colgroup>
					<col width="8%" />
					<col width="45%" />
					<col width="12%" />
					<col width="*" />
				</colgroup>
				
				<tbody>
				<tr>
					<td>납품일</td>
					<td>
						<input type="text"   name="st_from_date" size="10" id="st_from_date" class="input_type_text"  value="" readonly>
						&nbsp;~&nbsp;
						<input type="text"   name="st_to_date" size="10" id="st_to_date" class="input_type_text"  value="" readonly>
						
						<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
						<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span> 
<!-- 						<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>				 -->
					</td>
                     <td>납품완료유무</td>  
				    <td>
			  			<select name = "st_dely_type" id="st_dely_type" style="height:20px;">
			  				<option value="DELY_YES">납품완료</option>
				      		<option value="ALL">납품미완료</option>
                          </select>
                       </td>
				</tr>
				<tr>
					<td>고객사</td>
					<td>
						<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:65%;ime-mode:active" value="" READONLY>
						<input type="hidden" name="st_buyer_code" id="st_buyer_code" value="">
						<a href="javascript:doPop('commonMpIvTranBuyerChoicePop');"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
						<a href="javascript:buyerEraser();"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
					</td>
					
						<td>발주번호</td>
						<td>
							<input type="text" class="input_type_text" name="st_po_no" id="st_po_no" style="width:80%;" onKeyDown="kepEnter();">
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
      	</span>      
		<span class="fr">총건수 <%=total_cnt %></span>      
       	<br>
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<!-- 공통 -->
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
	  	
		<table id="table_list"  class="cont_t_list02" style="width:100%">
			<colgroup>
	            <col width="5%" />
	            <col width="6%" />
	            <col width="6%" />
	            <col width="10%" />
	            <col width="3%" />
	            <col width="7%" />
	            <col width="3%" />
	            <col width="6%" />
	            <col width="6%" />
	            <col width="8%" />
	            <col width="22%" />
	            <col width="*" />
	        </colgroup>
	        <thead>
			<tr>
                <th scope="col">발주일</th>
                <th scope="col">거래명세서번호</th>
                <th scope="col">발주번호</th>
                <th scope="col">고객사</th>
                <th scope="col">품목수</th>
                <th scope="col">총 금액</th>
                <th scope="col">배송유형</th>
                <th scope="col">납품예정일</th>
                <th scope="col">납품일</th>
                <th scope="col">KeP담당자</th>
                <th scope="col">발주비고</th>
                <th scope="col">메모</th> <!-- REMARK_INV -->
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
        } else {
			for (int j=0; j<_gridList.size(); j++) {
				Map<String,String> rowData = _gridList.get(j);
				String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
				
		%> 
				<input type="hidden" name="li_buyer" 				value="<%=CommonUtil.nvl(rowData.get("BUYER"))%>" />
				<input type="hidden" name="li_po_no" 				value="<%=CommonUtil.nvl(rowData.get("PO_NO"))%>" />
				<input type="hidden" name="li_inv_no" 				value="<%=CommonUtil.nvl(rowData.get("INV_NO"))%>" />
				<input type="hidden" name="li_ds_date" 				value="<%=CommonUtil.nvl(rowData.get("DS_DATE"))%>" />
				<input type="hidden" name="li_seller" 				value="<%=CommonUtil.nvl(rowData.get("SELLER"))%>" />
				<input type="hidden" name="li_process_type" 		value="<%=CommonUtil.nvl(rowData.get("PROCESS_TYPE"))%>" />
				<input type="hidden" name="li_legacy_po_no" 		value="<%=CommonUtil.nvl(rowData.get("LEGACY_PO_NO"))%>" />
				<input type="hidden" name="li_tr_buyer" 			value="<%=CommonUtil.nvl(rowData.get("TR_BUYER"))%>" />
				<input type="hidden" name="li_dely_to_location" 	value="<%=CommonUtil.nvl(rowData.get("DELY_TO_LOCATION"))%>" />
				<input type="hidden" name="li_add_user_id"			value="<%=CommonUtil.nvl(rowData.get("ADD_USER_ID"))%>" />
				<input type="hidden" name="li_di_remain_qty" 		value="<%=CommonUtil.nvl(rowData.get("DI_REMAIN_QTY"))%>" />
				<input type="hidden" name="li_gr_remain_qty" 		value="<%=CommonUtil.nvl(rowData.get("GR_REMAIN_QTY"))%>" />
				<input type="hidden" name="li_ref_pr_no" 			value="<%=CommonUtil.nvl(rowData.get("REF_PR_NO"))%>" />
				<input type="hidden" name="li_wms_gr_qty" 			value="<%=CommonUtil.nvl(rowData.get("WMS_GR_QTY"))%>" />
				<input type="hidden" name="li_legacy_invoice_key" 	value="<%=CommonUtil.nvl(rowData.get("LEGACY_INVOICE_KEY"))%>" />
			  
				<tr align="center" bgcolor="<%=tclass%>">           
                    <td title="발주일"><%=CommonUtil.formatStrinigDate(rowData.get("PO_CREATE_DATE"))%></td>
                    <td title="거래명세서번호">
                    	<a class="hyperLink" style="color:#0066cc;" href="javascript:doPop('sellerMpIvTranStatementAlterPrintPop',<%=j%>);">
                    		<%=CommonUtil.nvl(rowData.get("INV_NO"))%>
                    	</a>
                    </td>
                    <td title="발주번호">
                    	<a class="hyperLink" style="color:#0066cc;" href="javascript:doPop('commonMpIvOrderInfoPop','<%=CommonUtil.nvl(rowData.get("BUYER"))%>','<%=CommonUtil.nvl(rowData.get("PO_NO"))%>');">
                    		<%=CommonUtil.nvl(rowData.get("PO_NO"))%>
                    	</a>
                    </td>
                    <td title="고객사" class="left">
                     	<a class="hyperLink" href="javascript:doPop('agent','<%=CommonUtil.nvl(rowData.get("BUYER2"))%>');">
                     		<%=CommonUtil.nvl(CommonUtil.nvl(rowData.get("BUYER_NAME")))%>
                     	</a>
                    </td>
                    <td title="품목수" class="right"><%=CommonUtil.formatNumber(rowData.get("DS_ITEM_CNT"),true,0,3)%></td>
                    <td title="총 금액" class="right"><%=CommonUtil.formatNumber(rowData.get("PO_AMT"),true,0,3)%></td>
                    <td title="배송유형" class="right"><%=CommonUtil.nvl(rowData.get("PARCEL_YN_TEXT"))%></td>
                    <td title="납품예정일"><%=CommonUtil.formatStrinigDate(rowData.get("DS_DATE"))%></td>
                    <td title="납품일"><%=CommonUtil.formatStrinigDate(rowData.get("INVOICE_DATE"))%></td>
                    <td title="KeP담당자"><%=CommonUtil.nvl(rowData.get("KEP_USER_NAME"))%><br>(<%=CommonUtil.nvl(rowData.get("KEP_PHONE_NUMBER"))%>)</td>
                    <td title="발주비고" class="left"><%=CommonUtil.nvl(rowData.get("PO_REMARK"))%></td>
                    <td title="메모" class="left"><%=CommonUtil.nvl(rowData.get("INV_REMARK"))%></td>
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
			<div class="fr" id="excel_down">
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
</div>

<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/sellerFooter.jsp" %>   
</div>
</body>
</html>
