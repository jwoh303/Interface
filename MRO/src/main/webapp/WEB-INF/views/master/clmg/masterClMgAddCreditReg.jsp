<%--
**********************************************
* 메뉴 : 여신관리>추가여신 등록
* 화면 : 추가여신 등록
* 기능 :
* 프로그램 ID : U_01_M_001_02
* 담당자 : 한승준 ( 설계 : 옥대수 )
* 착수일 : 2015-10-20
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
// 공통
	String sessionEmpNo = _sessionInfo.getEmpNo();
	String userNameLoc =  _sessionInfo.getUserNameLoc();
	String userId =  _sessionInfo.getUserId();
%> 
<!-- 다중선택콤보(공통) - 사용시 필수 선언 start -->
<script src="/resources/js/jquery.multiple.select.js"></script>
<link rel="stylesheet" href="/resources/styles/multiple-select.css" type="text/css" />
<!-- 다중선택콤보(공통) - 사용시 필수 선언 end -->

<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

var manageDept = KepSheetComboQueryIdData('getKepDeptList','SEL','');	// IBSHEET : 담당부서

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var remarkOn="/resources/images/btn_search03.gif";
	var remarkOff="/resources/images/btn_search03.gif";
	var initsheet = {};
	initsheet.Cols = [
					{ Align:"Center",	Width:60,	Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",				Header:"상태",							SaveName:"sStatus"}
					,{ Align:"Center",	Width:30,	Edit:true,	EditLen:30,		Hidden:false,	Type:"DummyCheck",	Header:"",								SaveName:"SELECTED"}
					,{ Align:"Center",	Width:30,	Edit:false,	EditLen:30,		Hidden:true,	Type:"Text",					Header:"LOAN_NO",					SaveName:"LOAN_NO"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:190,	Hidden:true,	Type:"Text",					Header:"그룹코드",					SaveName:"GROUP_CODE"}
					,{ Align:"left",		Width:150,	Edit:false,	EditLen:190,	Hidden:true,	Type:"Text",					Header:"그룹",							SaveName:"GROUP_NAME"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:190,	Hidden:true,	Type:"Text",					Header:"법인코드",					SaveName:"CORP_CODE"}
					,{ Align:"left",		Width:150,	Edit:false,	EditLen:190,	Hidden:true,	Type:"Text",					Header:"법인",							SaveName:"CORP_NAME"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:120,	Hidden:false,	Type:"Text",					Header:"사업자등록번호",			SaveName:"IRS_NO"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:90,		Hidden:true,	Type:"Text",					Header:"고객사코드",				SaveName:"COM_CODE"}
					,{ Align:"left",		Width:200,	Edit:false,	EditLen:190,	Hidden:false,	Type:"Text",					Header:"고객사",						SaveName:"COM_NAME"}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:95,		Hidden:false,	Type:"Text",					Header:"사업팀",						SaveName:"DEPT_NAME"}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:95,		Hidden:true,	Type:"Text",					Header:"사업팀",						SaveName:"DEPT_CODE"}
					,{ Align:"right",	Width:120,	Edit:false,	EditLen:95,		Hidden:false,	Type:"Float",				Header:"여신한도(기초금액)",		SaveName:"BASE_AMT"}
					,{ Align:"right",	Width:120,	Edit:false,	EditLen:95,		Hidden:false,	Type:"Float",				Header:"추가여신금액",		SaveName:"ADD_CREDIT_LIMIT_AMT"}
					,{ Align:"right",	Width:100,	Edit:true,	EditLen:95,		Hidden:false,	Type:"Float",				Header:"여신감액(-)",						SaveName:"MINUS_ROAN",			BackColor:"${notnullColor}",	KeyField:true}
					,{ Align:"right",	Width:100,	Edit:true,	EditLen:95,		Hidden:false,	Type:"Float",				Header:"여신증액(+)",						SaveName:"ADD_ROAN",			BackColor:"${notnullColor}",	KeyField:true}
					,{ Align:"left",	Width:150,	Edit:true,	EditLen:95,		Hidden:false,	Type:"Text",				    Header:"비고",						SaveName:"REMARK",			BackColor:"${notnullColor}"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:95,		Hidden:true,	Type:"Image",				Header:"추가여신등록",		SaveName:"ADD_ROAN"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:95,		Hidden:false,	Type:"Image",				Header:"추가여신상세",		SaveName:"ADD_ROAN_HIS"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Date",				Header:"등록일",						SaveName:"REG_DATE"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",					Header:"등록시간",					SaveName:"REG_TIME"}

];
	
	initsheet.Cfg = {MergeSheet:msHeaderOnly};
	
	// 사업팀 콤보박스
	kepAjaxCommonQueryIdCombo('st_dept','getKepDeptList','ALL','');
	
	IBS_InitSheet(mySheet, initsheet,pagingMode, 'XLS');
	//비고이미지설정
	mySheet.SetImageList(1, remarkOn);
	mySheet.SetImageList(0, remarkOff);
	//데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]
	mySheet.SetCountPosition(4);

}

// 기능함수
function doAction(str) {

	switch (str) {
	case "search":	 // 조회

		kepSearch(document.searchCondition,  mySheet , "/clmg/getMasterClMgAddCreditReg.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		mySheet.RemoveAll();

		break;

	case "save": // 저장
		if ( !validationSave() )
			return;
		gw_aprv();
		break;

	case "del":	//삭제
		if ( !validationDel() )
			return;
		if (selectedGrid.length == 0){
			alert("삭제할 대상을 선택해 주십시요.");
			return;
		}
		if (!confirm("선택한 항목을 삭제 하시겠습니까?")) {
			return;
		}else{
			kepSave(document.searchCondition, mySheet , "/clmg/deleteMasterClMgAddCreditReg.do", "SELECTED");
		}		
		break;
	case "AddLoan": //여신추가
		kepAjaxFormCall("/mdcd/saveMasterMdCdBuyerCardManageList.do","searchCondition", "addLoan");
	
		break;
	}
}


//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	var sMsg = response.msg;
	
	if (pMethod == "addLoan") {
		if (sMsg == 'OK') {
			alert("등록이 완료 되었습니다.");
         	// 처리후 재조회
    		doAction("search");
		} else {
			alert("추가등록 요청이 실패 하였습니다.\n다시 확인하여 주십시요");
            return;
		}
	}
}
/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	var msg = response.Message;
	
	if (msg != ""){
		alert(msg);
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
	
	if(!checkedSession(stCode)){
		return;
		}	

	if (msg != ""){
		alert(msg);
	}
}
	
// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	
	if(!checkedSession(stCode)){
		return;
	}
	if (msg != ""){
		alert(msg);
	}
	
	if(code>0){
		//저장 성공시 재조회
		doAction('search');
	}
}

function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
}
var grbRow = "";
//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	if (column == "ADD_ROAN_HIS" ){ //여신이력 상세
		popupSel = "masterClmgLoanHistoryPop";
		var st_loan_no = mySheet.GetCellValue(Row, "LOAN_NO");
		var st_irs_no = mySheet.GetCellValue(Row, "IRS_NO");
		var st_dept_cd = mySheet.GetCellValue(Row, "DEPT_CODE");
		openSearchPopup("/clmg/showMasterClmgLoanHistoryPop.do", '?st_loan_no='+st_loan_no+'&st_irs_no='+st_irs_no+'&st_dept_cd='+st_dept_cd, "800,350,no");		
	}
	
}

function gw_aprv(){
	var st_link = "";
	var st_add_amt = "";
	var st_remark  = "";
	var st_user_id = "";
	if (mySheet.RowCount() == 0){
		alert("조회된 데이터가 없습니다.");
		return;
	}
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	if (selectedGrid.length == 0){
		alert("선택하신 품목이 없습니다.");
		return;
	}
	var bodyContents =
		"<style> .SmallTB{border:1px solid #000; font-size:12px} .SmallTB th{ height:30px;text-align:center; background-color:#e8f3f9;border-right:1px solid #000;border-bottom:1px solid #000;} .SmallTB td{ height:25px;border-bottom:1px solid #000;padding-left:5px} .SmallTbNoboder{border:0px solid #000; font-size:12px} </style>"+
		"<body>"+
		"<p style=\"font-size:12px\">상기 건과 관련하여 아래와 같이 품의하오니 검토 후 재가하여 주시기 바랍니다</p>"+
		"<br/>"+
    	"<p style=\"font-size:12px\">① 여신한도 변경</p>"+
		"<table class=\"SmallTB\" cellSpacing=\"0\" cellPadding=\"0\" width=\"100%\">"+
	  	"<tbody>"+
	  	"<colgroup>"+
	  	"<col width=\"15%\" />"+
	  	"<col width=\"18%\" />"+
	  	"<col width=\"18%\" />"+
	  	"<col width=\"13%\" />"+
	  	"<col width=\"13%\" />"+
	  	"<col width=\"13%\" />"+
	  	"<col width=\"*\" />"+
	  	"</colgroup>"+
	  	"<tr >"+
	    "<th >사업자번호</th>"+
	    "<th >고객사</th>"+
	    "<th >담당부서</th>"+
	    "<th >여신한도</th>"+
	    "<th >여신감액</th>"+
	    "<th >여신증액</th>"+
	    "<th >비고</th>";
		for(var i= 1 ; i<mySheet.GetTotalRows()+1; i++){
			if ( mySheet.GetCellValue(i, "SELECTED") == '1' ) {
				st_link += mySheet.GetCellValue(i, "LOAN_NO")+"^"+mySheet.GetCellValue(i, "IRS_NO")+"^"+mySheet.GetCellValue(i, "DEPT_CODE")+ ",";
				st_add_amt += mySheet.GetCellValue(i, "MINUS_ROAN")+"^"+mySheet.GetCellValue(i, "ADD_ROAN")+ ",";
				st_remark += mySheet.GetCellValue(i, "REMARK")+ ",";
				st_user_id += "<%=userId%>"+ ",";
				var amt = parseInt(mySheet.GetCellValue(i, "BASE_AMT"))+parseInt(mySheet.GetCellValue(i, "ADD_CREDIT_LIMIT_AMT"));
				bodyContents += "<tr>"  
					+"<td align=\"center\" style=\"border-right:1px solid #000;\">"+mySheet.GetCellValue(i, "IRS_NO")+"</td>"
					+"<td style=\"border-right:1px solid #000;\">"+ mySheet.GetCellValue(i, "COM_NAME")+"</td>"
					+"<td style=\"border-right:1px solid #000;\">"+ mySheet.GetCellValue(i, "DEPT_NAME")+"</td>"
					+"<td align=\"right\" style=\"border-right:1px solid #000;\">"+numberComma(amt)+ "원"
					+"<td align=\"right\" style=\"border-right:1px solid #000;\">"+numberComma(mySheet.GetCellValue(i, "MINUS_ROAN"))+ "원"
					+"<td align=\"right\" style=\"border-right:1px solid #000;\">"+numberComma(mySheet.GetCellValue(i, "ADD_ROAN"))+ "원"
					+"<td style=\"border-right:1px solid #000;\">"+ mySheet.GetCellValue(i, "REMARK")+"</td>"
					+"</tr>";
			}
		}
	  	bodyContents += "</tbody>"+
		"</table>"+
	    "<p style=\"font-size:12px\">②</p>";
	var form = document.createElement("form");
	form.setAttribute("method", "post");
	form.setAttribute("target", "_blank");
	form.setAttribute("action", "https://gw.koreab2b.com/jsp/kep_linkage/InQdbData.jsp");

	var hiddenField01 = document.createElement("input");
	hiddenField01.setAttribute("type", "hidden");
	hiddenField01.setAttribute("name", "DrafterCode");
	hiddenField01.setAttribute("value", <%=sessionEmpNo%>);
	form.appendChild(hiddenField01);
	var hiddenField02 = document.createElement("input");
	hiddenField02.setAttribute("type", "hidden");
	hiddenField02.setAttribute("name", "FormID");
	hiddenField02.setAttribute("value", "JHOMS160070008591000,LINK001");
	form.appendChild(hiddenField02);
	
	var hiddenField03 = document.createElement("input");
	hiddenField03.setAttribute("type", "hidden");
	hiddenField03.setAttribute("name", "LinkageKey");
	hiddenField03.setAttribute("value", "B04");
	form.appendChild(hiddenField03);
	
	var hiddenField04 = document.createElement("input");
	hiddenField04.setAttribute("type", "hidden");
	hiddenField04.setAttribute("name", "LinkageSub1");
	hiddenField04.setAttribute("value", st_link);
	form.appendChild(hiddenField04);
	
	var LinkageSub2 = document.createElement("input");
	LinkageSub2.setAttribute("type", "hidden");
	LinkageSub2.setAttribute("name", "LinkageSub2");
	LinkageSub2.setAttribute("value", st_add_amt);
	form.appendChild(LinkageSub2);
	
	var LinkageSub3 = document.createElement("input");
	LinkageSub3.setAttribute("type", "hidden");
	LinkageSub3.setAttribute("name", "LinkageSub3");
	LinkageSub3.setAttribute("value", st_remark);
	form.appendChild(LinkageSub3);
	
	var LinkageSub4 = document.createElement("input");
	LinkageSub4.setAttribute("type", "hidden");
	LinkageSub4.setAttribute("name", "LinkageSub4");
	LinkageSub4.setAttribute("value", st_user_id);
	form.appendChild(LinkageSub4);
	
	var LinkageSub5 = document.createElement("input");
	LinkageSub5.setAttribute("type", "hidden");
	LinkageSub5.setAttribute("name", "LinkageSub5");
	LinkageSub5.setAttribute("value", "");
	form.appendChild(LinkageSub5);			
	
	var hiddenField05 = document.createElement("input");
	hiddenField05.setAttribute("type", "hidden");
	hiddenField05.setAttribute("name", "SancTitle");
	hiddenField05.setAttribute("value", "[품의] 고객사 여신한도 변경 품의의 건");
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
	doAction('search');
}
function numberComma(number) {
    return number.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
} 
//Valitation - 저장
function validationSave() {
	var checkVal = true;
	
	for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
		if ( mySheet.GetCellValue(i, "SELECTED") == 1 ) {
			// 여신추가 유효성 체크
			if ( mySheet.GetCellValue(i, "MINUS_ROAN") == '' && mySheet.GetCellValue(i, "ADD_ROAN") == '') {
				checkVal = false;
			}
			if ( !checkVal ) {
				alert(i + " 번째 줄 : 여신감액 or 여신증액 입력은 필수입니다.");
				mySheet.SelectCell(i, "ADD_ROAN");
				return checkVal;
			}
		}
	}
	return true;
}

//Valitation - 삭제
function validationDel() {
	var checkVal = true;
	
	for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
		if ( mySheet.GetCellValue(i, "SELECTED") == 1 ) {
			// 사유 유효성 체크
			if ( mySheet.GetCellValue(i, "REASON") == '' ) {
				checkVal = false;
			}
			if ( !checkVal ) {
				alert(i + " 번째 줄 : 사유는 필수입니다.");
				mySheet.SelectCell(i, "REASON");
				return checkVal;
			}
		}
	}
	return true;
}

//TABLE의 ROW 데이타 생성
function addrows() {
	var maxRowCount = mySheet.RowCount();
	var checkFlag = false;
	
	if (maxRowCount == 0) {
		alert("조회된 데이터가 없습니다.");
		return;
	}else{
		for ( var i = 1; i <= maxRowCount; i++ ) {
			if ( mySheet.GetCellValue(i, "SELECTED") == 1 ) {
				
				var rows = mySheet.DataInsert(-1);				
				
				// 대분류, 중분류, 사업자등록번호, 고객사, 사업팀, 여신한도(기초금액) 복사
				mySheet.SetCellValue(rows, 'SELECTED', "1");
				mySheet.SetCellValue(rows, 'LOAN_NO', mySheet.GetCellValue(i, "LOAN_NO"));
				mySheet.SetCellValue(rows, 'REG_DATE', mySheet.GetCellValue(i, "REG_DATE"));
				mySheet.SetCellValue(rows, 'REG_TIME', mySheet.GetCellValue(i, "REG_TIME"));
				mySheet.SetCellValue(rows, 'L_GROUP_CODE', mySheet.GetCellValue(i, "L_GROUP_CODE"));
				mySheet.SetCellValue(rows, 'L_GROUP_NAME', mySheet.GetCellValue(i, "L_GROUP_NAME"));
				mySheet.SetCellValue(rows, 'M_GROUP_CODE', mySheet.GetCellValue(i, "M_GROUP_CODE"));
				mySheet.SetCellValue(rows, 'M_GROUP_NAME', mySheet.GetCellValue(i, "M_GROUP_NAME"));
				mySheet.SetCellValue(rows, 'IRS_NO', mySheet.GetCellValue(i, "IRS_NO"));
				mySheet.SetCellValue(rows, 'COM_CODE', mySheet.GetCellValue(i, "COM_CODE"));
				mySheet.SetCellValue(rows, 'COM_NAME', mySheet.GetCellValue(i, "COM_NAME"));
				mySheet.SetCellValue(rows, 'DEPT_CODE', mySheet.GetCellValue(i, "DEPT_CODE"));
				mySheet.SetCellValue(rows, 'DEPT_NAME', mySheet.GetCellValue(i, "DEPT_NAME"));
				mySheet.SetCellValue(rows, 'BASE_AMT', mySheet.GetCellValue(i, "BASE_AMT"));
				
				// 복사할 행 1개라도 존재
				checkFlag = true;
				
				// 기존 선택한 항목은 체크해제(저장시 중복될 수 있으므로)
				mySheet.SetCellValue(i, 'SELECTED', "0");
			}
		}
		
		if (!checkFlag) {
			alert("복사할 행을 선택하여 주시기 바랍니다.");
		}
	}
}

/**
 * 시작일 종료일 검증
 */
function kep_dateSearchCheck(startdate,enddate){
	
	var s = startdate.replace(/[/]/gi,"");
	var e = enddate.replace(/[/]/gi,"");
	
	if (s > e) {
		alert("시작일이 종료일보다 전이어야 합니다. 확인 부탁드립니다.");
		return false;
	}
}

/**
* 입력값 숫자 체크
*/
function fnNumberCheck(id) {
	
	if (!kepIsNumDash(id)) {
		alert("숫자와 - 만 입력할수 있습니다.");
		$("#"+id).val("");
	}
}

</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>추가여신 등록</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span>  
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form id = "searchCondition" name = "searchCondition" method = "post" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_addloan_amt" name="st_addloan_amt"  value="">
			<input type="hidden" id="st_addloan_remark" name="st_addloan_remark"  value="">
            	<table  class="cont_t_list01" >
					<caption>추가여신 등록</caption> 
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
						<th>고객사</th>
						<td>
								<input type="text"   class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:70%" value="" onKeyDown="kepEnter()">
						</td>
						<th>사업자번호</th>
						<td>
							<input type="text"   class="input_type_text" name="st_irs_no" id="st_irs_no" style="width:70%" value="" onKeyDown="kepEnter()" onkeyup="fnNumberCheck('st_irs_no')" onchange="fnNumberCheck('st_irs_no')">
						</td>
						<th>사업팀</th>
						<td>
							<select id="st_dept" name="st_dept" style="width:180px; height:20px"></select>
						</td>
					</tbody>
				</table>
            </div>
            <b>※ 품의상신 후 진행상태 반영 되기까지는 최대 5분이 소요됩니다.</b>
			<br>
		</form>
					
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "480px");
  				</script>
  			</div>
  			
  			<!--버튼영역-->
               <div class="btnArea">
  	          	<span class="fr">
  	          		<span class="btn_02 mr04"><a href="javascript:doAction('save');">품의상신</a></span>
  				</span> 
  			 </div>
  			 
<!--내용 종료-->	                 
</body>
</html>
