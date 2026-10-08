<%--
**********************************************
* 메뉴 : 도안관리>도안관리(동부)>발주관리
* 화면 : 발주관리
* 기능 : 도안을 사용하는 발주내역을 조회할 수 있다.
* 프로그램 ID : PG_06_B_020_00
* 담당자 : 손상민 ( 설계 : 김지현 )
* 착수일 : 2014-06-20
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
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
	int total_cnt = (CommonUtil.nvlInt((List<Map<String,String>>) _gridList ,"0")).intValue(); // 총 조회수 (필수)
	int grid_cnt = (_gridList != null )? _gridList.size() : 0;
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = (String) request.getParameter("onepagerow");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
    
	// 조회조건 S
	// 조회조건 E
%> 

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
	<h3>발주관리</h3>
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
            <table class="cont_t_list01" width="780"><!-- 마이페이지 닫힐때 width="887"-->
					<caption>발주관리</caption>
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
				          <th >
							<select name="st_date_type"   class="TitSelect" >
								<option value="ADD_DATE">주문일</option>
								<option value="PO_DATE">발주일</option>
								<option value="RD_DATE">납품요청일</option>
							</select>
						  </th>
					      <td colspan="3"> 
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:20%; text-align:center;" value=""> - 
		                        <input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:20%; text-align:center;" value=""> 
		                        <span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span>	
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>
								<span class="btn_month"><a href="javascript:setCurMonth('st_from_date','st_to_date')">당월</a></span>									
							</td>
					          <th >요청공장</th>
					          <td>
					          <c:if test="${sessionInfo.comCode ne 'KRDONG0732'}">
									<select id="st_buyer_code" name="st_buyer_code">
										<option value="ALL" selected>전체</option>
										<option value="KRDONG0110">(주)동부한농 인천공장</option>
										<option value="KRDONG0107">(주)동부한농 구미공장</option>
										<option value="KRDONG0128">(주)동부아그로텍 전주공장</option>
									</select>
					          </c:if>
					          <c:if test="${sessionInfo.comCode eq 'KRDONG0732'}">
									<select id="st_buyer_code" name="st_buyer_code">
										<option value="KRDONG0732" selected>(주)동부팜한농 안성공장</option><!-- SM000010 추가 -->
									</select>
					          </c:if>
							  </td>
					        </tr>
						<tr> 
				          <th>품목코드</th>
				          <td><input type="text" name="st_buyer_item_no" style="width:87%" value="" onkeydown="kepEnter()"></td>
				          <th >진행상태</th>
				          <td >
				            <select  name="st_po_status"  >
								<option value="ALL" >전체</option>
								<option value="PR" >주문</option>
								<option value="PO" >발주</option>
								<option value="DS" >접수</option>
								<option value="IV" >납품</option>
								<option value="GR" >입고</option>	
							</select>
							</td>
				          <th>진행완료 제외</th>
				          <td>
				            <input type="checkbox"  class="Noborder" name="st_gr_exception" id="st_gr_exception" checked>
				           </td>
						</tr>
						<tr>
				          <th>품목명</th>
				          <td><input type="text" name="st_description" style="width:87%" value="" onkeydown="kepEnter()"></td> 
				          <th>발주자</th>
				          <td><input type="text" name="st_purchaser_name" style="width:87%" value="" onkeydown="kepEnter()"></td>
				          <th></th><td></td>
						</tr>
					</tbody>
				</table>
		</div>

		<table style="width:100%;">
			<tr>
				<td align="left">
	           		<img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
	               	<label for="b_no02" class="hidden">정렬개수선택</label>
					<select name="onepagerow">
						<option value = "10" >10건</option>
						<option value = "20" >20건</option>
						<option value = "30" >30건</option>
						<option value = "40" >40건</option>
						<option value = "50" >50건</option> 
					</select>
					
				</td>
				<c:if test="${sessionInfo.comCode eq 'KRDONG0110' || sessionInfo.comCode eq 'KRDONG0107' || sessionInfo.comCode eq 'KRDONG0128' || sessionInfo.userId eq 'CHANG9581' || sessionInfo.userId eq 'EUNHOJEE' }">
			        <td align="right">
						<span class="btn_02"><a href="javascript:doPop('buyerOffPo');">발주</a></span>
			        </td>
				</c:if>
	   		</tr>
		</table>

	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<!-- 공통 -->
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
		<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
	  	
	  	
		<table id="table_list" class="cont_t_list02" style="width:100%">

	        <thead>
			<tr>
					<th scope="col" width="30">
						<input type="checkbox" name="check_status" id="check_status" value="선택"  style="cursor:hand;" onclick="javascript:kepCheckAll('<%=grid_cnt %>',document.forms.contentForm.check_status,'document.forms.contentForm.checkbox')">
					</th>
					<th width="8%"  >품목코드</th>
					<th width="16%"  >품목명</th>
					<th width="7%" >주문자<br>주문일</th>
					<th width="7%" >수량<br>단위</th>
					<th width="8%" >발주일<br>납품요청일</th>
					<th width="10%" >입고일<br>입고수량</th>
					<th width="7%" >비고<br>제조모집단</th>
					<th width="*" colspan="5">제품확인상태<br>주문/발주/접수/납품/입고</th>
					<th width="8%"  >납품<br>예정일</th>
					<th width="6%"  >납품처</th>
					<th width="8%"  >도안<br>상태</th>
			</tr>
		</thead>
		<tbody>
 		<%
        if (_gridList == null || _gridList.size() == 0){
        %>
                    <tr>
                        <td colspan="16" align="center" height = "50"> 
                        <span>조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
        <%
        }else{

			String statusProgressPR		= "";
			String statusProgressPO		= "";
			String statusProgressDS		= "";
			String statusProgressIV		= "";
			String statusProgressGR		= "";
        	
			for (int j=0; j<_gridList.size(); j++) {
				Map<String,String> rowData = _gridList.get(j);
				String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
				
				if(rowData.get("STATUS").equals("PR")) {
					statusProgressPR	= "<img src=\"/resources/images/icon_bl.gif\">";
				}
				if(rowData.get("STATUS").equals("PO")) {
					statusProgressPR	= "<img src=\"/resources/images/icon_bl.gif\">";
					statusProgressPO	= "<img src=\"/resources/images/icon_bl.gif\">";
				}
				if(rowData.get("STATUS").equals("DS")) {
					statusProgressPR	= "<img src=\"/resources/images/icon_bl.gif\">";
					statusProgressPO	= "<img src=\"/resources/images/icon_bl.gif\">";
					statusProgressDS	= "<img src=\"/resources/images/icon_bl.gif\">";
				}
				if(rowData.get("STATUS").equals("IV")) {
					statusProgressPR	= "<img src=\"/resources/images/icon_bl.gif\">";
					statusProgressPO	= "<img src=\"/resources/images/icon_bl.gif\">";
					statusProgressDS	= "<img src=\"/resources/images/icon_bl.gif\">";
					statusProgressIV	= "<img src=\"/resources/images/icon_bl.gif\">";
				}
				if(rowData.get("STATUS").equals("GR")) {
					statusProgressPR	= "<img src=\"/resources/images/icon_bl.gif\">";
					statusProgressPO	= "<img src=\"/resources/images/icon_bl.gif\">";
					statusProgressDS	= "<img src=\"/resources/images/icon_bl.gif\">";
					statusProgressIV	= "<img src=\"/resources/images/icon_bl.gif\">";
					
					if(Double.parseDouble(rowData.get("DS_QTY")) > Double.parseDouble(rowData.get("GR_QTY"))) {
						statusProgressGR	= "<img src=\"/resources/images/icon_bl01.gif\">";
					}else {
						statusProgressGR	= "<img src=\"/resources/images/icon_bl.gif\">";
					}								
				}				
		%> 

							<tr align="center">
								<td rowspan="2" >
									<input type="checkbox" name="checkbox" id="checkbox<%=j%>">
									<input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=grid_cnt %>" >
									<input type="hidden" name="st_buyer"		value="<%=rowData.get("BUYER")%>">
									<input type="hidden" name="st_add_date"		value="<%=rowData.get("ADD_DATE")%>">
									<input type="hidden" name="st_seq"			value="<%=rowData.get("SEQ")%>">
									<input type="hidden" name="st_ds_seq"		value="<%=rowData.get("DS_SEQ")%>">
									<input type="hidden" name="st_di_qty"		value="<%=rowData.get("DI_QTY")%>">
									<input type="hidden" name="st_ds_qty"		value="<%=rowData.get("DS_QTY")%>">
									<input type="hidden" name="st_status"		value="<%=rowData.get("STATUS")%>">
									<input type="hidden" name="st_byca_comorg_code"		value="<%=rowData.get("BYCA_COMORG_CODE")%>">
									
								</td>
								<td rowspan="2" >
									<a class="hyperLink" href="javascript:doPop('masterMpDsOrderInfoConfirmPop', '<%=rowData.get("BUYER")%>','<%=rowData.get("ADD_DATE")%>','<%=rowData.get("SEQ")%>','<%=rowData.get("STATUS")%>','<%=rowData.get("DS_SEQ")%>');"><%=rowData.get("BUYER_ITEM_NO")%></a>
								</td>
								<td rowspan="2" class="left"><%=rowData.get("DESCRIPTION")%></td>
								<td ><%=rowData.get("PURCHASERNAME")%></td>
								<td align="right" ><%=CommonUtil.formatNumber(rowData.get("DS_QTY"), true, 0, 3)%></td>
								<td ><%=CommonUtil.formatStrinigDate(rowData.get("PO_DATE"))%></td>
								<td >
								<%
									if(!rowData.get("GR_DATE").equals("")) {
								%>
									<input type="text" id="st_gr_date<%=j %>" name="st_gr_date"  value="<%=CommonUtil.formatStrinigDate(rowData.get("GR_DATE"))%>" readonly style="width:78%;text-align:center;border-width:0px;background-color:transparent;">
<%-- 									<input type="hidden" name="st_gr_date"	value="<%=rowData.get("GR_DATE")%>"> --%>
								<%
									}else {

										if(rowData.get("STATUS").equals("IV")) {
								%>
											<input type="text" id="st_gr_date<%=j %>" name="st_gr_date" value="<%=CommonUtil.formatStrinigDate(rowData.get("DS_DATE"))%>" readonly style="width:78%;text-align:center;" >
<%-- 											<input type="hidden" name="st_gr_date"	value="<%=rowData.get("DS_DATE")%>"> --%>
								<%
										}else {

								%>
											<input type="text"  id="st_gr_date<%=j %>"  name="st_gr_date" value="" readonly style="width:78%;text-align:center;" >
								<%
										}
									}
								%>
								</td>
								<td >
								<input type="hidden" name="st_remark"	value="<%=rowData.get("REMARK")%>">
									<%
										if(rowData.get("REMARK").equals("")) {
									%>
										<img src="/resources/images/but_icon02.gif" border="0" name="st_delytolocation_img">
									<%
										}else {
									%>
<%-- 										<a href="javascript:get_remark('<%=j%>');"  ><img src="/resources/images/but_icon01.gif" border="0" name="st_delytolocation_img"></a> --%>
										<a class="hyperLink"  href="javascript:doPop('remarkReturnPop','<%=rowData.get("REMARK")%>');"><img src="/resources/images/but_icon01.gif" border="0" name="st_delytolocation_img"></a>
										
									<%
										}
									%>
								</td>
								<td rowspan="2"  style="width:30px;">
								<%=statusProgressPR%>
								</td>
								<td rowspan="2"  style="width:30px;">
								<%=statusProgressPO%></td>
								<td rowspan="2"  style="width:30px;">
								<%=statusProgressDS%></td>
								<td rowspan="2"  style="width:30px;">
								<%=statusProgressIV%></td>
								<td rowspan="2"  style="width:30px;">
								<%=statusProgressGR%></td>
								<td rowspan="2" style="width:30px;"><%=CommonUtil.formatStrinigDate(rowData.get("DS_DATE"))%></td>
								<td rowspan="2" >
									
									<%
										if(rowData.get("DELY_TO_LOCATION_TEXT").equals("")) {
									%>
										<img src="/resources/images/but_icon02.gif" border="0" name="st_delytolocation_img">
									<%
										}else {
									%>
										<a class="hyperLink"  href="javascript:doPop('remarkReturnPop','<%=rowData.get("DELY_TO_LOCATION_TEXT")%>');"><img src="/resources/images/but_icon01.gif" border="0" name="st_delytolocation_img"></a>
									<%
										}
									%>
								</td>
								<td rowspan="2" >
								<%
									if(rowData.get("PACKAGE_STATUS").equals("")) {
								%>
									매핑중
								<%
									}else {
								%>
										<%=rowData.get("PACKAGE_STATUS")%>
								<%
									}
								%>
								</td>
							</tr>
							<tr >
								<td ><%=CommonUtil.formatStrinigDate(rowData.get("ADD_DATE"))%></td>
								<td ><%=rowData.get("UNIT_MEASURE")%></td>
								<td ><%=CommonUtil.formatStrinigDate(rowData.get("RD_DATE"))%></td>
								<td>
								<%
									if(!rowData.get("GR_DATE").equals("")) {
								%>
										<input type="text" name="st_gr_qty" value="<%=CommonUtil.formatNumber(rowData.get("GR_QTY"), true, 0, 3)%>" readonly style="width:92%;border-width:0px;text-align:right;background-color:transparent;">
<%-- 										<input type="hidden" name="st_gr_qty" value="<%=rowData.get("GR_QTY")%>"> --%>
								<%
									}else {
										if(rowData.get("STATUS").equals("IV")) {
								%>
											<input type="text" id="st_gr_qty" name="st_gr_qty"  value="<%=CommonUtil.formatNumber(rowData.get("DS_QTY"), true, 0, 3)%>" onkeyup="kepNumcheck2('contentForm', 'st_gr_qty','<%= j %>')"  style="width:92%;text-align:right;">
<%-- 											<input type="hidden" name="st_gr_qty" value="<%=rowData.get("DS_QTY")%>"> --%>
								<%
										}else {

								%>
											<input type="text" id="st_gr_qty"  name="st_gr_qty"  value="" onkeyup="kepNumcheck2('contentForm', 'st_gr_qty','<%= j %>')" style="width:92%;text-align:right;">
<!-- 											<input type="hidden" name="st_gr_qty" value=""> -->
								<%
										}
									}
								%>
								</td>
								<td >
									<%
										if(rowData.get("REF_NO").equals("")) {
									%>
										<img src="/resources/images/but_icon02.gif" border="0" name="st_delytolocation_img">
									<%
										}else {
									%>
<%-- 										<a href="#"  onmouseover="show('<%=rowData.get("REF_NO")%>');" onmouseout="hide();" ><img src="/resources/images/but_icon01.gif" border="0" name="st_delytolocation_img"></a> --%>
										<a class="hyperLink"  href="javascript:doPop('remarkReturnPop','<%=rowData.get("REF_NO")%>');"><img src="/resources/images/but_icon01.gif" border="0" name="st_delytolocation_img"></a>
									<%
										}
									%>
								</td>
							</tr>
			<%
							statusProgressPR		= "";
							statusProgressPO		= "";
							statusProgressDS		= "";
							statusProgressIV		= "";
							statusProgressGR		= "";

                        } 
        			}
            %>
           		</tbody>
            </table>
		<!-- 페이징 -->
		<p id="paging" class="paging">
			<%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow) %>
			<span class="cl">[ 총 <%=total_cnt %> 건 ]</span> 
		</p>  
		
		<!-- 버튼영역 -->
		<div class="btnArea">
			<div class="fr">
  					<span class="btn_02 mr04"><a href="javascript:doAction('setGrNextMonth');">부분입고</a></span>
  					<span class="btn_02 mr04"><a href="javascript:doAction('setGrCancelReg');">입고취소</a></span>
  					<span class="btn_05 mr04"><a href="javascript:doAction('setGrReg');">입고실적등록</a></span>
  					<span class="btn_05"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
            </div>
        </div>
</form>

<form name="processForm" id="processForm" method="post">	
	<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" />
	<input type="hidden" name="total_cnt" id="total_cnt"  value="<%=total_cnt %>"/>
	<input type="hidden" name="curPage" id="curPage"  value="<%=curPage %>"/>
	<input type="hidden" name="onepagerow" id="onepagerow"  value="<%=onepagerow %>"/>
	<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
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
	
	//조회조건 초기화(기존값 재설정)
	initSearchCondition("searchForm", "st_from_date", "${st_from_date}");	//시작일(FROM)
	initSearchCondition("searchForm", "st_to_date", "${st_to_date}");	//시작일(TO)

	initSearchCondition("searchForm", "st_date_type", "${st_date_type}");	//정렬기준
	initSearchCondition("searchForm", "st_buyer_code", "${st_buyer_code}", "${sessionInfo.comCode}");	//요청공장
	initSearchCondition("searchForm", "st_gr_exception", "${st_gr_exception}");	//진행완료 제외
	initSearchCondition("searchForm", "st_buyer_item_no", "${st_buyer_item_no}");	//품목코드
	initSearchCondition("searchForm", "st_description", "${st_description}");	//품명
	initSearchCondition("searchForm", "st_purchaser_name", "${st_purchaser_name}");	//발주자
	initSearchCondition("searchForm", "st_po_status", "${st_po_status}");	//진행상태
	
	initSearchCondition("searchForm", "onepagerow", "${onepagerow}");	//페이징단위

	//
	kep_listkepSetCalender('st_gr_date', <%=grid_cnt%>);
	<%-- kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	<%if("".equals(st_from_date)){%>
		$("#st_from_date").val( kepToMonthAdd("1","M"));
		$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
	<%}%> --%>
}

var st;
//기능함수
function doAction(str) {
	switch (str) {
	case "search":	 //조회
		kepSearch($("#curPage").val());
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
		document.forms.searchForm.action = "/mpds/excelBuyerMpDsOrderManageList.do";
		document.forms.searchForm.submit();
// 		$('#searchForm').attr("action", "/mpds/excelBuyerMpDsOrderManageList.do").submit();
		break;

	case "setGrNextMonth": // 부분입고	
		var btnEvent = "setGrNextMonth";
		// 그리드 데이터 셋팅
		if(setGridData(btnEvent)){
			if(!confirm("부분입고 하시겠습니까?")){ 
				return;
			} 
			kepAjaxFormCall("/mpds/setGrNextMonthBuyerMpDsOrderManage.do","processForm",btnEvent); 	
		}
		break;

	case "setGrCancelReg": // 입고취소	
		var btnEvent = "setGrCancelReg";
		// 그리드 데이터 셋팅
		if(setGridData(btnEvent)){
			if(!confirm("입고취소 하시겠습니까?")){ 
				return;
			} 
			kepAjaxFormCall("/mpds/setGrCancelRegBuyerMpDsOrderManage.do","processForm",btnEvent); 	
		}
		break;

	case "setGrReg": // 입고실적등록
		var btnEvent = "setGrReg";
		// 그리드 데이터 셋팅
		if(setGridData(btnEvent)){
			if(!confirm("입고실적등록 하시겠습니까?")){ 
				return;
			} 
			kepAjaxFormCall("/mpds/setGrRegBuyerMpDsOrderManage.do","processForm",btnEvent); 	
		}
		break;

	}
}

// 조회
function kepSearch(curPage){
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mpds/getBuyerMpDsOrderManageList.do").submit();   
}
  
// 팝업 함수호출
function doPop(str,value1, value2, value3, value4, value5) {

	popupSel = str;
	
	switch (str) {
	case "buyerOffPo": // 발주팝업
		openSearchPopup('/mpds/showMasterMpDsOrderCreationPop.do','?st_com_type=buyer','937,650,no');
		break;
	case "masterMpDsOrderInfoConfirmPop"://품목코드
		openSearchPopup('/mpds/getMasterMpDsOrderInfoConfirmPop.do','?st_buyer='+value1+'&st_add_date='+value2+'&st_seq='+value3+'&st_po_status='+value4+'&st_ds_seq='+value5,'620,440,no');
		break;	
	case "remarkReturnPop": // 비고
		openSearchPopup('/common/remarkReturnPop.do','?st_return_remark='+value1,'500,230,');
		break;
	}
	
}

// 콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text){
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyerOffPo") {	// 발주
		doAction('search');	

	}else	if (popupSel == "masterMpDsOrderInfoConfirmPop") { 
		doAction('search');	

	}
}

// 선택된 그리드 값을 셋팅
function setGridData(btnEvent){
	var returnValue = true;
	var chkGridValue = {};
	var tot_cnt  = $("#display_item_cnt").val();
	
	if(btnEvent == "setGrNextMonth"){//부분입고
	
        for(var k = 0; k < tot_cnt; k++){
            var box = eval("document.forms.contentForm.checkbox"+k+"");
			
            if(box !=null && box.checked == true){
				var ds_qty = $("form[name=contentForm]").find("input[name=st_ds_qty]").eq(k).val();
				var di_qty = $("form[name=contentForm]").find("input[name=st_di_qty]").eq(k).val();
				var gr_date = $("form[name=contentForm]").find("input[name=st_gr_date]").eq(k).val();
				var gr_qty = $("form[name=contentForm]").find("input[name=st_gr_qty]").eq(k).val();
				var st_status = $("form[name=contentForm]").find("input[name=st_status]").eq(k).val();
				var next_po_qty;
				
				if(st_status =="PR" || st_status =="PO" || st_status =="DS") {
					alert("송장이 생성되지 않아 처리할 수 없습니다.");
					return false;
				}

				if(st_status =="GR") {
					alert("이미 입고처리가 진행되었습니다.");
					return false;
				}
				if(isEmpty(gr_date)) {
					alert("입고일을 입력하여 주십시오.");
					return false;
				}
				if(isEmpty(gr_qty)) {
					alert("입고 수량을 입력하여 주십시오.");
					return false;
				}
				if (ds_qty != '' && gr_qty != ''){
		            next_po_qty	= eval(kepRemoveComma(ds_qty))-eval(kepRemoveComma(gr_qty));

	     			if(eval(next_po_qty)==0) {
			 			alert("입고완료 된 상태 입니다.\n\n부분입고 할 수 없습니다.");
			 			return false;
	 				}
	     			if(eval(next_po_qty)<0) {
			 			alert("주문수량을 초과하였습니다.\n\n부분입고 할 수 없습니다.");
			 			return false;
	 				}
		        }
				if (di_qty != null && di_qty!=''){
		 			if(eval(di_qty)>eval(next_po_qty)) {
		 				alert("협력사 납품 실적 수량이 "+di_qty+" 라서 이월 할 수 없으니\n\n담당자(엄미주,02-3016-8937) 연락하여 처리하시길 바랍니다.");
		 				return false;
		 			}
				}
            }
        }
	    
	}else if(btnEvent == "setGrCancelReg"){// 입고취소

        for(var k = 0; k < tot_cnt; k++){
            var box = eval("document.forms.contentForm.checkbox"+k+"");
            
            if(box !=null && box.checked == true){
				var st_status = $("form[name=contentForm]").find("input[name=st_status]").eq(k).val();

				if(st_status =="PR" || st_status =="PO" || st_status =="DS"  || st_status =="IV") {
					alert("입고실적이 등록되지 않았으므로 처리 할 수 없습니다.");
					return false;
				}
            }

        }

		
	}else if(btnEvent == "setGrReg"){// 입고실적등록
		
	         for(var k = 0; k < tot_cnt; k++){
		         var box = eval("document.forms.contentForm.checkbox"+k+"");
		         if(box !=null && box.checked == true){
					var gr_date = $("form[name=contentForm]").find("input[name=st_gr_date]").eq(k).val();
					var gr_qty = $("form[name=contentForm]").find("input[name=st_gr_qty]").eq(k).val();
					var st_status = $("form[name=contentForm]").find("input[name=st_status]").eq(k).val();
					
					if(st_status =="PR" || st_status =="PO" || st_status =="DS") {
						alert("송장이 생성되지 않아 처리할 수 없습니다.");
						return false;
					}
					if(st_status =="GR") {
						alert("이미 입고처리가 진행되었습니다.");
						return false;
					}
		
					if(st_status == "IV"){
						if(isEmpty(gr_date)) {
							alert("입고일을 입력하여 주십시오.");
							return false;
						}
						if(isEmpty(gr_qty)) {
							alert("입고 수량을 입력하여 주십시오.");
							return false;
						}
				     }
		         }
		}

	}

	var formArr = getFormToArr("document.forms.contentForm",true, chkGridValue );
// 	alert(formArr[0]);return;
	if(formArr[0].length == 0){
		alert("선택된 항목이 없습니다");
		return;	
	}

	if(formArr != null && formArr !=""){
		document.forms.processForm.s_SAVENAME.value =formArr[0];
		$("#process").html(formArr[1]);
	}else{
		alert("그리드 데이터 변환에 실패하였습니다.[getFormToArr]");
		returnValue = false;
	}
	return returnValue;
}

// ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	var msg = response.msg;
	
	if (msg != ""){
		alert(msg);
	}
	// 처리후 재조회
	kepSearch($("#curPage").val());
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
 function  kepAjaxError(pMethod , response) {
	 alert("처리중 오류가 발생 하였습니다.\n\n확인 후 다시 시도하여 주십시요");
 } 
</script>
</html>
