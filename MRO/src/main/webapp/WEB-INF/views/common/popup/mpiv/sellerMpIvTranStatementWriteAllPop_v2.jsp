<%--
**********************************************
* 메뉴 : 
* 화면 : 거래명세서생성
* 기능 : 거래명세서를 생성하기 위한 팝업 - 일괄
* 프로그램 ID : SU0503005
* 담당자 : 최찬규
* 착수일 : 2025-10-28
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
<%@ include file="../../include/head_v2.jspf"  %>
<script src="/resources/js/common.js"></script>
<link rel="stylesheet" href="/resources/css/month_popup.css" type="text/css" />
</head>
<%
@SuppressWarnings (value="unchecked")

	Map<String,String> _info = (Map<String,String>) request.getAttribute("info"); // 조회된 결과

	String user_id = _sessionInfo.getUserId();
	String agent = _sessionInfo.getComCode();
	
	String info = CommonUtil.nvl((String)request.getParameter("layerPopInfo"), ""); //이전 페이지에서 넘겨온 대상 품목 데이터들
	if(info == null) info = "[]"; //null 방지
	
	String p_user_id = CommonUtil.nvl((String)request.getParameter("p_user_id_all"), ""); //
	String p_kep_id = CommonUtil.nvl((String)request.getParameter("p_kep_id"), ""); //
	String p_buyer = CommonUtil.nvl((String)request.getParameter("st_buyer_code"), ""); //

	
	// 입고라벨 미사용 대상 고객사
	String st_no_tag_check_yn = "N";
	boolean st_no_tag_check = CommonUtil.getCodeCheckReturn("M204", p_buyer);
	if(st_no_tag_check == true){
		st_no_tag_check_yn = "Y";
	}else{
		st_no_tag_check_yn = "N";
	}
		
	String tr_buyer = CommonUtil.nvl(_info.get("TR_BUYER"));
	String process_type = CommonUtil.nvl(_info.get("PROCESS_TYPE"));
	
	String legacy_po_no = CommonUtil.nvl(_info.get("LEGACY_PO_NO"));
	String pur_id = CommonUtil.nvl(_info.get("PURCHASER_ID"));
	
	String rpt_url = CommonUtil.nvl(_info.get("RPT_URL"));

	String session_com_code = CommonUtil.nvl(_sessionInfo.getComCode());
	
	// 품목라벨 자체 사용 고객사(KEP 품목라벨은 중복되어 출력되지 않아야 함)
	String st_no_itemTag_check_yn = "N";
	boolean st_no_itemTag_check = CommonUtil.getCodeCheckReturn("M206", p_buyer);
	if(st_no_itemTag_check == true){
		st_no_itemTag_check_yn = "Y";
	}else{
		st_no_itemTag_check_yn = "N";
	}
	
	// 고객사 고유 품목라벨 사용
	String p070000034 = "";
	Map<String, String> p070000034_map = CommonUtil.getSpecialCheckReturnMap(p_buyer,"P07-0000034");
	if (p070000034_map != null){
    	p070000034 = CommonUtil.nvl(p070000034_map.get("COL01_DATA"),""); // 품목라벨 mrd
    }
%>
<script type="text/javascript">
window.calendarPositionOffset = {
		top:-150,
		left:-100
	};
	
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤

var but1text = "확인";
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

//최초 화면 함수 
function init(){
	$("#st_invoice_date_text").val(kepGetNowTimeStr('YYYYMMDD','/'));
	
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet.Cols = [
			 { Align:"Center",	SaveName:"sStatus",				Header:"상태",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}
			,{ Align:"Center",	SaveName:"SELECTED",			Header:"",					Type:"DummyCheck",	Width:60,	Edit:true,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"DS_DATE",				Header:"DS_DATE",			Type:"Date",		Width:150,	Edit:false,	EditLen:100,	Hidden:false,Format:"yyyy-MM-dd"}
			,{ Align:"Left",	SaveName:"BUYER",				Header:"BUYER",				Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"PO_NO",				Header:"PO_NO",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"PO_SEQ",				Header:"PO_SEQ",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Right",	SaveName:"CD_QTY",				Header:"CD_QTY",			Type:"Float",			Width:60,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Right",	SaveName:"IV_QTY",				Header:"IV_QTY",			Type:"Float",			Width:60,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Right",	SaveName:"PO_QTY",				Header:"PO_QTY",			Type:"Float",			Width:60,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Right",	SaveName:"INV_POSS_QTY",		Header:"INV_POSS_QTY",			Type:"Float",			Width:60,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"PROCESS_TYPE",		Header:"PROCESS_TYPE",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Center",	SaveName:"SELLER",			Header:"SELLER",			Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:false}
	];

	IBS_InitSheet(mySheet, initsheet, pagingMode);
	
	mySheet.SetHeaderBackColor("#f2f7ff");
	mySheet.SetCountFormat(" 총  ROWCOUNT 건 ");

	mySheet.SetTheme("DB", "DeepBlue");
	
	var infoList = <%=info%>;
	
	mySheet.RenderSheet(0);
	for(var i = 0; i<infoList.length; i++){
		// 대상품목 그려주기
		var newIndex = 0;
		newIndex = mySheet.DataInsert(-1);
		mySheet.SetCellValue(newIndex, "BUYER", infoList[i].BUYER);
		mySheet.SetCellValue(newIndex, "PO_NO", infoList[i].PO_NO);
		mySheet.SetCellValue(newIndex, "PO_SEQ", infoList[i].PO_SEQ);
		mySheet.SetCellValue(newIndex, "DS_DATE", infoList[i].DS_DATE);
		mySheet.SetCellValue(newIndex, "CD_QTY", infoList[i].CD_QTY);
		mySheet.SetCellValue(newIndex, "INV_POSS_QTY", infoList[i].INV_POSS_QTY);
		mySheet.SetCellValue(newIndex, "PROCESS_TYPE", infoList[i].PROCESS_TYPE);
		mySheet.SetCellValue(newIndex, "SELLER", infoList[i].SELLER);
		mySheet.SetCellValue(newIndex, "PO_QTY", infoList[i].PO_QTY);
		mySheet.SetCellValue(newIndex, "IV_QTY", infoList[i].IV_QTY);
		mySheet.SetCellValue(newIndex, "SELLER", infoList[i].SELLER);
	}
	mySheet.RenderSheet(1);
	
	$("#st_seller").val(mySheet.GetCellValue(1,"SELLER"));
}

//조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
}
//팝업호출
function doPop(str, value1, value2, value3, value4) {
	popupSel = str ;
	
	switch (str) {
		case "commonMpIvDlvryNoticePop": // 납품시 공지정보
			openSearchPopup("/mpiv/getCommonMpIvDlvryNoticePop.do", "?st_type="+value1, value2);
			break;
	}
}
function invoiceCreate(){ //cck
	
	var process_type = "<%=process_type%>";
	if(process_type == "2"){
		var print_size = $("#st_print_size").val();
		
		if(isEmpty(print_size)){
// 			alert("라벨출력방식을 선택해주세요.");
			var text = "라벨출력방식을 선택해주세요.";
			openLayerPopText2(text,but1text,but1func,but1width);
			$("#st_print_size").focus();
			return;
		}	
	}
	
	
	var parcel_yn = $("input[name='st_parcel_type']:checked").val();
	if(isEmpty(parcel_yn)){
// 		alert("배송유형을 선택해주세요.");
		var text = "배송유형을 선택해주세요.";
		openLayerPopText2(text,but1text,but1func,but1width);
		$("#st_parcel_type").focus();
		return;
	}
	document.forms["contentForm"].st_parcel_yn.value =  parcel_yn;

	var query = "";
	var invoice_date = $("#st_invoice_date_text").val().replace(/[/]/gi,"");
	
	var text = "거래명세서를 작성 하시겠습니까?";
	var but1textC = "확인";
	var but2textC = "취소";
	var but1funcC = "javascript:invoiceCreateFunc(); return false;";
	var but2funcC = "javascript:closePopText1(); return false;";
	var but1widthC = "110px";
	var but2widthC = "110px";
	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
	
// 	if(confirm("거래명세서를 작성 하시겠습니까?")){
// 		for(var i=1; i<=mySheet.RowCount(); i++){ //CCK
// 			var complete_mark   = "N";
// 			var buyer = mySheet.GetCellValue(i,"BUYER");
// 			var po_no = mySheet.GetCellValue(i,"PO_NO");
// 			var po_seq = mySheet.GetCellValue(i,"PO_SEQ");
// 			var cd_qty = mySheet.GetCellValue(i,"CD_QTY");
// 			var po_qty = mySheet.GetCellValue(i,"PO_QTY");
// 			var poss_cd_qty = mySheet.GetCellValue(i,"INV_POSS_QTY");
// 			var inv_qty = mySheet.GetCellValue(i,"IV_QTY");
// 			var ds_date = mySheet.GetCellValue(i,"DS_DATE");
// 			var process_type = mySheet.GetCellValue(i,"PROCESS_TYPE");
// 			var seller = mySheet.GetCellValue(i,"SELLER");
// 			if(poss_cd_qty == cd_qty){
// 				complete_mark = "Y";
// 			}
			
// 			query +=  buyer         + "@@";
// 			query +=  po_no         + "@@";
// 			query +=  po_seq        + "@@";
// 			query +=  cd_qty        + "@@";
// 			query +=  invoice_date  + "@@";
// 			query +=  ds_date       + "@@";
// 			query +=  complete_mark + "@@";
// 			query +=  po_qty	 	+ "@@";
// 			query +=  inv_qty		;
// // 			query +=  process_type + "@@";
// // 			query +=  seller + "@@";
// 			query +=  "^||^" ;
			
// 		}
// 		document.forms["contentForm"].st_query.value  = query;
// 		kepAjaxFormCall("/mpiv/saveSellerMpIvTranStatementWriteAllPop.do","contentForm","btnSave");
// 	}
}
function invoiceCreateFunc(){
	closePopText1();
	var query = "";
	var invoice_date = $("#st_invoice_date_text").val().replace(/[/]/gi,"");
	
	for(var i=1; i<=mySheet.RowCount(); i++){ //CCK
		var complete_mark   = "N";
		var buyer = mySheet.GetCellValue(i,"BUYER");
		var po_no = mySheet.GetCellValue(i,"PO_NO");
		var po_seq = mySheet.GetCellValue(i,"PO_SEQ");
		var cd_qty = mySheet.GetCellValue(i,"CD_QTY");
		var po_qty = mySheet.GetCellValue(i,"PO_QTY");
		var poss_cd_qty = mySheet.GetCellValue(i,"INV_POSS_QTY");
		var inv_qty = mySheet.GetCellValue(i,"IV_QTY");
		var ds_date = mySheet.GetCellValue(i,"DS_DATE");
		var process_type = mySheet.GetCellValue(i,"PROCESS_TYPE");
		var seller = mySheet.GetCellValue(i,"SELLER");
		if(poss_cd_qty == cd_qty){
			complete_mark = "Y";
		}
		
		query +=  buyer         + "@@";
		query +=  po_no         + "@@";
		query +=  po_seq        + "@@";
		query +=  cd_qty        + "@@";
		query +=  invoice_date  + "@@";
		query +=  ds_date       + "@@";
		query +=  complete_mark + "@@";
		query +=  po_qty	 	+ "@@";
		query +=  inv_qty		;
//			query +=  process_type + "@@";
//			query +=  seller + "@@";
		query +=  "^||^" ;
		
	}
	document.forms["contentForm"].st_query.value  = query;
	kepAjaxFormCall("/mpiv/saveSellerMpIvTranStatementWriteAllPop.do","contentForm","btnSave");
}
function reloadFunc(){
	closePopText2();
	location.reload();
}
//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	
	if(pMethod == "btnSave"){
		
		var action_flag = response.action_flag;
		
		if(action_flag == "DO"){
// 			alert("해당건에 대해서 현재 작업중입니다.");
			var text = "해당건에 대해서 현재 작업중입니다.";
			var but1funcTmp = "javascript:reloadFunc();return false;";
			openLayerPopText2(text,but1text,but1funcTmp,but1width);
// 			location.reload();
			return;
		}
		$("#inv_no").val(response.inv_no);
		var text = "거래명세서가 일괄생성 되었습니다.</br>거래명세서 번호는 <span style='color:#2172EC'>"+response.inv_no+"</span> 입니다.";
		openLayerPopText2(text,but1text,but1funcSearch,but1width);
	} 
	
	return;
}

//ajax 공통 호출후 실패시 처리 함수
function kepAjaxError(pMethod , response){
	var msg = response.Message;
		
	if (!isEmpty(msg)){
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
	return;
}

function checkRemark(){
	
    if(kepGetByteLength("st_remark")>120){
//         alert("비고란에 입력한 내용이 입력가능한 크기를 초과하였습니다.\n\n※한글(2byte) 영문,숫자,특수문자(1byte)로 120byte를 초과할 수 없습니다.");
        var text = "비고란에 입력한 내용이 입력가능한 크기를 초과하였습니다.</br>※한글(2byte) 영문,숫자,특수문자(1byte)로 120byte를 초과할 수 없습니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
        document.forms["contentForm"].st_remark.focus();
        return ;
    }   
}
function sheetWin(inv_no) {
	var buyer			= "<%=p_buyer%>";
	var seller			= $("#st_seller").val();
	var legacy_po_no	= "<%=legacy_po_no%>";
	var pur_id			= "<%=pur_id%>";
	var tr_buyer = "<%=tr_buyer%>";
	var process_type = "<%=process_type%>"; 
	
	var legacy_iv_serial = "";
	
	var rpt_url 		= "<%=rpt_url%>";
	var param = "["+inv_no+"]["+seller+"]["+buyer+"]["+legacy_po_no+"]["+pur_id+"]";
	
    if(inv_no.length == 0 ){
//         alert("조회한 결과가 없습니다.");
        var text = "조회한 결과가 없습니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
        return;
    }else{
    	if(process_type == "2" && "<%=st_no_tag_check_yn%>" == "N"){
    		if($("#st_print_size").val() == "N"){
    			rpt_url = "RD_06_S_001_170";
    		}else if($("#st_print_size").val() == "L"){
    			rpt_url = "RD_06_S_001_171";
    		}
    		
    		param = "["+inv_no+"]["+seller+"]["+buyer+"][]";
    		
    		openBuyerTranStatReportOpen(buyer, rpt_url, param, legacy_iv_serial, tr_buyer, "", legacy_po_no);
    		
    		if("<%=st_no_itemTag_check_yn%>" == "Y"){
   				rpt_url = "<%=p070000034%>";
   				param = "["+inv_no+"]["+seller+"]["+buyer+"]";
   				
   				openBuyerTranStatReportOpen(buyer, rpt_url, param, legacy_iv_serial, tr_buyer, "", legacy_po_no);
   			}
    	}else{
    		openBuyerTranStatReportOpen(buyer, rpt_url, param, legacy_iv_serial, tr_buyer, "", legacy_po_no);
    	}
    }
}
function thisPopClose(){
	closePopText2();
	sheetWin($("#inv_no").val());
	
	parent.doAction('search');
	parent.closePop3();
}


</script> 

<body>
<form name = "contentForm" id="contentForm" method = "post">
<input type="hidden" name="s_SAVENAME" />
<!-- HIDDEN -->
<input type="hidden" name="st_query" id="st_query" value="">
<input type="hidden" name="st_parcel_yn"  id="st_parcel_yn" value="">
<input type="hidden" name="st_user_id"  id="st_user_id" value="<%=p_user_id%>">
<input type="hidden" name="st_kep_id"  id="st_kep_id" value="<%=p_kep_id%>">
<input type="hidden" name="st_inv_tax_rate"  id="st_inv_tax_rate" value="0.1">
<input type="hidden" name="st_process_type"  id="st_process_type" value="<%=process_type%>">
<input type="hidden" name="st_seller"  id="st_seller" value="">
<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
<input type="hidden" name="inv_no"  id="inv_no" value="">

<div class="wrapPopup">
  <div class="PopupTit">거래명세서 일괄생성 <span><a href="javascript:parent.closePop3();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="h15"></div>
  <div class="Importance_Popup" style="width:830px"><img src="/resources/imgs/Icon_Importance01.png" /> 여러 건의 발주건을  하나의 거래명세서로 통합하여 생성할 수 있습니다. 대상목록을 확인하시고 생성해주세요.</div>
  <div class="h15"></div>
  <table class="PopupTableTxt"  width="850px">
    <colgroup>
      <col width="130px" />
      <col width="270px" />
      <col width="130px" />
      <col width="270px" />  
   	</colgroup>
    <tr>      
      <th>납품일 <span class="F6495F">*</span></th>
      <td><div class="datepicker-wrap" style=" width:120px">
                  <div class="date-input" data-datepicker><input type="text" placeholder="" id="st_invoice_date_text" name="st_invoice_date_text" readonly /><span> </span></div>
                </div>
        </td>
      <th>배송유형 <span class="F6495F">*</span></th>
      <td><label class="RadioMediumLabel"><input type="radio" name="st_parcel_type" value="Y" disabled="disabled"><span class="RadioMediumTxt"></span> 택배</label>
      <label class="RadioMediumLabel"><input type="radio" name="st_parcel_type" value="N" checked disabled="disabled"><span class="RadioMediumTxt"></span>자차</label> </td>
    </tr>
    <%if(process_type.equals("2")){ %>
    <tr>
    	<th>라벨출력방식</th>
    	<td colspan="3">
    			<select style="width: 123px; height:32px; border:1px solid #dedede; border-radius:6px; font-size: 14px; font-family: Pretendard;" name="st_print_size" id ="st_print_size" >
            		<option value="N" selected>일반프린터(A4 4분할)</option>
            		<option value="L">라벨프린터(10x10cm)</option>
            	</select>
		</td>
    </tr> 
    <%} %>
    <tr style="display: none;">
      <th>메모</th>
      <td colspan="3"> <div class="TextField" id="limitedArea">
          <textarea name="st_remark" id="st_remark" maxlength="400" placeholder="" style=" width:94%"></textarea>
          <div class="meta" aria-live="polite"> <span id="count">0</span>/400 </div>
        </div>
        <script>
          (function () {
            const wrap = document.getElementById('limitedArea');
            const ta   = document.getElementById('st_remark');
            const cnt  = document.getElementById('count');
            const MAX  = parseInt(ta.getAttribute('maxlength'), 10);
            function update() {
              const len = ta.value.length;
              cnt.textContent = len;
            }
            // 초기 상태 반영 및 입력 시 업데이트
            update();
            ta.addEventListener('input', update);
          })();
        </script>            
      </td>      
    </tr>      
  </table>  
  <div class="IBSheetTablePopup" width="800px" style="display: none;">
  	<script type="text/javascript">
		createIBSheet("mySheet", "", "100%");
    </script>
  </div>  
  <div class="h30"></div>
  <div class="PopupListBtnBox_Center" style="width:850px">
    <button class="ButQuaternary_large" onclick="javascript:parent.closePop3();">취소</button>
    <button class="ButPrimary_large" onclick="javascript:invoiceCreate(); return false;">거래명세서 생성</button>
  </div> 
</div><!-- warp 끝-->
</form> 

</body>
</html>