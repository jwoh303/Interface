<%--
**********************************************
* 메뉴 : 카탈로그관리 >물질정보 관리 > 물질정보 등록관리
* 화면 : 물질정보 등록관리
* 기능 : 
* 프로그램 ID :
* 담당자 : 현명환
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %> 
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var remarkOn="/resources/images/icon.gif";
var remarkOff="/resources/images/icon2.gif";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
						 {Align:"Center",	SaveName:"sStatus",			Header:"상태",			Type:"Status",			Width:60,		Edit:false,	EditLen:0,		Sort:0,		Hidden:true}
							,{ Align:"Left",	SaveName:"BUYER_NM",		Header:"고객사",		Type:"Text",				Width:200,	Edit:false,	EditLen:6,		Sort:1,		Hidden:false}
							,{ Align:"Left",	SaveName:"AGENT_NM",		Header:"협력사",		Type:"Text",				Width:150,	Edit:false,	EditLen:6,		Sort:1,		Hidden:false}
							,{ Align:"Center",	SaveName:"REQ_NO",		Header:"요청번호",		Type:"Text",				Width:80,	Edit:false,	EditLen:6, ColMerge:1,Sort:1,		Hidden:false}
							,{ Align:"Center",	SaveName:"STATUS_NM",		Header:"진행상태",		Type:"Text",				Width:110,	Edit:false,	EditLen:6,		Sort:1,		Hidden:false}
							,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"물질정보",	SaveName:"MAKE_IMG",ColMerge:0,Sort:1}
							,{ Align:"Center",	SaveName:"PO_YN",		Header:"최근발주여부",		Type:"Text",				Width:90,	Edit:false,	EditLen:6,		Sort:1,		Hidden:false}
							,{ Align:"Left",	SaveName:"BUYER_ITEM_NO",		Header:"품목코드",		Type:"Text",				Width:100,	Edit:false,	EditLen:6,		Sort:1,		Hidden:false}
							,{ Align:"Center",	SaveName:"QUOTATION_NO",		Header:"견적번호",		Type:"Text",				Width:100,	Edit:false,	EditLen:0,		Sort:1,		Hidden:false}
							,{ Align:"Center",	SaveName:"QUOTATION_SEQ",		Header:"견적항번",		Type:"Text",				Width:80,	Edit:false,	EditLen:0,		Sort:1,		Hidden:false}
							,{ Align:"Center",	SaveName:"REVISION",			Header:"고객사차수",	Type:"Text",				Width:80,	Edit:false,	EditLen:0,		Sort:1,		Hidden:false}
							,{ Align:"Left",	SaveName:"DESCRIPTION_LOC",		Header:"품목명",		Type:"Text",				Width:100,	Edit:false,	EditLen:6,		Sort:1,		Hidden:false}
							,{ Align:"Left",	SaveName:"SPECIFICATION",		Header:"규격",		Type:"Text",				Width:150,	Edit:false,	EditLen:6,		Sort:1,		Hidden:false}
							,{ Align:"Left",	SaveName:"MAKER_NAME",		Header:"제조사",		Type:"Text",				Width:100,	Edit:false,	EditLen:6,		Sort:1,		Hidden:false}
							,{ Align:"Center",	SaveName:"REQ_DATE",		Header:"요청일",		Type:"Date",				Width:80,	Edit:false,	EditLen:6,		Sort:1,		Hidden:false}
							,{ Align:"Center",	SaveName:"USER_NAME_LOC",		Header:"요청자",		Type:"Text",				Width:80,	Edit:false,	EditLen:6,		Sort:1,		Hidden:false}
							,{ Align:"Center",	SaveName:"CHANGE_DATE",		Header:"수정일",		Type:"Date",				Width:80,	Edit:false,	EditLen:6,		Sort:1,		Hidden:false}
							,{ Align:"Center",	SaveName:"CHANGE_USER_NM",		Header:"수정자",		Type:"Text",				Width:80,	Edit:false,	EditLen:6,		Sort:1,		Hidden:false}
							,{ Align:"Center",	SaveName:"STOA_DATE",		Header:"협력사 제출일",		Type:"Date",				Width:80,	Edit:false,	EditLen:6,		Sort:1,		Hidden:false}
							,{ Align:"Center",	SaveName:"STOA_USER_NM",		Header:"협력사 제출자",		Type:"Text",				Width:80,	Edit:false,	EditLen:6,		Sort:1,		Hidden:false}
							,{ Align:"Center",	SaveName:"ATOB_DATE",		Header:"사업팀 제출일",		Type:"Date",				Width:80,	Edit:false,	EditLen:6,		Sort:1,		Hidden:false}
							,{ Align:"Center",	SaveName:"ATOB_USER_NM",		Header:"사업팀 제출자",		Type:"Text",				Width:80,	Edit:false,	EditLen:6,		Sort:1,		Hidden:false}
							,{ Align:"Center",	SaveName:"CONFIRM_DATE",		Header:"최종 승인일",		Type:"Date",				Width:80,	Edit:false,	EditLen:6,		Sort:1,		Hidden:false}
							,{ Align:"Center",	SaveName:"CONFIRM_USER_NM",		Header:"최종 승인자",		Type:"Text",				Width:80,	Edit:false,	EditLen:6,		Sort:1,		Hidden:false}
							,{ Align:"Center",	SaveName:"BUYER",		Header:"BUYER",		Type:"Text",				Width:80,	Edit:false,	EditLen:6,		Sort:1,		Hidden:true}
							,{ Align:"Center",	SaveName:"AGENT",		Header:"AGENT",		Type:"Text",				Width:80,	Edit:false,	EditLen:6,		Sort:1,		Hidden:true}
							,{ Align:"Center",	SaveName:"STOA_USER_ID",		Header:"STOA_USER_ID",		Type:"Text",				Width:80,	Edit:false,	EditLen:6,		Sort:1,		Hidden:true}
							,{ Align:"Center",	SaveName:"BYIT_COMORG_CODE",		Header:"BYIT_COMORG_CODE",		Type:"Text",				Width:80,	Edit:false,	EditLen:6,		Sort:1,		Hidden:true}
							,{ Align:"Center",	SaveName:"REQ_STATUS",		Header:"REQ_STATUS",		Type:"Text",				Width:80,	Edit:false,	EditLen:6,		Sort:1,		Hidden:true}
							
	];

	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:1};
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//비고이미지설정
	mySheet.SetImageList(1, remarkOn);
	mySheet.SetImageList(0, remarkOff);
	//하이퍼링크 설정
	setLinkCol(mySheet, "BUYER_NM");	//고객사
	setLinkCol(mySheet, "AGENT_NM");	//협력사
	setLinkCol(mySheet, "STOA_USER_NM");	//협력사제출자
	setLinkCol(mySheet, "MAKE_IMG");	//물질정보
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
	switch (str) {
	case "search":	 // 조회
		if(document.forms.searchCondition.st_checkbox2.checked == true){ //기간무시 체크 한 경우
			document.forms.searchCondition.st_send_gbn2.value = "";
			if(document.forms.searchCondition.st_checkbox.checked == true){
				document.forms.searchCondition.st_send_gbn.value = "Y";
			}else{
				document.forms.searchCondition.st_send_gbn.value = "";
			}
			if (isEmpty($("#st_buyer_item_no").val()) && isEmpty($("#st_quotation_no").val()) && isEmpty($("#st_buyer_code").val()) && isEmpty($("#st_agent_code").val()) &&
					isEmpty($("#st_req_no").val()) && isEmpty($("#st_description").val()) && isEmpty($("#st_specification").val()) && isEmpty($("#st_maker_name").val())) {
				alert("기간무시 체크할 경우 최소 부분은 입력을 해야 합니다.");
				return;			
			}
		}else{ //기간무시 체크 안한 경우 
			document.forms.searchCondition.st_send_gbn2.value = "Y";
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
			var diff = kepGetDateDiff('st_from_date','st_to_date','D');
			if (eval(diff)>93){
				alert("3개월 이내 조회만 가능합니다.");
				return;
			}
			if(document.forms.searchCondition.st_checkbox.checked == true){
				document.forms.searchCondition.st_send_gbn.value = "Y";
			}else{
				document.forms.searchCondition.st_send_gbn.value = "";
			}
		}
		current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/mdcm/getMasterMdCmChemicalMatMngList.do" , pagingMode );
		break;
	case "reload":	// 초기화
		$("#re_current_page").val(1);
		$( '#searchCondition' )[0].reset();
		$("#st_from_date").val( kepToMonthAdd("1","M"));
		$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
		mySheet.RemoveAll();
		$("#st_buyer_code").val("");
		$("#st_agent_code").val("");
		break;
	case "excelDown": // 엑셀다운로드

		if(document.forms.searchCondition.st_checkbox2.checked == true){ //기간무시 체크 한 경우
			document.forms.searchCondition.st_send_gbn2.value = "";
			if(document.forms.searchCondition.st_checkbox.checked == true){
				document.forms.searchCondition.st_send_gbn.value = "Y";
			}else{
				document.forms.searchCondition.st_send_gbn.value = "";
			}
			if (isEmpty($("#st_buyer_item_no").val()) && isEmpty($("#st_quotation_no").val()) && isEmpty($("#st_buyer_code").val()) && isEmpty($("#st_agent_code").val()) &&
					isEmpty($("#st_req_no").val()) && isEmpty($("#st_description").val()) && isEmpty($("#st_specification").val()) && isEmpty($("#st_maker_name").val())) {
				alert("기간무시 체크할 경우 고객사,품목코드는 \n검색조건으로 필수 지정해야 합니다.");
				return;			
			}
		}else{ //기간무시 체크 안한 경우 
			document.forms.searchCondition.st_send_gbn2.value = "Y";
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
			var diff = kepGetDateDiff('st_from_date','st_to_date','D');
			if (eval(diff)>93){
				alert("3개월 이내 조회만 가능합니다.");
				return;
			}
			if(document.forms.searchCondition.st_checkbox.checked == true){
				document.forms.searchCondition.st_send_gbn.value = "Y";
			}else{
				document.forms.searchCondition.st_send_gbn.value = "";
			}
		}
	    $("#pageflag").val('0');
		var param = {FileName:"물질정보등록관리.xlsx",Merge:1,SheetDesign:1,DownCols:"BUYER_NM|AGENT_NM|REQ_NO|STATUS_NM|PO_YN|BUYER_ITEM_NO|QUOTATION_NO|QUOTATION_SEQ|REVISION|DESCRIPTION_LOC|SPECIFICATION|MAKER_NAME|REQ_DATE|USER_NAME_LOC|CHANGE_DATE|CHANGE_USER_NM|STOA_DATE|STOA_USER_NM|ATOB_DATE|ATOB_USER_NM|CONFIRM_DATE|CONFIRM_USER_NM|"}; 
		kepDownExcel(document.searchCondition ,mySheet , "/mdcm/excelMasterMdCmChemicalMatMngList.do", param);
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
	if(current_page==-1){
		makePageIndex2(mySheet, 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2(mySheet, current_page , document.searchCondition.onepagerow.value);	
	}
	
}

function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
    pagingMode = "P";
	current_page = param.page;
	$("#re_current_page").val(current_page);
	kepSearch(document.searchCondition ,  mySheet , "/mdcm/getMasterMdCmChemicalMatMngList.do?page="+current_page , pagingMode );
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
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'BUYER_NM') { // 고객사
		var BUYER = mySheet.GetCellValue(Row,"BUYER");
		openSearchPopup('/common/agentInfoDisplayPop.do','?st_com_code='+BUYER, '800,550,no');
	} else if (column == 'STOA_USER_NM') { // 협력사제출자
		var ID = mySheet.GetCellValue(Row,"STOA_USER_ID");
		openSearchPopup('/common/userDisplayPop.do','?user_id='+ID,'800,500,no');
	} else if (column == 'MAKE_IMG') { // 물질정보
		var st_buyer = mySheet.GetCellValue(Row,"BUYER");
		var st_req_no = mySheet.GetCellValue(Row,"REQ_NO");
		var st_buyer_item_no = mySheet.GetCellValue(Row,"BUYER_ITEM_NO");
		var st_req_status = mySheet.GetCellValue(Row,"REQ_STATUS");
		
		var st_quotation_no = mySheet.GetCellValue(Row,"QUOTATION_NO");
		var st_quotation_seq = mySheet.GetCellValue(Row,"QUOTATION_SEQ");
		var st_revision = mySheet.GetCellValue(Row,"REVISION");
		var st_sg118_yn = mySheet.GetCellValue(Row,"SG118_YN");
		
		if(st_quotation_no != "" && st_quotation_seq != "" && st_revision != ""){ // 견적 정보로 조회
			openSearchPopup('/mdct/getSellerMdCtChemicalMatRegPopHd.do', '?st_req_no='+st_req_no+'&st_buyer='+st_buyer+'&st_quotation_no='+st_quotation_no+'&st_quotation_seq='+st_quotation_seq+'&st_revision='+st_revision+'&st_type=mInput'+'&st_req_status='+st_req_status,'800,620,yes');
		}else{ // 카탈로그 정보로 조회
			if(st_sg118_yn == "Y"){ // 시약류이면 보관조건 높이만큼 추가
				openSearchPopup('/mdct/getSellerMdCtChemicalMatRegPopHd.do', '?st_req_no='+st_req_no+'&st_buyer_item_no='+st_buyer_item_no+'&st_type=mInput'+'&st_req_status='+st_req_status,'800,670,yes');	
			}else{
				openSearchPopup('/mdct/getSellerMdCtChemicalMatRegPopHd.do', '?st_req_no='+st_req_no+'&st_buyer_item_no='+st_buyer_item_no+'&st_type=mInput'+'&st_req_status='+st_req_status,'800,620,yes');
			}
		}
	} else if(column == 'BUYER_ITEM_NO'){ // 품목코드 선택
		var buyer = mySheet.GetCellValue(Row,"BYIT_COMORG_CODE");
		var buyer_item_no = mySheet.GetCellValue(Row,"BUYER_ITEM_NO");
		openSearchPopup("/mdcm/showMasterMdCmBuyerCatalogAlterPop.do","?st_buyer_code="+buyer+"&st_catalog_com_code="+buyer+"&st_buyer_item_no="+escape(buyer_item_no),"988,710,no");
	} else 	if (column == 'AGENT_NM') { // 협력사
		var AGENT = mySheet.GetCellValue(Row,"AGENT");
		openSearchPopup('/common/agentInfoDisplayPop.do','?st_com_code='+AGENT, '800,550,no');
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
	}
	grbRow="";	//초기화
}
	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
	<!--버튼영역-->
	<div id="searchBtnA"  >
		<h3>물질정보 등록관리</h3>
        <span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		<span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   	</div>        	

	<!--조회영역-->
	<form name = "searchCondition" id="searchCondition" method = "post" onsubmit="return false" >
		<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<input type="hidden" name="st_send_gbn"  id="st_send_gbn" value ="">
			<input type="hidden" name="st_send_gbn2"  id="st_send_gbn2" value =""> <!-- 기간무시용 -->
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="re_current_page" name="re_current_page"  value="">

			<table class="cont_t_list01">
			    <caption></caption>
			    <colgroup>
				    <col width="6%" />
				    <col width="19%" />
				    <col width="6%" />
				    <col width="19%" />
				    <col width="6%" />
				    <col width="19%" />
				    <col width="6%" />
				    <col width="19%" />
			    </colgroup>
			    
			    <tbody>
			    	<tr>
						<th>요청일</th>
						<td colspan="3">
							<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:15%; text-align:center;" value=""> - 
							<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:15%; text-align:center;" value="">
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span> 
							<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>	
							<input type="checkbox"  class="Noborder"  name="st_checkbox2" id="st_checkbox2"> 기간무시
							<input type="checkbox"  class="Noborder"  name="st_checkbox" id="st_checkbox" checked> 미제출
						</td>
						
						<th>품목코드</th>
						<td>
							<input type="text" class="input_type_text" name="st_buyer_item_no" id="st_buyer_item_no" style="width:87%;" value =""  onKeyDown="kepEnter()">
						</td>
						
						<th>견적번호</th>
						<td>
							<input type="text"   class="input_type_text" name="st_quotation_no" id="st_quotation_no" style="width:87%" value="" onKeyDown="kepEnter()">
						</td>
					</tr>
					
					<tr>
						<th>고객사</th>
						<td>
							<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:60%;" value = "" READONLY><!-- KRKOLO0031 -->
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
						
						<th>요청번호</th>
						<td>
							<input type="text" class="input_type_text" id="st_req_no" name="st_req_no" style="width:87%;" value="" onkeydown="kepEnter()">
						</td>
						
						<th>요청자</th>
						<td>
							<input type="text"   class="input_type_text" name="st_add_usr_id" id="st_add_usr_id" style="width:87%" value="" onKeyDown="kepEnter()">
							<input type="hidden"   class="input_type_text" name="st_quotation_no" id="st_quotation_no" style="width:87%" value="" onKeyDown="kepEnter()">
						</td>
					</tr>
					
					<tr>
						<th>품명</th>
						<td>
							<input type="text"   class="input_type_text" name="st_description" id="st_description" style="width:87%" value="" onKeyDown="kepEnter()">
						</td>
						
						<th>규격</th>
						<td>
							<input type="text"   class="input_type_text" name="st_specification" id="st_specification" style="width:87%" value="" onKeyDown="kepEnter()">
						</td>
						
						<th>제조사</th>
						<td>
							<input type="text"   class="input_type_text" name="st_maker_name" id="st_maker_name" style="width:87%" value="" onKeyDown="kepEnter()">
						</td>
						
						<th>진행상태</th>
						<td>
							<select name="st_status" id="st_status" style="width:87%">
						  		<%= CommonUtil.getCode3ComboList("", "ALL", "CM01","", "ICOMCOD1", "", "") %>           
				         	</select>
                    	</td>
					</tr>
		    	</tbody>
			</table>
		</div>
           	
       	<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
           	<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow" style="width: 70px;" >
				<option value="50" selected>50건</option>
				<option value="100">100건</option>
				<option value="150">150건</option>
				<option value="200">200건</option>
				<option value="300">300건</option>
			</select>
		</span>
		
		<font style="color: red; size: 12px;"><b>&nbsp;※ 현재일 기준 30일 이내 발주생성 된 품목은 최근 발주여부가 Y로 표기 됩니다.</b></font>
		
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
		<span class="fl" >
			<span class="btn_04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
		</span>
	</div>
<!--내용 종료-->	                 
</body>
</html>
