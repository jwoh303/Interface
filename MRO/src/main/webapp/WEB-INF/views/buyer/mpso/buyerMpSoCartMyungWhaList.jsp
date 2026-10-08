<%--
**********************************************
* 메뉴 : 주문관리>장바구니(명화용)
* 화면 : 장바구니(명화용)
* 기능 : 명화용 장바구니
* 프로그램 ID : PG_06_B_009_00  -- EOKWON
* 담당자 : CEJ ( 설계 : 김지현 )
* 착수일 : 2014-06-16
**********************************************
--%> 
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
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
	String onepagerow =  CommonUtil.nvl((String) request.getParameter("onepagerow"),"50"); // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	
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
    
    boolean p060000034 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000034"); // KRDAEW0023 KRDAEW0043 KRDAEW0045
    
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
	<h3>장바구니(명화)</h3>
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
						<option <%=("200".equals(onepagerow) ? "selected" : "")%> value = "200">200건</option>
						<option <%=("500".equals(onepagerow) ? "selected" : "")%> value = "500">500건</option>
					</select>
		      	</span>	          
                <span class="btn_imghide">
<%  if(st_image_status.equals("IMAGE_HIDDEN")){   %>
<a href="javascript:imageHideView();"  title="이미지보이기" >이미지보이기</a>
<%  }else{   %>
<a href="javascript:imageHideView();"  title="이미지감추기" >이미지감추기</a>
<%  }   %> </span>
		      </div>
				  <div class="fr">총금액
				: <input type="text" name="check_sum_price"   id="check_sum_price"  class="input_type_text"  value="0" style="background-color:#FFFFFF;font-weight: bold;font-size:9pt;border:#FFFFFF 1px solid;text-align:right;" READONLY>&nbsp;
				<input type="hidden" name="st_check_sum_price"  id="st_check_sum_price"  value=""> 				 
              </div>
        </div>
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<!-- 공통 -->
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
	  	
		<table class="cont_t_list02" style="width:100%">
			<colgroup>
               <col width="3%" />
               <col width="7%" />
               <col width="12%" />
               <col width="*" />
               <col width="13%" />
<%

if("Y".equals(budget_flag)){ 
%>                              
               <col width="15%" />
<%} %>     
               <col width="15%" />
               <col width="7%" />
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
                   <th scope="col">품목코드<br><a href="javascript:setRefNoCopy();">관리번호</a></th>
                   <th scope="col">품목명<br>규격</th>
                   <th scope="col">협력사<br>제조사</th>
                   
<%

if("Y".equals(budget_flag)){ 
%>
   <th scope="col">계정명<br>예산부서  </th>
<%
}else{
%>                	
<%} %>         
                 
                   <th scope="col">단위 / 단가 / 수량 / 구매액<br>비고</th>   
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
			<td colspan="15" align="center" height = "50"> 
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
          <%=(CommonUtil.nvl(rowData.get("ITEM_STATUS_FLAG")).equals("거래") ? ""   : "<img src=/resources/images/outitem2.gif>")%>
 
<%     }
    }
%>		 
                    </td>
					<td>
                   		<a class="hyperLink" href="javascript:getBuyerCatalogDisplayPop('<%=rowData.get("BYIT_COMORG_CODE")%>','<%=rowData.get("BUYER_ITEM_NO")%>','<%=rowData.get("CONTRACT_NO")%>','<%=rowData.get("CONTRACT_SEQ")%>');"><b><font color="#5B5B5B"><%=rowData.get("BUYER_ITEM_NO")%></font></b></a>
                               <input type="hidden" name="st_item_no"            value="<%=rowData.get("BUYER_ITEM_NO")%>" >
                               <input type="hidden" name="st_contract_no"        value="<%=rowData.get("CONTRACT_NO")%>">
                               <input type="hidden" name="st_contract_seq"       value="<%=rowData.get("CONTRACT_SEQ")%>">
                               <input type="hidden" name="st_agent_code"         value="<%=rowData.get("AGENT_CODE")%>">
                               <input type="hidden" name="st_byit_comorg_code"   value="<%=rowData.get("BYIT_COMORG_CODE")%>">
                               <input type="hidden" name="st_bdgt_flag"          value="<%=rowData.get("BDGT_FLAG")%>">
                               <input type="hidden" name="st_product_close_flag" value="<%=rowData.get("PRODUCT_CLOSE_FLAG")%>">
                               <input type="hidden" name="st_process_type"			value="<%=rowData.get("PROCESS_TYPE")%>">
                               <input type="hidden" name="st_stock_item_flag"		value="<%=rowData.get("STOCK_ITEM_FLAG")%>">
							<input type="hidden" name="st_ref_pr_dept" value="<%=rowData.get("HI_DEPT_CODE")%>">
							<input type="hidden" name="st_item_status_flag"			value="<%=rowData.get("ITEM_STATUS_FLAG")%>">
                               <!--<input type="hidden" name="st_account_type"       value="<%=rowData.get("ACCOUNT_TYPE")%>"> -->
                   		<br>
                        
                                   <input type="text" name="st_ref_pr_no" class="input_type_text" size="14" maxlength="20" value="<%=rowData.get("REF_PR_NO")%>">
                </td> 
                <td class="left">
                    <%=rowData.get("DESCRIPTION_LOC")%><br>
                    <%=rowData.get("SPECIFICATION")%><br>
                            <% if(rowData.get("PRODUCT_CLOSE_FLAG").equals("Y")) { %>&nbsp; <% }else if(rowData.get("OVER_SHORT_FLAG").equals("N")) { %>&nbsp; <% } else { %> <br><font color="green">(재 판매일 :<%=CommonUtil.formatStrinigDate(rowData.get("HS_NO"))%>)</font><% } %>
               </td>             

               <td>
                    <a class="hyperLink" href="javascript:getAgentDisplayPop('<%=rowData.get("AGENT3")%>');"><%=rowData.get("AGENT")%></a><br>
                   <%=rowData.get("MAKER_NAME")%>
				</td>

                <%
                    // ICOMCMPY.BUDGET_FLAG = 'Y' 예산 사용 고객사
                    if(budget_flag.equals("Y")){
                %>
                    <!-- 계정명 , 예산부서 -->
                    <td>
                        <table style="width:100%">
                            <tr>
                                <td>
                <%
                        if(rowData.get("ACCOUNT_NAME").equals(""))
                        {
                %>
                                    <input type="text"   name="st_account_type_name" class="input_type_text" size="14" value="선택"  style="background-color:<%=tclass%>;font-size:9pt;border:<%=tclass%>;color=#003694;1px solid; cursor:pointer;" READONLY onClick="javascript:getBdgtAccountPop('<%=buyer%>','<%=userDept%>');">
                <%
                        }else{
                %>
                                    <input type="text"   name="st_account_type_name" class="input_type_text" size="14" value="<%=rowData.get("ACCOUNT_NAME")%>"  style="background-color:<%=tclass%>;font-size:9pt;border:<%=tclass%>;color=#0043A8; 1px solid; cursor:pointer;" READONLY onClick="javascript:getBdgtAccountPop('<%=buyer%>','<%=userDept%>');">
                <%
                        }
                %>
                                    <input type="hidden" name="st_account_type" value="<%=rowData.get("ACCOUNT_TYPE")%>">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input type="text"   name="st_budget_dept_name" class="left_align" size="14" value="<%=rowData.get("BUDGET_DEPT_CODE").equals("")?"":rowData.get("BUDGET_DEPT_NAME")%>"  style="background-color:<%=tclass%>;font-size:9pt;border:<%=tclass%> 1px solid;" READONLY>
                                    <input type="hidden" name="st_budget_dept" value="<%=rowData.get("BUDGET_DEPT_CODE")%>">
                                </td>
                            </tr>
                        </table>
                    </td>
                <%
                    }else{  // ICOMCMPY.BUDGET_FLAG = 'N' 예산 미사용 고객사
                %>
                        <input type="hidden" name="st_account_type" value="<%=rowData.get("ACCOUNT_TYPE")%>">
                        <input type="hidden" name="st_budget_dept"  value="">
                <%
                    }
                %>

				<td>
					<table style="width:100%">
						<tr>
							<td><%=rowData.get("UNIT_MEASURE")%> / 
								<% if(rowData.get("FIXED_PRICE_FLAG").equals("N")) { %>
                                    <input type="text" name="st_order_price"   style="width:15%;text-align:right;"   class="input_type_text" size="10" value="<%=CommonUtil.formatNumber(rowData.get("TARGET_PRICE"),true,0,3)%>" onChange="javascript:price_update_P('<%=j%>',this.value,'<%=rowData.get("CART_QTY")%>');" onBlur="this.value=this.value;" onkeydown="if (event.keyCode == 13) javascript:price_update_P('<%=j%>',this.value,'<%=rowData.get("CART_QTY")%>');">
                                <% }else { %>
                                    <%=CommonUtil.formatNumber(rowData.get("TARGET_PRICE"),true,0,3)%>
                                    <input type="hidden" name="st_order_price" value="<%=CommonUtil.formatNumber(rowData.get("TARGET_PRICE"),true,0,3)%>">
                                <% } %>
                                <input type="hidden" name="st_fixed_price_flag" value="<%=rowData.get("FIXED_PRICE_FLAG")%>"> / 
								<input type="text" name="st_order_qty" class="input_type_text" size="7"   style="width:15%;text-align:right;"    value="<%=CommonUtil.formatNumber(rowData.get("CART_QTY"),true,0,3)%>" onChange="javascript:price_update(this.value,'<%=j%>','<%=rowData.get("TARGET_PRICE")%>','<%=rowData.get("CART_QTY")%>');" onBlur="this.value=this.value;" onkeydown="if (event.keyCode == 13) javascript:price_update(this.value,'<%=j%>','<%=rowData.get("TARGET_PRICE")%>','<%=rowData.get("CART_QTY")%>');"> / <input type="text" name="st_sum_price" size="10" value="<%=CommonUtil.formatNumber(rowData.get("TOT_SUM"),true,0,3)%>"  style="background-color:<%=tclass%>;font-weight: bold;font-size:9pt;border:<%=tclass%> 1px solid;" READONLY>
							</td>
						</tr>
						<tr>
							<td>
								<input type="text" name="st_item_remark" class="input_type_text" size="50"  style="width:85%;"  value="<%=rowData.get("REMARK")%>">
							</td>
						</tr>
						</table>
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
        	<div class="fl">

				
 <%  //SLOGIC-BEGIN(P06-0000034)
 if( p060000034 == false){  %>
                <span class="btn_03 mr04"  title="품의서출력" ><a href="javascript:doAction('PrSheet');">품의서출력</a></span>
                <span class="btn_03 mr04"  title="엑셀다운로드" ><a href="javascript:doAction('setExcelDown');">엑셀다운로드</a></span>
            <%  }
//SLOGIC-END
            %>
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
                   <span class="btn_order mr04"  title="바로주문" ><a href="javascript:doAction('CART');">바로주문</a></span>
            <%      }else{                              %>
                   <span class="btn_order mr04"  title="바로주문" ><a href="javascript:doAction('ORDER');">바로주문</a></span>
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
	<input type="hidden" name="st_update" id="st_update"  value=""/> 
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
 
	case "setExcelDown":   
		setExcelDown();
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

	case "CART":   //바로주문
		item_qty_update('CART');
		break;  
		
	case "ORDER":   //바로주문
		item_qty_update('ORDER');
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
	doAction('CART');
	<%      }else{          %>
	doAction('ORDER');
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
	$('#searchForm').attr("action", "/mpso/getBuyerMpSoCartMyungWhaList.do").submit();   
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
  
/*
 * 관리번호 세팅
 */
function setRefNoCopy()
{
    var tot_cnt  = $("#display_item_cnt").val();
    var cnt = 0;
    var ref_no = "";    
    if(eval(tot_cnt) < 2){
       return;
    }else{
        for(var k = 0; k < tot_cnt; k++){
            var box = eval("document.forms.contentForm.lnCheck" + k);
            if(box.checked == true){
              if(cnt < 1)
              {
                 	ref_no = document.forms.contentForm.st_ref_pr_no[k].value;
                cnt++;
              }else { 
                    document.forms.contentForm.st_ref_pr_no[k].value = ref_no;
              }
            }
        }
    }
}


//상품 큰이미지
function getBigImage(file_dir, file_name){
	getBigImageView("<%= CommonUtil.getURL(request) %><%=CommonUtil.realImgS3UploadPath%>", file_dir, file_name);
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



// 예산계정 선택 팝업
function getBdgtAccountPop(com_code,dept_code)
{ 
    var tot_cnt  = $("#display_item_cnt").val();        
    var cnt = getCheckedRowCount(tot_cnt);
    if(cnt ==0){
        alert("예산 계정을 선택할 품목을 선택해 주십시요.");
        return;
    }
    var cart_sum_price =$("#st_check_sum_price").val();       
    var val = "";  
    openSearchPopup("/mpso/showBuyerMpSoAccountSelPop.do","?open=Y&com_code=" + com_code+"&dept_code="+dept_code+"&st_cart_sum_price="+cart_sum_price , "750,500,no"); 
 
    return;
}



//예산계정 설정
function setBdgtAccount(account_type , account_name, dept_code , dept_name, mg_code, mg_note){ 
    var tot_cnt  = $("#display_item_cnt").val();
    if(eval(tot_cnt) < 2){
        document.forms.contentForm.st_account_type_name.value= account_name;
        document.forms.contentForm.st_account_type.value     = account_type;
        document.forms.contentForm.st_budget_dept_name.value = dept_name;
        document.forms.contentForm.st_budget_dept.value      = dept_code; 
    }else{
        for(var k =0; k < tot_cnt; k++){
            var box = eval("document.forms.contentForm.lnCheck" + k);             
            if(box.checked == true){
                document.forms.contentForm.st_account_type_name[k].value   = account_name;
                document.forms.contentForm.st_account_type[k].value        = account_type;
                document.forms.contentForm.st_budget_dept_name[k].value    = dept_name;
                document.forms.contentForm.st_budget_dept[k].value         = dept_code; 
            }
        }
    }
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






function item_qty_update(next_status){  // CART : 배송지 입력화면 이동,   ORDER : 주문최종 확인 화면 이동
 
    var tot_cnt         = $("#display_item_cnt").val();
    var chk_cnt  = 0;
    var query    = "";
    var next_status = next_status;
    var buyer = document.forms.searchForm.st_buyer.value;

    var budget_flag = "<%=budget_flag%>";
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
        var box = eval("document.contentForm.lnCheck0");
        var st_item_no              = document.forms.contentForm.st_item_no.value;
        var st_order_qty            = TrimCommon(document.forms.contentForm.st_order_qty.value);
        var st_ref_pr_no            = document.forms.contentForm.st_ref_pr_no.value;
        var st_contract_no          = document.forms.contentForm.st_contract_no.value;
        var st_contract_seq			= document.forms.contentForm.st_contract_seq.value;
        var st_fixed_price_flag		= document.forms.contentForm.st_fixed_price_flag.value;
        var st_order_price          = document.forms.contentForm.st_order_price.value;
        var st_account_type			= document.forms.contentForm.st_account_type.value;
        var st_budget_dept          = document.forms.contentForm.st_budget_dept.value;
        var product_close_flag		= document.forms.contentForm.st_product_close_flag.value;
		var item_remark				= document.forms.contentForm.st_item_remark.value;
		var process_type				= document.forms.contentForm.st_process_type.value;
		var stock_item_flag			= document.forms.contentForm.st_stock_item_flag.value;
		var ref_pr_dept			= document.forms.contentForm.st_ref_pr_dept.value;
		var item_status_flag      = document.forms.contentForm.st_item_status_flag.value;


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

            if(buyer == "KRDONG0121" || buyer == "KRDUPO0001" || buyer == "KRKEPB0006" || buyer == "KRFAGB0001" || buyer == "KRFAGB0002" || buyer == "KRFAGB0003" || buyer == "KRSCHA0001" || buyer == "KRKDBO0003" || buyer == "KRKDPR0003" || buyer == "KRDOOS0013" || buyer=="KRCHO-0001")
//            if(buyer == "KRDONG0121" || buyer == "KRDUPO0001" || buyer == "KRKEPB0006" || buyer == "KRFAGB0001" || buyer == "KRFAGB0002" || buyer == "KRFAGB0003" || buyer == "KRSCHA0001")
            {
                if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                    alert("관리번호(계정)가 선택되지 않았습니다.\n"+"관리번호란을 클릭하여 계정을 선택하여 주십시요.");
                    return;
                }
            }else {
                if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null){
                    st_ref_pr_no = " ";
                }
            }

            if(budget_flag == "Y" && (next_status == "CART" || next_status =="ORDER")){
                if(isEmpty(st_account_type) || isEmpty(st_budget_dept)){
                    alert("예산 적용 부서 및 계정을 선택해 주십시요");
                    return;
                }
            }

          //query += st_item_no + "@@" + st_order_qty + "@@" + st_ref_pr_no + "@@"+ st_contract_no + "@@" + st_contract_seq + "@@" + st_fixed_price_flag + "@@" + st_order_price + "@@" + st_account_type + "@@" + st_budget_dept + "@@";
            query += st_item_no + "@@" + st_order_qty + "@@" + st_ref_pr_no + "@@"+ st_contract_no + "@@" + st_contract_seq + "@@" + st_fixed_price_flag + "@@" + st_order_price + "@@" + st_account_type + "@@" + st_budget_dept + "@@" + item_remark+ "@@"+ref_pr_dept+ "@@"+""+ "@@"+"";
            query +=  "|";
         }

    }else{

        for(var j = 0; j < tot_cnt; j++){

            var box = eval("document.contentForm.lnCheck" + j);
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
            var item_remark			= document.forms.contentForm.st_item_remark[j].value;
            var process_type			= document.forms.contentForm.st_process_type[j].value;
            var stock_item_flag			= document.forms.contentForm.st_stock_item_flag[j].value;  
            var ref_pr_dept			= document.forms.contentForm.st_ref_pr_dept[j].value;   
            var item_status_flag      = document.forms.contentForm.st_item_status_flag[j].value;

            if(box.checked == true){

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

                if(st_order_qty == "" || st_order_qty == "null" || st_order_qty == null || st_order_qty == "0" || isEmpty(st_order_qty) || !chkDecimal(st_order_qty,3)){
                    alert((j+1)+"번째 품목의 발주수량(숫자)을 입력하여 주십시요.");
                    document.forms.contentForm.st_order_qty[j].focus();
                    return;
                }

                if(buyer == "KRDONG0121" || buyer == "KRDUPO0001" || buyer == "KRKEPB0006" || buyer == "KRFAGB0001" || buyer == "KRFAGB0002" || buyer == "KRFAGB0003" || buyer == "KRSCHA0001" || buyer == "KRKDBO0003" || buyer == "KRKDPR0003" || buyer == "KRDOOS0013" || buyer=="KRCHO-0001")
//                if(buyer == "KRDONG0121" || buyer == "KRDUPO0001" || buyer == "KRKEPB0006" || buyer == "KRFAGB0001" || buyer == "KRFAGB0002" || buyer == "KRFAGB0003" || buyer == "KRSCHA0001")
                {
                    if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
                        alert( (j+1)+"번째 관리번호(계정)가 선택되지 않았습니다.\n"+"관리번호란을 클릭하여 계정을 선택하여 주십시요.");
                        return;
                    }
                }else {
                    if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null){
                        st_ref_pr_no = " ";
                    }
                }

                if(budget_flag == "Y" && (next_status == "CART" || next_status =="ORDER")){
                    if(isEmpty(st_account_type) || isEmpty(st_budget_dept)){
                        alert(  (j+1) + " 번째 품목의 예산 적용 부서 및 계정을 선택해 주십시요");
                        return;
                    }
                }

              //query += st_item_no + "@@" + st_order_qty + "@@" + st_ref_pr_no + "@@"+ st_contract_no + "@@" + st_contract_seq + "@@" + st_fixed_price_flag + "@@" + st_order_price + "@@" + st_account_type + "@@" + st_budget_dept + "@@";
                query += st_item_no + "@@" + st_order_qty + "@@" + st_ref_pr_no + "@@"+ st_contract_no + "@@" + st_contract_seq + "@@" + st_fixed_price_flag + "@@" + st_order_price + "@@" + st_account_type + "@@" + st_budget_dept + "@@" + item_remark+ "@@"+ref_pr_dept+ "@@"+""+ "@@"+"";
                query += "|";
            }
        }
    } 
    
    document.forms.processForm.next_status.value = next_status;
    document.forms.processForm.st_update.value = query; 
    ///kr/customer/shopping_cart/buyer_shoppingcart_qty_update.jsp

	kepAjaxFormCall("/mpso/saveBuyerShoppingcartQtyUpdate.do","processForm",next_status); 	

}

/*
 * 나의상품담기
 */
function setMyCatalogReg(){
	saveProcess("R");
}

/*
 * 나의상품등록 R 
 */
function saveProcess(flag){    
    var tot_cnt  = $("#display_item_cnt").val();
    var chk_cnt = 0; 
    var query   = "";
    if(tot_cnt == 0 || tot_cnt == "" || tot_cnt == "null" || tot_cnt == null){
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
            if(box.checked == true){
            	var order_qty     = document.forms.contentForm.st_order_qty.value; 
		        var st_item_no   = document.forms.contentForm.st_item_no.value;
				var st_order_qty = document.forms.contentForm.st_order_qty.value;
				var st_agent     = document.forms.contentForm.st_agent_code.value;
				var contract_no  = document.forms.contentForm.st_contract_no.value;
				var contract_seq = document.forms.contentForm.st_contract_seq.value;
				var byit_comorg_code = document.forms.contentForm.st_byit_comorg_code.value;
 
                if(!kepChkDecimal(order_qty,3)){
                    alert( " 첫번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n 소숫점은 3자리까지 가능합니다.    ");
                    document.forms.contentForm.st_order_qty.focus();
                    return;
                } else{
					query = st_item_no + "@@" + st_order_qty + "@@" + st_agent  + "@@" + contract_no  + "@@" + contract_seq + "@@" + byit_comorg_code + "&&";
				}
            }
        }else{
            for(var i = 0; i <tot_cnt; i++){
                var box = eval("document.forms.contentForm.lnCheck" + i);
                var order_qty     = document.forms.contentForm.st_order_qty[i].value; 
				var st_item_no   = document.forms.contentForm.st_item_no[i].value;
				var st_order_qty = document.forms.contentForm.st_order_qty[i].value;
				var st_agent     = document.forms.contentForm.st_agent_code[i].value;
				var contract_no  = document.forms.contentForm.st_contract_no[i].value;
				var contract_seq = document.forms.contentForm.st_contract_seq[i].value;
				var byit_comorg_code = document.forms.contentForm.st_byit_comorg_code[i].value;

                if(box.checked == true){
                    
                    
                    if(!kepChkDecimal(order_qty,3)){
                        alert( (i+1)+" 번째 상품수량을 숫자형식으로 입력하십시오.(ex : 1,2,10,20..)\n\n소숫점은 3자리까지 가능합니다.    ");
                        document.forms.contentForm.st_order_qty[i].focus();
                        return;
                    }
                    else {
					  query += st_item_no + "@@" + st_order_qty + "@@" + st_agent + "@@" + contract_no + "@@" + contract_seq + "@@" + byit_comorg_code;
					  query += "&&";
					}
                }
            }
        }
    }	      
	$("#confirm1").val(flag+"saveProcess");
	$("#confirm2").val(query);
	$("#confirm3").val(flag);
	$("#confirm4").val("");
	kep_showConfirm(); 
}
 

function kep_showConfirm(){  
    if(!confirm("선택하신 상품을 나의 상품으로 등록하시겠습니까?")){
        return;
    }    
    runProcess();
}
 

/** 
 
 desc ICOMCART
 USE_FLAG	NOT NULL	CHAR(1)	용도구분(A:도안관리,C:장바구니,D:,R:나의상품)
 장바구니 담기
 
 */
function runProcess() {  	
	
	var gubun = $("#confirm1").val();
	var query = $("#confirm2").val(); 	 

	if (gubun == "CsaveProcess"){ // 장바구니 		
	}else if (gubun == "RsaveProcess"){ // 나의상품 		
	}  		 	
	document.forms.processForm.st_use_flag.value = "R"; 
	document.forms.processForm.st_query2.value = query;
	///kr/customer/categ_search/buyer_shoppingcart_new_reg.jsp
	kepAjaxFormCall("/mdcm/saveBuyerMdCmGoodsLisList.do","processForm",gubun); 
}
  



/**
 * 삭제
 */
function setCartDelete(){
 
    var tot_cnt     =  $("#display_item_cnt").val();
    var chk_cnt     = 0;
    var query       = "";     
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
/**
 * KEPPROJECT
 * @author 최진수
 * @programid CJS00002 start
 * @remark KRHONG0020 일 경우 setCartDelete() 에서 전체 삭제에 대한 확인을 한다.
 * @date 2014-04-04
 */

        var buyer       =  $("#st_buyer").val(); 
        allDelFlag      = "N";
        if( tot_cnt == chk_cnt ) allDelFlag = "Y";        

        if(buyer == "KRHONG0020" && allDelFlag == "Y") {
            chk_str = "전체품목을 삭제할 경우 주문내역 화면으로 이동합니다.\n삭제하시겠습니까?";
        }
        else {
            chk_str = "선택된 상품을 장바구니에서 삭제하시겠습니까?";
        }

        ok = confirm(chk_str);
/* @programid CJS00002 end */
        if(ok){
            if(eval(tot_cnt) < 2){
                var box = eval("document.forms.contentForm.lnCheck0");
                var st_item_no          = document.forms.contentForm.st_item_no.value;
                //var st_order_qty        = document.forms.contentForm.st_order_qty.value;
                var st_contract_no      = document.forms.contentForm.st_contract_no.value;
                var st_contract_seq     = document.forms.contentForm.st_contract_seq.value;
                var st_agent_code       = document.forms.contentForm.st_agent_code.value;
                var st_byit_comorg_code = document.forms.contentForm.st_byit_comorg_code.value;

                if(box.checked == true){
                    query = st_item_no + "@@" + st_agent_code + "@@" + st_contract_no + "@@" + st_contract_seq + "@@" + st_byit_comorg_code + "@@"  + "C" + "&&";
                }
            }else{
                for(var j = 0; j < tot_cnt; j++){
                    var box = eval("document.forms.contentForm.lnCheck" + j);
                    var st_item_no          = document.forms.contentForm.st_item_no[j].value;
                    //var st_order_qty        = document.forms.contentForm.st_order_qty[j].value;
                    var st_contract_no      = document.forms.contentForm.st_contract_no[j].value;
                    var st_contract_seq     = document.forms.contentForm.st_contract_seq[j].value;
                    var st_agent_code       = document.forms.contentForm.st_agent_code[j].value;
                    var st_byit_comorg_code = document.forms.contentForm.st_byit_comorg_code[j].value;

                    if(box.checked == true){
                        query += st_item_no + "@@" + st_agent_code + "@@" + st_contract_no + "@@" + st_contract_seq + "@@" + st_byit_comorg_code + "@@" + "C";
                        query += "&&";
                    }
                }
            }            
            document.forms.processForm.next_status.value = "DELETE";
            document.forms.processForm.st_update.value = query; 
            //"/kr/customer/categ_search/buyer_shoppingcart_mycart_del_reg.jsp
    
        	kepAjaxFormCall("/mpso/removeBuyerShoppingcartMycartDelReg.do","processForm","DELETE"); 

        }else{
             return;
        }
    }
}


function setExcelDown()
{
    var tot_cnt  = $("#display_item_cnt").val(); 
    var query   = ""; 
    if(eval(tot_cnt) == 0)
    {
        alert("조회한 데이타가 없습니다.");
        return;
    }
    
	document.forms.searchForm.action = "/mpso/excelBuyerMpSoCartMyungWhaList.do";
	document.forms.searchForm.submit();
    
	//$('#searchForm').attr("action", "/mpso/excelBuyerMpSoCartMyungWhaList.do").submit();    
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
            //var st_agent_code = document.forms.contentForm.st_agent_code.value;
            //var st_byit_comorg_code = document.forms.contentForm.st_byit_comorg_code.value;

            if(box.checked == true){
                query = st_item_no + st_contract_no  + st_contract_seq + "@@";
            }
        }else{
            for(var k = 0; k < tot_cnt; k++){
                var box = eval("document.forms.contentForm.lnCheck" + k);
                var st_item_no   = document.forms.contentForm.st_item_no[k].value;
                var st_contract_no = document.forms.contentForm.st_contract_no[k].value;
                var st_contract_seq = document.forms.contentForm.st_contract_seq[k].value;
                //var st_agent_code = document.forms.contentForm.st_agent_code[k].value;
                //var st_byit_comorg_code = document.forms.contentForm.st_byit_comorg_code[k].value;

                if(box.checked == true){
                    query += st_item_no + st_contract_no  + st_contract_seq + "@@"; 
                }
            }
        }
    }//end else
    	
    	
    	

   if(buyer=="KRFUJI0002") {	   
	   reportOpen("RD_06_B_001_00","["+query+"]["+buyer+"]["+user_id+"]");
      // window.open("/kr/customer/sheet/cart_print_t_xerox_report.jsp?cart_query="+query+"&buyer="+buyer+"&user_id="+user_id,"cartWin","width=700,height=700,resizable=YES,scrollbars=YES,top=0,left=0");
    }else if(buyer=="KRKOLO0033") {
        rd_onload(query);
    }else {
    	 reportOpen("RD_06_B_001_11","["+query+"]["+buyer+"]["+user_id+"]");
    	//buyerMpSoCartListReport(buyer,"["+query+"]["+buyer+"]["+user_id+"]"); 
        //window.open("/kr/customer/sheet/cart_print.jsp?cart_query="+query+"&buyer="+buyer+"&user_id="+user_id,"cartWin","width=700,height=700,resizable=YES,scrollbars=YES,top=0,left=0");
    }
}

//코오롱 전산기기 견적제안서
function rd_onload(query) { 
    reportOpen("RD_06_B_001_14","["+query+"]");
    //window.open("/kr/customer/sheet/cart_print_krkolo0033_sheet.jsp?cart_query="+query, "krkolo0033Sheet", "width="+scr_width+", height="+scr_height+"");
}


/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
	

	var sMsg = response.msg.MSG;   
	var tot_cnt  = $("#display_item_cnt").val();
	var query = "";
	 
	
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

                  if(box.checked == true){
                      query += st_item_no + st_contract_no + st_contract_seq + "@@";
                  }
              }else{

                  for(var j = 0; j < tot_cnt; j++){
                      var box = eval("document.forms.contentForm.lnCheck" + j);
                      var st_item_no   = document.forms.contentForm.st_item_no[j].value;
                      var st_contract_no = document.forms.contentForm.st_contract_no[j].value;
                      var st_contract_seq = document.forms.contentForm.st_contract_seq[j].value;

                      if(box.checked == true){ 
                          query += st_item_no + st_contract_no + st_contract_seq + "@@";
                      }
                  }//END FOR
              }//END IF

               
              document.forms.locationForm.st_query_cart.value = query;  
              document.forms.locationForm.st_verif_num.value = document.forms.searchForm.st_verif_num.value;  
              
              // 질문 -- 배송정보
              //document.forms.contentForm.action = "/kr/customer/shopping_cart/buyer_delivery_info.jsp";
              //alert("buyer_delivery_info 로 이동");               
              //PG_06_B_007_00
              $('#locationForm').attr("action", "<%=h_sslurl2%>/mpso/getBuyerMpSoDlvryInfo.do").submit();   

           }else if(pMethod == "ORDER"){
               if(eval(tot_cnt) < 2){
                    var box = eval("document.forms.contentForm.lnCheck0");
                    var st_item_no   = document.forms.contentForm.st_item_no.value;
                    var st_contract_no = document.forms.contentForm.st_contract_no.value;
                    var st_contract_seq = document.forms.contentForm.st_contract_seq.value;

                    if(box.checked == true){
                        query += st_item_no + st_contract_no + st_contract_seq + "@@";
                    }
               }else{
                    for(var j = 0; j < tot_cnt; j++){
                       var box = eval("document.forms.contentForm.lnCheck" + j);
                       var st_item_no   = document.forms.contentForm.st_item_no[j].value;
                       var st_contract_no = document.forms.contentForm.st_contract_no[j].value;
                       var st_contract_seq = document.forms.contentForm.st_contract_seq[j].value;

                       if(box.checked == true){
                        query += st_item_no + st_contract_no + st_contract_seq + "@@";
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
              
              // 질문
             // document.forms.contentForm.action = "/kr/customer/shopping_cart/buyer_delivery_list.jsp";     
             //alert("buyer_delivery_list 로 이동"); 
             //PG_06_B_008_00
              $('#locationForm').attr("action", "/mpso/getBuyerMpSoOrderInfoList.do").submit();   
              
           }else if(pMethod == "PrSheet") {
        	   
        	   cartPrSheet();
              
           }else if(pMethod == "SAVE") {
        	   
        	   
               alert(" 정상적으로 저장되었습니다.");
             	 // 처리후 재조회
             	 kepSearch($("#curPage").val()); 
          	 
           }else if(pMethod == "DELETE") { // asis setResulte -- 삭제
        	   
        	  alert(" 정상적으로 삭제되었습니다.   "); 
              kepSearch($("#curPage").val()); 
 
        	    
           }
    	  
      } else {
    	  
         if(pMethod == "RsaveProcess")
          {
        	 alert("품목코드 (" + sMsg + ") 은 이미 나의 상품으로 저장된 항목입니다.  ");
          } else {
        	  
          }
         
     	 // 처리후 재조회
     	 kepSearch($("#curPage").val());
         
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
