<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../../common/include/head_pop.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList1 = (List<Map<String,String>>) request.getAttribute("data1"); // 조회된결과
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList2 = (List<Map<String,String>>) request.getAttribute("data2"); // 조회된결과

String INV_NO = CommonUtil.nvl((String) request.getParameter("INV_NO"),"");  //  (조회조건)  
String BUYER = CommonUtil.nvl((String) request.getParameter("BUYER"),"");  //  (조회조건)

Map<String,String> rowData = null;

String SELLER = "";
String LEGACY_PO_NO = "";
String PURCHASER_ID = "";
String LEGACY_IV_SERIAL = "";
String TR_BUYER = "";

String RPT_URL = "";

String WAREHOUSE_CODE = "";

if (_dataList1==null || _dataList1.size()==0){	
}else{
	rowData = _dataList1.get(0);
	
	SELLER = CommonUtil.nvl(rowData.get("SELLER"));
	LEGACY_PO_NO = CommonUtil.nvl(rowData.get("LEGACY_PO_NO"));
	PURCHASER_ID = CommonUtil.nvl(rowData.get("PURCHASER_ID"));
	LEGACY_IV_SERIAL = CommonUtil.nvl(rowData.get("LEGACY_IV_SERIAL"));
	TR_BUYER = CommonUtil.nvl(rowData.get("TR_BUYER"));
	
	
	RPT_URL = CommonUtil.nvl(rowData.get("RPT_URL"));
	
	WAREHOUSE_CODE = CommonUtil.nvl(rowData.get("WAREHOUSE_CODE"));
}

String pP08_0000011id ="";
Map<String,String> formDataTemp = new HashMap<String,String>();
Map<String, String> _map = CommonUtil.getSpecialCheckReturnSheetMap(BUYER);
if(_map!=null){
	pP08_0000011id = _map.get("SLG_ID");
}
String  deptMap = "";
if("P08-0000011-23".equals(pP08_0000011id)  && "IK".equals(INV_NO.substring(0, 2))   ){
	
	formDataTemp.put("st_warehouse_code",CommonUtil.nvl((String) request.getParameter(WAREHOUSE_CODE),"") );
	formDataTemp.put("st_ik_no_temp",CommonUtil.nvl((String) request.getParameter(INV_NO),""));
	formDataTemp.put("st_buyer",CommonUtil.nvl((String) request.getParameter(BUYER),"") );
	deptMap = CommonUtil.getSpecialCheckReturnSheetMapByDept( formDataTemp );

	}

String com_type = "";
if (_sessionInfo != null){
	com_type =  CommonUtil.nvl((String)_sessionInfo.getComType()); 	
}
%>
<script src="/resources/js/wms_tr_sheet.js"></script>
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
	openSearchPopup("/common/catalogDetailPop.do", "?BUYER="+BUYER+"&BUYER_ITEM_NO="+BUYER_ITEM_NO+"&CONTRACT_NO="+CONTRACT_NO+"&CONTRACT_SEQ="+CONTRACT_SEQ, "800,290,no");
}

function sheetWin() {
	
	var buyer	= "<%=BUYER%>";
	var inv_no	= "<%=INV_NO%>";
	
	if(inv_no.substring(0,2) == "IK"){
		
		var user_id = $("#st_user_id").val();
		
		var warehouse_code = "<%=WAREHOUSE_CODE%>";
		var legacy_po_no = "<%=LEGACY_PO_NO%>";
		var legacy_iv_serial = "<%=LEGACY_IV_SERIAL%>";
		
		var legacy_po_seq = $("#st_legacy_po_seq_tot").val();
		
		if("P08-0000011-23"=="<%=pP08_0000011id%>" ){
			setWmsTrSheet("<%=pP08_0000011id%>","" ,"<%=deptMap%>", warehouse_code, buyer, inv_no, user_id, legacy_po_no, legacy_po_seq, legacy_iv_serial, "");
		}else{
			setWmsTrSheet("<%=pP08_0000011id%>","" ,"", warehouse_code, buyer, inv_no, user_id, legacy_po_no, legacy_po_seq, legacy_iv_serial, "");
		}
		

		return;
		
	} else {
		var rpt_url = "<%=RPT_URL%>";
		
		var seller	= "<%=SELLER%>";
		var legacy_po_no = "<%=LEGACY_PO_NO%>";
		var pur_id = "<%=PURCHASER_ID%>";
		var legacy_iv_serial = "<%=LEGACY_IV_SERIAL%>";
		var tr_buyer = "<%=TR_BUYER%>";
		var print_gbn = $("input:radio[name='radioBtn']:checked").val();	// 0:발주서, 1:납품서
		 
		 	
	   	var param = "["+inv_no+"]["+seller+"]["+buyer+"]["+legacy_po_no+"]["+pur_id+"]";
	   	
	   	openBuyerTranStatReportOpen(buyer, rpt_url, param, legacy_iv_serial, tr_buyer, print_gbn, legacy_po_no);
	}
	
	return;
}

 //-->
</script> 
<body onload="kep_onload_view()">
	 <form name=invoiceDisplayPop id=invoiceDisplayPop method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="invoiceDisplayPop"> 
	 <input type="hidden"  name="INV_NO"  id="INV_NO"  value="<%=INV_NO%>" /> 
	 <input type="hidden"  name="BUYER"  id="BUYER"  value="<%=BUYER%>" /> 
	 <input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
	
	
<%
if (_dataList1==null || _dataList1.size()==0){
%>
<%}else{ %>	 
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:544px;">
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
			<th scope="row">공급받는자</th>
			<td scope="row">&nbsp;<%=CommonUtil.nvl(rowData.get("COM_NAME_LOC1"))%></td>
		</tr>
    	<tr> 
    		<th scope="row">발주비고</th>
			<td scope="row" colspan="3">&nbsp;<%=CommonUtil.nvl(rowData.get("PO_REMARK"))%></td>
		</tr>
    	<tr> 
    		<th scope="row">납품예정일</th>
			<td scope="row">&nbsp;<%=CommonUtil.formatStrinigDate(rowData.get("DS_DATE"))%></td>
    		<th scope="row">총금액</th>
<%if(!com_type.equals("W")){%>
			<td scope="row">&nbsp;<%=CommonUtil.formatNumber(rowData.get("INV_AMT"),true,0,3)%></td>
<%}else{%>
			<td scope="row"></td>
<%}%>
		</tr>
    	<tr> 
    		<th scope="row">공급원</th>
			<td scope="row">&nbsp;<%=CommonUtil.nvl(rowData.get("COM_NAME_LOC2"))%></td>
    		<th scope="row">납품일</th>
			<td scope="row">&nbsp;<%=CommonUtil.formatStrinigDate(rowData.get("INV_DATE"))%></td>
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
			<div class="scrollArea" style="height:230px">
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
String _legacyPoSeqA = "";
String _legacyPoSeqTot = "";

for (int j=0; j<_dataList2.size(); j++) {
	Map<String,String> _tmp2 = _dataList2.get(j);
	
	if(BUYER.equals("KRDOOS0035")){
		if(j == (_dataList2.size()-1) ){
			_legacyPoSeqA = CommonUtil.nvl(_tmp2.get("LEGACY_PO_SEQ")) + "";
		} else {
			_legacyPoSeqA = CommonUtil.nvl(_tmp2.get("LEGACY_PO_SEQ")) + ",";
		}
		
		_legacyPoSeqTot = _legacyPoSeqTot + _legacyPoSeqA;
		
	} else {
		_legacyPoSeqA = CommonUtil.nvl(_tmp2.get("LEGACY_PO_SEQ")) + "@@";	
		_legacyPoSeqTot = _legacyPoSeqTot + _legacyPoSeqA;
	}
%>  

				<input type="hidden" name="st_buyer"   value="<%=BUYER%>">
				<input type="hidden" name="st_po_no"   value="<%=CommonUtil.nvl(_tmp2.get("PO_NO"))%>">
				<input type="hidden" name="st_po_seq"  value="<%=CommonUtil.nvl(_tmp2.get("PO_SEQ"))%>">
				<input type="hidden" name="st_inv_no"  value="<%=INV_NO%>">
				<input type="hidden" name="st_inv_seq" value="<%=CommonUtil.nvl(_tmp2.get("INV_SEQ"))%>">
				<input type="hidden" name="st_ds_date" value="<%=CommonUtil.formatStrinigDate(_tmp2.get("DS_DATE"))%>">


				<input type="hidden" name="st_cd_qty"  value="<%=CommonUtil.bnvl(_tmp2.get("INV_QTY"))%>">
				<input type="hidden" name="st_po_qty"  value="<%=CommonUtil.bnvl(_tmp2.get("ITEM_QTY"))%>">
				<input type="hidden" name="st_iv_qty"  value="<%=CommonUtil.bnvl(_tmp2.get("INV_QTY"))%>">
				
                        <tr>
						   <td><%=CommonUtil.nvl(_tmp2.get("REF_PR_NO"))%></td>						    
						   <td><%=CommonUtil.nvl(_tmp2.get("MAKER_NAME"))%></td>						    
						   <td><%=CommonUtil.formatNumber(_tmp2.get("ITEM_QTY"),true,0,3)%></td>
<%if(!com_type.equals("W")){%>
						   <td><%=CommonUtil.formatNumber(_tmp2.get("UNIT_PRICE"),true,0,3)%></td>
<%}else{%>
							<td></td>
<%}%>
						   <td><%=CommonUtil.formatStrinigDate(_tmp2.get("DS_DATE"))%></td>						    
						</tr> 
                        <tr> 
						   <td><a href="javascript:popupOpen('<%=CommonUtil.nvl(_tmp2.get("BYIT_COMORG_CODE"))%>','<%=CommonUtil.nvl(_tmp2.get("BUYER_ITEM_NO"))%>','<%=CommonUtil.nvl(_tmp2.get("CONTRACT_NO"))%>','<%=CommonUtil.nvl(_tmp2.get("CONTRACT_SEQ"))%>');"><%=CommonUtil.nvl(_tmp2.get("BUYER_ITEM_NO"))%></a></td>						    
						   <td><%=CommonUtil.nvl(_tmp2.get("SPECIFICATION"))%></td>						    
						   <td><%=CommonUtil.formatNumber(_tmp2.get("INV_QTY"),true,0,3)%></td>
<%if(!com_type.equals("W")){%>
						   <td><%=CommonUtil.formatNumber(_tmp2.get("UNIT_PRICE2"),true,0,3)%> </td>
<%}else{%>
							<td></td>
<%}%>
						   <td><%=CommonUtil.formatStrinigDate(_tmp2.get("RD_DATE"))%></td>						    
						</tr> 
<% } %>

                    </tbody>
                </table>  
             </div>	
             
             <input type="hidden" id="st_legacy_po_seq_tot"  name="st_legacy_po_seq_tot" value="<%=_legacyPoSeqTot%>">
             
			<!-- 거래명세서인쇄 버튼 -->
			<div class="btnArea">
				<div class="fr"> 
				<% if (("KRSTX-0002".equals(BUYER) ||   "KRSTX-0003".equals(BUYER) ||   "KRSTX-0005".equals(BUYER) ||   "KRSTX-0006".equals(BUYER) ||   "KRSTX-0007".equals(BUYER)) && INV_NO.indexOf("IK") == -1){       //STX 엔진3사 (KRSTX-0002,KRSTX-0003,KRSTX-0005,KRSTX-0006)              %>
					<span style="vertical-align:top;height:28px;padding-top:2px; vertical-align: middle;">
						<input type="radio" name="radioBtn" value="0" style="border:0px;vertical-align:middle;" checked>발주서</input>&nbsp;&nbsp;
						<input type="radio" name="radioBtn" value="1" style="border:0px;vertical-align:middle;">납품서</input>
					</span>
				<%} else{ %>			
				
				<%} %>		
					<span class="btn_04">
						<a href="javascript:sheetWin();">거래명세서</a>
					</span>	
				</div>
			</div>
        </div>
    </div>         
<%}%>                     
</form> 
</body>
</html>
