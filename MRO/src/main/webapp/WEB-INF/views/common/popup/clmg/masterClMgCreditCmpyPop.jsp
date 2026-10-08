<%--
**********************************************
* 메뉴 : 고객사코드 매핑정보
* 화면 : 고객사코드 매핑정보
* 기능 :
* 프로그램 ID : 
* 담당자 : 현명환
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script> 
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
<%
String st_modify_yn = CommonUtil.nvl((String) request.getParameter("st_modify_yn"),"");
%>

<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";
//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
    
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
					,{ Align:"Center",	Width:30,	Edit:true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:10,	Type:"Text",	Header:"고객사코드",	SaveName:"COM_CODE", BackColor:"${notnullColor}"}
					,{ Align:"Left",	Width:120,	Edit:false,	EditLen:100,Type:"Text",	Header:"고객사명",	SaveName:"COM_NAME_LOC"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:20,	Type:"Text",	Header:"등록자",	SaveName:"ADD_USER_NAME"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:20,	Type:"Date",	Header:"등록일",	SaveName:"ADD_DATE"}
					,{ Align:"Center",	Width:150,	Edit:false,	EditLen:120,	Hidden:false,	Type:"Text",					Header:"사업자등록번호",					SaveName:"IRS_NO", BackColor:"${notnullColor}",	KeyField:true}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:40,	Type:"Text",	Header:"요청부서",	SaveName:"REQ_DEPT_NM", BackColor:"${notnullColor}"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:20,	Hidden : true, Type:"Text",	Header:"BYEX_YN",	SaveName:"BYEX_YN"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:40,	Hidden : true, Type:"Text",	Header:"REQ_DEPT_CD",	SaveName:"REQ_DEPT_CD"}
					];
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	mySheet.SetCountPosition(4);//데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]
	setLinkCol(mySheet, "COM_CODE");
	setLinkCol(mySheet, "REQ_DEPT_NM");
	kepSearch(document.searchCondition ,  mySheet , "/clmg/getMasterClMgCreditCmpyPop.do" , pagingMode );
}
//기능함수
function doAction(str) {
	
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow = selectedGrid.split("|");
	
	// 선택된 항목 유무 체크
	if ((str =="mapping" || str =="save") && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}
	switch (str) {
	case "mapping": // 매핑
		var comCodeArry = "";
		for(var i=0; i<arrRow.length; i++){
			var comCode =  mySheet.GetCellValue(arrRow[i],"COM_CODE");
			var irsNo = mySheet.GetCellValue(arrRow[i],"IRS_NO");
			var reqDeptCd = mySheet.GetCellValue(arrRow[i],"REQ_DEPT_CD");
			var byexYn = mySheet.GetCellValue(arrRow[i],"BYEX_YN");
			if(comCode == ""){
				alert("고객사 코드 입력 바랍니다.");
				return;
			}
			if(irsNo  == ""){
				alert("사업자 번호 입력 바랍니다.");
				return;
			}
			if(byexYn == "Y"){
				if(reqDeptCd == ""){
					alert("요청부서 입력 바랍니다.");
					return;					
				}
			}
			comCodeArry += comCode+"^"+irsNo+"^"+reqDeptCd+","; 
		}
		opener.setPopupReturn(comCodeArry);
		this.close();
		break; 
	}
}

// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {

	return DATA;
}
function mySheet_OnDownFinish(downloadType, result) {
    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거
}
// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
		var byEXYn = mySheet.GetCellValue(i,"BYEX_YN");
		if(byEXYn == "Y"){
			mySheet.SetCellEditable(i, 'IRS_NO', 1);	
		}else{
			mySheet.SetCellEditable(i, 'IRS_NO', 0);
		}

	}
	if(!checkedSession(stCode)){return;}	
	if (msg != "") {
		alert(msg);
	}
	

}
	
// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");

}

//TABLE의 ROW 데이타 생성
function addrows() {
	var rows = mySheet.DataInsert(-1);
	mySheet.SetCellValue(rows, 'SELECTED', "1");
	mySheet.SetCellValue(rows, 'REQ_DEPT_IMG', "7");
	
}
//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	if (column == 'COM_CODE') { //고객사코드
		popupSel = "buyerMulti";
		openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N","500,466,no");
		
	}else if (column == 'REQ_DEPT_NM') { //요청부서
		var comCode = mySheet.GetCellValue(Row,"COM_CODE");
		var byEXYn = mySheet.GetCellValue(Row,"BYEX_YN");
		if(byEXYn== "N"){
			alert("요청부서를 설정 할 수 없는 고객사 입니다.");
			return;			
		}
		if(comCode == ""){
			alert("고객사를 선택해 주십시오.");
			return;
		}
		popupSel = "dept";
		openSearchPopup("/common/deptCodeAdminPop.do", "?open=Y&com_code="+comCode, "500,500,no");
	}
}
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9,value10
		,value11,value12,value13,value14,value15,value16,value17,value18,value19,value20
		,value21,value22,value23,value24,value25,value26,value27,value28,value29){
	
	 if (popupSel == "buyerMulti") {	//고객사 정보 설정 
			mySheet.SetCellValue(grbRow, 'COM_CODE', value1);
			mySheet.SetCellValue(grbRow, 'COM_NAME_LOC', value2);
			mySheet.SetCellValue(grbRow, 'BYEX_YN', value6);
			mySheet.SetCellValue(grbRow, 'IRS_NO', value7);
			if(value6 == "Y"){
				mySheet.SetCellEditable(grbRow, 'IRS_NO', 1);	
			}else{
				mySheet.SetCellEditable(grbRow, 'IRS_NO', 0);
			}
	}else if(popupSel == "dept"){//요청부서 설정
		mySheet.SetCellValue(grbRow, 'REQ_DEPT_CD', value1);
		mySheet.SetCellValue(grbRow, 'REQ_DEPT_NM', value2);
	}
}
//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	
}

</script>

<body onload="kep_onload_view()">
<!--내용 시작-->
        <!--조회영역-->
       	<form id = "searchCondition" name = "searchCondition" method = "post" >
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag"  name="pageflag" value="1">
			<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_user_dept" name="st_user_dept"  value="${sessionInfo.department}">
			<input type="hidden" id="st_irs_no"  name="st_irs_no" value="${param.st_irs_no}">	
			<input type="hidden" id="st_dept_cd"  name="st_dept_cd" value="${param.st_dept_cd}">
		</form>
      	<!--grid-->
	<div id="popWrapper" style="height:504px;">
    	<div id="popHeader">
        	<h1 class="title">고객사코드 매핑</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <br>
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "99%", "200px");
  				</script>
  			</div>
  			<!--버튼영역-->
  			<br>
  			<%
  			if(st_modify_yn.equals("Y")){
  			%>
               <div class="btnArea">
  	          	<span class="fr">
  					<span class="btn_02 mr04"><a href="javascript:addrows();">행추가</a></span>
  					<span class="btn_02"><a href="javascript:doAction('mapping');">매핑</a></span>
  				</span> 
  			 </div>
  			<%
  			}
  			%>
</div>
<!--내용 종료-->	                 
</body>
</html>
