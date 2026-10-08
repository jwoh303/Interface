<%--
**********************************************
* 메뉴 : 외자납품 관리
* 화면 : 외자납품 관리
* 기능 : 외자납품 관리
* 프로그램 ID : 
* 담당자 : 한승준
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<script type="text/javascript"> 
var popupSel = "";
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";
var iconOff = "/resources/images/icon2.gif";
var iconOn = "/resources/images/icon3.gif";
var searchOn = "/resources/images/btn_search03.gif";

var grbRow = "";
// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view(){
	var initsheet = {};
	initsheet.Cols = [ 
			{ Align:"Center",	Width:40,	Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",		Header:"상태",			SaveName:"sStatus"}
			,{ Align:"Center",	Width:40,	Edit:true,	EditLen:0,		Hidden:false,	Type:"DummyCheck",	Header:"",				SaveName:"SELECTED", Sort:0}
			,{ Align:"Center",	Width:250,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"고객사코드",			SaveName:"BUYER"}
			,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"고객사",			SaveName:"BUYER_NAME"}
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"진행상태",			SaveName:"STATUS"}
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"I/F 처리상태",		SaveName:"RESULT_FLAG"}
			,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"C/I No.",		SaveName:"CI_NO"}
			,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"Invoice Date",	SaveName:"CI_DATE"}
			,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"B/L No.",		SaveName:"BL_NO"}
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"Forwarder",		SaveName:"FORWARDER"}
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"Forwarder",		SaveName:"FORWARDER_NAME"}
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"Ship Method",	SaveName:"SHIP_METHOD"}
			,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"Curruncy",		SaveName:"CURRENCY_CODE"}
			,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float", 		Header:"C/I amount",	SaveName:"ITEM_AMT"}
			,{ Align:"Right",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"Total Weight",	SaveName:"TOTAL_WEIGHT"}
			,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",		Header:"C/I Sheet",		SaveName:"CI_SHEET"}
			,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",		Header:"P/L Sheet",		SaveName:"PL_SHEET"}
			,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"C/I 첨부",		SaveName:"CI_IMAGE_KEY"}
			,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",		Header:"C/I 첨부",		SaveName:"CI_IMAGE_KEY_IMG",		BackColor:"${optColor}"}
			,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"B/L 첨부",		SaveName:"BL_IMAGE_KEY"}
			,{ Align:"Center",	Width:70,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",		Header:"B/L 첨부",		SaveName:"BL_IMAGE_KEY_IMG"}
			,{ Align:"Center",	Width:50,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",		Header:"Lot",			SaveName:"LOT_IMG"}
			,{ Align:"Center",	Width:90,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"수출신고일",			SaveName:"EXP_REPORT_DATE",		BackColor:"${optColor}"}
			,{ Align:"Center",	Width:90,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"선적일",			SaveName:"EXP_SHIP_DATE",		BackColor:"${optColor}"}
			,{ Align:"Right",	Width:60,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"통관환율",			SaveName:"ENTRY_EXCHANGE_RATE",	BackColor:"${optColor}",	PointCount:2}
			,{ Align:"Center",	Width:110,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"수출신고필증첨부",		SaveName:"IMAGE_KEY"}
			,{ Align:"Center",	Width:110,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",		Header:"수출신고필증첨부",		SaveName:"IMAGE_KEY_IMG",		BackColor:"${optColor}"}
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"BL완료여부",		SaveName:"BL_COMPLETE_MARK"}
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"납품완료여부",		SaveName:"COMPLETE_MARK"}
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"I/F고객사선적번호",	SaveName:"BUYER_SHIPPING_NO"}
			,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"I/F처리일시",		SaveName:"RESULT_DATE"}
			,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"I/F처리내용",		SaveName:"RESULT_MSG"}
	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:2};
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//비고이미지설정
	mySheet.SetImageList(0, remarkOn);
	mySheet.SetImageList(1, remarkOff);
	
	mySheet.SetImageList(2, diskOn);
	mySheet.SetImageList(3, diskOff);
	
	mySheet.SetImageList(4, iconOff);
	mySheet.SetImageList(5, iconOn);
	
	mySheet.SetImageList(6, searchOn);
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "CI_NO");
	setLinkCol(mySheet, "BL_NO");
	setLinkCol(mySheet, "CI_SHEET");
	setLinkCol(mySheet, "PL_SHEET");
	setLinkCol(mySheet, "CI_IMAGE_KEY_IMG");
	setLinkCol(mySheet, "BL_IMAGE_KEY_IMG");
	setLinkCol(mySheet, "LOT_IMG");
	setLinkCol(mySheet, "IMAGE_KEY_IMG");
	
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	$("#st_from_date").val(kepToDateAdd("60","M"));
	$("#st_to_date").val(kepToDateAdd("20","P")); 
}
	
//기능함수
function doAction(str) {
	
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");

	// 선택된 항목 유무 체크
	if (str !="search" && str !="reload" && str !="downexcel" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
		case "search":	 // 조회
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
			
			current_page = -1;
			pagingMode = "N";
			
			kepSearch(document.searchCondition,  mySheet , "/exol/getExportExOlExportProgressList.do" , pagingMode );
			break;
			
		case "downexcel":
			$("#pageflag").val('0');
		    var downCol = "";
			for(var i=0;i<=mySheet.LastCol();i++){
				if(!mySheet.GetColHidden(i) && mySheet.ColSaveName(i) !="SELECTED"){
					downCol += "|"+i;	
				}
			}
			var param = {FileName:"외자납품관리.xlsx",Merge:1,SheetDesign:1,DownCols:downCol.substring(1)};
			kepDownExcel(document.searchCondition ,mySheet , "/exiv/excelExportExOlExportProgressList.do", param);
			$("#pageflag").val('1');
			break;
			
		case "reload":	// 초기화
			kepReload('searchCondition');
			$("#st_buyer_code").val("");
			$("#st_complete_mark").val("N");
			mySheet.RemoveAll();
			$("#st_from_date").val( kepToMonthAdd("1","M"));
			$("#st_to_date").val( kepToMonthAdd("1","P"));
			break;

		case "ciDel": // CI, PL 삭제
			for(var i = 0 ; i <arrRow.length; i++){
				var complete_mark = mySheet.GetCellValue(arrRow[i],"COMPLETE_MARK");
				var bl_complete_mark = mySheet.GetCellValue(arrRow[i],"BL_COMPLETE_MARK");
				var result_flag = mySheet.GetCellValue(arrRow[i],"RESULT_FLAG");
				
				if(result_flag == "CONFIRM"){
					alert("승인 건은 삭제할 수 없습니다.");
					return;
				}
				
				if(result_flag == "REJECT" && bl_complete_mark == "Y"){
					alert("취소 건은 B/L 삭제 후 진행하여 주시기 바랍니다.");
					return;
				}
				
				if(complete_mark == "Y"){
					alert("납품완료 건은 삭제할 수 없습니다.");
					return;
				}
				
				if(bl_complete_mark == "Y"){
					alert("B/L 삭제 후 진행하여 주시기 바랍니다.");
					return;
				}
	 	 	}
		
	 	    if(!confirm("C/I, P/L 삭제하시겠습니까?")){
	 	    	return;
	 	    }else{
	 	    	kepSave(document.searchCondition ,  mySheet , "/exol/delCiExportExOlExportProgress.do", "SELECTED");
	 	    }
			break;
			
		case "blDel": // BL 삭제
			for(var i = 0 ; i <arrRow.length; i++){
				var complete_mark = mySheet.GetCellValue(arrRow[i],"COMPLETE_MARK");
				var bl_no = mySheet.GetCellValue(arrRow[i],"BL_NO");
				var result_flag = mySheet.GetCellValue(arrRow[i],"RESULT_FLAG");
				
				if(result_flag == "CONFIRM"){
					alert("승인 건은 삭제할 수 없습니다.");
					return;
				}
				
				if(complete_mark == "Y"){
					alert("납품완료 건은 삭제할 수 없습니다.");
					return;
				}
				
				if(bl_no == ""){
					alert("B/L 미생성 건은 삭제할 수 없습니다.");
					return;
				}
	 	 	}
		
	 	    if(!confirm("B/L 삭제하시겠습니까?")){
	 	    	return;
	 	    }else{
	 	    	kepSave(document.searchCondition ,  mySheet , "/exol/delBlExportExOlExportProgress.do", "SELECTED");
	 	    }
			break;
			
		case "save": // 저장
			for(var i = 0 ; i <arrRow.length; i++){
				var complete_mark = mySheet.GetCellValue(arrRow[i],"COMPLETE_MARK");
				var result_flag = mySheet.GetCellValue(arrRow[i],"RESULT_FLAG");
				
				if(result_flag == "CONFIRM"){
					alert("승인 건은 저장할 수 없습니다.");
					return;
				}
				
				if(complete_mark == "Y"){
					alert("납품완료 건은 저장할 수 없습니다.");
					return;
				}
	 	 	}
		
	 	    if(!confirm("저장하시겠습니까?")){
	 	    	return;
	 	    }else{
	 	    	kepSave(document.searchCondition ,  mySheet , "/exol/saveExportExOlExportProgress.do", "SELECTED");
	 	    }
			break;
			
		case "cmpl": // 납품완료
			for(var i = 0 ; i <arrRow.length; i++){
				var complete_mark = mySheet.GetCellValue(arrRow[i],"COMPLETE_MARK");
				var bl_complete_mark = mySheet.GetCellValue(arrRow[i],"BL_COMPLETE_MARK");
				var result_flag = mySheet.GetCellValue(arrRow[i],"RESULT_FLAG");
				var ci_image_key = mySheet.GetCellValue(arrRow[i],"CI_IMAGE_KEY");
				var bl_image_key = mySheet.GetCellValue(arrRow[i],"BL_IMAGE_KEY");
				
				if(result_flag == "CONFIRM"){
					alert("승인 건은 처리할 수 없습니다.");
					return;
				}
				
				if(complete_mark == "Y"){
					alert("납품완료 건은 처리할 수 없습니다.");
					return;
				}
				
				if(bl_complete_mark != "Y"){
					alert("B/L 등록 후 진행하여 주시기 바랍니다.");
					return;
				}
				
				if(ci_image_key == ""){
					alert("C/I 첨부는 필수입니다.");
					return;
				}
				
				if(bl_image_key == ""){
					alert("B/L 첨부는 필수입니다.");
					return;
				}
	 	 	}
			
			mySheet.SetColProperty("EXP_REPORT_DATE",{KeyField:true});
			mySheet.SetColProperty("EXP_SHIP_DATE",{KeyField:true});
			mySheet.SetColProperty("ENTRY_EXCHANGE_RATE",{KeyField:true});
			mySheet.SetColProperty("IMAGE_KEY",{KeyField:true});
			$("#st_complete_mark").val("Y");
			
	 	    if(!confirm("납품완료 처리하시겠습니까?")){
	 	    	return;
	 	    }else{
	 	    	kepSave(document.searchCondition ,  mySheet , "/exol/saveExportExOlExportProgress.do", "SELECTED");
	 	    }
	 	    
			mySheet.SetColProperty("EXP_REPORT_DATE",{KeyField:false});
	 		mySheet.SetColProperty("EXP_SHIP_DATE",{KeyField:false});
	 		mySheet.SetColProperty("ENTRY_EXCHANGE_RATE",{KeyField:false});
	 		mySheet.SetColProperty("IMAGE_KEY",{KeyField:false});
	 		$("#st_complete_mark").val("N");
			
	 		break;
	}
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
	if (!isEmpty(msg)){
		alert(msg);
	}

	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);
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

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition, mySheet, "/exol/getExportExOlExportProgressList.do?page="+current_page, pagingMode);
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH){
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	
	if(column == "CI_SHEET"){
		var PKG_CMPY_NO = $("#st_pkg_cmpy_no").val();
		var BUYER = mySheet.GetCellValue(Row,"BUYER");
		var CI_NO = mySheet.GetCellValue(Row,"CI_NO");
		
		var fileName = "RD_06_S_001_134";
		var param = "["+PKG_CMPY_NO+"]["+BUYER+"]["+CI_NO+"]";
		
		openSearchPopup("/coco/showReportViewer.do","?fileName=" + fileName + "&param=" + param,"800,850,no,yes");
	}else if(column == "PL_SHEET"){
		var PKG_CMPY_NO = $("#st_pkg_cmpy_no").val();
		var BUYER = mySheet.GetCellValue(Row,"BUYER");
		var CI_NO = mySheet.GetCellValue(Row,"CI_NO");
		
		var fileName = "RD_06_S_001_135";
		var param = "["+PKG_CMPY_NO+"]["+BUYER+"]["+CI_NO+"]";
		
		openSearchPopup("/coco/showReportViewer.do","?fileName=" + fileName + "&param=" + param,"800,850,no,yes");
	}else if(column == "IMAGE_KEY_IMG"){
		popupSel = "fileUpload";
		
		var type="EXP";
		var viewType="VI";
		var complete_mark = mySheet.GetCellValue(Row,"COMPLETE_MARK");
		var image_key=mySheet.GetCellValue(Row, "IMAGE_KEY");
		
		if(complete_mark == "Y"){
			viewType = "R";
		}
		
		openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
	}else if(column == "BL_IMAGE_KEY_IMG"){
		popupSel = "bl_fileUpload";
		
		var type="EXP_BL";
		var viewType="R";
		var complete_mark = mySheet.GetCellValue(Row,"COMPLETE_MARK");
		var bl_complete_mark = mySheet.GetCellValue(Row,"BL_COMPLETE_MARK");
		var image_key=mySheet.GetCellValue(Row, "BL_IMAGE_KEY");
		
		if(bl_complete_mark == "Y"){
			viewType = "VI";
		}else{
			alert("B/L 생성 이후 파일첨부 가능합니다.");
			return;
		}
		
		if(complete_mark == "Y"){
			viewType = "R";
		}
		
		openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
	}else if(column == "CI_IMAGE_KEY_IMG"){
		popupSel = "ci_fileUpload";
		
		var type="EXP_CI";
		var viewType="VI";
		var complete_mark = mySheet.GetCellValue(Row,"COMPLETE_MARK");
		var image_key=mySheet.GetCellValue(Row, "CI_IMAGE_KEY");
		
		if(complete_mark == "Y"){
			viewType = "R";
		}
		
		openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
	}else if(column == "LOT_IMG"){
		var BUYER = mySheet.GetCellValue(Row,"BUYER");
		var CI_NO = mySheet.GetCellValue(Row,"CI_NO");

		var params= "?st_buyer="+BUYER+"&st_ci_no="+CI_NO;
		
		openSearchPopup("/exol/showExportExOlExportProgressLotPop.do", params, "800,300,no");
	}else if(column == "CI_NO"){
		var PKG_CMPY_NO = $("#st_pkg_cmpy_no").val();
		var BUYER = mySheet.GetCellValue(Row,"BUYER");
		var CI_NO = mySheet.GetCellValue(Row,"CI_NO");
		
		var params= "?st_pkg_cmpy_no="+PKG_CMPY_NO+"&st_buyer="+BUYER+"&st_ci_no="+CI_NO;
		
		openSearchPopup('/exol/getExportExOlExportProgressCiData.do', params, "900,660,no");
	}else if(column == "BL_NO" && (mySheet.GetCellValue(Row,"BL_NO") != "")){
		var PKG_CMPY_NO = $("#st_pkg_cmpy_no").val();
		var BUYER = mySheet.GetCellValue(Row,"BUYER");
		var BL_NO = mySheet.GetCellValue(Row,"BL_NO");
		
		var params= "?st_pkg_cmpy_no="+PKG_CMPY_NO+"&st_buyer="+BUYER+"&st_bl_no="+BL_NO;
		
		openSearchPopup('/exol/getExportExOlExportProgressBlData.do', params, "900,660,no");
	}
}

//그리드 헤더 전체 체크박스 클릭 이벤트
function mySheet_OnCheckAllEnd(Col, Value) {
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	if (column == 'SELECTED') { // 선택
	} 
}

// 그리드 셀 변경시 이벤트
function mySheet_OnChange(Row, Col, Value) {
}

//팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "buyer_multi_b": // 고객사 M
			openSearchPopup('/common/safetyCompanyCodePop.do','?COM_TYPE=B', '880,450,no');
	        popupSel = "buyer_multi_b";
		break;
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	//팝업 조회후 해당 항목에 값을 셋팅
	 if(popupSel == "buyer_multi_b") {	// 다중 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(kepMultiName(value2,"@"));
	}else if(popupSel == "ci_fileUpload"){
		mySheet.SetCellValue(grbRow, 'CI_IMAGE_KEY', value1);
		mySheet.SetCellValue(grbRow, 'CI_IMAGE_KEY_IMG', (value2=='on')? diskOn : diskOff);
	}else if(popupSel == "bl_fileUpload"){
		mySheet.SetCellValue(grbRow, 'BL_IMAGE_KEY', value1);
		mySheet.SetCellValue(grbRow, 'BL_IMAGE_KEY_IMG', (value2=='on')? diskOn : diskOff);
	}else if(popupSel == "fileUpload"){
		mySheet.SetCellValue(grbRow, 'IMAGE_KEY', value1);
		mySheet.SetCellValue(grbRow, 'IMAGE_KEY_IMG', (value2=='on')? diskOn : diskOff);
	}
	grbRow="";	//초기화
}
function mySheet_OnDownFinish(downloadType, result) {
    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거
}
</script>
</head>

<body onload="kep_onload_view()">
<div id="wrapper">
<!-- 메뉴 S -->
<c:import charEncoding="utf-8" url="/menu/menu.do" >
<c:param name="page" value="exportHeader"/>
<c:param name="part" value="eheader"/>
</c:import>

<div id="container2">
<c:import charEncoding="utf-8" url="/menu/menu.do">
<c:param name="page" value="sellerLeft"/>
<c:param name="part" value="${param.upperId}"/>
</c:import>
<!-- 메뉴 E -->
<!--내용 시작-->
<div id="ContArea">
	<h3>외자납품 관리</h3>
	<!--버튼영역-->
     <div id="searchBtnA">
     	<span class="btn_search"><a href="javascript:doAction('search');">조회</a></span> 
		<span class="btn_reset"><a href="javascript:doAction('reload');">초기화</a></span>
     </div>
	<!--조회영역-->
	<form name = "searchCondition" method = "post" onsubmit="return false" >
		<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_pkg_cmpy_no" name="st_pkg_cmpy_no"  value="${sessionInfo.comCode}">
			<input type="hidden" id="st_complete_mark" name="st_complete_mark"  value="N">
			
			<table  class="cont_t_list01" style="width:1024px;">
				<caption>외자납품 관리</caption>
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
							<th>C/I Date</th>
							<td colspan="3">
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:20%; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_from_date')"></a> -
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:20%; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_to_date')"></a>
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span>
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span>
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>
							</td>

							<th>진행상태</th>
							<td style="font-weight:normal;">
								<select id="st_recv_flag" name="st_recv_flag" style="width:50%;">
									<option value="ALL" selected>전체</option>
									<option value="CI">C/I, P/L생성</option>
									<option value="BL">B/L생성</option>
									<option value="CMPL">납품완료</option>
					            </select>
							</td>
						</tr>

						<tr>
							<th>고객사</th>
							<td>
							    <input type="text" class="input_type_text" id="st_buyer_name" name="st_buyer_name" style="width:70%;" value="" readonly onclick="javascript:doPop('buyer_multi_b');">
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:80%" value="">
								<a href="javascript:doPop('buyer_multi_b');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							
							<th>C/I No</th>
							<td>
								<input type="text" class="al" name="st_ci_no" id="st_ci_no" style="width:78%" value="" onkeydown="if(event.keyCode == 13) JavaScript:doAction('search');"  />
							</td>
							
							<th>B/L No</th>
							<td>
								<input type="text" class="al" name="st_bl_no" id="st_bl_no" style="width:70%" value=""   onkeydown="if(event.keyCode == 13) JavaScript:doAction('search');"  /> 
							</td>
						</tr>
				</tbody>
			</table>
		</div>
		
		<span class="fl">
			<img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
			<label for="b_no02" class="hidden">정렬개수선택</label>
			<select name="onepagerow" style="width: 70px;">
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
			createIBSheet("mySheet", "100%", "324px");
		</script>
	</div>
	<p class="paging" id="pageindex"></p>

	<!--버튼영역-->
	<div class="btnArea mb0">
		<span class="fl">
			<span class="btn_04 mr04" ><a href="javascript:doAction('downexcel');">엑셀다운로드</a></span>
		</span>
		<span class="fr">
			<span class="btn_05"><a href="javascript:doAction('ciDel');">C/I, P/L 삭제</a></span>
			<span class="btn_04"><a href="javascript:doAction('blDel');">B/L 삭제</a></span>
			<span class="btn_02"><a href="javascript:doAction('save');">저장</a></span>
			<span class="btn_04"><a href="javascript:doAction('cmpl');">납품완료</a></span> 
		</span>
	</div>

</div>

<!--내용 종료-->	                 
</div>
<%@ include file="/WEB-INF/views/common/include/exportFooter.jsp" %>
</div>
</body>
</html>
