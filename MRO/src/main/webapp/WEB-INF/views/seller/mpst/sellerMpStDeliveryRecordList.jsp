<%--
**********************************************
* 메뉴 : 재고관리>VMI 납품관리>납품실적조회
* 화면 : 납품실적조회
* 기능 : 
* 프로그램 ID : PG_07_A_017_00
* 담당자 : 고영일 ( 설계 : 김지현 )
* 착수일 : 2014-08-28
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
 
</head>
<%
	// 공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = (String) request.getParameter("onepagerow");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	
	String pg_row = CommonUtil.nvl((String)request.getParameter("st_pg_row"), "10");
    String pg_no = CommonUtil.nvl((String)request.getParameter("st_page"), "1");
	String tot_cnt_string = "";
    int tot_cnt = 0;                                    //전체데이타row수
    int rec_cnt = 0;
    int page_display_cnt = 0;
    
	// 조회조건 S
	String st_check_date = CommonUtil.nvl((String) request.getParameter("st_check_date"),"");  	// 조회필드콤보
	String st_from_date = CommonUtil.nvl((String) request.getParameter("st_from_date"),""); 	 	// 조회일(From)
	String st_to_date = CommonUtil.nvl((String) request.getParameter("st_to_date"),"");  			// 조회일(To)
	String st_status_ing = CommonUtil.nvl((String) request.getParameter("st_status_ing"),"");  	// 조회필드콤보
	// 조회조건 E
	
%> 
<script type="text/javascript">
var popupSel = "";

// 최초 화면 함수 
function kep_onload_view(){
	
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	<%if("".equals(st_from_date)){%>
		$("#st_from_date").val( kepToMonthAdd("1","M"));
		$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
	<%}%>
}

var st;
//기능함수
function doAction(str, value1, value2) {
	switch (str) {
	case "search":	 //조회
		kepSearch(1);
		break;
		
	case "reload":	//초기화
		kepReload("searchForm");
		// 조회일 초기 셋팅
		kepSetCalender("st_from_date");
		kepSetCalender("st_to_date");
		
		$("#st_from_date").val( kepToMonthAdd("1","M"));
		$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));   
		jspTableClean("table_list");
		break;

	case "excelDown": // 엑셀다운로드
		document.forms.searchForm.action = "/mpst/excelSellerMpStDeliveryRecordList.do";
		document.forms.searchForm.submit();
		break;

	case "reportOpen": // 납품명세서 RD
		var st_buyer = value1;
	    var st_vpo_no = value2;
	    var st_agent = $("#st_com_code").val();
	    var rpt_url = "";
	    
	    // 고객사에 따른 REPORT 양식(기본 : RD_06_S_003_04), 조회된 결과로 특수로직 사용하기 어려워 하드코딩함.
	    if(st_buyer == "KRKORE0424"){ // GS칼텍스 여수 물류센터
	    	rpt_url = "RD_06_S_003_50";
	    }else{
	    	rpt_url = "RD_06_S_003_04";
	    }
	    	
	    reportOpen(rpt_url,"["+value1+"]["+value2+"]["+st_agent+"]"); 
		break;

	}
}

// 조회
function kepSearch(curPage){
	if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
	
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mpst/getSellerMpStDeliveryRecordList.do").submit();   
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
	<h3>납품실적조회</h3>
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
			
		<div id="cont_searchA">	
			<table class="cont_t_list01">
				<caption>조회</caption>
				<colgroup>
					<col width="10%" />
					<col width="25%" />
					<col width="10%" />
					<col width="25%" />
					<col width="10%" />
                    <col width="20%" />
				</colgroup>
				
				<tbody>
				<tr>
					<td>
						<label for="b_code" class="hidden">조회일선택</label>
			  			<select name = "st_check_date" id="st_check_date" style="height:20px;">
				      		<option value="CHANGE" <%if ("CHANGE".equals(st_check_date)) {%>selected<%} %>>생성일</option>
				      		<option value="GR" <%if ("GR".equals(st_check_date)) {%>selected<%} %>>입고일</option>
				      		<option value="PO" <%if ("PO".equals(st_check_date)) {%>selected<%} %>>권고발주일</option>
						</select>
					</td>
					<td colspan="3">
						<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:100px; text-align:center;" value="<%=st_from_date%>">
							<a href="javascript:kepCalendar('st_from_date')"></a>
						&nbsp;~&nbsp;
						<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:100px; text-align:center;" value="<%=st_to_date%>">
							<a href="javascript:kepCalendar('st_to_date')"></a>
							&nbsp;&nbsp;
						<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
						<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span> 
						<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>							
					</td>
                       
				    <td>입고여부</td>
					<td>
						<select name = "st_status_ing" id="st_status_ing" style="height:20px;">
				      		<option value="" >전체</option>
				      		<option value="A" <%if ("A".equals(st_status_ing)) {%>selected<%} %>>권고발주</option>
				      		<option value="B" <%if ("B".equals(st_status_ing)) {%>selected<%} %>>송장생성</option>
				      		<option value="C" <%if ("C".equals(st_status_ing)) {%>selected<%} %>>입고완료</option>
                         </select>
					</td>
				</tr>
				</tbody>
			</table>
		</div>
 		
 		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
	      	<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow">
				<option value = "10" <%if ("10".equals(onepagerow)) {%>selected<%} %>>10건</option>
				<option value = "20" <%if ("20".equals(onepagerow)) {%>selected<%} %>>20건</option>
				<option value = "30" <%if ("30".equals(onepagerow)) {%>selected<%} %>>30건</option>
				<option value = "40" <%if ("40".equals(onepagerow)) {%>selected<%} %>>40건</option>
				<option value = "50" <%if ("50".equals(onepagerow)) {%>selected<%} %>>50건</option>
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
	            <col width="20%" />
	            <col width="10%" />
	            <col width="*" />
	            <col width="8%" />
	            <col width="8%" />
	            <col width="8%" />
	            <col width="15%" />
	        </colgroup>
	        <thead>
			<tr>
                <th scope="col">물류센터명<br>입고여부</th>
                <th scope="col">발주송장번호<br>품목코드</th>
                <th scope="col">품목명<br>규격</th>
                <th scope="col">단위<br>입고수량</th>
                <th scope="col">입고일자<br>발주수량</th>
                <th scope="col">발주일자<br>송장수량</th>
                <th scope="col">송장일자<br>비고</th>
			</tr>
		</thead>
		<tbody>
 		<%
        if (_gridList == null || _gridList.size() == 0){
        %>
                    <tr>
                        <td colspan="7" align="center" height = "50"> 
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
                    <td title="물류센터명" class="td02"><%=String.valueOf(CommonUtil.nvl(rowData.get("WMS_NAME")))%></td>
                    <td title="발주송장번호" class="hyperLink"><a class="hyperLink" href="javascript:doAction('reportOpen','<%=String.valueOf(rowData.get("BUYER"))%>','<%=String.valueOf(rowData.get("VPO_NO"))%>');"><%=String.valueOf(CommonUtil.nvl(rowData.get("VPO_NO")))%></a></td>
                    <td title="품목명" class="td02 left"><%=String.valueOf(CommonUtil.nvl(rowData.get("DESCRIPTION")))%></td>
                    <td title="단위" class="td02"><%=String.valueOf(CommonUtil.nvl(rowData.get("UNIT_MEASURE")))%></td>
                    <td title="입고일자" class="td02"><%=CommonUtil.formatStrinigDate(rowData.get("VGR_DATE"))%></td>
                    <td title="발주일자" class="td02"><%=CommonUtil.formatStrinigDate(rowData.get("VPO_DATE"))%></td>
                    <td title="송장일자" class="td02"><%=CommonUtil.formatStrinigDate(rowData.get("VIV_DATE"))%></td>
				</tr>
				<tr bgcolor="<%=tclass%>">
                    <td title="입고여부" class="td02"><%=String.valueOf(CommonUtil.nvl(rowData.get("RECV_FLAG_NAME")))%></td>
                    <td title="품목코드" class="td02"><%=String.valueOf(CommonUtil.nvl(rowData.get("BUYER_ITEM_NO")))%></td>
                    <td title="규격" class="td02 left"><%=String.valueOf(CommonUtil.nvl(rowData.get("SPECIFICATION")))%></td>
                    <td title="입고수량" class="td02 right"><%=CommonUtil.formatNumber(String.valueOf(rowData.get("GR_QTY")),true,0,3)%></td>
                    <td title="발주수량" class="td02 right"><%=CommonUtil.formatNumber(String.valueOf(rowData.get("ITEM_QTY")),true,0,3)%></td>
                    <td title="송장수량" class="td02 right"><%=CommonUtil.formatNumber(String.valueOf(rowData.get("IV_QTY")),true,0,3)%></td>
                    <td title="비고" class="td02 left"><%=String.valueOf(CommonUtil.nvl(rowData.get("VPO_REMARK")))%></td>
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
</div>

<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/sellerFooter.jsp" %>   
</div>
</body>
</html>
