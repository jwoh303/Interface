<%--
**********************************************
* 메뉴 : 임시저장조회
* 화면 : 신규견적 임시저장 조회
* 기능 : 신규 견적의뢰 임시저장 조회
* 프로그램 ID :
* 담당자 : 한승준(설계 : 최진수)
* 착수일 : 2016-06-30
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
	
	String SessionComCode = "";
	String row_cnt = "";

	String st_query = CommonUtil.nvl((String) request.getParameter("st_query"),"");
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	if (sessionInfo != null){ 
		SessionComCode =  CommonUtil.nvl((String)sessionInfo.getComCode());
		row_cnt = CommonUtil.nvl((String)sessionInfo.getRowCnt());
	}
	
	String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),row_cnt);  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	
	// 빙그레 특수로직
	String p060000068 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P06-0000068", "COL01_DATA");
	
	//롯데알미늄(주) 특수로직.
	boolean p04404201 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P04-4042-01");
	//요청단가 필수 특수로직.
	boolean p04405301 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P04-4053-01");
	//제조사 필수 특수로직.
	boolean p04405401 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P04-4054-01");
	//고객사 단위 사용 특수로직.
	boolean p04405501 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P04-4055-01");
	//안전인증서 표기 여부
	boolean p04405701 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P04-4057-01");
	//품목 NO_CODE만 가능 특수로직.
	boolean p060000132 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P06-0000132");
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
	<h3><%=CommonLang.get("HTITLE123")%></h3>	<!-- 신규견적 임시저장 조회 -->
	<!--조회영역-->
		<form name = "searchForm" id="searchForm" method = "post">
		<!--HIDDEN-->
			<input type="hidden" name="st_check" id="st_check"		value="">
			<input type="hidden" name="st_buyer" id="st_buyer" value="${sessionInfo.comCode}">
			<input type="hidden" name="st_pass_flag" id="st_pass_flag" value="">
			<input type="hidden" name="st_query" id="st_query" value="<%=st_query%>">
			<!-- 비교견적서 변수-->
			<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
			<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
<%	if (_gridList != null && _gridList.size() > 0){	%>
			 <input type="hidden" name="display_item_cnt" id="display_item_cnt" value="<%=_gridList.size() %>" >
<%	}	%>
			<div id="cont_searchA">	
				<table class="cont_t_list01" >
					<caption><%=CommonLang.get("HTITLE123")%></caption>	<!-- 신규견적 임시저장 조회 -->
					<colgroup>
						<col width="8%" />
						<col width="12%" />
						<col width="8%" />
						<col width="22%" />
						<col width="8%" />
						<col width="17%" />
						<col width="8%" />
						<col width="17%" />
					</colgroup>
					
					<tbody>
					<tr >
						<td ><%=CommonLang.get("HTITLE40")%></td>	<!-- 의뢰자 -->
						<td ><label>: ${sessionInfo.userNameLoc}</label></td>
						<td ><%=CommonLang.get("HTITLE41")%></td>	<!-- 이메일 -->
						<td ><label>: ${sessionInfo.email}</label>
							<input type="hidden"  id="st_btoa_user_mail" name="st_btoa_user_mail"  style="width:80%" value="${sessionInfo.email}"></td>
						<td ><%=CommonLang.get("HTITLE42")%></td>	<!-- 연락처 -->
						<td ><label>: ${sessionInfo.tel}</label>
							<input type="hidden" id="st_btoa_user_tel" name="st_btoa_user_tel"  style="width:80%" value="${sessionInfo.tel}"></td>
						<td ><%=CommonLang.get("HTITLE43")%></td>	<!-- 팩스번호 -->
						<td ><label>: ${sessionInfo.fax}</label>
							<input type="hidden" id="st_btoa_user_fax" name="st_btoa_user_fax"  style="width:80%;" value="${sessionInfo.fax}"></td>
					</tr>
				</tbody>
			</table>
		</div>
		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
	      	<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow" onchange="kepSearch(1);"> 
				<option <%=(onepagerow.equals("10") ? "selected" : "")%> value = "10">10<%=CommonLang.get("HTITLE595")%></option>	<!-- 건 -->
				<option <%=(onepagerow.equals("50") ? "selected" : "")%> value = "50">50<%=CommonLang.get("HTITLE595")%></option>
				<option <%=(onepagerow.equals("100") ? "selected" : "")%> value = "100">100<%=CommonLang.get("HTITLE595")%></option>
			</select>
      	</span>
        <span class="fr">
        	<span class="btn_06 mr04"><a href="javascript:doPop('buyerMpRqCatalogRegYnPop');"><%=CommonLang.get("HTITLE33")%></a></span>	<!-- 카탈로그등록여부 -->
		</span>
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<!-- 공통 -->
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
	  	<input type="hidden" name="rowi" id="rowi" value="">
	  	
		<table id="table_list" class="cont_t_list02" style="width:100%">
			<colgroup>
            	<col width="5%" />
            	<col width="5%" />
            	<col width="5%" />
            	<col width="*" />
	            <col width="7%" />
	            <col width="8%" />
	            <col width="7%" />
	            <col width="11%" />
	            <col width="12%" />
	            <col width="15%" />
	        </colgroup>
	        <thead>
			<tr>
				<th rowspan="2" > 
					<input type="checkbox" name="check_status" id="check_status" value="선택"  style="cursor:hand;" onclick="checkAll();">
				</th> 
				<th colspan="2"><%=CommonLang.get("HTITLE12")%></th>	<!-- 품목코드 -->
				<th><font color="#FF6600">*</font><%=CommonLang.get("HTITLE13")%></th>	<!-- 품목명 -->
				<th><%=CommonLang.get("HTITLE46")%></th>	<!-- 단가구분 -->  
				<%
	if((p04405301 == true)) {
%>
            	<th><font color="#FF6600">*</font><%=CommonLang.get("HTITLE50")%></th>	<!-- 요청단가 -->
<%
	}else{
%>
				<th><%=CommonLang.get("HTITLE50")%></th>	<!-- 요청단가 -->
<%
	}
%>  
				<th><%=CommonLang.get("HTITLE52")%></th>	<!-- 단위 -->
<%
	if((p04405401 == true)) {
%>				
				<th><font color="#FF6600">*</font><%=CommonLang.get("HTITLE15")%></th>	<!-- 제조사 -->
<%
	}else{
%>
				<th><%=CommonLang.get("HTITLE15")%></th>	<!-- 제조사 -->
<%
	}
%>
				<th><%=CommonLang.get("HTITLE120")%></th>	<!-- 원산지 -->
				<th><%=CommonLang.get("HTITLE121")%></th>	<!-- 기존협력사 -->
			</tr>
			<tr >
				<th><%=CommonLang.get("HTITLE314")%>	<!-- 구분 --></th>
				<th><%=CommonLang.get("HTITLE45")%>	<!-- 수량 --></th>
				<th><font color="#FF6600">*</font><%=CommonLang.get("HTITLE14")%></th>	<!-- 규격 -->  
				<th><font color="#FF6600">*</font><a href="javascript:btoaDateCopy();"><font style="text-decoration:underline;"><%=CommonLang.get("HTITLE51")%></font></a></th>	<!-- 회신요청일 -->
				<th><%=CommonLang.get("HTITLE510")%><!-- 카테고리 --></th> 
				<th><%=CommonLang.get("HTITLE119")%></th>	<!-- 첨부파일 -->
				<th style="text-decoration:underline;"><a href="javascript:remarkCopy();"><%=CommonLang.get("HTITLE122")%></a></th>	<!-- 비고 -->
				<th><%=CommonLang.get("HTITLE842")%></th>	<!-- 선입고 -->
				<th><%=CommonLang.get("HTITLE913")%></th>	<!-- 품목자료 -->
			</tr> 
	</thead>
		<tbody>
<%
if (_gridList == null || _gridList.size() == 0){
%>
			<tr>
				<td colspan="15" align="center" height = "50"> 
				<span><%=CommonLang.msg("MSG347")%></span>	<!-- 조회된 데이타가 없습니다. -->
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
					<td class="font1_black1"  class="center" rowspan="2" >
						<input type="checkbox" name="InCheck">	                   
					</td>
					<td class="left"  title="품목코드" colspan="2">
						<input type="hidden" name="st_buyer_item_no" value="<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>" >
                   		<input type="hidden" name="st_byit_comorg_code" value="<%=CommonUtil.nvl(rowData.get("BYCA_COMORG_CODE"))%>">
                   		<input type="hidden" name="st_image_key" value="<%=CommonUtil.nvl(rowData.get("IMAGE_KEY"))%>">
                   		<input type="hidden" name="excel_up" value="N">
                   		<input type="hidden" name="st_buyer" value="${sessionInfo.comCode}">
                   		<input type="hidden" name="st_quotation_no" value="<%=CommonUtil.nvl(rowData.get("QUOTATION_NO"))%>">
                   		<input type="hidden" name="st_quotation_seq" value="<%=CommonUtil.nvl(rowData.get("QUOTATION_SEQ"))%>">
                   		<input type="hidden" name="st_revision" value="<%=CommonUtil.nvl(rowData.get("REVISION"))%>">
                   		<input type="hidden" name="st_req_type" value="<%=CommonUtil.nvl(rowData.get("REQ_TYPE"))%>">
                   		<input type="hidden" name="st_cms_categ_id" value="<%=CommonUtil.nvl(rowData.get("CMS_CATEG_ID"))%>">
                   		<input type="hidden" name="st_cms_catlg_id" value="<%=CommonUtil.nvl(rowData.get("CMS_CATLG_ID"))%>">
                   		<input type="hidden" name="st_imgfile_dir" value="<%=CommonUtil.nvl(rowData.get("IMGFILE_DIR"))%>">
                   		<input type="hidden" name="st_imgfile_name" value="<%=CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>">
                   		
                   		
			            <%=rowData.get("BUYER_ITEM_NO")%>
					</td>			
                    <td title="품목명">
                    <%
                    //미계약상품, 기등록 상품일 경우 품명.규격 수정 불가
                    if(CommonUtil.nvl(rowData.get("REQ_TYPE")).equals("G")||CommonUtil.nvl(rowData.get("REQ_TYPE")).equals("N")){
                    %>
                    	<input type="text" name="st_description" style="width:95%;text-align:left;background:#EAEAEA;" id="st_description" class = "input_type_text"  readonly  value="<%=CommonUtil.nvl(rowData.get("DESCRIPTION"))%>">
                    <%
                    }else{
                    %>
                    	<input type="text" name="st_description" style="width:95%;text-align:left;" id="st_description" class = "input_type_text"   value="<%=CommonUtil.nvl(rowData.get("DESCRIPTION"))%>">
                   <%
                    }
                    %>
                    </td> 

					<td title="단가구분">
						<select name='st_req_price_type' id="st_req_price_type"><%= CommonUtil.getCodeComboList("M150", "", CommonUtil.nvl(rowData.get("REQ_PRICE_TYPE"), "R"), "", "", "") %></select>
					</td>
					
					<td title="요청단가">
						<input type="text" name="st_buyer_target_price" style="width:95%;text-align:right;" id="st_buyer_target_price" class = "input_type_text" value = "<%=CommonUtil.nvl(rowData.get("BUYER_TARGET_PRICE"))%>">
					</td>
					<td title="단위">
<%	if((p04405501 == true)) {	//고객사 단위 사용 %>					
					 	<select name='st_unit_measure' id="st_unit_measure"><%= CommonUtil.getCodeBComboList(SessionComCode,"NO","UNIT","ICOMCOD2",CommonUtil.nvl(rowData.get("UNIT_MEASURE")),"TEXT1") %></select>
<%	}else{%>
					 	<select name='st_unit_measure' id="st_unit_measure"><%=CommonUtil.getCodeComboQueryIdList("getUnitMeasureInfo","", CommonUtil.nvl(rowData.get("UNIT_MEASURE")))%></select>
<%}%>					
					</td>					
		          	<td title="제조사">
		          		<input type="text" name="st_maker_name" style="width:95%;text-align:left;" id="st_maker_name" class = "input_type_text" value="<%=CommonUtil.nvl(rowData.get("MAKER_NAME"))%>">
		            </td>
		          	<td title="원산지">
		          		<input type="hidden" name="st_origin_code" id="st_origin_code" style="width:95%;" value="<%=CommonUtil.nvl(rowData.get("ORIGIN_CODE"))%>" >
		          		<input type="text" name="st_origin_name" id="st_origin_name" maxlength="20" style="width:70%;cursor:hand;" value="<%=CommonUtil.nvl(rowData.get("ORIGIN_NAME"))%>"  readonly onclick="doPop('country','<%=j%>');">
		            </td>
		          	<td title="기존협력사">	
		            	<input type="text" name="st_agent_name" style="width:95%;text-align:left;" id="st_agent_name" class = "input_type_text" value="<%=CommonUtil.nvl(rowData.get("BTOA_AGENT_NAME"))%>">
		            </td> 
				</tr>
				<tr align="center" bgcolor="<%=tclass%>">
					<td title="구분"> 
						<%=rowData.get("REQ_TYPE_NM")%>
					</td>
					<td title="수량"> 
						<input type="text" name="st_item_qty" style="width:95%;text-align:right;" id="st_item_qty" class = "input_type_text" value = "<%=rowData.get("ITEM_QTY")%>">
					</td>
					<td title="규격">
                    <%
                    //미계약상품, 기등록 상품일 경우 품명.규격 수정 불가
                    if(CommonUtil.nvl(rowData.get("REQ_TYPE")).equals("G")||CommonUtil.nvl(rowData.get("REQ_TYPE")).equals("N")){
                    %>
						<input type="text" name="st_specification" style="width:95%;text-align:left;background:#EAEAEA;" id="st_specification" class = "input_type_text"  readonly value="<%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%>">
                    <%
                    }else{
                    %>
                    	<input type="text" name="st_specification" style="width:95%;text-align:left;" id="st_specification" class = "input_type_text" value="<%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%>">
                    <%
                    }
                    %>
					</td>
					<td title="회신요청일">
					    <input type="hidden" name="st_btoa_end_date" value="<%=rowData.get("BTOA_END_DATE")%>">
						<input type="text" name="st_btoa_end_date_text" style="width:95%;text-align:center;" id="st_btoa_end_date_text" class = "input_type_text" value = "<%=CommonUtil.formatDate(rowData.get("BTOA_END_DATE"))%>"  onclick="doPop('calendar','<%=j%>');" readonly>
					</td>
					<td title="카테고리">
						<input type="hidden" name="st_category_code" id="st_category_code" style="width:95%;" value = "<%=rowData.get("CATEGORY_CODE")%>">
						<input type="text" name="st_category_name" style="width:65%;" cursor:hand; id="st_category_name" value = "<%=rowData.get("CATEGORY_NAME")%>" readonly>
						<a href="javascript:doPop('category','<%=j%>');"><img src="/resources/images/btn_search03.gif" alt="검색"/></a>
					</td>
					<td title="첨부파일">
<%if(CommonUtil.nvl(rowData.get("IMAGE_KEY")).equals("")){%>
						<a href="javascript:doPop('attach','<%=j%>');"><img src="/resources/images/disk_off.gif" name="Image2" width="14" height="14" border="0"></a>
<%}else{%>
						<a href="javascript:doPop('attach','<%=j%>');"><img src="/resources/images/disk_on.gif" name="Image2" width="14" height="14" border="0"></a>
<%}%>
					</td>
					<td title="비고">
						<input type="text" name="st_btoa_remark" style="width:95%;text-align:left;" id="st_btoa_remark" maxlength="400" class = "input_type_text" value = "<%=CommonUtil.nvl(p060000068, rowData.get("BTOA_REMARK"))%>">
					</td>
					<td title="선입고" >
						<select name='st_pre_gr_flag' id="st_pre_gr_flag"><%= CommonUtil.getCodeComboList("CA03", "", CommonUtil.nvl(rowData.get("PRE_GR_FLAG"))) %></select> 선입고&nbsp;&nbsp;
					</td>
					<td title="품목자료" >
						<input type="hidden" name="st_safety_flag" value="">
	               		<select name='st_msds_flag' id="st_msds_flag"><%= CommonUtil.getCodeComboList("CA03", "", CommonUtil.nvl(rowData.get("BUYER_MSDS_YN"))) %></select> MSDS&nbsp;&nbsp;
				        <% //안전인증서 표기 여부
				        if((p04405701 == true)) {
				        %>
				        	<input type="checkbox" name="st_safety_yn"  id="st_safety_yn"> 안전인증서    
				        <%
				        }
				        %>  
					</td>
				</tr>
            <%
                        } 
        			}
            %>
           		</tbody>
            </table>
		<table id="tblshow" class='cont_t_list022'></table>
		<!-- 페이징 -->
		<p id="paging" class="paging">
			<%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow) %> 
			<span class="cl"><%=CommonLang.get("HTITLE598")%><%=total_cnt %><%=CommonLang.get("HTITLE599")%></span>	<!-- [ 총  건 ] --> 
		</p>  
		
		<!-- 버튼영역 -->
		<div class="btnArea"> 
			<div class="fr">
				<span class="btn_04" title="삭제" >
					<a href="javascript:doAction('del','');"><%=CommonLang.get("HTITLE25")%></a>	<!-- 삭제 -->
				</span>
				<span class="btn_04" title="저장" >
					<a href="javascript:doAction('save','');"><%=CommonLang.get("HTITLE124")%></a>	<!-- 저장 -->
				</span>	
				<span class="btn_04" title="견적의뢰" >
					<a href="javascript:doAction('reg','');"><%=CommonLang.get("HTITLE39")%></a>	<!-- 견적의뢰 -->
				</span>					
            </div>
        </div> 
</form>
 
<form name="locationForm" id="locationForm" method="post">	
	<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	 
	<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
	<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}"> 	
	 
</form>
<form name="processForm" id="processForm" method="post">	
	<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" />
	<input type="hidden" name="buyer" id="buyer" value="" />
	<input type="hidden" name="gubun" id="gubun" value="" />
	<input type="hidden" name="total_cnt" id="total_cnt"  value="<%=total_cnt %>"/>
	<input type="hidden" name="curPage" id="curPage"  value="<%=curPage %>"/>
	<input type="hidden" name="onepagerow" id="onepagerow"  value="<%=onepagerow %>"/>
	<div id="process">
	
	</div>
</form>

<form name="updateForm" id="updateForm" method="post">	
	<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" />
	<input type="hidden" name="buyer" id="buyer" value="" />
	<input type="hidden" name="gubun" id="gubun" value="" />
	<input type="hidden" name="total_cnt" id="total_cnt"  value="<%=total_cnt %>"/>
	<input type="hidden" name="curPage" id="curPage"  value="<%=curPage %>"/>
	<input type="hidden" name="onepagerow" id="onepagerow"  value="<%=onepagerow %>"/>
	<input type="hidden" name="st_update" id="st_update"  value=""/>
	<input type="hidden" name="st_buyer" id="st_buyer"  value="${sessionInfo.comCode}"/>
	 <input type="hidden" name="st_btoa_user_mail" id="st_btoa_user_mail"  value=""/>
	 <input type="hidden" name="st_btoa_user_tel" id="st_btoa_user_tel"  value=""/>
	 <input type="hidden" name="st_btoa_user_fax" id="st_btoa_user_fax"  value=""/>
	 <input type="hidden" name="st_user_id" id="st_user_id"  value="${sessionInfo.userId}"/>
	 <input type="hidden" name="st_user_name" id="st_user_name"  value="${sessionInfo.userNameLoc}"/>
	 <input type="hidden" name="st_user_dept" id="st_user_dept"  value="${sessionInfo.department}"/>
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
var st;
var btnEvent= "";
var g_Row ="";
// 최초 화면 함수 
function kep_onload_view(){
}

//기능함수
function doAction(str , gubun) {
	btnEvent = str;	
	switch (str) {
	case "search":	 //조회 
		kepSearch($("#curPage").val());
		break;
	case "save": // 저장
		setSave();
		break;
	case "del": // 삭제
		setDelete();
		break;
	case "reg": // 견적의뢰
		setRequest();
		break;
	}
}

function kepSearch(curPage){
	document.forms.searchForm.curPage.value = curPage;
	$('#searchForm').attr("action", "/mprq/getBuyerMpRqRequestQuotationTempList.do").submit();   
}

// 견적의뢰
function setRequest(){
	var tot_cnt = $("#display_item_cnt").val();
    var checked_count = 0;
    var nowDate = kepGetNowTimeStr('YYYYMMDD','');
    var query = "";
	
    if(tot_cnt==1){
        if(document.forms.contentForm.InCheck.checked==true) checked_count = 1;
    }else{
        for(var j = 0; j < tot_cnt; j++) {
            if(document.forms.contentForm.InCheck[j].checked==true) {
                checked_count++;
            }
        }
    }
    
    if(checked_count==0) {
    	//견적의뢰할 품목을 선택하여 주십시요.
        alert("<%=CommonLang.msg("MSG43")%>");
        return;
    }
	if(tot_cnt <= 1) {
		if(eval("document.forms.contentForm.InCheck").checked==true) {
			var item_qty				= document.forms.contentForm.st_item_qty.value;
			var item_qty_text			= kepFilterNum(kepTrimStr(document.forms.contentForm.st_item_qty.value));              // 수량
			var description			= document.forms.contentForm.st_description.value;
			var buyer_target_price	= document.forms.contentForm.st_buyer_target_price.value;
			var btoa_end_date		= document.forms.contentForm.st_btoa_end_date.value;
			var specification			= document.forms.contentForm.st_specification.value;
			var st_category_code		= document.forms.contentForm.st_category_code.value;
            var category_name		= document.forms.contentForm.st_category_name.value;
            var maker_name			= document.forms.contentForm.st_maker_name.value;
            var buyer_item_no		= document.forms.contentForm.st_buyer_item_no.value;
			// 회신요청일 체크
			if(kepIsValueNull(kepTrimStr(btoa_end_date))) {
				//회신요청일을 입력하여 주십시오..
				alert("<%=CommonLang.msg("MSG51")%>");
				return;
			}
			
			if(parseInt(btoa_end_date) < parseInt(nowDate)) {
				//회신요청일은 현재일 이후여야 합니다.
				alert("<%=CommonLang.msg("MSG40")%>");
				return;
			}
			
			if(kepIsValueNull(kepTrimStr(item_qty_text)) || !(kepIsNumberStr(item_qty_text))) {
				//수량을 정수형으로 입력하여 주십시오.
				alert("<%=CommonLang.msg("MSG555")%>");
				document.forms.contentForm.st_item_qty.value ="";
				document.forms.contentForm.st_item_qty.focus();
				return;
			}
			
			<%
			// 롯데알미늄 카테고리 필수값 체크
			if((p04404201 == true)) {
			%>
				if(kepIsValueNull(kepTrimStr(category_name))) {
					//카테고리 필수값 체크
					alert("<%=CommonLang.msg("MSG489")%>");
					return;
				}
			<%
			}
			%>
			
			// NO_CODE로만 진행하도록 통제
			<%if(p060000132 == true) { %>
					if(buyer_item_no != 'NO_CODE') {
						alert("<%=CommonLang.msg("MSG592")%>");
						return;
					}
			<% } %>
			
			// 품목명 체크
			if(kepIsValueNull(kepTrimStr(description))) {
				//품목명을 입력하여 주십시오.
				alert("<%=CommonLang.msg("MSG43")%>");
				document.forms.contentForm.st_description.focus();
				return;
			}
			
			// 규격 체크
			if(kepIsValueNull(kepTrimStr(specification))) {
				//규격을 입력하여 주십시오.
				alert("<%=CommonLang.msg("MSG50")%>");
				document.forms.contentForm.st_specification.focus();
				return;
			}
			
			<%
			// 요청단가 필수값 체크
			if((p04405301 == true)) {
			%>
				if(kepIsValueNull(kepTrimStr(buyer_target_price))) {
					alert("요청단가를 입력하여 주십시오.");
					document.forms.contentForm.st_buyer_target_price.focus();
					return;
				}
			<%
			}
			%>
			
			if(!kepIsValueNull(kepTrimStr(buyer_target_price))) {
				if(!kepIsNumChkStr(buyer_target_price, 3)) {
					//요청단가를 숫자형식으로 소수점 3자리 까지 입력가능합니다.
					alert("<%=CommonLang.msg("MSG63")%>");
					document.forms.contentForm.st_buyer_target_price.value   = "";
					document.forms.contentForm.buyer_target_price.focus();
					return;
				}
			}else{
				buyer_target_price = 0;
			}
			
			<%
			// 제조사 필수값 체크
			if((p04405401 == true)) {
			%>
				if(kepIsValueNull(kepTrimStr(maker_name))) {
					alert("제조사를 입력하여 주십시오.");
					document.forms.contentForm.st_maker_name.focus();
					return;
				}
			<%
			}
			%>
			<%
			//안전인증서 선택여부 셋팅
			if((p04405701 == true)) {
			%>
				//안전인증서 셋팅.
				if(document.forms.contentForm.st_safety_yn.checked == true){
					document.forms.contentForm.st_safety_flag.value = "Y";
				}else{
					document.forms.contentForm.st_safety_flag.value = "N";
				}
			<%
			}else{
			%>
				//안전인증서 체크로직이 없으므로 무조건 N처리
				document.forms.contentForm.st_safety_flag.value = "N";
			<%
			}
			%>
		}
	} else {
		for(var i =0; i < tot_cnt; i++) {
			if(document.forms.contentForm.InCheck[i].checked==true) {
				var item_qty				= document.forms.contentForm.st_item_qty[i].value;
				var item_qty_text			= kepFilterNum(document.forms.contentForm.st_item_qty[i].value);               // 수량
				var description			= document.forms.contentForm.st_description[i].value;
				var buyer_target_price	= document.forms.contentForm.st_buyer_target_price[i].value;
				var btoa_end_date		= document.forms.contentForm.st_btoa_end_date[i].value;
				var specification			= document.forms.contentForm.st_specification[i].value;
				var st_category_code		= document.forms.contentForm.st_category_code[i].value;
	            var category_name		= document.forms.contentForm.st_category_name[i].value;
	            var maker_name			= document.forms.contentForm.st_maker_name[i].value;
	            var buyer_item_no		= document.forms.contentForm.st_buyer_item_no[i].value;
				// 회신요청일 체크
				if(kepIsValueNull(kepTrimStr(btoa_end_date))) {
					//번째 행의 회신요청일을 입력하여 주십시오.
					alert((i+1)+"<%=CommonLang.msg("MSG64")%>");
					return;
				}
				
				if(parseInt(btoa_end_date) < parseInt(nowDate)) {
					//번째 회신요청일은 현재일 이후여야 합니다.
					alert((i+1)+"<%=CommonLang.msg("MSG65")%>");
					return;
				}
				
				if(kepIsValueNull(kepTrimStr(item_qty_text)) || !(kepIsNumberStr(item_qty_text))) {
					//번째 행의 수량을 정수형으로 입력하여 주십시오.
					alert((i+1)+"<%=CommonLang.msg("MSG556")%>");
					document.forms.contentForm.st_item_qty[i].value="";
					document.forms.contentForm.st_item_qty[i].focus();
					return;
				}
				
				<%
				// 롯데알미늄 카테고리 필수값 체크
				if((p04404201 == true)) {
				%>
					if(kepIsValueNull(kepTrimStr(category_name))) {
						//카테고리 필수값 체크
						alert("<%=CommonLang.msg("MSG489")%>");
						return;
					}
				<%
				}
				%>
				
				// NO_CODE로만 진행하도록 통제
				<%if(p060000132 == true) { %>
						if(buyer_item_no != 'NO_CODE') {
							alert("<%=CommonLang.msg("MSG592")%>");
							return;
						}
				<% } %>
				
				// 품목명 체크
				if(kepIsValueNull(kepTrimStr(description))) {
					//번째 행의 품명을 입력하여 주십시오.
					alert((i+1)+"<%=CommonLang.msg("MSG54")%>");
					document.forms.contentForm.st_description[i].focus();
					return;
				}
				
				// 규격 체크
				if(kepIsValueNull(kepTrimStr(specification))) {
					//번째 행의 규격을 입력하여 주십시오.
					alert((i+1)+"<%=CommonLang.msg("MSG56")%>");
					document.forms.contentForm.st_specification[i].focus();
					return;
				}
				
				<%
				// 요청단가 필수값 체크
				if((p04405301 == true)) {
				%>
					if(kepIsValueNull(kepTrimStr(buyer_target_price))) {
						alert((i+1)+"<%=CommonLang.msg("MSG501")%>");	//번째 행의 요청단가를 입력하여 주십시오.
						document.forms.contentForm.st_buyer_target_price[i].focus();
						return;
					}
				<%
				}
				%>
				
				if(!kepIsValueNull(kepTrimStr(buyer_target_price))) {
					if(!kepIsNumChkStr(buyer_target_price, 3)) {
						//번째 행의 요청단가를 숫자형식으로 소수점 3자리 까지 입력가능합니다.
						alert((i+1)+"<%=CommonLang.msg("MSG67")%>");
						document.forms.contentForm.st_buyer_target_price[i].value    = "";
						document.forms.contentForm.buyer_target_price[i].focus();
						return;
					}
				}else {
					buyer_target_price = 0;
				}
				
				<%
				// 제조사 필수값 체크
				if((p04405401 == true)) {
				%>
					if(kepIsValueNull(kepTrimStr(maker_name))) {
						alert((i+1)+"<%=CommonLang.msg("MSG502")%>");	//번째 행의 제조사를 입력하여 주십시오.
						document.forms.contentForm.st_maker_name[i].focus();
						return;
					}
				<%
				}
				%>
				<%
				//안전인증서 선택여부 셋팅
				if((p04405701 == true)) {
				%>
					//안전인증서 셋팅.
					if(document.forms.contentForm.st_safety_yn[i].checked == true){
						document.forms.contentForm.st_safety_flag[i].value = "Y";
					}else{
						document.forms.contentForm.st_safety_flag[i].value = "N";
					}

				<%
				}else{
				%>
					//안전인증서 체크로직이 없으므로 무조건 N처리
					document.forms.contentForm.st_safety_flag[i].value = "N";

				<%
				}
				%>
			}
		}
	}
	//선택된 내용을 저장 후, 견적의뢰 하시겠습니까?
	if (confirm("<%=CommonLang.msg("MSG357")%>")){
    	if(eval(tot_cnt) < 2){
            var st_quotation_no			= document.forms.contentForm.st_quotation_no.value;
            var st_quotation_seq			= document.forms.contentForm.st_quotation_seq.value;
            var st_revision					= document.forms.contentForm.st_revision.value;
            
            var st_buyer_item_no		= document.forms.contentForm.st_buyer_item_no.value;
            var st_description				= document.forms.contentForm.st_description.value;
            var st_specification			= document.forms.contentForm.st_specification.value;
            var st_unit_measure			= document.forms.contentForm.st_unit_measure.value;
            var st_maker_name			= document.forms.contentForm.st_maker_name.value;
            var st_origin_code			= document.forms.contentForm.st_origin_code.value;
            var st_btoa_end_date		= document.forms.contentForm.st_btoa_end_date.value;
            var st_buyer_target_price	= document.forms.contentForm.st_buyer_target_price.value;
            var st_item_qty				= document.forms.contentForm.st_item_qty.value;
            var st_agent_name			= document.forms.contentForm.st_agent_name.value;
            var st_btoa_remark			= document.forms.contentForm.st_btoa_remark.value;
            var st_image_key				= document.forms.contentForm.st_image_key.value;
            var st_req_price_type		= document.forms.contentForm.st_req_price_type.value;
            var st_category_code			= document.forms.contentForm.st_category_code.value;
            //표준카테고리, 표준카탈로그 추가
            var st_cms_categ_id		= document.forms.contentForm.st_cms_categ_id.value;
            var st_cms_catlg_id		= document.forms.contentForm.st_cms_catlg_id.value;
            var st_req_type			= document.forms.contentForm.st_req_type.value;
            var st_imgfile_dir		= document.forms.contentForm.st_imgfile_dir.value;
            var st_imgfile_name		= document.forms.contentForm.st_imgfile_name.value;
            var st_safety_flag		= document.forms.contentForm.st_safety_flag.value;
            var st_msds_flag		= document.forms.contentForm.st_msds_flag.value;
            var st_pre_gr_flag		= document.forms.contentForm.st_pre_gr_flag.value;
            
            if(document.forms.contentForm.InCheck.checked == true){
                query =	st_quotation_no + "@@" + st_quotation_seq + "@@" + st_revision + "@@" + st_buyer_item_no + "@@" + st_description + "@@" + st_specification + "@@" + st_unit_measure + "@@" + st_maker_name + "@@" +
                			st_origin_code + "@@" + st_btoa_end_date + "@@" + st_buyer_target_price + "@@" + st_item_qty + "@@" + st_agent_name + "@@" + st_btoa_remark + "@@" + st_image_key + "@@" + st_req_price_type + "@@" + st_category_code +
                			 "@@" + st_cms_categ_id + "@@" + st_cms_catlg_id + "@@" + st_req_type + "@@" + st_imgfile_dir + "@@" + st_imgfile_name + "@@" + st_safety_flag+ "@@" + st_msds_flag+ "@@" + st_pre_gr_flag+"&&";
            }
        }else{
            for(var j = 0; j < tot_cnt; j++){
                var box							= eval("document.forms.contentForm.InCheck[" + j + "]");
                var st_quotation_no			= document.forms.contentForm.st_quotation_no[j].value;
                var st_quotation_seq			= document.forms.contentForm.st_quotation_seq[j].value;
                var st_revision					= document.forms.contentForm.st_revision[j].value;

                var st_buyer_item_no		= document.forms.contentForm.st_buyer_item_no[j].value;
                var st_description				= document.forms.contentForm.st_description[j].value;
                var st_specification			= document.forms.contentForm.st_specification[j].value;
                var st_unit_measure			= document.forms.contentForm.st_unit_measure[j].value;
                var st_maker_name			= document.forms.contentForm.st_maker_name[j].value;
                var st_origin_code			= document.forms.contentForm.st_origin_code[j].value;
                var st_btoa_end_date		= document.forms.contentForm.st_btoa_end_date[j].value;
                var st_buyer_target_price	= document.forms.contentForm.st_buyer_target_price[j].value;
                var st_item_qty				= document.forms.contentForm.st_item_qty[j].value;
                var st_agent_name			= document.forms.contentForm.st_agent_name[j].value;
                var st_btoa_remark			= document.forms.contentForm.st_btoa_remark[j].value;
                var st_image_key				= document.forms.contentForm.st_image_key[j].value;
                var st_req_price_type		= document.forms.contentForm.st_req_price_type[j].value;
                var st_category_code			= document.forms.contentForm.st_category_code[j].value;
                //표준카테고리, 표준카탈로그 추가
                var st_cms_categ_id		= document.forms.contentForm.st_cms_categ_id[j].value;
                var st_cms_catlg_id		= document.forms.contentForm.st_cms_catlg_id[j].value;
                var st_req_type			= document.forms.contentForm.st_req_type[j].value;
                var st_imgfile_dir		= document.forms.contentForm.st_imgfile_dir[j].value;
            	var st_imgfile_name		= document.forms.contentForm.st_imgfile_name[j].value;
            	var st_safety_flag		= document.forms.contentForm.st_safety_flag[j].value;
                var st_msds_flag		= document.forms.contentForm.st_msds_flag[j].value;
                var st_pre_gr_flag		= document.forms.contentForm.st_pre_gr_flag[j].value;
                
                if(box.checked == true){
                    query +=	st_quotation_no + "@@" + st_quotation_seq + "@@" + st_revision + "@@" + st_buyer_item_no + "@@" + st_description + "@@" + st_specification + "@@" + st_unit_measure + "@@" + st_maker_name + "@@" +
                    				st_origin_code + "@@" +	st_btoa_end_date + "@@" + st_buyer_target_price + "@@" + st_item_qty + "@@" + st_agent_name + "@@" + st_btoa_remark + "@@" + st_image_key + "@@" + st_req_price_type + "@@" + st_category_code +
                    				"@@" + st_cms_categ_id + "@@" + st_cms_catlg_id + "@@" + st_req_type + "@@" + st_imgfile_dir + "@@" + st_imgfile_name + "@@" + st_safety_flag+ "@@" + st_msds_flag+ "@@" + st_pre_gr_flag+"&&";
                }
            }
        }            
        
        document.forms.updateForm.st_update.value = query;
        document.forms.updateForm.st_btoa_user_mail.value = document.forms.searchForm.st_btoa_user_mail.value;
        document.forms.updateForm.st_btoa_user_fax.value = document.forms.searchForm.st_btoa_user_fax.value;
        document.forms.updateForm.st_btoa_user_tel.value = document.forms.searchForm.st_btoa_user_tel.value;

        var chkFlag = false;
    	var chkGridValue = {};
    	var formArr = getFormToArr("document.forms.contentForm",chkFlag,chkGridValue);
    	if(formArr != null && formArr !=""){
    		$("#processForm").find("#s_SAVENAME").val(formArr[0].replace("check_status|",""));
    		$("#process").html(formArr[1]);
    		$("#process").find("#check_status").remove();
    	}else{
    		alert("<%=CommonLang.msg("MSG13")%>");
    		return;
    	}
    	
    	kepAjaxFormCall("/mprq/saveBuyerMpRqTempRequestList.do","updateForm", btnEvent);
    }else{
         return;
    }
}
// TEST 시작
// 저장
function setSave(){
	var tot_cnt = $("#display_item_cnt").val();
    var checked_count = 0;
    var nowDate = kepGetNowTimeStr('YYYYMMDD','');
    var query = "";
	
    if(tot_cnt==1){
        if(document.forms.contentForm.InCheck.checked==true) checked_count = 1;
    }else{
        for(var j = 0; j < tot_cnt; j++) {
            if(document.forms.contentForm.InCheck[j].checked==true) {
                checked_count++;
            }
        }
    }
    
    if(checked_count==0) {
    	//저장할 품목을 선택하여 주십시요.
        alert("<%=CommonLang.msg("MSG68")%>");
        return;
    }
    
	if(tot_cnt <= 1) {
		if(eval("document.forms.contentForm.InCheck").checked==true) {
			var item_qty				= document.forms.contentForm.st_item_qty.value;
			var item_qty_text			= kepFilterNum(kepTrimStr(document.forms.contentForm.st_item_qty.value));              // 수량
			var description			= document.forms.contentForm.st_description.value;
			var buyer_target_price	= document.forms.contentForm.st_buyer_target_price.value;
			var btoa_end_date		= document.forms.contentForm.st_btoa_end_date.value;
			var specification			= document.forms.contentForm.st_specification.value;
			var maker_name			= document.forms.contentForm.st_maker_name.value;
			
			// 회신요청일 체크
			if(kepIsValueNull(kepTrimStr(btoa_end_date))) {
				//회신요청일을 입력하여 주십시오..
				alert("<%=CommonLang.msg("MSG51")%>");
				return;
			}
			
			if(parseInt(btoa_end_date) < parseInt(nowDate)) {
				//회신요청일은 현재일 이후여야 합니다.
				alert("<%=CommonLang.msg("MSG40")%>");
				return;
			}
			
			if(kepIsValueNull(kepTrimStr(item_qty_text)) || !(kepIsNumberStr(item_qty_text))) {
				//수량을 정수형으로 입력하여 주십시오.
				alert("<%=CommonLang.msg("MSG555")%>");
				document.forms.contentForm.st_item_qty.value ="";
				document.forms.contentForm.st_item_qty.focus();
				return;
			}
			
			// 품목명 체크
			if(kepIsValueNull(kepTrimStr(description))) {
				//품목명을 입력하여 주십시오.
				alert("<%=CommonLang.msg("MSG62")%>");
				document.forms.contentForm.st_description.focus();
				return;
			}
			
			// 규격 체크
			if(kepIsValueNull(kepTrimStr(specification))) {
				//규격을 입력하여 주십시오.
				alert("<%=CommonLang.msg("MSG50")%>");
				document.forms.contentForm.st_specification.focus();
				return;
			}
			
			<%
			// 요청단가 필수값 체크
			if((p04405301 == true)) {
			%>
				if(kepIsValueNull(kepTrimStr(buyer_target_price))) {
					//요청단가를 입력해주세요.
					alert("<%=CommonLang.msg("MSG495")%>");
					document.forms.contentForm.st_buyer_target_price.focus();
					return;
				}
			<%
			}
			%>
			
			if(!kepIsValueNull(kepTrimStr(buyer_target_price))) {
				if(!kepIsNumChkStr(buyer_target_price, 3)) {
					//요청단가를 숫자형식으로 소수점 3자리 까지 입력가능합니다.
					alert("<%=CommonLang.msg("MSG63")%>");
					document.forms.contentForm.st_buyer_target_price.value   = "";
					document.forms.contentForm.buyer_target_price.focus();
					return;
				}
			}else{
				buyer_target_price = 0;
			}
		
			<%
			// 제조사 필수값 체크
			if((p04405401 == true)) {
			%>
				if(kepIsValueNull(kepTrimStr(maker_name))) {
					//제조사를 입력하여 주십시오.
					alert("<%=CommonLang.msg("MSG496")%>");
					document.forms.contentForm.st_maker_name.focus();
					return;
				}
			<%
			}
			%>	
		}
	} else {
		for(var i =0; i < tot_cnt; i++) {
			if(document.forms.contentForm.InCheck[i].checked==true) {
				var item_qty				= document.forms.contentForm.st_item_qty[i].value;
				var item_qty_text			= kepFilterNum(document.forms.contentForm.st_item_qty[i].value);               // 수량
				var description			= document.forms.contentForm.st_description[i].value;
				var buyer_target_price	= document.forms.contentForm.st_buyer_target_price[i].value;
				var btoa_end_date		= document.forms.contentForm.st_btoa_end_date[i].value;
				var specification			= document.forms.contentForm.st_specification[i].value;
				var maker_name			= document.forms.contentForm.st_maker_name[i].value;

				// 회신요청일 체크
				if(kepIsValueNull(kepTrimStr(btoa_end_date))) {
					//번째 행의 회신요청일을 입력하여 주십시오.
					alert((i+1)+"<%=CommonLang.msg("MSG64")%>");
					return;
				}
				
				if(parseInt(btoa_end_date) < parseInt(nowDate)) {
					//번째 회신요청일은 현재일 이후여야 합니다.
					alert((i+1)+"<%=CommonLang.msg("MSG65")%>");
					return;
				}
				
				if(kepIsValueNull(kepTrimStr(item_qty_text)) || !(kepIsNumberStr(item_qty_text))) {
					//번째 행의 수량을 정수형으로 입력하여 주십시오.
					alert((i+1)+"<%=CommonLang.msg("MSG556")%>");
					document.forms.contentForm.st_item_qty[i].value="";
					document.forms.contentForm.st_item_qty[i].focus();
					return;
				}
				
				// 품목명 체크
				if(kepIsValueNull(kepTrimStr(description))) {
					//번째 행의 품명을 입력하여 주십시오.
					alert((i+1)+"<%=CommonLang.msg("MSG54")%>");
					document.forms.contentForm.st_description[i].focus();
					return;
				}
				
				// 규격 체크
				if(kepIsValueNull(kepTrimStr(specification))) {
					//번째 행의 규격을 입력하여 주십시오.
					alert((i+1)+"<%=CommonLang.msg("MSG56")%>");
					document.forms.contentForm.st_specification[i].focus();
					return;
				}
				
				<%
				// 요청단가 필수값 체크
				if((p04405301 == true)) {
				%>
					if(kepIsValueNull(kepTrimStr(buyer_target_price))) {
						alert((i+1)+"<%=CommonLang.msg("MSG501")%>");	//번째 행의 요청단가를 입력하여 주십시오.
						document.forms.contentForm.st_buyer_target_price[i].focus();
						return;
					}
				<%
				}
				%>
				
				if(!kepIsValueNull(kepTrimStr(buyer_target_price))) {
					if(!kepIsNumChkStr(buyer_target_price, 3)) {
						//번째 행의 요청단가를 숫자형식으로 소수점 3자리 까지 입력가능합니다.
						alert((i+1)+"<%=CommonLang.msg("MSG67")%>");
						document.forms.contentForm.st_buyer_target_price[i].value    = "";
						document.forms.contentForm.buyer_target_price[i].focus();
						return;
					}
				}else {
					buyer_target_price = 0;
				}
				
				<%
				// 제조사 필수값 체크
				if((p04405401 == true)) {
				%>
					if(kepIsValueNull(kepTrimStr(maker_name))) {
						alert((i+1)+"<%=CommonLang.msg("MSG502")%>");	//번째 행의 제조사를 입력하여 주십시오.
						document.forms.contentForm.st_maker_name[i].focus();
						return;
					}
				<%
				}
				%>	
			}
		}
	}
	//선택된 내용을 저장하시겠습니까?
	if (confirm("<%=CommonLang.msg("MSG358")%>")){
    	if(eval(tot_cnt) < 2){
            var st_quotation_no			= document.forms.contentForm.st_quotation_no.value;
            var st_quotation_seq			= document.forms.contentForm.st_quotation_seq.value;
            var st_revision					= document.forms.contentForm.st_revision.value;
            
            var st_buyer_item_no		= document.forms.contentForm.st_buyer_item_no.value;
            var st_description				= document.forms.contentForm.st_description.value;
            var st_specification			= document.forms.contentForm.st_specification.value;
            var st_unit_measure			= document.forms.contentForm.st_unit_measure.value;
            var st_maker_name			= document.forms.contentForm.st_maker_name.value;
            var st_origin_code			= document.forms.contentForm.st_origin_code.value;
            var st_btoa_end_date		= document.forms.contentForm.st_btoa_end_date.value;
            var st_buyer_target_price	= document.forms.contentForm.st_buyer_target_price.value;
            var st_item_qty				= document.forms.contentForm.st_item_qty.value;
            var st_agent_name			= document.forms.contentForm.st_agent_name.value;
            var st_btoa_remark			= document.forms.contentForm.st_btoa_remark.value;
            var st_image_key				= document.forms.contentForm.st_image_key.value;
            var st_req_price_type		= document.forms.contentForm.st_req_price_type.value;
            var st_category_code			= document.forms.contentForm.st_category_code.value;
            var st_msds_flag			= document.forms.contentForm.st_msds_flag.value;
            var st_pre_gr_flag			= document.forms.contentForm.st_pre_gr_flag.value;

            if(document.forms.contentForm.InCheck.checked == true){
                query =	st_quotation_no + "@@" + st_quotation_seq + "@@" + st_revision + "@@" + st_buyer_item_no + "@@" + st_description + "@@" + st_specification + "@@" + st_unit_measure + "@@" + st_maker_name + "@@" +
                			st_origin_code + "@@" + st_btoa_end_date + "@@" + st_buyer_target_price + "@@" + st_item_qty + "@@" + st_agent_name + "@@" + st_btoa_remark + "@@" + st_image_key + "@@" + st_req_price_type + "@@" + st_category_code + "@@" + st_msds_flag + "@@" + st_pre_gr_flag + "&&";
            }
        }else{
            for(var j = 0; j < tot_cnt; j++){
                var box							= eval("document.forms.contentForm.InCheck[" + j + "]");
                var st_quotation_no			= document.forms.contentForm.st_quotation_no[j].value;
                var st_quotation_seq			= document.forms.contentForm.st_quotation_seq[j].value;
                var st_revision					= document.forms.contentForm.st_revision[j].value;

                var st_buyer_item_no		= document.forms.contentForm.st_buyer_item_no[j].value;
                var st_description				= document.forms.contentForm.st_description[j].value;
                var st_specification			= document.forms.contentForm.st_specification[j].value;
                var st_unit_measure			= document.forms.contentForm.st_unit_measure[j].value;
                var st_maker_name			= document.forms.contentForm.st_maker_name[j].value;
                var st_origin_code			= document.forms.contentForm.st_origin_code[j].value;
                var st_btoa_end_date		= document.forms.contentForm.st_btoa_end_date[j].value;
                var st_buyer_target_price	= document.forms.contentForm.st_buyer_target_price[j].value;
                var st_item_qty				= document.forms.contentForm.st_item_qty[j].value;
                var st_agent_name			= document.forms.contentForm.st_agent_name[j].value;
                var st_btoa_remark			= document.forms.contentForm.st_btoa_remark[j].value;
                var st_image_key				= document.forms.contentForm.st_image_key[j].value;
                var st_req_price_type		= document.forms.contentForm.st_req_price_type[j].value;
                var st_category_code			= document.forms.contentForm.st_category_code[j].value;
                var st_msds_flag			= document.forms.contentForm.st_msds_flag[j].value;
                var st_pre_gr_flag			= document.forms.contentForm.st_pre_gr_flag[j].value;
                
                if(box.checked == true){
                    query +=	st_quotation_no + "@@" + st_quotation_seq + "@@" + st_revision + "@@" + st_buyer_item_no + "@@" + st_description + "@@" + st_specification + "@@" + st_unit_measure + "@@" + st_maker_name + "@@" +
                    				st_origin_code + "@@" + st_btoa_end_date + "@@" + st_buyer_target_price + "@@" + st_item_qty + "@@" + st_agent_name + "@@" + st_btoa_remark + "@@" + st_image_key + "@@" + st_req_price_type + "@@" + st_category_code + "@@" + st_msds_flag + "@@" + st_pre_gr_flag + "&&";
                }
            }
        }            
        
        document.forms.updateForm.st_update.value = query;
        document.forms.updateForm.st_btoa_user_mail.value = document.forms.searchForm.st_btoa_user_mail.value;
        document.forms.updateForm.st_btoa_user_fax.value = document.forms.searchForm.st_btoa_user_fax.value;
        document.forms.updateForm.st_btoa_user_tel.value = document.forms.searchForm.st_btoa_user_tel.value;

    	kepAjaxFormCall("/mprq/saveBuyerMpRqTempSaveList.do","updateForm", btnEvent);
    }else{
         return;
    }
}

// 삭제
function setDelete(){
    var tot_cnt =  $("#display_item_cnt").val();
    var checked_count = 0;
    var query = "";
    if(eval(tot_cnt) == 0){
    	//조회한 데이타가 없습니다.
        alert("<%=CommonLang.msg("MSG69")%>");
        return;
    }

    if(tot_cnt==1){
        if(document.forms.contentForm.InCheck.checked==true) checked_count = 1;
    }else{
        for(var j = 0; j < tot_cnt; j++) {
            if(document.forms.contentForm.InCheck[j].checked==true) {
            	checked_count++;
            }
        }
    }
    
    if(checked_count == "0"){
    	//삭제할 품목을 선택하여 주십시요.
    	alert("<%=CommonLang.msg("MSG70")%>");
        return;
    }else{
    	//선택된 내용을 삭제하시겠습니까?
        if (confirm("<%=CommonLang.msg("MSG71")%>")){
        	if(eval(tot_cnt) < 2){
                var box = eval("document.forms.contentForm.InCheck[0]");
                var st_quotation_no = document.forms.contentForm.st_quotation_no.value;
                var st_quotation_seq = document.forms.contentForm.st_quotation_seq.value;
                var st_revision = document.forms.contentForm.st_revision.value;

                if(document.forms.contentForm.InCheck.checked == true){
                    query = st_quotation_no + "@@" + st_quotation_seq + "@@" + st_revision + "&&";
                }
            }else{
                for(var j = 0; j < tot_cnt; j++){
                    var box = eval("document.forms.contentForm.InCheck[" + j + "]");
                    var st_quotation_no = document.forms.contentForm.st_quotation_no[j].value;
                    var st_quotation_seq = document.forms.contentForm.st_quotation_seq[j].value;
                    var st_revision = document.forms.contentForm.st_revision[j].value;

                    if(box.checked == true){
                        query += st_quotation_no + "@@" + st_quotation_seq + "@@" + st_revision + "&&";
                    }
                }
            }            
            
            document.forms.updateForm.st_update.value = query;
            
        	kepAjaxFormCall("/mprq/delBuyerMpRqTempSaveList.do","updateForm", btnEvent);	
        }else{
             return;
        }
    }
}

//팝업함수호출
function doPop(str,value1, value2, value3) {
	popupSel = str;
	switch (str) {
			case "calendar": // 달력
				g_Row = value1;
				gridIndex = value1;
				openSearchPopup('/common/calendarPop.do','','130,240,no');
				break;
			case "buyerMpRqCatalogRegYnPop": // 카탈로그등록여부
				openSearchPopup("/mprq/showBuyerMpRqCatalogRegYnPop.do", "", "750,600,no"); 
				break;
			case "attach":
				g_Row = value1;
				var tot_cnt  = $("#display_item_cnt").val();
				var image_key = "";
			    if(eval(tot_cnt) < 2) {
			        image_key = document.forms.contentForm.st_image_key.value;
			    }else{
			        image_key = document.forms.contentForm.st_image_key[value1].value;
			    }
				var type="RFQ";
				var viewType="VI";
				openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부 
				break;
			case "country": // 원산지
				g_Row = value1;
				gridIndex = value1;
				openSearchPopup("/common/countryCodePop.do", "", "500,500,no"); 
				break;
			case "category": // 카테고리
				var buyer = "<%=SessionComCode%>";
				g_Row = value1;	
				gridIndex = value1;
				if (buyer=='KRDDDD0001' || buyer=='KRHYUN0026' || buyer=='KRHYUN0033' || buyer=='KRKYUN0002' ||						
						buyer=='KRISUC0002' || buyer=='KRISUC0007' ){
					openSearchPopup("/coco/getCommonCoCoBuyerCategoryChoiceTreePop.do",'?st_buyer='+buyer,"400,500,no");			
				} else if (buyer=='KRDOOS0004' || buyer=='KRILJI0003' || buyer=='KRILJI0015' || buyer=='KRILJI0026' || 				
						buyer=='KRILJI0043' || buyer=='KRHSDE0003' ){	
					openSearchPopup("/coco/getCommonCoCoBuyerSpecialCategoryChoicePop.do",'?st_buyer='+buyer,'728,710,no');			
				} else if (buyer == 'KRDOOD0001'){ // 두산중공업 전용						
					openSearchPopup("/coco/showCommonCoCoBuyerCategoryChoiceDooPop.do",'?st_buyer='+buyer,"728,510,no");			
				} else {				
					openSearchPopup("/coco/getCommonCoCoBuyerCategoryChoicePop.do",'?st_buyer='+buyer,"728,510,no");			
				}		 
				break;
	}
}
function setPopupReturn(code, text, value){
	var diskOn = "/resources/images/disk_on.gif";
	var diskOff = "/resources/images/disk_off.gif";
	var tot_cnt  = $("#display_item_cnt").val();

	if (popupSel == "attach"){//파일 첨부
		if(eval(tot_cnt) < 2){
	        document.forms.contentForm.st_image_key.value = code;
	    }else{
	        document.forms.contentForm.st_image_key[g_Row].value = code;
	    }
	    if(code != '' && text == "on"){
			if(eval(tot_cnt) < 2){
	            document.forms.contentForm.st_image_key.value = code;
	            document.forms.contentForm.Image2.src = diskOn;
	        }else{
	            document.forms.contentForm.st_image_key[g_Row].value = code;
	            document.forms.contentForm.Image2[g_Row].src = diskOn;
	        }
	    }else{
			if(eval(tot_cnt) < 2){
	            document.forms.contentForm.st_image_key.value = "";
	            document.forms.contentForm.Image2.src = diskOff;
	        }else{
	            document.forms.contentForm.st_image_key[g_Row].value = "";
	             document.forms.contentForm.Image2[g_Row].src = diskOff;
	        }
	    }
	}else if(popupSel == "country"){
		if(eval(tot_cnt) < 2){
	        document.forms.contentForm.InCheck.checked        = true;
	        document.forms.contentForm.st_origin_name.value   = value;
	        document.forms.contentForm.st_origin_code.value   = code;
	    }else{
	        document.forms.contentForm.InCheck[g_Row].checked      = true;
	        document.forms.contentForm.st_origin_name[g_Row].value = value ;
	        document.forms.contentForm.st_origin_code[g_Row].value = code ;
	    }
	    document.forms.contentForm.rowi.value="";
	}else if (popupSel == "category") {
		if(eval(tot_cnt) < 2){
	        document.forms.contentForm.InCheck.checked        = true;
	        document.forms.contentForm.st_category_name.value   = text;
	        document.forms.contentForm.st_category_code.value   = code;
	    }else {
	        document.forms.contentForm.InCheck[g_Row].checked      = true;
	        document.forms.contentForm.st_category_name[g_Row].value = text;
	        document.forms.contentForm.st_category_code[g_Row].value = code;
	    }
		document.forms.contentForm.rowi.value="";
	}
}
//전체선택/해제
function checkAll() {
    var tot_cnt  = $("#display_item_cnt").val();
    if(document.forms.contentForm.check_status.checked == true) {
        if(tot_cnt<=1) {
            var box = document.forms.contentForm.InCheck;
            if(box.checked == false) box.checked = true;
        }else {
            for(var j = 0; j < tot_cnt; j++) {
            	var box = document.forms.contentForm.InCheck[j];
                if(box.checked == false) box.checked = true;
            }
        }
    }else{
        if(tot_cnt<=1) {
            var box = document.forms.contentForm.InCheck;
            if(box.checked == true) box.checked = false;
        }else {
            for(var j = 0; j < tot_cnt; j++){
                var box = document.forms.contentForm.InCheck[j];
                if(box.checked == true) box.checked = false;
            }
        }
    }
}
//견적의뢰 비고 복사 기능
function setPopupCalendar(year,month,day){
    var tot_cnt  = $("#display_item_cnt").val();
    var btoa_end_date   = year.toString()+month.toString()+day.toString();
    var nowDate         = kepGetNowTimeStr('YYYYMMDD','');
    if(parseInt(btoa_end_date) < parseInt(nowDate)) {
    	//회신요청일은 현재일 이후여야 합니다.
        alert("<%=CommonLang.msg("MSG40")%>");
        return;
    }
    if(eval(tot_cnt)<=1)  {
        document.forms.contentForm.InCheck.checked=true;
        document.forms.contentForm.st_btoa_end_date_text.value = year+"/"+month+"/"+day;
        document.forms.contentForm.st_btoa_end_date.value = btoa_end_date;
    }
    else {
        document.forms.contentForm.InCheck[g_Row].checked=true;
        document.forms.contentForm.st_btoa_end_date_text[g_Row].value = year+"/"+month+"/"+day;
        document.forms.contentForm.st_btoa_end_date[g_Row].value = btoa_end_date;
    }
}
function remarkCopy() {
	var tot_cnt  = $("#display_item_cnt").val();
    var btoa_remark         = "";
    var checked_count       = 0;
    if(tot_cnt==1) {
        if(document.forms.contentForm.InCheck.checked==true) {
            checked_count = 1;
            btoa_remark =  document.forms.contentForm.st_btoa_remark.value;
        }
    }else {
        for(var j = 0; j < tot_cnt; j++) {
            if(document.forms.contentForm.InCheck[j].checked==true) {
                checked_count++;
                btoa_remark =  document.forms.contentForm.st_btoa_remark[j].value;
                break;
            }
        }
    }

    if(checked_count==0) {
    	//복사할 비고를 선택하여 주십시요.
        alert("<%=CommonLang.msg("MSG38")%>");
        return;
    }
    if(tot_cnt>=2) {
        for(var j=0; j<tot_cnt; j++) {
            if(document.forms.contentForm.InCheck[j].checked==true) {
                document.forms.contentForm.st_btoa_remark[j].value           = btoa_remark;
            }else {
                document.forms.contentForm.st_btoa_remark[j].value           = "";
            }
        }
    }else {
    	//견적의뢰할 품목이 2개 이상일 경우 복사할수 있습니다.
        alert("<%=CommonLang.msg("MSG37")%>");
        return;
    }
}
//회신요청일 복사.
function btoaDateCopy() {
	var tot_cnt  = $("#display_item_cnt").val();
    var btoa_end_date_text  = "";
    var btoa_end_date       = "";
    var checked_count       = 0;
    if(tot_cnt==1) {
        if(document.forms.contentForm.InCheck.checked==true) {
            checked_count = 1;
            btoa_end_date_text  =  document.forms.contentForm.st_btoa_end_date_text.value;
            btoa_end_date   =  document.forms.contentForm.st_btoa_end_date.value;
        }
    }else {
        for(var j = 0; j < tot_cnt; j++) {
            if(document.forms.contentForm.InCheck[j].checked==true) {
                checked_count++;
                btoa_end_date_text  =  document.forms.contentForm.st_btoa_end_date_text[j].value;
                btoa_end_date   =  document.forms.contentForm.st_btoa_end_date[j].value;
                break;
            }
        }
    }
    if(checked_count==0) {
    	//회신요청일을 복사할 품목을 선택하여 주십시요.
        alert("<%=CommonLang.msg("MSG36")%>");
        return;
    }
    if(tot_cnt>=2) {
        for(var j=0; j<tot_cnt; j++) {
            if(document.forms.contentForm.InCheck[j].checked==true) {
                document.forms.contentForm.st_btoa_end_date[j].value         = btoa_end_date;
                document.forms.contentForm.st_btoa_end_date_text[j].value    = btoa_end_date_text;
            }else {
                document.forms.contentForm.st_btoa_end_date[j].value         = "";
                document.forms.contentForm.st_btoa_end_date_text[j].value    = "";
            }
        }
    }else {
    	//견적의뢰할 품목이 2개 이상일 경우 복사할수 있습니다.
        alert("<%=CommonLang.msg("MSG37")%>");
        return;
    }
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
	if (pMethod == "reg"){
		var passFlag = response.msg.passflag;
		
		if (passFlag == "Y"){
			var type = "NG"; // 견적의뢰
			var buyer = "<%=SessionComCode%>";
			kepSearch($("#curPage").val());
			openSearchPopup("/common/approval/buyerCommonApprovalPop.do", '?DOC_TYPE=' + type + '&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO='+response.msg.usrmsg+'&PARAM1='+buyer, "1000,500,no");
		}else if (passFlag == "C"){
			//전자 결재 처리 하시겠습니까? \n\n바로 견적의뢰 하시려면 취소버튼을 눌러 주십시오.
			if (!confirm("<%=CommonLang.msg("MSG356")%>")){
				// 바로생성	
				btnEvent = "noPassReq";
				kepAjaxFormCall("/mprq/saveNoPassReq.do","processForm",btnEvent); 
			} else {
				// 결재 연결
				btnEvent = "passReq";
				kepAjaxFormCall("/mprq/savePassReq.do","processForm",btnEvent); 
			}
		}else if (passFlag == "N"){
			var msg = response.msg.msg;   
			if (msg != ""){
				//견적번호 생성 되었습니다.
				alert(msg+" "+"<%=CommonLang.msg("MSG507")%>");
			}
			kepSearch($("#curPage").val());
		}
	}else if (pMethod == "noPassReq"){
		var msg = response.msg.msg;   
		if (msg != ""){
			//견적번호 생성 되었습니다.
			alert(msg+" "+"<%=CommonLang.msg("MSG507")%>");
		}
		kepSearch($("#curPage").val());
	}else if (pMethod == "passReq"){
		var type = "NG"; // 견적의뢰
		var buyer = "<%=SessionComCode%>";
		kepSearch($("#curPage").val());
		openSearchPopup("/common/approval/buyerCommonApprovalPop.do", '?DOC_TYPE=' + type + '&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO='+response.msg.usrmsg+'&PARAM1='+buyer, "1000,500,no");
	}else if(pMethod == "del"){
		//정상적으로 삭제되었습니다.
		alert("<%=CommonLang.msg("MSG75")%>");
 	  	kepSearch($("#curPage").val());
    }else if(pMethod == "save"){
    	var passFlag = response.msg.passflag;
    	var msg = response.msg.msg;
    	var usrmsg = response.msg.usrmsg;
    	//정상적으로 저장되었습니다.
		alert("<%=CommonLang.msg("MSG76")%>");
 	  	kepSearch($("#curPage").val());
    }
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	//견적생성에 실패하였습니다.\n\n관리자에게 문의하여 주시길 바랍니다.
	alert("<%=CommonLang.msg("MSG77")%>");
	
} 
function kepApprovalReturn(flag,docu_no){
	doAction("search");
}
</script>
</html>
