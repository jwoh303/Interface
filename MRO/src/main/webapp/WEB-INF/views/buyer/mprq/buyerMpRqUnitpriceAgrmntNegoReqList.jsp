<%--
**********************************************
* 메뉴 : 견적관리>단가합의 및 Nego 요청
* 화면 : 단가합의 및 Nego 요청
* 기능 : 합의대상 목록 조회 및 단가합의 또는 네고요청 처리
* 프로그램 ID : PG_04_B_004_00
* 담당자 : 김영미 ( 설계 : 권우재 )
* 착수일 : 2014-08-13
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
	String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),  CommonUtil.nvl(_sessionInfo.getRowCnt(),"10"));  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
    
	// 조회조건 S
	String st_from_date = CommonUtil.nvl((String) request.getParameter("st_from_date"),"");  // 조회일(From)
	String st_to_date = CommonUtil.nvl((String) request.getParameter("st_to_date"),"");  // 조회일(To)
	String st_date_type = CommonUtil.nvl((String) request.getParameter("st_date_type"),"");  // 조회필드콤보
	String st_btoa_user_dept_code = CommonUtil.nvl((String) request.getParameter("st_btoa_user_dept_code"),"");  // 요청부서코드
	String st_btoa_user_dept_name = CommonUtil.nvl((String) request.getParameter("st_btoa_user_dept_name"),"");  // 요청부서명
	String st_sourcing_status = CommonUtil.nvl((String) request.getParameter("st_sourcing_status"),"");  // 진행상태
	String st_quotation_no = CommonUtil.nvl((String) request.getParameter("st_quotation_no"),"");  // 견적번호
	String st_desc_spec = CommonUtil.nvl((String) request.getParameter("st_desc_spec"),""); 
	String st_btoa_user_name = CommonUtil.nvl((String) request.getParameter("st_btoa_user_name"),""); 
	String st_buyer_item_no = CommonUtil.nvl((String) request.getParameter("st_buyer_item_no"),""); 
	String user_group = CommonUtil.nvl((String)_sessionInfo.getUserGroup(),"");
	String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
	String st_com_code=  CommonUtil.nvl((String) request.getParameter("st_com_code"), _sessionInfo.getComCode());
	String st_term_pass_flag = CommonUtil.nvl((String) request.getParameter("st_term_pass_flag"),"N");  // 기간무시 체크
	String st_sourcing_sort = CommonUtil.nvl((String) request.getParameter("st_sourcing_sort"),"");  // 정렬기능
	
	// 조회조건 E
	//SLOGIC-BEGIN(P04-4027-02)
	String reportid = "RD_04_M_004_03"; 
	String reporttype = "B"; 
	if (_gridList!= null ){
		if (_gridList.size() > 0){
			Map<String, String> p04402702 = CommonUtil.getSpecialCheckReturnMap(st_com_code,"P04-4027-02");   // st_com_code , 특수로직아이디
			if (p04402702 != null){
				reporttype = CommonUtil.nvl(p04402702.get("COL01_DATA"),reporttype); // 레포트type
				reportid = CommonUtil.nvl(p04402702.get("COL02_DATA"),reportid); // 레포트아이디
			}
		}
	}
	/*
	프로그램ID: PG_02_B_000834_008
	수정자: 현명환
	수정일: 2015.03.06
	펀치아웃 해당 내용 표시.
	*/
	boolean p060000052 = CommonUtil.getSpecialCheckReturn(st_com_code,"P06-0000052");
 	//고객사 그룹통합여부 여부
 	String st_user_id = _sessionInfo.getUserId();
	boolean getCodeTGCM = CommonUtil.getCode3CheckReturn("TGCM", st_user_id, com_code);
	String group_mng_flag = "N";
	String st_buyer_select = CommonUtil.nvl((String) request.getParameter("st_com_code"),"");  // 계열사정보
	if(getCodeTGCM == true){
		group_mng_flag = "Y"; 
	}
	//MOQ를 이용하여 주문 통제
    boolean p060000077 = CommonUtil.getSpecialCheckReturn(st_com_code,"P06-0000077");
  	//견적상세 팝업
    boolean p04402705 = CommonUtil.getSpecialCheckReturn(st_com_code,"P04-4027-05");
  	//네고이력 팝업
    boolean p04402706 = CommonUtil.getSpecialCheckReturn(st_com_code,"P04-4027-06");
  	//네고제출건에 대해서 네고요청, 단가합의 가능 기능
    boolean p04402707 = CommonUtil.getSpecialCheckReturn(st_com_code,"P04-4027-07");
  	//네고제출건에 대해서 네고요청, 단가합의 기능 가능건 USER_GROUP='A'만 견적 상세 내용 보여줌
	if(p04402707 == true){
		if(!user_group.equals("A")){
			p04402705 = false; 
		}		
	}
  	//화면내 엑셀 다운로드 기능
	Map<String, String> p04402708 = CommonUtil.getSpecialCheckReturnMap(st_com_code,"P04-4027-08");   // st_com_code , 특수로직아이디
	String exceltype = "";
	if (p04402708 != null){
		exceltype = CommonUtil.nvl(p04402708.get("COL01_DATA"),""); // 엑셀 type
	}

  	// 롯데칠성 견적 결재 상신
	boolean p110000006 = CommonUtil.getSpecialCheckReturn(st_com_code,"P11-0000006");
  	
	//중앙대 사용자별 합의자 지정
	boolean getCodeM_01 = CommonUtil.getCode3CheckReturnCodeAllParam("M-01", "", st_user_id, com_code, "", "", "", "A");
	String assign_agrmnt_flag = "N";
	if(getCodeM_01 == true){
		assign_agrmnt_flag = "Y"; 
	}
	
	// 단가합의 사유 추가
	boolean p04402709 = CommonUtil.getSpecialCheckReturn(st_com_code,"P04-4027-09");
	
	// MSDS 표기 여부
	String msds_view_flag = "N";
	// MSDS 미승인 조회 여부
	String msds_valid_flag = "N";
	boolean p060000123 = CommonUtil.getSpecialCheckReturn(st_com_code,"P06-0000123");
	if(p060000123 == true){
		Map<String, String> p060000123_map = CommonUtil.getSpecialCheckReturnMap(st_com_code,"P06-0000123");   // st_com_code , 특수로직아이디
		if (p060000123_map != null){
			msds_valid_flag = CommonUtil.nvl(p060000123_map.get("COL01_DATA"),"N"); // 단가합의 통제 여부 (Y:미승인건 조회 안됨, N:모든 MSDS조회)
		}
		msds_view_flag = "Y";
	}
	
	// 단가합의 과정 예외 처리(TYPE 구분) SQL파라미터로 사용 
	String except_type = "";
	
	// 단가합의 과정이 다른 고객사 리스트 
	boolean p04402710 = CommonUtil.getSpecialCheckReturn(st_com_code,"P04-4027-10");
	if(p04402710 == true){
		Map<String, String> p04402710_map = CommonUtil.getSpecialCheckReturnMap(st_com_code,"P04-4027-10");
		if (p04402710_map != null){
			except_type = CommonUtil.nvl(p04402710_map.get("COL01_DATA"),"N");
		}
	}
	
	// 화학물질(기준: MSDS 존재)만 조회
	String msds_search_flag = "N";
	
	// 일반적인 단가합의 기능을 사용하지 않는 사용자(ex 깨끗한나라 화학물질 담당자)
	boolean msds_user_flag = CommonUtil.getCode2CheckReturn("MSDSBUSR", st_user_id, com_code);
	if(msds_user_flag == true){
		msds_search_flag = "Y";
	}
	
	//SLOGIC-END
%> 

<body onload="kep_onload_view();">
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
	<h3><%=CommonLang.get("HTITLE125")%></h3>	<!-- 단가합의 및 Nego 요청 -->
	<!--버튼영역-->
     <div id="searchBtnA">
     	<span class="btn_search"><a href="javascript:doAction('search');"><%=CommonLang.get("HTITLE7")%></a></span>	<!-- 조회 --> 
		<span class="btn_reset"><a href="javascript:doAction('reload');"><%=CommonLang.get("HTITLE8")%></a></span>	<!-- 초기화 -->
     </div>
	<!--조회영역-->
	<form name = "searchForm" id="searchForm" method = "post">
		<!--HIDDEN-->
		<!-- 공통 -->
		<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
		<!-- 화면 내 정의 -->
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
		<input type="hidden" name="st_user_group" id="st_user_group" value="${sessionInfo.userGroup}">
		<input type="hidden" name="st_group_mng_flag" id="st_group_mng_flag" value="<%=group_mng_flag%>">
		<input type="hidden" name="assign_agrmnt_flag" id="assign_agrmnt_flag" value="<%=assign_agrmnt_flag%>">
		<input type="hidden" name="st_sort" id="st_sort" value="">
		<input type="hidden" name="st_group_info" id="st_group_info" value="">
		<input type="hidden" name="st_session_com_code" id="st_session_com_code" value="${sessionInfo.comCode}">
		<input type="hidden" id="st_excel_type" name="st_excel_type"	value="" />
		<input type="hidden" name="st_msds_view_flag" id="st_msds_view_flag" value="<%=msds_view_flag%>">
		<input type="hidden" name="st_msds_valid_flag" id="st_msds_valid_flag" value="<%=msds_valid_flag%>">
		<input type="hidden" name="st_msds_search_flag" id="st_msds_search_flag" value="<%=msds_search_flag%>">
		<input type="hidden" name="st_except_type" id="st_except_type" value="<%=except_type%>">
		
		<div id="cont_searchA">	
			<table class="cont_t_list01" >
				<caption><%=CommonLang.get("HTITLE7")%></caption>	<!-- 조회 -->
				<colgroup>
				    <col width="12%" />
				    <col width="21%" />
				    <col width="12%" />
				    <col width="21%" />
				    <col width="12%" />
				    <col width="21%" />
				</colgroup>
				<tbody>
				    <tr>
				      <th><label for="" class="hidden">견적제출일</label>
						<select name="st_date_type" class="TitSelect">
				          <option value="ATOB_DATE" <%if ("ATOB_DATE".equals(st_date_type)) {%>selected<%} %>><%=CommonLang.get("HTITLE132")%></option>	<!-- 견적제출일 -->
				          <option value="BTOA_END_DATE" <%if ("BTOA_END_DATE".equals(st_date_type)) {%>selected<%} %>><%=CommonLang.get("HTITLE51")%></option>	<!-- 회신요청일 -->
				          <option value="BTOA_DATE" <%if ("BTOA_DATE".equals(st_date_type)) {%>selected<%} %>><%=CommonLang.get("HTITLE127")%></option>	<!-- 견적의뢰일 -->
				        </select>
				      </th>
				      <td colspan="3">
	   						<input type="text" name="st_from_date" id="st_from_date" readOnly style="width:20%; text-align:center;" value="<%=st_from_date%>">
								<a href="javascript:kepCalendar('st_from_date')"></a>
							-
							<input type="text" name="st_to_date" id="st_to_date" readOnly style="width:20%; text-align:center;" value="<%=st_to_date%>">
								<a href="javascript:kepCalendar('st_to_date')"></a>
								&nbsp;&nbsp;
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1<%=CommonLang.get("HTITLE602")%></a></span>	<!-- 개월 --> 
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2<%=CommonLang.get("HTITLE602")%></a></span> 
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3<%=CommonLang.get("HTITLE602")%></a></span>
							<span class="btn_month"><a href="javascript:setCurMonth('st_from_date','st_to_date')">당월</a></span>		
							<input type="checkbox"  class="Noborder" name="st_checkbox" id="st_checkbox" <%if("Y".equals(st_term_pass_flag)){%>checked<%}%> onclick="setTermPassFlag()">&nbsp;<%=CommonLang.get("HTITLE603")%>	<!-- 기간무시 -->
							<input type="hidden" name="st_term_pass_flag" id="st_term_pass_flag" value="<%=st_term_pass_flag%>">				
				      </td>
					<%if(group_mng_flag.equals("Y")){%>
					     <th><%=CommonLang.get("HTITLE604")%></th>	<!-- 고객사 -->
					      <td >
					        <select name="st_com_code" id="st_com_code" style="width:90%;height:20px;">
					        	<%= CommonUtil.getCode3ComboList(_sessionInfo.getComCode(), "ALL", "TGCM",_sessionInfo.getUserId(), "ICOMCOD3", st_buyer_select, "") %>
					        </select>
					      </td>
					<%}else{%>
					      <th></th>
					      <td ><input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}"></td>
					 <%}%>
				    	<tr>  
				      <th><%=CommonLang.get("HTITLE133")%></th>	<!-- 요청자 -->
				      <td ><input type="text" name="st_btoa_user_name" id="st_btoa_user_name" style="width:87%;ime-mode:active" value="<%=st_btoa_user_name %>" onKeyDown="kepEnter()"></td>
				      <th ><%=CommonLang.get("HTITLE126")%></th>	<!-- 견적번호 -->
				      <td ><input type="text" name="st_quotation_no" id="st_quotation_no" style="width:87%" value="<%=st_quotation_no%>" onKeyUp="kepToUpper('st_quotation_no')" onKeyDown="kepEnter()"></td>
				      <th><%=CommonLang.get("HTITLE134")%></th>	<!-- 품목명/규격 -->
				      <td ><input type="text" name="st_desc_spec" id="st_desc_spec" style="width:87%" value="<%=st_desc_spec%>" onKeyDown="kepEnter()"></td>
				    </tr>
				    <tr>
				      <th><%=CommonLang.get("HTITLE135")%></th>	<!-- 요청부서 -->
				      <td ><input type="hidden" name="st_btoa_user_dept_code" id="st_btoa_user_dept_code" value="<%=st_btoa_user_dept_code%>">
				        <input type="text" name="st_btoa_user_dept_name" id="st_btoa_user_dept_name" style="width:55%;ime-mode:active" value="<%=st_btoa_user_dept_name %>" READONLY>
				        <a href="javascript:doPop('dept');"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
				        <a href="javascript:kepEraser('st_btoa_user_dept_code','st_btoa_user_dept_name');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
				      </td>
				      <th><%=CommonLang.get("HTITLE12")%></th>	<!-- 품목코드 -->
				      <td ><input type="text" name="st_buyer_item_no" id="st_buyer_item_no" style="width:87%" value="<%=st_buyer_item_no %>" onKeyUp="kepToUpper('st_buyer_item_no')" onKeyDown="kepEnter()"></td>
				      <th><%=CommonLang.get("HTITLE136")%></th>	<!-- 진행상태 -->
				      <td ><select name="st_sourcing_status" id="st_sourcing_status" style="width:90%;height:20px;" >
				          <option value="" ><%=CommonLang.get("HTITLE29")%></option>	<!-- 전체 -->
				          <option value="합의대상" <%if ("합의대상".equals(st_sourcing_status)) {%>selected<%} %>><%=CommonLang.get("HTITLE137")%></option>	<!-- 합의대상 -->
				          <option value="Nego합의대상" <%if ("Nego합의대상".equals(st_sourcing_status)) {%>selected<%} %>><%=CommonLang.get("HTITLE138")%></option>	<!-- Nego합의대상 -->
				          <option value="결재반려" <%if ("결재반려".equals(st_sourcing_status)) {%>selected<%} %>><%=CommonLang.get("HTITLE139")%></option>	<!-- 결재반려 -->
				        </select></td>
				    </tr>
				</tbody>
			</table>
		</div>
 		
 		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
	      	<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow">
				<option value = "10" <%if ("10".equals(onepagerow)) {%>selected<%} %>>10<%=CommonLang.get("HTITLE595")%></option>	<!-- 건 -->
				<option value = "20" <%if ("20".equals(onepagerow)) {%>selected<%} %>>20<%=CommonLang.get("HTITLE595")%></option>
				<option value = "30" <%if ("30".equals(onepagerow)) {%>selected<%} %>>30<%=CommonLang.get("HTITLE595")%></option>
				<option value = "40" <%if ("40".equals(onepagerow)) {%>selected<%} %>>40<%=CommonLang.get("HTITLE595")%></option>
				<option value = "50" <%if ("50".equals(onepagerow)) {%>selected<%} %>>50<%=CommonLang.get("HTITLE595")%></option> 
				<option value = "100"<%if ("100".equals(onepagerow)) {%>selected<%} %>>100<%=CommonLang.get("HTITLE595")%></option> 
			</select>
			<select name="st_sourcing_sort">
				<option value="A"  <%if ("A".equals(st_sourcing_sort)) {%>selected<%} %>><%=CommonLang.get("HTITLE126")%>▼</option>	<!-- 견적번호▼ -->
				<option value="B"  <%if ("B".equals(st_sourcing_sort)) {%>selected<%} %>><%=CommonLang.get("HTITLE126")%>▲</option>	<!-- 견적번호▲ -->
				<option value="C"  <%if ("C".equals(st_sourcing_sort)) {%>selected<%} %>><%=CommonLang.get("HTITLE127")%>▼</option>	<!-- 견적의뢰▲ -->
				<option value="D"  <%if ("D".equals(st_sourcing_sort)) {%>selected<%} %>><%=CommonLang.get("HTITLE127")%>▲</option>	<!-- 견적의뢰▲ -->
				<option value="E"  <%if ("E".equals(st_sourcing_sort)) {%>selected<%} %>><%=CommonLang.get("HTITLE51")%>▼</option>	<!-- 회신요청일▼ -->
				<option value="F"  <%if ("F".equals(st_sourcing_sort)) {%>selected<%} %>><%=CommonLang.get("HTITLE51")%>▲</option>	<!-- 회신요청일▲ -->
				<option value="G"  <%if ("G".equals(st_sourcing_sort)) {%>selected<%} %>>제조사명▼</option>
				<option value="H"  <%if ("H".equals(st_sourcing_sort)) {%>selected<%} %>>제조사명▲</option>
				<option value="I"  <%if ("I".equals(st_sourcing_sort)) {%>selected<%} %>>요청부서명▼</option>
				<option value="J"  <%if ("J".equals(st_sourcing_sort)) {%>selected<%} %>>요청부서명▲</option>
			</select>
			<!--  span class="btn_gray_04" title="견적번호" ><a href="javascript:doAction('search_quot');"><%=CommonLang.get("HTITLE126")%></a></span-->		<!-- 견적번호 -->
			<!--  span class="btn_gray_04" title="견적의뢰일" ><a href="javascript:doAction('search_btoa');"><%=CommonLang.get("HTITLE127")%></a></span-->	<!-- 견적의뢰일 -->
			<%=CommonLang.get("HTITLE605")%><!-- ※ Nego를 원하시면 해당 품목의 Nego 단가를 입력하셔야 합니다.-->&nbsp;&nbsp;<b><%=CommonLang.get("HTITLE606")%><!-- 진행상태--></b> <%=CommonLang.get("HTITLE607")%><!-- 클릭 시 Nego 이력을 보실 수 있습니다.-->
      	</span>      
       <span class="fr">
       <%=CommonLang.get("HTITLE608")%> <!-- 총건수 --><input type="text" class="input_type_text" id="st_total_cnt" name="st_total_cnt" readonly style="width:30px;border:0" value="<%=total_cnt %>"/>
       </span>
       	<br>
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<!-- 공통 -->
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
		<table id="table_list" class="cont_t_list02" style="width:100%">
			<colgroup>
	            <col width="2%" />
	            <col width="5%" />
			<%if(group_mng_flag.equals("Y")){%>
				<col width="8%" />
			<%}%>
	            <col width="9%" />
	            <col width="8%" />
	            <col width="7%" />
	            <col width="*" />
	            <col width="8%" />
	            <col width="9%" />
	            <col width="9%" />
	            <col width="7%" />
	            <col width="3%" />
	            <col width="3%" />
	            <col width="5%" />
	        </colgroup>
	        <thead>
			<tr>
				<th scope="col">
					<input type="checkbox" name="check_status" id="check_status" value="선택"  style="cursor:hand;" onclick="kepCheckAll2();">
				</th>
				<%if(msds_view_flag.equals("Y")){ //MSDS 사용 특수로직%>
					<th scope="col"><%=CommonLang.get("HTITLE140")%><!--순번--><br><%=CommonLang.get("HTITLE914")%><!--MSDS--></th>
				<%}else{%>
					<th scope="col" rowspan="2"><%=CommonLang.get("HTITLE140")%><!--순번--></th>
				<%}%>
				<%if(group_mng_flag.equals("Y")){%>
						<th scope="col"><%=CommonLang.get("HTITLE290")%><!-- 고객사코드 --><br><%=CommonLang.get("HTITLE291")%><!-- 고객사명 --></th>
				<%}%>
				  <th scope="col" ><%=CommonLang.get("HTITLE126")%><!-- 견적번호 --><br><%=CommonLang.get("HTITLE136")%><!-- 진행상태 --></th>
				  <th scope="col" ><%=CommonLang.get("HTITLE510")%><!-- 카테고리 --><br><%=CommonLang.get("HTITLE12")%><!-- 품목코드 --></th>
				  <th scope="col" ><%=CommonLang.get("HTITLE127")%><!-- 견적의뢰일 --><br><%=CommonLang.get("HTITLE51")%><!-- 회신요청일 --></th>
				  <th scope="col" ><%=CommonLang.get("HTITLE13")%><!-- 품목명 --><br><%=CommonLang.get("HTITLE14")%><!-- 규격 --></th>
				  <th scope="col" ><%=CommonLang.get("HTITLE15")%><!-- 제조사 --><br><%=CommonLang.get("HTITLE120")%><!-- 원산지 --></th>
				  <th scope="col" ><%=CommonLang.get("HTITLE144")%><!-- 협력사 --><br><%=CommonLang.get("HTITLE143")%><!-- 단가구분/요청단가 --></th>
				  <th scope="col" ><%=CommonLang.get("HTITLE578")%><!-- 조달일수 -->/<%=CommonLang.get("HTITLE45")%><!-- 수량 -->/<%=CommonLang.get("HTITLE52")%><!-- 단위 --><br><%=CommonLang.get("HTITLE145")%><!-- 견적단가 -->/<%=CommonLang.get("HTITLE978")%><!-- 견적금액 --></th>
				  <th scope="col" ><%=CommonLang.get("HTITLE133")%><!-- 요청자 --><br><%=CommonLang.get("HTITLE135")%><!-- 요청부서 --></th>
				  <th scope="col" colspan="2"><%=CommonLang.get("HTITLE146")%><!-- KeP담당자 --><br><%=CommonLang.get("HTITLE147")%><!-- Nego/첨부 --></th>
				  <th scope="col" ><%=CommonLang.get("HTITLE122")%><!-- 비고 --><br><%=CommonLang.get("HTITLE686")%><!-- 취소/지연 --></th>
			</tr>
		</thead>
		<tbody>
		<%
		if (_gridList == null){
		%>
					<tr>
                    <%if(group_mng_flag.equals("Y")){%>
                    	<td colspan="14" align="center" height = "50">
                    <%}else{%>
                        <td colspan="13" align="center" height = "50">
					<%}%> 
                        <span><%=CommonLang.msg("MSG558")%><!-- 조회 조건을 확인 후 조회 버튼을 클릭하여 주시기 바랍니다. --></span>
                        </td> 
                    </tr>
		<%
		}else if (_gridList.size() == 0){
		%>
					<tr>
                    <%if(group_mng_flag.equals("Y")){%>
                    	<td colspan="14" align="center" height = "50">
                    <%}else{%>
                        <td colspan="13" align="center" height = "50">
					<%}%> 
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
                                <td rowspan ="2" class="font1_black1"  align="center">
							<!-- //SLOGIC-BEGIN(P04-4027-01) -->
                            <%
								if(com_code.equals("KRKEPB0004") || com_code.equals("KRDOOS0020")) {
							%>    
                                <input type="checkbox" name="checkbox" id="checkbox<%=j%>" onclick="javascript:getCheckedItemAmt();">
                           <%
								} else {
                           %>     
                           		<input type="checkbox" name="checkbox" id="checkbox<%=j%>">
                           <%
								}
                           %>
                           <!-- //SLOGIC-END -->
								<input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=_gridList.size() %>" >
	                            <input type="hidden" name="st_buyer2" id="st_buyer2"              value="<%=rowData.get("BUYER")%>">
	                            <input type="hidden" name="st_quotation_no2" id="st_quotation_no2"       value="<%=rowData.get("QUOTATION_NO")%>">
	                            <input type="hidden" name="st_quotation_seq2"  id="st_quotation_seq2"     value="<%=rowData.get("QUOTATION_SEQ")%>">
	                            <input type="hidden" name="st_revision2" id="st_revision2"           value="<%=rowData.get("REVISION")%>">
	                            <input type="hidden" name="st_btoa_nego_price2" id="st_btoa_nego_price2"    value="">
	                            <input type="hidden" name="st_btoa_end_date2" id="st_btoa_end_date2"      value="">
	                            <input type="hidden" name="st_btoa_end_time2" id="st_btoa_end_time2"      value="190000">
	                            <input type="hidden" name="st_reject_remark2" id="st_reject_remark2"      value="">
	                            <input type="hidden" name="st_doos_item_no_back" id="st_doos_item_no_back"      value="">
	                            <input type="hidden" name="st_confirm_user_id2"     value="${sessionInfo.userId}">
	                            <input type="hidden" name="st_user_id"     value="${sessionInfo.userId}">
	                            <input type="hidden" name="st_agent2" id="st_agent2"              value="<%=rowData.get("AGENT")%>">
	                            <input type="hidden" name="st_reg_item_no2" id="st_reg_item_no2"        value="<%=rowData.get("REG_ITEM_NO")%>">
	                            <input type="hidden" name="st_contract_no" id="st_contract_no"         value="<%=rowData.get("CONTRACT_NO")%>">
	                            <input type="hidden" name="st_contract_seq" id="st_contract_seq"        value="<%=rowData.get("CONTRACT_SEQ")%>">
	                            <input type="hidden" name="st_byit_comorg_code" id="st_byit_comorg_code"    value="<%=rowData.get("BYCA_COMORG_CODE")%>">
	                            <input type="hidden" name="st_atob_remark" id="st_atob_remark"         value="<%=rowData.get("ATOB_REMARK")%>">
	                            <input type="hidden" name="st_kep_user_id" id="st_kep_user_id"         value="<%=rowData.get("KEP_USER_ID")%>">
	                            <input type="hidden" name="st_buyer_target_price" id="st_buyer_target_price"  value="<%=rowData.get("BUYER_TARGET_PRICE")%>">
	                            <input type="hidden" name="st_stoa_list_price" id="st_stoa_list_price"		value="<%=rowData.get("STOA_LIST_PRICE")%>">
	                            <input type="hidden" name="st_description" id="st_description"			value="<%=rowData.get("DESCRIPTION")%>">
	                            <input type="hidden" name="st_specification" id="st_specification"		value="<%=rowData.get("SPECIFICATION")%>">
	                            <input type="hidden" name="st_unit_measure"	id="st_unit_measure"		value="<%=rowData.get("UNIT_MEASURE")%>">
	                            <input type="hidden" name="st_maker_name" id="st_maker_name"			value="<%=rowData.get("MAKER_NAME")%>">
	                            <input type="hidden" name="st_origin_code"	 id="st_origin_code"		value="<%=rowData.get("ORIGIN_CODE")%>">
	                            <input type="hidden" name="st_lead_time" id="st_lead_time"			value="<%=rowData.get("LEAD_TIME")%>">
	                            <input type="hidden" name="st_load_user_id" id="st_load_user_id"			value="<%=rowData.get("LOAD_USER_ID")%>">
	                            <input type="hidden" name="st_atob_unit_price" id="st_atob_unit_price"		value="<%=rowData.get("ATOB_UNIT_PRICE")%>">
								<input type="hidden" name="st_cms_categ_id"	id="st_cms_categ_id"		value="<%=rowData.get("CMS_CATEG_ID")%>">
								<input type="hidden" name="st_cms_catlg_id"	id="st_cms_catlg_id"		value="<%=rowData.get("CMS_CATLG_ID")%>">
								<input type="hidden" name="st_process_type"	id="st_process_type"		value="<%=rowData.get("PROCESS_TYPE")%>">
								<input type="hidden" name="st_import_flag"	 id="st_import_flag"		value="<%=rowData.get("IMPORT_FLAG")%>">
								<input type="hidden" name="st_warehouse_code"	id="st_warehouse_code"	value="<%=rowData.get("WAREHOUSE_CODE")%>">
								<input type="hidden" name="st_below_comorg_code" id="st_below_comorg_code"	value="<%=rowData.get("BELOW_COMORG_CODE")%>">
								<input type="hidden" name="st_item_group"	 id="st_item_group" value="<%=rowData.get("ITEM_GROUP")%>">
								<input type="hidden" name="st_image_key"	 id="st_image_key" value="<%=rowData.get("IMAGE_KEY")%>">
								<input type="hidden" name="st_item_detail_desc"	 id="st_item_detail_desc" value="<%=rowData.get("ITEM_DETAIL_DESC")%>">
								<input type="hidden" name="st_imgfile_name"	 id="st_imgfile_name" value="<%=rowData.get("IMGFILE_NAME")%>">
								<input type="hidden" name="st_imgfile_dir"	 id="st_imgfile_dir" value="<%=rowData.get("IMGFILE_DIR")%>">
								<input type="hidden" name="st_product_close_flag"	 id="st_product_close_flag" value="<%=rowData.get("PRODUCT_CLOSE_FLAG")%>">
								<input type="hidden" name="st_nocode_yn"	 id="st_nocode_yn" value="<%=rowData.get("NOCODE_YN")%>">
								<input type="hidden" name="st_green_flag"	 id="st_green_flag" value="<%=rowData.get("GREEN_FLAG")%>">
								<input type="hidden" name="st_item_gubun"	 id="st_item_gubun" value="<%=rowData.get("ITEM_GUBUN")%>">
								<input type="hidden" name="st_msds_yn"	 id="st_msds_yn" value="<%=rowData.get("MSDS_YN")%>">
								<input type="hidden" name="st_msds_status"	 id="st_msds_status" value="<%=rowData.get("MSDS_STATUS")%>">
								<input type="hidden" name="st_msds_no"	 id="st_msds_no" value="<%=rowData.get("MSDS_NO")%>">
								<input type="hidden" name="st_msds_type_text"	 id="st_msds_type_text" value="<%=rowData.get("MSDS_TYPE_TEXT")%>">
								<input type="hidden" name="st_cancle_remark"	 id="st_cancle_remark" value="">
								<input type="hidden" name="st_group_mng_flag" id="st_group_mng_flag" value="<%=group_mng_flag%>">
								<input type="hidden"   name="st_pass_yn"     id="st_pass_yn"    value="<%=rowData.get("PASS_YN")%>">
								<input type="hidden"   name="st_confirm_yn"     id="st_confirm_yn"    value="<%=rowData.get("CONFIRM_YN")%>">
								<input type="hidden"   name="st_pre_gr_flag"     id="st_pre_gr_flag"    value="<%=rowData.get("PRE_GR_FLAG")%>">
								<input type="hidden"   name="st_btoa_user_id"     id="st_btoa_user_id"    value="<%=rowData.get("BTOA_USER_ID")%>">
								<input type="hidden"   name="st_min_order_qty"     id="st_min_order_qty"    value="<%=rowData.get("MIN_ORDER_QTY")%>">
								<input type="hidden"   name="st_pur_unit_qty"     id="st_pur_unit_qty"    value="<%=rowData.get("PUR_UNIT_QTY")%>">
								<input type="hidden" name="st_buyer" id="st_buyer" value="${sessionInfo.comCode}">
								<input type="hidden"   name="st_nego_yn"     id="st_nego_yn"    value="<%=rowData.get("NEGO_YN")%>">
								<input type="hidden"   name="st_snd_chk_yn"     id="st_snd_chk_yn"    value="<%=rowData.get("SND_CHK")%>">
								<input type="hidden"   name="st_sell_close_date"     id="st_sell_close_date"    value="<%=rowData.get("SELL_CLOSE_DATE")%>">
								<input type="hidden"   name="st_buy_close_date"     id="st_buy_close_date"    value="<%=rowData.get("BUY_CLOSE_DATE")%>">
								<input type="hidden" name="st_msds_search_flag" id="st_msds_search_flag" value="<%=msds_search_flag%>">
                                </td>
                                <td title="순번" rowspan="2"><%=((Integer.parseInt(curPage)-1)*Integer.parseInt(onepagerow))+(j+1) %>
                <%if("Y".equals(rowData.get("PRE_GR_FLAG"))){%>
						<br>
						<b>(선입고)</b>
				<%}%>
				 <%if(p04402705 == true){ //견적상세 특수로직%>
						<br>
						<a class="hyperLink" href="javascript:doPop('kepQuotDetailInfo','<%=CommonUtil.nvl(rowData.get("BUYER"))%>','<%=CommonUtil.nvl(rowData.get("QUOTATION_NO"))%>','<%=CommonUtil.nvl(rowData.get("QUOTATION_SEQ"))%>','<%=CommonUtil.nvl(rowData.get("REVISION"))%>');">견적상세</a>
				<%}%>
				<%if(msds_view_flag.equals("Y")){ //MSDS 사용 특수로직%>
					<%if(rowData.get("MSDS_YN").equals("Y") || (rowData.get("MSDS_YN").equals("N") && !rowData.get("MSDS_NO").equals(""))){%>
						<br>
						<a class="hyperLink" href="javascript:doPop('getMsdsView','<%=rowData.get("MSDS_NO")%>','<%=rowData.get("BUYER")%>','<%=rowData.get("QUOTATION_NO")%>','<%=rowData.get("QUOTATION_SEQ")%>','<%=rowData.get("REVISION")%>');">MSDS</a>
					<%}%>
				<%}%>
                                </td>
				<%if(group_mng_flag.equals("Y")){%>
								<td title="고객사코드"><%=String.valueOf(CommonUtil.nvl(rowData.get("BUYER")))%></td>
				<%}%>
                                <td title="견적번호">
								 <a class="hyperLink b"  href="javascript:doPop('buyerMpRqDepartmentTotalPop','<%=rowData.get("BUYER")%>', '<%=rowData.get("QUOTATION_NO")%>', '<%=rowData.get("REVISION")%>', '<%=rowData.get("QUOTATION_SEQ")%>');"><b><%=rowData.get("QUOTATION_NO")%></b></a></td>
                                <td title="카테고리" class="td02" class="left"><%=rowData.get("CATEG_NAME")%>
                               		<input type="hidden" name="st_category_no" id="st_category_no" value="<%=rowData.get("CATEG_NAME")%>">
                               		<input type="hidden" name="st_category_code" id="st_category_code" value="<%=rowData.get("CATEG_CODE")%>">
                                </td>
                                <td title="견적의뢰일"><%=CommonUtil.formatStrinigDate(rowData.get("BTOA_DATE"))%></td>
                                <td title="품목명"       class="td02"><%=rowData.get("DESCRIPTION")%></td>
                                <td title="제조사"       class="td02"><%=rowData.get("MAKER_NAME")%></td>
								<td title="협력사" class="td02" align="left">
								<%
									if(rowData.get("AGENT_OPEN_FLAG").equals("Y")) {
								%>
										<a class="hyperLink" href="javascript:doPop('agent','<%=rowData.get("AGENT")%>');"><%=rowData.get("AGENT_NAME")%></a>
								<%
									}else {
								%>
										<a class="hyperLink" href="javascript:doPop('agent','KRKORE0001');"><%=CommonLang.get("HTITLE614")%><!-- 코리아e플랫폼(주) --></a>
								<%
									}
								%>
								</td>
								<td title="조달일수/수량/단위">
								  <input type="hidden" name="st_item_qty" id="st_item_qty" value="<%=rowData.get("ITEM_QTY")%>">
								  <%=CommonUtil.formatNumber(rowData.get("LEAD_TIME"),true,0,3)%>일 / <%=CommonUtil.formatNumber(rowData.get("ITEM_QTY"),true,0,3)%> / <%=rowData.get("UNIT_MEASURE")%>
								</td>
                                <td title="요청자"><%=rowData.get("BTOA_USER_NAME")%></td>
                                <td title="KeP담당자" class="td02" colspan="2">
                                	<a class="hyperLink" href="javascript:doPop('kepManagerPop','<%=rowData.get("KEP_USER_ID")%>')"><%=rowData.get("KEP_USER_NAME")%></a>
                                </td>
                                <% 
                                	if(p04402709 == true) {
                                %>
                                	<td title="비고" class="td02" >
    								<%
                                            if(rowData.get("ATOB_REMARK").equals("") && rowData.get("CONFIRM_REMARK").equals("")) {
                                    %>
                                    			<a href="javascript:doPop('confirm_remark','<%=CommonUtil.nvl(rowData.get("ATOB_REMARK"), "")%>','<%=CommonUtil.nvl(rowData.get("BTOA_REMARK"), "")%>','<%=((Integer.parseInt(curPage)-1)*Integer.parseInt(onepagerow))+(j+1) %>','<%=CommonUtil.nvl(rowData.get("BUYER"), "")%>','<%=CommonUtil.nvl(rowData.get("QUOTATION_NO"), "")%>','<%=CommonUtil.nvl(rowData.get("QUOTATION_SEQ"), "")%>','<%=CommonUtil.nvl(rowData.get("REVISION"), "")%>');"><img name = "st_atob_remark_img" id="st_atob_remark_img<%=((Integer.parseInt(curPage)-1)*Integer.parseInt(onepagerow))+(j+1) %>" src="/resources/images/but_icon02.gif" border="0"></a>
                                    <%
                                            }else if(!rowData.get("ATOB_REMARK").equals("") || !rowData.get("CONFIRM_REMARK").equals("")) {
                                    %>
                                                <a href="javascript:doPop('confirm_remark','<%=CommonUtil.nvl(rowData.get("ATOB_REMARK"), "")%>','<%=CommonUtil.nvl(rowData.get("BTOA_REMARK"), "")%>','<%=((Integer.parseInt(curPage)-1)*Integer.parseInt(onepagerow))+(j+1) %>','<%=CommonUtil.nvl(rowData.get("BUYER"), "")%>','<%=CommonUtil.nvl(rowData.get("QUOTATION_NO"), "")%>','<%=CommonUtil.nvl(rowData.get("QUOTATION_SEQ"), "")%>','<%=CommonUtil.nvl(rowData.get("REVISION"), "")%>');"><img name = "st_atob_remark_img" id="st_atob_remark_img<%=((Integer.parseInt(curPage)-1)*Integer.parseInt(onepagerow))+(j+1) %>" src="/resources/images/but_icon01.gif" border="0"></a>
                                    <%
                                            }
                                    
                                    %>
                                    <input type="hidden" name="st_atob_remark" id="st_atob_remark<%=((Integer.parseInt(curPage)-1)*Integer.parseInt(onepagerow))+(j+1) %>" value="<%=rowData.get("ATOB_REMARK")%>"/>
                                    <input type="hidden" name="st_confirm_remark" id="st_confirm_remark<%=((Integer.parseInt(curPage)-1)*Integer.parseInt(onepagerow))+(j+1) %>" value="<%=rowData.get("CONFIRM_REMARK")%>"/>
                                    </td>
                                   <% 	
                                } else { %>
	                                <td title="비고" class="td02" >
									<%
	                                        if(rowData.get("ATOB_REMARK").equals("")) {
	                                %>
	                                		<img name = "st_atob_remark_img" id="st_atob_remark_img" src="/resources/images/but_icon02.gif" border="0">
	                                <%
	                                        }else {
	                                %>
	                                            <a href="javascript:doPop('remark','<%=CommonUtil.nvl(rowData.get("ATOB_REMARK"), "")%>','<%=CommonUtil.nvl(rowData.get("BTOA_REMARK"), "")%>');"><img name = "st_atob_remark_img" src="/resources/images/but_icon01.gif" border="0"></a>
	                                <%
	                                        }	                                
	                                %>
	                                </td>
	                                <% } %>
                            </tr>
                            <tr align="center" bgcolor="<%=tclass%>">
				<%if(group_mng_flag.equals("Y")){%>
								<td title="고객사명"><%=String.valueOf(CommonUtil.nvl(rowData.get("COM_NAME_LOC")))%></td>
				<%}%>
                                <td title="진행상태">
								<%
									if(rowData.get("SOURCING_STATUS").equals("Nego합의대상")) {
								%>
										<a class="hyperLink" href="javascript:doPop('getNegoView','<%=rowData.get("BUYER")%>','<%=rowData.get("QUOTATION_NO")%>','<%=rowData.get("QUOTATION_SEQ")%>','<%=rowData.get("REVISION")%>');"><%=rowData.get("SOURCING_STATUS")%></a>
								<%
									}else {
								%>
										<%=rowData.get("SOURCING_STATUS")%>
								<%
									}
								%>
								
								<% if(p110000006 == true) { if(CommonUtil.nvl(rowData.get("SND_CHK")).equals("S")){%>
		                    		 <p>( <%=CommonLang.get("HTITLE941")%> ) </p><!-- 상신중 -->
		                    		 <% } else if (CommonUtil.nvl(rowData.get("SND_CHK")).equals("T")){ %>
		                    		 <p>( <%=CommonLang.get("HTITLE195")%> ) </p><!-- 주문결재중-->
		                    		 <% } else if (CommonUtil.nvl(rowData.get("SND_CHK")).equals("Y")){ %>
		                    		 <p>( <%=CommonLang.get("HTITLE321")%> ) </p><!-- 승인-->
		                    	<% }} %>
								
								</td>
                                <td title="품목코드" class="td02" class="left">
                                    <input type="hidden" name="st_buyer_item_no2" id="st_buyer_item_no2" value="<%=rowData.get("BUYER_ITEM_NO")%>">
                                    <a class="hyperLink"  href="javascript:doPop('quotation_print', '<%=rowData.get("QUOTATION_NO")%>','<%=rowData.get("QUOTATION_SEQ")%>','<%=rowData.get("REVISION")%>','<%=rowData.get("AGENT")%>','N','<%=rowData.get("BUYER_ITEM_NO")%>', '<%=rowData.get("BUYER")%>');"><%=rowData.get("BUYER_ITEM_NO")%></a>
                                </td>
                                <td title="회신요청일" class="td02">
									<b><%=CommonUtil.formatStrinigDate(rowData.get("BTOA_END_DATE"))%></b>
								</td>
                                <td title="규격" class="td02" class="left"><%=rowData.get("SPECIFICATION")%>
                                <%
									if(p060000077==true) {
								%>
									/ MOQ:  <%=rowData.get("MIN_ORDER_QTY")%>
								<%} %>
								</td>
                                <td title="원산지"><%=rowData.get("ORIGIN_NAME")%></td>
								<td title="단가구분/요청단가">
									<input type="hidden" name="st_target_price" id="st_target_price" size="10" maxlength ="17"  value="<%=rowData.get("BUYER_TARGET_PRICE")%>">
									<%=rowData.get("REQ_PRICE_TYPE_TEXT") + " / " + CommonUtil.formatNumber(rowData.get("BUYER_TARGET_PRICE"),true,0,3)%>
                                </td>
                                <td title="견적단가/견적금액" class="td02" class="right">
                                    <input type="hidden" name="st_confirm_price" id="st_confirm_price"  value="<%=rowData.get("ATOB_UNIT_PRICE")%>">
                                    <%=CommonUtil.formatNumber(rowData.get("ATOB_UNIT_PRICE"),true,0,3)%><br><%=CommonUtil.formatNumber(rowData.get("ATOB_UNIT_AMT"),true,0,3)%>
                                </td>
                                <td title="요청부서"><%=rowData.get("BTOA_USER_DEPT")%></td>
                                <td title="Nego">
<%
                if(user_group.equals("C") || user_group.equals("A") || user_group.equals("N")) {
%>
                                  <a href="javascript:doPop('negoreq',<%=j%>)"><img name="Image2" id="Image2" src="/resources/images/icon2.gif"></a>
<%
                }
%>
                                </td>
                                <td title="첨부">
                                    <%
                                        if(!rowData.get("IMAGE_KEY").equals("")) {
                                    %>
                                            <a class="hyperLink" href="javascript:doPop('attach', '<%=CommonUtil.nvl(rowData.get("IMAGE_KEY"))%>')"><img name = "st_image_key_img" src="/resources/images/disk_on.gif" border="0"></a>
                                    <%
                                        }else {
                                    %>
                                            <img name = "st_image_key_img" id="st_image_key_img" src="/resources/images/disk_off.gif" border="0">
                                    <%
                                        }
                                    %>
                                </td>
                                <td title="취소/지연">
<%
			if(user_group.equals("C") || user_group.equals("A") || user_group.equals("N")|| user_group.equals("Q")) {
%>
                                  <a href="javascript:doPop('canclereq',<%=j%>)"><img name="cancleImage" id="cancleImage" src="/resources/images/icon2.gif"></a>
<%
                }
%>
                                    <%
                                    	if(!CommonUtil.nvl(rowData.get("DELAY_REASON_CODE")).equals("")) {
                                    %>
                                            <a href="javascript:doPop('delayPop','<%=rowData.get("BUYER")%>', '<%=rowData.get("QUOTATION_NO")%>', '<%=rowData.get("QUOTATION_SEQ")%>', '<%=rowData.get("REVISION")%>', '<%=rowData.get("DELAY_REASON_CODE")%>');"><img name="delayImage" id="delayImage" src="/resources/images/icon.gif"></a>
                                    <%
                                        }else {
                                    %>
                                            <a href="javascript:doPop('delayPop','<%=rowData.get("BUYER")%>', '<%=rowData.get("QUOTATION_NO")%>', '<%=rowData.get("QUOTATION_SEQ")%>', '<%=rowData.get("REVISION")%>', '<%=rowData.get("DELAY_REASON_CODE")%>');"><img name="delayImage" id="delayImage" src="/resources/images/icon2.gif"></a>
                                    <%
                                        }
                                    %>
                                    <%if(p04402706 == true){ //네고이력 특수로직%>
									<br>
									<a class="hyperLink" href="javascript:doPop('kepNegoLogInfo','<%=CommonUtil.nvl(rowData.get("BUYER"))%>','<%=CommonUtil.nvl(rowData.get("QUOTATION_NO"))%>','<%=CommonUtil.nvl(rowData.get("QUOTATION_SEQ"))%>','<%=CommonUtil.nvl(rowData.get("REVISION"))%>');">네고이력</a>
									<%}%>
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
			<div class="fl">
			<%
				if(com_code.equals("KRKEPB0004") || com_code.equals("KRDOOS0020")) {
			%>
					■ <b><%=CommonLang.get("HTITLE615")%><!-- 실적단가 금액 --></b> : <input type="text" name="st_target_price_amt" id="st_target_price_amt" style="text-align:right;border-width:0px;" size="10" value="0원" readonly>,   
					■ <b><%=CommonLang.get("HTITLE616")%><!-- 견적단가 금액 --></b> : <input type="text" name="st_atob_unit_price_amt" id="st_atob_unit_price_amt" style="text-align:right;border-width:0px;" size="10" value="0원" readonly>,  
					■ <b><%=CommonLang.get("HTITLE617")%><!-- 절감금액 --></b> : <input type="text" name="st_quotation_price_amt" id="st_quotation_price_amt" style="text-align:right;border-width:0px;" size="15" value="%" readonly>,
					■ <b><%=CommonLang.get("HTITLE618")%><!-- 절감율 --></b> : <input type="text" name="st_rate" id="st_rate" style="text-align:right;border-width:0px;" value="%" size="6" readonly>
			<%
				}
			%>			
			</div>
			<div class="fr">
			<%if(p04402708 != null) { // 엑셀다운로드 조절%>
				<span class="btn_03 mr04">
						<a href="javascript:doAction('excelDown', '<%=exceltype%>');"><%=CommonLang.get("HTITLE150")%><!-- 엑셀다운로드 --></a>
				</span>
			<%}
			//두산중공업 펀치아웃 
			//SLOGIC-BEGIN(P06-0000052)
			if(p060000052 == false) {
			%>
				<span class="btn_03 mr04">
					<a href="javascript:doAction('printPum');"><%=CommonLang.get("HTITLE619")%><!-- 견적서출력 --></a>
				</span>
			<%} %>
				
	<%
		if(user_group.equals("C") || user_group.equals("A")) {
	%>
        		<span class="btn_03 mr04">
					<a href="javascript:doAction('cancleSubmit');"><%=CommonLang.get("HTITLE129")%><!-- 견적취소 --></a>
				</span>
				<span class="btn_03">
					<a href="javascript:doAction('negoSubmit');"><%=CommonLang.get("HTITLE130")%><!-- NEGO요청 --></a>
				</span>
        		<span class="btn_03 mr04">
					<a href="javascript:doAction('confirmKepPrice');"><%=CommonLang.get("HTITLE131")%><!-- 단가합의 --></a>
				</span>	
	<%
		}else if(user_group.equals("N")) {
	%>
        		<span class="btn_03 mr04">
					<a href="javascript:doAction('cancleSubmit');"><%=CommonLang.get("HTITLE129")%><!-- 견적취소 --></a>
				</span>
				<span class="btn_03">
					<a href="javascript:doAction('negoSubmit');"><%=CommonLang.get("HTITLE130")%><!-- NEGO요청 --></a>
				</span>
	<%
		}else if(user_group.equals("Q")) {
	%>
        		<span class="btn_03 mr04">
					<a href="javascript:doAction('cancleSubmit');"><%=CommonLang.get("HTITLE129")%><!-- 견적취소 --></a>
				</span>
				
				<%
					if(p110000006 == true) {
				%>
					<span class="btn_03 mr04">
						<a href="javascript:doAction('appSend');"><%=CommonLang.get("HTITLE702")%><!-- 결재상신 --></a>
					</span>
				<%
					}
				%>
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
    <input type="hidden" name="st_close_remark" id="st_close_remark"      value="">
    <input type="hidden" name="st_recv_flag" id="st_recv_flag"      value="">
	<div id="process">
	
	</div>
</form>
<!-- 애경 단가합의 결재정보 -->
<form name="aekyApprForm" id="aekyApprForm" method="post">	
	<input type="hidden" name="ak_docu_no" id="ak_docu_no" value="" />	
</form>
</div>

<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>   
</div>
</body>

<script type="text/javascript">
var popupSel = "";
var gridIndex = 0;
var btnEvent = "";
var p060000077 = "<%=p060000077%>";

// 최초 화면 함수 
function kep_onload_view(){
	
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	<%if("".equals(st_from_date)){%>
		$("#st_from_date").val(kepToDateAdd("30","M"));
		$("#st_to_date").val(kepGetNowTimeStr('YYYYMMDD','/')); 
	<%}%>
}

var st;
//기능함수
function doAction(str) {
	btnEvent = str;
	var tot_cnt = $("#display_item_cnt").val(); 
	var cnt = getCheckedRowCount(tot_cnt);
	// 선택된 항목 유무 체크
	if (str !="search" && str !="excelDown" && str != "search_quot" && str != "search_btoa" && str !="reload" && cnt <=0) {
		// 선택된 항목이 없습니다.
		alert("<%=CommonLang.msg("MSG78")%>");
		return;
	}

	switch (str) {
	case "search":	 //조회
		$('#st_sort').val("");
		kepSearch(1);
		break;
		
	case "search_quot":	 // 견적번호 소트 조회
		$('#st_sort').val("quot");
		kepSearch($("#curPage").val());
		break;
		
	case "search_btoa":	 // 견적의뢰일 소트 조회
		$('#st_sort').val("btoa");
		kepSearch($("#curPage").val());
		break;
		
	case "reload":	//초기화
		kepReload("searchForm");
		$('#st_btoa_user_dept_code').val('');
		// 조회일 초기 셋팅
		kepSetCalender("st_from_date");
		kepSetCalender("st_to_date");
		
		$("#st_from_date").val(kepToDateAdd("30","M"));
		$("#st_to_date").val(kepGetNowTimeStr('YYYYMMDD','/')); 
		$('#st_total_cnt').val('0');
// 		kepSearch(-1);
	<%if(group_mng_flag.equals("N")){%>
		jspTableClean("table_list","13");
	<%}else{%>
		jspTableClean("table_list","14");
	<%}%>
		document.getElementById("st_checkbox").checked = false;
		break;

	case "negoSubmit": // 네고요청
		if(setGridData(btnEvent)){
			// NEGO요청 하시겠습니까?
			if(!confirm("<%=CommonLang.msg("MSG359")%>")) return;
			kepAjaxFormCall("/mprq/saveBuyerMpRqUnitpriceAgrmntNegoReqList.do","processForm",btnEvent); 
		}
		break;
	case "cancleSubmit": // 취소
		if(setGridData(btnEvent)){
			/* 견적을 취소 하시겠습니까? */
			if(!confirm("<%=CommonLang.msg("MSG360")%>")) return;
			kepAjaxFormCall("/mprq/saveBuyerMpRqUnitpriceAgrmntCancleReqList.do","processForm",btnEvent); 
		}	
		break;

	case "confirmKepPrice": // 단가합의	
		if(setGridData(btnEvent)){
			/* 단가합의 하시겠습니까? */
			if(!confirm("<%=CommonLang.msg("MSG361")%>")) return;
			kepAjaxFormCall("/mprq/saveBuyerMpRqUnitpriceAgrmnt.do","processForm",btnEvent); 
		}
		break;
	
	case "printPum": // 견적서 출력
		getQuotationHiteLists();
		break;
	case "estimateClose":// 견적종료
			/* 견적종료 하시겠습니까? \n\n확인을 클릭하시면 견적종료 사유를 입력할 수 있는 창이 뜹니다. */
			if(!confirm("<%=CommonLang.msg("MSG362")%>")) return;
			doPop('closeReg');
		break;
	case "appSend": // 결재상신 (롯데칠성 특수로직)
		if(setGridData(btnEvent)){
			/* 결재상신을 하시겠습니까? */
			if(!confirm("<%=CommonLang.msg("MSG545")%>")) return;
			kepAjaxFormCall("/mprq/getBuyerMpRqAppSend.do","processForm",btnEvent); 
		}	
		break;
		case "excelDown": // 엑셀다운로드
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
			if (kepGetDateDiff('st_from_date','st_to_date','D') > 93 ){
				alert("<%=CommonLang.msg("MSG95")%>");<%-- 조회기간을 3개월 단위로 조회가 가능합니다. --%>
				return;
			}
		
			$("#st_excel_type").val("<%=exceltype%>");
		
			document.forms.searchForm.action = "/mprq/excelBuyerMpRqUnitpriceAgrmntNegoReqList.do";
			document.forms.searchForm.submit();
			break;
	}
}
function setCloseRemark(close_remark){
	document.forms.processForm.st_close_remark.value = close_remark;
	document.forms.processForm.st_recv_flag.value = "GD";
	
	if(setGridData('estimateClose')){
		kepAjaxFormCall("/mprq/saveBuyerMpRqCloseRemark.do","processForm",btnEvent);	
	}
	
}
//선택된 그리드 값을 셋팅
function setGridData(btnEvent){
	var returnValue = true;
	var chkFlag = false;
	var tot_cnt  = $("#display_item_cnt").val(); 
	//p04402707 값이 true면 반드시 네고를 해야 단가합의 및 네고요청이 가능.
    var p04402707 = "<%=p04402707%>";
    //롯데칠성 특수로직
    var p110000006 = "<%=p110000006%>";
	if (btnEvent == "negoSubmit"){ // 네고요청
  	    var box = "";
	  	var btoa_nego_price  = "";
	  	var btoa_end_date = "";

		if (tot_cnt < 2) {
			box = eval("document.forms.contentForm.checkbox0");
	            if(box.checked == true){
	            	btoa_nego_price  = document.forms.contentForm.st_btoa_nego_price2.value;
	            	btoa_end_date = document.forms.contentForm.st_btoa_end_date2.value;
	            	var st_confirm_yn= document.forms.contentForm.st_confirm_yn.value;
	            	var st_nego_yn= document.forms.contentForm.st_nego_yn.value; //네고여부
	            	var st_confirm_price = document.forms.contentForm.st_confirm_price.value; // 견적단가
	            	
	            	if(st_confirm_price == 0 || st_confirm_price == "0") {
	            		alert("<%=CommonLang.msg("MSG599")%>");
	            		return false;
	            	}
				    if(st_confirm_yn == "N"){
				    	//선택한 고객사는 네고요청 권한이 없습니다.
				    	alert("<%=CommonLang.msg("MSG79")%>");
				    	return false;
				    }
	            	//네고를 해야 단가합의 및 네고요청이 가능.
	            	if(p04402707 == true){
	            		if(st_nego_yn == "N"){
	            			//네고요청 내역이 없습니다. 네고요청 먼저 진행 바랍니다.
	            			alert("<%=CommonLang.msg("MSG543")%>");
	            			return false;
	            		}
	            	}
	            	if(kepIsValueNull(kepTrimStr(btoa_nego_price))) {
	            		//Nego단가를 입력하여 주십시요.
	                  alert("<%=CommonLang.msg("MSG80")%>");
	                  return false;
	               }

	  	           if(kepIsValueNull(kepTrimStr(btoa_end_date))) {
	  	        	   //회신요청일을 입력하여 주십시요.
	  	              alert("<%=CommonLang.msg("MSG81")%>");
	  	              document.forms.contentForm.st_btoa_end_date2.focus();
	  	              return false;
	  	           }
            }
		} else {
  	        for(var k = 0; k < tot_cnt; k++){
  	            box = eval("document.forms.contentForm.checkbox" + k);
  	            if(box.checked == true){
  	            	btoa_nego_price  = document.forms.contentForm.st_btoa_nego_price2[k].value;
  	            	btoa_end_date = document.forms.contentForm.st_btoa_end_date2[k].value;
  	            	var st_confirm_yn= document.forms.contentForm.st_confirm_yn[k].value;
  	            	var st_nego_yn= document.forms.contentForm.st_nego_yn[k].value; //네고여부
					var st_confirm_price = document.forms.contentForm.st_confirm_price[k].value; // 견적단가
	            	
	            	if(st_confirm_price == 0 || st_confirm_price == "0") {
	            		alert("<%=CommonLang.msg("MSG599")%>");
	            		return false;
	            	}
				    if(st_confirm_yn == "N"){
				    	//선택한 고객사는 네고요청 권한이 없습니다.
				    	alert("<%=CommonLang.msg("MSG79")%>");
				    	return false;
				    }
	            	//네고를 해야 단가합의 및 네고요청이 가능.
	            	if(p04402707 == true){
	            		if(st_nego_yn == "N"){
	            			//네고요청 내역이 없습니다. 네고요청 먼저 진행 바랍니다.
	            			alert("<%=CommonLang.msg("MSG543")%>");
	            			return false;
	            		}
	            	}
  	            	if(kepIsValueNull(kepTrimStr(btoa_nego_price))) {
  	            		//Nego단가를 입력하여 주십시요.
  	                  alert("<%=CommonLang.msg("MSG80")%>");
  	                  document.forms.contentForm.st_btoa_nego_price2[k].focus();
  	                  return false;
  	               }

	  	           if(kepIsValueNull(kepTrimStr(btoa_end_date))) {
	  	        	   //회신요청일을 입력하여 주십시요.
	  	              alert("<%=CommonLang.msg("MSG81")%>");
	  	              document.forms.contentForm.st_btoa_end_date2[k].focus();
	  	              return false;
	  	           }
  	            }
  	        }
		}
  	}else if(btnEvent == "confirmKepPrice"){//단가합의
  		
	  	var item_gubun = "";
	  	var doos_item_no_back = "";
    	item_gubun = document.forms.contentForm.st_item_gubun.value;
    	var st_group_mng_flag = document.forms.searchForm.st_group_mng_flag.value;
    	var st_msds_valid_flag = document.forms.searchForm.st_msds_valid_flag.value;
    	
    	
    	if (tot_cnt < 2) {
			box = eval("document.forms.contentForm.checkbox0");
	            if(box.checked == true){
	                //발주통합권한&발주결재시 해당기능 처리 안됨.
	                var st_pass_yn = document.forms.contentForm.st_pass_yn.value;
	                var st_confirm_yn= document.forms.contentForm.st_confirm_yn.value;
	                var st_nego_yn= document.forms.contentForm.st_nego_yn.value; //네고여부
	                
				    if(st_confirm_yn == "N"){
				    	//선택한 고객사는 단가합의 권한이 없습니다.
				    	alert("<%=CommonLang.msg("MSG82")%>");
				    	return false;
				    }
	            	//네고를 해야 단가합의 및 네고요청이 가능.
	            	if(p04402707 == true){
	            		if(st_nego_yn == "N"){
	            			//네고요청 내역이 없습니다. 네고요청 먼저 진행 바랍니다.
	            			alert("<%=CommonLang.msg("MSG543")%>");
	            			return false;
	            		}
	            	}
				    /*
	                if(st_pass_yn=="Y"&& st_group_mng_flag=="Y"){
	                	//선택된 고객사는 전자결재범위가 단가합의 품의이므로 처리 불가능합니다.
	                    alert("<%=CommonLang.msg("MSG83")%>");
	                    return false;            	
	                }
				    */
			    	if(item_gubun == "I"){
			    		doos_item_no_back = document.forms.contentForm.st_doos_item_no_back.value;
			        	if(kepIsValueNull(kepTrimStr(doos_item_no_back))) {
			        		//재고코드가 입력되지 않았습니다.
			                  alert("<%=CommonLang.msg("MSG84")%>");
			                  document.forms.contentForm.st_doos_item_no_back.focus();
			                  return false;
			               }	            		
			    	}
			    	if(st_msds_valid_flag == "Y"){
			    		if(document.forms.contentForm.st_msds_no.value == "MS88888888"){
			    			if(!confirm("<%=CommonLang.msg("MSG563")%>")){
			    				return false;
			    			}
			    		}
			    	}
	            }
	            
		}else{
  	        for(var k = 0; k < tot_cnt; k++){
  	            box = eval("document.forms.contentForm.checkbox" + k);
  	            if(box.checked == true){
	            	item_gubun = document.forms.contentForm.st_item_gubun[k].value;
	            	var msds_yn = document.forms.contentForm.st_msds_yn[k].value;
	                //발주통합권한&발주결재시 해당기능 처리 안됨.
	                var st_pass_yn = document.forms.contentForm.st_pass_yn[k].value;
	                var st_confirm_yn= document.forms.contentForm.st_confirm_yn[k].value;
	                var st_nego_yn= document.forms.contentForm.st_nego_yn[k].value; //네고여부
				    if(st_confirm_yn == "N"){
				    	//선택한 고객사는 단가합의 권한이 없습니다.
				    	alert("<%=CommonLang.msg("MSG82")%>");
				    	return false;
				    }
	            	//네고를 해야 단가합의 및 네고요청이 가능.
	            	if(p04402707 == true){
	            		if(st_nego_yn == "N"){
	            			//네고요청 내역이 없습니다. 네고요청 먼저 진행 바랍니다.
	            			alert("<%=CommonLang.msg("MSG543")%>");
	            			return false;
	            		}
	            	}
				    /*
	                if(st_pass_yn=="Y"&& st_group_mng_flag=="Y"){
	                	//번째 고객사는 전자결재범위가 단가합의 품의이므로 처리 불가능합니다.
	                    alert( k+1 + "<%=CommonLang.msg("MSG85")%>");
	                    return;            	
	                }
				    */
	            	if(item_gubun == "I"){
	            		doos_item_no_back = document.forms.contentForm.st_doos_item_no_back[k].value;
		            	if(kepIsValueNull(kepTrimStr(doos_item_no_back))) {
		            		//번째 재고코드가 입력되지 않았습니다.
			                  alert(k+1+"<%=CommonLang.msg("MSG86")%>");
			                  return false;
			               }	            		
	            	}
	            	if(st_msds_valid_flag == "Y"){
			    		if(document.forms.contentForm.st_msds_no[k].value == "MS88888888"){
			    			if(!confirm("<%=CommonLang.msg("MSG563")%>")){
			    				return false;
			    			}
			    		}
			    	}
  	            }
  	        }
		}
  	}
  	else if (btnEvent == "cancleSubmit"){ // 취소
		if (tot_cnt < 2) {
			box = eval("document.forms.contentForm.checkbox0");
	            if(box.checked == true){
	            	var st_cancle_remark  = document.forms.contentForm.st_cancle_remark.value;
	            	var st_confirm_yn= document.forms.contentForm.st_confirm_yn.value;
				    if(st_confirm_yn == "N"){
				    	//선택한 고객사는 견적취소 권한이 없습니다.
				    	alert("<%=CommonLang.msg("MSG87")%>");
				    	return false;
				    }
	  	            if(kepIsValueNull(kepTrimStr(st_cancle_remark))) {
	  	            	//견적취소 사유를 입력하여 주십시요.
	  	              alert("<%=CommonLang.msg("MSG88")%>");
	  	              document.forms.contentForm.st_cancle_remark.focus();
	  	              return false;
	  	           }
            }
		} else {
  	        for(var k = 0; k < tot_cnt; k++){
  	            box = eval("document.forms.contentForm.checkbox" + k);
  	            if(box.checked == true){
  	                var st_cancle_remark  = document.forms.contentForm.st_cancle_remark[k].value;
  	              	var st_confirm_yn= document.forms.contentForm.st_confirm_yn[k].value;
				    if(st_confirm_yn == "N"){
				    	//견적취소 권한이 없습니다.
				    	alert("<%=CommonLang.msg("MSG89")%>");
				    	return false;
				    }
	  	            if(kepIsValueNull(kepTrimStr(st_cancle_remark))) {
	  	            	//견적취소 사유를 입력하여 주십시요.
		  	              alert("<%=CommonLang.msg("MSG88")%>");
	  	              document.forms.contentForm.st_cancle_remark[k].focus();
	  	              return false;
	  	           }
  	            }
  	        }
		}
  	}
  	else if (btnEvent == "appSend"){
  	
    	if (tot_cnt < 2) {
			box = eval("document.forms.contentForm.checkbox0");
	            if(box.checked == true){
	            	var st_nego_yn= document.forms.contentForm.st_nego_yn.value; //네고여부    	 
	            	var st_snd_chk_yn= document.forms.contentForm.st_snd_chk_yn.value; //결재여부    	 
	            	
	            	//1차 견적건만 결재 상신
	            	if(p110000006 == "true"){
	            		if(st_nego_yn == "Y"){
	            			//네고 견적건입니다. 네고 견적건은 결재 상신이 불가합니다.
	            			alert("<%=CommonLang.msg("MSG546")%>");
	            			return false;
	            		}
	            		if(st_snd_chk_yn != "N"){
	            			//품의상신중인 문서가 존재합니다. 롯데칠성 그룹웨어에서 확인 바랍니다. 문의사항은 코리아이플랫폼(주) 담당자에게 연락 주세요
	            			alert("<%=CommonLang.msg("MSG547")%>");
	            			return false;
	            		}
	            	}
	            }
		}else{
  	        for(var k = 0; k < tot_cnt; k++){
  	            box = eval("document.forms.contentForm.checkbox" + k);
  	            if(box.checked == true){
  	            	var st_nego_yn= document.forms.contentForm.st_nego_yn[k].value; //네고여부
  	            	var st_snd_chk_yn= document.forms.contentForm.st_snd_chk_yn[k].value; //결재여부    	
	            	if(p110000006 == "true"){
	            		if(st_nego_yn == "Y"){
	            			//네고 견적건입니다. 네고 견적건은 결재 상신이 불가합니다.
	            			alert("<%=CommonLang.msg("MSG546")%>");
	            			return false;
	            		}
	            		if(st_snd_chk_yn != "N"){
	            			//품의상신중인 문서가 존재합니다. 롯데칠성 그룹웨어에서 확인 바랍니다. 문의사항은 코리아이플랫폼(주) 담당자에게 연락 주세요
	            			alert("<%=CommonLang.msg("MSG547")%>");
	            			return false;
	            		}
	            	}
  	            }
  	        }
		}
  	}
	var chkGridValue = {};
	var formArr = getFormToArr("document.forms.contentForm",chkFlag,chkGridValue);
	
	if(formArr != null && formArr !=""){
		document.forms.processForm.s_SAVENAME.value =formArr[0];
		$("#process").html(formArr[1]);
	}else{
		//그리드 데이터 변환에 실패하였습니다.[getFormToArr]
		alert("<%=CommonLang.msg("MSG13")%>");
		returnValue = false;
	}

	return returnValue;
}
/**
 * 체크 된 수
 */
function getCheckedRowCount(tot_cnt) {
	
	var chk_cnt = 0;
	if(eval(tot_cnt) < 2){
	    var box = eval("document.forms.contentForm.checkbox0");
	    if(box.checked == true) chk_cnt++;
	}else{
	    for(var j = 0; j < tot_cnt; j++){
	         var box = eval("document.forms.contentForm.checkbox" + j);
	         if(box.checked == true){
	              chk_cnt++;
	         }
	    }
	}
	return chk_cnt;
}
//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){	
	if (pMethod == "confirmKepPrice") {
		if (response.msg.usrmsg == "N"){
			alert(response.msg.msg);
			kepSearch($("#curPage").val());
			return;
		}
	} else if (pMethod == "negoSubmit") {
		var msg = response.msg.MSG;   
		if (msg != ""){
			alert(msg);
		}
	} else if (pMethod=="nonPassAgrmnt") {
		alert(response.msg.msg);
		kepSearch($("#curPage").val());
		return;
	} else if (pMethod=="APPROVAL_PRICE"){
		alert(response.msg.ATTR1);
	}
	var buyer = "<%=st_com_code%>";
	if (pMethod == 'confirmKepPrice'){
		
		if (response.msg.passflag == "N"){
			if (confirm(response.msg.msg)){
				if (response.msg.usrmsg != "N"){
					var type = "NS"; // 소싱합의
					openSearchPopup("/common/approval/buyerCommonApprovalPop.do", '?DOC_TYPE=' + type + '&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO='+response.msg.usrmsg+'&PARAM1='+buyer, "1000,500,no");
				}
			} else {
				kepAjaxFormCall("/mprq/saveBuyerMpRqUnitpriceAgrmntNonPass.do","processForm","nonPassAgrmnt"); 
			}
		} else { // 필수
			if (response.msg.buyerpopflag == "Y") {
				window.open(response.msg.callurl,"AppPop");
				doAction('search');
			} else {
				var type = "NS"; // 소싱합의
				openSearchPopup("/common/approval/buyerCommonApprovalPop.do", '?DOC_TYPE=' + type + '&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO='+response.msg.usrmsg+'&PARAM1='+buyer, "1000,500,no");	
			}
		}
	} else if (pMethod=="estimateClose") {
		alert(response.msg.msg);
		kepSearch($("#curPage").val());
		return;
	} else if (pMethod=="cancleSubmit") {
		//견적취소 처리가 되었습니다.
		alert("<%=CommonLang.msg("MSG90")%>");
		kepSearch($("#curPage").val());
		return;
	} else if (pMethod=="appSend") {
		//결재 상신 처리가 되었습니다.
		var post_url = response.APP.callback;
		var post_chk = response.APP.chk;
		var post_msg = response.APP.msg;
		
		if (post_chk == "OK"){
			window.open(post_url);
		} else {
			alert(post_msg);
		}
		kepSearch($("#curPage").val());
		return;
	}
	  else {
		// 처리후 재조회
		kepSearch($("#curPage").val());
	}
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	//단가합의 하던중 오류가 발생되었습니다.\n\n관리자에게 문의 바랍니다.
	alert("<%=CommonLang.msg("MSG91")%>");
	
} 

function kepApprovalReturn(flag,docu_no){
	kepSearch($("#curPage").val(), docu_no);		
}
//SLOGIC-BEGIN(P04-4027-03)
//하이트 강원 견적서
function getQuotationHiteLists(){
	var buyer = "";
	var c_quotation_no     = "";
	var c_quotation_seq    = "";
	var c_revision         = "";
	var query = "";
	
	var tot_cnt      = $("#display_item_cnt").val();
	if (tot_cnt < 2) {
		var checkbox			= eval("document.forms.contentForm.checkbox0");
		var li_buyer			= document.forms.contentForm.st_buyer2.value;
		var li_quotation_no     = document.forms.contentForm.st_quotation_no2.value;
		var li_quotation_seq    = document.forms.contentForm.st_quotation_seq2.value;
		var li_revision         = document.forms.contentForm.st_revision2.value;
		var agent				= document.forms.contentForm.st_agent2.value;
		buyer = document.forms.contentForm.st_buyer2.value;
		
		if(checkbox.checked==true) {

			if(isEmpty(agent) || agent=="") {
				//견적서가 생성되지 않았습니다.
				alert("<%=CommonLang.msg("MSG92")%>");
				return false;
			}
			
			query	+= li_buyer			+"$$";
			query	+= li_quotation_no	+"$$";
			query	+= li_quotation_seq	+"$$";
			query	+= li_revision			 ;
			query	+= "^||^";

			c_quotation_no  = li_quotation_no;
			c_quotation_seq = li_quotation_seq;
			c_revision      = li_revision;

		}
	} else {
		var buyerCheck = "Y";
		for(var k=0; k<tot_cnt; k++) {
        	var box2 = eval("document.forms.contentForm.checkbox" + k);
        	if(box2.checked==true) {
        		for(var z=0; z<tot_cnt; z++) {
        			var box3 = eval("document.forms.contentForm.checkbox" + z);
        			if(box3.checked==true){
        				if(document.forms.contentForm.st_buyer2[k].value != document.forms.contentForm.st_buyer2[z].value){
        					buyerCheck= "N";			
        				}
        			} 
        		}
        	}
        }
        if(buyerCheck=="N"){
        	//고객사가 다를경우 견적서 출력이 불가능합니다.
            alert("<%=CommonLang.msg("MSG93")%>");
            return;
        }
		for(var j=0; j<tot_cnt; j++) {
			
			var checkbox			= eval("document.forms.contentForm.checkbox" + j);
			var li_buyer			= document.forms.contentForm.st_buyer2[j].value;
			var li_quotation_no     = document.forms.contentForm.st_quotation_no2[j].value;
			var li_quotation_seq    = document.forms.contentForm.st_quotation_seq2[j].value;
			var li_revision         = document.forms.contentForm.st_revision2[j].value;
			var agent				= document.forms.contentForm.st_agent2[j].value;
			
			if(checkbox.checked==true) {
	
				if(isEmpty(agent) || agent=="") {
					//번째 품목은 견적서가 생성되지 않았습니다.
					alert((j+1)+"<%=CommonLang.msg("MSG94")%>");
					return false;
				}
				
				query	+= li_buyer			+"$$";
				query	+= li_quotation_no	+"$$";
				query	+= li_quotation_seq	+"$$";
				query	+= li_revision			 ;
				query	+= "^||^";
	
				c_quotation_no  = li_quotation_no;
				c_quotation_seq = li_quotation_seq;
				c_revision      = li_revision;
	
				buyer = document.forms.contentForm.st_buyer2[j].value;
			}
		}
	}
	var fileName = "";
	var param = "";
	if (	 
			buyer == "KRSNT 0001" ||
			buyer == "KRSNT 0002" ||
			buyer == "KRSNT 0003" ||
			buyer == "KRSNT 0004" ||
			buyer == "KRSNT 0005" ||
			buyer == "KRSNT 0006" ||
			buyer == "KRSNT 0007" ||
			buyer == "KRSNT 0008"   
		){  
			fileName = "RD_04_B_005_01";
			param = "["+buyer+"]["+c_quotation_no+"]["+c_quotation_seq+"]["+c_revision+"]";
 	}else if(buyer == "KRCELL0004"   ){ 
 		fileName = "RD_04_B_006_06";
		param = "["+buyer+"]["+query+"]";
 	}else{ 
	 		fileName = "RD_04_B_006_03";
			param = "["+buyer+"]["+query+"]";
		}
	  	reportOpen(fileName,param);
	  	return;
}
//SLOGIC-END
// 조회
function kepSearch(curPage, docu_no){
	if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
	if (kepGetDateDiff('st_from_date','st_to_date','D') > 93 ){
		//조회기간을 3개월 단위로 조회가 가능합니다.
		alert("<%=CommonLang.msg("MSG95")%>");
		return;
	}
	//조회그룹으로 추가.
	var st_com_code =document.forms.searchForm.st_com_code.value;
	if(st_com_code.indexOf("GROUP") >=0){
		document.forms.searchForm.st_group_info.value = st_com_code; 
	}else{
		document.forms.searchForm.st_group_info.value = "";
	}
	document.forms.searchForm.curPage.value = curPage;
	$('#searchForm').attr("action", "/mprq/getBuyerMpRqUnitpriceAgrmntNegoReqList.do").submit();	
	if(typeof docu_no !== "undefined"){
		var buyer = st_com_code;
		console.log("### st_com_code " + st_com_code);
		if(buyer == "KRAEKY0006"){
			document.forms.aekyApprForm.ak_docu_no.value = docu_no;			
			callAekyAppr();					
		}
	}

}
  
// 팝업 함수호출
function doPop(str,value1, value2, value3, value4, value5, value6, value7) {
	switch (str) {
	case "dept": // 요청부서
		popupSel = "dept";
		openSearchPopup("/common/deptCodeAdminPop.do", "?open=Y&com_code="+$('#st_com_code').val(), "500,500,no");
		break;
	case "buyerMpRqDepartmentTotalPop": // 견적번호
		<%
		//두산중공업 펀치아웃 
		//SLOGIC-BEGIN(P06-0000052)
		if(p060000052 == true) {
		%>
			openSearchPopup("/common/mprq/quotationReDetailPop.do", '?st_buyer='+value1+'&st_quotation_no='+value2+'&st_revision='+value3, "1020,500,no");
	<%}else{%>
			openSearchPopup("/mprq/showBuyerMpRqDepartmentTotalPop.do", '?st_buyer='+value1+'&st_quotation_no='+value2+'&st_revision='+value3+'&st_quotation_seq='+value4, "950,450,no");
	<%}%>
		break;
	case "agent": // 협력사
		openSearchPopup("/common/agentInfoDisplayPop.do", "?st_com_code="+value1, "800,550,no");
		break;
	case "kepManagerPop": // KeP담당자
		openSearchPopup("/common/kepManagerPop.do", "?st_user_id="+value1, "430,194,no");
		break;
	case "quotation_print": // 품목코드 클릭시 출력물 연결
		//SLOGIC-BEGIN(P04-4027-02)
		var fileName = "<%=reportid%>";
		var type = "<%=reporttype%>";
		var param =  "["+value7+"]["+value1+"]["+value2+"]["+value3+"]["+value4+"]["+value5+"]";
		if (type == "A"){
			param =  "["+value7+"]["+value1+"]["+value2+"]["+value3+"]["+value5+"]";
		} else if (type == "E"){
			var query = "";
			param =  "["+value7+"]["+value1+"]["+value2+"]["+value3+"]["+value4+"]["+query+"]";
		} else if (type == "F"){
			param =  "["+value7+"]["+value1+"]["+value2+"]["+value3+"]["+value4+"]["+value6+"]";
		}
	  	reportOpen(fileName,param);
	/*
	A	RD_04_B_004_01
	B	RD_04_M_004_03
	C	RD_04_B_006_02
	D	RD_04_B_004_05
	E	RD_04_B_006_03
	F	RD_04_B_006_04
	*/
		//SLOGIC-END
		break;
	case "attach"://파일 첨부
		popupSel = "fileUpload";
		var type="RFQ";
		var viewType="R";
		openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+value1+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부 
		break;
	case "negoreq"://네고팝업
		popupSel = "buyerMpRqNegoReqPop";
		gridIndex = value1;
		var nego_price = $('input[name=st_btoa_nego_price2]').eq(gridIndex).val();
		var btoa_end_date = $('input[name=st_btoa_end_date2]').eq(gridIndex).val();
		var reject_remark = $('input[name=st_reject_remark2]').eq(gridIndex).val();
		openSearchPopup('/mprq/showBuyerMpRqNegoReqPop.do','?st_btoa_nego_price='+nego_price+'&st_btoa_end_date='+btoa_end_date+'&st_reject_remark='+reject_remark,'400,250,no');// 파일첨부 
		break;
	case "remark"://비고		
		var viewType="R";
		var title = "ATOB";
		openSearchPopup('/common/remarkPop.do','?st_btoa_remark='+value2+'&st_atob_remark='+value1+'&viewType='+viewType+'&title='+title,'500,310,no');  
		break;
	case "confirm_remark"://단가합의 비고
		popupSel = "confirm_remark";
		var confirm_remark = $('#st_confirm_remark'+value3).val();
		var viewType="R";
		var confirmType="W";
		var title = "ATOB";
		openSearchPopup('/common/confirmRemarkPop.do','?st_btoa_remark='+value2+'&st_atob_remark='+value1+'&viewType='+viewType+'&confirmType='+confirmType+'&title='+title+'&confirm_remark='+confirm_remark+'&buyer='+value4+'&quotation_no='+value5+'&quotation_seq='+value6+'&revision='+value7+'&seq='+value3,'600,400,no');  
		break;	
		
	case "getNegoView":
		openSearchPopup('/mprq/showBuyerMpRqNegoViewPop.do','?st_buyer='+value1+'&st_quotation_no='+value2+'&st_quotation_seq='+value3+'&st_revision='+value4,'800,300,no');  
		break;
	case "getMsdsView":
		openSearchPopup("/coco/showCommonCoCoMsdsDetailPop.do","?st_msds_no="+value1+'&st_buyer='+value2+'&st_quotation_no='+value3+'&st_quotation_seq='+value4+'&st_revision='+value5, '750,580,no');
		break;	
	case "closeReg"://네고팝업
		popupSel = "buyerMpRqClosePop";

		openSearchPopup('/mprq/showBuyerMpRqClosePop.do','','400,250,no');// 파일첨부
		break;
	case "canclereq"://취소팝업		
		popupSel = "cancelRemark";
		gridIndex = value1;
		var viewType="R";
		var cancel_remark = $("input[name=st_cancle_remark]").eq(gridIndex).val();
		openSearchPopup("/common/remarkCancelPop.do",'?cancel_remark='+cancel_remark+'&viewType='+viewType,"500,230,no");
		break;
	case "delayPop"://지연팝업		
			if(value5 != ""){
 				openSearchPopup('/mpiv/getMasterMpIvQuotationSendDelayReasonPop.jsp.do','?st_buyer='+value1+'&st_quotation_no='+value2+'&st_quotation_seq='+value3+'&st_revision='+value4+'&st_modify=N','450,350,no');
 			}else{
 				alert("<%=CommonLang.msg("MSG390")%>");
 				return;
 			}
		break;
	case "kepQuotDetailInfo": //견적상세 팝업
		openSearchPopup("/common/getQuotDetailInfoPop.do", "?st_buyer="+value1+"&st_quotation_no="+value2+"&st_quotation_seq="+value3+"&st_revision="+value4, "430,210,yes");
		break;
	case "kepNegoLogInfo": //네고이력 팝업
		openSearchPopup("/common/getNegoLogInfo.do", "?st_buyer="+value1+"&st_quotation_no="+value2+"&st_quotation_seq="+value3+"&st_revision="+value4, "600,210,yes");
		break;
	}
}

// 콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text, value){
	if (popupSel == "dept") {
		$("#st_btoa_user_dept_code").val(code);
		$("#st_btoa_user_dept_name").val(text);
	} else if (popupSel == "buyerMpRqNegoReqPop") {
		$("input[name=st_btoa_nego_price2]").eq(gridIndex).val(code);
		$("input[name=st_btoa_end_date2]").eq(gridIndex).val(text);
		$("input[name=st_reject_remark2]").eq(gridIndex).val(value);
		if(code ==""){
			$("img[id=Image2]").eq(gridIndex).attr("src","/resources/images/icon2.gif");
	 	 }else{
			$("img[id=Image2]").eq(gridIndex).attr("src","/resources/images/icon.gif");
	 	 }
	} else if (popupSel == "cancelRemark") {
		$("input[name=st_cancle_remark]").eq(gridIndex).val(code);
		if(code ==""){
			$("img[id=cancleImage]").eq(gridIndex).attr("src","/resources/images/icon2.gif");
	 	 }else{
			$("img[id=cancleImage]").eq(gridIndex).attr("src","/resources/images/icon.gif");
	 	 }
	} else if (popupSel == "confirm_remark") {		
		$('#st_confirm_remark'+text).val(value);
		var atob_value = $('#st_atob_remark'+text).val();		
		if(value == "" && atob_value == "") { 
			$('#st_atob_remark_img'+text).attr('src', '/resources/images/but_icon02.gif');			
		} else {
			$('#st_atob_remark_img'+text).attr('src', '/resources/images/but_icon01.gif');	
		}
	}
}

function kepCheckAll2(){
	//전체선택/해제
	var tot_cnt      = $("#display_item_cnt").val();
// 	var check_status = $("#check_status").html();
	
	var box = eval("document.forms.contentForm.check_status");
    
	if(box.checked == true) {
		if (tot_cnt < 2) {
		   var box = eval("document.contentForm.checkbox0");
	       if(box.checked == false) box.checked = true;
		} else {
			for(var j = 0; j < tot_cnt; j++){
		       var box = eval("document.contentForm.checkbox" + j);
		       if(box.checked == false) box.checked = true;
		       
		   }
		}
	}else{
		if (tot_cnt < 2) {
	       var box = eval("document.contentForm.checkbox0");
	       if(box.checked == true) box.checked = false;
		} else {
		   for(var j = 0; j < tot_cnt; j++){
		       var box = eval("document.contentForm.checkbox" + j);
		       if(box.checked == true) box.checked = false;
		   }
		}
	}
	//SLOGIC-BEGIN(P04-4027-01)
	var buyer = "<%=com_code%>";
	if(buyer=="KRKEPB0004" || buyer=="KRDOOS0020") {
		getCheckedItemAmt();
	}
	//SLOGIC-END
}

//선택한 품목에 대한 실적단가 및 시장단가 총 금액
function getCheckedItemAmt(){

	var rate				= 0;
	var target_price_amt	= 0;
	var atob_price_amt		= 0;

	var tot_cnt  = $("#display_item_cnt").val(); 

    if(eval(tot_cnt) == 0 ){
        cnt = 0;
    }else{
    	if (tot_cnt < 2){
    		box = eval("document.forms.contentForm.checkbox0");
			if(box.checked == true){
				atob_price_amt += eval(document.forms.contentForm.st_atob_unit_price.value)*eval(document.forms.contentForm.st_item_qty.value);
				target_price_amt += eval(document.forms.contentForm.st_buyer_target_price.value)*eval(document.forms.contentForm.st_item_qty.value);
			}
    	} else {
	       for(var k = 0; k < tot_cnt; k++){
				box = eval("document.forms.contentForm.checkbox" + k);
				if(box.checked == true){
					atob_price_amt += eval(document.forms.contentForm.st_atob_unit_price[k].value)*eval(document.forms.contentForm.st_item_qty[k].value);
					target_price_amt += eval(document.forms.contentForm.st_buyer_target_price[k].value)*eval(document.forms.contentForm.st_item_qty[k].value);
				}
			}
    	}
    }

    document.forms.contentForm.st_target_price_amt.value = kepCommaNum(target_price_amt)+" <%=CommonLang.get("HTITLE660")%>";	//원
    document.forms.contentForm.st_atob_unit_price_amt.value = kepCommaNum(atob_price_amt)+" <%=CommonLang.get("HTITLE660")%>";	//원
    document.forms.contentForm.st_quotation_price_amt.value = kepCommaNum(eval(target_price_amt)-eval(atob_price_amt))+" <%=CommonLang.get("HTITLE660")%>";	//원

	if(atob_price_amt!=0) {
		rate = (eval(target_price_amt) - eval(atob_price_amt))/eval(target_price_amt)*100;
		document.forms.contentForm.st_rate.value = kepGetRound2(eval(rate), 2) + "%";
	}else {
		document.forms.contentForm.st_rate.value = "0%";
	}
}

function setTermPassFlag(){
	if($('#st_checkbox')[0].checked) {
		$("#st_term_pass_flag").val("Y");		
	} else {
		$("#st_term_pass_flag").val("N");
		
	}
}
function callAekyAppr(){
	kepAjaxFormCallAsync("/mpso/buyerNewCreateOrder.do","aekyApprForm","APPROVAL_PRICE");
}

function kepAjaxFormCallAsync(pUrl,pForm,pMethod) {    
	loader_obj("Y");
	$.ajax({
		      type: "POST",
		      dataType:"json",
		      url: pUrl,
		      headers: { 'X-Requested-With': 'XMLHttpRequest' },
		      data: $("#"+pForm+"").serialize(),
		      timeout: 600000, //milisecond기준 10분(600000ms) TIMEOUT
		      async: false,
		      success:function( response ) {
		    	 loader_obj("N");
		    	 if(typeof response.Message != 'undefined'){
		    		 kepAjaxError(pMethod , response); // 화면에 필수적으로 있어여한다. (Exception 발생)
		    		 return;
		    	} 
		    	 kepAjaxSuccess(pMethod , response); // 화면에 필수적으로 있어여한다.
			   },
			   error:function( response, textStatus) {				   
				   	loader_obj("N");
				   	if(textStatus == 'timeout'){
				   		response.Message = "응답시간이 초과되었습니다. 잠시 후 다시 이용해주세요.";
				   	} 				   	
				 	//403코드 리턴(로그인 세션 없음)시는  sub_login페이지로 redirect
				if(response.status == '403'){
					alert("로그아웃 되셨습니다. 재 로그인하여 주십시오.");
					location.href = "/login/sub_login.do";
					return;
				} 				  
				kepAjaxError(pMethod , response); // 화면에 필수적으로 있어여한다.
			   }
		});  
}


</script>
</html>
