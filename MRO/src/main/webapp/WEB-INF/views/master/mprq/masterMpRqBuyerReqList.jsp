<%--
**********************************************
* 메뉴 : 운영사 > 견적관리
* 화면 : 견적접수(오프라인)
* 기능 : 고객이 오프라인으로 견적의뢰 한 건을 운영담당자가 직접 견적의뢰 등록
* 프로그램 ID : PG_04_M_004_00
* 담당자 : 김영미 ( 설계 : 권우재 )
* 생성일 : 2014-05-13
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"%>
<script src="/resources/js/common.js"></script>
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
		var price_type = KepSheetComboQueryIdData("getReqPriceTypeInfo", "");
		
		var initsheet = {};

		initsheet.HeaderMode = {Sort : 0,ColMove : 1,ColResize : 1	};
		initsheet.Cols = [ 
		      			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Sort:0, Width : 60,	Hidden : 1}, 
		        			{Align : "Center",SaveName : "SELECTED",	Header : "",	Type : "DummyCheck",	Width : 50,	EditLen : 50,	Edit : true}, 
		        			{Align : "Center",SaveName : "QUOTATION_SEQ",		Header : "번호",	Type : "Seq",	Width : 40,	EditLen : 110,	Edit : false},
		        			{Align : "Center",SaveName : "INS",		Header : " ",	Type : "Text",	Width : 25,	EditLen : 110,	Edit : false},
		        			{Align : "Center",SaveName : "DEL",		Header : " ",	Type : "Text",	Width : 25,	EditLen : 110,	Edit : false},
		        			{Align : "Center",SaveName : "BUYER_ITEM_NO",		Header : "품목코드",	Type : "Text",	Width : 100, EditLen : 100,	Edit : true,	hidden:1},
		        			{Align : "Left",SaveName : "DESCRIPTION",		Header : "품목명",	Type : "Text",	Width : 150,	EditLen : 200,	Edit : true, KeyField:true},
		        			{Align : "Left",SaveName : "SPECIFICATION",		Header : "규격",	Type : "Text",	Width : 200,	EditLen : 600,	Edit : true, KeyField:true},
		        			{Align : "Center",SaveName : "REQ_PRICE_TYPE",		Header : "단가구분",	Type : "Combo", ComboText:price_type.ComboText, ComboCode:price_type.ComboCode,	Width : 70,	EditLen : 110,	Edit : true, KeyField:true},
		        			{Align : "Center",SaveName : "BUYER_TARGET_PRICE",		Header : "요청단가",	Type : "Float",	 Format:"${priceFormat}", Width : 100,	EditLen : 110,	Edit : true},
		        			{Align : "Center",SaveName : "UNIT_MEASURE",		Header : "단위",	Type : "Combo", ComboText:unit.ComboText, ComboCode:unit.ComboCode,	Width : 70,	EditLen : 110,	Edit : true, KeyField:true},
		        			{Align : "Center",SaveName : "ITEM_QTY",		Header : "수량",	Type : "Float",	Format:"${qtyFormat}", Width : 100,	EditLen : 110,	Edit : true},
		        			{Align : "Left",SaveName : "MAKER_NAME",		Header : "제조사",	Type : "Text",	Width : 80,	EditLen : 80,	Edit : true},
		        			{Align : "Center",SaveName : "ORIGIN_CODE",		Header : "원산지코드",	Hidden:true,Type : "Text",	Width : 100,	EditLen : 2,	Edit : true},
		        			{Align : "Center",SaveName : "ORIGIN_NAME",		Header : "원산지",	Type : "Text",	Width : 80,	EditLen : 110,	Edit : false},
		        			{Align : "Left",SaveName : "AGENT_NAME",		Header : "기존협력사",	Type : "Text",	Width : 100,	EditLen : 100,	Edit : true},
		        			{Align : "Center",SaveName : "BTOA_END_DATE",		Header : "회신요청일",	Type : "Date",	Width : 90,	EditLen : 110,	Edit : true, KeyField:true},
		        			{Align:"Center",	Width:60,	Edit:true,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:"공개",	SaveName:"AGENT_OPEN_FLAG", BackColor:"${optColor}"},
		        			{Align : "Center",SaveName : "IMAGE_KEY_IMG",		Header : "첨부파일",	Type : "Image",	Width : 60,	EditLen : 110,	Edit : true},
		        			{Align : "Center",SaveName : "IMAGE_KEY",		Header : "첨부파일", Hidden:true, 	Type : "Text",	Width : 100,	EditLen : 110,	Edit : true},
		        			{Align : "Center",SaveName : "BTOA_REMARK_IMG",		Header : "비고",	Type : "Image",	Width : 60,	EditLen : 110,	Edit : true},
		        			{Align : "Center",SaveName : "BTOA_REMARK",		Header : "비고2", Hidden:true,	Type : "Text",	Width : 100,	EditLen : 300,	Edit : true}
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

		mySheet.SetCellFontUnderline(0, "ORIGIN_NAME", true);
		mySheet.SetCellFontUnderline(0, "BTOA_END_DATE", true);
		
	}
	var st;
	var mt;
	//기능함수
	function doAction(str) {
		var confirm_string = "";
		var agent_open_miss_flag = "N";
		
		st = new Date();
		switch (str) {
		case "save":
			var selectedGrid = mySheet.FindCheckedRow("SELECTED");
			var arrRow = selectedGrid.split("|");
			if (document.searchCondition.st_buyer.value == '' || document.searchCondition.st_buyer.value == null) {
				alert("고객사를 지정하여 주십시요.");
				return;
			}
			if (document.searchCondition.st_btoa_user_id.value == '' || document.searchCondition.st_btoa_user_id.value == null) {
				alert("의뢰자를 지정하여 주십시요.");
				return;
			}
			if (kepReplaceAll('st_btoa_date', '\\/', '') == '' || kepReplaceAll('st_btoa_date', '\\/', '') == null) {
				alert("견적의뢰일을 지정하여 주십시요.");
				return;
			}

			if (selectedGrid.length == 0) {
				alert("견적의뢰할 품목을 선택하여 주십시요.");
				return;
			}

			for (var i = 0; i < arrRow.length; i++) {
				var selectedDate = mySheet.GetCellValue(arrRow[i], "BTOA_END_DATE");
				var currDate = kepGetNowTimeStr('YYYYMMDD', '');

				var specLen	= kepGetByteLen(mySheet.GetCellValue(arrRow[i], "ORIGIN_CODE"));
				if ( specLen > 2 )
				{
					alert("현재 입력된 원산지 코드값은 "+specLen+"바이트 입니다.\n원산지 코드는 2바이트 이상 입력할 수 없습니다.");
					return ;
				}
				
				if (selectedDate < currDate) {
					alert((i + 1) + "번째 행의 견적 회신요청일은 현재날짜 이후로 지정해 주십시오.");
					return;
				}

				//  	 			if (mySheet.GetCellValue(arrRow[i],"ITEM_QTY") <= 0 ||  mySheet.GetCellValue(arrRow[i],"ITEM_QTY") == ""){
				// 	 				alert((i+1)+"번째 행의 수량을 입력하여 주십시오.숫자형식으로 소수점 3자리 까지 입력가능합니다.");
				// 	 				return;
				// 	 			}

				KepFilterString(mySheet.GetCellValue(arrRow[i], "DESCRIPTION"));
				KepFilterString(mySheet.GetCellValue(arrRow[i], "SPECIFICATION"));
				KepFilterString(mySheet.GetCellValue(arrRow[i], "MAKER_NAME"));
				KepFilterString(mySheet.GetCellValue(arrRow[i], "BTOA_REMARK"));
				
				// 협력사 공개여부 회사정보와 맞는지 확인(견적의뢰 진행 멘트 변경)
				if ($('#st_open_flag').val() == "Y"){ // 협력사 공개 회사
					if(mySheet.GetCellValue(arrRow[i], "AGENT_OPEN_FLAG") == "0"){ // 견적정보는 공개 미체크 시
						agent_open_miss_flag = "Y";
					}
				}else{ // 협력사 비공개 회사
					if(mySheet.GetCellValue(arrRow[i], "AGENT_OPEN_FLAG") == "1"){ // 견적정보는 공개 체크 시
						agent_open_miss_flag = "Y";
					}
				}
			}
			
			if(agent_open_miss_flag == "N"){ // 회원사 정보와 견적 정보 일치(협력사 공개여부)
				confirm_string = "견적의뢰를 하시겠습니까?";
			}else{
				confirm_string = "[주의]협력사 공개여부 미일치(회원사정보 vs 견적정보)\n\n그래도 견적의뢰를 하시겠습니까?";
			}
			
			if (!confirm(confirm_string))
				return;
			// 시트 각 컬럼의 이름을 S_SAVENAME 객체에 담는다.
			IBS_SaveName(document.searchCondition, mySheet);

			// 조회조건 묶기
			kepSave(document.searchCondition, mySheet, "/mprq/saveMasterMpRqBuyerReq.do", "SELECTED");
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
	
function kepGetByteLen(id) {
		
	    var byteLength = 0;
	    for (var inx = 0; inx < id.length; inx++) {
	        var oneChar = escape(id.charAt(inx));
	        if ( oneChar.length == 1 ) {
	            byteLength ++;
	        } else if (oneChar.indexOf("%u") != -1) {
	            byteLength += 2;
	        } else if (oneChar.indexOf("%") != -1) {
	            byteLength += oneChar.length/3;
	        }
	    }
	    return byteLength;
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
			alert(msg.msg + " 견적번호가 생성되었습니다.");
			return;
		} else {
			alert("견적생성에 실패하였습니다.\n\n\관리자에게 문의하여 주시길 바랍니다.");
			return;
		}
	}
	// TABLE의 ROW 데이타 생성
	function addrows() {
		if (kepIsValueNull($('#st_buyer').val())){
			alert("고객사를 선택하세요.");
			return;
		}
		var rows = mySheet.DataInsert(-1);

		mySheet.SetCellValue(rows, 'DEL', "D");
		mySheet.SetCellValue(rows, 'INS', "C");
		mySheet.SetCellValue(rows, 'BTOA_REMARK_IMG', remarkOff);
		mySheet.SetCellValue(rows, 'IMAGE_KEY_IMG', diskOff);
		
		if ($('#st_open_flag').val() == "Y"){
			mySheet.SetCellValue(rows, 'AGENT_OPEN_FLAG', "1");
		} else {
			mySheet.SetCellValue(rows, 'AGENT_OPEN_FLAG', "0");
		}
	}

	// 체크박스에서 선택된 ROW를 한꺼번에 삭제 (단, 모든 데이타를 한꺼번에 삭제할수는 없다.)
	// 재귀함수
	function checkedDel() {

		var selectedGrid = mySheet.FindCheckedRow("SELECTED");

		if (mySheet.RowCount() == 0) {
			alert("행이 없습니다.");
		}

		if (selectedGrid.length == 0) {
			alert("선택하신 행이 없습니다.");
			return;
		}

		if (!confirm("선택되어 있는 행은 모두 삭제 됩니다.\n삭제하시겠습니까?")) {
			return;
		}

		var rows = mySheet.RowCount();

		while (rows >= 0) {
			var chkedYn = mySheet.GetCellValue(rows, "SELECTED");
			if (chkedYn == "1") {
				mySheet.RowDelete(rows);
			}
			rows--;
		}
		//순번 재배열
		mySheet.ReNumberSeq();
	}

	//팝업함수호출
	function doPop(str) {

		switch (str) {
		case "buyer_single":
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
			popupSel = "buyer_single";
			break;
		case "user":
			if ($("#st_buyer").val() == "") {
				alert("고객사를 선택해 주십시요.");
				break;
			}
			openSearchPopup("/common/misUserSelectAllPop.do", '?open=O&com_code=' + $("#st_buyer").val(), "500,500,no");
			popupSel = "user";
			break;
		case "excelUpLoad": // 엑셀업로드
			if (document.searchCondition.st_buyer.value == '' || document.searchCondition.st_buyer.value == null) {
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
			}

			mySheet.RemoveAll();
			var params = {
				Mode : "HeaderMatch"
			};
			mySheet.LoadExcel(params);
			break;
			
		case "manual": // 매뉴얼 호출
			openSearchPopup("https://gw.koreab2b.com/servlet/HIServlet", "?SLET=bbs.BBSMtrlRead.java&MENUBAR=ON&MET=LIST&BMID=0000007zj&BRDID=0000008i3&LM=nm&NL=1&LMET=CLOSE", "800,600, yes");
			break;
		}
	}

	function sheetSet(open_flag){
		mySheet.RemoveAll();
		
		var rows = mySheet.DataInsert(-1);
		mySheet.SetCellValue(rows, 'DEL', "D");
		mySheet.SetCellValue(rows, 'INS', "C");
		mySheet.SetCellValue(rows, 'BTOA_REMARK_IMG', remarkOff);
		mySheet.SetCellValue(rows, 'IMAGE_KEY_IMG', diskOff);
		
		if (open_flag == "Y"){
			mySheet.SetCellValue(rows, 'AGENT_OPEN_FLAG', "1");
		} else {
			mySheet.SetCellValue(rows, 'AGENT_OPEN_FLAG', "0");
		}
		
	}

	//콜백함수(파일명은 모두 동일)
	function setPopupReturn(code, text, value3, value4, value5, value6, value7, value8) {
		if (popupSel == "buyer_single") {
			if($("#st_buyer").val() != code) {
				doEraser();	
			}
			$("#st_buyer").val(code);
			$("#st_buyer_name").val(text);
			$("#st_open_flag").val(value5);			
			sheetSet(value5);
			
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
			for (var idx = 1; idx <= arrRow.length; idx++) {
				mySheet.SetCellValue(arrRow[idx], "BTOA_END_DATE", btoaEndDate);
			}
		} else if (mySheet.ColSaveName(Col) == "ORIGIN_NAME") { // 원산지
			var value1 = mySheet.GetCellValue(arrRow[0], "ORIGIN_CODE");
			var value2 = mySheet.GetCellValue(arrRow[0], "ORIGIN_NAME");
			for (var idx = 1; idx <= arrRow.length; idx++) {
				mySheet.SetCellValue(arrRow[idx], "ORIGIN_CODE", value1);
				mySheet.SetCellValue(arrRow[idx], "ORIGIN_NAME", value2);
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
			openSearchPopup("/common/countryCodePop.do", "", "500,500,no");
			popupSel = "country";

		} else if (column == "BTOA_REMARK_IMG") {
			popupSel = "remarkBtoA";
			var btoaRemark = mySheet.GetCellValue(Row, "BTOA_REMARK");
			openSearchPopup("/common/remarkReturn2Pop.do", "?st_return_remark="+btoaRemark, "500,230,no"); 

		} else if (column == "IMAGE_KEY_IMG") {
			popupSel = "fileUpload";
			var type = "RFQ";
			var viewType = "VI";
			var image_key = mySheet.GetCellValue(Row, "IMAGE_KEY");
			openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부

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
		<h3>고객사 견적의뢰 입력</h3>
		<span><a href="javascript:doPop('manual')"><img src="/resources/images/question_mark.gif"></a></span>
	</div>
	<form name="searchCondition" id="searchCondition">
		<input type="hidden" name="st_btoa_user_mail" id="st_btoa_user_mail" value=""> <input type="hidden" name="st_kep_recv_user_id"
			id="st_kep_recv_user_id" value="${sessionInfo.userId}">
		<!-- 세션 ID 매핑 -->
		<input type="hidden" name="GW_NO" id="GW_NO" value="N"> <input type="hidden" name="s_SAVENAME">

		<div id="cont_searchA">
			<table class="cont_t_list01" >
			<caption>리스트</caption>
                <colgroup>
                    <col width="12%" />
                    <col width="21%" />
                    <col width="12%" />
                    <col width="21%" />
                    <col width="12%" />
                    <col width="21%" />
                </colgroup>
                <tbody>
					<tr>
						<th><font color="red"><b>*</b></font>고객사</th>
						<td>
							<input type="text" name="st_buyer_name" id="st_buyer_name" style="width: 55%" value="" readonly onclick="javascript:doPop('buyer_single');"> 
							<input type="hidden" name="st_buyer" id="st_buyer" style="width: 80%" value=""> <a href="javascript:doPop('buyer_single');"><img src="/resources/images/btn_search03.gif"></a> 
							<a href="javascript:kepEraser2('st_buyer','st_buyer_name','st_open_flag');"><img src="/resources/images/btn_eraser2.gif"></a>
							<input type="hidden" name="st_open_flag" id="st_open_flag" style="width: 80%" value="">
						</td>
						<th><font color="red"><b>*</b></font>의뢰자</th>
						<td><input type="text" name="st_btoa_user_name" id="st_btoa_user_name" style="width: 55%" value="" readonly
							onclick="javascript:doPop('user');"> <input type="hidden" name="st_btoa_user_id" id="st_btoa_user_id" style="width: 80%" value="">
							<a href="javascript:doPop('user');"><img src="/resources/images/btn_search03.gif"></a> <a href="javascript:doEraser();"><img
								src="/resources/images/btn_eraser2.gif"></a></td>
						<th>의뢰부서</th>
						<td><input type="hidden" name="st_btoa_user_dept" id="st_btoa_user_dept" style="width: 87%" value=""> <input type="text"
							name="st_btoa_user_dept_name" id="st_btoa_user_dept_name" style="width: 87%" value=""></td>
					</tr>
					<tr>
						<th>견적의뢰일</th>
						<td><input type="text" name="st_btoa_date" id="st_btoa_date" readOnly style="width: 70%; text-align: center;">
							<a href="javascript:kepCalendar('st_btoa_date')"></a></td>
						<th>전화번호</th>
						<td><input type="text" name="st_btoa_user_tel" id="st_btoa_user_tel" style="width: 87%" value=""></td>
						<th>팩스번호</th>
						<td><input type="text" name="st_btoa_user_fax" id="st_btoa_user_fax" style="width: 87%" value=""></td>
					</tr>
				</tbody>
			</table>
		</div>
		※ <span style="color: blue;"><b>C</b></span> : 클릭 행 복사, <span style="color: blue;"><b>D</b></span> : 클릭 행 삭제

		<div class="ib_product" style="border-top: 2px solid #3c639c">
			<script type="text/javascript">
				createIBSheet("mySheet", "", "354px");
			</script>
		</div>
		<!-- 		<div class="paging" id="pageindex"></div> -->

		<div class="btnArea mt05">
			<div class="fl">
				<span class="btn_04 mr04"><a href="javascript:doPop('excelUpLoad');">EXCEL업로드</a></span> 
				<span class="btn_04 mr04"><a href="/resources/excel/work/NEWSOURCING/BuyerNewSourcingSheet.xls">양식다운로드</a></span> 
				<span class="btn_02 mr04"><a href="javascript:addrows();">행추가</a></span>
				<span class="btn_02 mr04"><a href="javascript:checkedDel();">삭제</a></span>
			</div>
			<div class="fr">
				<span class="btn_02"><a href="javascript:doAction('save')">견적의뢰</a></span>
			</div>
		</div>
	</form>

	<!--내용 종료-->
</body>
</html>
