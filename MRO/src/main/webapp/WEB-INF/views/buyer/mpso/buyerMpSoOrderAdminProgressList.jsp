<%--
**********************************************
* 메뉴 :관리자>발주현황
* 화면 : 발주현황
* 기능 : 발주 내역의 목록및 상태를 파악하고 상세정보를 확인할 수 있다.
* 프로그램 ID : PG_06_B_014_00
* 담당자 : 현명환
* 착수일 : 2015-04-06
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
</head>
<%
	// 공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수) 
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");	
	String budget_flag           = sessionInfo.getBudgetFlag();
	
    String fromDate  = "";
    String toDate    = "";

    fromDate        = CommonUtil.nvl((String) request.getParameter("fromDate"),"");
    if( fromDate.equals("")){
        toDate      =   CommonUtil.formatDateNoDateGubun(new Date(),1);
        fromDate    = CommonUtil.addDate(new Date(),"M",-1,1);
    }else{
        toDate    = CommonUtil.nvl((String) request.getParameter("toDate"),"");
    }    
    fromDate = fromDate.replace("/", "");
    toDate = toDate.replace("/", "");   
    String from_year   = fromDate.substring(0,4);
    String from_month  = fromDate.substring(4,6);
    String from_day    = fromDate.substring(6,8);
    String v_fromDate   = from_year+"/"+from_month+"/"+from_day;
    String to_year   = toDate.substring(0,4);
    String to_month  = toDate.substring(4,6);
    String to_day    = toDate.substring(6,8);
    String v_toDate   = to_year+"/"+to_month+"/"+to_day;
    String SessionComCode        = sessionInfo.getComCode();
    String SessionUserId         = sessionInfo.getUserId();
    String row_cnt = sessionInfo.getRowCnt();
    
    String pr_no         = CommonUtil.nvl((String) request.getParameter("st_pr_no"),""); 
    String legacy_po_no = CommonUtil.nvl((String) request.getParameter("st_legacy_po_no"),"");
    String ref_no        = CommonUtil.nvl((String) request.getParameter("st_dept_no"),"");
    String ref_nm        = CommonUtil.nvl((String) request.getParameter("st_dept_nm"),"");
    
    String search_no = CommonUtil.nvl((String) request.getParameter("st_search_no"),"");
    String st_buyer_code = CommonUtil.nvl((String) request.getParameter("st_buyer_code"),"");
    String st_date_type = CommonUtil.nvl((String) request.getParameter("st_date_type"),"");

    // 진행상태
    String status        = CommonUtil.nvl((String) request.getParameter("st_status"),"ALL");
    // HTML 리스트 조회시 공통사용
    String pg_row             = CommonUtil.nvl((String) request.getParameter("st_pg_row"),""); 
 
    String tot_cnt_string = "";
    int tot_cnt = 0;                                    //전체데이타row수
    int rec_cnt = 0;
 
    // HTML 리스트 조회시 공통사용
    //1개월
    String fromDate1  = "";
    String toDate1    = "";
    toDate1      =   CommonUtil.formatDateNoDateGubun(new Date(),1);
    fromDate1    =    CommonUtil.addDate(new Date(),"M",-1,1);
    String from_year1   = fromDate1.substring(0,4);
    String from_month1  = fromDate1.substring(4,6);
    String from_day1    = fromDate1.substring(6,8);
    String v_fromDate1   = from_year1+"/"+from_month1+"/"+from_day1;
    String to_year1   = toDate1.substring(0,4);
    String to_month1  = toDate1.substring(4,6);
    String to_day1    = toDate1.substring(6,8);
    String v_toDate1   = to_year1+"/"+to_month1+"/"+to_day1; 
    
    String buyer = sessionInfo.getComCode();
    String userid = sessionInfo.getUserId();
    String SessionComOrg = CommonUtil.nvl((String)sessionInfo.getBycaComorgCode());
	  if ("".equals(curPage)){ 
		  v_fromDate = v_fromDate1;
		  v_toDate = v_toDate1;

	 } 
    
	String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),row_cnt); // 정렬갯수  
 
%>  
<body onLoad="kep_onload_view()">
<div id="wrapper"> 
<!-- 메뉴 S --> 
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   

<div id="container2">
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>
<!-- 메뉴 E -->
<!--내용 시작-->
<div id="ContArea">
	<h3>발주현황</h3>
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
		<input type="hidden" name="st_buyer_org_code" id="st_buyer_org_code" value="<%=SessionComOrg%>">
		<input type="hidden" name="st_fromDate" value="<%=fromDate%>">
		<input type="hidden" name="st_toDate"   value="<%=toDate%>">
			
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
                    <col width="8%" />
                    <col width="21%" />
                </colgroup>
				
				<tbody>
				<tr>
					<th>
				          <select name="st_date_type"  id="st_date_type"  style="width:90%"> 
							<option <%=(st_date_type.equals("PO")? "selected" : "")%> value="PO">주문일 </option>
            				<option <%=(st_date_type.equals("GR")? "selected" : "")%> value="GR">입고일</option>
				          </select>
					</th>
					<td colspan="3">
						<input type="text" class="input_type_text" name="fromDate" id="fromDate" readOnly style="width:15%;text-align:center;" value="<%=v_fromDate%>"> - 
                        <input type="text" class="input_type_text" name="toDate" id="toDate" readOnly style="width:15%;text-align:center;"  value="<%=v_toDate%>"> 
                        <span class="btn_month"><a href="javascript:kepMonth('fromDate','toDate','1')">1개월</a></span> 
						<span class="btn_month"><a href="javascript:kepMonth('fromDate','toDate','2')">2개월</a></span>	
						<span class="btn_month"><a href="javascript:kepMonth('fromDate','toDate','3')">3개월</a></span>							
					</td>
				    <th>고객사</th>
					<td><select name="st_buyer_code"  id="st_buyer_code"  style="width:90%"> 
				             <option <%=(st_buyer_code.equals("KRDOOD0001")? "selected" : "")%> value="KRDOOD0001">두산중공업(주) 창원</option>
				             <option <%=(st_buyer_code.equals("KRDOOS0004")? "selected" : "")%> value="KRDOOS0004">두산중공업(주) 서울</option>
				          </select>		
					</td>
				</tr>
                <tr>
					<th>발주번호</th>
					<td><input type="text"  class="input_type_text"  name="st_legacy_po_no" style="width:87%" value="<%=(legacy_po_no.equals("ALL") ? "" : legacy_po_no)%>" onKeyDown="kepEnter()" /></td>
                    <th>품목코드</th>
					<td><input type="text"  class="input_type_text"   name="st_search_no" style="width:87%" value = "<%=(search_no.equals("ALL") ? "" : search_no)%>" onKeyDown="kepEnter()" /></td>
					<th>요청부서</th>
                    <td><input type="text"  class="input_type_text"  name="st_dept_nm" style="width:70%" value = "<%=(ref_nm.equals("ALL") ? "" : ref_nm)%>" onKeyDown="kepEnter()" />
	                    		<input type="hidden" id="st_dept_no" name="st_dept_no" value="<%=(ref_no.equals("ALL") ? "" : ref_no)%>" />
	                    		<a href="javascript:doPop('dept', '');"><img src="/resources/images/btn_search03.gif"></a>
	                 </td>
			   </tr>
				<tr>
				    <th>배송상태</th>
					<td><select name="st_status"  id="st_status"  style="width:90%"> 
			              <%= CommonUtil.getCodeComboQueryIdList("buyer.mpso.getPcOStatusList","ALL",status) %> 
			            </select>					
					</td>
				</tbody>
			</table>
		</div>
 		
 		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
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
		<!-- 공통 -->
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
	  	
		<table id="table_list" class="cont_t_list02" style="width:100%">
			<colgroup>
			 	  <col width="10%" />
                  <col width="10%" />
                  <col width="*" />
                  <col width="10%" />
                  <col width="6%" />                  
                  <col width="8%" />
                  <col width="10%" />
                  <col width="14%" />
	        </colgroup>
	        <thead>
        <tr>
          <th scope="col"  >발주번호<br>요청번호</th>
          <th scope="col" >품목코드<br>진행상태</th>
          <th scope="col">품목명<br>규격</th>
          <th scope="col" >단가/단위<br>납기요청일</th>
          <th scope="col" >발주수량<br>발주수량</th>
          <th scope="col" >발주금액<br>입고금액</th>
          <th scope="col" >주문일<br>입고일</th>
          <th scope="col" >협력사<br>요청자</th>
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
String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";

%> 
 
      <tr align="center" bgcolor="<%=tclass%>">
       <td title="발주번호/요청번호">	            
	             <%=rowData.get("LEGACY_PO_NO")%><br>
	               <%=rowData.get("REF_PR_NO")%>
	          </td>
	          <td title="품목코드/진행상태">
	            <%=rowData.get("BUYER_ITEM_NO")%><br>
				<%=rowData.get("STATUS")%>
	          </td>
	          <td class="left" title="품목명/규격">
	            <%=rowData.get("DESCRIPTION")%><br>
				<%=rowData.get("SPECIFICATION")%>
	          </td>
	          <td title="단가/단위/납기요청일">
	             <%=CommonUtil.formatNumber(rowData.get("TARGET_PRICE"),true,0,3)%>/<%=rowData.get("UNIT_MEASURE")%><br>
	            <%=CommonUtil.formatStrinigDate(rowData.get("RD_DATE"))%><br>
	          </td>
	          <td  class="right"  title="발주수량/입고수량">
	            <%=CommonUtil.formatNumber(rowData.get("ITEM_QTY"),true,0,3)%><br>
				<%=CommonUtil.formatNumber(rowData.get("GR_QTY"),true,0,3)%>
	          </td>
	          <td class="right"  title="발주금액/입고금액">
	            <%=CommonUtil.formatNumber(rowData.get("TARGET_AMT"),true,0,3)%><br>
				<%=CommonUtil.formatNumber(rowData.get("GR_AMT"),true,0,3)%>
	          </td>
	          <td title="주문일/입고일">
	            <%=CommonUtil.formatStrinigDate(rowData.get("PO_CREATE_DATE"))%><br>
				<%=CommonUtil.formatStrinigDate(rowData.get("GR_DATE"))%>
	          </td>
	          <td title="협력사/요청자">
	            <a class="hyperLink"  href="javascript:getAgentDisplayPop('<%=rowData.get("AGENT")%>');"><%=rowData.get("AGENT_LOC")%></a><br>
	            <%=rowData.get("ADD_USER_NAME")%>
	          </td>
      </tr>      
 <%}
} %>
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
	<!-- 버튼영역 -->
	<div class="btnArea">
		<div class="fl">
			<span class="btn_04 mr04">
				<a href="javascript:doPop('buyerMpPoOrderDeptPop', '');">부서별집계</a>
			</span>
			<span class="btn_04 mr04">
				<a href="javascript:doPop('buyerMpPoOrderAgentPop', '');">협력사별집계</a>
			</span>
		</div>
		<div class="fr">
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
		

		document.forms.searchForm.st_search_no.value = "";
		document.forms.searchForm.st_legacy_po_no.value = "";
		document.forms.searchForm.st_dept_nm.value = "";
		document.forms.searchForm.st_dept_no.value = "";	  		
		
		jspTableClean("table_list");
		break;

	case "excelDown": // 엑셀다운로드
		if (kepGetDateDiff('fromDate','toDate','D') > 93 ){
			alert("조회기간을 3개월 단위로 조회가 가능합니다.");
			return;
		}
		document.forms.searchForm.action = "/mpso/excelBuyerMpSoOrderAdminProgressList.do";
		document.forms.searchForm.submit();
		
		break;

	}
}

// 조회
function kepSearch(curPage){
	
	if (kep_dateSearchCheck($("#fromDate").val(),$("#toDate").val()) == false) return;  
	if (kepGetDateDiff('fromDate','toDate','D') > 93 ){
		alert("조회기간을 3개월 단위로 조회가 가능합니다.");
		return;
	}
	document.forms.searchForm.curPage.value = curPage;

	$('#searchForm').attr("action", "/mpso/getBuyerMpSoOrderAdminProgressList.do").submit();   
}

//팝업함수호출
function doPop(str, val, val2) {
	popupSel = str;
	var com_code = document.forms.searchForm.st_buyer_code.value;
	
	switch (str) {
		case "dept":
			openSearchPopup("/common/deptCodeAdminPop.do", "?com_code=" + com_code + "&open=Y", "500,500,no");	
			break;
		case "buyerMpPoOrderDeptPop": // 부서별집계
			if (kepGetDateDiff('fromDate','toDate','D') > 93 ){
				alert("조회기간을 3개월 단위로 조회가 가능합니다.");
				return;
			}
			var st_buyer_code = document.forms.searchForm.st_buyer_code.value;
		    var st_date_type = document.forms.searchForm.st_date_type.value;
			var fromDate = document.forms.searchForm.fromDate.value;
			var toDate = document.forms.searchForm.toDate.value;
			var st_search_no = document.forms.searchForm.st_search_no.value;
			var st_legacy_po_no = document.forms.searchForm.st_legacy_po_no.value;
			var st_dept_no =document.forms.searchForm.st_dept_no.value;
			var st_dept_nm =document.forms.searchForm.st_dept_nm.value;
			var st_status =document.forms.searchForm.st_status.value;
			openSearchPopup("/mppo/getBuyerMpPoOrderDeptPop.do", "?st_date_type="+st_date_type+"&fromDate="+fromDate+"&toDate="+toDate
										+"&st_search_no="+st_search_no+"&st_legacy_po_no="+st_legacy_po_no+"&st_dept_no="+st_dept_no+"&st_status="+st_status+"&st_buyer_code="+st_buyer_code+"&st_dept_nm="+st_dept_nm, "680,490,no");
			break;
		case "buyerMpPoOrderAgentPop": // 부서별집계
			if (kepGetDateDiff('fromDate','toDate','D') > 93 ){
				alert("조회기간을 3개월 단위로 조회가 가능합니다.");
				return;
			}
			var st_buyer_code = document.forms.searchForm.st_buyer_code.value;
		    var st_date_type = document.forms.searchForm.st_date_type.value;
			var fromDate = document.forms.searchForm.fromDate.value;
			var toDate = document.forms.searchForm.toDate.value;
			var st_search_no = document.forms.searchForm.st_search_no.value;
			var st_legacy_po_no = document.forms.searchForm.st_legacy_po_no.value;
			var st_dept_no =document.forms.searchForm.st_dept_no.value;
			var st_dept_nm =document.forms.searchForm.st_dept_nm.value;
			var st_status =document.forms.searchForm.st_status.value;
			openSearchPopup("/mppo/getBuyerMpPoOrderAgentPop.do", "?st_date_type="+st_date_type+"&fromDate="+fromDate+"&toDate="+toDate
										+"&st_search_no="+st_search_no+"&st_legacy_po_no="+st_legacy_po_no+"&st_dept_no="+st_dept_no+"&st_status="+st_status+"&st_buyer_code="+st_buyer_code+"&st_dept_nm="+st_dept_nm, "680,490,no");
			break;
	}
}
//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text, val) {
	//팝업 조회후 해당 항목에 값을 셋팅
	switch (popupSel) {
		case "dept":
			document.forms.searchForm.st_dept_nm.value = text;
			document.forms.searchForm.st_dept_no.value = code;
			break;

	}
}



</script>
</html>
