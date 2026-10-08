<%--
**********************************************
* 메뉴 : 
* 화면 : BQMS용 배송조회 팝업
* 기능 : 
* 프로그램 ID : 
* 담당자 : HSJ
* 착수일 : 2024-11-14
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../../common/include/head_pop.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과
String ICON1_TYPE = CommonUtil.nvl3((String) request.getParameter("ICON1_TYPE"),"");
String ICON2_TYPE = CommonUtil.nvl3((String) request.getParameter("ICON2_TYPE"),"");
String ICON3_TYPE = CommonUtil.nvl3((String) request.getParameter("ICON3_TYPE"),"");
String ICON4_TYPE = CommonUtil.nvl3((String) request.getParameter("ICON4_TYPE"),"");
String TEXT1_TYPE = CommonUtil.nvl3((String) request.getParameter("TEXT1_TYPE"),"주문정보없음");
String TEXT2_TYPE = CommonUtil.nvl3((String) request.getParameter("TEXT2_TYPE"),"");
String TEXT3_1_TYPE = CommonUtil.nvl3((String) request.getParameter("TEXT3_1_TYPE"),"");
String TEXT3_2_TYPE = CommonUtil.nvl3((String) request.getParameter("TEXT3_2_TYPE"),"");
String TEXT4_TYPE = CommonUtil.nvl3((String) request.getParameter("TEXT4_TYPE"),"");
String DATE1_TYPE = CommonUtil.nvl3((String) request.getParameter("DATE1_TYPE"),"");
String DATE2_TYPE = CommonUtil.nvl3((String) request.getParameter("DATE2_TYPE"),"");
String DATE3_TYPE = CommonUtil.nvl3((String) request.getParameter("DATE3_TYPE"),"");
String DATE4_TYPE = CommonUtil.nvl3((String) request.getParameter("DATE4_TYPE"),"");
String PARCEL_COM_CODE = CommonUtil.nvl3((String) request.getParameter("PARCEL_COM_CODE"),"");
String PARCEL_INV_NO = CommonUtil.nvl3((String) request.getParameter("PARCEL_INV_NO"),"");
String PARCEL_URL = CommonUtil.nvl3((String) request.getParameter("PARCEL_URL"),"");
String OPEN_FLAG = CommonUtil.nvl3((String) request.getParameter("OPEN_FLAG"),"N");
String SEARCH_FLAG = "Y"; // 화면 무한 로딩 방지용(첫 조회 결과 확인)
// 발주,담당자,배송 정보 추가분
String LEGACY_PO_NO = CommonUtil.nvl3((String) request.getParameter("LEGACY_PO_NO"),"");
String LEGACY_PO_SEQ = CommonUtil.nvl3((String) request.getParameter("LEGACY_PO_SEQ"),"");
String BUYER_ITEM_NO = CommonUtil.nvl3((String) request.getParameter("BUYER_ITEM_NO"),"");
String BYIT_USER_ID = CommonUtil.nvl3((String) request.getParameter("BYIT_USER_ID"),"");
String BYIT_USER_NAME = CommonUtil.nvl3((String) request.getParameter("BYIT_USER_NAME"),"");
String BYIT_USER_PHONE = CommonUtil.nvl3((String) request.getParameter("BYIT_USER_PHONE"),"");
String BYIT_USER_EMAIL = CommonUtil.nvl3((String) request.getParameter("BYIT_USER_EMAIL"),"");
String MNG_USER_NAME = CommonUtil.nvl3((String) request.getParameter("MNG_USER_NAME"),"");
String MNG_USER_CONTACT = CommonUtil.nvl3((String) request.getParameter("MNG_USER_CONTACT"),"");
String PROCESS_TYPE = CommonUtil.nvl3((String) request.getParameter("PROCESS_TYPE"),"");
String INV_QTY = CommonUtil.nvl3((String) request.getParameter("INV_QTY"),"");
String UNIT_MEASURE = CommonUtil.nvl3((String) request.getParameter("UNIT_MEASURE"),"");
String ST_DATE = CommonUtil.nvl3((String) request.getParameter("ST_DATE"),"");
String BUYER_DS_DATE = CommonUtil.nvl3((String) request.getParameter("BUYER_DS_DATE"),"");
String WMS_GR_DATE = CommonUtil.nvl3((String) request.getParameter("WMS_GR_DATE"),"");
String WMS_GR_DATE_W1 = CommonUtil.nvl3((String) request.getParameter("WMS_GR_DATE_W1"),"");
String WMS_INV_DATE = CommonUtil.nvl3((String) request.getParameter("WMS_INV_DATE"),"");
String WMS_DELIVERY_DATE = CommonUtil.nvl3((String) request.getParameter("WMS_DELIVERY_DATE"),"");

// 하단 html 파라미터 중앙 관리하기 위해 위에서 표기값 모두 정의
if (_dataList == null || _dataList.size() == 0){
	SEARCH_FLAG = "N";
}else{
	Map<String,String> rowData = _dataList.get(0);
	ICON1_TYPE = rowData.get("ICON1_TYPE");
	ICON2_TYPE = rowData.get("ICON2_TYPE");
	ICON3_TYPE = rowData.get("ICON3_TYPE");
	ICON4_TYPE = rowData.get("ICON4_TYPE");
	TEXT1_TYPE = rowData.get("TEXT1_TYPE");
	TEXT2_TYPE = rowData.get("TEXT2_TYPE");
	TEXT3_1_TYPE = rowData.get("TEXT3_1_TYPE");
	TEXT3_2_TYPE = rowData.get("TEXT3_2_TYPE");
	TEXT4_TYPE = rowData.get("TEXT4_TYPE");
	DATE1_TYPE = rowData.get("DATE1_TYPE");
	DATE2_TYPE = rowData.get("DATE2_TYPE");
	DATE3_TYPE = rowData.get("DATE3_TYPE");
	DATE4_TYPE = rowData.get("DATE4_TYPE");
	PARCEL_COM_CODE = rowData.get("PARCEL_COM_CODE");
	PARCEL_INV_NO = rowData.get("PARCEL_INV_NO");
	PARCEL_URL = rowData.get("PARCEL_URL");
	// 발주,담당자,배송 정보 추가분
	LEGACY_PO_NO = rowData.get("LEGACY_PO_NO");
	LEGACY_PO_SEQ = rowData.get("LEGACY_PO_SEQ");
	BUYER_ITEM_NO = rowData.get("BUYER_ITEM_NO");
	BYIT_USER_ID = rowData.get("BYIT_USER_ID");
	BYIT_USER_NAME = rowData.get("BYIT_USER_NAME");
	BYIT_USER_PHONE = rowData.get("BYIT_USER_PHONE");
	BYIT_USER_EMAIL = rowData.get("BYIT_USER_EMAIL");
	MNG_USER_NAME = rowData.get("MNG_USER_NAME");
	MNG_USER_CONTACT = rowData.get("MNG_USER_CONTACT");
	PROCESS_TYPE = rowData.get("PROCESS_TYPE");
	INV_QTY = rowData.get("INV_QTY");
	UNIT_MEASURE = rowData.get("UNIT_MEASURE");
	ST_DATE = rowData.get("ST_DATE");
	BUYER_DS_DATE = rowData.get("BUYER_DS_DATE");
	WMS_GR_DATE = rowData.get("WMS_GR_DATE");
	WMS_GR_DATE_W1 = rowData.get("WMS_GR_DATE_W1");
	WMS_INV_DATE = rowData.get("WMS_INV_DATE");
	WMS_DELIVERY_DATE = rowData.get("WMS_DELIVERY_DATE");
}
%>

<script type="text/javascript">
//최초 화면 함수 
function kep_onload_view(){
	if("<%=SEARCH_FLAG%>" == "Y" || "<%=OPEN_FLAG%>" == "N"){
		$('#bqmsInvoiceSearchPop').attr("action", "/common/show_pop_bqms_invoice.do").submit();	
	}
	if("<%=ICON1_TYPE%>" == "Y"){
		$("#PR_STTS").attr("class","Status01_on");
	}
	if("<%=ICON2_TYPE%>" == "Y"){
		$("#PX_STTS").attr("class","Status02_on");
	}
	if("<%=ICON3_TYPE%>" == "Y"){
		$("#IV_STTS").attr("class","Status03_on");
	}
	if("<%=ICON4_TYPE%>" == "Y"){
		$("#GR_STTS").attr("class","Status04_on");
	}
}
</script> 
<body onLoad="kep_onload_view()">
<form name="bqmsInvoiceSearchPop" id="bqmsInvoiceSearchPop" method="post" >
	<input type="hidden" name="ICON1_TYPE" id="ICON1_TYPE"  value="<%=ICON1_TYPE%>">
	<input type="hidden" name="ICON2_TYPE" id="ICON2_TYPE"  value="<%=ICON2_TYPE%>">
	<input type="hidden" name="ICON3_TYPE" id="ICON3_TYPE"  value="<%=ICON3_TYPE%>">
	<input type="hidden" name="ICON4_TYPE" id="ICON4_TYPE"  value="<%=ICON4_TYPE%>">
	<input type="hidden" name="TEXT1_TYPE" id="TEXT1_TYPE"  value="<%=TEXT1_TYPE%>">
	<input type="hidden" name="TEXT2_TYPE" id="TEXT2_TYPE"  value="<%=TEXT2_TYPE%>">
	<input type="hidden" name="TEXT3_1_TYPE" id="TEXT3_1_TYPE"  value="<%=TEXT3_1_TYPE%>">
	<input type="hidden" name="TEXT3_2_TYPE" id="TEXT3_2_TYPE"  value="<%=TEXT3_2_TYPE%>">
	<input type="hidden" name="TEXT4_TYPE" id="TEXT4_TYPE"  value="<%=TEXT4_TYPE%>">
	<input type="hidden" name="DATE1_TYPE" id="DATE1_TYPE"  value="<%=DATE1_TYPE%>">
	<input type="hidden" name="DATE2_TYPE" id="DATE2_TYPE"  value="<%=DATE2_TYPE%>">
	<input type="hidden" name="DATE3_TYPE" id="DATE3_TYPE"  value="<%=DATE3_TYPE%>">
	<input type="hidden" name="DATE4_TYPE" id="DATE4_TYPE"  value="<%=DATE4_TYPE%>">
	<input type="hidden" name="PARCEL_COM_CODE" id="PARCEL_COM_CODE"  value="<%=PARCEL_COM_CODE%>">
	<input type="hidden" name="PARCEL_INV_NO" id="PARCEL_INV_NO"  value="<%=PARCEL_INV_NO%>">
	<input type="hidden" name="PARCEL_URL" id="PARCEL_URL"  value="<%=PARCEL_URL%>">
	<input type="hidden" name="OPEN_FLAG" id="OPEN_FLAG"  value="Y">
	
	<input type="hidden" name="LEGACY_PO_NO" id="LEGACY_PO_NO"  value="<%=LEGACY_PO_NO%>">
	<input type="hidden" name="LEGACY_PO_SEQ" id="LEGACY_PO_SEQ"  value="<%=LEGACY_PO_SEQ%>">
	<input type="hidden" name="BUYER_ITEM_NO" id="BUYER_ITEM_NO"  value="<%=BUYER_ITEM_NO%>">
	<input type="hidden" name="BYIT_USER_ID" id="BYIT_USER_ID"  value="<%=BYIT_USER_ID%>">
	<input type="hidden" name="BYIT_USER_NAME" id="BYIT_USER_NAME"  value="<%=BYIT_USER_NAME%>">
	<input type="hidden" name="BYIT_USER_PHONE" id="BYIT_USER_PHONE"  value="<%=BYIT_USER_PHONE%>">
	<input type="hidden" name="BYIT_USER_EMAIL" id="BYIT_USER_EMAIL"  value="<%=BYIT_USER_EMAIL%>">
	<input type="hidden" name="MNG_USER_NAME" id="MNG_USER_NAME"  value="<%=MNG_USER_NAME%>">
	<input type="hidden" name="MNG_USER_CONTACT" id="MNG_USER_CONTACT"  value="<%=MNG_USER_CONTACT%>">
	<input type="hidden" name="PROCESS_TYPE" id="PROCESS_TYPE"  value="<%=PROCESS_TYPE%>">
	<input type="hidden" name="INV_QTY" id="INV_QTY"  value="<%=INV_QTY%>">
	<input type="hidden" name="UNIT_MEASURE" id="UNIT_MEASURE"  value="<%=UNIT_MEASURE%>">
	<input type="hidden" name="ST_DATE" id="ST_DATE"  value="<%=ST_DATE%>">
	<input type="hidden" name="BUYER_DS_DATE" id="BUYER_DS_DATE"  value="<%=BUYER_DS_DATE%>">
	<input type="hidden" name="WMS_GR_DATE" id="WMS_GR_DATE"  value="<%=WMS_GR_DATE%>">
	<input type="hidden" name="WMS_GR_DATE_W1" id="WMS_GR_DATE_W1"  value="<%=WMS_GR_DATE_W1%>">
	<input type="hidden" name="WMS_INV_DATE" id="WMS_INV_DATE"  value="<%=WMS_INV_DATE%>">
	<input type="hidden" name="WMS_DELIVERY_DATE" id="WMS_DELIVERY_DATE"  value="<%=WMS_DELIVERY_DATE%>">
	
	<div id="popWrapper" style="height:250px;">
		<div id="popHeader">
			<h1 class="title">배송조회</h1>
			<p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
		</div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<!--grid-->
        	<div>
        		<table class="cont_t_list02" style="width:100%">
        			<thead>
        			</thead>
        			<tbody>
                    	<div id="OrderStatus">
                    		<ul style="width:100%; height:180px"><!-- 외곽선 상자 높이 사이즈 조절 -->
                    			<li id="PR_STTS" class="Status01_off"><p id="PR_STTS_TEXT"><%=TEXT1_TYPE%><br><%=DATE1_TYPE%></p></li>
                    			<li class="arrow"></li>
                    		<%if("협력사".equals(TEXT2_TYPE)){%>
                    			<li id="PX_STTS" class="Status02_off"><p id="PX_STTS_TEXT"><%=TEXT2_TYPE%><br>수주접수<br><%=DATE2_TYPE%></p></li>
                    		<%}else{%>
                    			<li id="PX_STTS" class="Status02_off"><p id="PX_STTS_TEXT"><%=TEXT2_TYPE%><br><%=DATE2_TYPE%></p></li>
                   			<%}%>
                    			<li class="arrow"></li>
                   			<%if("배송조회".equals(TEXT3_2_TYPE)){%>
                    			<li id="IV_STTS" class="Status03_off"><p id="IV_STTS_TEXT"><u><a href='<%=PARCEL_URL%>' target='_blank' style='color:#003694'><%=TEXT3_1_TYPE%><br><%=TEXT3_2_TYPE%></u></a><br><%=DATE3_TYPE%></p></li>
                   			<%}else{%>
                    			<li id="IV_STTS" class="Status03_off"><p id="IV_STTS_TEXT"><%=TEXT3_1_TYPE%><br><%=TEXT3_2_TYPE%><br><%=DATE3_TYPE%></p></li>
                   			<%}%>
                    			<li class="arrow"></li>
                    			<li id="GR_STTS" class="Status04_off"><p id="GR_STTS_TEXT"><%=TEXT4_TYPE%><br><%=DATE4_TYPE%></p></li>
                    		</ul>
                    	</div>
                    	<font color="RED">※ 부분 납품의 경우 최근 납품된 일자 기준으로 표시됩니다.</font>
                    </tbody>
				</table>
				
				<br>
				
				<!--데이타그리드-->
				<h2>발주정보</h2>
	        	<table class="cont_t_list06 mb15" style="width:100%;">
	            	<caption>리스트</caption>
	                <colgroup>
	                    <col width="14%" />
	                    <col width="36%" />
	                    <col width="14%" />
	                    <col width="36%" />
	                </colgroup>
	                <tbody>
	                    <tr>
	                      <th>발주번호 / 항번</th>
	                      <td><%=LEGACY_PO_NO%> / <%=LEGACY_PO_SEQ%></td>
	                      <th>BQMS코드</th>
	                      <td><%=BUYER_ITEM_NO%></td>
	                    </tr>
	                    <tr>
	                      <th>KeP 영업담당자</th>
	                      <td><%=BYIT_USER_NAME%></td>
	                      <th>KeP 구매담당자</th>
	                      <td><%=MNG_USER_NAME%></td>
	                    </tr>
	                    <tr>
	                      <th>연락처</th>
	                      <td><%=BYIT_USER_EMAIL%> / <%=BYIT_USER_PHONE%></td>
	                      <th>연락처</th>
	                      <td><%=MNG_USER_CONTACT%></td>
	                    </tr>
	                </tbody>
	            </table>
	            
				<!--데이타그리드-->
				<h2>운송정보</h2>
	        	<table class="cont_t_list06 mb15" style="width:100%;">
	            	<caption>리스트</caption>
	                <colgroup>
	                    <col width="25%" />
	                    <col width="25%" />
	                    <col width="25%" />
	                    <col width="25%" />
	                </colgroup>
	                <tbody>
	                	<tr>
	                		<th style="text-align:center;">거래유형</th>
	                		<th style="text-align:center;">납품수량 / 단위</th>
	                		<th style="text-align:center;">표준납기일</th>
	                		<th style="text-align:center;">납품예정일</th>
	                    </tr>
	                    <tr>
	                    	<td style="text-align:center;"><%=PROCESS_TYPE%></td>
	                    	<td style="text-align:center;"><%=INV_QTY%> / <%=UNIT_MEASURE%></td>
	                    	<td style="text-align:center;"><%=ST_DATE%></td>
	                    	<td style="text-align:center;"><%=BUYER_DS_DATE%></td>
	                    </tr>
<%
if(!"직납".equals(PROCESS_TYPE)){
%>	                    
	                    <tr>
	                    	<th style="text-align:center;">센터입고일</th>
	                    	<th style="text-align:center;">출고준비</th>
	                    	<th style="text-align:center;">출고완료 / 배송중</th>
	                    	<th style="text-align:center;">납품완료</th>
	                    </tr>
	                    <tr>
	                    	<td style="text-align:center;"><%=WMS_GR_DATE%></td>
	                    	<td style="text-align:center;"><%=WMS_GR_DATE_W1%></td>
	                    	<td style="text-align:center;"><%=WMS_INV_DATE%></td>
	                    	<td style="text-align:center;"><%=WMS_DELIVERY_DATE%></td>
	                    </tr>
<%
}
%>
	                </tbody>
	            </table>
			</div>
		</div>
	</div>
</form>
</body>
</html>