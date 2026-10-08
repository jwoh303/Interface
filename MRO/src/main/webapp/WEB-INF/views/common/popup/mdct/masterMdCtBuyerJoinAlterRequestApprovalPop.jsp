<%--
**********************************************
* 메뉴 : 
* 화면 : 고객사 가입/변경요청 승인 
* 기능 : 고객사의 등록요청 정보를 승인처리
* 프로그램 ID : PG_01_M_001_01
* 담당자 : 이수영 ( 설계 : 권우재 )
* 착수일 : 2014-06-05
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
List<Map<String,String>> _dataAreaList = (List<Map<String,String>>) request.getAttribute("dataDelyArea"); // 조회된 납품가능 지역

String userID = _sessionInfo.getUserId();
String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
String sessionEmpNo = _sessionInfo.getEmpNo();

//String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
//String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"), "3");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.

Map<String,String> _rowData = null;
if (_dataList != null && _dataList.size() != 0) { 
	_rowData = _dataList.get(0);
}
String irs_no_temp = CommonUtil.nvl(_rowData.get("IRS_NO").substring(4, 6));

%>

<script type="text/javascript">
<!--
var mySheet = new ibsheetObject();
var mySheet2 = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";
var button_flag = "";
var id_check_flag = "N";
var manageDept = KepSheetComboQueryIdData('common.getMdcdBuyerCardManageDeptList','SEL','');	// IBSHEET : 담당부서

//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	<% if (_dataList.size() == 0) { %>
		alert("고객사 사용자 정보가 없습니다.\n\n관리자에게 문의 하십시요.");
		self.close();
		return;
	<% } %>

	var initsheet = {};
	initsheet.Cols = [
					 {Align:"Center",	SaveName:"sStatus",			Header:"상태",		Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}
					,{ Align:"Center",	SaveName:"SELECTED",		Header:"",			Type:"DummyCheck",	Width:60,	Edit:true,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"COM_CODE",		Header:"고객사코드",	Type:"Text",		Width:90,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"YEAR",			Header:"년도",		Type:"Text",		Width:40,	Edit:false,	EditLen:4,		Hidden:false}
					,{ Align:"Center",	SaveName:"KEP_DEPT",		Header:"담당부서",		Type:"Combo",		Width:120,	Edit:false,	EditLen:100,	Hidden:false,	ComboText:manageDept.ComboText, 	ComboCode:manageDept.ComboCode}
					,{ Align:"Center",	SaveName:"POSITION_GROUP",	Header:"업무",		Type:"Combo",		Width:35,	Edit:false,	EditLen:2,		Hidden:false,	ComboText:"BM|PM", 			ComboCode:"BM|PM"}
					,{ Align:"Center",	SaveName:"KEP_USER_ID",		Header:"담당자ID",	Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"KEP_USER_NAME",	Header:"담당자",		Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"PRIORITY",		Header:"메인담당자",	Type:"Radio",		Width:100,	Edit:true,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"ITEM_GROUP",		Header:"업무구분",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"MAIN_CLERK_YN",	Header:"영업",		Type:"Text",		Width:35,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"PRIORITY_YN",		Header:"운영",		Type:"Text",		Width:35,	Edit:false,	EditLen:100,	Hidden:false}
	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	mySheet.SetCountPosition(4); // 데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]

	//하이퍼링크 설정
	setLinkCol(mySheet, "KEP_DEPT_NM");		//부서명
	kepSetCalender("establish_date");
	
	var initsheet2 = {};
	initsheet2.Cols = [
					 {Align:"Center",	SaveName:"sStatus",					Header:"상태",					Type:"Status",			Width:60,		Edit:false,	EditLen:0,		Hidden:true}
					,{ Align:"Center",	SaveName:"SELECTED",					Header:"",							Type:"DummyCheck",	Width:40,		Edit:true,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"SG_ID",				Header:"SG코드",			Type:"Text",				Width:100,		Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"SG_NAME",						Header:"SG명",					Type:"Text",				Width:150,		Edit:false,	EditLen:4,		Hidden:false}
					,{ Align:"Center",	SaveName:"SG_SM_NM",		Header:"SM",				Type:"Text",				Width:180,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"SG_DSM_NM",		Header:"DSM",				Type:"Text",				Width:180,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Right",	Width:150,	Edit:true,	EditLen:100,	Hidden:false,	Type : "Float",	 Format:"${priceFormat}", 	Header:"SG매익율",	SaveName:"MARGIN",	Sort:0,		KeyField:true,		BackColor:"${notnullColor}"}
					,{ Align:"Center",	SaveName:"BUYER",		Header:"BUYER",				Type:"Text",				Width:180,	Edit:false,	EditLen:100,	Hidden:true}
	];
	
	IBS_InitSheet(mySheet2, initsheet2, pagingMode);
	mySheet2.SetCountPosition(4); // 데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]
	mySheet2.SetCellFontUnderline(0, "MARGIN", true);
	
	doAction("search");
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		kepSearch();
	}
}

function setReturn(value1,value2)
{ 
	opener.setPopupReturn(value1,value2);
	this.close();
}

//팝업함수호출
function doPop(str,key) {
	popupSel = str;
	
	switch (str) {
		case "kepBusinessItem": // 고객사 업종선택
			openSearchPopup("/coco/getCommonCoCoBuyerBusnstypeClassifyPop.do", "", "750,450,no");
			break;
	 	/* case "zipcode": //ICOMPOST 테이블 이용하여 우편번호 검색 김영훈 
			openSearchPopup("/common/zipCodeSearchPop.do", "?1=1", "500,666,no");			
			break; */
		case "newzipcode": //우편번호 검색
			openSearchPopup("/common/newZipCodeSearchPop.do", "?1=1", "554,481,no");			
			break;
		case 	"fileUpload": //파일업로드
			openSearchPopup("/common/fileUploadPop.do","?DOC_NO="+$("#st_image_key").val(), "500,430,no");
			break;
		case "kepDamdang":		// KeP담당자
			openSearchPopup("/mdcp/getMasterMdCpUserChoicePop.do", "?st_buyer=KRKORE0001", "500,500,no");
			break;
		case "dept":
			openSearchPopup("/common/deptCodeAdminPop.do", "?com_code=KRKORE0001&open=Y", "500,500,no");			
			break;	
		case "kepCorpCcode": //고객사 법인그룹선택
			openSearchPopup("/mdct/showMasterMdctBuyerCorpGroupPop.do", "", "500,500,no");
			break;
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text) {
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "kepBusinessItem") {	// 다중 고객사
		$("#st_kep_business_item").val(code);
		$("#st_kep_business_item_text").val(text);
	} else if (popupSel == "zipcode") {
		$("#st_zip_code").val(code);
		$("#st_address").val(text);
	} else if (popupSel == "fileUpload") {
		$("#st_image_key").val(code);
		$("#st_image_key_text").val(text);
	} else if (popupSel == "kepDamdang") {	// 다중 고객사
		mySheet.SetCellValue(grbRow,"KEP_USER_ID", code);
		mySheet.SetCellValue(grbRow,"KEP_USER_NAME", text);
	} else if (popupSel == "newzipcode") {
		$("#st_zip_code").val(code);
		$("#st_address").val(text);
	}else if (popupSel == "kepCorpCcode") {
		$("#st_corp_code").val(code);
		$("#st_corp_name").val(text);
	}
	grbRow="";	//초기화
}
/* 
//	ICOMPOST 테이블 이용하여 우편번호 검색 김영훈 
function setZipPopupReturn(str_zipcode, str_zip_key, str_sido, str_gugun, str_roadNm, str_buildingNo, str_buildingName, str_dong) {
	$("#st_zip_code").val(str_zipcode);
	$("#st_zip_key").val(str_zip_key);
	$("#st_address").val(str_sido + " " + str_gugun + " " + str_roadNm + " " + str_buildingNo);
	$("#st_address_dt").val(str_buildingName);
}
 */
 
function jusoCallBack(roadFullAddr,roadAddrPart1,addrDetail,roadAddrPart2,engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn){
	$("#st_zip_code").val(zipNo.replace(/[^0-9]/gi, ''));
	$("#st_zip_key").val(bdMgtSn);
	$("#st_address").val(roadAddrPart1 + " " + roadAddrPart2);
	$("#st_address_dt").val(addrDetail);
	$("#st_address_loc").val(roadAddrPart1 + " " + roadAddrPart2 + " " + addrDetail);
} 
var st;
var mt;

//기능함수
function doAction(str, flag) {
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");
	button_flag = flag;
	
	if (str =="del"  && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}
	
	switch (str) {
		case "search":
			current_page = -1;
			kepSearch(document.searchForm, mySheet, "/mdct/getMasterMdCtBuyerJoinAlterRequestApprovalChargeEntryList.do" , pagingMode );
			kepSearch(document.searchForm, mySheet2, "/mdct/getMasterMdCtBuyerJoinAlterMarginList.do" , pagingMode );
			break;
		case "insert":	 // 조회
			var rows = mySheet.DataInsert(-1);
			mySheet.SetCellValue(rows, "YEAR", st.getFullYear());
			mySheet.SetCellValue(rows, "COM_CODE", $("#com_code").val());
			mySheet.SetCellEditable(rows, "POSITION_GROUP", 1);
			break;
		case "kepsave": // 수정
			if (checkKepSave()) {
				kepSave(document.searchForm, mySheet, "/mdct/saveMasterMdCtBuyerJoinAlterRequestApprovalChargeEntryList.do", -1 );
			}
			break;
		case "kepUserIDCheck":			//  담당자 중복체크
			kepAjaxFormCall("/mdct/selectMasterMdCtBuyerJoinAlterRequestApprovalChargeEntryUserIdCheck.do", "searchForm", str);
			break;
		case "del":					// 고객사별 담당자 삭제
			if (checkKepDelete()) {
				var delCnt = 0;

				for (var i = arrRow.length-1; i >= 0; i--) {
					if (mySheet.GetCellValue(arrRow[i], "sStatus") == "I") {
						mySheet.RowDelete(arrRow[i], 0);
					} else {
						delCnt++;
					}
				}

				if (delCnt > 0) {
					kepSave(document.searchForm, mySheet, "/mdct/deleteMasterMdCtBuyerJoinAlterRequestApprovalChargeEntryList.do", 1);
				}
			}
			break;	
		case "save":
			if(button_flag == 'C'){
				for (var i = 1; i <= mySheet2.RowCount(); i++ ) {
					if (mySheet2.GetCellValue(i, "MARGIN") == "") {
						alert(i+"번째 매익율 입력 바랍니다.");
						mySheet2.SelectCell(i, "MARGIN");
						return;
					}
					mySheet2.SetCellValue(i,"SELECTED" ,"1");
				}
			}
			if (checkSubmit(flag)) {
				if(button_flag == 'C'){
					gw_aprv();
				}
				kepAjaxFormCall("/mdct/saveMasterMdCtBuyerJoinAlterRequestApprovalPop.do","masterMdCtBuyerJoinAlterRequestApprovalPop","APPROVALSAVE");
			}
			break;
		case "marginsave": // 수정
			for (var i = 1; i <= mySheet2.RowCount(); i++ ) {
				if (mySheet2.GetCellValue(i, "MARGIN") == "") {
					alert(i+"번째 매익율 입력 바랍니다.");
					mySheet2.SelectCell(i, "MARGIN");
					return;
				}
			}
			kepSave(document.searchForm, mySheet2, "/mdct/saveMasterMdCtBuyerJoinAlterSgMarginList.do", "SELECTED");
			break;
	}
}

function gw_aprv(){
	
	var bodyContents =
		"<style>.SmallTB{border:1px solid #000; font-size:12px}.SmallTB th{ text-align:center; background-color:#e8f3f9;border-right:1px solid #000;border-bottom:1px solid #000;}.SmallTB td{ height:25px;border-bottom:1px solid #000; padding-left:5px}</style>" +
		"<table class=\"SmallTB\" cellSpacing=\"0\" cellPadding=\"0\" width=\"100%\">"+
		"<tbody>"+
		"<colgroup>"+
		"<col width=\"14%\" />"+
		"<col width=\"15%\" />"+
		"<col width=\"28%\" />"+
		"<col width=\"15%\" />"+
		"<col width=\"28%\" />"+
		"</colgroup>"+
		"<tr >"+
		"<th rowSpan=\"2\" >회사정보</th>"+
	    "<th >회사명</th>"+
	    "<td style=\"border-right:1px solid #000;\"><%=CommonUtil.nvl(_rowData.get("COM_NAME_LOC"))%></td>"+
	    "<th >회사코드</th>"+
	    "<td ><%=CommonUtil.nvl(_rowData.get("COM_CODE"))%></td>"+
	    "</tr>"+
	    "<tr >"+
	    "<th >대표자명</th>"+
	    "<td style=\"border-right:1px solid #000;\"><%=CommonUtil.nvl(_rowData.get("CEO_NAME_LOC"))%></td>"+
	    "<th >사업자번호</th>"+
	    "<td ><%=CommonUtil.nvl(_rowData.get("IRS_NO"))%></td>"+
	    "</tr>"+
	    "<tr >"+
	    "<th >담당부서</th>"+
	    "<th style=\"border-right:1px solid #000;\">부서명</th>"+
	    "<td colspan=\"3\"></td>"+
	    "</tr>"+
	    "<tr >"+
	    "<th style=\"border-bottom:1px solid #000;\"  >담당자정보</th>"+
	    "<th style=\"border-bottom:1px solid #000;\" >BM</th>"+
	    "<td style=\"border-bottom:1px solid #000;border-right:1px solid #000;\" ></td>"+
	    "<th style=\"border-bottom:1px solid #000;\" >PM</th>"+
	    "<td style=\"border-bottom:1px solid #000;\" ></td>"+
	    "</tr>"+
	    "<tr>"+
	  	"<th style=\"border-bottom:0px solid #000;\">비 고</th>"+
	    "<td style=\"height:100px; vertical-align:top;border-bottom:0px solid #000;\" colspan=\"4\" ></td>"+
	  	"</tr>"+
	    "</tbody>"+
	    "</table>"
	    ;
	
	var form = document.createElement("form");
	form.setAttribute("method", "post");
	form.setAttribute("target", "_blank");
	form.setAttribute("action", "https://gw.koreab2b.com/jsp/kep_linkage/InQdbData.jsp");
	var hiddenField01 = document.createElement("input");
	hiddenField01.setAttribute("type", "hidden");
	hiddenField01.setAttribute("name", "DrafterCode");
	hiddenField01.setAttribute("value", "<%=sessionEmpNo%>");	
	form.appendChild(hiddenField01);
	
	var hiddenField02 = document.createElement("input");
	hiddenField02.setAttribute("type", "hidden");
	hiddenField02.setAttribute("name", "FormID");
	hiddenField02.setAttribute("value", "JHOMS160070008591000,LINK001");
	form.appendChild(hiddenField02);
	
	var hiddenField03 = document.createElement("input");
	hiddenField03.setAttribute("type", "hidden");
	hiddenField03.setAttribute("name", "LinkageKey");
	hiddenField03.setAttribute("value", "B01");
	form.appendChild(hiddenField03);
	
	var hiddenField04 = document.createElement("input");
	hiddenField04.setAttribute("type", "hidden");
	hiddenField04.setAttribute("name", "LinkageSub1");
	hiddenField04.setAttribute("value", "<%=CommonUtil.nvl(_rowData.get("COM_CODE"))%>");
	form.appendChild(hiddenField04);
	
	var LinkageSub2 = document.createElement("input");
	LinkageSub2.setAttribute("type", "hidden");
	LinkageSub2.setAttribute("name", "LinkageSub2");
	LinkageSub2.setAttribute("value", "<%=CommonUtil.nvl(_rowData.get("USER_ID"))%>");
	form.appendChild(LinkageSub2);
	
	var LinkageSub3 = document.createElement("input");
	LinkageSub3.setAttribute("type", "hidden");
	LinkageSub3.setAttribute("name", "LinkageSub3");
	LinkageSub3.setAttribute("value", "");
	form.appendChild(LinkageSub3);
	
	var LinkageSub4 = document.createElement("input");
	LinkageSub4.setAttribute("type", "hidden");
	LinkageSub4.setAttribute("name", "LinkageSub4");
	LinkageSub4.setAttribute("value", "");
	form.appendChild(LinkageSub4);
	
	var LinkageSub5 = document.createElement("input");
	LinkageSub5.setAttribute("type", "hidden");
	LinkageSub5.setAttribute("name", "LinkageSub5");
	LinkageSub5.setAttribute("value", "");
	form.appendChild(LinkageSub5);			
	
	var hiddenField05 = document.createElement("input");
	hiddenField05.setAttribute("type", "hidden");
	hiddenField05.setAttribute("name", "SancTitle");
	hiddenField05.setAttribute("value", "[koreab2b] 신규고객사 등록 품의");
	form.appendChild(hiddenField05);
	
	var SacnBodyType = document.createElement("input");
	SacnBodyType.setAttribute("type", "hidden");
	SacnBodyType.setAttribute("name", "SacnBodyType");
	SacnBodyType.setAttribute("value", "TEXT");
	form.appendChild(SacnBodyType);	
	
	var hiddenField06 = document.createElement("input");
	hiddenField06.setAttribute("type", "hidden");
	hiddenField06.setAttribute("name", "SancBody");
	hiddenField06.setAttribute("value", bodyContents);
	form.appendChild(hiddenField06);
	
	var AttachYN = document.createElement("input");
	AttachYN.setAttribute("type", "hidden");
	AttachYN.setAttribute("name", "AttachYN");
	AttachYN.setAttribute("value", "N");
	form.appendChild(AttachYN);
	
	var AttachInfo = document.createElement("input");
	AttachInfo.setAttribute("type", "hidden");
	AttachInfo.setAttribute("name", "AttachInfo");
	AttachInfo.setAttribute("value", "");
	form.appendChild(AttachInfo);
	
	document.charset="UTF-8";
	document.body.appendChild(form);
	form.submit();
	
	// 그룹웨어 전송 후 캐릭터 셋 복원
	document.charset="utf-8";
	//aodlr
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	return;
}

function mySheet_OnChange(Row, Col, Value) {

	if ( Row  < 1) return;
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

}
//그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}
	
// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	
	//납품가능지역 데이터 셋팅
	var st_cmpy_dely_area = $("#st_cmpy_dely_area").val();
	if(st_cmpy_dely_area == null || st_cmpy_dely_area =="") return;
	var str_area_list = st_cmpy_dely_area.split("");
	var tot_cnt = $("#st_cmpy_dely_cnt").val();
	// 파라미터 선택된 값 체크하기
	for(var i=0; i< tot_cnt; i++){
		if(str_area_list[i] == "Y"){
			document.getElementById("st_dely_area_flag"+i).checked = true;
		}else{
			document.getElementById("st_dely_area_flag"+i).checked = false;
		}
	}

	if (msg != "") {
		alert(msg);
	}

	if (current_page==-1) {
		makePageIndex2(mySheet, 1, document.searchForm.onepagerow.value);
	} else {
		makePageIndex2(mySheet, current_page, document.searchForm.onepagerow.value);	
	}
}
	
// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if (msg != "") {
		alert(msg);
	}
	
	if (code > 0) {
		//저장 성공시 재조회
		doAction('search');
	}
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param) {
	//조회
	current_page = param.page;
	kepSearch(document.searchForm ,  mySheet , "/mdct/getMasterMdCtBuyerJoinAlterRequestApprovalChargeEntryList.do?page="+current_page , pagingMode );
}

//트랜젝션(저장,삽입등) 후처리
function mySheet2_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if (msg != "") {
		alert(msg);
	}
	
	if (code > 0) {
		//저장 성공시 재조회
		doAction('search');
	}
}
/**
* ajax 공통 호출후 성공시 처리 함수
*/ 
function kepAjaxSuccess(pMethod , response) {
	var sMsg = response.msg;    
	
	if (pMethod == "APPROVALSAVE") {
		if (sMsg == 'OK') {
			if (button_flag != "C") {
				alert("정상적으로 저장 완료 되었습니다.");
			}
			kepSave(document.searchForm, mySheet2, "/mdct/saveMasterMdCtBuyerJoinAlterSgMarginList.do", "SELECTED");
			opener.setPopupReturn("","");
			self.close();
		} else {
			if (flag != "C") {
				alert("회원사 및 Admin 사용자 저장이 실패 하였습니다.\n다시 확인하여 주십시요!");
			}
		}
	}
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
} 

//변경 여부 체크
function checkRow() {
	var check = true;

	for (var i = 1; i <= mySheet.RowCount(); i++ ) {
		if (mySheet.GetCellValue(i, "sStatus") != 'R' ) {
        	check = false;
        	break;
		}
	}
	if (check) {
		alert("추가된 행이 없습니다.");
		return false;
	}
	return true;
}

function checkKepDelete() {
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");
	var mainCnt = 0;
	
	for (var i = 0; i < arrRow.length; i++) {
		if (mySheet.GetCellValue(arrRow[i], "PRIORITY") == 1) {
			mainCnt++;
		}
	}
	
	if (mainCnt > 0) {
		alert("메인담당자는 삭제 할수 없습니다.\n메인담당자 변경후 삭제 하십시요.");
		return false;
	}
	return confirm("KeP담당자를 삭제하시겠습니까?");	
}

function checkKepSave() {
	if (!checkRow()) return false;
	var priorityCnt = 0;
	
	for (var i = 1; i <= mySheet.RowCount(); i++ ) {

		if (mySheet.GetCellValue(i, "sStatus") != 'R' ) {
			if (kepTrimStr(mySheet.GetCellValue(i, "KEP_DEPT")) == "") {
				alert("담당부서를 선택해주세요.");
				mySheet.SelectCell(i, "KEP_DEPT");
				return false;
			}
			
			if (kepTrimStr(mySheet.GetCellValue(i, "POSITION_GROUP")) == "") {
				alert("업무구분을 입력해주세요.");
				mySheet.SelectCell(i, "POSITION_GROUP");
				return false;
			}

			if (kepTrimStr(mySheet.GetCellValue(i, "KEP_USER_ID")) == "") {
				alert("담당자를 선택해주세요.");
				mySheet.SelectCell(i, "KEP_USER_ID");
				return false;
			}
		}
		
		if (mySheet.GetCellValue(i, "PRIORITY") == 1) {
			priorityCnt++;
		}
	}
	
	if (priorityCnt == 0) {
		alert("메인담당자가 없습니다.\n메인담당자를 선택해 주세요.");
		return false;
	}

	return confirm("KeP 담당자를 저장하시겠습니까?");
}


function checkSubmit(flag) {
	var irs_no_check = <%=irs_no_temp%>;
	
	if (isEmpty($("#st_com_name_loc").val())) {
        alert("한글회사명을 입력해주세요.");
        $("#st_com_name_loc").focus();
        return false;
	}

	if (isEmpty($("#st_com_name_eng").val())) {
		alert("영문회사명을 입력해주세요.");
		$("#st_com_name_eng").focus();
        return false;
	}
	
    //영문 회사명 Check
	if ( $("#st_com_name_eng").val().length < chkKorea($("#st_com_name_eng").val())) {
		alert("회사명(영문)을 영문으로 입력해 주십시요.");
		$("#st_com_name_eng").focus();
		return false;
	}

	if ( $("#st_com_name_eng").val().length < 1) { 
		alert("회사명(영문)을 입력해 주십시요.");
		$("#st_com_name_eng").focus();
		return false;
	}
	
	if(isEmpty($("#st_corp_name").val())) {
		alert("법인그룹을 선택해 주십시요.");
		$("#st_corp_name").focus();
		return false;
	}
	
	
    if (isEmpty($("#st_ceo_name_loc").val())) {
		alert("대표자(국문)를 입력해주세요.");
		$("#st_ceo_name_loc").focus();
		return false;
	}

	if (isEmpty($("#st_ceo_name_eng").val())) {
		alert("대표자(영문)를 입력해주세요.");
		$("#st_ceo_name_eng").focus();
		return false;
	}

	if ( $("#st_ceo_name_eng").val().length < chkKorea($("#st_ceo_name_eng").val())) {
		alert("대표자(영문)를 영문으로 입력해 주십시요.");
		$("#st_ceo_name_eng").focus();
		return false;
	}

	if (isEmpty($("#st_tel_no").val())) {
		alert("대표전화번호를 입력해 주십시요.");
		$("#st_tel_no").focus();
		return false;
	}

	if (isEmpty($("#st_industry_type").val())) {
		alert("업태을 입력해 주십시요.");
		$("#st_industry_type").focus();
		return false;
	}

	if (isEmpty($("#st_business_items").val())) {
		alert("종목을 입력해 주십시요.");
		$("#st_business_items").focus();
		return false;
	}

	if (isEmpty($("#st_zip_code").val())) {
		alert("우편번호를 입력해 주십시요.");
		$("#st_zip_code").focus();
		return false;
	}
	
	if (isEmpty($("#st_address").val())) {
		alert("주소를 입력해 주십시요");
		$("#st_address").focus();
		return false;
	}

	if ( $("#st_address_eng").val().length < chkKorea($("#st_address_eng").val())) {
		alert("영문주소를 영문으로 입력해 주십시요.");
		$("#st_address_eng").select();
		return false;
	}
	
	if(irs_no_check == "81" || irs_no_check == "82" || irs_no_check == "83" || irs_no_check == "84" ||
			irs_no_check == "85" || irs_no_check == "86" || irs_no_check == "87" || irs_no_check == "88") {
			
		if($("#st_corp_reg_no_1").val() == "" || $("#st_corp_reg_no_2").val() == "") {
			alert("법인등록번호 필수 대상 고객사입니다. 법인등록번호 입력 바랍니다.");
			$("#st_corp_reg_no_1").focus();
			return false;
		}		
	}

	if ( $("#st_corp_reg_no_1").val() != "" && $("#st_corp_reg_no_2").val() != "" ) {
		$("#st_corp_reg_no").val($("#st_corp_reg_no_1").val() + "-" + $("#st_corp_reg_no_2").val());
	}

	if ($("#st_pay_terms").val() == "") {
		alert("수금조건을 선택해 주십시요.");
		$("#st_pay_terms").focus();
		return false;
	}
	
	if ($("#st_pay_type").val() == "") {
		alert("수금형태를 선택해 주십시요.");
		$("#st_pay_type").focus();
		return false;
	}
    
	$("#st_establish_date").val($("#establish_date").val().replace(/[/]/gi,""));
	$("#st_contract_expire_date").val($("#contract_expire_date").val().replace(/[/]/gi,""));
	
	if (isEmpty($("#st_kep_business_item").val())) {
		alert("고객사 관리 업종을 선택하여 주십시요.");
		return false;
	}
	<% if (_dataList.size() > 0) { %>
	<% if (CommonUtil.nvl(_rowData.get("STATUS")).equals("S")) { %>
	
	if (isEmpty($("#st_user_name_loc").val())) {
		alert("사용자명을 입력해 주십시요");
		$("#st_user_name_loc").focus();
		return false;
	}
	
	if (isEmpty($("#st_user_name_eng").val())) {
		alert("사용자 영문명을 입력해 주십시요");
		$("#st_user_name_eng").focus();
		return false;
	}
	
	if (isEmpty($("#st_mobile_phone").val())) {
		alert("사용자 핸드폰번호를 입력해 주십시요");
		$("#st_mobile_phone").focus();
		return false;
	}
	
	if(isEmpty($("#st_email").val())) {
		alert("사용자 E-MAIL을 입력해 주십시요");
		$("#st_email").focus();
		return false;
	}
	
	if (!checkemail("st_email")) {
		return false;
	}
	
	if (isEmpty($("#st_phone_number").val())) {
		alert("사용자 전화번호를 입력해 주십시요");
		$("#st_phone_number").focus();
		return false;
	}
	<% } %>
	<% } %>
	
	if (kepTrim("st_from_date") != "" || kepTrim("st_to_date") != "" || kepTrim("st_contract_flag") != "" || kepTrim("st_rate_gubun") != "" || kepTrim("st_rate_edit_flag") != "") {
		
		if (kepTrim("st_from_date") == "") {
			alert("매익율 시작월을 선택해주세요.");
			$("#st_from_date").focus();
			return false;
		}
		
		if (kepTrim("st_to_date") == "") {
			alert("매익율 종료월을 선택해주세요.");
			$("#st_to_date").focus();
			return false;
		}
		
		if (kepTrim("st_from_date").replace("/","") > kepTrim("st_to_date").replace("/","")) {
			alert("매익율 종료월은 시작월보다 이전월일 수 없습니다.");
			$("#st_to_date").focus();
			return false;
		}
		
		if (kepTrim("st_contract_flag") == "") {
			alert("계약방식을 선택해주세요.");
			$("#st_contract_flag").focus();
			return false;
		}
		
		if (kepTrim("st_contract_flag") == "F") {
			if ($("#st_rate").val() == "") {
				alert("매익율을 입력해주세요.");
				$("#st_rate").focus();
				return false;
			}
			
			if (	!chkDecimal(kepTrim("st_rate"), 2)) {
				alert("매익율은 소숫점 2자리로 입력해주세요.");
				$("#st_rate").focus();
				return false;
			}
		}
		
		if (kepTrim("st_rate_gubun") == "") {
			alert("산정구분을 선택해주세요.");
			$("#st_rate_gubun").focus();
			return false;
		}
		
		if (kepTrim("st_rate_edit_flag") == "") {
			alert("수정여부를 선택해주세요.");
			$("#st_rate_edit_flag").focus();
			return false;
		}
		
		
		if (isEmpty($("#st_process_type").val())) {
			alert("거래유형을 선택하여 주십시요.");
			$("#st_process_type").focus();
			return false;
		}
		
		if (isEmpty($("#st_warehouse_code").val()) && $("#st_process_type").val()!= "0") {
			alert("물류센터를 선택하여 주십시요.");
			$("#st_warehouse_code").focus();
			return false;
		}
		//직납이면 강제 물류센터 지정안함
		if ($("#st_process_type").val() == "0") {
			$("#st_warehouse_code").val("");
		}
	}
	//납품가능 지역 데이터 셋팅
	var tmpChoiceArea = "";
	var tot_cnt = $("#st_cmpy_dely_cnt").val();
	for(var i = 0; i < tot_cnt; i++){
		var box = eval("document.forms.masterMdCtBuyerJoinAlterRequestApprovalPop.st_dely_area_flag"+i);
		if(box.checked == true){
			tmpChoiceArea += "Y";
		}else{
			tmpChoiceArea += "N";
		}
	}
	//납품가능지역 데이터 셋팅
	$("#st_cmpy_dely_area").val(tmpChoiceArea);
	
	$("#st_mail_send_flag").val($("input[name=mail_send_flag]:checked").val());
	$("#st_sms_recv_flag").val($("input[name=sms_recv_flag]:checked").val());
	$("#st_delivery_car_info").val($("input[name=delivery_car_info]:checked").val());
	$("#st_contract_auto_renew").val($("input[name=contract_auto_renew]:checked").val());
	$("#st_agent_open_flag").val($("input[name=agent_open_flag]:checked").val());
	$("#st_budget_flag").val($("input[name=budget_flag]:checked").val());
	$("#st_logo_yn").val($("input[name=logo_yn]:checked").val());
	$("#st_ds_flag").val($("input[name=ds_flag]:checked").val());

	$("#st_rcpt_po_flag").val($("input[name=rcpt_po_flag]:checked").val());
	$("#st_fee_base_flag").val($("input[name=fee_base_flag]:checked").val());
	$("#st_mng_no_flag").val($("input[name=mng_no_flag]:checked").val());
	$("#st_mng_no_popup_flag").val($("input[name=mng_no_popup_flag]:checked").val());
	$("#st_office_catlg_flag").val($("input[name=office_catlg_flag]:checked").val());
	$("#st_buyer_catlg_edit_flag").val($("input[name=buyer_catlg_edit_flag]:checked").val());
	$("#st_quotataion_edit_flag").val($("input[name=quotataion_edit_flag]:checked").val());
	$("#st_new_item_pm_flag").val($("input[name=new_item_pm_flag]:checked").val());
	$("#st_exist_act_flag").val($("input[name=exist_act_flag]:checked").val());
	$("#st_auto_confirm_flag").val($("input[name=auto_confirm_flag]:checked").val());
	$("#st_quotataion_batch_flag").val($("input[name=quotataion_batch_flag]:checked").val());
	$("#st_price_confirm_elctr_flag").val($("input[name=price_confirm_elctr_flag]:checked").val());
	$("#st_step2_price_flag").val($("input[name=step2_price_flag]:checked").val());
	$("#st_price_confirm_repl_flag").val($("input[name=price_confirm_repl_flag]:checked").val());
	$("#st_order_confirm_flag").val($("input[name=order_confirm_flag]:checked").val());
	$("#st_order_dept_elctr_flag").val($("input[name=order_dept_elctr_flag]:checked").val());
	$("#st_request_dept_elctr_flag").val($("input[name=request_dept_elctr_flag]:checked").val());
	$("#st_gr_regist_flag").val($("input[name=gr_regist_flag]:checked").val());
	$("#st_auto_gr_flag").val($("input[name=auto_gr_flag]:checked").val());
	$("#st_std_date_flag").val($("input[name=std_date_flag]:checked").val());
	$("#st_multi_quotation_flag").val($("input[name=multi_quotation_flag]:checked").val());
	$("#st_std_invoice_flag").val($("input[name=std_invoice_flag]:checked").val());
	$("#st_five_categ_flag").val($("input[name=five_categ_flag]:checked").val());
	$("#st_vat_flag").val($("input[name=vat_flag]:checked").val());

    var confir = "";
    if (flag == "C") {
		confir = confirm("고객사 승인 품의를 진행하시겠습니까?");
    } else {
		confir = confirm("고객사 저장을 하시겠습니까?");
    }

	$("#st_flag").val(flag);
	
	return confir;
}

//헤더 더블클릭시 복사
function mySheet2_OnDblClick(Row, Col, CellX, CellY, CellW, CellH) { 
	if ( Row > 0 ) return;
	var checkRows = mySheet2.FindCheckedRow("SELECTED");
	if (checkRows.length == 0){
		alert("복사할 행을 선택하여 주십시요.");
		return;
	}
	var arrRow = checkRows.split("|");
	if (mySheet2.ColSaveName(Col) == "MARGIN"){ //매익율
		var value1 = mySheet2.GetCellValue(arrRow[0], "MARGIN");
		if(kepIsValueNull(value1)){
			alert("복사할 매익율을 선택하여 주십시요.");
			return;
		}
		for(var idx=0; idx<arrRow.length; idx++){
			mySheet2.SetCellValue(arrRow[idx], "MARGIN", value1);
		}
	}
}
//거래유형 지정
function set_process_type_value(){
	var st_process_type = $("#st_process_type").val();
	if(st_process_type == "0"){
		$("#st_warehouse_code").val("");
	}
}
//물류센터 지정
function set_warehouse_code_value(){
	var st_process_type = $("#st_process_type").val();
	if(st_process_type == "0"){
		alert("거래유형이 직납일 경우 물류센터 지정 할 필요 없습니다.");
		$("#st_warehouse_code").val("");
	}
}
 //-->
</script> 
<body onload="kep_onload_view();">
<form name="searchForm" id="searchForm" method=post >
<input type="hidden"	id="st_user_id" name="st_user_id" value="<%=userID%>" />
<input type="hidden" id="s_SAVENAME"  name="s_SAVENAME" />
<input type="hidden" id="pageflag" name="pageflag" value="1" />
<input type="hidden" id="com_code" name="com_code" value="<%=com_code%>" />

<%-- <input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" /> --%>
<%-- <input type="hidden" name="onepagerow" id="onepagerow" value="<%=onepagerow %>" /> --%>

</form>

<form name="masterMdCtBuyerJoinAlterRequestApprovalPop" id="masterMdCtBuyerJoinAlterRequestApprovalPop" method=post >
<input type="hidden"	id="com_code"				name="com_code"				value="<%=com_code%>" />
<input type="hidden"	id="st_user_id"				name="st_user_id"				value="<%=userID%>" />
<input type="hidden"	id="st_password_page"	name="st_password_page"	value="PPT" />
<input type="hidden"	id="st_irs_no"				name="st_irs_no"				value = "" />
<input type="hidden"	id="st_flag"					name="st_flag"					value = "" />
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:700px;">
    	<div id="popHeader">
        	<h1 class="title">고객사 가입/변경요청 승인 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        
        <div id="popContainer">
            <div class="scrollArea" style="height:580px;" >
            	<div style="height:280px">
	            	<div style="float:left; width:52%;">
	            		<font style="font-weight:bold;">[고객사 담당자정보]</font>
	            	</div>

	            	<div style="float:left; width:48%;">
	            		<font style="font-weight:bold;">[고객사 견적 관리]</font>
	            	</div>
	            	
	            	<br>
	  				
	  				<div style="float:left; width:48%; border-top:2px solid #3c639c">
		  				<script type="text/javascript">
		  					createIBSheet("mySheet", "100%", "265px");
		  				</script>
	  				</div>
	  				
					<div style="float:right; width:48%;">
	  					<table  class="cont_t_list06" style="width:100%;">
			                <caption>고객사 견적 관리</caption>
			                <colgroup>
			                    <col width="25%" />
			                    <col width="75%" />
			                </colgroup>
			                <tbody>
								<tr>
			                        <th scope="row" class="star">거래유형</th>
			                      	<td>
			                      		<select id="st_process_type" name="st_process_type" style="width:80px;" onChange="set_process_type_value();">
			                      			<option value="" <%=CommonUtil.nvl(_rowData.get("PROCESS_TYPE")).equals("") ? "selected" : "" %>>선택</option>
			                      			<option value="0" <%=CommonUtil.nvl(_rowData.get("PROCESS_TYPE")).equals("0") ? "selected" : "" %>>직납</option>
			                      			<option value="2" <%=CommonUtil.nvl(_rowData.get("PROCESS_TYPE")).equals("2") ? "selected" : "" %>>TR</option>
			                      		</select>
			                      	</td>
			                    </tr>
								<tr>
			                      	<th scope="row" class="star">물류센터</th>
									<td>
										<select id="st_warehouse_code" name="st_warehouse_code" onChange="set_warehouse_code_value();" style="width:90%;"> 
											<script>kepAjaxCommonQueryIdCombo('st_warehouse_code', 'common.mdct.selectMasterMdCtBuyerJoinAlterRequestApprovalWarehouseCode', 'SEL', '<%=CommonUtil.nvl(_rowData.get("WAREHOUSE_CODE")) %>');</script>
										</select>
									</td>
			                    </tr>
								<tr>
			                        <th scope="row">견적<br>특이사항</th>
			                      	<td>
			                      		<textarea id="st_re_note" name="st_re_note" style='width:100%;ime-mode:active; overflow:auto; border-color:white; border-width:0; <%=CommonUtil.nvl(_rowData.get("STATUS")).equals("S") ? "background-color: #FAF9CF;" : "" %>' rows="15" cols="35" <%=CommonUtil.nvl(_rowData.get("STATUS")).equals("S") ? "" : "readonly" %>><%=CommonUtil.nvl(_rowData.get("RE_NOTE"))%></textarea>
			                      	</td>
			                    </tr>
			                </tbody>
			            </table>
	  				</div>
				</div>
				
				<p class="pt20" style="font-weight:bold;">[고객사 상세정보]</P>
	        	<% if (_rowData != null) {  %>
	        	<table  class="cont_t_list06" style="width:100%;">
	                <caption>회원사 정보관리</caption>
	                <colgroup>
	                    <col width="130px" />
	                    <col width="32%" />
	                    <col width="130px" />
	                    <col width="30%" />
	                </colgroup>
	                <tbody>
						<tr>
							<th scope="row">회사코드</th>
	                        <td><%=com_code%></td>	                        	
	                        	<input type="hidden" id="st_sell_close_date" name="st_sell_close_date"  value="" />	                        	
	                        <th class="star" scope="row">법인그룹</th>
	                        <td>
	                        	<input type="hidden" id="st_corp_code" name="st_corp_code"  value="<%=CommonUtil.nvl(_rowData.get("CORP_CODE"))%>" />
	                        	<input type="text" id="st_corp_name" name="st_corp_name" class="input_type_text" title="" style="width:120px;" value="<%=CommonUtil.nvl(_rowData.get("CORP_NAME"))%>"  readonly />
	                        	<a href="javascript:doPop('kepCorpCcode');"><img src="/resources/images/btn_search03.gif"></a>
	                        	<a href="javascript:kepEraser('st_corp_code','st_corp_name');"><img src="/resources/images/btn_eraser2.gif"></a>
	                        </td>
						</tr>
						
						<tr>
	                        <th scope="row" class="star">회사명(국문)</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("COM_NAME_LOC")) %>
	                      		<input type="hidden" id="st_com_name_loc" name="st_com_name_loc" class="input_type_text" title=""  maxlength="50" style="width:160px;" value="<%=CommonUtil.nvl(_rowData.get("COM_NAME_LOC"))%>"  onkeyup="fnCheckInputByte(this, 50);" onchange="fnCheckInputByte(this, 50);"/>
	                      	</td>
	                        <th scope="row" class="star">회사명(영문)</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("COM_NAME_ENG")) %>
	                      		<input type="hidden" id="st_com_name_eng" name="st_com_name_eng" class="input_type_text" title=""  maxlength="50" style="width:160px; ime-mode:disabled;"" value="<%=CommonUtil.nvl(_rowData.get("COM_NAME_ENG"))%>" />
	                      	</td>
	                    </tr>
	                    <tr>
	                        <th scope="row" class="star">사업자등록번호</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("IRS_NO")) %></td>
	                        <th scope="row">설립년도</th>
	                      	<td>
	                      		<input type="text" id="establish_date" name="establish_date" class="input_type_text" title="" style="width:100px;" maxlength="8"  value="<%=CommonUtil.formatStrinigDate(_rowData.get("ESTABLISH_DATE"))%>" />
	                      		<input type="hidden" id="st_establish_date" name="st_establish_date" class="input_type_text" title="" style="width:100px;" maxlength="8"  value="<%=CommonUtil.nvl(_rowData.get("ESTABLISH_DATE"))%>" />
	                      	</td>
	                    </tr>
	                    <tr>
	                        <th scope="row" class="star">대표자(국문)</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("CEO_NAME_LOC")) %>
	                      		<input type="hidden" id="st_ceo_name_loc" name="st_ceo_name_loc" class="input_type_text" title="" style="width:100px;" maxlength="40" value="<%=CommonUtil.nvl(_rowData.get("CEO_NAME_LOC"))%>"  onkeyup="fnCheckInputByte(this, 40);" onchange="fnCheckInputByte(this, 40);" />
	                      	</td>
	                        <th scope="row" class="star">대표자(영문)</th>
	                      	<td><input type="text" id="st_ceo_name_eng" name="st_ceo_name_eng" class="input_type_text" title="" style="width:100px; ime-mode:disabled;"" maxlength="20" value="<%=CommonUtil.nvl(_rowData.get("CEO_NAME_ENG"))%>" /></td>
	                    </tr>
	                    <tr>
	                        <th scope="row" class="star">대표전화번호</th>
	                      	<td><input type="text" id="st_tel_no" name="st_tel_no"class="input_type_text" title="" style="width:80px;" maxlength="20" value="<%=CommonUtil.nvl(_rowData.get("TEL_NO"))%>" onkeyup="fnPhoneNumberCheck('st_tel_no');" onchange="fnPhoneNumberCheck('st_tel_no');"/> (EX : 02-0000-0000)</td>
	                        <th scope="row">대표FAX번호</th>
	                      	<td><input type="text" id="st_fax_no" name="st_fax_no"class="input_type_text" title="" style="width:100px;" maxlength="20" value="<%=CommonUtil.nvl(_rowData.get("FAX_NO"))%>" onkeyup="fnPhoneNumberCheck('st_fax_no');" onchange="fnPhoneNumberCheck('st_fax_no');"/></td>
	                    </tr>
	                    <tr>
	                        <th scope="row" class="star">업태</th>
	                      	<td><input type="text" id="st_industry_type" name="st_industry_type"class="input_type_text" title="" style="width:160px;" maxlength="50" value="<%=CommonUtil.nvl(_rowData.get("INDUSTRY_TYPE"))%>" onkeyup="fnCheckInputByte(this, 50);" onchange="fnCheckInputByte(this, 50);" /></td>
	                        <th scope="row" class="star">종목</th>
	                      	<td><input type="text" id="st_business_items" name="st_business_items"class="input_type_text" title="" style="width:160px;" maxlength="50" value="<%=CommonUtil.nvl(_rowData.get("BUSINESS_ITEMS"))%>" onkeyup="fnCheckInputByte(this, 50);" onchange="fnCheckInputByte(this, 50);" /></td>
	                    </tr>
	                    <tr>
	                        <th scope="row" class="star">우편번호</th>
	                      	<td>
	                      		<input type="text" id="st_zip_code" name="st_zip_code" class="input_type_text" title="" style="width:80px;" maxlength="10"  readonly  value="<%=CommonUtil.nvl(_rowData.get("ZIP_CODE"))%>" />
	                      		<input type="hidden" id="st_zip_key" name="st_zip_key" value="<%=CommonUtil.nvl(_rowData.get("ZIP_KEY"))%>"/>
	                      		<!-- <span class="btn_gray_05"  title="우편번호" ><a href="javascript:doPop('zipcode');">우편번호 검색</a></span>	ICOMPOST 테이블 이용하여 우편번호 검색 김영훈 -->
	                      		<span class="btn_gray_05"  title="우편번호" ><a href="javascript:doPop('newzipcode');">우편번호 검색</a></span>
	                      	</td>
	                        <th scope="row">메일링서비스</th>
	                      	<td>
	                      		<input type="radio" id="mail_send_flag1" name="mail_send_flag" value="Y" <% if (CommonUtil.nvl(_rowData.get("MAIL_SEND_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;예&nbsp;&nbsp;&nbsp;
                        		<input type="radio" id="mail_send_flag2" name="mail_send_flag" value="N" <% if (!CommonUtil.nvl(_rowData.get("MAIL_SEND_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;아니오
                        		<input type="hidden" id="st_mail_send_flag" name="st_mail_send_flag"  value="<%=CommonUtil.nvl(_rowData.get("MAIL_SEND_FLAG"))%>" />
                        	</td>
	                    </tr>
	                    <tr>
	                        <th scope="row" class="star">주소</th>
	                      	<td colspan="3">
	                      		<input type="text" id="st_address_loc" name="st_address_loc" class="input_type_text" title="" style="width:480px;" value="<%=CommonUtil.nvl(_rowData.get("ADDRESS_LOC"))%>" />
	                      		<input type="hidden" id="st_address" name="st_address" class="input_type_text" title="" style="width:480px;" maxlength="100" readonly value="<%=CommonUtil.nvl(_rowData.get("ADDRESS_LOC1"))%>" />
	                      		<input type="hidden" id="st_address_eng" name="st_address_eng"class="input_type_text" title="" style="width:480px;" maxlength="100" value="<%=CommonUtil.nvl(_rowData.get("ADDRESS_ENG"))%>" />
	                      		<input type="hidden" id="st_address_dt" name="st_address_dt" class="input_type_text" title="" style="width:480px;" maxlength="100" value="<%=CommonUtil.nvl(_rowData.get("ADDRESS_LOC2"))%>" onkeyup="fnCheckInputByte(this, 100);" onchange="fnCheckInputByte(this, 100);"  />
	                      	</td>
	                    </tr>
	                    <tr>
	                        <th scope="row">홈페이지주소</th>
	                      	<td colspan="3"><input type="text" id="st_hp_address" name="st_hp_address" class="input_type_text" title="" style="width:280px;" maxlength="50" value="<%=CommonUtil.nvl(_rowData.get("HP_ADDRESS"))%>"  onkeyup="fnCheckInputByte(this, 50);" onchange="fnCheckInputByte(this, 50);" /></td>
	                    </tr>
	                    <tr>
	                        <th scope="row" class="star">법인등록번호</th>
	                      	<% 
	                      	String _corpRegNo1 = "";
                  			String _corpRegNo2 = "";
	                      	if (!CommonUtil.nvl(_rowData.get("CORP_REG_NO")).equals("")) {
	                      		_corpRegNo1 = CommonUtil.nvl(_rowData.get("CORP_REG_NO").substring(0, 6));
	                      		_corpRegNo2 = CommonUtil.nvl(_rowData.get("CORP_REG_NO").substring(7, 14));
	                      	}
	                      	%>
	                      	<td>
	                      		<input type="text" id="st_corp_reg_no_1" name="st_corp_reg_no_1" class="input_type_text" title="" style="width:60px;" maxlength="6" value="<%=_corpRegNo1%>"/>-
	                      		<input type="text" id="st_corp_reg_no_2" name="st_corp_reg_no_2" class="input_type_text" title="" style="width:60px;" maxlength="7" value="<%=_corpRegNo2 %>"/>
	                      		<input type="hidden" id="st_corp_reg_no" name="st_corp_reg_no" value="<%=CommonUtil.nvl(_rowData.get("CORP_REG_NO")) %>" />
	                      	</td>
	                      	<th scope="row">무역업등록번호</th>
	                      	<td><input type="text" id="st_trade_reg_no" name="st_trade_reg_no" class="input_type_text" title="" style="width:160px;" maxlength="20" onkeyup="fnCheckInputByte(this, 20);" onchange="fnCheckInputByte(this, 20);" value="<%=CommonUtil.nvl(_rowData.get("TRADE_REG_NO")) %>" /></td>
	                    </tr>
	                    <tr>
	                        <th scope="row">DUNS-NO</th>
	                      	<td colspan="3"><input type="text" id="st_duns_no" name="st_duns_no" class="input_type_text" title="" style="width:160px;" maxlength="20" onkeyup="fnCheckInputByte(this, 20);" onchange="fnCheckInputByte(this, 20);" value="<%=CommonUtil.nvl(_rowData.get("DUNS_NO")) %>" /></td>
	                      	<!-- th scope="row">신용등급</th>
	                      	<td><input type="text" id="st_credit_rating" name="st_credit_rating" class="input_type_text" title="" style="width:140px;" maxlength="10" onkeyup="fnCheckInputByte(this, 10);" onchange="fnCheckInputByte(this, 10);" value="<%=CommonUtil.nvl(_rowData.get("CREDIT_RATING")) %>" /></td -->
	                    </tr>
	                      	<input type="hidden" id="st_gr_emp_nm" name="st_gr_emp_nm" class="input_type_text" title="" style="width:160px;" maxlength="20" value="<%=CommonUtil.nvl(_rowData.get("GR_EMP_NM")) %>"  onkeyup="fnCheckInputByte(this, 20);" onchange="fnCheckInputByte(this, 20);" />
	                      	<input type="hidden" id="st_gr_emp_tel" name="st_gr_emp_tel" class="input_type_text" title="" style="width:160px;" maxlength="20" value="<%=CommonUtil.nvl(_rowData.get("GR_EMP_TEL")) %>"  onkeyup="fnPhoneNumberCheck('st_gr_emp_tel');" onchange="fnPhoneNumberCheck('st_gr_emp_tel');"/>
	                      	<input type="hidden" id="st_ac_emp_nm" name="st_ac_emp_nm" class="input_type_text" title="" style="width:160px;" maxlength="20" value="<%=CommonUtil.nvl(_rowData.get("AC_EMP_NM")) %>" onkeyup="fnCheckInputByte(this, 20);" onchange="fnCheckInputByte(this, 20);" />
	                      	<input type="hidden" id="st_ac_emp_tel" name="st_ac_emp_tel" class="input_type_text" title="" style="width:160px;" maxlength="20" value="<%=CommonUtil.nvl(_rowData.get("AC_EMP_TEL")) %>"  onkeyup="fnPhoneNumberCheck('st_ac_emp_tel');" onchange="fnPhoneNumberCheck('st_ac_emp_tel');"/>
	                      	<input type="hidden" id="st_pay_recver" name="st_pay_recver" class="input_type_text" title="" style="width:480px;" maxlength="50" value="<%=CommonUtil.nvl(_rowData.get("PAY_RECVER")) %>"  onkeyup="fnCheckInputByte(this, 50);" onchange="fnCheckInputByte(this, 50);" />
	                    <tr>
	                        <th scope="row">직납가능지역</th>
	                      	<td colspan="3">
								<input type="hidden" id="st_cmpy_dely_area" name="st_cmpy_dely_area" value="<%=CommonUtil.nvl(_rowData.get("DELY_AREA"))%>" />
								<input type="hidden" id="st_cmpy_dely_cnt" name="st_cmpy_dely_cnt" value="<%=_dataAreaList.size()%>" />
							<%
								for (int j=0; j<_dataAreaList.size(); j++) {
									Map<String,String> rowDataAreaList = _dataAreaList.get(j);
							%>
									<input id="st_dely_area_flag<%=j%>" name="st_dely_area_flag<%=j%>" id="st_dely_area_flag<%=j%>" type="checkbox" value="" style="vertical-align:middle"> <%=CommonUtil.nvl(rowDataAreaList.get("TEXT1"))%>&nbsp;&nbsp;&nbsp;
									<%if((j > 0) && ((j+1)%6 == 0)){%>
										<br>
									<%}%>
								<%}%>
	                      	</td>
	                    </tr>
	                    <tr>
	                      	<td colspan="4" style="text-align:center;">※ 통장이체, 공장/본사 출납부서등을 표기 부탁드립니다.</td>
	                    </tr>
	                    <tr>
							<th scope="row" class="star">수금조건</th>
							<td>
								<select id="st_pay_terms" name="st_pay_terms" style="width:55%;">
									<script>kepAjaxCommonComboDataValue('st_pay_terms', 'SA15', 'SEL', '<%=CommonUtil.nvl(_rowData.get("PAY_TERMS")) %>');</script>
								</select>
							</td>
							<th scope="row" class="star">수금형태</th>
							<td>
								<select id="st_pay_type" name="st_pay_type" style="width:55%;">
									<script>kepAjaxCommonComboDataValue('st_pay_type', 'SA02', 'SEL', '<%=CommonUtil.nvl(_rowData.get("PAY_TYPE")) %>');</script>
								</select>
							</td>
						</tr>
	                    <!--  tr>
	                      	<th scope="row">차량정보입력</th>
	                      	<td colspan="3">
	                      		<input type="radio" id="delivery_car_info1" name="delivery_car_info" value="Y" <% if (CommonUtil.nvl(_rowData.get("CAR_FLAG")).equals("Y")) { %>checked="checked"<% } %>/>&nbsp;예&nbsp;&nbsp;&nbsp;
                        		<input type="radio" id="delivery_car_info2" name="delivery_car_info" value="N" <% if (!CommonUtil.nvl(_rowData.get("CAR_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;아니오
                        		<input type="hidden" id="st_delivery_car_info" name="st_delivery_car_info" value="<%=CommonUtil.nvl(_rowData.get("CAR_FLAG"))%>" />
                        	</td>
	                    </tr -->
	                    <tr>
	                    	<th scope="row">차량일배송횟수</th>
	                      	<td><input type="text" id="st_car_deliv_cnt" name="st_car_deliv_cnt" class="input_type_text" title="" style="width:120px;" value="<%=CommonUtil.nvl(_rowData.get("CAR_DELIV_CNT")) %>"  onkeyup="kepNumcheck(this);" onchange="kepNumcheck(this);"/></td>
	                      		<input type="hidden" id="contract_expire_date" name="contract_expire_date" class="input_type_text" title="" style="width:120px;" readOnly value="<%=CommonUtil.formatStrinigDate(_rowData.get("CONTRACT_EXPIRE_DATE"))%>" />
	                      		<input type="hidden" id="st_contract_expire_date" name="st_contract_expire_date"  value="<%=CommonUtil.nvl(_rowData.get("CONTRACT_EXPIRE_DATE"))%>" />
	                      	<th scope="row">자동연장여부</th>
	                      	<td>
	                      		<input type="radio" id="contract_auto_renew1" name="contract_auto_renew" value="Y" <% if (CommonUtil.nvl(_rowData.get("CONTRACT_AUTO_RENEW")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;예&nbsp;&nbsp;&nbsp;
                        		<input type="radio" id="contract_auto_renew2" name="contract_auto_renew" value="N" <% if (!CommonUtil.nvl(_rowData.get("CONTRACT_AUTO_RENEW")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;아니오
                        		<input type="hidden" id="st_contract_auto_renew" name="st_contract_auto_renew" value="<%=CommonUtil.nvl(_rowData.get("CONTRACT_AUTO_RENEW"))%>" />
                        	</td>
	                    </tr>
	                    <tr>
	                        <th scope="row"></th>
	                      	<td></td>
	                      	<th scope="row">표준납기관리여부</th>
	                      	<td>
	                      		<input type="radio" id="std_date_flag1" name="std_date_flag" value="Y" checked="checked" disabled/>&nbsp;예&nbsp;&nbsp;&nbsp;
                        		<input type="radio" id="std_date_flag2" name="std_date_flag" value="N" disabled/>&nbsp;아니오
                        		<input type="hidden" id="st_std_date_flag" name="st_std_date_flag" value="<%=CommonUtil.nvl(_rowData.get("STD_DATE_FLAG"))%>"/>
	                      	</td>
	                    </tr>
	                    <tr>
	                        <th scope="row" class="star">업종관리</th>
	                      	<td>
	                      		<input type="hidden" id="st_kep_business_item" name="st_kep_business_item" class="input_type_text" title="" style="width:120px;" value="<%=CommonUtil.nvl(_rowData.get("KEP_BUSINESS_ITEM")) %>" />
	                      		<input type="text" id="st_kep_business_item_text" name="st_kep_business_item_text" class="input_type_text" title="" style="width:120px;" readonly value="<%=CommonUtil.nvl(_rowData.get("KEP_BUSINESS_ITEM_TEXT")) %>" />
	                      		<a href="javascript:doPop('kepBusinessItem');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_kep_business_item','st_kep_business_item_text');"><img src="/resources/images/btn_eraser2.gif"></a>
	                      	</td>
	                      	<th scope="row">SAP코드</th>
	                      	<td><%=CommonUtil.nvl(_rowData.get("SAP_CODE")) %></td>
	                    </tr>
	                    <tr>
	                        <th scope="row">SMS수신여부</th>
	                      	<td>
	                      		<input type="radio" id="sms_recv_flag1" name="sms_recv_flag" value="Y" <% if (CommonUtil.nvl(_rowData.get("SMS_RECV_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;예&nbsp;&nbsp;&nbsp;
                        		<input type="radio" id="sms_recv_flag2" name="sms_recv_flag" value="N" <% if (!CommonUtil.nvl(_rowData.get("SMS_RECV_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;아니오
                        		<input type="hidden" id="st_sms_recv_flag" name="st_sms_recv_flag" value="<%=CommonUtil.nvl(_rowData.get("SMS_RECV_FLAG"))%>" />
	                      	</td>
	                      	<th scope="row">협력사공개여부</th>
	                      	<td>
	                      		<input type="radio" id="agent_open_flag1" name="agent_open_flag" value="Y" <% if (CommonUtil.nvl(_rowData.get("AGENT_OPEN_FLAG")).equals("Y")) { %>checked="checked"<% } %> disabled/>&nbsp;예&nbsp;&nbsp;&nbsp;
                        		<input type="radio" id="agent_open_flag2" name="agent_open_flag" value="N" <% if (!CommonUtil.nvl(_rowData.get("AGENT_OPEN_FLAG")).equals("Y")) { %>checked="checked"<% } %> disabled/>&nbsp;아니오
                        		<input type="hidden" id="st_agent_open_flag" name="st_agent_open_flag" value="<%=CommonUtil.nvl(_rowData.get("AGENT_OPEN_FLAG"))%>" />
	                      	</td>
	                    </tr>
	                    <tr>
	                        <th scope="row">예산관리여부</th>
	                      	<td>
	                      		<input type="radio" id="budget_flag1" name="budget_flag" value="Y" <% if (CommonUtil.nvl(_rowData.get("BUDGET_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;예&nbsp;&nbsp;&nbsp;
                        		<input type="radio" id="budget_flag2" name="budget_flag" value="N" <% if (!CommonUtil.nvl(_rowData.get("BUDGET_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;아니오
                        		<input type="hidden" id="st_budget_flag" name="st_budget_flag" value="<%=CommonUtil.nvl(_rowData.get("BUDGET_FLAG"))%>" />
	                      	</td>
	                      	<th scope="row">로고사용여부</th>
	                      	<td>
	                      		<input type="radio" id="logo_yn1" name="logo_yn" value="Y" <% if (CommonUtil.nvl(_rowData.get("LOGO_YN")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;예&nbsp;&nbsp;&nbsp;
                        		<input type="radio" id="logo_yn2" name="logo_yn" value="N" <% if (!CommonUtil.nvl(_rowData.get("LOGO_YN")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;아니오
                        		<input type="hidden" id="st_logo_yn" name="st_logo_yn" value="<%=CommonUtil.nvl(_rowData.get("LOGO_YN"))%>" />
	                      	</td>
	                    </tr>
	                    <tr>
							<th scope="row" class="padding">서류접수현황</th>
							<td colspan="5">
								<input type="checkbox" id="st_corp_regist_flag"			name="st_corp_regist_flag"		value="Y"	 <%=_rowData.get("CORP_REGIST_FLAG").equals("Y")?"checked":""%> /> 법인등기부등록증
								<input type="checkbox" id="st_seal_certi_regist_flag"		name="st_seal_certi_regist_flag"	value="Y"	 <%=_rowData.get("SEAL_CERTI_REGIST_FLAG").equals("Y")?"checked":""%> /> 인감증명서
								<input type="checkbox" id="st_use_seal_regist_flag"		name="st_use_seal_regist_flag"	value="Y"	 <%=_rowData.get("USE_SEAL_REGIST_FLAG").equals("Y")?"checked":""%> /> 사용인감
								<input type="checkbox" id="st_contract_regist_flag"		name="st_contract_regist_flag"	value="Y"	 <%=_rowData.get("CONTRACT_REGIST_FLAG").equals("Y")?"checked":""%> /> 계약서
							</td>
						</tr>
	                    <tr>
	                    	<th scope="row">첨부파일</th>
	                      	<td>
	                      		<input type="hidden" id="st_image_key" name="st_image_key" class="input_type_text" title="" style="width:110px;" value="<%=CommonUtil.nvl(_rowData.get("IMAGE_KEY")) %>" />
	                      		<input type="hidden" id="st_image_key_Text" name="st_image_key_Text" class="input_type_text" title="" style="width:110px;" value="<%=CommonUtil.nvl(_rowData.get("IMAGE_KEY_TEXT")) %>" />
	                      		<span class="btn_gray_03"  title="파일첨부" ><a href="javascript:doPop('fileUpload','<%=CommonUtil.nvl(_rowData.get("IMAGE_KEY")) %>')">파일첨부</a></span>
	                      		
	                      	</td>
	                        <th scope="row">납품수량변경유무</th>
	                      	<td>
	                      		<input type="radio" id="ds_flag1" name="ds_flag" value="Y" <% if (CommonUtil.nvl(_rowData.get("DS_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;예&nbsp;&nbsp;&nbsp;
                        		<input type="radio" id="ds_flag1" name="ds_flag" value="N" <% if (!CommonUtil.nvl(_rowData.get("DS_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;아니오
                        		<input type="hidden" id="st_ds_flag" name="st_ds_flag" value="<%=CommonUtil.nvl(_rowData.get("DS_FLAG"))%>" />
	                      	</td>
	                    </tr>
	                    <tr>
	                        <th scope="row">비고</th>
	                      	<td colspan="3"><input type="text"  id="st_remark" name="st_remark" class="input_type_text" title="" style="width:300px;" maxlength="50" value="<%=CommonUtil.nvl(_rowData.get("REMARK")) %>" /></td>
	                    </tr>
					</tbody>
				</table>
				
<div style="display: none"> <!-- 미지원 기능이 많아 화면상 가리기로 결정 2022.10.19 -->
				<p class="pt20" style="font-weight:bold;">[추가옵션관리]</P>
				<table  class="cont_t_list06" style="width:100%;">
	                <caption>추가옵션관리</caption>
	                <colgroup>
	                    <col width="120px" />
	                    <col width="32%" />
	                    <col width="120px" />
	                    <col width="30%" />
	                </colgroup>
	                <tbody>
						<tr>
	                        <th scope="row">접수발주여부</th>
	                      	<td>
	                      		<input type="radio" id="rcpt_po_flag1" name="rcpt_po_flag" value="Y" <% if (CommonUtil.nvl(_rowData.get("RCPT_PO_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;예&nbsp;&nbsp;&nbsp;
                        		<input type="radio" id="rcpt_po_flag2" name="rcpt_po_flag" value="N" <% if (!CommonUtil.nvl(_rowData.get("RCPT_PO_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;아니오
                        		<input type="hidden" id="st_rcpt_po_flag" name="st_rcpt_po_flag" value="<%=CommonUtil.nvl(_rowData.get("RCPT_PO_FLAG"))%>" />
	                      	</td>
	                        <th scope="row">FEE방법거래여부</th>
	                      	<td>
	                      		<input type="radio" id="fee_base_flag1" name="fee_base_flag" value="Y" <% if (CommonUtil.nvl(_rowData.get("FEE_BASE_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;예&nbsp;&nbsp;&nbsp;
                        		<input type="radio" id="fee_base_flag2" name="fee_base_flag" value="N" <% if (!CommonUtil.nvl(_rowData.get("FEE_BASE_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;아니오
                        		<input type="hidden" id="st_fee_base_flag" name="st_fee_base_flag" value="<%=CommonUtil.nvl(_rowData.get("FEE_BASE_FLAG"))%>" />
	                      	</td>
	                    </tr>
	                    <tr>
	                        <th scope="row">관리번호사용여부</th>
	                      	<td>
	                      		<input type="radio" id="mng_no_flag1" name="mng_no_flag" value="Y" <% if (CommonUtil.nvl(_rowData.get("MNG_NO_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;예&nbsp;&nbsp;&nbsp;
                        		<input type="radio" id="mng_no_flag2" name="mng_no_flag" value="N" <% if (!CommonUtil.nvl(_rowData.get("MNG_NO_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;아니오
                        		<input type="hidden" id="st_mng_no_flag" name="st_mng_no_flag" value="<%=CommonUtil.nvl(_rowData.get("MNG_NO_FLAG"))%>" />
	                      	</td>
	                        <th scope="row">관리번호팝업사용여부</th>
	                      	<td>
	                      		<input type="radio" id="mng_no_popup_flag1" name="mng_no_popup_flag" value="Y" <% if (CommonUtil.nvl(_rowData.get("MNG_NO_POPUP_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;예&nbsp;&nbsp;&nbsp;
                        		<input type="radio" id="mng_no_popup_flag2" name="mng_no_popup_flag" value="N" <% if (!CommonUtil.nvl(_rowData.get("MNG_NO_POPUP_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;아니오
                        		<input type="hidden" id="st_mng_no_popup_flag" name="st_mng_no_popup_flag" value="<%=CommonUtil.nvl(_rowData.get("MNG_NO_POPUP_FLAG"))%>" />
	                      	</td>
	                    </tr>
	                    <tr>
	                        <th scope="row">사무용품카탈로그사용여부</th>
	                      	<td>
	                      		<input type="radio" id="office_catlg_flag1" name="office_catlg_flag" value="Y" <% if (CommonUtil.nvl(_rowData.get("OFFICE_CATLG_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;예&nbsp;&nbsp;&nbsp;
                        		<input type="radio" id="office_catlg_flag2" name="office_catlg_flag" value="N" <% if (!CommonUtil.nvl(_rowData.get("OFFICE_CATLG_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;아니오
                        		<input type="hidden" id="st_office_catlg_flag" name="st_office_catlg_flag" value="<%=CommonUtil.nvl(_rowData.get("OFFICE_CATLG_FLAG"))%>" />
	                      	</td>
	                        <th scope="row">고객사카탈로그정비불가여부</th>
	                      	<td>
	                      		<input type="radio" id="buyer_catlg_edit_flag1" name="buyer_catlg_edit_flag" value="Y" <% if (CommonUtil.nvl(_rowData.get("BUYER_CATLG_EDIT_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;예&nbsp;&nbsp;&nbsp;
                        		<input type="radio" id="buyer_catlg_edit_flag2" name="buyer_catlg_edit_flag" value="N" <% if (!CommonUtil.nvl(_rowData.get("BUYER_CATLG_EDIT_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;아니오
                        		<input type="hidden" id="st_buyer_catlg_edit_flag" name="st_buyer_catlg_edit_flag" value="<%=CommonUtil.nvl(_rowData.get("BUYER_CATLG_EDIT_FLAG"))%>" />
	                      	</td>
	                    </tr>
	                    <tr>
	                        <th scope="row">견적제출수정가능여부</th>
	                      	<td>
	                      		<input type="radio" id="quotataion_edit_flag1" name="quotataion_edit_flag" value="Y" <% if (CommonUtil.nvl(_rowData.get("QUOTATAION_EDIT_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;예&nbsp;&nbsp;&nbsp;
                        		<input type="radio" id="quotataion_edit_flag2" name="quotataion_edit_flag" value="N" <% if (!CommonUtil.nvl(_rowData.get("QUOTATAION_EDIT_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;아니오
                        		<input type="hidden" id="st_quotataion_edit_flag" name="st_quotataion_edit_flag" value="<%=CommonUtil.nvl(_rowData.get("QUOTATAION_EDIT_FLAG"))%>" />
	                      	</td>
	                        <th scope="row">신규상품견적의뢰결재상신여부</th>
	                      	<td>
	                      		<input type="radio" id="new_item_pm_flag1" name="new_item_pm_flag" value="Y" <% if (CommonUtil.nvl(_rowData.get("NEW_ITEM_PM_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;예&nbsp;&nbsp;&nbsp;
                        		<input type="radio" id="new_item_pm_flag2" name="new_item_pm_flag" value="N" <% if (!CommonUtil.nvl(_rowData.get("NEW_ITEM_PM_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;아니오
                        		<input type="hidden" id="st_new_item_pm_flag" name="st_new_item_pm_flag" value="<%=CommonUtil.nvl(_rowData.get("NEW_ITEM_PM_FLAG"))%>" />
	                      	</td>
	                    </tr>
	                    <tr>
	                        <th scope="row">기존매입대응불가여부</th>
	                      	<td>
	                      		<input type="radio" id="exist_act_flag1" name="exist_act_flag" value="Y" <% if (CommonUtil.nvl(_rowData.get("EXIST_ACT_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;예&nbsp;&nbsp;&nbsp;
                        		<input type="radio" id="exist_act_flag2" name="exist_act_flag" value="N" <% if (!CommonUtil.nvl(_rowData.get("EXIST_ACT_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;아니오
                        		<input type="hidden" id="st_exist_act_flag" name="st_exist_act_flag" value="<%=CommonUtil.nvl(_rowData.get("EXIST_ACT_FLAG"))%>" />
	                      	</td>
	                        <th scope="row">자동단가합의여부</th>
	                      	<td>
	                      		<input type="radio" id="auto_confirm_flag1" name="auto_confirm_flag" value="Y" <% if (CommonUtil.nvl(_rowData.get("AUTO_CONFIRM_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;예&nbsp;&nbsp;&nbsp;
                        		<input type="radio" id="auto_confirm_flag2" name="auto_confirm_flag" value="N" <% if (!CommonUtil.nvl(_rowData.get("AUTO_CONFIRM_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;아니오
                        		<input type="hidden" id="st_auto_confirm_flag" name="st_auto_confirm_flag" value="<%=CommonUtil.nvl(_rowData.get("AUTO_CONFIRM_FLAG"))%>" />
	                      	</td>
	                    </tr>
	                    <tr>
	                        <th scope="row">견적일괄제출여부</th>
	                      	<td>
	                      		<input type="radio" id="quotataion_batch_flag1" name="quotataion_batch_flag" value="Y" <% if (CommonUtil.nvl(_rowData.get("QUOTATAION_BATCH_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;예&nbsp;&nbsp;&nbsp;
                        		<input type="radio" id="quotataion_batch_flag2" name="quotataion_batch_flag" value="N" <% if (!CommonUtil.nvl(_rowData.get("QUOTATAION_BATCH_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;아니오
                        		<input type="hidden" id="st_quotataion_batch_flag" name="st_quotataion_batch_flag" value="<%=CommonUtil.nvl(_rowData.get("QUOTATAION_BATCH_FLAG"))%>" />
	                      	</td>
	                        <th scope="row">단가합의전자결재여부</th>
	                      	<td>
	                      		<input type="radio" id="price_confirm_elctr_flag1" name="price_confirm_elctr_flag" value="Y" <% if (CommonUtil.nvl(_rowData.get("PRICE_CONFIRM_ELCTR_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;예&nbsp;&nbsp;&nbsp;
                        		<input type="radio" id="price_confirm_elctr_flag2" name="price_confirm_elctr_flag" value="N" <% if (!CommonUtil.nvl(_rowData.get("PRICE_CONFIRM_ELCTR_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;아니오
                        		<input type="hidden" id="st_price_confirm_elctr_flag" name="st_price_confirm_elctr_flag" value="<%=CommonUtil.nvl(_rowData.get("PRICE_CONFIRM_ELCTR_FLAG"))%>" />
	                      	</td>
	                    </tr>
	                    <tr>
	                        <th scope="row">2단계단가협의여부</th>
	                      	<td>
	                      		<input type="radio" id="step2_price_flag1" name="step2_price_flag" value="Y" <% if (CommonUtil.nvl(_rowData.get("STEP2_PRICE_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;예&nbsp;&nbsp;&nbsp;
                        		<input type="radio" id="step2_price_flag2" name="step2_price_flag" value="N" <% if (!CommonUtil.nvl(_rowData.get("STEP2_PRICE_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;아니오
                        		<input type="hidden" id="st_step2_price_flag" name="st_step2_price_flag" value="<%=CommonUtil.nvl(_rowData.get("STEP2_PRICE_FLAG"))%>" />
	                      	</td>
	                        <th scope="row">견적단가협의대행등록가능여부</th>
	                      	<td>
	                      		<input type="radio" id="price_confirm_repl_flag1" name="price_confirm_repl_flag" value="Y" <% if (CommonUtil.nvl(_rowData.get("PRICE_CONFIRM_REPL_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;예&nbsp;&nbsp;&nbsp;
                        		<input type="radio" id="price_confirm_repl_flag2" name="price_confirm_repl_flag" value="N" <% if (!CommonUtil.nvl(_rowData.get("PRICE_CONFIRM_REPL_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;아니오
                        		<input type="hidden" id="st_price_confirm_repl_flag" name="st_price_confirm_repl_flag" value="<%=CommonUtil.nvl(_rowData.get("PRICE_CONFIRM_REPL_FLAG"))%>" />
	                      	</td>
	                    </tr>
	                    <tr>
	                        <th scope="row">2주문확정여부</th>
	                      	<td>
	                      		<input type="radio" id="order_confirm_flag1" name="order_confirm_flag" value="Y" <% if (CommonUtil.nvl(_rowData.get("ORDER_CONFIRM_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;예&nbsp;&nbsp;&nbsp;
                        		<input type="radio" id="order_confirm_flag2" name="order_confirm_flag" value="N" <% if (!CommonUtil.nvl(_rowData.get("ORDER_CONFIRM_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;아니오
                        		<input type="hidden" id="st_order_confirm_flag" name="st_order_confirm_flag" value="<%=CommonUtil.nvl(_rowData.get("ORDER_CONFIRM_FLAG"))%>" />
	                      	</td>
	                        <th scope="row">주문부서전자결재여부</th>
	                      	<td>
	                      		<input type="radio" id="order_dept_elctr_flag1" name="order_dept_elctr_flag" value="Y" <% if (CommonUtil.nvl(_rowData.get("ORDER_DEPT_ELCTR_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;예&nbsp;&nbsp;&nbsp;
                        		<input type="radio" id="order_dept_elctr_flag2" name="order_dept_elctr_flag" value="N" <% if (!CommonUtil.nvl(_rowData.get("ORDER_DEPT_ELCTR_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;아니오
                        		<input type="hidden" id="st_order_dept_elctr_flag" name="st_order_dept_elctr_flag" value="<%=CommonUtil.nvl(_rowData.get("ORDER_DEPT_ELCTR_FLAG"))%>" />
	                      	</td>
	                    </tr>
	                    <tr>
	                        <th scope="row">의뢰부서전자결재여부</th>
	                      	<td>
	                      		<input type="radio" id="request_dept_elctr_flag1" name="request_dept_elctr_flag" value="Y" <% if (CommonUtil.nvl(_rowData.get("REQUEST_DEPT_ELCTR_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;예&nbsp;&nbsp;&nbsp;
                        		<input type="radio" id="request_dept_elctr_flag2" name="request_dept_elctr_flag" value="N" <% if (!CommonUtil.nvl(_rowData.get("REQUEST_DEPT_ELCTR_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;아니오
                        		<input type="hidden" id="st_request_dept_elctr_flag" name="st_request_dept_elctr_flag" value="<%=CommonUtil.nvl(_rowData.get("REQUEST_DEPT_ELCTR_FLAG"))%>" />
	                      	</td>
	                        <th scope="row">입고대행등록가능여부</th>
	                      	<td>
	                      		<input type="radio" id="gr_regist_flag1" name="gr_regist_flag" value="Y" <% if (CommonUtil.nvl(_rowData.get("GR_REGIST_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;예&nbsp;&nbsp;&nbsp;
                        		<input type="radio" id="gr_regist_flag2" name="gr_regist_flag" value="N" <% if (!CommonUtil.nvl(_rowData.get("GR_REGIST_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;아니오
                        		<input type="hidden" id="st_gr_regist_flag" name="st_gr_regist_flag" value="<%=CommonUtil.nvl(_rowData.get("GR_REGIST_FLAG"))%>" />
	                      	</td>
	                    </tr>
	                    <tr>
	                        <th scope="row">자동입고여부</th>
	                      	<td>
	                      		<input type="radio" id="auto_gr_flag1" name="auto_gr_flag" value="Y" <% if (CommonUtil.nvl(_rowData.get("AUTO_GR_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;예&nbsp;&nbsp;&nbsp;
                        		<input type="radio" id="auto_gr_flag2" name="auto_gr_flag" value="N" <% if (!CommonUtil.nvl(_rowData.get("AUTO_GR_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;아니오
                        		<input type="hidden" id="st_auto_gr_flag" name="st_auto_gr_flag" value="<%=CommonUtil.nvl(_rowData.get("AUTO_GR_FLAG"))%>" />
	                      	</td>
	                      	<th scope="row">납기일구분</th>
	                      	<td>
	                      		<select id="st_duedate_flag" name="st_duedate_flag">
                        			<option value="SD" <% if (CommonUtil.nvl(_rowData.get("DUEDATE_FLAG")).equals("SD")) { %> selected <% } %>>표준납기일</option>
                        			<option value="RD"  <% if (CommonUtil.nvl(_rowData.get("DUEDATE_FLAG")).equals("RD")) { %> selected <% } %>>요구납기일</option>
                        		</select>
	                      	</td>
	                    </tr>
	                    <tr>
	                        <th scope="row">복수협력사견적필수여부</th>
	                      	<td>
	                      		<input type="radio" id="multi_quotation_flag1" name="multi_quotation_flag" value="Y" <% if (CommonUtil.nvl(_rowData.get("MULTI_QUOTATION_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;예&nbsp;&nbsp;&nbsp;
                        		<input type="radio" id="multi_quotation_flag2" name="multi_quotation_flag" value="N" <% if (!CommonUtil.nvl(_rowData.get("MULTI_QUOTATION_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;아니오
                        		<input type="hidden" id="st_multi_quotation_flag" name="st_multi_quotation_flag" value="<%=CommonUtil.nvl(_rowData.get("MULTI_QUOTATION_FLAG"))%>" />
	                      	</td>
	                        <th scope="row">kep표준거래명세서사용여부</th>
	                      	<td>
	                      		<input type="radio" id="std_invoice_flag1" name="std_invoice_flag" value="Y" <% if (CommonUtil.nvl(_rowData.get("STD_INVOICE_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;예&nbsp;&nbsp;&nbsp;
                        		<input type="radio" id="std_invoice_flag2" name="std_invoice_flag" value="N" <% if (!CommonUtil.nvl(_rowData.get("STD_INVOICE_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;아니오
                        		<input type="hidden" id="st_std_invoice_flag" name="st_std_invoice_flag" value="<%=CommonUtil.nvl(_rowData.get("STD_INVOICE_FLAG"))%>" />
	                      	</td>
	                    </tr>
	                    <tr>
	                        <th scope="row">5단계카테고리</th>
	                      	<td>
	                      		<input type="radio" id="five_categ_flag1" name="five_categ_flag" value="Y" <% if (CommonUtil.nvl(_rowData.get("FIVE_CATEG_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;예&nbsp;&nbsp;&nbsp;
                        		<input type="radio" id="five_categ_flag2" name="five_categ_flag" value="N" <% if (!CommonUtil.nvl(_rowData.get("FIVE_CATEG_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;아니오
                        		<input type="hidden" id="st_five_categ_flag" name="st_five_categ_flag" value="<%=CommonUtil.nvl(_rowData.get("FIVE_CATEG_FLAG"))%>" />
	                      	</td>
	                        <th scope="row">부가세포함여부</th>
	                      	<td>
	                      		<input type="radio" id="vat_flag1" name="vat_flag" value="Y" <% if (CommonUtil.nvl(_rowData.get("VAT_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;예&nbsp;&nbsp;&nbsp;
                        		<input type="radio" id="vat_flag2" name="vat_flag" value="N" <% if (!CommonUtil.nvl(_rowData.get("VAT_FLAG")).equals("Y")) { %>checked="checked"<% } %> />&nbsp;아니오
                        		<input type="hidden" id="st_vat_flag" name="st_vat_flag" value="<%=CommonUtil.nvl(_rowData.get("VAT_FLAG"))%>" />
	                      	</td>
	                    </tr>
					</tbody>
				</table>
</div>

				<p class="pt20" style="font-weight:bold;">[매익율 관리]</P>
				<table  class="cont_t_list06" style="width:100%;">
	                <caption>매익율 관리</caption>
	                <colgroup>
	                    <col width="130px" />
	                    <col width="32%" />
	                    <col width="130px" />
	                    <col width="30%" />
	                </colgroup>
	                <tbody>
						<tr>
							<th scope="row">시작월</th>
	                        <td>
	                        	<input type="text" id="st_from_date" name="st_from_date" class="input_type_text" title="" style="width:43%;" value="<%=CommonUtil.nvl(_rowData.get("FROM_DATE"))%>"  readonly />
	                        	<script>kepSetCalenderYearMonth("st_from_date"); $("#st_from_date").val("<%=CommonUtil.nvl(_rowData.get("FROM_DATE"))%>");</script>
	                        </td>
	                        <th scope="row">종료월</th>
	                        <td>
	                        	<input type="text" id="st_to_date" name="st_to_date" class="input_type_text" title="" style="width:42%;" value="<%=CommonUtil.nvl(_rowData.get("TO_DATE"))%>"  readonly />
	                        	<script>kepSetCalenderYearMonth("st_to_date"); $("#st_to_date").val("<%=CommonUtil.nvl(_rowData.get("TO_DATE"))%>");</script>
	                        </td>
						</tr>
						<tr>
	                        <th scope="row">매익율</th>
	                      	<td><input type="text" id="st_rate" name="st_rate" class="input_type_text" title=""  maxlength="50" style="width:52%;" value="<%=CommonUtil.nvl(_rowData.get("RATE"))%>"  onkeyup="fnCheckInputByte(this, 50);" onchange="fnCheckInputByte(this, 50);"/></td>
	                        <th scope="row">계약방식</th>
	                      	<td>
	                      		<select id="st_contract_flag" name="st_contract_flag" style="width:55%;">
	                      			<option value="F" <%=CommonUtil.nvl(_rowData.get("CONTRACT_FLAG")).equals("F") ? "selected" : "" %>>Fee-base</option>
	                      			<option value="N" <%=CommonUtil.nvl(_rowData.get("CONTRACT_FLAG")).equals("N") ? "selected" : "" %>>일반</option>
	                      		</select>
	                      	</td>
	                    </tr>
	                    <tr>
	                        <th scope="row">산정구분</th>
	                      	<td>
	                      		<select id="st_rate_gubun" name="st_rate_gubun" style="width:55%;">
	                      			<option value="B" <%=CommonUtil.nvl(_rowData.get("RATE_GUBUN")).equals("B") ? "selected" : "" %>>매입가기준</option>
	                      			<option value="S" <%=CommonUtil.nvl(_rowData.get("RATE_GUBUN")).equals("S") ? "selected" : "" %>>매출가기준</option>
	                      		</select>
	                      	</td>
	                        <th scope="row">수정여부</th>
	                      	<td>
	                      		<select id="st_rate_edit_flag" name="st_rate_edit_flag" style="width:55%;">
	                      			<option value="">선택</option>
	                      			<option value="Y" <%=CommonUtil.nvl(_rowData.get("RATE_EDIT_FLAG")).equals("Y") ? "selected" : "" %>>수정가능</option>
	                      			<option value="N" <%=CommonUtil.nvl(_rowData.get("RATE_EDIT_FLAG")).equals("N") ? "selected" : "" %>>수정불가</option>
	                      		</select>
	                      	</td>
	                    </tr>
					</tbody>
				</table>	
				<p class="pt20" style="font-weight:bold;">[SG별 매익율 관리]</P>
				<div class="ib_product" style="border-top:2px solid #3c639c">
					<script type="text/javascript">
						createIBSheet("mySheet2", "100%", "182px");
					</script>
				</div>
				<div id="userInfo"  style='display:<%=CommonUtil.nvl(_rowData.get("STATUS")).equals("S") ? "block" : "none" %>;'>
				<p class="pt20" style="font-weight:bold;">[Admin 사용자정보]</P>
				<table  class="cont_t_list06" style="width:100%;">
	                <caption>Admin 사용자정보</caption>
	                <colgroup>
	                    <col width="120px" />
	                    <col width="32%" />
	                    <col width="120px" />
	                    <col width="30%" />
	                </colgroup>
	                <tbody>
						<tr>
							<th scope="row">사용자ID</th>
	                        <td colspan="3">
	                        	<%=CommonUtil.nvl(_rowData.get("USER_ID"))%>
	                        	<input type="hidden" id="buyer_user_id" name="buyer_user_id" value="<%=CommonUtil.nvl(_rowData.get("USER_ID"))%>" />
	                        </td>
						</tr>
	                    <tr>
	                        <th scope="row" class="star">이름(국문)</th>
	                      	<td><input type="text" id="st_user_name_loc" name="st_user_name_loc" class="input_type_text" title="" style="width:160px;"  maxlength="40" onkeyup="fnCheckInputByte(this, 40);" onchange="fnCheckInputByte(this, 40);" value="<%=CommonUtil.nvl(_rowData.get("USER_NAME_LOC"))%>" /></td>
	                        <th scope="row" class="star">이름(영문)</th>
	                      	<td><input type="text" id="st_user_name_eng" name="st_user_name_eng" class="input_type_text" title="" style="width:160px; ime-mode:disabled;""  maxlength="40" value="<%=CommonUtil.nvl(_rowData.get("USER_NAME_ENG"))%>" /></td>
	                    </tr>
	                    <tr>
	                        <th scope="row" class="star">E-MAIL</th>
	                      	<td><input type="text" id="st_email" name="st_email" class="input_type_text" title="" style="width:160px;"  maxlength="50" onkeyup="fnCheckInputByte(this, 50);" onchange="fnCheckInputByte(this, 50);" value="<%=CommonUtil.nvl(_rowData.get("EMAIL"))%>" /></td>
	                        <th scope="row" class="star">핸드폰</th>
	                      	<td><input type="text" id="st_mobile_phone" name="st_mobile_phone" class="input_type_text" title="" style="width:160px;"  maxlength="20" value="<%=CommonUtil.nvl(_rowData.get("MOBILE_PHONE"))%>" onkeyup="fnPhoneNumberCheck('st_mobile_phone');" onchange="fnPhoneNumberCheck('st_mobile_phone');" /></td>
	                    </tr>
	                    <tr>
	                        <th scope="row" class="star">전화번호</th>
	                      	<td><input type="text" id="st_phone_number" name="st_phone_number" class="input_type_text" title="" style="width:160px;"  maxlength="20" value="<%=CommonUtil.nvl(_rowData.get("PHONE_NUMBER"))%>"  onkeyup="fnPhoneNumberCheck('st_phone_number');" onchange="fnPhoneNumberCheck('st_phone_number');" /></td>
	                        <th scope="row">팩스번호</th>
	                      	<td><input type="text" id="st_user_fax_no" name="st_user_fax_no" class="input_type_text" title="" style="width:160px;"  maxlength="20" value="<%=CommonUtil.nvl(_rowData.get("FAX_NUMBER"))%>" onkeyup="fnPhoneNumberCheck('st_user_fax_no');" onchange="fnPhoneNumberCheck('st_user_fax_no');" /></td>
	                    </tr>
					</tbody>
				</table>
				</div>
			</div>	
				<!--버튼영역-->
				<p class="btnArea mt10 mb05"> 
					<% if (CommonUtil.nvl(_rowData.get("STATUS")).equals("S") || CommonUtil.nvl(_rowData.get("STATUS")).equals("B") || CommonUtil.nvl(_rowData.get("STATUS")).equals("E")) { %>
					<span class="btn_02"><a href="javascript:doAction('save', 'C'); ">품의</a></span>
					<span class="btn_05"><a href="javascript:doAction('marginsave');">매익율 저장</a></span>
					<span class="btn_02"><a href="javascript:doAction('save','S');">저장</a></span>
					<% } else { %>
					<span class="btn_02"><a href="javascript:doAction('save','S');">저장</a></span>
					<% } %>
				</p>
				<% } %>
		</div>
	</div>
</form> 
</body>
</html>
