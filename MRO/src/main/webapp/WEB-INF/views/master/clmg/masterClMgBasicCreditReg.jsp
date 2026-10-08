<%--
**********************************************
* 메뉴 : 여신관리>기초여신한도
* 화면 : 기초여신한도
* 기능 :
* 프로그램 ID : U_01_M_001_01
* 담당자 : 한승준 ( 설계 : 옥대수 )
* 착수일 : 2015-10-12
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

var unit01 = KepSheetComboQueryIdData('common.masterCodeList','','');	// IBSHEET : 팀구분
var iconOff = "/resources/images/icon2.gif";
var iconOn = "/resources/images/icon3.gif";
// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
					{ Align:"Center",	Width:60,	Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",				Header:"상태",									SaveName:"sStatus"}
					,{Align : "Center", SaveName :"SELECTED",          Header:"",				Type : "DummyCheck",     Width : 30,      Edit : true}
					,{ Align:"Center",	Width:30,	Edit:false,	EditLen:30,		Hidden:true,	Type:"Text",					Header:"LOAN_NO",							SaveName:"LOAN_NO"}
					,{ Align:"Center",	Width:150,	Edit:true,	EditLen:120,	Hidden:false,	Type:"Text",					Header:"사업자등록번호",					SaveName:"IRS_NO", BackColor:"${notnullColor}",	KeyField:true}
					,{ Align:"Center",	Width:30,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"",	SaveName:"COMCODE_GUBUN_IMG"}
					,{ Align:"left",		Width:250,	Edit:true,	EditLen:190,	Hidden:false,	Type:"Text",					Header:"고객사",								SaveName:"IRS_NM",			BackColor:"${notnullColor}",	KeyField:true}
					,{ Align:"Center",	Width:150,	Edit:true,	EditLen:200,	Hidden:false,	Type:"Combo",			Header:"담당부서",					SaveName:"DEPT_CD",				BackColor:"${notnullColor}",	KeyField:true,		Sort:0,		ComboText:unit01.ComboText, 	ComboCode:unit01.ComboCode}
					,{ Align:"right",	Width:250,	Edit:true,	EditLen:95,		Hidden:false,	Type:"Float",				Header:"기초여신한도",						SaveName:"BASE_CREDIT_AMT",			BackColor:"${notnullColor}",	KeyField:true}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:60,		Hidden:true,	Type:"Text",					Header:"상태코드",							SaveName:"STATUS"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",					Header:"상태",									SaveName:"STATUS_TEXT"}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Date",				Header:"등록일",								SaveName:"ADD_DATE"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:500,		Hidden:true,	Type:"Text",					Header:"COM_CODE",							SaveName:"COM_CODE"}
];
	
	// 사업팀 콤보박스
	kepAjaxCommonQueryIdCombo('st_dept','getKepDeptList','ALL','');
	mySheet.SetImageList(7, iconOff);
	mySheet.SetImageList(8, iconOn);
	IBS_InitSheet(mySheet, initsheet,pagingMode, 'XLS');
	setLinkCol(mySheet, "COMCODE_GUBUN_IMG");
	
	//데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]
	mySheet.SetCountPosition(4);

}

// 기능함수
function doAction(str) {
	
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var maxRow = mySheet.RowCount();
	
	// 선택된 항목 유무 체크
	if (str !="search" && str !="reload" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
	case "search":	 // 조회
		//조회
		kepSearch(document.searchCondition,  mySheet , "/clmg/getMasterClMgBasicCreditReg.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		mySheet.RemoveAll();
		break;

	case "save": // 저장
		if ( !validationSave())
			return;
		if (!confirm('선택한 항목을 품의상신 하시겠습니까?'))
			return;
		kepSave(document.searchCondition ,  mySheet , "/clmg/apprMasterClMgBasicCreditReg.do" , "SELECTED" );
		break;

	case "del":	//삭제
		if (maxRow == 0){
			alert("조회된 데이터가 없습니다.");
			return;
		}
		if (selectedGrid.length == 0){
			alert("삭제할 대상을 선택해 주십시요.");
			return;
		}
		if (!confirm("선택한 항목을 삭제 하시겠습니까?")) {
			return;
		}else{
			kepSave(document.searchCondition, mySheet, "/clmg/deleteMasterClMgBasicCreditReg.do", "SELECTED");
		}		
		break;	
	}
}
function gw_aprv(){
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var st_user_id = "<%=userId%>";
	var st_irs_no = "";
	var st_irs_nm ="";
	var st_dept_cd ="";
	var st_base_credit_amt = "";
	if (mySheet.RowCount() == 0){
		alert("조회된 데이터가 없습니다.");
		return;
	}
	if (selectedGrid.length == 0){
		alert("선택하신 품목이 없습니다.");
		return;
	}

	var bodyContents =
		"<style> .SmallTB{border:1px solid #000; font-size:12px} .SmallTB th{ height:30px; text-align:center; background-color:#e8f3f9;border-right:1px solid #000;border-bottom:1px solid #000;} .SmallTB td{ height:25px;border-bottom:1px solid #000; padding-left:5px} .SmallTbNoboder{border:0px solid #000; font-size:12px} </style>"+
		"<body>"+
		"<p style=\"font-size:12px\">상기 건과 관련하여 아래와 같이 품의하오니 검토 후 재가하여 주시기 바랍니다</p>"+
		"<br/>"+
    	"<p style=\"font-size:12px\">① 여신설정 기본</p>"+
		"<table  class=\"SmallTB\"  cellSpacing=\"0\" cellPadding=\"0\" width=\"100%\">"+
	  	"<tbody>"+
	  	"<colgroup>"+
	  	"<col width=\"15%\" />"+
	  	"<col width=\"25%\" />"+
	  	"<col width=\"15%\" />"+
	  	"<col width=\"20%\" />"+
	  	"<col width=\"*\" />"+
	  	"</colgroup>"+
	  	"<tr ><th>사업자번호</th><th>고객사명</th><th>여신한도</th><th>연간 추정매출</th><th>결제조건</th></tr>";
		for(var i= 1 ; i<mySheet.GetTotalRows()+1; i++){
			if ( mySheet.GetCellValue(i, "SELECTED") == '1' ) {
		  		bodyContents += "<tr>";
				st_irs_no += mySheet.GetCellValue(i, "IRS_NO")+ ",";
				st_irs_nm += mySheet.GetCellValue(i, "IRS_NM")+ ",";
				st_dept_cd += mySheet.GetCellValue(i, "DEPT_CD")+ ",";
				st_base_credit_amt += mySheet.GetCellValue(i, "BASE_CREDIT_AMT")+ ",";
				var amt = mySheet.GetCellValue(i, "BASE_CREDIT_AMT");
				bodyContents +=  "<td align=\"center\" style=\"border-right:1px solid #000;\">"+mySheet.GetCellValue(i, "IRS_NO")+"</td>"
					+"<td style=\"border-right:1px solid #000;\">"+ mySheet.GetCellValue(i, "IRS_NM")+"</td>"+"<td align=\"right\" style=\"border-right:1px solid #000;\">"+numberComma(amt)+ "원"
					+"</td><td style=\"border-right:1px solid #000;\"></td><td style=\"border-right:1px solid #000;\"></td></tr>";
			}
		}
	  	bodyContents +="</tbody>"+
		"</table>"+
	    "<p style=\"font-size:12px\">②</p>";
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
	hiddenField03.setAttribute("value", "B03");
	form.appendChild(hiddenField03);
	
	var hiddenField04 = document.createElement("input");
	hiddenField04.setAttribute("type", "hidden");
	hiddenField04.setAttribute("name", "LinkageSub1");
	hiddenField04.setAttribute("value", st_irs_no);
	form.appendChild(hiddenField04);
	
	var LinkageSub2 = document.createElement("input");
	LinkageSub2.setAttribute("type", "hidden");
	LinkageSub2.setAttribute("name", "LinkageSub2");
	LinkageSub2.setAttribute("value", st_dept_cd);
	form.appendChild(LinkageSub2);
	
	var LinkageSub3 = document.createElement("input");
	LinkageSub3.setAttribute("type", "hidden");
	LinkageSub3.setAttribute("name", "LinkageSub3");
	LinkageSub3.setAttribute("value", st_irs_nm);
	form.appendChild(LinkageSub3);
	
	var LinkageSub4 = document.createElement("input");
	LinkageSub4.setAttribute("type", "hidden");
	LinkageSub4.setAttribute("name", "LinkageSub4");
	LinkageSub4.setAttribute("value", st_base_credit_amt);
	form.appendChild(LinkageSub4);
	
	var LinkageSub5 = document.createElement("input");
	LinkageSub5.setAttribute("type", "hidden");
	LinkageSub5.setAttribute("name", "LinkageSub5");
	LinkageSub5.setAttribute("value", st_user_id);
	form.appendChild(LinkageSub5);			
	
	var hiddenField05 = document.createElement("input");
	hiddenField05.setAttribute("type", "hidden");
	hiddenField05.setAttribute("name", "SancTitle");
	hiddenField05.setAttribute("value", "[품의] 고객사 여신한도 설정 품의의 건");
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

/**
* ajax 공통 호출후 성공시 처리 함수
*/ 
function kepAjaxSuccess(pMethod , response){
	var msg = response.Message;
	
	if (msg != ""){
		alert(msg);
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
var grbRow = "";
//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	if(column == "COMCODE_GUBUN_IMG"){ //품목코드 확인.
		var st_modify_yn = "Y";

		popupSel = "buyerMulti";
		var st_irs_no = mySheet.GetCellValue(Row, "IRS_NO");
		var st_dept_cd = mySheet.GetCellValue(Row, "DEPT_CD");
		openSearchPopup("/clmg/showMasterClMgCreditCmpyPop.do", '?st_irs_no='+st_irs_no+'&st_dept_cd='+st_dept_cd+'&st_modify_yn='+st_modify_yn, "660,350,no");
	}
}
//콜백함수(파일명은 모두 동일)
function setPopupReturn(code,text){
	if (popupSel == "buyerMulti") {	
		mySheet.SetCellValue(grbRow, "COM_CODE", code);
		mySheet.SetCellValue(grbRow, "COMCODE_GUBUN_IMG", "8");
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
	if(msg =="OK"){
		//품의상신
		gw_aprv();
	}else{
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

}

function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
}

//Valitation - 저장
function validationSave() {
	for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
		if ( mySheet.GetCellValue(i, "SELECTED") == 1 ) {
			// 기존 등록여부 체크
			var st_status_code = mySheet.GetCellValue(i, "STATUS_CODE");
			if (st_status_code == "C"||st_status_code=="R"||st_status_code=="T") {
				alert(i + " 번째: 품의상신 가능한 상태가 아닙니다.");
				return false;
			}
			var st_irs_no = mySheet.GetCellValue(i, "IRS_NO");
			// 사업자번호 체크
			if ( st_irs_no == "") {
				alert(i+ "번째 사업자번호를 입력해야 합니다.");
				return false;
			}
			if(!kepIsNumChkStr(st_irs_no, '4')){
				alert(i+ "번째 사업자번호는 숫자와 -만 입력해야 합니다.");
				return false;
			}
			if (st_irs_no.length != 12) {
				alert(i+ "번째 사업자번호는 12자리로 입력해야 합니다.");
				return false;
			}
			if(mySheet.GetCellValue(i, "IRS_NM") == ""){
				alert(i+ "번째 사업자명을 입력해야 합니다.");
				return false;				
			}
			if(mySheet.GetCellValue(i, "DEPT_CD") == ""){
				alert(i+ "번째 부서정보를 입력해야 합니다.");
				return false;				
			}
			if(mySheet.GetCellValue(i, "BASE_CREDIT_AMT") == ""){
				alert(i+ "번째 기초여신한도를 입력해야 합니다.");
				return false;				
			}
			//사업1팀, 2팀 제외.
			if(mySheet.GetCellValue(i, "DEPT_CD") != "114"&&mySheet.GetCellValue(i, "DEPT_CD") != "118"){
				if(mySheet.GetCellValue(i, "COM_CODE") == ""){
					alert(i+ "번째 돋보기 버튼을 클릭하여 고객사코드 매핑 바랍니다.");
					return false;				
				}				
			}
		}

	}
	return true;
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
function numberComma(number) {
    return number.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
} 
//TABLE의 ROW 데이타 생성
function addrows() {
	var rows = mySheet.DataInsert(-1);
	var st_dept_code           = $("#st_dept_code").val();
	mySheet.SetCellValue(rows, 'DEPT_CD', st_dept_code);
	mySheet.SetCellValue(rows, "COMCODE_GUBUN_IMG", "7");
}
</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>기초여신한도</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span>  
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form id = "searchCondition" name = "searchCondition" method = "post" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_dept_code" name="st_dept_code"  value="${sessionInfo.department}">
            	<table  class="cont_t_list01" >
					<caption>기초여신한도등록</caption> 
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
						<th>사업팀</th>
						<td>
							<select id="st_dept" name="st_dept" style="width:60%;height:20px"></select>
						</td>
						<th>상태</th>
						<td>
							<select id="st_status" name="st_status"	style="width:60%;">
								<option value="ALL">전체</option>
								<option value="T">결재중</option>
								<option value="B">결재반려</option>
								<option value="E">결재선오류</option>
							</select>
						</td>
					</tr>
					<tr>
						<th>사업자번호</th>
						<td>
							<input type="text"   class="input_type_text" name="st_irs_no" id="st_irs_no" style="width:70%" value="" onKeyDown="kepEnter()" onkeyup="fnNumberCheck('st_irs_no')" onchange="fnNumberCheck('st_irs_no')">
						</td>
						<th></th>
						<td></td>
					</tr>
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
					<span class="btn_02 mr04"><a href="javascript:addrows();">행추가</a></span>   	          	
  					<span class="btn_02 mr04"><a href="javascript:doAction('save');">품의상신</a></span>
  				</span> 
  			 </div>
  			 
<!--내용 종료-->	                 
</body>
</html>
