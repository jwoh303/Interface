<%--
**********************************************
* 메뉴 : 관리자>코드관리>제조사 관리
* 화면 : 제조사 관리
* 기능 : 
* 프로그램 ID : PG_90_M_400_04
* 담당자 :  ( 설계 : 공통 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
String SessionUserId         = _sessionInfo.getUserId();
boolean getMakerYn = CommonUtil.getCodeCheckReturn("M163",SessionUserId);//제조사등록권한
boolean getMgYn = CommonUtil.getCodeCheckReturn("M164",SessionUserId);//제조사 수정, 대표제조사 등록권한
%>
<!-- 다중선택콤보(공통) - 사용시 필수 선언 start -->
<script src="/resources/js/jquery.multiple.select.js"></script>
<link rel="stylesheet" href="/resources/styles/multiple-select.css" type="text/css" />
<!-- 다중선택콤보(공통) - 사용시 필수 선언 end -->

<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";
var iconR="/resources/images/icon_r.gif";
var iconY="/resources/images/icon_y.gif";
var iconG="/resources/images/icon_g.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
// 	initsheet.HeaderMode = {			Sort : 0,			ColMove : 1,			ColResize : 1		};
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol : 2};
	initsheet.Cols = [
	{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,		Type:"Text",	Header:"대표 제조사코드",	SaveName:"TEXT7"}
	,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,		Type:"Text",	Header:"대표 제조사명",	SaveName:"MG_TEXT"}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,		Type:"Text",	Header:"제조사코드",	SaveName:"CODE"}
	,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,		Type:"Text",	Header:"제조사명",	SaveName:"TEXT1"}
	,{ Align:"Left",	Width:430,	Edit:false,	EditLen:100,	Type:"Text",	Header:"대표품목",	SaveName:"TEXT5"}
	,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Type:"Text",	Header:"URL",	SaveName:"TEXT6"}
	,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Type:"Text",	Header:"원산지",	SaveName:"ORIGIN"}
	,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Type:"Date",	Header:"등록일",	SaveName:"ADD_DATE"}
	
	];
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	setLinkCol(mySheet, "TEXT6");//URL
	setLinkCol(mySheet, "TEXT7");//대표제조사코드
	setLinkCol(mySheet, "MG_TEXT");//대표제조사명
	setLinkCol(mySheet, "CODE");//제조사코드
	setLinkCol(mySheet, "TEXT1");//제조사명
}

	
var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");

	switch (str) {
	case "search":	 // 조회	
		current_page = -1;
		if(document.getElementById("st_checkbox").checked == true){
			$("#st_check_value").val("Y");
		}else{
			$("#st_check_value").val("N");
		}
		kepSearch(document.searchCondition,  mySheet , "/mdam/getMasterMdAmMakerManageList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		$('#st_buyer_code').val("");
		mySheet.RemoveAll();
		
		// 다중선택콤보(공통) - 초기화
		init_multiCombo("st_status");
		
		$("#st_from_date").val(kepToDateAdd("7","M"));
		$("#st_to_date").val(kepGetNowTimeStr('YYYYMMDD','/')); 
		break;
	}
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

	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	
	var totRow = mySheet.RowCount();
	if( totRow<= 0) return;

	if (msg != "") {
		alert(msg);
	}
	
}

function mySheet_OnMouseMove(Button, Shift, X, Y) { 
	var row = mySheet.MouseRow();

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
	if(document.getElementById("st_checkbox").checked == true){
		$("#st_check_value").val("Y");
	}else{
		$("#st_check_value").val("N");
	}
	kepSearch(document.searchCondition ,  mySheet , "/mdam/getMasterMdAmMakerManageList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str , val1) {
	popupSel = str;
	var st_user_id = document.searchCondition.st_user_id.value;
	
	switch (str) {
		case "makerReg": //  제조사등록
			mode = 'INS';
			openSearchPopup('/mdam/showMasterMdAmMakerManageRegPop.do', "?st_mode=" + mode,'617,320,no');
		break;			
		case "makerChange": // 제조사수정
			mode = 'FIX';
			openSearchPopup("/mdam/getMasterMdAmMakerManageRegPop.do", "?st_code=" + val1+'&st_mode='+mode, "617,320,no");
		break;
		case "makerMgReg": // 대표제조사 등록
			openSearchPopup("/mdam/showMasterMdAmMgMakerManageRegPop.do", "", "600,150,no");
		break;	
	}
}

// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	if (column == 'TEXT6') { // URL
		var link = 'http://' + Value;
        var features ='height=768, width=1024, status=no, scrollbars=auto, resizable=yes';
        window.open(link, 'watchwin', features);
	}
	if (column == 'TEXT1'||column == 'CODE'||column == 'MG_TEXT'||column == 'TEXT7') { // URL
		var st_mg_yn = "<%=getMgYn%>";
		if(st_mg_yn == "true"){
			doPop("makerChange", mySheet.GetCellValue(Row,"CODE"));	
		}else{
			alert("제조사 수정 권한이 없습니다.");
			return;
		}
		
	}
	return;
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyerMulti") {	// 다중 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(kepMultiName(value2,"@"));
	
	} else if(popupSel == "cancelRemark") {	//견적 취소
		mySheet.SetCellValue(grbRow, 'CANCEL_REMARK', value1);
		mySheet.SetCellValue(grbRow, 'CANCEL_REMARK_IMG', (value1!="")? remarkOn : remarkOff);

	} else if(popupSel == "remarkReturn2Pop") {	// SCM비고
		mySheet.SetCellValue(grbRow, 'SCM_REMARK', value1);
		mySheet.SetCellValue(grbRow, 'SCM_REMARK_IMG', (value1!="")? remarkOn : remarkOff);
		
	} else if (popupSel == "maker"){ // 제조사
		$("#st_maker_code").val(value1);
		$("#st_maker_name").val(value2);
		
	}
	grbRow="";	//초기화
}

	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>제조사 관리</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition" method = "post">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_check_value" name="st_check_value"  value="">
			<div id="cont_searchA">
            	<table  class="cont_t_list01"  >
					<caption>제조사 관리</caption>
					<colgroup>
						<col width="10%" />
						<col width="23%" />
						<col width="10%" />
						<col width="23%" />
						<col width="10%" />
                        <col width="23%" />
					</colgroup>
					<tbody>
						<tr> 
							<th>제조사 코드</th>
							<td>
								<input type="text" name="st_maker_code" id="st_maker_code" style="width:87%" value="" onKeyUp="kepToUpper('st_maker_code')" onkeydown="kepEnter()" />
							</td>
							<th>제조사명</th>
							<td>
									<input type="text" name="st_maker_name" id="st_maker_name" style="width:87%" value="" onkeydown="kepEnter()" />
							</td>
							<th colspan="2">
								<input type="checkbox"  class="Noborder" name="st_checkbox" id="st_checkbox">&nbsp;대표 제조사 미매핑
							</th>
						</tr>
					</tbody>
				</table>
            </div>
            
           	<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
               	<label for="b_no02" class="hidden">정렬개수선택</label>
					<select name="onepagerow" style="width: 70px;" >
					<option value="50" selected>50건</option>
					<option value="100">100건</option>
					<option value="500">500건</option>
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
  				
  				<span class="fr">
  				<%if(getMgYn== true){ %>
  					<span class="btn_08 mr04"><a href="javascript:doPop('makerMgReg');">대표 제조사 등록</a></span>
  				<%} %>
  				<%if(getMakerYn== true){ %>
  					<span class="btn_05 mr04"><a href="javascript:doPop('makerReg');">제조사 등록</a></span>
  				<%} %>
  				</span>
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
