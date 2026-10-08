<%--
**********************************************
* 메뉴 : 회원사관리>고객사관리>SAP 코드 관리
* 화면 : 고객사의 SAP코드 관리
* 기능 : 고객사의 SAP코드 관리
* 프로그램 ID : PG_01_M_099_00
* 담당자 : 이수영 ( 설계 : 권우재 )
* 착수일 : 2014-06-012
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>

<script type="text/javascript">

var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;
var sapOn="/resources/images/but_img_on.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
					{ Align:"Center",	SaveName:"sStatus",					Header:"상태",				Type:"Status",				Width:60,		Edit:false,	EditLen:0,		Hidden:true}
					,{ Align:"Center",	SaveName:"SELECTED",					Header:"",						Type:"DummyCheck",		Width:60,		Edit:true,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"BUSINESS_COND",		Header:"회원사구분",		Type:"Text",					Width:100,	Edit:false,	EditLen:0,		Hidden:true}
					,{ Align:"Center",	SaveName:"BUSINESS_COND_TEXT",	Header:"회원사구분",		Type:"Text",					Width:100,	Edit:false,	EditLen:0,		Hidden:false}
					,{ Align:"Center",	SaveName:"COM_CODE",				Header:"회원사코드",		Type:"Text",					Width:120,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Left",	SaveName:"COM_NAME",				Header:"회원사명",			Type:"Text",					Width:300,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"IRS_NO",					Header:"사업자등록번호",	Type:"Text",					Width:120,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"SAP_CODE",				Header:"회원사SAP코드",	Type:"Text",					Width:140,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"SAP_IMG",					Header:"조회",				Type:"Image",				Width:40,		Edit:false,	EditLen:110,	Hidden:false}
	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode, 8);
	//검색 이미지설정
	mySheet.SetImageList(1, sapOn);
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "SAP_IMG");
}
	
var st;
var mt;
// 기능함수
function doAction(str) {
	st = new Date();
	var selectedGrid	= mySheet.FindCheckedRow("SELECTED");
	var arrRow		= selectedGrid.split("|");
	
	// 선택된 항목 유무 체크
	if (str !="search" && str !="excelDown" && str !="reload" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
		case "search":	 // 조회
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mdct/getMasterSapInterfaceManageList.do" , pagingMode );
			break;
		case "reload":	// 초기화
			kepReload('searchCondition');
			mySheet.RemoveAll();
			break;
		case "sapcode":
			kepAjaxFormCall("/mdct/getMasterSapInterfaceManageSapCode.do", "searchCondition", str);
			break;
		case "sapList":
			$("#st_irsNo").val("");
			$("#st_business_cond").val("");

			for (var j=0; j < arrRow.length; j++) {
				
				if ((isInStr(mySheet.GetCellValue(arrRow[j], "IRS_NO"),$("#st_irsNo").val(), "|"))) {
					if (mySheet.GetCellValue(arrRow[j], "IRS_NO") !="" && mySheet.GetCellValue(arrRow[j], "SAP_CODE") == "") {
						$("#st_irsNo").val($("#st_irsNo").val() + mySheet.GetCellValue(arrRow[j], "IRS_NO") + "|");
						$("#st_business_cond").val($("#st_business_cond").val() + mySheet.GetCellValue(arrRow[j], "BUSINESS_COND") + "|");
					}
				}
			}

			kepAjaxFormCall("/mdct/getMasterSapInterfaceManageSapCodeList.do","searchCondition","sapList");
			break;
	
		case "save":
			if(!confirm("SAP코드를 저장 하시겠습니까?"))
	 			return;
			// 시트 각 컬럼의 이름을 S_SAVENAME 객체에 담는다.
			IBS_SaveName(document.searchCondition,mySheet);

			// 조회조건 묶기
			kepSave(document.searchCondition ,  mySheet , "/mdct/saveMasterSapInterfaceManageList.do" , "SELECTED" );
			break;
	}
}

/**
* ajax 공통 호출후 성공시 처리 함수
*/ 
function kepAjaxSuccess(pMethod , response) {
	var sMsg = response.msg;

	if (pMethod == "sapcode") {
		if (sMsg == "OK") {
			mySheet.SetCellValue(grbRow, 'SAP_CODE', response.sapCode);
		} else if (sMsg == "0") {
			mySheet.SetCellValue(grbRow, 'SELECTED', 0);
			alert("SaP 시스템에 등록되지 않은 고객사입니다.\n\n해당 담당자에게 SaP코드 생성요청 하여 주십시요.");
		} else {
			mySheet.SetCellValue(grbRow, 'SELECTED', 0);
			alert("SAP코드 가져오는데 실패 했습니다.");
		}
	} else if (pMethod == "sapList") {
		var selRows = mySheet.FindCheckedRow("SELECTED").split("|");
		var irsNoList = response.irsNo.split("|");
		var sapCodeList = response.sapCode.split("|");

		if (sMsg == "OK") {
			for (var j=0; j < selRows.length; j++) {
				for (var k = 0;k < sapCodeList.length; k++ ) {
					if (mySheet.GetCellValue(selRows[j], "SAP_CODE") == "" && irsNoList[k] == mySheet.GetCellValue(selRows[j], "IRS_NO").replace(/-/gi,"")) {
						mySheet.SetCellValue(selRows[j], 'SAP_CODE', sapCodeList[k]);
					}
				}
			}
		} else if (sMsg == "0") {
			mySheet.CheckAll(1, 0);
			alert("SaP 시스템에 등록되지 않은 고객사입니다.\n\n해당 담당자에게 SaP코드 생성요청 하여 주십시요.");
		}
	}
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	alert(response.Message);
} 

// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if (msg != "") {
		alert(msg);
	}

	if (current_page==-1) {
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	} else {
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
}

//트랜젝션(저장,삽입등) 후처리
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
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mdct/getMasterSapInterfaceManageList.do?page="+current_page , pagingMode );
}

// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'SAP_IMG') { // 요청자
		if (mySheet.GetCellValue(Row, "IRS_NO") != "" && mySheet.GetCellValue(Row, "SAP_CODE") == "") {
			$("#st_irsNo").val(mySheet.GetCellValue(Row, "IRS_NO"));
			$("#st_business_cond").val(mySheet.GetCellValue(Row, "BUSINESS_COND"));
			mySheet.SetCellValue(Row, 'SELECTED', 1);
			doAction("sapcode");
		}
	}
	return;
}

//그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		doAction('search');
	}
}

function isInStr(str, arrStr, flag) {
	var arrIrsNo = arrStr.split(flag);
	return jQuery.inArray(str, arrIrsNo);
}
</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>SAP 코드 관리 조회</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form id="searchCondition" name="searchCondition" method = "post" onsubmit="return false" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_flag" name="st_flag"  value="" />
			<input type="hidden" id="st_irsNo" name="st_irsNo"  value="" />
			<input type="hidden" id="st_business_cond" name="st_business_cond"  value="" />
			
            	<table  class="cont_t_list01" >
					<caption>고객사등록관리 조회</caption>
					<colgroup>
						<col width="8%" />
						<col width="17%" />
						<col width="8%" />
						<col width="17%" />
						<col width="8%" />
                        <col width="17%" />
                        <col width="8%" />
                        <col width="*" />
					</colgroup>
						
					<tbody>
						<tr> 
							<td>고객사</td>
							<td style="text-align:left;">
								<input type="text" id="st_com_name_loc" name="st_com_name_loc" class="input_type_text"  style="width:80%" value=""  onkeydown="kepEnter();" />
							</td>
							<td>SAP코드</td>
							<td>
								<input type="text" id="st_sap_code" name="st_sap_code"  class="input_type_text" style="width:80%;" value="" onkeyup="kepToUpper('st_sap_code')" onkeydown="kepEnter();" />
							</td>
							<td>사업자번호</td>
							<td>
								<input type="text" id="st_irs_no" name="st_irs_no"  class="input_type_text" style="width:80%;" value="" onkeyup="kepToUpper('st_sap_code')" onkeydown="kepEnter();" />
							</td>
							<td>SAP코드유무</td>
							<td>
								<select name="st_sap_code_yn" style="width: 80%;" >
									<option value="">전체</option>
									<option value="Y">유</option>
									<option value="N">무</option>
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
  				<span class="fr">
  					<span class="btn_02 mr04"><a href="javascript:doAction('save');">저장</a></span>
  					<span class="btn_06 mr04"><a href="javascript:doAction('sapList');">SAP코드가져오기</a></span>
  				</span>
  			 </div>
<!--내용 종료-->	                 

</body>
</html>
