<%--
**********************************************
* 메뉴 : 재고>로케이션관리>로케이션관리
* 화면 : 로케이션관리
* 기능 : 로케이션 현황 조회
* 프로그램 ID : PG_08_M_013_00
* 담당자 : 김지혜 ( 설계 : 김상근 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %> 
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
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"로케이션 코드",	SaveName:""} /* rowData.get("obj[1]")%>*/
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"",	SaveName:""} /* 	<input type="hidden" name="st_location_id_row" value="rowData.get("obj[1]")%>">*/
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"구역",	SaveName:""} /* rowData.get("obj[2]")%></td>*/
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"행",	SaveName:""} /* rowData.get("obj[3]")%></td>*/
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"열",	SaveName:""} /* rowData.get("obj[4]")%></td>*/
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"단",	SaveName:""} /* rowData.get("obj[5]")%></td>*/
					,{ Align:"Center",	Width:300,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"로케이션 구역명",	SaveName:""} /* 
						<select name="st_location_name">
							<option value="가상로케이션" rowData.get("obj[6]").equals("가상로케이션")?"selected":""%>>가상로케이션</option>
							<option value="선반보관장" rowData.get("obj[6]").equals("선반보관장")?"selected":""%>>선반보관장</option>
							<option value="BULK보관장" rowData.get("obj[6]").equals("BULK보관장")?"selected":""%>>BULK보관장</option>
							<option value="T/R보관장" rowData.get("obj[6]").equals("T/R보관장")?"selected":""%>>T/R보관장</option>
							<option value="분실보관장" rowData.get("obj[6]").equals("분실보관장")?"selected":""%>>분실보관장</option>
							<option value="반품보관장" rowData.get("obj[6]").equals("반품보관장")?"selected":""%>>반품보관장</option>
						</select>*/
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"재고유무",	SaveName:""} /* rowData.get("obj[7]")%></td>*/
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"",	SaveName:""} /* <input type="hidden" name="st_stck_yn" value="rowData.get("obj[7]")%>">*/
					
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//비고이미지설정
	mySheet.SetImageList(1, remarkOn);
	mySheet.SetImageList(0, remarkOff);

	//콤보데이터 셋팅		
	kepAjaxCommonQueryIdCombo('st_kep_user_id','getKepUserList','SEL','');

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
		kepSearch(document.searchCondition,  mySheet , "/wmst/getMasterWmStLocationManageList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
			mySheet.RemoveAll();
		break;

	case "save": // 저장
		if (!confirm('선택한 항목을 저장 하시겠습니까?'))
			return;
		kepSave(document.searchCondition ,  mySheet , "/wmst/saveMasterWmStLocationManageList.do" , "SELECTED" );
		break;
		
	case "del": // 취소
		if (!confirm('선택한 항목을 삭제 하시겠습니까?'))
			return;
		kepSave(document.searchCondition ,  mySheet , "/wmst/delMasterWmStLocationManageList.do" , "SELECTED" );
		break;

	case "excelDown": // 엑셀다운로드
	    $("#pageflag").val('0');
		var param = {FileName:"MyExcel.xlsx"};
		kepDownExcel(document.searchCondition ,mySheet , "/wmst/excelMasterWmStLocationManageList.do", param);
		$("#pageflag").val('1');
		break;
	}
}
function mySheet_OnDownFinish(downloadType, result) {

    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거

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
	kepSearch(document.searchCondition ,  mySheet , "/wmst/getMasterWmStLocationManageList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "buyer_single": // 고객사 M
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
			popupSel = "buyer_single";
			break;
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'BTOA_USER_NAME') { // 요청자
		var ID = mySheet.GetCellValue(Row,"BTOA_USER_ID");
		openSearchPopup('/common/userDisplayPop.do','?user_id='+ID, "800,500,no"); 
		
	} else if (column == 'BUYER_ITEM_NO') { // 품목코드
		var buyer = mySheet.GetCellValue(Row, "BUYER");
		var buyerItemNo = mySheet.GetCellValue(Row,"BUYER_ITEM_NO");
		var contractNo = mySheet.GetCellValue(Row,"CONTRACT_NO");
		var contractSeq = mySheet.GetCellValue(Row,"CONTRACT_SEQ");
		
		getBuyerCatalogDisplayPop(buyer,buyerItemNo,contractNo,contractSeq); 

		}else if (column == "QUOTATION_NO" ){ 
		popupSel = "quotationReDetailPop";
		var buyer = mySheet.GetCellValue(Row, "BUYER");
		var quotation_no = mySheet.GetCellValue(Row, "QUOTATION_NO");
		var revision = mySheet.GetCellValue(Row, "REVISION");
		openSearchPopup("/common/mprq/quotationReDetailPop.do",'?buyer='+buyer+'&quotation_no='+quotation_no+'&revision='+revision, "1020,500,no"); // 견적상세

	} else if (column == 'AGENT_NAME') { // 협력사
		var agent = mySheet.GetCellValue(Row,"AGENT");
		openSearchPopup('/common/agentInfoDisplayPop.do','?st_com_code='+agent, "800,550,no");
		
		}else if (column == "ORIGIN_NAME" ){ 
		popupSel = "country";
		openSearchPopup("/common/countryCodePop.do","","500,500,no");// 원산지

		}else  if (column == "MAKER_NAME" ){ 
		popupSel = "maker";
		openSearchPopup("/common/agentRegMakerCodePop.do","","500,500,no");// 제조사

		}else if (column == "ATOB_REMARK_IMG" ){ 
		popupSel = "remarkBAS";
		var btoa_remark = mySheet.GetCellValue(Row, "BTOA_REMARK");
		var atos_remark = mySheet.GetCellValue(Row, "ATOS_REMARK");
		var stoa_remark = mySheet.GetCellValue(Row, "STOA_REMARK");
		var atob_remark = mySheet.GetCellValue(Row, "ATOB_REMARK");
		openSearchPopup("/common/remarkBASPop.do",'?st_btoa_remark='+btoa_remark+'&st_atos_remark='+atos_remark+'&st_stoa_remark='+stoa_remark+'&st_atob_remark='+atob_remark, "500,600,no");// 고객사 비고

		}else if (column == "ATOS_REMARK_IMG" ){ 
		popupSel = "remarkAtoS2";
		var viewType="R";
		var atos_remark = mySheet.GetCellValue(Row, "ATOS_REMARK");
		var reject_remark = mySheet.GetCellValue(Row, "REJECT_REMARK");
		openSearchPopup("/common/remarkAtoS2Pop.do",'?st_atos_remark='+atos_remark+'&st_reject_remark='+reject_remark+'&viewType='+viewType, "500,270,no");// 협력사 비고
		
	} else if(column == "REJECT_REMARK_IMG"){
		popupSel = "cancelRemark";
		var viewType="R";
		var cancel_remark = mySheet.GetCellValue(Row, "REJECT_REMARK");
		openSearchPopup("/common/remarkCancelPop.do",'?cancel_remark='+cancel_remark+'&viewType='+viewType, "500,230,no"); // 취소사유

	}
	return;
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyer_single") {	// 다중 고객사
		$("#st_buyer_code").val(code);
		$("#st_buyer_name").val(text);
	
	} else if (popupSel == "country") {	// 원산지
		mySheet.SetCellValue(grbRow, 'ORIGIN_CODE', value1);
		mySheet.SetCellValue(grbRow, 'ORIGIN_NAME', value2);
	
	}else if (popupSel == "maker") {	// 제조사
		mySheet.SetCellValue(grbRow, 'MAKER_CODE', value1);
		mySheet.SetCellValue(grbRow, 'MAKER_NAME', value2);
		
	}else if(popupSel == "remarkBAS") {	//고객사 비고
		mySheet.SetCellValue(grbRow, 'ATOB_REMARK', value1);
		mySheet.SetCellValue(grbRow, 'ATOB_REMARK_IMG', (value1!="")? remarkOn : remarkOff);
	
	}else if(popupSel == "remarkAtoS2") {	//고객사 비고
		mySheet.SetCellValue(grbRow, 'ATOS_REMARK', value1);
		mySheet.SetCellValue(grbRow, 'ATOS_REMARK_IMG', (value1!="")? remarkOn : remarkOff);
			
	}else if(popupSel == "cancelRemark") {	//견적 취소
		mySheet.SetCellValue(grbRow, 'REJECT_REMARK', value1);
		mySheet.SetCellValue(grbRow, 'REJECT_REMARK_IMG', (value1!="")? remarkOn : remarkOff);
			
	}
	grbRow="";	//초기화
}

	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>로케이션관리</h3>
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
			
            	<table  class="cont_t_list01" >
					<caption>로케이션관리</caption>
					<colgroup>
						<col width="100" />
						<col width="25%" />
						<col width="*" />
					</colgroup>
						
					<tbody>
						<tr> 
							<td>로케이션코드&nbsp;</td>
							<td ><input type="text" name="st_location_id" style="width:80%" value="" onKeyUp="ToUpper(this);"></td>
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
  					<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
  				</span>
  				
  				<span class="fr">
  					<span class="btn_02 mr04"><a href="javascript:doAction('save');">저장</a></span>
  					<span class="btn_02"><a href="javascript:doAction('del');">견적취소</a></span>
  				</span>
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
