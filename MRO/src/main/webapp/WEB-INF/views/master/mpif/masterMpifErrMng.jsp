<%--
**********************************************
* 메뉴 : I/F 관리>I/F진행현황>I/F모니터링
* 화면 : I/F모니터링
* 기능 :
* 프로그램 ID : 
* 담당자 : 
* 착수일 :
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
	String searchYn		= CommonUtil.nvl((String)request.getParameter("search_yn"));
	String buyerCode	= CommonUtil.nvl((String)request.getParameter("st_buyer_code"));
	String buyerName	= CommonUtil.nvl((String)request.getParameter("st_buyer_name"));
	String st_user_check = CommonUtil.nvl((String)request.getParameter("st_user_check"));
	String st_user_dept = CommonUtil.nvl((String)request.getParameter("st_user_dept"));
	String processYN = CommonUtil.nvl((String)request.getParameter("processYN"));
%>
<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var imageG="/resources/images/icon_g.gif";
var imageY="/resources/images/icon_y.gif";
var imageR="/resources/images/icon_r.gif";
var imagePrifC="/resources/images/icon_prif_c.gif";
var imagePrifR="/resources/images/icon_prif_r.gif";
var imagePrifCancel="/resources/images/icon_prif_cancel.gif";
var imagePrifDelete="/resources/images/icon_prif_delete.gif";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";
var cancelRemarkOn="/resources/images/but_icon01.gif";
var cancelRemarkOff="/resources/images/but_icon02.gif";
var searchYn = "<%=searchYn%>";
var processYN ="<%=processYN%>";
// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol : 2};
	initsheet.HeaderMode = {			ColMove : 1,			ColResize : 1		};
	initsheet.Cols = [
		 { Align:"Center",	Width:60,	Edit:false,	EditLen:0,	Hidden:true,	Type:"Status",				Header:"상태",				SaveName:"sStatus"}
		,{ Align:"Center",	Width:30,	Edit:true,	EditLen:30,	Hidden:false,	Type:"DummyCheck",			Header:"",						SaveName:"SELECTED"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"고객사ID",			SaveName:"BUYER_ID"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"고객사코드",			SaveName:"COM_CODE"}
		//,{ Align:"Center",	Width:100,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"고객사명",			SaveName:"COM_NAME_LOC"}
		,{ Align:"Center",	Width:150,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"유형",			SaveName:"IF_TYPE"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"오류건수",			SaveName:"ERR_CNT"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Image",				Header:"상태(ON/OFF)",			SaveName:"IF_STATUS_IMG"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:95,	Hidden:true,	Type:"Text",				Header:"상태(ON/OFF)",			SaveName:"IF_STATUS"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"실행주기",			SaveName:"EX_TERM"}
		,{ Align:"Center",	Width:160,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"최근실행시간",			SaveName:"LAST_UPDATE_DATE"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"전송방향",			SaveName:"IF_DIRECTION"}
		,{ Align:"left",	Width:300,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"PROGRAM_ID",			SaveName:"PROGRAM_ID"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:95,	Hidden:true,	Type:"Text",				Header:"TASK_GUBUN",			SaveName:"TASK_GUBUN"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:95,	Hidden:true,	Type:"Text",				Header:"TASK_ORDER",			SaveName:"TASK_ORDER"}
		,{ Align:"Center",	Width:60,	Edit:false,	EditLen:95,	Hidden:true,	Type:"Text",				Header:"PROCESS_GUBUN",			SaveName:"PROCESS_GUBUN"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Image",				Header:"집계상태",			SaveName:"CHECKING_IMG"}
		,{ Align:"Center",	Width:80,	Edit:false,	EditLen:95,	Hidden:true,	Type:"Text",				Header:"집계상태값",			SaveName:"CHECKING"}
	];

	IBS_InitSheet(mySheet, initsheet, pagingMode);

	// 상태이미지설정
	mySheet.SetImageList(0, imageG);
	mySheet.SetImageList(1, imageY);
	mySheet.SetImageList(2, imageR);

	// 초기화 설정
	resetValue();
}

// 초기화 설정
function resetValue() {

	$("#st_buyer_code").val("");

}

var st;
var mt;
var count_reload=0;

// 그리드 표시후 처리
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}	


// 기능함수
function doAction(str) {

	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if (str !="search" && str !="all" && str !="reload" && selectedGrid.length == 0 ) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
		case "search": // 조회
			// 조회조건 체크
			if ( !searchValidate() )
				return;
			current_page = -1;
			count_reload++;
			$("#job_kind").val("");
			kepSearch(document.searchCondition, mySheet, "/mpif/getMasterMpifErrMng.do", pagingMode);

			if(count_reload == 1){
				window.setInterval("doAction('search')",60000*5);
			}
			break;

		case "reload": // 초기화
			kepReload('searchCondition');
			resetValue();
			mySheet.RemoveAll();
			break;
			
		case "partial": // 부분집계
		
			var arrRow = selectedGrid.split("|");
			for(var i = 0 ; i <arrRow.length; i++){
 	 			if(mySheet.GetCellValue(arrRow[i],'CHECKING') == '1' ){
	 					alert("집계중인 항목이 존재합니다.\n\n고객사코드 : "+mySheet.GetCellValue(arrRow[i],'COM_CODE')+"\n\n유형 : "+mySheet.GetCellValue(arrRow[i],'IF_TYPE'));
	 					return;
	 			}
			}
			if (!confirm('선택한 항목의 부분집계를 실행하시겠습니까?')){
				return;
			}
			$("#job_kind").val("save");
			kepSave(document.searchCondition, mySheet, "/mpif/runMasterMpifErrMngSubTotal.do", "SELECTED");
			break;
			
		case "all": // 전체집계
			if (!confirm('전체집계를 실행하시겠습니까?')){
				return;
			}
			$("#job_kind").val("save");
			kepSearch(document.searchCondition, mySheet, "/mpif/runMasterMpifErrMngTotal.do");
		    kepSearch(document.searchCondition, mySheet, "/mpif/getMasterMpifErrMng.do", pagingMode);
			break;
			
	}
}

function doPop(str, params) {
	popupSel = str;

	switch (str) {
		case "masterWmCoTranBuyerPop": // 다중 거래고객사
			var st_user_dept = $("#st_user_dept").val();
			var ischecked = $("#st_user_check").is(":checked");
			var check_yn = '';
			if ( ischecked ) {
				check_yn = "Y";
			} else {
				check_yn = "N";
			}
// 			kepOpenSearchPopup(popupSel, '?st_user_dept='+st_user_dept+'&st_user_check='+check_yn);
			openSearchPopup("/wmco/showMasterWmCoTranBuyerPop.do", "?st_user_dept="+st_user_dept+"&st_user_check="+check_yn+'&Gubun=PO', "500,500,no");
			break;

		case "buyerMulti": // 다중 고객사
 	        //openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=Y", "500,466,no"); // 1Grid
	         openSearchPopup('/common/safetyCompanyCodePop.do','?COM_TYPE=B', '880,450,no'); // 2Grid
			break;
		
		
	}
}
// 조회조건 체크
function searchValidate() {

	return true;
}

// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}


	if (msg != "") {
		alert(msg);
	}

	if ( current_page == -1 ) {
		makePageIndex2(mySheet, 1, document.searchCondition.onepagerow.value);
	}
	else {
		makePageIndex2(mySheet, current_page, document.searchCondition.onepagerow.value);
	}
	
	for( var k = 1;  k<mySheet.GetTotalRows()+1 ; k++ ) {
		
		// 글자
		if ( mySheet.GetCellValue(k, "ERR_CNT") > 0 ) {
			mySheet.SetCellFontColor(k,"ERR_CNT","#FF0000");
			mySheet.SetCellFontBold(k,"ERR_CNT",1);
		}
		
	}


}

// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}

	if ( msg != "" ) {
		alert(msg);
	}

	if ( code >= 0 ) {
		doAction("search");
	}
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param) {
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition, mySheet, "/mpif/getMasterMpifErrMng.do?page="+current_page , pagingMode);
}

// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;

	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == "CMS_CATLG_ID" ){ 
		popupSel = "stndCatlg";
		
		var st_buyer = mySheet.GetCellValue(Row, "BUYER");
		var st_quotation_no = mySheet.GetCellValue(Row, "QUOTATION_NO");
		var st_quotation_seq = mySheet.GetCellValue(Row, "QUOTATION_SEQ");
		var st_revision = mySheet.GetCellValue(Row, "REVISION");

		openSearchPopup("/mprq/showMasterMpRqStndCatalgListPop.do","?st_buyer="+st_buyer+"&st_quotation_no="+st_quotation_no+"&st_quotation_seq="+st_quotation_seq+"&st_revision="+st_revision+"&st_type=RCMD&st_row_no="+Row,"900,800,no");
	} 

	return;
}

function setPopupReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9,value10
		,value11,value12,value13,value14,value15,value16,value17,value18,value19,value20
		,value21,value22,value23,value24,value25,value26,value27,value28,value29,value30){

	// 팝업 조회후 해당 항목에 값을 셋팅
	if ( popupSel == "masterWmCoTranBuyerPop" ) { // 다중 거래고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
	} else if ( popupSel == "buyerMulti" ) { // 다중 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(kepMultiName(value2,"@"));
	}
	
	grbRow="";	//초기화
}

</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
	<!--버튼영역-->
	<div id="searchBtnA"  >
		<h3>인터페이스 모니터링 현황</h3>
		<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span>
	    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
	</div>

	<!--조회영역-->
    <form name = "searchCondition" method = "post" onsubmit="return false" >
		<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_user_name_loc" name="st_user_name_loc"  value="${sessionInfo.userNameLoc}">
			<input type="hidden" id="job_kind" name="job_kind" value="">
			<input type="hidden" id="st_cancel_remark" name="st_cancel_remark" value="">
			<input type="hidden" id="st_suser_name" name="st_suser_name" value="">

           	<table  class="cont_t_list01">
				<caption>인터페이스 모니터링 현황</caption>
				<colgroup>
					<col width="8%" />
					<col width="20%" />
					<col width="8%" />
					<col width="20%" />
					<col width="8%" />
					<col width="20%" />
				</colgroup>

				<tbody>
					<tr>
						<th>고객사</th>
						<td>
							<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:70%" value="" readonly onclick="javascript:doPop('buyerMulti','');">
							<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:80%" value="">
							<a href="javascript:doPop('buyerMulti','');"><img src="/resources/images/btn_search03.gif"></a>
							<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
						</td>
						<th>고객사ID</th>
						<td>
							<input type="text" id="st_buyer_id" name="st_buyer_id" style="width:80%;" value="">
						</td>
					</tr>
					<tr>
						<th>오류여부</th>
						<td>
							<select id="st_error_flag" name="st_error_flag" style="width:80%">
								<option value="">전체</option>
								<option value="Y">오류</option>
								<option value="N">정상</option>
							</select>
						</td>
						<th>중지여부</th>
						<td>
							<select id="st_if_status_flag" name="st_if_status_flag" style="width:80%">
								<option value="">전체</option>
								<option value="OFF">중지</option>
								<option value="ON">정상</option>
							</select>
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
		</span>
		<span class="fl">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
		<span class="fl">
			<img src="/resources/images/icon_g.gif" style="padding-top:3px;"/>&nbsp;<b>On</b>&nbsp;&nbsp;
			<img src="/resources/images/icon_r.gif" style="padding-top:3px;"/>&nbsp;<b>Off</b>&nbsp;&nbsp;
			<img src="/resources/images/icon_y.gif" style="padding-top:3px;"/>&nbsp;<b>집계중</b>&nbsp;&nbsp;
		</span>
		<br>
	</form>

    <!--grid-->
   	<div class="ib_product" style="border-top:2px solid #3c639c">
		<script type="text/javascript">
			createIBSheet("mySheet", "100%", "333px");
		</script>
  	</div>
  	<p class="paging" id="pageindex"></p>

	<!--버튼영역-->
	<div class="btnArea">
  		<span class="fr">
  			<span class="btn_04 mr04"><a href="javascript:doAction('partial');">부분집계</a></span>
			<span class="btn_04 mr04"><a href="javascript:doAction('all');">전체집계</a></span>
  		</span>
	</div>
<!--내용 종료-->

</body>
</html>
