<%--
**********************************************
* 메뉴 : 담당자셋팅
* 화면 : 담당자셋팅
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
	String st_buyer_code		= CommonUtil.nvl((String)request.getParameter("buyer_code"),"");
	String st_buyer_irs_no	= CommonUtil.nvl((String)request.getParameter("buyer_irs_no"),"");
	String st_buyer_name	= CommonUtil.nvl((String)request.getParameter("buyer_name"),""); 
	String confirm_flag	= CommonUtil.nvl((String)request.getParameter("confirm_flag"),"");
	
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>담당자셋팅</title>
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
         		,{ Align:"Left",	Width:120,	Edit:true,	EditLen:200,	Hidden:false,	Type:"Text",				Header:"담당자명",		SaveName:"USER_NAME_LOC", BackColor:"${notnullColor}", KeyField:true}
         		,{ Align:"Left",	Width:200,	Edit:true,	EditLen:200,	Hidden:false,	Type:"Text",				Header:"이메일",				SaveName:"EMAIL", BackColor:"${notnullColor}", KeyField:true}
         		,{ Align:"Left",	Width:160,	Edit:true,	EditLen:200,	Hidden:false,	Type:"Text",				Header:"전화번호",				SaveName:"PHONE_NUMBER"}
         		,{ Align:"Left",	Width:160,	Edit:true,	EditLen:200,	Hidden:false,	Type:"Text",				Header:"팩스",				SaveName:"FAX_NUMBER"}
         		,{ Align : "Center",SaveName : "PRIORITY",	Header : "",	Type : "Radio", Width : 60,	EditLen : 50, Edit:true, Hidden:false, Header:"메인"}
         		,{ Align:"Left",	Width:400,	Edit:false,	EditLen:200,	Hidden:true,	Type:"Text",				Header:"ACCOUNTING_CODE",				SaveName:"ACCOUNTING_CODE"}
         		
	];

	IBS_InitSheet(mySheet, initsheet, pagingMode);
	
	doAction( "search");
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
			kepSearch(document.searchCondition ,  mySheet , "/cmcl/getMasterCmClStndSettingPop.do" , pagingMode );
			break;
		case "add": // 추가
			var rows = mySheet.DataInsert(-1);
			mySheet.SetCellValue(rows, "SELECTED", "1");
		break;
		case "save": // 저장
			for ( var i =1; i < mySheet.RowCount()+1;i++) {
				mySheet.SetCellValue(i, "SELECTED", "1"); 
				if ( mySheet.GetCellValue(i, "SELECTED") == 1) {
					if(mySheet.GetCellValue(i, "USER_NAME_LOC") == ""||mySheet.GetCellValue(i, "USER_NAME_LOC") == null){
						alert(i+"번째 담당자명 정보가 없습니다.");
						return;
					}
					if(mySheet.GetCellValue(i, "EMAIL") == ""||mySheet.GetCellValue(i, "EMAIL") == null){
						alert(i+"번째 EMAIL 정보가 없습니다.");
						return;
					}
					if ( !kepIsValidEmailValue(mySheet.GetCellValue(i, "EMAIL")) ) {
						alert(i + "번째 EMAIL이 형식에 맞지 않습니다.");
						return;
					}
				
				}
			}
			if ( !confirm('선택한 항목을 저장 하시겠습니까?') )
				return;
			kepSave(document.searchCondition ,  mySheet , "/mdcm/saveMasterCmClStndSettingPop.do" , "SELECTED" );
			break;
		case "del": // 삭제
			if ( !confirm('선택한 항목을 삭제 하시겠습니까?') )
				return;
			if ( !beforeProcessDelete() )
				return;
			kepSave(document.searchCondition ,  mySheet , "/mdcm/delMasterCmClStndSettingPop.do" , "SELECTED" );
			break;
		case "confirm": //확인
			var userNameLoc = "";
			var phoneNumber = "";
			var email = "";
			var cnt =0;
			for ( var i =1; i < mySheet.RowCount()+1;i++) {
				if ( mySheet.GetCellValue(i, "SELECTED") == 1) {
					userNameLoc = mySheet.GetCellValue(i, "USER_NAME_LOC");
					phoneNumber = mySheet.GetCellValue(i, "PHONE_NUMBER");
					email = mySheet.GetCellValue(i, "EMAIL");
					cnt++;
				}
			}
			if(cnt > 1){
				alert("다중 선택은 불가능 합니다.");
				return;
			}
			opener.setPopupReturn(userNameLoc,phoneNumber,email);
			this.close();
			break;
	}

}

// 변경 여부 체크
function checkRow() {
	var check = true;
	
	for ( var i = 1; i <= mySheet.RowCount(); i++ ) {
		if ( mySheet.GetCellValue(i, "sStatus") != 'R' ) {
        	check = false;
        	break;
		}
	}
	
	if ( check ) {
		alert("변경된 항목이 없습니다.");
		return false;
	}
	
	return true;
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

//행삭제 선행 처리
function beforeProcessDelete() {
	for ( var i = mySheet.RowCount(); i >= 1; i-- ) {
		if ( mySheet.GetCellValue(i, "SELECTED") == 1 && mySheet.GetCellValue(i, "sStatus") == 'I' ) {
			mySheet.RowDelete(i, 0);
		}
	}
	
	if ( mySheet.FindCheckedRow("SELECTED").length == 0 ) {
		return false;
	}
	
	return true;
}
</script> 
<body onload="kep_onload_view();">
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id=st_user_id  name="st_user_id" value="${sessionInfo.userId}">
	<input type="hidden" id="st_buyer_code" name="st_buyer_code"  value="<%=st_buyer_code%>">
	<input type="hidden" id="st_buyer_irs_no" name="st_buyer_irs_no"	value="<%=st_buyer_irs_no%>">
	<input type="hidden" id="st_sys_type" name="st_sys_type"	value="KA">
	
	<div id="popWrapper" style="height:250px;">
    	<div id="popHeader">
        	<h1 class="title">회원사 담당자</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<!--버튼영역-->
            <div id="searchBtnA02"></div>
        	<table class="cont_t_list06">
            	<caption>리스트</caption>
                <colgroup>
                    <col width="20%" />
                    <col width="30%" />
                    <col width="20%" />
                    <col width="30%" />
                </colgroup>
                <tbody>
                	<tr>
                      <th>회원사명</th>
                      <td><%=st_buyer_name%></td>
                      <th>사업자번호</th>
                      <td><%=st_buyer_irs_no%></td>
                	</tr>
                </tbody>
            </table>
            <!--grid-->
 			<div style="border-top:2px solid #3c639c">
				<script type="text/javascript">
					createIBSheet("mySheet", "", "180px");
				</script>
			</div>
		</div>	
        <!--버튼영역-->
        <div class="btnArea mr25">
			<span class="fr">
				<span class="btn_02 mr04"><a href="javascript:doAction('add');">행추가</a></span>
				<%if(confirm_flag.equals("Y")){ %>
				<span class="btn_02 mr04"><a href="javascript:doAction('confirm');">확인</a></span>
				<%} %>
				<span class="btn_02 mr04"><a href="javascript:doAction('save');">저장</a></span>
				<span class="btn_02"><a href="javascript:doAction('del');">삭제</a></span>
			</span>
       </div>
        
    </div>
</form> 
</body>
</html>
