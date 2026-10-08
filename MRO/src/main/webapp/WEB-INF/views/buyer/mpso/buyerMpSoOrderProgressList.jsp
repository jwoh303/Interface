<%--
**********************************************
* 메뉴 : 주문관리>주문진행현황
* 화면 : 주문진행현황
* 기능 : 주문한 내역의 목록및 상태를 파악하고 상세정보를 확인할 수 있다.
* 프로그램 ID : PG_06_B_014_00
* 담당자 : CEJ ( 설계 : 김지현 )
* 착수일 : 2014-07-11
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
    String row_cnt = sessionInfo.getRowCnt();
    String userDept = sessionInfo.getDepartment();
    String img_view_flag = sessionInfo.getImgViewFlag(); // 20070704 이미지보기 우선여부
    String pr_no         = CommonUtil.nvl((String) request.getParameter("st_pr_no"),"ALL"); 
    String legacy_po_no = CommonUtil.nvl((String) request.getParameter("st_legacy_po_no"),"ALL");
    String ref_no        = CommonUtil.nvl((String) request.getParameter("st_ref_no"),"ALL"); 
    String search_type   = CommonUtil.nvl((String) request.getParameter("st_search_type"),"");
    String user_search_type   = CommonUtil.nvl((String) request.getParameter("st_user_search_type"),"");
    String dept_search_type   = CommonUtil.nvl((String) request.getParameter("st_dept_search_type"),"");
    String search_no = CommonUtil.nvl((String) request.getParameter("st_search_no"),"");

    String st_pur_user_id = CommonUtil.nvl((String) request.getParameter("st_pur_user_id"),"");
    String st_pur_user_name = CommonUtil.nvl((String) request.getParameter("st_pur_user_name"),"");
    String st_pur_dept_code = CommonUtil.nvl((String) request.getParameter("st_pur_dept_code"),"");
    String st_pur_dept_name = CommonUtil.nvl((String) request.getParameter("st_pur_dept_name"),"");
    
    String st_own_search_flag = CommonUtil.nvl((String) request.getParameter("st_own_search_flag"),"N");  // 본인건만 체크
    
    if(search_no.equals(""))
    {
       search_type = "BC";
       search_no = "ALL";
    }
    // 진행상태
    String status        = CommonUtil.nvl((String) request.getParameter("st_status"),"ALL");
 //파트유닛
    String unitPart        = CommonUtil.nvl((String) request.getParameter("st_unit_part"),"ALL");
    // HTML 리스트 조회시 공통사용
    String pg_row             = CommonUtil.nvl((String) request.getParameter("st_pg_row"),""); 
    String st_check           = CommonUtil.nvl((String) request.getParameter("st_check"),"SEARCH"); 
 
    String tot_cnt_string = "";
    int tot_cnt = 0;                                    //전체데이타row수
    int rec_cnt = 0;
 
    // HTML 리스트 조회시 공통사용
    //1개월
    String fromDate1  = "";
    String toDate1    = "";
    toDate1      =   CommonUtil.formatDateNoDateGubun(new Date(),1);
    fromDate1    =    CommonUtil.addDate(new Date(),"M",-1,1);
    //System.out.println("fromDate1 "+fromDate1);
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
    String prMngFlag = sessionInfo.getPrMngFlag();
	  if ("".equals(curPage)){ 
		  v_fromDate = v_fromDate1;
		  v_toDate = v_toDate1;

	 } 
    
	String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),row_cnt); // 정렬갯수  
	
	
	boolean p060000043 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000043"); // KRCOLL0001
	
	boolean p060000060 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000060");
	
	boolean getCodeYn = CommonUtil.getCodeCheckReturn("M141",SessionUserId);
	/*
	장바구니 필드추가 제어, 엑셀다운로드 양식 구분에도 사용 
	-TYPE1: 윈체  수량길이 필드 추가
	*/
	String p060000080 =  CommonUtil.getSpecialCheckReturn(buyer,"P06-0000080","COL01_DATA");
	
	boolean p060000091 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000091"); // IF 주문전송 고객사 리스트, 주문취소 불가
	
	boolean p170000001 = CommonUtil.getSpecialCheckReturn(buyer,"P17-0000001"); //엑셀다운로드 기능 통제
	//관리번호 팝업 연결
    Map<String, String> p060000029_map = CommonUtil.getSpecialCheckReturnMap(buyer,"P06-0000029");
	String p060000029 = "";
    if (p060000029_map != null){
    	p060000029= CommonUtil.nvl(p060000029_map.get("COL01_DATA"),""); // 관리번호 팝업 연결
    }
    
    boolean p160000004 = CommonUtil.getSpecialCheckReturn(buyer,"P16-0000004");
    
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
	<h3><%=CommonLang.get("HTITLE524")%></h3><!-- 주문진행현황-->
	<!--버튼영역-->
     <div id="searchBtnA">
     	<span class="btn_search"><a href="javascript:doAction('search');"><%=CommonLang.get("HTITLE7")%></a></span><!-- 조회--> 
		<span class="btn_reset"><a href="javascript:doAction('reload');"><%=CommonLang.get("HTITLE8")%></a></span><!-- 초기화-->
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
		<input type="hidden" name="st_p060000114"      value="<%=p060000114%>">
		<input type="hidden" name="st_p060000114_search"      value="<%=p060000114_search%>">
		<input type="hidden" name="st_pr_mng_flag"      value="<%=prMngFlag%>">
		<input type="hidden" name="st_own_search_flag" id="st_own_search_flag" value="<%=st_own_search_flag%>">
			
		<div id="cont_searchA" >
            <table class="cont_t_list01">
				<caption><%=CommonLang.get("HTITLE7")%><!-- 조회 --></caption>		
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
					<th><%=CommonLang.get("HTITLE185")%></th><!-- 주문일-->
					<td colspan="3">
						<input type="text" class="input_type_text" name="fromDate" id="fromDate" readOnly style="width:15%;text-align:center;" value="<%=v_fromDate%>"> - 
                        <input type="text" class="input_type_text" name="toDate" id="toDate" readOnly style="width:15%;text-align:center;"  value="<%=v_toDate%>"> 
                        <span class="btn_month"><a href="javascript:kepMonth('fromDate','toDate','1')">1<%=CommonLang.get("HTITLE602")%><!-- 개월 --></a></span> 
						<span class="btn_month"><a href="javascript:kepMonth('fromDate','toDate','3')">3<%=CommonLang.get("HTITLE602")%><!-- 개월 --></a></span>	
						<span class="btn_month"><a href="javascript:kepMonth('fromDate','toDate','6')">6<%=CommonLang.get("HTITLE602")%><!-- 개월 --></a></span>
						<span class="btn_month"><a href="javascript:setCurMonth('fromDate','toDate')">당월</a></span>
<%if(prMngFlag.equals("Y") || prMngFlag.equals("T")) { %>
						&nbsp;
						<input type="checkbox" class="Noborder" name="st_checkbox" id="st_checkbox" <%if("Y".equals(st_own_search_flag)){%>checked<%}%> onclick="setOwnSearchFlag()">&nbsp;<%=CommonLang.get("HTITLE1139")%> <!-- 본인건만 조회 -->
<%}%>
					</td>
				    <th><%=CommonLang.get("HTITLE189")%></th><!-- 주문상태-->
					<td><select name="st_status"  id="st_status"  style="width:90%"> 
			              <%= CommonUtil.getCodeComboQueryIdList("buyer.mpso.getStatusList","ALL",status) %> 
			            </select>					
					</td>
				</tr>
                <tr>
				<th><%=CommonLang.get("HTITLE186")%><!-- 주문번호 --></th>
					<td><input type="hidden" name="st_legacy_po_no"   value ="">
					<input type="text"  class="input_type_text"  name="st_pr_no" style="width:87%" value="<%=(pr_no.equals("ALL") ? "" : pr_no)%>" onKeyDown="kepEnter()" /></td>
					
					<th><%=CommonLang.get("HTITLE18")%><!-- 관리번호 --></th>

					
                    <td><input type="text"  class="input_type_text"  name="st_ref_no" style="width:87%" value = "<%=(ref_no.equals("ALL") ? "" : ref_no)%>" onKeyDown="kepEnter()" /></td>
                    <th><select name = "st_search_type" class="TitSelect">
                        <option <%=(search_type.equals("BC")? "selected" : "")%> value = "BC"><%=CommonLang.get("HTITLE12")%><!-- 품목코드 --></option>
                        <option <%=(search_type.equals("DE")? "selected" : "")%> value = "DE"><%=CommonLang.get("HTITLE13")%><!-- 품목명 --></option>
                        <option <%=(search_type.equals("SP")? "selected" : "")%> value = "SP"><%=CommonLang.get("HTITLE14")%><!-- 규격 --></option>
                        </select>
                    </th>
					<td><input type="text"  class="input_type_text"   name="st_search_no" style="width:87%" value = "<%=(search_no.equals("ALL") ? "" : search_no)%>" onKeyDown="kepEnter()" /></td>
				</tr>
				<tr>
				<%if(prMngFlag.equals("Y") || prMngFlag.equals("T")) { %>
					<th><select name = "st_user_search_type" class="TitSelect">
                        <option <%=(user_search_type.equals("REQ")? "selected" : "")%> value = "REQ"><%=CommonLang.get("HTITLE133")%><!-- 요청자 --></option>
                        <option <%=(user_search_type.equals("PUR")? "selected" : "")%> value = "PUR"><%=CommonLang.get("HTITLE187")%><!-- 발주자 --></option>                        
                        </select>
                    </th>
				<% } else { %>
					<th><%=CommonLang.get("HTITLE187")%><!-- 발주자 --></th>					
				<% }  %>
					
					<td>
						<input type="text" class="input_type_text" name="st_pur_user_name" id="st_pur_user_name" style="width:63%;ime-mode:active" value="<%=st_pur_user_name %>" READONLY>
						<input type="hidden" name="st_pur_user_id" id="st_pur_user_id" value="<%=st_pur_user_id%>">
						<a href="javascript:getUserSelect();"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
						<a href="javascript:kepEraser('st_pur_user_id','st_pur_user_name');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
					</td>
				<%if(prMngFlag.equals("Y") || prMngFlag.equals("T")) { %>
					<th><select name = "st_dept_search_type" class="TitSelect">
                        <option <%=(dept_search_type.equals("REQ")? "selected" : "")%> value = "REQ"><%=CommonLang.get("HTITLE135")%><!-- 요청부서 --></option>
                        <option <%=(dept_search_type.equals("PUR")? "selected" : "")%> value = "PUR"><%=CommonLang.get("HTITLE188")%><!-- 발주부서 --></option>                        
                        </select>
                    </th>	
				<% } else { %>
				<th><%=CommonLang.get("HTITLE188")%><!-- 발주부서 --></th>
				<% }  %>				
					<td>
						<input type="text" class="input_type_text" name="st_pur_dept_name" id="st_pur_dept_name" style="width:63%;ime-mode:active" value="<%=st_pur_dept_name %>" READONLY>
						<input type="hidden" name="st_pur_dept_code" id="st_pur_dept_code" value="<%=st_pur_dept_code%>">
						<a href="javascript:getDepartmentCode();"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
						<a href="javascript:kepEraser('st_pur_dept_code','st_pur_dept_name');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
					</td>
					<th>&nbsp;</th>
					<td>&nbsp;</td>
				<input type="hidden" name="st_unit_part"   value ="ST_USER_ID">			
				</tr>	
    
				</tbody>
			</table>
		</div>
 		
 		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
	      	<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow" onChange="javascript:kepSearch(1);">   
				<option value = "10" <%if ("10".equals(onepagerow)) {%>selected<%} %>>10<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
				<option value = "20" <%if ("20".equals(onepagerow)) {%>selected<%} %>>20<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
				<option value = "30" <%if ("30".equals(onepagerow)) {%>selected<%} %>>30<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
				<option value = "40" <%if ("40".equals(onepagerow)) {%>selected<%} %>>40<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
				<option value = "50" <%if ("50".equals(onepagerow)) {%>selected<%} %>>50<%=CommonLang.get("HTITLE595")%><!-- 건 --></option> 
			</select>
      	</span>      
       <span class="fr"><%=CommonLang.get("HTITLE594")%><!-- (기준 : 원) --> </span>
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
                  <col width="6%" />
                  <col width="8%" />
                  <col width="6%" />
<%    
if(p060000080.equals("TYPE1")) {
%>
				 <col width="8%" />
<%
}
%> 
                  <col width="8%" />
                  <col width="9%" />
                  <col width="9%" />
                  <%if ("Y".equals(budget_flag)) { %>
                  <col width="4%" />
                  <%} %>
<%
	//주문취소 비활성화SLOGIC
	if((p060000060 == false)) {
%>
                  <col width="8%" />
<%}%>
	        </colgroup>
	        <thead>

<%
//서울대학교 경영대학원이아닐경우(카드사용고객사)
//SLOGIC-BEGIN(P06-0000043)
if(!(p060000043 == true)) {
%>
        <tr>
          <th scope="col" ><%=CommonLang.get("HTITLE186")%><!-- 주문번호 --><br><%=CommonLang.get("HTITLE203")%><!-- 발주번호 --></th>
          <th scope="col" ><%=CommonLang.get("HTITLE12")%><!-- 품목코드 --><br><%=CommonLang.get("HTITLE185")%><!-- 주문일 --></th>
          <th scope="col"><A class="td_blueLink" href="javascript:setDescriptionSort();"><%=CommonLang.get("HTITLE13")%><!-- 품목명 --></A><br><%=CommonLang.get("HTITLE14")%><!-- 규격 -->/<%=CommonLang.get("HTITLE15")%><!-- 제조사 --></th>
          <th scope="col" ><%=CommonLang.get("HTITLE174")%><!-- 단가 --><br><%=CommonLang.get("HTITLE204")%><!-- 금액 --></th>
          <th scope="col" ><%=CommonLang.get("HTITLE205")%><!-- 배송희망일 --><br><%=CommonLang.get("HTITLE206")%><!-- 납품예정일 --></th>
          <th scope="col" ><%=CommonLang.get("HTITLE133")%><!-- 요청자 --></th>
<%    
if(p060000080.equals("TYPE1")) {
%>
		  <th scope="col" ><%=CommonLang.get("HTITLE639")%><!-- 길이 --><br><%=CommonLang.get("HTITLE45")%><!-- 수량 --></th>
<%
}
%> 
          <th scope="col" ><%=CommonLang.get("HTITLE208")%><!-- 발주일 --><br><%=CommonLang.get("HTITLE209")%><!-- 요청/발주수량 --></th>
          <th scope="col" ><%=CommonLang.get("HTITLE144")%><!-- 협력사 --><br><%=CommonLang.get("HTITLE18")%><!-- 관리번호 --></th>
          <th scope="col" ><%=CommonLang.get("HTITLE189")%><!-- 배송상태 --><br><%=CommonLang.get("HTITLE211")%><!-- 입고수량 --></th>
          <th scope="col" ><%=CommonLang.get("HTITLE52")%><!-- 단위 --><br><%=CommonLang.get("HTITLE957")%><!-- 반려사유 --></th>
           <%if ("Y".equals(budget_flag)) { %>
          <th scope="col" ><%=CommonLang.get("HTITLE267")%><!-- 계정명 --><br><%=CommonLang.get("HTITLE268")%><!-- 예산부서 --></th>	 
          <%} %>
<%
	//주문취소 비활성화SLOGIC
	if((p060000060 == false)) {
%>
          <th scope="col" ><%=CommonLang.get("HTITLE212")%><!-- 주문취소/반품/교환 --><br/><%=CommonLang.get("HTITLE500")%><!-- 요청 --></th>	 
<%}%>
        </tr>

<%
//SLOGIC-END
}else {

%>
        <tr>
          <th scope="col"  ><%=CommonLang.get("HTITLE186")%><!-- 주문번호 --><br><%=CommonLang.get("HTITLE203")%><!-- 발주번호 --></th>
          <th scope="col" ><%=CommonLang.get("HTITLE12")%><!-- 품목코드 --><br><%=CommonLang.get("HTITLE203")%><!-- 주문일 --></th>
          <th scope="col"><A class="td_blueLink" href="javascript:setDescriptionSort();"><%=CommonLang.get("HTITLE13")%><!-- 품목명 --></A><br><%=CommonLang.get("HTITLE14")%><!-- 규격 --></th>
          <th scope="col" ><%=CommonLang.get("HTITLE174")%><!-- 단가 --><br><%=CommonLang.get("HTITLE204")%><!-- 금액 --></th>
          <th scope="col" ><%=CommonLang.get("HTITLE205")%><!-- 배송희망일 --><br><%=CommonLang.get("HTITLE206")%><!-- 납품예정일 --></th>
          <th scope="col" ><%=CommonLang.get("HTITLE208")%><!-- 발주일 --><br><%=CommonLang.get("HTITLE209")%><!-- 요청/발주수량 --></th>
          <th scope="col" ><%=CommonLang.get("HTITLE144")%><!-- 협력사 --><br><%=CommonLang.get("HTITLE18")%><!-- 관리번호 --></th>
          <th scope="col" ><%=CommonLang.get("HTITLE189")%><!-- 배송상태 --><br><%=CommonLang.get("HTITLE211")%><!-- 입고수량 --></th>
          <th scope="col" ><%=CommonLang.get("HTITLE52")%><!-- 단위 --><br><%=CommonLang.get("HTITLE957")%><!-- 반려사유 --></th>
          <th scope="col" ><%=CommonLang.get("HTITLE644")%><!-- 카드여부 --><br><%=CommonLang.get("HTITLE645")%><!-- 카드승인번호 --></th>
           <%if ("Y".equals(budget_flag)) { %>
          <th scope="col" ><%=CommonLang.get("HTITLE267")%><!-- 계정명 --><br><%=CommonLang.get("HTITLE268")%><!-- 예산부서 --></th>	
          <%} %> 
           <th scope="col" ><%=CommonLang.get("HTITLE212")%> <%=CommonLang.get("HTITLE500")%><!-- 주문취소/반품/교환 요청 --></th>	 
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
		<span><%=CommonLang.msg("MSG69")%><!-- 조회된 데이타가 없습니다. --></span>
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

          <td title="주문번호/발주번호">
                    <a class="hyperLink"  href="javascript:getPrDisplay('<%=rowData.get("BUYER")%>','<%=rowData.get("PR_NO")%>','<%=rowData.get("STATUS_TEXT")%>','<%=rowData.get("RECV_FLAG")%>','<%=rowData.get("REF_NO")%>')"><%=rowData.get("PR_NO")%></a><br>
					<a class="hyperLink"   href="javascript:getPoDisplayPop('<%=rowData.get("BUYER")%>','<%=rowData.get("PO_NO")%>');"><%=rowData.get("PO_NO")%></a>
          </td>
          <td title="품목코드/주문일">
            <a class="hyperLink"  href="javascript:getBuyerCatalogDisplayPop('<%=rowData.get("BYIT_COMORG_CODE")%>','<%=rowData.get("BUYER_ITEM_NO")%>','<%=rowData.get("CONTRACT_NO")%>','<%=rowData.get("CONTRACT_SEQ")%>');"><%=rowData.get("BUYER_ITEM_NO")%></a>
            <%if(rowData.get("ITEM_NO_MNG_FLAG").equals("BNCD")){ %> <!-- 에스와이에스리테일(KRSYSR0001) 지점 명함 품목코드이면 -->
            	<span class="btn_wishproduct mb02"  title="명함시안"><a href="javascript:nameCardView('<%=rowData.get("REMARK")%>', '<%=rowData.get("NAMECARD_RPT")%>');"><%=CommonLang.get("HTITLE735") %><!-- 명함시안 --></a></span>
            <%}%>
            <br>
			<%=CommonUtil.formatStrinigDate(rowData.get("ADD_DATE"))%>
<% if(SessionComCode.equals("KRHYNI0001")) { %>
<BR>(<%=rowData.get("CHANGE_TIME")%>)
<% } 
//SLOGIC-END
%>
                
          </td>
          <td class="left" title="품목명/규격/제조사">
            <%=rowData.get("DESCRIPTION")%><br>
			<%=rowData.get("SPECIFICATION")%> / <%=rowData.get("MAKER_NAME")%>
          </td>
          <td class="right" title="단가/금액">
            
                <%=CommonUtil.formatNumber(rowData.get("UNIT_PRICE"),true,0,3)%><br>
                <%=CommonUtil.formatNumber(rowData.get("ITEM_AMT"),true,0,3)%>
          </td>
          <td title="배송희망일/납품예정일">
            <%=CommonUtil.formatStrinigDate(rowData.get("RD_DATE"))%><br>
			<%=CommonUtil.formatStrinigDate(rowData.get("CD_DATE"))%>
          </td>
		<td title="요청자">
<%if(!rowData.get("GW_NO").equals("")){%>
			<a class="hyperLink" href="javascript:openSearchPopup('/common/approval/getBuyerCommonMyPagePop.do','?COMPANY='+'<%=rowData.get("BUYER")%>'+'&DOCU_NO='+'<%=rowData.get("GW_NO")%>'+'&PASS_TP=1&FLAG=COMPLETE' , '1200,700,no');"><%=rowData.get("REQ_USER_NAME")%></a>
<%}else{%>
			<%=rowData.get("REQ_USER_NAME")%>
<%}%>
		</td>
<%    
if(p060000080.equals("TYPE1")) {
%>
          <td class="right"  title="길이/수량">
			<%=CommonUtil.formatNumber(rowData.get("SIZE_LEN"),true,0,3)%><br>
			<%=CommonUtil.formatNumber(rowData.get("SIZE_QTY"),true,0,3)%>
          </td>
<%} %>
          <td title="발주일/요청,발주수량">
            <%=CommonUtil.formatStrinigDate(rowData.get("PO_CREATE_DATE"))%><br>
			<%=CommonUtil.formatNumber(rowData.get("TARGET_QTY"),true,0,3)%>&nbsp;/&nbsp;<%=CommonUtil.formatNumber(rowData.get("ITEM_QTY"),true,0,3)%>
          </td>
          <td title="협력사/관리번호">
            <a class="hyperLink"  href="javascript:getAgentDisplayPop('<%=rowData.get("AGENT_CODE")%>');"><%=rowData.get("AGENT_TEXT")%></a><br>
<%
if(p060000029.equals("TYPE22")) {//동화기업 팝업 연결
%>
	<% if(rowData.get("REF_PR_NO").equals("")) { %>
                <img src="/resources/images/icon2.gif" border="0"> 
	<% }else { %>
				<input type="hidden" name="st_type22_ref_no"   value="<%=rowData.get("REF_PR_NO")%>">
                <a  href="javascript:getRefNoPopUp('TYPE22','<%=rowData.get("BUYER")%>','<%=j%>');"><img src="/resources/images/icon.gif" border="0"></a>
	<% } %>
<%
}else{
%>
            <%=rowData.get("REF_PR_NO")%>
<%
}
%>
          </td>
          <td title="배송상태/입고수량">
            
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
          <td title="단위/사유">
            <%=rowData.get("UNIT_MEASURE")%><br>
<% if(rowData.get("RETURN_REASON").equals("ALL")) { %>
                <img src='<%=rowData.get("RETURN_REASON_IMG")%>' border="0"> 
<% }else { %>
<%		if (true == p160000004) { // IF 메세지 출력시 사용한다. %>
                <a  href="javascript:setIFMessage('<%=rowData.get("BUYER") + rowData.get("PR_NO")%>');"><img src='<%=rowData.get("RETURN_REASON_IMG")%>' border="0"></a>
<%		} else { %>
                <a  href="javascript:setReturnReason('<%=rowData.get("RETURN_REASON")%>');"><img src='<%=rowData.get("RETURN_REASON_IMG")%>' border="0"></a>
<%		} %>
<% } %>
          </td>
          <%if ("Y".equals(budget_flag)) { %>
			<td title="계정명/예산부서">
			 <%=rowData.get("ACCOUNT_TYPE_NAME")%><br><%=rowData.get("BUDGET_DEPT_NAME")%>
			</td>                    
			<%} %>
<%
	//주문취소 비활성화SLOGIC
	if((p060000060 == false)) {
%>
			<td title="주문취소/반품/교환 요청">
			<% if(!"".equals(rowData.get("PO_NO"))  && rowData.get("PO_NO") != null  && "Y".equals(rowData.get("RE_PO"))  ) {%>
			  <span class="btn_quickbuy mb02"  title="상세"><a href="javascript:moveReturn('<%=rowData.get("STATUS_BACK_CODE")%>' , '<%=rowData.get("PO_NO")%>' , '<%=rowData.get("PO_SEQ")%>' ,'<%=rowData.get("BUYER")%>'  ,'<%=rowData.get("PROCESS_TYPE")%>'  );"><%="1".equals(rowData.get("STATUS_BACK_CODE"))?"주문취소":"반품/교환"%></a></span>
			<%}else if("PR50".equals(rowData.get("STATUS_CODE")) && (p060000091 == false)){%>
				<span class="btn_quickbuy mb02"  title="상세"><a href="javascript:buyerPrCancel('<%=rowData.get("BUYER")%>' , '<%=rowData.get("PR_NO")%>' , '<%=rowData.get("PR_SEQ")%>');">주문취소</a></span>
			<%}else{ %>
				<%=rowData.get("RE_WMRE_TYP")%>
			<%} %>
			</td>   
<%} %> 
<%
} else {
//서울대 카드용
%>
        <tr>
          <td> 
		  <a class="hyperLink"  href="javascript:getPrDisplay('<%=rowData.get("BUYER")%>','<%=rowData.get("PR_NO")%>','<%=rowData.get("STATUS_TEXT")%>','<%=rowData.get("RECV_FLAG")%>','<%=rowData.get("REF_NO")%>')"><%=rowData.get("PR_NO")%></a><br>
			<a class="hyperLink"   href="javascript:getPoDisplayPop('<%=rowData.get("BUYER")%>','<%=rowData.get("PO_NO")%>');"><%=rowData.get("PO_NO")%></a>
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
			<%=CommonUtil.formatStrinigDate(rowData.get("CD_DATE"))%>
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
            <%=CommonUtil.formatStrinigDate(rowData.get("PO_CREATE_DATE"))%><br>
			<%=CommonUtil.formatNumber(rowData.get("TARGET_QTY"),true,0,3)%>&nbsp;/&nbsp;<%=CommonUtil.formatNumber(rowData.get("ITEM_QTY"),true,0,3)%>
          </td>
          <td>
            <a class="hyperLink"  href="javascript:getAgentDisplayPop('<%=rowData.get("AGENT_CODE")%>');"><%=rowData.get("AGENT_TEXT")%></a><br>
            <%=rowData.get("REF_PR_NO")%>
          </td>
          <td>
            <%=rowData.get("STATUS_TEXT")%><br>
			<%=CommonUtil.formatNumber(rowData.get("GR_QTY"),true,0,3)%>
          </td>
          <td>
            <%=rowData.get("CARD_USE_FLAG")%><br>
			<a class="hyperLink" href="javascript:cardBillPop('<%=rowData.get("CARD_CONFIRM_NO")%>');"><%=rowData.get("CARD_CONFIRM_NO")%></a>
          </td>
            <%if ("Y".equals(budget_flag)) { %>
			<td>
			 <%=rowData.get("ACCOUNT_TYPE_NAME")%><br><%=rowData.get("BUDGET_DEPT_NAME")%>
			</td>          
			<%} %>
			<td title="주문취소/반품/교환 요청">
			<% if(!"".equals(rowData.get("PO_NO"))  && rowData.get("PO_NO") != null && "Y".equals(rowData.get("RE_PO")) ) {%>
				<span class="btn_quickbuy mb02"  title="상세"><a href="javascript:moveReturn('<%=rowData.get("STATUS_BACK_CODE")%>' , '<%=rowData.get("PO_NO")%>' , '<%=rowData.get("PO_SEQ")%>' ,'<%=rowData.get("BUYER")%>'  ,'<%=rowData.get("PROCESS_TYPE")%>'  );"><%="1".equals(rowData.get("STATUS_BACK_CODE"))?"주문취소":"반품/교환"%></a></span>
			<%}else if("PR50".equals(rowData.get("STATUS_CODE")) && (p060000091 == false)){%>
				<span class="btn_quickbuy mb02"  title="상세"><a href="javascript:buyerPrCancel('<%=rowData.get("BUYER")%>' , '<%=rowData.get("PR_NO")%>' , '<%=rowData.get("PR_SEQ")%>');">주문취소</a></span>
			<%}else{ %>
				<%=rowData.get("RE_WMRE_TYP")%>
			<%} %>
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
			<span class="cl"><%=CommonLang.get("HTITLE598")%><!-- [ 총 --> <%=total_cnt %><%=CommonLang.get("HTITLE599")%><!--  건 ] --></span> 
		</p>  

	<!-- 버튼영역 -->
	<div class="btnArea">
		<div class="fr">
			<%
			//엑셀다운로드 기능 통제
			if(p170000001 == false){
			%>
				<span class="btn_04 mr04">
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
	<input type="hidden" name="st_buyer" id="st_buyer" value="">
	<input type="hidden" name="st_pr_no" id="st_pr_no" value="">
	<input type="hidden" name="st_pr_seq" id="st_pr_seq" value="">
</form>

<form name="locationForm" id="locationForm" method="post">
	<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">
	<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
	<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
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
		

		document.forms.searchForm.st_pr_no.value = "";
		document.forms.searchForm.st_ref_no.value = "";
		document.forms.searchForm.st_search_type.value = "BC";
		document.forms.searchForm.st_search_no.value = "";

		document.forms.searchForm.st_pur_dept_code.value = "";
		document.forms.searchForm.st_pur_dept_name.value = "";
		document.forms.searchForm.st_pur_user_id.value = "";
		document.forms.searchForm.st_pur_user_name.value = "";
		
		document.getElementById("st_checkbox").checked = false;
		$("#st_own_search_flag").val("N");
		
		jspTableClean("table_list");
		break;

	case "excelDown": // 엑셀다운로드
		if (kep_dateSearchCheck($("#fromDate").val(),$("#toDate").val()) == false) return;  
		if (kepGetDateDiff('fromDate','toDate','D') > 186 ){
			//조회기간을 6개월 단위로 조회가 가능합니다.
			alert("<%=CommonLang.msg("MSG494")%>");
			return;
		}

		document.forms.searchForm.action = "/mpso/excelBuyerMpSoOrderProgressList.do";

		document.forms.searchForm.submit();
		
		break;

	}
}

// 조회
function kepSearch(curPage){
	
	if (kep_dateSearchCheck($("#fromDate").val(),$("#toDate").val()) == false) return;  
	if (kepGetDateDiff('fromDate','toDate','D') > 186 ){
		//조회기간을 6개월 단위로 조회가 가능합니다.
		alert("<%=CommonLang.msg("MSG494")%>");
		return;
	}
	document.forms.searchForm.curPage.value = curPage;

	$('#searchForm').attr("action", "/mpso/getBuyerMpSoOrderProgressList.do").submit();   
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


function moveReturn(gubun, PO_NO, PO_SEQ,BUYER,PROCESS_TYPE){
	
	if(''== BUYER ){
		//고객사 코드가 조회 되지 않습니다.
		alert('<%=CommonLang.msg("MSG181")%>');
		return;
	}
	else if( '' == PO_NO ){
		//발주번호 정보가 없습니다. 
		alert('<%=CommonLang.msg("MSG182")%>');
		return;
		
	}else if(''==PO_SEQ){
		//발주번호순번 정보가 없습니다. 
		alert('<%=CommonLang.msg("MSG183")%>');
		return;
		
	}
	//주문취소/반품/교환'의 경우 품목에 따라 처리불가한 경우도 있기에 필히 KeP 담당자와 협의 후 진행하셔야 하는 부분입니다. 계속 진행 하시겠습니까?
	if (confirm("<%=CommonLang.msg("MSG369")%>")==false) return;
	if('1' ==gubun  ){
		
		openSearchPopup('/wmre/showMasterWmReReturnEntryForBuyerCancelPop.do','?st_po_no='+PO_NO+'&st_po_seq='+PO_SEQ+'&st_buyer_code='+BUYER , '900,380,no'); 
	
	}

	else if('2' ==gubun ){

		openSearchPopup('/wmre/showMasterWmReReturnEntryForBuyerPop.do','?st_po_no='+PO_NO+'&st_po_seq='+PO_SEQ+'&st_buyer_code='+BUYER , '900,380,no'); 
	 }
}

function buyerPrCancel(BUYER, PR_NO, PR_SEQ){
	document.forms.processForm.st_buyer.value = BUYER;
	document.forms.processForm.st_pr_no.value = PR_NO;
	document.forms.processForm.st_pr_seq.value = PR_SEQ;
	
	//주문취소 하시겠습니까?
	if (confirm("<%=CommonLang.msg("MSG538")%>")==false){
		return;
	}

	kepAjaxFormCall("/mpso/saveBuyerPrCancel.do","processForm","SAVE");
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
	
	var sMsg = response.msg.MSG;   
	 
    if (sMsg == "UPDATE_OK"){
		if(pMethod == "SAVE"){
			// 정상적으로 처리 되었습니다.
			alert("<%=CommonLang.msg("MSG507")%>");
			// 처리후 재조회
			kepSearch($("#curPage").val()); 
		}
	} else {
		// 처리후 재조회
		kepSearch($("#curPage").val());
	}  
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	//오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  
	alert("<%=CommonLang.msg("MSG163")%>"); 
} 

function getDepartmentCode(){ 
	openSearchPopup('/common/deptCodeAdminPop.do', "?open=Y&com_code=<%=SessionComCode%>", "500,500,no"); 
} 

function setPopupReturn(code, text1, text2, gubun) {
	if (gubun == "dept") {
		document.forms.searchForm.st_pur_dept_code.value = code;
		document.forms.searchForm.st_pur_dept_name.value = text1;	
	} else {
		document.forms.searchForm.st_pur_user_id.value   = code;
		document.forms.searchForm.st_pur_user_name.value = text1;
	}
}

function getUserSelect(){
	openSearchPopup('/common/misUserSelectDeptPop.do', '?open=Y&com_code=<%=SessionComCode%>&dept_code=', "650,500,no");
}

//에스와이에스리테일(KRSYSR0001) 명함 시안
function nameCardView(obj1, rpt){
	var remark_full_arr = obj1.split("^^");
	
	var kor_name =  "";
	var eng_name =  "";
	var branch_name = "";
	var position = "";
	var kor_addr = "";
	var eng_addr = "";
	var phone_no = "";
	var fax_no = "";
	var mobile_no = "";
	var email = "";
	var homepage = "";
	var bank = "";
	var account = "";	
	
	if(remark_full_arr.length == 13){
		for(var i=0; i<remark_full_arr.length; i++){
			var remark_arr = remark_full_arr[i].split(";;");
			
			if(remark_arr.length == 2){
				if(i == 0){
					kor_name = remark_arr[1];
				}else if(i == 1){
					eng_name = remark_arr[1];
				}else if(i == 2){
					branch_name = remark_arr[1];
				}else if(i == 3){
					position = remark_arr[1];
				}else if(i == 4){
					kor_addr = remark_arr[1];
				}else if(i == 5){
					eng_addr = remark_arr[1];
				}else if(i == 6){
					phone_no = remark_arr[1];
				}else if(i == 7){
					fax_no = remark_arr[1];
				}else if(i == 8){
					mobile_no = remark_arr[1];
				}else if(i == 9){
					email = remark_arr[1];
				}else if(i == 10){
					homepage = remark_arr[1];
				}else if(i == 11){
					bank = remark_arr[1];
				}else if(i == 12){
					account = remark_arr[1];
				}
			}else{
				alert("<%=CommonLang.msg("MSG435")%>"); // 명함정보가 올바르지 않습니다. KEP관리자에게 문의해주시기 바랍니다.
				return;
			}
		}
		
	}else{
		alert("<%=CommonLang.msg("MSG436")%>"); // 명함정보를 입력하여 주시기 바랍니다.
		return;
	}
	
	var param = "["+kor_name+"]["+eng_name+"]["+branch_name+"]["+position+"]["+kor_addr+"]["+eng_addr+"]["+phone_no+"]["+fax_no+"]["+mobile_no+"]["+email+"]["+homepage+"]["+bank+"]["+account+"]";
	
	reportOpen(rpt, param);
}
//관리번호 팝업 연결
function getRefNoPopUp(type, param1, param2){
	var tot_cnt  = $("#display_item_cnt").val();
	//동화기업 관리번호 팝업
	if(type =="TYPE22"){
		var st_ref_no = "";
	    if(eval(tot_cnt) < 2){
	    	st_ref_no = kepTrimStr(document.forms.contentForm.st_type22_ref_no.value);
	    }else{
	    	st_ref_no = kepTrimStr(document.forms.contentForm.st_type22_ref_no[param2].value);
	    } 
		openSearchPopup("/mpso/getBuyerMpSoDongHwaPop.do","?open=Y&st_buyer="+param1+"&st_row=1&st_ref_no="+st_ref_no+"&st_close_yn=Y", "800,250,no");
	}
}

/* I/F 메세지 출력 팝업(공통) */
function setIFMessage(key){ 
	if(key == "")
	{return;}
	else {
		openSearchPopup('/mpif/getIfMessagePop.do','?openYn=Y&INTERFACE_ID='+key , "500,180,no"); 
		return;
	}	
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
