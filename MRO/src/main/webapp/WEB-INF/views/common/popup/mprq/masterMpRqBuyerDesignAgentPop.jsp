<%--
**********************************************
* 메뉴 : 
* 화면 : 고객사 지정 협력사 관리 팝업
* 기능 : 
* 프로그램 ID : 
* 담당자 : HSJ
* 착수일 : 2021-03-15
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="java.util.Map"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script> 
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
<%
@SuppressWarnings (value="unchecked")
Map<String,String> _infoMap = (Map<String,String>) request.getAttribute("info"); // 조회된 결과

String st_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");
String st_agent = CommonUtil.nvl((String) request.getParameter("st_agent"),"");
%>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow;

//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function initPage() {
	var initsheet = {};
	initsheet.HeaderMode = {Sort : 0, ColMove : 0, ColResize : 0};
	initsheet.Cols = [  
	      			{Align : "Center",	SaveName : "sStatus",			Header : "상태|상태",			Type : "Status",	Width : 60,		Hidden : true}, 
	    			{Align : "Center", 	SaveName : "SELECTED",			Header : "|",				Type : "Radio",		Width : 30,		EditLen : 50},
	    			{Align : "Center",	SaveName : "ADD_DATE",			Header : "등록일|등록일",		Type : "Date",		Width : 90,		EditLen : 110,	Edit : false},
	    			{Align : "Center",	SaveName : "REQ_DEPT_NAME",		Header : "요청자 정보|부서명",	Type : "Text",		Width : 200,	EditLen : 110,	Edit : true},
	    			{Align : "Center",	SaveName : "REQ_USER_NAME",		Header : "요청자 정보|담당자명",	Type : "Text",		Width : 100,	EditLen : 110,	Edit : true},
	    			{Align : "Center",	SaveName : "REQ_USER_TEL",		Header : "요청자 정보|전화번호",	Type : "Text",		Width : 120,	EditLen : 110,	Edit : true},
	    			{Align : "Center",	SaveName : "DEL_DATE",			Header : "삭제일|삭제일",		Type : "Date",		Width : 100,	EditLen : 110,	Edit : false},
	    			{Align : "Center",	SaveName : "AGENT_CHOICE_SEQ",	Header : "|",				Type : "Text",		Width : 100,	EditLen : 110,	Edit : false,	Hidden : true},
	    			{Align : "Center",	SaveName : "STATUS",			Header : "|",				Type : "Text",		Width : 90,		EditLen : 110,	Edit : false,	Hidden : true}
	];
	
	initsheet.Cfg = {MergeSheet:msHeaderOnly};
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	kepSearch(document.searchCondition, mySheet, "/mprq/getMasterMpRqBuyerDesignAgentList.do", pagingMode);
}

function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)) return;
	var totRow = mySheet.RowCount();
	if( totRow<= 0) return;

	for(var i=1; i<=totRow+1;i++){
		mySheet.SetCellEditable(i,"REQ_DEPT_NAME", 0);
		mySheet.SetCellEditable(i,"REQ_USER_NAME", 0);
		mySheet.SetCellEditable(i,"REQ_USER_TEL", 0);
	}
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
	grbRow = Row;
}

//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if (msg != "") {
		alert(msg);
	}
	
	if (code > 0) {
		//저장 성공시 재조회
		doAction('search');
	}
}

//기능함수
function doAction(str) {
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");

	//선택된 항목 유무 체크
	if (str !="search" && str !="add" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}
	
	switch (str) {
		case "search": // 조회
			current_page = -1;
			kepSearch(document.searchCondition, mySheet, "/mprq/getMasterMpRqBuyerDesignAgentList.do", pagingMode);
			break;
		case "add": // 추가
			var rows = mySheet.DataInsert(-1);
			grbRow = rows;
			mySheet.SetCellValue(rows, 'SELECTED', "1");
			break;
		case "save": // 저장
			var value1 = mySheet.GetCellValue(grbRow, "sStatus");
			var value2 = mySheet.GetCellValue(grbRow, "STATUS");
			var value3 = mySheet.GetCellValue(grbRow, "REQ_DEPT_NAME");
			var value4 = mySheet.GetCellValue(grbRow, "REQ_USER_NAME");
			var value5 = mySheet.GetCellValue(grbRow, "REQ_USER_TEL");
		
			if(value1 == "U"){
				alert("행추가 항목만 저장이 가능합니다.");
				return;
			}
			if(value2 == "D"){
				alert("삭제된 정보는 선택할 수 없습니다.");
				return;
			}
			if(value3 == '' || value4 == '' || value5 == ''){
				alert("부서명, 담당자명, 전화번호 필수 입력입니다.");
				return;
			}
			
			if (!confirm('선택된 항목을 저장 하시겠습니까?')) return;
			kepSave(document.searchCondition ,  mySheet , "/mprq/saveMasterMqRqBuyerDesignAgentList.do" , "SELECTED" );
			break;
		case "del": // 삭제
			var value1 = mySheet.GetCellValue(grbRow, "sStatus");
			var value2 = mySheet.GetCellValue(grbRow, "STATUS");
			
			if(value1 == "I"){
				alert("행추가 항목 저장한 후 삭제하시기 바랍니다.");
				return;
			}
			if(value2 == "D"){
				alert("이미 삭제된 건입니다.");
				return;
			}
			
			if (!confirm('선택된 항목을 삭제 하시겠습니까?')) return;
			kepSave(document.searchCondition ,  mySheet , "/mprq/delMasterMpRqBuyerDesignAgentList.do" , "SELECTED" );
			break;
		case "bid": // 확인
			var value1 = mySheet.GetCellValue(grbRow, "sStatus");
			var value2 = mySheet.GetCellValue(grbRow, "STATUS");
			var value3 = mySheet.GetCellValue(grbRow, "REQ_DEPT_NAME");
			var value4 = mySheet.GetCellValue(grbRow, "REQ_USER_NAME");
			var value5 = mySheet.GetCellValue(grbRow, "AGENT_CHOICE_SEQ");
			
			if(value1 == "I"){
				alert("행추가 항목 저장한 후 선택하시기 바랍니다.");
				return;
			}
			if(value2 == "D"){
				alert("삭제된 정보는 선택할 수 없습니다.");
				return;
			}
			opener.setPopupReturn(value3,value4,value5);
			this.close();
			break;
	}
}
</script>
<title>코리아 e 플랫폼</title>
</head>

<body onload="initPage();">

<!--조회영역-->
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="1000">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper">
    	<div id="popHeader">
        	<h1 class="title">고객사 지정 협력사 관리</h1>
            <p class="popClose"><a href="javascript:self.close();"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        
        <!--팝업내용입니다-->
        <div id="popContainer">
        
        	<div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span>  
            </div> 
	       	
	       	<!--조회영역-->
            <div id="cont_searchA">
            	<table class="cont_t_list01" style="width:100%">
						<caption>SG리스트</caption>
						<colgroup>
							<col width="10%" />
							<col width="34%" />
                            <col width="10%" />
                            <col width="34%" />
                            <col width="*" />
						</colgroup>						
						<tbody>
						<tr>
							<td>고객사명</td>
							<td> 
								<input type="hidden" name="st_buyer" id="st_buyer" value="<%=_infoMap.get("BUYER")%>" onkeydown="kepEnter()" class="input_type_text" style="width:80%;" readonly>
								<input type="text" name="st_buyer_name" id="st_buyer" value="<%=_infoMap.get("BUYER_NAME")%> (<%=_infoMap.get("BUYER")%>)" onkeydown="kepEnter()" class="input_type_text" style="width:80%;" readonly> 
                            </td>
						    <td>협력사명</td>						 
							<td>
								<input type="hidden" name="st_agent" id="st_agent" value="<%=_infoMap.get("AGENT")%>" onkeydown="kepEnter()" class="input_type_text" style="width:80%;" readonly>
								<input type="text" name="st_agent_name" id="st_agent" value="<%=_infoMap.get("AGENT_NAME")%> (<%=_infoMap.get("AGENT")%>)" onkeydown="kepEnter()" class="input_type_text" style="width:80%;" readonly>
							</td>
							<td><input type="checkbox" class="input_type_text" id="ck_del_except" name="ck_del_except" value="Y" checked/> 삭제제외</td>
						</tr>					 
					</tbody>
				</table>
            </div>
	       	
	       	<!--grid-->
 			<div style="border-top:2px solid #3c639c">
					<script type="text/javascript">
						createIBSheet("mySheet", "", "200px");
					</script>
			</div>
        </div>
        
        <div class="mt10 mr25" style="height:25px;">
			<span class="fr">
				<span class="btn_02 mr04"><a href="javascript:doAction('add');">행추가</a></span>
				<span class="btn_02 mr04"><a href="javascript:doAction('save')">저장</a></span>
				<span class="btn_02 mr04"><a href="javascript:doAction('del')">삭제</a></span>
				<span class="btn_02"><a href="javascript:doAction('bid');">확인</a></span>
			</span>
		</div>
    </div>
    </form>
</body>
</html>
