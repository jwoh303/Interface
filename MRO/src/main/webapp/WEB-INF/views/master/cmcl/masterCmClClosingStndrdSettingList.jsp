<%--
**********************************************
* 메뉴 : 마감관리>마감기준설정
* 화면 : 마감기준설정
* 기능 :
* 프로그램 ID : PG_10_M_001_00
* 담당자 : 최명진 ( 설계 : 김상근 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>

<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

var unit01 = KepSheetComboData("TX03", "");		// IBSHEET : 발행주체
var unit02 = KepSheetComboData("TX09", "");		// IBSHEET : 발행사이트

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
		 { Align:"Center",Width:60,		Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",			Header:"상태",				SaveName:"sStatus"}
		,{ Align:"Center",	Width:30,		Edit:true,	EditLen:30,	Hidden:false,	Type:"DummyCheck",	Header:"",						SaveName:"SELECTED"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"당사사업장",		SaveName:"KEP_IRS_NAME"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"사이트구분",		SaveName:"SITE_GUBUN_NAME"}
		,{ Align:"Center",	Width:90,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"팀구분",				SaveName:"KEP_DEPT"}
		,{ Align:"left",		Width:150,	Edit:false,	EditLen:190,	Hidden:false,	Type:"Text",				Header:"회원사",				SaveName:"COM_NAME"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:120,	Hidden:false,	Type:"Text",				Header:"사업자등록번호",	SaveName:"BUYER_IRS_NO"}
		,{ Align:"Center",	Width:80,		Edit:true,	EditLen:80,	Hidden:false,	Type:"Combo",			Header:"마감횟수",			SaveName:"CLOSE_CNT",			FontColor:"#1e90ff",		ComboText:"1회|2회|3회", 			ComboCode:"1|2|3"}
		,{ Align:"Center",	Width:80,		Edit:true,	EditLen:80,	Hidden:false,	Type:"Combo",			Header:"발행주체",			SaveName:"BILL_TYPE", 			FontColor:"#1e90ff",		ComboText:unit01.ComboText, 	ComboCode:unit01.ComboCode}
		,{ Align:"Center",	Width:80,		Edit:true,	EditLen:80,	Hidden:false,	Type:"Combo",			Header:"발행사이트",		SaveName:"BILL_CODE",			FontColor:"#1e90ff",		ComboText:unit02.ComboText, 	ComboCode:unit02.ComboCode}
		,{ Align:"Center",	Width:80,		Edit:false,	EditLen:80,	Hidden:false,	Type:"Text",				Header:"담당자(정)",			SaveName:"KEP_USER1_NAME"}
		,{ Align:"Center",	Width:80,		Edit:false,	EditLen:80,	Hidden:false,	Type:"Text",				Header:"담당자(부)",			SaveName:"KEP_USER2_NAME"}
		,{ Align:"Left",	Width:120,	Edit:true,	EditLen:20,	Hidden:false,	Type:"Text",				Header:"회원사담당자",		SaveName:"AC_USER_NAME",		BackColor:"${optColor}"}
		,{ Align:"Left",	Width:120,	Edit:true,	EditLen:25,	Hidden:false,	Type:"Text",				Header:"회원사전화",		SaveName:"AC_USER_PHONE",	BackColor:"${optColor}"}
		,{ Align:"Left",	Width:120,	Edit:true,	EditLen:25,	Hidden:false,	Type:"Text",				Header:"회원사팩스",		SaveName:"AC_USER_FAX",		BackColor:"${optColor}"}
		,{ Align:"Left",	Width:120,	Edit:true,	EditLen:50,	Hidden:false,	Type:"Text",				Header:"회원사이메일",		SaveName:"AC_USER_EMAIL",		BackColor:"${optColor}"}
		,{ Align:"Left",	Width:100,	Edit:true,	EditLen:7,		Hidden:true,	Type:"Text",				Header:"고객사우편번호",	SaveName:"AC_USER_ZIP",			BackColor:"${optColor}"}
		,{ Align:"Left",	Width:150,	Edit:true,	EditLen:50,	Hidden:true,	Type:"Text",				Header:"고객사주소",		SaveName:"AC_USER_ADD",		BackColor:"${optColor}"}
		,{ Align:"Center",	Width:90,		Edit:false,	EditLen:90,	Hidden:false,	Type:"Text",				Header:"회원사코드",		SaveName:"COM_CODE"}
		,{ Align:"Center",	Width:90,		Edit:false,	EditLen:90,	Hidden:false,	Type:"Text",				Header:"담당자코드",		SaveName:"AC_CODE"}
		,{ Align:"Right",	Width:90,		Edit:false,	EditLen:90,	Hidden:true,	Type:"Text",				Header:"사이트구분",		SaveName:"SYS_TYPE"}
		,{ Align:"Right",	Width:90,		Edit:false,	EditLen:90,	Hidden:true,	Type:"Text",				Header:"BUSINESS_CON",	SaveName:"BUSINESS_COND"}
	];

	IBS_InitSheet(mySheet, initsheet, pagingMode);
	mySheet.SetCountPosition(4); // 데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]

	// 콤보데이터 셋팅
	//kepAjaxCommonQueryIdCombo('st_dept','common.masterCodeList','ALL','');													// 조회조건 : 해당팀
	kepAjaxCommonQueryIdCombo('st_dept','getKepDeptList','ALL','${sessionInfo.department}');
	kepAjaxCommonQueryIdSearchTwoCombo('st_user','common.masterDepartmentUserList','PG_10_M_001_00','','ALL','');	// 조회조건 : 담당자
	kepAjaxCommonCombo('st_bill_type','TX03','ALL');																					// 조회조건 : 발행방법
}

function checkLoc(){
	var search = kepSelectOptionVal('st_dept');
	kepAjaxCommonQueryIdSearchTwoCombo("st_user","common.masterDepartmentUserList",'PG_10_M_001_00',search,"ALL","");
}

var st;
var mt;

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
	if (str !="search" && str !="excelDown" && str !="reload" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
		case "search": // 조회
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/cmcl/getMasterCmClClosingStndrdSettingList.do" , pagingMode );
			break;
	
		case "reload": // 초기화
			kepReload('searchCondition');
			$("#st_dept").val("${sessionInfo.department}");
			mySheet.RemoveAll();
			break;
	
		case "save": // 저장
			if ( !validationSave() )
				return;
			if (!confirm('선택한 항목을 저장 하시겠습니까?'))
				return;
			kepSave(document.searchCondition ,  mySheet , "/cmcl/saveMasterCmClClosingStndrdSettingList.do" , "SELECTED" );
			break;
	
		case "excelDown": // 엑셀다운로드
			var param = {FileName:"마감기준조회.xlsx",Merge:1,SheetDesign:1,DownCols:"KEP_IRS_NAME|SITE_GUBUN_NAME|KEP_DEPT|COM_NAME|BUYER_IRS_NO|CLOSE_CNT|BILL_TYPE|BILL_CODE|KEP_USER1_NAME|KEP_USER2_NAME|AC_USER_NAME|AC_USER_PHONE|AC_USER_FAX|AC_USER_EMAIL|AC_USER_ZIP|AC_USER_ADD|COM_CODE|AC_CODE"};
			kepDownExcel(document.searchCondition ,mySheet , "/cmcl/excelMasterCmClClosingStndrdSettingList.do", param);
			break;
	}
}
//팝업함수호출
function doPop(str, params) {
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");
	
	switch (str) {
	case "masterCmClStndSettingPop": // 담당자추가및 변경
		var cnt = 0;
		var buyer_code = "";
		var buyer_irs_no = "";
		var buyer_name = "";
		for (var i=0; i<arrRow.length; i++){
			cnt++;
			buyer_code = mySheet.GetCellValue(arrRow[i],"COM_CODE");
			buyer_irs_no = mySheet.GetCellValue(arrRow[i],"BUYER_IRS_NO");
			buyer_name = mySheet.GetCellValue(arrRow[i],"COM_NAME");
		}
		if(cnt >1){
			alert("다중 선택이 불가능 합니다.");
			return;
		}
		if(selectedGrid.length == 0){
			alert("선택된 항목이 없습니다.");
			return;			
		}
		openSearchPopup("/cmcl/showMasterCmClStndSettingPop.do", '?buyer_code='+buyer_code+'&buyer_irs_no='+buyer_irs_no+'&buyer_name='+buyer_name, "800,340,no");
		break;
	}
}

function mySheet_OnDownFinish(downloadType, result) {

    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거

}
// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if (msg != "") {
		alert(msg);
	}
}

// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
	if (msg != "") {
		alert(msg);
	}

	if(code>0){
		//저장 성공시 재조회
		doAction('search');
	}
}

// Valitation - 저장
function validationSave() {
	var checkVal = true;
	
	for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
		if ( mySheet.GetCellValue(i, "SELECTED") == 1 ) {
			// 우편번호 유효성 체크
			/*if ( mySheet.GetCellValue(i, "AC_USER_ZIP") != '' ) {
				var firstNum = mySheet.GetCellValue(i, "AC_USER_ZIP").substring(0,3);
				var hyphen = mySheet.GetCellValue(i, "AC_USER_ZIP").substring(3,4);
				var secondNum = mySheet.GetCellValue(i, "AC_USER_ZIP").substring(4,7);
				
				if ( !$.isNumeric(firstNum) ) {
					checkVal = false;
				}
				if ( hyphen != '-' ) {
					checkVal = false;
				}
				if ( !$.isNumeric(secondNum) ) {
					checkVal = false;
				}
				if ( !checkVal ) {
					alert(i + "번째 우편번호가 형식에 맞지 않습니다.\n\n[ 예) 123-456 ]");
					return checkVal;
				}
			}
			*/
			// 이메일 유효성 체크
			if ( mySheet.GetCellValue(i, "AC_USER_EMAIL") != '' ) {
				if ( !kepIsValidEmailValue(mySheet.GetCellValue(i, "AC_USER_EMAIL")) ) {
					alert(i + "번째 이메일이 형식에 맞지 않습니다.");
					return false;
				}
			}
		}
	}
	
	return true;
}
</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
	<!--버튼영역-->
	<div id="searchBtnA"  >
		<h3>마감기준설정</h3>
       	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span>
	    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
	</div>
	<!--조회영역-->
    <form name = "searchCondition" method = "post" onsubmit="return false" >
		<div id="cont_searchA">
		<!--HIDDEN-->
		<!-- 공통 -->
		<input type="hidden" name="s_SAVENAME">
		<!-- 화면 내 정의 -->
		<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">

           	<table  class="cont_t_list01" >
				<caption>마감기준설정</caption>
				<colgroup>
					<col width="30px" />
					<col width="25%" />
					<col width="30px" />
					<col width="25%" />
					<col width="30px" />
                    <col width="25%" />
				</colgroup>

				<tbody>
					<tr>
						<th>회원사</th>
						<td>
							<input type="text" class="input_type_text" id="st_com_name" name="st_com_name" style="width:80%;" value="" onkeydown="kepEnter()">
						</td>
						<th>해당팀</th>
						<td>
							<select id="st_dept" name="st_dept" style="width:80%;height:20px" onChange="checkLoc()"></select>
						</td>
						<th>담당자</th>
						<td>
							<select id="st_user" name="st_user" style="width:80%;height:20px"></select>
						</td>
					</tr>
					<tr>
						<th>마감횟수</th>
						<td>
							<select id="st_close_cnt" name="st_close_cnt"	>
								<option value="">전체</option>
								<option value="1">1 회</option>
								<option value="2">2 회</option>
								<option value="3">3 회</option>
							</select>
						</td>
						<th>발행방법</th>
						<td>
							<select id="st_bill_type" name="st_bill_type" style="width:80%;height:20px"></select>
						</td>
						<th>사업자등록번호</th>
						<td>
							<input type="text" class="input_type_text" id="st_irs_no" name="st_irs_no" style="width:80%;" value="" onkeydown="kepEnter()">
						</td>
					</tr>
				</tbody>
			</table>
		</div>

      	<!--grid-->
		<div class="ib_product" style="border-top:2px solid #3c639c; padding-bottom:10px;">
			<script type="text/javascript">
				createIBSheet("mySheet", "100%", "354px");
			</script>
		</div>

		<!--버튼영역-->
        <div class="btnArea">
          	<span class="fl">
				<span class="btn_05" style="display:none"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
			</span>

			<span class="fr">
				<span class="btn_05 mr04"><a href="javascript:doPop('masterCmClStndSettingPop');">회원사담당자추가</a></span>
				<span class="btn_02"><a href="javascript:doAction('save');">저장</a></span>				
			</span>
		</div>
	</form>
<!--내용 종료-->

</body>
</html>
