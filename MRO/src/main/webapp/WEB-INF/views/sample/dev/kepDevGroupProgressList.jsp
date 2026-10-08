<%--
**********************************************
* 메뉴 : 
* 화면 : 
* 기능 : 
* 프로그램 ID : 
* 담당자 : 
* 생성일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"%>

<script src="/resources/js/TableBarChart.js"></script>
<script src="/resources/js/common.js"></script>
<link rel="stylesheet" href="/resources/styles/TableBarChart.css" type="text/css" />

<title>Insert title here</title>
<script>
	var mySheet = new ibsheetObject();
	var popupSel = "";
	var grbRow = "";
	var remarkOn = "/resources/images/but_icon01.gif";
	var remarkOff = "/resources/images/but_icon02.gif";
	var diskOn = "/resources/images/disk_on.gif";
	var diskOff = "/resources/images/disk_off.gif";

	//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
	function kep_onload_view() {
		// 견적의뢰일 초기화
		kepSetCalender("st_btoa_date");
		$("#st_btoa_date").val(kepGetNowTimeStr('YYYYMMDD', '/'));
		var unit = KepSheetComboQueryIdData("getUnitMeasureInfo", "");

		var initsheet = {};

		initsheet.HeaderMode = {Sort : 0,ColMove : 1,ColResize : 1	};
		initsheet.Cols = [ 
		      			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Sort:0, Width : 60,	Hidden : 1}
		        			,{Align : "Center",SaveName : "SELECTED",	Header : "",	Type : "DummyCheck",	Width : 50,	EditLen : 50,	Edit : true}
		        			,{Align : "Center",SaveName : "SEQ",		Header : "순번",	Type : "Seq",	Width : 40,	EditLen : 110,	Edit : false}
 		        			,{Align : "Center",SaveName : "PORTAL",		Header : "Portal",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false}
 		        			,{Align : "Center",SaveName : "PART_1",		Header : "대메뉴",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false}
 		        			,{Align : "Center",SaveName : "PART_2",		Header : "중메뉴",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false}
 		        			,{Align : "Center",SaveName : "PART_3",		Header : "소메뉴",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false}
 		        			,{Align : "Center",SaveName : "PART_POP",		Header : "팝업",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false}
 		        			,{Align : "Center",SaveName : "PART_GUBUN",		Header : "구분",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false}
 		        			,{Align : "Center",SaveName : "PROGRAM_ID",		Header : "화면ID",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false}
 		        			,{Align : "Center",SaveName : "DEL_YN",		Header : "삭제여부",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false}
 		        			,{Align : "Center",SaveName : "DESIGN_END_DATE",		Header : "P1",	Type : "Date",	Width : 100,	EditLen : 110,	Edit : false}
 		        			,{Align : "Center",SaveName : "DESIGN_YN",		Header : "C1",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false}
 		        			,{Align : "Center",SaveName : "DESIGN_USER",		Header : "담당자1",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false}
 		        			,{Align : "Center",SaveName : "DEV_END_DATE",		Header : "P2",	Type : "Date",	Width : 100,	EditLen : 110,	Edit : false}
 		        			,{Align : "Center",SaveName : "DEV_YN",		Header : "C2",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false}
 		        			,{Align : "Center",SaveName : "DEV_USER",		Header : "개발자",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false}
 		        			,{Align : "Center",SaveName : "TEST_END_DATE",		Header : "P3",	Type : "Date",	Width : 100,	EditLen : 110,	Edit : false}
 		        			,{Align : "Center",SaveName : "TEST_YN",		Header : "C3",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false}
 		        			,{Align : "Center",SaveName : "TEST_USER",		Header : "담당자3",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false}
 		        			,{Align : "Center",SaveName : "PRIORITY",		Header : "우선순위",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false}
		      		];
		IBS_InitSheet(mySheet, initsheet);

		//비고이미지설정
		mySheet.SetImageList(1, remarkOn);
		mySheet.SetImageList(0, remarkOff);
		//파일첨부이미지설정
		mySheet.SetImageList(2, diskOff);
		mySheet.SetImageList(3, diskOn);

		//하이퍼링크 설정
		setLinkCol(mySheet, "DEL");
		setLinkCol(mySheet, "INS");
		setLinkCol(mySheet, "ORIGIN_NAME");
		setLinkCol(mySheet, "BTOA_REMARK_IMG");
		setLinkCol(mySheet, "IMAGE_KEY_IMG");

		var rows = mySheet.DataInsert(-1);
		mySheet.SetCellValue(rows, 'DEL', "D");
		mySheet.SetCellValue(rows, 'INS', "C");
		mySheet.SetCellValue(rows, 'BTOA_REMARK_IMG', remarkOff);
		mySheet.SetCellValue(rows, 'IMAGE_KEY_IMG', diskOff);
	}
	var st;
	var mt;
	//기능함수
	function doAction(str) {
		st = new Date();
		switch (str) {

		case "save":
// 			var selectedGrid = mySheet.FindCheckedRow("SELECTED");
// 			var arrRow = selectedGrid.split("|");
// 			if (document.searchCondition.st_buyer.value == '' || document.searchCondition.st_buyer.value == null) {
// 				alert("고객사를 지정하여 주십시요.");
// 				return;
// 			}
// 			if (document.searchCondition.st_btoa_user_id.value == '' || document.searchCondition.st_btoa_user_id.value == null) {
// 				alert("의뢰자를 지정하여 주십시요.");
// 				return;
// 			}
// 			if (kepReplaceAll('st_btoa_date', '\\/', '') == '' || kepReplaceAll('st_btoa_date', '\\/', '') == null) {
// 				alert("견적의뢰일을 지정하여 주십시요.");
// 				return;
// 			}

// 			if (selectedGrid.length == 0) {
// 				alert("견적의뢰할 품목을 선택하여 주십시요.");
// 				return;
// 			}

// 			for (var i = 0; i < arrRow.length; i++) {
// 				var selectedDate = mySheet.GetCellValue(arrRow[i], "BTOA_END_DATE");
// 				var currDate = kepGetNowTimeStr('YYYYMMDD', '');

// 				if (selectedDate < currDate) {
// 					alert((i + 1) + "번째 행의 견적 회신요청일은 현재날짜 이후로 지정해 주십시오.");
// 					return;
// 				}

// 				//  	 			if (mySheet.GetCellValue(arrRow[i],"ITEM_QTY") <= 0 ||  mySheet.GetCellValue(arrRow[i],"ITEM_QTY") == ""){
// 				// 	 				alert((i+1)+"번째 행의 수량을 입력하여 주십시오.숫자형식으로 소수점 3자리 까지 입력가능합니다.");
// 				// 	 				return;
// 				// 	 			}

// 				KepFilterString(mySheet.GetCellValue(arrRow[i], "DESCRIPTION"));
// 				KepFilterString(mySheet.GetCellValue(arrRow[i], "SPECIFICATION"));
// 				KepFilterString(mySheet.GetCellValue(arrRow[i], "MAKER_NAME"));
// 				KepFilterString(mySheet.GetCellValue(arrRow[i], "BTOA_REMARK"));

// 			}

			if (!confirm("저장 하시겠습니까?"))
				return;
			// 시트 각 컬럼의 이름을 S_SAVENAME 객체에 담는다.
			IBS_SaveName(document.searchCondition, mySheet);

			// 조회조건 묶기
			kepSave(document.searchCondition, mySheet, "/dev/saveKepDevGroupProgress.do", "SELECTED");
			break;

		case "reload":
			mySheet.RemoveAll();
			break;
		}
	}
	function checkValidation(msgFlg) {

		var checkRows = mySheet.FindCheckedRow("SELECTED");
		var arrRow = checkRows.split("|");
		var checkedCnt = arrRow.length;

		for (var i = 0; i < checkedCnt; i++) {

			if (msgFlg == 'true') {
				if (mySheet.GetCellValue(arrRow[i], "ITEM_STATUS") == 'K' && mySheet.GetCellValue(arrRow[i], "CONTRACT_NO")) {
					alert(i + 1 + '번째 품목은 기등록 상품 입니다.\n\n품목코드를 확인하시어,\n\n계약서번호를 설정 바랍니다.');
					return false;
					break;
				} else if (mySheet.GetCellValue(arrRow[i], "KEP_MAKER_CODE") == '') {
					alert((i + 1) + "번째 상품 제조사를 설정 바랍니다.");
					return false;
					break;
				}
			}
		}
		return true;
	}
	function mySheet_OnLoadData(DATA) {
		mt = new Date();
		return DATA;
	}
	function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	


	}
	function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
		if (code > 0) {
			mySheet.RemoveAll();
			alert("견적번호가 생성되었습니다.");
			return;
		} else {
			alert("견적생성에 실패하였습니다.\n\n\관리자에게 문의하여 주시길 바랍니다.");
			return;
		}
	}
	// TABLE의 ROW 데이타 생성
	function addrows() {
		var rows = mySheet.DataInsert(-1);

		mySheet.SetCellValue(rows, 'DEL', "D");
		mySheet.SetCellValue(rows, 'INS', "C");
		mySheet.SetCellValue(rows, 'BTOA_REMARK_IMG', remarkOff);
		mySheet.SetCellValue(rows, 'IMAGE_KEY_IMG', diskOff);
	}

	
	function viewGraph() {
		var strTmp = "";
		var strTmpDesign = "";
// ,{Align : "Center",SaveName : "PORTAL",		Header : "Portal",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false}
// 	,{Align : "Center",SaveName : "PART_1",		Header : "대메뉴",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false}
// 	,{Align : "Center",SaveName : "PART_2",		Header : "중메뉴",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false}
// 	,{Align : "Center",SaveName : "PART_3",		Header : "소메뉴",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false}
// 	,{Align : "Center",SaveName : "PART_POP",		Header : "팝업",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false}
// 	,{Align : "Center",SaveName : "PART_GUBUN",		Header : "구분",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false}
// 	,{Align : "Center",SaveName : "PROGRAM_ID",		Header : "화면ID",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false}
// 	,{Align : "Center",SaveName : "DEL_YN",		Header : "삭제여부",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false}
// 	,{Align : "Center",SaveName : "DESIGN_END_DATE",		Header : "상세설계완료일자",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false}
// 	,{Align : "Center",SaveName : "DESIGN_YN",		Header : "상세설계완료여부",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false}
// 	,{Align : "Center",SaveName : "DESIGN_USER",		Header : "상세설계담당자",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false}
// 	,{Align : "Center",SaveName : "DEV_END_DATE",		Header : "개발완료일자",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false}
// 	,{Align : "Center",SaveName : "DEV_YN",		Header : "개발완료여부",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false}
// 	,{Align : "Center",SaveName : "DEV_USER",		Header : "개발담당자",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false}
// 	,{Align : "Center",SaveName : "TEST_END_DATE",		Header : "테스트완료일자",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false}
// 	,{Align : "Center",SaveName : "TEST_YN",		Header : "테스트완료여부",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false}
// 	,{Align : "Center",SaveName : "TEST_USER",		Header : "테스트담당자",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false}
// 	,{Align : "Center",SaveName : "PRIORITY",		Header : "우선순위",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false}


		var headerNm = new Array();
		var headerDesignNm = new Array();
		for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
			var design_user = mySheet.GetCellValue(i, "DESIGN_USER");
			var dev_user = mySheet.GetCellValue(i, "DEV_USER");

			if(headerDesignNm.indexOf(design_user) == -1){
				headerDesignNm.push(design_user);
			}
			if(headerNm.indexOf(dev_user) == -1){
				headerNm.push(dev_user);
			}

		}
		
		var totCntDesign = new Map();
		var realCntDesign = new Map();
		var totnoDesign = 0;
		var realnoDesign = 0;
		
		var totCnt = new Map();
		var realCnt = new Map();
		var realCntTest = new Map();
		var totno = 0;
		var realno = 0;
		
		for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
			
			var design_user = kepTrimStr(mySheet.GetCellValue(i, "DESIGN_USER"));
			var design_yn = kepTrimStr(mySheet.GetCellValue(i, "DESIGN_YN"));
			
			for(var k=0; k<headerDesignNm.length; k++){
				if( headerDesignNm[k] == design_user ){
					var cnt_t_design = totCntDesign.get(design_user);
					cnt_t_design = (cnt_t_design != null && cnt_t_design !='' && cnt_t_design !='undefined' )? eval(cnt_t_design)+1: 1;
					totCntDesign.put(design_user, cnt_t_design);
					
					if(design_yn != ''){
						var cnt_r_design = realCntDesign.get(design_user);
						cnt_r_design = (cnt_r_design != null && cnt_r_design !='' && cnt_r_design !='undefined' )? eval(cnt_r_design)+1: 1;
						realCntDesign.put(design_user, cnt_r_design);
					}
				}
			}

			
			var dev_user = kepTrimStr(mySheet.GetCellValue(i, "DEV_USER"));
			var dev_yn = kepTrimStr(mySheet.GetCellValue(i, "DEV_YN"));
			var test_yn = mySheet.GetCellValue(i, "TEST_YN");
			
			for(var j=0; j<headerNm.length; j++){
				if( headerNm[j] == dev_user ){
					var cnt_t = totCnt.get(dev_user);
					cnt_t = (cnt_t != null && cnt_t !='' && cnt_t !='undefined' )? eval(cnt_t)+1: 1;
					totCnt.put(dev_user, cnt_t);

					if(dev_yn != ''){
						var cnt_r = realCnt.get(dev_user);
						cnt_r = (cnt_r != null && cnt_r !='' && cnt_r !='undefined' )? eval(cnt_r)+1: 1;
						realCnt.put(dev_user, cnt_r);
					}
					
					if(test_yn != ''){
						var cnt_r_test = realCntTest.get(dev_user);
						cnt_r_test = (cnt_r_test != null && cnt_r_test !='' && cnt_r_test !='undefined' )? eval(cnt_r_test)+1: 1;
						realCntTest.put(dev_user, cnt_r_test);
					}					
				}
			}
			
		}

		for(var i=0; i<headerDesignNm.length; i++){
			totnoDesign += eval(totCntDesign.get(headerDesignNm[i]));
			realnoDesign += eval(realCntDesign.get((headerDesignNm[i]!='undefined')?headerDesignNm[i]:0 ));
		}
		for(var i=0; i<headerNm.length; i++){
			totno += eval(totCnt.get(headerNm[i]));
			realno += eval(realCnt.get(headerNm[i]));
		}

		//---------------------------------------------------------------------
					
		strTmpDesign += "<caption>상세설계</caption>";	    	
		strTmpDesign += "<thead><tr>";	    	
		strTmpDesign += "<th></th>";
// 		strTmpDesign += "<th>전체</th>";
		for(var i=0; i<headerDesignNm.length; i++){
			strTmpDesign += "<th>"+headerDesignNm[i]+"</th>";
		}		
		strTmpDesign += "</tr></thead>";	    	
		strTmpDesign += "<tbody><tr>";
		strTmpDesign += "<th>총건수(Total)</th>";	    	
// 		strTmpDesign += "<td>"+totnoDesign+"</td>";
		for(var i=0; i<headerDesignNm.length; i++){
			strTmpDesign += "<td>"+totCntDesign.get(headerDesignNm[i])+"</td>";	    	
		}		
		strTmpDesign += "</tr><tr>";	    	
		strTmpDesign += "<th>설계(실적)</th>";	    	
// 		strTmpDesign += "<td>"+realnoDesign+"</td>";
		for(var i=0; i<headerDesignNm.length; i++){
			strTmpDesign += "<td>"+realCntDesign.get(headerDesignNm[i])+"</td>";	    	
		}		
		strTmpDesign += "</tr></tbody>";	    	
	
		$("#source1").html(strTmpDesign);
		$('#source1').tableBarChart('#target1', '', false);		

		//---------------------------------------------------------------------

		strTmp += "<caption>개발 및 테스트</caption>";	    	
		strTmp += "<thead><tr>";	    	
		strTmp += "<th></th>";
// 		strTmp += "<th>전체</th>";
		for(var i=0; i<headerNm.length; i++){
			strTmp += "<th>"+headerNm[i]+"</th>";
		}		
		strTmp += "</tr></thead>";	    	
		strTmp += "<tbody><tr>";
		strTmp += "<th>총건수(Total)</th>";	    	
// 		strTmp += "<td>"+totno+"</td>";
		for(var i=0; i<headerNm.length; i++){
			strTmp += "<td>"+totCnt.get(headerNm[i])+"</td>";	    	
		}		
		strTmp += "</tr><tr>";	    	
		strTmp += "<th>개발(실적)</th>";	    	
// 		strTmp += "<td>"+realno+"</td>";
		for(var i=0; i<headerNm.length; i++){
			strTmp += "<td>"+realCnt.get(headerNm[i])+"</td>";	    	
		}		
		strTmp += "</tr><tr>";	    	
		strTmp += "<th>테스트(실적)</th>";	    	
// 		strTmp += "<td>"+realno+"</td>";
		for(var i=0; i<headerNm.length; i++){
			strTmp += "<td>"+realCntTest.get(headerNm[i])+"</td>";	    	
		}		
		strTmp += "</tr><tr>";	    	
		strTmp += "<th>총실적(%)</th>";	    	
		for(var i=0; i<headerNm.length; i++){
			strTmp += "<td>"+ parseInt (( eval(realCnt.get(headerNm[i])) / eval(totCnt.get(headerNm[i]) )) * 100)+"</td>";	    	
		}		
		strTmp += "</tr></tbody>";	    	
	
		$("#source2").html(strTmp);
		$('#source2').tableBarChart('#target2', '', false);
	
		}
	
	//팝업함수호출
	function doPop(str) {

		switch (str) {
		case "buyer_single":
			openSearchPopup('/common/icomcmpyPop.do','?BUSINESS_COND=B&MULTI=N','500,466,no');
			popupSel = "buyer_single";
			break;
		case "user":
			if ($("#st_buyer").val() == "") {
				alert("고객사를 선택해 주십시요.");
				break;
			}

			openSearchPopup('/common/misUserSelectAllPop.do', '?open=Y&com_code=' + $("#st_buyer").val(),'500,500,no');
			popupSel = "user";
			break;
		case "excelUpLoad": // 엑셀업로드
			/* if (document.searchCondition.st_buyer.value == '' || document.searchCondition.st_buyer.value == null) {
				alert("고객사를 지정하여 주십시요.");
				break;
			}
			if (document.searchCondition.st_btoa_user_id.value == '' || document.searchCondition.st_btoa_user_id.value == null) {
				alert("의뢰자를 지정하여 주십시요.");
				break;
			}
			if (kepReplaceAll('st_btoa_date', '\\/', '') == '' || kepReplaceAll('st_btoa_date', '\\/', '') == null) {
				alert("견적의뢰일을 지정하여 주십시요.");
				break;
			} */

			mySheet.RemoveAll();
			var params = {
				Mode : "HeaderMatch",
				StartRow: "20",
				EndRow : "1024",
				WorkSheetName : "프로그램 개발 진척도 관리 Chart"
			};
			mySheet.LoadExcel(params);
			break;
		}
	}

	function mySheet_OnLoadExcel() {
		var errCnt = 0;
// 		if (1000 < mySheet.RowCount() + 1) {
// 			alert("1000건이하의 파일만 업로드하여 주세요.");
// 			mySheet.RemoveAll();
// 			return;
// 		}

		for (var i = 1; i <= mySheet.RowCount(); i++) {
			// 품목명
			if (kepIsValueNull(mySheet.GetCellValue(i, "DESCRIPTION")) == true) {
				mySheet.SetCellBackColor(i, "DESCRIPTION", "#FF0000");
				errCnt += 1;
			}
			// 규격 
			if (kepIsValueNull(mySheet.GetCellValue(i, "SPECIFICATION")) == true) {
				mySheet.SetCellBackColor(i, "SPECIFICATION", "#FF0000");
				errCnt += 1;
			}
			// 단위
			if (kepIsValueNull(mySheet.GetCellValue(i, "UNIT_MEASURE")) == true) {
				mySheet.SetCellBackColor(i, "UNIT_MEASURE", "#FF0000");
				errCnt += 1;
			}
			// 제조사
			if (kepIsValueNull(mySheet.GetCellValue(i, "MAKER_NAME")) == true) {
				mySheet.SetCellBackColor(i, "MAKER_NAME", "#FF0000");
				errCnt += 1;
			}
			// 원산지
			if (kepIsValueNull(mySheet.GetCellValue(i, "ORIGIN_NAME")) == true) {
				mySheet.SetCellBackColor(i, "ORIGIN_NAME", "#FF0000");
				errCnt += 1;
			}
			// 실적단가
			if (kepIsNumberString(mySheet.GetCellValue(i, "BUYER_TARGET_PRICE")) == false
					|| kepIsValueNull(mySheet.GetCellValue(i, "BUYER_TARGET_PRICE")) == true) {
				mySheet.SetCellBackColor(i, "BUYER_TARGET_PRICE", "#FF0000");
				errCnt += 1;
			}
			// 수량
			if (kepIsNumberString(mySheet.GetCellValue(i, "ITEM_QTY")) == false || kepIsValueNull(mySheet.GetCellValue(i, "ITEM_QTY")) == true) {
				mySheet.SetCellBackColor(i, "ITEM_QTY", "#FF0000");
				errCnt += 1;
			}

			mySheet.SetCellValue(i, 'DEL', "D");
			mySheet.SetCellValue(i, 'INS', "C");
			mySheet.SetCellValue(i, 'IMAGE_KEY_IMG', diskOff);
			mySheet.SetCellValue(i, 'BTOA_REMARK_IMG', (mySheet.GetCellValue(i, "BTOA_REMARK") != "") ? remarkOn : remarkOff);
		}
		if (errCnt > 0)
			alert(errCnt + "건의 데이터가 잘못되었습니다. 수정하여 주세요.");
	}

	//콜백함수(파일명은 모두 동일)
	function setPopupReturn(code, text, value3, value4, value5, value6, value7, value8) {
		if (popupSel == "buyer_single") {
			$("#st_buyer").val(code);
			$("#st_buyer_name").val(text);
		} else if (popupSel == "country") {
			mySheet.SetCellValue(grbRow, 'ORIGIN_CODE', code);
			mySheet.SetCellValue(grbRow, 'ORIGIN_NAME', value3);
		} else if (popupSel == "user") { // id,이름,부서코드,부서명,전화번호,email,fax
			$("#st_btoa_user_id").val(code);
			$("#st_btoa_user_name").val(text);
			$("#st_btoa_user_dept").val(value3);
			$("#st_btoa_user_dept_name").val(value4);
			$("#st_btoa_user_tel").val(value5);
			$("#st_btoa_user_mail").val(value6);
			$("#st_btoa_user_fax").val(value7);

		} else if (popupSel == "remarkBtoA") { //고객사 비고
			mySheet.SetCellValue(grbRow, 'BTOA_REMARK', code);
			mySheet.SetCellValue(grbRow, 'BTOA_REMARK_IMG', (code != "") ? remarkOn : remarkOff);
		} else if (popupSel == "fileUpload") { //파일 첨부
			mySheet.SetCellValue(grbRow, 'IMAGE_KEY', code);
			mySheet.SetCellValue(grbRow, 'IMAGE_KEY_IMG', (code != '') ? diskOn : diskOff);
		}

	}
	// 헤더 더블클릭시 복사
	function mySheet_OnDblClick(Row, Col, CellX, CellY, CellW, CellH) {
		if (Row > 0)
			return;

		var checkRows = mySheet.FindCheckedRow("SELECTED");
		var arrRow = checkRows.split("|");

		if (mySheet.ColSaveName(Col) == "BTOA_END_DATE") { // 회신요청일
			var btoaEndDate = mySheet.GetCellValue(arrRow[0], "BTOA_END_DATE");
			for (var idx = 0; idx < arrRow.length; idx++) {
				mySheet.SetCellValue(arrRow[idx], "BTOA_END_DATE", btoaEndDate);
			}
		}
	}
	//그리드 셀클릭 이벤트
	function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		if (Row < 1)
			return;
		var column = mySheet.ColSaveName(Col);
		grbRow = Row; //현재 Row를 전역변수에 셋팅

		if (column == 'ORIGIN_NAME') { // 원산지
			openSearchPopup('/common/countryCodePop.do');
			popupSel = "country";

		} else if (column == "BTOA_REMARK_IMG") {
			popupSel = "remarkBtoA";
			var btoaRemark = mySheet.GetCellValue(Row, "BTOA_REMARK");
			openSearchPopup('/common/remarkBtoAPop.do', '?st_btoa_remark=' + btoaRemark,'500,220,no');// 고객사 비고

		} else if (column == "IMAGE_KEY_IMG") {
			popupSel = "fileUpload";
			var type = "RFQ";
			var viewType = "VI";
			var image_key = mySheet.GetCellValue(Row, "IMAGE_KEY");
			openSearchPopup('/common/fileUploadPop.do', '?DOC_NO=' + image_key + '&type=' + type + '&viewType=' + viewType,'500,430,no');// 파일첨부

		} else if (column == "DEL") { // 삭제
			mySheet.RowDelete();
			//순번 재배열
			mySheet.ReNumberSeq();

		} else if (column == "INS") { // 행복사
			mySheet.DataCopy();
			//순번 재배열
			mySheet.ReNumberSeq();

		}
	}
	// 의뢰자 관련 초기화(의뢰자,의뢰부서,전화번호,팩스번호)
	function doEraser() {
		$("#st_btoa_user_id").val("");
		$("#st_btoa_user_name").val("");
		$("#st_btoa_user_dept").val("");
		$("#st_btoa_user_dept_name").val("");
		$("#st_btoa_user_tel").val("");
		$("#st_btoa_user_mail").val("");
		$("#st_btoa_user_fax").val("");
	}
</script>
<title>IBSheet Sample</title>
</head>
<body onload="kep_onload_view()">
	<!--내용 시작-->
	<div id="searchBtnA">
		<h3>개발 진척관리</h3>
<!-- 	    <span class="btn_search"><a href="javascript:doPop('excelUpLoad')">EXCEL업로드</a></span>  -->
<!-- 	    <span class="btn_reset"><a href="javascript:viewGraph();">그래프 표시</a></span> -->
		<span class="btn_05 mr04"><a href="javascript:doPop('excelUpLoad');">EXCEL업로드</a></span> 
		<span class="btn_05 mr04"><a href="javascript:viewGraph();">그래프 표시</a></span>
	</div>
	
	<form name="searchCondition" id="searchCondition">
		<input type="hidden" name="st_btoa_user_mail" id="st_btoa_user_mail" value=""> <input type="hidden" name="st_kep_recv_user_id"
			id="st_kep_recv_user_id" value="${sessionInfo.userId}">
		<!-- 세션 ID 매핑 -->
		<input type="hidden" name="GW_NO" id="GW_NO" value="N"> <input type="hidden" name="s_SAVENAME">

		<!-- <div id="cont_searchA">
			<table class="cont_t_list01" style="width: 100%;">
				<tr>
					<td>고객사</td>
					<td><input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width: 71%" value="" readonly
						onclick="javascript:doPop('buyer_single');"> <input type="hidden" name="st_buyer" id="st_buyer" style="width: 80%" value=""> <a
						href="javascript:doPop('buyer_single');"><img src="/resources/images/btn_search03.gif"></a> <a
						href="javascript:kepEraser('st_buyer','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a></td>
					<td>의뢰자</td>
					<td><input type="text" class="input_type_text" name="st_btoa_user_name" id="st_btoa_user_name" style="width: 73%" value="" readonly
						onclick="javascript:doPop('user');"> <input type="hidden" name="st_btoa_user_id" id="st_btoa_user_id" style="width: 80%" value="">
						<a href="javascript:doPop('user');"><img src="/resources/images/btn_search03.gif"></a> <a href="javascript:doEraser();"><img
							src="/resources/images/btn_eraser2.gif"></a></td>
					<td>의뢰부서</td>
					<td><input type="hidden" name="st_btoa_user_dept" id="st_btoa_user_dept" style="width: 90%" value=""> <input type="text"
						class="input_type_text" name="st_btoa_user_dept_name" id="st_btoa_user_dept_name" style="width: 90%" value=""></td>
				</tr>
				<tr>
					<td>견적의뢰일</td>
					<td><input type="text" class="input_type_text" name="st_btoa_date" id="st_btoa_date" readOnly style="width: 100px; text-align: center;">
						<a href="javascript:kepCalendar('st_btoa_date')"></a></td>
					<td>전화번호</td>
					<td><input type="text" class="input_type_text" name="st_btoa_user_tel" id="st_btoa_user_tel" style="width: 90%" value=""></td>
					<td>팩스번호</td>
					<td><input type="text" class="input_type_text" name="st_btoa_user_fax" id="st_btoa_user_fax" style="width: 90%" value=""></td>
				</tr>
			</table>
		</div> -->



	<table>
		<tr>
			<td>
				<table id="source1">
				</table>
			</td>
			<td>
				<table id="source2">
				</table>
			</td>
		</tr>
		<tr>
			<td><div id="target1" style="width: 600px; height: 400px"></div></td>
			<td><div id="target2" style="width: 600px; height: 400px"></div></td>
		</tr>
	</table>


		<table>
			<tr>
				<td>
					<div class="ib_product" style="border-top: 2px solid #3c639c">
						<script type="text/javascript">
							createIBSheet("mySheet", "", "354px");
						</script>
					</div>
				</td>
			</tr>
		</table>
		

		<!-- 		<div class="paging" id="pageindex"></div> -->

<!-- 		<div class="btnArea mt05">
			<div class="fl">
				<span class="btn_04 mr04"><a href="javascript:doPop('excelUpLoad');">EXCEL업로드</a></span> 
				<span class="btn_02 mr04"><a href="javascript:viewGraph();">그래프 표시</a></span>
			</div>
			<div class="fr">
				<span class="btn_02"><a href="javascript:doAction('save')">저장</a></span>
			</div>
		</div> -->
	</form>

	<!--내용 종료-->
</body>
</html>
