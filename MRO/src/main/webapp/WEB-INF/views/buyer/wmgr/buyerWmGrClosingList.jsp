<%--
**********************************************
* 메뉴 : 입고관리>마감조회
* 화면 : 마감조회
* 기능 : 마감데이터를 조회한다.
* 프로그램 ID : PG_07_B_003_00
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
	String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),  CommonUtil.nvl(_sessionInfo.getRowCnt(),"10"));   // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	
	String pg_row = CommonUtil.nvl((String)request.getParameter("st_pg_row"), "10");
    String pg_no = CommonUtil.nvl((String)request.getParameter("st_page"), "1");
	String tot_cnt_string = "";
    int tot_cnt = 0;                                    //전체데이타row수
    int rec_cnt = 0;
    int page_display_cnt = 0;
    
    String sessionComCode = _sessionInfo.getComCode();
    
    //엑셀다운로드 기능 통제
    boolean p170000001 = CommonUtil.getSpecialCheckReturn(sessionComCode,"P17-0000001");
%> 

<script type="text/javascript">
var popupSel = "";

// 최초 화면 함수 
function kep_onload_view(){
	console.log("adsasd");
	var from_date = "${st_from_date}";
	var to_date = "${st_to_date}";
	var today = kepGetNowTimeStr("YYYYMMDD","");
	
	if(kepIsValueNull("${st_from_date}")){
		
		from_date = kepToMonthAdd("1","M","noslash");
		to_date = today;
	}
	
	initSearchCondition("searchForm", "st_from_date", from_date);	//시작일자
	initSearchCondition("searchForm", "st_to_date", to_date);		//종료일자
	
	initSearchCondition("searchForm", "st_check_date", "${st_check_date}");	// 입고일/주문일
	
	initSearchCondition("searchForm", "st_status", "${st_status}");	// 상태
	
	initSearchCondition("searchForm", "st_buyer_item_no", "${st_buyer_item_no}");	// 품목코드
	
	kepSetCalender('st_from_date');
	kepSetCalender('st_to_date');
	
	initSearchCondition("searchForm", "onepagerow", "<%=onepagerow%>");	//페이징단위 "${onepagerow}"
}

function getDepartmentCode(){
	var com_code = $("#st_com_code").val();
	openSearchPopup("/common/deptCodeAdminPop.do", "?open=Y&com_code="+com_code, "500,500,no");
} 

function getNewDepartmentDisplayPop(st_dept){
	var com_code = $("#st_com_code").val();
	openSearchPopup("/coco/getCommonCoCoDepartmentDetailViewPop.do", "?openYn=Y&st_com_code="+com_code+"&st_dept="+st_dept, "410,143,no");
}

var st;
//기능함수
function doAction(str) {
	switch (str) {
		case "search":	 //조회
			
			kepSearch('1');
			break;
			
		case "reload":	//초기화
			kepReload("searchForm");
		
			// 조회일 초기 셋팅
			kepSetCalender("st_from_date");
			kepSetCalender("st_to_date");
			
			$("#st_from_date").val( kepToMonthAdd("1","M"));
			$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
			$('#st_total_cnt').val('0');
// 			kepSearch("-1");
			jspTableClean("table_list");

			break;
	
		case "save":	 //입고
			setInsertGr();
			break;
			
		case "excelDown": // 엑셀다운로드
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;  
			if (kepGetDateDiff('st_from_date','st_to_date','D') > 93 ){
				//조회기간을 3개월 단위로 조회가 가능합니다.
				alert("<%=CommonLang.msg("MSG95")%>");
				return;
			}
			document.forms.searchForm.action = "/wmgr/excelBuyerWmGrClosingList.do";
			document.forms.searchForm.submit();
			break;
	}
}

// 조회
function kepSearch(curPage){
	if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
	if (kepGetDateDiff('st_from_date','st_to_date','D') > 93 ){
		//조회기간을 3개월 단위로 조회가 가능합니다.
		alert("<%=CommonLang.msg("MSG95")%>");
		return;
	}
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/wmgr/getBuyerWmGrClosingList.do").submit();   
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
		case "commonMpIvOrderDetailPop": // 발주번호
			openSearchPopup("/mpiv/getCommonMpIvBuyerOrderDetailInfoPop.do", "?buyer="+value1+"&po_no="+value2, "820,550,no");
			break;
		case "commonMpIvOdrreqDetailPop": // 요청번호
			openSearchPopup("/mpiv/showCommonMpIvOdrreqDetailPop.do", "?openYn=Y&PR_NO="+value1+"&RECV_FLAG="+value2, "800,600,no");
			break;
			
		
	}
}

</script>
</head>
<body onload="kep_onload_view()">
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
	<h3><%=CommonLang.get("HTITLE282")%><!-- 마감조회 --></h3>
	<!--버튼영역-->
     <div id="searchBtnA">
     	<span class="btn_search"><a href="javascript:doAction('search');"><%=CommonLang.get("HTITLE7")%><!-- 조회 --></a></span> 
		<span class="btn_reset"><a href="javascript:doAction('reload');"><%=CommonLang.get("HTITLE8")%><!-- 초기화 --></a></span>
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
				<caption><%=CommonLang.get("HTITLE7")%><!-- 조회 --></caption>
				<colgroup>
					<col width="8%" />
				    <col width="12%" />
				    <col width="15%" />
				    <col width="15%" />
				    <col width="10%" />
				    <col width="15%" />
				    <col width="10%" />
				    <col width="15%" />
				</colgroup>
				
				<tbody>
				<tr>
					<td>
					   <select name="st_check_date" id="st_check_date" width="80%;">
				      		<option value="GR"><%=CommonLang.get("HTITLE283")%><!-- 입고일 --></option>
				      		<option value="PR"><%=CommonLang.get("HTITLE185")%><!-- 주문일 --></option>
                          </select>
					</td>
					<td colspan="3">
						<input type="text" name="st_from_date" style="width:20%; text-align: center;" id="st_from_date" class="input_type_text"  value="" readonly>
			          	&nbsp;~&nbsp;
						<input type="text" name="st_to_date" style="width:20%; text-align: center;" id="st_to_date" class="input_type_text"  value="" readonly>
						
						<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1<%=CommonLang.get("HTITLE602")%><!-- 개월 --></a></span> 
						<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2<%=CommonLang.get("HTITLE602")%><!-- 개월 --></a></span> 
						<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3<%=CommonLang.get("HTITLE602")%><!-- 개월 --></a></span>
						<span class="btn_month"><a href="javascript:setCurMonth('st_from_date','st_to_date')">당월</a></span>					
					</td>
				    <td><%=CommonLang.get("HTITLE255")%><!-- 상태 --></td>
				    <td>
						<select name = "st_status" id="st_status" style="height:20px;">
							<option value=""><%=CommonLang.get("HTITLE29")%><!-- 전체 --></option>
							<option value="입고완료"><%=CommonLang.get("HTITLE201")%><!-- 입고완료 --></option>
							<option value="마감완료"><%=CommonLang.get("HTITLE284")%><!-- 마감완료 --></option>
							<option value="국세청전송"><%=CommonLang.get("HTITLE285")%><!-- 국세청전송 --></option>
						</select>
					</td>
					<td>품목코드</td>
					<td>
						<input type="text" name="st_buyer_item_no" id="st_buyer_item_no" style="width:80%;" class="input_type_text"  value="">
					</td>
				</tr>
				</tbody>
			</table>
		</div>
 		
 		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
	      	<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow">
				<option value = "10" <%if ("10".equals(onepagerow)) {%>selected<%} %> >10<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
				<option value = "20" <%if ("20".equals(onepagerow)) {%>selected<%} %> >20<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
				<option value = "30" <%if ("30".equals(onepagerow)) {%>selected<%} %> >30<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
				<option value = "40" <%if ("40".equals(onepagerow)) {%>selected<%} %> >40<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
				<option value = "50" <%if ("50".equals(onepagerow)) {%>selected<%} %> >50<%=CommonLang.get("HTITLE595")%><!-- 건 --></option> 
			</select>
      	</span>      
       <span class="fr">
       <%=CommonLang.get("HTITLE608")%><!-- 총건수 --> <input type="text" class="input_type_text" id="st_total_cnt" name="st_total_cnt" readonly style="width:30px;border:0" value="<%=total_cnt %>"/>
       <%=CommonLang.get("HTITLE594")%><!-- (기준: 원) --></span>
       	<br>
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<!-- 공통 -->
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
	  	
		<table id="table_list" class="cont_t_list02" style="width:100%">
			<colgroup>
				<col width="8%" />
	            <col width="9%" />
	            <col width="9%" />
	            <col width="9%" />
	            <col width="10%" />
	            <col width="*" />
	            <col width="10%" />
	            <col width="8%" />
	            <col width="11%" />
	            <col width="8%" />
	        </colgroup>
	        <thead>
	        <tr>
	        	<th scope="col" rowspan="2"><%=CommonLang.get("HTITLE186")%><!-- 주문번호 --></th>
				<th scope="col"><%=CommonLang.get("HTITLE216")%><!-- 요청번호 --></th>
				<th scope="col"><%=CommonLang.get("HTITLE203")%><!-- 발주번호 --></th>
				<th scope="col"><%=CommonLang.get("HTITLE185")%><!-- 주문일 --></th>
				<th scope="col"><%=CommonLang.get("HTITLE12")%><!-- 품목코드 --></th>
				<th scope="col"><%=CommonLang.get("HTITLE13")%><!-- 품목명 --></th>
				<th scope="col"><%=CommonLang.get("HTITLE174")%><!-- 단가 --></th>
				<th scope="col"><%=CommonLang.get("HTITLE217")%><!-- 발주수량 --></th>
				<th scope="col"><%=CommonLang.get("HTITLE144")%><!-- 협력사 --></th>
				<th scope="col" rowspan="2"><%=CommonLang.get("HTITLE255")%><!-- 상태 --></th>
			</tr>
			<tr>
				<th scope="col"><%=CommonLang.get("HTITLE18")%><!-- 관리번호 --></th>
				<th scope="col"><%=CommonLang.get("HTITLE286")%><!-- 입고번호 --></th>
				<th scope="col"><%=CommonLang.get("HTITLE283")%><!-- 입고일 --></th>
				<th scope="col"><%=CommonLang.get("HTITLE208")%><!-- 발주일 --></th>
				<th scope="col"><%=CommonLang.get("HTITLE14")%><!-- 규격 --></th>
				<th scope="col"><%=CommonLang.get("HTITLE287")%><!-- 입고금액 --></th>
				<th scope="col"><%=CommonLang.get("HTITLE211")%><!-- 입고수량 --></th>
				<th scope="col"><%=CommonLang.get("HTITLE280")%><!-- 총입고수량 --></th>
			</tr>
		</thead>
		<tbody>
 		<%
        if (_gridList == null || _gridList.size() == 0){
        %>
                    <tr>
                        <td colspan="15" align="center" height = "50"> 
                        <span><%=CommonLang.msg("MSG347")%><!-- 조회된 데이타가 없습니다. --></span>
                        </td> 
                    </tr>
        <%
        }else{
			for (int j=0; j<_gridList.size(); j++) {
				Map<String,String> rowData = _gridList.get(j);
				String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
				
		%> 
				<tr align="center" bgcolor="<%=tclass%>">
					<td class="left" title="주문번호" rowspan="2">
	                    <%=CommonUtil.nvl(rowData.get("PX_NO"))%>
	                </td>
	                <td class="left" title="요청번호">
	                	<a class="hyperLink" href="javascript:doPop('commonMpIvOdrreqDetailPop', '<%=rowData.get("PR_NO")%>', '<%=rowData.get("RECV_FLAG")%>');">
	                    	<%=CommonUtil.nvl(rowData.get("PR_NO"))%>
	                    </a>
	                </td>
	                <td class="left" title="발주번호">
	                	<a class="hyperLink" href="javascript:doPop('commonMpIvOrderDetailPop','<%=rowData.get("BUYER")%>', '<%=rowData.get("PO_NO")%>');">
	                    	<%=CommonUtil.nvl(rowData.get("PO_NO"))%>
	                    </a>
	                </td>
	                <td title="주문일">
	                    <%=CommonUtil.formatStrinigDate(rowData.get("CHANGE_DATE"))%>
	                </td>
	                <td class="left" title="품목코드">
		                <a class="hyperLink" href="javascript:getBuyerCatalogDisplayPop('<%=rowData.get("BYIT_COMORG_CODE")%>', '<%=rowData.get("BUYER_ITEM_NO")%>','<%=rowData.get("CONTRACT_NO")%>', '<%=rowData.get("CONTRACT_SEQ")%>');">
	                    	<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>
	                    </a>
	                </td>
	                <td class="left" title="품목명">
	                    <%=CommonUtil.nvl(rowData.get("DESCRIPTION"))%>
	                </td>
	                <td class="right" title="단가">
	                    <%=CommonUtil.formatNumber(rowData.get("UNIT_PRICE"),true,0,3)%>
	                </td>
	                <td class="right" title="발주수량">
	                    <%=CommonUtil.formatNumber(rowData.get("PO_ITEM_QTY"),true,0,3)%>/<%=CommonUtil.nvl(rowData.get("UNIT_MEASURE"))%>
	                </td>
	                <td class="left" title="협력사">
		                <a class="hyperLink" href="javascript:getAgentDisplayPop('<%=rowData.get("AGENT")%>');">
	                    	<%=CommonUtil.nvl(rowData.get("AGENT_NAME"))%>
	                    </a>
	                </td>
	                <td title="상태" rowspan="2">
	                    <%=CommonUtil.nvl(rowData.get("CLOSE_STATUS"))%>
	                </td>
				</tr>
				<tr bgcolor="<%=tclass%>">
					<td class="left" class="left" title="관리번호">
	                    <%=CommonUtil.nvl(rowData.get("REF_PR_NO"))%>
	                </td>
	                <td class="left" class="left" title="입고번호">
	                    <%=CommonUtil.nvl(rowData.get("GR_NO"))%>
	                </td>
	                <td title="입고일">
	                    <%=CommonUtil.formatStrinigDate(rowData.get("GR_DATE"))%>
	                </td>
	                <td title="발주일">
	                    <%=CommonUtil.formatStrinigDate(rowData.get("PO_CREATE_DATE"))%>
	                </td>
	                <td class="left" title="규격">
	                    <%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%>
	                </td>
	                <td class="right" title="입고금액">
	                    <%=CommonUtil.formatNumber(rowData.get("ITEM_AMT"),true,0,3)%>
	                </td>
	                <td class="right" title="입고수량">
	                    <%=CommonUtil.formatNumber(rowData.get("GR_ITEM_QTY"),true,0,3)%>/<%=CommonUtil.nvl(rowData.get("UNIT_MEASURE"))%>
	                </td>
	                <td class="right" title="총입고수량">
	                    <%=CommonUtil.formatNumber(rowData.get("GR_QTY"),true,0,3)%>/<%=CommonUtil.nvl(rowData.get("UNIT_MEASURE"))%>
	                </td>
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
				<%
				//엑셀다운로드 기능 통제
				if(p170000001 == false){
				%>
					<span class="btn_04">
						<a href="javascript:doAction('excelDown');"><%=CommonLang.get("HTITLE150")%><!-- 엑셀다운로드 --></a>
					</span>
				<%
				}
				%>
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
</html>
