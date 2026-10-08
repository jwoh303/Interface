<%--
**********************************************
* 메뉴 : 관리자>메뉴관리>권한관리
* 화면 : 권한관리
* 기능 : 권한 신규 정의 및 수정
* 프로그램 ID : PG_90_M_400_09
* 담당자 :  손상민 ( 설계 : 공통 )
* 착수일 : 2014-10-10
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<script src="/resources/js/kep_common.js"></script>
<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
						 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
						,{ Align:"Center",	Width:60,	Edit : true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"}
	 					,{ Align:"Left",	Width:150,	Edit:false,	EditLen:30,	Hidden:false,	Type:"Text", Header:"권한ID",	SaveName:"AUTH_ID", KeyField : true, ToolTip:true, InputCaseSensitive:1}
	 					,{ Align:"Left",	Width:200,	Edit:true,	EditLen:60,	Hidden:false,	Type:"Text", Header:"권한명",	SaveName:"AUTH_NAME", KeyField : true,BackColor:"${optColor}", ToolTip:true , InputCaseSensitive:1}
						,{ Align:"Left",	Width:300,	Edit:true,	EditLen:200,	Hidden:false,	Type:"Text",	Header:"설명",	SaveName:"AUTH_DC", BackColor:"${optColor}", ToolTip:true, InputCaseSensitive:1}
						,{ Align:"Center",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Combo",	ComboText:"일반권한|특수권한", ComboCode:"G|S",	Header:"권한구분",	SaveName:"ROLE_FLAG" ,BackColor:"${optColor}"}
						,{ Align:"Center",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Combo",	ComboText:"Y|N", 		ComboCode:"Y|N",	Header:"사용유무",	SaveName:"USE_FLAG" ,BackColor:"${optColor}"}
						,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"등록일",	SaveName:"CREATE_DT"}
						,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"메뉴매핑수",	SaveName:"ROLE_MENU_CNT"}
						,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"일반사용자매핑수",	SaveName:"ROLE_USER_G_CNT"}
						,{ Align:"Center",	Width:150,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"특수사용자매핑수",	SaveName:"ROLE_USER_S_CNT"}
						
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//비고이미지설정
	mySheet.SetImageList(1, remarkOn);
	mySheet.SetImageList(0, remarkOff);

	//콤보데이터 셋팅		
	kepAjaxCommonQueryIdCombo('st_kep_user_id','getKepUserList','SEL','');

	//하이퍼링크 설정
	
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
}
	
	
var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	switch (str) {
	case "search":	 // 조회
			current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/mdam/getMasterMdAmAuthorityManageList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
	 	$("#st_from_date").val('');
	 	$("#st_to_date").val('');
		mySheet.RemoveAll();
		break;

	case "add": // 행추가
		 if( mySheet.RowCount() > 0) {
			 	
			 	//현재 클릭한 그리드 위치(행)번호를 취득
// 			 	var selectRow = mySheet.GetSelectRow();
// 			 	if(selectRow == 1){
// 			 		alert("추가할 위치의 [권한 ID] 를 선택한 후, 추가버튼을 클릭해 주십시오.");return;
// 			 	}
// 				var rowIdx = mySheet.DataInsert(selectRow+1);
				var rowIdx = mySheet.DataInsert(-1);
				
				var info = { Align:"Left",	Width:150,	Edit:false,	EditLen:30,	Hidden:false,	Type:"Text", Header:"권한ID",	SaveName:"AUTH_ID", KeyField : true, ToolTip:true, InputCaseSensitive:1,Edit:true, BackColor:"${optColor}"};
				mySheet.InitCellProperty(rowIdx,"AUTH_ID", info);
				mySheet.SetCellValue(rowIdx, "SELECTED", "1");
// 				mySheet.SetCellValue(rowIdx, "ROLE_FLAG", mySheet.GetCellValue(selectRow, "ROLE_FLAG"));
				mySheet.SetCellValue(rowIdx, "ROLE_FLAG", "G");
				mySheet.SetCellValue(rowIdx, "USE_FLAG", "Y");
				mySheet.SetCellValue(rowIdx, "CREATE_DT", kepGetNowTimeStr('YYYYMMDD',''));

		 }else{
				alert("조회된 데이터가 없습니다.");
				return;
		 }	
		break;
		
	case "save": // 저장
		// 선택된 항목 유무 체크
		if (selectedGrid.length == 0) {
			alert("선택된 항목이 없습니다.");return;
		}
		for( var i = 1; i <= mySheet.RowCount(); i++ ) {
			
			var code = mySheet.GetCellValue(i, "AUTH_ID");
			var name = mySheet.GetCellValue(i, "AUTH_NAME");
			
			if($.trim(code) == ''){
				alert("["+i+"]번째 권한ID 가 입력되지 않았습니다.");return;
			}else if($.trim(name) == ''){
				alert("["+i+"]번째 권한명이 입력되지 않았습니다.");return;
			}
	    }
	
		if (!confirm('선택한 항목을 저장 하시겠습니까?'))
			return;
		kepSave(document.searchCondition ,  mySheet , "/mdam/saveMasterMdAmAuthorityManageList.do" , "SELECTED" );
		break;
		
	case "del": // 취소
		// 선택된 항목 유무 체크
		if (selectedGrid.length == 0) {
			alert("선택된 항목이 없습니다.");return;
		}
		var arrRow = selectedGrid.split("|");
		for(var i=0; i<arrRow.length; i++){
			var menuCnt = mySheet.GetCellValue(arrRow[i], "ROLE_MENU_CNT");
			var userGCnt = mySheet.GetCellValue(arrRow[i], "ROLE_USER_G_CNT");
			var userSCnt = mySheet.GetCellValue(arrRow[i], "ROLE_USER_S_CNT");
			
			if(menuCnt !="" && parseInt(menuCnt) > 0){
				alert("해당 권한ID는 [ "+menuCnt+" 건의]메뉴에 매핑되어 있습니다. \n 해당 매핑을 취소한뒤 삭제 가능합니다.");return;
			}else if(userGCnt !="" && parseInt(userGCnt) > 0){
				alert("해당 권한ID는 [ "+userGCnt+" 건의]일반사용자 권한에 매핑되어 있습니다.\n 해당 매핑을 취소한뒤 삭제 가능합니다.");return;
			}else if(userSCnt !="" && parseInt(userSCnt) > 0){
				alert("해당 권한ID는 [ "+userSCnt+" 건의]특수사용자 권한에 매핑되어 있습니다.\n 해당 매핑을 취소한뒤 삭제 가능합니다.");return;
			}
	    }
		
		if (!confirm('선택한 항목을 삭제 하시겠습니까?'))
			return;
		kepSave(document.searchCondition ,  mySheet , "/mdam/delMasterMdAmAuthorityManageList.do" , "SELECTED" );
		break;
	}
}
	
// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}
	
// 조회 후처리
function mySheet_OnSearchEnd(code, msg) {
	loader_obj("N");
   	if(mySheet.RowCount() <= 0) return;
   	
	if (msg != "") {
		alert(msg);
	}

	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	
}
	
// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg) {
	loader_obj("N");
	if (msg != "") {
		alert(msg);
	}
	
	if(code>=0){
		//저장 성공시 재조회
		doAction('search');
	}
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mdam/getMasterMdAmAuthorityManageList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
// 	switch (str) {
// 		case "buyer_single": // 고객사 M
// 			kepOpenSearchPopup('icomcmpyPop','?BUSINESS_COND=B&MULTI=N');
// 			popupSel = "buyer_single";
// 			break;
// 	}
}

// function mySheet_OnEditValidation(Row, Col, Value) {
// 	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
//     if(column=='AUTH_ID'){
//     	var dupIdx = mySheet.ColValueDup("AUTH_ID");
//     	if(dupIdx == -1){
//         	alert("입력하신 권한ID는 이미 존재합니다.");
// //         	mySheet.ValidateFail(1); 
//     	}
//     }
// }

function mySheet_OnAfterEdit(Row, Col) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
    if(column=='AUTH_ID'){
    	var dupIdx = mySheet.ColValueDup("AUTH_ID");
    	if(dupIdx > -1){
        	alert("입력하신 권한ID는 이미 존재합니다.");
        	mySheet.SetCellValue(Row,"AUTH_ID",'');
    	}
    }
}


// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
// 	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
// 	grbRow = Row;		//현재 Row를 전역변수에 셋팅

}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	//팝업 조회후 해당 항목에 값을 셋팅
}

	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>권한관리</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition" method = "post">
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			
            	<table  class="cont_t_list01" style="width:100%;">
					<caption>권한관리</caption>
					<colgroup>
						<col width="8%" />
						<col width="17%" />
						<col width="8%" />
						<col width="17%" />
						<col width="8%" />
                        <col width="25%" />
						<col width="*" />
					</colgroup>
						
					<tbody>
						<tr> 
							<th>권한구분</th>
							<td>
								<select id="st_role_flag" name="st_role_flag" class="sel_125">
									<option value="">전체</option>
									<option value="G">일반권한</option>
									<option value="S">특수권한</option>
								</select>
							</td>
							<th>권한ID</th>
							<td>
								<input type="text" class="input_type_text" id="st_auth_id" name="st_auth_id"  style="width:80%;" value=""  onkeyup="kepToUpper('st_auth_id')"  onkeydown="kepEnter()">
							</td>
							<th></th>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<th>사용유무</th>
							<td>
								<select id="st_use_flag" name="st_use_flag" class="sel_125">
									<option value="">전체</option>
									<option value="Y">사용</option>
									<option value="N">미사용</option>
								</select>
							</td>
							<th>권한명</th>
							<td>
								<input type="text" class="input_type_text" id="st_auth_name" name="st_auth_name"  style="width:80%;" value=""   onkeydown="kepEnter()">
							</td>
							<th>등록일</th>
							<td >
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:20%; text-align:center;" value=""> - 
		                        <input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:20%; text-align:center;" value=""> 
							</td>
							<td></td>
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
  				<span class="fl">
	           		<span class="btn_02" ><a href="javascript:doAction('add');" >추가</a></span>
	           		<span class="btn_02"><a href="javascript:doAction('save');">저장</a></span>
	           		<span class="btn_02"><a href="javascript:doAction('del');">삭제</a></span>
  				</span>
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
