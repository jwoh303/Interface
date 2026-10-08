<%--
**********************************************
* 메뉴 : 카탈로그관리>표준카탈로그 승인대상
* 화면 : 표준카탈로그 승인대상
* 기능 : 표준카탈로그 승인대상
* 프로그램 ID : 
* 담당자 : 현명환 
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>

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
	 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
	,{ Align:"Center",	Width:30,	Edit : true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED",ColMerge:0}
	,{ Align:"Center",	Width:80,	ImgWidth:50, Edit:false,		Type:"Image",	Header:"이미지",	SaveName:"IMG"}
	,{ Align:"Center",	Width:80,	ImgWidth:50, Edit:false,		Type:"Image",	Header:"상세이미지",	SaveName:"IMG_DT"}
	,{ Align:"Center",	Width:100,	Wrap:1, Edit:false,	EditLen:300,	Type:"Text",	Header:"표준카탈로그코드",	SaveName:"CMS_CATLG_ID"}
	,{ Align:"Left",	Width:150,	Wrap:1, Edit:false,	EditLen:400,	Type:"Text",	Header:"품목명",	SaveName:"DESCRIPTION_LOC"}
	,{ Align:"Left",	Width:150,	Wrap:1, Edit:false,	EditLen:400,	Type:"Text",	Header:"영문품목명",	SaveName:"DESCRIPTION_ENG"}
	,{ Align:"Left",	Width:180,	Wrap:1, Edit:false,	EditLen:400,	Type:"Text",	Header:"규격",	SaveName:"SPECIFICATION"}
	,{ Align:"Left",	Width:220,	Wrap:1, Edit:false,	EditLen:400,	Type:"Text",	Header:"표준카테고리",	SaveName:"CATEG_PATH"}
	,{ Align:"Left",	Width:100,	Wrap:1, Edit:false,	EditLen:400,	Type:"Text",	Header:"모델정보",	SaveName:"MODEL_INFO"}
	,{ Align:"Center",	Width:60,	Wrap:1, Edit:false,	EditLen:400,	Type:"Text",	Header:"표준화여부",	SaveName:"STD_FLAG"}
	,{ Align:"Left",	Width:80,	Wrap:1, Edit:false,	EditLen:400,	Type:"Text",	Header:"제조사",	SaveName:"MAKER_NAME"}
	,{ Align:"Center",	Width:80,	Wrap:1, Edit:false,	EditLen:400,	Type:"Text",	Header:"원산지",	SaveName:"ORIGIN_NAME"}
	,{ Align:"Center",	Width:60,	Wrap:1, Edit:false,	EditLen:400,	Type:"Text",	Header:"단위",	SaveName:"ORDER_MEASURE"}
	,{ Align:"Center",	Width:80,	Wrap:1, Edit:false,	EditLen:300,	Type:"Date",	Header:"요청일",	SaveName:"ADD_DATE"}
	,{ Align:"Center",	Width:60,	Edit:false,	EditLen:300,	Type:"Text",	Header:"요청자",	SaveName:"ADD_USER_NM"}
	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"STATUS",	SaveName:"STATUS"}
	];
	
	IBS_InitSheet2(mySheet, initsheet,pagingMode,5);

	//조회조건 초기값 설정
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	$("#st_from_date").val(kepToDateAdd("31","M"));
	$("#st_to_date").val(kepGetNowTimeStr('YYYYMMDD','/'));
	//하이퍼링크 설정
	setLinkCol(mySheet, "IMG");
	setLinkCol(mySheet, "IMG_DT");

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
		if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
	
		current_page = -1;
		kepSearch(document.searchCondition,  mySheet , "/mdcm/getMasterMdCmCatalogConfirmList.do" , pagingMode );
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
	case "confirn": // 승인
		if (!confirm("선택한 항목을 승인 하시겠습니까?"))
			return;
		for (var i=0; i<arrRow.length; i++){
			mySheet.SetCellValue(arrRow[i],"STATUS","C");
		}
		kepSave(document.searchCondition ,  mySheet , "/mdcm/saveMasterMpRqConfirmCatlg.do" , "SELECTED" );
		break;
	case "reject": // 반려
		if (!confirm('선택한 항목을 반려 하시겠습니까?'))
			return;
		for (var i=0; i<arrRow.length; i++){
			mySheet.SetCellValue(arrRow[i],"STATUS","X");
		}
		kepSave(document.searchCondition ,  mySheet , "/mdcm/saveMasterMpRqConfirmCatlg.do" , "SELECTED" );
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
	kepSearch(document.searchCondition ,  mySheet , "/mdcm/getMasterMdCmCatalogImgList.do?page="+current_page , pagingMode );
}

//엑셀업로드(LoadExcel) 후처리
function mySheet_OnLoadExcel() {

	//alert("저장");
	return;
}

// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	if (column == "IMG"){
		var strImg = mySheet.GetCellValue(Row,"IMG");
		if(strImg == "/resources/images/icon_emptyimg.gif"){
			alert("등록된 이미지가 없습니다.");
			return;
		}else{
			window.open('<%= CommonUtil.getURL(request) %>'+strImg,'catalogImage','status=no,resizable=yes,menubar=no,scrollbars=no,"","",width=550,height=550');	
		}
	}else if(column == "IMG_DT"){
		var strImg = mySheet.GetCellValue(Row,"IMG_DT");
		if(strImg == "/resources/images/icon_emptyimg.gif"){
			alert("등록된 이미지가 없습니다.");
			return;
		}else{
			window.open('<%= CommonUtil.getURL(request) %>'+strImg,'catalogImage','status=no,resizable=yes,menubar=no,scrollbars=no,"","",width=720,height=550');	
		}		
	}

}


//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2,value3,value4){
	
	//팝업 조회후 해당 항목에 값을 셋팅
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyer_single") {	// 고객사 
		
		//그룹을 선택할 수 없도록 처리.
		if(value4 == "1"){
			alert("그룹은 선택할 수 없습니다.");
			return;
		}
	
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2); 
		$("#st_com_org_code").val(value3); 
		 
	} else if (popupSel == "agent_single") {	// 협력사
		$("#st_agent_code").val(value1);
		$("#st_agent_name").val(value2);
		
		chItemStatusList(value1);
	} 
	grbRow="";	//초기화
}

	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>표준카탈로그승인대상조회</h3>
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
			<input type="hidden" id="USR_ID" name="USR_ID"  value="${sessionInfo.userId}">
			
            	<table  class="cont_t_list01" >
					<caption>표준카탈로그승인대상조회</caption>
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
							<th>요청일자</th>
							<td colspan="3">
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:20%; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_from_date')"></a>
								-
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:20%; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_to_date')"></a>
									&nbsp;&nbsp;
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>							
							</td>
							<th>표준카탈로그코드</th>
							<td>
								<input type="text"   class="input_type_text" name="st_cms_catlg_id" id="st_cms_catlg_id" style="width:87%" value="" onKeyDown="kepEnter()">
							</td>
						</tr>
						<tr> 
							<th>품목명</th>
							<td>
		                        <input type="text"   class="input_type_text" name="st_description" id="st_description" style="width:87%" value="" onKeyDown="kepEnter()">
							</td>
							<th>규격</th>
							<td>
								<input type="text"   class="input_type_text" name="st_spec" id="st_spec" style="width:87%" value="" onKeyDown="kepEnter()">
							</td>
							<th>모델명</th>
							<td>
								<input type="text"   class="input_type_text" name="st_model_info" id="st_model_info" style="width:87%" value="" onKeyDown="kepEnter()">
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
					<option value="10000">10000건</option>
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
<%
String _SessionUserId         = _sessionInfo.getUserId();
boolean getCodeYn = CommonUtil.getCodeCheckReturn("M200",_SessionUserId);
if(getCodeYn == true){ %>
  				<span class="fr">
  					<span class="btn_02 mr04"><a href="javascript:doAction('confirn');">승인</a></span>
  					<span class="btn_02 mr04"><a href="javascript:doAction('reject');">반려</a></span>
  				</span>
<%}%>
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
