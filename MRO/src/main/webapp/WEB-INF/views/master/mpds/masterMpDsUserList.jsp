<%--
**********************************************
* 메뉴 : 운영사 > 도안관리
* 화면 : 도안관리사용자 관리
* 기능 : 도안관리 사용자를 관리
* 프로그램 ID : PG_07_M_015_00
* 담당자 : 손상민 ( 설계 : 김지현 )
* 생성일 : 2014-05-11
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>

<script src="/resources/js/common.js"></script>
<title>Insert title here</title>
<script>
	var mySheet = new ibsheetObject();
	var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
	var popupSel = "";
	var grbRow = "";
	var item_code="";
	var remarkOn="/resources/images/but_icon01.gif";
	var remarkOff="/resources/images/but_icon02.gif";
	
	//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
	function kep_onload_view() {
		//콤보데이터 셋팅	
		kepAjaxCommonQueryIdSearchCombo('st_cnfrm_step','getCnfrmStepCombo','PK02','ALL');
		var cnfrmStep = KepSheetComboQueryIdData("getCnfrmStepCombo","", $("#st_pkg_gubun").val());
		
		var initsheet = {};

		initsheet.HeaderMode = {			Sort : 0,			ColMove : 1,			ColResize : 1		};
		initsheet.Cols = [ 
			{Align : "Center",SaveName : "sStatus",	Header : "상태",	Type : "Status",	Sort:0, Width : 60,	Hidden : 0}, 
  			{Align : "Center",SaveName : "SELECTED",	Header : "",	Type : "DummyCheck",	Width : 50,	EditLen : 50,	Edit : true}, 
  			{Align : "Center",SaveName : "PKG_CODE",		Header : "도안구분",	Type : "Combo",	ComboText:"작물보호|종자", 		ComboCode:"PKG1|PKG2",		Width : 100,	EditLen : 100,	Edit : true,	hidden:0},
  			{Align : "Center",SaveName : "CNFRM_STEP_CODE",		Header : "확인단계",	Type : "Combo", ComboText:cnfrmStep.ComboText, 	ComboCode:cnfrmStep.ComboCode,	Width : 150,	EditLen : 100,	Edit : true,	hidden:0},
  			{Align : "Left",SaveName : "COM_NAME",		Header : "고객사명",	Type : "Text",	Width : 200,	EditLen : 100,	Edit : false,	hidden:0, BackColor:"${optColor}"},
  			{Align : "Center",SaveName : "COM_CODE",		Header : "고객사코드",	Type : "Text",	Width : 150,	EditLen : 100,	Edit : false,	hidden:0, BackColor:"${optColor}"},
  			{Align : "Center",SaveName : "CNFRM_USER_NM",		Header : "승인권한자명",	Type : "Text",	Width : 100,	EditLen : 100,	Edit : false,	hidden:0, BackColor:"${optColor}"},
  			{Align : "Left",SaveName : "CNFRM_USER_ID",		Header : "승인권한자ID",	Type : "Text",	Width : 120,	EditLen : 100,	Edit : false,	hidden:0, BackColor:"${optColor}"},
  			{Align : "Center",SaveName : "DFND_COL1_IMG",		Header : "관리구분",	Type : "Image",	Width : 100,	EditLen : 100,	Edit : false,	hidden:0},
  			{Align : "Center",SaveName : "DFND_COL1",		Header : "관리구분코드",	Type : "Text",	Width : 100,	EditLen : 100,	Edit : false,	hidden:1, ToolTip:1},
  			{Align : "Center",SaveName : "DFND_NAME",		Header : "관리구분명",	Type : "Text",	Width : 100,	EditLen : 100,	Edit : false,	hidden:0, ToolTip:1},
  			{Align : "Center",SaveName : "DEL_YN",		Header : "삭제",	Type : "Combo",	ComboText:"Y|N", Width : 100,	EditLen : 100,	Edit : true,	hidden:0},
  			{Align : "Center",SaveName : "USER_SEQ",		Header : "순번",	Type : "Text",	Width : 100,	EditLen : 100,	Edit : true,	Hidden:1},
  			{Align : "Center",SaveName : "ADD_DATE",		Header : "등록일",	Type : "Text",	Width : 100,	EditLen : 100,	Edit : true,	Hidden:1},
  			{Align : "Center",SaveName : "ADD_TIME",		Header : "등록시간",	Type : "Text",	Width : 100,	EditLen : 100,	Edit : true,	Hidden:1},
  			{Align : "Center",SaveName : "ADD_USER_ID",		Header : "등록자_사용자ID",	Type : "Text",	Width : 100,	EditLen : 100,	Edit : true,	Hidden:1},
  			{Align : "Center",SaveName : "CHANGE_DATE",		Header : "수정자",	Type : "Text",	Width : 100,	EditLen : 100,	Edit : true,	Hidden:1},
  			{Align : "Center",SaveName : "CHANGE_TIME",		Header : "수정자시간",	Type : "Text",	Width : 100,	EditLen : 100,	Edit : true,	Hidden:1},
  			{Align : "Center",SaveName : "CHANGE_USER_ID",		Header : "수정자_사용자ID",	Type : "Text",	Width : 100,	EditLen : 100,	Edit : true,	Hidden:1}
  			
		];
		IBS_InitSheet(mySheet, initsheet, pagingMode);
		
		//비고이미지설정
		mySheet.SetImageList(1, remarkOn);
		mySheet.SetImageList(0, remarkOff);

		//하이퍼링크 설정
		setLinkCol(mySheet, "DFND_COL1_IMG");
		setLinkCol(mySheet, "COM_NAME");
		setLinkCol(mySheet, "COM_CODE");
		setLinkCol(mySheet, "CNFRM_USER_NM");
		setLinkCol(mySheet, "CNFRM_USER_ID");
		
		$("#st_del_yn").val('N');//삭제여부
	}
	var st;
	var mt;
	//기능함수
	function doAction(str) {
		st = new Date();
		var selectedGrid = mySheet.FindCheckedRow("SELECTED");
		var arrRow     = selectedGrid.split("|");

		// 선택된 항목 유무 체크
		if (str =="save" && selectedGrid.length == 0) {
			alert("선택된 항목이 없습니다.");
			return;
		}
		
		switch (str) {
		case "search":	 // 조회
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mpds/getMasterMpDsUserList.do" , pagingMode );
			break;
		case "save":
			
	 		if(!confirm("저장 하시겠습니까?"))
	 			return;
			// 시트 각 컬럼의 이름을 S_SAVENAME 객체에 담는다.
			IBS_SaveName(document.searchCondition,mySheet);

			// 조회조건 묶기
			kepSave(document.searchCondition ,  mySheet , "/mpds/saveMasterMpDsUser.do" );
			break;
			
		case "reload":
			kepReload('searchCondition');
			$("#st_del_yn").val('N');
			mySheet.RemoveAll();
			break;
		}
	}
	
	//도안구분 변경시
	function comboOnchange(){
		var search = kepSelectOptionVal('st_pkg_gubun');
		kepAjaxCommonQueryIdSearchCombo('st_cnfrm_step','getCnfrmStepCombo',search,'ALL');
	}
	
	
	function checkValidation(msgFlg) {

		var checkRows = mySheet.FindCheckedRow("SELECTED");
		var arrRow = checkRows.split("|");
		var checkedCnt = arrRow.length;

		
		for ( var i = 0; i < checkedCnt; i++) {
			
			if (msgFlg == 'true') {
				if (mySheet.GetCellValue(arrRow[i], "ITEM_STATUS") == 'K' && mySheet.GetCellValue(arrRow[i], "CONTRACT_NO")) {
					alert(i+1 +'번째 상품은 기등록 상품 입니다.\n\n품목코드를 확인하시어,\n\n계약서번호를 설정 바랍니다.');
					return false;
					break;
				} else if (mySheet.GetCellValue(arrRow[i], "KEP_MAKER_CODE") == '') {
					alert((i+1) + "번째 상품 제조사를 설정 바랍니다.");
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

		var totRow = mySheet.RowCount();
		if( totRow<= 0) return;

		if (msg != "") {
			alert(msg);
		}
		var cnfrmStepGrid = KepSheetComboQueryIdData("getCnfrmStepCombo","", $("#st_pkg_gubun").val());	
		mySheet.SetColProperty("CNFRM_STEP_CODE", {Type : "Combo", ComboText:cnfrmStepGrid.ComboText, 	ComboCode:cnfrmStepGrid.ComboCode});
			
	}
	

	
	function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
		if (code > 0){
			alert("저장 하였습니다.");
			//저장 성공시 재조회
			doAction('search');
			return;
		} else {
			alert("저장에 실패하였습니다.\n\n\관리자에게 문의하여 주시길 바랍니다.");
			return;
		}
	}
	// TABLE의 ROW 데이타 생성
	function addrows() {
		if( mySheet.RowCount() < 1){
			alert('먼저 조회를 실행해 주십시오.'); return;
		}
		  
		var rows = mySheet.DataInsert(-1);
		mySheet.SetCellValue(rows, 'PKG_CODE', ($("#st_pkg_gubun").val() =='PK02')?'PKG1':'PKG2');//도안구분
		mySheet.SetCellValue(rows, 'CNFRM_STEP_CODE', $("#st_cnfrm_step").val());//확인단계
		mySheet.SetCellValue(rows, 'DFND_COL1_IMG', remarkOff);
		mySheet.SetCellValue(rows, 'DEL_YN', 'N');
	}
	
	// 체크박스에서 선택된 ROW를 한꺼번에 삭제 (단, 모든 데이타를 한꺼번에 삭제할수는 없다.)
	// 재귀함수
	function checkedDel() {
		var selectedGrid = mySheet.FindCheckedRow("SELECTED");

		if (mySheet.RowCount() == 0){
			alert("행이 없습니다.");
		}
		
		if (selectedGrid.length == 0){
			alert("선택하신 행이 없습니다.");
			return;
		}
		
		if (!confirm("선택되어 있는 행은 모두 삭제 됩니다.\n삭제하시겠습니까?")) {
			return;
		}
	
	    var rows=  mySheet.RowCount();
	  
		while (rows >= 0) {
			var chkedYn = mySheet.GetCellValue(rows,"SELECTED");
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
		popupSel = str;
		
		switch (str) {
		case "icomcmpyPop":
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
			break;
		case "user":
			if($("#st_buyer").val() == "") {
				alert("고객사를 선택해 주십시요.");
				return;
			}
			openSearchPopup('/common/misUserSelectAllPop.do','?open=Y&com_code='+$("#st_buyer").val(), '500,500,no');
			break;
		}
	}
	
	//그리드 셀클릭 이벤트
	function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		if ( Row  < 1) return;
		
		var column = mySheet.ColSaveName(Col);
		grbRow = Row; //현재 Row를 전역변수에 셋팅
		
		if (column == 'COM_NAME' || column == 'COM_CODE') { // 고객사
			popupSel = "icomcmpyPop2";
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
			
		} else	if (column == 'CNFRM_USER_NM' || column == 'CNFRM_USER_ID') { // 사용자
			popupSel = "user2";
			var com_code = mySheet.GetCellValue(Row, "COM_CODE");
			if(com_code == "") {
				alert("고객사를 선택해 주십시요.");
				return;
			}
			
			openSearchPopup('/common/misUserSelectAllPop.do','?open=Y&com_code='+com_code, '500,500,no');
			
		} else if (column == "DFND_COL1_IMG" ){
			
			if($("#st_pkg_gubun").val() == 'PK03' ){
				var cnfrm_step_code = mySheet.GetCellValue(Row, "CNFRM_STEP_CODE");
				
				if(cnfrm_step_code == 'P002'){ // 작물담당
					popupSel = "masterMpDsSeedKindMultiPop";
					item_code = mySheet.GetCellValue(Row, "DFND_COL1");
					openSearchPopup('/mpds/showMasterMpDsSeedKindMultiPop.do','?st_item_code='+item_code,'500,330,no');
				
				}else if(cnfrm_step_code == 'P005'){ // 영업관리
					popupSel = "masterMpDsSeedProductKindPop";
					item_code = mySheet.GetCellValue(Row, "DFND_COL1");
					openSearchPopup('/mpds/showMasterMpDsSeedProductKindPop.do','?st_product_flag='+item_code,'400,210,no');
					
				}
			}			
			
		} else if(column == "DEL"){ // 삭제
			mySheet.RowDelete();
			//순번 재배열
			mySheet.ReNumberSeq();
		}
	}

	// 그리드 셀 변경시 이벤트
	function mySheet_OnChange(Row, Col, Value) {
		var column = mySheet.ColSaveName(Col);
		grbRow = Row; //현재 Row를 전역변수에 셋팅
		
		if (column == 'PKG_CODE') {
			var pkgCode =mySheet.GetCellValue(Row,"PKG_CODE");
			var cnfrmStepGrid = "";
			if(pkgCode == 'PKG1'){
				cnfrmStepGrid = KepSheetComboQueryIdData("getCnfrmStepCombo","", "PK02");	
			}else{
				cnfrmStepGrid = KepSheetComboQueryIdData("getCnfrmStepCombo","", "PK03");
			}
			mySheet.InitCellProperty(Row,"CNFRM_STEP_CODE", {Type : "Combo", ComboText:cnfrmStepGrid.ComboText, 	ComboCode:cnfrmStepGrid.ComboCode});
		}
	};
	
	
	//콜백함수(파일명은 모두 동일)
   function setPopupReturn(code, text, value3, value4, value5, value6, value7, value8){
		if (popupSel == "icomcmpyPop"){
			$("#st_buyer").val(code);
			$("#st_buyer_name").val(text);
			
		}else if (popupSel == "icomcmpyPop2"){
			mySheet.SetCellValue(grbRow, 'COM_CODE', code);
			mySheet.SetCellValue(grbRow, 'COM_NAME', text);
			
		}else if (popupSel == "user"){ 
			$("#st_user_id").val(code);
			$("#st_user_name").val(text);

		}else if (popupSel == "user2"){
			mySheet.SetCellValue(grbRow, 'CNFRM_USER_ID', code);
			mySheet.SetCellValue(grbRow, 'CNFRM_USER_NM', text);
			/*	사용자 등록 시 데이터그리드에서 조회된 사용자에 대하여 체크로직 불필요
			var totRow = mySheet.RowCount();
			var existUser = 0;
			for(var idx=0; idx<totRow; idx++){
				var userId = mySheet.GetCellValue(idx, "CNFRM_USER_ID");
				if(userId == code ){
					existUser = 1;
				}
			}
			if(existUser == 0){
				
			}else{
				alert("기등록 사용자입니다.");
			}
*/			
		}else if(popupSel == "masterMpDsSeedKindMultiPop" || popupSel == "masterMpDsSeedProductKindPop") {	// 종자구분
 			mySheet.SetCellValue(grbRow, 'DFND_COL1', code);
 			mySheet.SetCellValue(grbRow, 'DFND_COL1_IMG', (code!="")? remarkOn : remarkOff);
 			mySheet.SetCellValue(grbRow, 'sStatus', (code!=item_code)? "U" : "R");
 			
		}
	}



	function doEraser(){
		$("#st_user_id").val("");
		$("#st_user_name").val("");
		$("#st_buyer").val("");
		$("#st_buyer_name").val("");
	}
</script>
<title>KOREA e-Platform</title>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->	
		<!--버튼영역-->
	<div id="searchBtnA"  >
		<h3>도안관리 사용자관리</h3>
       	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
	    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
	</div>        	
	<form name="searchCondition" id="searchCondition">
		<input type="hidden" name="st_kep_user_id" id="st_kep_user_id"	value="${sessionInfo.userId}">
		<!-- 세션 ID 매핑 -->
		<input type="hidden" name="GW_NO" id="GW_NO" value="N">
		<input type="hidden" name="s_SAVENAME">
		<input type="hidden" name="onepagerow" id="onepagerow" value="20">

		<div id="cont_searchA">	
			<table  class="cont_t_list01" >
				<caption>농약포장재</caption>
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
					<th>도안구분</th>
			      	<td >
			      		<select  id="st_pkg_gubun"  name="st_pkg_gubun" onchange="comboOnchange();" >
			              <option value="PK02"  selected>작물보호</option>
			              <option value="PK03" >종자</option>
			            </select>
			        </td>
					<th>확인단계</th>
					<td>
						<select   name="st_cnfrm_step" id="st_cnfrm_step" ></select>
					</td>
					<th></th>
					<td></td>
				</tr>
				<tr> 
					<th>고객사</th>
					<td>
						<input type="text" name="st_buyer_name" id="st_buyer_name" style="width:67%" value="" readonly onclick="javascript:doPop('icomcmpyPop');">
						<input type="hidden" name="st_buyer" id="st_buyer" style="width:80%" value="">
						<a href="javascript:doPop('icomcmpyPop');"><img src="/resources/images/btn_search03.gif"></a>
						<a href="javascript:kepEraser('st_buyer','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
					</td>
					<th>사용자</th>
					<td>
						<input type="text" name="st_user_name" id="st_user_name" style="width:67%" value="" readonly onclick="javascript:doPop('user');">
						<input type="hidden" name="st_user_id" id="st_user_id" style="width:80%" value="">
						<a href="javascript:doPop('user');"><img src="/resources/images/btn_search03.gif"></a> 
						<a href="javascript:doEraser();"><img src="/resources/images/btn_eraser2.gif"></a> 
					</td>
					<th>삭제여부</th>
					<td>
			      		<select   name="st_del_yn"  id="st_del_yn" >
			              <option value="" >전체</option>
			              <option value="Y" >삭제</option>
			              <option value="N" >활성</option>
			            </select>
					</td>
				</tr>
				</tbody>
			</table>
		</div>
	</form>
	
		<div class="ib_product"  style="border-top:2px solid #3c639c">
			<script type="text/javascript">
				createIBSheet("mySheet", "", "354px");
			</script>
		</div>
		<div class="paging" id="pageindex"></div>
		
        <div class="btnArea mt05">
            <div class="fr">
				<span class="btn_02 mr04"><a href="javascript:addrows();">행추가</a></span>
                <span class="btn_02"><a href="javascript:doAction('save')">저장</a></span>
            </div>
        </div>
	
<!--내용 종료-->	       
</body>
</html>
