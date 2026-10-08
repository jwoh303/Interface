<%--
**********************************************
* 메뉴 : I/F 관리>진행현황>진행현황 메인
* 화면 : 다중 거래고객사 팝업
* 기능 : 
* 프로그램 ID : PG_11_M_001_01
* 담당자 : 최명진 ( 설계 : 김상근 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
	String st_user_dept = CommonUtil.nvl(request.getParameter("st_user_dept"),"");
	String st_user_check = CommonUtil.nvl(request.getParameter("st_user_check"),"");
	String st_com_name = CommonUtil.nvl(request.getParameter("st_com_name"),"");
	String st_gubun = CommonUtil.nvl(request.getParameter("Gubun"),"");
	String errorText = "발주";
	if("PO".equals(st_gubun)){
		errorText = "발주";
	}
	else if("IV".equals(st_gubun)){
		errorText = "납품";
		
	}else if("GR".equals(st_gubun)){
		errorText = "입고";
		
	}else if("RE".equals(st_gubun)){
		errorText = "견적";
		
	}else if("XX".equals(st_gubun)){
		errorText = "기타";
	}
	
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>거래 고객사 선택</title>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script> 
</head>

<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;
//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly,FrozenCol:0};
	initsheet.Cols = [
		 { Align:"Center",Width:60,		Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",			Header:"상태",				SaveName:"sStatus"}
		,{ Align:"Center",	Width:40,		Edit:true,	EditLen:30,	Hidden:false,	Type:"DummyCheck",	Header:"",						SaveName:"SELECTED"}
		,{ Align:"Center",	Width:100,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"고객사코드",		SaveName:"BUYER"}
		,{ Align:"Left",	Width:200,	Edit:false,	EditLen:95,	Hidden:false,	Type:"Text",				Header:"고객사명",			SaveName:"BUYER_NAME"}
		,{ Align:"Right",	Width:90,		Edit:false,	EditLen:190,	Hidden:false,	Type:"Text",				Header:"오류건수(발주)",	SaveName:"ERR_CNT"}
	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	mySheet.SetCountPosition(4); // 데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]

	// 하이퍼링크 설정
	setLinkCol(mySheet, "BUYER");
	var textError = '오류건수('+"<%=errorText%>"+')'
	mySheet.SetCellValue(0, 'ERR_CNT', textError);
	mySheet.SetCellText(0, 'ERR_CNT', textError);
	doAction("search");
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
	
	switch (str) {
		case "search": //조회
			current_page = -1;
			kepSearch(document.searchCondition, mySheet, "/wmco/getMasterWmCoTranBuyerPop.do", pagingMode);
			break;
	}
}

// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	var rowCnt = mySheet.RowCount();
	
	if ( rowCnt <= 0 ) return;
	
	if ( msg != "" ) {
		alert(msg);
	}
}

// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	grbRow = Row;
	
	if ( column == "BUYER" ) {
		var buyerCode = mySheet.GetCellValue(Row, "BUYER");
		openSearchPopup("/mdcp/showMasterMdCpCompyDetailViewPop.do","?com_code="+buyerCode, "800,600,no");
	}
	
	return;
}

// 확인
function kepConfirm()
{
	var sRow = mySheet.FindCheckedRow("SELECTED");
	
	if ( sRow.length <= 0 ) {
        alert("고객사를 선택하여 주십시요.");
        return;
	}
	
	var arrRow = sRow.split("|");
	var value1 = "";
	var value2 = mySheet.GetCellValue(arrRow[0], "BUYER_NAME");
	
	if ( arrRow.length > 1 ) {
		value2 += " 이외 " + (arrRow.length-1) + " 개 고객사";
	}
	
	for ( var idx = 0; idx < arrRow.length; idx++ ) {
		value1 += mySheet.GetCellValue(arrRow[idx], "BUYER")+"@";
		
	}
	
	opener.setPopupReturn(value1,value2);
	this.close();
}
</script> 
<body onload="kep_onload_view();">
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="st_user_id"  name="st_user_id" value="${sessionInfo.userId}">
	<input type="hidden" id="st_user_check"  name="st_user_check" value="<%=st_user_check%>">
	<input type="hidden" id="st_user_dept"  name="st_user_dept" value="<%=st_user_dept%>">
	<input type="hidden" id="st_gubun"  name="st_gubun" value="<%=st_gubun%>">	
	<div id="popWrapper" style="height:500px;">
    	<div id="popHeader">
        	<h1 class="title">거래 고객사 선택</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<!--버튼영역-->
            <div id="searchBtnA02">
				<span class="btn_search"><a href="javascript:doAction('search');">조회</a></span>
            </div>
            
            <!--조회영역-->
            <div id="cont_searchA">
            	<table  class="cont_t_list01"  style="width:100%">
					<caption>검색 리스트</caption>
					<colgroup>
						<col width="100px" />
						<col width="20%" />
						<col width="10px" /> 
                    	<col width="*" />
					</colgroup>						
					<tbody>
						<tr>
							<th>고객사명</th>
							<td> 
								<input type=text class="input_type_text" name="st_com_name"  id="st_com_name" size=20 value="<%=st_com_name%>" onkeydown="kepEnter()">
                            </td>
							<th></th>
							<td></td>
                         </tr> 
					</tbody>
				</table>
            </div>
            
            <!--grid-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "311px");
				</script>
			</div>
			<div id="pageindex"></div>
		</div>	
        <!--버튼영역-->
        <div class="btnArea mr25">
			<span class="fr">
				<span class="btn_02 mr04"><a href="javascript:kepConfirm()">확인</a></span>
			</span>
		</div>
        
    </div>
</form> 
</body>
</html>
