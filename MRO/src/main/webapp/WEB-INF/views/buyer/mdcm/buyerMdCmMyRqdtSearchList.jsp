<%--
**********************************************
* 메뉴 : 상품검색>견적의뢰
* 화면 : 신규견적의뢰
* 기능 : 상품검색 조회 후 신규 견적의뢰
* 프로그램 ID : PG_06_B_004_00
* 담당자 : 현명환
* 착수일 : 2015-11-06
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
	String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),"10");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	
	
	String SessionComCode = "";
	String st_query = CommonUtil.nvl((String) request.getParameter("st_query"),"");   
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	if (sessionInfo != null){ 
		SessionComCode =  CommonUtil.nvl((String)sessionInfo.getComCode());  
	}  
	// 빙그레 특수로직
	String p060000068 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P06-0000068", "COL01_DATA");
	// 카테고리 필수값 특수로직.
	boolean p04404201 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P04-4042-01");
%> 

<body onload="kep_onload_view()">
<div id="wrapper"> 
<!-- 메뉴 S --> 
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>
<div id="container2">
<!-- 메뉴 E -->
<!--내용 시작-->
<div id="ContArea">
	<h3><%=CommonLang.get("HTITLE32")%><!-- 신규상품 견적의뢰 --></h3>
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
					<caption>신규상품 견적의뢰</caption>
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
						<td ><%=CommonLang.get("HTITLE40")%><!-- 의뢰자 --></td>
						<td ><label>: ${sessionInfo.userNameLoc}</label></td>
						<td ><%=CommonLang.get("HTITLE41")%><!-- 이메일 --></td>
						<td ><input type="text"  id="st_btoa_user_mail" name="st_btoa_user_mail"  style="width:90%" value="${sessionInfo.email}"></td>
						<td ><%=CommonLang.get("HTITLE42")%><!-- 연락처 --></td>
						<td ><input type="text" id="st_btoa_user_tel" name="st_btoa_user_tel"  style="width:90%" value="${sessionInfo.tel}"></td>
						<td ><%=CommonLang.get("HTITLE43")%><!-- 팩스번호 --></td>
						<td ><input type="text" id="st_btoa_user_fax" name="st_btoa_user_fax"  style="width:90%;" value="${sessionInfo.fax}"></td>
					</tr>
				</tbody>
			</table>
		</div>
        <span class="fr">
        	<span class="btn_06 mr04"><a href="javascript:doPop('buyerMpRqCatalogRegYnPop');"><%=CommonLang.get("HTITLE33")%><!-- 카탈로그등록여부 --></a></span>
		</span>
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<!-- 공통 -->
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
	
	  	
		<table id="table_list" class="cont_t_list02" style="width:100%">
			<colgroup>
            	<col width="5%" />
            	<col width="10%" />
				<col width="5%" />
            	<col width="*" />
	            <col width="7%" />
	            <col width="8%" />
	            <col width="7%" />
	            <col width="11%" />
	            <col width="12%" />
	            <col width="10%" />
	        </colgroup>
	        <thead>
			<tr>
				<th rowspan="2" > 
					<input type="checkbox" name="check_status" id="check_status" value="선택"  style="cursor:hand;" onclick="checkAll();">
				</th> 
				<th colspan="2"><%=CommonLang.get("HTITLE12")%><!-- 품목코드 --></th>
				<th><font color="#FF6600">*</font><%=CommonLang.get("HTITLE13")%><!-- 품목명 --></th>
				<th><%=CommonLang.get("HTITLE46")%><!-- 단가구분 --></th>  
				<th><%=CommonLang.get("HTITLE50")%><!-- 요청단가 --></th>  
				<th><%=CommonLang.get("HTITLE52")%><!-- 단위 --></th>
				<th><%=CommonLang.get("HTITLE15")%><!-- 제조사 --></th>
				<th><%=CommonLang.get("HTITLE120")%><!-- 원산지 --></th>
				<th><%=CommonLang.get("HTITLE121")%><!-- 기존협력사 --></th>
			</tr>
			<tr>
				<th><%=CommonLang.get("HTITLE510")%><!-- 카테고리 --></th>
				<th><%=CommonLang.get("HTITLE45")%><!-- 수량 --></th>
				<th><font color="#FF6600">*</font><%=CommonLang.get("HTITLE14")%><!-- 규격 --></th>  
				<th colspan="2"><font color="#FF6600">*</font><a href="javascript:btoaDateCopy();"><font style="text-decoration:underline;"><%=CommonLang.get("HTITLE51")%><!-- 회신요청일 --></font></a></th> 
				<th><%=CommonLang.get("HTITLE119")%><!-- 첨부파일 --></th>
				<th colspan="3" style="text-decoration:underline;"><a href="javascript:remarkCopy();"><%=CommonLang.get("HTITLE122")%><!-- 비고 --></a></th>
			</tr> 
	</thead>
		<tbody>
<%
if (_gridList == null || _gridList.size() == 0){
%>
			<tr>
				<td colspan="15" align="center" height = "50"> 
				<span><%=CommonLang.msg("MSG347")%><!-- 조회된 데이타가 없습니다. --></span>
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
					<td class="center"  title="품목코드" colspan="2">
						<input type="text" id="st_buyer_item_no" name="st_buyer_item_no" style="border:0px; background-color:transparent; width:90%;" value="<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>" readonly>
                   		<input type="hidden" id="st_buyer_item_no_tmp" name="st_buyer_item_no_tmp" value="<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>">
                   		<input type="hidden" name="st_byit_comorg_code" value="<%=CommonUtil.nvl(rowData.get("BYCA_COMORG_CODE"))%>">
                   		<input type="hidden" name="st_image_key" value="">
                   		<input type="hidden" name="excel_up" value="N">
                   		<input type="hidden" name="st_safety_flag" value="N">
                   		<input type="hidden" name="st_msds_flag" value="N">
                   		<input type="hidden" name="st_pre_gr_flag" value="N">
                   		<input type="hidden" name="st_buyer" value="${sessionInfo.comCode}">
					</td>			
                    <td class="center" title="품목명">
						<input type="text" id="st_description" name="st_description" style="border:0px; background-color:transparent; width:90%;" value="<%=CommonUtil.nvl(rowData.get("DESCRIPTION_LOC"))%>" readonly>
                    </td> 
					<td class="center" title="단가구분">
						<select name='st_req_price_type' id="st_req_price_type"><%= CommonUtil.getCodeComboList("M150", "", "R", "", "", "") %></select>
					</td>
					<td class="center" title="요청단가 ">
						<input type="text" name="st_buyer_target_price" style="width:90%;text-align:right;" id="st_buyer_target_price" class = "input_type_text" value = "">
					</td>
					 <td class="center"  title="단위">  
						<select name='st_unit_measure' id="st_unit_measure" ><%= CommonUtil.getCodeComboList("M007", "", rowData.get("UNIT_MEASURE"), "", "", "CODE") %></select>
					</td>
		          	<td class="center"  title="제조사">
		          		<input type="text" id="st_maker_name" name="st_maker_name" style="border:0px; background-color:transparent; width:90%;" value="<%=CommonUtil.nvl(rowData.get("MAKER_NAME"))%>" readonly>
		            </td>
		          	<td class="center"  title="원산지">
		          		<input type="hidden" id="st_origin_code" name="st_origin_code" value="<%=CommonUtil.nvl(rowData.get("ORIGIN_CODE"))%>" >
		            	<input type="text" id="st_origin_name" name="st_origin_name" style="border:0px; background-color:transparent; width:90%;" value="<%=CommonUtil.nvl(rowData.get("ORIGIN_NMAE"))%>">
		            </td>
		          	<td class="center"  title="기존협력사">	
		            	<input type="text" name="st_agent_name" style="width:90%;text-align:left;" id="st_agent_name" class = "input_type_text" value = "">
		            </td> 
				</tr>
				<tr align="center" bgcolor="<%=tclass%>">
					<td title="카테고리">
						<input type="hidden" name="st_category_code" id="st_category_code" style="width:95%;" value = "<%=rowData.get("CATEGORY_CODE")%>">
						<input type="text" name="st_category_name" style="width:75%;" cursor:hand; id="st_category_name" value = "<%=rowData.get("CATEGORY_NAME")%>" readonly>
						<a href="javascript:doPop('category','<%=j%>');"><img src="/resources/images/btn_search03.gif" alt="검색"/></a>
					</td>
					<td title="수량">
						<input type="text" name="st_item_qty" style="width:90%;text-align:right;" id="st_item_qty" class = "input_type_text" value = "<%=rowData.get("RQDT_QTY")%>">
					</td>
					<td class="center" title="규격">
						<input type="text" id="st_specification" name="st_specification" style="border:0px; background-color:transparent; width:90%;" value="<%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%>" readonly>
					</td>
					<td colspan="2" title="회신요청일">
					    <input type="hidden" name="st_btoa_end_date" value="">
						<input type="text" name="st_btoa_end_date_text" style="width:70%;text-align:center;" id="st_btoa_end_date_text" class = "input_type_text" value = ""  onclick="doPop('calendar','<%=j%>');" readonly>
					</td>
					<td title="첨부파일">
						<a href="javascript:doPop('attach','<%=j%>');"><img src="/resources/images/disk_off.gif" name="Image2" width="14" height="14" border="0"></a>
					</td>
					<td title="비고" colspan="3">
						<input type="text" name="st_btoa_remark" style="width:95%;text-align:left;" id="st_btoa_remark" maxlength="400" class = "input_type_text" value = "<%=p060000068%>">
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
			<span class="cl"><%=CommonLang.get("HTITLE598")%><!-- [ 총 --> <%=total_cnt %><%=CommonLang.get("HTITLE599")%><!--  건 ] --></span> 
		</p>  
		
		<!-- 버튼영역 -->
		<div class="btnArea"> 
			<div class="fr">
			<!-- 
				<span class="btn_04" title="이전화면" >
					<a href="javascript:doAction('remove','');">이전화면</a> 
				</span> -->	
				<span class="btn_04">
					<a href="javascript:changeEditMode();"><%=CommonLang.get("HTITLE874")%><!-- 편집모드 --></a>
				</span>
				<span class="btn_04">
					<a href="javascript:doAction('save', '');"><%=CommonLang.get("HTITLE38")%><!-- 임시저장 --></a>
				</span>
				<span class="btn_04" title="견적의뢰" >
					<a href="javascript:doAction('reg','');"><%=CommonLang.get("HTITLE39")%><!-- 견적의뢰 --></a>
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
	<input type="hidden" name="st_buyer_assign_agent_code" id="st_buyer_assign_agent_code"  value=""/>
	<div id="process">
	
	</div>
</form>
</div>

<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>   
</div>
</body>
<div id="confirmArea"  style="position:absolute; left:  250px; top: 250px; width: 500px; height: 100px; background-color: #FFFFFF; display:none;  no-repeat; z-index:99999999999;  border: 1px solid blue; padding:20px;">
 <h4  id="confirmMsg"></h4>  
 		<!-- 버튼영역 -->
		<div class="btnArea"> 
			<div class="fr">
				<span class="btn_04">
					<a href="javascript:kep_confrim_search();"><%=CommonLang.get("HTITLE591")%><!-- 계속검색 --></a>
				</span>	
				<span class="btn_04">
					<a href="javascript:kep_confirm_location();"><%=CommonLang.get("HTITLE592")%><!-- 이동 --></a>
				</span>	
				<span class="btn_04">
					<a href="javascript:kep_confirm_cancel();"><%=CommonLang.get("HTITLE229")%><!-- 취소 --></a>
				</span>					
            </div>
        </div>
        
</div>
<script type="text/javascript">
var popupSel = "";
var st;
var btnEvent= "";
var g_Row ="";
var temp_yn = "N"; // 임시저장 여부
var editMode = "N"; // 정보수정 모드 여부

// 최초 화면 함수 
function kep_onload_view(){
 
}
//기능함수
function doAction(str , gubun) {
	btnEvent = str;	
	switch (str) {
	case "search":	 //조회 
		kepSearch(1);
		break;
	case "remove": // 이전화면
		actionBuyerMdCmGoodsDiLisList2();
		break;  
	case "reg": // 견적의뢰
		temp_yn = "N";	
		saveRqdt();
		break;  		
	case "save":
		temp_yn = "Y";
		saveRqdt();
		break;
	}
}
function kepSearch(){
	$('#searchForm').attr("action", "/mdcm/getBuyerMdCmMyRqdtSearchList.do").submit();   
	
}
//견적의뢰
function saveRqdt() {
	var tot_cnt  = $("#display_item_cnt").val();
    var checked_count       = 0;
    var nowDate             = kepGetNowTimeStr('YYYYMMDD','');
	
    if(tot_cnt==1) {
        if(document.forms.contentForm.InCheck.checked==true) checked_count = 1;
    }else {
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
			var buyer_item_no					= document.forms.contentForm.st_buyer_item_no.value;         // 품목코드
			var item_qty								= document.forms.contentForm.st_item_qty.value;              // 수량
			var description							= document.forms.contentForm.st_description.value;           // 품목명
			var buyer_target_price			= document.forms.contentForm.st_buyer_target_price.value;    // 실적단가
			var btoa_end_date					= document.forms.contentForm.st_btoa_end_date.value;         // 회신요처일
			var specification						= document.forms.contentForm.st_specification.value;         // 규격
			var image_key						= document.forms.contentForm.st_image_key.value;              // 첨부파일 이미지 키
			var btoa_remark					= document.forms.contentForm.st_btoa_remark.value;           // 비고
			var unit_measure					= document.forms.contentForm.st_unit_measure.value;          // 단위
			var maker_name					= document.forms.contentForm.st_maker_name.value;            // 제조사
			var origin_code					= document.forms.contentForm.st_origin_code.value;           // 원산지
			var agent_name					= document.forms.contentForm.st_agent_name.value;            // 기존협력사
			var st_category_code			= document.forms.contentForm.st_category_code.value;
            var st_category_name				= document.forms.contentForm.st_category_name.value;
			
			if(parseInt(btoa_end_date) < parseInt(nowDate)) {
				//회신요청일은 현재일 이후여야 합니다.
				alert("<%=CommonLang.msg("MSG40")%>");
				return;
			}
			if(!kepIsNumChkStr(item_qty, 3)) {
				//수량을 입력하여 주십시오.숫자형식으로 소수점 3자리 까지 입력가능합니다.
				alert("<%=CommonLang.msg("MSG47")%>");
				document.forms.contentForm.st_item_qty.value ="";
				document.forms.contentForm.st_item_qty_text.focus();
				return;
			}
			<%
			// 롯데알미늄 카테고리 필수값 체크
			if((p04404201 == true)) {
			%>
				if(kepIsValueNull(kepTrimStr(st_category_name))) {
					//카테고리 필수값 체크
					alert("<%=CommonLang.msg("MSG489")%>");
					return;
				}
			<%
			}
			%>
			// 품목명 체크
			if(kepIsValueNull(kepTrimStr(description))) {
				//품명을 입력하여 주십시오.
				alert("<%=CommonLang.msg("MSG48")%>");
				document.forms.contentForm.st_description.focus();
				return;
			}
			if(!kepIsValueNull(kepTrimStr(buyer_target_price))) {
				if(!kepIsNumChkStr(buyer_target_price, 3)) {
					//실적단가를 숫자형식으로 소수점 3자리 까지 입력가능합니다.
					alert("<%=CommonLang.msg("MSG49")%>");
					document.forms.contentForm.st_buyer_target_price.value   = "";
					document.forms.contentForm.buyer_target_price.focus();
					return;
				}
			}else {
				buyer_target_price = 0;
			}
			// 규격 체크
			if(kepIsValueNull(kepTrimStr(specification))) {
				//규격을 입력하여 주십시오.
				alert("<%=CommonLang.msg("MSG50")%>");
				document.forms.contentForm.st_specification.focus();
				return;
			}

			// 회신요청일 체크
			if(kepIsValueNull(kepTrimStr(btoa_end_date))) {
				//회신요청일을 입력하여 주십시오..
				alert("<%=CommonLang.msg("MSG51")%>");
				return;
			}

		}
	} else {
		for(var i =0; i < tot_cnt; i++) {

			if(document.forms.contentForm.InCheck[i].checked==true) {
				var buyer_item_no					= document.forms.contentForm.st_buyer_item_no[i].value;                          // 품목코드
				var item_qty								= document.forms.contentForm.st_item_qty[i].value;                               // 수량
				var description							= document.forms.contentForm.st_description[i].value;                            // 품목명
				var buyer_target_price			= document.forms.contentForm.st_buyer_target_price[i].value;                     // 실적단가
				var btoa_end_date					= document.forms.contentForm.st_btoa_end_date[i].value;                          // 회신요처일
				var specification						= document.forms.contentForm.st_specification[i].value;                          // 규격
				var btoa_remark						= document.forms.contentForm.st_btoa_remark[i].value;        // 비고
				var image_key							= document.forms.contentForm.st_image_key[i].value;           // 첨부파일 이미지 키
				var unit_measure						= document.forms.contentForm.st_unit_measure[i].value;           // 단위
				var maker_name						= document.forms.contentForm.st_maker_name[i].value;         // 제조사
				var origin_code						= document.forms.contentForm.st_origin_code[i].value;        // 원산지
				var agent_name						= document.forms.contentForm.st_agent_name[i].value;         // 기존협력사
				var st_category_code		= document.forms.contentForm.st_category_code[i].value;
	            var st_category_name		= document.forms.contentForm.st_category_name[i].value;
				if(parseInt(btoa_end_date) < parseInt(nowDate)) {
					//회신요청일은 현재일 이후여야 합니다.
					alert("<%=CommonLang.msg("MSG40")%>");
					return;
				}
				if(!kepIsNumChkStr(item_qty, 3)) {
					//번째 행의 수량을 입력하여 주십시오.숫자형식으로 소수점 3자리 까지 입력가능합니다.
					alert((i+1)+"<%=CommonLang.msg("MSG53")%>");
					document.forms.contentForm.st_item_qty[i].value="";
					document.forms.contentForm.st_item_qty_text[i].focus();
					return;
				}
				<%
				// 롯데알미늄 카테고리 필수값 체크
				if((p04404201 == true)) {
				%>
					if(kepIsValueNull(kepTrimStr(st_category_name))) {
						//카테고리 필수값 체크
						alert("<%=CommonLang.msg("MSG489")%>");
						return;
					}
				<%
				}
				%>
				// 품목명 체크
				if(kepIsValueNull(kepTrimStr(description))) {
					//번째 행의 품명을 입력하여 주십시오.
					alert((i+1)+"<%=CommonLang.msg("MSG54")%>");
					document.forms.contentForm.st_description[i].focus();
					return;
				}
				if(!kepIsValueNull(kepTrimStr(buyer_target_price))) {
					if(!kepIsNumChkStr(buyer_target_price, 3)) {
						//번째 행의 실적단가를 숫자형식으로 소수점 3자리 까지 입력가능합니다.
						alert((i+1)+"<%=CommonLang.msg("MSG55")%>");
						document.forms.contentForm.st_buyer_target_price[i].value    = "";
						document.forms.contentForm.buyer_target_price[i].focus();
						return;
					}
				}else {
					buyer_target_price = 0;
				}
				// 규격 체크
				if(kepIsValueNull(kepTrimStr(specification))) {
					//번째 행의 규격을 입력하여 주십시오.
					alert((i+1)+"<%=CommonLang.msg("MSG56")%>");
					document.forms.contentForm.st_specification[i].focus();
					return;
				}

				// 등록요청일 체크
				if(kepIsValueNull(kepTrimStr(btoa_end_date))) {
					//번째 행의 회신요청일을 입력하여 주십시오..
					alert((i+1)+"<%=CommonLang.msg("MSG57")%>");
					return;
				}
			}
		}
	}

	
	var chkFlag = false;
	var chkGridValue = {};
	var formArr = getFormToArr("document.forms.contentForm",chkFlag,chkGridValue);
	if(formArr != null && formArr !=""){
		//document.forms.processForm.s_SAVENAME.value =formArr[0];
		//$("#process").html(formArr[1]);
		$("#processForm").find("#s_SAVENAME").val(formArr[0].replace("check_status|",""));
		$("#process").html(formArr[1]);
		$("#process").find("#check_status").remove();
	}else{
		//그리드 데이터 변환에 실패하였습니다.[getFormToArr]
		alert("<%=CommonLang.msg("MSG13")%>");
		return;
	}
	
	if(temp_yn == "Y"){ // 임시저장
		//임시저장한 데이터는 견적임시저장조회 화면에서 확인 가능합니다. \n저장하시겠습니까?
		if (confirm("<%=CommonLang.msg("MSG58")%>")){
			temp_yn = "N";
			kepAjaxFormCall("/mprq/saveBuyerMpRqRequestQuotationTemp.do","processForm",btnEvent);
		}
	}else{ // 결재
		kepAjaxFormCall("/mprq/saveBuyerMpRqRequestQuotationStnd.do","processForm",btnEvent);
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
	 if (popupSel == "attach") {	//파일 첨부
		var diskOn = "/resources/images/disk_on.gif";
		var diskOff = "/resources/images/disk_off.gif";
		var tot_cnt  = $("#display_item_cnt").val();
	    
	    if(eval(tot_cnt) < 2) {
	        document.forms.contentForm.st_image_key.value = code;
	    }else {
	        document.forms.contentForm.st_image_key[g_Row].value = code;
	    }
	    if(code != ''){
	        if(eval(tot_cnt) < 2) {
	            document.forms.contentForm.st_image_key.value = code;
	            document.forms.contentForm.Image2.src = diskOn;
	        }else{
	            document.forms.contentForm.st_image_key[g_Row].value = code;
	            document.forms.contentForm.Image2[g_Row].src = diskOn;
	        }
	    }else{
	        if(eval(tot_cnt) < 2) {
	            document.forms.contentForm.st_image_key.value = "";
	            document.forms.contentForm.Image2.src = diskOff;
	        }else{
	            document.forms.contentForm.st_image_key[g_Row].value = "";
	             document.forms.contentForm.Image2[g_Row].src = diskOff;
	        }
	    }
		
	}else if (popupSel == "country"){
		var tot_cnt  = $("#display_item_cnt").val();
		
	    if(eval(tot_cnt) < 2){
	        document.forms.contentForm.st_origin_name.value   = value;
	        document.forms.contentForm.st_origin_code.value   = code;
	    }else {
	        document.forms.contentForm.st_origin_name[g_Row].value = value ;
	        document.forms.contentForm.st_origin_code[g_Row].value = code ;
	    }
	}else if (popupSel == "category") {
		var tot_cnt  = $("#display_item_cnt").val();
		if(eval(tot_cnt) < 2){
	        document.forms.contentForm.st_category_name.value   = text;
	        document.forms.contentForm.st_category_code.value   = code;
	    }else {
	        document.forms.contentForm.st_category_name[g_Row].value = text;
	        document.forms.contentForm.st_category_code[g_Row].value = code;
	    }
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
			openSearchPopup("/common/approval/buyerCommonApprovalPop.do", '?DOC_TYPE=' + type + '&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO='+response.msg.usrmsg+'&PARAM1='+buyer, "1000,500,no");
		} else if (passFlag == "C"){
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
		} else if (passFlag == "N"){
			var msg = response.msg.msg;   
			if (msg != ""){
				alert(msg);
			}
			doAction("remove");
		}
	} else if (pMethod == "noPassReq"){
		var msg = response.msg.msg;   
		if (msg != ""){
			alert(msg);
		}
		doAction("remove");
	} else if (pMethod == "passReq"){
		var type = "NG"; // 견적의뢰
		var buyer = "<%=SessionComCode%>";
		openSearchPopup("/common/approval/buyerCommonApprovalPop.do", '?DOC_TYPE=' + type + '&requesTemptYn=N&DOCU_NO=&BIZ_DOCU_NO='+response.msg.usrmsg+'&PARAM1='+buyer, "1000,500,no");
	} else if(pMethod == "save"){
		//정상적으로 임시저장되었습니다.
		alert("<%=CommonLang.msg("MSG59")%>");
	}

}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	//견적생성에 실패하였습니다.\n\n\관리자에게 문의하여 주시길 바랍니다.
	alert("<%=CommonLang.msg("MSG77")%>");
	
} 
function kepApprovalReturn(flag,docu_no){
	doAction("search");
}

function changeEditMode(){
	var tot_cnt  = $("#display_item_cnt").val();
	
	// 정보수정 비활성 -> 활성
	if(editMode == "N"){
		if(tot_cnt <= 1) {
			$("input[id=st_buyer_item_no]").val("");
			$("input[id=st_buyer_item_no]").css("border", "solid 1px #d2d2d2");
			$("input[id=st_buyer_item_no]").css("padding", "2px");
			$("input[id=st_buyer_item_no]").css("background-color", "#ffffff");
			$("input[id=st_buyer_item_no]").attr("readonly", false);
			
			// 품명, 규격 ID 중복으로 방식 변경
			document.forms.contentForm.st_description.style.border = "solid 1px #d2d2d2";
			document.forms.contentForm.st_description.style.padding = "2px";
			document.forms.contentForm.st_description.style.backgroundColor = "#ffffff";
			document.forms.contentForm.st_description.readOnly = false;
			
			document.forms.contentForm.st_specification.style.border = "solid 1px #d2d2d2";
			document.forms.contentForm.st_specification.style.padding = "2px";
			document.forms.contentForm.st_specification.style.backgroundColor = "#ffffff";
			document.forms.contentForm.st_specification.readOnly = false;
			
			//$("select[id=st_unit_measure]").attr("disabled", false);
			
			$("input[id=st_maker_name]").css("border", "solid 1px #d2d2d2");
			$("input[id=st_maker_name]").css("padding", "2px");
			$("input[id=st_maker_name]").css("background-color", "#ffffff");
			$("input[id=st_maker_name]").attr("readonly", false);
			
			$("input[id=st_origin_name]").css("border", "solid 1px #d2d2d2");
			$("input[id=st_origin_name]").css("padding", "2px");
			$("input[id=st_origin_name]").css("background-color", "#ffffff");
			$("input[id=st_origin_name]").css("cursor", "pointer");
			$("input[id=st_origin_name]").attr("onclick", "doPop('country')");
		}else{
			for(var i=0; i<tot_cnt; i++){
				$("input[id=st_buyer_item_no]").eq(i).val("");
				$("input[id=st_buyer_item_no]").eq(i).css("border", "solid 1px #d2d2d2");
				$("input[id=st_buyer_item_no]").eq(i).css("padding", "2px");
				$("input[id=st_buyer_item_no]").eq(i).css("background-color", "#ffffff");
				$("input[id=st_buyer_item_no]").eq(i).attr("readonly", false);

				// 품명, 규격 ID 중복으로 방식 변경
				document.forms.contentForm.st_description[i].style.border = "solid 1px #d2d2d2";
				document.forms.contentForm.st_description[i].style.padding = "2px";
				document.forms.contentForm.st_description[i].style.backgroundColor = "#ffffff";
				document.forms.contentForm.st_description[i].readOnly = false;
				
				document.forms.contentForm.st_specification[i].style.border = "solid 1px #d2d2d2";
				document.forms.contentForm.st_specification[i].style.padding = "2px";
				document.forms.contentForm.st_specification[i].style.backgroundColor = "#ffffff";
				document.forms.contentForm.st_specification[i].readOnly = false;
				
				//$("select[id=st_unit_measure]").eq(i).attr("disabled", false);
				
				$("input[id=st_maker_name]").eq(i).css("border", "solid 1px #d2d2d2");
				$("input[id=st_maker_name]").eq(i).css("padding", "2px");
				$("input[id=st_maker_name]").eq(i).css("background-color", "#ffffff");
				$("input[id=st_maker_name]").eq(i).attr("readonly", false);
				
				$("input[id=st_origin_name]").eq(i).css("border", "solid 1px #d2d2d2");
				$("input[id=st_origin_name]").eq(i).css("padding", "2px");
				$("input[id=st_origin_name]").eq(i).css("background-color", "#ffffff");
				$("input[id=st_origin_name]").eq(i).css("cursor", "pointer");
				$("input[id=st_origin_name]").eq(i).attr("onclick", "doPop('country',"+ i + ")");
			}
		}
	
		editMode = "Y";
	// 정보수정 활성 -> 비활성
	}else{
		if(tot_cnt <= 1) {
			// 품목코드 변경사항 없을 시 기존 품목코드로 변경
			if(document.forms.contentForm.st_buyer_item_no.value == ""){
				$("input[id=st_buyer_item_no]").val($("input[id=st_buyer_item_no_tmp]").val());
			}
			$("input[id=st_buyer_item_no]").css("border", "0px");
			$("input[id=st_buyer_item_no]").css("background-color", "transparent");
			$("input[id=st_buyer_item_no]").attr("readonly", true);
			
			// 품명, 규격 ID 중복으로 방식 변경
			document.forms.contentForm.st_description.style.border = "0px";
			document.forms.contentForm.st_description.style.backgroundColor = "transparent";
			document.forms.contentForm.st_description.readOnly = true;
			
			document.forms.contentForm.st_specification.style.border = "0px";
			document.forms.contentForm.st_specification.style.backgroundColor = "transparent";
			document.forms.contentForm.st_specification.readOnly = true;
			
			//$("select[id=st_unit_measure]").attr("disabled", true);
			
			$("input[id=st_maker_name]").css("border", "0px");
			$("input[id=st_maker_name]").css("background-color", "transparent");
			$("input[id=st_maker_name]").attr("readonly", true);
			
			$("input[id=st_origin_name]").css("border", "0px");
			$("input[id=st_origin_name]").css("background-color", "transparent");
			$("input[id=st_origin_name]").css("cursor", "default");
			$("input[id=st_origin_name]").attr("readonly", true);
			$("input[id=st_origin_name]").attr("onclick", '').unbind('click');
		}else{
			for(var i=0; i<tot_cnt; i++){
				// 품목코드 변경사항 없을 시 기존 품목코드로 변경
				if(document.forms.contentForm.st_buyer_item_no[i].value == ""){
					$("input[id=st_buyer_item_no]").eq(i).val($("input[id=st_buyer_item_no_tmp]").eq(i).val());
				}
				$("input[id=st_buyer_item_no]").eq(i).css("border", "0px");
				$("input[id=st_buyer_item_no]").eq(i).css("background-color", "transparent");
				$("input[id=st_buyer_item_no]").eq(i).attr("readonly", true);
				
				// 품명, 규격 ID 중복으로 방식 변경
				document.forms.contentForm.st_description[i].style.border = "0px";
				document.forms.contentForm.st_description[i].style.backgroundColor = "transparent";
				document.forms.contentForm.st_description[i].readOnly = true;
				
				document.forms.contentForm.st_specification[i].style.border = "0px";
				document.forms.contentForm.st_specification[i].style.backgroundColor = "transparent";
				document.forms.contentForm.st_specification[i].readOnly = true;
				
				//$("select[id=st_unit_measure]").eq(i).attr("disabled", true);
				
				$("input[id=st_maker_name]").eq(i).css("border", "0px");
				$("input[id=st_maker_name]").eq(i).css("background-color", "transparent");
				$("input[id=st_maker_name]").eq(i).attr("readonly", true);
				
				$("input[id=st_origin_name]").eq(i).css("border", "0px");
				$("input[id=st_origin_name]").eq(i).css("background-color", "transparent");
				$("input[id=st_origin_name]").eq(i).css("cursor", "default");
				$("input[id=st_origin_name]").eq(i).attr("readonly", true);
				$("input[id=st_origin_name]").eq(i).attr("onclick", '').unbind('click');
			}
		}
		
		editMode = "N";
	}
}
</script>
</html>
