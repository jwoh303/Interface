<%--
**********************************************
* 메뉴 : 견적관리>단가합의 및 Nego 요청 멀티(삼양사)
* 화면 : 단가합의 및 Nego 요청
* 기능 : 합의대상 목록 조회 및 단가합의 또는 네고요청 처리
* 프로그램 ID : PG_04_B_004_00
* 담당자 : 김영미 ( 설계 : 권우재 )
* 착수일 : 2015-09-03
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
	String login_id=  CommonUtil.nvl((String) request.getParameter("userId"), _sessionInfo.getUserId());
	String st_buyer_select = CommonUtil.nvl((String) request.getParameter("st_buyer_select"),"");  // 계열사정보
	String st_term_pass_flag = CommonUtil.nvl((String) request.getParameter("st_term_pass_flag"),"N");  // 기간무시 체크
	String st_msds_status_select = CommonUtil.nvl((String) request.getParameter("st_msds_status_select"),"");  // MSDS상태
	
	// 조회조건 E
	//SLOGIC-BEGIN(P04-4027-02)
	String reportid = "RD_04_M_004_03"; 
	String reporttype = "B"; 
	if (_gridList!= null ){
		if (_gridList.size() > 0){
			Map<String, String> p04402702 = CommonUtil.getSpecialCheckReturnMap(com_code,"P04-4027-02");   // com_code , 특수로직아이디
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
	boolean p060000052 = CommonUtil.getSpecialCheckReturn(com_code,"P06-0000052"); 
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
	<h3>단가합의 및 Nego 요청</h3>
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
		<input type="hidden" name="st_user_group" id="st_user_group" value="${sessionInfo.userGroup}">
		<input type="hidden" name="st_sort" id="st_sort" value="">
			
		<div id="cont_searchA">	
			<table class="cont_t_list01" >
				<caption>조회</caption>
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
				          <option value="ATOB_DATE" <%if ("ATOB_DATE".equals(st_date_type)) {%>selected<%} %>>견적제출일</option>
				          <option value="BTOA_END_DATE" <%if ("BTOA_END_DATE".equals(st_date_type)) {%>selected<%} %>>회신요청일</option>
				          <option value="BTOA_DATE" <%if ("BTOA_DATE".equals(st_date_type)) {%>selected<%} %>>견적의뢰일</option>
				        </select>
				      </th>
				      <td colspan="3">
	   						<input type="text" name="st_from_date" id="st_from_date" readOnly style="width:20%; text-align:center;" value="<%=st_from_date%>">
								<a href="javascript:kepCalendar('st_from_date')"></a>
							-
							<input type="text" name="st_to_date" id="st_to_date" readOnly style="width:20%; text-align:center;" value="<%=st_to_date%>">
								<a href="javascript:kepCalendar('st_to_date')"></a>
								&nbsp;&nbsp;
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span> 
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>
							<span class="btn_month"><a href="javascript:setCurMonth('st_from_date','st_to_date')">당월</a></span>			
								<input type="checkbox"  class="Noborder" name="st_checkbox" id="st_checkbox" <%if("Y".equals(st_term_pass_flag)){%>checked<%}%> onclick="setTermPassFlag()">&nbsp;기간무시
								<input type="hidden" name="st_term_pass_flag" id="st_term_pass_flag" value="<%=st_term_pass_flag%>">				
				      </td>
				      <th>고객사</th>
				      <td >
				        <select name="st_buyer_select" id="st_buyer_select" style="width:90%;height:20px;" >
						  <%= CommonUtil.getCode3ComboList(_sessionInfo.getComCode(), "ALL", "TCFM",_sessionInfo.getComCode(), "ICOMCOD3", st_buyer_select, "") %>
				        </select>
				      </td>
				      <th></th>
					<tr>  
						<th>요청자</th>
						<td ><input type="text" name="st_btoa_user_name" id="st_btoa_user_name" style="width:87%;ime-mode:active" value="<%=st_btoa_user_name %>" onKeyDown="kepEnter()"></td>
						<th >견적번호</th>
						<td ><input type="text" name="st_quotation_no" id="st_quotation_no" style="width:87%" value="<%=st_quotation_no%>" onKeyUp="kepToUpper('st_quotation_no')" onKeyDown="kepEnter()"></td>
						<th>MSDS상태</th>
						<td >
							<select name="st_msds_status_select" id="st_msds_status_select" style="width:90%;height:20px;" >
								<option value="" >전체</option>
								<option value="YC" <%if ("YC".equals(st_msds_status_select)) {%>selected<%} %>>MSDS제출</option>
								<option value="YT" <%if ("YT".equals(st_msds_status_select)) {%>selected<%} %>>MSDS검토</option>								
								<option value="YA" <%if ("YA".equals(st_msds_status_select)) {%>selected<%} %>>MSDS승인</option>
							</select>
						</td>
				    </tr>
				    <tr>
<%
//두산중공업 펀치아웃 
//SLOGIC-BEGIN(P06-0000052)
if(p060000052 == true) {
%>
				      <th>품목코드</th>
				      <td><input type="text" name="st_buyer_item_no" id="st_buyer_item_no" style="width:87%" value="<%=st_buyer_item_no %>" onKeyUp="kepToUpper('st_buyer_item_no')" onKeyDown="kepEnter()"></td>
				      <th>진행상태</th>
				      <td ><select name="st_sourcing_status" id="st_sourcing_status" style="width:90%;height:20px;" >
				          <option value="" >전체</option>
				          <option value="합의대상" <%if ("합의대상".equals(st_sourcing_status)) {%>selected<%} %>>합의대상</option>
				          <option value="Nego합의대상" <%if ("Nego합의대상".equals(st_sourcing_status)) {%>selected<%} %>>Nego합의대상</option>
				        </select></td>
				        <th></th>
				        <td></td>
<%}else{ %>
				      <th>요청부서</th>
				      <td ><input type="hidden" name="st_btoa_user_dept_code" id="st_btoa_user_dept_code" value="<%=st_btoa_user_dept_code%>">
				        <input type="text" name="st_btoa_user_dept_name" id="st_btoa_user_dept_name" style="width:55%;ime-mode:active" value="<%=st_btoa_user_dept_name %>" READONLY>
				        <a href="javascript:doPop('dept');"><img src="/resources/images/btn_search03.gif" alt="검색" /></a>
				        <a href="javascript:kepEraser('st_btoa_user_dept_code','st_btoa_user_dept_name');"><img src="/resources/images/btn_eraser2.gif" alt="조건지우기"></a>
				      </td>
				      <th>품목코드</th>
				      <td ><input type="text" name="st_buyer_item_no" id="st_buyer_item_no" style="width:87%" value="<%=st_buyer_item_no %>" onKeyUp="kepToUpper('st_buyer_item_no')" onKeyDown="kepEnter()"></td>
				      <th>진행상태</th>
				      <td ><select name="st_sourcing_status" id="st_sourcing_status" style="width:90%;height:20px;" >
				          <option value="" >전체</option>
				          <option value="합의대상" <%if ("합의대상".equals(st_sourcing_status)) {%>selected<%} %>>합의대상</option>
				          <option value="합의대상 (MSDS 미승인 제외)" <%if ("합의대상 (MSDS 미승인 제외)".equals(st_sourcing_status)) {%>selected<%} %>>합의대상 (MSDS 미승인 제외)</option>
				          <option value="Nego합의대상" <%if ("Nego합의대상".equals(st_sourcing_status)) {%>selected<%} %>>Nego합의대상</option>
				          <option value="결재반려" <%if ("결재반려".equals(st_sourcing_status)) {%>selected<%} %>>결재반려</option>
				        </select></td>
<%} %>
				    </tr>
				    <tr>
						<th>품목명/규격</th>
				      	<td><input type="text" name="st_desc_spec" id="st_desc_spec" style="width:87%" value="<%=st_desc_spec%>" onKeyDown="kepEnter()"></td>
				      	<th></th>
				      	<td></td>
				      	<th></th>
				      	<td></td>
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
				<option value = "100" <%if ("100".equals(onepagerow)) {%>selected<%} %>>100건</option> 
			</select>
			<span class="btn_gray_04" title="견적번호" ><a href="javascript:doAction('search_quot');">견적번호</a></span>
			<span class="btn_gray_04" title="견적의뢰일" ><a href="javascript:doAction('search_btoa');">견적의뢰일</a></span>
			※ Nego를 원하시면 해당 품목의 Nego 단가를 입력하셔야 합니다.&nbsp;&nbsp;<b>진행상태</b> 클릭 시 Nego 이력을 보실 수 있습니다.
      	</span>      
       <span class="fr">
       총건수 <input type="text" class="input_type_text" id="st_total_cnt" name="st_total_cnt" readonly style="width:30px;border:0" value="<%=total_cnt %>"/>
       </span>
       	<br>
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<!-- 공통 -->
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
		<table id="table_list" class="cont_t_list02" style="width:100%">
<%
//두산중공업 펀치아웃 
//SLOGIC-BEGIN(P06-0000052)
if(p060000052 == true) {
%>
			<colgroup>
	            <col width="2%" />
	            <col width="6%" />
	            <col width="9%" />
	            <col width="10%" />
	            <col width="8%" />
	            <col width="*%" />
	            <col width="9%" />
	            <col width="8%" />
	            <col width="9%" />
	            <col width="4%" />
	            <col width="4%" />
	            <col width="4%" />
	        </colgroup>
	        <thead>
			<tr>
				<th scope="col">
					<input type="checkbox" name="check_status" id="check_status" value="선택"  style="cursor:hand;" onclick="kepCheckAll2();">
				</th>
				  <th scope="col" >순번<br>진행상태</th>
				  <th scope="col" >견적번호<br>품목구분</th>
				  <th scope="col" >품목코드<br>재고코드</th>
				  <th scope="col" >견적의뢰일<br>회신요청일</th>
				  <th scope="col" >품목명<br>규격</th>
				  <th scope="col" >제조사<br>원산지</th>
				  <th scope="col" >수량<br>단위</th>
				  <th scope="col" >실적단가<br>견적단가</th>
				  <th scope="col" colspan="2">KeP담당자<br>Nego/첨부</th>
				  <th scope="col" >비고<br>소요일</th>
<%}else{ %>
			<colgroup>
	            <col width="2%" />
	            <col width="3%" />
	            <col width="9%" />
	            <col width="9%" />
	            <col width="9%" />
	            <col width="16%" />
	            <col width="9%" />
	            <col width="9%" />
	            <col width="9%" />
	            <col width="7%" />
	            <col width="9%" />
	            <col width="4%" />
	            <col width="4%" />
	            <col width="4%" />
	        </colgroup>
	        <thead>
			<tr>
				<th scope="col">
					<input type="checkbox" name="check_status" id="check_status" value="선택"  style="cursor:hand;" onclick="kepCheckAll2();">
				</th>
				  <th scope="col" rowspan="2">순번</th>
				  <th scope="col" >견적번호<br>진행상태</th>
				  <th scope="col" >고객사명<br>품목코드</th>
				  <th scope="col" >견적의뢰일<br>회신요청일</th>
				  <th scope="col" >품목명<br>규격</th>
				  <th scope="col" >제조사<br>원산지</th>
				  <th scope="col" >수량/단위<br>단가구분/요청단가</th>
				  <th scope="col">협력사<br>견적단가</th>
				  <th scope="col" >요청자<br>요청부서</th>
				  <th scope="col" colspan="2">KeP담당자<br>Nego/첨부</th>
				  <th scope="col" >비고<br>취소사유</th>
<%}%>
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
			<%
			//두산중공업 펀치아웃 
			//SLOGIC-BEGIN(P06-0000052)
			if(p060000052 == true) {
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
	                            <input type="hidden" name="st_confirm_user_id2"     value="${sessionInfo.userId}">
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
								<input type="hidden" name="st_target_price" id="st_target_price" value="<%=rowData.get("BUYER_TARGET_PRICE")%>">
								<input type="hidden" name="st_buyer_item_no2"	 id="st_buyer_item_no2" value="<%=rowData.get("BUYER_ITEM_NO")%>">
								<input type="hidden" name="st_msds_yn"	 id="st_msds_yn" value="<%=rowData.get("MSDS_YN")%>">
								<input type="hidden" name="st_msds_status"	 id="st_msds_status" value="<%=rowData.get("MSDS_STATUS")%>">
								<input type="hidden" name="st_msds_no"	 id="st_msds_no" value="<%=rowData.get("MSDS_NO")%>">
								<input type="hidden" name="st_msds_type_text"	 id="st_msds_type_text" value="<%=rowData.get("MSDS_TYPE_TEXT")%>">
								<input type="hidden" name="st_buyer_name"	 id="st_buyer_name" value="<%=rowData.get("BUYER_NAME")%>">
								<input type="hidden" name="st_cancle_remark"	 id="st_cancle_remark" value="">
								<input type="hidden" name="st_sell_close_date"     id="st_sell_close_date"    value="<%=rowData.get("SELL_CLOSE_DATE")%>">
								<input type="hidden" name="st_buy_close_date"     id="st_buy_close_date"    value="<%=rowData.get("BUY_CLOSE_DATE")%>">
								<input type="hidden" name="st_min_order_qty" id="st_min_order_qty" value="<%=rowData.get("MIN_ORDER_QTY")%>">
								<input type="hidden" name="st_pur_unit_qty" id="st_pur_unit_qty" value="<%=rowData.get("PUR_UNIT_QTY")%>">
                                </td>
                                <td title="순번/진행상태" ><%=rowData.get("QUOTATION_SEQ")%></td>
                                <td title="견적번호">
								 <a class="hyperLink b"  href="javascript:doPop('buyerMpRqDepartmentTotalPop','<%=rowData.get("BUYER")%>', '<%=rowData.get("QUOTATION_NO")%>', '<%=rowData.get("REVISION")%>');"><b><%=rowData.get("QUOTATION_NO")%></b></a>
                               		<%if(!rowData.get("ITEM_TYPE").equals("")){ %>
                               		<%} %>
								 </td>
                                <td title="품목코드" class="td02" class="left" >
                                <%if(rowData.get("GREEN_FLAG").equals("Y")){ %>
                               		<img src="/resources/images/greenmark.jpg" width="20" height="20" border="0"><%=rowData.get("REG_ITEM_NO")%><input type="hidden" name="st_buyer_item_no3" id="st_buyer_item_no3" value="<%=rowData.get("BUYER_ITEM_NO")%>" readonly style="border:0">
                               	<%}else{ %>
	                               	<input type="hidden" name="st_buyer_item_no3" id="st_buyer_item_no3" value="<%=rowData.get("BUYER_ITEM_NO")%>" readonly style="border:0"><%=rowData.get("REG_ITEM_NO")%>
                               	<%} %>
                                </td>
                                <td title="견적의뢰일"><%=CommonUtil.formatStrinigDate(rowData.get("BTOA_DATE"))%></td>
                                <td title="품목명"       class="left" ><%=rowData.get("DESCRIPTION")%></td>
                                <td title="제조사"       class="td02"><%=rowData.get("MAKER_NAME")%></td>
								<td title="수량">
								  <input type="hidden" name="st_item_qty" id="st_item_qty" value="<%=rowData.get("ITEM_QTY")%>">
								  <%=CommonUtil.formatNumber(rowData.get("ITEM_QTY"),true,0,3) %>
                                <td title="실적단가" class="right" ><%=CommonUtil.formatNumber(rowData.get("BUYER_TARGET_PRICE"),true,0,3)%></td>
                                <td title="KeP담당자" class="td02" colspan="2">
                                	<a class="hyperLink" href="javascript:doPop('kepManagerPop','<%=rowData.get("KEP_USER_ID")%>')"><%=rowData.get("KEP_USER_NAME")%></a>
                                </td>
                                <td title="비고" class="td02" >
								<%
                                        if(rowData.get("ATOB_REMARK").equals("")) {
                                %>
                                		<img name = "st_atob_remark_img" id="st_atob_remark_img" src="/resources/images/but_icon02.gif" border="0">
                                <%
                                        }else {
                                %>
                                            <a href="javascript:doPop('remark','<%=rowData.get("ATOB_REMARK")%>','<%=rowData.get("BTOA_REMARK")%>');"><img name = "st_atob_remark_img" src="/resources/images/but_icon01.gif" border="0"></a>
                                <%
                                        }
                                %>
                                </td>
                            </tr>
                            <tr align="center" bgcolor="<%=tclass%>">
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
								</td>
								<td title="품목구분" class="td02" class="left">
									(<%=rowData.get("ITEM_TYPE_TEXT")%>)
								</td>
                                <td title="재고코드" class="td02" class="left">
								<%
									if(rowData.get("ITEM_GUBUN").equals("I")) {
								%>
									<input type="text" name="st_doos_item_no_back" id="st_doos_item_no_back"		maxlength="6"	value="<%=rowData.get("RE_ITEM_NO")%>">
									<input type="hidden" name="st_doos_item_no_first" id="st_doos_item_no_first"			value="<%=rowData.get("REG_ITEM_NO2")%>">
									<input type="hidden" name="st_kep_item_no" id="st_kep_item_no" size="20"  value="<%=rowData.get("REG_ITEM_NO")%>">
								<%}else{ %>
									<input type="hidden" name="st_doos_item_no_back" id="st_doos_item_no_back"			value="<%=rowData.get("REG_ITEM_NO2")%>">
									<input type="hidden" name="st_doos_item_no_first" id="st_doos_item_no_first"			value="<%=rowData.get("REG_ITEM_NO2")%>">
								<%} %>
                                </td>
                                <td title="회신요청일" class="td02">
									<b><%=CommonUtil.formatStrinigDate(rowData.get("BTOA_END_DATE"))%> <%//=rowData.get("BTOA_END_TIME")%></b>
								</td>
                                <td title="규격" class="td02" class="left"><%=rowData.get("SPECIFICATION")%></td>
                                <td title="원산지"><%=rowData.get("ORIGIN_NAME")%></td>
								<td title="단위">
                                    <%=rowData.get("UNIT_MEASURE") %>
                                </td>
                                <td title="견적단가"  class="right">
                                    <input type="hidden" name="st_confirm_price" id="st_confirm_price"  value="<%=rowData.get("ATOB_UNIT_PRICE")%>">
                                    <%=CommonUtil.formatNumber(rowData.get("ATOB_UNIT_PRICE"),true,0,3)%>
                                </td>
                                <td title="Nego">
<%
                if(user_group.equals("C") || user_group.equals("A")) {
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
								<td title="소요일">
                                    <%=CommonUtil.formatNumber(rowData.get("LEAD_TIME"),true,0,3)%>일
                                </td>
                            </tr>
            <%
			}else{
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
                                <input type="hidden" name="st_user_id"   id="st_user_id"   value="${sessionInfo.userId}">
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
								<input type="hidden" name="st_buyer_item_no3"	 id="st_buyer_item_no3"  value="<%=rowData.get("BUYER_ITEM_NO")%>">
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
								<input type="hidden" name="st_buyer_name"	 id="st_buyer_name" value="<%=rowData.get("BUYER_NAME")%>">
								<input type="hidden" name="st_cancle_remark"	 id="st_cancle_remark" value="">
								<input type="hidden"   name="st_sell_close_date"     id="st_sell_close_date"    value="<%=rowData.get("SELL_CLOSE_DATE")%>">
								<input type="hidden"   name="st_buy_close_date"     id="st_buy_close_date"    value="<%=rowData.get("BUY_CLOSE_DATE")%>">
								<input type="hidden" name="st_min_order_qty" id="st_min_order_qty" value="<%=rowData.get("MIN_ORDER_QTY")%>">
								<input type="hidden" name="st_pur_unit_qty" id="st_pur_unit_qty" value="<%=rowData.get("PUR_UNIT_QTY")%>">
								
								
                                </td>
                                <td title="순번" rowspan="2"><%=((Integer.parseInt(curPage)-1)*Integer.parseInt(onepagerow))+(j+1) %></td>
                                <td title="견적번호">
								 <a class="hyperLink b"  href="javascript:doPop('buyerMpRqDepartmentTotalPop','<%=rowData.get("BUYER")%>', '<%=rowData.get("QUOTATION_NO")%>', '<%=rowData.get("REVISION")%>', '<%=rowData.get("QUOTATION_SEQ")%>');"><b><%=rowData.get("QUOTATION_NO")%></b></a></td>
                                <td title="고객사명" class="td02" class="left"><%=rowData.get("BUYER_NAME")%></td>
                                <td title="견적의뢰일"><%=CommonUtil.formatStrinigDate(rowData.get("BTOA_DATE"))%></td>
                                <td title="품목명"       class="td02"><%=rowData.get("DESCRIPTION")%></td>
                                <td title="제조사"       class="td02"><%=rowData.get("MAKER_NAME")%></td>
								<td title="수량/단위">
								  <input type="hidden" name="st_item_qty" id="st_item_qty" value="<%=rowData.get("ITEM_QTY")%>">
								  <%=CommonUtil.formatNumber(rowData.get("ITEM_QTY"),true,0,3)+" / "+rowData.get("UNIT_MEASURE") %>
								</td>

								<td title="협력사" class="td02" align="left">
								<%
									if(rowData.get("AGENT_OPEN_FLAG").equals("Y")) {
								%>
										<a class="hyperLink" href="javascript:doPop('agent','<%=rowData.get("AGENT")%>');"><%=rowData.get("AGENT_NAME")%></a>
								<%
									}else {
								%>
										<a class="hyperLink" href="javascript:doPop('agent','KRKORE0001');">코리아e플랫폼(주)</a>
								<%
									}
								%>
								</td>
                                <td title="요청자"><%=rowData.get("BTOA_USER_NAME")%></td>
                                <td title="KeP담당자" class="td02" colspan="2">
                                	<a class="hyperLink" href="javascript:doPop('kepManagerPop','<%=rowData.get("KEP_USER_ID")%>')"><%=rowData.get("KEP_USER_NAME")%></a>
                                </td>
                                <td title="비고" class="td02">
								<%
                                        if(rowData.get("ATOB_REMARK").equals("")) {
                                %>
                                		<img name = "st_atob_remark_img" id="st_atob_remark_img" src="/resources/images/but_icon02.gif" border="0">
                                <%
                                        }else {
                                %>
                                            <a href="javascript:doPop('remark','<%=rowData.get("ATOB_REMARK")%>','<%=rowData.get("BTOA_REMARK")%>');"><img name = "st_atob_remark_img" src="/resources/images/but_icon01.gif" border="0"></a>
                                <%
                                        }
                                %>
                                </td>
                            </tr>
                            <tr align="center" bgcolor="<%=tclass%>">
                                <td title="진행상태">
								<%
									if(rowData.get("SOURCING_STATUS").equals("Nego합의대상")) {
								%>
										<a class="hyperLink" href="javascript:doPop('getNegoView','<%=rowData.get("BUYER")%>','<%=rowData.get("QUOTATION_NO")%>','<%=rowData.get("QUOTATION_SEQ")%>','<%=rowData.get("REVISION")%>');"><%=rowData.get("SOURCING_STATUS")%></a>
										<% if(rowData.get("MSDS_YN").equals("Y")) {    %>
									          <br><a class="hyperLink" href="javascript:doPop('getMsdsView','<%=rowData.get("MSDS_NO")%>','<%=rowData.get("BUYER")%>','<%=rowData.get("QUOTATION_NO")%>','<%=rowData.get("QUOTATION_SEQ")%>','<%=rowData.get("REVISION")%>');"><%=rowData.get("MSDS_TYPE_TEXT")%></a>
										<% } %>
								<%
									}else {
								%>
										<%=rowData.get("SOURCING_STATUS")%>
										<% if(rowData.get("MSDS_YN").equals("Y")) {    %>
									          <br><a class="hyperLink" href="javascript:doPop('getMsdsView','<%=rowData.get("MSDS_NO")%>','<%=rowData.get("BUYER")%>','<%=rowData.get("QUOTATION_NO")%>','<%=rowData.get("QUOTATION_SEQ")%>','<%=rowData.get("REVISION")%>');"><%=rowData.get("MSDS_TYPE_TEXT")%></a>
										<% } %>
								<%
									}
								%>
								</td>
                                <td title="품목코드" class="td02" class="left">
                                    <input type="hidden" name="st_buyer_item_no2" id="st_buyer_item_no2" value="<%=rowData.get("BUYER_ITEM_NO")%>">
                                    <a class="hyperLink"  href="javascript:doPop('quotation_print','<%=rowData.get("QUOTATION_NO")%>','<%=rowData.get("QUOTATION_SEQ")%>','<%=rowData.get("REVISION")%>','<%=rowData.get("AGENT")%>','N','<%=rowData.get("BUYER_ITEM_NO")%>','<%=rowData.get("BUYER")%>');"><%=rowData.get("BUYER_ITEM_NO")%></a>
                                </td>
                                <td title="회신요청일" class="td02">
									<b><%=CommonUtil.formatStrinigDate(rowData.get("BTOA_END_DATE"))%> <%//=rowData.get("BTOA_END_TIME")%></b>
								</td>
                                <td title="규격" class="td02" class="left"><%=rowData.get("SPECIFICATION")%></td>
                                <td title="원산지"><%=rowData.get("ORIGIN_NAME")%></td>
								<td title="단가구분/요청단가">
									<input type="hidden" name="st_target_price" id="st_target_price" size="10" maxlength ="17"  value="<%=rowData.get("BUYER_TARGET_PRICE")%>">
									<%=rowData.get("REQ_PRICE_TYPE_TEXT") + " / " + CommonUtil.formatNumber(rowData.get("BUYER_TARGET_PRICE"),true,0,3)%>
								</td>
                                <td title="견적단가" class="td02" class="right">
                                    <input type="hidden" name="st_confirm_price" id="st_confirm_price"  value="<%=rowData.get("ATOB_UNIT_PRICE")%>">
                                    <%=CommonUtil.formatNumber(rowData.get("ATOB_UNIT_PRICE"),true,0,3)%>
                                </td>
                                <td title="요청부서"><%=rowData.get("BTOA_USER_DEPT")%></td>
                                <td title="Nego">
<%
                if(user_group.equals("C") || user_group.equals("A")) {
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
                                <td title="취소사유">
<%
			if(user_group.equals("C") || user_group.equals("A") || user_group.equals("N")) {
%>
                                  <a href="javascript:doPop('canclereq',<%=j%>)"><img name="cancleImage" id="cancleImage" src="/resources/images/icon2.gif"></a>
<%
                }
%>
                                </td>
                            </tr>
				
<%
				
			}
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
					■ <b>실적단가 금액</b> : <input type="text" name="st_target_price_amt" id="st_target_price_amt" style="text-align:right;border-width:0px;" size="10" value="0원" readonly>,   
					■ <b>견적단가 금액</b> : <input type="text" name="st_atob_unit_price_amt" id="st_atob_unit_price_amt" style="text-align:right;border-width:0px;" size="10" value="0원" readonly>,  
					■ <b>절감금액</b> : <input type="text" name="st_quotation_price_amt" id="st_quotation_price_amt" style="text-align:right;border-width:0px;" size="15" value="%" readonly>,
					■ <b>절감율</b> : <input type="text" name="st_rate" id="st_rate" style="text-align:right;border-width:0px;" value="%" size="6" readonly>
			<%
				}
			%>
				<span class="btn_04 mr04"><a href="javascript:ExcelDown()"><%=CommonLang.get("HTITLE150") %><!-- 엑셀다운로드 --></a></span>
			</div>
			<div class="fr">			
				
	<%
		if(user_group.equals("C") || user_group.equals("A")) {
	%>
        		<span class="btn_03 mr04">
					<a href="javascript:doAction('cancleSubmit');">견적취소</a>
				</span>
        		<span class="btn_03 mr04">
					<a href="javascript:doAction('confirmKepPrice');">단가합의</a>
				</span>
				<span class="btn_03">
					<a href="javascript:doAction('negoSubmit');">NEGO요청</a>
				</span>	
	<%
		}else if(user_group.equals("N")) {
	%>
        		<span class="btn_03 mr04">
					<a href="javascript:doAction('cancleSubmit');">견적취소</a>
				</span>
				<span class="btn_03">
					<a href="javascript:doAction('negoSubmit');">NEGO요청</a>
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
    <input type="hidden" name="st_close_remark" id="st_close_remark"      value="">
    <input type="hidden" name="st_recv_flag" id="st_recv_flag"      value="">
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
var gridIndex = 0;
var btnEvent = "";
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
		alert("선택된 항목이 없습니다.");
		return;
	}
	
	var buyer = "<%=com_code%>";
	var st_user_id  = "<%=login_id%>";
	/*if(buyer !="KRHYOS0049"&&buyer !="KRHANH0008"&&buyer !="KRHANH0009"&&buyer !="KRHANW0057"&&buyer !="KRHANW0058"){
		if (buyer !="KRSYSE0001" && st_user_id !="SYSJADMIN") {
			alert("특정 고객사 및 특정 권한 사용자만 조회가능합니다.");
			return;
		}
	}*/
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
		jspTableClean("table_list");
		document.getElementById("st_checkbox").checked = false;
		break;

	case "negoSubmit": // 네고요청
		if(setGridData(btnEvent)){
			if(!confirm("NEGO요청 하시겠습니까?")) return;
			kepAjaxFormCall("/mprq/saveBuyerMpRqUnitpriceAgrmntNegoReqMultiList.do","processForm",btnEvent); 
		}
	
		break;

	case "confirmKepPrice": // 단가합의	
		if(setGridData(btnEvent)){
			if(!confirm("단가합의 하시겠습니까?")) return;
	
			kepAjaxFormCall("/mprq/saveBuyerMpRqUnitpriceAgrmntMulti.do","processForm",btnEvent); 
		}
		break;
	
	case "printPum": // 견적서 출력
		getQuotationHiteLists();
		break;
		
	case "cancleSubmit": // 취소
		if(setGridData(btnEvent)){
			if(!confirm("견적을 취소 하시겠습니까?")) return;
			kepAjaxFormCall("/mprq/saveBuyerMpRqUnitpriceAgrmntCancleReqList.do","processForm",btnEvent); 
		}	
		break;
		
	case "estimateClose":// 견적종료
			if(!confirm("견적종료 하시겠습니까? \n\n확인을 클릭하시면 견적종료 사유를 입력할 수 있는 창이 뜹니다.")) return;
			doPop('closeReg');
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
// 	var cnt      = getCheckedRowCount(tot_cnt);
	if (btnEvent == "negoSubmit"){ // 네고요청
  	    var box = "";
	  	var btoa_nego_price  = "";
	  	var btoa_end_date = "";

		if (tot_cnt < 2) {
			box = eval("document.forms.contentForm.checkbox0");
	            if(box.checked == true){
	            	btoa_nego_price  = document.forms.contentForm.st_btoa_nego_price2.value;
	            	btoa_end_date = document.forms.contentForm.st_btoa_end_date2.value;

	            	if(kepIsValueNull(kepTrimStr(btoa_nego_price))) {
	                  alert("Nego단가를 입력하여 주십시요.");
	                  return false;
	               }

	  	           if(kepIsValueNull(kepTrimStr(btoa_end_date))) {
	  	              alert("회신요청일을 입력하여 주십시요.");
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

  	            	if(kepIsValueNull(kepTrimStr(btoa_nego_price))) {
  	                  alert("Nego단가를 입력하여 주십시요.");
  	                  document.forms.contentForm.st_btoa_nego_price2[k].focus();
  	                  return false;
  	               }

	  	           if(kepIsValueNull(kepTrimStr(btoa_end_date))) {
	  	              alert("회신요청일을 입력하여 주십시요.");
	  	              document.forms.contentForm.st_btoa_end_date2[k].focus();
	  	              return false;
	  	           }
  	            }
  	        }
		}
  	}else if(btnEvent == "confirmKepPrice"){
  		
	  	var item_gubun = "";
	  	var doos_item_no_back = "";
    	item_gubun = document.forms.contentForm.st_item_gubun.value;
    	if (tot_cnt < 2) {
			box = eval("document.forms.contentForm.checkbox0");
	            if(box.checked == true){
	            	var msds_yn = document.forms.contentForm.st_msds_yn.value;
					var st_confirm_price = document.forms.contentForm.st_confirm_price.value; // 견적단가
	            	
	            	if(st_confirm_price == 0 || st_confirm_price == "0") {
	            		alert("<%=CommonLang.msg("MSG599")%>");
	            		return false;
	            	}
			    	if(item_gubun == "I"){
			    		doos_item_no_back = document.forms.contentForm.st_doos_item_no_back.value;
			        	if(kepIsValueNull(kepTrimStr(doos_item_no_back))) {
			                  alert("재고코드가 입력되지 않았습니다.");
			                  document.forms.contentForm.st_doos_item_no_back.focus();
			                  return false;
			               }	            		
			    	}
			    	if(msds_yn == "Y"){
			    		var msds_status = document.forms.contentForm.st_msds_status.value;
			        	if(msds_status != "A"){
			                  alert("MSDS가 승인되지 않았습니다.");
			                  return false;
			            }	            		
	                }
	            }
	            
		}else{
  	        for(var k = 0; k < tot_cnt; k++){
  	            box = eval("document.forms.contentForm.checkbox" + k);
  	            if(box.checked == true){
	            	item_gubun = document.forms.contentForm.st_item_gubun[k].value;
	            	var msds_yn = document.forms.contentForm.st_msds_yn[k].value;
					var st_confirm_price = document.forms.contentForm.st_confirm_price[k].value; // 견적단가
	            	
	            	if(st_confirm_price == 0 || st_confirm_price == "0") {
	            		alert("<%=CommonLang.msg("MSG599")%>");
	            		return false;
	            	}
	            	if(item_gubun == "I"){
	            		doos_item_no_back = document.forms.contentForm.st_doos_item_no_back[k].value;
		            	if(kepIsValueNull(kepTrimStr(doos_item_no_back))) {
			                  alert(k+1+"번째 재고코드가 입력되지 않았습니다.");
			                  return false;
			               }	            		
	            	}
	            	if(msds_yn == "Y"){
			    		var msds_status = document.forms.contentForm.st_msds_status[k].value;
			        	if(msds_status != "A"){
			                  alert(k+1+"번째 MSDS가 승인되지 않았습니다.");
			                  return false;
			            }	            		
			    	}
	            	
  	            }
  	        }
		}
  	}else if (btnEvent == "cancleSubmit"){ // 취소


		if (tot_cnt < 2) {
			box = eval("document.forms.contentForm.checkbox0");
	            if(box.checked == true){
	            	var st_cancle_remark  = document.forms.contentForm.st_cancle_remark.value;

	  	           if(kepIsValueNull(kepTrimStr(st_cancle_remark))) {
	  	              alert("견적취소 사유를 입력하여 주십시요.");
	  	              document.forms.contentForm.st_cancle_remark.focus();
	  	              return false;
	  	           }
            }
		} else {
  	        for(var k = 0; k < tot_cnt; k++){
  	            box = eval("document.forms.contentForm.checkbox" + k);
  	            if(box.checked == true){
  	            	var st_cancle_remark  = document.forms.contentForm.st_cancle_remark[k].value;

	  	           if(kepIsValueNull(kepTrimStr(st_cancle_remark))) {
	  	        	 alert("견적취소 사유를 입력하여 주십시요.");
	  	              document.forms.contentForm.st_cancle_remark[k].focus();
	  	              return false;
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
		alert("그리드 데이터 변환에 실패하였습니다.[getFormToArr]");
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
	}
	var buyer = "<%=com_code%>";
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
			var type = "NS"; // 소싱합의
			openSearchPopup("/common/approval/buyerCommonApprovalPop.do", '?DOC_TYPE=' + type + '&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO='+response.msg.usrmsg+'&PARAM1='+buyer, "1000,500,no");
		}
	} else if (pMethod=="estimateClose") {
		alert(response.msg.msg);
		kepSearch($("#curPage").val());
		return;
	} else {
		// 처리후 재조회
		kepSearch($("#curPage").val());
	}
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	alert("단가합의 하던중 오류가 발생되었습니다.\n\n관리자에게 문의 바랍니다.");
	
} 
function kepApprovalReturn(flag,docu_no){
	kepSearch($("#curPage").val());
}
//SLOGIC-BEGIN(P04-4027-03)
//하이트 강원 견적서
function getQuotationHiteLists(){
	var buyer = "<%=com_code%>";
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

		if(checkbox.checked==true) {

			if(isEmpty(agent) || agent=="") {
				alert("견적서가 생성되지 않았습니다.");
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
		for(var j=0; j<tot_cnt; j++) {
			
			var checkbox			= eval("document.forms.contentForm.checkbox" + j);
			var li_buyer			= document.forms.contentForm.st_buyer2[j].value;
			var li_quotation_no     = document.forms.contentForm.st_quotation_no2[j].value;
			var li_quotation_seq    = document.forms.contentForm.st_quotation_seq2[j].value;
			var li_revision         = document.forms.contentForm.st_revision2[j].value;
			var agent				= document.forms.contentForm.st_agent2[j].value;
	
			if(checkbox.checked==true) {
	
				if(isEmpty(agent) || agent=="") {
					alert((j+1)+"번째 품목은 견적서가 생성되지 않았습니다.");
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
// 			window.open("/kr/new_sourcing/sheet/buyer/sysop_sourcing_print_sntdw.jsp?st_buyer="+buyer+"&st_quotation_no="+c_quotation_no+"&st_quotation_seq="+c_quotation_seq+"&st_revision="+c_revision, "SheetSntdw","width=1100,height=700,resizable=NO,scrollbars=NO,top=0,left=0");
	 	}else{ 
	 		fileName = "RD_04_B_006_03";
			param = "["+buyer+"]["+query+"]";
// 			window.open("/kr/new_sourcing/sheet/buyer/sysop_proxbuy_sourcing_print_buyer_report_hite_sheet.jsp?st_buyer="+buyer+"&st_query="+query, "SheetWin","width=700,height=700,resizable=YES,scrollbars=YES,top=0,left=0");
		}
		
// 		alert(param);
	  	reportOpen(fileName,param);
	  	return;
}
//SLOGIC-END
// 조회
function kepSearch(curPage){
	if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
	
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mprq/getBuyerMpRqUnitpriceAgrmntNegoReqMultiList.do").submit();   
}
  
// 팝업 함수호출
function doPop(str,value1, value2, value3, value4, value5, value6,value7) {
	switch (str) {
	case "dept": // 요청부서
		popupSel = "dept";
		openSearchPopup("/common/deptCodeAdminPop.do", '?open=Y&com_code='+value7, "500,500,no");
		break;
	case "buyerMpRqDepartmentTotalPop": // 견적번호
		<%
		//두산중공업 펀치아웃 
		//SLOGIC-BEGIN(P06-0000052)
		if(p060000052 == true) {
		%>
			openSearchPopup("/common/mprq/quotationReDetailPop.do", '?st_buyer='+value1+'&st_quotation_no='+value2+'&st_revision='+value3, "1020,500,no");
	<%}else{%>
			//openSearchPopup("/mprq/showBuyerMpRqDepartmentTotalPop.do", '?st_buyer='+value1+'&st_quotation_no='+value2+'&st_revision='+value3, "950,450,no");
			openSearchPopup("/common/mprq/quotationReDetailPop.do", '?st_buyer='+value1+'&st_quotation_no='+value2+'&st_revision='+value3+'&st_quotation_seq='+value4, "1020,500,no");
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
		var buyer = value7;
		var fileName = "<%=reportid%>";
		var type = "<%=reporttype%>";
		var param =  "["+buyer+"]["+value1+"]["+value2+"]["+value3+"]["+value4+"]["+value5+"]";
		if (type == "A"){
			param =  "["+buyer+"]["+value1+"]["+value2+"]["+value3+"]["+value5+"]";
		} else if (type == "E"){
			var query = "";
			param =  "["+buyer+"]["+value1+"]["+value2+"]["+value3+"]["+value4+"]["+query+"]";
		} else if (type == "F"){
			param =  "["+buyer+"]["+value1+"]["+value2+"]["+value3+"]["+value4+"]["+value6+"]";
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
	case "getNegoView":
		openSearchPopup('/mprq/showBuyerMpRqSamyangNegoViewPop.do','?st_buyer='+value1+'&st_quotation_no='+value2+'&st_quotation_seq='+value3+'&st_revision='+value4,'1000,300,no');  
		break;
	case "getMsdsView":
		openSearchPopup("/coco/showCommonCoCoMsdsDetailPop.do","?st_msds_no="+value1+'&st_buyer='+value2+'&st_quotation_no='+value3+'&st_quotation_seq='+value4+'&st_revision='+value5, '750,580,no');
		break;	
	case "closeReg"://네고팝업
		popupSel = "buyerMpRqClosePop";

		openSearchPopup('/mprq/showBuyerMpRqClosePop.do','','400,250,no');// 파일첨부
	case "canclereq"://취소팝업		
		popupSel = "cancelRemark";
		gridIndex = value1;
		var viewType="R";
		var cancel_remark = $("input[name=st_cancle_remark]").eq(gridIndex).val();
		openSearchPopup("/common/remarkCancelPop.do",'?cancel_remark='+cancel_remark+'&viewType='+viewType,"500,230,no");
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

    document.forms.contentForm.st_target_price_amt.value = kepCommaNum(target_price_amt)+" 원";
    document.forms.contentForm.st_atob_unit_price_amt.value = kepCommaNum(atob_price_amt)+" 원";
    document.forms.contentForm.st_quotation_price_amt.value = kepCommaNum(eval(target_price_amt)-eval(atob_price_amt))+" 원";

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

//엑셀다운로드
function ExcelDown(){
	if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
	
	document.forms.searchForm.method = "post";
	document.forms.searchForm.action = "/mprq/getBuyerMpRqUnitpriceAgrmntNegoReqMultiExcelDown.do";
	document.forms.searchForm.submit();
}
</script>
</html>
