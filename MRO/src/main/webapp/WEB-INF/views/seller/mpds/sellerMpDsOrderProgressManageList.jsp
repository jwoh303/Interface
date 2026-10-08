<%--
**********************************************
* 메뉴 : 도안관리>도안관리>발주진행관리
* 화면 : 발주진행관리
* 기능 : 도안관련 발주 목록을 조회할 수 있다.
* 프로그램 ID : PG_07_A_012_00
* 담당자 : 손상민 ( 설계 : 김지현 )
* 착수일 : 2014-06-26
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
	<h3>발주진행관리</h3>
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
            	<table  class="cont_t_list01" >
					<caption>발주진행관리</caption>
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
				            <th>납품요청일</th>
							<td  colspan="3">
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:20%; text-align:center;" value=""> - 
		                        <input type="text" class="input_type_text" name="st_to_date_p1" id="st_to_date_p1" readOnly style="width:20%; text-align:center;" value=""> 
		                        <span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date_p1','1')">1개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date_p1','2')">2개월</a></span>	
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date_p1','3')">3개월</a></span>								
							</td>
							<th>구분</th>
							<td > 
								<c:if test="${st_gubun == null or st_gubun == '' or st_gubun == 'CROP' }">
									<input type="radio" class="Noborder" id="st_gubun" name="st_gubun"  value="CROP" checked  onclick="setBuyerCombo();">
									작물보호 
									<input type="radio" class="Noborder" id="st_gubun" name="st_gubun"  value="SEED" onclick="setBuyerCombo();">
									종자
								</c:if>
								<c:if test="${st_gubun == 'SEED'}">
									<input type="radio" class="Noborder" id="st_bugun" name="st_gubun"  value="CROP"  onclick="setBuyerCombo();">
									작물보호 
									<input type="radio" class="Noborder" id="st_gubun" name="st_gubun"  value="SEED"  checked onclick="setBuyerCombo();">
									종자
								</c:if>
							</td>
					          <th></th>
					          <td></td>
					        </tr>
						<tr> 
				          <th>품목코드</th>
				          <td><input type="text" name="st_buyer_item_no" id="st_buyer_item_no"  style="width:87%" value="" onkeydown="kepEnter()"></td>
				          <th>요청공장</th>
				          <td>
							<select id="st_buyer_code" name="st_buyer_code"  >
								<option value="ALL" selected>전체</option>
								<option value="KRDONG0110">(주)동부한농 인천공장</option>
								<option value="KRDONG0107">(주)동부한농 구미공장</option>
								<option value="KRDONG0128">(주)동부아그로텍 전주공장</option>
							</select>
						  </td>
							<th></th><td></td>
						</tr>
						<tr>
				          <th>품목명</th>
				          <td><input type="text" name="st_description" id="st_description"  style="width:87%" value="" onkeydown="kepEnter()"></td> 
				          <th  >진행상태</th>
				          <td >
				            <select   name="st_po_status">
								<option value="ALL" >전체</option>
								<option value="PO" >발주</option>
								<option value="DS" >접수</option>
								<option value="IV" >송장</option>
								<option value="DI" >납품</option>	
							</select>
							</td>
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
	   		</tr>
		</table>

	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<!-- 공통 -->
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
		<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
	  	
	  	
		<table id="table_list"  class="cont_t_list02" style="width:100%">

	        <thead>
			<tr>
					<th scope="col" width="30">
						<input type="checkbox" name="check_status" id="check_status" value="선택"  style="cursor:hand;" onclick="javascript:kepCheckAll('<%=grid_cnt %>',document.forms.contentForm.check_status,'document.forms.contentForm.checkbox')">
					</th>
					<th width="12%"  >공장</th>
					<th width="6%"  >품목코드</th>
					<th width="18%"  >품목명</th>
					<th width="7%" >납품<br>예정일</th>
					<th width="4%" >수량<br>단위</th>
					<th width="8%" >발주일<br>납품요청일</th>
					<th width="7%" >비고<br>제조모집단</th>
					<th width="*" colspan="4">상태<br>발주/접수/송장/납품</th>
					<th width="10%"  >실적<br>등록일</th>
					<th width="8%"  >납품처</th>
					<th width="6%"  >도안<br>상태</th>
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

			String statusProgressPO		= "";
			String statusProgressDS		= "";
			String statusProgressIV		= "";
			String statusProgressDI		= "";
        	
			for (int j=0; j<_gridList.size(); j++) {
				Map<String,String> rowData = _gridList.get(j);
				String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
				
				if(rowData.get("STATUS").equals("PO")) {
					statusProgressPO	= "<img src=\"/resources/images/icon_bl.gif\">";
				}
				if(rowData.get("STATUS").equals("DS")) {
					statusProgressPO	= "<img src=\"/resources/images/icon_bl.gif\">";
					statusProgressDS	= "<img src=\"/resources/images/icon_bl.gif\">";
				}
				if(rowData.get("STATUS").equals("IV")) {
					statusProgressPO	= "<img src=\"/resources/images/icon_bl.gif\">";
					statusProgressDS	= "<img src=\"/resources/images/icon_bl.gif\">";
					statusProgressIV	= "<a href=\"javascript:doPop('reportViewerPop','"+rowData.get("BUYER")+"','"+rowData.get("ADD_DATE")+"','"+rowData.get("SEQ")+"','"+rowData.get("DS_SEQ")+"');\"><img src=\"/resources/images/icon_bl.gif\" board=\"0\"></a>";
				}
				if(rowData.get("STATUS").equals("DI")) {
					statusProgressPO	= "<img src=\"/resources/images/icon_bl.gif\">";
					statusProgressDS	= "<img src=\"/resources/images/icon_bl.gif\">";
					statusProgressIV	= "<a href=\"javascript:doPop('reportViewerPop','"+rowData.get("BUYER")+"','"+rowData.get("ADD_DATE")+"','"+rowData.get("SEQ")+"','"+rowData.get("DS_SEQ")+"');\"><img src=\"/resources/images/icon_bl.gif\" board=\"0\"></a>";
					statusProgressDI	= "<img src=\"/resources/images/icon_bl.gif\">";
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
									<input type="hidden" name="st_ds_qty"		value="<%=rowData.get("DS_QTY")%>">
							        <input type="hidden" name="st_item_no"			value="<%=rowData.get("BUYER_ITEM_NO")%>">
							        <input type="hidden" name="st_status"			value="<%=rowData.get("STATUS")%>">
									
								</td>
						<td rowspan="2" align="center" ><%=rowData.get("BUYER_NAME")%></td>
						<td rowspan="2" align="center" >
						<%
							if(rowData.get("STATUS").equals("PO") || rowData.get("STATUS").equals("DS")) {

								if(rowData.get("DS_DATE").equals("")) {
						%>
<%-- 									<a class="hyperLink" href="javascript:dopsysop_dongbu_agent_ds_pop('<%=rowData.get("BUYER")%>','<%=rowData.get("ADD_DATE")%>','<%=rowData.get("SEQ")%>','<%=rowData.get("DS_SEQ")%>');"><%=rowData.get("BUYER_ITEM_NO")%></a> --%>
									<a class="hyperLink" href="javascript:doPop('sellerMpDsOrderObtnodrReceiptPop', '<%=rowData.get("BUYER")%>','<%=rowData.get("ADD_DATE")%>','<%=rowData.get("SEQ")%>','<%=rowData.get("DS_SEQ")%>');"><%=rowData.get("BUYER_ITEM_NO")%></a>
						<%
								}else {
						%>
<%-- 									<a class="hyperLink" href="javascript:sysop_dongbu_agent_iv_pop('<%=rowData.get("BUYER")%>','<%=rowData.get("ADD_DATE")%>','<%=rowData.get("SEQ")%>','<%=rowData.get("DS_SEQ")%>');"><%=rowData.get("BUYER_ITEM_NO")%></a> --%>
									<a class="hyperLink" href="javascript:doPop('sellerMpDsTranStatementCreationPop', '<%=rowData.get("BUYER")%>','<%=rowData.get("ADD_DATE")%>','<%=rowData.get("SEQ")%>','<%=rowData.get("DS_SEQ")%>');"><%=rowData.get("BUYER_ITEM_NO")%></a>
						<%
								}
							}else {
						%>
								<%=rowData.get("BUYER_ITEM_NO")%>
						<%
							}
						%>

						</td>
						<td rowspan="2" ><%=rowData.get("DESCRIPTION")%></td>
						<td rowspan="2" ><%=CommonUtil.formatStrinigDate(rowData.get("DS_DATE")) %></td>
						<td align="right" ><%=CommonUtil.formatNumber(rowData.get("DS_QTY"), true, 0, 3) %></td>
						<td align="center" ><%=CommonUtil.formatStrinigDate(rowData.get("PO_DATE")) %></td>
						<td align="center">
								<%
									if( rowData.get("A_REMARK").equals("") && rowData.get("B_REMARK").equals("") ) {
								%>
									<img src="/resources/images/but_icon02.gif"  border="0" name="st_delytolocation_img">
								<%
									}else {
								%>
<%-- 									<a href="javascript:remark_view_list('<%=j%>');"><img src="/resources/images/but_icon01.gif"  border="0" name="st_delytolocation_img"></a> --%>
									<a class="hyperLink"  href="javascript:doPop('remark','<%=rowData.get("A_REMARK")%>','<%=rowData.get("B_REMARK")%>');"><img src="/resources/images/but_icon01.gif" border="0" name="st_delytolocation_img"></a>
								<%
									}
								%>
						</td>
						<td rowspan="2" style="width:30px;"><%=statusProgressPO%></td>
						<td rowspan="2" style="width:30px;"><%=statusProgressDS%></td>
						<td rowspan="2" style="width:30px;"><%=statusProgressIV%></td>
						<td rowspan="2" style="width:30px;"><%=statusProgressDI%></td>
						<td rowspan="2" >
						<%
							if(rowData.get("DI_DATE").equals("") && rowData.get("STATUS").equals("IV")) {
						%>	
								<input type="text" name="st_di_date" id="st_di_date<%=j %>" readOnly style="width:55%; text-align:center;" value="">
								<a href="javascript:kepCalendar('st_di_date')"></a>
						<%
							}else if(!rowData.get("DI_DATE").equals("") && rowData.get("STATUS").equals("DI")) {
						%>
								<input type="text" name="st_di_date" id="st_di_date" value="<%=CommonUtil.formatStrinigDate(rowData.get("DI_DATE")) %>" readOnly style="width:55%; text-align:center;border-width:0px;">
						<%
							}else {
						%>	
								<input type="text" name="st_di_date" id="st_di_date" readOnly style="width:55%; text-align:center;border-width:0px;" value="">
						<%
							}
						%>
						<input type="hidden" name="st_di_qty" value="0">
						</td>
						<td rowspan="2" ><%=rowData.get("DELY_TO_LOCATION_TEXT")%></td>
						<td rowspan="2" align="center">
							<%
								if(rowData.get("PACKAGE_STATUS").equals("완료")) {
							%>
								<a class="hyperLink" href="javascript:doPop('setPickingMappging','<%=rowData.get("BUYER")%>','<%=rowData.get("ADD_DATE")%>','<%=rowData.get("SEQ")%>', <%=j-1%>,'<%=rowData.get("BUYER_ITEM_NO")%>');"><%=rowData.get("PACKAGE_STATUS")%></a>

							<%
								}else {
							%>
								<%=rowData.get("PACKAGE_STATUS")%> 
							<%
								}
							%>
						</td>  
					</tr>
					<tr bgcolor="#FFFFFF" align="center">
						<td align="center" ><%=rowData.get("UNIT_MEASURE")%></td>
						<td align="center" ><%=CommonUtil.formatStrinigDate(rowData.get("RD_DATE")) %></td>
						<td align="center">
							<%
								if(rowData.get("REF_NO").equals("")) {
							%>
								<img src="/resources/images/but_icon02.gif"  border="0" name="st_delytolocation_img">
							<%
								}else {
							%>
<%-- 								<a href="javascript:remark_view('<%=j%>');"  onmouseover="show('<%=rowData.get("REF_NO")%>');" onmouseout="hide();" ><img src="/resources/images/but_icon01.gif"  border="0" name="st_delytolocation_img"></a> --%>
								<a class="hyperLink"  href="javascript:doPop('remarkReturnPop','<%=rowData.get("REF_NO")%>');"><img src="/resources/images/but_icon01.gif" border="0" name="st_delytolocation_img"></a>
							<%
								}
							%>
						</td>
					</tr>
				<%
						statusProgressPO="";
						statusProgressDS="";
						statusProgressIV="";
						statusProgressDI="";
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
  					<span class="btn_05 mr04"><a href="javascript:doAction('setDiReg');">납품실적등록</a></span>
  					<span class="btn_05 mr04"><a href="javascript:doAction('setDiCancelReg');">납품실적취소</a></span>
  					<span class="btn_05 mr04"><a href="javascript:doAction('setIvCancelReg');">거래명세서삭제</a></span>
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
<%@ include file="/WEB-INF/views/common/include/sellerFooter.jsp" %>   
</div>
</body>

<script type="text/javascript">
var popupSel = "";
var btnEvent="";
// 최초 화면 함수 
function kep_onload_view(){
// 	alert("${st_gubun}");
	//조회조건 초기화(기존값 재설정)
	initSearchCondition("searchForm", "st_from_date", "${st_from_date}");	//시작일(FROM)
	initSearchCondition("searchForm", "st_to_date_p1", "${st_to_date_p1}");	//시작일(TO)
	initSearchCondition("searchForm", "st_gubun", "${st_gubun}");	//구분
	setBuyerCombo();//요청공장 콤보셋팅
	initSearchCondition("searchForm", "st_buyer_code", "${st_buyer_code}");	//요청공장
	initSearchCondition("searchForm", "st_buyer_item_no", "${st_buyer_item_no}");	//품목코드
	initSearchCondition("searchForm", "st_description", "${st_description}");	//품명
	initSearchCondition("searchForm", "st_po_status", "${st_po_status}");	//진행상태
	
	initSearchCondition("searchForm", "onepagerow", "${onepagerow}");	//페이징단위

// 	kepSetCalender("st_di_date");
	kep_listkepSetCalender('st_di_date', <%=grid_cnt%>);//실적등록일
}

var st;
//기능함수
function doAction(str) {
	switch (str) {
	case "search":	 //조회
		kepSearch(1);
		break;
		
	case "reload":	//초기화
		kepReload("searchForm");
		setBuyerCombo();//요청공장 콤보셋팅
// 		kepSearch(-1);
		jspTableClean("table_list");
		break;

	case "excelDown": // 엑셀다운로드
		document.forms.searchForm.action = "/mpds/excelSellerMpDsOrderProgressManageList.do";
		document.forms.searchForm.submit();
// 		$('#searchForm').attr("action", "/mpds/excelSellerMpDsOrderProgressManageList.do").submit();
		break;

	case "setDiReg": // 납품실적등록
		btnEvent = "setDiReg";

		// 그리드 데이터 셋팅
		if(setGridData(btnEvent)){
			if(!confirm("납품실적을 등록 하시겠습니까?")){ 
				return;
			} 
			kepAjaxFormCall("/mpds/setDiRegSellerMpDsOrderProgressManage.do","processForm",btnEvent); 	
		}
		break;

	case "setDiCancelReg": // 납품실적취소	
		btnEvent = "setDiCancelReg";
		// 그리드 데이터 셋팅
		if(setGridData(btnEvent)){
			if(!confirm("납품실적을 취소 하시겠습니까?")){ 
				return;
			} 
			kepAjaxFormCall("/mpds/setDiCancelRegSellerMpDsOrderProgressManage.do","processForm",btnEvent); 	
		}
		break;

	case "setIvCancelReg": // 송장취소
		btnEvent = "setIvCancelReg";
		// 그리드 데이터 셋팅
		if(setGridData(btnEvent)){
			if(!confirm("송장 취소 하시겠습니까?")){ 
				return;
			} 
			kepAjaxFormCall("/mpds/setIvCancelRegSellerMpDsOrderProgressManage.do","processForm",btnEvent); 	
		}
		break;

	}
}

// 조회
function kepSearch(curPage){
	if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date_p1").val()) == false) return;
	
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mpds/getSellerMpDsOrderProgressManageList.do").submit();   
}
  
// 팝업 함수호출
function doPop(str,value1, value2, value3, value4, value5) {

	popupSel = str;
	
	switch (str) {
	case "sellerMpDsOrderObtnodrReceiptPop"://품목코드(접수)
		openSearchPopup('/mpds/getSellerMpDsOrderObtnodrReceiptPop.do','?st_buyer='+value1+'&st_add_date='+value2+'&st_seq='+value3+'&st_ds_seq='+value4,'620,440,no');
		break;	
	case "sellerMpDsTranStatementCreationPop"://품목코드(납품)
		openSearchPopup('/mpds/getSellerMpDsTranStatementCreationPop.do','?st_buyer='+value1+'&st_add_date='+value2+'&st_seq='+value3+'&st_ds_seq='+value4+'&st_inv_user_id='+$("#st_user_id").val(),'620,440,no');
		break;	
	case "remark": // 비고
		openSearchPopup('/common/remarkPop.do','?viewType=R&st_btoa_remark='+value2+'&st_atob_remark='+value1,'500,310,no');
		break;
	case "remarkReturnPop": // 제조모집단
		openSearchPopup('/common/remarkReturnPop.do','?st_return_remark='+value1,'500,230,no');
		break;
	case "reportViewerPop": // 거래명세서
		var fileName = "RD_06_S_001_85"; // 리포트파일 이름
		var param = "["+value1+"]["+value2+"]["+value3+"]["+value4+"]";// 파라미터
		reportOpen(fileName,param);
		break;
	case "setPickingMappging": // 맵핑완료
		popupSel = (value1 == "KRDONG0732")?"/mpds/showMasterMpDsSeed.do":"/mpds/showMasterMpDscropProtect.do";
		openSearchPopup(popupSel,'?moveToMaster=Y&popflag=Y&st_buyer_item_no='+value5+'&st_off_buyer='+value1+'&st_off_add_date='+value2+'&st_off_seq='+value3,'1224,670,no');
		break;
	}
	
}

// 콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text){
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyerOffPo") {	// 발주
		doAction('search');	

	}else	if (popupSel == "sellerMpDsOrderObtnodrReceiptPop") { 
		doAction('search');	

	}else	if (popupSel == "sellerMpDsTranStatementCreationPop") { 
		doAction('search');	
	}
}

// 선택된 그리드 값을 셋팅
function setGridData(btnEvent){
	var returnValue = true;
	var chkGridValue = {};
	var tot_cnt  = $("#display_item_cnt").val();
	
	if(btnEvent == "setDiReg"){//납품 실적등록
	
        for(var k = 0; k < tot_cnt; k++){
            var box = eval("document.forms.contentForm.checkbox"+k+"");
            if(box !=null && box.checked == true){
				var di_date = $("form[name=contentForm]").find("input[name=st_di_date]").eq(k).val();
				var di_qty = $("form[name=contentForm]").find("input[name=st_di_qty]").eq(k).val();
				var st_status = $("form[name=contentForm]").find("input[name=st_status]").eq(k).val();
				
				if(st_status =="PR" || st_status =="PO" || st_status =="DS") {
					alert("송장이 생성되지 않아 처리할 수 없습니다.");
					return false;
				}
				if(st_status =="DI" || st_status =="GR") {
					alert("이미 처리되었습니다.");
					return false;
				}
				if(di_date=="") {
					alert("납품 실적일을 입력하여 주십시오.");
					return false;
				}

				if(isEmpty(di_qty)) {
					alert("납품 실적수량을 입력하여 주십시오.");
					return false;
				}
            }
        }
	    
	}else if(btnEvent == "setDiCancelReg"){// 납품실적취소

        for(var k = 0; k < tot_cnt; k++){
            var box = eval("document.forms.contentForm.checkbox"+k+"");
            if(box !=null && box.checked == true){
				var st_status = $("form[name=contentForm]").find("input[name=st_status]").eq(k).val();

				if(st_status =="PR" || st_status =="PO" || st_status =="DS" || st_status =="IV") {
					alert("납품실적이 등록되지 않았으므로 처리할 수 없습니다.");
					return false;
				}
            }
        }

	}else if(btnEvent == "setIvCancelReg"){// 송장취소
		
        for(var k = 0; k < tot_cnt; k++){
            var box = eval("document.forms.contentForm.checkbox"+k+"");
            if(box !=null && box.checked == true){
				var st_status = $("form[name=contentForm]").find("input[name=st_status]").eq(k).val();
		
				if(st_status =="PR" || st_status =="PO" || st_status =="DS") {
					alert("송장이 생성되지 않아 처리할 수 없습니다.");
					return false;
				}
				if(st_status =="DI") {
					alert("납품실적을 취소하신 후 거래명세서를 삭제하실수 있습니다.");
					return false;
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

function setBuyerCombo(){
	var flag = $("input[name=st_gubun]:checked").val();
	if(flag == "CROP"){
	$("#st_buyer_code option").remove();
	$("#st_buyer_code").append("<option value=\"ALL\" selected>전체</option>");
	$("#st_buyer_code").append("<option value=\"KRDONG0110\">(주)동부한농 인천공장</option>");
	$("#st_buyer_code").append("<option value=\"KRDONG0107\">(주)동부한농 구미공장</option>");
	$("#st_buyer_code").append("<option value=\"KRDONG0128\">(주)동부아그로텍 전주공장</option>");
	
	}else if(flag == "SEED"){
		$("#st_buyer_code option").remove();
		$("#st_buyer_code").append("<option value=\"KRDONG0732\">동부한농(주)안성공장</option>");
	}
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

</script>
</html>
