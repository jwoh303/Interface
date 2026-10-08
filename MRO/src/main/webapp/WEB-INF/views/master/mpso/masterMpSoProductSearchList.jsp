<%--
**********************************************
* 메뉴 : 주문관리>재고관리>상품검색
* 화면 : 상품검색
* 기능 : 상품을 조회하고 장바구니에 담아 발주처리 합니다.검색과 장바구니, 2개이상의 UI필요
* 프로그램 ID : PG_06_M_017_00
* 담당자 : 고영일 ( 설계 : 김지현 )
* 착수일 : 2014-08-20
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>

<script src="/resources/js/common.js"></script>
<script>
var mySheet1 = new ibsheetObject();
var mySheet2 = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet1 = {};
	var initsheet2 = {};
	
	mySheet1.SetConfig({ChildPage:1});
	mySheet1.ShowTreeLevel(0,0);
	initsheet1.Cols = [ 
					 { Align:"Left",	Width:227,	Edit : false,	EditLen:100,	Hidden : false, TreeCol:1,	Type:"Text",	Header:"카테고리 목록", LevelSaveName:"TREELEVEL", SaveName:"CATEG_NAME"}
					,{ Align:"Center",	Width:40,	Edit : false,	EditLen:100,	Hidden : true, Type:"Int",	Header:"레벨",	SaveName:"Level"}
					,{ Align:"Center",	Width:40,	Edit : false,	EditLen:100,	Hidden : true, Type:"Text",	Header:"카테고리번호",	SaveName:"STD_CATEG_ID"}
					,{ Align:"Center",	Width:40,	Edit : false,	EditLen:100,	Hidden : true, Type:"Text",	Header:"카테고리타입",	SaveName:"CATEG_TYPE"}
					,{ Align:"Center",	Width:40,	Edit : false,	EditLen:100,	Hidden : true, Type:"Text",	Header:"상위카테고리번호",	SaveName:"PID"}
					,{ Align:"Center",	Width:40,	Edit : false,	EditLen:100,	Hidden : true, Type:"Text",	Header:"트리형위치코드",	SaveName:"CATEG_SYS_CODE"}
					,{ Align:"Center",	Width:40,	Edit : false,	EditLen:100,	Hidden : true, Type:"Text",	Header:"트리레벨",	SaveName:"DEPTH"}
	];
	initsheet2.Cols = [ 
					 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
					,{ Align:"Center",	Width:60,	Edit : true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"공급경로코드",	SaveName:"PROCESS_TYPE"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"공급경로",	SaveName:"INCOME_PATH"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목코드",	SaveName:"STDCATLG_ID"}
					,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"품목명",	SaveName:"DESCRIPTION"}
					,{ Align:"Left",	Width:250,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"규격",	SaveName:"SPECIFICATION"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"제조사코드",	SaveName:"MAKER_CODE,"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"제조사",	SaveName:"MAKER_NAME"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"단위",	SaveName:"UNIT_MEASURE"}
					,{ Align:"Right",	Width:80,	Edit:true,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",	Header:"보충재고량",	SaveName:"COM_STCK_QTY", BackColor:"#FFDAB9"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",	Header:"가용재고량",	SaveName:"AVAIL_QTY"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",	Header:"안전재고",	SaveName:"SAFE_STOCK_QTY"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",	Header:"최대재고",	SaveName:"MAX_STOCK_QTY"}
					,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${priceFormat}",	Header:"매입단가",	SaveName:"LIST_PRICE"}
					,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type : "Float",  Format:"${qtyFormat}",	Header:"최소발주량",	SaveName:"MIN_ORDER_QTY"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"협력사코드",	SaveName:"AGENT"}
					,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사",	SaveName:"AGENT_NAME"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사상태",	SaveName:"AGENT_STATUS"}
					
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"계약서번호",	SaveName:"CONTRACT_NO"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"계약서항번",	SaveName:"CONTRACT_SEQ"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"품목코드2",	SaveName:"BUYER_ITEM_NO"}
	];
	
	IBS_InitSheet(mySheet1, initsheet1,pagingMode);
	IBS_InitSheet(mySheet2, initsheet2,pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet2, "STDCATLG_ID");	//품목코드
	setLinkCol(mySheet2, "AGENT_NAME");	//협력사
	
}
	
var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet2.FindCheckedRow("SELECTED");
		var arrRow     = selectedGrid.split("|");

	// 선택된 항목 유무 체크
	if (str !="searchTree" && str !="searchSuppleOrder" && str !="search" && str !="excelDown" && str !="reload" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
		case "searchTree":	 // 조회
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet1 , "/mpso/getMasterMpSoProductSearchRootTreeList.do" , pagingMode );
			break;
	
		case "search":	 // 조회
			if(isEmpty($("#st_wms_code").val())){
				alert("센터를 선택해 주세요.");
				return;
			}
		
			current_page = -1;
			$("#st_search_type").val("S");
			kepSearch(document.searchCondition,  mySheet2 , "/mpso/getMasterMpSoProductSearchList.do" , pagingMode );
			break;
			
		case "searchSuppleOrder":	 // 조회
			if(isEmpty($("#st_wms_code").val())){
				alert("센터를 선택해 주세요.");
				return;
			}
		
			current_page = -1;
			$("#st_search_type").val("T");
			kepSearch(document.searchCondition,  mySheet2 , "/mpso/getMasterMpSoProductSearchList.do" , pagingMode );
			break;
			
		case "reload":	// 초기화
			kepReload('searchCondition');
			document.forms.searchCondition.reset();
			mySheet1.RemoveAll();
			mySheet2.RemoveAll();
			kepEraser('st_wms_code','st_wms_name');
			break;
			
		case "setCart":	// 장바구니 담기
			if(!checkProduct(arrRow)){ return; }
			
			if(confirm("선택하신 항목에 대한 장바구니 담기(재고보충발주)를 진행 하시겠습니까?  ")){
				kepSave(document.searchCondition ,  mySheet2 , "/mpso/saveMasterMpSoProductSearch.do" , "SELECTED" );
			}
			break;
	}
}

function checkProduct(arrRow){
	var stock_chk	= false;
	
	for(var inx = 0 ; inx < arrRow.length ; inx++){

		if( mySheet2.GetCellValue(arrRow[inx],"PROCESS_TYPE") == "1") {
			stock_chk = true;
		}
		
		if(Number(mySheet2.GetCellValue(arrRow[inx],"COM_STCK_QTY")) <= 0) {
			alert(arrRow[inx] +"번째 행의 보충재고수량을 0이나 음수로 지정 할 수 없습니다.");
			mySheet2.SetSelectRow(arrRow[inx]);
			mySheet2.SetSelectCol("COM_STCK_QTY");
			return false ;
		}
	}
	
	if (stock_chk == true) {
		alert("공급경로가 재고인 품목이 포함되어 있습니다.\n재고보충발주는 대표이사님 품의전결 규정입니다.");
	}
	
	return true;
}

function mySheet1_OnTreeChild(Row){
	var st_std_categ_id = mySheet1.GetCellValue(Row,"STD_CATEG_ID");
	var st_wms_code = $("#st_wms_code").val();
	mySheet1.SetWaitImageVisible(true);
	mySheet1.DoSearchChild(Row, "/mpso/getMasterMpSoProductSearchChildTreeList.do?st_wms_code="+st_wms_code+"&st_std_categ_id="+st_std_categ_id, "", 1);
}
	
// 그리드 표시후 처리	 
function mySheet2_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}
	
// 조회 후처리
function mySheet1_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	
	if (msg != "") {
		alert(msg);
	}
}
function mySheet2_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

   	
	if (msg != "") {
		alert(msg);
	}

	if(current_page==-1){
		makePageIndex2( mySheet2 , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet2 , current_page , document.searchCondition.onepagerow.value);	
	}
	
}
	
// 트랜젝션(저장,삽입등) 후처리
function mySheet2_OnSaveEnd(code, resultFlag) {
	loader_obj("N");

	if(resultFlag == "OK"){
		if(confirm('장바구니에 저장되었습니다\n재고보충발주 화면으로 이동 하시겠습니까?')) {
			var st_search_type = $("#st_search_type").val();
			
			if(st_search_type == "S"){
				doAction('search');
			}else if(st_search_type == "T"){
				doAction('searchSuppleOrder');
			}else{
				kepSearch(document.searchCondition,  mySheet2 , "/mpso/getMasterMpSoProductSearchList.do" , pagingMode );
			}
			
			var st_wms_code = $("#st_wms_code").val();
			var st_wms_name = $("#st_wms_name").val();
			var param = "?st_wms_code="+st_wms_code+"&st_wms_name="+st_wms_name;
			param = encodeURI(param);
		    parent.tab("재고보충발주","/mpso/showMasterMpSoStockSuppleOrder.do" + param);
		}
	}else if(resultFlag == "EXIST"){
		alert("장바구니에 이미 저장되어 있는 품목이 있습니다.");
	}
	
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet2 , "/mpso/getMasterMpSoProductSearchList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "masterMpSoWmsSearchPop": // 물류센터
			openSearchPopup("/mpso/getMasterMpSoWmsSearchPop.do", "?1=1", "500,500,no");
			popupSel = "masterMpSoWmsSearchPop";
			break;
		case "masterMpSoAgntcmpyTypePop": // 공급유형별 협력사 검색
			var st_process_type = $("input[name=st_process_type]:checked").val();
			var st_wms_code = $("#st_wms_code").val();

			if(isEmpty(st_wms_code)){
				alert("센터를 선택해 주세요.");
				return;
			}
			
			openSearchPopup("/mpso/getMasterMpSoAgntcmpyTypePop.do", "?st_wms_code="+st_wms_code+"&st_process_type="+st_process_type, "500,500,no");
			popupSel = "masterMpSoAgntcmpyTypePop";
			break;
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet1.ColSaveName(mySheet1.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'CATEG_NAME') { // 카테고리 목록
		var st_categ_sys_code = mySheet1.GetCellValue(Row, "CATEG_SYS_CODE");
		current_page = -1;
		$("#st_search_type").val("C");
		$("#st_categ_sys_code").val(st_categ_sys_code);
		kepSearch(document.searchCondition,  mySheet2 , "/mpso/getMasterMpSoProductSearchList.do" , pagingMode );
	}
	return;
}

//그리드 셀 변경시 이벤트
function mySheet2_OnChange(Row, Col, Value) {
	var column = mySheet2.ColSaveName(Col);
	grbRow = Row; //현재 Row를 전역변수에 셋팅
	
	if(column == "COM_STCK_QTY"){
		mySheet2.SetCellValue(Row,"SELECTED", "1");
	}
	
}
	
function mySheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet2.ColSaveName(mySheet2.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'STDCATLG_ID') { // 품목코드
		var buyer = $("#st_wms_code").val();
		var buyerItemNo = mySheet2.GetCellValue(Row,"STDCATLG_ID");
		var contractNo = mySheet2.GetCellValue(Row,"CONTRACT_NO");
		var contractSeq = mySheet2.GetCellValue(Row,"CONTRACT_SEQ");
		openSearchPopup("/common/catalogDetailPop.do", "?BUYER="+buyer+"&BUYER_ITEM_NO="+buyerItemNo+"&CONTRACT_NO="+contractNo+"&CONTRACT_SEQ="+contractSeq, "800,290,no");
	}else if(column == 'AGENT_NAME'){
		var agent = mySheet2.GetCellValue(Row,"AGENT");
		openSearchPopup("/common/agentInfoDisplayPop.do", "?st_com_code="+agent, "800,550,no");
	}
	return;
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "masterMpSoWmsSearchPop") {	// 물류센터
		$("#st_wms_code").val(value1);
		$("#st_wms_name").val(value2);
		
		// 카테고리 목록 조회
		doAction("searchTree");
	} else if (popupSel == "masterMpSoAgntcmpyTypePop") {	// 공급유형별 협력사 검색
		$("#st_agent_code").val(value1);
		$("#st_agent_name").val(value2);
	}
	
	grbRow="";	//초기화
}

function kepCenterEraser(){
	kepEraser('st_wms_code','st_wms_name');
	mySheet1.RemoveAll();
	mySheet2.RemoveAll();
}

	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>상품검색</h3>
        	<span class="btn_07 mr04" style="height: 23px;"><a href="javascript:doAction('searchSuppleOrder')">자동 보충발주 검색</a></span>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span>
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition" method = "post" onsubmit="return false" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME" />
			<input type="hidden" id="pageflag" name="pageflag" value="1" />
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_search_type" name="st_search_type" value="" />
			<input type="hidden" id="st_categ_sys_code" name="st_categ_sys_code" value="" />
			
            	<table  class="cont_t_list01" style="width:1024px;">
					<caption>상품검색</caption>
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
							<td><font color="red"><b>*</b></font>물류센터</td>
							<td>
								<input type="text" class="input_type_text" name="st_wms_name" id="st_wms_name" style="width:71%" value="" readonly onclick="javascript:doPop('masterMpSoWmsSearchPop');">
								<input type="hidden" name="st_wms_code" id="st_wms_code" style="width:80%" value="">
								<a href="javascript:doPop('masterMpSoWmsSearchPop');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepCenterEraser('st_wms_code','st_wms_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<td>협력사</td>
							<td>
								<input type="text" class="input_type_text" name="st_agent_name" id="st_agent_name" style="width:71%" value="" readonly onclick="javascript:doPop('masterMpSoAgntcmpyTypePop');">
								<input type="hidden" name="st_agent_code" id="st_agent_code" style="width:80%" value="">
								<a href="javascript:doPop('masterMpSoAgntcmpyTypePop');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>
							<td>공급경로</td>
							<td>
								<input type="radio" name="st_process_type" value="" class="Noborder" checked="checked" /> 전체
								<input type="radio" name="st_process_type" class="Noborder" value="1" /> 재고
								<input type="radio" name="st_process_type" class="Noborder" value="3" /> VMI
							</td>
						</tr>
						<tr> 
							<td>품목코드</td>
							<td>
								<input type="text" class="input_type_text" id="st_item_code" name="st_item_code" style="width:80%;" onkeyup="kepToUpper('st_item_code')" onkeydown="kepEnter()"> 
							</td>
							<td>품목명/규격</td>
							<td>
								<input type="text" class="input_type_text" id="st_description" name="st_description" style="width:80%;" onkeydown="kepEnter()">
							</td>
							<td>재고존재여부</td>
							<td>
								<input type="radio" name="st_isExist" value="" class="Noborder" checked="checked" /> 전체
								<input type="radio" name="st_isExist" value="Y" class="Noborder" /> 재고유
								<input type="radio" name="st_isExist" value="N" class="Noborder" /> 재고무
							</td>
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
  				<table style="border-width: 0px; width: 100%;">
  					<colgroup>
					<col width="250" />
                       <col width="*" />
				</colgroup>
				<tbody>
					<tr>
						<td>
							<div class="ib_product" style="border-top:2px solid #3c639c;">
								<script type="text/javascript">
				  					createIBSheet("mySheet1", "100%", "354px");
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
				</tbody>
			</table>
  		
  			<p class="paging" id="pageindex"></p>
  			
  			<!--버튼영역-->
               <div class="btnArea">
  				<span class="fr">
  					<span class="btn_06 mr04"><a href="javascript:doAction('setCart');">장바구니 담기</a></span>
  				</span>
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
