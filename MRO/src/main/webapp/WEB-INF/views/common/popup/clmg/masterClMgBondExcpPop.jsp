<%--
**********************************************
* 메뉴 : 여신한도 예외 정보
* 화면 : 여신한도 예외 정보
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
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script> 
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
<%
String sessionDept = CommonUtil.nvl((String) request.getParameter("sessionDept"),"");
%>

<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";
var unit01 = KepSheetComboQueryIdData('common.masterCodeList','','');	// IBSHEET : 팀구분
//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
    
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
					,{ Align:"Center",	Width:30,	Edit:true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"}
					,{ Align:"Center",	Width:100,	Edit:true,	EditLen:12,	Type:"Text",	Header:"사업자번호",	SaveName:"IRS_NO", BackColor:"${notnullColor}"}
					,{ Align:"Left",	Width:200,	Edit:true,	EditLen:200,	Type:"Text",	Header:"사업자명",	SaveName:"IRS_NM", BackColor:"${notnullColor}"}
					,{ Align:"Center",	Width:100,	Edit:true,	EditLen:200,	Hidden:false,	Type:"Combo",			Header:"사업팀",					SaveName:"KEP_DEPT",			Sort:0,		ComboText:unit01.ComboText, 	ComboCode:unit01.ComboCode, BackColor:"${notnullColor}"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:20,	Type:"Text",	Header:"등록자",	SaveName:"ADD_USER_NAME"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:20,	Type:"Date",	Header:"등록일",	SaveName:"ADD_DATE"}

					];
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	mySheet.SetCountPosition(4);//데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]


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
	case "search": // 조회
		//조회
		kepSearch(document.searchCondition,  mySheet , "/clmg/getMasterClMgBondExcpPop.do" , pagingMode );
		break;
	case "save": // 저장
		for(var i=0; i<arrRow.length; i++){
			if(mySheet.GetCellValue(arrRow[i],"sStatus") != "I"){
				alert("신규등록건만 저장 가능 합니다.");
				return;				
			}
			if(mySheet.GetCellValue(arrRow[i],"IRS_NO") == ""){
				alert("사업자번호 입력바랍니다.");
				return;
			}
			if(mySheet.GetCellValue(arrRow[i],"IRS_NM") == ""){
				alert("사업자명 입력바랍니다.");
				return;
			}
			if(mySheet.GetCellValue(arrRow[i],"KEP_DEPT") == "100"){
				alert("사업팀 정보 입력바랍니다.");
				return;
			}
		}
		
		if (!confirm('여신한도 제외 처리 하시겠습니까?')){
			return;
		}else{
			kepSave(document.searchCondition ,  mySheet , "/clmg/saveMasterClMgBondExcpPop.do" , "SELECTED" );
		}
		break; 
	case "delete": // 삭제
		if (!confirm('여신한도 제외 헤제 하시겠습니까?')){
			return;
		}else{
			kepSave(document.searchCondition ,  mySheet , "/clmg/deleteMasterClMgBondExcpPop.do" , "SELECTED" );
		}
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
	if(!checkedSession(stCode)){return;}	

   	
	if (msg != "") {
		alert(msg);
	}
	

}


//TABLE의 ROW 데이타 생성
function addrows() {
	
	var rows = mySheet.DataInsert(-1);
	mySheet.SetCellValue(rows, 'SELECTED', "1");
}
//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	if (column == 'COM_CODE') { //고객사코드
		openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N","500,466,no");
		popupSel = "buyerMulti";
		
	}
}
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9,value10
		,value11,value12,value13,value14,value15,value16,value17,value18,value19,value20
		,value21,value22,value23,value24,value25,value26,value27,value28,value29){
	
	 if (popupSel == "buyerMulti") {	//KEP 표준카테고리 선택 
			mySheet.SetCellValue(grbRow, 'COM_CODE', value1);
	}
}
//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	
}
//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	
	if(!checkedSession(stCode)){
		return;
	}
	if (msg != ""){
		alert(msg);
		//저장 성공시 재조회
		doAction('search');
	}

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
	<div id="popWrapper" style="height:504px;">
    	<div id="popHeader">
        	<h1 class="title">여신한도 예외</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <br>
             <div class="fr">
            	<span class="btn_search"><a href="javascript:doAction('search');">조회</a></span>  
            </div>
            <br>
            <!--조회영역-->
            <div id="cont_searchA" class="mt10">
            	<table class="cont_t_list01" style="width:100%">
						<caption>여신한도 예외</caption>
						<colgroup>
							<col width="10%" />
							<col width="40%" />
                            <col width="10%" />
                            <col width="40%" />
						</colgroup>
						<tbody>
						<tr>
							<td>사업자번호</td>
							<td> 
								<input type=text name=st_irs_no id="st_irs_no" style="width:90%; value="" class="input_type_text" onKeyDown="kepEnter();"> 
                            </td>
						    <td>사업자명</td>						 
							<td> 
								<input type=text name="st_irs_nm" id="st_irs_nm" style="width:90%; value="" class="input_type_text" onKeyDown="kepEnter();"> 
							</td>
						</tr>
					</tbody>
				</table>
            </div>    
         </form>
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "99%", "250px");
  				</script>
  			</div>
  			<!--버튼영역-->
  			<br>
  			<%
  			if(sessionDept.equals("004")||sessionDept.equals("095")){
  			%>
               <div class="btnArea">
  	          	<span class="fr">
  					<span class="btn_02 mr04"><a href="javascript:addrows();">행추가</a></span>
  					<span class="btn_02"><a href="javascript:doAction('delete');">삭제</a></span>
  					<span class="btn_02"><a href="javascript:doAction('save');">저장</a></span>
  				</span> 
  			 </div>
  			<%
  			}
  			%>
</div>
<!--내용 종료-->	                 
</body>
</html>
