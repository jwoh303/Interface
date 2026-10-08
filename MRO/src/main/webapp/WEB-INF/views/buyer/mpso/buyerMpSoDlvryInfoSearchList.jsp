<%--
**********************************************
* 메뉴 : 배송조회
* 화면 : 배송조회
* 기능 : 배송조회
* 프로그램 ID : PG_06_B_070_00
* 담당자 : CEJ ( 설계 : 김지현 )
* 착수일 : 2014-07-14
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
    String fromDate  = "";
    String toDate    = "";
    String sortType = CommonUtil.nvl(request.getParameter("st_sortType"),"DESC");
    if (sortType == null ||  "".equals(sortType)){
    	sortType = "DESC";
    }
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
    String prMngFlag = sessionInfo.getPrMngFlag();
    String row_cnt = sessionInfo.getRowCnt();
    String img_view_flag = sessionInfo.getImgViewFlag(); // 20070704 이미지보기 우선여부
    String pr_no         = CommonUtil.nvl((String) request.getParameter("st_pr_no"),"ALL");
    String ref_no        = CommonUtil.nvl((String) request.getParameter("st_ref_no"),"ALL");
    String search_type   = CommonUtil.nvl((String) request.getParameter("st_search_type"),"");
    // 진행상태
    String status        = CommonUtil.nvl((String) request.getParameter("st_status"),"ALL");
    // HTML 리스트 조회시 공통사용
    String pg_row             = CommonUtil.nvl((String) request.getParameter("st_pg_row"),"");
    String st_check           = CommonUtil.nvl((String) request.getParameter("st_check"),"SEARCH");
    String st_own_search_flag = CommonUtil.nvl((String) request.getParameter("st_own_search_flag"),"N");  // 본인건만 체크
    
    String tot_cnt_string = "";
    int tot_cnt = 0;                                    //전체데이타row수
    int rec_cnt = 0;
 
    // HTML 리스트 조회시 공통사용
    //1개월
    String fromDate1  = "";
    String toDate1    = "";
    toDate1      =   CommonUtil.formatDateNoDateGubun(new Date(),1);
    fromDate1    =    CommonUtil.addDate(new Date(),"M",-1,1);
    System.out.println("fromDate1 "+fromDate1);
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
    String userDept = sessionInfo.getDepartment();
    
    if ("".equals(curPage)){
    	v_fromDate = v_fromDate1;
    	v_toDate = v_toDate1;
    } 
    
	String onepagerow = "10"; // 정렬갯수  
	
	String st_search_no = CommonUtil.nvl((String) request.getParameter("st_search_no"),""); 
	
	boolean p060000043 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000043"); // KRCOLL0001
	
	boolean p170000001 = CommonUtil.getSpecialCheckReturn(buyer,"P17-0000001"); // 엑셀다운로드 기능 통제.

	//검색조건 추가
	String p060000114 =  CommonUtil.nvl(CommonUtil.getSpecialCheckReturn(buyer,"P06-0000114","COL01_DATA"));
	String p060000114_search = "" ;
	if(p060000114.equals("TYPE01")){
		p060000114_search = sessionInfo.getDepartment();//요청부서 검색조건 추가.
	}else{
		p060000114_search= "";
	}
%> 

<body onLoad="kep_onload_view()">
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
	<h3><%=CommonLang.get("HTITLE230") %><!-- 배송조회 --></h3>
	<!--버튼영역-->
     <div id="searchBtnA">
     	<span class="btn_search"><a href="javascript:doAction('search');"><%=CommonLang.get("HTITLE7") %><!-- 조회 --></a></span> 
		<span class="btn_reset"><a href="javascript:doAction('reload');"><%=CommonLang.get("HTITLE8") %><!-- 초기화 --></a></span>
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

		<input type="hidden" name="st_buyer"    value ="<%=buyer%>"> 
		<input type="hidden" name="st_userid"    value ="<%=userid%>">
		<input type="hidden" name="st_userDept"    value ="<%=userDept%>"> 
		<input type="hidden" name="st_check"    value ="<%=st_check%>"> 
		<input type="hidden" name="page_type"   value ="">
		<input type="hidden" name="st_fromDate" value="<%=fromDate%>">
		<input type="hidden" name="st_toDate"   value="<%=toDate%>">
		<input type="hidden" name="SessionComCode"   value="<%=SessionComCode%>">
		<input type="hidden" name="SessionUserId"   value="<%=SessionUserId%>">
		<input type="hidden" name="st_sortType"      value="<%=sortType%>">		
		<input type="hidden" name="st_pr_mng_flag"      value="<%=prMngFlag%>">	
		<input type="hidden" name="st_p060000114"      value="<%=p060000114%>">
		<input type="hidden" name="st_p060000114_search"      value="<%=p060000114_search%>">
		<input type="hidden" name="st_own_search_flag" id="st_own_search_flag" value="<%=st_own_search_flag%>">
		
		<div id="cont_searchA">	
        	<!-- 수정전 --><!-- table class="cont_t_list01" style="width:100%;"-->
            <table class="cont_t_list01"><!-- 마이페이지 닫힐때 width="887"-->
				<caption><%=CommonLang.get("HTITLE7") %><!-- 조회 --></caption>
				<!-- 수정전 --> 
                <!--colgroup>
					<col width="8%" />
					<col width="25%" />
					<col width="9%" />
					<col width="25%" />
					<col width="8%" />
                    <col width="25%" />
				</colgroup-->
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
					<th><%=CommonLang.get("HTITLE185") %><!-- 주문일 --></th>
					<td colspan="3">
						<input type="text" class="input_type_text" name="fromDate" id="fromDate" readOnly style="width:15%;text-align:center;" value="<%=v_fromDate%>"> - 
                        <input type="text" class="input_type_text" name="toDate" id="toDate" readOnly style="width:15%;text-align:center;"  value="<%=v_toDate%>"> 
                        <span class="btn_month"><a href="javascript:kepMonth('fromDate','toDate','1')">1<%=CommonLang.get("HTITLE602") %><!-- 개월 --></a></span> 
						<span class="btn_month"><a href="javascript:kepMonth('fromDate','toDate','6')">6<%=CommonLang.get("HTITLE602") %><!-- 개월 --></a></span>	
						<span class="btn_month"><a href="javascript:kepMonth('fromDate','toDate','12')">12<%=CommonLang.get("HTITLE602") %><!-- 개월 --></a></span>
						<span class="btn_month"><a href="javascript:setCurMonth('fromDate','toDate')">당월</a></span>

<%if(prMngFlag.equals("Y") || prMngFlag.equals("T")) { %>
						&nbsp;
						<input type="checkbox" class="Noborder" name="st_checkbox" id="st_checkbox" <%if("Y".equals(st_own_search_flag)){%>checked<%}%> onclick="setOwnSearchFlag()">&nbsp;<%=CommonLang.get("HTITLE1139")%> <!-- 본인건만 조회 -->
<%}%>
					</td>
				    <th><%=CommonLang.get("HTITLE189") %><!-- 배송상태 --></th>
					<td><select id="st_status" name = "st_status"  style="width:80%"> 
			              <%= CommonUtil.getCodeComboQueryIdList("buyer.mpso.getStatusList","ALL",status) %> 
			            </select>					
					</td>
				</tr> 
				<tr>
					<th><select name = "st_search_type" class="TitSelect">
                        <option <%=(search_type.equals("BC")? "selected" : "")%> value = "BC"><%=CommonLang.get("HTITLE12") %><!-- 품목코드 --></option>
                        <option <%=(search_type.equals("DE")? "selected" : "")%> value = "DE"><%=CommonLang.get("HTITLE13") %><!-- 품목명 --></option>
                        <option <%=(search_type.equals("PR")? "selected" : "")%> value = "PR"><%=CommonLang.get("HTITLE186") %><!-- 주문번호 --></option>
                        <option <%=(search_type.equals("PO")? "selected" : "")%> value = "PO"><%=CommonLang.get("HTITLE203") %><!-- 발주번호 --></option>
                        <option <%=(search_type.equals("MN")? "selected" : "")%> value = "MN"><%=CommonLang.get("HTITLE18") %><!-- 관리번호 --></option>
                        <option <%=(search_type.equals("IF")? "selected" : "")%> value = "IF"><%=CommonLang.get("HTITLE885") %><!-- I/F발주번호 --></option>
                        </select></th>
					<td colspan="2">	<input type="text"  class="st_search_no"   name="st_search_no" style="width:87%" value = "<%=st_search_no%>" onKeyDown="kepEnter()">		
					</td>
					<td></td>
				    <th></th>
					<td></td>
				</tr> 				
				</tbody>
			</table>
		</div>
 		
 
       <span class="fr"><%=CommonLang.get("HTITLE594") %><!-- (기준 : 원) --> </span>
       	<br>
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<!-- 공통 -->
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
	  	
		<table id="table_list" class="cont_t_list02" style="width:100%">
			<colgroup>
			 	  <col width="9%" />
                  <col width="9%" />
                  <col width="*" />
                  <col width="7%" />
                  <col width="8%" />
                  <col width="4%" />
                  <col width="8%" />
                  <col width="9%" />
                  <col width="9%" />
                  <col width="9%" />
	        </colgroup>
	        <thead>

<%
//서울대학교 경영대학원이아닐경우(카드사용고객사)
//SLOGIC-BEGIN(P06-0000043)
if(!(p060000043 == true)) {
%>


        <tr>
          <th scope="col" ><%=CommonLang.get("HTITLE186") %><!-- 주문번호 --><br><%=CommonLang.get("HTITLE18") %><!-- 관리번호 --></th>
          <th scope="col" ><%=CommonLang.get("HTITLE12") %><!-- 품목코드 --><br><%=CommonLang.get("HTITLE185") %><!-- 주문일 --></th>
          <th scope="col"><A class="td_blueLink" href="javascript:setDescriptionSort();"><%=CommonLang.get("HTITLE13") %><!-- 품목명 --></A><br><%=CommonLang.get("HTITLE14") %><!-- 규격 --></th>
          <th scope="col" ><%=CommonLang.get("HTITLE174") %><!-- 단가 --><br><%=CommonLang.get("HTITLE204") %><!-- 금액 --></th>
          <th scope="col" ><%=CommonLang.get("HTITLE205") %><!-- 배송희망일 --><br><%=CommonLang.get("HTITLE232") %><!-- 배송확정일 --></th>
          <th scope="col" ><%=CommonLang.get("HTITLE52") %><!-- 단위 --><br><%=CommonLang.get("HTITLE207") %><!-- 사유 --></th>
          <th scope="col" ><%=CommonLang.get("HTITLE208") %><!-- 발주일 --><br><%=CommonLang.get("HTITLE209") %><!-- 요청/발주수량 --></th>
          <th scope="col" ><%=CommonLang.get("HTITLE144") %><!-- 협력사 --><br><%=CommonLang.get("HTITLE203") %><!-- 발주번호 --><br><%=CommonLang.get("HTITLE885") %><!-- I/F발주번호 --></th>
          <th scope="col" ><%=CommonLang.get("HTITLE189") %><!-- 배송상태 --><br><%=CommonLang.get("HTITLE211") %><!-- 입고수량 --></th>
          <th scope="col" ><%=CommonLang.get("HTITLE924") %><!-- 택배회사 --><br><%=CommonLang.get("HTITLE925") %><!-- 운송장번호 --></th>
        </tr>

<%
}
//SLOGIC-END
else {
%> <!--swf-->
        <tr>
          <th scope="col"  ><%=CommonLang.get("HTITLE186") %><!-- 주문번호 --><br><%=CommonLang.get("HTITLE18") %><!-- 관리번호 --></th>
          <th scope="col" ><%=CommonLang.get("HTITLE12") %><!-- 품목코드 --><br><%=CommonLang.get("HTITLE185") %><!-- 주문일 --></th>
          <th scope="col"><A class="td_blueLink" href="javascript:setDescriptionSort();"><%=CommonLang.get("HTITLE13") %><!-- 품목명 --></A><br><%=CommonLang.get("HTITLE14") %><!-- 규격 --></th>
          <th scope="col" ><%=CommonLang.get("HTITLE174") %><!-- 단가 --><br><%=CommonLang.get("HTITLE204") %><!-- 금액 --></th>
          <th scope="col" ><%=CommonLang.get("HTITLE205") %><!-- 배송희망일 --><br><%=CommonLang.get("HTITLE232") %><!-- 배송확정일 --></th>
          <th scope="col" ><%=CommonLang.get("HTITLE52") %><!-- 단위 --><br><%=CommonLang.get("HTITLE207") %><!-- 사유 --></th>
          <th scope="col" ><%=CommonLang.get("HTITLE208") %><!-- 발주일 --><br><%=CommonLang.get("HTITLE209") %><!-- 요청/발주수량 --></th>
          <th scope="col" ><%=CommonLang.get("HTITLE144") %><!-- 협력사 --><br><%=CommonLang.get("HTITLE203") %><!-- 발주번호 --></th>
          <th scope="col" ><%=CommonLang.get("HTITLE189") %><!-- 배송상태 --><br><%=CommonLang.get("HTITLE211") %><!-- 입고수량 --></th>
          <th scope="col" ><%=CommonLang.get("HTITLE644") %><!-- 카드여부 --><br><%=CommonLang.get("HTITLE645") %><!-- 카드승인번호 --></th>
        </tr>
<%
}
%>
			
		</thead>
		<tbody>
<%
if (_gridList == null || _gridList.size() == 0){
%>
	<tr>
		<td colspan="15" align="center" height = "50"> 
		<span><%=CommonLang.msg("MSG347") %><!-- 조회된 데이타가 없습니다. --></span>
		</td> 
	</tr>
<%
}else{
for (int j=0; j<_gridList.size(); j++) {
Map<String,String> rowData = _gridList.get(j);
String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";

%> 
 
      <tr align="center" bgcolor="<%=tclass%>">
<%
//서울대학교 경영대학원 아닐경우(카드사용고객사)
//SLOGIC-BEGIN(P06-0000043)
if(!(p060000043 == true)) {
%>
        
          <td title="주문번호/관리번호">
            
                    <a class="hyperLink"  href="javascript:getPrDisplay('<%=rowData.get("BUYER")%>','<%=rowData.get("PR_NO")%>','<%=rowData.get("STATUS_TEXT")%>','<%=rowData.get("RECV_FLAG")%>','<%=rowData.get("REF_NO")%>')"><%=rowData.get("PR_NO")%></a><br>
                <%=rowData.get("REF_PR_NO")%>
          </td>
          <td title="품목코드/주문일">
            <a class="hyperLink"  href="javascript:getBuyerCatalogDisplayPop('<%=rowData.get("BYIT_COMORG_CODE")%>','<%=rowData.get("BUYER_ITEM_NO")%>','<%=rowData.get("CONTRACT_NO")%>','<%=rowData.get("CONTRACT_SEQ")%>');"><%=rowData.get("BUYER_ITEM_NO")%></a><br>
			<%=CommonUtil.formatStrinigDate(rowData.get("ADD_DATE"))%>
<% if(SessionComCode.equals("KRHYNI0001")) { %>
<BR>(<%=rowData.get("CHANGE_TIME")%>)
<% } 
//SLOGIC-END
%>
                
          </td>
          <td class="left" title="품목명/규격">
            <%=rowData.get("DESCRIPTION")%><br>
			<%=rowData.get("SPECIFICATION")%>
          </td>
          <td class="right" title="단가/금액">
            
                <%=CommonUtil.formatNumber(rowData.get("UNIT_PRICE"),true,0,3)%><br>
                <%=CommonUtil.formatNumber(rowData.get("ITEM_AMT"),true,0,3)%>
          </td>
          <td title="배송희망일/배송확정일">
            <%=CommonUtil.formatStrinigDate(rowData.get("RD_DATE"))%><br>
			<%=CommonUtil.formatStrinigDate(rowData.get("DLVY_DATE"))%>
          </td>
          <td title="단위/사유">
            <%=rowData.get("UNIT_MEASURE")%><br>
<% if(rowData.get("RETURN_REASON").equals("ALL")) { %>
                <img src='<%=rowData.get("RETURN_REASON_IMG")%>' border="0"> 
<% }else { %>
                <a  href="javascript:setReturnReason('<%=rowData.get("RETURN_REASON")%>');"><img src='<%=rowData.get("RETURN_REASON_IMG")%>' border="0"></a> 
<% } %>
          </td>
          <td title="발주일/요청,발주수량">
            <%=CommonUtil.formatStrinigDate(rowData.get("PO_CREATE_DATE"))%><br>
			<%=CommonUtil.formatNumber(rowData.get("TARGET_QTY"),true,0,3)%>&nbsp;/&nbsp;<%=CommonUtil.formatNumber(rowData.get("ITEM_QTY"),true,0,3)%>
          </td>
          <td title="협력사/발주번호/IF발주번호">
            <a class="hyperLink"  href="javascript:getAgentDisplayPop('<%=rowData.get("AGENT_CODE")%>');"><%=rowData.get("AGENT_TEXT")%></a><br>
			<a class="hyperLink"   href="javascript:getPoDisplayPop('<%=rowData.get("BUYER")%>','<%=rowData.get("PO_NO")%>');"><%=rowData.get("PO_NO")%></a><br>
			<%=rowData.get("LEGACY_PO_NO")%>
          </td>
          <td title="배송상태/입고수량">
            <span class="btn_quickbuy mb02"  title="바로주문"><a href="javascript:kep_dtl('<%=rowData.get("PR_NO")%>','<%=rowData.get("PR_SEQ")%>','<%=rowData.get("REF_NO")%>','<%=rowData.get("PO_NO")%>' )"><%=CommonLang.get("HTITLE231") %><!-- 상세 --></a></span><br>
<!-- 변경부분  20131211 장민기 -->
                <%
      if(rowData.get("STATUS_TEXT").equals("결재중")) {
%>
                    <a class="hyperLink"  href="javascript:getPrDisplay('<%=rowData.get("BUYER")%>','<%=rowData.get("PR_NO")%>','<%=rowData.get("STATUS_TEXT")%>','<%=rowData.get("RECV_FLAG")%>','<%=rowData.get("REF_NO")%>')"><%=rowData.get("STATUS_TEXT")%></a>
<%    }else { %>
                    <%=rowData.get("STATUS_TEXT")%>
<%    }      %>
			<br>
                <%=CommonUtil.formatNumber(rowData.get("GR_QTY"),true,0,3)%>
          </td>
          <td>
            <%=rowData.get("PARCEL_COM_NAME")%><br>
			<a href="<%=rowData.get("REAL_INV_NO_URL")%>" target='_blank' style='color:#003694'><%=rowData.get("PARCEL_INV_NO")%></a>
          </td>
<%
} else {
//서울대 카드용
%>
        <tr>
          <td> 
		  <a class="hyperLink"  href="javascript:getPrDisplay('<%=rowData.get("BUYER")%>','<%=rowData.get("PR_NO")%>','<%=rowData.get("STATUS_TEXT")%>','<%=rowData.get("RECV_FLAG")%>','<%=rowData.get("REF_NO")%>')"><%=rowData.get("PR_NO")%></a><br>
                <%=rowData.get("REF_PR_NO")%>
          </td>
          <td class="left">
            <a class="hyperLink" href="javascript:getBuyerCatalogDisplayPop('<%=rowData.get("BYIT_COMORG_CODE")%>','<%=rowData.get("BUYER_ITEM_NO")%>','<%=rowData.get("CONTRACT_NO")%>','<%=rowData.get("CONTRACT_SEQ")%>');"><%=rowData.get("BUYER_ITEM_NO")%></a><br>
			<%=CommonUtil.formatStrinigDate(rowData.get("ADD_DATE"))%>                
          </td>
          <td>
            <%=rowData.get("DESCRIPTION")%><br>
			<%=rowData.get("SPECIFICATION")%>
          </td>
          <td class="right">
            
                <%=CommonUtil.formatNumber(rowData.get("UNIT_PRICE"),true,0,3)%><br>
                <%=CommonUtil.formatNumber(rowData.get("ITEM_AMT"),true,0,3)%>
          </td>
          <td>
            <%=CommonUtil.formatStrinigDate(rowData.get("RD_DATE"))%><br>
			<%=CommonUtil.formatStrinigDate(rowData.get("DLVY_DATE"))%>
          </td>
          <td>
            <%=rowData.get("UNIT_MEASURE")%><br>
<% if(rowData.get("RETURN_REASON").equals("ALL")) { %>
                <img src='<%=rowData.get("RETURN_REASON_IMG")%>' border="0"> 
<% }else { %>
                <a href="javascript:setReturnReason('<%=rowData.get("RETURN_REASON")%>');"><img src='<%=rowData.get("RETURN_REASON_IMG")%>' border="0"></a> 
<% } %>
          </td>
          <td>
            <%=CommonUtil.formatStrinigDate(rowData.get("PO_CREATE_DATE"))%>
			<%=CommonUtil.formatNumber(rowData.get("TARGET_QTY"),true,0,3)%>&nbsp;/&nbsp;<%=CommonUtil.formatNumber(rowData.get("ITEM_QTY"),true,0,3)%>
          </td>
          <td>
            <a class="hyperLink"  href="javascript:getAgentDisplayPop('<%=rowData.get("AGENT_CODE")%>');"><%=rowData.get("AGENT_TEXT")%></a><br>
			<a class="hyperLink"   href="javascript:getPoDisplayPop('<%=rowData.get("BUYER")%>','<%=rowData.get("PO_NO")%>');"><%=rowData.get("PO_NO")%></a><br>
			<%=rowData.get("LEGACY_PO_NO")%>
          </td>
          <td>
           <span class="btn_quickbuy mb02"  title="상세"><a href="javascript:kep_dtl('<%=rowData.get("PR_NO")%>','<%=rowData.get("PR_SEQ")%>','<%=rowData.get("REF_NO")%>','<%=rowData.get("PO_NO")%>' )"><%=CommonLang.get("HTITLE231") %><!-- 상세 --></a></span><br>
            <%=rowData.get("STATUS_TEXT")%><br>
			<%=CommonUtil.formatNumber(rowData.get("GR_QTY"),true,0,3)%>
          </td>
          <td>
            <%=rowData.get("CARD_USE_FLAG")%><br>
			<a class="hyperLink" href="javascript:cardBillPop('<%=rowData.get("CARD_CONFIRM_NO")%>');"><%=rowData.get("CARD_CONFIRM_NO")%></a>
          </td>
<%
}
%>
      </tr>      
<%
}
}
%>

           		</tbody>
            </table>
<%	if (_gridList != null && _gridList.size() > 0){	%>
			 <input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=_gridList.size() %>" >
<%	}	%>
		<!-- 페이징 -->
		<p id="paging" class="paging">
			<%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow) %> 
			<span class="cl"><%=CommonLang.get("HTITLE598") %><!-- [ 총 --> <%=total_cnt %> <%=CommonLang.get("HTITLE599") %><!-- 건 ] --></span> 
		</p>  
		
		
<%
if (_gridList == null || _gridList.size() == 0){        
}else{
%>
	<!-- 버튼영역 -->
	<div class="btnArea">
		<div class="fr">
			<%
			//엑셀다운로드 기능 통제
			if(p170000001 == false){
			%>
				<span class="btn_04 mr04">
					<a href="javascript:doAction('excelDown');"><%=CommonLang.get("HTITLE150") %><!-- 엑셀다운로드 --></a>
				</span>
			<%
			}
			%>
		</div>
	</div>
<%} %>		 
		
		<div id="dlvryStatusView" style="display:none; " >	
			  <div id="statusText"></div>
			
                <div id="OrderStatus">
                	<ul>
                    	<li id="PR_STTS" class="Status01_off"><p  id="PR_STTS_TEXT"></p></li>
                    	<li class="arrow"></li>
                    	<li id="PX_STTS" class="Status01_off"><p id="PX_STTS_TEXT"></p></li>
                    	<li class="arrow"></li>
                    	<li id="IV_STTS" class="Status03_off"><p id="IV_STTS_TEXT"></p></li>
                    	<li class="arrow"></li>
                    	<li id="GR_STTS" class="Status04_off"><p id="GR_STTS_TEXT"></p></li>
                    </ul>
                </div>
                 
			
			
			 	
			<h4><%=CommonLang.get("HTITLE656") %><!-- 배송상태상세 --></h4>
			<table class="cont_t_list02" style="width:100%">
				<colgroup>
				 	  <col width="15%" />
	                  <col width="15%" /> 
	                  <col width="10%" />
	                  <col width="15%" />
	                  <col width="*" /> 
		        </colgroup>
		        <thead>
		     <tr>
		        <th  scope="col" ><%=CommonLang.get("HTITLE255") %><!-- 상태 --></th>
		        <th  scope="col" ><%=CommonLang.get("HTITLE325") %><!-- 이름 -->/<%=CommonLang.get("HTITLE476") %><!-- 직급 --></th>
		        <th  scope="col" ><%=CommonLang.get("HTITLE657") %><!-- 작업일시 --></th>
		        <th  scope="col" ><%=CommonLang.get("HTITLE658") %><!-- 누계일수(주문일기준) --></th>
		        <th  scope="col" ><%=CommonLang.get("HTITLE122") %><!-- 비고 --></th>
		      </tr>	   
		      </thead>   
	           <tbody id="dlvryStatusDtl">
	           </tbody>
			</table> 
		</div>
		
		
		
		
		

</form>

<form name="processForm" id="processForm" method="post">	
	<input type="hidden" name="PR_NO" id="PR_NO" value="" />
	<input type="hidden" name="REF_NO" id="REF_NO" value="" />
	<input type="hidden" name="PO_NO" id="PO_NO" value="" />
	<input type="hidden" name="PR_SEQ" id="PR_SEQ" value="" />
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

 
function kep_dtl(PR_NO,PR_SEQ,REF_NO,PO_NO) {
	
	document.forms.processForm.PR_NO.value = PR_NO; 
	document.forms.processForm.PR_SEQ.value = PR_SEQ; 
	document.forms.processForm.REF_NO.value = REF_NO; 
	document.forms.processForm.PO_NO.value = PO_NO; 
	 
	kepAjaxFormCall("/mpso/getBuyerMpSoDlvryInfoStatusList.do","processForm","KEP_DTL"); 
}


/**
* ajax 공통 호출후 성공시 처리 함수
*/ 
function kepAjaxSuccess(pMethod , response){ 
  
	var STTS_CD = ""; 
	var TYPE = "";  
	var STTS_NM = ""; 
	var STTS = ""; 
	var PR_STTS = ""; 
	var PX_STTS = ""; 
	var IV_STTS = ""; 
	var GR_STTS = ""; 
	var ROW_CNT = ""; 
	var PARCEL_COM_CODE = ""; 
	var PARCEL_INV_NO = ""; 
	var INV_NO_URL = ""; 
	var REAL_INV_NO_URL = ""; 
	
	var listStr = "";
	var dtlStr = "";
	var invStr = ""; // 택배조회
	
	$("PR_STTS").attr("class","Status01_off");
	$("PX_STTS").attr("class","Status02_off");
	$("IV_STTS").attr("class","Status03_off");
	$("GR_STTS").attr("class","Status04_off");
	if (pMethod == "KEP_DTL"){ 
		if (response.data1.length > 0){
			STTS_CD = $.trim(eval("response.data1[0].STTS_CD")); 
			TYPE = $.trim(eval("response.data1[0].TYPE")); 
			STTS_NM = $.trim(eval("response.data1[0].STTS_NM")); 
			STTS = $.trim(eval("response.data1[0].STTS")); 
			PR_STTS = $.trim(eval("response.data1[0].PR_STTS")); 
			PX_STTS = $.trim(eval("response.data1[0].PX_STTS")); 
			IV_STTS = $.trim(eval("response.data1[0].IV_STTS")); 
			GR_STTS = $.trim(eval("response.data1[0].GR_STTS")); 
			ROW_CNT = $.trim(eval("response.data1[0].ROW_CNT")); 
			PARCEL_COM_CODE = $.trim(eval("response.data1[0].PARCEL_COM_CODE")); 
			PARCEL_INV_NO = $.trim(eval("response.data1[0].PARCEL_INV_NO")); 
			INV_NO_URL = $.trim(eval("response.data1[0].INV_NO_URL")); 
			REAL_INV_NO_URL = $.trim(eval("response.data1[0].REAL_INV_NO_URL")); 
			
			if (IV_STTS != ""){ 
				if (PARCEL_INV_NO != ""){
					invStr = "<a href='"+REAL_INV_NO_URL+"' target='_blank' style='color:#003694'><%=CommonLang.get("HTITLE659")%></a>";	/* 택배조회 */
				}
			} 
<%
//언어타입이 영어일 경우 이미지 변경
if(!h_get_session_user_lang.equals("EN")) {
%>
			if (PR_STTS != ""){ 
				$("#PR_STTS").attr("class","Status01_on");
				$("#PR_STTS_TEXT").html(PR_STTS);
			}else{
				$("#PR_STTS").attr("class","Status01_off");
				$("#PR_STTS_TEXT").html("");
			}
			if (PX_STTS != ""){ 
				$("#PX_STTS").attr("class","Status02_on");
				$("#PX_STTS_TEXT").html(PX_STTS);
			}else{
				$("#PX_STTS").attr("class","Status02_off");
				$("#PX_STTS_TEXT").html("");
			}
			if (IV_STTS != ""){ 
				$("#IV_STTS").attr("class","Status03_on");
				if (invStr == ""){
					$("#IV_STTS_TEXT").html(IV_STTS);
				}else{
					$("#IV_STTS_TEXT").html(invStr); // 택배조회
				}
			}else{
				$("#IV_STTS").attr("class","Status03_off");
				$("#IV_STTS_TEXT").html("");
			}		
			if (GR_STTS != ""){ 
				$("#GR_STTS").attr("class","Status04_on");
				$("#GR_STTS_TEXT").html(GR_STTS);
			}else {
				$("#GR_STTS").attr("class","Status04_off");
				$("#GR_STTS_TEXT").html("");
			}
<%}else{ %>
			if (PR_STTS != ""){ 
				$("#PR_STTS").attr("class","Status01en_on");
				$("#PR_STTS_TEXT").html(PR_STTS);
			}else{
				$("#PR_STTS").attr("class","Status01en_off");
				$("#PR_STTS_TEXT").html("");
			}
			if (PX_STTS != ""){ 
				$("#PX_STTS").attr("class","Status02en_on");
				$("#PX_STTS_TEXT").html(PX_STTS);
			}else{
				$("#PX_STTS").attr("class","Status02en_off");
				$("#PX_STTS_TEXT").html("");
			}
			if (IV_STTS != ""){ 
				$("#IV_STTS").attr("class","Status03en_on");
				if (invStr == ""){
					$("#IV_STTS_TEXT").html(IV_STTS);
				}else{
					$("#IV_STTS_TEXT").html(invStr); // 택배조회
				}
			}else{
				$("#IV_STTS").attr("class","Status03en_off");
				$("#IV_STTS_TEXT").html("");
			}		
			if (GR_STTS != ""){ 
				$("#GR_STTS").attr("class","Status04en_on");
				$("#GR_STTS_TEXT").html(GR_STTS);
			}else {
				$("#GR_STTS").attr("class","Status04en_off");
				$("#GR_STTS_TEXT").html("");
			}
<% } %>
				if (response.data2.length > 0){
				   	  for (var i=0; i<response.data2.length; i++){ 		 		    		  
					   		STTS_NM = $.trim(eval("response.data2["+i+"].STTS_NM"));
					   		ID = $.trim(eval("response.data2["+i+"].ID"));
					   		NAME = $.trim(eval("response.data2["+i+"].NAME"));
					   		JOBDATE = $.trim(eval("response.data2["+i+"].JOBDATE"));
					   		DAYS = $.trim(eval("response.data2["+i+"].DAYS"));
					   		MEMO = $.trim(eval("response.data2["+i+"].MEMO"));
					   		listStr = listStr + "<tr><td>"+STTS_NM+"</td><td class='left'>"+NAME+"</td><td>"+JOBDATE+"</td><td class='right'>"+DAYS+"</td><td class='left'>"+MEMO+"</td></tr>";
				   	  }
				}
		}
	}  	
	 
	$("#dlvryStatus").html(dtlStr);
	$("#dlvryStatusDtl").html(listStr);
	$("#statusText").html("<h4><%=CommonLang.get("HTITLE189")%> ("+document.forms.processForm.PR_NO.value+")</h4>");	/* 배송상태 */
	$("#dlvryStatusView").show(); 
	var documentHeight = $(document).height();
	$('html, body').animate({ scrollTop: documentHeight }, 'slow'); 

}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) { 
	//오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  
	alert("<%=CommonLang.msg("MSG163")%>"); 
} 


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
		if (kep_dateSearchCheck($("#fromDate").val(),$("#toDate").val()) == false) return; 
		document.forms.searchForm.curPage.value = 1; 
	
		kepSearch($("#curPage").val());
		break;
		
	case "reload":	//초기화
		kepReload("searchForm");
		// 조회일 초기 셋팅
		$("#fromDate").val( kepToMonthAdd("1","M"));
		$("#toDate").val( kepGetNowTimeStr('YYYYMMDD','/'));   		
		
		document.getElementById("st_checkbox").checked = false;
		$("#st_own_search_flag").val("N");
		
// 		kepSearch(-1);
		jspTableClean("table_list");
		break;

	case "excelDown": // 엑셀다운로드 
		if (kepGetDateDiff('fromDate','toDate','D') > 366 ){
			alert("조회기간을 12개월 단위로 조회가 가능합니다.");
			return;
		}
		document.forms.searchForm.action = "/mpso/excelBuyerMpSoOrderProgressList.do";
		document.forms.searchForm.submit();
		
		//$('#searchForm').attr("action", "/mpso/excelBuyerMpSoOrderProgressList.do").submit();
		break;
/*
	case "cartCheck": // 저장	
		var btnEvent = "cartCheck";
		// 그리드 데이터 셋팅
		if(setGridData(btnEvent)){
			if(!confirm("이동 하시겠습니까?")){ 
				return;
			} 
			kepAjaxFormCall("/mpso/saveBuyerMpSoOrderProgressList.do","processForm",btnEvent); 	
		}
		break;
	
	case "printPum": // 견적서 출력
		alert("견적서 출력");
		break;
		*/
	}
}

// 조회
function kepSearch(curPage){
	
	if (kep_dateSearchCheck($("#fromDate").val(),$("#toDate").val()) == false) return;  
	if (kepGetDateDiff('fromDate','toDate','D') > 366 ){
		alert("조회기간을 12개월 단위로 조회가 가능합니다.");
		return;
	}
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mpso/getBuyerMpSoDlvryInfoSearchList.do").submit();   
	}
   
function setDescriptionSort()
{
    var sort = document.forms.searchForm.st_sortType.value ;
    if(sort == "DESC" || sort == ""){
        document.forms.searchForm.st_sortType.value = "ASC";
    }else if (sort == "ASC"){
        document.forms.searchForm.st_sortType.value = "DESC";
    }
    kepSearch(1);

} 

function getPrDisplay(BUYER,PR_NO,STATUS_TEXT,RECV_FLAG,REF_NO){ 
	openSearchPopup('/mpiv/showCommonMpIvOdrreqDetailPop.do','?openYn=Y&PR_NO='+PR_NO+'&RECV_FLAG='+RECV_FLAG , "800,600,no"); 
} 


function setReturnReason(RETURN_REASON){ 
	
	  if(RETURN_REASON == "ALL")
	  {
	     return;
	  }else {
	       // var loc = "/kr/customer/proxybuy/pr_recv_reject_reason_view.jsp?st_return_reason="+return_reason;
	       // childWin = window.open(loc, "Navigate","width=520,height=255,resizable=no,scrollbars=no, top=0, left=0");
	     	openSearchPopup('/common/reasonPop.do','?openYn=Y&reason='+RETURN_REASON , "500,180,no"); 
	        return;
	  }	
} 
function getPoDisplayPop(BUYER,PO_NO){  
	openSearchPopup('/mpiv/getCommonMpIvBuyerOrderDetailInfoPop.do','?buyer='+BUYER+'&po_no='+PO_NO  , "820,550,no"); 
} 
function cardBillPop(bill_no){ 
    var loc = 'https://admin8.kcp.co.kr/assist/bill.BillAction.do?cmd=card_bill&c_trade_no='+bill_no;
    var childWin1 = window.open(loc, "Navigate","width=470,height=815,resizable=no,scrollbars=no, top=0, left=0");
} 

function setOwnSearchFlag(){
	if($('#st_checkbox')[0].checked) {
		$("#st_own_search_flag").val("Y");		
	} else {
		$("#st_own_search_flag").val("N");
	}
}
</script>
</html>
