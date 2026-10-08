<%--
**********************************************
* 메뉴 : 물질정보관리 > 물질정보 제출
* 화면 : 물질정보 제출
* 기능 : 
* 프로그램 ID : 
* 담당자 : 현명환
* 착수일 : 
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
<%@ include file="../../common/include/head.jspf"  %>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";
var remarkOn="/resources/images/icon.gif";
var remarkOff="/resources/images/icon2.gif";
var iconR="/resources/images/icon_r.gif";
var iconY="/resources/images/icon_y.gif";
var iconG="/resources/images/icon_g.gif";
// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
					 {Align:"Center",	SaveName:"sStatus",			Header:"상태",			Type:"Status",			Width:60,		Edit:false,	EditLen:0,		Sort:0,		Hidden:true}
					,{ Align:"Center",	Width:15,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"요청번호",	SaveName:"REQ_NO_IMG", ColMerge:1,Sort:1}
					,{ Align:"Left",	SaveName:"REQ_NO",		Header:"요청번호",		Type:"Text",				Width:100,	Edit:false,	EditLen:6, ColMerge:1,Sort:1,		Hidden:false}
					,{ Align:"Center",	SaveName:"STATUS_NM",		Header:"진행상태",		Type:"Text",				Width:90,	Edit:false,	EditLen:6,		Sort:1,		Hidden:false}
					,{ Align:"Left",	SaveName:"BUYER_NM",		Header:"고객사",		Type:"Text",				Width:120,	Edit:false,	EditLen:6,		Sort:1,		Hidden:false}
					,{ Align:"Left",	SaveName:"BUYER_ITEM_NO",		Header:"품목코드",		Type:"Text",				Width:100,	Edit:false,	EditLen:6,		Sort:1,		Hidden:false}
					,{ Align:"Left",	SaveName:"DESCRIPTION_LOC",		Header:"품목명",		Type:"Text",				Width:150,	Edit:false,	EditLen:6,		Sort:1,		Hidden:false}
					,{ Align:"Left",	SaveName:"SPECIFICATION",		Header:"규격",		Type:"Text",				Width:220,	Edit:false,	EditLen:6,		Sort:1,		Hidden:false}
					,{ Align:"Left",	SaveName:"MAKER_NAME",		Header:"제조사",		Type:"Text",				Width:100,	Edit:false,	EditLen:6,		Sort:1,		Hidden:false}
					,{ Align:"Center",	SaveName:"REQ_DATE",		Header:"생성일",		Type:"Date",				Width:100,	Edit:false,	EditLen:6,		Sort:1,		Hidden:false}
					,{ Align:"Center",	SaveName:"USER_NAME_LOC",		Header:"생성자",		Type:"Text",				Width:80,	Edit:false,	EditLen:6,		Sort:1,		Hidden:false}
					,{ Align:"Center",	SaveName:"PHONE_NUMBER",		Header:"요청자연락처",		Type:"Text",				Width:100,	Edit:false,	EditLen:6,		Sort:1,		Hidden:false}
					,{ Align:"Center",	SaveName:"PO_YN",		Header:"최근발주여부",		Type:"Text",				Width:90,	Edit:false,	EditLen:6,		Sort:1,		Hidden:false}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"물질정보",	SaveName:"MAKE_IMG",ColMerge:0,Sort:1}
					,{ Align:"Center",	SaveName:"BUYER",			Header:"고객사코드",	Type:"Text",				Width:90,	Edit:false,	EditLen:6,		Sort:1,		Hidden:true}
					,{ Align:"Center",	SaveName:"QUOTATION_NO",	Header:"견적번호",		Type:"Text",				Width:90,	Edit:false,	EditLen:6,		Sort:1,		Hidden:true}
					,{ Align:"Center",	SaveName:"QUOTATION_SEQ",	Header:"견적항번",		Type:"Text",				Width:90,	Edit:false,	EditLen:6,		Sort:1,		Hidden:true}
					,{ Align:"Center",	SaveName:"REVISION",		Header:"고객사차수",	Type:"Text",				Width:90,	Edit:false,	EditLen:6,		Sort:1,		Hidden:true}
					
					

	];
	//InitHeaders의 두번째 인자
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:1};
	initsheet.HeaderMode = {ColMove:0,ColResize:1,HeaderCheck:1};
	var cfg = {MergeSheet:msPrevColumnMerge};
	mySheet.SetConfig(cfg);
	IBS_InitSheet(mySheet, initsheet,pagingMode, '');	
	//이미지 설정
	//비고이미지설정
	mySheet.SetImageList(0, remarkOff);
	mySheet.SetImageList(1, remarkOn);
	mySheet.SetImageList(2, iconG);
	mySheet.SetImageList(3, iconY);
	mySheet.SetImageList(4, iconR);
	
	

	//하이퍼링크 설정
	setLinkCol(mySheet, "MAKE_IMG");	//물질정보

	
	$("#st_from_date").val(kepToDateAdd("31","M"));
	$("#st_to_date").val(kepGetNowTimeStr('YYYYMMDD','/'));	
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
}

var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if (str =="del" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
		case "search":	 // 조회
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
			if (kepGetDateDiff('st_from_date','st_to_date','D') > 93 ){
				alert("조회기간을 3개월 단위로 조회가 가능합니다.");
				return;
			}
			current_page = -1;
			kepSearch(document.searchCondition, mySheet, "/mdct/getSellerMdCtChemicalMatSendList.do" , pagingMode );
			break;
		case "reload":	// 초기화
			kepReload('searchCondition');
			dateEraser();
			mySheet.RemoveAll();
			break;
	}
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

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mdct/getSellerMdCtChemicalMatSendList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str, val1, val2, val3, val4, val5) {
	popupSel = str;
	
	switch (str) {
		case "reqMake": //물질정보 등록
			popupSel = "reqMake";
			if(val3 != "" && val4 != "" && val5 != ""){ // 견적 정보로 조회
				openSearchPopup('/mdct/getSellerMdCtChemicalMatRegPopHd.do', '?st_req_no='+val1+'&st_buyer='+val2+'&st_quotation_no='+val3+'&st_quotation_seq='+val4+'&st_revision='+val5+'&st_type=sInput'+'&st_req_status=Q','800,800,yes');
			}else{ // 카탈로그 정보로 조회
				openSearchPopup('/mdct/getSellerMdCtChemicalMatRegPopHd.do', '?st_req_no='+val1+'&st_buyer_item_no='+val2+'&st_type=sInput'+'&st_req_status=Q','800,800,yes');	
			}
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	if (column == "MAKE_IMG") { 
		var st_req_no = mySheet.GetCellValue(Row, "REQ_NO");
		var st_buyer_item_no = mySheet.GetCellValue(Row, "BUYER_ITEM_NO");
		var st_buyer = mySheet.GetCellValue(Row, "BUYER");
		var st_quotation_no = mySheet.GetCellValue(Row,"QUOTATION_NO");
		var st_quotation_seq = mySheet.GetCellValue(Row,"QUOTATION_SEQ");
		var st_revision = mySheet.GetCellValue(Row,"REVISION");
		
		if(st_quotation_no != "" && st_quotation_seq != "" && st_revision != ""){ // 견적 정보로 조회
			doPop("reqMake",st_req_no, st_buyer, st_quotation_no, st_quotation_seq, st_revision);
		}else{ // 카탈로그 정보로 조회
			doPop("reqMake",st_req_no, st_buyer_item_no, "", "", "");
		}
	}
	return;
}

function mySheet_OnChange(Row, Col, Value) {

	if ( Row  < 1) return;

	var column = mySheet.ColSaveName(Col);
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
}

//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if ( msg != "" ) {
		alert(msg);
	}
	if ( code > 0 ) {
		//저장 성공시 처리
		doAction("search");
	}
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	var sMsg = response.msg;
}


// ajax 공통 호출후 에러시 처리 함수
function  kepAjaxError(pMethod , response) {
	alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  ");
}



function kepEnter() {	
	if (event.keyCode == 13) { 
		doAction("search");
	}
}

function dateEraser() {
	
}

</script>
</head>
<%
@SuppressWarnings (value="unchecked")

String userID = _sessionInfo.getUserId();
%>
<body onload="kep_onload_view()">
<div id="wrapper">
<!-- 메뉴 S --> 
<c:import charEncoding="utf-8" url="/menu/menu.do" >
<c:param name="page" value="sellerHeader"/>
<c:param name="part" value="header"/>
</c:import>
<div id="container2">
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="sellerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>
	<!--내용 시작-->
<!--내용 시작-->
<div id="ContArea">
	<h3>물질정보 제출</h3>
		<!--버튼영역-->
       	<div id="searchBtnA"  >
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form id="searchCondition" name="searchCondition" method="post" onsubmit="return false;" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME" />
			<input type="hidden" id="pageflag" name="pageflag" value="1" />
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}" />
			<input type="hidden" id="st_com_code" name="st_com_code"  value="${sessionInfo.comCode}" />
			<input type="hidden" id="st_corp_code" name="st_corp_code"  value="" />
			<table  class="cont_t_list01" >
					<caption>물질정보 제출</caption>
					<colgroup>
						<col width="12%" />
						<col width="21%" />
						<col width="12%" />
						<col width="21%" />
						<col width="12%" />
                        <col width="21%" />
					</colgroup>
						
					<tbody>
						<tr>
							<th>
								생성일
							</th>
							<td colspan="3">
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:20%; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_from_date')"></a>
								-
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:20%; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_to_date')"></a>
									&nbsp;&nbsp;
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>
							</td>
							<th>요청번호</th>
							<td>
								<input type="text" class="input_type_text" id="st_req_no" name="st_req_no" style="width:87%;" value=""  onkeydown="kepEnter()"> 
							</td>
							
						</tr>
						<tr>
							<th>품목코드</th>
							<td>
								<input type="text" class="input_type_text" id="st_buyer_item_no" name="st_buyer_item_no" style="width:87%;" value=""  onkeydown="kepEnter()">
							</td> 
							<th>품명</th>
							<td>
								<input type="text" class="input_type_text" id="st_desc" name="st_desc" style="width:87%;" value=""  onkeydown="kepEnter()">
							</td>
							<th>규격</th>
							<td>
								<input type="text" class="input_type_text" id="st_spec" name="st_spec" style="width:87%;" value=""  onkeydown="kepEnter()">
							</td>
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
				&nbsp;<img src="/resources/images/icon_g.gif"> 생성일 시점 2일 이내
				&nbsp;<img src="/resources/images/icon_y.gif"> 생성일 시점 5일 이내
				&nbsp;<img src="/resources/images/icon_r.gif"> 생성일 시점 5일 이내
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
  		<!--div class="btnArea">
			<span class="fl">
				<font style="color: red; size: 12px;"><b>※ 현재일 기준 30일 이내 발주생성 된 품목은 최근 발주여부가 Y로 표기 됩니다.</b></font>
			</span>			
			<span class="btn_10 mr04 fr">
					<a href="/resources/excel/work/MAIN/msds_manual.mp4" download="msds_manual.mp4">물질정보 제출 메뉴얼</a>
			</span>			
		</div-->
<!--내용 종료-->	    
</div>
<%@ include file="/WEB-INF/views/common/include/sellerFooter.jsp" %>
</div>    
</body>
</html>
