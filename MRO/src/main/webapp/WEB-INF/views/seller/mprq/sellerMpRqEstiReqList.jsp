<%--
**********************************************
* 메뉴 : 협력사 > 견적관리
* 화면 : 견적의뢰 접수(예)
* 기능 : KeP에서 협력사에 요청한 견적요청내역을 조회하고 요청접수를 하거나 견적포기 처리를 한다
* 프로그램 ID : PG_04_A_001_00
* 담당자 : 김영미(설계:권우재)
* 생성일 : 2014-07-28
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!doctype html>
<html>
<head>
<%@include file="../../common/include/head.jspf" %>
</head>
<script type="text/javascript" src="/resources/js/kep_main_common.js" ></script>
<script type="text/javascript" src="/module/crosscert/ccc-sample/init.js"></script>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과
String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
String onepagerow = (String) request.getParameter("onepagerow");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
String msg = CommonUtil.nvl( (String)request.getAttribute("msg"),""); // 결과
String com_code = CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
int page_display_cnt = 0;
%> 

<body onload="kep_onload_view()">
<div id="wrapper"> 
<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
<c:import charEncoding="utf-8" url="/menu/menu.do" >
<c:param name="page" value="sellerHeader"/>
<c:param name="part" value="header"/>
</c:import>
<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
<div id="container2">  
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="sellerLeft"/>
<c:param name="part" value="${param.upperId}" />
</c:import>
<!--내용 시작-->		

        <div id="ContArea">
        	<h3>견적요청 접수</h3>
        	<div style="height:30px;"></div>
            <!--조회영역-->
	  	<form name = "searchForm" id="searchForm" method = "post">
   			<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
   			<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">
			<input type="hidden" name="agent" id="agent" value="${sessionInfo.comCode}">
	  		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
	       	<label for="b_no02" class="hidden">정렬개수선택</label>
				<select id="onepagerow"  name="onepagerow" onChange="javascript:kepSearch(1)">
					<option value = "10" <%if ("10".equals(onepagerow)) {%>selected<%} %>>10건</option>
					<option value = "20" <%if ("20".equals(onepagerow)) {%>selected<%} %>>20건</option>
					<option value = "30" <%if ("30".equals(onepagerow)) {%>selected<%} %>>30건</option>
					<option value = "40" <%if ("40".equals(onepagerow)) {%>selected<%} %>>40건</option>
					<option value = "50" <%if ("50".equals(onepagerow)) {%>selected<%} %>>50건</option> 
				</select>
	       	</span>
	        <span class="fr">총건수 <%=total_cnt %></span>
		</form>
		<br>                    
                
 		 <form name = "contentForm" method = "post">
		 <input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
		 <input type="hidden" name="userId" id="userId" value="${sessionInfo.userId}">
		 <input type="hidden" id="originData" name = "originData" size="40" >
            	<!--grid-->
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>견적요청 접수</caption>
                    <colgroup>
                        <col width="3%" />
                        <col width="10%" />
                        <col width="9%" />
                        <col width="9%" />
                        <col width="8%" />
                        <col width="*" />
                        <col width="7%" />
                        <col width="5%" />
                        <col width="5%" />
                        <col width="7%" />
                        <col width="4%" />
                        <col width="5%" />
                        <col width="4%" />
                        <col width="4%" />
                        <col width="4%" />
                    </colgroup>
                    <thead>
				        <tr>
				          <th rowspan="2"><input type="checkbox" name="check_status" id="check_status" value="선택"  style="cursor:hand;" onclick="kepCheckAll(document.forms.contentForm.display_item_cnt.value,document.forms.contentForm.check_status,'document.forms.contentForm.checkbox')"> </th>
				          <th >고객사</th>
				          <th >진행상태</th>
				          <th >견적요청일</th>
				          <th >품목코드</th>
				          <th >품목명</th>
				          <th >제조사</th>
				          <th>조달일수</th>
				          <th >제출단가<br>(VAT별도)</th>
				          <th >KeP담당자</th>
				          <th >MSDS</th>
				          <th >이미지필수</th>
				          <th >납품지역</th>
				          <th >MOQ</th>
				          <th >과세구분</th>
				        </tr>
				        <tr>
				          <th >견적번호</th>
				          <th >순번</th>
				          <th >견적마감일</th>
				          <th >모델번호</th>
				          <th >규격</th>
				          <th >원산지</th>
				          <th>수량/단위</th>
				          <th >금액합계</th>
				          <th>운영사비고/파일</th>
				          <th >파일첨부</th>
				          <th >이미지첨부</th>
				          <th >거래유형</th>
				          <th >발주배수</th>
				          <th></th>
				        </tr>
                    </thead>
                    <tbody>
				 		<%
				        if (_gridList == null || _gridList.size() == 0){
				        %>
				                            <tr bgcolor="#FFFFFF">
				                        <td colspan="15" align="center" height = "50"> 
				                        <span>조회된 데이타가 없습니다.</span>
				                        </td> 
				                    </tr>
				        <%
				        }else{
				        	
				        	String aaa=null;
				            
							for (int j=0; j<_gridList.size(); j++) {
								Map<String,String> rowData = _gridList.get(j);
								String  tclass = (j % 2 != 0)? "#FFFFFF" : "#D5D5D5";
								
								page_display_cnt++;
						%> 

							<tr align="center" bgcolor="<%=tclass%>">
					          <td  rowspan="2">
					          	<input type="checkbox" name="checkbox" id="checkbox<%=j%>">
					          	<input type="hidden" id="st_irs_no" name="st_irs_no" value="<%=CommonUtil.nvl(rowData.get("AGENT_IRS_NO"))%>" />
						        <input type="hidden" name="st_buyer"  id="st_buyer"            value="<%=rowData.get("BUYER") %>">
						        <input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
						        <input type="hidden" name="st_user_name" id="st_user_name" value="${sessionInfo.userNameLoc}">
						        <input type="hidden" name="st_user_tel" id="st_user_tel" value="${sessionInfo.tel}">
						        <input type="hidden" name="st_quotation_no"  id="st_quotation_no"   value="<%=rowData.get("QUOTATION_NO") %>">
						        <input type="hidden" name="st_quotation_seq"  id="st_quotation_seq"    value="<%=rowData.get("QUOTATION_SEQ") %>">
						        <input type="hidden" name="st_revision"   id="st_revision"        value="<%=rowData.get("REVISION")%>">
						        <input type="hidden" name="st_agent"     id="st_agent"         value="<%=rowData.get("AGENT") %>">
						        <input type="hidden" name="st_agent_revision"  id="st_agent_revision"    value="<%=rowData.get("AGENT_REVISION")%>">
						        <input type="hidden" name="st_cert_yn"    id="st_cert_yn"       value="<%=rowData.get("CERT_CHECK") %>">
						        <input type="hidden" name="st_moq_use_flag"    id="st_moq_use_flag"       value="<%=rowData.get("MOQ_USE_FLAG") %>">
						        <input type="hidden" name="st_deli_area_use_flag"    id="st_deli_area_use_flag"       value="<%=rowData.get("DELI_AREA_USE_FLAG") %>">
						        <input type="hidden" name="st_process_type_flag"    id="st_process_type_flag"       value="<%=rowData.get("PROCESS_TYPE_FLAG") %>">
						        <input type="hidden" name="st_giveup_yn"     id="st_giveup_yn"      value="N">
						        <input type="hidden" name="st_stoa_date"	id="st_stoa_date"	value="<%=rowData.get("STOA_DATE") %>">
						        <input type="hidden" name="st_stoa_time"	id="st_stoa_time"	value="<%=rowData.get("STOA_TIME") %>">
						        <input type="hidden" name="st_buyer_item_no"     id="st_buyer_item_no"      value="<%=rowData.get("BUYER_ITEM_NO") %>">
						        <input type="hidden" name="st_imgfile_dir"     id="st_imgfile_dir"      value="">
						        <input type="hidden" name="st_imgfile_name"     id="st_imgfile_name"      value="">
						        <input type="hidden" name="st_plant"  id="st_plant"            value="<%=rowData.get("PLANT") %>">
						      
						        
<%-- 						        <input type="hidden" name="st_agent_irs_no"     value="<%=rowData.get("AGENT_IRS_NO") %>"> --%>
					          </td>
					          <td ><%=rowData.get("BUYER_NAME") %>&nbsp;<%=rowData.get("PLANT_NAME") %></td>
					          <td>
					<%
					      if(rowData.get("SOURCING_STATUS").equals("신규견적")) {
					%>
					            <%=rowData.get("SOURCING_STATUS") %>
					<%
					      }else {
					%>
					            <a class="hyperLink" href="javascript:AgentSourcingHistory('<%=rowData.get("BUYER") %>','<%=rowData.get("QUOTATION_NO") %>','<%=rowData.get("QUOTATION_SEQ") %>','<%=rowData.get("REVISION") %>','<%=rowData.get("AGENT") %>');"><%=rowData.get("SOURCING_STATUS") %></a>
					<%
					      }
					%>
					<!-- SLOGIC-BEGIN(P04-4040-02) -->
					<%
					      if(rowData.get("BUYER").equals("KRHITE0006") || rowData.get("BUYER").equals("KRFAGB0002")) {
					%>
					            (<%=rowData.get("BUYER_NAME") %>)
					<!-- SLOGIC-END -->
					<%
					      }
					
							if(rowData.get("STOA_DATE").equals("") && rowData.get("STOA_TIME").equals("")) {
					%>
					
							<b><font color="blue">(미제출)</font></b>
					<%
							}else {
					%>
							<b><font color="red">(제출)</font></b>
					<%
							}
							if(rowData.get("CERT_CHECK").equals("Y")) {
					%>
							<b><font color="red">(인증서)</font></b>
					<%
							}
					%>
					          </td>
					          <td ><%=rowData.get("ATOS_DATE") %></td>
					          <td align="left" >
					<%
					      // 두산인프라코어만 I/F 에서 REMARK_URL에 첨부파일이 첨부된다.
					      if("".equals(rowData.get("REMARK_URL").trim())) {
					          if(rowData.get("REF_NO").trim().equals("")){
					%>
					            <%=rowData.get("BUYER_ITEM_NO") %>
					<%
					          }else{
					%>
					            <%=rowData.get("BUYER_ITEM_NO") %><br>(<%=rowData.get("REF_NO") %>)
					<%
					          }
					      }else {
					          if("".equals(rowData.get("REF_NO").trim())){
					%>
					            <a class="hyperLink" href="javascript:getRemarkUrL('<%=rowData.get("REMARK_URL") %>');"><%=rowData.get("BUYER_ITEM_NO") %></a>
					<%
					          }else{
					%>
					            <a class="hyperLink" href="javascript:getRemarkUrL('<%=rowData.get("REMARK_URL") %>');"><%=rowData.get("BUYER_ITEM_NO") %></a><br>(<%=rowData.get("REF_NO") %>)
					<%
					          }
					      }
					%>
					          </td>
					          <td  align="left" nowrap title="<%=rowData.get("DESCRIPTION") %>">
					            <a href="#"><div style="oerflow:hidden; text-overflow:ellipsis; width:90%"><%=rowData.get("DESCRIPTION") %></div></a>
					          </td>
					          <td class="center" title="제조사">
					          <input type="text" class="input_type_text" name="st_maker_name" id="st_maker_name" value="<%=rowData.get("MAKER_NAME") %>" style="background-color:<%=tclass%>;width:80px;border-width:0px;" readonly>
<%-- 					            <input type="text" class="input_type_text" name="st_maker_name" id="st_maker_name" value="<%=rowData.get("MAKER_NAME") %>"  readonly> --%>
					          </td>
					          <td title="조달일수" >
					          	<input type="text" class="input_type_text" name="st_lead_time"  id="st_lead_time" style="text-align:right;width:50%;"  value="<%=rowData.get("LEAD_TIME")%>" maxlength="3" onkeypress="onlyNumber();" />
							  </td>
					          <td align="center" title="제출단가">
								<input type="text" class="input_type_text" name="st_stoa_list_price_text" id="st_stoa_list_price_text" style="text-align:right;width:90%;" value="<%=rowData.get("STOA_LIST_PRICE")%>" onBlur="displayAgentPrice(<%=j%>);" />
								<input type="hidden" name="st_stoa_list_price" id="st_stoa_list_price" value="<%=rowData.get("STOA_LIST_PRICE") %>">
					          </td>
					          <td title="kep담당자">
					            	<a class="hyperLink" href="javascript:KePManager('<%=rowData.get("KEP_USER_ID") %>');"><b><%=rowData.get("KEP_USER_NAME") %></b>/</a>
					          </td>
					          <td align="center"  title="MSDS">
					           <input type="hidden" name="chk_msds" id="chk_msds" value="">
					       <%  if("Y".equals(rowData.get("MSDS_YN")))   {   %>
								<select id="select_msds"  name="select_msds"  disabled>
									<option value = "Y" <%if ("Y".equals(rowData.get("MSDS_YN"))) {%>selected<%} %>>Y</option>
								</select>	
					       <% }else{ %>  	
								<select id="select_msds"  name="select_msds" >
									<option value = "N" <%if ("N".equals(rowData.get("MSDS_YN"))) {%>selected<%} %>>N</option>
									<option value = "Y" <%if ("Y".equals(rowData.get("MSDS_YN"))) {%>selected<%} %>>Y</option>
								</select>
					       <% } %>  				          				          
					          <td class="center" title="이미지필수">
					          	<input type="hidden" name="st_rfq_img_flag"     id="st_rfq_img_flag"      value="<%=rowData.get("RFQ_IMG_FLAG") %>">
					          	<%=rowData.get("RFQ_IMG_FLAG") %>
					          </td>
					          </td>
					          <td title="납품지역">
					            <input type="hidden" name="st_deliArea" id="st_deliArea" value="<%=rowData.get("SELLER_AREA")%>">
					            <%if("Y".equals(rowData.get("DELI_AREA_USE_FLAG"))){%>
						            <%if("".equals(rowData.get("SELLER_AREA")) || null == rowData.get("SELLER_AREA")){%>
						            	<a class="hyperLink" href="javascript:doPop('deliAreaPop', '<%=rowData.get("BUYER") %>', '<%=rowData.get("PLANT") %>', '<%=j%>');"><img name="area_select_img" id="area_select_img" src="/resources/images/icon2.gif"></a>
						            <%}else{%>
						            	<a class="hyperLink" href="javascript:doPop('deliAreaPop', '<%=rowData.get("BUYER") %>', '<%=rowData.get("PLANT") %>', '<%=j%>');"><img name="area_select_img" id="area_select_img" src="/resources/images/icon.gif"></a>
						            <%}%>
					            <%}else{%>
					            	<img name="area_select_img" id="area_select_img"   style="display:none;">
					            <%}%>
					          </td>
					          <td title="MOQ">
					          <%if("Y".equals(rowData.get("MOQ_USE_FLAG"))){%>
								<input type="text" class="input_type_text" name="st_min_order_qty"  id="st_min_order_qty" style="text-align:right;width:50px;"  value="<%=rowData.get("MIN_ORDER_QTY")%>" maxlength="15" onkeypress="onlyNumber();"/>
					          <%}else{%>
					          	<input type="hidden" class="input_type_text" name="st_min_order_qty"  id="st_min_order_qty" style="text-align:right;width:50px;"  value="<%=rowData.get("MIN_ORDER_QTY")%>" maxlength="15" onkeypress="onlyNumber();"/>
					          <%}%>
							  </td>
							  <td title="과세구분">
							  	<select id="st_tax_type" name="st_tax_type"><%= CommonUtil.getCodeComboList("TX17", "", CommonUtil.nvl(rowData.get("TAX_TYPE")), "", "", "") %></select>
							  </td>
					        </tr>
					        
					        <tr bgcolor="<%=tclass%>">
					          <td  title="견적번호">
					            <a class="hyperLink" href="javascript:req_print('<%=rowData.get("BUYER") %>','<%=rowData.get("QUOTATION_NO") %>','<%=rowData.get("QUOTATION_SEQ") %>','<%=rowData.get("REVISION") %>','<%=rowData.get("KEP_USER_ID") %>','<%=rowData.get("REF_NO") %>');">
					              <b><%=rowData.get("QUOTATION_NO") %></b>
					            </a>
					          </td>
					          <td  title="순번">
					          <%=rowData.get("QUOTATION_SEQ")%>
					<%if("Y".equals(rowData.get("PRE_GR_FLAG"))){%>
						<b>(선입고)</b>
					<%}%>
					          </td>
					          <td  title="견적마감일">
					            <b>
					              <%=CommonUtil.formatDate(rowData.get("ATOS_END_DATE"), CommonUtil.YYYYMMDD)%>
					<%
									String time1 = "";
									String time2 = "";
									if( !"".equals(rowData.get("ATOS_END_TIME"))){
						                time1 = rowData.get("ATOS_END_TIME").substring(0,2);
						                time2 = rowData.get("ATOS_END_TIME").substring(2,4);
									}
					%>
					              <%=time1%>:<%=time2%>
					            </b>
					          </td>
					          <td  align="left" nowrap title="모델번호">
					            <input type="text" class="input_type_text" name="st_maker_part_no" id="st_maker_part_no"   value="<%=rowData.get("MAKER_PART_NO") %>" style="background-color:<%=tclass%>;width:80px;border-width:0px;" readonly>
					          </td>
					          <td  align="left" >
					            <%=rowData.get("SPECIFICATION") %> 
					          </td>
					          <td  class="center" title="원산지">
					            <input type="hidden" name="st_origin_code"  value="<%=rowData.get("ORIGIN_CODE") %>" style="width:95%">
					            <input type="text" class="input_type_text" name="st_origin_name" id="st_origin_name"   value="<%=rowData.get("ORIGIN_NAME") %>" style="background-color:<%=tclass%>;width:80px;border-width:0px;" readonly>
					          </td>
								<td  align="center" title="수량/단위">
								    <input type="hidden" name="st_item_qty" id="st_item_qty" value="<%=rowData.get("ITEM_QTY") %>">
					            <%=rowData.get("ITEM_QTY")%>&nbsp;
					            
					            / 
<!-- 								</td> -->
<!-- 					          <td  align="right"  width="30" title="단위"> -->
							  <%=rowData.get("UNIT_MEASURE") %>
					          </td>
					          <td title="견적금액합계(VAT별도)"  align="center">
					            <input type="text" class="input_type_text" name="st_stoa_list_price_amt" id="st_stoa_list_price_amt" style="text-align:right; border-width:0; width:90%; background-color:<%=tclass%>;" value="<%=rowData.get("ITEM_AMT")%>" readonly>  
					          </td>
					          <td class="center" title="운영사비고/파일">
					          	<input type="hidden" name="st_remark" id="st_remark" value="">
					          	<%=rowData.get("ATOS_REMARK_M") %>
					            <input type="hidden" name="st_atos_remark" id="st_atos_remark" value="<%=rowData.get("ATOS_REMARK") %>">
					            <input type="hidden" name="st_stoa_remark" id="st_stoa_remark" value="<%=rowData.get("STOA_REMARK") %>">
								<%
								      if("".equals(rowData.get("ATOS_REMARK")) && "".equals(rowData.get("STOA_REMARK"))) {
								%>
								            <a href="javascript:doPop('remarkStoA','<%=rowData.get("ATOS_REMARK") %>','<%=rowData.get("STOA_REMARK") %>', <%=j%>);"><img name = "st_stoa_remark_img" id="st_stoa_remark_img" src="/resources/images/but_icon02.gif" border="0"></a>
								<%
								      }else {
								%>
								            <a href="javascript:doPop('remarkStoA','<%=rowData.get("ATOS_REMARK") %>','<%=rowData.get("STOA_REMARK") %>', <%=j%>);"><img name = "st_stoa_remark_img" id="st_stoa_remark_img" src="/resources/images/but_icon01.gif" border="0"></a>
								<%
								      }
								%>/
									<%
									      if(!"".equals(rowData.get("IMAGE_KEY"))) {
									%>
									            <a href="javascript:doPop('attach','<%=rowData.get("IMAGE_KEY") %>','<%=rowData.get("BUYER") %>','<%=j%>');"><img src="/resources/images/disk_on.gif" border="0"></a>
									<%
									      }else {
									%>
									              <img src="/resources/images/disk_off.gif" border="0">
									<%
									      }
									%>
					          </td>
					          <td >
					            <input type="hidden" name="st_image_key" id="st_image_key" value="">
					            <a href="javascript:doPop('attachSet',<%=j%>);"><img src="/resources/images/disk_off.gif" name="st_image_key_img" id="st_image_key_img" border="0"></a>
					          </td>
					          <td title="이미지첨부">
					            <a class="hyperLink" href="javascript:doPop('addImgPop', '<%=rowData.get("BUYER") %>', '<%=j%>');"><img name="reg_select_img" id="reg_select_img" src="/resources/images/icon2.gif"></a>
					          </td>
					          <td >
						          <%if("Y".equals(rowData.get("PROCESS_TYPE_FLAG"))){%>
									<select id="select_process_type"  name="select_process_type" >
										<option value = ""  selected>선택</option>
										<option value = "0" >직납</option>
										<option value = "2" >TR</option>
									</select>
								<%}else{ %>
									<input type="hidden" name="select_process_type" id="select_process_type" value="">
								<%} %>
					          </td>
					          <td title="발주배수" >
					          <%if("Y".equals(rowData.get("MOQ_USE_FLAG"))){%>
					            <input type="text" class="input_type_text" name="st_pur_unit_qty"  id="st_pur_unit_qty" style="text-align:right;width:50px;"  value="<%=rowData.get("PUR_UNIT_QTY")%>" maxlength="15" onkeypress="onlyNumber();"/>
					          <%}else{%>
					          	<input type="hidden" class="input_type_text" name="st_pur_unit_qty"  id="st_pur_unit_qty" style="text-align:right;width:50px;"  value="<%=rowData.get("PUR_UNIT_QTY")%>" maxlength="15" onkeypress="onlyNumber();"/>
					          <%}%>
							  </td>
							  <td>
							  </td>
					        </tr>
					<%
					      }
				        }
					%>
                    </tbody>
                </table>
				<input type="hidden" name="display_item_cnt" id="display_item_cnt"    value="<%=page_display_cnt%>">
            </form>
                
	            <!--페이징-->
	            <p class="paging" >
	            <%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow) %> 
				</p>
				
                <!--버튼영역-->
                <div class="btnArea">
                	<span class="fl">
                		<font style="color: red; size: 12px;"><b>※납품지역, 거래유형, MOQ, 발주배수 항목은 특정 고객사만 입력하는 항목이며, 입력한 단가를 한번 더 확인하시고 신중하게 견적제출 하여 주십시요.</b></font>
                	</span>
                	<br>
                	<span class="fl">
						<font style="color: black; size: 12px;">(거래유형: KeP 물류 이용 시 TR 선택, MOQ: 최소주문(발주) 수량, 발주배수: 1회 주문 시 최소수량(예: 연필 12개 한 다스 일때 발주배수 12개, 24개, 36개...))</font>
                	</span>
	                <span class="fr">
						<span class="btn_08 mr04"><a href="javaScript:doPop('deliAreaPopMulti');">납품지역 일괄선정</a></span>
						<span class="btn_06 mr04"><a href="javaScript:doAction('reqSourcing');">견적요청서 목록</a></span>
						<span class="btn_04 mr04"><a href="javaScript:doAction('agentHandout');">견적제출</a></span>
						<span class="btn_04 "><a href="javaScript:doAction('cancel');">견적포기</a></span>
					</span>
				 </div>
				 
				<form name="processForm" id="processForm"  method="post">	
					<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" />
					<input type="hidden" name="total_cnt" id="total_cnt"  value="<%=total_cnt %>"/>
					<input type="hidden" name="curPage" id="curPage"  value="<%=curPage %>"/>
					<input type="hidden" name="onepagerow" id="onepagerow"  value="<%=onepagerow %>"/>
					<div id="process">
					</div>
				 
				</form>
          </div>    
    </div>
</div>
<div id="ksign" style="position:absolute; left:0px; top:0px; width:0%; height:0%;display:none;" >
	<object id="CC_Object_id"
	      classid="CLSID:A099920B-630C-426B-91EC-737685CEEE17"
	      width= Document.body.clientWidth
	      height= Document.body.clientHeight>
	</object>
</div>
    <!--내용 종료-->	                  
    
<%@ include file="/WEB-INF/views/common/include/sellerFooter.jsp" %>    
</body>
<script type="text/javascript"> 
var btnEvent = "";
var gridIndex = 0;
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";
var areaOn = "/resources/images/icon.gif";
var areaOff = "/resources/images/icon2.gif";

//ie브라우져 체크
var agt = navigator.userAgent.toLowerCase();
var browser;
if(agt.indexOf("msie") != -1 || agt.indexOf("trident") != -1){
	browser = "ie";
}else{
	browser = "other";
}
	
/*
 *  최초 화면 함수
 */
function kep_onload_view(){
	
	<%if (!"complate".equals(msg)){%>
			kepSearch(1);
	<%}%> 
	
}	


//기능함수
var pTag = "";
function doAction(str) {
	st = new Date();
	btnEvent = str;
	
	switch (str) {
	case "search":
		kepSearch(curPage);
		break;
	case "reqSourcing"://견적요청서 목록
		ReqSourcingList(btnEvent);
		break;
	case "agentHandout"://견적제출
		$('#st_giveup_yn').val("N");
		pTag = "agentHandout";
		agentHandout(btnEvent);
		break;
	case "cancel"://견적포기
		$('#st_giveup_yn').val("N");
		pTag = "cancel";
		if(setGridData(btnEvent)){
			if(!confirm("견적을 포기하시겠습니까?")){ 
				return;
			}
			openSearchPopup("/common/mprq/estimateAbandonmentReasonPop.do", "", "410,400,no");
		}
		break;
	case "signVendor":	// 공인인증
		signData();
// 			kepAjaxFormCall("/mdct/getMasterMdCtContractProgressPopCertValidate.do","processForm", btnEvent);
// 		}
		break;
	case "vendorSigned" :
		if (pTag == "agentHandout"){
			kepAjaxFormCall("/mprq/sellerMpRqEstiReqAgentHandout.do","processForm",btnEvent);
		} else if (pTag ==  "cancel"){
			kepAjaxFormCall("/mprq/sellerMpRqEstiReqGiveUp.do","processForm",btnEvent);
		}
		break;
	}

}

/* 공동인증서 로그인을 위한 처리 */
function signData(){
	
	var userId = $("#userId").val();
	
	if(browser == "other"){
    	 alert("공동인증서는 인터넷 익스플로러 브라우져만 사용가능합니다.");
    	 return;
     }
	
// 	if(userId  == null ||  userId == ""){
//         alert("회원아이디를 입력하여 주십시요. \n회원아이디로 사업자등록번호를 체크합니다.");
//         document.contentForm.userId.focus();
//         return;
//      }
     
     //object 존재여부 확인(설치가 안된 client는 수동설치 할 수 있도록 popup띄움)
     if (document.CC_Object_id.object == null) {
    	 window.open( "/module/crosscert/ccc-sample/Object_chk.html" ,"BicImage","width=600,height=470,toolbar=no,location=no,resizable=yes,menubar=no,status=no,scrollbars=yes");
    	 return;
     }else{
	     //사업자 번호 get(후 처리는 kepAjaxSuccessMain 펑션에서 수행.)
	     var pData = { st_user_id : userId };
	     kepAjaxCallMain("/login/getIRSNo.do",pData,"getIRSNo");
     }
}


/*
 * FORM 을 이용한조회
 */
function kepSearch(curPage){
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mprq/getSellerMpRqEstiReqList.do").submit();   
	
// 	document.forms.searchForm.target = "_self";
// 	document.forms.searchForm.method = "post";
// 	document.forms.searchForm.action = "/mprq/getSellerMpRqEstiReqList.do";
// 	document.forms.searchForm.submit(); 
	
}

/*
 * 견적요청서 목록
 */
function ReqSourcingList(btnEvent) {
    var tot_cnt = $("#display_item_cnt").val(); 
    
	var cnt = getCheckedRowCount(tot_cnt);
  	if(cnt <=0) {
  		alert("견적을 선택하여 주십시요.");
        return;
	}
  	
    var deli_query      = "";

    if(eval(tot_cnt)<=1) {

        buyer           = document.forms.contentForm.st_buyer.value;
        quotation_no    = document.forms.contentForm.st_quotation_no.value;
        quotation_seq   = document.forms.contentForm.st_quotation_seq.value;
        revision        = document.forms.contentForm.st_revision.value;

        deli_query  = buyer;
        deli_query += quotation_no;
        deli_query += quotation_seq;
        deli_query += revision;
        deli_query += "^||^";

    }else {

        for(var j=0; j<tot_cnt; j++) {

            var box = eval("document.forms.contentForm.checkbox" + j);

            if(box.checked==true) {

                buyer           = document.forms.contentForm.st_buyer[j].value;
                quotation_no    = document.forms.contentForm.st_quotation_no[j].value;
                quotation_seq   = document.forms.contentForm.st_quotation_seq[j].value;
                revision        = document.forms.contentForm.st_revision[j].value;

                deli_query += buyer;
                deli_query += quotation_no;
                deli_query += quotation_seq;
                deli_query += revision;
                deli_query += "^||^";
            }
        }
    }
  	
  	var param =  "["+deli_query+"]["+$('#agent').val()+"]";
	var fileName = "RD_04_B_008_03";
	
	reportOpen(fileName,param);
  	
}

/*
 * 협력사 견적요청
 */
 var rFlag = "N";
 var certFlag = "N";
 function agentHandout(btnEvent){
	 
	 var tot_cnt  = $("#display_item_cnt").val(); 
	 var box = "";
	    if(eval(tot_cnt) < 2){
	    	box = eval("document.forms.contentForm.checkbox0");
	        if(box.checked == true){
	        	var box2 = document.forms.contentForm.select_msds.value
	        	if(box2== "Y"){
	        		document.forms.contentForm.chk_msds.value = "Y";	        		
	        	}else{
	        		document.forms.contentForm.chk_msds.value = "N";	        		
	        	}
	        }
	    }else{
	        for(var k = 0; k < tot_cnt; k++){
	            box = eval("document.forms.contentForm.checkbox" + k);
	            if(box.checked == true){
	            	var box2 = document.forms.contentForm.select_msds[k].value
	            	if(box2== "Y"){
		        		document.forms.contentForm.chk_msds[k].value = "Y";		        		
		        	}else{
		        		document.forms.contentForm.chk_msds[k].value = "N";		        		
		        	}	            	

	            }
	        }
	    }
	 
	 if(setGridData(btnEvent)){
		if (rFlag == "N"){
			if(!confirm("견적제출을 하시겠습니까?")){ 
				return;
			}
		}
		if (certFlag == "N"){
			kepAjaxFormCall("/mprq/sellerMpRqEstiReqAgentHandout.do","processForm",btnEvent);
		} else {
			doAction('signVendor');
		}
	}
}



//협력사 견적포기
 function AgentGiveUp(reason) { 
 	var mode ="GIVEUP";
 	$("#st_mode").val(mode); 
 	
    var tot_cnt  = $("#display_item_cnt").val(); 
    var box = "";
    if(eval(tot_cnt) < 2){
    	box = eval("document.forms.contentForm.checkbox0");
        if(box.checked == true){
//             document.forms.contentForm.st_stoa_remark_img.src = remarkOn;
            document.forms.contentForm.st_remark.value = reason;
        }
    }else{
        for(var k = 0; k < tot_cnt; k++){
            box = eval("document.forms.contentForm.checkbox" + k);
            if(box.checked == true){
//                 document.forms.contentForm.st_stoa_remark_img[k].src = remarkOn;
                document.forms.contentForm.st_remark[k].value = reason;
            }
        }
    }
    
    var formArr = getFormToArr("document.forms.contentForm",false,"");
	if(formArr != null && formArr !=""){
		document.forms.processForm.s_SAVENAME.value =formArr[0];
		$("#process").html(formArr[1]);
	} else{
		alert("그리드 데이터 변환에 실패하였습니다.[getFormToArr]");
		return;
	}
    
	$('#st_giveup_yn').val("Y");
    kepAjaxFormCall("/mprq/sellerMpRqEstiReqGiveUp.do","processForm",btnEvent); 
  
 }
 
 /**
  * ajax 공통 호출후 에러시 처리 함수
  */
 function  kepAjaxError(pMethod , response) {
	 var msg = response.msg.MSG;   
 	
 	if (msg != ""){
 		alert(msg);
 	}
 } 
//ajax 공통 호출후 성공시 처리 함수
 function kepAjaxSuccess(pMethod , response){
 	var msg = response.msg.MSG;   
 	
 	if (msg != ""){
 		alert(msg);
 	}
 	// 처리후 재조회
 	kepSearch($("#curPage").val());
 }
 
 /**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccessMain(pMethod , response){
	if(pMethod == "getIRSNo"){
		//사업자 정보 체크
	     var irs_no = $.trim(eval("response.data.IRS_NO"));
    	 
    	 if( irs_no == null || irs_no == "" ){
 	        alert(" 사업자번호 정보가 없습니다.");
 	        return;
 	    }
    	 
    	 //원문data set
    	 var originData = $.trim(eval("response.data.ORIGIN_DATA"));
		 $("#originData").val(originData);
 	   
 	     var ret;
 	     var signeddata;
 	     var userdn, getR;
 	 	
    	 // 환경설정 함수 콜
    	 initCrosscert();
	 	// 인증서 선택창 초기화 및 선택된 인증서의 DN 추출
	 	// DN은 인증기관에서 유니크한 것임.
	 	userdn = document.CC_Object_id.GetUserDN();
	 	
	 	if( userdn == null || userdn == "" ) { 
			return;
		} else {
			signeddata = document.CC_Object_id.SignData( document.contentForm.originData.value, "SHA1", "");
			
			if( signeddata == null || signeddata == "" ){
	            errmsg = document.CC_Object_id.GetErrorContent();
	            errcode = document.CC_Object_id.GetErrorCode();
	            alert( "SignData :"+errmsg );
	            return;
	        }else{
	        	getR = document.CC_Object_id.GetRFromKey(userdn, "");
	        	
	        	if (getR == ""){
	                alert("주민/사업자번호를 확인할 수 없는 인증서입니다.");
	                return;
	            }
	            ret = CC_Object_id.ValidCert_VID(userdn, getR, irs_no); //사업자번호 체크
	            if (ret != "0"){
	                alert("본인확인에 실패했습니다. 선택한 인증서의 사업자번호와 일치하지 않습니다. \n\n해당 인증기관에 문의하시기 바랍니다.");
	                return;
	            }else{
	            	//인증서의 유효성 체크(서명된 데이터를 서버에서 처리. )
 		  		    var pData = { signedData : signeddata, getR : getR, ssn : irs_no, userId :  $("#userId").val()};
 		  		 kepAjaxCallMain("/login/certValidate.do",pData,"getCertValidate"); 
	            }
	        }
		    
		}
 	} else if(pMethod == "getCertValidate"){

 		if("0000" != response.data.errorCode) {
// 			alert("유효하지 않은 인증서입니다.\n"+response.data.errorMsg);
			alert("유효하지 않은 인증서입니다.\n"+response.data.errorMsg+"\n"+response.data.errorCode);
			return;
		}else{ 
			//인증성공
			if (pTag == "agentHandout"){
				kepAjaxFormCall("/mprq/sellerMpRqEstiReqAgentHandout.do","processForm",btnEvent);
			} else if (pTag ==  "cancel"){
				kepAjaxFormCall("/mprq/sellerMpRqEstiReqGiveUp.do","processForm",btnEvent);
			}
		}
	} 	 
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxErrorMain(pMethod , response) {
	
	if (pMethod == "getIRSNo"){ 
		alert("사업자번호 조회 중 오류 발생하였습니다.");
			return;
	}else if (pMethod == "getCertValidate"){ 
		alert("인증서 검증 중 오류 발생하였습니다.");
			return;
	}
}  
 
/* 선택된 그리드 값을 셋팅 */
function setGridData(btnEvent){
	var returnValue = true;
	var chkFlag = false;
	//선택된 항목수 체크
	var tot_cnt  = $("#display_item_cnt").val(); 
  	var cnt      = getCheckedRowCount(tot_cnt);
  	if(cnt <=0) {
  		if (btnEvent == "cancel"){ // 견적포기
  			alert("견적포기할 폼목을 선택하여 주십시요.");
  		} else if (btnEvent == "agentHandout"){ // 견적제출
  			alert("견적제출할 폼목을 선택하여 주십시요.");
  		}
			return false;
	}
  	if (btnEvent == "agentHandout"){
  	    var box = "";
  	    if (tot_cnt < 2) {
  	    	box = eval("document.forms.contentForm.checkbox0");
	            if(box.checked == true){
	            	var lead_time  = document.forms.contentForm.st_lead_time.value;
	            	var stoa_list_price = document.forms.contentForm.st_stoa_list_price.value;
	            	var cert_yn = document.forms.contentForm.st_cert_yn.value;
	            	var moq_use_flag = document.forms.contentForm.st_moq_use_flag.value;
	            	var min_order_qty = document.forms.contentForm.st_min_order_qty.value;
	            	var pur_unit_qty = document.forms.contentForm.st_pur_unit_qty.value;
	            	var select_msds = document.forms.contentForm.select_msds.value;
	            	var st_image_key= document.forms.contentForm.st_image_key.value;
	            	var st_deliArea = document.forms.contentForm.st_deliArea.value;
	            	var deli_area_use_flag = document.forms.contentForm.st_deli_area_use_flag.value;
	            	var st_rfq_img_flag = document.forms.contentForm.st_rfq_img_flag.value;
	            	var st_imgfile_name = document.forms.contentForm.st_imgfile_name.value;
	            	var st_buyer = document.forms.contentForm.st_buyer.value;
	            	//거래유형 필수 체크 추가
	            	var st_process_type_flag = document.forms.contentForm.st_process_type_flag.value;
	            	var select_process_type = document.forms.contentForm.select_process_type.value;
	            	//이미지필수 일경우 반드시 체크
	            	if(st_rfq_img_flag=="Y"&&kepIsValueNull(st_imgfile_name)){
	            		alert("해당 품목 이미지첨부가 필요합니다.");
	            		return false;	            		
	            	}
	            	//msds 품목은 첨부파일이 필요함.
	            	if(select_msds =="Y"&&kepIsValueNull(st_image_key)){
	            		alert("MSDS 품목은 파일첨부가 필요합니다.");
	            		return false;
	            	}
					if(kepIsValueNull(lead_time)) {
						 alert("조달일수(숫자형식)를 입력하여 주십시요.");
						 document.forms.contentForm.st_lead_time.focus();
	                     return false;
					}
					if(!kepIsNumChkStr(lead_time,1)) {
						 alert("조달일수(숫자형식)를 입력하여 주십시요.");
						 document.forms.contentForm.st_lead_time.focus();
	                     return false;
					}
					
					if(kepIsValueNull(stoa_list_price)) {
						 alert("제출단가(숫자형식)를 입력하여 주십시요.");
						 document.forms.contentForm.st_stoa_list_price_text.focus();
	                     return false;
					}
					if(!kepIsNumChkStr(stoa_list_price,3)) {
						 alert("제출단가(숫자형식)를 입력하여 주십시요.");
						 document.forms.contentForm.st_stoa_list_price_text.focus();
	                     return false;
					}
					
					if(stoa_list_price <= 1) {
						rFlag = "Y";
// 						alert("제출단가가 "+stoa_list_price+"원 입니다. 다시 입력하세요.");
						alert("유효하지 않는 견적단가입니다.");
						return;
					}
					
					if (cert_yn == "Y"){
						certFlag = "Y";
					}
					
					if(moq_use_flag == "Y"){
						if(kepIsValueNull(min_order_qty) || min_order_qty < 1 || !kepIsNumChkStr(min_order_qty,2)){
							$("#st_min_order_qty").val("");
							alert("MOQ(숫자형식)를 입력하여 주십시요.");
							document.forms.contentForm.st_min_order_qty.focus();
							return false;
						}
						if(kepIsValueNull(pur_unit_qty) || pur_unit_qty < 1 || !kepIsNumChkStr(pur_unit_qty,2)){
							$("#st_pur_unit_qty").val("");
							alert("발주배수(숫자형식)를 입력하여 주십시요.");
							document.forms.contentForm.st_pur_unit_qty.focus();
							return false;
						}
					}
					if(deli_area_use_flag == "Y"){
						if(kepIsValueNull(st_deliArea)){
							alert("납품지역을 선택하여 주십시요.");
							document.forms.contentForm.st_deliArea.focus();
							return false;
						}
					}
					//거래유형 필수체크로직 추가.
					if(st_process_type_flag == "Y"){
						if(kepIsValueNull(select_process_type)){
							alert("거래유형을 선택하여 주십시요.");
							document.forms.contentForm.select_process_type.focus();
							return false;
						}
					}
	            }
  	    } else {
  	        for(var k = 0; k < tot_cnt; k++){
  	            box = eval("document.forms.contentForm.checkbox" + k);
  	            if(box.checked == true){
  	            	var lead_time  = document.forms.contentForm.st_lead_time[k].value;
  	            	var stoa_list_price = document.forms.contentForm.st_stoa_list_price[k].value;
  	            	var cert_yn = document.forms.contentForm.st_cert_yn[k].value;
  	            	var moq_use_flag = document.forms.contentForm.st_moq_use_flag[k].value;
  	            	var min_order_qty = document.forms.contentForm.st_min_order_qty[k].value;
	            	var pur_unit_qty = document.forms.contentForm.st_pur_unit_qty[k].value;
	            	var select_msds = document.forms.contentForm.select_msds[k].value;
	            	var st_image_key= document.forms.contentForm.st_image_key[k].value;
	            	var st_deliArea = document.forms.contentForm.st_deliArea[k].value;
	            	var deli_area_use_flag = document.forms.contentForm.st_deli_area_use_flag[k].value;
	            	var st_rfq_img_flag = document.forms.contentForm.st_rfq_img_flag[k].value;
	            	var st_imgfile_name = document.forms.contentForm.st_imgfile_name[k].value;
	            	var st_buyer = document.forms.contentForm.st_buyer[k].value;
	            	//거래유형 필수 체크 추가
	            	var st_process_type_flag = document.forms.contentForm.st_process_type_flag[k].value;
	            	var select_process_type = document.forms.contentForm.select_process_type[k].value;
	            	//이미지필수 일경우 반드시 체크
	            	if(st_rfq_img_flag=="Y"&&kepIsValueNull(st_imgfile_name)){
	            		alert("해당 품목 이미지첨부가 필요합니다.");
	            		return false;	            		
	            	}
	            	//msds 품목은 첨부파일이 필요함.
	            	if(select_msds =="Y"&&kepIsValueNull(st_image_key)){
	            		alert("MSDS 품목은 파일첨부가 필요합니다.");
	            		return false;
	            	}
  					if(kepIsValueNull(lead_time)) {
  						 alert("조달일수(숫자형식)를 입력하여 주십시요.");
  						 document.forms.contentForm.st_lead_time[k].focus();
  	                     return false;
  					}
  					if(!kepIsNumChkStr(lead_time,1)) {
  						 alert("조달일수(숫자형식)를 입력하여 주십시요.");
  						 document.forms.contentForm.st_lead_time[k].focus();
  	                     return false;
  					}
  					
  					if(kepIsValueNull(stoa_list_price)) {
  						 alert("제출단가(숫자형식)를 입력하여 주십시요.");
  						 document.forms.contentForm.st_stoa_list_price_text[k].focus();
  	                     return false;
  					}
  					if(!kepIsNumChkStr(stoa_list_price,3)) {
  						 alert("제출단가(숫자형식)를 입력하여 주십시요.");
  						 document.forms.contentForm.st_stoa_list_price_text[k].focus();
  	                     return false;
  					}
  					
  					if(stoa_list_price <= 1) {
  						rFlag = "Y";
//   						alert("제출단가가 "+stoa_list_price+"원 입니다. 다시 입력하세요."); 
						alert("유효하지 않는 견적단가입니다.");
  						return;
  					}
  					
  					if (cert_yn == "Y"){
						certFlag = "Y";
					}
  					
  					if(moq_use_flag == "Y"){
						if(kepIsValueNull(min_order_qty) || min_order_qty < 1 || !kepIsNumChkStr(min_order_qty,2)){
							$("input[name=st_min_order_qty]").eq(k).val("");
							alert("MOQ(숫자형식)를 입력하여 주십시요.");
							document.forms.contentForm.st_min_order_qty[k].focus();
							return false;
						}
						if(kepIsValueNull(pur_unit_qty) || pur_unit_qty < 1 || !kepIsNumChkStr(pur_unit_qty,2)){
							$("input[name=st_pur_unit_qty]").eq(k).val("");
							alert("발주배수(숫자형식)를 입력하여 주십시요.");
							document.forms.contentForm.st_pur_unit_qty[k].focus();
							return false;
						}
					}
  					
  					if(deli_area_use_flag == "Y"){
						if(kepIsValueNull(st_deliArea)){
							alert("납품지역을 선택하여 주십시요.");
							document.forms.contentForm.st_deliArea[k].focus();
							return false;
						}
					}
					//거래유형 필수체크로직 추가.
					if(st_process_type_flag == "Y"){
						if(kepIsValueNull(select_process_type)){
							alert("거래유형을 선택하여 주십시요.");
							document.forms.contentForm.select_process_type[k].focus();
							return false;
						}
					}
  	            }
  	        }
  	    }
  	}
  	
	var chkGridValue = {};
	if(btnEvent == "agentHandout") {

		chkFlag=true;
		chkGridValue = {
				keys : ["st_cert_yn"] ,
				value0 : "Y",
				msg0 : "공동인증서 필수인 견적건이 포함되어 있습니다.\n (인증서) 표기 견적건은 공동인증서 로그인 후\n 견적제출하여 주십시요."
		}; 
	} else if(btnEvent == "cancel" ){
		if( cnt > 1) {
		alert("한번에 하나의 견적만 포기 가능 합니다.");
		return false;
		} else {
			return true;
		}
	}
	
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
	if (tot_cnt == 0){
		return 0;
	}
	
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
//팝업함수호출
function doPop(str, value1, value2, idx) {
	popupSel = str ;
	gridIndex = idx;
	
	switch (str) {
	case "remarkStoA":
		var atos_remark = value1;
		var stoa_remark = $("input[name=st_stoa_remark]").eq(gridIndex).val();
		openSearchPopup("/common/remarkStoAPop.do", '?st_atos_remark='+atos_remark+'&st_stoa_remark='+stoa_remark, "500,310,no");
		
		break;
	case "attach"://파일 첨부
		//SLOGIC-BEGIN(P04-4040-03)
		if (value2 == "KRKORE0254"){
			var image_key = value1;
			attach_popup(image_key);
		//SLOGIC-END	
 		} else if ( "KRDHIM0001|KRDOOS0046|KRDAEW0023|".indexOf(value2) > -1 ) {	//  drm 적용시 변경.
		// Drm Begin
 			var type="RFQ";
 			var viewType="R";
 			openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+value1+'&TYPE='+type+'&viewType='+viewType+'&DRM=Y','500,430,no');// 파일첨부
		// Drm End
		} else {
			var type="RFQ";
			var viewType="R";
			openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+value1+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
		}
		break;
	case "attachSet"://파일 첨부(등록)
		var type="RFQ";
		var viewType="VI";
		gridIndex = value1;
		var image_key =  $("input[name=st_image_key]").eq(gridIndex).val();
		openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
		break;
	case "deliAreaPop": // 납품지역
		gridIndex = idx;
		var area_list = $("input[name=st_deliArea]").eq(gridIndex).val();
		var stoa_date = "";
		var stoa_time = "";
		var mod_yn = "Y";
		
		stoa_date = $("input[name=st_stoa_date]").eq(gridIndex).val();
		stoa_time = $("input[name=st_stoa_time]").eq(gridIndex).val();
		
		if(stoa_date != "" || stoa_time != ""){
			mod_yn = "N";
		}
		
		openSearchPopup("/common/getDeliveryAreaPop.do", '?st_com_code='+value1+'&st_area_list='+area_list+'&mod_yn='+mod_yn+'&plant_code='+value2, "400,270,no");
		break;
	case "deliAreaPopMulti": // 납품지역 일괄선정
		var tot_cnt = document.forms.contentForm.display_item_cnt.value;
		var cnt = getCheckedRowCount(tot_cnt);
		var stoa_date = "";
		var stoa_time = "";
		var buyer_bf = "";
		var buyer_af = "";
		var plant_bf = "";
		var plant_af = "";
		var mod_yn = "Y";
		
		if(cnt <= 0){
			alert("선택된 항목이 없습니다.");
			return;
		}else if(cnt < 2){
			alert("일괄선정은 2건 이상 선택이 필요합니다.");
			return;
		}
		
		for(var i=0; i<tot_cnt; i++){
			var box = eval("document.forms.contentForm.checkbox" + i);
			if(box.checked == true){
				if(buyer_bf == ""){
					buyer_bf = document.forms.contentForm.st_buyer[i].value;
					
					if(plant_bf == ""){
						plant_bf = document.forms.contentForm.st_plant[i].value;
					}
					
					plant_af = document.forms.contentForm.st_plant[i].value;
				}

				buyer_af = document.forms.contentForm.st_buyer[i].value;
				
				stoa_date = document.forms.contentForm.st_stoa_date[i].value;
				stoa_time = document.forms.contentForm.st_stoa_time[i].value;
				
				if(stoa_date != "" || stoa_time != ""){
					alert("미제출건에 대해서만 납품지역 설정이 가능합니다.");
					return;
				}
				
				if(i > 0 && buyer_bf != buyer_af){
					alert("동일한 고객사들만 선택 가능합니다.");
					return;
					
					if(i > 0 && plant_bf != plant_af){
						alert("동일한 플랜트들만 선택 가능합니다.");
						return;
					}
					
					plant_bf = plant_af;
				}
				
				buyer_bf = buyer_af;
				
				var deli_area_use_flag = document.forms.contentForm.st_deli_area_use_flag[i].value;

				if(deli_area_use_flag != "Y"){
					alert("선택 고객사는 납품지역 일괄선정을 할 수 없습니다.");
					return;
				}
			}
		}
		
		if(confirm("선택된 항목들에 일괄적용됩니다. 진행하시겠습니까?")){
			openSearchPopup("/common/getDeliveryAreaPop.do", '?st_com_code='+buyer_af+'&mod_yn='+mod_yn+'&plant_code='+plant_af, "400,270,no");	
		}
		
		break;
	case "addImgPop": // 이미지첨부
		gridIndex = value2;
		var st_buyer = $("input[name=st_buyer]").eq(gridIndex).val();
		var st_quotation_no = $("input[name=st_quotation_no]").eq(gridIndex).val();
		var st_quotation_seq = $("input[name=st_quotation_seq]").eq(gridIndex).val();
		var st_revision = $("input[name=st_revision]").eq(gridIndex).val();
		var st_agent_revision = $("input[name=st_agent_revision]").eq(gridIndex).val();
		var st_agent = $("input[name=st_agent]").eq(gridIndex).val();
		var st_imgfile_dir = $("input[name=st_imgfile_dir]").eq(gridIndex).val();
		var st_imgfile_name = $("input[name=st_imgfile_name]").eq(gridIndex).val();
		var st_buyer_item_no = $("input[name=st_buyer_item_no]").eq(gridIndex).val();
		var mod_yn = "Y"; //수정여부
		var st_type = "S"; //협력사일경우
		
		openSearchPopup("/common/addImagePop.do", '?st_buyer='+st_buyer+'&st_quotation_no='+st_quotation_no+'&st_quotation_seq='+st_quotation_seq+'&st_revision='+st_revision+'&st_agent_revision='+st_agent_revision+'&st_agent='+st_agent+'&st_imgfile_dir='+st_imgfile_dir+'&st_imgfile_name='+st_imgfile_name+'&st_buyer_item_no='+st_buyer_item_no+'&mod_yn='+mod_yn+'&st_type='+st_type, "590,670,no");
		break;
	}
}

function attach_popup(image_key){
    var left = 0;
    var top = 0;
    var width = 800;
    var height = 400;
    var toolbar = 'no';
    var menubar = 'no';
    var status = 'no';
    var scrollbars = 'yes';
    var resizable = 'no';
//  var loc = "http://safety.koreab2b.com/kr/common/popup/attach_view_pop_doosanmeca.jsp?st_image_key="+image_key;
    var loc = "http://safety.koreab2b.com/file/view.wu?fileUploadId=fileUploadPop&bizType=BOARD&fileUuid="+image_key+"&callback=setFileImage&callbackParam=0%2CCSTMR_ATTCH_FILE_NO_IMAGE%2CCSTMR_ATTCH_FILE_NO&removeBtnUnvisible=false";
    window.open(loc,'attach_popup', 'left='+left+', top='+top+', width='+width+', height='+height+', toolbar='+toolbar+', menubar='+menubar+', status='+status+', scrollbars='+scrollbars+', resizable='+resizable);
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	if (popupSel == "remarkStoA"){
		$("input[name=st_stoa_remark]").eq(gridIndex).val(value1);
	 	 if(value1 ==""){
	 		$("img[id=st_stoa_remark_img]").eq(gridIndex).attr("src",remarkOff);
	 	 }else{
	 		$("img[id=st_stoa_remark_img]").eq(gridIndex).attr("src",remarkOn);
	 	 }
	} else if(popupSel == "attachSet") {	//파일 첨부
		 $("input[name=st_image_key]").eq(gridIndex).val(value1);
	 	 if(value1 ==""){
			 $("img[id=st_image_key_img]").eq(gridIndex).attr("src",diskOff);
	 	 }else{
			 $("img[id=st_image_key_img]").eq(gridIndex).attr("src",diskOn);
	 	 }
	}else if(popupSel == "deliAreaPop") {	// 납품가능지역
		 $("input[name=st_deliArea]").eq(gridIndex).val(value1);
	 	 if(value1 ==""){
	 		$("img[id=area_select_img]").eq(gridIndex).attr("src", areaOff);
	 	 }else{
	 		$("img[id=area_select_img]").eq(gridIndex).attr("src",areaOn);
	 	 }
	}else if(popupSel == "deliAreaPopMulti") {	// 납품지역 일괄선정
		var tot_cnt  = document.forms.contentForm.display_item_cnt.value;
	
		for(var i=0; i<tot_cnt; i++){
			var box = eval("document.forms.contentForm.checkbox" + i);
			if(box.checked == true){
				$("input[name=st_deliArea]").eq(i).val(value1);
				if(value1 ==""){
					$("img[id=area_select_img]").eq(i).attr("src", areaOff);
				}else{
			 		$("img[id=area_select_img]").eq(i).attr("src", areaOn);
			 	}
			}
		}
	}else if(popupSel == "addImgPop") {	// 이미지첨부
		$("input[name=st_imgfile_dir]").eq(gridIndex).val(value1);
		$("input[name=st_imgfile_name]").eq(gridIndex).val(value2);
		if(value1 ==""){
			$("img[id=reg_select_img]").eq(gridIndex).attr("src", areaOff);
		}else{
	 		$("img[id=reg_select_img]").eq(gridIndex).attr("src", areaOn);
	 	}
	}
}
// 견적요청서
function req_print(buyer,quotation_no,quotation_seq,revision,kep_user_id,ref_no){
	//SLOGIC-BEGIN(P04-4040-05)
	var param = "";
	var fileName = "";
	var rfq_gubun = ref_no;
	if(buyer == "KRDOOD0001"){
	    if(rfq_gubun == "RFQ"){
	    	fileName = "RD_04_M_005_02";
	    	param =  "["+quotation_no+"]["+revision+"]["+buyer+"]";
	    }else{
	    	fileName = "RD_04_M_006_02"; //견적번호기준으로 품목 나오도록 수정.2015.1.15 현업 협의완료.
	    	param =  "["+buyer+"]["+quotation_no+"]["+quotation_seq+"]["+revision+"]["+kep_user_id+"]["+"${sessionInfo.comCode}"+"]";	
	    }
    } else {
    	fileName = "RD_04_M_006_01";
    	param =  "["+buyer+"]["+quotation_no+"]["+quotation_seq+"]["+revision+"]["+kep_user_id+"]["+"${sessionInfo.comCode}"+"]";
    }
	reportOpen(fileName,param);
	//SLOGIC-END
}
function AgentSourcingHistory(buyer,quotation_no,quotation_seq,revision,agent){
	openSearchPopup("/mprq/showSellerMpRqUnitPriceHistoryPop.do", '?st_buyer='+buyer+'&st_quotation_no='+quotation_no+'&st_quotation_seq='+quotation_seq+'&st_revision='+revision+'&st_agent='+agent, "800,300,no");
}
function KePManager(kep_user_id){
	openSearchPopup("/common/kepManagerPop.do", '?st_user_id='+kep_user_id, "430,194,no");
}
function getRemarkUrL(remark_url){
	var loc = remark_url;
    window.open(loc, "doosaninfracore", "left=0,top=0");
}
function displayAgentPrice( k ) {
    var tot_cnt  = document.forms.contentForm.display_item_cnt.value;
    
	if (tot_cnt  < 2) {
        var imsi_target_qty        = kepTrimStr(kepFilterNum(document.forms.contentForm.st_item_qty.value));          // 수량 - 고정
        var imsi_list_price_text   = kepTrimStr(kepFilterNum(document.forms.contentForm.st_stoa_list_price_text.value));     // 단가 - 변화
        var imsi_list_price        = kepTrimStr(kepFilterNum(document.forms.contentForm.st_stoa_list_price.value));
	} else {
        var imsi_target_qty        = kepTrimStr(kepFilterNum(document.forms.contentForm.st_item_qty[k].value));          // 수량 - 고정
        var imsi_list_price_text   = kepTrimStr(kepFilterNum(document.forms.contentForm.st_stoa_list_price_text[k].value));     // 단가 - 변화
        var imsi_list_price        = kepTrimStr(kepFilterNum(document.forms.contentForm.st_stoa_list_price[k].value));
	}
	
    if( kepIsValueNull(imsi_list_price_text) || (imsi_list_price_text <= 1)  || !kepIsNumChkStr(imsi_list_price_text, 3)){
//         alert(" 단가를 입력해 주십시요!!   ");
        alert("유효하지 않는 견적단가입니다.");
        if (tot_cnt  < 2) {
	        document.forms.contentForm.st_stoa_list_price_text.value = imsi_list_price;
	        document.forms.contentForm.st_stoa_list_price_amt.value = kepCommaNum(imsi_target_qty * imsi_list_price);
        } else {
	        document.forms.contentForm.st_stoa_list_price_text[k].value = imsi_list_price;
	        document.forms.contentForm.st_stoa_list_price_amt[k].value = kepCommaNum(imsi_target_qty * imsi_list_price);
        }

        return;
    }

    if(imsi_list_price_text!=""){
    	if (tot_cnt  < 2) {
	        document.forms.contentForm.st_stoa_list_price.value           = eval(imsi_list_price_text);
	        document.forms.contentForm.st_stoa_list_price_text.value      = kepCommaNum(eval(imsi_list_price_text));
	        document.forms.contentForm.st_stoa_list_price_amt.value       = kepCommaNum(eval(imsi_target_qty) * eval(imsi_list_price_text));     // 금액 변경
    	} else {
	        document.forms.contentForm.st_stoa_list_price[k].value           = eval(imsi_list_price_text);
	        document.forms.contentForm.st_stoa_list_price_text[k].value      = kepCommaNum(eval(imsi_list_price_text));
	        document.forms.contentForm.st_stoa_list_price_amt[k].value       = kepCommaNum(eval(imsi_target_qty) * eval(imsi_list_price_text));     // 금액 변경
    		
    	}
    }
}
</script> 
</html>
