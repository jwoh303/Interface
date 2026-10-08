<%--
**********************************************
* 메뉴 : 주문/배송조회
* 화면 : 주문/배송조회
* 기능 : 반품요청 등록
* 프로그램 ID : BU0402005
* 담당자 : 최찬규
* 착수일 : 2026-04-02
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
	String tab_id = (String) request.getParameter("tab_id");
    SessionInfo _sessionInfoPop = (SessionInfo)request.getSession().getAttribute("sessionInfo");
	String buyer = "";
	String userid = "";
	
	if (_sessionInfoPop != null){
		buyer =  CommonUtil.nvl((String)_sessionInfoPop.getComCode()); 	
		userid =  CommonUtil.nvl((String)_sessionInfoPop.getUserId());  		
	} 
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
	Map<String,String> _dataMap = null;
	String jsonData = "";
	if (_dataList != null || _dataList.size() != 0){
		_dataMap = _dataList.get(0);
		jsonData = new com.fasterxml.jackson.databind.ObjectMapper().writeValueAsString(_dataMap);
	}
%>
<!doctype html>
<html>
<head>
<%@ include file="../../include/head_v2.jspf"  %>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
</head>

<script>
//alert layer용
var but1text = "<%=CommonLang.get("HTITLE516")%>"; //확인
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1width = "120px";

var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;

var st;
var mt;
function popupOnload(){
	

	// 조회조건 초기화
	$("#st_b_req_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet.Cols = [
			 { Align:"Center",	SaveName:"sStatus",				Header:"<%=CommonLang.get("HTITLE255")%>",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}/*상태*/
			 ,{ Align:"Left",	SaveName:"REF_PR_NO",				Header:"<%=CommonLang.get("HTITLE18")%>",				Type:"Text",		Width:100,	Edit:false,	EditLen:100,	Hidden:false} /*관리번호*/
			 ,{ Align:"Left",	SaveName:"BUYER_ITEM_NO",				Header:"<%=CommonLang.get("HTITLE12")%>",				Type:"Text",		Width:90,	Edit:false,	EditLen:100,	Hidden:false} /*품목코드*/
			 ,{ Align:"Left",	SaveName:"DESCRIPTION",				Header:"<%=CommonLang.get("HTITLE13")%>",				Type:"Text",		Width:135,	Edit:false,	EditLen:100,	Hidden:false} /*품목명*/
			 ,{ Align:"Left",	SaveName:"SPECIFICATION",				Header:"<%=CommonLang.get("HTITLE14")%>",				Type:"Text",		Width:160,	Edit:false,	EditLen:100,	Hidden:false} /*규격*/
			 ,{ Align:"Right",	SaveName:"UNIT_PRICE",				Header:"<%=CommonLang.get("HTITLE174")%>",				Type:"Float",		Width:80,	Edit:false,	EditLen:100,	Hidden:false, Format:"${priceFormat}"}/*단가*/
			 ,{ Align:"Right",	SaveName:"ITEM_QTY",				Header:"<%=CommonLang.get("HTITLE45")%>",				Type:"Float",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}/*수량*/
			 ,{ Align:"Right",	SaveName:"WMRE_QTY",				Header:"<%=CommonLang.get("HTITLE1210")%>",				Type:"Float",		Width:90,	Edit:true,	EditLen:100,	Hidden:false,BackColor:"${optColor}"}/*교환/반품수량*/
	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	mySheet.SetHighlightAfterSort(2);
	
	mySheet.SetHeaderBackColor("#f2f7ff");
	mySheet.SetTheme("DB", "DeepBlue");
	
	var dataList = <%=jsonData%>;
	
	mySheet.RenderSheet(0);
		// 대상품목 그려주기
		var newIndex = 0;
		newIndex = mySheet.DataInsert(-1);
		mySheet.SetCellValue(newIndex, "REF_PR_NO", dataList.REF_PR_NO);
		mySheet.SetCellValue(newIndex, "BUYER_ITEM_NO", dataList.BUYER_ITEM_NO);
		mySheet.SetCellValue(newIndex, "DESCRIPTION", dataList.DESCRIPTION);
		mySheet.SetCellValue(newIndex, "SPECIFICATION", dataList.SPECIFICATION);
		mySheet.SetCellValue(newIndex, "UNIT_PRICE", dataList.UNIT_PRICE);
		mySheet.SetCellValue(newIndex, "ITEM_QTY", dataList.ITEM_QTY);
		mySheet.SetCellValue(newIndex, "WMRE_QTY", 0);
	mySheet.RenderSheet(1);
}

function mySheet_OnChange(Row, Col, Value,oldValue, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	if(column == "WMRE_QTY"){
		var item_qty = $("#st_item_qty").val();
		if(mySheet.GetCellValue(Row,"WMRE_QTY") > item_qty){
			//반품/교환 수량이 발주수량 보다 클 수 없습니다.
			var text = "<%=CommonLang.msg("MSG480") %>";
			openLayerPopText2(text,but1text,but1func,but1width);
			mySheet.SetCellValue(Row,"WMRE_QTY",0);
			return;
		}
		
		$("#st_wmre_qty").val(mySheet.GetCellValue(Row,"WMRE_QTY"));
	}
	return;
}
//기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "save":
			if($('#st_wmre_qty').val() == ""){
				//요청수량을  입력하세요
				var text = "<%=CommonLang.msg("MSG485") %>";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
			if($("#st_b_req_remark").val() == ""){
				//취소 사유를 입력하세요.
				var text = "<%=CommonLang.msg("MSG955") %>";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
			
			if(document.searchCondition.st_wmre_type.value == ""){
				//요청 구분을 선택 하세요
				var text = "<%=CommonLang.msg("MSG475") %>";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
	
			//반품/교환 요청 등록을 하시겠습니까?
			var text = "<%=CommonLang.msg("MSG486")%>";
			var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
			var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
			var but1funcC = "javascript:saveMasterWmReReturnEntryForBuyerCancelPop(); return false;";
			var but2funcC = "javascript:closePopText1(); return false;";
			var but1widthC = "100px";
			var but2widthC = "100px";
			openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
			
			break;
	}

}

function saveMasterWmReReturnEntryForBuyerCancelPop(){
	closePopText1();
	kepAjaxFormCall("/wmre/saveMasterWmReReturnEntryForBuyerCancelPop.do","searchCondition","save"); 
}
/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	
	if (pMethod == "save"){ 
		//실패 하였습니다. 다시 시도 하여 주십시오
		 var text = "<%=CommonLang.msg("MSG624")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
	}
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){

	var result = response.msg.MSG;  
	
	if(result=="Ok"){
		//정상적으로 저장 되었습니다.
		var text = "<%=CommonLang.msg("MSG478")%>";
		openLayerPopText2(text,but1text,but1funcSearch,but1width);
		
	}else{
		var text = result;
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
}

function thisPopClose(){
	closePopText2();
	
	var tab_id = "<%=tab_id%>";
	
	opener.tabs[tab_id]["search"]();
	self.close();
}
//팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {

	}
}

function  attach_popup(){	
   popupSel = "attach_popup";
	var type = "WR";
	var viewType = "C";
	var img_key = $("#st_wmre_file").val(); 	
	
	var src = '/common/fileUploadPop_v2.do?DOC_NO='+img_key+'&viewType='+viewType+'&TYPE='+type;
	openLayerPop(src,"600px","510px");
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if(popupSel=="attach_popup"){
	   	$("#st_wmre_file").val(value1);
	   	if(value2 >0){
	   		$("#st_file_upload_but").attr("class","ButQuaternary_Small");
		   	$("#st_file_upload_cnt").html(value2);
	   	}else{
	   		$("#st_file_upload_but").attr("class","ButOutline_Small");
		   	$("#st_file_upload_cnt").html("");
	   	}
	}
	
	
	grbRow="";	//초기화
}

</script>
<body onload="popupOnload(); ">
<form name = "searchCondition"  id = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
	<input type="hidden" id="st_user_id"  name="st_user_id" value="${sessionInfo.userId}">
	<input type="hidden" id="st_com_code"  name="st_com_code" value="${sessionInfo.comCode}">
	<input type="hidden" id="st_cancel_flag"  name="st_cancel_flag" value="N">	
    <input type="hidden" id="st_process_type"  name="st_process_type" value="<%=CommonUtil.nvl(_dataMap.get("PROCESS_TYPE"),"") %>">	
    <input type="hidden" id="st_WAREHOUSE_CODE"  name="st_WAREHOUSE_CODE" value="<%=CommonUtil.nvl(_dataMap.get("WAREHOUSE_CODE"),"") %>">	    
	 <input type="hidden" id="st_buyer_code"  name="st_buyer_code" value="<%=CommonUtil.nvl((String) request.getParameter("st_buyer_code"),"") %>" >
	<input type="hidden" class="al" name="st_b_req_date" id="st_b_req_date" readOnly  style="width:70%;height:20px" />
	<input type="hidden" name="st_buyer_person_tel" id="st_buyer_person_tel"   value="${sessionInfo.tel}"  class="al" title="" style="width:90%;" onkeyup="fnCheckInputByte(this, 20);"/>
	<input type="hidden" name="st_b_req_user_id" id="st_b_req_user_id"   value="${sessionInfo.userId}"  class="input_type_text" title="" style="width:90%;" />
	<input type="hidden" name="st_buyer_person_name"  id="st_buyer_person_name"  class="al" title=""   value="${sessionInfo.userNameLoc}"  style="width:90%;" onkeyup="fnCheckInputByte(this, 20);"/>
	<input type="hidden" name="st_buyer_dept_name" id="st_buyer_dept_name" class="input_type_text" title=""   value="${sessionInfo.departmentName}"  style="width:60%;" readonly onclick="javascript:doPop('get_dept');"/>
	<input type="hidden" name="st_buyer_dept_code" id="st_buyer_dept_code"  value="${sessionInfo.department}"   style="width:80%" value="">
	
	<input type="hidden" name="st_po_no" id="st_po_no" class="input_type_text" title=""   value="<%=CommonUtil.nvl(_dataMap.get("PO_NO"),"") %>"    style="width:60%;background:#EAEAEA;" " readonly />
	<input type="hidden" name="st_po_seq" id="st_po_seq" class="input_type_text" title=""  value="<%=CommonUtil.nvl(_dataMap.get("PO_SEQ"),"") %>"     style="width:20%;background:#EAEAEA;" readonly />
	<input type="hidden" name="st_buyer_item_no" id="st_buyer_item_no" class="input_type_text" title=""  value="<%=CommonUtil.nvl(_dataMap.get("BUYER_ITEM_NO"),"") %>"   style="width:90%;background:#EAEAEA;" readonly />
	<input type="hidden" name="st_description" id="st_description" class="input_type_text" title="" value="<%=CommonUtil.nvl(_dataMap.get("DESCRIPTION"),"") %>"     style="width:90%;background:#EAEAEA;"readonly />
	<input type="hidden" name="st_specification" id="st_specification" class="input_type_text" title=""  value="<%=CommonUtil.nvl(_dataMap.get("SPECIFICATION"),"") %>"   style="width:90%;background:#EAEAEA;"readonly />	
	<input type="hidden" name="st_item_qty" id="st_item_qty" class="ar" title=""  value="<%=CommonUtil.nvl(_dataMap.get("ITEM_QTY"),"") %>"    style="width:90%;background:#EAEAEA;" readonly />
	<input type="hidden" name="st_unit_measure" id="st_unit_measure" class="input_type_text" title=""  value="<%=CommonUtil.nvl(_dataMap.get("UNIT_MEASURE"),"") %>"   style="width:90%;background:#EAEAEA;" readonly/>
	<input type="hidden" name="st_seller_name" id="st_seller_name" class="input_type_text" title=""  value="<%=CommonUtil.nvl(_dataMap.get("AGENT_NAME"),"") %>"   style="width:90%;background:#EAEAEA;"readonly />
	<input type="hidden" name="st_seller" id="st_seller" class="input_type_text" title=""   value="<%=CommonUtil.nvl(_dataMap.get("AGENT"),"") %>"  style="width:90%;background:#EAEAEA;"readonly />
	<input type="hidden" name="st_wmre_qty" id="st_wmre_qty"  value=""   style="width:80%" value="">
	
	<div class="wrapPopup">
  <div class="PopupTit"><%=CommonLang.get("HTITLE1211")%><!--교환/반품신청--><span><a href="javascript:self.close();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <table class="PopTableThLTdL" width="100%">
    <colgroup>
      <col width="20%" />
      <col width="30%" />
      <col width="20%" />
      <col width="30%" />
<!--       <col width="10%" /> -->
<!--       <col width="40%" /> -->
  	</colgroup>
    <tr>
      <th><%=CommonLang.get("HTITLE1179") %><!-- 주문요청번호 --></th>
      <td><%=CommonUtil.nvl(_dataMap.get("PR_NO"),"") %></td>
      <th><%=CommonLang.get("HTITLE203") %><!-- 발주번호 --></th>
      <td><%=CommonUtil.nvl(_dataMap.get("PO_NO"),"") %></td>
    </tr>
    <tr>
      <th><%=CommonLang.get("HTITLE1213")%><!--신청구분--></th>
      <td><label class="RadioLargeLabel"><input type="radio" name="st_wmre_type" value="02"><span class="RadioLargeTxt"></span>교환</label> <label class="RadioLargeLabel"><input type="radio" name="st_wmre_type" value="01"><span class="RadioLargeTxt"></span>반품</label></td>
  	  <th><%=CommonLang.get("HTITLE166") %><!-- 첨부 --></th>
  	  <input type="hidden" name="st_wmre_file" id="st_wmre_file" class="al" title="" style="width:20%;"   value=""/>
  	  <td>
  	  <button class="ButOutline_Small" style="width:150px;" onclick="javascript:attach_popup(); return false;" id="st_file_upload_but"><%=CommonLang.get("HTITLE177") %><!-- 파일첨부 --> <span id="st_file_upload_cnt"></span></button>
<%--   	  <button class="ButOutlineBlue_Small" style="vertical-align:middle;" onclick="javascript:attach_popup();return false;"><%=CommonLang.get("HTITLE177")%><!-- 파일첨부 --></button> --%>
  	  </td>
  	</tr>
  </table> 
  <div class="PopupTitSub" ><%=CommonLang.get("HTITLE1104") %><!-- 품목정보 --></div>  
  <div class="ScrollBox " style="height:83px">
  	    <script type="text/javascript">
          	createIBSheet("mySheet", "", "100%");
        </script>
  </div>  
  <div class="PopupTitSub" ><span class="F6495F" style="padding-left: 0px;">*</span><%=CommonLang.get("HTITLE148") %><!-- 취소사유 --></div> 
  <div class="TextField" id="limitedArea">
    <textarea id="st_b_req_remark" name="st_b_req_remark" maxlength="200" style="width:97%" placeholder=""></textarea>
    <div class="meta" aria-live="polite"> <span id="count">0</span>/200 </div>
  </div>
  <script>
    (function () {
    const wrap = document.getElementById('limitedArea');
    const ta   = document.getElementById('st_b_req_remark');
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
  <div class="PopupListBtnBox_Center mt20" >
    <button class="ButQuaternary_large" onclick="javascript:self.close(); return false;"><%=CommonLang.get("HTITLE229") %><!-- 취소 --></button>
    <button class="ButPrimary_large"  onclick="javascript:doAction('save'); return false;"><%=CommonLang.get("HTITLE1214")%><!--신청하기--></button>
	 
  </div>  
</div><!-- warp 끝-->
</form> 
</body>
</html>
