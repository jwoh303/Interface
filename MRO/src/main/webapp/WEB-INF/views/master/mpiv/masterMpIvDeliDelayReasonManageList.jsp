<%--
**********************************************
* 메뉴 : 납품관리 > 납기지연사유 관리
* 화면 : 납기지연사유 관리
* 기능 :
* 프로그램 ID :
* 담당자 : HSJ ( 설계 : 김승우 )
* 착수일 : 2019-09-11
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"%>
<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
		  { Align:"Left",	Width:150,	Edit:false,	Hidden:false,	Type:"Text",	Header:"협력사명",		SaveName:"AGENT_NAME"}
		, { Align:"Center",	Width:100,	Edit:false,	Hidden:false,	Type:"Text",	Header:"접수자명",		SaveName:"AGENT_USER_NAME"}
		, { Align:"Left",	Width:150,	Edit:false,	Hidden:false,	Type:"Text",	Header:"고객사명",		SaveName:"BUYER_NAME"}
		, { Align:"Center",	Width:100,	Edit:false,	Hidden:false,	Type:"Text",	Header:"고객발주번호",	SaveName:"LEGACY_PO_NO"}
		, { Align:"Center",	Width:100,	Edit:false,	Hidden:false,	Type:"Text",	Header:"발주번호",		SaveName:"PO_NO"}
		, { Align:"Center",	Width:60,	Edit:false,	Hidden:false,	Type:"Text",	Header:"발주항번",		SaveName:"PO_SEQ"}
		, { Align:"Center",	Width:70,	Edit:false,	Hidden:false,	Type:"Text",	Header:"발주일",		SaveName:"PO_DATE"}
		, { Align:"Center",	Width:120,	Edit:false,	Hidden:false,	Type:"Text",	Header:"발주생성일시",	SaveName:"PO_ADD_DATE"}
		, { Align:"Center",	Width:70,	Edit:false,	Hidden:false,	Type:"Text",	Header:"납기요청일",		SaveName:"RD_DATE"}
		, { Align:"Center",	Width:70,	Edit:false,	Hidden:false,	Type:"Text",	Header:"납품예정일",		SaveName:"DS_DATE"}
		, { Align:"Center",	Width:120,	Edit:false,	Hidden:false,	Type:"Text",	Header:"수주접수일시",	SaveName:"RS_ADD_DATE"}
		, { Align:"Left",	Width:150,	Edit:false,	Hidden:false,	Type:"Text",	Header:"납기지연사유",	SaveName:"DS_DELAY_REASON"}
		, { Align:"Center",	Width:70,	Edit:false,	Hidden:false,	Type:"Text",	Header:"SCM비고",		SaveName:"SCM_REMARK"}
		, { Align:"Center",	Width:100,	Edit:false,	Hidden:false,	Type:"Text",	Header:"품목코드",		SaveName:"BUYER_ITEM_NO"}
		, { Align:"Center",	Width:70,	Edit:false,	Hidden:false,	Type:"Text",	Header:"거래유형",		SaveName:"PROCESS_TYPE"}
		, { Align:"Right",	Width:70,	Edit:false,	Hidden:false,	Type:"Float",	Header:"발주수량",		SaveName:"ITEM_QTY"}
		, { Align:"Right",	Width:70,	Edit:false,	Hidden:false,	Type:"Float",	Header:"납품수량",		SaveName:"IV_QTY"}
		, { Align:"Right",	Width:70,	Edit:false,	Hidden:false,	Type:"Float",	Header:"입고수량",		SaveName:"GR_QTY"}
		, { Align:"Right",	Width:70,	Edit:false,	Hidden:false,	Type:"Float",	Header:"확정수량",		SaveName:"DI_QTY"}
		, { Align:"Left",	Width:200,	Edit:false,	Hidden:false,	Type:"Text",	Header:"품명",		SaveName:"DESCRIPTION"}
		, { Align:"Left",	Width:250,	Edit:false,	Hidden:false,	Type:"Text",	Header:"규격",		SaveName:"SPECIFICATION"}
		, { Align:"Center",	Width:70,	Edit:false,	Hidden:false,	Type:"Text",	Header:"발주자명",		SaveName:"PURCHASER_NAME"}
		, { Align:"Left",	Width:300,	Edit:false,	Hidden:false,	Type:"Text",	Header:"발주비고",		SaveName:"PO_REMARK"}
		, { Align:"Left",	Width:400,	Edit:false,	Hidden:false,	Type:"Text",	Header:"도착지주소",		SaveName:"DELY_TO_LOCATION"}
		
		, { Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"고객사",		SaveName:"BUYER"}
		, { Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"협력사",		SaveName:"AGENT"}
		, { Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"접수자ID",		SaveName:"ADD_USER_ID"}
		, { Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"발주자ID",		SaveName:"PURCHASER_ID"}
		, { Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"카탈로그관리코드",	SaveName:"BYIT_COMORG_CODE"}
		, { Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"계약서번호",		SaveName:"CONTRACT_NO"}
		, { Align:"Center",	Width:100,	Edit:false,	Hidden:true,	Type:"Text",	Header:"계약서항번",		SaveName:"CONTRACT_SEQ"}
	];
	
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:0};
	IBS_InitSheet(mySheet, initsheet, pagingMode);
// 	mySheet.SetCountPosition(4);
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "AGENT_NAME"); // 협력사명
	setLinkCol(mySheet, "AGENT_USER_NAME"); // 접수자명
	setLinkCol(mySheet, "BUYER_NAME"); // 고객사명
	setLinkCol(mySheet, "PO_NO"); // 발주번호
	setLinkCol(mySheet, "DS_DATE"); // 납품예정일
	setLinkCol(mySheet, "SCM_REMARK"); // SCM비고
	setLinkCol(mySheet, "BUYER_ITEM_NO"); // 품목코드
	setLinkCol(mySheet, "PURCHASER_NAME"); // 발주자명
	
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	$("#st_from_date").val(kepGetNowTimeStr('YYYYMMDD','/'));
	$("#st_to_date").val(kepGetNowTimeStr('YYYYMMDD','/'));
	kepAjaxCommonQueryIdCombo('st_kep_dept','getKepDeptList','','${sessionInfo.department}');
}

// 기능함수
function doAction(str) {
	switch (str) {
		case "search":	 // 조회
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
		
			if(!validCheck('true')){
				return;
			}
			
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mpiv/getMasterMpIvDeliDelayReasonManageList.do" , pagingMode );
			break;
		case "reload":	// 초기화
			kepReload('searchCondition');
			$("#st_from_date").val(kepGetNowTimeStr('YYYYMMDD','/'));
			$("#st_to_date").val(kepGetNowTimeStr('YYYYMMDD','/'));
			$("#st_buyer_code").val('');		
			$("#st_agent_code").val('');
			$("#st_iv_flag").val('N');
			document.getElementById("st_iv_flag_check").checked = false;
			kepAjaxCommonQueryIdCombo('st_kep_dept','getKepDeptList','','${sessionInfo.department}');
			mySheet.RemoveAll();
			break;
		case "excelDown": // 엑셀다운로드
			if(!validCheck('true')){
				return;
			}
		
			$("#pageflag").val('0');
			var param = {FileName:"협력사 납기지연사유.xls",Merge:1,SheetDesign:1,DownCols:"AGENT_NAME|AGENT_USER_NAME|BUYER_NAME|LEGACY_PO_NO|PO_NO|PO_SEQ|PO_DATE|PO_ADD_DATE|RD_DATE|DS_DATE|RS_ADD_DATE|DS_DELAY_REASON|SCM_REMARK|BUYER_ITEM_NO|PROCESS_TYPE|ITEM_QTY|IV_QTY|GR_QTY|DI_QTY|DESCRIPTION|SPECIFICATION|PURCHASER_NAME|PO_REMARK|DELY_TO_LOCATION|"};
			kepDownExcel(document.searchCondition ,mySheet , "/mpiv/excelMasterMpIvDeliDelayReasonManageList.do", param);
			$("#pageflag").val('1');
			break;
	}
}

function validCheck() {
	var from_date = $("#st_from_date").val();
	var to_date = $("#st_to_date").val();
	var st_kep_dept = $("#st_kep_dept").val();
	var st_buyer_code = $("#st_buyer_code").val();
	
	if(from_date == "" && to_date == ""){
		alert("수주접수일을 선택하여 주시기 바랍니다.");
		return false;
	}
	
	if(kepGetDateDiff('st_from_date','st_to_date','D') > 31){
		alert("조회기간을 1개월 단위로 조회가 가능합니다.");
		return false;
	}
	
	if(st_kep_dept == ""){
		alert("팀명을 선택하여 주시기 바랍니다.");
		return false;
	}
	
	if($("#st_iv_flag_check").is(":checked")){
		if(st_buyer_code == ""){
			alert("납품서 생성 포함 시 고객사 선택 필수입니다.");
			return false;
		}
	}
	
	return true;
}

// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	
	return DATA;
}
	
// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}

	if(mySheet.RowCount() <= 0) return;
	
	for(var i = 1; i <= mySheet.RowCount(); i++){
	}
	
	if (msg != "") {
		alert(msg);
	}
	
	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
}

function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
}

//페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mpiv/getMasterMpIvDeliDelayReasonManageList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "seller": // 협력사
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=S&MULTI=N", "500,466,no");
			popupSel = "seller";
			break;
		case "buyerMulti": // 고객사 M
			openSearchPopup('/common/safetyCompanyCodePop.do','?COM_TYPE=B', '880,450,no');
			popupSel = "buyerMulti";
			break;
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'AGENT_NAME') { // 협력사
		var ID = mySheet.GetCellValue(Row,"AGENT");
	
		getAgentDisplayPop(ID);
	} else if (column == 'BUYER_NAME') { // 고객사
		var ID = mySheet.GetCellValue(Row,"BUYER");
	
		getAgentDisplayPop(ID);
	} else if (column == 'AGENT_USER_NAME') { // 접수자명
		var ID = mySheet.GetCellValue(Row,"ADD_USER_ID");
	
		openSearchPopup('/common/userDisplayPop.do','?user_id='+ID,'800,500,no');
	} else if (column == 'PURCHASER_NAME') { // 발주자명
		var ID = mySheet.GetCellValue(Row,"PURCHASER_ID");
	
		openSearchPopup('/common/userDisplayPop.do','?user_id='+ID,'800,500,no');
	} else if (column == 'PO_NO') { // 발주번호
		var BUYER = mySheet.GetCellValue(Row,"BUYER");
		var PO_NO = mySheet.GetCellValue(Row,"PO_NO");
		
		openSearchPopup('/common/mpso/poDetailPop.do','?st_buyer='+BUYER+'&st_po_no='+PO_NO,'900,550,no');
	} else if (column == 'SCM_REMARK') { // SCM비고
		var BUYER = mySheet.GetCellValue(Row,"BUYER");
		var PO_NO = mySheet.GetCellValue(Row,"PO_NO");
		var PO_SEQ = mySheet.GetCellValue(Row,"PO_SEQ");
		
		openSearchPopup("/coco/getCommonCoCoScmActionDetailPop.do", "?st_buyer="+BUYER+"&st_po_no="+PO_NO+"&st_po_seq="+PO_SEQ, "520,500,no");
	} else if (column == 'DS_DATE') { // 납품예정일
		var BUYER = mySheet.GetCellValue(Row,"BUYER");
		var PO_NO = mySheet.GetCellValue(Row,"PO_NO");
		var PO_SEQ = mySheet.GetCellValue(Row,"PO_SEQ");
		var RD_DATE = mySheet.GetCellValue(Row,"RD_DATE");
		RD_DATE = RD_DATE.replace(/[.]/gi,"");
		
		var ITEM_QTY = mySheet.GetCellValue(Row,"ITEM_QTY");
		var SELLER = mySheet.GetCellValue(Row,"AGENT");
		var ADD_USER_ID = mySheet.GetCellValue(Row,"PURCHASER_ID");
		
		openSearchPopup("/mpiv/getMasterMpIvMultiDeliveryPop.do", "?st_buyer="+BUYER+"&st_po_no="+PO_NO+"&st_po_seq="+PO_SEQ+"&st_rd_date="+RD_DATE+"&st_item_qty="+ITEM_QTY+"&st_seller="+SELLER+"&st_add_user_id="+ADD_USER_ID, "550,600,no");
	} else if (column == 'BUYER_ITEM_NO') { // 품목코드
		var buyer = mySheet.GetCellValue(Row,"BYIT_COMORG_CODE");
		var buyerItemNo = mySheet.GetCellValue(Row,"BUYER_ITEM_NO");
		var contractNo = mySheet.GetCellValue(Row,"CONTRACT_NO");
		var contractSeq = mySheet.GetCellValue(Row,"CONTRACT_SEQ");
		
		openSearchPopup('/common/catalogDetailPop.do','?BUYER='+buyer+'&BUYER_ITEM_NO='+buyerItemNo+'&CONTRACT_NO='+contractNo+'&CONTRACT_SEQ='+contractSeq,'800,290,no');
	}
	
	return;
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "seller") {	// 협력회원사
		$("#st_agent_code").val(value1);
		$("#st_agent_name").val(value2);
	}else if (popupSel == "buyerMulti") {	
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(kepMultiName(value2,"@"));
	}

	grbRow="";	//초기화
}

// 납품서 생성 포함 체크
function setCheckBox(){
	
	if($("#st_iv_flag_check").is(":checked")){
		$("#st_iv_flag").val("Y");
	} else {
		$("#st_iv_flag").val("N");
	}
}
</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>협력사 납기지연사유 관리</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition" method = "post">
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			
            	<table  class="cont_t_list01" >
					<caption>협력사 납기지연사유 관리</caption>
					<colgroup>
							<col width="8%" />
							<col width="34%" />
							<col width="6%" />
							<col width="20%" />
							<col width="6%" />
							<col width="20%" />
					</colgroup>
						
					<tbody>
						<tr>
							<th><font color="red"><b>*</b></font>수주접수일</th>
							<td>
								<input type="text" name="st_from_date" id="st_from_date" readOnly style="width:75px; text-align:center;" > - 
								<input type="text" name="st_to_date" id="st_to_date" readOnly style="width:75px; text-align:center;" >
							</td>
							<td colspan="4">
								<input type="checkbox" class="Noborder" id="st_iv_flag_check" name="st_iv_flag_check"  value="" onChange="setCheckBox();">
								<input type="hidden"   id="st_iv_flag" name="st_iv_flag" value="N" />
								<b><font color="#333333">납품서 생성 포함</font></b>
							</td>
						</tr>
						<tr>
							<th><font color="red"><b>*</b></font>팀명</th>
							<td>
								<select id="st_kep_dept" name="st_kep_dept" style="width:40%;height:20px" onChange="checkLoc()"></select>
							</td>
							<th>고객사</th>
							<td>
								<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:60%" value="" readonly onclick="javascript:doPop('buyer_single');">
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:80%" value="">
								<a href="javascript:doPop('buyerMulti');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>
							<th>협력사</th>
							<td>
								<input type="text" class="input_type_text" name="st_agent_name" id="st_agent_name" style="width:60%;" value ="" READONLY>
								<input type="hidden" name="st_agent_code" id="st_agent_code"  style="width:80%value ="">
								<a href="javascript:doPop('seller');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
						</tr>
					</tbody>
				</table>
            </div>
            <table style="width:100%;">
				<tr>
					<td align="left">
		           		<img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
		               	<label for="b_no02" class="hidden">정렬개수선택</label>
							<select name="onepagerow" style="width: 70px;" >
							<option value="10" selected>10건</option>
							<option value="20">20건</option>
							<option value="30">30건</option>
							<option value="40">40건</option>
							<option value="50">50건</option>
						</select>
					</td>
				</tr>
			</table>
		</form>
					
		<!--grid-->
		<div class="ib_product" style="border-top:2px solid #3c639c">
			<script type="text/javascript">
				createIBSheet("mySheet", "100%", "354px");
			</script>
		</div>
		<p class="paging" id="pageindex"></p>
		
		<table style="width:100%;">
		    <tr>
		        <td height="25" align = "right" valign="middle">
		            <span class="btn_06"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
		        </td>
		    </tr>
		</table>
<!--내용 종료-->	                 

</body>
</html>
