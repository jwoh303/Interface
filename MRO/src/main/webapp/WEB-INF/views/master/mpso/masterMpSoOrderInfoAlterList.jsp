<%--
**********************************************
* 메뉴 : 주문관리>주문 정보수정
* 화면 : 주문 정보수정
* 기능 : 주문목록을 조회한다.
* 프로그램 ID : PG_06_M_006_00
* 담당자 : 손상민 CEJ ( 설계 : 김지현 )
* 착수일 : 2014-07-15
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %> 
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
					,{ Align:"Center",	Width:60,	Edit : true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"발주번호",	SaveName:"PO_NO"}     //[01]
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"관리번호",	SaveName:"REF_PR_NO"}     //[11]
					,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사",	SaveName:"AGENT_NAME"}     //[02]
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목코드",	SaveName:"BUYER_ITEM_NO"}     //[12]
					,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"품목명",	SaveName:"DESCRIPTION"}     //[22]
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"발주일",	SaveName:"PO_CREATE_DATE"}     //[03]
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"납품일",	SaveName:"INVOICE_DATE"}     //[13]
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"납기요청일",	SaveName:"RD_DATE"}     //[04]
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"납품예정일",	SaveName:"DS_DATE"}     //[34]
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"표준납기일",	SaveName:"ST_DATE"}     //[14]
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"입고일",	SaveName:"GR_DATE"}     //[05]
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"확정일",	SaveName:"DELIVERY_DATE"}     //[15]
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	 Format:"${priceFormat}",	Header:"발주수량",	SaveName:"ITEM_QTY"}     //[06]
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	 Format:"${priceFormat}",	Header:"납품수량",	SaveName:"INV_QTY"}     //[16]
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	 Format:"${priceFormat}",	Header:"입고수량",	SaveName:"GR_QTY"}     //[07]
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	 Format:"${priceFormat}",	Header:"확정수량",	SaveName:"DELIVERY_QTY"}     //[17]
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Header:"매출단가",	SaveName:"UNIT_PRICE", Format:"${priceFormat}"}     //[08]
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",	Header:"매입단가",	SaveName:"AGENT_PRICE", Format:"${priceFormat}"}     //[18]
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"I/F발주번호",	SaveName:"LEGACY_PO_NO"}     //[19]
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"발주부서",	SaveName:"PO_DEPT_NAME"}     //[20]
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"발주순번",	SaveName:"PO_SEQ"}     //[09]
					,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"제조사",	SaveName:"MAKER_NAME"}     //[10]
					,{ Align:"Center",	Width:130,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"요청부서",	SaveName:"REQ_DEPT_NAME"}     //[25]
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"상태",	SaveName:"STATUS_TEXT"}     //[21]
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"규격",	SaveName:"SPECIFICATION"}     //[23]
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"I/F발주순번",	SaveName:"LEGACY_PO_SEQ"}     //[24]
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"고객사",	SaveName:"BUYER"}     //[26]
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"협력사ID",	SaveName:"AGENT_CODE"}     //[27]
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"발주부서코드",	SaveName:"PO_DEPT_CODE"}     //[28]
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"요청부서코드",	SaveName:"REQ_DEPT_CODE"}     //[29]
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"요청공장",	SaveName:"BYIT_COMORG_CODE"} //[30]
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"계약번호",	SaveName:"CONTRACT_NO"}     //[31]
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"계약순번",	SaveName:"CONTRACT_SEQ"}     //[32]
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"요청DS_FLAG명",	SaveName:"DS_FLAG"}	//[33]
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목구분",	SaveName:"ITEM_MAKE_TYPE"}     //[35]
	];

	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:7};
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//비고이미지설정
	mySheet.SetImageList(1, remarkOn);
	mySheet.SetImageList(0, remarkOff);

	//하이퍼링크 설정
	setLinkCol(mySheet, "PO_NO");	//발주번호
	setLinkCol(mySheet, "AGENT_NAME");	//협력사
	setLinkCol(mySheet, "BUYER_ITEM_NO");	//품목코드
	
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
}
	
	
var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
		var arrRow     = selectedGrid.split("|");

	// 선택된 항목 유무 체크
	if (str !="search" && str !="search1"&& str !="excelDown" && str !="reload" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
	case "search":	 // 조회
		if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
	
		$("#re_current_page").val(1);
			current_page = -1;
			if($("#st_buyer_code").val() == "") {
				alert("고객사를 선택해 주십시요.");
				return;
			}
			
			var buyer_item_no   = $("#st_buyer_item_no").val();//f.st_buyer_item_no.value;
			var if_po_no        = $("#st_if_po_no").val();//f.st_if_po_no.value;
			var po_no           = $("#st_po_no").val();
			var ref_no			= $("#st_ref_no").val();
		   
			var checkAll = 'N';
			
		    if(document.getElementById("st_checkbox").checked == true){
				if( buyer_item_no =="" &&  if_po_no =="" && po_no =="" && ref_no == ""){
					alert("기간을 무시하고 조회시\n\n고객사 선택후\n\n품목코드, I/F발주번호, 발주번호, 관리번호 중\n\n한가지 이상을 정확히(전체입력) 기입해야 합니다.");	
					return;
				}
				checkAll ="Y";
				$("#st_all_po").val('Y');
			}else{
				checkAll = 'N';
				$("#st_all_po").val('N');
				var diff = kepGetDateDiff('st_from_date','st_to_date','D');
				if (eval(diff)>31){
					alert("한달이내 조회만 가능합니다.");
					return;
				}
	}
			
		pagingMode = "N";
		kepSearch(document.searchCondition,  mySheet , "/mpso/getMasterMpSoOrderInfoAlterList.do" , pagingMode );
		break;
		
		case "search1":	 // 조회 
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
		
			if($("#st_buyer_code").val() == "") {
				alert("고객사를 선택해 주십시요.");
				return;
			}
			
			var buyer_item_no   = $("#st_buyer_item_no").val();//f.st_buyer_item_no.value;
			var if_po_no        = $("#st_if_po_no").val();//f.st_if_po_no.value;
			var po_no           = $("#st_po_no").val();
			var ref_no			= $("#st_ref_no").val();
		   
			var checkAll = 'N';
			
		    if(document.getElementById("st_checkbox").checked == true){
				if( buyer_item_no =="" &&  if_po_no =="" && po_no =="" && ref_no == ""){
					alert("기간을 무시하고 조회시\n\n고객사 선택후\n\n품목코드, I/F발주번호, 발주번호, 관리번호 중\n\n한가지 이상을 정확히(전체입력) 기입해야 합니다.");	
					return;
				}
				checkAll ="Y";
				$("#st_all_po").val('Y');
			}else{
				checkAll = 'N';
				$("#st_all_po").val('N');
				var diff = kepGetDateDiff('st_from_date','st_to_date','D');
				if (eval(diff)>31){
					alert("한달이내 조회만 가능합니다.");
					return;
					}
			}		
			
			//조회
		    pagingMode = "P";
			current_page = $("#re_current_page").val();
			kepSearch(document.searchCondition ,  mySheet , "/mpso/getMasterMpSoOrderInfoAlterList.do?page="+current_page , pagingMode );
		break;

	
	case "reload":	// 초기화
		$("#re_current_page").val(1);
		$( '#searchCondition' )[0].reset();

		$("#st_from_date").val( kepToMonthAdd("1","M"));
		$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
// 		current_page = -1;
// 		kepSearch(document.searchCondition ,  mySheet , "/mpso/getMasterMpSoOrderInfoAlterList.do?page="+current_page , pagingMode );
		mySheet.RemoveAll();
		$("#st_buyer_code").val("");
		$("#st_agent_code").val("");
		document.getElementById("st_checkbox").checked = false;
		
		break;

	case "excelDown": // 엑셀다운로드
	    $("#pageflag").val('0');
		var param = {FileName:"주문 정보수정.xlsx",DownCols:"PO_NO|AGENT_NAME|PO_CREATE_DATE|RD_DATE|GR_DATE|ITEM_QTY|GR_QTY|UNIT_PRICE|PO_SEQ|MAKER_NAME|REF_PR_NO|BUYER_ITEM_NO|INVOICE_DATE|DS_DATE|DELIVERY_DATE|INV_QTY|DELIVERY_QTY|AGENT_PRICE|LEGACY_PO_NO|PO_DEPT_NAME|STATUS_TEXT|DESCRIPTION|SPECIFICATION|LEGACY_PO_SEQ|REQ_DEPT_NAME"};
		kepDownExcel(document.searchCondition ,mySheet , "/mpso/excelMasterMpSoOrderInfoAlterList.do", param);
		$("#pageflag").val('1');
		break;
	}
}
	
// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}
	
// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

   	
   	
	if (msg != "") {
		alert(msg);
	}
	
	var totRow = mySheet.RowCount();
	for(var i=1; i<=totRow;i++){
		var STATUS_TEXT = mySheet.GetCellValue(i, 'STATUS_TEXT'); 
		
		if(STATUS_TEXT == "발주") { 
			mySheet.SetCellFontColor(i,"PO_NO","red");
		} 
	}
 
	if(current_page==-1){
		$("#re_current_page").val(1);
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		$("#re_current_page").val(current_page);
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	
}

function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
// 	alert(downloadType + ' 다운이 완료되었습니다. \n 다운로드 결과 : ' + ((result==true)?'성공':'실패'));
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
    pagingMode = "P";
	current_page = param.page;
	$("#re_current_page").val(current_page);
	kepSearch(document.searchCondition ,  mySheet , "/mpso/getMasterMpSoOrderInfoAlterList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "buyer_single": // 고객사 M
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
			break;
		case "seller": // 협력사
			openSearchPopup('/common/icomcmpyPop.do','?BUSINESS_COND=S&MULTI=N', "500,466,no");
			break;
		case "manual": // 매뉴얼 호출
			openSearchPopup("https://gw.koreab2b.com/servlet/HIServlet", "?SLET=bbs.BBSMtrlRead.java&MENUBAR=ON&MET=LIST&BMID=0000007zr&BRDID=0000008i3&LM=nm&NL=1&LMET=CLOSE", "800,600, yes");
			break;
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	var ORDERFLAG = "after";
	var STATUS_TEXT = mySheet.GetCellValue(Row, 'STATUS_TEXT'); 	
	if(STATUS_TEXT == "발주") { 
		ORDERFLAG = "before";		
	}
	
	if (column == 'PO_NO') { // 발주번호
		var BUYER = mySheet.GetCellValue(Row,"BUYER");
		var PO_NO = mySheet.GetCellValue(Row,"PO_NO");
		openSearchPopup('/mpso/getMasterMpSoOrderInfoAlterBeforeMainPop.do','?st_buyer='+BUYER+'&st_po_no='+PO_NO+'&st_orderFlag='+ORDERFLAG , "1300,625,no");

	} else if (column == 'AGENT_NAME') { // 협력사
		var agent = mySheet.GetCellValue(Row,"AGENT_CODE");
		getAgentDisplayPop(agent);

	} else if (column == 'BUYER_ITEM_NO') { // 품목코드
		var buyer = mySheet.GetCellValue(Row, "BYIT_COMORG_CODE");
		var buyerItemNo = mySheet.GetCellValue(Row,"BUYER_ITEM_NO");
		var contractNo = mySheet.GetCellValue(Row,"CONTRACT_NO");
		var contractSeq = mySheet.GetCellValue(Row,"CONTRACT_SEQ");
		getBuyerCatalogDisplayPop(buyer,buyerItemNo,contractNo,contractSeq);

	}
	return;
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyer_single") {	// 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
	}else if(popupSel == "seller") {	// 협력사
		$("#st_agent_code").val(value1);
		$("#st_agent_name").val(value2);
		
	}else if(popupSel == "remarkBAS") {	//고객사 비고
		mySheet.SetCellValue(grbRow, 'ATOB_REMARK', value1);
		mySheet.SetCellValue(grbRow, 'ATOB_REMARK_IMG', (value1!="")? remarkOn : remarkOff);
	
	}else if(popupSel == "remarkAtoS2") {	//고객사 비고
		mySheet.SetCellValue(grbRow, 'ATOS_REMARK', value1);
		mySheet.SetCellValue(grbRow, 'ATOS_REMARK_IMG', (value1!="")? remarkOn : remarkOff);
			
	}else if(popupSel == "cancelRemark") {	//견적 취소
		mySheet.SetCellValue(grbRow, 'REJECT_REMARK', value1);
		mySheet.SetCellValue(grbRow, 'REJECT_REMARK_IMG', (value1!="")? remarkOn : remarkOff);
			
	}
	grbRow="";	//초기화
}

	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>주문 정보수정</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
		    <span><a href="javascript:doPop('manual')"><img src="/resources/images/question_mark.gif"></a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition" id="searchCondition" method = "post" onsubmit="return false" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<input type="hidden" name="st_all_po"  id="st_all_po" value ="N">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="re_current_page" name="re_current_page"  value="">

		  <table  class="cont_t_list01">
		    <caption></caption>
		    <colgroup>
		    <col width="8%" />
		    <col width="25%" />
		    <col width="8%" />
		    <col width="25%" />
		    <col width="8%" />
		    <col width="25%" />
		    </colgroup>
		    <tbody>
		      <tr>
					<th>발주생성일</th>
					<td colspan="3">
						<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:15%; text-align:center;" value=""> - 
						<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:15%; text-align:center;" value="">
						<!-- <span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span> 
						<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','6')">6개월</a></span>						 -->
						<span class="btn_month"><a href="javascript:kepFromMonth('st_from_date','st_to_date','1')">-1개월</a></span>	
						<input type="checkbox"  class="Noborder" name="st_checkbox" id="st_checkbox">&nbsp;기간무시
					</td>
					<th>발주번호</th>
					<td><input type="text" class="input_type_text" id="st_po_no" name="st_po_no" style="width:87%;" value="" onkeydown="kepEnter()"></td>
		      </tr>
		      <tr>
					<th><font color="red"><b>*</b></font>고객사</th>
					<td>
	                       <input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:67%;" value = "" READONLY><!-- KRKOLO0031 -->
	                       <input type="hidden" name="st_buyer_code" id="st_buyer_code" value ="">
	                       <a href="javascript:doPop('buyer_single');"><img src="/resources/images/btn_search03.gif"></a>
	                       <a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
					</td>
					<th>협력사</th>
						<td>
	                        <input type="text" class="input_type_text" name="st_agent_name" id="st_agent_name" style="width:60%;" value ="" READONLY>
	                        <input type="hidden" name="st_agent_code" id="st_agent_code" value ="">
	                        <a href="javascript:doPop('seller');"><img src="/resources/images/btn_search03.gif"></a>
	                        <a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a>
                           </td>
					<th>품목코드</th>
					<td>
						<input type="text" class="input_type_text" name="st_buyer_item_no" id="st_buyer_item_no" style="width:87%;" value =""  onKeyDown="kepEnter()">
					</td>
		      </tr>
		      <tr>
					<th>관리번호</th>
					<td><input type="text" class="input_type_text" id="st_ref_no" name="st_ref_no" style="width:87%;" value="" onkeydown="kepEnter()"></td>
					<th>I/F발주번호</th>
					<td><input type="text" class="input_type_text" id="st_if_po_no" name="st_if_po_no" style="width:87%;" value="" onkeydown="kepEnter()"></td>
					<th></th>
					<td></td>
		      </tr>
		    </tbody>
		  </table>
            </div>
            
           	<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
               	<label for="b_no02" class="hidden">정렬개수선택</label>
					<select name="onepagerow" style="width: 70px;" >
					<option value="10" selected>10건</option>
					<option value="20">20건</option>
					<option value="30">30건</option>
					<option value="40">40건</option>
					<option value="50">50건</option>
				</select>
				<label for="b_no02" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					※ 수주접수전 ▶<font color="red"> 발주번호</font> : 수주접수후 ▶ <font color="blue">발주번호</font>
				</label>
			</span>
			<br>
		</form>
					
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "354px");
  				</script>
  			</div>
  			<p class="paging" id="pageindex"></p>
  			
  			<!--버튼영역-->
               <div class="btnArea">
  	          	<span class="fl">
  					<span class="btn_05 mr04" style="display:none"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
  				</span>
  				
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
