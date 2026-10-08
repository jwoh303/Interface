<%--
**********************************************
* 메뉴 : 주문/배송조회
* 화면 : 거래명세서 상세조회 팝업
* 기능 : 
* 프로그램 ID : BU0402009
* 담당자 : 최찬규
* 착수일 : 2026-04-17
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
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<%@ include file="../../include/head_v2.jspf"  %>
 
<%
	@SuppressWarnings (value="unchecked")
	Map<String,String> _infoMap 		= (Map<String,String>) request.getAttribute("info"); // 조회된 결과
	
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _dataList  = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과

	//buyer=KRKEPB0004&seller=KRKORE0001&inv_no=IV13372113&po_no=PO13000067&pur_id=BUYER
	SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	
	String buyer = CommonUtil.nvl((String) request.getParameter("buyer"),(String)sessionInfo.getComCode());
	String inv_no = CommonUtil.nvl((String) request.getParameter("inv_no"),"");
	String seller = CommonUtil.nvl((String) request.getParameter("seller"),"");
	String po_no = CommonUtil.nvl((String) request.getParameter("po_no"),"");
	String pur_id = CommonUtil.nvl((String) request.getParameter("pur_id"),"");
	String user_id = CommonUtil.nvl((String) request.getParameter("user_id"),"");
	
	String p_buyer			= CommonUtil.nvl((String)request.getAttribute("buyer"));
	String p_seller			= CommonUtil.nvl((String)request.getAttribute("seller"));
	String p_po_no			= CommonUtil.nvl((String)request.getAttribute("po_no"));
	String p_inv_no			= CommonUtil.nvl((String)request.getAttribute("inv_no"));
	
	String legacy_po_no		= CommonUtil.nvl(_infoMap.get("LEGACY_PO_NO"));
	String purchaser_id		= CommonUtil.nvl(_infoMap.get("PURCHASER_ID"));
	String tr_buyer			= CommonUtil.nvl(_infoMap.get("TR_BUYER"));
	String legacy_iv_serial	= CommonUtil.nvl(_infoMap.get("LEGACY_IV_SERIAL"));
	String rpt_url			= CommonUtil.nvl(_infoMap.get("RPT_URL"));
	
	//SLOGIC-BEGIN(P06-0000072) - 장바구니 중복 등록 허용 고객사
	boolean p060000072 = CommonUtil.getSpecialCheckReturn(p_buyer,"P06-0000072");
	
	String dup_add_posb_yn = "N";
	
	if(p060000072 == true){
		dup_add_posb_yn = "Y";
    }
	
	String defaultUrl = "/mpso/getBuyerMpSoCartList.do";
	String p060000036 = CommonUtil.getSpecialCheckReturn(request.getParameter("buyer"),"P06-0000036","COL02_DATA", request); // 권한별URL
	if (p060000036 == null){
		p060000036 = defaultUrl;
	}else if ("".equals(p060000036)){
		p060000036 = defaultUrl;
	} 
	
%>

<script type="text/javascript">
//alert layer용
var but1text = "<%=CommonLang.get("HTITLE516")%>"; //확인
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

var mySheet = new ibsheetObject();
var pagingMode = "N";

function kep_onload_view(){ 
	 
	 var initsheet = {};
		initsheet.Cfg = {MergeSheet:msHeaderOnly,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
		initsheet.Cols = [
				 { Align:"Center",	SaveName:"sStatus",				Header:"<%=CommonLang.get("HTITLE255")%>",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}/*상태*/
				,{ Align:"Left",	SaveName:"REF_PR_NO",			Header:"<%=CommonLang.get("HTITLE18")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*관리번호*/
				,{ Align:"Left",	SaveName:"BUYER_ITEM_NO",		Header:"<%=CommonLang.get("HTITLE12")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*품목코드*/
				,{ Align:"Left",	SaveName:"DESCRIPTION",			Header:"<%=CommonLang.get("HTITLE13")%>",				Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:false} /*품목명*/
				,{ Align:"Left",	SaveName:"SPECIFICATION",		Header:"<%=CommonLang.get("HTITLE14")%>",				Type:"Text",		Width:170,	Edit:false,	EditLen:100,	Hidden:false}/*규격*/
				,{ Align:"Right",	SaveName:"UNIT_PRICE",			Header:"<%=CommonLang.get("HTITLE174")%>",				Type:"Float",		Width:90,	Edit:false,	EditLen:100,	Hidden:false,Format:"${priceFormat}"}/*단가*/
				,{ Align:"Right",	SaveName:"ITEM_QTY",			Header:"<%=CommonLang.get("HTITLE217")%>",				Type:"Float",		Width:70,	Edit:false,	EditLen:100,	Hidden:false} /*발주수량*/
				,{ Align:"Right",	SaveName:"INV_QTY",				Header:"<%=CommonLang.get("HTITLE263")%>",				Type:"Float",		Width:70,	Edit:false,	EditLen:100,	Hidden:false} /*송장수량*/
				,{ Align:"Center",	SaveName:"UNIT_MEASURE",		Header:"<%=CommonLang.get("HTITLE52")%>",				Type:"Text",		Width:70,	Edit:false,	EditLen:100,	Hidden:false}/*단위*/
				,{ Align:"Right",	SaveName:"PO_AMT",				Header:"<%=CommonLang.get("HTITLE922")%>",				Type:"Float",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,Format:"${priceFormat}"}/*합계*/
				,{ Align:"Left",	SaveName:"BUDGET_DEPT_NAME",	Header:"<%=CommonLang.get("HTITLE268")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}/*예산부서*/
				,{ Align:"Left",	SaveName:"ACCOUNT_NAME",		Header:"<%=CommonLang.get("HTITLE966")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false}/*예산계정*/
				,{ Align:"Center",	SaveName:"IMAGE_KEY_CNT",		Header:"<%=CommonLang.get("HTITLE177")%>",				Type:"Button",		Width:80,	Edit:false,	EditLen:100,	Hidden:false,ClassName:'Type03'}/*파일첨부*/
				,{ Align:"Left",	SaveName:"PO_REMARK",			Header:"<%=CommonLang.get("HTITLE783")%>",				Type:"Text",		Width:200,	Edit:false,	EditLen:100,	Hidden:false}/*품목비고*/
				,{ Align:"Center",	SaveName:"IMAGE_KEY",			Header:"IMAGE_KEY",										Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"CONTRACT_NO",			Header:"CONTRACT_NO",									Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"CONTRACT_SEQ",		Header:"CONTRACT_SEQ",									Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"BYIT_COMORG_CODE",	Header:"BYIT_COMORG_CODE",								Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:true}
				,{ Align:"Center",	SaveName:"AGENT_CODE",	Header:"AGENT_CODE",								Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:true}
				
		];
		
		IBS_InitSheet(mySheet, initsheet, pagingMode);
		mySheet.SetHighlightAfterSort(2);
		
		mySheet.SetHeaderBackColor("#f2f7ff");
		mySheet.SetTheme("DB", "DeepBlue");
		
		kepSearch(document.commonMpIvInvoiceDetailIVPop, mySheet, "/mpiv/getCommonMpIvInvoiceDetailListIVPop_v2.do" , pagingMode);
}
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if (msg != "") {
//		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
	
	for(var i = 1; i<=mySheet.RowCount(); i++){
		if(mySheet.GetCellValue(i,"IMAGE_KEY_CNT") == "0"){
			mySheet.SetCellValue(i,"IMAGE_KEY_CNT","");
		}else{
			mySheet.SetCellValue(i,"IMAGE_KEY_CNT","<%=CommonLang.get("HTITLE1202")%>"+mySheet.GetCellValue(i,"IMAGE_KEY_CNT")+"<%=CommonLang.get("HTITLE1203")%>"); // 첨부()
		}
	}
	
}
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;
	
	var image_key = mySheet.GetCellValue(Row,"IMAGE_KEY");
	
	if(column == "IMAGE_KEY_CNT"){
		if(mySheet.GetCellValue(Row, "IMAGE_KEY") != "")
			location.href="/common/download_v2.do?DOC_NO="+image_key;
	}
	return;
}

function sheetWin() {
	
	var buyer	= "<%=p_buyer%>";

	var seller			= "<%=p_seller%>";
	var inv_no			= "<%=p_inv_no%>";
	var rpt_url 		= "<%=rpt_url%>";
	var legacy_po_no	= "<%=legacy_po_no%>";
	var pur_id 			= "<%=purchaser_id%>";
	var legacy_iv_serial= "<%=legacy_iv_serial%>";
	var tr_buyer 		= "<%=tr_buyer%>";
	var print_gbn 		= "";
	 	
   	var param = "["+inv_no+"]["+seller+"]["+buyer+"]["+legacy_po_no+"]["+pur_id+"]";
   	
   	openBuyerTranStatReportOpen(buyer, rpt_url, param, legacy_iv_serial, tr_buyer, print_gbn, legacy_po_no);
   	
	return;
}
function cartInsertText(){
	var text = "<%=CommonLang.msg("MSG104")%>";	//장바구니에 담으시겠습니까?
	var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
	var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
	var but1funcC = "javascript:cartInsert(); return false;";
	var but2funcC = "javascript:closePopText1(); return false;";
	var but1widthC = "120px";
	var but2widthC = "120px";
	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
}
function cartInsert(){
	closePopText1();
	
	var query = "";
	for(var i = 1; i<=mySheet.RowCount(); i++){
		query += mySheet.GetCellValue(i,"BUYER_ITEM_NO") + "@@" + "1" + "@@" + mySheet.GetCellValue(i,"AGENT_CODE") + "@@" + mySheet.GetCellValue(i,"CONTRACT_NO") + "@@" + mySheet.GetCellValue(i,"CONTRACT_SEQ") + "@@" + mySheet.GetCellValue(i,"BYIT_COMORG_CODE");
		query += "&&";
	}
	
	document.forms.processForm.st_pf_my_group.value = "";
	document.forms.processForm.st_use_flag.value = "C"; 
	document.forms.processForm.st_query2.value = query;
	document.forms.processForm.st_dup_add_flag.value = "<%=dup_add_posb_yn%>";
	kepAjaxFormCall("/mdcm/saveBuyerMdCmGoodsLisList.do","processForm","CsaveProcess");
}
function kepAjaxSuccess(pMethod , response){
	
	var sMsg = response.msg.MSG;  
	if(pMethod == "CsaveProcess"){
		if (sMsg == "CREATE_OK"){
			//장바구니에 추가되었습니다. 장바구니로 이동하시겠습니까?
			var text = "<%=CommonLang.msg("MSG695")%>" +" "+ "<%=CommonLang.msg("MSG364")%>"; 
			var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
			var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
         	var but1funcC = "javascript:goCart(); return false;";
         	var but2funcC = "javascript:closePopText1(); return false;";
         	var but1widthC = "120px";
         	var but2widthC = "120px";
         	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
		} else{
			//이미 장바구니에 담긴 품목입니다.\n선택하신 수량이 추가되었습니다. 장바구니로 이동하시겠습니까?
			var text = sMsg +"<br/>"+ "<%=CommonLang.msg("MSG364")%>";
			var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
			var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
         	var but1funcC = "javascript:goCart(); return false;";
         	var but2funcC = "javascript:closePopText1(); return false;";
         	var but1widthC = "120px";
         	var but2widthC = "120px";
         	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
		}
	}
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	
	if (pMethod == "CsaveProcess"){ 
		//장바구니담기 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.
		 var text = "<%=CommonLang.msg("MSG26") %>  ";
   		 openLayerPopText2(text,but1text,but1func,but1width);
	}
	 
	
} 

function goCart(){
	closePopText1();
	
	opener.location.href = "<%=p060000036%>";
	self.close();
}
</script> 
</head>
<body onload="kep_onload_view()">
<form name="commonMpIvInvoiceDetailIVPop" id="commonMpIvInvoiceDetailIVPop" method=post >
	<input type="hidden" name="s_SAVENAME" />
	<input type="hidden" name="COMPANY" value="<%=p_buyer%>"/>
	<input type="hidden" name="buyer" value="<%=buyer%>"/>
	<input type="hidden" name="seller" value="<%=seller %>" />
	<input type="hidden" name="inv_no" value="<%=inv_no %>" />
	<input type="hidden" name="po_no" value="<%=po_no %>" />
	<input type="hidden" name="pur_id" value="<%=pur_id %>" />
	<input type="hidden" name="user_id" value="<%=user_id %>" />
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div class="wrapPopup">
  <div class="PopupTit"><%=CommonLang.get("HTITLE1241")%><!--거래명세서상세--><span><a href="javascript:self.close();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="PopupTitSubState"><%=CommonLang.get("HTITLE1241")%><!-- 거래명세서상세 -->  
  
  </div>
  <table class="PopTableThLTdL" width="100%">
    <colgroup>
      <col width="12%" />
      <col width="12%" />
      <col width="12%" />
      <col width="12%" />
      <col width="12%" />
      <col width="12%" />
      <col width="12%" />
      <col width="12%" />
  	</colgroup>
    <tr>
      <th><%=CommonLang.get("HTITLE144")%><!-- 협력사 --></th>
      <td><%=CommonUtil.nvl(_infoMap.get("AGENT_NAME")) %></td>
      <th><%=CommonLang.get("HTITLE784")%><!-- 거래명세서번호 --></th>
      <td><%=CommonUtil.nvl(_infoMap.get("INV_NO")) %></td>
      <th><%=CommonLang.get("HTITLE1224")%><!-- 택배사 --></th>
      <td><%=CommonUtil.nvl(_infoMap.get("PARCEL_COM_CODE")) %></td>
      <th><%=CommonLang.get("HTITLE1240")%><!-- 택배송장번호 --></th>
      <td><a href="<%=CommonUtil.nvl(_infoMap.get("PARCEL_URL")) %>" target='_blank' style="text-decoration:underline; color:#3a72c7;"><%=CommonUtil.nvl(_infoMap.get("PARCEL_INV_NO")) %></a></td>
    </tr>
  </table>
  
  <div class="PopupTitSub"><%=CommonLang.get("HTITLE824")%><!-- 배송정보 --></div>
  <div class="Popup_GrayBox">
    <div class="txtbold"><%=CommonUtil.nvl(_infoMap.get("DELY_TO_LOCATION_TEXT")) %></div> 
    <div class="txt"> <%=CommonUtil.nvl(_infoMap.get("DELY_TO_LOCATION")) %></div> 
    <div class="txt">
    <%if(!CommonUtil.nvl(_infoMap.get("RECIPIENT_NAME"),"").equals("")) {%>
    	<%=CommonUtil.nvl(_infoMap.get("RECIPIENT_NAME")) %> |
    <%} %>
    <%if(!CommonUtil.nvl(_infoMap.get("RECIPIENT_PHONE"),"").equals("")) {%>
    	<%=CommonUtil.nvl(_infoMap.get("RECIPIENT_PHONE")) %> |
    <%} %> 
    <%=CommonLang.get("HTITLE831")%><!-- 수령희망일 -->  <%=CommonUtil.nvl(_infoMap.get("RD_DATE")) %> 
    </div>
  </div>  
  <div class="PopupTitSub"  ><%=CommonLang.get("HTITLE1222")%><!-- 주문품목 --><p style="display:inline-block; margin-left:5px">(<%=CommonUtil.formatNumber(_infoMap.get("INV_CNT"),true,0,3)%> <%=CommonLang.get("HTITLE1233")%><!--품목--> / <%=CommonUtil.formatNumber(_infoMap.get("INV_AMT"),true,0,3)%><%=CommonLang.get("HTITLE660")%><!-- 원 -->)</p> </div>  
  <div class="ScrollBox " style="height:169px">
	<script type="text/javascript">
		createIBSheet("mySheet", "", "100%");
	</script>
  </div>  
 
  <div class="PopupListBtnBox_Center mt20" >
    <button class="ButQuaternary_large" onclick="javascript:sheetWin(); return false;"><%=CommonLang.get("HTITLE1242")%><!--거래명세서출력--></button>
    <button class="ButQuaternary_large" onclick="javscript:cartInsertText(); return false;"><%=CommonLang.get("HTITLE1183")%><!-- 장바구니담기 --></button>
  </div>  
</div><!-- warp 끝-->
</form> 

<form name="processForm" id="processForm" method="post">	
	<input type="hidden" name="st_buyer" id="st_buyer" value="">
	<input type="hidden" name="st_pr_no" id="st_pr_no" value="">
	<input type="hidden" name="st_pr_seq" id="st_pr_seq" value="">
	<input type="hidden" name="st_pf_my_group" id="st_pf_my_group" value="">
	<input type="hidden" name="st_use_flag" id="st_use_flag" value="">
	<input type="hidden" name="st_query2" id="st_query2" value="">
	<input type="hidden" name="st_dup_add_flag" id="st_dup_add_flag" value="">
</form> 
</body>
</html>
