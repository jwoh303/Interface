<%--
**********************************************
* 메뉴 : 
* 화면 : 거래명세서생성
* 기능 : 거래명세서를 생성하기 위한 팝업 - 품목별
* 프로그램 ID : SU0503004
* 담당자 : 최찬규
* 착수일 : 2026-09-22
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
<%
	String user_id = _sessionInfo.getUserId();
	String agent = _sessionInfo.getComCode();
	
	String info = CommonUtil.nvl((String)request.getParameter("layerPopInfo"), ""); //이전 페이지에서 넘겨온 대상 품목 데이터들
	if(info == null) info = "[]"; //null 방지
	
	String trCheck = CommonUtil.nvl((String)request.getParameter("trCheck"), ""); //
	String p_user_id = CommonUtil.nvl((String)request.getParameter("p_user_id_item"), ""); //
	String p_kep_id = CommonUtil.nvl((String)request.getParameter("p_kep_id_item"), ""); //
	
	
	
	
%>
<script type="text/javascript">
window.calendarPositionOffset = {
		top:-150,
		left:-100
	};
	
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";
var g_inv_param = "";
var group_no_arr = []; 

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
			,{ Align:"Right",	SaveName:"PO_QTY",				Header:"PO_QTY",			Type:"Float",			Width:60,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Right",	SaveName:"GROUP_NO",			Header:"GROUP_NO",			Type:"Int",			Width:60,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"PROCESS_TYPE",		Header:"PROCESS_TYPE",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}
			,{ Align:"Left",	SaveName:"SIZE_YN",				Header:"SIZE_YN",			Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Left",	SaveName:"SIZE_LEN",			Header:"SIZE_LEN",			Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Left",	SaveName:"SIZE_QTY",			Header:"SIZE_QTY",			Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"P060000080",			Header:"P060000080",			Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:false}
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
		mySheet.SetCellValue(newIndex, "PROCESS_TYPE", infoList[i].PROCESS_TYPE);
		mySheet.SetCellValue(newIndex, "SIZE_YN", infoList[i].SIZE_YN);
		mySheet.SetCellValue(newIndex, "SIZE_LEN", infoList[i].SIZE_LEN);
		mySheet.SetCellValue(newIndex, "SIZE_QTY", infoList[i].SIZE_QTY);
		mySheet.SetCellValue(newIndex, "P060000080", infoList[i].P060000080);
		mySheet.SetCellValue(newIndex, "GROUP_NO", infoList[i].GROUP_NO);
		mySheet.SetCellValue(newIndex, "SELLER", infoList[i].SELLER);
		mySheet.SetCellValue(newIndex, "PO_QTY", infoList[i].PO_QTY);
		
		if(group_no_arr.indexOf(infoList[i].GROUP_NO) < 0){
			group_no_arr.push(infoList[i].GROUP_NO);
		}
	}
	mySheet.RenderSheet(1);
	
	$("#st_group_no_arr").val(group_no_arr.toString()); //거래명세서 만들 group_no-> 서버에서 쪼개서 해당 group_no 별로 IV생성할 예정
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
// 			var src = "/mpiv/getCommonMpIvDlvryNoticePop.do?st_type="+value1;
// 			openLayerPop2(src,"620px","530px");
			
			openSearchPopup("/mpiv/getCommonMpIvDlvryNoticePop.do", "?st_type="+value1, value2);
			break;
	}
}

// TR 협력사 배송 변경 팝업
function setDlvryNotice2(value1){
	document.forms["contentForm"].st_query.value = g_inv_param;
	
	kepAjaxFormCall("/mpiv/saveSellerMpIvTranStatementWriteItemPop_v3.do","contentForm","btnSave");
}

/**
	거래명세서 작성
	1. 직납건 확인.
	2. 구매사 차량등록유무 확인.
	3. 공급사 차량 리스트 확인.
	4. 차량코드 확인.
	5.거래명세서 생성
**/
function invoiceCreate(){ //cck
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
// 			var buyer = mySheet.GetCellValue(i,"BUYER");
// 			var po_no = mySheet.GetCellValue(i,"PO_NO");
// 			var po_seq = mySheet.GetCellValue(i,"PO_SEQ");
// 			var cd_qty = mySheet.GetCellValue(i,"CD_QTY");
// 			var ds_date = mySheet.GetCellValue(i,"DS_DATE");
// 			var process_type = mySheet.GetCellValue(i,"PROCESS_TYPE");
// 			var seller = mySheet.GetCellValue(i,"SELLER");
// 			var complete_mark = "Y";
		
// 			query +=  buyer         + "@@";
// 			query +=  po_no         + "@@";
// 			query +=  po_seq        + "@@";
// 			query +=  cd_qty        + "@@";
// 			query +=  invoice_date  + "@@";
// 			query +=  ds_date       + "@@";
// 			query +=  complete_mark + "@@";
// 			query +=  process_type + "@@";
// 			query +=  seller + "@@";
// 			query += mySheet.GetCellValue(i,"GROUP_NO");
			
// 			var p060000080 = mySheet.GetCellValue(i,"P060000080");
			
// 			if(p060000080 == "TYPE1"){
// 				var size_yn = mySheet.GetCellValue(i,"SIZE_YN");
// 				var size_len = mySheet.GetCellValue(i,"SIZE_LEN");
// 				var size_qty = mySheet.GetCellValue(i,"SIZE_QTY");
				
// 				if(size_yn == "Y"){
// 					query += "@@";
// 					query += size_yn + "@@";
// 					query += size_len + "@@";
// 					query += size_qty;
// 				}
// 			}
// 			query +=  "^||^" ;
// 		}
		
<%-- 		if('<%=trCheck%>' == "Y"){ --%>
// 			g_inv_param = query;
// 			doPop('commonMpIvDlvryNoticePop', "TYPE90", "620,530,no");
// 		}else{
// 			document.forms["contentForm"].st_query.value  = query;
// 			kepAjaxFormCall("/mpiv/saveSellerMpIvTranStatementWriteItemPop.do","contentForm","btnSave");
// 		}
		
		
// 	}
}

function invoiceCreateFunc(){
	closePopText1();
	var query = "";
	var invoice_date = $("#st_invoice_date_text").val().replace(/[/]/gi,"");
	
	for(var i=1; i<=mySheet.RowCount(); i++){ //CCK
		var buyer = mySheet.GetCellValue(i,"BUYER");
		var po_no = mySheet.GetCellValue(i,"PO_NO");
		var po_seq = mySheet.GetCellValue(i,"PO_SEQ");
		var cd_qty = mySheet.GetCellValue(i,"CD_QTY");
		var ds_date = mySheet.GetCellValue(i,"DS_DATE");
		var process_type = mySheet.GetCellValue(i,"PROCESS_TYPE");
		var seller = mySheet.GetCellValue(i,"SELLER");
		var po_qty = mySheet.GetCellValue(i,"PO_QTY");
		var complete_mark = "Y";
	
		query +=  buyer         + "@@";
		query +=  po_no         + "@@";
		query +=  po_seq        + "@@";
		query +=  po_qty		+ "@@";
		query +=  cd_qty        + "@@";
		query +=  invoice_date  + "@@";
		query +=  ds_date       + "@@";
		query +=  complete_mark + "@@";
		query +=  process_type + "@@";
		query +=  seller + "@@";
		query += mySheet.GetCellValue(i,"GROUP_NO");
		
		var p060000080 = mySheet.GetCellValue(i,"P060000080");
		
		if(p060000080 == "TYPE1"){
			var size_yn = mySheet.GetCellValue(i,"SIZE_YN");
			var size_len = mySheet.GetCellValue(i,"SIZE_LEN");
			var size_qty = mySheet.GetCellValue(i,"SIZE_QTY");
			
			if(size_yn == "Y"){
				query += "@@";
				query += size_yn + "@@";
				query += size_len + "@@";
				query += size_qty;
			}
		}
		query +=  "^||^" ;
	}
	
	if('<%=trCheck%>' == "Y"){
		g_inv_param = query;
		doPop('commonMpIvDlvryNoticePop', "TYPE90", "620,530,no");
	}else{
		document.forms["contentForm"].st_query.value  = query;
		kepAjaxFormCall("/mpiv/saveSellerMpIvTranStatementWriteItemPop_v3.do","contentForm","btnSave");
	}
}
//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	
	if(pMethod == "btnSave"){
		var text = "총 <span style='color:#2172EC'>"+response.inv_cnt+"</span>건의 거래명세서가 생성되었습니다.</br>생성된 거래명세서는 <span class='F6495F'>거래명세서출력 탭</span>에서 출력하실 수 있습니다.";
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
function thisPopClose(){
	closePopText2();
	parent.doAction('search');
	parent.closePop3();
}


</script> 

<body>
<form name = "contentForm" id="contentForm" method = "post">
<input type="hidden" name="s_SAVENAME" />
<!-- HIDDEN -->
<input type="hidden" name="st_query" id="st_query" value="">
<input type="hidden" name="st_group_no_arr"  id="st_group_no_arr" value="">
<input type="hidden" name="st_parcel_yn"  id="st_parcel_yn" value="">
<input type="hidden" name="st_user_id"  id="st_user_id" value="<%=p_user_id%>">
<input type="hidden" name="st_kep_id"  id="st_kep_id" value="<%=p_kep_id%>">
<input type="hidden" name="st_inv_tax_rate"  id="st_inv_tax_rate" value="0.1">

<div class="wrapPopup">
  <div class="PopupTit">거래명세서 생성 <span><a href="javascript:parent.closePop3();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="h15"></div>
  <div class="Importance_Popup" style="width:830px"><img src="/resources/imgs/Icon_Importance01.png" /> 선택한 발주 건별 거래명세서를 한번에 생성합니다. 목록과 입력 정보를 확인 후 [거래명세서 생성]을 해주세요</div>
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
      <td><label class="RadioMediumLabel"><input type="radio" name="st_parcel_type" value="Y"><span class="RadioMediumTxt"></span> 택배</label>
      <label class="RadioMediumLabel"><input type="radio" name="st_parcel_type" value="N"><span class="RadioMediumTxt"></span>자차</label> </td>
    </tr> 
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