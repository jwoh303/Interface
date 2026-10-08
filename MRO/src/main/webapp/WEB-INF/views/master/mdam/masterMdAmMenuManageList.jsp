<%--
**********************************************
* 메뉴 : 관리자>메뉴관리>메뉴관리
* 화면 : 메뉴별 권한관리
* 기능 : 
* 프로그램 ID : PG_90_M_400_07
* 담당자 : 손상민 ( 설계 : 공통 )
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

var authInfoG = KepSheetComboQueryIdDataNoCache("getAuthInfoList", "SPACE","G");		// (G:일반권한, S:특수권한)
var authInfoS = KepSheetComboQueryIdDataNoCache("getAuthInfoList", "SPACE","S");		// (G:일반권한, S:특수권한)

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
					,{ Align:"Center",	Width:45,	Edit : true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"}
					
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"상위메뉴ID",	SaveName:"UPPER_ID",ToolTip:true}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"메뉴ID",	SaveName:"MENU_ID",ToolTip:true,KeyField : true}
					,{ Align:"Left",	Width:220,	Edit:true,	EditLen:300,	Hidden:false,	Type:"Text",	Header:"메뉴명",	SaveName:"NAME", TreeCol:1,BackColor:"${optColor}",ToolTip:true ,KeyField : true}
					,{ Align:"Center",	Width:50,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Int",	Header:"메뉴\n레벨",	SaveName:"DEPTH"}
					,{ Align:"Center",	Width:60,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Combo", ComboCode:"menu|tab|action|folder", ComboText:"메뉴|탭|액션|폴더",	Header:"메뉴유형",	SaveName:"TYPE",BackColor:"${optColor}"}
					,{ Align:"Left",	Width:410,	Edit:true,	EditLen:500,	Hidden:false,	Type:"Text",	Header:"메뉴URL",	SaveName:"URL",BackColor:"${optColor}",ToolTip:true}
					,{ Align:"Center",	Width:60,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Int",	Header:"표시\n순서",	SaveName:"MENU_ORDER",BackColor:"${optColor}"}
					,{ Align:"Left",	Width:200,	Edit:true,	EditLen:250,	Hidden:false,	Type:"Text",	Header:"메뉴설명",	SaveName:"MENU_DC",BackColor:"${optColor}",ToolTip:true}
					,{ Align:"Center",	Width:60,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Combo", ComboCode:"Y|N", ComboText:"Y|N",	Header:"사용\n유무",	SaveName:"USE_FLAG",BackColor:"${optColor}"}
					,{ Align:"Center",	Width:130,	Edit:true,	EditLen:30,	Hidden:false,	Type:"Combo", ComboText:authInfoS.ComboText, 	ComboCode:authInfoS.ComboCode, 	Header:"특수권한",	SaveName:"ROLE_ID",BackColor:"${optColor}"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"등록일",	SaveName:"CREATE_DT"}
					
	];
	initsheet.Cfg = {FrozenCol:5};
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//비고이미지설정
	mySheet.SetImageList(1, remarkOn);
	mySheet.SetImageList(0, remarkOff);

	
	var initsheet2 = {};
	initsheet2.Cols = [ 
					 { Align:"Center",	Width:40,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
					,{ Align:"Center",	Width:45,	Edit : true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:60,	Hidden:true,	Type:"Text",	Header:"메뉴ID",	SaveName:"MENU_ID"}
					,{ Align:"Center",	Width:150,	Edit:false,	EditLen:30,	Hidden:false,	Type:"Combo", ComboText:authInfoG.ComboText, 	ComboCode:authInfoG.ComboCode, 	Header:"메뉴권한",	SaveName:"AUTH_ID"}
// 					,{ Align:"Left",	Width:110,	Edit:false,	EditLen:60,	Hidden:false,	Type:"Text",	Header:"권한ID",	SaveName:"AUTH_ID", KeyField : true, ToolTip:true}
// 					,{ Align:"Left",	Width:120,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"권한명",	SaveName:"NAME",KeyField : true ,ToolTip:true ,BackColor:"${optColor}", ToolTip:true}
					,{ Align:"Left",	Width:180,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"설명",	SaveName:"AUTH_DC" , ToolTip:true}
					,{ Align:"Center",	Width:60,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Combo",	ComboText:"Y|N", 		ComboCode:"Y|N",	Header:"사용유무",	SaveName:"USE_FLAG" ,BackColor:"${optColor}"}
					,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"등록일",	SaveName:"CREATE_DT"}

	];
	
	IBS_InitSheet2(mySheet2, initsheet2,pagingMode);

	//콤보데이터 셋팅		
// 	kepAjaxCommonQueryIdCombo('st_kep_user_id','getKepUserList','SEL','');

	//하이퍼링크 설정
// 	setLinkCol(mySheet, "BTOA_USER_NAME");	//요청자
// 	setLinkCol(mySheet, "BUYER_ITEM_NO");	//품목코드
// 	setLinkCol(mySheet, "QUOTATION_NO");	//견적번호
// 	setLinkCol(mySheet, "AGENT_NAME");	//협력사
// 	setLinkCol(mySheet, "ATOB_REMARK_IMG");
// 	setLinkCol(mySheet, "ATOS_REMARK_IMG");
// 	setLinkCol(mySheet, "REJECT_REMARK_IMG");
	setLinkCol(mySheet, "NAME");
	
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
// 	$("#st_from_date").val( kepToMonthAdd("1","M"));
// 	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
}
	
	
var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var selectedGrid2 = mySheet2.FindCheckedRow("SELECTED");

	switch (str) {
	case "search":	 // 조회
			current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/mdam/getMasterMdAmMenuManageList.do" , pagingMode );
		break;

	case "search2":	 // 조회(상세)
		kepSearch(document.searchCondition,  mySheet2 , "/mdam/getMasterMdAmMenuManageDetailList.do" , pagingMode );
	break;

	case "reload":	// 초기화
		kepReload('searchCondition');
		$("#st_from_date").val('');
		$("#st_to_date").val('');
		$("#st_menu_id_detail").val('');
		mySheet.RemoveAll();
		mySheet2.RemoveAll();		
		break;

	case "masterAddAfter": // 복사(하위레벨)
		 if( mySheet.RowCount() > 0) {
			 	
			 	if($("#st_menu_id_detail").val() == ''){
			 		alert("추가할 위치의 [상위메뉴ID] 를 선택한 후, 추가버튼을 클릭해 주십시오.");return;
			 	}
			 	//현재 클릭한 그리드 위치(행)번호를 취득
			 	var selectRow = mySheet.GetSelectRow();
				var rows = mySheet.DataInsert(selectRow+1);

				mySheet.SetCellValue(rows, "SELECTED", "1");
				mySheet.SetCellValue(rows, "UPPER_ID", mySheet.GetCellValue(selectRow, "MENU_ID"));
				var info = { Align:"Left",	Width:150,	Edit:false,	EditLen:30,	Hidden:false,	Type:"Text",	Header:"메뉴ID",	SaveName:"MENU_ID", Edit:true, BackColor:"${optColor}"}
				mySheet.InitCellProperty(rows,"MENU_ID", info);
				var depth = mySheet.GetCellValue(selectRow, "DEPTH");
				var url = mySheet.GetCellValue(selectRow, "URL");
				mySheet.SetCellValue(rows, "DEPTH", eval(depth)+1);
				mySheet.SetCellValue(rows, "TYPE", (depth=='1'&& url.indexOf("masterFrame") > -1)?"tab":"menu");
				mySheet.SetCellValue(rows, "CREATE_DT", kepGetNowTimeStr('YYYYMMDD',''));

		 }else{
				alert("조회된 데이터가 없습니다.");
				return;
		 }	
		break;

	case "masterSave": // 저장
		// 선택된 항목 유무 체크
		if (selectedGrid.length == 0) {
			alert("선택된 항목이 없습니다.");return;
		}
		for( var i = 1; i <= mySheet.RowCount(); i++ ) {
			
			var code = mySheet.GetCellValue(i, "MENU_ID");
			var name = mySheet.GetCellValue(i, "NAME");
			
			if($.trim(code) == ''){
				alert("["+i+"]번째 메뉴ID가 입력되지 않았습니다.");return;
			}else if($.trim(name) == ''){
				alert("["+i+"]번째 메뉴명이 입력되지 않았습니다.");return;
			}
	    }
	
		if (!confirm('선택한 항목을 저장 하시겠습니까?'))
			return;
		kepSave(document.searchCondition ,  mySheet , "/mdam/saveMasterMdAmMenuManageList.do" , "SELECTED" );
		break;

	case "detailAdd": // 추가
		 if(mySheet2.RowCount() > 0 || $("#st_menu_id_detail").val() != '') {
			 	//행추가
				var rows = mySheet2.DataInsert(-1);
				//초기값설정
				mySheet2.SetCellValue(rows, "SELECTED", "1");
				mySheet2.SetCellValue(rows, "MENU_ID",$("#st_menu_id_detail").val());
				var info = { Align:"Center", Width:150,	Edit:true,	EditLen:30,	Hidden:false,	Type:"Combo", ComboText:authInfoG.ComboText, 	ComboCode:authInfoG.ComboCode, 	Header:"메뉴권한",	SaveName:"AUTH_ID",BackColor:"${optColor}"}
				mySheet2.InitCellProperty(rows,"AUTH_ID", info);
				mySheet2.SetCellValue(rows, "CREATE_DT", kepGetNowTimeStr('YYYYMMDD',''));

		 }else{
			 if(mySheet.RowCount() > 0) {
				 if($("#st_menu_id_detail").val() == ''){
						alert("선택된 데이터가 없습니다.");
						return;
				 }				 
			 }else{
				alert("조회된 데이터가 없습니다.");
				return;
			 }
		 }	
		break;	
		
	case "detailSave": // 저장
		// 선택된 항목 유무 체크
		if (selectedGrid2.length == 0) {
			alert("선택된 항목이 없습니다.");return;
		}
		for( var i = 1; i <= mySheet2.RowCount(); i++ ) {
			
			var code = mySheet2.GetCellValue(i, "AUTH_ID");
			var name = mySheet2.GetCellValue(i, "NAME");
			
			if($.trim(code) == ''){
				alert("["+i+"]번째 권한ID가 입력되지 않았습니다.");return;
			}else if($.trim(name) == ''){
				alert("["+i+"]번째 권한명이 입력되지 않았습니다.");return;
			}
	    }
	
		if (!confirm('선택한 항목을 저장 하시겠습니까?'))
			return;
		kepSave(document.searchCondition ,  mySheet2 , "/mdam/saveMasterMdAmMenuManageDetailList.do" , "SELECTED" );
		break;	
		
	case "detailDel": // 삭제
		if (!confirm('선택한 항목을 삭제 하시겠습니까?'))
			return;
		kepSave(document.searchCondition ,  mySheet2 , "/mdam/delMasterMdAmMenuManageDetailList.do" , "SELECTED" );
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
	
	
	mySheet2.RemoveAll();
}
//조회 후처리(상세)
function mySheet2_OnSearchEnd(code, msg) {
	loader_obj("N");
   	if(mySheet.RowCount() <= 0) return;
   	
	if (msg != "") {
		alert(msg);
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

//트랜젝션(저장,삽입등) 후처리
function mySheet2_OnSaveEnd(code, msg) {
	loader_obj("N");
	if (msg != "") {
		alert(msg);
	}
	
	if(code>=0){
		//저장 성공시 재조회
		doAction('search2');
	}
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mdam/getMasterMdAmMenuManageList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "buyer_single": // 고객사 M
			kepOpenSearchPopup('icomcmpyPop','?BUSINESS_COND=B&MULTI=N');
			popupSel = "buyer_single";
			break;
	}
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'NAME') { // 요청자
		$("#st_menu_id_detail").val(mySheet.GetCellValue(Row,"MENU_ID"));
		kepSearch(document.searchCondition ,  mySheet2 , "/mdam/getMasterMdAmMenuManageDetailList.do" , pagingMode );
	}
	return;
}


function mySheet_OnAfterEdit(Row, Col) {
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
    if(column=='MENU_ID'){
    	var dupIdx = mySheet.ColValueDup("MENU_ID");
    	if(dupIdx > -1){
        	alert("입력하신 메뉴ID는 이미 존재합니다.");
        	mySheet.SetCellValue(Row,"MENU_ID",'');
    	}
    }
}

function mySheet2_OnAfterEdit(Row, Col) {
	var column = mySheet2.ColSaveName(mySheet2.GetSelectCol());
    if(column=='AUTH_ID'){
    	var dupIdx = mySheet2.ColValueDup("AUTH_ID");
    	if(dupIdx > -1){
        	alert("입력하신 권한ID는 이미 존재합니다.");
        	mySheet2.SetCellValue(Row,"AUTH_ID",'');
    	}
    }
}


//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	grbRow="";	//초기화
}

	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>메뉴별 권한관리</h3>
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
			<input type="hidden" id="st_menu_id_detail" name="st_menu_id_detail"  value="">
			
            	<table  class="cont_t_list01" style="width:100%;">
					<caption>메뉴별 권한관리</caption>
					<colgroup>
						<col width="7%" />
						<col width="12%" />
						<col width="7%" />
						<col width="15%" />
						<col width="7%" />
						<col width="25%" />
						<col width="*" />
					</colgroup>
						
					<tbody>
						<tr> 
							<th>메뉴구분</th>
							<td><select id="st_com_gubun" name="st_com_gubun" class="sel_125">
									<option value="b">고객사</option>
									<option value="m">운영사</option>
									<option value="s">협력사</option>
									<option value="e">수출</option>
								</select>
							</td>
							<th>메뉴ID</th>
							<td>
								<input type="text" class="input_type_text" id="st_menu_id" name="st_menu_id" style="width:80%;" value=""  onkeydown="kepEnter()">
							</td>
							<th>메뉴URL</th>
							<td>
								<input type="text" class="input_type_text" id="st_menu_url" name="st_menu_url" style="width:80%;" value=""  onkeydown="kepEnter()">
							</td>
							<td></td>
						</tr>
						<tr>
							<th>권한구분</th>
							<td>
								<select id="st_sroleYn" name="st_sroleYn" class="sel_125">
									<option value="">전체</option>
									<option value="G">일반권한</option>
									<option value="S">특수권한</option>
								</select>
							</td>
							<th>메뉴명</th>
							<td>
								<input type="text" class="input_type_text" id="st_menu_name" name="st_menu_name" style="width:80%;" value="" onkeydown="kepEnter()">
							</td>
							<th>등록일</th>
							<td >
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:27%; text-align:center;" value=""> - 
		                        <input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:27%; text-align:center;" value=""> 
							</td>
							<td></td>
						</tr>
					</tbody>
				</table>
            </div>
            
           	<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
               	<label for="b_no02" class="hidden">정렬개수선택</label>
					<select name="onepagerow" style="width: 70px;" >
					<option value="50" selected>50건</option>
					<option value="100">100건</option>
					<option value="500">500건</option>
				</select>
			</span>
			<br>
		</form>
					
      	<!--grid-->
  				<table style="border-width: 0px; width: 100%;">
  					<colgroup>
					<col width="70%" />
                       <col width="*" />
				</colgroup>
				<tbody>
					<tr>
						<td>
				   			<div class="ib_product" style="border-top:2px solid #3c639c">
				  				<script type="text/javascript">
				  					createIBSheet("mySheet", "97%", "354px");
				  				</script>
				  			</div>
						</td>
						<td>
							<div class="ib_product" style="border-top:2px solid #3c639c;">
								<script type="text/javascript">
				  					createIBSheet("mySheet2", "100%", "354px");
				  				</script>
			  				</div>
						</td>
					</tr>
		      		<tr>
		      			<td>
				  			<p class="paging" id="pageindex"  ></p>
		      			</td>
		      			<td>
<!-- 				  			<p class="paging" id="pageindex2" ></p> -->
		      			</td>
		      		</tr>
				</tbody>
			</table>
      	
  			
  			<!--버튼영역-->
               <div class="btnArea">
  	          	<span class="fl">
	           		<span class="btn_02"><a href="javascript:doAction('masterAddAfter');">하위 추가</a></span>
	           		<span class="btn_02"><a href="javascript:doAction('masterSave');">저장</a></span>
  				</span>
  				
 				<span class="fr">
	           		<span class="btn_02"><a href="javascript:doAction('detailAdd');">추가</a></span>
	           		<span class="btn_02"><a href="javascript:doAction('detailSave');">저장</a></span>
	           		<span class="btn_02"><a href="javascript:doAction('detailDel');">삭제</a></span>
  				</span>
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
