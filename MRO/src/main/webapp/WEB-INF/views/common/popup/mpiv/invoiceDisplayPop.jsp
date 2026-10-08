<%--
**********************************************
* 메뉴 : 거래명세서조회
* 화면 : 거래명세서조회
* 기능 : 거래명세서조회
* 프로그램 ID : PG_07_A_002_01
* 담당자 : 개발1 ( 설계 : 김지현 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList1 = (List<Map<String,String>>) request.getAttribute("data1"); // 조회된결과
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList2 = (List<Map<String,String>>) request.getAttribute("data2"); // 조회된결과  
String INV_NO = CommonUtil.nvl((String) request.getParameter("INV_NO"),"");  //  (조회조건)  
String BUYER = CommonUtil.nvl((String) request.getParameter("BUYER"),"");  //  (조회조건)  
Map<String,String> rowData = null;
if (_dataList1==null || _dataList1.size()==0){	
}else{
	rowData = _dataList1.get(0);
}
%>
<script type="text/javascript">
<!--
function kep_onload_view(){
	<%
		if (_dataList1==null || _dataList1.size()==0){
	%>
			setQuery();
	<%	
		}
	%>
}

function setQuery()
{ 
  $('#invoiceDisplayPop').attr("action", "/common/getInvoiceDisplayPop.do").submit();   
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		setQuery();
	}
}
function setReturn(value1,value2)
{ 
  opener.setPopupReturn(value1,value2);
  this.close();
} 					    
			
function popupOpen(BUYER,BUYER_ITEM_NO,CONTRACT_NO,CONTRACT_SEQ){
	getBuyerCatalogDisplayPop(BUYER,BUYER_ITEM_NO,CONTRACT_NO,CONTRACT_SEQ); 
}
 //-->
</script> 
<body onload="kep_onload_view()">
	 <form name=invoiceDisplayPop id=invoiceDisplayPop method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="invoiceDisplayPop"> 
	 <input type="hidden"  name="INV_NO"  id="INV_NO"  value="<%=INV_NO%>" /> 
	 <input type="hidden"  name="BUYER"  id="BUYER"  value="<%=BUYER%>" /> 
<%
if (_dataList1==null || _dataList1.size()==0){
%>
<%}else{ %>	 
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:540px;">
    	<div id="popHeader">
        	<h1 class="title">거래명세서 상세조회</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">

	<table  class="cont_t_list06 mb15" summary="회원사" style="width:100%;">
		<caption>거래명세서 상세조회</caption>
		<colgroup>
			<col width="20%" />
			<col width="30%" />
			<col width="20%" />
			<col width="*" />
		</colgroup>
		<tbody>  
    	<tr> 
    		<th scope="row">발주번호</th>
			<td scope="row">&nbsp;<%=CommonUtil.nvl(rowData.get("PO_NO"))%></td>
    		<th scope="row">발주비고</th>
			<td scope="row">&nbsp;<%=CommonUtil.nvl(rowData.get("PO_REMARK"))%></td>
		</tr>
    	<tr> 
    		<th scope="row">공급가액</th>
			<td scope="row">&nbsp;<%=CommonUtil.formatNumber(rowData.get("INV_AMT"),true,0,3)%></td>
    		<th scope="row">공급받는자</th>
			<td scope="row">&nbsp;<%=CommonUtil.nvl(rowData.get("COM_NAME_LOC1"))%></td>
		</tr>
    	<tr> 
    		<th scope="row">납품예정일</th>
			<td scope="row">&nbsp;<%=CommonUtil.nvl(rowData.get("DS_DATE"))%></td>
    		<th scope="row">부가세</th>
			<td scope="row">&nbsp;<%=CommonUtil.formatNumber(rowData.get("INV_TAX_AMT_1"),true,0,3)%></td>
		</tr>
    	<tr> 
    		<th scope="row">공급원</th>
			<td scope="row">&nbsp;<%=CommonUtil.nvl(rowData.get("COM_NAME_LOC2"))%></td>
    		<th scope="row">납품일</th>
			<td scope="row">&nbsp;<%=CommonUtil.formatStrinigDate(rowData.get("INV_DATE"))%></td>
		</tr>
    	<tr> 
    		<th scope="row">총금액</th>
			<td scope="row">&nbsp;<%=CommonUtil.formatNumber(rowData.get("INV_TTL_AMT"),true,0,3)%></td>
    		<th scope="row"></th>
			<td scope="row"></td>
		</tr>
    	<tr> 
    		<th scope="row">납품장소</th>
			<td scope="row" colspan="3">&nbsp;<%=CommonUtil.nvl(rowData.get("DELY_TO_LOCATION"))%></td> 
		</tr>		
    	<tr> 
    		<th scope="row">비고</th>
			<td scope="row" colspan="3">&nbsp;<%=CommonUtil.nvl(rowData.get("REMARK_INV"))%></td> 
		</tr>
        </tbody>
   </table> 

			<!--grid-->
			<div class="scrollArea" style="height:190px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>개인정보 리스트</caption>
                    <colgroup>
                        <col width="20%" />  
                        <col width="20%" />  
                        <col width="20%" />  
                        <col width="20%" />  
                        <col width="*" />    
                    </colgroup>		   
                    <thead> 
                        <tr>         
                            <th scope="col">관리번호</th>     
                            <th scope="col">품목명/제조사</th>   
                            <th scope="col">발주수량/단위</th>   
                            <th scope="col">단가</th>   
                            <th scope="col">납품예정일</th>   
                        </tr>
                        <tr>         
                            <th scope="col">품목코드</th>     
                            <th scope="col">규격</th>   
                            <th scope="col">납품수량</th>   
                            <th scope="col">공급가액</th>   
                            <th scope="col">납기요청일</th>   
                        </tr>
                    </thead>
                    <tbody>
<!--                		<tr bgcolor="#FFFFFF"> -->
<!--                         <td colspan="5" align="center" height = "200"> -->
<!--                         <span class="font1">조회된 데이타가 없습니다.</span> -->
<!--                         </td>  -->
<!--                     </tr> -->
<%-- <%}else{ --%>
<% 
for (int j=0; j<_dataList2.size(); j++) {
	Map<String,String> _tmp2 = _dataList2.get(j);
%>  

				<input type="hidden" name="st_buyer"   value="<%=BUYER%>">
				<input type="hidden" name="st_po_no"   value="<%=CommonUtil.nvl(_tmp2.get("PO_NO"))%>">
				<input type="hidden" name="st_po_seq"  value="<%=CommonUtil.nvl(_tmp2.get("PO_SEQ"))%>">
				<input type="hidden" name="st_inv_no"  value="<%=INV_NO%>">
				<input type="hidden" name="st_inv_seq" value="<%=CommonUtil.nvl(_tmp2.get("INV_SEQ"))%>">
				<input type="hidden" name="st_ds_date" value="<%=CommonUtil.nvl(_tmp2.get("DS_DATE"))%>">


				<input type="hidden" name="st_cd_qty"  value="<%=CommonUtil.bnvl(_tmp2.get("INV_QTY"))%>">
				<input type="hidden" name="st_po_qty"  value="<%=CommonUtil.bnvl(_tmp2.get("ITEM_QTY"))%>">
				<input type="hidden" name="st_iv_qty"  value="<%=CommonUtil.bnvl(_tmp2.get("INV_QTY"))%>">
				
                        <tr>
						   <td><%=CommonUtil.nvl(_tmp2.get("REF_PR_NO"))%></td>						    
						   <td><%=CommonUtil.nvl(_tmp2.get("SPECIFICATION"))%></td>						    
						   <td><%=CommonUtil.formatNumber(_tmp2.get("ITEM_QTY"),true,0,3)%></td>					    
						   <td><%=CommonUtil.formatNumber(_tmp2.get("UNIT_PRICE"),true,0,3)%></td>		    
						   <td><%=CommonUtil.formatStrinigDate(_tmp2.get("DS_DATE"))%></td>						    
						</tr> 
                        <tr> 
						   <td><a href="javascript:popupOpen('<%=CommonUtil.nvl(_tmp2.get("BYIT_COMORG_CODE"))%>','<%=CommonUtil.nvl(_tmp2.get("BUYER_ITEM_NO"))%>','<%=CommonUtil.nvl(_tmp2.get("CONTRACT_NO"))%>','<%=CommonUtil.nvl(_tmp2.get("CONTRACT_SEQ"))%>');"><%=CommonUtil.nvl(_tmp2.get("BUYER_ITEM_NO"))%></a></td>						    
						   <td><%=CommonUtil.nvl(_tmp2.get("SPECIFICATION"))%></td>						    
						   <td><%=CommonUtil.formatNumber(_tmp2.get("INV_QTY"),true,0,3)%></td>				    
						   <td><%=CommonUtil.formatNumber(_tmp2.get("UNIT_PRICE2"),true,0,3)%> </td>						    
						   <td><%=CommonUtil.formatStrinigDate(_tmp2.get("RD_DATE"))%></td>						    
						</tr> 
<% } %>

                    </tbody>
                </table>  
             </div>	
        </div>
    </div>         
<%}%>                     
</form> 
</body>
</html>
