<%--
**********************************************
* 메뉴 : 결재
* 화면 : 결재진행함
* 기능 : 결재진행함(다수 사용자 결재 몰아서 보기)
* 프로그램 ID : 
* 담당자 : HSJ  
* 착수일 : 2024-09-24
**********************************************
--%> 
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="page" uri="/WEB-INF/tld"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!doctype html>
<html>
<head>
<%@include file="../../common/include/head.jspf" %>
</head>
<%
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과
	String _CRUD =  CommonUtil.nvl((String)request.getAttribute("CRUD")); // 조회된결과	
	String total_cnt = CommonUtil.nvl((String)request.getAttribute("total_cnt"),"0"); // 조회된결과
	if (_dataList == null || _dataList.size() == 0) {
		total_cnt = "0";
	}
	
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),  CommonUtil.nvl(_sessionInfo.getRowCnt(),"10"));  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.

	String startDate = CommonUtil.nvl((String) request.getParameter("startDate"),""); // 조회조건
	String endDate = CommonUtil.nvl((String) request.getParameter("endDate"),""); // 조회조건
	
	String st_buyer_list = CommonUtil.nvl((String) request.getParameter("st_buyer_list"),""); // 조회조건
	
	String buyer = "";
	String userid = "";
	String businessCond = "";
	if (_sessionInfo != null){
		buyer =  CommonUtil.nvl((String)_sessionInfo.getComCode()); 	
		userid =  CommonUtil.nvl((String)_sessionInfo.getUserId());
		businessCond = CommonUtil.nvl((String)_sessionInfo.getBusinessCond());
	} 
	
	String st_status1 = CommonUtil.nvl((String) request.getParameter("st_status1"),""); // 조회조건
	String st_status = CommonUtil.nvl((String) request.getParameter("st_status"),""); // 조회조건
	String st_gubun = CommonUtil.nvl((String) request.getParameter("st_gubun"),""); // 조회조건 
	String st_subject = CommonUtil.nvl((String) request.getParameter("st_subject"),""); // 조회조건 
	String moveToBuyer = CommonUtil.nvl((String) request.getParameter("moveToBuyer"),""); // 조회조건
	String SESSION_COWAY_FLAG = (String)request.getSession().getAttribute("SESSION_COWAY_FLAG"); // 코웨이구분
	
	Map<String, String> _map = new HashMap<String, String>();
%>  
<body onload="kepOnload()">
<div id="wrapper"> 
<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
<%if(!"Y".equals(moveToBuyer) ){%>
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   
<%}%>
<%if(!"Y".equals(moveToBuyer) ){%>
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>
<%}%>
<!--내용 시작 고객사, 운영사에 따라 디자인 상이.-->		
<%if("M".equals(businessCond) ){%>
	<div id="container3">
<%}else{%>
    <div id="container2">
<%} %>
<%if(!"Y".equals(moveToBuyer) ){%>
	<div id="ContArea">
<%}else{%>
    <div id="ContArea2">
<%} %>    
 
      	<!--버튼영역-->
<%if(!"Y".equals(moveToBuyer) ){%>
         <h3><%=CommonLang.get("HTITLE308") %><!-- 결재진행함 --></h3>
         <div id="searchBtnA">
<%}else{%>
         <div id="searchBtnA" style="position:relative;  text-align:right; width:950px; height:32px; border: solid 0px; margin-top:5px; ">
         <h3 style="position:absolute; width:500px; font-family:맑은 고딕; font-weight:bold; font-size:18px; color:#333333; text-align:left; letter-spacing:-1px "><%=CommonLang.get("HTITLE308") %><!-- 결재진행함 --></h3>
<%} %>     
<%if("M".equals(businessCond) ){%> 
         	<span class="Mbtn_search" title="조회"><a href="javascript:kepSearch(1);"><%=CommonLang.get("HTITLE7") %><!-- 조회 --></a></span>
         	<span class="Mbtn_reset" title="초기화"><a href="javascript:reload();"><%=CommonLang.get("HTITLE8") %><!-- 초기화 --></a></span>
<%}else{%>
         	<span class="btn_search" title="조회"><a href="javascript:kepSearch(1);"><%=CommonLang.get("HTITLE7") %><!-- 조회 --></a></span>
         	<span class="btn_reset" title="초기화"><a href="javascript:reload();"><%=CommonLang.get("HTITLE8") %><!-- 초기화 --></a></span>
<%}%>
         </div>
            <!--조회영역-->
            <form name = "searchForm"  id="searchForm" method = "post">
            <input type="hidden" id="BUYER"  name="BUYER" value="<%=buyer%>">
            <input type="hidden" id="USERID"  name="USERID" value="<%=userid%>">
             <input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">
             <input type="hidden" id="moveToBuyer"  name="moveToBuyer" value="<%=moveToBuyer%>">            
            <div id="cont_searchA">        	
			<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
				<table class="cont_t_list01" >
					<caption><%=CommonLang.get("HTITLE7") %><!-- 조회 --></caption>
					<colgroup>
	                    <col width="8%" />
	                    <col width="21%" />
	                    <col width="8%" />
	                    <col width="21%" />
	                    <col width="8%" />
	                    <col width="21%" />      
					</colgroup>				
						<tbody>
						<tr>
							<th><%=CommonLang.get("HTITLE298") %><!-- 기안일 --></th>
							<td colspan="5">			
							<input type="text" id="startDate"  class="input_type_text" name="startDate" value="<%=startDate%>"  style="width:10%; text-align:center;" >
							-
							<input type="text" id="endDate" class="input_type_text"  name="endDate" value="<%=endDate%>"  style="width:10%; text-align:center;" >
							<span class="btn_month"><a href="javascript:kepMonth('startDate','endDate','1')">1<%=CommonLang.get("HTITLE602") %><!-- 개월 --></a></span>  
							<span class="btn_month"><a href="javascript:kepMonth('startDate','endDate','3')">3<%=CommonLang.get("HTITLE602") %><!-- 개월 --></a></span>			
							<span class="btn_month"><a href="javascript:kepMonth('startDate','endDate','6')">6<%=CommonLang.get("HTITLE602") %><!-- 개월 --></a></span>
							<span class="btn_month"><a href="javascript:setCurMonth('startDate','endDate')">당월</a></span>					
                            </td>
                        </tr>
                        <tr>
						    <th><%=CommonLang.get("HTITLE306") %><!-- 유형 --></th>
							<td>
							<select name = "st_status1"  style="width: 90%">
						              <option value = "ALL" selected><%=CommonLang.get("HTITLE29") %><!-- 전체 --></option>
						              <option <%=(st_status1.equals("0") ? "selected" : "")%> value = "0"><%=CommonLang.get("HTITLE309") %><!-- 미결재 --></option>
						              <option <%=(st_status1.equals("1") ? "selected" : "")%> value = "1"><%=CommonLang.get("HTITLE310") %><!-- 결재 --></option>
						              <option <%=(st_status1.equals("2") ? "selected" : "")%> value = "2"><%=CommonLang.get("HTITLE311") %><!-- 참조 --></option>
						              <option <%=(st_status1.equals("3") ? "selected" : "")%> value = "3"><%=CommonLang.get("HTITLE238") %><!-- 반려 --></option>
				            </select>
                            </td> 
							<th><%=CommonLang.get("HTITLE255") %><!-- 상태 --></th>
							<td>
				              <select name = "st_status"  style="width: 90%">
						              <option <%=(st_status.equals("ALL") ? "selected" : "")%> value = "ALL"><%=CommonLang.get("HTITLE29") %><!-- 전체 --></option>           <!--  ICOGDOCU.PASS_STATUS = '2' ==> 참조진행  -->
						              <option <%=(st_status.equals("0") ? "selected" : "")%> value = "0"><%=CommonLang.get("HTITLE158") %><!-- 결재진행중 --></option>
						              <option <%=(st_status.equals("1") ? "selected" : "")%> value = "1"><%=CommonLang.get("HTITLE238") %><!-- 반려 --></option>
						              <option <%=(st_status.equals("3") ? "selected" : "")%> value = "3"><%=CommonLang.get("HTITLE312") %><!-- 결재완료 --></option>
						              <option <%=(st_status.equals("4") ? "selected" : "")%> value = "4"><%=CommonLang.get("HTITLE193") %><!-- 상신취소 --></option>
					            </select>
                            </td>
                            <th><%=CommonLang.get("HTITLE604") %><!-- 고객사 --></th>
                            <td>
                            	<select name = "st_buyer_list" style="width: 90%">
                            	<%
                            		_map.put("CODE2",_sessionInfo.getUserId()); // 로그인 ID로 세팅된 고객사 목록(ICOMCOD3.TYPE=M-APPR)
                            	%>
                            	<%=CommonUtil.getCodeComboQueryIdList("common.getMultiApprComNameList","ALL",_map,st_buyer_list)%>
                            	</select>
                            </td>
                        </tr>
                        <tr>
						    <th><%=CommonLang.get("HTITLE313") %><!-- 기안제목 --></th>
							<td>
								<input type="text" name="st_subject"  class="input_type_text" style="width:87%;ime-mode:active" value="<%=(st_subject.equals("ALL") ? "" : st_subject)%>" onKeyDown="kepEnter()">
                            </td> 
                            <th><%=CommonLang.get("HTITLE299") %><!-- 결재구분 --></th>
                            <td>
								<select name = "st_gubun"  style="width: 90%"> 
						                   <% 
	                             _map.put("TEXT5",_sessionInfo.getBusinessCond()); // 고객사인지 운영사인지 구분
	                             %>
						              	<%= CommonUtil.getCodeComboQueryIdList("common.getApprCodeList","ALL",_map,st_gubun) %>
					            </select>
                             </td>
							<% 
							   if ("Y".equals(SESSION_COWAY_FLAG)) { %>
                              <th><%=CommonLang.get("HTITLE302") %><!-- 기안자 --></th>
                              <td>
                              <input type="hidden" name="st_po_user_id"  id="st_po_user_id" value="">
                              <input type="text" name="st_drafter"  id="st_drafter" value="" class="input_type_text" style="width:87%;ime-mode:active" onKeyDown="kepEnter()">
                              </td>
                             <%}else{ %>
                              <th><%=CommonLang.get("HTITLE302") %><!-- 기안자 --></th>
                              <td><input type="hidden" name="st_po_user_id"  id="st_po_user_id" value="">
                              <input type="text" name="st_drafter"  id="st_drafter" value="" class="input_type_text" style="width:87%;ime-mode:active" onKeyDown="kepEnter()">
                              </td>
                             <%} %>
						</tr>
					</tbody>
				</table>
            </div>
   <div>
             	<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
              	<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow"  id="onepagerow" onchange="kepSearch(1);">
                      <option value="10" <%if ("10".equals(onepagerow)) {%>selected<%} %>>10<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
                      <option value="20" <%if ("20".equals(onepagerow)) {%>selected<%} %>>20<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
                      <option value="30" <%if ("30".equals(onepagerow)) {%>selected<%} %>>30<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
                      <option value="40" <%if ("40".equals(onepagerow)) {%>selected<%} %>>40<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
                      <option value="50" <%if ("50".equals(onepagerow)) {%>selected<%} %>>50<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
                  </select></span> 
                  <span class="fr">※<b><%=CommonLang.get("HTITLE606") %><!-- 진행상태 --></b> <%=CommonLang.get("HTITLE318") %><!-- 클릭 시 현재 결재 현황을 보실 수 있습니다. --> </span>
    </div>
</form>    
    <br>
    
<form name = "contentForm" method = "post">
<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />            	
                <table id="table_list" class="cont_t_list02"  style="width:100%">
                    <caption><%=CommonLang.get("HTITLE683") %><!-- 리스트 --></caption>
                    <colgroup>
                        <col width="7%" />
                        <col width="5%" />
                        <col width="*" />
                        <col width="7%" />
                        <col width="14%" />
                        <col width="*" />
                        <col width="7%" /> 
                        <col width="8%" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col"><%=CommonLang.get("HTITLE314") %><!-- 구분 --></th>
                            <th scope="col"><%=CommonLang.get("HTITLE306") %><!-- 유형 --> </th>
                            <th scope="col"><%=CommonLang.get("HTITLE604") %><!-- 고객사 --></th>
                            <th scope="col"><%=CommonLang.get("HTITLE302") %><!-- 기안자 --></th>
                            <th scope="col"><%=CommonLang.get("HTITLE303") %><!-- 기안일시 --></th>
                            <th scope="col"><%=CommonLang.get("HTITLE304") %><!-- 제목 --></th>
                            <th scope="col"><%=CommonLang.get("HTITLE315") %><!-- 다음결재자 --></th>
                            <th scope="col"><%=CommonLang.get("HTITLE255") %><!-- 상태 --></th>  
                        </tr>                
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
                <tr bgcolor="#FFFFFF">
		            <td colspan="10" align="center" height = "50"> 
		            <span><%=CommonLang.msg("MSG347") %><!-- 조회된 데이타가 없습니다. --></span>
		            </td> 
           		</tr>
<%
     }else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
%>                             
                    <tr>
                    	<td title="구분"><%=CommonUtil.nvl( rowData.get("EXTIF_TP_TEXT"))%></td>
                    	<td title="유형"><%=CommonUtil.nvl( rowData.get("GUBUN"))%></td>
                    	<td title="고객사"><%=CommonUtil.nvl( rowData.get("COMPANY_NAME"))%></td>
                    	<td title="기안자"><%=CommonUtil.nvl( rowData.get("ADD_USER_ID"))%></td>
                    	<td title="기안일시"><%=CommonUtil.nvl( rowData.get("START_DATE"))%></td>
                    	<td title="제목" class="left">
                    	<a class="hyperLink"  href="javascript:openSearchPopup('/common/approval/getBuyerCommonMyPagePop.do','?COMPANY=<%= CommonUtil.nvl( rowData.get("COMPANY"))%>&DOCU_NO=<%=CommonUtil.nvl( rowData.get("DOCU_NO")) %>&PASS_TP=<%=CommonUtil.nvl( rowData.get("PASS_TP")) %>&FLAG=COMPLETE' , '1200,700,no')">
                        <%=CommonUtil.nvl( rowData.get("DOCU_TITLE"))%>
                        </a>
                        </td>
                    	<td title="다음결재자"><%=CommonUtil.nvl( rowData.get("NEXT_USER_NM"))%></td>
                    	<td title="상태">
                    	<a class="hyperLink"  href="javascript:openSearchPopup('/common/popup/approval/buyerCommonPassStatusPop.do','?COMPANY=<%= CommonUtil.nvl( rowData.get("COMPANY"))%>&DOCU_NO=<%=CommonUtil.nvl( rowData.get("DOCU_NO")) %>' , '800,400,no')">
                    	<%=CommonUtil.nvl( rowData.get("PASS_STATUS"))%>
                    	</a>
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
 </form>     
<!--페이징-->
<p id="paging" class="paging">
<%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow) %> 
<span class="cl"><%=CommonLang.get("HTITLE598") %><!-- [ 총 --> <%=total_cnt %> <%=CommonLang.get("HTITLE599") %><!-- 건 ] --></span> 
</p> 
</div>
    
    </div>
<!--내용 종료-->	                  
<!--내용 종료-->	                 
<!--내용 종료-->	                 
</div>
<%if(!"Y".equals(moveToBuyer) ){%>
<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>   
<%} %> 
</div>
</div>
</body>
<script type="text/javascript">

var st;
//기능함수
function doAction(str) { 
	
	switch (str) {
	case "search":	 //조회
		kepSearch(1);
		break; 
	}
}

function kepOnload() {
	<% if ("".equals(_CRUD)){%>
	kepNoSetCalender("startDate","Y"); // 초기 시작하자마 해당 ID에 달력세팅
	kepNoSetCalender("endDate","Y"); // 초기 시작하자마 해당 ID에 달력세팅
	$("#startDate").val(kepToMonthAdd('1','M'));
	<%}else{%>	
	kepNoSetCalender("startDate",""); // 초기 시작하자마 해당 ID에 달력세팅
	kepNoSetCalender("endDate",""); // 초기 시작하자마 해당 ID에 달력세팅
	<%}%>
}

/*
 * FORM 을 이용한조회
 */
function kepSearch(curPage){
	
	if (kep_dateSearchCheck($("#startDate").val(),$("#endDate").val()) == false) return; 
	
	if (kepGetDateDiff('startDate','endDate','D') > 184 ){
		alert("조회기간을 6개월 단위로 조회가 가능합니다.");
		return;
	}
	//document.forms.searchForm.st_check.value = ser;
	if (curPage == ""){		
	}else{
	document.forms.searchForm.curPage.value = curPage;
	}
	$('#searchForm').attr("action", "/buyerNewPassCompleteList.do").submit();
}

/**
 * FORM 을 초기화
 */
function reload(){
	kepReload("searchForm");
	
	kepNoSetCalender("startDate","Y"); // 초기 시작하자마 해당 ID에 달력세팅
	kepNoSetCalender("endDate","Y"); // 초기 시작하자마 해당 ID에 달력세팅
	$("#startDate").val(kepToMonthAdd('1','M'));
	
// 	kepSearch(-1);
	jspTableClean("table_list", "10");
}

</script>
