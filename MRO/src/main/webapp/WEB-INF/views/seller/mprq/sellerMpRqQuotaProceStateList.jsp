<%--
**********************************************
* 메뉴 : 협력사 > 견적관리
* 화면 : 견적진행상태조회
* 기능 : 고객사의 견적의뢰를 조회하거나 피드백 하는 기능(예)
* 프로그램 ID : PG_04_A_002_00
* 담당자 : 김영미 (설계:권우재)
* 생성일 : 2014-XX-XX
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!doctype html>
<html>
<head>
<%@include file="../../common/include/head.jspf" %>
</head>
<%
@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _gridList ,"0"); // 총 조회수 (필수)
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"0"); // 현재페이지  (필수)
	String onepagerow = (String) request.getParameter("onepagerow");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	String st_fb_flag = CommonUtil.nvl((String) request.getParameter("st_fb_flag"),"");  // 상태페이지 (조회조건)
	String msg = CommonUtil.nvl( (String)request.getAttribute("msg"),""); // 결과
	//조회조건 S
	String st_from_date = CommonUtil.nvl((String) request.getParameter("st_from_date"),"");  // 견적일(From)
	String st_to_date = CommonUtil.nvl((String) request.getParameter("st_to_date"),"");  // 견적일(To)
	String st_quotation_no = CommonUtil.nvl((String) request.getParameter("st_quotation_no"),"");  // 견적번호
	String st_description = CommonUtil.nvl((String) request.getParameter("st_description"),"");  // 품목명
	String st_specification = CommonUtil.nvl((String) request.getParameter("st_specification"),"");  // 규격
	String st_sourcing_status = CommonUtil.nvl((String) request.getParameter("st_sourcing_status"),"");  // 진행상태
	//조회조건 E	
	
	String pg_row           = CommonUtil.nvl((String)request.getParameter("st_pg_row"), "10");
    String pg_no            = CommonUtil.nvl((String)request.getParameter("st_page"), "1");
	String tot_cnt_string   = "";
    int tot_cnt = 0;                                    //전체데이타row수
    int rec_cnt = 0;
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
<h3>제출견적 진행조회</h3>
<!--버튼영역-->
	<div id="searchBtnA">
		<span class="btn_search"><a href="javascript:kepSearch(1);">조회</a></span> 
		<span class="btn_reset"><a href="javascript:reload();">초기화</a></span>
	</div>
	<!--조회영역-->
	<form name = "searchForm" id="searchForm" method = "post">
	<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" /> <!-- 필수 -->
	<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
	<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    
	<input type="hidden" id="st_query" name="st_query" value ="">
	
         <div id="cont_searchA">
         	<table  class="cont_t_list01" style="width:100%">
			<caption>공지사항 리스트</caption>
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
                <th>견적요청일</th>
				<td colspan="3">
					<input type="text" name="st_from_date" id="st_from_date" readOnly style="width:20%; text-align:center;" value="<%=st_from_date%>">
					<a href="javascript:kepCalendar('st_from_date')"></a>
					-
					<input type="text" name="st_to_date" id="st_to_date" readOnly style="width:20%; text-align:center;" value="<%=st_to_date%>">
					<a href="javascript:kepCalendar('st_to_date')"></a>
					<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
					<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span> 
					<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>
				</td>
                
				<th>견적번호</th>                           
				<td><input type="text" name="st_quotation_no" id="st_quotation_no" value="<%=st_quotation_no %>" style="width:87%;" onKeyDown="kepEnter()" /></td> 
			  </tr>
			<tr>
			  <th>품목명</th>
			  <td><input type="text" name="st_description" id="st_description" value="<%=st_description %>" style="width:87%;" onKeyDown="kepEnter()" /></td>
			  <th>규격</th>
			  <td><input type="text" name="st_specification" id="st_specification" value="<%=st_specification %>" style="width:87%;" onKeyDown="kepEnter()" /></td>
			  <th>진행상태</th>
			  <td>
             	  <label for="b_delivery" class="hidden">진행상태선택</label>
       			  <select name="st_sourcing_status" id="st_sourcing_status" style="width:90%;height:20px;">
			          <option value="" <%if ("".equals(st_sourcing_status)) {%>selected<%} %>>전체</option>
			          <option value="신규견적요청" <%if ("신규견적요청".equals(st_sourcing_status)) {%>selected<%} %>>신규견적요청</option>
			          <option value="재견적요청" <%if ("재견적요청".equals(st_sourcing_status)) {%>selected<%} %>>재견적요청</option>
			          <option value="견적제출" <%if ("견적제출".equals(st_sourcing_status)) {%>selected<%} %>>견적제출</option>
			          <option value="단가선정" <%if ("단가선정".equals(st_sourcing_status)) {%>selected<%} %>>단가선정</option>
			          <option value="단가미선정" <%if ("단가미선정".equals(st_sourcing_status)) {%>selected<%} %>>단가미선정</option>
			          <option value="견적미제출" <%if ("견적미제출".equals(st_sourcing_status)) {%>selected<%} %>>견적미제출</option>
			          <option value="차수증가종료" <%if ("차수증가종료".equals(st_sourcing_status)) {%>selected<%} %>>차수증가종료</option>
			          <option value="견적취소" <%if ("견적취소".equals(st_sourcing_status)) {%>selected<%} %>>견적취소</option>
		          </select>
                </td>
			  </tr>
	    </tbody>
	</table>
         </div>
         
         <div>
         	<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
              <label for="b_no02" class="hidden">정렬개수선택</label>
				<select name="onepagerow">
					<option value = "10" <%if ("10".equals(onepagerow)) {%>selected<%} %>>10건</option>
					<option value = "20" <%if ("20".equals(onepagerow)) {%>selected<%} %>>20건</option>
					<option value = "30" <%if ("30".equals(onepagerow)) {%>selected<%} %>>30건</option>
					<option value = "40" <%if ("40".equals(onepagerow)) {%>selected<%} %>>40건</option>
					<option value = "50" <%if ("50".equals(onepagerow)) {%>selected<%} %>>50건</option> 
				</select>
     		</span>
      	<span class="fr">
       총건수 <input type="text" class="input_type_text" id="st_total_cnt" name="st_total_cnt" readonly style="width:30px;border:0" value="<%=total_cnt %>"/>
       </span>
</div>
	<br>                    
	</form> 
	<form name = "contentForm" id="contentForm" method = "post">
		<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
    	<!--grid-->
        <table id="table_list" class="cont_t_list02"  style="width:100%">
            <caption>제출견적 진행조회</caption>
            <colgroup>
            	<col width="3%" />
                <col width="8%" />
                <col width="5%" />
                <col width="8%" />
                <col width="10%" />
                <col width="*" />
                <col width="8%" />
                <col width="6%" />
                <col width="4%" />
                <col width="5%" />
                <col width="5%" />
                <col width="5%" />
                <col width="5%" />
                <col width="7%" />
                <col width="5%" />
            </colgroup>
            <thead>
                <tr>
					<th scope="col">
						<a href="javascript:checkAll();" id="check_status">전체</a>
					</th>
                    <th scope="col">견적번호<br>(관리번호)</th>
                    <th scope="col">순번<br>차수</th>
                    <th scope="col">진행상태<br>품목명코드</th>
                    <th scope="col">견적요청일<br>견적마감일</th>
                    <th scope="col">품목명<br>규격</th>
                    <th scope="col">제조사<br>&nbsp;</th>
                    <th scope="col">원산지<br>&nbsp;</th>
                    <th scope="col">단위<br>수량</th>
                    <th scope="col">조달일수<br>제출단가<br>(VAT별도)</th>
                    <th scope="col">KeP/첨부<br>제출단가<br>(VAT포함)</th>
                    <th scope="col">납품지역<br>협력사비고</th>
                    <th scope="col">이미지필수<br>이미지첨부</th>
                    <th scope="col">MOQ/발주배수<br>거래유형</th>
                    <th scope="col">과세구분<br>품목구분</th>
                </tr>
            </thead>
            <tbody>
            <%
        if (_gridList == null || _gridList.size() == 0){
        %>
                    <tr>
                        <td colspan="14" align="center" height = "50"> 
                        <span>조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
        <%
        }else{
        	
        	String aaa=null;
            
			for (int j=0; j<_gridList.size(); j++) {
				++page_display_cnt;
				Map<String,String> rowData = _gridList.get(j);
				String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
				
// 				if ((j%2) == 1) tclass = "#FFFFFF";
//                 else tclass = "f4f5f9";
		%>
                <tr bgcolor="<%=tclass%>">
                	<input type="hidden" id="db_buyer" name="db_buyer" value="<%=CommonUtil.nvl(rowData.get("BUYER"))%>">
			        <input type="hidden" id="db_quotation_no" name="db_quotation_no" value="<%=CommonUtil.nvl(rowData.get("QUOTATION_NO"))%>">
			        <input type="hidden" id="db_quotation_seq" name="db_quotation_seq" value="<%=CommonUtil.nvl(rowData.get("QUOTATION_SEQ"))%>">
			        <input type="hidden" id="db_revision" name="db_revision" value="<%=CommonUtil.nvl(rowData.get("REVISION"))%>">
			        <input type="hidden" id="db_agent" name="db_agent" value="<%=CommonUtil.nvl(rowData.get("AGENT"))%>">
			        <input type="hidden" id="db_agent_revision" name="db_agent_revision" value="<%=CommonUtil.nvl(rowData.get("AGENT_REVISION"))%>">
			        <input type="hidden" id="db_modify_flag" name="db_modify_flag" value="<%=CommonUtil.nvl(rowData.get("MODIFY_FLAG"))%>">
			        <input type="hidden" id="st_tax_type_cd" name="st_tax_type_cd" value="<%=CommonUtil.nvl(rowData.get("TAX_TYPE_CD"))%>">
			        
                	<td title="체크박스" class="td02" rowspan="2">
                		<input type="checkbox" name="checkbox<%=j%>" value="" id="check" onClick="javascript:checkInvoiceDate('<%=CommonUtil.nvl(rowData.get("INVOICE_DATE"))%>','<%=j%>')">
                	</td>
                    <td title="견적번호" class="td02" rowspan="2">
                     	<a class="hyperLink" href="javascript:report('<%=String.valueOf(rowData.get("BUYER"))%>',
                     																 '<%=String.valueOf(rowData.get("QUOTATION_NO"))%>',
                     																 '<%=String.valueOf(CommonUtil.nvl(rowData.get("QUOTATION_SEQ")))%>',
                     																 '<%=CommonUtil.nvl(String.valueOf(rowData.get("REVISION")))%>', 
                     																 '<%=String.valueOf(rowData.get("KEP_USER_ID"))%>',
                   																 	 '<%=String.valueOf(rowData.get("SEL_USER_ID"))%>'
                   																 	 );">
                     		<b><%=String.valueOf(CommonUtil.nvl(rowData.get("QUOTATION_NO")))%></b>
                     	</a>
                     	<%
							if (!("").equals(String.valueOf(CommonUtil.nvl(rowData.get("REF_NO")))) ) {
						%>
                     	<br>
                     		(<%=String.valueOf(CommonUtil.nvl(rowData.get("REF_NO")))%>)
                     	<%
							}
                     	%>
                     </td>
                     <td title="순번" class="td02">
                     	<%=String.valueOf(CommonUtil.nvl(rowData.get("QUOTATION_SEQ")))%>
                     <%if("Y".equals(rowData.get("PRE_GR_FLAG"))){%>
						<b>(선입고)</b>
					<%}%>
                     </td>
                     <td title="진행상태" class="td02"><%=String.valueOf(CommonUtil.nvl(rowData.get("AGENT_SOURCING_STATUS")))%></td>
                     <td title="견적요청일" class="td02"><%=CommonUtil.formatStrinigDate(CommonUtil.nvl(rowData.get("ATOS_DATE")))%></td>
                     <td title="<%=String.valueOf(CommonUtil.nvl(rowData.get("DESCRIPTION")))%>')" class="left">
                     <%=String.valueOf(CommonUtil.nvl(rowData.get("DESCRIPTION")))%>
                     </td>
                     <td title="제조사" class="td02"><%=String.valueOf(CommonUtil.nvl(rowData.get("MAKER_NAME")))%></td>
                     <td title="원산지" class="td02"><%=String.valueOf(rowData.get("ORIGIN_NAME"))%></td>
                     <td title="단위" class="td02"><%=String.valueOf(CommonUtil.nvl(rowData.get("UNIT_MEASURE")))%></td>
                     <td title="조달일수" class="td02 right">
                     	<input type="text" class="input_type_text" name="st_lead_time"  id="st_lead_time" style="text-align:right;width:40%;"  value="<%=rowData.get("LEAD_TIME")%>" maxlength="3"; onBlur="chkLeadTime(<%=j%>);"/>
                     </td>
                     <td title="KeP담당자" class="td02">
                     	<a class="hyperLink" href="javascript:doPop('kepManagerPop','<%=String.valueOf(rowData.get("KEP_USER_ID"))%>');">
                     		<%=String.valueOf(CommonUtil.nvl(rowData.get("BTOA_USER_NAME")))%>
                     	</a> /
						<input type="hidden" name="st_image_key"	id="st_image_key" value="<%=CommonUtil.nvl( rowData.get("SELLER_IMAGE_KEY"))%>"> 
						<%
						if (("").equals(CommonUtil.nvl( rowData.get("SELLER_IMAGE_KEY")))) { 
						%>
							<img name = "st_image_key_img" id="st_image_key_img" src="/resources/images/disk_off.gif" border="0">
						<%
							}else{
						%>         
							<a class="hyperLink" href="javascript:doPop('attach', '<%=CommonUtil.nvl(rowData.get("SELLER_IMAGE_KEY"))%>')"><img name = "st_image_key_img" src="/resources/images/disk_on.gif" border="0"></a>    
						<%
							}
						%>		
                     </td>
                     <td title="납품지역" class="td02">
                     <%
                     	if (("").equals(CommonUtil.nvl(rowData.get("SELLER_AREA")))) {
                     %>
						<a class="hyperLink" href="javascript:deliArea('<%=CommonUtil.nvl(rowData.get("BUYER"))%>', '<%=j%>');"><img name="area_select_img" id="area_select_img" src="/resources/images/icon2.gif"></a> 
					<%
						}else{
					%>
						<a class="hyperLink" href="javascript:deliArea('<%=CommonUtil.nvl(rowData.get("BUYER"))%>', '<%=j%>');"><img name="area_select_img" id="area_select_img" src="/resources/images/icon.gif"></a>           
					<%
						}
					%>
						<input type="hidden" name="st_deliArea" id="st_deliArea" value="<%=CommonUtil.nvl(rowData.get("SELLER_AREA"))%>">
                     </td>
                     <td title="이미지필수 class="td02"><%=String.valueOf(CommonUtil.nvl(rowData.get("RFQ_IMG_FLAG")))%></td>
                     <td title="MOQ" class="td02"><%=CommonUtil.formatNumber(String.valueOf(rowData.get("MIN_ORDER_QTY")),true,0,0)%>/<%=CommonUtil.formatNumber(String.valueOf(rowData.get("PUR_UNIT_QTY")),true,0,0)%></td>
                     <td title="과세구분" class="td02"><%=CommonUtil.nvl(rowData.get("TAX_TYPE"))%></td>
                </tr>
                <tr bgcolor="<%=tclass%>">
                	<td title="차수" class="td02">
                		<a class="hyperLink" href="javascript:doPop('agentHistoryPop','<%=rowData.get("BUYER") %>','<%=rowData.get("QUOTATION_NO") %>','<%=rowData.get("QUOTATION_SEQ") %>','<%=rowData.get("REVISION") %>','<%=rowData.get("AGENT") %>');"><%=rowData.get("AGENT_REVISION") %></a>
                	</td>
                    <td title="품목코드" class="td02">
					<%
						if (("").equals(String.valueOf(CommonUtil.nvl(rowData.get("REMARK_URL")))) ) {
					%>
					<%=String.valueOf(CommonUtil.nvl(rowData.get("BUYER_ITEM_NO")))%>
					<%
					     }else {
					%>
 					 <a class="hyperLink" href="javascript:getRemarkUrL('<%=String.valueOf(CommonUtil.nvl(rowData.get("REMARK_URL")))%>');">
 					 	<%=String.valueOf(CommonUtil.nvl(rowData.get("BUYER_ITEM_NO")))%>
 					 </a>
 					 <%
					     }
					%>
                    </td>
                    <td title="견적마감일" class="td02">
                        <b>
                        <%=String.valueOf(rowData.get("ATOS_END_DATE"))%>
                        </b>
                    </td>
<!--                     <td>&nbsp;</td> -->
                    <td colspan="3" title="<%=String.valueOf(CommonUtil.nvl(rowData.get("SPECIFICATION")))%>" class="left"><%=String.valueOf(CommonUtil.nvl(rowData.get("SPECIFICATION")))%></td>
<!--                     <td>&nbsp;</td> -->
                    <td title="수량" class="td02 right"><%=CommonUtil.formatNumber(String.valueOf(rowData.get("ITEM_QTY")),true,0,0)%></td>
                    <td title="제출단가(VAT별도)" class="td02 right">
                    	<input type="text" class="input_type_text" name="st_stoa_list_price" id="st_stoa_list_price" style="text-align:right;width:70%;" value="<%=rowData.get("STOA_LIST_PRICE")%>" onBlur="chkAgentPrice(<%=j%>);" onChange="javascript:setStoaVatListPrice('<%=j%>');">
                    </td>
                    <td title="제출단가(VAT포함)" class="td02 right">
                    	<input type="text" class="Price" name="st_stoa_vat_list_price" id="st_stoa_vat_list_price" style="width:90%;border:0;text-align:right;background-color:<%=tclass%>"  value="<%=CommonUtil.formatNumber(rowData.get("STOA_VAT_LIST_PRICE"),true,0,3)%>"   READONLY>
                    </td>
                    <td title="협력사비고">
                    	<%=CommonUtil.nvl(rowData.get("STOA_REMARK_M"))%>
                    	<input type="hidden" name="st_btoa_remark"	value="<%=CommonUtil.nvl(rowData.get("BUYER_REMARK"))%>">
						<input type="hidden" name="st_atob_remark"	value="<%=CommonUtil.nvl(rowData.get("KEP_KEP_REMARK"))%>">
						<%
							if (("").equals(CommonUtil.nvl(rowData.get("STOA_REMARK")))) {
						%>
							<img name = "st_atob_remark_img" id="st_atob_remark_img" src="/resources/images/but_icon02.gif" border="0">
						<%
							}else{
						%>         
							<a class="hyperLink" href="javascript:doPop('remark', '<%=CommonUtil.nvl(rowData.get("ATOS_REMARK"))%>','<%=CommonUtil.nvl(rowData.get("STOA_REMARK"))%>','')"><img name = "st_atob_remark_img" src="/resources/images/but_icon01.gif" border="0"></a>           
						<%
							}
						%>
                    </td>
					<td title="이미지첨부" >
			            <%if("".equals(rowData.get("IMGFILE_NAME")) || null == rowData.get("IMGFILE_NAME")){%>
			            	<a class="hyperLink" href="javascript:setImageView('<%=CommonUtil.realImgS3UploadPath+"/"+rowData.get("IMGFILE_DIR") %>', '<%=rowData.get("IMGFILE_NAME")%>');">
			            		<img name="reg_select_img" id="reg_select_img" src="/resources/images/icon2.gif">
			            	</a>
			            <%}else{%>
			            	<a class="hyperLink" href="javascript:setImageView('<%=CommonUtil.realImgS3UploadPath+"/"+rowData.get("IMGFILE_DIR") %>', '<%=rowData.get("IMGFILE_NAME")%>');">
			            		<img name="reg_select_img" id="reg_select_img" src="/resources/images/icon.gif">
			            	</a>
			            <%}%>
					</td>
					<td title="거래유형" >
						<%=String.valueOf(rowData.get("PROCESS_NM"))%>
					</td>
					<td title="품목구분"><%=CommonUtil.nvl(rowData.get("ITEM_MAKE_TYPE"))%></td>
                </tr>
				<%
	            	} 
	            %>
                <%
                    } 
            %> 
            </tbody>
        </table>
        <input type="hidden" id="display_item_cnt" name="display_item_cnt" value="<%=page_display_cnt%>">
        <!--페이징-->
        <p id="paging" class="paging">
			<%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow) %> 
		</p>
        <!--버튼영역-->
        <div class="btnArea">
        	<!--버튼이 2글자일때 class="btn_02",버튼이 3글자일때 class="btn_03",버튼이 4글자일때 class="btn_04" 글자수와 class숫자가 동일 최대 10글자까지 가능-->
        	<span class="btn_04 mr04">
				<a href="javascript:ExcelDown()">엑셀다운로드</a>
			</span>
			<span class="btn_04">
				<a href="javascript:doAction('save');">저장</a>
			</span>
        </div>
    </form>

	<form name="processForm" id="processForm" method="post">	
		<input type="hidden" name="s_SAVENAME" id="s_SAVENAME" value="" />
		<input type="hidden" name="gubun" id="gubun" value="" />
		<input type="hidden" name="total_cnt" id="total_cnt"  value="<%=total_cnt %>"/>
		<input type="hidden" name="curPage" id="curPage"  value="<%=curPage %>"/>
		<input type="hidden" name="onepagerow" id="onepagerow"  value="<%=onepagerow %>"/>
		<div id="process">
	
		</div>
	</form> 
</div>    
               
</div>

<!--내용 종료-->	       
	<%@ include file="/WEB-INF/views/common/include/sellerFooter.jsp" %>    
</div>
</body>
<script type="text/javascript"> 
 var popupSel = "";
/*
 *  최초 화면 함수
 */
function kep_onload_view(){
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	<%if("".equals(st_from_date)){%>
		$("#st_from_date").val(kepToDateAdd("7","M"));
		$("#st_to_date").val(kepGetNowTimeStr('YYYYMMDD','/')); 
	<%}%>
}	

//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
	case "search":
		kepSearch(1);
		break;
		
	case "save":	//저장
		saveInfo();
		break;	
	}

}
/*
 * FORM 을 이용한조회
 */
function kepSearch(curPage){
	
	if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
	
	document.forms.searchForm.curPage.value = curPage; 
	$('#searchForm').attr("action", "/mprq/getSellerMpRqQuotaProceState.do").submit();   
}	

/**
 * FORM 을 초기화
 */
function reload(){
	kepReload('searchForm');
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	$("#st_from_date").val(kepToDateAdd("7","M"));
	$("#st_to_date").val(kepGetNowTimeStr('YYYYMMDD','/')); 
// 	kepSearch('-1');
	$('#st_total_cnt').val('0');
	jspTableClean("table_list");
}
// 팝업호출
var gridIndex = 0;
function doPop(str, value1, value2, value3, value4, value5) {
	popupSel = str ;
	
	switch (str) {
	case "quotationReDetailPop": // 견적번호
		openSearchPopup("/common/mprq/quotationReDetailPop.do", '?st_buyer='+value1+'&st_quotation_no='+value2+'&st_revision='+value3, "1020,500,no");
		break;
	case "agentHistoryPop": // 차수
		AgentSourcingHistory(value1,value2,value3,value4,value5);
		break;
		
	case "kepManagerPop": // KeP담당자
		openSearchPopup("/common/kepManagerPop.do", "?st_user_id="+value1, "430,194,no");
		break;
	case "remark"://비고
		var viewType="R";
		var titleType="S";
		openSearchPopup("/common/remarkAtoSPop.do", '?st_atos_remark='+value1+'&st_stoa_remark='+value2+'&viewType='+viewType+'&titleType='+titleType, "500,310,no");
		break;
	case "attach"://파일 첨부
		popupSel = "fileUpload";
		var type="RFQ";
		var viewType="R";
		openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+value1+'&type='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
		break;
	}
}
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	 if(popupSel == "remark") {	//고객사 비고
		 $("input[name=st_btoa_remark]").eq(gridIndex).val(value1);
		 $("input[name=st_atob_remark]").eq(gridIndex).val(value2);
		 if(value2 ==""){
	 		$("img[id=st_atob_remark_img]").eq(gridIndex).attr("src",remarkOff);
	 	 }else{
	 		$("img[id=st_atob_remark_img]").eq(gridIndex).attr("src",remarkOn);
	 	 }
		 
	}else if(popupSel == "attach") {	//파일 첨부
		 $("input[name=st_image_key]").eq(gridIndex).val(value1);
	 	 if(value1 ==""){
			 $("img[id=st_image_key_img]").eq(gridIndex).attr("src",diskOff);
	 	 }else{
			 $("img[id=st_image_key_img]").eq(gridIndex).attr("src",diskOn);
	 	 }
	}
}
// 출력물 - 견적번호 클릭
function report(buyer, quotation_no, quotation_seq, revision, user_id, sel_user_id) {
	    
		var agent = "${sessionInfo.comCode}";
	    if(kepIsValueNull(sel_user_id)) {
	        alert("견적서가 작성되지 않았습니다.");
	        return;
	    }
	    
	    var param =  "["+buyer+"]["+quotation_no+"]["+quotation_seq+"]["+revision+"]["+user_id+"]["+agent+"]["+sel_user_id+"]";
		var fileName = "RD_04_M_007_01";
		
		reportOpen(fileName,param);
	    return;
}
//엑셀다운로드
function ExcelDown(){
	if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
	
	document.forms.searchForm.method = "post";
	document.forms.searchForm.action = "/mprq/getExcelDown.do";
	document.forms.searchForm.submit();
}
function getRemarkUrL(remark_url) {
    var loc = "http://ez-van.doosaninfracore.co.kr/data/APPENDIX/"+remark_url;
    window.open(loc, "doosaninfracore", "left=0,top=0");
}
function AgentSourcingHistory(buyer,quotation_no,quotation_seq,revision,agent){
	openSearchPopup("/mprq/showSellerMpRqUnitPriceHistoryPop.do", '?st_buyer='+buyer+'&st_quotation_no='+quotation_no+'&st_quotation_seq='+quotation_seq+'&st_revision='+revision+'&st_agent='+agent, "800,300,no");
	return;
}

function deliArea(buyer, idx){
	popupSel = "deliAreaPop";
	gridIndex = idx;
	var area_list = $("input[name=st_deliArea]").eq(gridIndex).val();
	openSearchPopup("/common/getDeliveryAreaPop.do", '?st_com_code='+buyer+'&st_area_list='+area_list+'&mod_yn=N', "400,270,no");
}

function setImageView(img_dr,img_name){

	if(img_name == "" || img_name ==null){
		alert("등록된 이미지가 없습니다.");
		return;		
	}else{
		window.open('<%= CommonUtil.getURL(request) %>'+img_dr+ img_name,'catalogImage','status=no,resizable=yes,menubar=no,scrollbars=no,"","",width=550,height=550');	
	}
	
}

function checkAll(){
	var tot_cnt = document.contentForm.display_item_cnt.value;
	var check_status = $("#check_status").html();

	if(check_status == "전체"){
		for(var j = 0; j < tot_cnt; j++){
			var box = eval("document.contentForm.checkbox" + j);
			var check_status = "해제";

			if(box.checked == false) box.checked = true;
			$("#check_status").html(check_status);
		}
	}else{
		for(var j = 0; j < tot_cnt; j++){
			var box = eval("document.contentForm.checkbox" + j);
			var check_status = "전체";

			if(box.checked == true) box.checked = false;
			$("#check_status").html(check_status);
		}
	}
}

function chkAgentPrice( k ) {
    var tot_cnt  = document.forms.contentForm.display_item_cnt.value;
	if (tot_cnt  < 2) {
        var chk_price = kepTrimStr(document.forms.contentForm.st_stoa_list_price.value);
	} else {
        var chk_price = kepTrimStr(document.forms.contentForm.st_stoa_list_price[k].value);
	}
	
	if(!kepIsNumChkStr(chk_price, 2)){
		alert("숫자와 소숫점만 입력 가능합니다.");
		document.forms.contentForm.st_stoa_list_price[k].focus();
		return;
	}
}

function chkLeadTime( k ) {
    var tot_cnt  = document.forms.contentForm.display_item_cnt.value;
    
	if (tot_cnt  < 2) {
        var chk_lead_time = kepTrimStr(document.forms.contentForm.st_lead_time.value);
	} else {
        var chk_lead_time = kepTrimStr(document.forms.contentForm.st_lead_time[k].value);
	}
	
	if(!kepIsNumberStr(chk_lead_time)){
		alert("숫자만 입력 가능합니다.");
		document.forms.contentForm.st_lead_time[k].focus();
		return;
	}
}

//저장
function saveInfo(){
	
	var tot_cnt = $("#display_item_cnt").val();
	var query = "";
	var chk_cnt = 0; // 선택 건수
	var modify_yn = "N"; // 변경 가능 여부 FLAG
	
	var buyer = "";
	var quotation_no = "";
	var quotation_seq = "";
	var revision = "";
	var agent = "";
	var agent_revision = "";
	var lead_time = "";
	var stoa_list_price = "";
	
	if(eval(tot_cnt) == 0) {
		alert("조회한 데이타가 없습니다.");
		return;
	}
	
	if(eval(tot_cnt) < 2){
	
		var box = eval("document.contentForm.checkbox"+0);
		if(box.checked == true){
			chk_cnt++;
			
			buyer = document.contentForm.db_buyer.value;
			quotation_no = document.contentForm.db_quotation_no.value;
			quotation_seq = document.contentForm.db_quotation_seq.value;
			revision = document.contentForm.db_revision.value;
			agent = document.contentForm.db_agent.value;
			agent_revision = document.contentForm.db_agent_revision.value;
			lead_time = document.contentForm.st_lead_time.value;
			stoa_list_price = document.contentForm.st_stoa_list_price.value;
			modify_yn = document.contentForm.db_modify_flag.value;
			
			if(modify_yn == "N"){
				alert("견적 마감처리가 된 건이므로, 수정 불가능 합니다.")
				return;
			}
			
			query += buyer + "@@";
			query += quotation_no + "@@";
			query += quotation_seq + "@@";
			query += revision + "@@";
			query += agent + "@@";
			query += agent_revision + "@@";
			query += lead_time + "@@";
			query += stoa_list_price + "@@";
			query += "^||^" ;
		}
	
	}else{
		for(var k = 0; k < tot_cnt; k++){
			var box = eval("document.contentForm.checkbox"+k);
			if(box.checked == true){
				chk_cnt++;
				
				buyer = document.contentForm.db_buyer[k].value;
				quotation_no = document.contentForm.db_quotation_no[k].value;
				quotation_seq = document.contentForm.db_quotation_seq[k].value;
				revision = document.contentForm.db_revision[k].value;
				agent = document.contentForm.db_agent[k].value;
				agent_revision = document.contentForm.db_agent_revision[k].value;
				lead_time = document.contentForm.st_lead_time[k].value;
				stoa_list_price = document.contentForm.st_stoa_list_price[k].value;
				modify_yn = document.contentForm.db_modify_flag[k].value;
				
				if(modify_yn == "N"){
					alert((k+1)+"행은 견적 마감처리가 된 건이므로, 수정 불가능 합니다.")
					return;
				}
				
				query += buyer + "@@";
				query += quotation_no + "@@";
				query += quotation_seq + "@@";
				query += revision + "@@";
				query += agent + "@@";
				query += agent_revision + "@@";
				query += lead_time + "@@";
				query += stoa_list_price + "@@";
				query += "^||^" ;
			}
		}
	}
	
	if(chk_cnt == "0"){
		alert("저장할 항목을 선택하여 주십시요");
		return;
	}
	
	if(!confirm("선택된 항목을 저장하시겠습니까?")) return;
	
	document.searchForm.st_query.value = query;
	
	kepAjaxFormCall("/mprq/saveSellerMpRqQuotaProceState.do","searchForm","btnSave");
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	
	if(pMethod == "btnSave"){
		alert("정상적으로 저장되었습니다.");
		doAction("search");
	}
	return;
}

//ajax 공통 호출후 실패시 처리 함수
function kepAjaxError(pMethod , response){
	var msg = response.Message;
	
	if (!isEmpty(msg)){
		alert(msg);
	}
	return;
}
//부가세 포함 단가 자동 계산
function setStoaVatListPrice(j){
	var tot_cnt  = $("#display_item_cnt").val();
	var st_stoa_list_price= "";
	var st_tax_type_cd ="";
    if(eval(tot_cnt) < 2){
    	st_stoa_list_price = document.forms.contentForm.st_stoa_list_price.value;
    	st_tax_type_cd = document.forms.contentForm.st_tax_type_cd.value;
    	if(st_tax_type_cd =="12"){//면세일 경우
    		document.forms.contentForm.st_stoa_vat_list_price.value = st_stoa_list_price;
    	}else{
    		document.forms.contentForm.st_stoa_vat_list_price.value = kepGetRound2(st_stoa_list_price*1.1,1);	
    	}
    	
    }else{
    	st_stoa_list_price = document.forms.contentForm.st_stoa_list_price[j].value;
    	st_tax_type_cd = document.forms.contentForm.st_tax_type_cd[j].value;
    	if(st_tax_type_cd =="12"){//면세일 경우
    		document.forms.contentForm.st_stoa_vat_list_price[j].value = st_stoa_list_price;
    	}else{
    		document.forms.contentForm.st_stoa_vat_list_price[j].value = kepGetRound2(st_stoa_list_price*1.1,1);    		
    	}
    }
	
}
</script> 
</html>
