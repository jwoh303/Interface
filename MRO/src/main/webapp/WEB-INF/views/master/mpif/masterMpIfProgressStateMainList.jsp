<%--
**********************************************
* 메뉴 : I/F 관리>진행현황>진행현황 메인
* 화면 : 진행현황 메인
* 기능 :
* 프로그램 ID : PG_11_M_001_00
* 담당자 : 최명진 ( 설계 : 김상근 )
* 착수일 : 2014-
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
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var imageG="/resources/images/icon_g.gif";
var imageY="/resources/images/icon_y.gif";
var imageR="/resources/images/icon_r.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
		 { Align:"Center",Width:60,		Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",	Header:"상태",				SaveName:"sStatus"}
		,{ Align:"Center",	Width:50,		Edit:false,	EditLen:95,	Hidden:false,	Type:"Image",	Header:"I/F상태",			SaveName:"IF_STATUS"}
		,{ Align:"Left",	Width:180,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",		Header:"고객사명",			SaveName:"COM_NAME_LOC"}
		,{ Align:"Left",	Width:130,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"KeP팀명",			SaveName:"DEPT"}
		,{ Align:"Right",	Width:70,		Edit:false,	EditLen:190,	Hidden:false,	Type:"Float",		Header:"견적",				SaveName:"RE"}
		,{ Align:"Right",	Width:70,		Edit:false,	EditLen:120,	Hidden:false,	Type:"Float",		Header:"발주",				SaveName:"PO_TOTAL"}
		,{ Align:"Right",	Width:70,		Edit:false,	EditLen:120,	Hidden:false,	Type:"Float",		Header:"납품",				SaveName:"IV"}
		,{ Align:"Right",	Width:70,		Edit:false,	EditLen:120,	Hidden:false,	Type:"Float",		Header:"입고",				SaveName:"GR"}
		,{ Align:"Right",	Width:70,		Edit:false,	EditLen:120,	Hidden:false,	Type:"Float",		Header:"기타",				SaveName:"ETC"}
		,{ Align:"Left",	Width:330,	Edit:false,	EditLen:90,	Hidden:false,	Type:"Text",		Header:"고객사담당자",		SaveName:"REMARK"}
		,{ Align:"Center",	Width:90,		Edit:false,	EditLen:90,	Hidden:false,	Type:"Date",		Header:"데몬체크일시",		SaveName:"ADD_DATE"}
	];

	IBS_InitSheet(mySheet, initsheet, pagingMode);

	// 상태이미지설정
	mySheet.SetImageList(0, imageG);
	mySheet.SetImageList(1, imageY);
	mySheet.SetImageList(2, imageR);

	// 하이퍼링크 설정
	setLinkCol(mySheet, "RE");	
	setLinkCol(mySheet, "PO_TOTAL");	
	setLinkCol(mySheet, "IV");	
	setLinkCol(mySheet, "GR");	
	setLinkCol(mySheet, "ETC");	
	
	// 초기화 설정
	resetValue();
}

// 초기화 설정
function resetValue() {
	// 콤보데이터 셋팅
	kepAjaxCommonQueryIdCombo('st_user_dept','getKepDeptList','','${sessionInfo.department}');

	// checkbox 설정
	$("input:checkbox[id='st_user_check']").attr("checked",false);

	// 조회조건 hidden 설정
	$("#st_buyer_code").val("");
}

var st;
var mt;

// 그리드 표시후 처리
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

// 기능함수
function doAction(str) {

	st = new Date();
// 	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 담당자 무시 checkbox
	var ischecked = $("#st_user_check").is(":checked");

	if ( ischecked ) {
		$("#st_user_check_value").val("Y");
	} else {
		$("#st_user_check_value").val("N");
	}

	switch (str) {
		case "search": // 조회
			// 조회조건 체크
			if ( !searchValidate() )
				return;
			current_page = -1;
			kepSearch(document.searchCondition, mySheet, "/mpif/getMasterMpIfProgressStateMainList.do", pagingMode );
			break;

		case "reload": // 초기화
			kepReload('searchCondition');
			resetValue();
			mySheet.RemoveAll();
			break;
	}
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	
    var st_buyer_code = $('#st_buyer_code').val();
    var st_buyer_name = $('#st_buyer_name').val();
    var st_user_check;
    if($("input:checked[id='st_user_check']").is(":checked")){
    	st_user_check = "Y";
    }
    else{
    	st_user_check = "N";
    }
    var st_user_dept = $('#st_user_dept').val();

  //발주
	if(column == 'PO_TOTAL'){
		
		var param = "st_buyer_code="+st_buyer_code+"&st_buyer_name="+st_buyer_name+"&processYN=Y"+"&st_user_check="+st_user_check+"&st_user_dept="+st_user_dept;
		param = encodeURI(param);
		parent.tab("발주오류현황","/mpif/showMasterMpIfErrorStateMain.do?"+param);
		//parent.tab("발주오류현황","/mpif/showMasterMpIfErrorStateMain.do?st_buyer_code="+st_buyer_code+"&st_buyer_name="+st_buyer_name+"&processYN=Y"+"&st_user_check="+st_user_check+"&st_user_dept="+st_user_dept);
	}
	//견적
	if(column == 'RE'){
		var param = "st_buyer_code="+st_buyer_code+"&st_buyer_name="+st_buyer_name+"&processYN=Y"+"&st_user_check="+st_user_check+"&st_user_dept="+st_user_dept;
		param = encodeURI(param);
		parent.tab("견적오류현황","/mpif/showMasterMpIfSourcing.do?"+param);
		//parent.tab("견적오류현황","/mpif/showMasterMpIfSourcing.do?st_buyer_code="+st_buyer_code+"&st_buyer_name="+st_buyer_name+"&processYN=Y"+"&st_user_check="+st_user_check+"&st_user_dept="+st_user_dept);
	}
	
	//입고
	if(column == 'GR'){
		var param = "st_buyer_code="+st_buyer_code+"&st_buyer_name="+st_buyer_name+"&processYN=Y"+"&st_user_check="+st_user_check+"&st_user_dept="+st_user_dept;
		param = encodeURI(param);
		parent.tab("입고오류현황","/mpif/showMasterMpIfWarehousing.do?"+param);
		//parent.tab("입고오류현황","/mpif/showMasterMpIfWarehousing.do?st_buyer_code="+st_buyer_code+"&st_buyer_name="+st_buyer_name+"&processYN=Y"+"&st_user_check="+st_user_check+"&st_user_dept="+st_user_dept);
	}
	
	//납품
	if(column == 'IV'){
		var param = "st_buyer_code="+st_buyer_code+"&st_buyer_name="+st_buyer_name+"&processYN=Y"+"&st_user_check="+st_user_check+"&st_user_dept="+st_user_dept;
		param = encodeURI(param);
		parent.tab("납품오류현황","/mpif/showMasterMpIfDlvrysttmnt.do?"+param);
		//parent.tab("납품오류현황","/mpif/showMasterMpIfDlvrysttmnt.do?st_buyer_code="+st_buyer_code+"&st_buyer_name="+st_buyer_name+"&processYN=Y"+"&st_user_check="+st_user_check+"&st_user_dept="+st_user_dept);
	}
	
	//기타
	if(column == 'ETC'){
		var param = "st_buyer_code="+st_buyer_code+"&st_buyer_name="+st_buyer_name+"&processYN=Y"+"&st_user_check="+st_user_check+"&st_user_dept="+st_user_dept;
		param = encodeURI(param);
		parent.tab("기타오류현황","/mpif/showMasterMpIfBefr.do?"+param);
		//parent.tab("기타오류현황","/mpif/showMasterMpIfBefr.do?st_buyer_code="+st_buyer_code+"&st_buyer_name="+st_buyer_name+"&processYN=Y"+"&st_user_check="+st_user_check+"&st_user_dept="+st_user_dept);
	}
	
}


// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}

	if (msg != "") {
		alert(msg);
	}

	if ( current_page == -1 ) {
		makePageIndex2(mySheet, 1, document.searchCondition.onepagerow.value);
	}
	else {
		makePageIndex2(mySheet, current_page, document.searchCondition.onepagerow.value);
	}

}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param) {
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition, mySheet, "/mpif/getMasterMpIfProgressStateMainList.do?page="+current_page, pagingMode);
}

// 조회조건 체크
function searchValidate() {
	if ( kepTrim("st_buyer_code") == '' ) {
		alert("고객사를 선택해 주십시오");
		return false;
	}

	return true;
}

// 팝업함수호출
function doPop(str, params) {
	popupSel = str;

	switch (str) {
		case "masterWmCoTranBuyerPop": // 다중 거래고객사
			var st_user_dept = $("#st_user_dept").val();
			var ischecked = $("#st_user_check").is(":checked");
			var check_yn = '';
			if ( ischecked ) {
				check_yn = "Y";
			} else {
				check_yn = "N";
			}
			openSearchPopup("/wmco/showMasterWmCoTranBuyerPop.do", "?st_user_dept="+st_user_dept+"&st_user_check="+check_yn, "500,500,no");
			break;
		
		case "buyerMulti": // 다중 고객사
// 			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=Y", "500,466,no"); // 1Grid
			openSearchPopup('/common/safetyCompanyCodePop.do','?COM_TYPE=B', '880,450,no'); // 2Grid
			break;
		
		case "manual": // 매뉴얼 호출
			openSearchPopup("https://gw.koreab2b.com/servlet/HIServlet", "?SLET=bbs.BBSMtrlRead.java&MENUBAR=ON&MET=LIST&BMID=00000083o&BRDID=0000008i3&LM=nm&NL=1&LMET=CLOSE", "800,600, yes");
			break;
	}
}

// 콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text){
	// 팝업 조회후 해당 항목에 값을 셋팅
	if ( popupSel == "masterWmCoTranBuyerPop" ) { // 다중 거래고객사
		$("#st_buyer_code").val(code);
		$("#st_buyer_name").val(text);
		
	} else if ( popupSel == "buyerMulti" ) { // 다중 고객사
		$("#st_buyer_code").val(code);
		$("#st_buyer_name").val(kepMultiName(text,"@"));
		
	}

	grbRow="";	//초기화
}
</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
	<!--버튼영역-->
   	<div id="searchBtnA"  >
		<h3>진행현황</h3>
      	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span>
    	<span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
    	<span><a href="javascript:doPop('manual')"><img src="/resources/images/question_mark.gif"></a></span>
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

			<table  class="cont_t_list01">
				<caption>진행현황 메인</caption>
				<colgroup>
					<col width="8%" />
					<col width="30%" />
					<col width="8%" />
					<col width="20%" />
					<col width="8%" />
					<col width="10%" />
				</colgroup>

				<tbody>
					<tr>
						<th><font color="#FF6600">*</font>고객사</th>
						<td>
							<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:70%" value="" readonly onclick="javascript:doPop('buyerMulti', '');">
							<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:80%" value="">
							<a href="javascript:doPop('masterWmCoTranBuyerPop', '');"><img src="/resources/images/btn_search03.gif"></a>
							<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
						</td>
						<th>KeP팀명</th>
						<td>
							<select id="st_user_dept" name="st_user_dept" style="width:80%;height:20px"></select>
						</td>
						<th>&nbsp;&nbsp;
							<input type="checkbox" class="Noborder" id="st_user_check" name="st_user_check" value="N"> 담당자 무시
							<input type="hidden" id="st_user_check_value" name="st_user_check_value" value="N">
						</th>
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
		<span class="fl">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
		<span class="fl">
			<img src="/resources/images/icon_g.gif" style="padding-top:3px;"/>&nbsp;정상&nbsp;&nbsp;
			<img src="/resources/images/icon_y.gif" style="padding-top:3px;"/>&nbsp;당일거래 없는 경우&nbsp;&nbsp;
			<img src="/resources/images/icon_r.gif" style="padding-top:3px;"/>&nbsp;I/F 연결 끊어짐(필히 확인)&nbsp;&nbsp;
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

<!--내용 종료-->

</body>
</html>
