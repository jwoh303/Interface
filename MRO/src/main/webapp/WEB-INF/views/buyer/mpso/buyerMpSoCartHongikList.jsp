<%--
**********************************************
* 메뉴 : 주문관리>물품담기(홍익대용)
* 화면 : 물품담기(홍익대용)
* 기능 : 홍익대전용 장바구니
* 프로그램 ID : PG_06_B_011_00
* 담당자 : CEJ ( 설계 : 김지현 ) -- GRAD05
* 착수일 : 2014-06-09
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
	String Hdata_FLAG = (String) request.getAttribute("Hdata"); // 조회된 결과
	
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),""); // 현재페이지  (필수)
	String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),"50");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
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
	
	String SessionComCode = "";
	String byca_comorg_code = ""; 
	String img_view_flag   = "";
	String buyer             = "";
	String user_dept              = "";
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
		user_dept =  CommonUtil.nvl((String)sessionInfo.getDepartment()); 
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
	
    String st_query_cart      = CommonUtil.nvl((String) request.getParameter("st_query_cart"),"");
    if(st_query_cart.equals(""))
    {
        st_query_cart = "ALL";
    }
    String st_image_status   = CommonUtil.nvl((String) request.getParameter("st_image_status"),"");
    if(st_image_status.equals("")){
		if(img_view_flag.trim().equals("N")){  // 20070704 이미지보기 정보 세션에서 가져오기
			st_image_status = "IMAGE_HIDDEN";
		}else{
			st_image_status = "IMAGE_VIEW";
		}
    }
    
    String p060000027 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000027","COL05_DATA"); // KRGEST0001 KRHONG0020 KRKEPB0004
    //---------------------------------
	//홍익대학교-- 대학원 소속 체크.
	String hongikType = "N";
	 //SLOGIC-BEGIN(P06-0000027)
	if(p060000027.equals("TYPE2")){ // KRHONG0020
	    hongikType = Hdata_FLAG;
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
	<h3>물품담기(홍익대용)</h3> 
	<!--조회영역-->
	<form name = "searchForm" id="searchForm" method = "post">
		<!--HIDDEN-->
		<!-- 공통 -->
		<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
		<!-- 화면 내 정의 -->
		<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
		<input type="hidden" name="st_user_dept"          value="<%=user_dept%>">
		 
		<input type="hidden" name="st_image_status"   id="st_image_status" value="<%=st_image_status%>">
		<input type="hidden" name="st_buyer"          value="<%=buyer%>">
		<input type="hidden" name="st_key_flag"       value="">
		<input type="hidden" name="next_status"       value="">
		<input type="hidden" name="st_use_flag"       value="">
		<input type="hidden" name="st_move_flag"      value="">
		<input type="hidden" name="st_query2"         value="">
		<input type="hidden" name="st_update"         value="">
		<input type="hidden" name="st_cart_type"      value="HONG-CART">
		
		<input type="hidden" name="st_zip_code"       value="<%=st_zip_code%>">
		<input type="hidden" name="st_tel_no"         value="<%=st_tel_no%>">
		<input type="hidden" name="st_fax_no"         value="<%=st_fax_no%>">
		<input type="hidden" name="st_mobile_no"      value="<%=st_mobile_no%>">
		<input type="hidden" name="st_user_name"      value="<%=st_user_name%>">
		<input type="hidden" name="st_email"          value="<%=st_email%>">
		<input type="hidden" name="st_user_id"        value="<%=userId%>">
		<input type="hidden" name="st_query_cart"     value="<%=st_query_cart%>">
		<input type="hidden" name="st_recv_date"      value="<%=st_recv_date%>">
		<input type="hidden" name="st_recv_date2"     value="<%=st_recv_date2%>">
		<input type="hidden" name="st_remark"         value="<%=st_remark%>">
		<input type="hidden" name="st_location_type"  value="<%=st_location_type%>">
		<input type="hidden" name="st_location_name"  value="<%=st_location_name%>">
		<input type="hidden" name="st_purchase_dept_name"  value="<%=st_purchase_dept_name%>">
		<input type="hidden" name="st_purchase_dept_code"  value="<%=st_purchase_dept_code%>">
			 
 		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
	      	<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow" onchange="kepSearch(1)"> 
				<option value = "10" <%if ("10".equals(onepagerow)) {%>selected<%} %>>10건</option>
				<option value = "20" <%if ("20".equals(onepagerow)) {%>selected<%} %>>20건</option>
				<option value = "25" <%if ("25".equals(onepagerow)) {%>selected<%} %>>25건</option>
				<option value = "50" <%if ("50".equals(onepagerow)) {%>selected<%} %>>50건</option> 
				<option value = "100" <%if ("100".equals(onepagerow)) {%>selected<%} %>>100건</option> 
				<option value = "200" <%if ("200".equals(onepagerow)) {%>selected<%} %>>200건</option> 
				<option value = "500" <%if ("500".equals(onepagerow)) {%>selected<%} %>>500건</option> 
			</select>
<span class="btn_imghide">
<%  if(st_image_status.equals("IMAGE_HIDDEN")){   %>
<a href="javascript:imageHideView();"  title="이미지보이기" >이미지보이기</a>
<%  }else{   %>
<a href="javascript:imageHideView();"  title="이미지감추기" >이미지감추기</a>
<%  }   %> 
</span>    
      </span>
			<span class="fr">       
  							총금액
				       : <input type="text" name="check_sum_price"   id="check_sum_price"  class="input_type_text"  value="0" style="background-color:#FFFFFF;font-weight: bold;font-size:9pt;border:#FFFFFF 1px solid;text-align:right;" READONLY>&nbsp;
						<input type="hidden" name="st_check_sum_price"  id="st_check_sum_price"  value=""> 
			 
             </span>
       	<br>
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<!-- 공통 -->
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
		<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    		  	
		<table class="cont_t_list02" style="width:100%">
			<colgroup>
	            <col width="3%" />
	            <col width="7%" />
	            <col width="12%" /> 
	            <col width="*" />
	            <col width="15%" />
 				<%
                    if(budget_flag.equals("Y")){
                %>
                        <col width="10%" />
                <%
                    }
                %>	            
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
				<th scope="col"></th>
                <th scope="col">품목코드<br><a href="javascript:setRefNoCopy();">회계항목</a></th>
                <th scope="col">품목명<br>규격</th>
                <th scope="col">협력사<br>단위</th>
 				<%
                    if(budget_flag.equals("Y")){
                %>
                        <th scope="col">계정명<br>예산부서</th>
                <%
                    }
                %>
                <th scope="col">단가<br>구매수량</th>
                 <%
                    if("Y".equals(hongikType)){
                %>
					<th scope="col">구매액<br>대학원 학과</th>
                <%
                    }else{
				%>
					<th scope="col">구매액</th>
                <%
                    }
				%>    
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
				<tr align="center" bgcolor="<%=tclass%>">
					<td>
						<input type="checkbox" name="lnCheck<%=j%>" onclick="chk_sum_price()">	
	                
					</td>
                    <td title="이미지" >
                    
<% if(st_image_status.equals("IMAGE_HIDDEN")){
       if("".equals(CommonUtil.nvl(rowData.get("IMGFILE_DIR")))){
%>
           <img src="/resources/images/but_img_off.gif" border="0">
          <%=(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem.gif>")%>
          <%=(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem1.gif>")%>
 
<%     }else{ %> 
             <a href="javascript:getBigImage('<%=CommonUtil.nvl(rowData.get("IMGFILE_DIR"))%>','<%=CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>');">
             <img src="/resources/images/but_img_on.gif" border="0"></a>
          <%=(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem.gif>")%>
          <%=(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem1.gif>")%> 
 
<%     }
    }else{
    	 if("".equals(CommonUtil.nvl(rowData.get("IMGFILE_DIR")))){
%>
          <img src="/resources/images/noimage.gif" width="80" height="80" border="0">
          <%=(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem.gif>")%>
          <%=(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem1.gif>")%>
 
<%     }else{ %> 
             <a href="javascript:getBigImage('<%=CommonUtil.nvl(rowData.get("IMGFILE_DIR"))%>','<%=CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>');"><img src="<%=CommonUtil.realImgS3UploadPath+"/"+CommonUtil.nvl(rowData.get("IMGFILE_DIR"))+"/"+CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>"  onerror="javasrcipt:this.src='/resources/images/noimage.gif'"  name="image1" width="80" height="80" border="0"></a>
          <%=(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem.gif>")%>
          <%=(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem1.gif>")%>
 
<%     }
    }
%>		
 
				</td>
 				<td class="left">
                    <a class="hyperLink"  href="javascript:getBuyerCatalogDisplayPop('<%=rowData.get("BYIT_COMORG_CODE")%>','<%=rowData.get("BUYER_ITEM_NO")%>','<%=rowData.get("CONTRACT_NO")%>','<%=rowData.get("CONTRACT_SEQ")%>');"><b><font color="#5B5B5B"><%=rowData.get("BUYER_ITEM_NO")%></font></b></a>
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
                <br>
							<a href="javascript:getHongik('<%=j%>','<%=rowData.get("REF_PR_NO")%>');">
								<input type="text" id="st_ref_pr_no_text" name="st_ref_pr_no_text" class="input_type_text" style="cursor:pointer;" value="<%=rowData.get("REF_PR_NAME")%>" readonly>
								<input type="hidden" id="st_ref_pr_no" name="st_ref_pr_no" class="input_type_text" style="cursor:pointer;" value="<%=rowData.get("REF_PR_NO")%>" readonly>
							</a>  
                          </td>
                   
                <td class="left">
                    <%=rowData.get("DESCRIPTION_LOC")%><br>
                    <%=rowData.get("SPECIFICATION")%>
                            <% if(rowData.get("PRODUCT_CLOSE_FLAG").equals("Y")) { %>&nbsp; <% }else if(rowData.get("OVER_SHORT_FLAG").equals("N")) { %>&nbsp; <% } else { %> <br><font color="green">(재 판매일 :<%=CommonUtil.formatStrinigDate(rowData.get("HS_NO"))%>)</font><% } %>
                            

               </td>
                    <td style="padding-right:10px" class="left">&nbsp;<a class="hyperLink"  href="javascript:getAgentDisplayPop('<%=rowData.get("AGENT3")%>');"><%=rowData.get("AGENT")%></a>
                    <br>&nbsp;<%=rowData.get("UNIT_MEASURE")%>
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
                                    <input type="text"   name="st_account_type_name"size="14" value="선택"  style="background-color:<%=tclass%>;font-size:9pt;border:<%=tclass%>;color=#0043A8; 1px solid; cursor:pointer;" READONLY onClick="javascript:getBdgtAccountPop('<%=buyer%>','<%=user_dept%>');">
                <%
                        }else{
                %>
                                    <input type="text"   name="st_account_type_name"size="14" value="<%=rowData.get("ACCOUNT_NAME")%>"  style="background-color:<%=tclass%>;font-size:9pt;border:<%=tclass%>;color=#0043A8; 1px solid; cursor:pointer;" READONLY onClick="javascript:getBdgtAccountPop('<%=buyer%>','<%=user_dept%>');">
                <%
                        }
                %>
                                    <input type="hidden" name="st_account_type" value="<%=rowData.get("ACCOUNT_TYPE")%>">
                                </td>
                            </tr>
                            <tr>
                                <td height="23"  align="center">
                                    <input type="text"   name="st_budget_dept_name"  size="14" value="<%=rowData.get("BUDGET_DEPT_CODE").equals("")?"":rowData.get("BUDGET_DEPT_NAME")%>"  style="background-color:<%=tclass%>;font-size:9pt;border:<%=tclass%> 1px solid;" READONLY>
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


                <td class="right" >
						<% if(rowData.get("FIXED_PRICE_FLAG").equals("N")) { %>
						<input type="text" name="st_order_price" class="input_type_text" size="10"  style="width:85%;cursor:pointer;text-align:right;"  value="<%=CommonUtil.formatNumber(rowData.get("TARGET_PRICE"),true,0,3)%>" onChange="javascript:price_update_P('<%=j%>',this.value,'<%=rowData.get("CART_QTY")%>');" onBlur="this.value=this.value;" onKeyDown="if (event.keyCode == 13) javascript:price_update_P('<%=j%>',this.value,'<%=rowData.get("CART_QTY")%>');">
						<% }else { %>
							<%=CommonUtil.formatNumber(rowData.get("TARGET_PRICE"),true,0,3)%>
							<input type="hidden" name="st_order_price" value="<%=CommonUtil.formatNumber(rowData.get("TARGET_PRICE"),true,0,3)%>">
						<% } %>
						<input type="hidden" name="st_fixed_price_flag" value="<%=rowData.get("FIXED_PRICE_FLAG")%>">
								  
						<input type="text" name="st_order_qty" class="input_type_text"  style="width:85%;cursor:pointer;text-align:right;"  size="7" value="<%=CommonUtil.formatNumber(rowData.get("CART_QTY"),true,0,3)%>" onChange="javascript:price_update(this.value,'<%=j%>','<%=rowData.get("TARGET_PRICE")%>','<%=rowData.get("CART_QTY")%>');" onBlur="this.value=this.value;" onKeyDown="if (event.keyCode == 13) javascript:price_update(this.value,'<%=j%>','<%=rowData.get("TARGET_PRICE")%>','<%=rowData.get("CART_QTY")%>');">
                      </td>        
<!-- 홍익대학교-- 대학원 소속 체크.	-->	   
                <%
                if("Y".equals(hongikType)){
                %>
                <td  class="right" >                    
					   <input type="text" name="st_sum_price" size="10" value="<%=CommonUtil.formatNumber(rowData.get("TOT_SUM"),true,0,3)%>"  style="background-color:<%=tclass%>;font-weight: bold;font-size:9pt;border:<%=tclass%> 1px solid; text-align:right;" READONLY>                                          
						<a href="javascript:getHongIkDeptCode('<%=j%>');"><input type="text" name="st_ref_pr_dept_name" class="input_type_text" style="cursor:pointer;" size="14" value="<%=rowData.get("HI_DEPT_NAME")%>" READONLY></a>
				 </td>       
                <%
                    }else{
				%>
                <td class="right" >
					<input type="text" name="st_sum_price" size="10" value="<%=CommonUtil.formatNumber(rowData.get("TOT_SUM"),true,0,3)%>"  style="background-color:<%=tclass%>;font-weight: bold;font-size:9pt;border:<%=tclass%> 1px solid; text-align:right;" READONLY>
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
			<span class="cl">[ 총 <%=total_cnt %> 건 ]</span> 
		</p>  
		<!-- 버튼영역 -->
		<div class="btnArea">
        	<div class="fl">
        	<%  if(budget_flag.equals("Y")){    %>
        		<span class="btn_04 mr04">
					<a href="javascript:doAction('getBudgetList');">예산내역조회</a>
				</span>
				<%  }   %> 
			</div>
			<div class="fr">
				<span class="btn_04 mr04">
					<a href="javascript:doAction('SAVE');">저장</a>
				</span> 
				<span class="btn_04">
					<a href="javascript:doAction('setCartDelete');">삭제</a>
				</span>					
            </div>
        </div>
</form>

<form name="processForm" id="processForm" method="post">	 
	<input type="hidden" name="st_update" id="st_update"  value=""/>
 	<input type="hidden" name="next_status"    id="next_status"  value=""/>
 	<input type="hidden" name="st_cart_type"      value="HONG-CART">
 			<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
</form>
</div>

<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>   
</div>
</body>

<script type="text/javascript">
var popupSel = ""; 

//최초 화면 함수 
function kep_onload_view(){
 
}


//기능함수
var str = "";
function doAction(str) {	 
	
	switch (str) { 
	
		case "SAVE":  
			item_qty_update('SAVE');
			break;  
	
		case "getBudgetList":  
			getBudgetList();
			break;  
			
		case "setCartDelete":  
			setCartDelete();
			break;   
	}
}

//조회
function kepSearch(curPage) {

	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mpso/getBuyerMpSoCartHongikList.do").submit();   
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

 

 
//--홍익대 회계항목 설정 PG_06_B_006_07
function getHongik(row,ref_no){ 

	var buyer  =  "<%=buyer%>"; 	
	var tot_cnt  = $("#display_item_cnt").val();
	
	if(eval(tot_cnt) < 2){
        var box = eval("document.forms.contentForm.lnCheck0");
        box.checked =true;
        ref_no = kepTrimStr(document.forms.contentForm.st_ref_pr_no.value);
    }else{
        var box = eval("document.forms.contentForm.lnCheck" + row);
        box.checked =true;
        ref_no = kepTrimStr(document.forms.contentForm.st_ref_pr_no[row].value);
    }
    
    openSearchPopup("/mpso/showBuyerMpSoHongikAccntngItemPop.do","?open=Y&st_buyer="+buyer+"&st_row="+row+"&st_ref_no="+ref_no , "500,200,no"); 
    
    //window.open('/kr/customer/shopping_cart/refno_hongik.jsp?st_buyer='+buyer+"&st_row="+row+"&st_ref_no="+ref_no, 'getDoos0013', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
}

function setHongik(ref_no, row,ref_no_text)  {
	var tot_cnt  = $("#display_item_cnt").val();

   var box = eval("document.forms.contentForm.lnCheck" + row);
   box.checked =true;

    //alert(tot_cnt);
    if(eval(tot_cnt) < 2)     {
      document.forms.contentForm.st_ref_pr_no_text.value = ref_no_text;
      document.forms.contentForm.st_ref_pr_no.value = ref_no;
      var box = eval("document.forms.contentForm.lnCheck0");
      box.checked =true;
    } else{
      for(var x=0; x<eval(tot_cnt); x++) {
          var box = eval("document.forms.contentForm.lnCheck" + x);
          if(box.checked==true) {
              document.forms.contentForm.st_ref_pr_no_text[x].value = ref_no_text;
              document.forms.contentForm.st_ref_pr_no[x].value = ref_no;
          }
      } 
    }
  }


//홍익대학교-- 대학원 소속 체크. PG_06_B_006_30
function getHongIkDeptCode(row){ 

  var buyer                = "<%=buyer%>";
  var user_id             = "<%=userId%>";
  var tot_cnt  =$("#display_item_cnt").val();

  if(eval(tot_cnt) < 2)  {
      var box = eval("document.forms.contentForm.lnCheck0");
      box.checked =true;
  } else{
      var box = eval("document.forms.contentForm.lnCheck" + row);
      box.checked =true;
  }
  openSearchPopup("/mpso/showBuyerMpSoGraduateDetailDeptCodePop.do","?open=Y&st_buyer=" + buyer+"&st_row="+row+"&st_user_id="+user_id , "500,500,no"); 

}
function setHongIkDeptCode(dept_code,dept_name, row){
  var tot_cnt  = $("#display_item_cnt").val();
  if(eval(tot_cnt) < 2)  {
    document.forms.contentForm.st_ref_pr_dept.value = dept_code;
    document.forms.contentForm.st_ref_pr_dept_name.value = dept_name;
    var box = eval("document.forms.contentForm.lnCheck0");
    box.checked =true;
  } else{
    for(var x=0; x<eval(tot_cnt); x++) {
        var box = eval("document.forms.contentForm.lnCheck" + x);
        if(box.checked==true) {
            document.forms.contentForm.st_ref_pr_dept[x].value = dept_code;
            document.forms.contentForm.st_ref_pr_dept_name[x].value = dept_name;
        }
    }
  }
}

 



//예산계정 선택 팝업
function getBdgtAccountPop(com_code,dept_code,row)
{ 
 var tot_cnt  = $("#display_item_cnt").val();   
  
 //var order_qty = "";
 //var order_price = "";
 //var description = "";
 var box = "";
 var cart_sum_price =$("#st_check_sum_price").val();  
 
 if(eval(tot_cnt) < 2){
     box = eval("document.forms.contentForm.lnCheck0" );
     box.checked =true;
     order_qty = document.forms.contentForm.st_order_qty.value;
     order_price = document.forms.contentForm.st_order_price.value;
     description = document.forms.contentForm.st_description.value;
 }else{
     box = eval("document.forms.contentForm.lnCheck" + row);
     box.checked =true;
     order_qty = document.forms.contentForm.st_order_qty[row].value;
     order_price = document.forms.contentForm.st_order_price[row].value;
     description = document.forms.contentForm.st_description[row].value;
 }
 chk_sum_price(); 
  
 var val = ""; 
 openSearchPopup("/mpso/showBuyerMpSoAccountSelPop.do","?open=Y&com_code=" + com_code+"&dept_code="+dept_code+"&st_cart_sum_price="+cart_sum_price , "750,500,no"); 
 
 return;
}

//예산계정 설정
function setBdgtAccount(account_type , account_name, dept_code , dept_name, mg_code, mg_note){

	
	//alert("account_type "+account_type +"account_name "+ account_name +"dept_code "+ dept_code +"dept_name "+ dept_name +"mg_code "+ mg_code+"mg_note "+ mg_note);

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

//홍익대학교-- 대학원 소속 체크. PG_06_B_006_30
function getHongIkDeptCode(row){ 

    var buyer                = "<%=buyer%>";
    var user_id             = "<%=userId%>";
    var tot_cnt  =$("#display_item_cnt").val();

    if(eval(tot_cnt) < 2)  {
        var box = eval("document.forms.contentForm.lnCheck0");
        box.checked =true;
    } else{
        var box = eval("document.forms.contentForm.lnCheck" + row);
        box.checked =true;
    }
    openSearchPopup("/mpso/showBuyerMpSoGraduateDetailDeptCodePop.do","?open=Y&st_buyer=" + buyer+"&st_row="+row+"&st_user_id="+user_id, "500,500,no"); 

}
function setHongIkDeptCode(dept_code,dept_name, row){
    var tot_cnt  = $("#display_item_cnt").val();
    if(eval(tot_cnt) < 2)  {
      document.forms.contentForm.st_ref_pr_dept.value = dept_code;
      document.forms.contentForm.st_ref_pr_dept_name.value = dept_name;
      var box = eval("document.forms.contentForm.lnCheck0");
      box.checked =true;
    } else{
      for(var x=0; x<eval(tot_cnt); x++) {
          var box = eval("document.forms.contentForm.lnCheck" + x);
          if(box.checked==true) {
              document.forms.contentForm.st_ref_pr_dept[x].value = dept_code;
              document.forms.contentForm.st_ref_pr_dept_name[x].value = dept_name;
          }
      }
    }
  }
  

//예산내역 조회 PG_06_B_006_60
function getBudgetList(){    
	openSearchPopup("/mpso/showBuyerMpSoBudgetListPop.do","", "1000,500,no"); 

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
 
	
    var tot_cnt  =  $("#display_item_cnt").val();
    var chk_cnt  = 0;
    var query    = "";
    //var next_status = next_status;
    //var buyer = document.forms.searchForm.st_buyer.value;

    var budget_flag = "<%=budget_flag%>";
    var hongik_flag = "<%=hongikType%>";

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
        var box = eval("document.contentForm.lnCheck0" );
        var st_item_no              = document.forms.contentForm.st_item_no.value;
        var st_order_qty            = kepTrimStr(document.forms.contentForm.st_order_qty.value);
        var st_ref_pr_no            = document.forms.contentForm.st_ref_pr_no.value;
        var st_contract_no          = document.forms.contentForm.st_contract_no.value;
        var st_contract_seq			= document.forms.contentForm.st_contract_seq.value;
        var st_fixed_price_flag		= document.forms.contentForm.st_fixed_price_flag.value;
        var st_order_price          = document.forms.contentForm.st_order_price.value;
        var st_account_type			= document.forms.contentForm.st_account_type.value;
        var st_budget_dept          = document.forms.contentForm.st_budget_dept.value;
        var product_close_flag		= document.forms.contentForm.st_product_close_flag.value;
		var process_type				= document.forms.contentForm.st_process_type.value;
		var stock_item_flag			= document.forms.contentForm.st_stock_item_flag.value;
		var ref_pr_dept			= document.forms.contentForm.st_ref_pr_dept.value;
		var remark					= "NO_REMARK";


        if(box.checked == true){

            if(product_close_flag == "Y"){
                alert("해당 품목은 단종되었습니다.");
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

			if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
				alert("회계항목이 선택되지 않았습니다.\n"+"회계항목란을 클릭하여 선택하여 주십시요.");
				return;
			}	
			if(hongik_flag == "Y"&&(ref_pr_dept == "" || ref_pr_dept == "null" || ref_pr_dept == null || ref_pr_dept == " ")){
				alert("대학원 학과가 선택되지 않았습니다.\n\n대학원 학과란을 클릭하여 선택하여 주십시요.");
				return;			
			}		
		
            if(budget_flag == "Y" && (next_status == "CART" || next_status =="ORDER")){
                if(isEmpty(st_account_type) || isEmpty(st_budget_dept)){
                    alert("예산 적용 부서 및 계정을 선택해 주십시요");
                    return;
                }
            }

			query += st_item_no + "@@" + st_order_qty + "@@" + st_ref_pr_no + "@@"+ st_contract_no + "@@" + st_contract_seq + "@@" + st_fixed_price_flag + "@@" + kepFilterNum(st_order_price) + "@@" + st_account_type + "@@" + st_budget_dept + "@@"+remark+ "@@"+ref_pr_dept+ "@@"+""+ "@@"+"";;
            query += "|";
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
            var process_type			= document.forms.contentForm.st_process_type[j].value;
            var stock_item_flag			= document.forms.contentForm.st_stock_item_flag[j].value;  
            var ref_pr_dept			= document.forms.contentForm.st_ref_pr_dept[j].value;   
			var remark					= "NO_REMARK";

            if(box.checked == true){

                if(product_close_flag == "Y"){
                   alert((j+1)+"번째 품목은 단종되었습니다.");
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

				if(st_ref_pr_no == "" || st_ref_pr_no == "null" || st_ref_pr_no == null || st_ref_pr_no == " "){
					alert("회계항목이 선택되지 않았습니다.\n"+"회계항목란을 클릭하여 선택하여 주십시요.");
					return;
				}

				if(hongik_flag == "Y"&&(ref_pr_dept == "" || ref_pr_dept == "null" || ref_pr_dept == null || ref_pr_dept == " ")){
					alert("대학원 학과가 선택되지 않았습니다.\n\n대학원 학과란을 클릭하여 선택하여 주십시요.");
					return;			
				}		

                if(budget_flag == "Y" && (next_status == "CART" || next_status =="ORDER")){
                    if(isEmpty(st_account_type) || isEmpty(st_budget_dept)){
                        alert((j+1) + " 번째 품목의 예산 적용 부서 및 계정을 선택해 주십시요");
                        return;
                    }
                }

                query += st_item_no + "@@" + st_order_qty + "@@" + st_ref_pr_no + "@@"+ st_contract_no + "@@" + st_contract_seq + "@@" + st_fixed_price_flag + "@@" + kepFilterNum(st_order_price) + "@@" + st_account_type + "@@" + st_budget_dept + "@@"+remark+ "@@"+ref_pr_dept+ "@@"+""+ "@@"+"";
                query +=  "|";
            }
        }
    } 
    document.forms.processForm.next_status.value = next_status;
    document.forms.processForm.st_update.value = query;   

	kepAjaxFormCall("/mpso/saveBuyerShoppingcartQtyUpdate.do","processForm","SAVE"); 

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
                   var box = eval("document.contentForm.lnCheck0" );
                   var st_item_no   = document.forms.contentForm.st_item_no.value;
                   var st_order_qty = document.forms.contentForm.st_order_qty.value;
                   var st_contract_no = document.forms.contentForm.st_contract_no.value;
                   var st_contract_seq = document.forms.contentForm.st_contract_seq.value;
                   var st_agent_code = document.forms.contentForm.st_agent_code.value;
                   var st_byit_comorg_code = document.forms.contentForm.st_byit_comorg_code.value;

                   if(box.checked == true){
                          query = st_item_no + "@@" + st_agent_code + "@@" + st_contract_no + "@@" + st_contract_seq + "@@" + st_byit_comorg_code + "@@"  + "C" +  "&&";
                   }
              }else{
                   for(var j = 0; j < tot_cnt; j++){
                       var box = eval("document.contentForm.lnCheck" + j);
                       var st_item_no   = document.forms.contentForm.st_item_no[j].value;
                       var st_order_qty = document.forms.contentForm.st_order_qty[j].value;
                       var st_contract_no = document.forms.contentForm.st_contract_no[j].value;
                       var st_contract_seq = document.forms.contentForm.st_contract_seq[j].value;
                       var st_agent_code = document.forms.contentForm.st_agent_code[j].value;
                       var st_byit_comorg_code = document.forms.contentForm.st_byit_comorg_code[j].value;

                       if(box.checked == true){
                            query += st_item_no + "@@" + st_agent_code + "@@" + st_contract_no + "@@" + st_contract_seq + "@@" + st_byit_comorg_code + "@@" + "C";
                            query +=  "&&";
                       }
                   }
              }
 
              //document.forms.contentForm.action = "/kr/customer/categ_search/buyer_shoppingcart_mycart_del_reg.jsp?st_query=" + query;
 
               
            document.forms.processForm.st_update.value = query;   

          	kepAjaxFormCall("/mpso/removeBuyerShoppingcartMycartDelReg.do","processForm","DELETE"); 

         }else{
              return;

         }
    }
}



/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){

	//var sMsg = response.msg.MSG;   
	//var tot_cnt  = $("#display_item_cnt").val(); 
	 
	
  if(pMethod == "SAVE") {	  	  
		  var con = confirm("정상적으로 저장되었습니다.\n\n주문내역페이지로 이동하시겠습니까?");
		  if(con)	{
			   
				//url	="/kr/customer/shopping_cart/hongik_shoppingorder_list.jsp";
		  	 	$('#contentForm').attr("action", "/mpso/getBuyerMpSoOrderDetailHongikList.do").submit();    
		  }else{
			  kepSearch($("#curPage").val());       
		  }
		 
	 } else if(pMethod == "DELETE") {	  	   
			  kepSearch($("#curPage").val());       
	 } 
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {

	if (pMethod == "SAVE"){ 
		 alert("저장 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
	}else if(pMethod == "DELETE") {	  	   
		 alert("삭제 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
	} 
	 
	
} 

//상품 큰이미지
function getBigImage(file_dir, file_name){
	getBigImageView("<%= CommonUtil.getURL(request) %><%=CommonUtil.realImgS3UploadPath%>", file_dir, file_name);
}

</script>
</html>
