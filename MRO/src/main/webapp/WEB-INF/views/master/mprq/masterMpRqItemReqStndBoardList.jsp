<%--
**********************************************
* 메뉴 : 운영사 > 견적관리
* 화면 : 신규상품규격의뢰
* 기능 : 고객이 신규상품 규격의뢰 한 목록을 조회하고 규격확인처리
* 프로그램 ID : PG_04_M_001_00
* 담당자 : 김영미 (설계 : 권우재)
* 생성일 : 2014-05-12
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<script src="/resources/js/common.js"></script>
<%
	String searchYn		= CommonUtil.nvl((String)request.getParameter("search_yn"));
	String buyerCode	= CommonUtil.nvl((String)request.getParameter("st_buyer_code"));
	String buyerName	= CommonUtil.nvl((String)request.getParameter("st_buyer_name"));
%>
<title>Insert title here</title>
<script>
	var mySheet = new ibsheetObject();
	var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
	var popupSel = "";
	var grbRow;
	var remarkOn="/resources/images/but_icon01.gif";
	var remarkOff="/resources/images/but_icon02.gif";
	var diskOn = "/resources/images/disk_on.gif";
	var diskOff = "/resources/images/disk_off.gif";
	var unit = KepSheetComboQueryIdData("getUnitMeasureInfo","");
	
	//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
	function kep_onload_view() {         
	
		var initsheet = {};

// 		initsheet.HeaderMode = {			Sort : 1,			ColMove : 1,			ColResize : 1		};
		initsheet.Cols = [ 
			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Width : 60,	Hidden : 1}, 
		    			{Align : "Center",SaveName : "SELECTED",	Header : "",	Type : "DummyCheck",	Width : 60,	EditLen : 50,	Edit : true}, 
		    			{Align : "Center",SaveName : "BUYER",		Header : "고객사", Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
		    			{Align : "Center",SaveName : "RFQ_USER_NAME",		Header : "요청자",	Type : "Text",	Width : 80,	EditLen : 110,	Edit : false},
		    			{Align : "Center",SaveName : "RFQ_USER_ID",		Header : "요청자아이디",	Hidden:true, Type : "Text",	Width : 100, EditLen : 110,	Edit : false,	hidden:1},
		    			{Align : "Center",SaveName : "RAV_NO",		Header : "접수번호",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
		    			{Align : "Center",SaveName : "ITEM_STATUS",		Header : "품목상태",	Type : "Combo",	ComboText:"신규|기등록", ComboCode:"S|K", Width : 70,	EditLen : 110,	Edit : true},
		    			{Align : "Center",SaveName : "BUYER_ITEM_NO",		Header : "품목코드",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
		    			{Align : "Left",SaveName : "DESCRIPTION",		Header : "품목명",	Type : "Text",	Width : 150,	EditLen : 110,	Edit : false},
		    			{Align : "Left",SaveName : "SPECIFICATION",		Header : "규격",	Type : "Text",	Width : 200,	EditLen : 110,	Edit : false},
		    			{Align : "Center",SaveName : "UNIT_MEASURE",		Header : "단위",	Type : "Text",	Width : 70,	EditLen : 110,	Edit : false},
		    			{Align : "Center",SaveName : "MAKER_NAME",		Header : "제조사",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
		    			{Align : "Center",SaveName : "BUYER_REMARK",		Header : "비고",	Hidden:true, Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
		    			
		    			{Align : "Center",SaveName : "KEP_BUYER_ITEM_NO",		Header : "품목코드",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : true,	BackColor:"${optColor}"},
		    			{Align : "Left",SaveName : "KEP_DESCRIPTION",		Header : "품목명",	Type : "Text",	Width : 150,	EditLen : 110,	Edit : true, BackColor:"${optColor}"},
		    			{Align : "Left",SaveName : "KEP_SPECIFICATION",		Header : "규격",	Type : "Text",	Width : 200,	EditLen : 110,	Edit : true, BackColor:"${optColor}"},
		    			{Align : "Center",SaveName : "KEP_UNIT_MEASURE",		Header : "단위",	Type : "Combo", ComboText:unit.ComboText, ComboCode:unit.ComboCode,	Width : 70,	EditLen : 110,	Edit : true, BackColor:"${optColor}"},
		    			{Align : "Center",SaveName : "KEP_MAKER_CODE",		Header : "제조사코드(Hidden)",Hidden:true,	Type : "Text",	Width : 100,	EditLen : 110,	Edit : true},
		    			{Align : "Center",SaveName : "KEP_MAKER_NAME",		Header : "제조사",	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false, BackColor:"${optColor}"},
		    			{Align : "Center",SaveName : "ORIGIN_CODE",		Header : "원산지코드(Hidden)",	Hidden:true,Type : "Text",	Width : 100,	EditLen : 110,	Edit : true},
		    			{Align : "Center",SaveName : "ORIGIN_NAME",		Header : "원산지명(Hidden)",Hidden:true,	Type : "Text",	Width : 100,	EditLen : 110,	Edit : true},
		    			{Align : "Center",SaveName : "KEP_KEP_REMARK_IMG",		Header : "비고",	Type : "Image",	Width : 60,	EditLen : 110,	Edit : true},
		    			{Align : "Center",SaveName : "KEP_KEP_REMARK",		Header : "비고",	Hidden:true, Type : "Text",	Width : 100,	EditLen : 110,	Edit : true},
		    			
		    			{Align : "Center",SaveName : "RAV_SEQ",		Header : "검증차수", Hidden:true,	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
		    			{Align : "Center",SaveName : "STATUS",		Header : "상태", Hidden:true,	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
		    			{Align : "Center",SaveName : "KEP_RAV_SEQ",		Header : "KEP_RAV_SEQ", Hidden:true,	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
		    			{Align : "Center",SaveName : "KEP_ITEM_STATUS",		Header : "KEP_ITEM_STATUS", Hidden:true,	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
		    			{Align : "Center",SaveName : "FEEDBACK_FLAG",		Header : "FEEDBACK_FLAG", Hidden:true,	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
		    			{Align : "Center",SaveName : "CONTRACT_NO",		Header : "CONTRACT_NO", Hidden:true,	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
		    			{Align : "Center",SaveName : "CONTRACT_SEQ",		Header : "CONTRACT_SEQ", Hidden:true,	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
		    			{Align : "Center",SaveName : "KEP_USER_ID",		Header : "KEP_USER_ID", Hidden:true,	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
		    			{Align : "Center",SaveName : "KEP_PHONE_NUMBER",		Header : "KEP_PHONE_NUMBER", Hidden:true,	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
		    			{Align : "Center",SaveName : "IMAGE_KEY",		Header : "IMAGE_KEY", Hidden:true,	Type : "Text",	Width : 100,	EditLen : 110,	Edit : false},
		    			{Align : "Center",SaveName : "IMAGE_KEY_IMG",		Header : "첨부",	Type : "Image",	Width : 60,	EditLen : 110,	Edit : false}
		];
		IBS_InitSheet2(mySheet, initsheet, pagingMode,7);

		mySheet.SetCellBackColor(0,"KEP_BUYER_ITEM_NO","#FFE400");
		mySheet.SetCellBackColor(0,"KEP_DESCRIPTION","#FFE400");
		mySheet.SetCellBackColor(0,"KEP_SPECIFICATION","#FFE400");
		mySheet.SetCellBackColor(0,"KEP_UNIT_MEASURE","#FFE400");
		mySheet.SetCellBackColor(0,"KEP_MAKER_NAME","#FFE400");
		//조회조건 초기값 설정
		kepSetCalender("st_req_from_date");
		kepSetCalender("st_req_to_date");
		$("#st_req_from_date").val(kepToDateAdd("7","M"));
		$("#st_req_to_date").val(kepGetNowTimeStr('YYYYMMDD','/')); 
		
		//비고이미지설정
		mySheet.SetImageList(1, remarkOn);
		mySheet.SetImageList(0, remarkOff);
		//파일첨부이미지설정
		mySheet.SetImageList(2, diskOff);
		mySheet.SetImageList(3, diskOn);
		
		//하이퍼링크 설정
		setLinkCol(mySheet, "BUYER_REMARK_IMG");
		setLinkCol(mySheet, "IMAGE_KEY_IMG");
		setLinkCol(mySheet, "KEP_KEP_REMARK_IMG");
		setLinkCol(mySheet, "KEP_MAKER_NAME");
		
		var searchYn = "<%=searchYn%>";
		
		$("#st_buyer_code").val("<%=buyerCode%>");
		$("#st_buyer_name").val("<%=buyerName%>");
		
		if(searchYn == "Y"){
			doAction("search");
		}
	}
	var st;
	var mt;
	//기능함수
	function doAction(str) {
		st = new Date();
		switch (str) {
		case "search":
			if (kep_dateSearchCheck($("#st_req_from_date").val(),$("#st_req_to_date").val()) == false) return;
			current_page = -1;
			kepSearch(document.searchCondition ,  mySheet , "/mprq/masterMpRqItemReqStndBoard.do" , pagingMode );
			break;
		case "save":

			var selectedGrid = mySheet.FindCheckedRow("SELECTED");
			var arrRow     = selectedGrid.split("|");
			if (mySheet.RowCount() == 0){
				alert("품목이 없습니다.");
			}
			if (selectedGrid.length == 0){
				alert("선택하신 품목이 없습니다.");
				return;
			}
			if (!checkValidation('true')){
				return;
			}
			
			// 시트 각 컬럼의 이름을 S_SAVENAME 객체에 담는다.
			IBS_SaveName(document.searchCondition,mySheet);

			// 조회조건 묶기
			var info = FormQueryStringEnc(document.searchCondition,true);
			if(info){
				// 저장
			 	 mySheet.DoSave("/mprq/saveMasterMpRqItemReqStndBoard.do",info,"SELECTED");
			}

			break;
		case "reload":
// 			mySheet.RemoveAll();
			kepReload('searchCondition');
			$('#st_buyer_code').val("");
			$('#st_btoa_user_id').val("");
			
			mySheet.RemoveAll();
			
			document.getElementById("st_req_from_date").value = kepToDateAdd("7","M");
			document.getElementById("st_req_to_date").value = kepGetNowTimeStr('YYYYMMDD','/'); 
			break;
		}
	}
	//페이지 인덱스 눌렀을 경우 조회
	function pageSearch(param){
		//조회
		current_page = param.page;
		kepSearch(document.searchCondition, mySheet, "/mprq/masterMpRqItemReqStndBoard.do?page="+current_page, pagingMode);
	}
	function checkValidation(msgFlg) {

		var checkRows = mySheet.FindCheckedRow("SELECTED");
		var arrRow = checkRows.split("|");
		var checkedCnt = arrRow.length;

		
		for ( var i = 0; i < checkedCnt; i++) {
			
// 			mySheet.SetCellValue(arrRow[i], "STND_RE_SEQ", i + 1);
			
// 			mySheet.SetCellValue(arrRow[i], "URGNY_CHK", (mySheet.GetCellValue(
// 					arrRow[i], "URGNY_CHK_CHKBOX") == '1') ? 'Y' : 'N');

			if (msgFlg == 'true') {
				if (mySheet.GetCellValue(arrRow[i], "ITEM_STATUS") == 'K' && mySheet.GetCellValue(arrRow[i], "CONTRACT_NO") == "") {
					alert(i+1 +'번째 품목은 기등록 품목 입니다.\n\n품목코드를 확인하시어,\n\n계약서번호를 설정 바랍니다.');
					return false;
					break;
				} else if (mySheet.GetCellValue(arrRow[i], "KEP_MAKER_CODE") == '') {
					alert((i+1) + "번째 품목 제조사를 설정 바랍니다.");
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

		
		
// 		alert("서버 시간:" + ((mt - st) / 1000) + "초" + "\n데이터 로딩 시간:" + (new Date() - mt) / 1000 + "초" + "\n총 시간:"
//			+ (new Date() - st) / 1000 + "초");
		if (msg != "") {
			alert(msg);
		}
		
		if(current_page==-1){
			makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
		}else{
			makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
		}
		
	}
	function mySheet_OnSaveEnd(code, Message) {
		if(code =="1"){
			alert("저장(FeedBack)에 성공하였습니다.");
		} else {
			alert(Message);
		}
		javaScript:doAction('search');
	}
	//팝업함수호출
	function doPop(str) {
		
		switch (str) {
		case "buyer_single":
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
			popupSel = "buyer_single";
			break;
		case "user":
			if($("#st_buyer_code").val() == "") {
				alert("고객사를 선택해 주십시요.");
				break;
			}
			openSearchPopup("/common/misUserSelectAllPop.do", '?open=Y&com_code='+$("#st_buyer_code").val(), "500,500,no");
			popupSel = "user";
			break;
		}
	}
	//콜백함수(파일명은 모두 동일)
   function setPopupReturn(code, text, value3, value4, value5, value6, value7, value8, value9){
		if (popupSel == "buyer_single"){ // 고객사
			$("#st_buyer_code").val(code);
			$("#st_buyer_name").val(text);
		} else if (popupSel == "user"){ // 사용자
			$("#st_btoa_user_id").val(code);
			$("#st_btoa_user_name").val(text);
		} else if (popupSel == "maker"){ // 제조사
			mySheet.SetCellValue(grbRow, 'KEP_MAKER_CODE', code);
			mySheet.SetCellValue(grbRow, 'KEP_MAKER_NAME', text);
			mySheet.SetCellValue(grbRow, 'ORIGIN_CODE', value3);
			mySheet.SetCellValue(grbRow, 'ORIGIN_NAME', value4);
		}else if(popupSel == "remark") {	//고객사 비고
 			mySheet.SetCellValue(grbRow, 'KEP_KEP_REMARK', text);
 			mySheet.SetCellValue(grbRow, 'KEP_KEP_REMARK_IMG', (text!="")? remarkOn : remarkOff);
		}else if(popupSel == "constractNo") {	//계약서조회
 			mySheet.SetCellValue(grbRow, 'CONTRACT_NO', code);
 			mySheet.SetCellValue(grbRow, 'CONTRACT_SEQ', text);
 			mySheet.SetCellValue(grbRow, 'KEP_DESCRIPTION', value3);
 			mySheet.SetCellValue(grbRow, 'KEP_SPECIFICATION', value4);
 			mySheet.SetCellValue(grbRow, 'KEP_UNIT_MEASURE', value5);
 			mySheet.SetCellValue(grbRow, 'KEP_MAKER_CODE', value6);
 			mySheet.SetCellValue(grbRow, 'KEP_MAKER_NAME', value7);
 			mySheet.SetCellValue(grbRow, 'ORIGIN_CODE', value8);
 			mySheet.SetCellValue(grbRow, 'ORIGIN_NAME', value9);
		}
		grbRow = ""; //초기화
   }
   //그리드 셀클릭 이벤트
	function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		if ( Row  < 1) return;  
		var column = mySheet.ColSaveName(Col);
//	 		if (column == "SELECTED") { // 선택
//	 			var selected = mySheet.GetCellValue(Row,"SELECTED");
//	 		}
		grbRow = Row; //현재 Row를 전역변수에 셋팅
		
		if (column == 'KEP_MAKER_NAME') { // 제조사
			openSearchPopup("/common/agentRegMakerCodePop.do", "", "500,500,no");
			popupSel = "maker";
		} else if (column == "KEP_KEP_REMARK_IMG" ){ // 비고
			popupSel = "remark";
			var btoaRemark = mySheet.GetCellValue(Row, "BUYER_REMARK");
			var atobRemark = mySheet.GetCellValue(Row, "KEP_KEP_REMARK");
			openSearchPopup("/common/remarkPop.do", '?st_btoa_remark='+btoaRemark+'&st_atob_remark='+atobRemark, "500,310,no");
			
		} else if(column == "IMAGE_KEY_IMG"){ // 파일첨부
			popupSel = "fileUpload";
			var type="RFQ";
			var viewType="R"; // 보기전용
			var image_key=mySheet.GetCellValue(Row, "IMAGE_KEY");
			if (image_key != "") {
				openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+image_key+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부
			}

		} else if(column == "ITEM_STATUS"){ // 품목상태
			var itemStatus = mySheet.GetCellValue(Row,"ITEM_STATUS");
			var constractNo = mySheet.GetCellValue(Row,"CONTRACT_NO");
			var st_buyer = mySheet.GetCellValue(Row,"BUYER");
			var st_buyer_item_no = mySheet.GetCellValue(Row,"KEP_BUYER_ITEM_NO");
			
			if (itemStatus == "K" && constractNo != ""){
				openSearchPopup('/common/mprq/masterMpRqContractLisPop.do','?st_buyer='+st_buyer+'&st_buyer_item_no='+st_buyer_item_no,'800,300,no');
				popupSel = "constractNo";
			}
		} else if(column == "KEP_BUYER_ITEM_NO"){ // 품목상태
			var itemStatus = mySheet.GetCellValue(Row,"ITEM_STATUS");
			var st_buyer = mySheet.GetCellValue(Row,"BUYER");
			var st_buyer_item_no = mySheet.GetCellValue(Row,"KEP_BUYER_ITEM_NO");
			
			if (itemStatus == "K"){
				openSearchPopup('/common/mprq/masterMpRqContractLisPop.do','?st_buyer='+st_buyer+'&st_buyer_item_no='+st_buyer_item_no,'800,300,no');
				popupSel = "constractNo";
			}
		}
   }
   
	// 그리드 셀 변경시 이벤트
	function mySheet_OnChange(Row, Col, Value) {
		var column = mySheet.ColSaveName(Col);
		grbRow = Row; //현재 Row를 전역변수에 셋팅
		
		if (column == 'ITEM_STATUS') {
			var itemStatus = mySheet.GetCellValue(Row,"ITEM_STATUS");
			var st_buyer = mySheet.GetCellValue(Row,"BUYER");
			var st_buyer_item_no = mySheet.GetCellValue(Row,"KEP_BUYER_ITEM_NO");
			
			if (itemStatus == "K"){
				openSearchPopup('/common/mprq/masterMpRqContractLisPop.do','?st_buyer='+st_buyer+'&st_buyer_item_no='+st_buyer_item_no,'800,300,no');
				popupSel = "constractNo";
			}
			
		}
	};
</script>
<title>IBSheet Sample</title>
</head>
<body onload="kep_onload_view()">
	<!--내용 시작-->	
			<!--버튼영역-->
			<div id="searchBtnA"  >
        		<h3>신규상품 규격문의(모바일)</h3>
				<span class="btn_search"><a href="javaScript:doAction('search');">조회</a></span>
				<span class="btn_reset"><a href="javaScript:doAction('reload');">초기화</a></span>
       		</div>
			<form name="searchCondition" id="searchCondition">
				<input type="hidden" name="s_SAVENAME">
				<input type="hidden" id="pageflag" name="pageflag"  value="1">
				<div id="cont_searchA">
					<table class="cont_t_list01" >
						<caption>신규상품규격의뢰</caption>
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
								<th>의뢰일</th>
								<td colspan="3">
									<input type="text" name="st_req_from_date" id="st_req_from_date" readOnly style="width:20%; text-align:center;" >
										<a href="javascript:kepCalendar('st_req_from_date')"></a>
									-
									<input type="text" name="st_req_to_date" id="st_req_to_date" readOnly style="width:20%; text-align:center;" >
										<a href="javascript:kepCalendar('st_req_to_date')"></a>
										&nbsp;&nbsp;
									<span class="btn_month"><a href="javascript:kepMonth('st_req_from_date','st_req_to_date','1')">1개월</a></span> 
									<span class="btn_month"><a href="javascript:kepMonth('st_req_from_date','st_req_to_date','2')">2개월</a></span> 
									<span class="btn_month"><a href="javascript:kepMonth('st_req_from_date','st_req_to_date','3')">3개월</a></span>
								</td>
								<th>접수번호</th>
								<td>
									<input type="text" name="st_ser_rav_no" id="st_ser_rav_no" style="width:87%" value="" onKeyUp="kepToUpper('st_ser_rav_no')" onkeydown="kepEnter()" />
								</td>
							</tr> 
							 
							<tr>
								<th>고객사</th>
								<td>
									<input type="text" name="st_buyer_name" id="st_buyer_name" style="width:55%;" value="" readonly onclick="javascript:doPop('buyer_single');">
									<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:100px;" value="">
									<a href="javascript:doPop('buyer_single');"><img src="/resources/images/btn_search03.gif"></a>
									<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
								</td>
								<th>요청자</th>
								<td>
									<input type="text" name="st_btoa_user_name" id="st_btoa_user_name"  style="width:55%" value="" readonly onclick="javascript:doPop('user');">
									<input type="hidden" name="st_btoa_user_id" id="st_btoa_user_id" style="width:100" value="">
									<a href="javascript:doPop('user');"><img src="/resources/images/btn_search03.gif"></a>
									<a href="javascript:kepEraser('st_btoa_user_id','st_btoa_user_name');"><img src="/resources/images/btn_eraser2.gif"></a>
								</td>
								<th>품목명</th>
								<td>
									<input type="text" name="st_se_description" id="st_se_description" style="width:87%" value="" onkeydown="kepEnter()" />
								</td>	
							</tr>
						</tbody>
					</table>
				</div>
				<span class="fl">
					<img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
	              	<label for="b_no02" class="hidden">정렬개수선택</label>
					<select id="onepagerow" name="onepagerow" style="width: 70px;" >
						<option value="10" selected>10건</option>
						<option value="20">20건</option>
						<option value="30">30건</option>
						<option value="40">40건</option>
						<option value="50">50건</option>
					</select>
				</span>
				<br>
				
				<!-- grid -->
				<div style="border-top:2px solid #3c639c">
					<script type="text/javascript">
						createIBSheet("mySheet", "", "354px");
					</script>
				</div>
				<div class="paging" id="pageindex"></div>
				
				<!--버튼영역-->
	             <p class="btnArea"> 
					<span class="btn_02"><a href="javascript:doAction('save')">FeedBack</a></span>
				</p>
			</form>
	<!--내용 종료-->	       
</body>
</html>
