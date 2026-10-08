<%--
**********************************************
* 메뉴 : I/F 관리>오류현황>오류현황 기타
* 화면 : 오류현황 기타
* 기능 :
* 프로그램 ID : PG_11_M_006_00
* 담당자 : 최명진 ( 설계 : 김상근 )
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
	String searchYn		= CommonUtil.nvl((String)request.getParameter("search_yn"));
	String buyerCode	= CommonUtil.nvl((String)request.getParameter("st_buyer_code"));
	String buyerName	= CommonUtil.nvl((String)request.getParameter("st_buyer_name"));
	String st_user_check = CommonUtil.nvl((String)request.getParameter("st_user_check"));
	String st_user_dept = CommonUtil.nvl((String)request.getParameter("st_user_dept"));
	String processYN = CommonUtil.nvl((String)request.getParameter("processYN"));
%>
<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var imageG="/resources/images/icon_g.gif";
var imageY="/resources/images/icon_y.gif";
var imageR="/resources/images/icon_r.gif";
var imagePrifC="/resources/images/icon_prif_c.gif";
var imagePrifR="/resources/images/icon_prif_r.gif";
var imagePrifCancel="/resources/images/icon_prif_cancel.gif";
var imagePrifDelete="/resources/images/icon_prif_delete.gif";
var searchYn = "<%=searchYn%>";
var processYN ="<%=processYN%>";
// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
		 { Align:"Center",Width:60,		Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",	Header:"상태",					SaveName:"sStatus"}
   		,{ Align:"Center",	Width:50,		Edit:false,	EditLen:95,	Hidden:false,	Type:"Image",	Header:"상태",					SaveName:"STATUS"}
   		,{ Align:"Center",	Width:50,		Edit:false,	EditLen:95,	Hidden:true,	Type:"Text",		Header:"상태",					SaveName:"STATUS_NM"}
   		,{ Align:"Left",	Width:130,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",		Header:"고객사",					SaveName:"COM_NAME_LOC"}
   		,{ Align:"Left",	Width:110,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",		Header:"담당부서",				SaveName:"KEPT_DEPT_CODE"}
//    		,{ Align:"Left",	Width:110,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",		Header:"담당자",					SaveName:"KEPT_DEPT_NAME"}
   		,{ Align:"Left",	Width:110,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"분류명",					SaveName:"GUBUN_NM"}
   		,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"분류코드",				SaveName:"LEGACY_NUM"}
   		,{ Align:"Right",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"총건수",					SaveName:"TOT_CNT"}
   		,{ Align:"Right",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"총금액",					SaveName:"TOT_AMT"}
   		,{ Align:"Right",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"오류건수",				SaveName:"ERR_CNT"}
   		,{ Align:"Right",	Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Float",		Header:"정상건수",				SaveName:"STD_CNT"}
   		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"오류발생일시",			SaveName:"CHANGE_DT"}
   		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",		Header:"최종파일수신일시",	SaveName:"CONFIRM_DT"}
   		,{ Align:"Left",	Width:300,	Edit:false,	EditLen:190,	Hidden:false,	Type:"Text",		Header:"오류내용",				SaveName:"ERR_MSG"}
   		,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"비고",					SaveName:"REMARK"}
	];

	IBS_InitSheet(mySheet, initsheet,pagingMode);

	// 상태이미지설정
	mySheet.SetImageList(0, imageG);
	mySheet.SetImageList(1, imageY);
	mySheet.SetImageList(2, imageR);

	mySheet.SetImageList(3, imagePrifC);
	mySheet.SetImageList(4, imagePrifR);
	mySheet.SetImageList(5, imagePrifCancel);
	mySheet.SetImageList(6, imagePrifDelete);

	// 초기화 설정
	resetValue();
	
	$("#st_buyer_code").val("<%=buyerCode%>");
	$("#st_buyer_name").val("<%=buyerName%>");
	var st_user_check = "<%=st_user_check%>";
	if(st_user_check== "Y"){
		$('#st_user_check').prop('checked',true);
	}
	
	if(processYN == "Y"){
		kepAjaxCommonQueryIdCombo('st_user_dept','getKepDeptList','','<%=st_user_dept%>');
		doAction("search");
	}
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
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if (str !="search" && str !="excelDown" && str !="reload" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
		case "search": // 조회
			// 조회조건 체크
			if ( !searchValidate() )
				return;
			current_page = -1;
			kepSearch(document.searchCondition, mySheet, "/mpif/getMasterMpIfBefrList.do", pagingMode);
			break;

		case "reload": // 초기화
			kepReload('searchCondition');
			resetValue();
			mySheet.RemoveAll();
			break;

		case "excelDown": // 엑셀다운로드
		    $("#pageflag").val('0');
// 		    var param = {FileName:"오류현황_기타.xlsx",Merge:1,SheetDesign:1,DownCols:"STATUS_NM|COM_NAME_LOC|KEPT_DEPT_CODE|KEPT_DEPT_NAME|GUBUN_NM|LEGACY_NUM|TOT_CNT|TOT_AMT|ERR_CNT|STD_CNT|CHANGE_DT|CONFIRM_DT|ERR_MSG|REMARK"};
		    var param = {FileName:"오류현황_기타.xlsx",Merge:1,SheetDesign:1,DownCols:"STATUS_NM|COM_NAME_LOC|KEPT_DEPT_CODE|GUBUN_NM|LEGACY_NUM|TOT_CNT|TOT_AMT|ERR_CNT|STD_CNT|CHANGE_DT|CONFIRM_DT|ERR_MSG|REMARK"};
			kepDownExcel(document.searchCondition, mySheet, "/mpif/excelMasterMpIfBefrList.do", param);
			$("#pageflag").val('1');
			break;
	}
}

function mySheet_OnDownFinish(downloadType, result) {

    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거

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
	} else {
		makePageIndex2(mySheet, current_page, document.searchCondition.onepagerow.value);
	}
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition, mySheet, "/mpif/getMasterMpIfBefrList.do?page="+current_page, pagingMode);
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
			openSearchPopup('/wmco/showMasterWmCoTranBuyerPop.do', '?st_user_dept='+st_user_dept+'&st_user_check='+check_yn+'&Gubun=XX','500,500,no');
			break;

		case "buyerMulti": // 다중 고객사
// 	        openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=Y", "500,466,no"); // 1Grid
	        openSearchPopup('/common/safetyCompanyCodePop.do','?COM_TYPE=B', '880,450,no'); // 2Grid
			break;

		case "manual": // 매뉴얼 호출
			openSearchPopup("https://gw.koreab2b.com/servlet/HIServlet", "?SLET=bbs.BBSMtrlRead.java&MENUBAR=ON&MET=LIST&BMID=00000083t&BRDID=0000008i3&LM=nm&NL=1&LMET=CLOSE", "800,600, yes");
			break;
	}
}

// 콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2, value3, value4){
// 	alert(value1 + ":" + value2 + ":" + value3 + ":" + value4);

	// 팝업 조회후 해당 항목에 값을 셋팅
	if ( popupSel == "masterWmCoTranBuyerPop" ) { // 다중 거래고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
	}
	else if ( popupSel == "buyerMulti" ) { // 다중 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(kepMultiName(value2,"@"));
	}

	grbRow="";	//초기화
}
</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
	<!--버튼영역-->
    <div id="searchBtnA"  >
		<h3>기타오류현황</h3>
        <span class="btn_search"><a href="javascript:doAction('search')">조회</a></span>
		<span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
		<span><a href="javascript:doPop('manual')"><img src="/resources/images/question_mark.gif"></a></span>
   	</div>
    <!--조회영역-->
    <form name = "searchCondition" method = "post">
		<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">

            <table  class="cont_t_list01">
				<caption>오류현황 기타</caption>
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
							<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:61%" value="" readonly onclick="javascript:doPop('buyerMulti','');">
							<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:80%" value="">
							<a href="javascript:doPop('masterWmCoTranBuyerPop','');"><img src="/resources/images/btn_search03.gif"></a>
							<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a>
						</td>
						<th>KeP팀명</th>
						<td>
							<select id="st_user_dept" name="st_user_dept" style="width:80%;height:20px"></select>
						</td>
						<th>&nbsp;&nbsp;
							<input type="checkbox" class="Noborder" id="st_user_check" name="st_user_check" value=""> 담당자 무시
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
			<img src="/resources/images/icon_r.gif" style="padding-top:3px;"/>&nbsp;미확인&nbsp;&nbsp;
			<img src="/resources/images/icon_g.gif" style="padding-top:3px;"/>&nbsp;확인&nbsp;&nbsp;
			<img src="/resources/images/icon_y.gif" style="padding-top:3px;"/>&nbsp;작업진행&nbsp;&nbsp;
			<img src="/resources/images/icon_prif_delete.gif" style="padding-top:3px;"/>&nbsp;작업대기&nbsp;&nbsp;
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
  			<span class="btn_05 mr04" ><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
  		</span>
	</div>

<!--내용 종료-->

</body>
</html>
