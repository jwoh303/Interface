<%--
**********************************************
* 메뉴 : 상품관리>고객사 카탈로그 관리>통합 카탈로그 검색
* 화면 : 통합 카탈로그 검색
* 기능 : 통합 카탈로그 검색
* 프로그램 ID : PG_03_M_004_00
* 담당자 : 홍석규 ( 설계 : 권우재 )
* 착수일 : 2014-07-31
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
	// 공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	String total_cnt =CommonUtil.nvl((String)request.getAttribute("totalCnt"),"0"); // 조회된 결과
	
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),"10");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	
	String st_sort_change = CommonUtil.nvl((String) request.getParameter("st_sort_change"),"");
	String searchSort = CommonUtil.nvl((String) request.getParameter("searchSort"),"");   
	
	String SessionComCode = "";
	String image_status = CommonUtil.nvl((String) request.getParameter("st_image_status"),"IMAGE_HIDDEN");   
	String img_view_flag   = "";
	
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	if (sessionInfo != null){ 
		SessionComCode =  CommonUtil.nvl((String)sessionInfo.getComCode()); 
		img_view_flag =  CommonUtil.nvl((String)sessionInfo.getImgViewFlag()); 
	}  
	if(image_status.equals("")){ 
        image_status =  img_view_flag.trim().equals("Y")?"IMAGE_VIEW":"IMAGE_HIDDEN"; 
    }
	
	String st_categ_name = CommonUtil.nvl((String) request.getParameter("st_categ_name"),""); 
	String st_agent_name = CommonUtil.nvl((String) request.getParameter("st_agent_name"),""); 
	String st_buyer_item_no = CommonUtil.nvl((String) request.getParameter("st_buyer_item_no"),""); 
	String st_description = CommonUtil.nvl((String) request.getParameter("st_description"),""); 
	String st_specification = CommonUtil.nvl((String) request.getParameter("st_specification"),""); 
	String st_maker_name = CommonUtil.nvl((String) request.getParameter("st_maker_name"),"");
	String st_exclude_string = CommonUtil.nvl((String) request.getParameter("st_exclude_string"),"");
	String st_exclude_type = CommonUtil.nvl((String) request.getParameter("st_exclude_type"),"");
	
	/* 결과 내 검색 관련 파라미터 */
	String searchInResult = CommonUtil.nvl((String) request.getParameter("searchInResult"),"");
	String st_categ_name_field = CommonUtil.nvl((String) request.getParameter("st_categ_name_field"),""); 
	String st_agent_name_field = CommonUtil.nvl((String) request.getParameter("st_agent_name_field"),""); 
	String st_buyer_item_no_field = CommonUtil.nvl((String) request.getParameter("st_buyer_item_no_field"),""); 
	String st_description_field = CommonUtil.nvl((String) request.getParameter("st_description_field"),""); 
	String st_specification_field = CommonUtil.nvl((String) request.getParameter("st_specification_field"),""); 
	String st_maker_name_field = CommonUtil.nvl((String) request.getParameter("st_maker_name_field"),"");
	String st_exclude_string_field = CommonUtil.nvl((String) request.getParameter("st_exclude_string_field"),"");
	String st_exclude_type_field = CommonUtil.nvl((String) request.getParameter("st_exclude_type_field"),"");
	
	boolean list = true;
	 if (_gridList == null || _gridList.size() == 0){
		 list = false;
	 }
%> 
<script src="/resources/js/common.js"></script>
<script>
var popupSel = "";

function kep_onload_view() {
}
	
// 기능함수
function doAction(str , gubun) {
	
	switch (str) {
	case "search":	 // 조회
		kepSearch(1);
		break;
	
	case "reload":	// 초기화
		kepReload('searchForm');
		$("#st_categ_id").val("");
		$("#st_agent_code").val("");
		$("#st_description_field").val("");
		$("#st_specification_field").val("");
		$("#st_maker_name_field").val("");
		$("#searchInResult").attr("checked", false);
		break;

	}
}

//조회
function kepSearch(curPage){
	
	var st_categ_name = TrimCommon($("#st_categ_name").val());
	var st_agent_name = TrimCommon($("#st_agent_name").val());
	var st_buyer_item_no = TrimCommon($("#st_buyer_item_no").val());
	var st_description = TrimCommon($("#st_description").val());
	var st_specification = TrimCommon($("#st_specification").val());
	var st_maker_name = TrimCommon($("#st_maker_name").val());
	
	if(st_categ_name == "" && st_agent_name == "" && st_buyer_item_no == "" && st_description == "" && st_specification == "" && st_maker_name == ""){
		alert("최소 한가지의 검색조건은 입력하여 주십시요(제외 문자 비포함)");
		return;
	}
	
	//결과내 검색
	setQuerySearchInResult();

	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mdcm/getMasterMdCmCatalogSearchList.do").submit();
}

//회원사상세정보 팝업
function getAgentDisplayPop(agent){
	openSearchPopup("/mdcp/showMasterMdCpCompyDetailViewPop.do", '?com_code='+agent, "800,600,no");
}

//고객사 상세정보 팝업
function getBuyerCatalogDisplay(buyer, catalog_com_code, buyer_item_no){
	/* AS-IS
	var catalog_com_code = mySheet.GetCellValue(Row,"BUYER");
	var buyer = $("#st_buyer_code").val();
	var buyer_item_no = mySheet.GetCellValue(Row,"BUYER_ITEM_NO");
	*/
	//openSearchPopup("/mdcm/showMasterMdCmBuyerCatalogAlterPop.do", '?st_buyer_code='+buyer+'&st_catalog_com_code='+catalog_com_code+'&st_buyer_item_no='+buyer_item_no+'&st_edit_yn=N', "988,710,no");
	
	//post 팝업 파라미터 설정
	var st_form_name = "masterMdCmBuyerCatalogAlterPop";
	var st_popup_url = "/mdcm/showMasterMdCmBuyerCatalogAlterPop.do";
	var st_popup_param = "st_buyer_code@@"+buyer+"^||^"+"st_catalog_com_code@@"+catalog_com_code+"^||^"+"st_buyer_item_no@@"+buyer_item_no+"^||^"+"st_edit_yn@@N";
	var st_popup_option = "988,710,no";
	//post 팝업 호출
	openSearchPopupAppendPost(st_form_name,st_popup_url,st_popup_param,st_popup_option);
}

//단가변경이력 팝업
function setSysopCqepHistory(buyer, contractNo, contractSeq){ 
	openSearchPopup("/mdcm/showMasterMdCmUnitpriceAlterHistoryPop.do", '?st_buyer='+buyer+'&st_contract_no='+contractNo+'&st_contract_seq='+contractSeq, "840,250,no");
}

//상품 큰이미지
function getBigImage(file_dir, file_name){	
	getBigImageView("<%= CommonUtil.getURL(request) %><%=CommonUtil.realImgS3UploadPath%>", file_dir, file_name);
}

function searchSort(gubun){
	
	var st_sort_change = document.forms.searchForm.st_sort_change.value;
	
	if (st_sort_change == "" || st_sort_change == "DOWN"){
		st_sort_change = "UP";
	}else{
		st_sort_change = "DOWN";
	}
	
	document.forms.searchForm.st_sort_change.value = st_sort_change;
	document.forms.searchForm.st_sort_change.value = st_sort_change;
	document.forms.searchForm.searchSort.value = gubun + "_"+st_sort_change; 

	kepSearch(1);
}

//이미지 보이기 숨기기
function imageHideView(){ 
	
    var image_status   = document.forms.searchForm.st_image_status.value;
    if(image_status == "IMAGE_HIDDEN"){
        image_status = "IMAGE_VIEW"; 
    }else if(image_status == "IMAGE_VIEW"){
        image_status = "IMAGE_HIDDEN"; 
    }
    document.forms.searchForm.st_image_status.value = image_status;
	 // 처리후 재조회
	 kepSearch($("#curPage").val());
}

function setQuerySearchInResult(){
	// 결과 내 검색 로직 추가
	if($("#searchInResult").is(":checked")){ // 체크를 한 경우
		//===============협력사==================//
		if($("#st_agent_name_field").val()=="ALL") {
			$("#st_agent_name_field").val("");
		}
		
		if(!isEmpty($("#st_agent_name").val())) {
			$("#st_agent_name_field").val($("#st_agent_name_field").val()+$("#st_agent_name").val()+"||");
		}
		
		//===============카테고리==================//
		if($("#st_categ_name_field").val()=="ALL") {
			$("#st_categ_name_field").val("");
		}
		
		if(!isEmpty($("#st_categ_name").val())) {
			$("#st_categ_name_field").val($("#st_categ_name_field").val()+$("#st_categ_name").val()+"||");
		}
		
		//===============제조사==================//
		if($("#st_maker_name_field").val()=="ALL") {
			$("#st_maker_name_field").val("");
		}
		
		if(!isEmpty($("#st_maker_name").val())) {
			$("#st_maker_name_field").val($("#st_maker_name_field").val()+$("#st_maker_name").val()+"||");
		}
		
		//===============품목코드==================//
		if($("#st_buyer_item_no_field").val()=="ALL") {
			$("#st_buyer_item_no_field").val("");
		}
		
		if(!isEmpty($("#st_buyer_item_no").val())) {
			$("#st_buyer_item_no_field").val($("#st_buyer_item_no_field").val()+$("#st_buyer_item_no").val()+"||");
		}
		
		//===============품명==================//
		if($("#st_description_field").val()=="ALL") {
			$("#st_description_field").val("");
		}
		
		if(!isEmpty($("#st_description").val())) {
			$("#st_description_field").val($("#st_description_field").val()+$("#st_description").val()+"||");
		}
		
		//===============규격==================//
		if($("#st_specification_field").val()=="ALL") {
			$("#st_specification_field").val("");
		}
		
		if(!isEmpty($("#st_specification").val())) {
			$("#st_specification_field").val($("#st_specification_field").val()+$("#st_specification").val()+"||");
		}
		
		//===============제외 문자==================//
		if($("#st_exclude_type_field").val()=="ALL") {
			$("#st_exclude_type_field").val("");
		}
		
		if(!isEmpty($("#st_exclude_type").val())) {
			$("#st_exclude_type_field").val($("#st_exclude_type_field").val()+$("#st_exclude_type").val()+"||");
		}
		
		if($("#st_exclude_string_field").val()=="ALL") {
			$("#st_exclude_string_field").val("");
		}
		
		if(!isEmpty($("#st_exclude_string").val())) {
			$("#st_exclude_string_field").val($("#st_exclude_string_field").val()+$("#st_exclude_string").val()+"||");
		}
	}else{ // 체크를 하지 않은 경우
		//===============협력사==================//
		if(!isEmpty($("#st_agent_name").val())) {
			$("#st_agent_name_field").val($("#st_agent_name").val() +"||");
		}else {
			$("#st_agent_name_field").val("ALL");
		}
	
		//===============카테고리==================//
		if(!isEmpty($("#st_categ_name").val())) {
			$("#st_categ_name_field").val($("#st_categ_name").val() +"||");
		}else {
			$("#st_categ_name_field").val("ALL");
		}
		
		//===============제조사==================//
		if(!isEmpty($("#st_maker_name").val())) {
			$("#st_maker_name_field").val($("#st_maker_name").val() +"||");
		}else {
			$("#st_maker_name_field").val("ALL");
		}
		
		//===============품목코드==================//
		if(!isEmpty($("#st_buyer_item_no").val())) {
			$("#st_buyer_item_no_field").val($("#st_buyer_item_no").val() +"||");
		}else {
			$("#st_buyer_item_no_field").val("ALL");
		}
		
		//===============품명==================//
		if(!isEmpty($("#st_description").val())) {
			$("#st_description_field").val($("#st_description").val() +"||");
		}else {
			$("#st_description_field").val("ALL");
		}
		
		//===============규격==================//
		if(!isEmpty($("#st_specification").val())) {
			$("#st_specification_field").val($("#st_specification").val() +"||");
		}else {
			$("#st_specification_field").val("ALL");
		}
		
		//===============제외 문자==================//
		if(!isEmpty($("#st_exclude_type").val())) {
			$("#st_exclude_type_field").val($("#st_exclude_type").val() +"||");
		}else {
			$("#st_exclude_type_field").val("ALL");
		}
		
		if(!isEmpty($("#st_exclude_string").val())) {
			$("#st_exclude_string_field").val($("#st_exclude_string").val() +"||");
		}else {
			$("#st_exclude_string_field").val("ALL");
		}
		
	}
}
	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>통합 카탈로그 검색</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchForm" id="searchForm" method = "post">
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" name="searchSort" id="searchSort"  value="<%=searchSort%>" />
			<input type="hidden" name="st_sort_change" id="st_sort_change" value="<%=st_sort_change %>">  
 			<input type="hidden" name="st_image_status" id="st_image_status" value="<%=image_status %>">
			<!-- 결과 내 검색에 필요한 파라미터 -->
			<input type="hidden" id="st_agent_name_field" name="st_agent_name_field" value="<%=st_agent_name_field%>">
			<input type="hidden" id="st_categ_name_field" name="st_categ_name_field" value="<%=st_categ_name_field%>">
			<input type="hidden" id="st_maker_name_field" name="st_maker_name_field" value="<%=st_maker_name_field%>">
			<input type="hidden" id="st_buyer_item_no_field" name="st_buyer_item_no_field" value="<%=st_buyer_item_no_field%>">
			<input type="hidden" id="st_description_field" name="st_description_field" value="<%=st_description_field%>">
			<input type="hidden" id="st_specification_field" name="st_specification_field" value="<%=st_specification_field%>">
			<input type="hidden" id="st_exclude_type_field" name="st_exclude_type_field" value="<%=st_exclude_type_field%>">
			<input type="hidden" id="st_exclude_string_field" name="st_exclude_string_field" value="<%=st_exclude_string_field%>">
 			
			
            	<table  class="cont_t_list01" >
					<caption>통합 카탈로그 검색</caption>
					<colgroup>
						<col width="8%" />
						<col width="25%" />
						<col width="8%" />
						<col width="25%" />
						<col width="8%" />
						<col width="25%" />
					</colgroup>
						
					<tbody>
						<tr>
							<th>협력사</th>
							<td>
								<input type="text"   class="input_type_text" name="st_agent_name" id="st_agent_name" value="<%=st_agent_name %>" style="width:87%" value="" onKeyDown="kepEnter()">
							</td>
							<th>카테고리</th>
							<td>
								<input type="text"   class="input_type_text" name="st_categ_name" id="st_categ_name" value="<%=st_categ_name %>"  style="width:87%" value="" onKeyDown="kepEnter()">
							</td>
							<th>제조사</th>
							<td>
								<input type="text"   class="input_type_text" name="st_maker_name" id="st_maker_name" value="<%=st_maker_name %>"  style="width:87%" value="" onKeyDown="kepEnter()">
							</td>
						</tr>
						<tr>
							<th>품목코드</th>
							<td>
								<input type="text" class="input_type_text" id="st_buyer_item_no" name="st_buyer_item_no" value="<%=st_buyer_item_no %>"  style="width:87%"  value="" onKeyUp="kepToUpper('st_buyer_item_no')" onkeydown="kepEnter()">
							</td>
							<th>품목명</th>
							<td>
								<input type="text"   class="input_type_text" name="st_description" id="st_description" value="<%=st_description %>"  style="width:87%" value="" onKeyDown="kepEnter()">
							</td>
							<th>규격</th>
							<td>
								<input type="text"   class="input_type_text" name="st_specification" id="st_specification" value="<%=st_specification %>"  style="width:87%" value="" onKeyDown="kepEnter()">
							</td>
						</tr>
						<tr>
							<th>제외 문자</th>
							<td>
								<select id="st_exclude_type" name="st_exclude_type" style="width : 30%;">
									<option value="DESCRIPTION" <%if("DESCRIPTION".equals(st_exclude_type)){ %>selected="selected"<%} %>>품목명</option>
									<option value="AGENT_NAME" <%if("AGENT_NAME".equals(st_exclude_type)){ %>selected="selected"<%} %>>협력사</option>
									<option value="CATEG_NAME" <%if("CATEG_NAME".equals(st_exclude_type)){ %>selected="selected"<%} %>>카테고리</option>
									<option value="MAKER_NAME" <%if("MAKER_NAME".equals(st_exclude_type)){ %>selected="selected"<%} %>>제조사</option>
									<option value="BUYER_ITEM_NO" <%if("BUYER_ITEM_NO".equals(st_exclude_type)){ %>selected="selected"<%} %>>품목코드</option>
									<option value="SPECIFICATION" <%if("SPECIFICATION".equals(st_exclude_type)){ %>selected="selected"<%} %>>규격</option>
									<option value="LAST_PO_DATE" <%if("LAST_PO_DATE".equals(st_exclude_type)){ %>selected="selected"<%} %>>최근발주일</option>
								</select>
								<input type="text" class="input_type_text" id="st_exclude_string" name="st_exclude_string" value="<%=st_exclude_string %>" style="width:56%" onKeyDown="kepEnter()"/>
							</td>
							<th>결과 내 검색</th>
							<td><input type="checkbox" id="searchInResult" name="searchInResult" value="IN_RESULT" <%if("IN_RESULT".equals(searchInResult)){ %>checked="checked"<%} %>></td>
							<th>&nbsp;</th>
							<td>&nbsp;</td>
						</tr>
					</tbody>
				</table>
            </div>
            
           
			<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
	      	<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow" onchange="javascript:kepSearch(1);"> 
				<option value = "10" <%if ("10".equals(onepagerow)) {%>selected<%} %>>10건</option>
				<option value = "15" <%if ("15".equals(onepagerow)) {%>selected<%} %>>15건</option>
				<option value = "20" <%if ("20".equals(onepagerow)) {%>selected<%} %>>20건</option>
				<option value = "25" <%if ("25".equals(onepagerow)) {%>selected<%} %>>25건</option>
				<option value = "50" <%if ("50".equals(onepagerow)) {%>selected<%} %>>50건</option> 
				<option value = "100" <%if ("100".equals(onepagerow)) {%>selected<%} %>>100건</option> 
			</select>	
			&nbsp;		
			<span class="btn_gray_06">
		      <%  if(image_status.equals("IMAGE_HIDDEN")){   %>
		      <div title="이미지보이기" ><a href="javascript:imageHideView();">이미지보이기</a></div>
		      <%  }else{   %>
		     <div title="이미지감추기" ><a href="javascript:imageHideView();">이미지감추기</a></div>
		      <%  }   %>
     		</span>
			&nbsp;
			<span class="btn_gray_04" title="품목코드" ><a href="javascript:searchSort('BUYER_ITEM_NO');">품목코드</a></span>
			&nbsp;
			<span class="btn_gray_03" title="품목명" ><a href="javascript:searchSort('DESCRIPTION');">품목명</a></span>
			&nbsp;
			<span class="btn_gray_02" title="규격" ><a href="javascript:searchSort('SPECIFICATION');">규격</a></span>
			&nbsp;
			<span class="btn_gray_03" title="제조사" ><a href="javascript:searchSort('MAKER_NAME');">제조사</a></span>
			&nbsp;
			<span class="btn_gray_04" title="실적단가" ><a href="javascript:searchSort('TARGET_PRICE');">실적단가</a> </span>
			&nbsp;
			<span class="btn_gray_04" title="최근발주일" ><a href="javascript:searchSort('LAST_PO_DATE');">최근발주일</a> </span>
      	</span>
			<br>
		</form>
					
      	<form name = "contentForm" id="contentForm" method = "post">
		<!--grid header-->
		<table  class="cont_t_list02"  style="width:100%; margin-bottom:0px;">
			<colgroup>
	            <col width="11%" />
	            <col width="11%" />
	            <col width="35%" />
	            <col width="16%" />
	            <col width="16%" />
	            <col width="*" /> 
	        </colgroup>
	        <thead>
			<tr>
                <th scope="col">고객사코드</th>
                <th scope="col">이미지</th>
                <th scope="col">품목코드/품목명/규격</th>
                <th scope="col">원산지/제조사</th>
                <th scope="col">단위/협력사</th>
                <th scope="col">실적단가/최근발주일</th> 
			</tr>
			</thead>
		</table>
		
		<div style="min-height:394; height:394px; padding-bottom:10px; margin-bottom:10px; overflow-y:auto;">
		<table  class="cont_t_list02" style="width:100%; border-top:0px solid #6a98b5">
        <caption>카탈로그 조회</caption>
        <colgroup>
        		<col width="11%" />
            	<col width="11%" />
	            <col width="35%" />
	            <col width="16%" />
	            <col width="16%" />
	            <col width="*" /> 
        </colgroup>
		<tbody>
<%
if (list == false){
%>
                    <tr>
                        <td colspan="5" align="center" height = "50"> 
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
					<td title="고객사코드">
						<%=CommonUtil.nvl(rowData.get("COM_CODE"))%>
					</td>                      
					<td title="이미지">
<% if(image_status.equals("IMAGE_HIDDEN")){
       if("".equals(CommonUtil.nvl(rowData.get("IMGFILE_DIR")))){
%>
           <img src="/resources/images/but_img_off.gif" border="0"><br>
          <%=(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem.gif>")%>
          <%=(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem1.gif>")%>
 
<%     }else{ %> 
             <a href="javascript:getBigImage('<%=CommonUtil.nvl(rowData.get("IMGFILE_DIR"))%>','<%=CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>');">
             <img src="/resources/images/but_img_on.gif" border="0"></a><br>
          <%=(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem.gif>")%>
          <%=(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem1.gif>")%> 
 
<%     }
}else{
	if("".equals(CommonUtil.nvl(rowData.get("IMGFILE_DIR")))){
%>
          <img src="/resources/images/noimage.gif" width="80" height="80" border="0"><br>
          <%=(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem.gif>")%>
          <%=(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem1.gif>")%>
 
<%     }else{ %> 
             <a href="javascript:getBigImage('<%=CommonUtil.nvl(rowData.get("IMGFILE_DIR"))%>','<%=CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>');"><img src="<%=CommonUtil.realImgS3UploadPath+"/"+CommonUtil.nvl(rowData.get("IMGFILE_DIR"))+"/"+CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>" name="image1" width="80" height="80" border="0"></a><br>
          <%=(CommonUtil.nvl(rowData.get("OVER_SHORT_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem.gif>")%>
          <%=(CommonUtil.nvl(rowData.get("PRODUCT_CLOSE_FLAG")).equals("N") ? "" : "<img src=/resources/images/outitem1.gif>")%>
 
<%     }
    }
%>				
					</td>                      
                    <td class="left" title="품목코드/품목명/규격">&nbsp;<a class="hyperLink"  href="javascript:getBuyerCatalogDisplay('<%=CommonUtil.nvl(rowData.get("COM_CODE"))%>', '<%=CommonUtil.nvl(rowData.get("BUYER"))%>','<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>');">
                    <%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>&nbsp;
					 <input type="hidden" name="st_item_no" value="<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>" >
					<%=CommonUtil.nvl(rowData.get("DESCRIPTION_LOC"))%></a><br>
					&nbsp;<%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%> 
					 
                    </td>          
                   <td title="원산지/제조사">
				   <%=CommonUtil.nvl(rowData.get("ORIGIN_NAME"))%> <br>
				   <%=CommonUtil.nvl(rowData.get("MAKER_NAME"))%>

				   </td>            
                   <td title="단위/협력사">
				   
				 <%=CommonUtil.nvl(rowData.get("UNIT_MEASURE"))%> <br>
                 &nbsp;<a class="hyperLink"  href="javascript:getAgentDisplayPop('<%=CommonUtil.nvl(rowData.get("AGENT_2"))%>');"><%=(CommonUtil.nvl(rowData.get("AGENT")).equals("KOREAEPLATFORM")) ? "코리아e플랫폼(주)" : CommonUtil.nvl(rowData.get("AGENT"))%></a>
                   <input type="hidden" name="st_agent_flag"   value="<%=CommonUtil.nvl(rowData.get("AGENT"))%>">
                   <input type="hidden" name="st_agent_code"   value="<%=CommonUtil.nvl(rowData.get("AGENT_2"))%>">
                   <input type="hidden" name="st_contract_no"  value="<%=CommonUtil.nvl(rowData.get("CONTRACT_NO"))%>">
                   <input type="hidden" name="st_contract_seq" value="<%=CommonUtil.nvl(rowData.get("CONTRACT_SEQ"))%>">
                   <input type="hidden" name="st_byit_comorg_code" value="<%=CommonUtil.nvl(rowData.get("BUYER"))%>">
				   </td>            
                   <td title="실적단가" class="right">
				   <a class="hyperLink"  href="javascript:setSysopCqepHistory('<%=CommonUtil.nvl(rowData.get("BUYER"))%>','<%=CommonUtil.nvl(rowData.get("CONTRACT_NO"))%>','<%=CommonUtil.nvl(rowData.get("CONTRACT_SEQ"))%>');"><%=CommonUtil.formatNumber(rowData.get("TARGET_PRICE"),true,0,3)%></a> <br>
				   <%=CommonUtil.formatStrinigDate(CommonUtil.nvl(rowData.get("LAST_PO_DATE")))%>
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
		<p class="paging">
			<%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow) %> 
			<span class="cl">[ 총 <%=total_cnt %> 건 ]</span> 
		</p>  
		</div>
</form>

<!--내용 종료-->	                 

</body>
</html>
