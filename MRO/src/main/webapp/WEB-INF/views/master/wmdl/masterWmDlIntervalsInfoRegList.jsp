<%--
**********************************************
* 메뉴 : 배송>배차관리>배차정보등록
* 화면 : 배차정보등록
* 기능 : * 차량기본정보 (차량번호/기사/배송지역 등) - 추가
* 프로그램 ID : PG_08_M_018_00
* 담당자 : 김지혜 ( 설계 : 김상근 )
* 착수일 : 2014-7-21
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="java.util.HashMap"%> 
<%@ page import="java.util.Map"%>
<%
String buyer = "";
String userid = "";
if (_sessionInfo != null){
	buyer =  CommonUtil.nvl((String)_sessionInfo.getComCode()); 	
	userid =  CommonUtil.nvl((String)_sessionInfo.getUserId());  		
} 


String st_warehouse_code = CommonUtil.nvl((String) request.getParameter("st_po_user_id"),""); 
String whAdmin = _sessionInfo.getWhAdmin();
%> 
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
					,{Align : "Center",SaveName : "SELECTED",	Header : "",	Type : "DummyCheck",	Width : 50,	EditLen : 50,	Edit : true}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:20,	Hidden:false,	Type:"Text",	Header:"*차량번호",	SaveName:"CAR_NO", BackColor:"${notnullColor}"}
					,{ Align:"Left",	Width:100,	Edit:true,	EditLen:20,	Hidden:false,	Type:"Text",	Header:"*기사명",	SaveName:"CAR_PERSON_NAME", BackColor:"${notnullColor}"}
					,{ Align:"Center",	Width:100,	Edit:true,	EditLen:20,	Hidden:false,	Type:"Text",	Header:"*연락처",	SaveName:"CAR_PERSON_TEL", BackColor:"${notnullColor}"}
					,{ Align:"Right",	Width:100,	Edit:true,	EditLen:20,	Hidden:false,	Type:"Text",	Header:"톤급",	SaveName:"TON",BackColor:"${optColor}"}
					,{ Align:"Left",	Width:100,	Edit:true,	EditLen:50,	Hidden:false,	Type:"Text",	Header:"소속사",	SaveName:"AFFILIATED_CMPY",BackColor:"${optColor}"}
					,{ Align:"Center",	Width:100,	Edit:true,	EditLen:8,	Hidden:false,	Type:"Date",Format:"Ymd",	Header:"차량등록일",	SaveName:"REGISTRATION_DATE",BackColor:"${optColor}"}
					,{ Align:"Left",	Width:100,	Edit:true,	EditLen:50,	Hidden:false,	Type:"Text",	Header:"지역",	SaveName:"AREA",BackColor:"${optColor}"}
					,{ Align:"Left",	Width:150,	Edit:false,	EditLen:50,	Hidden:false,	Type:"Text",	Header:"물류센터",	SaveName:"WAREHOUSE_TEXT"}
					,{ Align:"Center",	Width:100,	Edit:true,	EditLen:8,	Hidden:false,	Type:"Date",Format:"Ymd",Header:"생년월일",	SaveName:"BIRTH_DATE",BackColor:"${optColor}"}
					,{ Align:"Left",	Width:100,	Edit:true,	EditLen:50,	Hidden:false,	Type:"Text",	Header:"운송사",	SaveName:"TRANSPORT_CMPY",BackColor:"${optColor}"}
					,{ Align:"Left",	Width:100,	Edit:true,	EditLen:50,	Hidden:true,	Type:"Text",	Header:"",	SaveName:"TRANSPORT_CMPY"}
					,{ Align:"Left",	Width:100,	Edit:true,	EditLen:50,	Hidden:true,	Type:"Text",	Header:"",	SaveName:"SAVE_FLAG"}
					,{ Align:"Left",	Width:100,	Edit:true,	EditLen:50,	Hidden:true,	Type:"Text",	Header:"",	SaveName:"CAR_ID"}
	];
	
	IBS_InitSheet2(mySheet, initsheet,pagingMode,5);

	//비고이미지설정
	mySheet.SetImageList(1, remarkOn);
	mySheet.SetImageList(0, remarkOff);

	//콤보데이터 셋팅		

	//하이퍼링크 설정
	setLinkCol(mySheet, "BTOA_USER_NAME");	//요청자
	setLinkCol(mySheet, "BUYER_ITEM_NO");	//품목코드
	setLinkCol(mySheet, "QUOTATION_NO");	//견적번호
	setLinkCol(mySheet, "AGENT_NAME");	//협력사
	setLinkCol(mySheet, "ATOB_REMARK_IMG");
	setLinkCol(mySheet, "ATOS_REMARK_IMG");
	setLinkCol(mySheet, "REJECT_REMARK_IMG");
	setLinkCol(mySheet, "CANCEL_REMARK_IMG");
	
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
}
	
	
var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
		var arrRow     = selectedGrid.split("|");

	// 선택된 항목 유무 체크
	if (str !="search" && str !="excelDown" && str !="reload" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
	case "search":	 // 조회
		current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/wmdl/getMasterWmDlIntervalsInfoRegList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		mySheet.RemoveAll();
		$("#st_from_date").val( kepToMonthAdd("1","M"));
		$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
		break;

	case "save": // 저장
		if (!confirm('선택한 항목을 저장 하시겠습니까?'))
			return;
		var selectedGrid = mySheet.FindCheckedRow("SELECTED");
		var arrRow     = selectedGrid.split("|");
 	 	for(var i = 0 ; i <arrRow.length; i++){
 	 		if(mySheet.GetCellValue(arrRow[i],'CAR_NO') == ""){
 	 			alert('차량번호를 입력하세요');
 	 			mySheet.SelectCell(arrRow[i], 'CAR_NO', 1);
 	 			return;
 	 		}
 	 		if(mySheet.GetCellValue(arrRow[i],'CAR_PERSON_NAME') == ""){
 	 			alert('기사명을 입력하세요');
 	 			mySheet.SelectCell(arrRow[i], 'CAR_PERSON_NAME', 1);
 	 			return;
 	 		}
 	 		if(mySheet.GetCellValue(arrRow[i],'CAR_PERSON_TEL') == ""){
 	 			alert('연락처를 입력하세요');
 	 			mySheet.SelectCell(arrRow[i], 'CAR_PERSON_TEL', 1);
 	 			return;
 	 		}
 	 	}
		kepSave(document.searchCondition ,  mySheet , "/wmdl/saveMasterWmDlIntervalsInfoRegList.do" , "SELECTED" );
		break;
		
	case "del": // 취소		
		if (!confirm('선택한 항목을 삭제 하시겠습니까?')){
			return;
		}else{
			var rows = mySheet.RowCount();

			while (rows >= 0) {
				var chkedYn = mySheet.GetCellValue(rows, "SELECTED");
				if (chkedYn == "1" &&("Y" !=mySheet.GetCellValue(rows, "SAVE_FLAG"))){
					alert('등록된 차량정보만 삭제 할 수 있습니다.');
					mySheet.SelectCell(rows, 'CAR_NO', 1);
				}
				rows--;
			}
			kepSave(document.searchCondition ,  mySheet , "/wmdl/delMasterWmDlIntervalsInfoRegList.do" , "SELECTED" );
		}

		break;
	}
}

// TABLE의 ROW 데이타 생성
function addrows() {
	var rows = mySheet.DataInsert(-1);
	mySheet.SetCellValue(rows, 'WAREHOUSE_TEXT', document.searchCondition.st_warehouse_code.options[document.searchCondition.st_warehouse_code.selectedIndex].text  );
	mySheet.SetCellValue(rows, 'SAVE_FLAG', 'N');
	mySheet.SetCellEditable(rows, 'CAR_NO',1);
}

function checkedDel() {

	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	if (mySheet.RowCount() == 0) {
		alert("행이 없습니다.");
	}

	if (selectedGrid.length == 0) {
		alert("선택하신 행이 없습니다.");
		return;
	}

	if (!confirm("선택한 행 중 행 추가 한 행은 삭제 합니다.\n삭제하시겠습니까?")) {
		return;
	}

	var rows = mySheet.RowCount();

	while (rows >= 0) {
		var chkedYn = mySheet.GetCellValue(rows, "SELECTED");
		if (chkedYn == "1" &&("Y" !=mySheet.GetCellValue(rows, "SAVE_FLAG"))){
			mySheet.RowDelete(rows);
		}
		rows--;
	}
	//순번 재배열
	mySheet.ReNumberSeq();
}

// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}
	
// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

   	
	for(var  i= 1 ; i<mySheet.GetTotalRows()+1 ;  i++)
	{
		
		mySheet.SetCellValue(i, 'WAREHOUSE_TEXT', document.searchCondition.st_warehouse_code.options[document.searchCondition.st_warehouse_code.selectedIndex].text  );
	}
	
	
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
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}


		if(code==1){
			//저장 성공시 재조회
			alert('차량정보가 성공적으로 등록 되었습니다.');
			doAction('search');
		}else if(code==0){
			alert(msg);
		}else if(code==3){
			//저장 성공시 재조회
			alert('차량정보가 삭제 되었습니다.');
			doAction('search');
		}else if(code==4){
			alert(msg);
		}


}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/wmdl/getMasterWmDlIntervalsInfoRegList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {

	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	
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
			<h3>차량정보등록</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
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
			
            	<table  class="cont_t_list01"  width="680" >
					<caption>배차정보등록</caption>
					<colgroup>
							<col width="12%" />
							<col width="38%" />
							<col width="12%" />
							<col width="38%" />
					</colgroup>
						
					<tbody>
						<tr>
							<th>물류센터</th>
							<td>
								<select id="st_warehouse_code" name="st_warehouse_code" 	<%=whAdmin.equals("Y") ? "" : "disabled"%>>
								<%
						 			Map<String, String> _map = new HashMap<String, String>();
						 			_map.put("BUYER",buyer);
						 			_map.put("USERID",userid);
						 			_map.put("whAdmin",whAdmin);
								%>
								<%= CommonUtil.getCodeComboQueryIdList("common.getWareHouseIdSchList","",_map,st_warehouse_code) %>
								</select>						
							</td>
						   <th>차량번호</th>
							<td>
								<input type="text" class="input_type_text" id="st_car_no" name="st_car_no" style="width:90%" value="" onkeydown="kepEnter()"/>
							</td>
						</tr>
						<tr> 

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
  					<span class="btn_02 mr04"><a href="javascript:addrows();">행추가</a></span>
  					<span class="btn_02 mr04"><a href="javascript:checkedDel();">행삭제</a></span>
  				</span>
  				
  				<span class="fr">
  					<span class="btn_02 mr04"><a href="javascript:doAction('save');">저장</a></span>
  					<span class="btn_02 mr04"><a href="javascript:doAction('del');">삭제</a></span>
  				</span>
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
