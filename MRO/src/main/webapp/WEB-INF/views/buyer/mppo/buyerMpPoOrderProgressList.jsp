<%--
**********************************************
* 메뉴 : 발주관리>발주진행관리
* 화면 : 발주진행관리
* 기능 : 구매발주 내역을 조회하고 진행상태를 확인할 수 있다.
* 프로그램 ID : PG_06_B_019_00
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
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	
	  
	  
	String curDate   = CommonUtil.formatDateNoDateGubun(new Date(),1);
	String st_from_date  = "";
	String st_to_date    = "";
	st_from_date        = CommonUtil.nvl((String) request.getParameter("st_from_date"),"");
	if( st_from_date.equals("")){    	
		st_from_date    = CommonUtil.addDate(new Date(),"M",-1,1);
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
	 
	String conv_from_date = st_from_date.replace("/", "");
	String conv_to_date = st_to_date.replace("/", "");
	
	String st_dept_type        = CommonUtil.nvl((String) request.getParameter("st_dept_type"),""); 
	String st_req_dept_name        = CommonUtil.nvl((String) request.getParameter("st_req_dept_name"),""); 
	String st_req_dept_code        = CommonUtil.nvl((String) request.getParameter("st_req_dept_code"),""); 
	String st_search_type        = CommonUtil.nvl((String) request.getParameter("st_search_type"),"");  
	String st_search_no        = CommonUtil.nvl((String) request.getParameter("st_search_no"),"");	
	String st_code_type        = CommonUtil.nvl((String) request.getParameter("st_code_type"),"");  
	String st_code_no        = CommonUtil.nvl((String) request.getParameter("st_code_no"),"");  
	String st_user_type        = CommonUtil.nvl((String) request.getParameter("st_user_type"),"");  
	String st_po_user_name        = CommonUtil.nvl((String) request.getParameter("st_po_user_name"),"");
	String st_docu_chk        = CommonUtil.nvl((String) request.getParameter("st_docu_chk"),"N");
	String st_status        = CommonUtil.nvl((String) request.getParameter("st_status"),"");  
	
	String st_sort_column        = CommonUtil.nvl((String) request.getParameter("st_sort_column"),"ALL");  
	String st_sort_flag        = CommonUtil.nvl((String) request.getParameter("st_sort_flag"),"");  
	
	String st_com_code = CommonUtil.nvl((String) request.getParameter("st_com_code"),"");  // 계열사정보
	
	String st_not_gr_chk        = CommonUtil.nvl((String) request.getParameter("st_not_gr_chk"),"N");
	
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
	 
	//SLOGIC-BEGIN(P06-0000022) 발주전제 조회
	String p060000022 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000022","COL01_DATA");   
	if ("ALL".equals(p060000022)){
		SessionUserDept = "";
	} else {
		 if (!"".equals(p060000022)){
			 String grant[] = p060000022.split("\\^");
			 if (grant != null){ 
				 if (grant.length>0){
					 for (int i=0; i<grant.length; i++){ 							
						 if (SessionUserId.equals(grant[i])){
							 SessionUserDept = "";
							 break;
						 }
					 }
				 }
			 }
		 }
	}      
   //SLOGIC-END
   
   //SLOGIC-BEGIN(P06-0000069) 고객사별 엑셀다운로드 형식 1줄/2줄 결정
   boolean p060000069 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000069");
   //SLOGIC-BEGIN(P06-0000098) 관리번호별 집계화면 활성화 기능
   boolean p060000098 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000098");
   //SLOGIC-END
 
   boolean getCodeTGCM = CommonUtil.getCode3CheckReturn("TGCM", SessionUserId, buyer);
   
   String group_mng_flag = "N";

   if(getCodeTGCM == true){
	   group_mng_flag = "Y"; 
   }
   
   //일진다이아몬드(주)(KRILJI0001) ILJIN_PUR 전체발주리스트 조회 권한 부여
   if ("ILJIN_PUR".equals(SessionUserId)){
	   SessionUserDept = "";
   }
   //결재타입 여부
   String st_docu_type = CommonUtil.getDocuTypeCheckReturn(buyer,"PX");
   String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),row_cnt); // 정렬갯수 
   
   //엑셀다운로드 기능 통제
   boolean p170000001 = CommonUtil.getSpecialCheckReturn(buyer,"P17-0000001");
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
	<h3><%=CommonLang.get("HTITLE256") %><!-- 발주진행관리 --></h3>
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
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
		<input type="hidden" name="st_sort_column" id="st_sort_column" value="<%=st_sort_column%>">
		<input type="hidden" name="st_sort_flag" id="st_sort_flag" value="<%=st_sort_flag%>">
		<input type="hidden" name="st_user_dept" id="st_user_dept" value="<%=SessionUserDept%>">
		<input type="hidden" name="st_group_mng_flag" id="st_group_mng_flag" value="<%=group_mng_flag%>">
		<input type="hidden" name="st_group_info" id="st_group_info" value="">
		<input type="hidden" name="st_docu_chk" id="st_docu_chk" value="<%=st_docu_chk%>">
		<input type="hidden" name="st_not_gr_chk" id="st_not_gr_chk" value="<%=st_not_gr_chk%>">
		
		<div id="cont_searchA">	
			<table class="cont_t_list01"  >
				<caption><%=CommonLang.get("HTITLE7") %><!-- 조회 --></caption>
				<colgroup>
                    <col width="10%" />
                    <col width="21%" />
                    <col width="10%" />
                    <col width="21%" />
                    <col width="10%" />
                    <col width="21%" />      
				</colgroup>
				
				<tbody>
				<tr>
					<th><%=CommonLang.get("HTITLE252") %><!-- 주문일자 --></th>
					<td colspan="3">
						<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:15%; text-align:center;" value="<%=st_from_date%>">
							<a href="javascript:kepCalendar('st_from_date')"></a>-
						<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:15%; text-align:center;" value="<%=st_to_date%>">
							<a href="javascript:kepCalendar('st_to_date')"></a> 
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1<%=CommonLang.get("HTITLE602") %><!-- 개월 --></a></span>  
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3<%=CommonLang.get("HTITLE602") %><!-- 개월 --></a></span>			
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','6')">6<%=CommonLang.get("HTITLE602") %><!-- 개월 --></a></span>
							<span class="btn_month"><a href="javascript:setCurMonth('st_from_date','st_to_date')">당월</a></span>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<span style="vertical-align: middle;"><input type="checkbox"  id="st_gr_chk"  name="st_gr_chk" class="input_noline"  title=""  value=""  <%=("Y".equals(st_not_gr_chk))?"checked":"" %>>&nbsp;<%=CommonLang.get("HTITLE958") %><!-- 미입고 --></span>
					</td>  
                       
				    <th>
                        <label for="b_code" class="hidden">부서선택</label>                        
			  			<select name = "st_dept_type" id="st_dept_type"  class="TitSelect">
				      		<option value="PR" <%if ("PR".equals(st_dept_type)) {%>selected<%} %>><%=CommonLang.get("HTITLE135") %><!-- 요청부서 --></option>
				      		<option value="VN" <%if ("VN".equals(st_dept_type)) {%>selected<%} %>><%=CommonLang.get("HTITLE144") %><!-- 협력사 --></option> 
                          </select> 
                       </th>
					<td colspan="3">
						<input type="text" class="input_type_text" name="st_req_dept_name" id="st_req_dept_name" style="width:55%;ime-mode:active" value="<%=st_req_dept_name%>" READONLY>
						<input type="hidden" name="st_req_dept_code" id="st_req_dept_code" value="<%=st_req_dept_code%>">
						<a href="javascript:getPopType();"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
						<a href="javascript:kepEraser('st_req_dept_code','st_req_dept_name');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
					
					</td>
				</tr>
				<tr>
					<th>
						<label for="b_code" class="hidden">품목선택</label>                        
			  			<select name = "st_search_type" id="st_search_type" class="TitSelect" style="height:20px;">
				      		<option value="BC" <%if ("BC".equals(st_search_type)) {%>selected<%} %>><%=CommonLang.get("HTITLE12") %><!-- 품목코드 --></option>
				      		<option value="DE" <%if ("DE".equals(st_search_type)) {%>selected<%} %>><%=CommonLang.get("HTITLE13") %><!-- 품목명 --></option>
				      		<option value="SP" <%if ("SP".equals(st_search_type)) {%>selected<%} %>><%=CommonLang.get("HTITLE14") %><!-- 규격 --></option>  
                          </select> 					
					</th>
					<td>
				 			<input type="text" class="input_type_text" name="st_search_no" id="st_search_no" style="width:87%;ime-mode:active" value="<%=st_search_no%>" onKeyDown="kepEnter()">
					</td>
					<th>
						<label for="b_code" class="hidden">번호선택</label>                        
			  			<select name = "st_code_type" id="st_code_type"  class="TitSelect" style="height:20px;">
				      		<option value="IN" <%if ("IN".equals(st_code_type)) {%>selected<%} %>><%=CommonLang.get("HTITLE186") %><!-- 주문번호 --></option>
				      		<option value="PO" <%if ("PO".equals(st_code_type)) {%>selected<%} %>><%=CommonLang.get("HTITLE203") %><!-- 발주번호 --></option>
				      		<option value="PR" <%if ("PR".equals(st_code_type)) {%>selected<%} %>><%=CommonLang.get("HTITLE216") %><!-- 요청번호 --></option>
				      		<option value="RN" <%if ("RN".equals(st_code_type)) {%>selected<%} %>><%=CommonLang.get("HTITLE18") %><!-- 관리번호 --></option>
				      		<option value="ON" <%if ("ON".equals(st_code_type)) {%>selected<%} %>><%=CommonLang.get("HTITLE259") %><!-- 품목번호 --></option>
				      		<option value="LPN" <%if ("LPN".equals(st_code_type)) {%>selected<%} %>>I/F발주번호</option>
                          </select> 					
					</th>
						<td> 
 							<input type="text" class="input_type_text" name="st_code_no" id="st_code_no" style="width:67%;ime-mode:active" value="<%=st_code_no%>" onKeyDown="kepEnter()">
                           </td>
						<td>
						<label for="b_code" class="hidden">요청발주선택</label>                        
			  			<select name = "st_user_type" id="st_user_type"   class="TitSelect" style="height:20px;">
				      		<option value="PR" <%if ("PR".equals(st_user_type)) {%>selected<%} %>><%=CommonLang.get("HTITLE133") %><!-- 요청자 --></option>
				      		<option value="PO" <%if ("PO".equals(st_user_type)) {%>selected<%} %>><%=CommonLang.get("HTITLE187") %><!-- 발주자 --></option> 
                          </select> 										
						</td>
						<td>
							<input type="text" class="input_type_text" name="st_po_user_name" id="st_po_user_name" style="width:63%;ime-mode:active" value="<%=st_po_user_name %>">
						</td>
					</tr>
					<tr>
						<th><%=CommonLang.get("HTITLE136") %><!-- 진행상태 -->
						</th>
						<td>
						<label for="b_code" class="hidden">진행상태</label>                      
						<select name = "st_status" id="st_status" style="width:90%;height:20px;">
        					<%= CommonUtil.getCodeComboQueryIdList("buyer.mppo.getPxStatusList","ALL",st_status) %> 
                          </select> 					
						</td>
					<%if(st_docu_type.equals("Y")){%>	
						<th><input type="checkbox"  id="st_docu_type_chk"  name="st_docu_type_chk" class="input_noline"  title=""  value=""  <%=("Y".equals(st_docu_chk))?"checked":"" %>>&nbsp;<%=CommonLang.get("HTITLE790") %><!-- 본인 결재건 조회 --></th>
						<td>
						</td>
					<%}else{%>
						<th></th>
						<td></td>
					<%}%>
					<%if(group_mng_flag.equals("Y")){%>
						<th><%=CommonLang.get("HTITLE604") %><!-- 고객사 --></th>
				      	<td>
					        <select name="st_com_code" id="st_com_code" style="width:90%;height:20px;" onchange="buyerChange()">
					        	<%= CommonUtil.getCode3ComboList(_sessionInfo.getComCode(), "ALL", "TGCM",_sessionInfo.getUserId(), "ICOMCOD3", st_com_code, "") %>
					        </select>
				      	</td>
					<%}else{%>
						<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
					<%}%>
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
			</select>
      	</span>      
 		<span class="fr" ><b><%=CommonLang.get("HTITLE172") %><!-- 총 금액 --> :</b> 
 			<input type="text" name="s_display_item_amt_sum" class="input_type_text" size="14" value="" READONLY style="background-color:#FFFFFF;font-weight: bold;font-size:9pt;text-align:right;border:#FFFFFF 1px solid;"><b><%=CommonLang.get("HTITLE660") %><!-- 원 --></b>&nbsp;
 		</span> 
       	<br>
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<!-- 공통 -->
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
	  	
		<table id="table_list" class="cont_t_list02" >
		<%if(group_mng_flag.equals("Y")){%>
			<colgroup>
				<col width="8%" />
				<col width="6%" />
	            <col width="6%" />
	            <col width="8%" />
	            <col width="*" />
	            <col width="8%" />
	            <col width="6%" />
	            <col width="6%" /> 
	            <col width="6%" />
	            <col width="6%" />
	            <col width="10%" />
	            <col width="6%" /> 
	            <col width="10%" /> 
	        </colgroup>
		<%}else{%>
			<colgroup>
				<col width="7%" />
	            <col width="7%" />
	            <col width="10%" />
	            <col width="*" />
	            <col width="8%" />
	            <col width="6%" />
	            <col width="6%" /> 
	            <col width="7%" />
	            <col width="7%" />
	            <col width="9%" />
	            <col width="7%" /> 
	            <col width="10%" /> 
	        </colgroup>
        <%}%>
	        <thead>
			<tr>
			<%if(group_mng_flag.equals("Y")){%>
				<th scope="col" ><%=CommonLang.get("HTITLE290") %><!-- 고객사코드 --><br><%=CommonLang.get("HTITLE291") %><!-- 고객사명 --></th>
			<%}%> 
				 <th scope="col" ><a href="javascript:setSortingList('REF_NO');"><%=CommonLang.get("HTITLE186") %><!-- 주문번호 --></a><br><%=CommonLang.get("HTITLE885") %><!-- I/F발주번호 --></th>		
				 <th scope="col" ><a href="javascript:setSortingList('PO_NO');"><%=CommonLang.get("HTITLE203") %><!-- 발주번호 --></a><br><a href="javascript:setSortingList('PR_NO');"><%=CommonLang.get("HTITLE216") %><!-- 요청번호 --></a></th>			
				  <th scope="col" ><a href="javascript:setSortingList('BUYER_ITEM_NO');"><%=CommonLang.get("HTITLE12") %><!-- 품목코드 --></a><br><%=CommonLang.get("HTITLE606") %><!-- 진행상태 --></th>			
				  <th scope="col" ><%=CommonLang.get("HTITLE13") %><!-- 품목명 --><br><%=CommonLang.get("HTITLE14") %><!-- 규격 --></th>
				  <th scope="col" ><%=CommonLang.get("HTITLE15") %><!-- 제조사 --><br><%=CommonLang.get("HTITLE187") %><!-- 발주자 --></th>			
				  <th scope="col" ><%=CommonLang.get("HTITLE45") %><!-- 수량 --><br><a href="javascript:setSortingList('PO_CREATE_DATE');"><%=CommonLang.get("HTITLE208") %><!-- 발주일 --></a></th>			
				  <th scope="col" ><%=CommonLang.get("HTITLE174") %><!-- 단가 --><br><%=CommonLang.get("HTITLE204") %><!-- 금액 --></th>			
				  <th scope="col" ><%=CommonLang.get("HTITLE243") %><!-- 납기요청일 --><br><%=CommonLang.get("HTITLE206") %><!-- 납품예정일 --></th>			
				  <th scope="col" ><%=CommonLang.get("HTITLE133") %><!-- 요청자 --><br><%=CommonLang.get("HTITLE884") %><!-- 송장/납품 수량 --></th>			
				  <th scope="col" ><%=CommonLang.get("HTITLE144") %><!-- 협력사 --><br><a href="javascript:setSortingList('REF_PR_NO');"><%=CommonLang.get("HTITLE18") %><!-- 관리번호 --></a></th>			
			  	  <th scope="col" ><%=CommonLang.get("HTITLE265") %><!-- 납품합의일 --><br><%=CommonLang.get("HTITLE266") %><!-- 합의이력 --><br>/<%=CommonLang.get("HTITLE166") %><!-- 첨부 --></th>	 
			  	  <th scope="col" ><%=CommonLang.get("HTITLE267") %><!-- 계정명 --><br><%=CommonLang.get("HTITLE268") %><!-- 예산부서 --></th>	 
			</tr>
		</thead>
		<tbody>
 		<%
 		
 		int display_item_amt = 0;
        if (_gridList == null || _gridList.size() == 0){
        %>
                    <tr>
                    <%if(group_mng_flag.equals("Y")){%>
                    	<td colspan="13" align="center" height = "50">
                    <%}else{%>
                    	<td colspan="12" align="center" height = "50">
                    <%}%>
                        <span><%=CommonLang.msg("MSG347") %><!-- 조회된 데이타가 없습니다. --></span>
                        </td> 
                    </tr>
        <%
        }else{
        	
        	String po_status = "";
			for (int j=0; j<_gridList.size(); j++) {
				Map<String,String> rowData = _gridList.get(j);
				String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
				display_item_amt+=Math.round(Double.parseDouble(CommonUtil.bnvl(rowData.get("TARGET_SUM_PRICE"))));
				
				/*
				if(rowData.get("RECV_FLAG").equals("PS")){
				      po_status = "결재중";
				}else if(rowData.get("RECV_FLAG").equals("PR")){
				      po_status = "<font color=#990000><b>결재반려</b></font>";
				}else if(SessionComCode.equals("KRHYNI0001") && rowData.get("RECV_FLAG").equals("PC") && Double.parseDouble(rowData.get("ITEM_QTY"))  < 0 ){
				      po_status = "<font color=red><b>반품발주</b></font>";
				}else if(rowData.get("RECV_FLAG").equals("PC") && Double.parseDouble(rowData.get("DO_QTY")) == 0 ){
				      po_status = "<font color=#0000ff><b>발주</b></font>";
				}else if(rowData.get("RECV_FLAG").equals("PC") && Double.parseDouble(rowData.get("DO_QTY")) > 0  && Double.parseDouble(rowData.get("IV_QTY"))  == 0   ){
				       po_status = "수주접수";
				}else if(rowData.get("RECV_FLAG").equals("PC") && Double.parseDouble(rowData.get("IV_QTY"))  > 0  && Double.parseDouble(rowData.get("GR_QTY"))  == 0   ){
				       po_status = "송장생성";
				}else if(rowData.get("RECV_FLAG").equals("PC") && Double.parseDouble(rowData.get("GR_QTY"))  > 0  && Double.parseDouble(rowData.get("ITEM_QTY"))  > Double.parseDouble(rowData.get("GR_QTY"))   ){
				       po_status = "부분입고";
				}else if(rowData.get("RECV_FLAG").equals("PC") && Double.parseDouble(rowData.get("ITEM_QTY"))  <= Double.parseDouble(rowData.get("GR_QTY"))  && Double.parseDouble(rowData.get("ITEM_QTY"))  > 0 ){
				       po_status = "<font color=#555555><b>입고완료</b></font>";
				}
				*/
				
				po_status = rowData.get("PO_STR");
				if("주문결재반려".equals(po_status)){
				       po_status = "<font color=#990000><b>"+po_status+"</b></font>";
				}else if("반품발주".equals(po_status)){
				       po_status = "<font color=red><b>"+po_status+"</b></font>";
				}else if("입고완료".equals(po_status)){
				       po_status = "<font color=#555555><b>"+po_status+"</b></font>";
				}
		%> 
				<tr align="center" bgcolor="<%=tclass%>">
				
			<%if(group_mng_flag.equals("Y")){%>
				<td title="고객사코드/고객사명">
				<%=rowData.get("BUYER")%><br><%=rowData.get("BUYER_NAME")%>
				</td>
			<%}%>
				 <td title="주문번호/I/F발주번호">
					<a class="hyperLink" href="javascript:getPxDisplayPop('<%=rowData.get("BUYER")%>','<%=rowData.get("REF_NO")%>','<%=rowData.get("RECV_FLAG")%>','<%=rowData.get("PO_NO")%>');"><%=rowData.get("REF_NO")%></a>
					<br>
					<%=rowData.get("LEGACY_PO_NO")%>
				</td>
				
				 <td title="발주번호/요청번호">
            			<a class="hyperLink" href="javascript:getPoDisplayPop('<%=rowData.get("BUYER")%>','<%=rowData.get("PO_NO")%>');"><%=rowData.get("PO_NO")%></a><br>
            			<a class="hyperLink" href="javascript:getPrDisplayPop('<%=rowData.get("BUYER")%>','<%=rowData.get("PR_NO")%>','<%=rowData.get("GUYLJAE_FLAG")%>','PR_LIST_IN','<%=rowData.get("RECV_FLAG")%>');"><%=rowData.get("PR_NO")%></a>
            	</td>     
                 <td title="품목코드/진행상태">
            <a class="hyperLink" href="javascript:getBuyerCatalogDisplayPop('<%=rowData.get("BYIT_COMORG_CODE")%>','<%=rowData.get("BUYER_ITEM_NO")%>','<%=rowData.get("CONTRACT_NO")%>','<%=rowData.get("CONTRACT_SEQ")%>');"><%=rowData.get("BUYER_ITEM_NO")%></a>
            <br><%=po_status%>
          </td>
          <td  title="품목명/규격"  class="left">
            <%=rowData.get("DESCRIPTION")%><br><%=rowData.get("SPECIFICATION")%>
         </td>
         <td  title="제조사/발주자"  class="center">
            <%=rowData.get("MAKER_NAME")%>
            <br>
<%if(!rowData.get("PX_GW_NO").equals("")){%>
	<a class="hyperLink" href="javascript:openSearchPopup('/common/approval/getBuyerCommonMyPagePop.do','?COMPANY='+'<%=rowData.get("BUYER")%>'+'&DOCU_NO='+'<%=rowData.get("PX_GW_NO")%>'+'&PASS_TP=1&FLAG=COMPLETE' , '1200,700,no');"><%=rowData.get("PURCHASER_NAME")%></a>					
<%}else{%>
	<%=rowData.get("PURCHASER_NAME")%>
<%}%>
         </td>
         <td align="center" width="6%" title="수량/발주일" class="right">            
                    <%=CommonUtil.formatNumber(rowData.get("RECV_QTY"),true,0,3)%>&nbsp;<%=rowData.get("UNIT_MEASURE")%><br>
                    <%=CommonUtil.formatStrinigDate(rowData.get("PO_CREATE_DATE"))%>          
          </td>
          <td title="단가/금액"  class="right">        
                    <%=CommonUtil.formatNumber(rowData.get("TARGET_PRICE"),true,0,3)%><br>
                    <%=CommonUtil.formatNumber(rowData.get("TARGET_SUM_PRICE"),true,0,3)%>
          </td>
          <td title="납기요청일/납품예정일">
            <%=CommonUtil.formatStrinigDate(rowData.get("RD_DATE"))%><br> <%=CommonUtil.formatStrinigDate(rowData.get("DS_DATE"))%>
         </td>
         <td title="요청자/송장/납품 수량">        
					<%if(!rowData.get("PR_GW_NO").equals("")){%>
						<a class="hyperLink" href="javascript:openSearchPopup('/common/approval/getBuyerCommonMyPagePop.do','?COMPANY='+'<%=rowData.get("BUYER")%>'+'&DOCU_NO='+'<%=rowData.get("PR_GW_NO")%>'+'&PASS_TP=1&FLAG=COMPLETE' , '1200,700,no');"><%=rowData.get("PR_ADD_USER_NM")%></a>					
					<%}else{%>
						<%=rowData.get("PR_ADD_USER_NM")%>
					<%}%>                    
                    <br><%=CommonUtil.formatNumber(rowData.get("IV_QTY"),true,0,3)%>&nbsp;/<%=CommonUtil.formatNumber(rowData.get("GR_QTY"),true,0,3)%>&nbsp;
          </td>
          <td title="협력사/관리번호">
            <a class="hyperLink" href="javascript:getAgentDisplayPop('<%=rowData.get("AGENT_CODE")%>');"><%=rowData.get("COM_NAME_LOC")%></a><br><%=rowData.get("REF_PR_NO")%>          
          </td>
			<td title="납품합의일/합의이력/첨부">
			 	<%=CommonUtil.formatStrinigDate(rowData.get("HA_DATE"))%><br>  
				<%if("".equals(CommonUtil.nvl(rowData.get("HA_DATE")).trim())) { %>  
					<img name="Image2" src="/resources/images/icon2.gif" border="0"> 
				<%}else{ %>
					<a class="hyperLink" href="javascript:getHistoryDateList('<%=rowData.get("BUYER")%>','<%=rowData.get("PO_NO")%>','<%=rowData.get("PO_SEQ")%>');"><img name="Image2" src="/resources/images/icon.gif" border="0"></a>
				<%} %>
				&nbsp; / &nbsp;
				<%if("".equals(CommonUtil.nvl(rowData.get("IMAGE_KEY")))) { %>  
					<img src="/resources/images/ico_file.gif" name="MasterImage" width="14" height="14" border="0"> 
				<%}else{ %>
					<a href="javascript:attach_popup('<%=rowData.get("IMAGE_KEY")%>');"> <img src="/resources/images/disk_on.gif" name="MasterImage" width="14" height="14" border="0"> </a>
				<%} %>    
			</td>
			<td title="계정명/예산부서">
			 <%=rowData.get("ACCOUNT_NAME")%><br><%=rowData.get("BUDGET_DEPT_NAME")%>
			</td>
			</tr>
            <%
                        } 
        			}
            %>
           		</tbody>
            </table>
             <input type = "hidden" name = "display_item_amt_sum"  value = "<%=display_item_amt%>">
<%	if (_gridList != null && _gridList.size() > 0){	%>
			 <input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=_gridList.size() %>" >
<%	}	%>
		<!-- 페이징 -->
		<p id="paging" class="paging">
			<%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow) %> 
			<span class="cl"><%=CommonLang.get("HTITLE598") %><!-- [ 총 --> <%=total_cnt %> <%=CommonLang.get("HTITLE599") %><!-- 건 ] --></span> 
		</p>  
		
		<!-- 버튼영역 -->
		<div class="btnArea">
			<div class="fl">
        		<span class="btn_04 mr04">
					<a href="javascript:getDeptTotal('<%=buyer %>','<%=conv_from_date%>','<%=conv_to_date%>','<%=st_req_dept_name%>','<%=st_search_no%>','<%=st_code_no%>');"><%=CommonLang.get("HTITLE257") %><!-- 부서별 집계 --></a>
				</span>
<%if(SessionAgentOpenFlag.equals("Y")){%>				
				<span class="btn_04 mr04">
					<a href="javascript:getSuplTotal('<%=buyer %>','<%=conv_from_date%>','<%=conv_to_date%>','<%=st_req_dept_name%>','<%=st_search_no%>','<%=st_code_no%>');"><%=CommonLang.get("HTITLE258") %><!-- 협력사별 집계 --></a>
				</span>
<%}%>
<%if(p060000098 == true){%>
				<!-- 관리번호별 집계 기능 활성화 -->
				<span class="btn_04 mr04">
					<a href="javascript:getRefTotal('<%=buyer %>','<%=conv_from_date%>','<%=conv_to_date%>','<%=st_req_dept_name%>','<%=st_search_no%>','<%=st_code_no%>');"><%=CommonLang.get("HTITLE937") %><!-- 관리번호별 집계 --></a>
				</span>

<%}%>

			</div> 
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
var selectedRow = "";

//최초 화면 함수 
function kep_onload_view(){
	
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date"); 
	
    var sum_price = document.forms.contentForm.display_item_amt_sum.value;
    document.forms.searchForm.s_display_item_amt_sum.value = kepCommaNum(sum_price);
}

var st;
//기능함수
function doAction(str) {
	
	switch (str) {
	case "search":	 //조회
		kepSearch(1);
		break; 
		 
	case "kep_reload":	 //초기화
		kep_reload();
		break; 
		 
	case "excelDown":	 //excelDown
		ExcelDown();
		break;
	}
}

// 조회
function kepSearch(curPage){ 
	if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;  
	if (kepGetDateDiff('st_from_date','st_to_date','D') > 184 ){
		//MSG494
		alert("조회기간을 6개월 단위로 조회가 가능합니다.");
		return;
	}
	//조회그룹으로 추가.
	var st_com_code =document.forms.searchForm.st_com_code.value;
	if(st_com_code.indexOf("GROUP") >=0){
		document.forms.searchForm.st_group_info.value = st_com_code; 
	}else{
		document.forms.searchForm.st_group_info.value = "";
	}
	//본인결재건 조회 체크
	var st_docu_type = "<%=st_docu_type%>";
	if(st_docu_type == "Y"){
	    var docu_chk = eval("document.forms.searchForm.st_docu_type_chk" );
	    if(docu_chk.checked == true){
	    	document.forms.searchForm.st_docu_chk.value = "Y";
	    }else{
	    	document.forms.searchForm.st_docu_chk.value = "N";
	    }		
	}else{
		document.forms.searchForm.st_docu_chk.value = "N";
	}

	//미입고 체크
	var not_gr = eval("document.forms.searchForm.st_gr_chk" );
	if(not_gr.checked == true){
		document.forms.searchForm.st_not_gr_chk.value = "Y";
	}else{
		document.forms.searchForm.st_not_gr_chk.value = "N";
	}	
	
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mppo/getBuyerMpPoOrderProgressList.do").submit();   
}

function ExcelDown(){
	if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;  
	if (kepGetDateDiff('st_from_date','st_to_date','D') > 184 ){
		//MSG494
		alert("조회기간을 6개월 단위로 조회가 가능합니다.");
		return;
	}
	//조회그룹으로 추가.
	var st_com_code =document.forms.searchForm.st_com_code.value;
	if(st_com_code.indexOf("GROUP") >=0){
		document.forms.searchForm.st_group_info.value = st_com_code; 
	}else{
		document.forms.searchForm.st_group_info.value = "";
	}
	if(<%=p060000069%> == true){
		document.forms.searchForm.action = "/mppo/excelBuyerMpPoOrderProgressList.do";
    }else{
    	document.forms.searchForm.action = "/mppo/excelNewBuyerMpPoOrderProgressList.do";
    }
	document.forms.searchForm.submit();
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


function getPopType(){

	var dept_type = document.forms.searchForm.st_dept_type.value;
	var st_group_mng_flag = document.forms.searchForm.st_group_mng_flag.value;
	
	if(st_group_mng_flag == "Y"){
		var select_buyer_code = document.forms.searchForm.st_com_code.value;
		
		if(select_buyer_code == ""){
			//고객사를 전체 아닌 값으로 선택하여야 합니다.
			alert("<%=CommonLang.msg("MSG239") %>");
			return;
		}
	}
	
	if(dept_type == "VN"){
		getAgentSearch();
	}else{
		getDepartmentCode();

	}

}

function getAgentSearch(){ 
	openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=S&MULTI=N", "500,466,no");
} 
function getDepartmentCode(){
	var buyer = "<%=SessionComCode%>";
	
<%if(group_mng_flag.equals("Y")){%>
	var buyer_select = document.forms.searchForm.st_com_code.value;
	buyer = buyer_select;
<%}%>
	openSearchPopup('/common/deptCodeAdminPop.do', "?open=Y&com_code="+buyer, "500,500,no"); 
} 

function setPopupReturn(code, text1, text2, gubun) { 
	document.forms.searchForm.st_req_dept_code.value = code;
	document.forms.searchForm.st_req_dept_name.value = text1;
}

function kep_reload(){
	 
	document.forms.searchForm.st_dept_type.value = "PR"; 
	document.forms.searchForm.st_req_dept_name.value = "";
	document.forms.searchForm.st_req_dept_code.value = "";
	document.forms.searchForm.st_search_type.value = "BC";	
	document.forms.searchForm.st_search_no.value = "";
	document.forms.searchForm.st_code_type.value = "IN";
	document.forms.searchForm.st_code_no.value = "";
	document.forms.searchForm.st_user_type.value = "PR";
	document.forms.searchForm.st_po_user_name.value = "";
	document.forms.searchForm.st_not_gr_chk.value = "N";
	var st_not_gr = eval("document.forms.searchForm.st_gr_chk" );
	st_not_gr.checked = false;
	
<%if(group_mng_flag.equals("Y")){%>
	document.forms.searchForm.st_com_code.value = "";
<%}%>

	document.forms.searchForm.st_status.value = ""; 	
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));   
	
// 	kepSearch(-1);
<%if(group_mng_flag.equals("N")){%>
	jspTableClean("table_list","12");
<%}else{%>
	jspTableClean("table_list","13");
<%}%>
}

function getPoDisplayPop(BUYER,PO_NO){ 
	openSearchPopup('/mpiv/getCommonMpIvBuyerOrderDetailInfoPop.do','?buyer='+BUYER+'&po_no='+PO_NO  , "820,550,no"); 
} 

function getPrDisplayPop(BUYER,PR_NO,VALUE1,VALUE2,RECV_FLAG){ 
	openSearchPopup('/mpiv/showCommonMpIvOdrreqDetailPop.do','?openYn=Y&COMPANY='+BUYER+'&PR_NO='+PR_NO+'&st_flag='+VALUE1+'&enter_flag='+VALUE2+'&RECV_FLAG='+RECV_FLAG , "800,600,no"); 
	//openSearchPopup('/mpiv/showCommonMpIvOdrreqDetailPop.do','?openYn=Y&PR_NO='+PR_NO+'&RECV_FLAG='+RECV_FLAG , "800,600,no"); 
} 
function getPxDisplayPop(BUYER,REF_NO,RECV_FLAG,PO_NO){  
	openSearchPopup('/mppo/showBuyerMpPoOrderDetailPop.do','?openYn=Y&COMPANY='+BUYER+'&REF_NO='+REF_NO+'&RECV_FLAG='+RECV_FLAG+'&PO_NO='+PO_NO , "1000,510,no"); 
} 


function getHistoryDateList(buyer,po_no,po_seq){ 
	//var loc = "/kr/customer/main/2009_home/popup/sysop_proxbuy_pmpa_iv_pop_history.jsp?";
	
	
	openSearchPopup('/mppo/showBuyerMpPoDvlyAgrmntHistoryPop.do', "?open=Y&st_buyer="+ buyer + "&st_po_no="+po_no + "&st_po_seq="+po_seq , "800,450,no"); 
} 

function getDeptTotal(buyer, fromDate, toDate, deptName, itemNo, codeNo){
	var st_group_mng_flag = document.forms.searchForm.st_group_mng_flag.value;
	
	if(st_group_mng_flag == "Y"){
		var select_buyer_code = document.forms.searchForm.st_com_code.value;
		buyer = select_buyer_code;
		
		if(select_buyer_code == ""){
			//고객사를 전체 아닌 값으로 선택하여야 합니다.
			alert("<%=CommonLang.msg("MSG239") %>");
			return;
		}
	}
	
	var cb_dept_code = document.getElementById("st_dept_type").value;
	var cb_dept_text = document.getElementById("st_dept_type")[document.getElementById("st_dept_type").selectedIndex].text;
	var st_dept_code = document.getElementById("st_req_dept_code").value;
	
	var cb_item_code = document.getElementById("st_search_type").value;
	var cb_item_text = document.getElementById("st_search_type")[document.getElementById("st_search_type").selectedIndex].text;
	
	var cb_order_code = document.getElementById("st_code_type").value;
	var cb_order_text = document.getElementById("st_code_type")[document.getElementById("st_code_type").selectedIndex].text;
	
	var status_code = document.getElementById("st_status").value;
	var status_text = document.getElementById("st_status")[document.getElementById("st_status").selectedIndex].text;
	
	openSearchPopup('/mppo/getBuyerMpPoOrderDeptTotalList.do','?buyer='+buyer+'&fromDate='+fromDate+'&toDate='+toDate
			+'&cb_dept_code='+cb_dept_code+'&cb_dept_text='+cb_dept_text+'&st_dept_code='+st_dept_code+'&st_dept_name='+escape(encodeURIComponent(deptName))
			+'&cb_item_code='+cb_item_code+'&cb_item_text='+cb_item_text+'&itemNo='+escape(encodeURIComponent(itemNo))
			+'&cb_order_code='+cb_order_code+'&cb_order_text='+cb_order_text+'&orderNo='+escape(encodeURIComponent(codeNo))
			+'&status_code='+status_code+'&status_text='+status_text, "820,500,no"); 
}

function getSuplTotal(buyer, fromDate, toDate, deptName, itemNo, codeNo){
	var st_group_mng_flag = document.forms.searchForm.st_group_mng_flag.value;
	
	if(st_group_mng_flag == "Y"){
		var select_buyer_code = document.forms.searchForm.st_com_code.value;
		buyer = select_buyer_code;
		
		if(select_buyer_code == ""){
			//고객사를 전체 아닌 값으로 선택하여야 합니다.
			alert("<%=CommonLang.msg("MSG239") %>");
			return;
		}
	}
	
	var cb_dept_code = document.getElementById("st_dept_type").value;
	var cb_dept_text = document.getElementById("st_dept_type")[document.getElementById("st_dept_type").selectedIndex].text;
	var st_dept_code = document.getElementById("st_req_dept_code").value;
	
	var cb_item_code = document.getElementById("st_search_type").value;
	var cb_item_text = document.getElementById("st_search_type")[document.getElementById("st_search_type").selectedIndex].text;
	
	var cb_order_code = document.getElementById("st_code_type").value;
	var cb_order_text = document.getElementById("st_code_type")[document.getElementById("st_code_type").selectedIndex].text;
	
	var status_code = document.getElementById("st_status").value;
	var status_text = document.getElementById("st_status")[document.getElementById("st_status").selectedIndex].text;
	
	openSearchPopup('/mppo/getBuyerMpPoOrderSuplTotalList.do','?buyer='+buyer+'&fromDate='+fromDate+'&toDate='+toDate
			+'&cb_dept_code='+cb_dept_code+'&cb_dept_text='+cb_dept_text+'&st_dept_code='+st_dept_code+'&st_dept_name='+escape(encodeURIComponent(deptName))
			+'&cb_item_code='+cb_item_code+'&cb_item_text='+cb_item_text+'&itemNo='+escape(encodeURIComponent(itemNo))
			+'&cb_order_code='+cb_order_code+'&cb_order_text='+cb_order_text+'&orderNo='+escape(encodeURIComponent(codeNo))
			+'&status_code='+status_code+'&status_text='+status_text, "820,500,no"); 
}
//관리번호별 팝업
function getRefTotal(buyer, fromDate, toDate, deptName, itemNo, codeNo){
	var st_group_mng_flag = document.forms.searchForm.st_group_mng_flag.value;
	
	if(st_group_mng_flag == "Y"){
		var select_buyer_code = document.forms.searchForm.st_com_code.value;
		buyer = select_buyer_code;
		
		if(select_buyer_code == ""){
			//고객사를 전체 아닌 값으로 선택하여야 합니다.
			alert("<%=CommonLang.msg("MSG239") %>");
			return;
		}
	}
	
	var cb_dept_code = document.getElementById("st_dept_type").value;
	var cb_dept_text = document.getElementById("st_dept_type")[document.getElementById("st_dept_type").selectedIndex].text;
	var st_dept_code = document.getElementById("st_req_dept_code").value;
	
	var cb_item_code = document.getElementById("st_search_type").value;
	var cb_item_text = document.getElementById("st_search_type")[document.getElementById("st_search_type").selectedIndex].text;
	
	var cb_order_code = document.getElementById("st_code_type").value;
	var cb_order_text = document.getElementById("st_code_type")[document.getElementById("st_code_type").selectedIndex].text;
	
	var status_code = document.getElementById("st_status").value;
	var status_text = document.getElementById("st_status")[document.getElementById("st_status").selectedIndex].text;
	//post 팝업 파라미터 설정
	var st_form_name = "RefTotalListForm";
	var st_popup_url = "/mppo/getBuyerMpPoOrderRefTotalList.do";
	var st_popup_param = "buyer@@"+buyer+"^||^"+"fromDate@@"+fromDate+"^||^"+"toDate@@"+toDate+"^||^"+"cb_dept_code@@"+cb_dept_code+"^||^"
							+"cb_dept_text@@"+cb_dept_text+"^||^"+"st_dept_code@@"+st_dept_code+"^||^"+"st_dept_name@@"+deptName+"^||^"
							+"cb_item_code@@"+cb_item_code+"^||^"+"cb_item_text@@"+cb_item_text+"^||^"+"itemNo@@"+itemNo+"^||^"
							+"cb_order_code@@"+cb_order_code+"^||^"+"cb_order_text@@"+cb_order_text+"^||^"+"orderNo@@"+codeNo+"^||^"
							+"status_code@@"+status_code+"^||^"+"status_text@@"+status_text;
	var st_popup_option = "820,500,no";
	//post 팝업 호출
	openSearchPopupAppendPost(st_form_name,st_popup_url,st_popup_param,st_popup_option);

}


function buyerChange(){
	var select_buyer_code = document.forms.searchForm.st_com_code.value;
	
	if(select_buyer_code == ""){
		document.forms.searchForm.st_req_dept_code.value = "";
		document.forms.searchForm.st_req_dept_name.value = "";
	}	
}
function attach_popup(img_key){		
	var type = "PR";
	var viewType = "R";	 
	kepFileUploadOpenPopup(img_key,type,viewType); 
}
 
</script>
</html>
