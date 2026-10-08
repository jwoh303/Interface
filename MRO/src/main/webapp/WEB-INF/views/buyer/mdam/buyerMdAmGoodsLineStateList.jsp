<%--
**********************************************
* 메뉴 : 고객사 > 관리자 > 품목군별 현황조회
* 화면 : 품목군별 현황조회
* 기능 : 
* 프로그램 ID : PG_XX_XXXX
* 담당자 : 김경례
* 생성일 : 2014-09-30
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
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과
	
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = CommonUtil.nvl((String)request.getParameter("onepagerow"),"");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	
	String sessionRowCnt = CommonUtil.nvl(_sessionInfo.getRowCnt(),"10");

	if(onepagerow.equals("")){
		onepagerow = sessionRowCnt;
	}
	
	String pg_row           = CommonUtil.nvl((String)request.getParameter("st_pg_row"), "10");
    String pg_no            = CommonUtil.nvl((String)request.getParameter("st_page"), "1");
	String tot_cnt_string = "";
    int tot_cnt = 0;                                    //전체데이타row수
    int rec_cnt = 0;
    int page_display_cnt = 0;
    
    
	// 조회조건 S
	String st_from_date = CommonUtil.nvl((String) request.getParameter("st_from_date"),"");  // 견적일(From)
	String st_to_date = CommonUtil.nvl((String) request.getParameter("st_to_date"),"");  // 견적일(To)
	
	String st_buyer_item_no = CommonUtil.nvl((String) request.getParameter("st_buyer_item_no"),"");  //
	
    String req_dept_code = CommonUtil.nvl((String)request.getParameter("st_req_dept_code"), "");
    String req_dept_name = CommonUtil.nvl((String)request.getParameter("st_req_dept_name"), "");

	
%> 

<script type="text/javascript">
var popupSel = "";

// 최초 화면 함수 
function kep_onload_view(){
	
	var from_date = "${st_from_date}";
	var to_date = "${st_to_date}";
	var today = kepGetNowTimeStr("YYYYMMDD","");
	
	if(kepIsValueNull("${st_from_date}")){
		
		from_date = kepToDateAdd("7","M","noslash");
		to_date = today;
	}
	
	$("#st_from_date").val(kepDateSlashAdd(from_date));
	$("#st_to_date").val(kepDateSlashAdd(to_date));
	
	initSearchCondition("searchForm", "st_po_no", "${st_po_no}");	// 발주번호
	initSearchCondition("searchForm", "st_buyer_item_no", "${st_buyer_item_no}");	// 품목코드
	
	initSearchCondition("searchForm", "st_req_dept_code", "${st_req_dept_code}");	// 발주부서코드
	initSearchCondition("searchForm", "st_req_dept_name", "${st_req_dept_name}");	// 발주부서명
	
	initSearchCondition("searchForm", "st_category_path", "${st_category_path}");	// 품목군
	initSearchCondition("searchForm", "st_categ_id", "${st_categ_id}");	// 품목군
	
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	initSearchCondition("searchForm", "onepagerow", "<%=onepagerow%>");	//페이징단위
	
	setUserList();
}


function setUserList(){
	
	kepAjaxFormCall("/mdam/getBuyerMdAmGoodsLineStateUserList.do","searchForm","setUserList");
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2, value3, value4, value5, value6, value7){
	
	if (popupSel == "dept") {	// 발주부서
		$("#st_req_dept_code").val(value1);
		$("#st_req_dept_name").val(value2);
		
	} else if (popupSel == "commonCoCoBuyerCategoryChoicePop") {	// 카테고리	
		$("#st_categ_id").val(value1);
		$("#st_category_path").val(value4);

	}else if (popupSel == "commonCoCoBuyerCategoryChoiceTreePop") {	// 고객사카테고리 트리형
		$("#st_categ_id").val(value1);
		$("#st_category_path").val(value7);
	}
}

var st;
//기능함수
function doAction(str) {
	switch (str) {
		case "search":	 //조회
			kepSearch('1');
			break;
			
		case "reload":	//초기화

			// 조회일 초기 셋팅
			$("#st_from_date").val( kepToDateAdd("7","M"));
			$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
			
			initSearchCondition("searchForm", "st_po_no", "");				// 발주번호
			initSearchCondition("searchForm", "st_buyer_item_no", "");		// 품목코드
			initSearchCondition("searchForm", "st_req_dept_code", "");		// 발주부서코드
			initSearchCondition("searchForm", "st_req_dept_name", "");		// 발주부서명
			
			initSearchCondition("searchForm", "st_category_path", "");	// 품목군
			initSearchCondition("searchForm", "st_categ_id", "");	// 품목군
			
			initSearchCondition("searchForm", "st_po_user_id", $("#st_user_id").val());			// 발주자
// 			kepSearch(-1); 
			$('#st_total_cnt').val('0');
			jspTableClean("table_list","7");
			
			break;
			
		case "excelDown": // 엑셀다운로드
			document.forms.searchForm.action = "/mdam/excelBuyerMdAmGoodsLineStateList.do";
			document.forms.searchForm.submit();
			break;
	}
}

// 조회
function kepSearch(curPage){
	if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
	
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mdam/getBuyerMdAmGoodsLineStateList.do").submit();   
}

// 팝업 함수호출
function doPop(str, value1, value2, value3, value4) {
	switch (str) {
		case "dept": // 요청부서
			popupSel = "dept";
			var com_code = $("#st_com_code").val();
			openSearchPopup("/common/deptCodeAdminPop.do", "?open=Y&com_code="+com_code, "500,500,no");
			break;		
		case "commonMpIvOrderDetailPop": // 발주번호
			openSearchPopup("/mpiv/getCommonMpIvBuyerOrderDetailInfoPop.do", "?buyer="+value1+"&po_no="+value2, "820,550,no");
			break;
			
		case "buyerCatalogDisplayPop": // 품목코드팝업
			getBuyerCatalogDisplayPop(value1, value2, value3, value4);
			break;
			
		case "buyerCategory": // 조회조건 - 품목군 팝업
			popupSel = "buyerCategory";
			getBuyerCategory();
			break;
			
	}
}

// ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	//var msg = response.Message;

	if(pMethod == "setUserList"){
		
		var userList = response.userList;
		
		var listbox = document.searchForm.st_po_user_id;
		
	    listbox.options.length = 0;
	    var option = new Array();

	    option[0] = new Option('전체','ALL');
	    listbox.options[0] = option[0];

	    var userId = "";
	    var userName = "";
	    var seq = 0;
	    
	    var po_user_id = "${st_po_user_id}";
	    
	    if(isEmpty(po_user_id)){
	    	po_user_id = $("#st_user_id").val();
	    }
	    
		for(var i = 0; i < userList.length; i++){
			
			seq = i+1;
			
			userId = userList[i].USER_ID;
			userName = userList[i].USER_NAME_LOC;
			
			option[seq] = new Option(userName, userId);
			
			if(userId == po_user_id){
				option[seq].selected = true;	
			}
			
			listbox.options[seq] = option[seq];
		}
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


function getBuyerCategory() {

	var buyer_code = $("#st_byca_comorg_code").val();
	popupSel = "commonCoCoBuyerCategoryChoicePop";
	
	if( buyer_code == "KRKEPB0007" || buyer_code == "KRDDDD0001" || buyer_code == "KRHYUN0026" || buyer_code == "KRHYUN0033" || buyer_code == "KRKYUN0002" || buyer_code == "KRISUC0002" || buyer_code == "KRISUC0007") {
		
		popupSel = "commonCoCoBuyerCategoryChoiceTreePop";
		openSearchPopup("/coco/getCommonCoCoBuyerCategoryChoiceTreePop.do", "?st_buyer="+buyer_code, "400,500,no");
		
		// /kr/sysop/proxbuy/common/popup/sysop_proxybuy_category/sysop_proxybuy_category_single.jsp
		//commonCoCoBuyerCategoryChoiceTreePop

	} else if( buyer_code == "KRDOOD0001" || buyer_code == "KRDOOS0004" || buyer_code == "KRILJI0003" || buyer_code == "KRILJI0015" || buyer_code == "KRILJI0026"){

		openSearchPopup("/coco/getCommonCoCoBuyerSpecialCategoryChoicePop.do", "?st_buyer="+buyer_code+"&st_flag=REG", "728,710,no");
		// KRILJI0015 일진전기(주)_ERP 삭제대상고객사
		// /kr/sysop/proxbuy/common/popup/sysop_buyer_new_category/buyer_special_category.jsp
	} else {

		openSearchPopup("/coco/getCommonCoCoBuyerSpecialCategoryChoicePop.do", "?st_buyer="+buyer_code+"&st_flag=REG", "728,710,no");
		// /kr/sysop/proxbuy/common/popup/sysop_buyer_new_category/buyer_new_category.jsp
		//commonCoCoBuyerCategoryChoicePop

		// 상품관리 화면에서 팝업 확인하기!!
	}
}
</script>
</head>
<body onload="kep_onload_view()">
<div id="wrapper"> 
<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   

<div id="container2">
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>

<!--내용 시작-->
<div id="ContArea">
	<h3><%=CommonLang.get("HTITLE691")%><!-- 품목군별 진행현황 --></h3>
	<!--버튼영역-->
     <div id="searchBtnA">
     	<span class="btn_search"><a href="javascript:kepSearch(1);"><%=CommonLang.get("HTITLE7")%><!-- 조회 --></a></span> 
		<span class="btn_reset"><a href="javascript:doAction('reload');"><%=CommonLang.get("HTITLE8")%><!-- 초기화 --></a></span>
     </div>
	<!--조회영역-->
	<form name = "searchForm" id="searchForm" method = "post">
		<!--HIDDEN-->
		<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
		
		<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
		
		<input type="hidden" name="st_byca_comorg_code" id="st_byca_comorg_code" value="${sessionInfo.bycaComorgCode}">
				
				
		<div id="cont_searchA">	
			<table class="cont_t_list01" >
				<caption><%=CommonLang.get("HTITLE691")%><!-- 품목군별 진행현황 --></caption>
				<colgroup>
					<col width="8%" />
					<col width="25%" />
					<col width="8%" />
					<col width="25%" />
					<col width="8%" />
					<col width="25%" />
				</colgroup>
				<tbody>
					<tr>
						<th><%=CommonLang.get("HTITLE208")%><!-- 발주일 --></th>
						<td colspan="3">
							<input type="text"   name="st_from_date" style="width: 20%; text-align: center;" id="st_from_date" class="input_type_text"  value="" readonly>
							&nbsp;~&nbsp;
							<input type="text"   name="st_to_date" style="width: 20%; text-align: center;" id="st_to_date" class="input_type_text"  value="" readonly>
						
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1<%=CommonLang.get("HTITLE602")%><!-- 개월 --></a></span> 
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2<%=CommonLang.get("HTITLE602")%><!-- 개월 --></a></span> 
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3<%=CommonLang.get("HTITLE602")%><!-- 개월 --></a></span>
							<span class="btn_month"><a href="javascript:setCurMonth('st_from_date','st_to_date')">당월</a></span>		
						</td>
					</tr>
					<tr>
						<th><%=CommonLang.get("HTITLE203")%><!-- 발주번호 --></th>
						<td>
							<input type="text" id="st_po_no" name="st_po_no" size="24" value="" onKeyDown="kepEnter();">
						</td>
						<th><%=CommonLang.get("HTITLE12")%><!-- 품목코드 --></th>
						<td>
							<input type="text" id="st_buyer_item_no" name="st_buyer_item_no" size="24" value="" onKeyDown="kepEnter();">
						</td>
						<th><%=CommonLang.get("HTITLE187")%><!-- 발주자 --></th>
						<td>
							<select id="st_po_user_id" name="st_po_user_id" style="height:20px;">
							</select>
						</td>
					</tr>
					<tr>
						<th><%=CommonLang.get("HTITLE188")%><!-- 발주부서 --></th>
						<td>
							<input type="text" class="input_type_text" id="st_req_dept_name" name="st_req_dept_name" style="width:55%;ime-mode:active" value="" READONLY>
							<input type="hidden" name="st_req_dept_code" id="st_req_dept_code" value="">
							
							<a href="javascript:doPop('dept');"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
							<a href="javascript:kepEraser('st_req_dept_code','st_req_dept_name');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
						</td>
						<th><%=CommonLang.get("HTITLE398")%><!-- 품목군 --></th>
						<td>
							<input type="text" class="input_type_text" name="st_category_path" id="st_category_path" style="width:51%" readonly>
							<input type="hidden" name="st_categ_id" id="st_categ_id">
							
							<a href="javascript:doPop('buyerCategory');"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
							<a href="javascript:kepEraser('st_category_path','st_categ_id');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
		<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow">
				<option value = "10" >10<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
				<option value = "20" >20<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
				<option value = "30" >30<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
				<option value = "40" >40<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
				<option value = "50" >50<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
				<option value = "100" >100<%=CommonLang.get("HTITLE595")%><!-- 건 --></option> 
			</select>
		</span>
		<span class="fr">
			&nbsp;&nbsp;<%=CommonLang.get("HTITLE608")%><!-- 총건수 --> <input type="text" class="input_type_text" id="st_total_cnt" name="st_total_cnt" readonly style="width:30px;border:0" value="<%=total_cnt %>"/>
		</span>
		<br>
	</form> 

	<form name = "contentForm" id="contentForm" method = "post">
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
		<table id="table_list" class="cont_t_list02" style="width:100%">
			<colgroup>
				<col width="11%" />
				<col width="15%" />
				<col width="20%" />
				<col width="10%" />
				<col width="11%" />
				<col width="12%" />
				<col width="12%" />
				<col width="9%" />
			</colgroup>
			<thead>
				<tr>
					<th scope="col"><%=CommonLang.get("HTITLE188")%><!-- 발주부서 --></th>
					<th scope="col" colspan="2"><%=CommonLang.get("HTITLE396")%><!-- 품목코드/품목명 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE15")%><!-- 제조사 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE45")%><!-- 수량 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE203")%><!-- 발주번호 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE208")%><!-- 발주일 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE206")%><!-- 납품예정일 --></th>
				</tr>
				<tr>
					<th scope="col"><%=CommonLang.get("HTITLE187")%><!-- 발주자 --></th>
					<th scope="col" colspan="2"><%=CommonLang.get("HTITLE14")%><!-- 규격 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE52")%><!-- 단위 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE174")%><!-- 단가 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE204")%><!-- 금액 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE399")%><!-- 납품요청일 --></th>
					<th scope="col"><%=CommonLang.get("HTITLE400")%><!-- 납품완료일 --></th>
				</tr>
			</thead>
			<tbody>
		<%
			if (_gridList == null || _gridList.size() == 0){
		%>
				<tr>
					<td colspan="7" align="center" height = "50"> 
						<span><%=CommonLang.msg("MSG347")%><!-- 조회된 데이타가 없습니다. --></span>
					</td> 
				</tr>
		<%
			}else{
        	
				for (int j=0; j<_gridList.size(); j++) {
					++page_display_cnt;
					Map<String,String> rowData = _gridList.get(j);
					String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";

		%>
				<tr align="center" bgcolor="<%=tclass%>">
					<td class="left" title="발주부서">
						<%=CommonUtil.nvl(rowData.get("PO_DEPT"))%>
					</td>
					<td class="left" title="품목코드">
						<a class="hyperLink" href="javascript:doPop('buyerCatalogDisplayPop','<%=rowData.get("BYIT_COMORG_CODE")%>', '<%=rowData.get("BUYER_ITEM_NO")%>','<%=rowData.get("CONTRACT_NO")%>', '<%=rowData.get("CONTRACT_SEQ")%>');">
							<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>
						</a>
					</td>
					<td class="left" title="품목명">
						<%=CommonUtil.nvl(rowData.get("DESCRIPTION"))%>
					</td>
					<td class="left" title="제조사">
						<%=CommonUtil.nvl(rowData.get("MAKER_NAME"))%>
					</td>
					<td class="right" title="수량">
						<%=CommonUtil.formatNumber(rowData.get("ITEM_QTY"),true,0,3)%>
					</td>
					<td class="left" title="발주번호">
						<a class="hyperLink" href="javascript:doPop('commonMpIvOrderDetailPop','<%=rowData.get("BUYER")%>', '<%=rowData.get("PO_NO")%>');">
							<%=CommonUtil.nvl(rowData.get("PO_NO"))%>
						</a>
					</td>
					<td class="left" title="발주일">
						<%=CommonUtil.formatStrinigDate(rowData.get("PO_CREATE_DATE"))%>
					</td>
					<td class="left" title="납품예정일">
						<%=CommonUtil.formatStrinigDate(rowData.get("DS_DATE"))%>
					</td>
				</tr>
				<tr align="center" bgcolor="<%=tclass%>">
					<td class="left" title="발주자">
						<%=CommonUtil.nvl(rowData.get("PURCHASER_NAME"))%>
					</td>
					<td class="left" title="규격" colspan="2">
						<%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%>
					</td>
					<td class="left" title="단위">
						<%=CommonUtil.nvl(rowData.get("UNIT_MEASURE"))%>
					</td>
					<td class="right" title="단가">
						<%=CommonUtil.formatNumber(rowData.get("UNIT_PRICE"),true,0,3)%>
					</td>
					<td class="right" title="금액">
						<%=CommonUtil.formatNumber(rowData.get("ITEM_AMT"),true,0,3)%>
					</td>
					<td class="left" title="납품요청일">
						<%=CommonUtil.formatStrinigDate(rowData.get("RD_DATE"))%>
					</td>
					<td class="left" title="납품완료일">
						<%=CommonUtil.formatStrinigDate(rowData.get("DELIVERY_DATE"))%>
					</td>
				</tr>
            <%
			} 
            %>
		<%
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
			<span class="btn_04 mr04">
				<a href="javascript:doAction('excelDown');"><%=CommonLang.get("HTITLE150")%><!-- 엑셀다운로드 --></a>
			</span>
		</div>
</form>
</div>

<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>   
</div>
</body>
</html>
