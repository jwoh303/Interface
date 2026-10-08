<%--
**********************************************
* 메뉴 : 상품관리 > 환연동계약정보 관리
* 화면 : 환연동계약정보 관리
* 기능 : 
* 프로그램 ID : 
* 담당자 :
* 착수일 :
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
var mySheet2 = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var grbRow = "";
var popupSel = "";

var areaOn = "/resources/images/icon.gif";
var areaOff = "/resources/images/icon2.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
    
	var initsheet = {};
	initsheet.Cols = [
		  { Align:"Center",		Width:60,	Edit:true,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:"선택",					SaveName:"SELECTED"}
		 ,{ Align:"Left",			Width:150,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",					Header:"고객사명",			SaveName:"COM_NAME_LOC"}
		 ,{ Align:"Center",		Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"고객사코드",		SaveName:"COM_CODE"}
		 ,{ Align:"Center",		Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"환율코드",			SaveName:"EXP_CODE"}
		 ,{ Align:"Center",		Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"통화단위",			SaveName:"EXP_CUR"}
		 ,{ Align:"Center",		Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"구분",			SaveName:"EXP_PRICE_NM"}
		 ,{ Align:"Right",			Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",					Header:"환율",				SaveName:"EXP_CUR_PRICE",				Format:"${qtyFormat}"}
		 ,{ Align:"Right",			Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",					Header:"부대비용율",				SaveName:"ACCESSORIAL_CHARGES",				Format:"${qtyFormat}"}
		 ,{ Align:"Center",		Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",					Header:"등록일",			SaveName:"ADD_DATE"}
		 ,{ Align:"Center",		Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",					Header:"변경일",			SaveName:"CHANGE_DATE"}
		 
	];

	mySheet.SetImageList(5, areaOn);
	mySheet.SetImageList(4, areaOff);

	IBS_InitSheet(mySheet, initsheet,pagingMode);

}
	
// 기능함수
function doAction(str) {
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if (str !="search" && str !="excelDown" && str !="reload" && str !="excelUpload" && selectedGrid.length == 0){
		alert("선택된 항목이 없습니다.");
		return;
	}
	
	var buyer = TrimCommon($("#st_buyer_code").val());

	switch (str) {
	case "search":	 // 조회 
		pagingMode = "N";
		kepSearch(document.searchCondition,  mySheet , "/mdcm/getMasterMdCmExpMngList.do" , pagingMode );
		break;
		
	case "reload":	// 초기화
		kepReload('searchCondition');
		$("#st_buyer_code").val(""); 
		$("#st_buyer_name").val(""); 
		mySheet.RemoveAll();
		break;
	case "submit"://환율반영
		
	    if (confirm("환율 반영 하시겠습니까?")==false) return;
		
		kepSave(document.searchCondition, mySheet, "/mdcm/saveMasterMdCmExpMng.do", "SELECTED");
		break;
	}
}
	
// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	loader_obj("N");
	return DATA;
}

function mySheet_OnLoadExcel() {
	loader_obj("N");
}

// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode){
	loader_obj("N");
	if(!checkedSession(stCode)){return;}

	var totRow = mySheet.RowCount();
	if( totRow<= 0) return;
   	
	if (msg != ""){
		alert(msg);
	}
}
	
// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode){
	loader_obj("N");
	
	if(!checkedSession(stCode)){return;}
	
	if (msg != "") {
		alert(msg);
	}
	doAction('search');
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	pagingMode = "P"; 
	kepSearch(document.searchCondition ,  mySheet , "/mdcm/getMasterMdCmExpMngList.do?page=1" , pagingMode );
}

//팝업함수호출
function doPop(str) {
	popupSel = str;

	switch (str) {
		case "buyer_single": // 고객사 M
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
			popupSel = "buyer_single";
			break;  
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2, value3, value4, value5, value6, value7){
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyer_single") {	// 고객사 
		//그룹을 선택할 수 없도록 처리.
		if(value4 == "1"){
			alert("그룹은 선택할 수 없습니다.");
			return;
		}
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2); 
	} 
}
</script>
</head>

<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>환연동 계약정보관리</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition"  id="searchCondition" method = "post" onsubmit="return false" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_user_dept" name="st_user_dept"  value="${sessionInfo.department}">
			<input type="hidden" id="onepagerow" name="onepagerow"  value="1000">
			<input type="hidden" id="st_query" name="st_query"  value="">
            	<table  class="cont_t_list01" >
					<caption>환연동 계약정보관리</caption>
					<colgroup>
						<col width="10%" />
						<col width="90%" />
					</colgroup>
						
					<tbody>
						<tr>
							<th>고객사</th>
							<td>
								<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:20%" value="" onclick="doPop('buyer_single');" readonly>
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" value="">
								<a href="javascript:doPop('buyer_single');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
						</tr>
					</tbody>
				</table>
            </div>
		</form>
      	
      	<!--grid-->
		<div class="ib_product" style="border-top:2px solid #3c639c">
			<script type="text/javascript">
				createIBSheet("mySheet", "100%", "354px");
			</script>
		</div> 
		
		<p class="paging" id="pageindex"></p>
  			
  		<!--버튼영역-->
		<div class="btnArea02">
  	        <span class="fr">
  				<!-- span class="btn_04 mr04"><a href="javascript:doAction('submit');">환율반영</a></span -->
  			</span>  				
		</div>
<!--내용 종료-->	                 
</body>
</html>
