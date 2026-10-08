<%--
**********************************************
* 메뉴 : 관리자>코드관리>공통관리 조회
* 화면 : 공통관리 조회
* 기능 : 
* 프로그램 ID : PG_90_M_400_02
* 담당자 :  ( 설계 : 공통 )
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
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
					,{ Align:"Center",	Width:60,	Edit : true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"선택",	SaveName:"SELECTED"}
					
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"구분",	SaveName:"TYPE"}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:4,	Hidden:false,	Type:"Text",	Header:"코드",	SaveName:"CODE" , KeyField : true, InputCaseSensitive:1}
					,{ Align:"Left",	Width:180,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"코드명1",	SaveName:"TEXT1", ToolTip:true ,BackColor:"${optColor}", KeyField : true}
					,{ Align:"Left",	Width:180,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"코드명2",	SaveName:"TEXT2", ToolTip:true ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"코드명3",	SaveName:"TEXT3", ToolTip:true ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:80,	Edit:true,	EditLen:400,	Hidden:false,	Type:"Text",	Header:"코드명4",	SaveName:"TEXT4", ToolTip:true ,BackColor:"${optColor}"}
					,{ Align:"Center",	Width:60,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Combo",	ComboText:"Y|N", 		ComboCode:"Y|N",	Header:"사용유무",	SaveName:"FLAG" ,BackColor:"${optColor}"}
					,{ Align:"Center",	Width:30,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"우선순위",	SaveName:"VALUE1"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"등록일",	SaveName:"ADD_DATE"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"기타1",	SaveName:"TEXT5"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"기타2",	SaveName:"TEXT6"}

	];
	
	IBS_InitSheet2(mySheet, initsheet,pagingMode);
	//하이퍼링크 설정
// 	setLinkCol(mySheet, "CODE");	//코드
	setLinkCol(mySheet, "TEXT1");	//코드명

	mySheet.SetCountPosition(4);
	
	var initsheet2 = {};
	initsheet2.Cols = [ 
					 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
					,{ Align:"Center",	Width:60,	Edit : true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"선택",	SaveName:"SELECTED"}
					
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"구분",	SaveName:"TYPE_DETAIL"}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:20,	Hidden:false,	Type:"Text",	Header:"코드",	SaveName:"CODE_DETAIL", KeyField : true, InputCaseSensitive:1}
					,{ Align:"Left",	Width:180,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"코드명1",	SaveName:"TEXT1_DETAIL", ToolTip:true ,BackColor:"${optColor}", KeyField : true}
					,{ Align:"Left",	Width:180,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"코드명2",	SaveName:"TEXT2_DETAIL", ToolTip:true ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"코드명3",	SaveName:"TEXT3_DETAIL", ToolTip:true ,BackColor:"${optColor}"}
					,{ Align:"Left",	Width:80,	Edit:true,	EditLen:400,	Hidden:false,	Type:"Text",	Header:"코드명4",	SaveName:"TEXT4_DETAIL", ToolTip:true ,BackColor:"${optColor}"}
					,{ Align:"Center",	Width:60,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Combo",	ComboText:"Y|N", 		ComboCode:"Y|N",	Header:"사용유무",	SaveName:"FLAG_DETAIL" ,BackColor:"${optColor}"}
					,{ Align:"Center",	Width:80,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Int",	Header:"우선순위",	SaveName:"VALUE1_DETAIL",BackColor:"${optColor}"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"등록일",	SaveName:"ADD_DATE_DETAIL"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"기타1",	SaveName:"TEXT5_DETAIL"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"기타2",	SaveName:"TEXT6_DETAIL"}

	];

	IBS_InitSheet2(mySheet2, initsheet2,pagingMode);
	//하이퍼링크 설정
// 	setLinkCol(mySheet2, "CODE");	//코드
	setLinkCol(mySheet2, "TEXT1");	//코드명

	mySheet2.SetCountPosition(4);
	
	
	
	//비고이미지설정
	mySheet.SetImageList(1, remarkOn);
	mySheet.SetImageList(0, remarkOff);
	
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
	
		if (!kepIsValueNull($("#st_from_date").val()) && !kepIsValueNull($("#st_to_date").val())) {
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
		}
	
	
// 			current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/mdam/getMasterMdAmCommonManageList.do" , pagingMode );
		break;
	
	case "search2":	 // 조회(상세)
		current_page = -1;
	kepSearch(document.searchCondition,  mySheet2 , "/mdam/getMasterMdAmCommonManageDetailList.do" , pagingMode );
	break;

	case "reload":	// 초기화
		$("#st_code_m").val('');
		$("#st_name_m").val('');
		$("#st_from_date").val('');
		$("#st_to_date").val('');
		mySheet.RemoveAll();
		mySheet2.RemoveAll();
		break;

	case "masterAdd": // 추가
		 if( mySheet.RowCount() > 0) {
				var rows = mySheet.DataInsert(-1);
				mySheet.SetCellValue(rows, "SELECTED", "1");
				mySheet.SetCellValue(rows, "TYPE", 'M000');
				mySheet.SetCellEditable(rows, "CODE", 1);
				mySheet.SetCellValue(rows, "ADD_DATE", kepGetNowTimeStr('YYYYMMDD',''));
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
			var code = mySheet.GetCellValue(i, "CODE");
			var name = mySheet.GetCellValue(i, "TEXT1");
			
			if($.trim(code) == ''){
				alert("["+i+"]번째 코드가 입력되지 않았습니다.");return;
			}else if($.trim(name) == ''){
				alert("["+i+"]번째 코드명이 입력되지 않았습니다.");return;
			}
	    }
	
		if(mySheet.ColValueDup("CODE", 0) == -1){ //중복된 코드가 없을경우 업데이트 진행
			if (!confirm('선택한 항목을 저장 하시겠습니까?'))
				return;
			kepSave(document.searchCondition ,  mySheet , "/mdam/saveMasterMdAmCommonManageList.do" , "SELECTED" );
		}
		break;
		
	case "detailAdd": // 추가(상세)
		 if( mySheet.RowCount() > 0) {
				var rows = mySheet2.DataInsert(-1);
				mySheet2.SetCellValue(rows, "SELECTED", "1");
				mySheet2.SetCellValue(rows, "TYPE_DETAIL", $("#st_code_d").val());
				var mCode = $("#st_code_d").val();
				if(mCode == 'M104'){
					mySheet2.SetCellValue(rows, "CODE_DETAIL", "AUTO");
					mySheet2.SetCellEditable(rows, "CODE_DETAIL", 0);
				}else{
					mySheet2.SetCellEditable(rows, "CODE_DETAIL", 1);
				}
				mySheet2.SetCellValue(rows, "ADD_DATE_DETAIL", kepGetNowTimeStr('YYYYMMDD',''));
		 }else{
				alert("조회된 데이터가 없습니다.");
				return;
		 }	
		break;

	case "detailSave": // 저장(상세)
		// 선택된 항목 유무 체크
		if (selectedGrid2.length == 0) {
			alert("선택된 항목이 없습니다.");return;
		}
		for( var i = 1; i <= mySheet2.RowCount(); i++ ) {
			var code = mySheet2.GetCellValue(i, "CODE_DETAIL");
			var name = mySheet2.GetCellValue(i, "TEXT1_DETAIL");
			if($.trim(code) == ''){
				alert("["+i+"]번째 코드가 입력되지 않았습니다.");return;
			}
/* 			if($.trim(name) == ''){
				alert("["+i+"]번째 코드명이 입력되지 않았습니다.");return;
			} */
	    }
	
		if(mySheet2.ColValueDup("CODE_DETAIL", 0) == -1){ //중복된 코드가 없을경우 업데이트 진행
			if (!confirm('선택한 항목을 저장 하시겠습니까?'))
				return;
			kepSave(document.searchCondition ,  mySheet2 , "/mdam/saveMasterMdAmCommonManageDetailList.do" , "SELECTED" );
		}
		break;	
		
	case "detailDel": // 취소(상세)
		// 선택된 항목 유무 체크
		if (selectedGrid2.length == 0) {
			alert("선택된 항목이 없습니다.");return;
		}
		if (selectedGrid2.length == 0){
			alert("삭제할 대상을 선택해 주십시요. ");
			return;
		}
	
		if (!confirm('선택한 항목을 삭제 하시겠습니까?'))
			return;
// 		var maxRow  = mySheet2.RowCount();
		//신규건 삭제
// 		for(var i=maxRow; i>= 0; i--){	
// 			var selectedRow = mySheet2.GetCellValue(i,"SELECTED");
// 			if(selectedRow == "1"){
// 				mySheet2.RowDelete(i, 0);	
// 			}
// 		}
		kepSave(document.searchCondition ,  mySheet2 , "/mdam/delMasterMdAmCommonManageDetailList.do" , "SELECTED" );
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
	
	mySheet2.RemoveAll();
}

//조회 후처리(상세)
function mySheet2_OnSearchEnd(code, msg) {
	loader_obj("N");
   	if(mySheet.RowCount() <= 0) return;
   	
	if (msg != "") {
		alert(msg);
	}
	if(current_page==-1){
		makePageIndex2( mySheet2 , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet2 , current_page , document.searchCondition.onepagerow.value);	
	}	
	$("#pageflag").val('0');
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

//트랜젝션(저장,삽입등) 후처리(상세)
function mySheet2_OnSaveEnd(code, msg) {
	loader_obj("N");
	if (msg != "") {
		alert(msg);
	} 
	
	if(code>=0){
		var code_d = $("#st_code_d").val();
		if(code_d == "M104"){
			$("#pageflag").val('1');
			$( "p" ).show();
		}else{
			$( "p" ).hide();
		}
		//저장 성공시 재조회
		doAction('search2');
	}
}


// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet2 , "/mdam/getMasterMdAmCommonManageDetailList.do?page="+current_page , pagingMode );
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
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'TEXT1') { // 요청자
		var code_d = mySheet.GetCellValue(Row,"CODE");
		if(code_d == "M104"){
			$("#pageflag").val('1');
			$( "p" ).show();
		}else{
			$( "p" ).hide();
		}
		$("#st_code_d").val(code_d);
		mySheet2.RemoveAll();
		
		kepSearch(document.searchCondition ,  mySheet2 , "/mdam/getMasterMdAmCommonManageDetailList.do" , pagingMode );
	}
	return;
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
			<h3>공통관리 조회</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition" method = "post">
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="0">
			<input type="hidden" id="onepagerow" name="onepagerow" value="20">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_code_d" name="st_code_d"  value="">
			
			
            	<table  class="cont_t_list01" style="width:100%;">
					<caption>공통관리 조회</caption>
					<colgroup>
						<col width="8%" />
						<col width="25%" />
						<col width="8%" />
						<col width="25%" />
						<col width="8%" />
                        <col width="25%" />
					</colgroup>
						
					<tbody>
						<tr>
							<th>코드</th>
							<td>
								<input type="text" class="input_type_text" id="st_code_m" name="st_code_m" style="width:87%;" value=""  onkeyup="kepToUpper('st_code_m')" onKeyDown="kepEnter()">
							</td>
							<th>코드명</th>
							<td>
								<input type="text" class="input_type_text" id="st_name_m" name="st_name_m" style="width:87%;" value=""  onKeyDown="kepEnter()">
							</td>
							<th>등록일</th>
							<td colspan="3">
								<input type="text" name="st_from_date" id="st_from_date" readOnly style="width:20%; text-align:center;" > - 
								<input type="text" name="st_to_date" id="st_to_date" readOnly style="width:20%; text-align:center;" >
								&nbsp;&nbsp;
							</td>
						</tr>
					</tbody>
				</table>
            </div>
            <br>
<!-- 			<table style="width:100%;"> -->
<!-- 				<tr> -->
<!-- 					<td align="left"> -->
<!-- 		           		<img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/> -->
<!-- 		               	<label for="b_no02" class="hidden">정렬개수선택</label> -->
<!-- 							<select name="onepagerow" style="width: 70px;" > -->
<!-- 							<option value="10" selected>10건</option> -->
<!-- 							<option value="20">20건</option> -->
<!-- 							<option value="30">30건</option> -->
<!-- 							<option value="40">40건</option> -->
<!-- 							<option value="50">50건</option> -->
<!-- 							</select> -->
<!-- 						</td> -->
<!-- 		   		</tr> -->
<!-- 			</table> -->
		</form>
					
      	<!--grid-->
  				<table style="border-width: 0px; width: 100%;">
  					<colgroup>
					<col width="50%" />
                       <col width="*" />
				</colgroup>
				<tbody>
					<tr>
						<td>
							<div class="ib_product" style="border-top:2px solid #3c639c;">
								<script type="text/javascript">
				  					createIBSheet("mySheet", "98%", "354px");
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
<!-- 				  			<p class="paging" id="pageindex" ></p> -->
		      			</td>
		      			<td>
				  			<p class="paging" id="pageindex" ></p>
		      			</td>
		      		</tr>
				</tbody>
			</table>

      		
  			<!--버튼영역-->
               <div class="btnArea">
  	          	<span class="fl">
	           		<span class="btn_02"><a href="javascript:doAction('masterAdd');">추가</a></span>
	           		<span class="btn_02"><a href="javascript:doAction('masterSave');">저장</a></span>
<!-- 	           		<span class="btn_02"><a href="javascript:doAction('masterDel');">삭제</a></span> -->
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
