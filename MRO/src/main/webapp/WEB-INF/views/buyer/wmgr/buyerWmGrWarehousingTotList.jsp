<%--
**********************************************
* 메뉴 : 입고관리>입고집계표
* 화면 : 입고집계표
* 기능 : 입고내역을 집계하여 보여준다.
* 프로그램 ID : 
* 담당자 : 한승준 (설계 : 현명환)
* 착수일 : 2016-08-03
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

	String rowCntYn 	= "";	// 그리드 행개수
	String rowCnt 		= "";	// 그리드 default 개수
	
	rowCntYn 	= CommonUtil.nvl((String)request.getParameter("st_row_cnt_yn"));
	rowCnt 		= CommonUtil.nvl((String)request.getParameter("st_row_cnt"));
	
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = CommonUtil.nvl((String)request.getParameter("onepagerow"),"100");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	String sessionRowCnt = CommonUtil.nvl(_sessionInfo.getRowCnt(),"100");
	String closingYn = CommonUtil.nvl((String)request.getParameter("st_closing_yn"),"ALL");
	String st_req_dept_name        = CommonUtil.nvl((String) request.getParameter("st_req_dept_name"),""); 
	String st_req_dept_code        = CommonUtil.nvl((String) request.getParameter("st_req_dept_code"),"");
	
	if(onepagerow.equals("")) {
		onepagerow = sessionRowCnt;
	}
	
	int tot_cnt = 0;	//전체데이타row수
    int page_display_cnt = 0;

    String sessionComCode = _sessionInfo.getComCode();
    
    String grSttsType = CommonUtil.getKepBuyerFlagColumnReturn(sessionComCode, "GR_STTS_TYPE"); // A:계정번호, B:관리번호, N:사용안함
    
    //엑셀다운로드 기능 통제
    boolean p170000001 = CommonUtil.getSpecialCheckReturn(sessionComCode,"P17-0000001");
%> 

<script type="text/javascript">
var popupSel = "";

// 최초 화면 함수 
function kep_onload_view(){
	var from_date = "${st_from_date}";
	var to_date = "${st_to_date}";
	var today = kepGetNowTimeStr("YYYYMMDD","");
	
	if(kepIsValueNull("${st_from_date}")){
		
		from_date = kepToMonthAdd("1","M","noslash");
		to_date = today;
	}
	
	var sum_price = document.forms.contentForm.display_item_amt_sum.value;
    document.forms.searchForm.s_display_item_amt_sum.value = kepCommaNum(sum_price);
    
	initSearchCondition("searchForm", "st_from_date", from_date);
	initSearchCondition("searchForm", "st_to_date", to_date);
	initSearchCondition("searchForm", "onepagerow", "<%=onepagerow%>"); //페이징단위
	initSearchCondition("searchForm", "st_closing_yn", "<%=closingYn%>");
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1,value2,value3,value4){
}

var st;

//기능함수
function doAction(str) {
	switch (str) {
		case "search":	 //조회
			
			kepSearch('1');
			break;
			
		case "reload":	//초기화

			$("#st_from_date").val( kepToMonthAdd("1","M"));
			$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));

			// 조회일 초기 셋팅
			kepSetCalender("st_from_date");
			kepSetCalender("st_to_date");		
			
			$("#st_closing_yn").val("ALL");
			$("#st_excel_type").val("");
			$('#st_total_cnt').val('0');
			jspTableClean("table_list");
			break;
		
		case "excelDown": // 엑셀다운로드
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;  
			if (kepGetDateDiff('st_from_date','st_to_date','D') > 93 ){
				//조회기간을 3개월 단위로 조회가 가능합니다.
				alert("<%=CommonLang.msg("MSG95")%>");
				return;
			}
			$("#st_excel_type").val("");
			
			document.forms.searchForm.action = "/wmgr/excelBuyerWmGrWarehousingTotList.do";
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
	$("#st_excel_type").val("");
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/wmgr/getBuyerWmGrWarehousingTotList.do").submit();   
}

//팝업 함수호출
function doPop(str, value1, value2, value3, value4, value5, value6) {
	switch (str) {
		case "buyerWmGrWarehousingDetailPop": // 발주번호
			var popFromDate = document.forms.searchForm.st_from_date.value;
			var popToDate = document.forms.searchForm.st_to_date.value;
			
			popFromDate = popFromDate.replace(/[/]/gi,"");
			popToDate = popToDate.replace(/[/]/gi,"");
			
			openSearchPopup("/wmgr/getBuyerWmGrWarehousingDetailPop.do", "?buyer="+value1+"&req_dept="+value2+"&fromDate="+popFromDate+"&toDate="+popToDate+"&closing_yn="+value3, "1200,550,no");
			break;
		case "getDepartmentCode": //요청부서 팝업
			var buyer = document.forms.searchForm.st_com_code.value;
			openSearchPopup('/common/deptCodeAdminPop.do', "?open=Y&com_code="+buyer, "500,500,no");		
			break;
		
	}
}

function setPopupReturn(code, text1, text2, gubun) { 
	document.forms.searchForm.st_req_dept_code.value = code;
	document.forms.searchForm.st_req_dept_name.value = text1;
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
			<h3><%=CommonLang.get("HTITLE288")%><!-- 부서별 입고집계 --></h3>
			
			<!--버튼영역-->
			<div id="searchBtnA">
				<span class="btn_search"><a href="javascript:doAction('search');"><%=CommonLang.get("HTITLE7")%><!-- 조회 --></a></span> 
				<span class="btn_reset"><a href="javascript:doAction('reload');"><%=CommonLang.get("HTITLE8")%><!-- 초기화 --></a></span>
			</div>
			
			<form name = "intiForm" id="intiForm" method = "get">
				<input type="hidden" name="user_id"  id="user_id"  value="${sessionInfo.userId}">
				<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">
			</form>
			
			<!--조회영역-->
			<form name = "searchForm" id="searchForm" method = "post">
				<!--HIDDEN-->
				<!-- 공통 -->
				<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
				<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
				
				<!-- 화면 내 정의 -->
				<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
				<input type="hidden" name="st_com_name" id="st_com_name" value="${sessionInfo.departmentName}">
				<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
				<input type="hidden" name="st_user_name" id="st_user_name" value="${sessionInfo.userNameLoc}">
					
				<input type="hidden" name="st_query" value ="">
				<input type="hidden" name="st_close_date" value ="">
				
				<input type="hidden" name="st_row_cnt_yn" 	id="st_row_cnt_yn" 	value="<%=rowCntYn%>" />
				<input type="hidden" name="st_row_cnt" 		id="st_row_cnt" 	value="<%=rowCnt%>" />
				
				<input type="hidden" name="st_search_type" 	id="st_search_type"	value="" />
				<input type="hidden" id="st_excel_type" name="st_excel_type"	value="" />
				
				<input type="hidden" id="st_gr_stts_type" name="st_gr_stts_type"	value="<%=grSttsType%>" />
 				
				<div id="cont_searchA">	
					<table class="cont_t_list01" >
						<caption><%=CommonLang.get("HTITLE7")%><!-- 조회 --></caption>
						
						<colgroup>
							<col width="8%" />
							<col width="25%" />
							<col width="9%" />
							<col width="25%" />
							<col width="8%" />
							<col width="25%" />
						</colgroup>
						
						<tbody>
							<tr>
								<td><%=CommonLang.get("HTITLE272")%><!-- 입고일자 --></td>
								<td colspan="3">
									<input type="text"   name="st_from_date" style="width: 20%; text-align: center;" id="st_from_date" class="input_type_text"  value="" readonly>
						          	&nbsp;~&nbsp;
									<input type="text"   name="st_to_date" style="width: 20%; text-align: center;" id="st_to_date" class="input_type_text"  value="" readonly>
									
									<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1<%=CommonLang.get("HTITLE602")%><!-- 개월 --></a></span> 
									<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2<%=CommonLang.get("HTITLE602")%><!-- 개월 --></a></span> 
									<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3<%=CommonLang.get("HTITLE602")%><!-- 개월 --></a></span>
									<span class="btn_month"><a href="javascript:setCurMonth('st_from_date','st_to_date')">당월</a></span>							
								</td>
								
								<td><%=CommonLang.get("HTITLE289")%><!-- 정산여부 --></td>
								<td>
									<select id="st_closing_yn" name="st_closing_yn" style="width:50%; height:20px;">
										<option value="ALL"><%=CommonLang.get("HTITLE29")%><!-- 전체 --></option>
										<option value="Y">Y</option>
										<option value="N">N</option>
									</select>
								</td>
							</tr>
							<tr>
								<td><%=CommonLang.get("HTITLE135") %><!-- 요청부서 --></td>
								<td colspan="3">
									<input type="text" class="input_type_text" name="st_req_dept_name" id="st_req_dept_name" style="width:20%;ime-mode:active" value="<%=st_req_dept_name%>" READONLY>
									<input type="hidden" name="st_req_dept_code" id="st_req_dept_code" value="<%=st_req_dept_code%>">
									<a href="javascript:doPop('getDepartmentCode');"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
									<a href="javascript:kepEraser('st_req_dept_code','st_req_dept_name');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>							
								</td>
								<td></td>
								<td></td>
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
						<option value = "70" >70<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
						<option value = "100" >100<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
						<option value = "200" >200<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
						<option value = "300" >300<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
						<option value = "500" >500<%=CommonLang.get("HTITLE595")%><!-- 건 --></option> 
					</select>
		      	</span>
		      	
		      	<span class="fr">
		      		<%=CommonLang.get("HTITLE172")%><!-- 총 금액 --> : 
					<input type="text" id="s_display_item_amt_sum" name="s_display_item_amt_sum" value=""  style="width:150px; text-align:right; background-color:#FFFFFF;font-weight:bold; font-size:9pt; border:#FFFFFF 1px solid;" READONLY>
		      		&nbsp;&nbsp;<%=CommonLang.get("HTITLE594")%><!-- (기준 : 원) -->
		      		&nbsp;&nbsp;<%=CommonLang.get("HTITLE608")%><!-- 총건수 --> <input type="text" class="input_type_text" id="st_total_cnt" name="st_total_cnt" readonly style="width:30px;border:0" value="<%=total_cnt %>"/>
				</span>
			</form>
			 
			<form name = "contentForm" id="contentForm" method = "post">
				<!-- 공통 -->
				<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
				<table id="table_list" class="cont_t_list02" style="width:100%">
					<colgroup>
					<%if(grSttsType.equals("A")){%>
						<col width="6%"/>
						<col width="12%"/>
						<col width="6%"/>
						<col width="16%"/>
						<col width="6%"/>
						<col width="16%"/>
						<col width="6%"/>
						<col width="16%"/>
						<col width="8%"/>
						<col width="4%"/>
					<%}else if(grSttsType.equals("B")){%>
						<col width="10%"/>
						<col width="20%"/>
						<col width="10%"/>
						<col width="20%"/>
						<col width="18%"/>
						<col width="12%"/>
						<col width="10%"/>
					<%}else{%>
						<col width="14%"/>
						<col width="25%"/>
						<col width="14%"/>
						<col width="25%"/>
						<col width="12%"/>
						<col width="10%"/>
					<%}%>
					</colgroup>
			        
			        <thead>
						<tr>
							<th scope="col"><%=CommonLang.get("HTITLE290")%><!-- 고객사코드 --></th>
							<th scope="col"><%=CommonLang.get("HTITLE291")%><!-- 고객사명 --></th>
							<th scope="col"><%=CommonLang.get("HTITLE292")%><!-- 요청부서코드 --></th>
							<th scope="col"><%=CommonLang.get("HTITLE293")%><!-- 요청부서명 --></th>
						<%if(grSttsType.equals("A")){%>
							<th scope="col"><%=CommonLang.get("HTITLE568")%><!-- 예산부서코드 --></th>
							<th scope="col"><%=CommonLang.get("HTITLE420")%><!-- 예산부서명 --></th>
							<th scope="col"><%=CommonLang.get("HTITLE386")%><!-- 계정코드 --></th>
							<th scope="col"><%=CommonLang.get("HTITLE267")%><!-- 계정명 --></th>
						<%}else if(grSttsType.equals("B")){%>
							<th scope="col"><%=CommonLang.get("HTITLE18")%><!-- 관리번호 --></th>
						<%}%>
							<th scope="col"><%=CommonLang.get("HTITLE294")%><!-- 입고집계금액 --></th>
							<th scope="col"><%=CommonLang.get("HTITLE289")%><!-- 정산여부 --></th>
						</tr>		
					</thead>
					
					<tbody>
			 		<%
			 			int display_item_amt = 0;
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
								++page_display_cnt;
								Map<String,String> rowData = _gridList.get(j);
								String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
								display_item_amt+=Math.round(Double.parseDouble(CommonUtil.bnvl(rowData.get("GR_AMT"))));
					%> 
						<tr align="center" bgcolor="<%=tclass%>">
			            	<td class="center" title="고객사코드">
								<%=CommonUtil.nvl(rowData.get("BUYER"))%>
							</td>
							
							<td class="left" title="고객사명">
								<%=CommonUtil.nvl(rowData.get("BUYER_NAME"))%>
							</td>
							
							<td class="center" title="요청부서코드">
								<%=CommonUtil.nvl(rowData.get("REQ_DEPT"))%>
							</td>
							
							<td class="left" title="요청부서명">
			                    <a class="hyperLink" href="javascript:doPop('buyerWmGrWarehousingDetailPop','<%=rowData.get("BUYER")%>', '<%=rowData.get("REQ_DEPT")%>', '<%=rowData.get("AR_BILL_FLAG")%>');">
			                    	<%=CommonUtil.nvl(rowData.get("REQ_DEPT_NAME"))%>
			                    </a>
							</td>
						<%if(grSttsType.equals("A")){%>
							<td class="center" title="예산부서코드">
								<%=CommonUtil.nvl(rowData.get("BUDGET_DEPT"))%>
							</td>
				            
							<td class="left" title="예산부서명">
								<%=CommonUtil.nvl(rowData.get("BUDGET_DEPT_NAME"))%>
							</td>
							
							<td class="center" title="계정코드">
								<%=CommonUtil.nvl(rowData.get("ACCOUNT_TYPE"))%>
							</td>
				            
							<td class="left" title="계정명">
								<%=CommonUtil.nvl(rowData.get("ACCOUNT_NAME"))%>
							</td>
						<%}else if(grSttsType.equals("B")){%>
							<td class="left" title="관리번호">
								<%=CommonUtil.nvl(rowData.get("REF_PR_NO"))%>
							</td>
						<%}%>
							<td class="right" title="입고집계금액">
								<%=CommonUtil.formatNumber(rowData.get("GR_AMT"),true,0,3)%>
							</td>
							
							<td title="정산여부">
								<%=CommonUtil.nvl(rowData.get("AR_BILL_FLAG"))%>
							</td>
						</tr>
		            	<%
							} 
						}
		            	%>
					</tbody>
				</table>
		         <input type="hidden" name="display_item_amt_sum"  value="<%=display_item_amt%>">
				<input type="hidden" id="display_item_cnt" name="display_item_cnt" value="<%=page_display_cnt%>">
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
