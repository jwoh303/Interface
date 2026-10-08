<%--
**********************************************
* 메뉴 : 발주관리>구매요청접수
* 화면 : 구매요청접수
* 기능 : 구매요청 건을 조회하여 내용을 확인하고 구매발주 승인/반려/보류 처리 하기 위한 화면
* 프로그램 ID : PG_06_B_016_00
* 담당자 : CEJ ( 설계 : 김지현 )
* 착수일 : 2014-06-24
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<script src="/resources/js/kep_buyer.js"></script> 
</head>
<%
	// 공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	 
	String pre_goods_count = (String)request.getAttribute("pre_goods_count"); //선입고발주 제외대상 업체 조회
	
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수) 
	String curPage2 = CommonUtil.nvl((String) request.getParameter("curPage"),""); // 현재페이지  (필수) 
	  
	String tot_cnt_string = "";
    int tot_cnt = 0;                                    //전체데이타row수
    int rec_cnt = 0;
    int page_display_cnt = 0;
    
 
    String curDate   = CommonUtil.formatDateNoDateGubun(new Date(),1);
    String st_from_date  = "";
    String st_to_date    = "";
    st_from_date        = CommonUtil.nvl((String) request.getParameter("st_from_date"),"");
    if( st_from_date.equals("")){    	
    	st_from_date    = CommonUtil.addDate(new Date(),"M",-3,1);
    	st_from_date = CommonUtil.formatStrinigDate(st_from_date);
    }else{
    	st_from_date    = CommonUtil.nvl((String) request.getParameter("st_from_date"),"");    	
    }
    
    
    st_to_date        = CommonUtil.nvl((String) request.getParameter("st_from_date"),"");
    if( st_to_date.equals("")){    	
    	st_to_date    = CommonUtil.formatDateNoDateGubun(new Date(),1);
    	st_to_date = CommonUtil.formatStrinigDate(st_to_date);
    }else{
    	st_to_date    = CommonUtil.nvl((String) request.getParameter("st_to_date"),"");    	
    } 
   
    		
    		
    		
    String buyer             = "";
    String SessionComCode             = "";
    String zip_code          = "";
    String SessionUserId            = "";
    String userName          = "";
    String SessionUserDept          = ""; 
    String userTel           = "";
    String email             = "";
    String fax_no            = "";
    String mobile            = "";

    String SessionComorgLevel = "";
    String SessionComorgCode  = "";
    String using_catal_type  = "";
    String location_code     = "";
    String location_name     = "";
    String purchaseDeptCode  = "";
    String purchaseDeptName  = ""; 
    
    String row_cnt  = ""; 
    String img_view_flag  = ""; 
    String budget_flag   = ""; 
    String SessionAgentOpenFlag = ""; 
    
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	if (sessionInfo != null){ 
      buyer             = sessionInfo.getComCode();      
      SessionComCode             = sessionInfo.getComCode();      
      SessionUserId            = sessionInfo.getUserId();
      userName          = sessionInfo.getUserNameLoc();
      SessionUserDept          = sessionInfo.getDepartment(); 
      userTel           = sessionInfo.getTel();
      email             = sessionInfo.getEmail();
      fax_no            = sessionInfo.getFax();
      mobile            = sessionInfo.getmPhone();
      using_catal_type  = sessionInfo.getUsingCatalType();
      
      zip_code          = sessionInfo.getZipCode();
      SessionComorgLevel = sessionInfo.getBycaComorgLevel();
      SessionComorgCode  = sessionInfo.getBycaComorgCode();      
      location_code     = CommonUtil.nvl(sessionInfo.getDelyToLocation());
      location_name     = CommonUtil.nvl(sessionInfo.getDelyToLocationName());
      purchaseDeptCode  = sessionInfo.getPurchaseDept();
      purchaseDeptName  = sessionInfo.getPurchaseDeptName();
      
  	  row_cnt = sessionInfo.getRowCnt(); //20070704 추가 페이지 기본 개수
      img_view_flag = sessionInfo.getImgViewFlag(); // 20070704 이미지보기 우선여부
       
      budget_flag           = sessionInfo.getBudgetFlag();
      SessionAgentOpenFlag  = sessionInfo.getAgentOpenFlag();
	}
    
	// 조회조건 S
    String req_dept_name        = CommonUtil.nvl((String) request.getParameter("st_req_dept_name"),"");
    String req_dept_code        = CommonUtil.nvl((String) request.getParameter("st_req_dept_code"),"");
    String add_user_name        = CommonUtil.nvl((String) request.getParameter("st_add_user_name"),"");
    String pr_no        = CommonUtil.nvl((String) request.getParameter("st_pr_no"),"");
    String st_check           = CommonUtil.nvl((String) request.getParameter("st_check"),"");
    String search_type   = CommonUtil.nvl((String) request.getParameter("st_search_type"),"");
    String search_code        = CommonUtil.nvl((String) request.getParameter("st_search_code"),"");
    
    boolean p060000010 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000010"); // KRCONT0006
    boolean p060000017 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000017"); // KRJINR0007
    boolean p060000011 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000011"); // KRJINR0004 KRJINR0005 KRJINR0007 
    //신용카드, 계좌이체 결재수단 COL01_DATA=Y 결재 필수
    Map<String, String> p060000043_map	= CommonUtil.getSpecialCheckReturnMap(buyer,"P06-0000043");
    boolean p060000043_yn		= false;
    //결재수단 Y면 필수 결재
    if (p060000043_map != null) {
    	p060000043_yn = true;
    }  
    if(st_check.equals(""))
    {
    	//SLOGIC-BEGIN(P06-0000010)
		//콘티넨탈오토모티브시스템(주)
		if(p060000010 == true){
			st_check = "SEARCH"; // 로딩시 바로 조회할 경우 주석 해제
		}     
		 //SLOGIC-END
    }
	String sort_column           = CommonUtil.nvl((String) request.getParameter("st_sort_column"),"ALL"); 
	String sort_flag           = CommonUtil.nvl((String) request.getParameter("st_sort_flag"),"ASC"); 
	// 조회조건 E
	String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),row_cnt); // 정렬갯수
 	//고객사 그룹통합여부 여부
 	String st_user_id = _sessionInfo.getUserId();
	boolean getCodeTGCM = CommonUtil.getCode3CheckReturn("TGCM", st_user_id, buyer);
	String group_mng_flag = "N";
	String st_buyer_select = CommonUtil.nvl((String) request.getParameter("st_com_code2"),"");  // 계열사정보
	if(getCodeTGCM == true){
		group_mng_flag = "Y"; 
	}
	
	//엑셀다운로드기능 통제 
	boolean p170000001 = CommonUtil.getSpecialCheckReturn(buyer,"P17-0000001");
	//관리번호 입력기능 활성화
	boolean p060000113 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000113");
	//관리번호 필수값체크 메세지
	String p060000113_type = CommonUtil.nvl(CommonUtil.getSpecialCheckReturn(buyer,"P06-0000113","COL01_DATA"),"");
	//구매발주 알림기능
	String p060000130_col01 = ""; // 고객사 품목코드
	String p060000130_col02 = ""; // 알림 메시지
	Map<String, String> p060000130_map	= CommonUtil.getSpecialCheckReturnMap(buyer,"P06-0000130");
	if(p060000130_map != null){
	 	p060000130_col01 = CommonUtil.nvl(p060000130_map.get("COL01_DATA"), p060000130_col01);
	 	p060000130_col02 = CommonUtil.nvl(p060000130_map.get("COL02_DATA"), p060000130_col02);
 	}
	// 구매요청접수 구매발주시 체크된 주문의 부서만 예산 체크
	boolean p060000134 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000134");
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
	<h3><%=CommonLang.get("HTITLE234") %><!-- 구매요청접수 --></h3>
	<!--버튼영역-->
     <div id="searchBtnA">
     	<span class="btn_search" title="조회"><a href="javascript:doAction('search');"><%=CommonLang.get("HTITLE7") %><!-- 조회 --></a></span> 
		<span class="btn_reset" title="초기화"><a href="javascript:doAction('kep_reload');"><%=CommonLang.get("HTITLE8") %><!-- 초기화 --></a></span>
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
		<input type="hidden" name="st_group_mng_flag" id="st_group_mng_flag" value="<%=group_mng_flag%>">
		
		<input type="hidden" name="st_check" value ="<%=st_check%>"> 
		<input type="hidden" name="page_type"value ="">
		<input type="hidden" name="st_query"            value="">
		<input type="hidden" name="st_y_position"       value="">
		<input type="hidden" name="st_bdgt_query"       value="">   <!-- 예산 계정 체크위해 추가 20050401 -->
		<input type="hidden" name="st_pr_return_type"   value="PR"> <!-- 예산 계정 PR ==> PR_NO , PX ==> REF_NO 이용해서 , 구매요청 반려시 예산 차감 -->
		<input type="hidden" name="st_fromDate" value="<%=st_from_date%>">
		<input type="hidden" name="st_toDate"   value="<%=st_to_date%>">
		<input type="hidden" name="st_account_type_code"    value="">
		<input type="hidden" name="st_buyer"                value="<%=SessionComCode%>">
		<input type="hidden" name="comCode"                value="<%=SessionComCode%>">
		<input type="hidden" name="userID"                  value="<%=SessionUserId%>">
		<input type="hidden" name="userDept"                value="<%=SessionUserDept%>">
		<input type="hidden" name="reqDept"                 value="">
		<input type="hidden" name="st_byca_comorg_code"     value="<%=SessionComorgCode%>">
		<input type="hidden" name="st_byca_comorg_level"    value="<%=SessionComorgLevel%>">
		<input type="hidden" name="st_using_catal_type"     value="<%=using_catal_type%>">
		<input type="hidden" name="st_add_user_tel"         value="<%=userTel%>">
		<input type="hidden" name="st_agent_open_flag"      value="">
		<input type="hidden" name="file_get_y"              value="">
		<input type="hidden" name="reject"                  value="N">
		<input type="hidden" name="x"                       value="">
		<input type="hidden" name="y"                       value="">
		<input type="hidden" name="st_check_setQuery"       value="">
		<input type="hidden" name="st_sort_column"			value="<%=sort_column%>">
		<input type="hidden" name="st_sort_flag"			value="<%=sort_flag%>">
		
		<input type="hidden" name="st_gr_flag" size="10" value="N">
		<!--   Login Buyer Code 입력 -->
		<input type="hidden" name="st_notify"  value="<%=SessionComCode%>">
		<!--   Sample Flag 입력 -->
		<input type="hidden" name="st_sample_flag" value = "N">
		<!-- Current Date -->
		<input type="hidden" name="currentDate" size="10" maxlength="10" value="<%= curDate %>">
		<input type="hidden" name="ToDateTemp" size="10" value="<%=CommonUtil.formatStrinigDate(new Date(),1)%>">
		<!--   new_item : JTABLE의 제품코드 click시에 사용   -->
		<input type="hidden" name="chknc"           value="NO">
		<input type="hidden" name="y"               value="null">
		<input type="hidden" name="list"            value="create">
		<input type="hidden" name="file_get_y"      value="">
		<input type="hidden" name="st_ref_no_sub"   value="">
		<input type="hidden" name="st_item_no_sub"  value="">
		<input type="hidden" name="gw_no_new"       value="">
		<input type="hidden" name="recv_flag_new"   value="">
		<input type="hidden" name="as_flag_new"     value="">
		<input type="hidden" name="payment_new"     value="">
		<input type="hidden" name="nu_end_price"    value="">
		<!--   이니시스 거래명세서 출력시 사용할 PXnumber -->
		<input type="hidden" name="pxnumber"  value="">
		<!--   일부품목 카드 결제를 위한 변수  2002/07/27   -->
		<input type="hidden" name="multi_flag"    value="">     <!--  구매대행발주와  카드결제 발주가 동시에 생성되는지 여부 -->
		<input type="hidden" name="payment_flag"  value="">     <!--  카드결제 여부                                   -->
		<input type="hidden" name="cc_flag"       value="">     <!--  카드결제 품목 리스트                                -->
		<input type="hidden" name="cs_flag"       value="">     <!--  현금결제 품목 리스트                                -->
		<input type="hidden" name="popup_flag"    value="">     <!--  팝업창 종료여부(임시저장목록에서 발주시 사용)       -->
		<input type="hidden" name="delete_flag"   value="">     <!--  현금결제 품목 리스트        -->
		<input type="hidden" name="st_group_info" id="st_group_info" value="">
		<div id="cont_searchA">	
			<table class="cont_t_list01"  >
				<caption><%=CommonLang.get("HTITLE234") %><!-- 조회 --></caption>
				<colgroup>
                    <col width="6%" />
                    <col width="19%" />
                    <col width="6%" />
                    <col width="19%" />
                    <col width="6%" />
                    <col width="19%" />
                    <col width="8%" />
                    <col width="19%" />
				</colgroup>
				
				<tbody>
				
				<tr>
					<th><%=CommonLang.get("HTITLE220") %><!-- 요청일 --></th>
					<td colspan="3">
						<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:15%; text-align:center;" value="<%=st_from_date%>">
							<a href="javascript:kepCalendar('st_from_date')"></a>
						 - 
						<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:15%; text-align:center;" value="<%=st_to_date%>">
							<a href="javascript:kepCalendar('st_to_date')"></a> 	
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1<%=CommonLang.get("HTITLE602") %><!-- 개월 --></a></span>  
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3<%=CommonLang.get("HTITLE602") %><!-- 개월 --></a></span>			
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','6')">6<%=CommonLang.get("HTITLE602") %><!-- 개월 --></a></span>
							<span class="btn_month"><a href="javascript:setCurMonth('st_from_date','st_to_date')">당월</a></span>						
					</td>                       
					<%if(group_mng_flag.equals("Y")){%>
					     <th><%=CommonLang.get("HTITLE604") %><!-- 고객사 --></th>
					      <td >
					        <select name="st_com_code2" id="st_com_code2" style="width:90%;height:20px;">
					        	<%= CommonUtil.getCode3ComboList(_sessionInfo.getComCode(), "ALL", "TGCM",_sessionInfo.getUserId(), "ICOMCOD3", st_buyer_select, "") %>
					        </select>
					      </td>
					<%}else{%>													  
					      <th></th>
					      <td ><input type="hidden" name="st_com_code2" id="st_com_code2" value="${sessionInfo.comCode}"></td>					      
					 <%}%>
				</tr>
				<tr>
					<th><%=CommonLang.get("HTITLE135") %><!-- 요청부서 --></th>
					<td>
						<input type="text" class="input_type_text" name="st_req_dept_name" id="st_req_dept_name" style="width:55%;ime-mode:active" value="<%=req_dept_name%>" READONLY>
						<input type="hidden" name="st_req_dept_code" id="st_req_dept_code" value="<%=req_dept_code%>">
						<a href="javascript:getDepartmentCode();"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
						<a href="javascript:kepEraser('st_req_dept_code','st_req_dept_name');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
					</td>
					<th><%=CommonLang.get("HTITLE240") %><!-- 요청자명 --></th>
						      <td>
							<input type="text" class="input_type_text" name="st_add_user_name" id="st_add_user_name" style="width:87%;" value="<%=add_user_name%>" onKeyDown="kepEnter()">
					</td>
                       	<th><%=CommonLang.get("HTITLE216") %><!-- 요청번호 --></th>
						<td>
							<input type="text" class="input_type_text" name="st_pr_no" id="st_pr_no" style="width:87%;" value="<%=pr_no%>" onkeyup="kepToUpper('st_pr_no')" onKeyDown="kepEnter()">
						</td>   
						<th>
							<select id = 'st_search_type' name = "st_search_type" class="TitSelect">
								<option <%=(search_type.equals("RN")? "selected" : "")%> value = "RN"><%=CommonLang.get("HTITLE18")%><!-- 관리번호 --></option>
								<option <%=(search_type.equals("CN")? "selected" : "")%> value = "CN"><%=CommonLang.get("HTITLE512")%><!-- 카테고리명 --></option>
								<option <%=(search_type.equals("BN")? "selected" : "")%> value = "BN"><%=CommonLang.get("HTITLE13")%><!-- 품목명 --></option>
							</select>
						</th>
						<td>
							<input type="text" class="input_type_text" name="st_search_code" id="st_search_code" style="width:85%;" value="<%=search_code%>" onKeyDown="kepEnter()">
						</td>
					</tr>
				</tbody>
			</table>
		</div>
 		
 		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
	      	<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow" onchange="kepSearch(1);"> 
				<option <%=(onepagerow.equals("10") ? "selected" : "")%> value = "10">10<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
				<option <%=(onepagerow.equals("20") ? "selected" : "")%> value = "20">20<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
				<option <%=(onepagerow.equals("30") ? "selected" : "")%> value = "30">30<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
				<option <%=(onepagerow.equals("40") ? "selected" : "")%> value = "40">40<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
				<option <%=(onepagerow.equals("50") ? "selected" : "")%> value = "50">50<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
				<option <%=(onepagerow.equals("100") ? "selected" : "")%> value = "100">100<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
				<option <%=(onepagerow.equals("200") ? "selected" : "")%> value = "200">200<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
				<option <%=(onepagerow.equals("500") ? "selected" : "")%> value = "500">500<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
				<option <%=(onepagerow.equals("1000") ? "selected" : "")%> value = "1000">1000<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
				<option <%=(onepagerow.equals("2000") ? "selected" : "")%> value = "2000">2000<%=CommonLang.get("HTITLE595") %><!-- 건 --></option>
			</select>
      	</span>      
       <span class="fr"><b><%=CommonLang.get("HTITLE172") %><!-- 총 금액 --> :</b> 
       <input type="text" name="st_sum_price" class="input_type_text" size="14" value=""  style="background-color:#FFFFFF;font-weight: bold;font-size:9pt;text-align:right;border:#FFFFFF 1px solid;" READONLY><b><%=CommonLang.get("HTITLE660") %><!-- 원 --></b></span>
       	<br>
	</form> 
	<form name = "contentForm" id="contentForm" method = "post"> 
	<input type="hidden" name="st_po_create_date" size="10" value="<%=curDate%>">
		<table id="table_list" class="cont_t_list02" >
			<colgroup>
	            <col width="3%" />
			<%if(group_mng_flag.equals("Y")){%>
				<col width="8%" />
			<%}%>
	            <col width="10%" />
	            <col width="8%" />
	            <col width="10%" />
	            <col width="*" />
	        <%if(budget_flag.equals("Y")){%>
	        	<col width="8%" />
	            <col width="8%" />	            
	            <col width="8%" />
	            <col width="8%" />
	            <col width="10%" />
	        <% } else { %>
	        	<col width="12%" />
	            <col width="12%" />
	            <col width="8%" />
	            <col width="10%" />
	        <% } %>    
	            
			<%if(p060000043_yn==true){%>			
				<col width="5%" />
			<%}%>
	        </colgroup>
	        <thead>
			<tr>
				<th scope="col">
<%
if (_gridList == null || _gridList.size() == 0){
}else{
%>				
					<input type="checkbox" name="check_status" id="check_status" value="선택"  style="cursor:pointer;" onclick="kepCheckAll(document.forms.contentForm.display_item_cnt.value,document.forms.contentForm.check_status,'document.forms.contentForm.lnCheck');sum_price();">
				<%} %>
				</th>
				<%if(group_mng_flag.equals("Y")){%>
						<th scope="col"><%=CommonLang.get("HTITLE290") %><!-- 고객사코드 --><br><%=CommonLang.get("HTITLE291") %><!-- 고객사명 --></th>
				<%}%>
                <th scope="col"><a href="javascript:setSortingList('REQ_DEPT');"><%=CommonLang.get("HTITLE135") %><!-- 요청부서 --></a><br><a href="javascript:setSortingList('PR_NO');"><%=CommonLang.get("HTITLE216") %><!-- 요청번호 --></a></th>
                <th scope="col"><%=CommonLang.get("HTITLE239") %><!-- 요청자ID --><br><%=CommonLang.get("HTITLE240") %><!-- 요청자명 --></th>
                <th scope="col"><a href="javascript:setSortingList('BUYER_ITEM_NO');"><%=CommonLang.get("HTITLE12") %><!-- 품목코드 --></a><br><a href="javascript:setSortingList('CHANGE_DATE');"><%=CommonLang.get("HTITLE220") %><!-- 요청일 --></a></th>
                <th scope="col"><%=CommonLang.get("HTITLE13") %><!-- 품목명 --><br><%=CommonLang.get("HTITLE14") %><!-- 규격 --></th>
                <th scope="col"><%=CommonLang.get("HTITLE241") %><!-- 요청수량/단위 --><br><%=CommonLang.get("HTITLE242") %><!-- 승인수량 --></th>
                <th scope="col"><%=CommonLang.get("HTITLE174") %><!-- 단가 --><br><%=CommonLang.get("HTITLE204") %><!-- 금액 --></th>
                <%if(budget_flag.equals("Y")){%>
	        		<th scope="col"><%=CommonLang.get("HTITLE268") %><!-- 예산부서 --><br><%=CommonLang.get("HTITLE966") %><!-- 예산계정 --></th>
	        	<% } %>                
                <th scope="col"><a href="javascript:setSortingList('RD_DATE');"><%=CommonLang.get("HTITLE243") %><!-- 납기요청일 --></a><br><a href="javascript:setSortingList('AGENT_CODE');"><%=CommonLang.get("HTITLE144") %><!-- 협력사 --></a></th>
                <th scope="col"><a href="javascript:setSortingList('REF_PR_NO');"><%=CommonLang.get("HTITLE18") %><!-- 관리번호 --></a><br><%=CommonLang.get("HTITLE253") %><!-- 결재유무 --> / <a href="javascript:remarkCopy();"><%=CommonLang.get("HTITLE122") %><!-- 비고 --></a></th>
                <%if(p060000043_yn==true){%>
                	<th scope="col"><%=CommonLang.get("HTITLE644") %><!-- 카드여부--></th>
                <%}%>
			</tr>
		</thead>
		<tbody>
 		<%
        if (_gridList == null || _gridList.size() == 0){
        %>
                    <tr>
                        <%if(group_mng_flag.equals("Y")){%>
                        <td colspan="11" align="center" height = "50">
					<%}else{%>
						<td colspan="10" align="center" height = "50">
					<%}%>
                        <span><%=CommonLang.msg("MSG347") %><!-- 조회된 데이타가 없습니다. --></span>
                        </td> 
                    </tr>
        <%
        }else{
        	 
        	//Map<String,String> rtobj = _gridList.get(0);
            //tot_cnt = Integer.parseInt(rtobj.get("rtobj.searchForm"));
            //tot_cnt_string = rtobj.get("rtobj.searchForm");      	        	
			for (int j=0; j<_gridList.size(); j++) {				
				Map<String,String> rowData = _gridList.get(j);
				String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
				String ref_pr_text = rowData.get("REF_PR_NO");
						 if(SessionComCode.equals("KRJINR0005")){
							ref_pr_text = rowData.get("REF_PR_TEXT");
						 }
		%> 
				<tr align="center" bgcolor="<%=tclass%>">
					<td><input type="checkbox" name="lnCheck<%=j%>" value="<%=rowData.get("BUYER")+"@@"+rowData.get("PR_NO")+"@@"+rowData.get("PR_SEQ")%>"  onClick="sum_price()">
					
					
  				 <input type="hidden"   name="st_reject_reason"      value=""> <!--(i+1)-->
                <input type="hidden"   name="db_qty"                value="<%=rowData.get("RECV_QTY")%>">  <!--(i+2)-->
                <input type="hidden"   name="db_price"              value="<%=rowData.get("UNIT_PRICE")%>">  <!--(i+3)-->
                <input type="hidden"   name="db_rd_date"            value="<%=rowData.get("RD_DATE")%>"> <!--(i+4) 납기예정일 수정으로인해 <%=j%>부분 삭제 , 다른 변수값들도 <%=j%>부분 삭제하는 방향으로 코딩해야함  , setRdDate() 참조-->
                <input type="hidden"   name="db_pay_terms"          value="<%=rowData.get("PAY_TERMS")%>"> <!--(i+5)-->
                <input type="hidden"   name="db_pr_no"              value="<%=rowData.get("PR_NO")%>">  <!--(i+6)-->
                <input type="hidden"   name="db_pr_seq"             value="<%=rowData.get("PR_SEQ")%>"> <!--(i+7)-->
                <input type="hidden"   name="db_total"              value="">                               <!--(i+8)-->
                <input type="hidden"   name="db_dbgt_flag"          value="<%=rowData.get("BDGT_FLAG")%>"> <!--(i+9)-->
                <input type="hidden"   name="db_fixed_price_flag"   value="<%=rowData.get("FIXED_PRICE_FLAG")%>"> <!--(i+10)-->
                <input type="hidden"   name="db_account_type"       value="<%=rowData.get("ACCOUNT_TYPE")%>"> <!--(i+11)-->
                <input type="hidden"   name="db_ref_no"             value="<%=rowData.get("REF_PR_NO")%>"> <!--(i+12)-->
                <input type="hidden"   name="db_return_reason"      value="<%=rowData.get("RETURN_REASON")%>"> <!--(i+13)-->
                <input type="hidden"   name="db_gr_flag"            value="<%=rowData.get("DOC_TYPE")%>"> <!--(i+14)-->
                <input type="hidden"   name="db_old_amt"            value="<%=rowData.get("AMT")%>"> <!--(i+15)-->
                <input type="hidden"   name="db_req_dept"           value="<%=rowData.get("CHANGE_USER_DEPT")%>"> <!--(i+16)-->
                <input type="hidden"   name="st_pr_no_sel"          value="<%=rowData.get("PR_NO")%>">
                <input type="hidden"   name="st_pr_seq_sel"         value="<%=rowData.get("PR_SEQ")%>">
                <input type="hidden"   name="st_com_code"           value="<%=SessionComCode%>">
				<input type="hidden"   name="pr_remark"             value="<%=rowData.get("REMARK")%>">
				<input type="hidden"   name="po_remark"             value="<%=rowData.get("REMARK")%>"> 
                <!-- 예산 관련 추가 -->
                <input type="hidden" name="st_account_type"     value="<%=rowData.get("ACCOUNT_TYPE")%>">
                <input type="hidden" name="st_budget_dept"      value="<%=rowData.get("BUDGET_DEPT")%>">
                <input type="hidden" name="st_plan_amt_flag"    value="<%=rowData.get("PLAN_AMT_FLAG")%>">
                
				<input type="hidden"   name="st_dt_buyer_code"     id="st_dt_buyer_code"    value="<%=rowData.get("BUYER")%>">
				<input type="hidden"   name="st_pass_yn"     id="st_pass_yn"    value="<%=rowData.get("PASS_YN")%>">
				<input type="hidden"   name="st_confirm_yn"     id="st_confirm_yn"    value="<%=rowData.get("CONFIRM_YN")%>">
				<input type="hidden"   name="db_buyer_item_no"  value="<%=rowData.get("BUYER_ITEM_NO")%>"> 
	          </td>
				<%if(group_mng_flag.equals("Y")){%>
					<td title="고객사코드/고객사명">
						<%=String.valueOf(CommonUtil.nvl(rowData.get("BUYER")))%><br>
						<%=String.valueOf(CommonUtil.nvl(rowData.get("BUYER_NAME_LOC")))%>
					</td>
				<%}%>
	          <td title="요청부서/요청번호"> 
	          	<a class="hyperLink" href="javascript:getNewDepartmentDisplayPop('<%=SessionComCode%>','<%=rowData.get("CHANGE_USER_DEPT")%>');"><%=rowData.get("REQ_DEPT")%></a><br>
				<a class="hyperLink" href="javascript:getPrDisplayPop('<%=rowData.get("BUYER")%>','<%=rowData.get("PR_NO")%>' ,'<%=rowData.get("GUYLJAE_FLAG")%>','PR_LIST_IN','<%=CommonUtil.nvl(rowData.get("RECV_FLAG"))%>')"><%=rowData.get("PR_NO")%></a>
	          </td>
	          <td title="요청자ID/요청자명"> 
	          <%=rowData.get("ADD_USER_ID")%><br>
				<%=rowData.get("ADD_USER_NAME")%>
	          </td>
	          <td  title="품목코드/요청일">
	             <a class="hyperLink" href="javascript:getBuyerCatalogDisplayPop('<%=rowData.get("BYIT_COMORG_CODE")%>', '<%=rowData.get("BUYER_ITEM_NO")%>','<%=rowData.get("CONTRACT_NO")%>', '<%=rowData.get("CONTRACT_SEQ")%>');"><%=rowData.get("BUYER_ITEM_NO")%></a><br>
				<%=CommonUtil.formatStrinigDate(rowData.get("CHANGE_DATE"))%>
	             </td>
	          <td class="left" title="품목명/규격"> 
	          <%=rowData.get("DESCRIPTION")%><br>
				<%=rowData.get("SPECIFICATION")%>
	          </td>
	          <td class="right"  title="요청수량/승인수량"> 
	          <%=CommonUtil.formatNumber(rowData.get("TARGET_QTY"),true,0,3)%>&nbsp;/&nbsp;<%=rowData.get("UNIT_MEASURE")%><br>            
	                    <input type="text"   name="target_qty" size="7" id="text" class="input_type_text"  style="text-align:right;" value="<%=CommonUtil.formatNumber(rowData.get("RECV_QTY"),true,0,3)%>" onChange="update_qty(<%=j%>)" >
	                    <input type="hidden" name="req_qty"  value="<%=CommonUtil.formatNumber(rowData.get("TARGET_QTY"),true,0,3)%>" >
	                    <input type="hidden" name="st_temp_qty" value="<%=rowData.get("RECV_QTY")%>">
	                
	          </td>
	          <td class="right" title="단가/금액"> 
	                    <%=CommonUtil.formatNumber(rowData.get("UNIT_PRICE"),true,0,3)%><br> <input type="hidden" name="buy_price" value="<%=CommonUtil.formatNumber(rowData.get("UNIT_PRICE"),true,0,3)%>" >
						<input type="text" name="item_amt" size="11" class = "input_type_text" style="text-align:right; background-color:<%=tclass%>;height=16;font-size:9pt;border:<%=tclass%> 1px solid; " value="<%=CommonUtil.formatNumber(rowData.get("AMT"),true,0,3)%>" READONLY >
	                
	          </td>
	          <%if(budget_flag.equals("Y")){%>
		          <td title="예산부서/예산계정"> 
		        	<%=rowData.get("BUDGET_DEPT_NAME")%><br>
					<%=rowData.get("ACCOUNT_NAME")%>
		          </td>
	          <%} %>
	          <td  title="납기요청일/협력사">  
	                    <input type="text"   name="rd_date_text" size="11" class = "input_type_text" style="background-color:<%=tclass%>;height=16;font-size:9pt;border:<%=tclass%> 1px solid;" value="<%=CommonUtil.formatStrinigDate(rowData.get("RD_DATE"))%>"  READONLY >
	                <br><a  class="hyperLink" href="javascript:getAgentDisplayPop('<%=rowData.get("AGENT_CODE")%>');"><%=rowData.get("AGENT_NAME")%></a>
	          </td>
	          <td  title="관리번호/결재번호"> 
	          		<%	//관리번호 수정 기능.
	          			if(p060000113==true){
	          		%>
	          				<input type="text"   name="st_ref_pr_no"  id="st_ref_pr_no" class="input_type_text"  style="text-align:left;" value="<%=ref_pr_text%>" >
	          		<%
	          			}else{
	          		%>
	          				<%=ref_pr_text%>
	          		<%
	          			}
	          		%>
	                
	              	<br>
	                &nbsp;&nbsp;<%=rowData.get("GUYLJAE_FLAG")%>
				<%= (rowData.get("DOC_TYPE").equals("S"))?" / <font color=red>선입고</font>":""%> /  
					<%
						if(rowData.get("REMARK").equals("")) { 
						%>  
						<a href="javascript:setPoRemark(<%=j%>,'<%=rowData.get("BUYER")%>','<%=rowData.get("PR_NO")%>','<%=rowData.get("PR_SEQ")%>','<%=rowData.get("REMARK")%>');"><img name="Image2" src="/resources/images/icon2.gif" border="0"></a>
					<%}else{
							
						%>
						<a href="javascript:setPoRemark(<%=j%>,'<%=rowData.get("BUYER")%>','<%=rowData.get("PR_NO")%>','<%=rowData.get("PR_SEQ")%>','<%=rowData.get("REMARK")%>');"><img name="Image2" src="/resources/images/icon.gif" border="0"></a>
					<%}  
						%> 
                <%if(p060000043_yn==true){%>
			          <td title="카드여부"> 
			          <%=String.valueOf(CommonUtil.nvl(rowData.get("CARD_USE_FLAG")))%>
			          </td>
                <%}%>
	          </td>
						 
 
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
<br>
		<!-- 버튼영역 -->
		<%if(group_mng_flag.equals("N")){%>
		<div class="btnArea">
			<div class="fl">
					<table>
						<tr>
							<td><%=CommonLang.get("HTITLE245") %><!-- 부서이관 --> </td><td width="5">
							</td><td>
							<select name="purchaserDept"> 
							                             <%
                             Map<String, String> _map = new HashMap<String, String>();
                             _map.put("company_code",SessionComCode);
                             %>
                             	<%= CommonUtil.getCodeComboQueryIdList("buyer.mppo.getDeptCombo2","SEL",_map,"") %> 
							</select>
							</td><td width="5"></td>
							<td><span class="btn_02" title="전송"><a href="javascript:doAction('transfer');"><%=CommonLang.get("HTITLE235") %><!-- 전송 --></a></span></td>
						</tr>
					</table>
			</div>
			<%}%>
			<div class="fr">
			
			
<%
//SLOGIC-BEGIN(P06-0000017)
//SLOGIC-BEGIN(P06-0000011)	 
  if(p060000011 == true || p060000017 == true) 
  {
%> 
<!-- 		<div>
        <input type="radio"  name="prsheetreport" id="prsheetreport" value="dept" checked>부서별&nbsp;
        <input type="radio"  name="prsheetreport" id="prsheetreport" value="item">품목별&nbsp;
        <input type="radio"  name="prsheetreport" id="prsheetreport" value="no">품의번호별&nbsp;
        <input type="radio"  name="prsheetreport" id="prsheetreport" value="dept_item">부서&품목별&nbsp;        
        <span class="btn_04" title="품의서"><a href="javascript:doAction('PRSheet');">품의서</a></span>
        </div> -->
        
        	 <span class="fl">
              <input type="radio" class="Noborder"  name="prsheetreport" id="prsheetreport" value="dept" onclick="doAction('PRSheet');">
              <%=CommonLang.get("HTITLE661") %><!-- 부서별 -->&nbsp;
              <input type="radio" class="Noborder" name="prsheetreport" id="prsheetreport" value="item" onclick="doAction('PRSheet');">
              <%=CommonLang.get("HTITLE662") %><!-- 품목별 -->&nbsp;
              <input type="radio"  class="Noborder" name="prsheetreport" id="prsheetreport" value="no" onclick="doAction('PRSheet');">
              <%=CommonLang.get("HTITLE663") %><!-- 품의번호별 -->&nbsp;
              <input type="radio"  class="Noborder" name="prsheetreport" id="prsheetreport" value="dept_item" checked onclick="doAction('PRSheet');">
              <%=CommonLang.get("HTITLE661") %><!-- 부서 -->&<%=CommonLang.get("HTITLE662") %><!-- 품목별 -->&nbsp; 
			  
			</span>
<%
    }
//SLOGIC-END
%>

<!-- 				<span class="btn_04" title="발주보류"><a href="javascript:doAction('createPR3');">발주보류</a></span> -->
<!-- 				<span class="btn_04" title="구매발주"><a href="javascript:doAction('createPR1');">구매발주</a></span> -->
<!-- 				<span class="btn_02" title="반려"><a href="javascript:doAction('prReturn');">반려</a></span> -->
<!-- 				<span class="btn_05" title="엑셀다운로드"><a href="javascript:doAction('ExcelDown');">엑셀다운로드</a></span> -->
				
	            <span class="fr">
	            <%
//SLOGIC-BEGIN(P06-0000017)
//SLOGIC-BEGIN(P06-0000011)	 
  if(p060000011 == true || p060000017 == true) 
  {
%> 
			  <span class="btn_02" title="품의서"><a href="javascript:doAction('PRSheet');"><%=CommonLang.get("HTITLE664") %><!-- 품의서 --></a></span>
<%
    }
//SLOGIC-END
%>			  
<%	//관리번호 수정 버튼 기능 활성화
	if(p060000113==true){
%>
				<span class="btn_05" title="관리번호수정"><a href="javascript:doAction('saveRefPrNo');"><%=CommonLang.get("HTITLE953") %><!-- 관리번호수정 --></a></span>
<%
	}
%>
	            <span class="btn_04" title="발주보류"><a href="javascript:doAction('createPR3');"><%=CommonLang.get("HTITLE236") %><!-- 발주보류 --></a></span> <span class="btn_04" title="구매발주"><a href="javascript:doAction('createPR1');"><%=CommonLang.get("HTITLE237") %><!-- 구매발주 --></a></span> <span class="btn_02" title="반려"><a href="javascript:doAction('prReturn');"><%=CommonLang.get("HTITLE238") %><!-- 반려 --></a></span> 
	            <%
	            //엑셀다운로드 기능 통제
	            if(p170000001 == false){ 
	            %>
	            	<span class="btn_05" title="엑셀다운로드"><a href="javascript:doAction('ExcelDown');"><%=CommonLang.get("HTITLE150") %><!-- 엑셀다운로드 --></a></span>
	            <%
	            } 
	            %>
	            
	            </span>
            
			</div>

        </div>
        <br/> 
<table>	   
	   <%
if("0".equals(pre_goods_count))
{
%>
  <tr>
    <td colspan="2" align="left" style="padding-bottom:2px">
 ※ <%=CommonLang.get("HTITLE665") %><!-- 선입고 발주일 --> &nbsp;&nbsp;&nbsp;: <input type="text" name="imsi_po_create_date" size="10" maxlength="10" value = ""  class="input_type_text" readonly> <a href="javascript:doAction('poDate')"><img src="/resources/images/btn_calendar.gif" width="19"  border="0" height="19" ></a>&nbsp;(<%=CommonLang.get("HTITLE666") %><!-- 선입고시 품목 선택 후 발주일을 선택해 주십시요. -->)
    </td>
  </tr>
<%
}else{
%>
  <tr>
    <td colspan="2" align="left" style="padding-bottom:2px">
      <input type="hidden" name="imsi_po_create_date" size="10" maxlength="10" value = "" readonly>
    </td>
  </tr>
<%
}
%>
</table>   

 ※ <%=CommonLang.get("HTITLE667") %><!-- 납기요청일 변경 --> : <input type="text" name="imsi_rd_date" size="10" maxlength="10" value = ""   class="input_type_text"  readonly> <a href="javascript:doAction('rdDate')"><img src="/resources/images/btn_calendar.gif" alt="검색" ></a><br>&nbsp;(<%=CommonLang.get("HTITLE668") %><!-- 납기요청일 수정 및 일괄 납기요청일 수정시 품목 선택후 수정해 주십시요. -->)<br>
 
</form>

<form name="processForm" id="processForm" method="post">	
	<input type="hidden" name="st_query" id="st_query" value="" /> 
	<input type="hidden" name="st_purchaserDept" id="st_purchaserDept" value="" /> 
	<input type="hidden" name="st_buyer" id="st_buyer" value="" /> 
	<input type="hidden" name="st_pr_return_type" id="st_pr_return_type" value="" />	
	<input type="hidden" name="st_bdgt_pr_no" id="st_bdgt_pr_no" value="" />
	<input type="hidden" name="recvFlag" id="recvFlag" value="" />
	<input type="hidden" name="end_price" id="end_price" value="" /> 	 
	<input type="hidden" name="TYPE" id="TYPE" value="" /> 
	<input type="hidden" name="COM_CODE" id="COM_CODE" value="" />	
	<input type="hidden" name="st_account_type" id="st_account_type" value="" /> 
	<input type="hidden" name="st_budget_dept" id="st_budget_dept" value="" /> 
	<input type="hidden" name="st_old_amt" id="st_old_amt" value="" /> 
	<input type="hidden" name="st_new_amt" id="st_new_amt" value="" />  
	<input type="hidden" name="nu_end_price" id="nu_end_price" value="" />   	
	<input type="hidden" name="st_po_create_date" id="st_po_create_date" value="" />   	
	<input type="hidden" name="st_account_type_code" id="st_account_type_code" value="" />
	<input type="hidden" name="gw_no_new" id="gw_no_new" value="" />   	
	<input type="hidden" name="recv_flag_new" id="recv_flag_new" value="" />   	   	
	<input type="hidden" name="as_flag_new" id="as_flag_new" value="" />   	   	 
	<input type="hidden" name="st_reqHold" id="st_reqHold" value="REQ" />   	   	 	
	<input type="hidden" name="st_budget_dept_flg" id="st_budget_dept_flg" value="" />   	   	 	
</form>

<form name="reportPostForm" id="reportPostForm" method="post">	 
	<input type="hidden" name="fileName" id="fileName" value=""> 
	<input type="hidden" name="param" id="param" value=""> 
</form>
</div>

<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>   
</div>
</body>

<script type="text/javascript">
var popupSel = "";
var selectedRow = "";

// 최초 화면 함수 
function kep_onload_view(){
	
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");  
	 
	<% if ("KRCONT0006".equals(buyer) && "".equals(curPage2)) {%>
	doAction("search");
	<%}%>
	
}

var st;
//기능함수
function doAction(str) {
		
	switch (str) {
	case "search":	 //조회
		kepSearch(1);
		break; 
		
	case "transfer":	 //전송
		transfer();
		break; 
		
	case "PRSheet":	 //품의서
		PRSheet(); 
		break; 
		
	case "createPR3":	 //발주보류
		createPR('3');
		break; 
		
	case "createPR1":	 //구매발주
		createPR('1');
		break; 
		
	case "prReturn":	 //반려
		prReturn();
		break; 
		
	case "ExcelDown":	 //엑셀다운로드
		ExcelDown();
		break; 
		
	case "kep_reload":	 //초기화
		kep_reload();
		break; 
		
	case "rdDate":	 // 달력
		CalendarCheck('rdDate');
		break; 
		
		
	case "poDate":	 // 달력
		CalendarCheck('poDate');
		break;
		
	case "saveRefPrNo":	 //관리번호 저장
		saveRefPrNo();
		break;
		
	}
}


function PRSheet()
{
	
	var tot_cnt = $("#display_item_cnt").val();  
    var cnt = getCheckedRowCount(tot_cnt); 
    var pr_no   =  ""; //document.forms.searchForm.st_pr_no.value;
    var ref_no   =  document.getElementById('st_search_type').value=='RN'?document.forms.searchForm.st_search_code.value:''; //document.forms.searchForm.st_ref_no.value;
    var buyer = document.forms.searchForm.st_buyer.value;
    var user_dept = document.forms.searchForm.userDept.value;    
    var req_dept_code =  document.forms.searchForm.st_req_dept_code.value;
    
    
    var query = "";
    var row_num = 0;
//  window.open("/kr/customer/sheet/pr_print_jinro.jsp?pr_no="+pr_no+"&buyer="+buyer+"&fromDate="+fromDate+"&toDate="+toDate+"&req_dept_code="+req_dept_code+"&ref_no="+ref_no+"&user_dept="+user_dept,"SWin","width=700,height=705,resizable=YES,scrollbars=YES,top=0,left=0");
    if(cnt == 0){
    	//출력할 목록을 선택 하세요. 
        alert("<%=CommonLang.msg("MSG187") %>");
        return;
    } 
     
	if(tot_cnt <=1) { 
	    var box = eval("document.forms.contentForm.lnCheck0"); 
	    if(box.checked==true) {
	  		  query += document.forms.contentForm.st_pr_no_sel.value; 
			  query += document.forms.contentForm.st_pr_seq_sel.value; 
              query += "@@"; 
	    }
    }else {
		var buyerCheck = "Y";
		var st_dt_buyer_code = "";
		for(var k=0; k<tot_cnt; k++) {
        	var box2 = eval("document.forms.contentForm.lnCheck"+k);
        	if(box2.checked==true) {
        		for(var z=0; z<tot_cnt; z++) {
        			st_dt_buyer_code = document.forms.contentForm.st_dt_buyer_code[k].value;
        			var box3 = eval("document.forms.contentForm.lnCheck" + z);
        			if(box3.checked==true){
	       				if(document.forms.contentForm.st_dt_buyer_code[k].value != document.forms.contentForm.st_dt_buyer_code[z].value){
	       					buyerCheck= "N";			
	       				}
        			}
        		}
        	}
        }
        if(buyerCheck=="N"){
        	//고객사가 다를경우 품의서 출력이 불가능합니다.
            alert("<%=CommonLang.msg("MSG188") %>");
            return;
        }
		for(j=0; j<tot_cnt; j++) { 
            var box = eval("document.forms.contentForm.lnCheck"+j); 
            if(box.checked==true) {
	      		  query += document.forms.contentForm.st_pr_no_sel[j].value; 
	    		  query += document.forms.contentForm.st_pr_seq_sel[j].value; 
	                query += "@@"; 
            }
        }
		buyer = st_dt_buyer_code;
    }  
	
	
	var reportid = "";
	var prsheetreport = kepRadioSelectVal("prsheetreport"); 
    if (prsheetreport == "dept"){ // 부서별
    	reportid = "RD_06_S_003_08";
    }else if (prsheetreport == "item"){ // 품목별
    	reportid = "RD_06_S_003_09";
    }else if (prsheetreport == "no"){ // 품의번호별
    	reportid = "RD_06_S_003_10";
    }else if (prsheetreport == "dept_item"){ // 부서&품목별	
    	reportid = "RD_06_S_003_11";
    }
	
    document.forms.processForm.st_query.value = query;
    reportPostOpen(reportid, "["+buyer+"]["+req_dept_code+"]["+ref_no+"]["+pr_no+"]["+user_dept+"]["+query+"]");   

}


//조회
function kepSearch(curPage){
	
	if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
	if (kepGetDateDiff('st_from_date','st_to_date','D') > 184 ){
		//MSG494
		alert("조회기간을 6개월 단위로 조회가 가능합니다.");
		return;
	}
	//조회그룹으로 추가.
	var st_com_code =document.forms.searchForm.st_com_code2.value;
	if(st_com_code.indexOf("GROUP") >=0){
		document.forms.searchForm.st_group_info.value = st_com_code; 
	}else{
		document.forms.searchForm.st_group_info.value = "";
	}
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mppo/getBuyerMpPoOrderReqReceiptList.do").submit();   
}

function ExcelDown(){
	if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;  
	if (kepGetDateDiff('st_from_date','st_to_date','D') > 184 ){
		//MSG494
		alert("조회기간을 6개월 단위로 조회가 가능합니다.");
		return;
	}
	//조회그룹으로 추가.
	var st_com_code =document.forms.searchForm.st_com_code2.value;
	if(st_com_code.indexOf("GROUP") >=0){
		document.forms.searchForm.st_group_info.value = st_com_code; 
	}else{
		document.forms.searchForm.st_group_info.value = "";
	}	
	document.forms.searchForm.action = "/mppo/excelBuyerMpPoOrderReqReceiptList.do";
	document.forms.searchForm.submit();
	
	//$('#searchForm').attr("action", "/mppo/excelBuyerMpPoOrderReqReceiptList.do").submit();   
}

function kep_reload(){
	 
	document.forms.searchForm.st_req_dept_code.value = ""; 
	document.forms.searchForm.st_req_dept_name.value = "";
	document.forms.searchForm.st_pr_no.value = "";
	document.forms.searchForm.st_search_code.value = "";
	
	
	$("#st_from_date").val( kepToMonthAdd("3","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));   
	
	document.getElementsByName('prsheetreport')[3].checked = true;
// 	kepSearch(-1);
	jspTableClean("table_list","8");
	
}


function getDepartmentCode(){ 
	openSearchPopup('/common/deptCodeAdminPop.do', "?open=Y&com_code=<%=SessionComCode%>", "500,500,no"); 
} 

function setPopupReturn(code, text) { 
		document.forms.searchForm.st_req_dept_code.value = code;
		document.forms.searchForm.st_req_dept_name.value = text; 
}

function getPrDisplayPop(BUYER,PR_NO,VALUE1,VALUE2,RECV_FLAG){  
	openSearchPopup('/mpiv/showCommonMpIvOdrreqDetailPop.do','?openYn=Y&COMPANY='+BUYER+'&PR_NO='+PR_NO+'&st_flag='+VALUE1+'&enter_flag='+VALUE2+'&RECV_FLAG='+RECV_FLAG , "800,600,no"); 
} 
function getNewDepartmentDisplayPop(st_com_code,st_dept){ 
	openSearchPopup('/coco/getCommonCoCoDepartmentDetailViewPop.do','?openYn=Y&st_com_code='+st_com_code+'&st_dept='+st_dept , "400,143,no"); 
}  


function setSortingList(sort_column) {
	document.forms.searchForm.st_sort_column.value = sort_column;
	
	var sort_flag = document.forms.searchForm.st_sort_flag.value;
	if(sort_flag=="ASC") {
		document.forms.searchForm.st_sort_flag.value = "DESC";
	}else {
		document.forms.searchForm.st_sort_flag.value = "ASC";
	} 
	kepSearch(1);
}

//선택 품목 총 합계금액
function sum_price(){
	
	
	var maxRow = $("#display_item_cnt").val(); 
    var sum_price = 0;
    if(eval(maxRow) < 2){
        var box = eval("document.contentForm.lnCheck0");
        if(box.checked == true){
            sum_price = eval(sum_price) + eval(filterNum(document.contentForm.item_amt.value));
        }
    }else{
        for(var k = 0; k < maxRow; k++){
            var box = eval("document.contentForm.lnCheck" + k);
            if(box.checked == true){
                sum_price = eval(sum_price) + eval(filterNum(document.contentForm.item_amt[k].value));
            }
        }
    }
    document.forms.searchForm.st_sum_price.value = kepCommaNum(sum_price);
}
function remarkCopy() { 
	
	var tot_cnt = $("#display_item_cnt").val(); 
	var checked_row_count   = getCheckedRowCount(tot_cnt);
	var cRemark         = ""; 
	var checked_count       = 0; 
	var cr_flag = false; 
    var y_position  = document.forms.searchForm.st_y_position.value; 
 	if(checked_row_count==0) {
 		//선택된 품목이 없습니다.
        alert("<%=CommonLang.msg("MSG100") %>");
        return;
    }
	if(tot_cnt <=1) {
		checked_count = 1;
	    cRemark = document.forms.contentForm.po_remark.value; 
    }else {  
		for(j=0; j<tot_cnt; j++) { 
            var box = eval("document.forms.contentForm.lnCheck"+j); 
            if(box.checked==true) {
				checked_count++; 
				if(TrimCommon(document.forms.contentForm.po_remark[j].value)) { 
					cr_flag = true;
					cRemark = document.forms.contentForm.po_remark[j].value; ; 
					break;
				}
            }
        }
		
    }  
 
    if(checked_count==0) { 
    	//복사할 비고를 선택하여 주십시요.
        alert("<%=CommonLang.msg("MSG38") %>"); 
        return;
    }
    if(!cr_flag) { 
    	//비고를 입력하여 주십시요.
        alert("<%=CommonLang.msg("MSG191") %>"); 
        return;
    } 
    if(tot_cnt>=2) { 
        for(var j=0; j<tot_cnt; j++) {
			var box = eval("document.forms.contentForm.lnCheck"+j); 
			if(box.checked==true) {   
                document.forms.contentForm.po_remark[j].value           = cRemark;   
            } 
			changeIcon(j);
        }
    }else { 
    	//복사할 비고를 선택하여 주십시요.
        alert("<%=CommonLang.msg("MSG38") %>"); 
        return; 
    }
	
} 
function changeIcon(y_position){ 
	
	var tot_cnt  = $("#display_item_cnt").val(); 
	if(tot_cnt > 1) {  
		var pr_remark = document.forms.contentForm.pr_remark[y_position].value;
		var po_remark = document.forms.contentForm.po_remark[y_position].value; 
        if(TrimCommon(po_remark)) { 
			if(TrimCommon(pr_remark)){ 
				document.forms.contentForm.Image2[y_position].src = "/resources/images/icon3.gif"; 
			}else{  
				document.forms.contentForm.Image2[y_position].src = "/resources/images/icon.gif"; 
			} 
		}else{
			if(TrimCommon(pr_remark)){ 
				document.forms.contentForm.Image2[y_position].src = "/resources/images/icon4.gif"; 
			}else{  
				document.forms.contentForm.Image2[y_position].src = "/resources/images/icon2.gif"; 
			} 
		}   
        
    }else { 
		var pr_remark = document.forms.contentForm.pr_remark.value;
		var po_remark = document.forms.contentForm.po_remark.value;  
        if(TrimCommon(po_remark)) { 
			if(TrimCommon(pr_remark)){ 
				document.forms.contentForm.Image2.src = "/resources/images/icon3.gif"; 
			}else{  
				document.forms.contentForm.Image2.src = "/resources/images/icon.gif"; 
			} 
		}else{
			if(TrimCommon(pr_remark)){ 
				document.forms.contentForm.Image2.src = "/resources/images/icon4.gif"; 
			}else{  
				document.forms.contentForm.Image2.src = "/resources/images/icon2.gif"; 
			} 
		}  
        
    }   
} 

function update_qty(row)
{
    var tot_cnt  = $("#display_item_cnt").val(); 
    if(eval(tot_cnt) < 2)
    {
        var plan_amt_flag       = TrimCommon(filterNum(document.forms.contentForm.st_plan_amt_flag.value));  // 예산적용여부( 'Y'=적용 , 'N'=미적용 )
        var bdgt_flag           = TrimCommon(filterNum(document.forms.contentForm.db_dbgt_flag.value));
        var imsi_qty            = TrimCommon(filterNum(document.forms.contentForm.target_qty.value));        // 발주수량
        var imsi_buy_price      = TrimCommon(filterNum(document.forms.contentForm.buy_price.value));         // 단가
        var imsi_req_qty        = TrimCommon(filterNum(document.forms.contentForm.req_qty.value));           // 요청수량
        
        //alert("plan_amt_flag " +plan_amt_flag + "  bdgt_flag " +bdgt_flag);
        if( plan_amt_flag == 'Y' && bdgt_flag == "Y")
        {
            if( isEmpty(imsi_qty) || !IsNumber1(imsi_qty) || (imsi_qty == 0) )
            {
            	//수량에 1 이상의 숫자를 입력해 주십시요
                alert("<%=CommonLang.msg("MSG192") %>");
                document.forms.contentForm.target_qty.value = imsi_req_qty;
                document.forms.contentForm.item_amt.value   = kepCommaNum(imsi_buy_price * imsi_req_qty);
                return;
            }
            checkBdgtAmt(0);
        }
        else
        {
            prRecvReturnReason(0);
        }
    }
    else
    {
        var imsi_qty            = TrimCommon(filterNum(document.forms.contentForm.target_qty[row].value));         // 발주수량
        var imsi_buy_price      = TrimCommon(filterNum(document.forms.contentForm.buy_price[row].value));          // 단가
        var imsi_req_qty        = TrimCommon(filterNum(document.forms.contentForm.req_qty[row].value));            // 요청수량
        // 예산적용 여부 ICOMPRDT.PLAN_AMT_FLAG
        var plan_amt_flag       = TrimCommon(filterNum(document.forms.contentForm.st_plan_amt_flag[row].value));   // 예산적용여부( 'Y'=적용 , 'N'=미적용 )
        var bdgt_flag           = TrimCommon(filterNum(document.forms.contentForm.db_dbgt_flag[row].value));
        
        //alert("plan_amt_flag " +plan_amt_flag + "  bdgt_flag " +bdgt_flag);  
        if( plan_amt_flag == 'Y' && bdgt_flag == "Y")
        {
            if( isEmpty(imsi_qty) || !IsNumber1(imsi_qty) || (imsi_qty == 0) )
            {
            	//수량에 1 이상의 숫자를 입력해 주십시요
                alert("<%=CommonLang.msg("MSG192") %>");
                document.forms.contentForm.target_qty.value = imsi_req_qty;
                document.forms.contentForm.item_amt.value   = kepCommaNum(imsi_buy_price * imsi_req_qty);
                return;
            }
            checkBdgtAmt(row);
        }
        else
        {
            prRecvReturnReason(row);
        }
    }
}

function checkBdgtAmt(row)
{	
	selectedRow = row;
    var tot_cnt  = $("#display_item_cnt").val(); 
    if(eval(tot_cnt) < 2)
    {
        var imsi_qty        = TrimCommon(filterNum(document.forms.contentForm.target_qty.value));        // 발주수량
        var imsi_buy_price  = TrimCommon(filterNum(document.forms.contentForm.buy_price.value));         // 단가
        var imsi_req_qty    = TrimCommon(filterNum(document.forms.contentForm.req_qty.value));           // 요청수량
        var old_amt         = eval(imsi_req_qty * imsi_buy_price);
        var new_amt         = eval(imsi_qty * imsi_buy_price);
        var buyer           = document.forms.searchForm.st_buyer.value;
        var account_type    = document.forms.contentForm.st_account_type.value;
        var budget_dept     = document.forms.contentForm.st_budget_dept.value;
        
        
        document.forms.processForm.st_buyer.value  = buyer;            
        document.forms.processForm.st_account_type.value  = account_type;            
        document.forms.processForm.st_budget_dept.value  = budget_dept;            
        document.forms.processForm.st_old_amt.value  = old_amt;            
        document.forms.processForm.st_new_amt.value  = new_amt;             

        kepAjaxFormCall("/mppo/buyerAdminBdgtTempQtyCheck.do","processForm","BUYERADMINBDGTTEMPQTYCHECK");        
        //var goUrl = "/kr/customer/proxybuy/bdgt/buyer_admin_bdgt_temp_qty_check.jsp?st_buyer="+buyer+"&st_account_type="+account_type+"&st_budget_dept="+budget_dept+"&old_amt="+old_amt+"&new_amt="+new_amt;
    }
    else
    {
        var imsi_qty            = TrimCommon(filterNum(document.forms.contentForm.target_qty[row].value));         // 발주수량
        var imsi_buy_price      = TrimCommon(filterNum(document.forms.contentForm.buy_price[row].value));          // 단가
        var imsi_req_qty        = TrimCommon(filterNum(document.forms.contentForm.req_qty[row].value));            // 요청수량
        var old_amt         = eval(imsi_req_qty * imsi_buy_price);
        var new_amt         = eval(imsi_qty * imsi_buy_price);
        var buyer           = document.forms.searchForm.st_buyer.value;
        var account_type    = document.forms.contentForm.st_account_type[row].value;
        var budget_dept     = document.forms.contentForm.st_budget_dept[row].value;
        
        document.forms.processForm.st_buyer.value  = buyer;            
        document.forms.processForm.st_account_type.value  = account_type;            
        document.forms.processForm.st_budget_dept.value  = budget_dept;            
        document.forms.processForm.st_old_amt.value  = old_amt;            
        document.forms.processForm.st_new_amt.value  = new_amt;              

        kepAjaxFormCall("/mppo/buyerAdminBdgtTempQtyCheck.do","processForm","BUYERADMINBDGTTEMPQTYCHECK");                
        //var goUrl = "/kr/customer/proxybuy/bdgt/buyer_admin_bdgt_temp_qty_check.jsp?st_buyer="+buyer+"&st_account_type="+account_type+"&st_budget_dept="+budget_dept+"&old_amt="+old_amt+"&new_amt="+new_amt+"&row="+row;
    }
}
var return_reason_obj;
function prRecvReturnReason(row)
{
    var tot_cnt  = $("#display_item_cnt").val(); 
	var budget_flag = "<%=budget_flag%>";
    if(eval(tot_cnt) < 2)
    {
        // 요청수량 변경사유
        return_reason_obj       = eval(document.forms.contentForm.db_return_reason);
        var imsi_qty            = TrimCommon(filterNum(document.forms.contentForm.target_qty.value));        // 발주수량
        var imsi_buy_price      = TrimCommon(filterNum(document.forms.contentForm.buy_price.value));         // 단가
        var imsi_req_qty        = TrimCommon(filterNum(document.forms.contentForm.req_qty.value));           // 요청수량
        var imsi_qty_temp       = TrimCommon(filterNum(document.forms.contentForm.st_temp_qty.value));       // 이전 변경수량
//      var old_amt         = eval(imsi_req_qty * imsi_buy_price);
        var old_amt         = eval(imsi_qty_temp * imsi_buy_price);
        var new_amt         = eval(imsi_qty * imsi_buy_price);
        var buyer           = document.forms.searchForm.st_buyer.value;
        var account_type    = document.forms.contentForm.st_account_type.value;
        var budget_dept     = document.forms.contentForm.st_budget_dept.value;
        if( isEmpty(imsi_qty) || !IsNumber1(imsi_qty) || (imsi_qty == 0) )
        {
        	//수량에 1 이상의 숫자를 입력해 주십시요
            alert("<%=CommonLang.msg("MSG192") %>");
            document.forms.contentForm.target_qty.value = imsi_req_qty;
            document.forms.contentForm.item_amt.value   = kepCommaNum(imsi_buy_price * imsi_req_qty);
            return;
        }
        if(imsi_qty!=""){
            document.forms.contentForm.db_qty.value     = eval(imsi_qty);
            document.forms.contentForm.target_qty.value = kepCommaNum(eval(imsi_qty));
            document.forms.contentForm.item_amt.value   = kepCommaNum(imsi_buy_price * imsi_qty);    // 금액 변경
        }
        sum_price();
        var com_code = document.forms.contentForm.st_com_code.value;
        var pr_no    = document.forms.contentForm.st_pr_no_sel.value;
        var pr_seq   = document.forms.contentForm.st_pr_seq_sel.value;
        //if( imsi_qty != imsi_req_qty){
        	//요청수량 변경사유를 입력해 주십시요
            alert("<%=CommonLang.msg("MSG193") %>");
            var reason = return_reason_obj.value;
            openSearchPopup('/mppo/showBuyerPrRecvReturnReasonPop.do','?openYn=Y&return_reason='+reason+'&recv_qty='+imsi_qty+'&st_pr_no='+pr_no+'&st_pr_seq='+pr_seq+'&st_com_code='+com_code+'&st_old_amt='+old_amt+'&st_new_amt='+new_amt+'&st_account_type='+account_type+'&st_budget_dept='+budget_dept+'&st_row=0&st_budget_flag='+budget_flag, "500,300,no"); 
            
          //  var loc = "/kr/customer/proxybuy/pr_recv_return_reason.jsp?return_reason="+reason+"&recv_qty="+imsi_qty+"&st_pr_no="+pr_no+"&st_pr_seq="+pr_seq+"&st_com_code="+com_code+"&st_old_amt="+old_amt+"&st_new_amt="+new_amt+"&st_account_type="+account_type+"&st_budget_dept="+budget_dept+"&st_row=0&st_budget_flag="+budget_flag;
         //   childWin = window.open(loc, "ReturnReason","left=0,top=0,width=520,height=255,resizable=no,scrollbars=no");
        //}else{
            return_reason_obj.value = "";
			return;
        //}
    }
    else
    {
        // 요청수량 변경사유
        return_reason_obj       = eval(document.forms.contentForm.db_return_reason[row]);
        var imsi_qty            = TrimCommon(filterNum(document.forms.contentForm.target_qty[row].value));         // 발주수량
        var imsi_buy_price      = TrimCommon(filterNum(document.forms.contentForm.buy_price[row].value));          // 단가
        var imsi_req_qty        = TrimCommon(filterNum(document.forms.contentForm.req_qty[row].value));            // 요청수량
        var imsi_qty_temp       = TrimCommon(filterNum(document.forms.contentForm.st_temp_qty[row].value));               // 이전 변경수량
//      var old_amt         = eval(imsi_req_qty * imsi_buy_price);
        var old_amt         = eval(imsi_qty_temp * imsi_buy_price);
        var new_amt         = eval(imsi_qty * imsi_buy_price);
        var buyer           = document.forms.searchForm.st_buyer.value;
        var account_type    = document.forms.contentForm.st_account_type[row].value;
        var budget_dept     = document.forms.contentForm.st_budget_dept[row].value;
        if( isEmpty(imsi_qty) || !IsNumber1(imsi_qty) || (imsi_qty == 0) ){
        	//수량에 1 이상의 숫자를 입력해 주십시요
            alert("<%=CommonLang.msg("MSG192") %>");
            document.forms.contentForm.target_qty[row].value = imsi_req_qty;
            document.forms.contentForm.item_amt[row].value   = kepCommaNum(imsi_buy_price * imsi_req_qty);
            return;
        }
        if(imsi_qty!=""){
            document.forms.contentForm.db_qty[row].value     = eval(imsi_qty);
            document.forms.contentForm.target_qty[row].value = kepCommaNum(eval(imsi_qty));
            document.forms.contentForm.item_amt[row].value   = kepCommaNum(imsi_buy_price * imsi_qty);    // 금액 변경
        }
        sum_price();
        var com_code = document.forms.contentForm.st_com_code[row].value;
        var pr_no    = document.forms.contentForm.st_pr_no_sel[row].value;
        var pr_seq   = document.forms.contentForm.st_pr_seq_sel[row].value;
        //if( imsi_qty != imsi_req_qty){
        	//요청수량 변경사유를 입력해 주십시요
            alert("<%=CommonLang.msg("MSG193") %>");
            var reason = return_reason_obj.value;
            openSearchPopup('/mppo/showBuyerPrRecvReturnReasonPop.do','?openYn=Y&return_reason='+reason+'&recv_qty='+imsi_qty+'&st_pr_no='+pr_no+'&st_pr_seq='+pr_seq+'&st_com_code='+com_code+'&st_old_amt='+old_amt+'&st_new_amt='+new_amt+'&st_account_type='+account_type+'&st_budget_dept='+budget_dept+'&st_row=0&st_budget_flag='+budget_flag, "500,300,no"); 
            
           // var loc = "/kr/customer/proxybuy/pr_recv_return_reason.jsp?return_reason="+reason+"&recv_qty="+imsi_qty+"&st_pr_no="+pr_no+"&st_pr_seq="+pr_seq+"&st_com_code="+com_code+"&st_old_amt="+old_amt+"&st_new_amt="+new_amt+"&st_account_type="+account_type+"&st_budget_dept="+budget_dept+"&st_row="+row+"&st_budget_flag="+budget_flag;
           // childWin = window.open(loc, "ReturnReason","left=0,top=0,width=520,height=255,resizable=no,scrollbars=no");
			return;
        //}else{
        //    return_reason_obj.value = "";
        //}
    }
}
//비고 팝업
function setPoRemark( y_position, buyer, pr_no, pr_seq, remark) {
	
	var tot_cnt  = $("#display_item_cnt").val(); 
	document.forms.searchForm.st_y_position.value = y_position;
    var left = 0;
    var top = 0;
    var width = 417;
    var height = 330;
    var toolbar = 'no';
    var menubar = 'no';
    var status = 'no';
    var scrollbars = 'yes';
    var resizable = 'no';
	var po_remark = ''; 
	
	if(eval(tot_cnt) < 2){
		po_remark = document.forms.contentForm.po_remark.value; 
	}else{
		po_remark = document.forms.contentForm.po_remark[y_position].value; 
    } 
	openSearchPopup('/mppo/showBuyerMpPoOrderRemarkInsPop.do','?openYn=Y&buyer='+buyer+'&pr_no='+pr_no+'&pr_seq='+pr_seq+'&pr_remark='+remark+'&po_remark='+po_remark , "500,500,no"); 
	//var loc = "/kr/customer/new_sourcing/buyer/pr_po_new_remark_view.jsp?buyer="+buyer+"&pr_no="+pr_no+"&pr_seq="+pr_seq+"&remark="+remark+"&po_remark="+po_remark;
    //window.open(loc,'setPoRemark', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
} 
function checkOnePr(remark) { 
	var tot_cnt  =  $("#display_item_cnt").val(); 
    var y_position  = document.forms.searchForm.st_y_position.value; 
    if(tot_cnt > 1) {   
		document.forms.contentForm.po_remark[y_position].value = remark;
		changeIcon(y_position);  
        
    }else {  
		document.forms.contentForm.po_remark.value = remark;
		changeIcon(y_position);  
    } 
} 

var date_check;
function CalendarCheck(check){
	
	var tot_cnt  = $("#display_item_cnt").val(); 
	
    if(check=="poDate"){
    	//선입고 품목에 적용되는 발주일 입니다.\n\n선입고 품목의 실제 발주일을 입력 하시겠습니까?
        if(!confirm("<%=CommonLang.msg("MSG370") %>")){
            return;
        }
    }else if(check=="rdDate"){
        var rd_row = getCheckedRowCount(tot_cnt);
        if(rd_row == 0){
        	//납기요청일을 수정할 품목을 선택해 주십시요
            alert("<%=CommonLang.msg("MSG194") %>");
            return;
        }
    }
    date_check = check;
    kepCalendarOpenPopup();
}

function setPopupCalendar(year,month,day){
    var rd_date      = year+""+month+""+day+"";
    var rd_date_text = year+"/"+month+"/"+day+"";
    if(date_check=="poDate"){
        document.forms.contentForm.imsi_po_create_date.value = rd_date_text;
        document.forms.contentForm.st_po_create_date.value   = rd_date;
    }else if(date_check=="rdDate"){
        document.forms.contentForm.imsi_rd_date.value = rd_date_text;
        setRdDate(rd_date  , rd_date_text);
    }
}
//납기요청일 수정
function setRdDate(rd_date , rd_date_text){
	
	var tot_cnt  = $("#display_item_cnt").val(); 
    if(eval(tot_cnt) < 2){
        var box = eval("document.contentForm.lnCheck0");
        if(box.checked == true){
            document.forms.contentForm.rd_date_text.value = rd_date_text;
            document.forms.contentForm.db_rd_date.value   = rd_date;
        }
    }else{
        for(var k = 0; k < tot_cnt; k++){
            var box = eval("document.contentForm.lnCheck" + k);
            if(box.checked == true){
                document.forms.contentForm.rd_date_text[k].value = rd_date_text ;
                document.forms.contentForm.db_rd_date[k].value   = rd_date ;
            }
        }
    }
}
function setReturnReason(value){
    return_reason_obj.value = value;
}

function prRecvReturnReasonResult(result, row)
{
    var tot_cnt  = $("#display_item_cnt").val(); 
    if(result=="OK")
    {
        if(eval(tot_cnt) < 2)
        { 
            var temp_qty = document.forms.contentForm.target_qty.value;
            document.forms.contentForm.st_temp_qty.value = temp_qty;
        }
        else
        { 
            var temp_qty = document.forms.contentForm.target_qty[row].value;
            document.forms.contentForm.st_temp_qty[row].value = temp_qty;
        }
    }
    else
    {
    	//예산이 부족하여 수량변경을 할 수 없습니다.\n 예산을 확인하여 주시기 바랍니다.
        alert("<%=CommonLang.msg("MSG195") %>");
        returnToQty(row);
        return;
    }
}
function returnToQty(row)
{
    var tot_cnt  =  $("#display_item_cnt").val(); 
    if(eval(tot_cnt) < 2)
    {
        var temp_qty = document.forms.contentForm.st_temp_qty.value;
        document.forms.contentForm.target_qty.value = temp_qty;
    }
    else
    {
        var temp_qty = document.forms.contentForm.st_temp_qty[row].value;
        document.forms.contentForm.target_qty[row].value = temp_qty;
    }
}
/**
 * 체크 된 수
 */
function getCheckedRowCount(tot_cnt) {
	
	var chk_cnt = 0;
	if(eval(tot_cnt) < 2){
	    var box = eval("document.forms.contentForm.lnCheck0");
	    if(box.checked == true) chk_cnt++;
	}else{
	    for(var j = 0; j < tot_cnt; j++){
	         var box = eval("document.forms.contentForm.lnCheck" + j);
	         if(box.checked == true){
	              chk_cnt++;
	         }
	    }
	}
	return chk_cnt;
}

//부서이관
function transfer(){
	 
	
   var buyer           = document.forms.searchForm.st_buyer.value;
	  
    var f               = document.forms.contentForm;  
    var purchaserDept   = f.purchaserDept.options[f.purchaserDept.selectedIndex].value;
    var tot_cnt         =  $("#display_item_cnt").val(); 
    var chk_cnt   = 0;
    var query     = ""; 
    if(eval(tot_cnt) == 0)
    {
    	//조회한 데이타가 없습니다.
        alert("<%=CommonLang.msg("MSG69") %>");
        return;
    }
    if(f.purchaserDept.selectedIndex == 0){
    	//이관할 발주부서를 선택하세요.
        alert("<%=CommonLang.msg("MSG196") %>   ");
        f.purchaserDept.focus();
        return;
    }
    if(eval(tot_cnt) < 2){
        var box = eval("document.forms.contentForm.lnCheck0");
        if(box.checked == true){
            chk_cnt++;
            query += box.value;                                         // BUYER + PR_NO + PR_SEQ
            query += "|";
        }
    }else{
        for(var k = 0; k < tot_cnt; k++){
            var box = eval("document.forms.contentForm.lnCheck" +k);
            if(box.checked == true){
                chk_cnt++;
                query += box.value;                                     // BUYER + PR_NO + PR_SEQ
                query += "|";
            }
        }
    }
    if(chk_cnt == "0")
    {
    	//부서이관할 요청목록을 선택해 주십시요!!
        alert("<%=CommonLang.msg("MSG197") %>");
        return;
    }
    var ok = confirm(" <%=CommonLang.msg("MSG230") %>" + f.purchaserDept.options[f.purchaserDept.selectedIndex].text + "<%=CommonLang.msg("MSG371") %> ");/* 선택된 품목을 로 부서이관 하시겠습니까?? */ 
    if(!ok){
        return;
    }else{
        document.forms.processForm.st_query.value  = query;         
        document.forms.processForm.st_purchaserDept.value  = purchaserDept;         
        document.forms.processForm.st_buyer.value  = buyer;       

        kepAjaxFormCall("/mppo/saveDeptTramsfer.do","processForm","DEPT_TRANSFER"); 	        //부서이관
    }
}
 
//구매요청반려
function prReturn(){
    var chk_cnt     = 0;
    var reject_flag = "Y";
    var query     = "";
    var tot_cnt  = $("#display_item_cnt").val(); 
    if(eval(tot_cnt) == 0)
    {
    	//조회한 데이타가 없습니다.
        alert("<%=CommonLang.msg("MSG69") %>");
        return;
    }
    if(eval(tot_cnt) < 2){
        var box =  eval("document.forms.contentForm.lnCheck0");
        if(box.checked == true){
        	//권한통제
        	var st_confirm_yn= document.forms.contentForm.st_confirm_yn.value;
		    if(st_confirm_yn == "N"){
		    	//해당 고객사는의 처리권한이 없습니다.
		    	alert("<%=CommonLang.msg("MSG198") %>");
		    	return false;
		    }
            chk_cnt++;
            query += box.value;                                         // BUYER + PR_NO + PR_SEQ
            query += "@@";
            query += document.forms.contentForm.st_reject_reason.value;          // RETURN_REASON
            query += "@@";
            query += document.forms.contentForm.db_qty.value;                    // TARGET_QTY
            query += "@@";
            query += document.forms.contentForm.db_req_dept.value;               // REQ_DEPT
            query += "@@";
            query += document.forms.contentForm.db_account_type.value;           // ACCOUNT_TYPE
            query += "@@";
            query += document.forms.contentForm.st_plan_amt_flag.value;           // plan_amt_flag
            query +=  "|";
            if(document.forms.contentForm.st_reject_reason.value == ""){
                reject_flag = "N";
            }
        }
    }else{
        for(var k = 0; k < tot_cnt; k++){
            var box = eval("document.forms.contentForm.lnCheck" +k);
            if(box.checked == true){
            	//권한통제
            	var st_confirm_yn= document.forms.contentForm.st_confirm_yn[k].value;
    		    if(st_confirm_yn == "N"){
    		    	//해당 고객사는의 처리권한이 없습니다.
    		    	alert("<%=CommonLang.msg("MSG198") %>");
    		    	return false;
    		    }
                chk_cnt++;
                query += box.value;                                         // BUYER + PR_NO + PR_SEQ
                query += "@@";
                query += document.forms.contentForm.st_reject_reason[k].value;     // RETURN_REASON
                query += "@@";
                query += document.forms.contentForm.db_qty[k].value;               // TARGET_QTY
                query += "@@";
                query += document.forms.contentForm.db_req_dept[k].value;          // REQ_DEPT
                query += "@@";
                query += document.forms.contentForm.db_account_type[k].value;      // ACCOUNT_TYPE
                query += "@@";
                query += document.forms.contentForm.st_plan_amt_flag[k].value;      // plan_amt_flag
                query +=  "|";
                if(document.forms.contentForm.st_reject_reason[k].value == ""){
                    reject_flag = "N";
                }
            }
        }
        //alert(query);
    }
    if(chk_cnt == "0")
    {
    	//반려할 목록들을 선택하여 주십시요
        alert("<%=CommonLang.msg("MSG199") %>");
        return;
    }
    if(reject_flag == "N"){
    	//반려사유를 입력해 주십시요
        alert("<%=CommonLang.msg("MSG200") %>");
        
        openSearchPopup('/mppo/showBuyerMpPoRejectReasonPop.do','?openYn=Y' , "500,280,no"); 
        
        return;
    }
      
     document.forms.processForm.st_query.value  = query;            
     document.forms.processForm.st_pr_return_type.value  = document.forms.searchForm.st_pr_return_type.value;       
     kepAjaxFormCall("/mppo/saveSerPrReturn.do","processForm","REJECT"); 	        //반려
   
}

function setReason(value){
    var tot_cnt  = $("#display_item_cnt").val(); 
    if(eval(tot_cnt) < 2){
        var box = eval("document.forms.contentForm.lnCheck0");
        if(box.checked == true){
            document.forms.contentForm.st_reject_reason.value = value;               // RETURN_REASON
        }
    }else{
        for(var k = 0; k < tot_cnt; k++){
            var box =  eval("document.forms.contentForm.lnCheck" +k);
            if(box.checked == true){
                document.forms.contentForm.st_reject_reason[k].value = value;      // RETURN_REASON
            }
        }
    }
    

    prReturn();
}


//구매발주(recvFlag=1) , 발주보류(recvFlag=3)
function createPR(recvFlag){
	
	var buyer	 = document.forms.searchForm.st_buyer.value;
    var tot_cnt  = $("#display_item_cnt").val(); 
    var cnt      = getCheckedRowCount(tot_cnt);
    var row_num = 0; // 선택한 체크박스 rownum
    if(cnt == 0){
        if(recvFlag == '3'){
        	//발주보류할 품목을 선택해 주세요!
            alert("<%=CommonLang.msg("MSG201") %>   ");
            return;
        }
        if(recvFlag == '1'){
        	//구매대행 발주 할 품목을 선택해 주세요!
            alert("<%=CommonLang.msg("MSG202") %>    ");
            return;
        }
    }
    // 진로 청원 발주수량 50건 이하로 제한
    <% 
  //SLOGIC-BEGIN(P06-0000017)
  if (p060000017 == true) { %> 
	if(cnt > 50){
		//시스템 과부하를 방지 하기 위해 1회 50건까지 제한을 둡니다.\n\n50건만 선택하시겠습니까?
		var cc = confirm("<%=CommonLang.msg("MSG372") %>   ");
		if(cc){
			var temp_cnt = 0;
			for(var k = 0; k < tot_cnt; k++){
				var box =  eval("document.forms.contentForm.lnCheck" + k);
				if(box.checked == true){
					temp_cnt++;
				}
				if(temp_cnt > 50){
					box.checked   = false;
				}
			}
		}else{
			return;
		}
	}//end if 
	<%}
	 //SLOGIC-END%>
    var gr_check_flag = 'N';        // 선택한 품목중에 선입고 품목이 있는지 여부
    var st_group_mng_flag = document.forms.searchForm.st_group_mng_flag.value;
    row_num = 0;
    // 품목별 수량 , 단가 체크
    if(eval(tot_cnt) < 2){
        var box = eval("document.forms.contentForm.lnCheck0" );
        row_num++;
        if(box.checked == true){
        	//권한통제
        	var st_confirm_yn= document.forms.contentForm.st_confirm_yn.value;
		    if(st_confirm_yn == "N"){
		    	//해당 고객사는의 처리권한이 없습니다.
		    	alert("<%=CommonLang.msg("MSG198") %>");
		    	return false;
		    }
            // 수량 체크(db_qty)
            var qty_check = TrimCommon(document.forms.contentForm.db_qty.value);
            if(qty_check == "0" || ( qty_check == null || qty_check == "" )){
            	//번째 줄에 수량이 입력되지 않았습니다.
                alert( row_num + "<%=CommonLang.msg("MSG203") %>  ");
                return;
            }
/*
            if(qty_check < 0) {
                alert( row_num + "번째 줄에 수량은 양수이어야 합니다.  ");
                return false;
            }
*/
            //발주통합권한&발주결재시 해당기능 처리 안됨.
            var st_pass_yn = document.forms.contentForm.st_pass_yn.value;
            if(st_pass_yn=="Y"&& st_group_mng_flag=="Y"){
            	//번째 고객사는 전자결재범위가 발주품의이므로 처리 불가능합니다.
                alert( row_num + "<%=CommonLang.msg("MSG204") %>");
                return false;            	
            }
         	// 단가 체크(db_price)
            var price_check = TrimCommon(document.forms.contentForm.db_price.value);
            if(price_check == "0" || ( price_check == null || price_check == "" )){
            		//번째 줄에 단가가 입력되지 않았습니다. 협력사를 클릭하여 선택 및 입력하여 주십시요.
                    alert( row_num + "<%=CommonLang.msg("MSG205") %>");
                    return;
            }
            if(price_check < 0){
            		//번째 줄에 단가는 양수이어야 합니다.
                    alert( row_num + "<%=CommonLang.msg("MSG206") %>");
                    return false;
            }
            //발주일때만 관리번호 저장 체크
            if(recvFlag == '1'){
            	var st_msg = "<%=p060000113_type%>";
            	//메세지가 공백이 아닐경우만 체크
            	if(st_msg != ""){
                	var st_ref_pr_no =document.forms.contentForm.st_ref_pr_no.value;
                	if(st_ref_pr_no == "" || st_ref_pr_no == null|| st_ref_pr_no == " "){
                		alert(st_msg);
                    	document.forms.contentForm.st_ref_pr_no.focus();
                		return;
                	}            		
            	}
            }
            // 납기요청일 체크(rd_date)
            var rd_date_check   = TrimCommon(document.forms.contentForm.db_rd_date.value);
            var date_type       = checkDate(rd_date_check);
            var to_day          = document.forms.searchForm.currentDate.value;
            var po_create_date  = document.forms.contentForm.st_po_create_date.value;    // 선입고 발주날짜
            var gr_flag         = document.forms.contentForm.db_gr_flag.value;           // 품목별 선입고 여부
			// 비고 엔터값제거.
			var po_remark       = document.forms.contentForm.po_remark.value;           
			document.forms.contentForm.po_remark.value = FilterString_ent(po_remark);
            if(gr_flag =="S"){
                gr_check_flag = 'Y';
                if(date_type == false){
                	//번째 줄에 납기요청일이 입력되지 않았거나,날짜형식으로 입력되지 않았습니다.
                    alert( row_num + "<%=CommonLang.msg("MSG207") %>\n"+"<%=CommonLang.msg("MSG373") %>");
                    return;
                }
                if(parseInt(rd_date_check) < parseInt(po_create_date)){
                	//번째 줄에 납기요청일은 발주일보다 이후이어야 합니다.
                    alert( row_num + "<%=CommonLang.msg("MSG208") %> ");
                    return
                }
            }else{
                if(date_type == false){
                	//번째 줄에 납기요청일이 입력되지 않았거나,날짜형식으로 입력되지 않았습니다.
                    alert( row_num + "<%=CommonLang.msg("MSG207") %>\n"+"<%=CommonLang.msg("MSG373") %>");
                    return;
                }
                if( parseInt(rd_date_check) < parseInt(to_day)){
                	//번째 줄에 납기요청일은 현재날짜보다 이후이어야 합니다.
                    alert( row_num + "<%=CommonLang.msg("MSG209") %>");
                    return
                }
            }
        }
    }else{
    	//고객사가 다를경우 처리 안됨.
		var buyerCheck = "Y";
		for(var k=0; k<tot_cnt; k++) {
        	var box2 = eval("document.forms.contentForm.lnCheck"+k);
        	if(box2.checked==true) {
        		for(var z=0; z<tot_cnt; z++) {
        			var box3 = eval("document.forms.contentForm.lnCheck" + z);
        			if(box3.checked==true){
	       				if(document.forms.contentForm.st_dt_buyer_code[k].value != document.forms.contentForm.st_dt_buyer_code[z].value){
	       					buyerCheck= "N";			
	       				}
        			}
        		}
        	}
		}
        if(buyerCheck=="N"){
        	//고객사가 다를경우 처리 불가능합니다.
            alert("<%=CommonLang.msg("MSG210") %>");
            return;
        }
        for(var k = 0; k < tot_cnt; k++){
            var box =  eval("document.forms.contentForm.lnCheck" + k);
            row_num++;
            if(box.checked == true){
            	//권한통제
            	var st_confirm_yn= document.forms.contentForm.st_confirm_yn[k].value;
    		    if(st_confirm_yn == "N"){
    		    	//해당 고객사는의 처리권한이 없습니다.
    		    	alert("<%=CommonLang.msg("MSG198") %>");
    		    	return false;
    		    }
                // 수량 체크(db_qty)
                var qty_check = TrimCommon(document.forms.contentForm.db_qty[k].value);
                if(qty_check == "0" || ( qty_check == null || qty_check == "" )){
                	//번째 줄에 수량이 입력되지 않았습니다.
                    alert( row_num + "<%=CommonLang.msg("MSG203") %>  ");
                    return;
                }
                //발주통합권한&발주결재시 해당기능 처리 안됨.
                var st_pass_yn = document.forms.contentForm.st_pass_yn[k].value;
                if(st_pass_yn=="Y"&& st_group_mng_flag=="Y"){
                	//번째 고객사는 전자결재범위가 발주품의이므로 처리 불가능합니다.
                    alert( row_num + "<%=CommonLang.msg("MSG204") %>");
                    return false;            	
                }
                // 단가 체크(db_price)
                var price_check = TrimCommon(document.forms.contentForm.db_price[k].value);
                if(price_check == "0" || ( price_check == null || price_check == "" )){
                		//번째 줄에 단가가 입력되지 않았습니다. 협력사를 클릭하여 선택 및 입력하여 주십시요.
                        alert( row_num + "<%=CommonLang.msg("MSG205") %>");
                        return;
                }
                if(price_check < 0){
                		//번째 줄에 단가는 양수이어야 합니다.
                        alert( row_num + "<%=CommonLang.msg("MSG206") %>");
                        return false;
                }
                //발주일때만 관리번호 저장 체크
                if(recvFlag == '1'){
                	var st_msg = "<%=p060000113_type%>";
                	//메세지가 공백이 아닐경우만 체크
                	if(st_msg != ""){
	                	var st_ref_pr_no =document.forms.contentForm.st_ref_pr_no[k].value;
	                	if(st_ref_pr_no == "" || st_ref_pr_no == null|| st_ref_pr_no == " "){
	                		alert(st_msg);
	                		document.forms.contentForm.st_ref_pr_no[k].focus();
	                		return;
	                	}
                	}
                }
                // 납기요청일 체크(rd_date)
                var rd_date_check   = TrimCommon(document.forms.contentForm.db_rd_date[k].value);
                var date_type       = checkDate(rd_date_check);
                var to_day          = document.forms.searchForm.currentDate.value;
                var po_create_date  = document.forms.contentForm.st_po_create_date.value;        // 선입고 발주날짜
                var gr_flag         = document.forms.contentForm.db_gr_flag[k].value;          // 품목별 선입고 여부
				// 비고 엔터값제거.
				var po_remark       = document.forms.contentForm.po_remark[k].value;           
				document.forms.contentForm.po_remark[k].value = FilterString_ent(po_remark);
                if(gr_flag =="S"){
                    gr_check_flag = 'Y';
                    if(date_type == false){
                    	//번째 줄에 납기요청일이 입력되지 않았거나, 날짜형식으로 입력되지 않았습니다.
                        alert( row_num + "<%=CommonLang.msg("MSG207") %>\n"+"<%=CommonLang.msg("MSG373") %>");
                        return;
                    }
                    if(parseInt(rd_date_check) < parseInt(po_create_date)){
                    	//번째 줄에 납기요청일은 발주일보다 이후이어야 합니다.
                        alert( row_num + "<%=CommonLang.msg("MSG208") %> ");
                        return
                    }
                }else{
                    if(date_type == false){
                    	//번째 줄에 납기요청일이 입력되지 않았거나, 날짜형식으로 입력되지 않았습니다.
                        alert( row_num + "<%=CommonLang.msg("MSG207") %>\n"+"<%=CommonLang.msg("MSG373") %>");
                        return;
                    }
                    if( parseInt(rd_date_check) < parseInt(to_day)){
                    	//번째 줄에 납기요청일은 현재날짜보다 이후이어야 합니다.
                        alert( row_num + "<%=CommonLang.msg("MSG209") %>");
                        return
                    }
                }
            }// end if
        }// end for
    }// end else
    // 구매발주 일때만 선입고 품목의 발주일을 체크함
    if(recvFlag == '1'){
        if(gr_check_flag =='Y'){
        	//선택하신 품목중에 선입고 품목이 있습니다. 선입고 품목의 실제 발주일을  로 입력하시겠습니까? ※발주일을 수정 하시려면 취소 버튼을 누르신 후 아래 발주일을 수정해 주십시요
            if(!confirm("<%=CommonLang.msg("MSG374") %> " +  document.forms.contentForm.imsi_po_create_date.value +" <%=CommonLang.msg("MSG375") %>\n\n<%=CommonLang.msg("MSG376") %>")){
                return;
            }
        }
    } 
    
    //setAMTCheck(recvFlag);
    doCheckAMT(recvFlag);

}

var g_dt_buyer = "";
//예산 체크 모듈 (ICOMCMPY.BUDGET_FLAG="Y" 구매사만 예산 체크)
function doCheckAMT(recvFlag){
	g_dt_buyer = "";
	var buyer	 = document.forms.searchForm.st_buyer.value;
    var tot_cnt  = $("#display_item_cnt").val(); 
    var cnt      = getCheckedRowCount(tot_cnt);
    var budget_dept_flg = "<%=p060000134%>"
    var pr_no       = ""; 
    var query = "";
    if(eval(tot_cnt) < 2){
        var box =  eval("document.forms.contentForm.lnCheck0" );
        if(box.checked == true){
				pr_no       = document.forms.contentForm.db_pr_no.value;
            var pr_seq      = document.forms.contentForm.db_pr_seq.value;
            var recv_qty    = document.forms.contentForm.db_qty.value;
            var account_type    = document.forms.contentForm.st_account_type.value;
            var budget_dept     = document.forms.contentForm.st_budget_dept.value;
            var buyer     = document.forms.contentForm.st_dt_buyer_code.value;
            g_dt_buyer = buyer;
            var total   = pr_seq+"@@"+recv_qty+"@@"+account_type+"@@"+budget_dept+"@@"+pr_no+"@@"+buyer;
            query += total;
            query += "|";
        }
    }else{
        for(var k = 0; k < tot_cnt; k++){
            var box =  eval("document.forms.contentForm.lnCheck" + k);
            if(box.checked == true){
					pr_no			= document.forms.contentForm.db_pr_no[k].value;
                var pr_seq          = document.forms.contentForm.db_pr_seq[k].value;
                var recv_qty        = document.forms.contentForm.db_qty[k].value;
                var account_type    = document.forms.contentForm.st_account_type[k].value;
                var budget_dept     = document.forms.contentForm.st_budget_dept[k].value;
                var buyer     = document.forms.contentForm.st_dt_buyer_code[k].value;
                g_dt_buyer = buyer;
                var total   = pr_seq+"@@"+recv_qty+"@@"+account_type+"@@"+budget_dept+"@@"+pr_no+"@@"+buyer;
                query += total;
                query += "|";
            }
        }
    }
    document.forms.processForm.st_query.value  = query;            
    document.forms.processForm.st_buyer.value  = g_dt_buyer;           
    document.forms.processForm.st_bdgt_pr_no.value  = pr_no;           
    document.forms.processForm.recvFlag.value  = recvFlag;           
    document.forms.processForm.st_budget_dept_flg.value = budget_dept_flg;
    kepAjaxFormCall("/mppo/buyerAdminBdgtTempOrderDetailCheck.do","processForm","BUYERADMINBDGTTEMPORDERCHECK"); 	       
}


function setCheckEnd(FLAG,recvFlag,end_price){
    if(FLAG == "OK"){
           document.forms.searchForm.nu_end_price.value = end_price;
           setData(recvFlag);
    }
}




var payment_flag = "Y";
all_list2       =   new     Array();
check_list2     =   new     Array();
function setData(recvFlag){
	
	
    var f = document.forms.searchForm;
	var buyer	 = f.st_buyer.value;
    var tot_cnt  = $("#display_item_cnt").val(); 
    var userID          = f.userID.value;
    var userTEL         = f.st_add_user_tel.value;
    var userDept        = f.userDept.value;
	var sum_price		= f.st_sum_price.value;
	var checked_cnt		= 0;
    var prSubject       = "";
    var remark          = "";
    var notify          = "";
    var tel             = f.st_add_user_tel.value;
    var dely_to_address = ""; 
    if((recvFlag == '3') && (!confirm("<%=CommonLang.msg("MSG377") %>  "))) return;	//발주보류 하시겠습니까?
    f.delete_flag.value = "N";
    f.multi_flag.value  = "N";
    
    var maxRow = getCheckedRowCount(tot_cnt);
    all_list   =  new Array(maxRow);
    check_list =  new Array(maxRow);
    var cc_flag    = "N";
    var cs_flag    = "N";
    var multi_flag = "N"; 
    
    if(eval(tot_cnt) < 2){
        var box = eval("document.forms.contentForm.lnCheck0" );
        var true_check      = box.value;
        var pay_terms       = document.forms.contentForm.db_pay_terms.value;
        all_list[0]         = pay_terms;
        check_list[0]       = true_check;
        if(box.checked == true){
			checked_cnt = 1;
            if(pay_terms=="CC"){
                cc_flag = "Y";
            }else{
                cs_flag = "Y";
            }
        }
    }else{
        for(var k = 0; k < tot_cnt; k++){
            var box =  eval("document.forms.contentForm.lnCheck"  + k);
            var true_check      = box.value;
            var pay_terms       = document.forms.contentForm.db_pay_terms[k].value;
            all_list[k]       = pay_terms;
            check_list[k]     = true_check;
            if(box.checked == true){
				checked_cnt++;
                if(pay_terms=="CC"){
                    cc_flag = "Y";
                }else{
                    cs_flag = "Y";
                }
            }
        }
        //alert(query);
    }
    if((cc_flag=="Y") && (cs_flag=="Y")){
            multi_flag = "Y";
            f.multi_flag.value = "Y";
    }
    if(cc_flag=="Y"){
         payment_flag = "Y";
         f.payment_new.value ="Y";
    }else{
         payment_flag = "N";
         f.payment_new.value ="N";
    }
    // 구매발주 일때
    if(recvFlag!="3"){
        if(multi_flag=="Y"){
            if(eval(tot_cnt) < 2){
                var box =  eval("document.forms.contentForm.lnCheck0" );
                if(box.checked == true){
                    var temp_pay_terms     = document.forms.contentForm.db_pay_terms.value;
                    var temp_buyer_item_no = document.forms.contentForm.db_buyer_item_no.value;
                    if(temp_pay_terms=="CC"){           // 카드결제 항목은 FALSE 세팅 , 나중에 카드 결제시 다시 TRUE 세팅
                        box.checked = false;
                    }
                    if(!isEmpty("<%=p060000130_col01%>") && "<%=p060000130_col01%>" == temp_buyer_item_no){
                    	alert("<%=p060000130_col02%>");
                    }
                }
            }else{
            	var alert_flg = true;
                for(var k = 0; k < tot_cnt; k++){
                    var box =  eval("document.forms.contentForm.lnCheck"  + k);
                    if(box.checked == true){
                        var temp_pay_terms     = document.forms.contentForm.db_pay_terms[k].value;
                        var temp_buyer_item_no = document.forms.contentForm.db_buyer_item_no[k].value;
                        if(temp_pay_terms=="CC"){           // 카드결제 항목은 FALSE 세팅 , 나중에 카드 결제시 다시 TRUE 세팅
                            box.checked = false;
                        }
                        if(!isEmpty("<%=p060000130_col01%>") && "<%=p060000130_col01%>" == temp_buyer_item_no){
                        	if(alert_flg){
	                        	alert("<%=p060000130_col02%>");
	                        	alert_flg = false;
                        	}
                        }
                    }
                }
            }
            if(recvFlag == '1'){
                payment_flag    =   "N";
                // 품목수 : 총 금액 :  선택한 품목을 구매대행 발주하시겠습니까? 
                if( !confirm("<%=CommonLang.msg("MSG378") %> : "+checked_cnt+", <%=CommonLang.get("HTITLE172") %> : "+sum_price+"\n<%=CommonLang.msg("MSG380") %>") ){
                    return;
                }else{
                
                 document.forms.processForm.TYPE.value = "PX";	 
           	     document.forms.processForm.COM_CODE.value = g_dt_buyer; 	
        	     kepAjaxFormCall("/mpso/newBuyerCommonPassbiz.do","processForm","NEWBUYERCOMMONPASSBIZ");         	      
                }
            }else{
                ServerCall("N","PT");
            }
        }else{
   
        	if(eval(tot_cnt) < 2){
                var box =  eval("document.forms.contentForm.lnCheck0" );
                if(box.checked == true){
                    var temp_buyer_item_no = document.forms.contentForm.db_buyer_item_no.value;
                    if(!isEmpty("<%=p060000130_col01%>") && "<%=p060000130_col01%>" == temp_buyer_item_no){
                    	alert("<%=p060000130_col02%>");
                    }
                }
            }else{
            	var alert_flg = true;
                for(var k = 0; k < tot_cnt; k++){
                    var box =  eval("document.forms.contentForm.lnCheck"  + k);
                    if(box.checked == true){
                        var temp_buyer_item_no = document.forms.contentForm.db_buyer_item_no[k].value;
                        if(!isEmpty("<%=p060000130_col01%>") && "<%=p060000130_col01%>" == temp_buyer_item_no){
                        	if(alert_flg){
	                        	alert("<%=p060000130_col02%>");
	                        	alert_flg = false;
                        	}
                        }
                    }
                }
            }
            if(recvFlag == '1'){
            	
                if(payment_flag=="Y"){  //  카드결제인 경우
                	//선택한 품목을 전자지불 하시겠습니까?
                    if(!confirm("<%=CommonLang.msg("MSG379") %>") ){
                        return;
                    }
                }else{
                	// 품목수 : 총 금액 :  선택한 품목을 구매대행 발주하시겠습니까? 
                    if( !confirm("<%=CommonLang.msg("MSG378") %> : "+checked_cnt+", <%=CommonLang.get("HTITLE172") %> : "+sum_price+"\n<%=CommonLang.msg("MSG380") %>") ){
                        return;
                    }else{
                        document.forms.processForm.TYPE.value = "PX";	 
                  	    document.forms.processForm.COM_CODE.value = g_dt_buyer; 	
              
               	     	kepAjaxFormCall("/mpso/newBuyerCommonPassbiz.do","processForm","NEWBUYERCOMMONPASSBIZ");  
                    }
                }
            }else{
                ServerCall("N","PT");
            }
        }
        all_list2       =   all_list;
        check_list2     =   check_list;
    }else{  //  임시저장 일때
        ServerCall("N","PT");
    }
}




function ServerCall(GW_NO,recvFlag){    //PS(결재중),PC(결재완료),PT(임시저장)
    var query = "";
//    alert( GW_NO + "  " + recvFlag );
    var asFlag = recvFlag;
  
    if(recvFlag =="PC" || recvFlag =="PS" || recvFlag =="1") {
            recvFlag= '1';
    }else{
            recvFlag='3';
    }
    
    var f = document.forms.searchForm;
    var frm = document.forms.contentForm;
     
    
    
    f.gw_no_new.value     = GW_NO;
    f.recv_flag_new.value = recvFlag;
    f.as_flag_new.value   = asFlag; 
    var buyer                = f.st_buyer.value;
    var userID               = f.userID.value;
    var userDept             = f.userDept.value;
    var reqDept              = f.reqDept.value;
    var prSubject            = " ";
    var remark               = " ";
    var notify               = f.st_notify.value;
    var tel                  = f.st_add_user_tel.value;
    var dely_to_address_text = " ";
    var dely_to_address      = " ";
    var account_type_code    = f.st_account_type_code.value;      // ACCOUNT_TYPE (계정분류)
    if(reqDept==""){
        reqDept=" ";
    }
    if(account_type_code==""){
        account_type_code=" ";
    }
    var userTel              = "<%=userTel%>";
    if(userTel==""){
        userTel=" ";
    }
    var usrname              = "<%=userName%>";
    if(usrname==""){
        usrname=" ";
    }
    var end_price            = f.nu_end_price.value; //예산차액
    if(end_price==""){
        end_price ="0";
    }
    var po_create_date = frm.st_po_create_date.value;
    // 선입고
    f.st_gr_flag.value = "N";
    var gr_flag = f.st_gr_flag.value;
    var  aaaa = "aaaa";
    var tot_cnt  = $("#display_item_cnt").val();
    var st_dt_buyer_code = "";
    if(eval(tot_cnt) < 2){
        var box = eval("document.forms.contentForm.lnCheck0" );
        if(box.checked == true){
                var pr_no           = frm.db_pr_no.value;
                var pr_seq          = frm.db_pr_seq.value;
                var recv_qty        = frm.db_qty.value;
                var ref_no          = frm.db_ref_no.value;
                var return_reason   = frm.db_return_reason.value;
                var rd_date         = frm.db_rd_date.value;
				var po_remark       = frm.po_remark.value;
				st_dt_buyer_code       = frm.st_dt_buyer_code.value;
                if(ref_no ==""){
                    ref_no = " ";
                }
                if(return_reason ==""){
                    return_reason = " ";
                }
				if(po_remark ==""){
                    po_remark = " ";
                }
				var total   = pr_no+"~~~"+pr_seq+"~~~"+recv_qty+"~~~"+ref_no+"~~~"+return_reason+"~~~"+rd_date+"~~~"+po_remark+"~~~";
                frm.db_total.value = total;
                query += total
                query += "@@";
        }
    }else{
        for(var k = 0; k < tot_cnt; k++){
            var box = eval("document.forms.contentForm.lnCheck" + k );
            if(box.checked == true){
                var pr_no           = frm.db_pr_no[k].value;
                var pr_seq          = frm.db_pr_seq[k].value;
                var recv_qty        = frm.db_qty[k].value;
                var ref_no          = frm.db_ref_no[k].value;
                var return_reason   = frm.db_return_reason[k].value;
                var rd_date         = frm.db_rd_date[k].value;
				var po_remark       = frm.po_remark[k].value;
				st_dt_buyer_code       = frm.st_dt_buyer_code[k].value;
                if(ref_no ==""){
                    ref_no = " ";
                }
                if(return_reason ==""){
                    return_reason = " ";
                }
				if(po_remark ==""){
                    po_remark = " ";
                }
				var total   = pr_no+"~~~"+pr_seq+"~~~"+recv_qty+"~~~"+ref_no+"~~~"+return_reason+"~~~"+rd_date+"~~~"+po_remark+"~~~";
                frm.db_total[k].value = total;
                query += total;
                query += "@@";
            }
        }
    }
    query += "|";
    query += st_dt_buyer_code;
    query += "|";
    query += userID;
    query += "|";
    query += userDept;
    query += "|";
    query += recvFlag;
    query += "|";
    query += userTel;
    query += "|";
    query += usrname;
    query += "|";
    query += GW_NO;
    query += "|";
    query += po_create_date;
    query += "|";
    query += gr_flag;
    query += "|";
    query += end_price;
    query += "|";
    query += "PRPO";                 // (PXPR)직발주 인지 , (PRPO)요청접수발주인지 구분
    query += "|";
    query += account_type_code;      // 계정분류
    query += "|";
    query += reqDept;                // 요청부서
    query += "|";


    document.forms.processForm.nu_end_price.value =  f.nu_end_price.value;	    
    document.forms.processForm.st_po_create_date.value =  frm.st_po_create_date.value;	  
    document.forms.processForm.st_account_type_code.value =  f.st_account_type_code.value;	  
    document.forms.processForm.gw_no_new.value =  f.gw_no_new.value;	  
    document.forms.processForm.recv_flag_new.value =  f.recv_flag_new.value;	  
    document.forms.processForm.as_flag_new.value =  f.as_flag_new.value;	      
    document.forms.processForm.st_query.value = query;	  
    kepAjaxFormCallAsync("/mppo/saveInsertMergePxPo.do","processForm","SAVEINSERTMERGEPXPO");         	
    
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




function kepApprovalReturn(ERR,GW_NO){ 
    	EndPassProcess(ERR,GW_NO); 
}

// 상신결과
function EndPassProcess(ERR,GW_NO){
	
//	alert("GW_NO "+GW_NO);
    if(ERR=="true"){
        ServerCall(GW_NO,"PS");
    }
}

function setResultCheckBdgtAmt(result, row)
{
	selectedRow = "";
	if (eval(result) <1){
		result = "ERR";
	}else{
		result = "OK";
	}
    var tot_cnt  =  $("#display_item_cnt").val(); 
    if(eval(tot_cnt) < 2)
    {
        if(result == "OK")
        {
            prRecvReturnReason(0);
        }
        else
        {
        	//예산초과하여 수량변경을 할 수 없습니다.
            alert("<%=CommonLang.msg("MSG212") %>");
            returnToQty(row);
            return;
        }
    }
    else
    {
        if(result == "OK")
        {
            prRecvReturnReason(row);
        }
        else
        {
        	//예산초과하여 수량변경을 할 수 없습니다.
            alert("<%=CommonLang.msg("MSG212") %>");
            returnToQty(row);
            return;
        }
    }
}
/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
	

	//var sMsg = response.msg.MSG;    
	var query = "";
	
	//alert("kepAjaxSuccess pMethod "+pMethod);
	
	var flag = "";
	var budget_dept_name = "";
	var account_text = "";
	var plan_amt = "";
	var result_amt = "";
	var temp_amt = "";
	var tot_price = "";	
	
	/*
	var result = response.msg.MSG;   	
	if(result == "DUP"){
		alert("해당 요청번호는 이미 진행되었습니다.");
        return;
	} 
	*/
	
	  
    if(pMethod == "DEPT_TRANSFER")  
    { 
    	
		result = response.msg.MSG;   		
		if (result == "DUP"){
				//선택된 대상중 발주 진행된 요청번호가 존재합니다.\n재 조회 후 확인부탁드립니다.
	           alert("<%=CommonLang.msg("MSG213") %>");
	           return;
		}
		if (result == "DUP2"){
				//선택된 대상중 반려된 요청번호가 존재합니다.\n재 조회 후 확인부탁드립니다.
	           alert("<%=CommonLang.msg("MSG214") %>");
	           return;
		}
		//부서이관이 성공적으로 이루어 졌습니다.
    	 alert(" <%=CommonLang.msg("MSG215") %> ");
     	// 처리후 재조회
     	kepSearch($("#curPage").val());        
    }  else if(pMethod == "REJECT"){
    	
		result = response.msg.MSG;   		
		if (result == "DUP"){
				//선택된 대상중 발주 진행된 요청번호가 존재합니다.\n재 조회 후 확인부탁드립니다.
	           alert("<%=CommonLang.msg("MSG213") %>");
	           return;
		}
		if (result == "DUP2"){
				//선택된 대상중 반려된 요청번호가 존재합니다.\n재 조회 후 확인부탁드립니다.
	           alert("<%=CommonLang.msg("MSG214") %>");
	           return;
		}
		
		//반려가 성공적으로 이루어 졌습니다.
        alert(" <%=CommonLang.msg("MSG216") %> ");
     	// 처리후 재조회
     	kepSearch($("#curPage").val());                
    }  else if(pMethod == "BUYERADMINBDGTTEMPORDERCHECK"){ 
    		var gbnYn = "Y";
			var recvFlag =  document.forms.processForm.recvFlag.value;
			var end_price =  document.forms.processForm.end_price.value;
    		for(var i=0; i < response.data.length; i++ ){
				flag = $.trim(eval("response.data["+i+"].BUYER_CHECK"));
				budget_dept_name = $.trim(eval("response.data["+i+"].BUDGET_DEPT_NAME"));
				account_text = $.trim(eval("response.data["+i+"].ACCOUNT_TYPE_TEXT"));
				plan_amt = $.trim(eval("response.data["+i+"].PLAN_AMT"));
				result_amt = $.trim(eval("response.data["+i+"].RESULT_AMT"));
				temp_amt = $.trim(eval("response.data["+i+"].TEMP_AMT"));
				tot_price = $.trim(eval("response.data["+i+"].TOT_AMT"));
			    if(flag == "예산초과"){
			    	//예산 원 구매가능 예산 원 구매금액 원 예산이 초과되어 구매할 수 없습니다.
			        alert(budget_dept_name +
			              "\n\n"+account_text+" <%=CommonLang.msg("MSG381") %>   "+kepCommaNum(plan_amt)+" <%=CommonLang.get("HTITLE660") %>"+
			              "\n\n"+account_text+" <%=CommonLang.msg("MSG382") %>   "+kepCommaNum(plan_amt-(eval(result_amt)+eval(temp_amt)))+" <%=CommonLang.get("HTITLE660") %>"+
			              "\n\n"+account_text+" <%=CommonLang.msg("MSG383") %>   "+kepCommaNum(tot_price)+" <%=CommonLang.get("HTITLE660") %>"+
			              "\n\n<%=CommonLang.msg("MSG384") %>");
			        gbnYn = "N";
			        return ;
			    } else if(flag == "예산미편성"){
			    	//예산이 편성되어 있지 않습니다.\n\n 확인 후 다시 주문해 주시기 바랍니다.
			        alert(budget_dept_name + " "+account_text+ " <%=CommonLang.msg("MSG219") %>");
			        gbnYn = "N";
			        return;
			    } else if(flag == "100"){
			    	//예산이 편성되어 있지 않습니다. 확인 후 다시 주문해 주시기 바랍니다.
			    	alert("<%=CommonLang.msg("MSG219") %>");
			    	gbnYn = "N";
			        return;
			    }
    		}
    		if(gbnYn == "Y"){
    			setCheckEnd('OK',recvFlag,end_price);
    		}
    } else if (pMethod == "NEWBUYERCOMMONPASSBIZ"){ 		
		var checkpass = response.msg.CHECKPASS;   
		var pass_flag = response.msg.PASS_FLAG;   		
		GoPass(checkpass,pass_flag,"",g_dt_buyer);
	}else if (pMethod ==  "BUYERADMINBDGTTEMPQTYCHECK"){
		
    	if (response.data.length > 0){
    		result = $.trim(eval("response.data[0].CNT")); 
			setResultCheckBdgtAmt(result, selectedRow);
			
    	}
	}else if (pMethod ==  "SAVEREFPRNO"){//관리번호 저장 성공시
		//저장 되었습니다.
        alert(" <%=CommonLang.msg("MSG31") %> ");
     	// 처리후 재조회
     	kepSearch($("#curPage").val());    
	}else{
		result = response.msg.MSG;   		
		if (result == "DUP"){
				//선택된 대상중 발주 진행된 요청번호가 존재합니다.\n재 조회 후 확인부탁드립니다.
	           alert("<%=CommonLang.msg("MSG213") %>");
	           return;
		}
		if (result == "DUP2"){
				//선택된 대상중 반려된 요청번호가 존재합니다.\n재 조회 후 확인부탁드립니다.
	           alert("<%=CommonLang.msg("MSG214") %>");
	           return;
		}
		//alert("result "+result);
        var pr_no_value   = result.substr(0,2);
        var gw_no_new     = document.forms.searchForm.gw_no_new.value;
        var recv_flag_new = document.forms.searchForm.recv_flag_new.value;
        var as_flag_new   = document.forms.searchForm.as_flag_new.value;
        if(pr_no_value == "PR" || pr_no_value == "PX"){
            if((!(result == "" || result == "null")) && gw_no_new == 'N' && recv_flag_new =='1' ) {
            	//구매대행 발주가 성공적으로 이루어 졌습니다.\n\n구매대행 발주번호는 입니다.
                alert("<%=CommonLang.msg("MSG221") %> "+ result + " <%=CommonLang.msg("MSG385") %>");
            }else if((!(result == "" || result == "null"))&&  as_flag_new =='PS' ) {
            	//구매대행발주 결재상신이 성공적으로 이루어 졌습니다.\n\n결재상신된 구매대행번호는 입니다.
                alert("<%=CommonLang.msg("MSG222") %> "+ result + " <%=CommonLang.msg("MSG385") %>");
            }else if((!(result == "" || result == "null"))&&  recv_flag_new =='3' ) {
            	//발주보류가 성공적으로 이루어 졌습니다.\n\n발주보류번호는 입니다.
                alert("<%=CommonLang.msg("MSG223") %> "+ result + " <%=CommonLang.msg("MSG385") %>");
            }
        }else{
        	//구매대행 발주생성에 실패하였습니다. 다시 확인하여 주시기 바랍니다.
            alert("<%=CommonLang.msg("MSG224") %>");
            return;
        }
        
     	// 처리후 재조회
     	kepSearch($("#curPage").val());   
     	
    }
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	

	//alert("kepAjaxError pMethod "+pMethod);
	
	if (pMethod == "DEPT_TRANSFER"){ 
		//부서이관 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.
		 alert("<%=CommonLang.msg("MSG225") %>  "); 
	} else if(pMethod == "REJECT"){
		//요청품목 반려에 실패하였습니다. 다시 한 번 시도해 주시기 바랍니다.
		alert(" <%=CommonLang.msg("MSG226") %>  ");       
    }else if(pMethod == "BUYERADMINBDGTTEMPORDERCHECK"){
    	//시스템 오류입니다. 관리자에게 전화하시기 바랍니다.
    	alert("<%=CommonLang.msg("MSG227") %>");
    }else {
    	//시스템 오류입니다. 관리자에게 문의하시기 바랍니다.
    	alert("<%=CommonLang.msg("MSG228") %>");
    }
	
} 
 
//관리번호 저장
function saveRefPrNo(){
    var chk_cnt     = 0;
    var reject_flag = "Y";
    var query     = "";
    var tot_cnt  = $("#display_item_cnt").val();
    var st_msg = "<%=p060000113_type%>";
    if(eval(tot_cnt) == 0)
    {
    	//조회한 데이타가 없습니다.
        alert("<%=CommonLang.msg("MSG69") %>");
        return;
    }
    if(eval(tot_cnt) < 2){
        var box =  eval("document.forms.contentForm.lnCheck0");
        if(box.checked == true){
        	// 관리번호
        	var st_ref_pr_no =document.forms.contentForm.st_ref_pr_no.value;
        	if(st_ref_pr_no == "" || st_ref_pr_no == null|| st_ref_pr_no == " "){
        		alert(st_msg);
        		document.forms.contentForm.st_ref_pr_no.focus();
        		return;
        	}
            chk_cnt++;
            query += box.value;                                         // BUYER + PR_NO + PR_SEQ
            query += "@@";
            query += st_ref_pr_no;          // 관리번호
            query +=  "|";
        }
    }else{
        for(var k = 0; k < tot_cnt; k++){
            var box = eval("document.forms.contentForm.lnCheck" +k);
            if(box.checked == true){
            	// 관리번호
            	var st_ref_pr_no =document.forms.contentForm.st_ref_pr_no[k].value;
            	if(st_ref_pr_no == "" || st_ref_pr_no == null|| st_ref_pr_no == " "){
            		alert(st_msg);
            		document.forms.contentForm.st_ref_pr_no[k].focus();
            		return;
            	}
                chk_cnt++;
                query += box.value;                                         // BUYER + PR_NO + PR_SEQ
                query += "@@";
                query += st_ref_pr_no;          // 관리번호
                query +=  "|";
            }
        }
    }
    if(chk_cnt == "0")
    {
    	//하나 이상의 상품이 선택되어야 합니다.   
        alert("<%=CommonLang.msg("MSG17") %>");
        return;
    }
    document.forms.processForm.st_query.value  = query;           
    //관리번호저장
    kepAjaxFormCall("/mppo/saveRefPrNo.do","processForm","SAVEREFPRNO"); 
   
}
</script>
</html>
