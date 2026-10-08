<%--
**********************************************
* 메뉴 : 고객사 > 상품검색 > 카탈로그 조회(관리자용)
* 화면 : 카탈로그 조회(관리자용)
* 기능 : 코웨이 관리자 전용 카탈로그 조회 화면
* 프로그램 ID : 
* 담당자 : HSJ
* 생성일 : 2017-06-19
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
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과
	String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
	
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = (String) request.getParameter("onepagerow");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	// 조회조건 S
	String st_maker_name = CommonUtil.nvl((String) request.getParameter("st_maker_name"),"");  // 
	String st_specification_loc = CommonUtil.nvl((String) request.getParameter("st_specification_loc"),"");  //
	String st_description_loc = CommonUtil.nvl((String) request.getParameter("st_description_loc"),"");  //
	String st_buyer_item_no = CommonUtil.nvl((String) request.getParameter("st_buyer_item_no"),"");  //
	String st_com_code = CommonUtil.nvl((String) request.getParameter("st_com_code"),_sessionInfo.getComCode());  // 계열사정보
	
	String SessionUserId = "";
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	if (sessionInfo != null){ 
		SessionUserId = sessionInfo.getUserId();
	}
	boolean getCodeTGCM = CommonUtil.getCode3CheckReturn("ADCA", SessionUserId, com_code);
	String group_mng_flag = "N";
	if(getCodeTGCM == true){
		   group_mng_flag = "Y"; 
	}
%> 

<body onload="kep_onload_view()">
<div id="wrapper"> 
<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   

<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>

<!--내용 시작-->
<div id="container2">
	
<div id="ContArea">
	<h3><%=CommonLang.get("HTITLE527")%></h3>	<!-- 카탈로그 조회 -->
	<!--버튼영역-->
     <div id="searchBtnA">
     	<span class="btn_search"><a href="javascript:kepSearch(1);"><%=CommonLang.get("HTITLE7")%></a></span> <!-- 조회 --> 
		<span class="btn_reset"><a href="javascript:reload();"><%=CommonLang.get("HTITLE8")%></a></span> <!-- 초기화 -->
     </div>
	<!--조회영역-->
		<form name = "searchForm" id="searchForm" method = "post">
		<!--HIDDEN-->
			<input type="hidden" name="st_check" id="st_check"		value="">
			<input type="hidden" name="st_buyer" id="st_buyer" value="${sessionInfo.comCode}">
			<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
			<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
			<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
			<input type="hidden" name="st_group_mng_flag" id="st_group_mng_flag" value="<%=group_mng_flag%>">
				
			<div id="cont_searchA">	
				<table class="cont_t_list01" >
					<caption>카탈로그 조회(관리자용)</caption>
					<colgroup>
						<col width="12%" />
						<col width="38%" />
						<col width="12%" />
						<col width="38%" />
					</colgroup>
					
					<tbody>
					<tr>
						<th><%=CommonLang.get("HTITLE291")%></a></span> <!-- 고객사명 --></th>
						<td>
							<select name="st_com_code" id="st_com_code" style="width:60%;height:20px;">
					        	<%= CommonUtil.getCode3ComboList(_sessionInfo.getComCode(), "ALL", "ADCA",_sessionInfo.getUserId(), "ICOMCOD3", st_com_code, "") %>
					        </select>
						</td>
						<th></th>
						<td>
						</td>
					</tr>
                     <tr>
						<th><%=CommonLang.get("HTITLE13")%></th> <!-- 품목명  -->
						<td>
							<input type="text" class="input_type_text" name="st_description_loc" id="st_description_loc" style="width:90%;" value="<%=st_description_loc%>" onKeyDown="kepEnter()">							
						</td>
						<th><%=CommonLang.get("HTITLE12")%></th> <!-- 품목코드 -->
						<td >
							<input type="text" class="input_type_text" name="st_buyer_item_no" id="st_buyer_item_no" style="width:90%;" value="<%=st_buyer_item_no%>" onkeyup="kepToUpper('st_buyer_item_no')" onKeyDown="kepEnter()">
						</td>
                     </tr>                     
					<tr>
						<th><%=CommonLang.get("HTITLE14")%></th> <!-- 규격 -->
						<td >
							<input type="text" class="input_type_text" name="st_specification_loc" id="st_specification_loc" style="width:90%;" value="<%=st_specification_loc%>" onKeyDown="kepEnter()">
						</td>
						<th><%=CommonLang.get("HTITLE15")%></th> <!-- 제조사 -->
						<td>
							<input type="text" class="input_type_text" name="st_maker_name" id="st_maker_name" style="width:90%;" value="<%=st_maker_name%>" onKeyDown="kepEnter()">							
						</td>
                     </tr>
					</tbody>
				</table>
			</div>
  		
  		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
       	<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow">
				<option value = "10" <%if ("10".equals(onepagerow)) {%>selected<%} %>>10<%=CommonLang.get("HTITLE595")%></option>
				<option value = "20" <%if ("20".equals(onepagerow)) {%>selected<%} %>>20<%=CommonLang.get("HTITLE595")%></option>
				<option value = "30" <%if ("30".equals(onepagerow)) {%>selected<%} %>>30<%=CommonLang.get("HTITLE595")%></option>
				<option value = "40" <%if ("40".equals(onepagerow)) {%>selected<%} %>>40<%=CommonLang.get("HTITLE595")%></option>
				<option value = "50" <%if ("50".equals(onepagerow)) {%>selected<%} %>>50<%=CommonLang.get("HTITLE595")%></option>
			</select>
       	</span>
        <span class="fr"><%=CommonLang.get("HTITLE608")%><!-- 총건수 --> <%=total_cnt %></span>
 		<br>
	</form> 
<form name = "contentForm" id="contentForm" method = "post">
	<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
	<table id="table_list" class="cont_t_list02" style="width:100%">
		<colgroup>
            <col width="18%" />
            <col width="12%" />
            <col width="55%" />
            <col width="15%" />
        </colgroup>
        <thead>
			<tr>
                <th scope="col"><%=CommonLang.get("HTITLE291")%><!--고객사명  --></th>
                <th scope="col"><%=CommonLang.get("HTITLE395")%><!--이미지  --></th>
                <th scope="col"><%=CommonLang.get("HTITLE12")%> <!-- 품목코드 --> / <%=CommonLang.get("HTITLE13")%><!-- 품목명  --><br><%=CommonLang.get("HTITLE14")%><!-- 규격 --></th>
                <th scope="col"><%=CommonLang.get("HTITLE15")%><!-- 제조사 --></th>
			</tr>
		</thead>
		<tbody>
 		<%
        if (_gridList == null || _gridList.size() == 0){
        %>
                    <tr>
                        <td colspan="4" align="center" height = "80"> 
                        <span><%=CommonLang.msg("MSG347")%></span>	<!-- 조회된 데이타가 없습니다. -->
                        </td> 
                    </tr>
        <%
		}else{
        	
        	String aaa=null;
            
			for (int j=0; j<_gridList.size(); j++) {
				Map<String,String> rowData = _gridList.get(j);
				String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";

		%> 
				<tr align="center" bgcolor="<%=tclass%>">
					<td title="사업장" rowspan ="2"><%=String.valueOf(CommonUtil.nvl(rowData.get("BUYER_NAME")))%></td>
					<td title="이미지" rowspan ="2">
        <%
	        String image_dr  = rowData.get("IMGFILE_DIR");
	        String image_sm = rowData.get("IMGFILE_NAME");
	        
	        if (image_sm == null || image_sm.equals("null") || image_sm.equals("") || image_sm.equals(" ")){
	        	image_sm = "noimage.gif";
	        }
	        
	        if(image_sm.equals("noimage.gif")) {
        %>             
                     	<img src="/resources/images/<%=image_sm%>" width="80" height="80">
       <%}else{%>
       					<img src = "<%=CommonUtil.realImgS3UploadPath+"/"+image_dr+"/"+image_sm%>"   width="80" height="80">
       <%}%>              	
                     </td>
                     <td title="품목코드/품목명" class="left">
              			<%
						//사용자 언어타입이 영어일 영문 품명 표기
						if(h_get_session_user_lang.equals("EN")) {
						%>
	                     	<b><%=String.valueOf(CommonUtil.nvl(rowData.get("BUYER_ITEM_NO")))%></b>&nbsp;
	                     	<%=String.valueOf(CommonUtil.nvl(rowData.get("DESCRIPTION_ENG")))%>
						<%
						}else{
						%>
	                     	<a class="hyperLink" href="javascript:doPop('sellerMpClGoodsDetailInfoCowayPop','<%=rowData.get("BYIT_COMORG_CODE")%>','<%=rowData.get("BUYER_ITEM_NO")%>');"><b><%=String.valueOf(CommonUtil.nvl(rowData.get("BUYER_ITEM_NO")))%></b></a>&nbsp;
	                     	<%=String.valueOf(CommonUtil.nvl(rowData.get("DESCRIPTION")))%>
						<%
						}
						%> 
                     </td>
                     <td title="제조사" rowspan ="2"><%=String.valueOf(CommonUtil.nvl(rowData.get("MAKER_NAME")))%></td>
				</tr>
				
				<tr bgcolor="<%=tclass%>" align="center" height="25">
              			<%
						//사용자 언어타입이 영어일 영문 품명 표기
						if(h_get_session_user_lang.equals("EN")) {
						%>
							<td title="규격" class="left"><%=String.valueOf(CommonUtil.nvl(rowData.get("SPECIFICATION_ENG")))%></td>
						<%
						}else{
						%>
							<td title="규격" class="left"><%=String.valueOf(CommonUtil.nvl(rowData.get("SPECIFICATION")))%></td>
						<%
						}
						%>
				</tr>
            <%
			} 
            %>
		<%
		} 
		%> 
           		</tbody>
            </table>
		<!--페이징-->
		<p id="paging" class="paging">
			<%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow) %> 
			<span class="cl"><%=CommonLang.get("HTITLE598")%> <%=total_cnt %><%=CommonLang.get("HTITLE599")%></span> 								<!-- [ 총  건 ] -->
		</p>  
		
</form>

</div>

<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/buyerFooter.jsp" %>   
</div>
</body>

<script type="text/javascript">

//기능함수
function doAction(str) {
	switch (str) {
	case "search":
		kepSearch(1);
		break;
	}
}

/*
 * FORM 을 이용한조회
 */
function kepSearch(curPage){
	var spec = document.forms.searchForm.st_specification_loc.value;
	var maker = document.forms.searchForm.st_maker_name.value;
	var desc = document.forms.searchForm.st_description_loc.value;
	var item_no = document.forms.searchForm.st_buyer_item_no.value;
	
	if(kepTrimStr(spec)=="" && kepTrimStr(maker) == "" && kepTrimStr(desc) == "" && kepTrimStr(item_no) == ""){
		//검색조건을 입력하세요.
		alert("<%=CommonLang.msg("MSG395")%>"); 
		
		return;
	}
	
	document.forms.searchForm.curPage.value = curPage;
	$('#searchForm').attr("action", "/mdam/getBuyerMdAmCatalogCoway.do").submit();   
}

/**
 * FORM 을 초기화
 */
function reload(){
	
	kepReload("searchForm");
	
// 	kepSearch(-1);
	jspTableClean("table_list","5");
}
  
/*
 *  최초 화면 함수
 */
function kep_onload_view(){
}	

//팝업함수호출
function doPop(str, value1, value2) {
	
	switch (str) {
		case "sellerMpClGoodsDetailInfoCowayPop": // 품목정보상세
			popupSel = "sellerMpClGoodsDetailInfoCowayPop";
			openSearchPopup("/mpcl/getSellerMpClGoodsDetailInfoCowayPop.do", "?st_byit_comorg_code="+value1+"&st_item_no="+value2, "850,500,no");
			break;
	}
}
</script>
</html>
