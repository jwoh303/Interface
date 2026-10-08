<%--
**********************************************
* 메뉴 : 회원사관리>계약관리>계약대상조회 
* 화면 : 표준계약서 조회 
* 기능 : 계약서 작성위한 표준계약서 조회
* 프로그램 ID : PG_02_M_002_01
* 담당자 : 이수영 ( 설계 : 권우재 )
* 착수일 : 2014-07-31
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
</head>
<%
String businessCond = (String)_sessionInfo.getBusinessCond();
String st_com_code = CommonUtil.nvl((String) request.getParameter("st_com_code"),"");  //  (조회조건)
String st_com_name = CommonUtil.nvl((String) request.getParameter("st_com_name"),"");  //  (조회조건)
%>

<script type="text/javascript">
<!--
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Center",	Width:60,		Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",			Header:"상태",						SaveName:"sStatus"}
					,{ Align:"Center",		Width:60,		Edit:true,	EditLen:100,	Hidden:false,	Type:"Radio",				Header:"선택",						SaveName:"SELECTED"}
					,{ Align:"Left",		Width:260,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"서식번호",					SaveName:"FORM_NO"}
					,{ Align:"Left",		Width:270,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"표준계약서 서식명",		SaveName:"FORM_NAME"}
					,{ Align:"Center",		Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"생성일",						SaveName:"ADD_DATE"}
					,{ Align:"Center",		Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"필수 첨부 서식수",		SaveName:"RFORM_CNT"}
					,{ Align:"Center",		Width:90,		Edit:true,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"회원사유형",				SaveName:"FORM_TYPE"}

	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "FORM_NAME");	//계약번호
}

var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if (str =="regi"&& selectedGrid.length == 0) {
		alert("표준계약서식을 선택하세요.");
		return;
	}
	switch (str) {
		case "search":	 // 조회
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mdct/getMasterMdCtStndrdContractPop.do" , pagingMode );
			break;
		
		case "reload":	// 초기화
			kepReload('searchCondition');
				mySheet.RemoveAll();
			break;
		case "kepUser":
			kepAjaxCommonQueryIdSearchTwoCombo('st_kep_user_id','master.mdct.selectMasterMdCtContractProgressKepUserList', $("#st_user_dept").val(), '', 'ALL','');	
			break;	
		case "del": // 취소
			if (mySheet.GetCellValue(selectedGrid, "sStatus") != "TMP") {
				alert("임시저장상태의 데이터만 삭제가능합니다.");
				return;
			}
	
			if (!confirm('선택한 항목을 삭제 하시겠습니까?'))
				return;
			kepSave(document.searchCondition ,  mySheet , "/mdct/delMasterMdCtContractProgressList.do" , "SELECTED" );
			break;
	}
}

//팝업함수호출
function doPop(str, val) {
	popupSel = str;
	
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	if (str =="regi" && selectedGrid.length == 0) {
		alert("표준계약서식을 선택하세요.");
		return;
	}
	
	switch (str) {
		case "company":
			var business_cond = "";
			if ($("#st_company_type").val() == "C002") {
				business_cond = "S";
			} else {
				business_cond = "B";
			}
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=" + business_cond + "&MULTI=N", "500,466,no");
			break;
		case "constract": // 고객사 M
			openSearchPopup("/mdct/showMasterMdCtStndrdContractDetailPop.do", "?st_form_no=" + val, "820,700,no");
			break;
		case "regi": // 고객사 M
			if ($("#st_com_code").val() == "") {
				alert("회원사를 선택해주세요.");
				$("#st_com_name").focus();
				return;
			}
			openSearchPopup("/mdct/showMasterMdCtContractRegPop.do", "?st_com_code=" + $("#st_com_code").val() + "&st_form_no=" + mySheet.GetCellValue(selectedGrid,"FORM_NO") + "&st_company_type=" + $("#st_company_type").val() + "&st_biz_type=" + $("#st_biz_type").val(), "820,700,no");
			break;		
	}
}

//그리드 표시후 처리	 
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
function mySheet_OnSaveEnd(code, msg) {
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
	kepSearch(document.searchCondition ,  mySheet , "/mdct/getMasterMdCtContractProgressList.do?page="+current_page , pagingMode );
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'FORM_NAME') { // 요청자
		doPop('constract',  mySheet.GetCellValue(Row,"FORM_NO"));
		
	}
	return;
}

function setReturn(value1,value2) { 
  opener.setPopupReturn(value1,value2);
  this.close();
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text) {
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "regi") {	// 다중 고객사
		setReturn("OK","");
	} else 	if (popupSel == "company") {	// 다중 고객사
		$("#st_com_code").val(code);
		$("#st_com_name").val(text);
	}
}
 //-->
</script> 
<body onload="kep_onload_view();">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:510px;">
    	<div id="popHeader">
        	<h1 class="title">표준계약서 조회 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--버튼영역-->
       	 <div id="popContainer" style="height:432px">
	       	<div id="searchBtnA" style="width:100%"  >
	        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
			    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
	   		</div>   
	        <!--팝업내용입니다-->
       
           	<form name="searchCondition" id="searchCondition" method="post" >
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			
			<div id="cont_searchA">
				<table  class="cont_t_list01" style="width:580px;">
					<caption>표준계약서 조회</caption>
						<colgroup>
						<col width="15%" />
						<col width="45%" />
						<col width="15%" />
						<col width="*" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">사업구분</th>
							<td>
								<select id="st_biz_type" name="st_biz_type" style="width:50%">
									<option value="C001" selected>구매대행</option>
									<option value="C002">유통</option>						
								</select>
							</td>
							<th scope="row">회원사유형</th>
							<td>
								<select id="st_company_type" name="st_company_type" style="width:80%">
									<option value="C002" selected>협력사</option>
									<option value="C001">고객사</option>
								</select>
							</td>
						</tr>
						<tr>
							<th scope="row">회원사</th>
							<td>
								<input type="text" class="input_type_text" name="st_com_name" id="st_com_name" style="width:70%" value="<%=st_com_name %>" readonly onclick="javascript:doPop('company');">
								<input type="hidden" name="st_com_code" id="st_com_code" style="width:80%" value="<%=st_com_code%>">
								<a href="javascript:doPop('company');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_com_code','st_com_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th scope="row">서식분류</th>
							<td>
								<select id="st_form_type" name="st_form_type" style="width:80%">
									<option value="C">거래약정</option>
									<option value="E">기타</option>
									<option value="P">프로모션</option>
									<option value="S">시즌</option>
								</select>
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
			<br />
			<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "214px");
  				</script>
  			</div>
  			<p class="paging" id="pageindex"></p>
 						
			<!--버튼영역-->
			<div class="btnArea mt10 mb05">
				<span class="fl">
					<span class="btn_04"><a href="javascript:doPop('regi');">계약서 작성</a></span>
				</span>
			</div>
			</form>
		</div>	
	</div>
</body>
</html>
