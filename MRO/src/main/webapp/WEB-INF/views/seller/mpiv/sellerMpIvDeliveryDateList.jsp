<%--
**********************************************
* 메뉴 : 납품관리>납품현황>납기일변경현황
* 화면 : 납기일변경현황
* 기능 : 납기일 변경 이력관리 화면
* 프로그램 ID : 
* 담당자 : 현명환
* 착수일 : 2015-12-22
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
	initSearchCondition("searchForm", "st_gr_flag", "${st_gr_flag}");	//확인완료제외 hidden값
	
	if(kepIsValueNull("${st_gr_flag}") ||  "${st_gr_flag}" == "GR"){
		$("#st_gr_flag").val("GR");
		$("#st_gr_flag_check").attr("checked", "checked");
	} else {
		$("#st_gr_flag").val("ALL");
		$("#st_gr_flag_check").removeAttr("checked");
	}
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
			if (kepGetDateDiff('st_from_date','st_to_date','D') > 93 ){
				alert("조회기간을 3개월 단위로 조회가 가능합니다.\n");
				return;
			}
			kepSearch("1");
			break;
			
		case "reload":	//초기화
			kepReload("searchForm");
			
			// hidden값은 공통에서 처리안됨.
			$("#st_buyer_code").val("");
			$("#st_from_date").val(kepToMonthAdd("1","M","noslash"));
			$("#st_to_date").val(kepGetNowTimeStr("YYYYMMDD",""));
			
			$("#st_gr_flag").val("GR");
			$("#st_gr_flag_check").attr("checked", "checked");
			jspTableClean("table_list");
			break;
			
		case "excelDown": // 엑셀다운로드
			document.forms.searchForm.action = "/mpiv/excelSellerMpIvDeliveryDateList.do";
			document.forms.searchForm.submit();
			break;
			
		case "confirm":	//확인
			confirmDeliveryDate();
			break;	
	}
}

/*
 * FORM 을 이용한조회
 */
function kepSearch(curPage){
	if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
	
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mpiv/getSellerMpIvDeliveryDateList.do").submit();
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
		
	}
}

function setBuyerChoiceReturn(buyer, com_name){
	$("#st_buyer_code").val(buyer);
	$("#st_buyer_name").val(com_name);
}
//확인완료 제외 이벤트
function setCheckBox(){
	
	if($("#st_gr_flag_check").is(":checked")){
		$("#st_gr_flag").val("GR");
		
	} else {
		$("#st_gr_flag").val("ALL");
		
	}
}

//납품실적확인
function confirmDeliveryDate(){
	
	var tot_cnt  = $("#display_item_cnt").val();
	var query   = "";
	var chk_cnt = 0;    // 납품기일변경 확인건수
	
	var buyer           = "";
	var po_no           = "";
	var po_seq          = "";
	var revision          = "";
	var confriom_user_id      = "";
	
	if(eval(tot_cnt) == 0) {
		alert("조회한 데이타가 없습니다.");
		return;
	}
	
	if(eval(tot_cnt) < 2){
	
		var box = eval("document.contentForm.checkbox"+0);
		if(box.checked == true){
			chk_cnt++;
			
			buyer           = document.contentForm.st_buyer.value;
			po_no           = document.contentForm.st_po_no.value;
			po_seq          = document.contentForm.st_po_seq.value;
			revision          = document.contentForm.st_revision.value;
			confriom_user_id = document.searchForm.st_user_id.value;
	
			
			query +=  buyer         + "@@";
			query +=  po_no         + "@@";
			query +=  po_seq        + "@@";
			query +=  revision        + "@@";
			query +=  confriom_user_id ;
			query +=  "^||^" ;
		}
	
	}else{
		for(var k = 0; k < tot_cnt; k++){
			var box = eval("document.contentForm.checkbox"+k);
			if(box.checked == true){
				chk_cnt++;
				
				buyer           = document.contentForm.st_buyer[k].value;
				po_no           = document.contentForm.st_po_no[k].value;
				po_seq          = document.contentForm.st_po_seq[k].value;
				revision          = document.contentForm.st_revision[k].value;
				confriom_user_id = document.searchForm.st_user_id.value;
				
				query +=  buyer         + "@@";
				query +=  po_no         + "@@";
				query +=  po_seq        + "@@";
				query +=  revision        + "@@";
				query +=  confriom_user_id ;
				query +=  "^||^" ;
			}
		}
	}
	
	if(chk_cnt == "0"){
		alert("납기일 변경 확인할 품목을 선택하여 주십시요");
		return;
	}
	
	
	if(!confirm("확인 하시겠습니까?")) return;
	
	document.searchForm.st_query.value  = query;
	
	kepAjaxFormCall("/mpiv/saveSellerMpIvDeliveryDateReg.do","searchForm","btnCreate");

}
//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	
	if(pMethod == "btnCreate"){
		alert("납품실적등록이  정상적으로 완료 되었습니다.");
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
	<h3>납기일 변경현황</h3>
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
		<input type="hidden" name="st_query" value ="">
		<!-- 화면 내 정의 -->
		<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
			
		<div id="cont_searchA">	
			<table class="cont_t_list01">
				<caption>조회</caption>
				<colgroup>
					<col width="10%" />
					<col width="25%" />
					<col width="10%" />
					<col width="25%" />
					<col width="10%" />
					<col width="*" />
				</colgroup>
				<tbody>
					<tr>
						<td>변경일</td>
						<td colspan="3">
							<input type="text"   name="st_from_date" size="10" id="st_from_date" class="input_type_text"  value="" readonly>
							&nbsp;~&nbsp;
							<input type="text"   name="st_to_date" size="10" id="st_to_date" class="input_type_text"  value="" readonly>
							
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span> 
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>	
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
						<td>발주번호</td>
						<td>
							<input type="text" class="input_type_text" name="st_po_no" id="st_po_no" style="width:80%;" onKeyDown="kepEnter();">
						</td>
						<td>고객사발주번호</td>
						<td>
							<input type="text" class="input_type_text" name="st_legacy_po_no" id="st_legacy_po_no" style="width:80%;" onKeyDown="kepEnter();">
						</td>
						<td colspan="2">
							<input type="checkbox" class="Noborder" id="st_gr_flag_check" name="st_gr_flag_check"  value="" onChange="setCheckBox();" <%--=(pGrFlag.equals("GR") ? "checked" : "")--%>>
							<input type="hidden"   id="st_gr_flag" name="st_gr_flag" value="" />
							<b><font color="#333333">확인건제외</font></b>
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
				<col width="3%" />
	            <col width="10%" />
	            <col width="10%" />
	            <col width="*" />
	            <col width="5%" />
	            <col width="5%" />
	            <col width="10%" />
	            <col width="10%" />
	            <col width="11%" />
	        </colgroup>
	        <thead>
                <tr>
		           <th scope="col" rowspan="2">
					<a href="javascript:checkAll();" id="check_status">전체</a>
		           </th>
                    <th scope="col">고객사</th>
                    <th scope="col">품목코드</th>
                    <th scope="col">품명</th>
                    <th scope="col">발주수량</th>
                    <th scope="col">납품수량</th>
                    <th scope="col">변경전</th>
                    <th scope="col">변경일</th>
                    <th scope="col">고객사발주번호</th>
                </tr>
                <tr>
                    <th scope="col">발주번호</th>
                    <th scope="col">발주항번</th>
                    <th scope="col">규격</th>
                    <th scope="col">입고수량</th>
                    <th scope="col">확정수량</th>
                    <th scope="col">변경후</th>
                    <th scope="col">확인일</th>
                    <th scope="col">고객사발주항번</th>
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
				<tr bgcolor="<%=tclass%>">
		          <td rowspan="2">
		            <input type="checkbox" name="checkbox<%=j%>" value="" id="check" onClick="javascript:checkInvoiceDate('<%=CommonUtil.nvl(rowData.get("INVOICE_DATE"))%>','<%=j%>')">
		          </td>
					<td class="left">
						<a href="javascript:doPop('agent','<%=CommonUtil.nvl(rowData.get("BUYER2"))%>');" class="hyperLink" >
							<input type="hidden" name="st_buyer" value="<%=CommonUtil.nvl(rowData.get("BUYER"))%>">
							<input type="hidden" name="st_po_no" value="<%=CommonUtil.nvl(rowData.get("PO_NO"))%>">
							<input type="hidden" name="st_po_seq" value="<%=CommonUtil.nvl(rowData.get("PO_SEQ"))%>">	
							<input type="hidden" name="st_revision" value="<%=CommonUtil.nvl(rowData.get("REVISION"))%>">	
							<%=CommonUtil.nvl(rowData.get("BUYER_NAME"))%>
						</a>
					</td>
					<td>
						<a href="javascript:doPop('catalogDetailPop','<%=CommonUtil.nvl(rowData.get("BYCA_COMORG_CODE"))%>','<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>','<%=CommonUtil.nvl(rowData.get("CONTRACT_NO"))%>','<%=CommonUtil.nvl(rowData.get("CONTRACT_SEQ"))%>');" class="hyperLink" >
							<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>
						</a>
					</td>
					<td  class="left">
						<%=CommonUtil.nvl(rowData.get("DESCRIPTION"))%>
					</td>
					<td class="right">
						<%=CommonUtil.formatNumber(rowData.get("ITEM_QTY"),true,0,3)%>
					</td>
					<td class="right">
						<%=CommonUtil.formatNumber(rowData.get("IV_QTY"),true,0,3)%>
					</td>
					<td class="center">
						<%=CommonUtil.formatStrinigDate(rowData.get("BEFORE_DATA"))%>
					</td>
					<td  class="center">
						<%=CommonUtil.formatStrinigDate(rowData.get("ADD_DATE"))%>
					</td>
					<td>
						<%=CommonUtil.nvl(rowData.get("LEGACY_PO_NO"))%>
					</td>
                </tr>
                <tr bgcolor="<%=tclass%>">
                	<td>
						<a href="javascript:doPop('commonMpIvOrderInfoPop','<%=CommonUtil.nvl(rowData.get("BUYER"))%>' ,'<%=CommonUtil.nvl(rowData.get("PO_NO"))%>')" class="hyperLink" >
							<%=CommonUtil.nvl(rowData.get("PO_NO"))%>
						</a>
					</td>
					<td>
						<%=CommonUtil.nvl(rowData.get("PO_SEQ"))%>
					</td>
					<td class="left">
						<%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%>
					</td>
					<td class="right">
						<%=CommonUtil.formatNumber(rowData.get("GR_QTY"),true,0,3)%>
					</td>
					<td class="right">
						<%=CommonUtil.formatNumber(rowData.get("DI_QTY"),true,0,3)%>
					</td>
					<td class="center">
						<%=CommonUtil.formatStrinigDate(rowData.get("AFTER_DATA"))%>
					</td>
					<td  class="center">
						<%=CommonUtil.formatStrinigDate(rowData.get("CONFIRM_DATE"))%>
					</td>
					<td>
						<%=CommonUtil.nvl(rowData.get("LEGACY_PO_SEQ"))%>
					</td>
                </tr>                
            <%
                        } 
        			}
            %>
           		</tbody>
            </table>
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
				<span class="btn_04 mr04">
					<a href="javascript:doAction('confirm');">확인</a>
				</span>
				<span class="btn_04 mr04">
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
