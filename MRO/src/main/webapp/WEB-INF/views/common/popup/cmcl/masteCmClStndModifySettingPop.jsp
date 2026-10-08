<%--
**********************************************
* 메뉴 : 수정사유선택
* 화면 : 수정사유선택
* 기능 : 
* 프로그램 ID : 
* 담당자 : 현명환
* 착수일 : 
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
	String st_kep_irs		= CommonUtil.nvl((String)request.getParameter("st_kep_irs"),"");
	String st_sup_email	= CommonUtil.nvl((String)request.getParameter("st_sup_email"),"");
	String st_issueDate	= CommonUtil.nvl((String)request.getParameter("st_issueDate"),"");
	String st_gbn	= CommonUtil.nvl((String)request.getParameter("st_gbn"),"");
	
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>세금 계산서 적요수정</title>
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
	var unit01 = KepSheetComboData("TX11", "");											// IBSHEET : 스마트빌 상태
	var unit02 = KepSheetComboData("TX15", "");											// IBSHEET : 스마트빌 상태
	initsheet.Cfg = {MergeSheet:msHeaderOnly,FrozenCol:0};
	initsheet.Cols = [
        		 { Align:"Center",Width:60,		Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",			Header:"상태",				SaveName:"sStatus"}
         		,{ Align:"Center",	Width:40,		Edit:true,	EditLen:30,	Hidden:false,	Type:"Radio",	Header:"",						SaveName:"SELECTED"}
         		,{ Align:"Left",	Width:80,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",				Header:"작성일자",				SaveName:"CREATION_DATE"}
         		,{ Align:"Left",	Width:160,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",				Header:"국세청번호",				SaveName:"ISSUE_ID"}
         		,{ Align:"Left",	Width:160,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",				Header:"거래처",				SaveName:"IRS_NAME"}
         		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",				Header:"사업자번호",				SaveName:"IRS_NO"}
         		,{ Align:"Left",	Width:60,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Combo",				Header:"세무구분",				SaveName:"DTI_TYPE",	ComboText:unit02.ComboText, 	ComboCode:unit02.ComboCode}
         		,{ Align:"Left",	Width:90,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Combo",				Header:"세금계산서상태",				SaveName:"DTI_STATUS" ,	ComboText:unit01.ComboText, 	ComboCode:unit01.ComboCode}
         		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:200,	Hidden:false,	Type:"Text",				Header:"세금계산서",				SaveName:"SEQ_ID"}
         		
	];

	IBS_InitSheet(mySheet, initsheet, pagingMode);
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
			kepSearch(document.searchCondition ,  mySheet , "/cmcl/getMasterCmClStndSettingModifyPop.do" , pagingMode );
			break;
		case "confirm": //발행
			var st_issue_id = "";
			var cnt =0;
			for ( var i =1; i < mySheet.RowCount()+1;i++) {
				if ( mySheet.GetCellValue(i, "SELECTED") == 1) {
					st_issue_id = mySheet.GetCellValue(i, "ISSUE_ID");
					cnt++;
				}
			}
			if(cnt > 1){
				alert("다중 선택은 불가능 합니다.");
				return;
			}
			if(st_arps_group1 =="02"||st_arps_group1=="01"){
				if(cnt ==0){
					alert("선택한건이 없습니다.");
					return;					
				} 
			}
			var st_arps_group1 = $("input[name=arps_group1]:checked").val();

			opener.setPopupReturn(st_arps_group1,st_issue_id);
			this.close();
			break;
		case "amendCode": //조회
		
			var st_arps_group1 = $("input[name=arps_group1]:checked").val();
			if(st_arps_group1 == "01"){
				doAction("search");
			}else{
				mySheet.RemoveAll();
			}
			break;
	}

}



// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");

}

// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if ( msg != "" ) {
		alert(msg);
	}

	if ( code > 0 ) {
		//저장 성공시 처리
		opener.doAction("search");
		this.close();
	}
}

// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	
	grbRow = Row;
	
	return;
}

</script> 
<body onload="kep_onload_view();">
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="st_kep_irs" name="st_kep_irs"  value="<%=st_kep_irs%>">
	<input type="hidden" id="st_sup_email" name="st_sup_email"	value="<%=st_sup_email%>">
	<input type="hidden" id="st_issueDate" name="st_issueDate"	value="<%=st_issueDate%>">
	<input type="hidden" id="st_gbn" name="st_gbn"	value="<%=st_gbn%>">
	<div id="popWrapper" style="height:250px;">
    	<div id="popHeader">
        	<h1 class="title">수정사유선택</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<!--버튼영역-->
            <div id="searchBtnA02"></div>
		   <table class="cont_t_list06 mb15" summary="제안 평가" style="width:100%;">
			   <caption>수정사유선택</caption>
					<colgroup>
						<col width="3%"/>
						<col width="30%"/>
						<col width="*"/>
					</colgroup>
					<tbody>
						<tr>
							<th style="text-align: center">
								<input type="radio" name="arps_group1" id="arps_group1" value="02"  onclick="doAction('amendCode');"/></th>
				    		<th>기재사항 착오정정 등 (당초세금계산서의 부(-)의 세금계산서 작성)</th>
				    		<td scope="row" >부(-)의 세금 계산서를 발행하고(작성일자:당초 작성일) 정정된 내용의(+) 세금계산서를 발행 합니다.<br>(작성일자: 당초 작성일이 원칙이나 작성일자를 잘못 기재한 경우에는 올바른 작성일자 기재)</td>
						</tr>
						<tr>
							<th style="text-align: center">
								<input type="radio" name="arps_group1" id="arps_group1"  value="01"  onclick="doAction('amendCode');"/></th>
				    		<th>기재사항 착오정정 등 (정정된 세금계산서 작성)</th>
				    		<td scope="row" >기재사항 등을 착오 또는 착오 외의 사유로 잘못 발급한 경우, 세율을 잘못 적용하여 발급한 경우</td>
						</tr>
						<tr>
							<th style="text-align: center">
								<input type="radio" name="arps_group1" id="arps_group1" value="06"  onclick="doAction('amendCode');"/></th>
				    		<th>착오에 의한 이중 발급 등</th>
				    		<td scope="row" >착오로 이중 발급한 경우, 면세 등 발급대상이 아닌 거래 등에 대하여 발급한 경우. 부(-)의 세금계산서를 발행 합니다.<br>(작성일자: 당초 작성일)</td>
						</tr>
						<tr>
							<th style="text-align: center">
								<input type="radio" name="arps_group1" id="arps_group1" value="04"  onclick="doAction('amendCode');"/></th>
				    		<th>계약의 해제</th>
				    		<td scope="row" >부(-)의 세금계산서를 발행합니다.<br>(작성일자: 계약 해제일) 비고1란: 당초 작성일 기재</td>
						</tr>
		        	</tbody>
		   </table>
            <!--grid-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "140px");
				</script>
			</div>	
		</div>	
        <!--버튼영역-->
        <div class="btnArea mr25">
			<span class="fr">
				<span class="btn_02 mr04"><a href="javascript:doAction('confirm');">발행</a></span>
			</span>
       </div>
        
    </div>
</form> 
</body>
</html>
