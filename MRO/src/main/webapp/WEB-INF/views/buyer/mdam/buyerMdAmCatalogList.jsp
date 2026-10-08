<%--
**********************************************
* 메뉴 : 고객사 > 관리자 > 카탈로그 조회
* 화면 : 카탈로그 조회
* 기능 : 
* 프로그램 ID : PG_XX_XXXX
* 담당자 : 홍석규
* 생성일 : 2014-07-14
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
	
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = (String) request.getParameter("onepagerow");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	// 조회조건 S
	String st_from_date = CommonUtil.nvl((String) request.getParameter("st_from_date"),"");  // 견적일(From)
	String st_to_date = CommonUtil.nvl((String) request.getParameter("st_to_date"),"");  // 견적일(To)
	String st_status_text = CommonUtil.nvl((String) request.getParameter("st_status_text"),"승인");  
	String st_maker_name = CommonUtil.nvl((String) request.getParameter("st_maker_name"),"");  // 
	String st_specification_loc = CommonUtil.nvl((String) request.getParameter("st_specification_loc"),"");  //
	String st_description_loc = CommonUtil.nvl((String) request.getParameter("st_description_loc"),"");  //
	String st_buyer_item_no = CommonUtil.nvl((String) request.getParameter("st_buyer_item_no"),"");  //
	
%> 

<body onload="kep_onload_view()">
<div id="wrapper"> 
<!-----------------------------------------------------------------------------------------------header------------------------------------------------------------------------------------------------------->
<%@ include file="/WEB-INF/views/common/include/buyerHeader.jsp" %>   

<div id="container2">
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="buyerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>

<!--내용 시작-->
	
<div id="ContArea">
	<h3><%=CommonLang.get("HTITLE392")%><!-- 카탈로그조회 --></h3>
	<!--버튼영역-->
     <div id="searchBtnA">
     	<span class="btn_search"><a href="javascript:kepSearch(1);"><%=CommonLang.get("HTITLE7")%><!-- 조회 --></a></span> 
		<span class="btn_reset"><a href="javascript:reload();"><%=CommonLang.get("HTITLE8")%><!-- 초기화 --></a></span>
     </div>
	<!--조회영역-->
		<form name = "searchForm" id="searchForm" method = "post">
		<!--HIDDEN-->
			<input type="hidden" name="st_check" id="st_check"		value="">
			<input type="hidden" name="st_buyer" id="st_buyer" value="${sessionInfo.comCode}">
			<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
			<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
				
			<div id="cont_searchA">	
				<table class="cont_t_list01" >
					<caption><%=CommonLang.get("HTITLE392")%><!-- 카탈로그조회 --></caption>
					<colgroup>
						<col width="12%" />
						<col width="52%" />
						<col width="12%" />
						<col width="21%" />
					</colgroup>
					
					<tbody>
					<tr>
						<th><%=CommonLang.get("HTITLE393")%><!-- 등록일 --></th>
						<td>
							<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:20%; text-align:center;" value="<%=st_from_date%>">
								<a href="javascript:kepCalendar('st_from_date')"></a>
							-
							<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:100px; text-align:center;" value="<%=st_to_date%>">
								<a href="javascript:kepCalendar('st_to_date')"></a>
								&nbsp;&nbsp;
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1<%=CommonLang.get("HTITLE602")%><!-- 개월 --></a></span> 
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2<%=CommonLang.get("HTITLE602")%><!-- 개월 --></a></span> 
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3<%=CommonLang.get("HTITLE602")%><!-- 개월 --></a></span>
							<span class="btn_month"><a href="javascript:setCurMonth('st_from_date','st_to_date')">당월</a></span>									
						</td>
						<th><%=CommonLang.get("HTITLE255")%><!-- 상태 --></th>
						<td >
							<select id="st_status_text" name="st_status_text">
								<option value="삭제" <%if ("삭제".equals(st_status_text)) {%>selected<%} %>><%=CommonLang.get("HTITLE25")%><!-- 삭제 --></option>
								<option value="단종" <%if ("단종".equals(st_status_text)) {%>selected<%} %>><%=CommonLang.get("HTITLE394")%><!-- 단종 --></option>
								<option value="승인" <%if ("승인".equals(st_status_text)) {%>selected<%} %>><%=CommonLang.get("HTITLE321")%><!-- 승인 --></option>
							</select>
						</td>
                     </tr>
					</tbody>
				</table>
				<table class="cont_t_list01" >
					<caption><%=CommonLang.get("HTITLE392")%><!-- 카탈로그조회 --></caption>
					<colgroup>
						<col width="12%" />
						<col width="38%" />
						<col width="12%" />
						<col width="38%" />
					</colgroup>
					
					<tbody>
					<tr>
						<th><%=CommonLang.get("HTITLE14")%><!-- 규격 --></th>
						<td >
							<input type="text" class="input_type_text" name="st_specification_loc" id="st_specification_loc" style="width:90%;" value="<%=st_specification_loc%>" onKeyDown="kepEnter()">
						</td>
						<th><%=CommonLang.get("HTITLE15")%><!-- 제조사 --></th>
						<td>
							<input type="text" class="input_type_text" name="st_maker_name" id="st_maker_name" style="width:90%;" value="<%=st_maker_name%>" onKeyDown="kepEnter()">							
						</td>
                     </tr>
                     <tr>
						<th><%=CommonLang.get("HTITLE13")%><!-- 품목명 --></th>
						<td>
							<input type="text" class="input_type_text" name="st_description_loc" id="st_description_loc" style="width:90%;" value="<%=st_description_loc%>" onKeyDown="kepEnter()">							
						</td>
						<th><%=CommonLang.get("HTITLE12")%><!-- 품목코드 --></th>
						<td >
							<input type="text" class="input_type_text" name="st_buyer_item_no" id="st_buyer_item_no" style="width:90%;" value="<%=st_buyer_item_no%>" onkeyup="kepToUpper('st_buyer_item_no')" onKeyDown="kepEnter()">
						</td>
                     </tr>
					</tbody>
				</table>
			</div>
  		
  		<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
       	<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow">
				<option value = "10" <%if ("10".equals(onepagerow)) {%>selected<%} %>>10<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
				<option value = "20" <%if ("20".equals(onepagerow)) {%>selected<%} %>>20<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
				<option value = "30" <%if ("30".equals(onepagerow)) {%>selected<%} %>>30<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
				<option value = "40" <%if ("40".equals(onepagerow)) {%>selected<%} %>>40<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
				<option value = "50" <%if ("50".equals(onepagerow)) {%>selected<%} %>>50<%=CommonLang.get("HTITLE595")%><!-- 건 --></option> 
			</select>
       	</span>
        <span class="fr"><%=CommonLang.get("HTITLE608")%><!-- 총건수 --> <%=total_cnt %></span>
 		<br>
	</form> 
<form name = "contentForm" id="contentForm" method = "post">
	<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
	<table id="table_list" class="cont_t_list02" style="width:100%">
		<colgroup>
            <col width="4%" />
            <col width="11%" />
            <col width="53%" />
            <col width="16%" />
            <col width="16%" />
        </colgroup>
        <thead>
			<tr>
                <th scope="col"><%=CommonLang.get("HTITLE255")%><!-- 상태 --></th>
                <th scope="col"><%=CommonLang.get("HTITLE395")%><!-- 이미지 --></th>
                <th scope="col"><%=CommonLang.get("HTITLE396")%><!-- 품목코드/품목명 --><br><%=CommonLang.get("HTITLE14")%><!-- 규격 --></th>
                <th scope="col"><%=CommonLang.get("HTITLE120")%><!-- 원산지 --><br><%=CommonLang.get("HTITLE15")%><!-- 제조사 --></th>
                <th scope="col"><%=CommonLang.get("HTITLE52")%><!-- 단위 --><br><%=CommonLang.get("HTITLE174")%><!-- 단가 --></th>
			</tr>
		</thead>
		<tbody>
 		<%
        if (_gridList == null || _gridList.size() == 0){
        %>
                    <tr>
                        <td colspan="5" align="center" height = "80"> 
                        <span><%=CommonLang.msg("MSG347")%><!-- 조회된 데이타가 없습니다. --></span>
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
                     <td title="상태" rowspan ="2"><%=String.valueOf(CommonUtil.nvl(rowData.get("STATUS_TEXT")))%></td>
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
                     	<a class="hyperLink" href="javascript:doPop('sellerMpClGoodsDetailInfoPop','<%=rowData.get("BUYER")%>','<%=rowData.get("BUYER_ITEM_NO")%>','<%=rowData.get("CONTRACT_NO")%>','<%=rowData.get("CONTRACT_SEQ")%>');"><b><%=String.valueOf(CommonUtil.nvl(rowData.get("BUYER_ITEM_NO")))%></b></a>&nbsp;
                     	<%=String.valueOf(CommonUtil.nvl(rowData.get("DESCRIPTION_LOC")))%>
                     </td>
                     <td title="원산지"><%=String.valueOf(CommonUtil.nvl(rowData.get("ORIGIN_NAME")))%></td>
                     <td title="단위" class="right"><%=String.valueOf(CommonUtil.nvl(rowData.get("UNIT_MEASURE")))%></td>
                    </tr>
				<tr bgcolor="<%=tclass%>" align="center" height="25">
					<td title="규격" class="left"><%=String.valueOf(CommonUtil.nvl(rowData.get("SPECIFICATION_LOC")))%></td>
					<td title="제조사"><%=String.valueOf(CommonUtil.nvl(rowData.get("MAKER_NAME")))%></td>
					<td title="단가" class="right"><%=CommonUtil.formatNumber(String.valueOf(rowData.get("UNIT_PRICE")),true,0,3)%></td>
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
			<span class="cl"><%=CommonLang.get("HTITLE598")%><!-- [ 총 --> <%=total_cnt %> <%=CommonLang.get("HTITLE599")%><!-- 건 ] --></span>
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
	if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;  
	
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mdam/getBuyerMdAmCatalog.do").submit();   
}

/**
 * FORM 을 초기화
 */
function reload(){
	
	kepReload("searchForm");
	
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
	
	$('#st_status_text').val("<%=CommonLang.get("HTITLE321")%>");	//승인
	
// 	kepSearch(-1);
	jspTableClean("table_list","5");
}
  
/*
 *  최초 화면 함수
 */
function kep_onload_view(){
	
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	<%if("".equals(st_from_date)){%>
		$("#st_from_date").val( kepToMonthAdd("1","M"));
		$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
	<%}%>

}	

//팝업함수호출
function doPop(str,value1, value2, value3, value4) {
	
	switch (str) {
		case "sellerMpClGoodsDetailInfoPop": // 품목정보상세
			popupSel = "sellerMpClGoodsDetailInfoPop";
			openSearchPopup("/mpcl/getSellerMpClGoodsDetailInfoPop.do", "?st_byit_comorg_code="+value1+"&st_item_no="+value2+"&st_contract_no="+value3+"&st_contract_seq="+value4+"&st_com_type=B", "850,330,no");
			break;
	}
}


</script>
</html>
