<%--
**********************************************
* 메뉴 : 주문관리>장바구니(코웨이용)
* 화면 : 장바구니(코웨이용)
* 기능 : 코웨이용 장바구니
* 프로그램 ID : PG_06_B_010_00   - CY20006243 -- 20015159
* 담당자 : CEJ ( 설계 : 김지현 )
* 착수일 : 2014-06-16
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
<script src="/resources/js/kep_buyer.js"></script> 
</head>
<%
	// 공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
	String Hdata_FLAG = (String) request.getAttribute("Hdata"); // 조회된 결과	
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,""); // 총 조회수 (필수)
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),""); // 현재페이지  (필수)
	String onepagerow =  CommonUtil.nvl((String) request.getParameter("onepagerow"),"10");   // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	
    
	// 조회조건 S
	String st_query_cart = CommonUtil.nvl((String) request.getParameter("st_query_cart"),"ALL");   
	//홍대~~~~~~~~~~~~~~~~~~~
	String st_verif_num = CommonUtil.nvl((String) request.getParameter("st_verif_num"),"");    
	String st_sort_gubun = CommonUtil.nvl((String) request.getParameter("st_sort_gubun"),"c_date");    
	String st_sort_change = CommonUtil.nvl((String) request.getParameter("st_sort_change"),"");     
	String st_check       = CommonUtil.nvl((String) request.getParameter("st_check"),"SEARCH");    	
	String st_zip_code = CommonUtil.nvl((String) request.getParameter("st_zip_code"),""); 
	String st_tel_no = CommonUtil.nvl((String) request.getParameter("st_tel_no"),""); 
	String st_fax_no = CommonUtil.nvl((String) request.getParameter("st_fax_no"),""); 
	String st_mobile_no = CommonUtil.nvl((String) request.getParameter("st_mobile_no"),""); 
	String st_user_name = CommonUtil.nvl((String) request.getParameter("st_user_name"),""); 
	String st_email = CommonUtil.nvl((String) request.getParameter("st_email"),""); 
	String st_user_id = CommonUtil.nvl((String) request.getParameter("st_user_id"),"");  
	String st_recv_date = CommonUtil.nvl((String) request.getParameter("st_recv_date"),""); 
	String st_recv_date2 = CommonUtil.nvl((String) request.getParameter("st_recv_date2"),""); 
	String st_remark = CommonUtil.nvl((String) request.getParameter("st_remark"),""); 
	String st_location_code = CommonUtil.nvl((String) request.getParameter("st_location_code"),""); 
	String st_location_type = CommonUtil.nvl((String) request.getParameter("st_location_type"),""); 
	String st_location_name = CommonUtil.nvl((String) request.getParameter("st_location_name"),""); 
	String st_purchase_dept_name = CommonUtil.nvl((String) request.getParameter("st_purchase_dept_name"),""); 
	String st_purchase_dept_code = CommonUtil.nvl((String) request.getParameter("st_purchase_dept_code"),""); 
	
    String sort_type      = CommonUtil.nvl((String) request.getParameter("st_sort_type"),"");
    if(sort_type.equals(""))
    {
        sort_type = "c_date";
    }
				
	// 조회조건 E 

	String SessionComCode = "";
	String byca_comorg_code = ""; 
	String img_view_flag   = "";
	String buyer             = "";
	String userDept              = "";
	String budget_flag       = "";     // 고객사 예산 사용여부
    String userRole           = "";  
    String userRole1 = "";  
    String userRole2 = "";   
    String userId = "";
 
	
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	if (sessionInfo != null){ 
		SessionComCode =  CommonUtil.nvl((String)sessionInfo.getComCode()); 
		byca_comorg_code =  CommonUtil.nvl((String)sessionInfo.getBycaComorgCode()); 
		img_view_flag =  CommonUtil.nvl((String)sessionInfo.getImgViewFlag()); 
		buyer  = SessionComCode;
		userDept =  CommonUtil.nvl((String)sessionInfo.getDepartment()); 
		budget_flag =  CommonUtil.nvl((String)sessionInfo.getBudgetFlag()); 
		userRole = CommonUtil.nvl((String)sessionInfo.getRole()); 
		userId = CommonUtil.nvl((String)sessionInfo.getUserId()); 
	}  
	if (userRole !=null){
			if (userRole.length() == 2){
			    userRole1 = userRole.substring(0,1);
			    userRole2 = userRole.substring(1,2);
			}
	}
	
    String st_image_status   = CommonUtil.nvl((String) request.getParameter("st_image_status"),"");
    if(st_image_status.equals(""))
    { 
            if(img_view_flag.trim().equals("N")){  // 20070704 이미지보기 정보 세션에서 가져오기
            	st_image_status = "IMAGE_HIDDEN";
            }else{
            	st_image_status = "IMAGE_VIEW";
            } 
    } 
    
	String req_date			  = CommonUtil.formatDateNoDateGubun(new Date(),1); 
	String select_year				=  req_date.substring(0,4);
	String select_mm			=  req_date.substring(4,6);
	String select_dd				=  req_date.substring(6,8); 
	  
    String p060000027 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000027","COL05_DATA"); // KRGEST0001 KRHONG0020 KRKEPB0004 
    boolean p060000034 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000034"); // KRDAEW0023 KRDAEW0043 KRDAEW0045 
	 //SLOGIC-BEGIN(P06-0000035)
    String reportText= "품의서출력"; // default 버튼명 
    String reportid = "RD_06_B_001_17";  ///kr/customer/sheet/cart_print_t.jsp
    String reportFunction = "doAction('PrSheet')";  // default report 
    Map<String, String> p060000035 = CommonUtil.getSpecialCheckReturnMap(buyer,"P06-0000035");   // com_code , 특수로직아이디
    if (p060000035 != null){
    	reportText= CommonUtil.nvl(p060000035.get("COL01_DATA"),reportText); // 레포트 버튼명
    	reportid = CommonUtil.nvl(p060000035.get("COL02_DATA"),reportid); // 레포트아이디
    	reportFunction = CommonUtil.nvl(p060000035.get("COL04_DATA"),reportFunction); // 레포트 asis 함수
    }
    //SLOGIC-END
    
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
	<h3>장바구니</h3>
	<!--조회영역-->
	<form name = "searchForm" id="searchForm" method = "post">
		<!--HIDDEN-->
		<!-- 공통 -->
		<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
		<!-- 화면 내 정의 -->
		<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
		<input type="hidden" name="st_buyer" id="st_buyer" value="<%=buyer %>">    
		
		<input type="hidden" name="st_verif_num" id="st_verif_num" value="<%=st_verif_num %>" /> 
		<input type="hidden" name="st_sort_change" id="st_sort_change" value="<%=st_sort_change %>">  
 		<input type="hidden" name="st_image_status" id="st_image_status" value="<%=st_image_status %>">
 		<input type="hidden" name="st_check" id="st_check" value="<%=st_check %>">    
 		<input type="hidden" name="st_user_dept" id="st_user_dept" value="<%=userDept %>">   
		<input type="hidden" name="st_item_no_in" id="st_item_no_in" value="">
		
		
		<input type="hidden" name="confirm1" id="confirm1" value="">
		<input type="hidden" name="confirm2" id="confirm2" value="">
		<input type="hidden" name="confirm3" id="confirm3" value="">
		<input type="hidden" name="confirm4" id="confirm4" value="">		
		
		<input type="hidden" name="st_zip_code"       value="<%=st_zip_code%>">
		<input type="hidden" name="st_tel_no"         value="<%=st_tel_no%>">
		<input type="hidden" name="st_fax_no"         value="<%=st_fax_no%>">
		<input type="hidden" name="st_mobile_no"      value="<%=st_mobile_no%>">
		<input type="hidden" name="st_user_name"      value="<%=st_user_name%>">
		<input type="hidden" name="st_email"          value="<%=st_email%>">
		<input type="hidden" name="st_user_id"        value="<%=st_user_id%>">
		<input type="hidden" name="st_query_cart"     value="<%=st_query_cart%>">
		<input type="hidden" name="st_recv_date"      value="<%=st_recv_date%>">
		<input type="hidden" name="st_recv_date2"     value="<%=st_recv_date2%>">
		<input type="hidden" name="st_remark"         value="<%=st_remark%>">
		<input type="hidden" name="st_location_code"  value="<%=st_location_code%>">
		<input type="hidden" name="st_location_type"  value="<%=st_location_type%>">
		<input type="hidden" name="st_location_name"  value="<%=st_location_name%>">
		<input type="hidden" name="st_purchase_dept_name"  value="<%=st_purchase_dept_name%>">
		<input type="hidden" name="st_purchase_dept_code"  value="<%=st_purchase_dept_code%>">
					
			
 		<div>
		<div id="cont_searchA" > 	
			<table class="cont_t_list01" >
				<tr><td>	
					<div style="height:20px; margin-bottom:6px; " >
					<!--배송정보 단계일때 이미지명 : b_img_carting02.gif / 주문완료 단계일때 이미지명 : b_img_carting03.gif-->
					<p class="cart"><img src="/resources/images/b_img_carting01.gif" alt="장바구니단계" /></p>
					<span class="sTitle">내가 담은 품목명은 총 <span class="text03"> <%=total_cnt %></span>건입니다. 품목명을 확인하시고 주문해 주세요.</span>
					</div>
				</td></tr>
			</table>
		</div>
			<div class="fl">
            	<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
			      	<label for="b_no02" class="hidden">정렬개수선택</label>
					<select name="onepagerow" onchange="javascript:kepSearch(1);">  
						<option <%=("10".equals(onepagerow) ? "selected" : "")%> value = "10">10건</option>
						<option <%=("15".equals(onepagerow) ? "selected" : "")%> value = "15">15건</option>
						<option <%=("20".equals(onepagerow) ? "selected" : "")%> value = "20">20건</option>
						<option <%=("25".equals(onepagerow) ? "selected" : "")%> value = "25">25건</option>
						<option <%=("50".equals(onepagerow)  ? "selected" : "")%> value = "50">50건</option>
						<option <%=("100".equals(onepagerow) ? "selected" : "")%> value = "100">100건</option> 
					</select>
				<select name="st_sort_gubun"  onchange="javascript:kepSearch(1);">  
				        <option <%=(st_sort_gubun.equals("c_date") ? "selected" : "")%> value = "c_date">등록일시&nbsp;</option>
				        <option <%=(st_sort_gubun.equals("c_item") ? "selected" : "")%> value = "c_item">품목코드&nbsp;</option>
				        <option <%=(st_sort_gubun.equals("c_prno") ? "selected" : "")%> value = "c_prno">관리번호&nbsp;</option>
				      </select>&nbsp;&nbsp;					
		      	</span>	          
                <span class="btn_imghide">
<%  if(st_image_status.equals("IMAGE_HIDDEN")){   %>
<a href="javascript:imageHideView();"  title="이미지보이기" >이미지보이기</a>
<%  }else{   %>
<a href="javascript:imageHideView();"  title="이미지감추기" >이미지감추기</a>
<%  }   %> </span>
		      </div>
		      <div class="fr"><b>총 금액 :</b><input type="text" name="check_sum_price"   id="check_sum_price"  class="input_type_text"  value="0" style="background-color:#FFFFFF;font-weight: bold;font-size:9pt;border:#FFFFFF 1px solid;text-align:right;" READONLY>&nbsp;
            <input type="hidden" name="st_check_sum_price"  id="st_check_sum_price"  value=""> 
              </div>
        </div>
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<!-- 공통 -->
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
		<input type="hidden" name="sangjo_cnt" id="sangjo_cnt" value="">
	  	<input type="hidden" name="st_key_flag"       value="">
		<table class="cont_t_list02" style="width:100%">
			<colgroup>
               <col width="3%" />
               <col width="7%" /> 
               <col width="*" />
               <col width="13%" />
<%

if("Y".equals(budget_flag)){ 
%>                              
               <col width="10%" />
<%} %>     
               <col width="10%" />
               <col width="8%" />
               <col width="8%" />
               <col width="8%" />
           </colgroup>
           <thead>
               <tr>
                   <th scope="col">
<%
if (_gridList == null || _gridList.size() == 0){
}else{
%>
                   <input type="checkbox" name="check_status" id="check_status" value="선택"  style="cursor:pointer;" onclick="kepCheckAll(document.forms.contentForm.display_item_cnt.value,document.forms.contentForm.check_status,'document.forms.contentForm.lnCheck');chk_sum_price();">
<%} %>
                   </th>
                   <th scope="col">&nbsp;</th>
                   <th scope="col">품목코드 / 품목명 / 규격</th>
                   <th scope="col">협력사/단위</th> 
                   
<%

if("Y".equals(budget_flag)){ 
%>
   <th scope="col">예산부서/계정명</th>
<%
}else{
%>                	
<%} %>         
                 
			       <th scope="col">단가/구매수량</th>
			       <th scope="col">구매액</th> 
			       <th scope="col">파일첨부/양식</th>   
			        <%if (userRole2.equals("+")) { %>
			       <th>선택</th>        
			       <%} %>    
               </tr>
           </thead>
           <tbody>
<%
if (_gridList == null || _gridList.size() == 0){
%>
		<tr>
			<td colspan="10" align="center" height = "50"> 
			<span>조회된 데이타가 없습니다.</span>
			</td> 
		</tr>
<%
}else{

Map<String,String> rowData = null;
for (int j=0; j<_gridList.size(); j++) {
	rowData = _gridList.get(j);
	String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";

	
%> 
				<tr bgcolor="<%=tclass%>">
					<td>
						<input type="checkbox" name="lnCheck<%=j%>" onclick="chk_sum_price()">	 
					</td>
					<td>
                    
<% if(st_image_status.equals("IMAGE_HIDDEN")){
       if("".equals(CommonUtil.nvl(rowData.get("IMGFILE_DIR")))){
%>
           <img src="/resources/images/but_img_off.gif" border="0">
          <%=(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem.gif>")%>
          <%=(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem1.gif>")%>
          <%=(CommonUtil.nvl(rowData.get("ITEM_STATUS_FLAG")).equals("거래") ? "" : "<img src=/resources/images/outitem2.gif>")%>
 
<%     }else{ %> 
             <a href="javascript:getBigImage('<%=CommonUtil.nvl(rowData.get("IMGFILE_DIR"))%>','<%=CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>');">
             <img src="/resources/images/but_img_on.gif" border="0"></a>
          <%=(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem.gif>")%>
          <%=(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem1.gif>")%> 
          <%=(CommonUtil.nvl(rowData.get("ITEM_STATUS_FLAG")).equals("거래") ? "" : "<img src=/resources/images/outitem2.gif>")%>
 
<%     }
    }else{
    	 if("".equals(CommonUtil.nvl(rowData.get("IMGFILE_DIR")))){
%>
          <img src="/resources/images/noimage.gif" width="80" height="80" border="0">
          <%=(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem.gif>")%>
          <%=(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem1.gif>")%>
          <%=(CommonUtil.nvl(rowData.get("ITEM_STATUS_FLAG")).equals("거래") ? "" : "<img src=/resources/images/outitem2.gif>")%>
 
<%     }else{ %> 
             <a href="javascript:getBigImage('<%=CommonUtil.nvl(rowData.get("IMGFILE_DIR"))%>','<%=CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>');"><img src="<%=CommonUtil.realImgS3UploadPath+"/"+CommonUtil.nvl(rowData.get("IMGFILE_DIR"))+"/"+CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>"  onerror="javasrcipt:this.src='/resources/images/noimage.gif'"  name="image1" width="80" height="80" border="0"></a>
          <%=(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem.gif>")%>
          <%=(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem1.gif>")%>
          <%=(CommonUtil.nvl(rowData.get("ITEM_STATUS_FLAG")).equals("거래") ? "" : "<img src=/resources/images/outitem2.gif>")%>
 
<%     }
    }
%>		 
                    </td>
				 
				 
				 
				 
				 
				    <td  class="left">
                    <input type="hidden" name="st_item_no"            value="<%=rowData.get("BUYER_ITEM_NO")%>" >
                    <input type="hidden" name="st_contract_no"        value="<%=rowData.get("CONTRACT_NO")%>">
                    <input type="hidden" name="st_contract_seq"       value="<%=rowData.get("CONTRACT_SEQ")%>">
                    <input type="hidden" name="st_agent_code"         value="<%=rowData.get("AGENT_CODE")%>">
                    <input type="hidden" name="st_byit_comorg_code"   value="<%=rowData.get("BYIT_COMORG_CODE")%>">
                    <input type="hidden" name="st_bdgt_flag"          value="<%=rowData.get("BDGT_FLAG")%>">
                    <input type="hidden" name="st_product_close_flag" value="<%=rowData.get("PRODUCT_CLOSE_FLAG")%>">
                    <input type="hidden" name="st_process_type"         value="<%=rowData.get("PROCESS_TYPE")%>">
                    <input type="hidden" name="st_stock_item_flag"      value="<%=rowData.get("STOCK_ITEM_FLAG")%>">
                    <input type="hidden" name="st_ref_pr_dept" value="<%=rowData.get("HI_DEPT_CODE")%>">
                    <input type="hidden" name="st_ref_pr_no"        value="<%=rowData.get("REF_PR_NO")%>">
                    <input type="hidden" name="st_image_key"            value="<%=rowData.get("IMAGE_KEY")%>">
                    <input type="hidden" name="st_format_type"            value="<%=rowData.get("MG_CODE")%>">
                    <input type="hidden" name="st_byit_bdgt_flag"            value="<%=rowData.get("MG_NOTE")%>">
                    <input type="hidden" name="st_category_no"            value="<%=rowData.get("CATEGORY_NO")%>">
                    <input type="hidden" name="st_cate_appr"            value="<%=rowData.get("CATE_APPR")%>">
                    <input type="hidden" name="st_item_status_flag"			value="<%=rowData.get("ITEM_STATUS_FLAG")%>">
                    <input type="hidden" name="st_cart_seq" value="<%=rowData.get("CART_SEQ")%>" >
                    <!--<input type="hidden" name="st_account_type"       value="<%=rowData.get("ACCOUNT_TYPE")%>"> -->
                 <div title="품목코드"><a class="hyperLink"  href="javascript:getBuyerCatalogDisplayPop('<%=rowData.get("BYIT_COMORG_CODE")%>','<%=rowData.get("BUYER_ITEM_NO")%>','<%=rowData.get("CONTRACT_NO")%>','<%=rowData.get("CONTRACT_SEQ")%>');"><%=rowData.get("BUYER_ITEM_NO")%></a>
                <span title="품목명"><%=rowData.get("DESCRIPTION_LOC")%></span></div>
                <div title="규격"><%=rowData.get("SPECIFICATION")%>
                            <% if(rowData.get("PRODUCT_CLOSE_FLAG").equals("Y")) { %>&nbsp; <% }else if(rowData.get("OVER_SHORT_FLAG").equals("N")) { %>&nbsp; <% } else { %> <br><font color="green">(재 판매일 :<%=CommonUtil.formatStrinigDate(rowData.get("HS_NO"))%>)</font><% } %></div></td>
           <td align="center">
            <div title="협력사"><a class="hyperLink"   href="javascript:getAgentDisplayPop('<%=rowData.get("AGENT3")%>');"><%=rowData.get("AGENT")%></a></div><div title="단위"><%=rowData.get("UNIT_MEASURE")%></div>
            </td>
<%
	// ICOMCMPY.BUDGET_FLAG = 'Y' 예산 사용 고객사
	if(budget_flag.equals("Y")){
%>
	<!-- 계정명 , 예산부서 -->
<%
		if(rowData.get("ACCOUNT_NAME").equals(""))
		{
			if(rowData.get("MG_NOTE").equals("N")){
%>
                                     <td><div title="예산부서"><input type="hidden" name="st_budget_dept_name"   size="10" value="" style="font-size: 7px;background:#dae4f0; border:1px solid #dae4f0; color:#212b3c; text-align:left;cursor:pointer;" READONLY></div>
                                    <div title="계정명"><input type="hidden"   name="st_account_type_name"   size="10" value=""  style="font-size: 7px;background:#dae4f0; border:1px solid #dae4f0; color:#212b3c; text-align:left;cursor:pointer;" READONLY></div>
                                    <input type="hidden" name="st_account_type" value="">
                                    <input type="hidden" name="st_budget_dept" value="">
                                    <input type="hidden" name="st_budget_yn" value="N"></td>
<%
			}else{
%>
                                    <td><div title="예산부서"><input type="text" name="st_budget_dept_name"   size="10" value="<%=rowData.get("BUDGET_DEPT_CODE").equals("")?"선택":rowData.get("BUDGET_DEPT_NAME")%>" style="font-size: 9px; background:#dae4f0; border:1px solid #dae4f0; color:#212b3c; text-align:left;cursor:pointer;" READONLY onClick="javascript:getDeptAccountPop('<%=buyer%>','<%=j%>');"><a href="javascript:getDeptAccountPop('<%=buyer%>','<%=j%>');"><img src="/resources/images/btn_search03.gif"  align="top" /></a></div>
                                    <div title="계정명"><input type="text"   name="st_account_type_name"   size="10" value="선택"  style="font-size: 7px;background:#dae4f0; border:1px solid #dae4f0; color:#212b3c; text-align:left;cursor:pointer;" READONLY onClick="javascript:getBdgtAccountPop('<%=buyer%>','<%=userDept%>','<%=j%>');"><a href="javascript:getBdgtAccountPop('<%=buyer%>','<%=userDept%>','<%=j%>');"><img src="/resources/images/btn_search03.gif"   align="top"  /></a></div>
                                    <input type="hidden" name="st_account_type" value="<%=rowData.get("ACCOUNT_TYPE")%>">
                                    <input type="hidden" name="st_budget_dept" value="<%=rowData.get("BUDGET_DEPT_CODE")%>">
                                    <input type="hidden" name="st_budget_yn" value="Y"></td>
<%
			}
		}else{
			if(rowData.get("MG_NOTE").equals("N")){
%>
                                     <td><div title="예산부서"><input type="hidden" name="st_budget_dept_name"   size="13" value="" style="font-size: 7px;background:#dae4f0; border:1px solid #dae4f0; color:#212b3c; text-align:left;cursor:pointer;" READONLY></div>
                                    <div title="계정명"><input type="hidden"   name="st_account_type_name"  size="13" value=""  style="font-size: 7px;background:#dae4f0; border:1px solid #dae4f0; color:#212b3c; text-align:left;cursor:pointer;" READONLY></div>
                                    <input type="hidden" name="st_account_type" value="">
                                    <input type="hidden" name="st_budget_dept" value="">
                                    <input type="hidden" name="st_budget_yn" value="N"></td>
<%
			}else{
%>
                                     <td>
                                     <div title="예산부서">
                                     <input type="text" name="st_budget_dept_name"  size="13" value="<%=rowData.get("BUDGET_DEPT_CODE").equals("")?"선택":rowData.get("BUDGET_DEPT_NAME")%>" style="background:#dae4f0; border:1px solid #dae4f0; color:#212b3c; text-align:left;cursor:pointer;" READONLY onClick="javascript:getDeptAccountPop('<%=buyer%>','<%=j%>');"><a href="javascript:getDeptAccountPop('<%=buyer%>','<%=j%>');"><img src="/resources/images/btn_search03.gif"   style="position:relative; top:50%; margin-top:-5px;" /></a>
                                     <input type="text" name="st_budget_dept" size="17" value="<%=rowData.get("BUDGET_DEPT_CODE")%>" style="background:#dae4f0; border:1px solid #dae4f0; color:#212b3c; text-align:left;cursor:pointer;" READONLY >
                                     </div>
                                     <div title="계정명"><input type="text"   name="st_account_type_name"  size="13" value="<%=rowData.get("ACCOUNT_NAME")%>"  style="background:#dae4f0; border:1px solid #dae4f0; color:#212b3c; text-align:left;cursor:pointer;" READONLY onClick="javascript:getBdgtAccountPop('<%=buyer%>','<%=userDept%>','<%=j%>');"><a href="javascript:getBdgtAccountPop('<%=buyer%>','<%=userDept%>','<%=j%>');"><img src="/resources/images/btn_search03.gif"   align="top"  /></a></div>
                                     <input type="hidden" name="st_account_type" value="<%=rowData.get("ACCOUNT_TYPE")%>">
                                     <input type="hidden" name="st_budget_yn" value="Y"></td>
<%
			}
		}
%> 
<%
	}else{  // ICOMCMPY.BUDGET_FLAG = 'N' 예산 미사용 고객사
	
%>
                  		<input type="hidden" name="st_account_type" value="<%=rowData.get("ACCOUNT_TYPE")%>">
                        <input type="hidden" name="st_budget_dept"  value="">
                        <input type="hidden" name="st_budget_yn" value="N"> 
<%

	}
%>
                <td align="right" >
                    <% if(rowData.get("FIXED_PRICE_FLAG").equals("N")) { %>
                        <div title="단가"><input type="text" name="st_order_price" class="input_type_text" size="10" value="<%=CommonUtil.formatNumber(rowData.get("TARGET_PRICE"),true,0,3)%>" onChange="javascript:price_update_P('<%=j%>',this.value,'<%=rowData.get("CART_QTY")%>');" onBlur="this.value=this.value;" onKeyDown="if (event.keyCode == 13) javascript:price_update_P('<%=j%>',this.value,'<%=rowData.get("CART_QTY")%>');"></div>
                    <% }else { %>
                        <div title="단가"><%=CommonUtil.formatNumber(rowData.get("TARGET_PRICE"),true,0,3)%></div>
                        <input type="hidden" name="st_order_price" value="<%=CommonUtil.formatNumber(rowData.get("TARGET_PRICE"),true,0,3)%>">
                    <% } %>
                    <input type="hidden" name="st_fixed_price_flag" value="<%=rowData.get("FIXED_PRICE_FLAG")%>">
                            <div title="구매수량"><input type="text" name="st_order_qty"  style="text-align:right;"  class="input_type_text" id="line" size="7" value="<%=rowData.get("CART_QTY")%>" onChange="javascript:price_update(this.value,'<%=j%>','<%=rowData.get("TARGET_PRICE")%>','<%=rowData.get("CART_QTY")%>');" onBlur="this.value=this.value;" onKeyDown="if (event.keyCode == 13) javascript:price_update(this.value,'<%=j%>','<%=rowData.get("TARGET_PRICE")%>','<%=rowData.get("CART_QTY")%>');"></div>
                </td>
 
                    <td align="right">
                        <div title="구매액"><input type="text" name="st_sum_price" size="10" style="text-align:right;"  value="<%=CommonUtil.formatNumber(rowData.get("TOT_SUM"),true,0,3)%>"  class="input_type_text" READONLY></div>
                    </td>
     
                    <td align="center">
                        <div title="첨부파일">
                <%
                         if(!rowData.get("IMAGE_KEY").equals("")) {
                        	 if(rowData.get("MG_CODE").equals("A")) {
                %>
	                            <span class="btn_quickbuy mb02"  title="파일추가"><a href="javascript:attach_popup('<%=rowData.get("IMAGE_KEY")%>', '<%=j%>','A');">파일추가</a></span>
                <%
                        	}else{
                %>
	                            <span class="btn_quickbuy mb02"  title="파일추가"><a href="javascript:attach_popup('<%=rowData.get("IMAGE_KEY")%>', '<%=j%>','B');">파일추가</a></span>
                <%
                        	}
                %>
                <%
                       }else {
                    	   if(rowData.get("MG_CODE").equals("A")) {
                %>
                             <span class="btn_wishproduct mb02"  title="파일추가"><a href="javascript:gridPopOpen('<%=j%>','A');"> 파일추가</a></span>
                <%
                    	   }else{
                %>
                			<span class="btn_wishproduct mb02"  title="파일추가"><a href="javascript:gridPopOpen('<%=j%>','B');"> 파일추가</a></span>
                <%
                    	   }
                       }
                %>
                        </div> 
                <%      //명함 양식다운로드
                         if(rowData.get("MG_CODE").equals("A")) {                %>
                            <div title="명함양식">
                             <span class="btn_quickbuy mb02"  title="명함양식"><a href="/resources/excel/coway_exceldown01.xls">명함양식</a></span>
                            </div>
                <%      //사원증 다운로드
                         }else if (rowData.get("MG_CODE").equals("B")) {
                %>
                            <div title="사원증양식">
                                <span class="btn_quickbuy mb02"  title="사원증양식"><a href="/resources/excel/coway_exceldown02.xls">사원증양식</a></span>
                            </div>
                <%      //사원증 다운로드(코디/닥터)
                         }else if (rowData.get("MG_CODE").equals("C")) {
                %>
                            <div title="사원증양식(코디/코닥)">
                                <span class="btn_quickbuy mb02"  title="사원증양식(코디/코닥)"><a href="/resources/excel/coway_exceldown03.xls">코디/코닥</a></span>
                            </div>
                <%      //양식다운(기타양식다운로드)
                         //}else if (rowData.get("MG_CODE").equals("D")) {
                %>
                <!--
                            <div title="첨부파일">
                                <a href="/kr/coway_buyer/guide_down/coway_exceldown04.xls"><img src="/kr/coway_buyer/images_new/but_coway_down.gif" alt="양식다운로드"></a>
                            </div>
                 -->
                <%      //명함 양식다운로드(닥터)
                         }else if(rowData.get("MG_CODE").equals("E")) {                %>
                            <div title="닥터명함양식">
                              <span class="btn_quickbuy mb02"  title="닥터명함양식"><a href="/resources/excel/coway_exceldown05.xls">닥터명함양식</a></span>
                            </div>
                <%      //CS닥터명함양식
                         }else if(rowData.get("MG_CODE").equals("F")) {                %>
                            <div title="CS닥터명함양식">
                              <span class="btn_quickbuy mb02"  title="닥터명함양식"><a href="/resources/excel/coway_exceldown06.xls">명함양식</a></span>
                            </div>
                <%      //명함양식
                         }else if(rowData.get("MG_CODE").equals("G")) {                %>
                            <div title="표준 명함양식">
                              <span class="btn_quickbuy mb02"  title="표준 명함양식"><a href="/resources/excel/coway_exceldown07.xlsx">명함양식</a></span>
                            </div>
                <%      //명함양식
                         }else if(rowData.get("MG_CODE").equals("H")) {                %>
                            <div title="기타 이력사항 추가명함 표준양식">
                              <span class="btn_quickbuy mb02"  title="기타 이력사항 추가명함 표준양식"><a href="/resources/excel/coway_exceldown08.xlsx">명함양식</a></span>
                            </div>
                <%      //명함양식
                         }else if(rowData.get("MG_CODE").equals("I")) {                %>
                            <div title="기타 이력사항 추가명함 표준양식">
                              <span class="btn_quickbuy mb02"  title="기타 이력사항 추가명함 표준양식"><a href="/resources/excel/coway_exceldown09.xlsx">명함양식</a></span>
                            </div>                            
                <%		//명함양식
                         }else if(rowData.get("MG_CODE").equals("J")) {                %>
                         	<div title="영문명 추가명함 표준양식">
                              <span class="btn_quickbuy mb02"  title="영문명 추가명함 표준양식"><a href="/resources/excel/coway_exceldown10.xlsx">명함양식</a></span>
                            </div>
                <%		//명함양식
                         }else if(rowData.get("MG_CODE").equals("K")) {                %>
                         	<div title="서비스매니저 명함 양식">
                              <span class="btn_quickbuy mb02"  title="서비스매니저 명함 양식"><a href="/resources/excel/coway_exceldown11.xlsx">명함양식</a></span>
                            </div>
                <%		//명함양식
                         }else if(rowData.get("MG_CODE").equals("L")) {                %>
                      		<div title="서비스매니저 명함 양식2">
                        	  <span class="btn_quickbuy mb02"  title="서비스매니저 명함 양식2"><a href="/resources/excel/coway_exceldown12.xlsx">명함양식</a></span>
                      		</div>
                <%		//사원증양식
                         }else if(rowData.get("MG_CODE").equals("M")) {                %>
                         	<div title="정직원사원증 신청양식">
                        	  <span class="btn_quickbuy mb02"  title="정직원사원증 신청양식"><a href="/resources/excel/coway_exceldown13.xls">사원증양식</a></span>
                      		</div>
                <%		// 대리점 사원증 신청양식
                         }else if(rowData.get("MG_CODE").equals("N")) {                %>
                         	<div title="대리점 사원증 신청양식">
                        	  <span class="btn_quickbuy mb02"  title="정직원사원증 신청양식"><a href="/resources/excel/coway_exceldown14.xls">사원증양식</a></span>
                      		</div>
                <%
                         }
                %>
                    </td> 
                     <%if (userRole2.equals("+")) { %>
                    <td><span class="btn_quickbuy mb02"  title="바로주문"><a href="javascript:item_qty_updateSel('<%=j%>')">바로주문</a></span>
                	<br><span class="btn_wishproduct"  title="나의상품"><a href="javascript:setMyCatalogRegSel('<%=j%>')">나의상품</a></span></td> 
                <%} %>
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
			<span class="cl">[ 총 <%=total_cnt %> 건 ]</span> 
		</p>  
        <%
		request.getSession().setAttribute("session_CART_CNT", total_cnt);
		%> 
		<script>	$('#top_cart_cnt').html("<%=total_cnt%>");</script>
		<!-- 버튼영역 -->
		<div class="btnArea">
        	<div class="fl" title="출력" >
				
			<% 
			 //SLOGIC-BEGIN(P06-0000027)
			 //SLOGIC-BEGIN(P06-0000034)
			 //SLOGIC-BEGIN(P06-0000035)
			if(!(p060000034 == true)){  %>
				
				<% if (!"NONE".equals(reportText)) {  
				%>
		  		<span class="btn_04 mr04"  title="<%=reportText%>"><a href="javascript:<%=reportFunction%>"><%=reportText%></a></span>  
		  		<%} %>		   
		  		
		  		
            <%  }  %>    
			<%  if(budget_flag.equals("Y")){  %>
                 <span class="btn_03 mr04"  title="예산조회" ><a href="javascript:doAction('getCowayBudgetList');">예산조회</a></span> 
            <%  }    %>
            
            
 </div> 
<div class="fr">    
            <span class="btn_03 mr04"  title="저장" ><a href="javascript:doAction('SAVE');">저장</a></span>
            <span class="btn_03 mr04"  title="나의상품등록" ><a href="javascript:doAction('setMyCatalogReg');">나의상품등록</a></span>
            <span class="btn_03 mr04"  title="삭제" ><a href="javascript:doAction('setCartDelete');">삭제</a></span>
            <span class="btn_03 mr04"  title="상품검색" ><a href="/mdcm/showBuyerMdCmCategoryGoodsSearch.do?upperId=b00100000000">상품검색</a></span>

            <%  
                if(userRole2.equals("+")) {                
                    if(st_query_cart.equals("ALL")){    
            %>
                   <span class="btn_order mr04"  title="바로주문" ><a href="javascript:doAction('CART_SANGJO');">바로주문</a></span>
            <%      }else{                              %>
                   <span class="btn_order mr04"  title="바로주문" ><a href="javascript:doAction('ORDER_SANGJO');">바로주문</a></span>
            <%      }
                }
            %>
 
 
 </div>
             
        </div>
</form>

<form name="processForm" id="processForm" method="post">	
	<input type="hidden" name="st_use_flag" id="st_use_flag" value="" />
	<input type="hidden" name="st_move_flag" id="st_move_flag"  value=""/>
	<input type="hidden" name="st_query2" id="st_query2"  value=""/> 
	<input type="hidden" name="next_status" id="next_status"  value=""/> 
	<input type="hidden" name="st_item_chk" id="st_item_chk"  value=""/> 
	<input type="hidden" name="st_update" id="st_update"  value=""/> 	
	<input type="hidden" name="st_buyer" id="st_buyer"  value=""/> 
	<input type="hidden" name="st_user_id" id="st_user_id"  value=""/> 	
	<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    
</form>


<form name="locationForm" id="locationForm" method="post">	 
	<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
	<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}"> 	
	<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
	<input type="hidden" name="st_buyer_item_no" id="st_buyer_item_no" value="">
	<input type="hidden" name="st_description" id="st_description" value="">
	<input type="hidden" name="st_specification" id="st_specification" value="">
	<input type="hidden" name="st_maker_name" id="st_maker_name" value="">			 
	<input type="hidden" name="st_verif_num" id="st_verif_num" value="<%=st_verif_num %>" /> 	
	<input type="hidden" name="st_zip_code"       value="<%=st_zip_code%>">
	<input type="hidden" name="st_tel_no"         value="<%=st_tel_no%>">
	<input type="hidden" name="st_fax_no"         value="<%=st_fax_no%>">
	<input type="hidden" name="st_mobile_no"      value="<%=st_mobile_no%>">
	<input type="hidden" name="st_user_name"      value="<%=st_user_name%>">
	<input type="hidden" name="st_email"          value="<%=st_email%>">
	<input type="hidden" name="st_user_id"        value="<%=st_user_id%>">
	<input type="hidden" name="st_query_cart"     value="<%=st_query_cart%>">
	<input type="hidden" name="st_recv_date"      value="<%=st_recv_date%>">
	<input type="hidden" name="st_recv_date2"     value="<%=st_recv_date2%>">
	<input type="hidden" name="st_remark"         value="<%=st_remark%>">
	<input type="hidden" name="st_location_code"  value="<%=st_location_code%>">
	<input type="hidden" name="st_location_type"  value="<%=st_location_type%>">
	<input type="hidden" name="st_location_name"  value="<%=st_location_name%>">
	<input type="hidden" name="st_purchase_dept_name"  value="<%=st_purchase_dept_name%>">
	<input type="hidden" name="st_purchase_dept_code"  value="<%=st_purchase_dept_code%>">	 
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

// 최초 화면 함수 
function kep_onload_view(){
 
}
 
//기능함수
var str = "";
function doAction(str) {

	switch (str) { 
	
		case "PrSheet":  
			item_qty_update('PrSheet');
			break;  
	
		case "PrSheetView":  
			PrSheetView();
			break;  
			
		case "PrSheetViewSiem":  
			PrSheetViewSiem();
			break;  
	
		case "getCowayBudgetList":   //예산조회
			getCowayBudgetList();
			break;  
			
		case "SAVE":   //저장
			item_qty_update('SAVE');
			break;  
			
		case "setMyCatalogReg":   //나의상품등록
			setMyCatalogReg();
			break;  
		
		case "setCartDelete":   //삭제
			setCartDelete();
			break;  
	
		case "CART_SANGJO":   //바로주문
			item_check('CART_SANGJO');
			break;  
			
		case "ORDER_SANGJO":   //바로주문
			item_check('ORDER_SANGJO');
			break;  
			 
		}
}


function item_qty_updateSel(row){
	lnCheckFalse(); // 전체 선택박스 해제
    var box = eval("document.forms.contentForm.lnCheck" + row);
    box.checked =true;    
<%  
if(userRole2.equals("+")) {
 if(st_query_cart.equals("ALL")){
%>
	doAction('CART_SANGJO');
	<%      }else{          %>
	doAction('ORDER_SANGJO');
<%      }
}
%>  
}
 
	   
function setMyCatalogRegSel(row){	
	lnCheckFalse(); // 전체 선택박스 해제
    var box = eval("document.forms.contentForm.lnCheck" + row);
    box.checked =true;    
    doAction('setMyCatalogReg'); 
}


function lnCheckFalse(){
	
	var tot_cnt  =$("#display_item_cnt").val();
    if(eval(tot_cnt) < 2)     { 
        var box = eval("document.forms.contentForm.lnCheck0");
        box.checked = false;
      } else{
        for(var x=0; x<eval(tot_cnt); x++) {
            var box = eval("document.forms.contentForm.lnCheck" + x);
            box.checked = false;
        } 
      }
}

// 조회
function kepSearch(curPage){
	
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mpso/getBuyerMpSoCartCowayList.do").submit();   
}

//이미지 보이기 숨기기
function imageHideView(){ 
	
    var image_status   = $("#st_image_status").val();
    if(image_status == "IMAGE_HIDDEN"){
        image_status = "IMAGE_VIEW"; 
    }else if(image_status == "IMAGE_VIEW"){
        image_status = "IMAGE_HIDDEN"; 
    }
    $("#st_image_status").val(image_status);
	 // 처리후 재조회
	 kepSearch($("#curPage").val());
}
   

function attach_popup(img_key, obj1, obj2){
	var type = "PR";
	var viewType = "C";	
	gridIndex = obj1;
	popupSel = "attach";
	if(obj2 =="A"){
		alert("※파일 첨부 업로드 하기전\nDRM 해제를 하였는지 확인 바랍니다.\n(DRM 미해제시 파일 내용 확인불가)");
	}
	kepFileUploadOpenPopup(img_key,type,viewType); 
}

/**
 * 첨부파일 구현
 */
function gridPopOpen(obj1, obj2){ 
 gridIndex = obj1;
 popupSel = "attach";
 attach_popup($("input[name=st_image_key]").eq(gridIndex).val(), gridIndex, obj2);
}
  
function setPopupReturn(value1){
	var tot_cnt  =  $("#display_item_cnt").val();
	if (popupSel == "attach"){
   		//$("input[name=st_image_key]").eq(gridIndex).val(value1);
   		if(eval(tot_cnt) < 2){    	
	    	document.forms.contentForm.st_image_key.value = value1;
	    }else{
	    	document.forms.contentForm.st_image_key[gridIndex].value = value1;
	    }
   		saveAttach(gridIndex);
	}
}   

//파일정보 저장
 function saveAttach(g_row){
	
	//alert("g_row " +g_row);
	
    var st_cstmr_id             = "<%=buyer%>"                                  // 고객사
    var st_user_id              = "<%=userId%>"                                 // 고객사 
    var query                   = "";
    var tot_cnt     =  $("#display_item_cnt").val();
    var st_item_no       = "";
    var st_contract_no   = "";
    var st_contract_seq  = "";
    var st_cart_seq = "";
    
    if(tot_cnt<=1) {
        st_item_no = document.forms.contentForm.st_item_no.value;
        st_contract_no = document.forms.contentForm.st_contract_no.value;
        st_contract_seq = document.forms.contentForm.st_contract_seq.value;
        image_key = document.forms.contentForm.st_image_key.value;
        st_cart_seq = document.contentForm.st_cart_seq.value;
    }else {
        st_item_no = document.forms.contentForm.st_item_no[g_row].value;
        st_contract_no = document.forms.contentForm.st_contract_no[g_row].value;
        st_contract_seq = document.forms.contentForm.st_contract_seq[g_row].value;
        image_key = document.forms.contentForm.st_image_key[g_row].value;
        st_cart_seq = document.contentForm.st_cart_seq[g_row].value;
    }
    if(isEmpty(TrimCommon(image_key))) image_key="";
    query +=  image_key             + "@@";
    query +=  st_cstmr_id               + "@@";
    query +=  st_user_id                + "@@";
    query +=  st_contract_no                + "@@";
    query +=  st_contract_seq               + "@@";
    query +=  st_item_no                + "@@";
    query +=  st_cart_seq                + "@@";
    document.forms.processForm.st_query2.value = query;    
    kepAjaxFormCall("/mpso/getBuyerShoppingcartListAttachUpdate.do","processForm","FILE");  
    
 }

//상품 큰이미지
function getBigImage(file_dir, file_name){
	getBigImageView("<%= CommonUtil.getURL(request) %><%=CommonUtil.realImgS3UploadPath%>", file_dir, file_name);
}

//예산부서 팝업 조회 PG_06_B_010_01 비용부서조회
function getDeptAccountPop(buyer,row)
{
    var tot_cnt  =  $("#display_item_cnt").val();
    
    
    var st_byit_bdgt_flag = "";
    if(eval(tot_cnt) < 2){
        st_byit_bdgt_flag = document.forms.contentForm.st_byit_bdgt_flag.value;
        var box = eval("document.forms.contentForm.lnCheck0");
            box.checked =true;
    }else{
        st_byit_bdgt_flag = document.forms.contentForm.st_byit_bdgt_flag[row].value; 
        var box = eval("document.forms.contentForm.lnCheck" + row);
            box.checked =true;
    } 
    
    if(st_byit_bdgt_flag == "Y"){ 
        var cnt = getCheckedRowCount(tot_cnt);        
        
        openSearchPopup("/mpso/showBuyerUserCowayBudgetOrderListPop.do","?open=Y&userId=<%=userId%>", "600,500,no"); 
 
        //var cart_sum_price = document.forms.contentForm.st_check_sum_price.value;
        //var val = "/kr/coway_buyer/admin/buyer_user_coway_budget_order_list_pop_up.jsp?userId=<%=userId%>";
        // var url = addr+val;
        //window.open(url, 'AccountListWin2', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
         
        return;
    }else{
        alert("예산통제 품목이 아닙니다.");
        return;
    }
}

//예산부서설정
function setDeptAccount(dept_code , dept_name){
    var tot_cnt  =  $("#display_item_cnt").val();
    if(eval(tot_cnt) < 2){
        document.forms.contentForm.st_budget_dept_name.value     = dept_name;
        document.forms.contentForm.st_budget_dept.value      = dept_code;
        document.forms.contentForm.st_account_type_name.value    = "선택";
        document.forms.contentForm.st_account_type.value = "";
    }else{

        for(var k = 0; k < tot_cnt; k++){
            var box = eval("document.forms.contentForm.lnCheck" + k);
            if(box.checked == true){

                if(document.forms.contentForm.st_byit_bdgt_flag[k].value =="Y"){

                    document.forms.contentForm.st_budget_dept_name[k].value   = dept_name;
                    document.forms.contentForm.st_budget_dept[k].value        = dept_code;
                    document.forms.contentForm.st_account_type_name[k].value    = "선택";
                    document.forms.contentForm.st_account_type[k].value = "";

                }else{

                    document.forms.contentForm.st_budget_dept_name[k].value = "";
                    document.forms.contentForm.st_budget_dept[k].value = "";
                    document.forms.contentForm.st_account_type_name[k].value = "";
                    document.forms.contentForm.st_account_type[k].value = "";

                }
            }
        }
    }
}


//예산계정 선택 팝업 PG_06_B_010_02 계정조회
 function getBdgtAccountPop(com_code,dept_code,row)
 {
     var tot_cnt  =  $("#display_item_cnt").val();
     var dept_cd="";
     var cart_sum_price = "";
     var st_byit_bdgt_flag = "";

     if(eval(tot_cnt) < 2){
         dept_cd = document.forms.contentForm.st_budget_dept.value;
         cart_sum_price = eval(filterNum(document.forms.contentForm.st_sum_price.value));
         st_byit_bdgt_flag = document.forms.contentForm.st_byit_bdgt_flag.value;

         var box = eval("document.forms.contentForm.lnCheck0");
             box.checked =true;

     }else{
         dept_cd = document.forms.contentForm.st_budget_dept[row].value;
         cart_sum_price = eval(filterNum(document.forms.contentForm.st_sum_price[row].value));
         st_byit_bdgt_flag = document.forms.contentForm.st_byit_bdgt_flag[row].value;
 
         var box = eval("document.forms.contentForm.lnCheck" + row);
             box.checked =true;

         var initBudgetDept = "";
         var cnt = 0;
         for(var k = 0; k < tot_cnt; k++){
             var box = eval("document.forms.contentForm.lnCheck" + k);

             if(box.checked == true){
                 if(document.forms.contentForm.st_byit_bdgt_flag[k].value !="Y"){
                     document.forms.contentForm.st_budget_dept_name[k].value = "";
                     document.forms.contentForm.st_budget_dept[k].value = "";
                     document.forms.contentForm.st_account_type_name[k].value = "";
                     document.forms.contentForm.st_account_type[k].value = "";
                 }
                 if(cnt < 1){
                 initBudgetDept = document.forms.contentForm.st_budget_dept[k].value;
                 cnt++;
                 }else{
                     if( initBudgetDept != document.forms.contentForm.st_budget_dept[k].value ){
                         alert("서로 다른 예산부서가 선택되었거나\n 예산비통제 품목이 선택 되었습니다.");
                         return;
                     }
                 }
             }
         }
     }
           
     //COWAY 예산 사용경우st_byit_bdgt_flag == "Y"
     if(st_byit_bdgt_flag == "Y"){ 
         if(dept_cd.length == 0){
             alert("예산부서를 선택하여 주세요.");
             return;
         }
         var cnt = getCheckedRowCount(tot_cnt);
         
         cart_sum_price = document.forms.searchForm.st_check_sum_price.value;
         openSearchPopup("/mpso/showBuyerUserCowayBudgetAccountListPop.do","?open=Y&st_buyer="+ com_code+"&st_userDept="+dept_cd+"&st_cart_sum_price="+cart_sum_price , "1000,510,no"); 
         
         /*
         cart_sum_price = document.forms.contentForm.st_check_sum_price.value;

         var val = "/kr/coway_buyer/admin/buyer_user_coway_budget_account_list_pop_up.jsp?com_code="+ com_code+"&dept_code="+dept_cd+"&st_cart_sum_price="+cart_sum_price;
         var url = addr+val;
         window.open(url, 'AccountListWin', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
         */
         return;
     }else{
         alert("예산통제 품목이 아닙니다.");
     }
 }
 
//예산계정 설정
 function setBdgtAccount(account_type , account_name){
     var tot_cnt  =$("#display_item_cnt").val();
     if(eval(tot_cnt) < 2){
         document.forms.contentForm.st_account_type_name.value    = account_name;
         document.forms.contentForm.st_account_type.value = account_type;

     }else{

         for(var k = 0; k <  tot_cnt; k++){
             var box = eval("document.forms.contentForm.lnCheck" + k);
             if(box.checked == true){
                 if(document.forms.contentForm.st_byit_bdgt_flag[k].value =="Y"){
                     document.forms.contentForm.st_account_type_name[k].value   = account_name;
                     document.forms.contentForm.st_account_type[k].value        = account_type;
                 }else{
                     document.forms.contentForm.st_account_type_name[k].value   = "";
                     document.forms.contentForm.st_account_type[k].value        = "";
                 }
             }
         }

     }
 }
 
 
//코웨이예산내역 조회 PG_06_B_010_03 부서예산조회
 function getCowayBudgetList(){
 
     var buyer       =   $("#st_buyer").val(); 
     var dept_code   = "<%=userDept%>";
     var account_type    ="ALL";
     var term_type       ="ALL";
     var select_year     ="<%=select_year%>"; 
     openSearchPopup("/mpso/showBuyerCowayUserBudgetAccountListPop.do","?open=Y&st_buyer="+buyer+"&st_dept_code="+dept_code+"&st_account_type="+account_type+"&st_term_type="+term_type+"&st_from_year="+select_year , "800,500,no"); 
     
     //window.open('/kr/coway_buyer/admin/buyer_coway_user_budget_account_list_pop_up.jsp?st_buyer='+buyer+'&st_dept_code='+dept_code+'&st_account_type='+account_type+'&st_term_type='+term_type+'&st_select_year='+select_year, 'BudgetWindow', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
 }
 
 
 function price_update(cart_qty, y_num, buy_price,orgin_cart_qty){

	    var tot_cnt  = $("#display_item_cnt").val();
	 

	    if(eval(tot_cnt) < 2){

	         if(cart_qty == "null" || cart_qty == "" || cart_qty == null){
	         }else{
	             var sum_price = kepGetRound((cart_qty * buy_price),3);
	             document.forms.contentForm.st_sum_price.value = kepCommaNum(sum_price);
	         }

	    }else{

	         if(cart_qty == "null" || cart_qty == "" || cart_qty == null){
	         }else{
	             var sum_price = kepGetRound((cart_qty * buy_price),3);
	             document.forms.contentForm.st_sum_price[y_num].value = kepCommaNum(sum_price);
	         }
	    }
	    chk_sum_price(); // 선택 품목 총 합계금액
	}

	function price_update_P(y_num, buy_price,orgin_cart_qty){

	    var tot_cnt  = $("#display_item_cnt").val();
	 

	    if(eval(tot_cnt) < 2){
	         var cart_qty = document.forms.contentForm.st_order_qty.value;
	         if(cart_qty == "null" || cart_qty == "" || cart_qty == null){
	         }else{
	             var sum_price = kepGetRound((cart_qty * buy_price),3);
	             document.forms.contentForm.st_sum_price.value = kepCommaNum(sum_price);
	         }

	    }else{
	         var cart_qty = document.forms.contentForm.st_order_qty[y_num].value;
	         if(cart_qty == "null" || cart_qty == "" || cart_qty == null){
	         }else{
	             var sum_price = kepGetRound((cart_qty * buy_price),3);
	             document.forms.contentForm.st_sum_price[y_num].value = kepCommaNum(sum_price);
	         }
	    }
	    chk_sum_price(); // 선택 품목 총 합계금액
	}

	//선택 품목 총 합계금액
	function chk_sum_price(){

	    var maxRow = $("#display_item_cnt").val();
	    var sum_price = 0;

	    if(eval(maxRow) < 2){
	    	var box = eval("document.forms.contentForm.lnCheck0");
	        if(box.checked == true){
	            sum_price = eval(sum_price) + eval(kepFilterNum(document.forms.contentForm.st_sum_price.value));
	        }
	    }else{
		    for(var j = 0; j < maxRow; j++){
		         var box = eval("document.forms.contentForm.lnCheck" + j);
	            if(box.checked == true){
	                sum_price = eval(sum_price) + eval(kepFilterNum(document.forms.contentForm.st_sum_price[j].value));
	            }
	        }
	    }
	    
	    document.forms.searchForm.check_sum_price.value     = kepCommaNum(sum_price) + " 원";
	    document.forms.searchForm.st_check_sum_price.value  = sum_price;
	    
	}
	
	
	

	function item_qty_update(next_status){  // CART : 배송지 입력화면 이동,   ORDER : 주문최종 확인 화면 이동 
		 
	    var tot_cnt  =  $("#display_item_cnt").val();
	    var chk_cnt  = 0;
	    var query    = "";
	    var next_status = next_status;
	    var buyer = $("#st_buyer").val(); 
	    var ck_ref_pr_no ="";
	    var ck_ref_pr_dept ="";
	    var budget_flag = "<%=budget_flag%>";
	    var hongik_flag = "N";
	    if(eval(tot_cnt) == 0)
	    {
	        alert("조회한 데이타가 없습니다.");
	        return;
	    }
	    chk_cnt = getCheckedRowCount(tot_cnt);
	    if(chk_cnt == "0"){
	        alert("하나 이상의 상품이 선택되어야 합니다.   ");
	        return;
	    }
	    if(eval(tot_cnt) < 2){
	        var box = eval("document.forms.contentForm.lnCheck0" );
	        var st_item_no              = document.forms.contentForm.st_item_no.value;
	        var st_order_qty            = TrimCommon(document.forms.contentForm.st_order_qty.value);
	        var st_ref_pr_no            = document.forms.contentForm.st_ref_pr_no.value;
	        var st_contract_no          = document.forms.contentForm.st_contract_no.value;
	        var st_contract_seq         = document.forms.contentForm.st_contract_seq.value;
	        var st_fixed_price_flag     = document.forms.contentForm.st_fixed_price_flag.value;
	        var st_order_price          = document.forms.contentForm.st_order_price.value;
	        var st_account_type         = document.forms.contentForm.st_account_type.value;
	        var st_budget_dept          = document.forms.contentForm.st_budget_dept.value;
	        var product_close_flag      = document.forms.contentForm.st_product_close_flag.value;
	        var process_type                = document.forms.contentForm.st_process_type.value;
	        var stock_item_flag         = document.forms.contentForm.st_stock_item_flag.value;
	        var ref_pr_dept         = document.forms.contentForm.st_ref_pr_dept.value;
	        var image_key           = document.forms.contentForm.st_image_key.value;
	        var format_type         = document.forms.contentForm.st_format_type.value;
	        //코웨이 예산체크 플래그
	        var st_byit_bdgt_flag  = document.forms.contentForm.st_byit_bdgt_flag.value;
	        var remark                  = "NO_REMARK";
	        var item_status_flag      = document.forms.contentForm.st_item_status_flag.value;
	        
 	        var st_cart_seq = document.contentForm.st_cart_seq.value;
	        if(box.checked == true){
	            if(product_close_flag == "Y"){
	                alert("해당 품목은 단종되었습니다.");
	                box.checked = false;
	                return;
	            }
	            if(item_status_flag == "삭제"){
	                alert("해당 품목은 삭제되었습니다.");
	                box.checked = false;
	                return;
	            }
	            if(process_type=="1" && stock_item_flag=="N"){
	                alert("해당 품목은 재고품목 입니다.\n\n품목상태가 올바르지 않습니다.\n\n담당자에게 확인 바랍니다.");
	                box.checked = false;
	                return;
	            }
	            if(st_order_qty == "" || st_order_qty == "null" || st_order_qty == null || st_order_qty == "0" || isEmpty(st_order_qty) || !chkDecimal(st_order_qty,3)){
	                alert("품목의 발주수량(숫자)을 입력하여 주십시요.");
	                document.forms.contentForm.st_order_qty.focus();
	                return;
	            }
	            //양식타입이 있을경우 파일 첨부는 반드시 있어야 할것.
	            if(format_type == "A" || format_type== "B" || format_type == "C" || format_type== "E"|| format_type== "F"){
	                if(image_key == "" || image_key == "null" || image_key == null || image_key == " "){
	                    alert("해당품목의 양식을 첨부하여 주십시요.");
	                    return;
	                }
	            }
	            if(buyer == "KRDONG0121" || buyer == "KRDUPO0001" || buyer == "KRKEPB0006" || buyer == "KRFAGB0001"
	                || buyer == "KRFAGB0002" || buyer == "KRFAGB0003" || buyer == "KRSCHA0001" || buyer == "KRKDBO0003"
	                || buyer == "KRKDPR0003" || buyer == "KRDOOS0013"|| buyer == "KRKOLO0018"|| buyer == "KRCONT0006" || buyer=="KRCONT0009"
	                || buyer == "KRJINR0005" || buyer == "KRCONT0007")
	            {
	                if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
	                    alert("관리번호(계정)가 선택되지 않았습니다.\n"+"관리번호란을 클릭하여 계정을 선택하여 주십시요.");
	                    return;
	                }
	            }else if(buyer=="KRHONG0020") {
	                if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
	                    alert("회계번호가 선택되지 않았습니다.\n"+"회계번호란을 클릭하여 선택하여 주십시요.");
	                    return;
	                }
	                if(hongik_flag == "Y"&&(ref_pr_dept == "" || ref_pr_dept == "null" || ref_pr_dept == null || ref_pr_dept == " ")){
	                    alert("대학원 학과가 선택되지 않았습니다.\n\n대학원 학과란을 클릭하여 선택하여 주십시요.");
	                    return;
	                }
	/*
	            }else if(buyer=="KRKEPB0004") {
	                if( ref_pr_dept == "" || ref_pr_dept == "null" || ref_pr_dept == null || ref_pr_dept == " ") {
	                    alert("요청부서가 선택되지 않았습니다.\n\n요청부서를 선택하여 주십시요.");
	                    return;
	                }
	*/
	            }else if(buyer=="KRGEST0001" && (next_status == "CART" || next_status == "ORDER")) {
	                var ref_pr_text             = document.forms.contentForm.st_ref_pr_text.value;
	                var ref_pr_text2            = document.forms.contentForm.st_ref_pr_text2.value;
	                if(ref_pr_text == "" || ref_pr_text == "null" || ref_pr_text == null || ref_pr_text == " "){
	                    alert("관리번호가 선택되지 않았습니다.\n"+"관리번호란을 클릭하여 선택하여 주십시요.");
	                    return;
	                }
	                if(ref_pr_text2 == "" || ref_pr_text2 == "null" || ref_pr_text2 == null || ref_pr_text2 == " "){
	                    alert("계정항목이 선택되지 않았습니다.\n\n계정항목란을 클릭하여 선택하여 주십시요.");
	                    return;
	                }
	            }else if(buyer=="KRSIEM0004" && (next_status == "CART" || next_status == "ORDER")) {
	                if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
	                    alert("관리번호가 입력되지 않았습니다.\n"+"관리번호를 입력하여 주십시요.");
	                    return;
	                }
	            }else if(buyer=="KRHYOS0026" && (next_status == "CART" || next_status == "ORDER")) {
	                if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
	                    alert("구체적인 사용용도와 실 사용자를 관리번호란에 입력 하셔야 합니다.");
	                    return;
	                }
	            }else {
	                if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null){
	                    st_ref_pr_no = " ";
	                }
	            }
	            if(budget_flag == "Y" && (next_status == "CART" || next_status =="ORDER")){
	                if(isEmpty(st_account_type) || isEmpty(st_budget_dept)){
	                    if(st_byit_bdgt_flag == "Y"){
	                        alert("예산 적용 부서 및 계정을 선택해 주십시요");
	                        return;
	                    }
	                }
	            }

	            if(st_byit_bdgt_flag == "N"){
	                document.forms.contentForm.st_budget_dept.value = "";
	                document.forms.contentForm.st_account_type.value = "";
	                st_budget_dept = "";
	                st_account_type = "";
	            }
	          //query += st_item_no + "@@" + st_order_qty + "@@" + st_ref_pr_no + "@@"+ st_contract_no + "@@" + st_contract_seq + "@@" + st_fixed_price_flag + "@@" + st_order_price + "@@" + st_account_type + "@@" + st_budget_dept + "@@";
 	            query += st_item_no + "@@" + st_order_qty + "@@" + st_ref_pr_no + "@@"+ st_contract_no + "@@" + st_contract_seq + "@@" + st_fixed_price_flag + "@@" + st_order_price + "@@" + st_account_type + "@@" + st_budget_dept + "@@"+remark+ "@@"+ref_pr_dept+ "@@"+""+ "@@"+""+ "@@"+st_cart_seq;
//	            query += st_item_no + "@@" + st_order_qty + "@@" + st_ref_pr_no + "@@"+ st_contract_no + "@@" + st_contract_seq + "@@" + st_fixed_price_flag + "@@" + st_order_price + "@@" + st_account_type + "@@" + st_budget_dept + "@@"+remark+ "@@"+ref_pr_dept+ "@@"+""+ "@@"+"";
	            query +=  "|";
	         }
	    }else{
	        var cNum = 0;
	        var old_st_agent_code="";
	        var diff_agent_status="false";
	        var old_st_budget_flag="";
	        var diff_budget_flag_status="false";
	        for(var j = 0; j < tot_cnt; j++){
	            var box = eval("document.forms.contentForm.lnCheck" + j);
	            var st_item_no          = document.forms.contentForm.st_item_no[j].value;
	            var st_order_qty        = TrimCommon(document.forms.contentForm.st_order_qty[j].value);
	            var st_ref_pr_no        = document.forms.contentForm.st_ref_pr_no[j].value;
	            var st_contract_no      = document.forms.contentForm.st_contract_no[j].value;
	            var st_contract_seq     = document.forms.contentForm.st_contract_seq[j].value;
	            var st_fixed_price_flag = document.forms.contentForm.st_fixed_price_flag[j].value;
	            var st_order_price      = document.forms.contentForm.st_order_price[j].value;
	            var st_account_type     = document.forms.contentForm.st_account_type[j].value;
	            var st_budget_dept      = document.forms.contentForm.st_budget_dept[j].value;
	            var product_close_flag  = document.forms.contentForm.st_product_close_flag[j].value;
	            var process_type            = document.forms.contentForm.st_process_type[j].value;
	            var stock_item_flag         = document.forms.contentForm.st_stock_item_flag[j].value;
	            var ref_pr_dept         = document.forms.contentForm.st_ref_pr_dept[j].value;
	            var remark                  = "NO_REMARK";
	            var st_agent_code = document.forms.contentForm.st_agent_code[j].value;
	            var image_key           = document.forms.contentForm.st_image_key[j].value;
	            var format_type         = document.forms.contentForm.st_format_type[j].value;
	            var st_category_no         = document.forms.contentForm.st_category_no[j].value;
	            var st_cate_appr         = document.forms.contentForm.st_cate_appr[j].value;
	            //코웨이 예산체크 플래그
	            var st_byit_bdgt_flag  = document.forms.contentForm.st_byit_bdgt_flag[j].value;
	            var item_status_flag      = document.forms.contentForm.st_item_status_flag[j].value;
 	            var st_cart_seq = document.contentForm.st_cart_seq[j].value;
	            if(box.checked == true){
	                cNum++;
	                if(cNum ==1 ){
	                    ck_ref_pr_dept = ref_pr_dept;
	                }
	                if(old_st_agent_code != '' && old_st_agent_code != st_agent_code){
	                    diff_agent_status = "true";
	                }
	                if("<%=SessionComCode%>" == 'KRKOLO0041'){
	                    if(next_status == 'CART' || next_status == 'ORDER'){
	                        if(diff_agent_status == 'true'){
	                            alert("☞코오롱생명과학(주) 요청으로, \n 공급업체가 여러개일 경우 \n 발주 진행을 할 수 없습니다.");
	                            return;
	                        }
	                    }
	                }
	                old_st_agent_code=st_agent_code;
	                if(product_close_flag == "Y"){
	                   alert((j+1)+"번째 품목은 단종되었습니다.");
	                   box.checked = false;
	                   return;
	                }
	                if(item_status_flag == "삭제"){
	                	 alert((j+1)+"번째 품목은 삭제되었습니다.");
	                    box.checked = false;
	                    return;
	                }
	                if(process_type=="1" && stock_item_flag=="N"){
	                alert("해당 품목은 재고품목 입니다.\n\n품목상태가 올바르지 않습니다.\n\n담당자에게 확인 바랍니다.");
	                    box.checked = false;
	                    return;
	                }
	                //양식타입이 있을경우 파일 첨부는 반드시 있어야 할것.
	                if(format_type == "A" || format_type== "B" || format_type == "C" || format_type== "E"|| format_type== "F"){
	                    if(image_key == "" || image_key == "null" || image_key == null || image_key == " "){
	                        alert((j+1)+"번째 품목의 양식을 첨부하여 주십시요.");
	                        return;
	                    }
	                }
	                if(st_order_qty == "" || st_order_qty == "null" || st_order_qty == null || st_order_qty == "0" || isEmpty(st_order_qty) || !chkDecimal(kepRemoveComma(st_order_qty),3)){
	                    alert((j+1)+"번째 품목의 발주수량(숫자)을 입력하여 주십시요.");
	                    document.forms.contentForm.st_order_qty[j].focus();
	                    return;
	                }
	                if(buyer == "KRDONG0121" || buyer == "KRDUPO0001" || buyer == "KRKEPB0006" || buyer == "KRFAGB0001"
	                    || buyer == "KRFAGB0002" || buyer == "KRFAGB0003" || buyer == "KRSCHA0001" || buyer == "KRKDBO0003"
	                    || buyer == "KRKDPR0003" || buyer == "KRDOOS0013"|| buyer == "KRKOLO0018"|| buyer == "KRCONT0006" || buyer=="KRCONT0009"
	                    || buyer == "KRJINR0005" || buyer == "KRCONT0007")
	                {
	                    if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
	                        alert((j+1)+"번째 관리번호(계정)가 선택되지 않았습니다.\n"+"관리번호란을 클릭하여 계정을 선택하여 주십시요.");
	                        return;
	                    }
	                }else if(buyer=="KRHONG0020") {
	                    if(ck_ref_pr_dept != ref_pr_dept){
	                        alert("서로다른 대학원 학과를 입력 하셨습니다.\n\n대학원 학과란을 클릭하여 확인하여 주십시요.");
	                        return;
	                    }
	                    if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
	                        alert("회계번호가 선택되지 않았습니다.\n"+"회계번호란을 클릭하여 선택하여 주십시요.");
	                        return;
	                    }
	                    if(hongik_flag == "Y"&&(ref_pr_dept == "" || ref_pr_dept == "null" || ref_pr_dept == null || ref_pr_dept == " ")){
	                        alert("대학원 학과가 선택되지 않았습니다.\n\n대학원 학과란을 클릭하여 선택하여 주십시요.");
	                        return;
	                    }
	/*
	                }else if(buyer=="KRKEPB0004") {
	                    if( ref_pr_dept == "" || ref_pr_dept == "null" || ref_pr_dept == null || ref_pr_dept == " ") {
	                        alert("요청부서가 선택되지 않았습니다.\n\n요청부서를 선택하여 주십시요.");
	                        return;
	                    }
	*/
	                }else if(buyer=="KRGEST0001" && (next_status == "CART" || next_status == "ORDER")) {
	                    var ref_pr_text             = document.forms.contentForm.st_ref_pr_text[j].value;
	                    var ref_pr_text2            = document.forms.contentForm.st_ref_pr_text2[j].value;
	                    if(ref_pr_text == "" || ref_pr_text == "null" || ref_pr_text == null || ref_pr_text == " "){
	                        alert( (j+1)+"번째 관리번호가 선택되지 않았습니다.\n"+"회계번호란을 클릭하여 선택하여 주십시요.");
	                        return;
	                    }
	                    if(ref_pr_text2 == "" || ref_pr_text2 == "null" || ref_pr_text2 == null || ref_pr_text2 == " "){
	                        alert((j+1)+"번째 계정항목이 선택되지 않았습니다.\n\n대학원 학과란을 클릭하여 선택하여 주십시요.");
	                        return;
	                    }
	                }else if(buyer=="KRSIEM0004" && (next_status == "CART" || next_status == "ORDER")) {
	                    if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
	                        alert( (j+1)+"번째 관리번호가 입력되지 않았습니다.\n"+"관리번호를 입력하여 주십시요.");
	                        return;
	                    }
	                }else if(buyer=="KRHYOS0026" && (next_status == "CART" || next_status == "ORDER")) {
	                    if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
	                        alert((j+1)+"구체적인 사용용도와 실 사용자를 관리번호란에 입력 하셔야 합니다.");
	                        return;
	                    }
	                }else {
	                    if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null){
	                        st_ref_pr_no = " ";
	                    }
	                }
					//카테고리별결재담당자가 정해져 있는 품목은 동일 카테고리끼리만 주문 가능하다.
					if(st_cate_appr > 0){
						var st_tmp_category_no = "";
						var st_tmp_cate_appr = 0;
						for(var k = 0; k < tot_cnt; k++){
							var box2 = eval("document.forms.contentForm.lnCheck" + k);
							if(box2.checked == true){
								st_tmp_category_no = document.forms.contentForm.st_category_no[k].value;
								st_tmp_cate_appr = document.forms.contentForm.st_cate_appr[k].value;
								if((st_tmp_cate_appr == 0) || (st_category_no != st_tmp_category_no)){
									alert("카테고리별 결재 담당자 지정 품목은 동일 카테고리 품목만 주문 가능합니다.");
									return;
								}
							}
						}
					}
	                if(budget_flag == "Y" && (next_status == "CART" || next_status =="ORDER")){
	                    if(isEmpty(st_account_type) || isEmpty(st_budget_dept)){
	                        if(st_byit_bdgt_flag == "Y"){
	                            alert( (j+1) + " 번째 품목의 예산 적용 부서 및 계정을 선택해 주십시요");
	                            return;
	                        }
	                    }
	                }

	                if(st_byit_bdgt_flag == "N"){
	                    document.forms.contentForm.st_budget_dept[j].value = "";
	                    document.forms.contentForm.st_account_type[j].value = "";
	                    st_budget_dept = "";
	                    st_account_type = "";
	                }

	                if(old_st_budget_flag != '' && old_st_budget_flag != st_byit_bdgt_flag){
	                    diff_budget_flag_status = "true";
	                }
	                if("<%=SessionComCode%>" == 'KRCOWA0001' || "<%=SessionComCode%>" == 'KRCOWA0005' || "<%=SessionComCode%>" == 'KRCOWA0006'){
	                    if(next_status == 'CART' || next_status == 'ORDER'){
	                        if(diff_budget_flag_status == 'true'){
	                            alert("☞사전예산통제품목(MRO)은 일반품목과 함께 주문할 수 없습니다.");
	                            return;
	                        }
	                    }
	                }
	                old_st_budget_flag=st_byit_bdgt_flag;
	                st_order_qty = kepRemoveComma(st_order_qty);

	              //query += st_item_no + "@@" + st_order_qty + "@@" + st_ref_pr_no + "@@"+ st_contract_no + "@@" + st_contract_seq + "@@" + st_fixed_price_flag + "@@" + st_order_price + "@@" + st_account_type + "@@" + st_budget_dept + "@@";
 	                query += st_item_no + "@@" + st_order_qty + "@@" + st_ref_pr_no + "@@"+ st_contract_no + "@@" + st_contract_seq + "@@" + st_fixed_price_flag + "@@" + st_order_price + "@@" + st_account_type + "@@" + st_budget_dept + "@@"+remark+ "@@"+ref_pr_dept+ "@@"+""+ "@@"+""+ "@@"+st_cart_seq;
//	                query += st_item_no + "@@" + st_order_qty + "@@" + st_ref_pr_no + "@@"+ st_contract_no + "@@" + st_contract_seq + "@@" + st_fixed_price_flag + "@@" + st_order_price + "@@" + st_account_type + "@@" + st_budget_dept + "@@"+remark+ "@@"+ref_pr_dept+ "@@"+""+ "@@"+"";
	                query +=  "|";
	            }
	        }
	    }
	    document.forms.processForm.next_status.value = next_status;
	    document.forms.processForm.st_update.value = query;
	 //   document.forms.contentForm.action = "/kr/coway_buyer/shopping_cart/buyer_shoppingcart_qty_update.jsp";	    

    	kepAjaxFormCall("/mpso/saveBuyerShoppingcartQtyUpdate.do","processForm",next_status); 
    	
	}
	
	
	function setMyCatalogReg(){    /////////////////////////////  나의상품등록  //////////////////////////////////
		
		 
	    var tot_cnt  = $("#display_item_cnt").val();
	    var chk_cnt = 0;
	    var cnt     = 0;
	    var query   = "";
	    if(tot_cnt == "" || tot_cnt == "null" || tot_cnt == null || tot_cnt == "0"){
	        alert(" 목록에 표시된 상품이 없습니다.     ");
	        return;
	    }

	    
	    chk_cnt = getCheckedRowCount(tot_cnt);
	    
	    
	    if(chk_cnt == "0"){
	        alert(" 하나 이상의 상품이 선택되어야 합니다.   ");
	        return;
	    }else{
	        if(eval(tot_cnt) < 2){
	            var box = eval("document.forms.contentForm.lnCheck0" );
	            var order_qty = document.forms.contentForm.st_order_qty.value;
	            var key_flag  = document.forms.contentForm.st_key_flag.value;
	            if(box.checked == true){
	                if(!chkDecimal(order_qty,3)){
	                    alert( " 첫번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n 소숫점은 3자리까지 가능합니다.    ");
	                    document.forms.contentForm.st_order_qty.focus();
	                    return;
	                }
	                if(key_flag == "Y"){
	                    alert( " 상품구분이 필요한 항목입니다.  \n\n 상품 상세보기에서 나의상품등록을 하실 수 있습니다. ");
	                    box.checked = false;
	                    return;
	                }
	            }
	        }else{
	            for(var i = 0; i < tot_cnt; i++){
	                var box = eval("document.forms.contentForm.lnCheck" + i);
	                var order_qty = document.forms.contentForm.st_order_qty[i].value;
	                if(box.checked == true){
	                    if(!chkDecimal(order_qty,3)){
	                        alert( (i+1)+" 번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n소숫점은 3자리까지 가능합니다.    ");
	                        document.forms.contentForm.st_order_qty[i].focus();
	                        return;
	                    }
	                    if(key_flag == "Y"){
	                        alert( " 상품구분이 필요한 항목입니다.  \n\n 상품 상세보기에서 나의상품등록을 하실 수 있습니다. ");
	                        box.checked = false;
	                        return;
	                    }
	                }
	            }
	        }
	    }
	    ok = confirm(" 선택하신 상품을 나의 상품으로 등록하시겠습니까?   ");
	    if(!ok){
	         return;
	    }else{
	         var move_flag = "N";
	    }
	    if(eval(tot_cnt) < 2){
	         var box = eval("document.forms.contentForm.lnCheck0" );
	         var st_item_no   = document.forms.contentForm.st_item_no.value;
	         var st_order_qty = document.forms.contentForm.st_order_qty.value;
	         var st_contract_no = document.forms.contentForm.st_contract_no.value;
	         var st_contract_seq = document.forms.contentForm.st_contract_seq.value;
	         var st_agent_code = document.forms.contentForm.st_agent_code.value;
	         var st_byit_comorg_code = document.forms.contentForm.st_byit_comorg_code.value;
	         if(box.checked == true){
	              if(st_order_qty == "" || st_order_qty == "null" || st_order_qty == null){
	                  st_order_qty = "1";
	              }
	              query = st_item_no + "@@" + st_order_qty + "@@" + st_agent_code  + "@@" + st_contract_no  + "@@" + st_contract_seq + "@@" + st_byit_comorg_code +  "&&";
	         }
	    }else{
	        for(var k = 0; k < tot_cnt; k++){
	             var box = eval("document.forms.contentForm.lnCheck" + k);
	             var st_item_no   = document.forms.contentForm.st_item_no[k].value;
	             var st_order_qty = document.forms.contentForm.st_order_qty[k].value;
	             var st_contract_no = document.forms.contentForm.st_contract_no[k].value;
	             var st_contract_seq = document.forms.contentForm.st_contract_seq[k].value;
	             var st_agent_code = document.forms.contentForm.st_agent_code[k].value;
	             var st_byit_comorg_code = document.forms.contentForm.st_byit_comorg_code[k].value;
	             if(box.checked == true){
	                  if(st_order_qty == "" || st_order_qty == "null" || st_order_qty == null){
	                      st_order_qty = "1";
	                  }
	                  query += st_item_no + "@@" + st_order_qty + "@@" + st_agent_code  + "@@" + st_contract_no  + "@@" + st_contract_seq + "@@" + st_byit_comorg_code;
	                  query +=  "&&";
	             }
	         }
	    }
	    
	   // document.forms.contentForm.action = "/kr/coway_buyer/categ_search/buyer_shoppingcart_new_reg.jsp";	    
		document.forms.processForm.st_use_flag.value = "R"; 
		document.forms.processForm.st_query2.value = query; 
		kepAjaxFormCall("/mdcm/saveBuyerMdCmGoodsLisList.do","processForm","RsaveProcess"); 
	}
	
	function setCartDelete(){
  
	    var tot_cnt  =  $("#display_item_cnt").val();
	    var chk_cnt  = 0;
	    var query    = "";
	    if(eval(tot_cnt) == 0)
	    {
	        alert("조회한 데이타가 없습니다.");
	        return;
	    }
 
	    chk_cnt = getCheckedRowCount(tot_cnt);
	    
	    if(chk_cnt == "0"){
	        alert("하나 이상의 상품이 선택되어야 합니다.   ");
	        return;
	    }else{
	         ok = confirm(" 선택된 상품을 장바구니에서 삭제하시겠습니까??   ");
	         if(ok){
	              if(eval(tot_cnt) < 2){
	                   var box = eval("document.forms.contentForm.lnCheck0" );
	                   var st_item_no   = document.forms.contentForm.st_item_no.value;
	                   var st_order_qty = document.forms.contentForm.st_order_qty.value;
	                   var st_contract_no = document.forms.contentForm.st_contract_no.value;
	                   var st_contract_seq = document.forms.contentForm.st_contract_seq.value;
	                   var st_agent_code = document.forms.contentForm.st_agent_code.value;
	                   var st_byit_comorg_code = document.forms.contentForm.st_byit_comorg_code.value;
	                   var st_cart_seq = document.forms.contentForm.st_cart_seq.value;
	                   if(box.checked == true){
	                          query = st_item_no + "@@" + st_agent_code + "@@" + st_contract_no + "@@" + st_contract_seq + "@@" + st_byit_comorg_code + "@@"  + "C" + "@@" + st_cart_seq + "&&";
	                   }
	              }else{
	                   for(var j = 0; j < tot_cnt; j++){
	                       var box = eval("document.forms.contentForm.lnCheck" + j);
	                       var st_item_no   = document.forms.contentForm.st_item_no[j].value;
	                       var st_order_qty = document.forms.contentForm.st_order_qty[j].value;
	                       var st_contract_no = document.forms.contentForm.st_contract_no[j].value;
	                       var st_contract_seq = document.forms.contentForm.st_contract_seq[j].value;
	                       var st_agent_code = document.forms.contentForm.st_agent_code[j].value;
	                       var st_byit_comorg_code = document.forms.contentForm.st_byit_comorg_code[j].value;
	                       var st_cart_seq = document.forms.contentForm.st_cart_seq[j].value;
	                       if(box.checked == true){
	                            query += st_item_no + "@@" + st_agent_code + "@@" + st_contract_no + "@@" + st_contract_seq + "@@" + st_byit_comorg_code + "@@" + "C" + "@@" + st_cart_seq;
	                            query +=  "&&";
	                       }
	                   }
	              }
	
	              //document.forms.contentForm.action = "/kr/coway_buyer/categ_search/buyer_shoppingcart_mycart_del_reg.jsp?st_query=" + query;

	              
	              
	              document.forms.processForm.next_status.value = "DELETE";
	              document.forms.processForm.st_update.value = query; 

	          	   kepAjaxFormCall("/mpso/removeBuyerShoppingcartMycartDelReg.do","processForm","DELETE"); 
	          	
	          	
	         }else{
	              return;
	         }
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


	

	function item_check(next_status){
		
 
	    var tot_cnt  =  $("#display_item_cnt").val();
	    if(eval(tot_cnt) == 0)
	    {
	        alert("조회한 데이타가 없습니다.");
	        return;
	    }

	    var chk_cnt  = 0;
	    chk_cnt = getCheckedRowCount(tot_cnt);
	    if(chk_cnt == "0"){
	        alert("하나 이상의 상품이 선택되어야 합니다.   ");
	        return;
	    }

	    var st_item_no = "";
	    var st_item_no_arr = "";
	    var ckCnt = 0;
	    if(eval(tot_cnt) < 2){
	        var box = eval("document.forms.contentForm.lnCheck0" );
	        if(box.checked == true){
	            st_item_no   = document.forms.contentForm.st_item_no.value;
	            st_item_no_arr +=     st_item_no + "@@";
	        }
	    }else{
	        for(var j = 0; j < tot_cnt; j++){
	            var box = eval("document.forms.contentForm.lnCheck" + j);
	            if(box.checked == true){
	                ckCnt++;
	                st_item_no   = document.forms.contentForm.st_item_no[j].value;
	                if(ckCnt==1){
	                    st_item_no_arr +=   st_item_no + "@@";
	                }else{
	                    st_item_no_arr +=   st_item_no + "@@";
	                }
	            }
	        }
	    }
	    document.forms.processForm.st_item_chk.value = st_item_no_arr;
	    document.forms.processForm.next_status.value = next_status; 
	    //document.forms.contentForm.action = "/kr/coway_buyer/shopping_cart/buyer_shoppingcart_sangjoitem_search.jsp";
	    kepAjaxFormCall("/mpso/getBuyerShoppingcartSangjoitemSearch.do","processForm",next_status);  
	}

	function set_item_check(sangjo_cnt){
		
		//alert("sangjo_cnt " +sangjo_cnt);
		var tot_cnt  = $("#display_item_cnt").val();
	    if(tot_cnt == "" || tot_cnt == "null" || tot_cnt == null){
	        alert(" 목록에 표시된 상품이 없습니다.     ");
	        return;
	    }

	    
	    var chk_cnt  = 0;
	    chk_cnt = getCheckedRowCount(tot_cnt);
	    var next_status = document.forms.processForm.next_status.value;
	    var next_status2 = "";
	    document.forms.contentForm.sangjo_cnt.value = sangjo_cnt;
	    
	    if (next_status == "CART_SANGJO"){
	    	next_status2 = "CART";
	    }else  if (next_status == "ORDER_SANGJO"){
	    	next_status2 = "ORDER";
	    }
	     
	    if(eval(sangjo_cnt) > 1){
	        alert("상조용품은 건별로 주문가능합니다.");
	        return;
	    }else if(eval(sangjo_cnt)== 1 && chk_cnt > 1){
	        alert("상조용품은 다른 품목과 주문할 수 없습니다.");
	        return;
	    }else{
	        item_qty_update(next_status2);
	    }
	}


	/**
	 * 팝업호출
	 */
	function cartPrSheet(){

	    var buyer               = "<%=buyer%>";
	    var user_id             = "<%=userId%>";

	    var tot_cnt  = $("#display_item_cnt").val();

	    var chk_cnt = 0; 
	    var query   = "";

	    if(tot_cnt == "" || tot_cnt == "null" || tot_cnt == null){
	        alert(" 목록에 표시된 상품이 없습니다.     ");
	        return;
	    }

	    chk_cnt = getCheckedRowCount(tot_cnt);
	    
	    if(chk_cnt == "0"){
	        alert(" 하나 이상의 상품이 선택되어야 합니다.   ");
	        return;
	    }else{

	        if(eval(tot_cnt) < 2){
	            var box = eval("document.forms.contentForm.lnCheck0");
	            var st_item_no   = document.forms.contentForm.st_item_no.value;
	            var st_contract_no = document.forms.contentForm.st_contract_no.value;
	            var st_contract_seq = document.forms.contentForm.st_contract_seq.value;
 	            var st_cart_seq = document.forms.contentForm.st_cart_seq.value;
	            //var st_agent_code = document.forms.contentForm.st_agent_code.value;
	            //var st_byit_comorg_code = document.forms.contentForm.st_byit_comorg_code.value;

	            if(box.checked == true){
//	                query = st_item_no + st_contract_no  + st_contract_seq + "@@";
 	                query = st_item_no + st_contract_no  + st_contract_seq + st_cart_seq + "^Y^" + "@@";
	            }
	        }else{
	            for(var k = 0; k < tot_cnt; k++){
	                var box = eval("document.forms.contentForm.lnCheck" + k);
	                var st_item_no   = document.forms.contentForm.st_item_no[k].value;
	                var st_contract_no = document.forms.contentForm.st_contract_no[k].value;
	                var st_contract_seq = document.forms.contentForm.st_contract_seq[k].value;
 	                var st_cart_seq = document.forms.contentForm.st_cart_seq[k].value;
	                //var st_agent_code = document.forms.contentForm.st_agent_code[k].value;
	                //var st_byit_comorg_code = document.forms.contentForm.st_byit_comorg_code[k].value;

	                if(box.checked == true){
//	                    query += st_item_no + st_contract_no  + st_contract_seq + "@@"; 
 	                    query += st_item_no + st_contract_no  + st_contract_seq + st_cart_seq + "^Y^" + "@@"; 
	                }
	            }
	        }
	    }//end else

	    reportOpen("<%=reportid%>","["+query+"]["+buyer+"]["+user_id+"]");     
	}
	
	//코오롱 전산기기 견적제안서
	function rd_onload(query) { 
	  //  reportOpen("RD_06_B_001_14","["+query+"]");
	    //window.open("/kr/customer/sheet/cart_print_krkolo0033_sheet.jsp?cart_query="+query, "krkolo0033Sheet", "width="+scr_width+", height="+scr_height+"");
	}
	
	//홍익대학교 물품구입 신청서.
	function PrSheetView(){
	    var userId = "<%=userId%>";
	    var userComCode = "<%=buyer%>";
	    var userDept = "<%=userDept%>";
	    var verif_num = "<%=st_verif_num%>";
	    reportOpen("<%=reportid%>","["+userComCode+"]["+userId+"]["+userDept+"]["+verif_num+"]");
	    //window.open("/kr/epro/buy/sheet/pum_hongik_sheet.jsp?st_buyer="+userComCode+"&st_user_id="+userId+"&st_user_dept="+userDept+"&st_verif_num="+verif_num,"PrSheetWin","width=1000,height=700,resizable=YES,scrollbars=YES,top=0,left=0");
	}

	function PrSheetViewSiem(){
	    var userId = "<%=userId%>";
	    var userComCode = "<%=buyer%>";    
	    reportOpen("<%=reportid%>","[]["+userComCode+"]["+userId+"]"); 
	    //window.open("/kr/epro/buy/sheet/pum_siem_sheet_html.jsp?st_buyer="+userComCode+"&st_user_id="+userId,"PrSheetWin","width=850,height=700,resizable=YES,scrollbars=YES,top=0,left=0");
	}


	/**
	 * ajax 공통 호출후 성공시 처리 함수
	 */ 
	function kepAjaxSuccess(pMethod , response){ 
		

		var sMsg = response.msg.MSG;   
		var tot_cnt  = $("#display_item_cnt").val();
		var query = "";
		 var sangjo_cnt  = document.forms.contentForm.sangjo_cnt.value;
		 var url = "";
		 
		// alert("sMsg " +sMsg + " pMethod " +pMethod);
		
	    if(sMsg == "CREATE_OK"){ // asis = setCartResult_Refresh
	    	
	       if(pMethod == "RsaveProcess")  // 나의상품 등록
	       { 
	    	   alert("나의상품으로 등록 되었습니다.   ");            
	        	// 처리후 재조회
	        	kepSearch($("#curPage").val());       
	 
	       } 
	        
	    }else if (sMsg == "UPDATE_OK") { // asis setQtyUpdateResults -- 저장,바로주문
	    	  
	    	  if(pMethod == "CART"){
	    		  
	    		  if(eval(tot_cnt) < 2){
	                  var box = eval("document.forms.contentForm.lnCheck0");
	                  var st_item_no   = document.forms.contentForm.st_item_no.value;
	                  var st_contract_no = document.forms.contentForm.st_contract_no.value;
	                  var st_contract_seq = document.forms.contentForm.st_contract_seq.value;
 	                  var st_cart_seq = document.forms.contentForm.st_cart_seq.value;

	                  if(box.checked == true){
						var BUYER = document.forms.searchForm.st_buyer.value;
						query += st_item_no + st_contract_no + st_contract_seq + "&&" + st_cart_seq + "@@";
	                  }
	              }else{

	                  for(var j = 0; j < tot_cnt; j++){
	                      var box = eval("document.forms.contentForm.lnCheck" + j);
	                      var st_item_no   = document.forms.contentForm.st_item_no[j].value;
	                      var st_contract_no = document.forms.contentForm.st_contract_no[j].value;
	                      var st_contract_seq = document.forms.contentForm.st_contract_seq[j].value;
 	                      var st_cart_seq = document.forms.contentForm.st_cart_seq[j].value;

	                      if(box.checked == true){ 
	                    	var BUYER = document.forms.searchForm.st_buyer.value;
	                    	query += st_item_no + st_contract_no + st_contract_seq + "&&" + st_cart_seq + "@@";
	                      }
	                  }//END FOR
	              }//END IF
					//카테고리별결재담당자 품목도 상조화면으로 이동
	    			var cate_appr_cnt = 0;
	    			var st_cate_appr = 0;
	    			 if(eval(tot_cnt) < 2){
	    				  var box = eval("document.forms.contentForm.lnCheck0");
	    				  if(box.checked == true){
	    					st_cate_appr = document.forms.contentForm.st_cate_appr.value;
	    					if(st_cate_appr > 0){
	    						cate_appr_cnt++;
	    					}
	    				  }
	    			 }else{
	    				  for(var j = 0; j < tot_cnt; j++){
	    					 var box = eval("document.forms.contentForm.lnCheck" + j);
	    					 if(box.checked == true){
	    						st_cate_appr = document.forms.contentForm.st_cate_appr[j].value;
	    						if(st_cate_appr > 0){
	    							cate_appr_cnt++;
	    						}
	    					 }
	    				 }
	    			 }
	              
	    			 if((sangjo_cnt != 0) || (cate_appr_cnt > 0)){			             
	    			  
	                  
		              var recv_date  = document.forms.searchForm.st_recv_date.value;
		              var zip_code   = document.forms.searchForm.st_zip_code.value;
		              var tel_no     = document.forms.searchForm.st_tel_no.value;
		              var fax_no     = document.forms.searchForm.st_fax_no.value;
		              var mobile     = document.forms.searchForm.st_mobile_no.value;

		              document.forms.locationForm.st_query_cart.value = query;
		              document.forms.locationForm.st_zip_code.value   = zip_code;
		              document.forms.locationForm.st_tel_no.value     = tel_no;
		              document.forms.locationForm.st_fax_no.value     = fax_no;
		              document.forms.locationForm.st_mobile_no.value  = mobile;
		              document.forms.locationForm.st_recv_date.value  = recv_date;
		              
		              ///kr/coway_buyer/shopping_cart/buyer_delivery_sangjo.jsp
	                  	//alert("코웨이 상조 주문 으로 이동 PG_06_B_010_06");
			            url = "<%=h_sslurl2%>/mpso/getBuyerMpSoOrderInfoSangjoList.do";			              
	    		  } else{   			  	    			  
	    			  
		              document.forms.locationForm.st_query_cart.value = query;  
		              document.forms.locationForm.st_verif_num.value = document.forms.searchForm.st_verif_num.value;  
		              
		              ///kr/coway_buyer/shopping_cart/buyer_delivery_info.jsp
		             // alert("일반 코웨이 배송 으로 이동 PG_06_B_010_04");
		              url = "<%=h_sslurl2%>/mpso/getBuyerMpSoDlvryInfoCowayList.do";
	    		  }
	    		  
	    		  $('#locationForm').attr("action", url).submit();   

	           }else if(pMethod == "ORDER"){
	        	    
	               if(eval(tot_cnt) < 2){
	                    var box = eval("document.forms.contentForm.lnCheck0");
	                    var st_item_no   = document.forms.contentForm.st_item_no.value;
	                    var st_contract_no = document.forms.contentForm.st_contract_no.value;
	                    var st_contract_seq = document.forms.contentForm.st_contract_seq.value;
 	                    var st_cart_seq = document.forms.contentForm.st_cart_seq.value;
	                    

	                    if(box.checked == true){
	                    	query += st_item_no + st_contract_no + st_contract_seq + "&&" + st_cart_seq + "@@";
	                    }
	               }else{
	                    for(var j = 0; j < tot_cnt; j++){
	                       var box = eval("document.forms.contentForm.lnCheck" + j);
	                       var st_item_no   = document.forms.contentForm.st_item_no[j].value;
	                       var st_contract_no = document.forms.contentForm.st_contract_no[j].value;
	                       var st_contract_seq = document.forms.contentForm.st_contract_seq[j].value;
 	                       var st_cart_seq = document.forms.contentForm.st_cart_seq[j].value;

	                       if(box.checked == true){
	                    	   query += st_item_no + st_contract_no + st_contract_seq + "&&" + st_cart_seq + "@@";
	                       }
	                   }
	               }

	              var recv_date  = document.forms.searchForm.st_recv_date.value;
	              var zip_code   = document.forms.searchForm.st_zip_code.value;
	              var tel_no     = document.forms.searchForm.st_tel_no.value;
	              var fax_no     = document.forms.searchForm.st_fax_no.value;
	              var mobile     = document.forms.searchForm.st_mobile_no.value;

	              document.forms.locationForm.st_query_cart.value = query;
	              document.forms.locationForm.st_zip_code.value   = zip_code;
	              document.forms.locationForm.st_tel_no.value     = tel_no;
	              document.forms.locationForm.st_fax_no.value     = fax_no;
	              document.forms.locationForm.st_mobile_no.value  = mobile;
	              document.forms.locationForm.st_recv_date.value  = recv_date;
	              
	              
	              document.forms.locationForm.st_query_cart.value = query;  
	              document.forms.locationForm.st_verif_num.value = document.forms.searchForm.st_verif_num.value;  
	              
					//카테고리별결재담당자 품목도 상조화면으로 이동
	    			var cate_appr_cnt = 0;
	    			var st_cate_appr = 0;
	    			 if(eval(tot_cnt) < 2){
	    				  var box = eval("document.forms.contentForm.lnCheck0");
	    				  if(box.checked == true){
	    					st_cate_appr = document.forms.contentForm.st_cate_appr.value;
	    					if(st_cate_appr > 0){
	    						cate_appr_cnt++;
	    					}
	    				  }
	    			 }else{
	    				  for(var j = 0; j < tot_cnt; j++){
	    					 var box = eval("document.forms.contentForm.lnCheck" + j);
	    					 if(box.checked == true){
	    						st_cate_appr = document.forms.contentForm.st_cate_appr[j].value;
	    						if(st_cate_appr > 0){
	    							cate_appr_cnt++;
	    						}
	    					 }
	    				 }
	    			 }
	    			 
	 				if((sangjo_cnt != 0) || (cate_appr_cnt > 0)){
	    			  ///kr/coway_buyer/shopping_cart/buyer_delivery_sangjo.jsp
	                  	//alert("코웨이 상조 주문 으로 이동 PG_06_B_010_06");
			            url = "<%=h_sslurl%>/mpso/getBuyerMpSoOrderInfoSangjoList.do";			              
	    		  } else{   	
		              // /kr/coway_buyer/shopping_cart/buyer_delivery_list.jsp
		             //alert("일반 코웨이 주문 으로 이동 PG_06_B_010_05");
		             url = "<%=h_sslurl%>/mpso/getBuyerMpSoOrderInfoCowayList.do";		 
	    		  }
	    		  
	    		  $('#locationForm').attr("action", url).submit();   
	              
	           }else if(pMethod == "PrSheet") {
	        	   
	              cartPrSheet();//***********************
	              
	           }else if(pMethod == "SAVE") {
	        	   
	        	   
	               alert(" 정상적으로 저장되었습니다.");
	             	 // 처리후 재조회
	             	 kepSearch($("#curPage").val()); 
	          	 
	           }else if(pMethod == "DELETE") { // asis setResulte -- 삭제
	        	   
	        	   alert(" 정상적으로 삭제되었습니다.   ");
	        	   var chk_cnt = getCheckedRowCount(tot_cnt);
	        	   if( tot_cnt == chk_cnt ) allDelFlag = "Y";
	        	    var buyer       = $("#st_buyer").val();  
	        	    if(buyer == "KRHONG0020" && allDelFlag == "Y"){
	        	    	
	        	    	// 질문
	        	        //action_url  = "/kr/customer/shopping_cart/hongik_shoppingorder_list.jsp";
	        	        
	             	//alert("hongik_shoppingorder_list 로 이동"); 
	              	$('#locationForm').attr("action", "/mpso/getBuyerMpSoCartHongikList.do").submit();    
	        	    }else{
	             	 // 처리후 재조회
	             	 kepSearch($("#curPage").val()); 
	        	    }
	        	    
	           } 
	    	  
	      } else {
	    	  
	    	  if(pMethod == "CART_SANGJO") {
	        	   set_item_check(sMsg);
	          }else if(pMethod == "ORDER_SANGJO") {
	        	   set_item_check(sMsg);
	          }else if(pMethod == "FILE") {
	        		// 처리후 재조회
//				kepSearch($("#curPage").val());
	          }else   if(pMethod == "RsaveProcess")
	          {
	        	 alert("품목코드 (" + sMsg + ") 은 이미 나의 상품으로 저장된 항목입니다.  ");
	        	// 처리후 재조회
		     	 kepSearch($("#curPage").val());
	          } else {
	        	  
	          }
	         
	     	 
	         
	      }  
	}

	/**
	 * ajax 공통 호출후 에러시 처리 함수
	 */
	function  kepAjaxError(pMethod , response) {
		
		if (pMethod == "RsaveProcess"){ 
			 alert("나의상품등록 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
		} else if (pMethod == "DELETE"){ 
			 alert("삭제 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
		} else{
			 alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
		}
		 
		
	} 
	
	
</script>
</html>
