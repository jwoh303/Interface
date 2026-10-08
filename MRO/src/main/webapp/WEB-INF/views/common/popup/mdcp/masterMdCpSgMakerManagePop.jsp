<%--
**********************************************
* 메뉴 : 회원사관리>협력사관리>SG별 제조사관리
* 화면 : SG별 제조사관리
* 기능 : 임시협력사의 SG별 제조사 관리
* 프로그램 ID : PG_01_M_007_01
* 담당자 : 이수영 ( 설계 : 권우재 )
* 착수일 : 2014-
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
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("compyData"); // 조회된 결과

String st_buyer_code=  CommonUtil.nvl((String) request.getParameter("st_buyer_code"), "");
String st_agent_code=  CommonUtil.nvl((String) request.getParameter("st_agent_code"), "");

String _userRole = "NO";
Map<String,String> _rowData = null;
if (_dataList != null && _dataList.size() != 0) { 
	_rowData = _dataList.get(0);
	_userRole =CommonUtil.nvl((String)  _rowData.get("USER_ROLE"), "NO");
}
%>

<script type="text/javascript">
<!--
var mySheet = new ibsheetObject();
var mySheet2 = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";

//최초 화면 함수 
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Center",	Width:60,		Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",			Header:"상태",				SaveName:"sStatus"}
					,{ Align:"Center",		Width:40,		Edit:true,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:"",						SaveName:"SELECTED"}
					,{ Align:"Center",		Width:90,		Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"상태코드",			SaveName:"APPROVAL_FLAG"}
					,{ Align:"Center",		Width:90,		Edit:false,	EditLen:90,	Hidden:false,	Type:"Html",				Header:"상태",				SaveName:"APPROVAL_TEXT"}
					,{ Align:"Center",		Width:90,		Edit:false,	EditLen:300,	Hidden:false,	Type:"Text",				Header:"SG코드",			SaveName:"SG_ID"}
					,{ Align:"Left",		Width:166,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"SG명",				SaveName:"SG_NAME"}
					,{ Align:"Center",		Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"제조사건수",		SaveName:"TNT"}
					,{ Align:"Center",		Width:80,		Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"제조사건수",		SaveName:"SIN_CON"}
					,{ Align:"Center",		Width:80,		Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"제조사건수",		SaveName:"DEL_CON"}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	mySheet.SetCountPosition(3);
	
	var initsheet2 = {};
	initsheet2.Cols = [ 
					 { Align:"Center",	Width:60,		Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",			Header:"상태",				SaveName:"sStatus"}
					,{ Align:"Center",		Width:40,		Edit:true,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:"",						SaveName:"SELECTED"}
					,{ Align:"Center",		Width:90,		Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"상태",				SaveName:"STATUS"}
					,{ Align:"Center",		Width:90,		Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"상태코드",			SaveName:"APPROVAL_FLAG"}
					,{ Align:"Center",		Width:90,		Edit:false,	EditLen:90,	Hidden:false,	Type:"Html",				Header:"상태",				SaveName:"APPROVAL_TEXT"}
					,{ Align:"Left",		Width:138,	Edit:false,	EditLen:300,	Hidden:false,	Type:"Text",				Header:"제조사명",			SaveName:"MAKER_NAME"}
					,{ Align:"Left",		Width:138,	Edit:false,	EditLen:300,	Hidden:true,	Type:"Text",				Header:"제조사코드",		SaveName:"MAKER_CODE"}
					,{ Align:"Center",		Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"작업자",				SaveName:"USER_NAME"}
					,{ Align:"Left",		Width:118,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"작업일",				SaveName:"CREATE_DATE"}
	];
	
	IBS_InitSheet(mySheet2, initsheet2, pagingMode);
	mySheet2.SetCountPosition(3);

	//하이퍼링크 설정
	setLinkCol(mySheet, "TNT");	//매핑건수

}

function kepEnter() {	
	if (event.keyCode == 13) { 
		kepSearch();
	}
}

var st;
//기능함수
function doAction(str) {
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var selectedGrid2 = mySheet2.FindCheckedRow("SELECTED");

	switch (str) {
		case "search1":	 //조회
			current_page = -1;
			kepSearch(document.searchCondition1,  mySheet , "/mdcp/getMasterMdCpSgMakerManagePopKepSgList.do", pagingMode );
			mySheet2.RemoveAll();
			$("#st_sg_id").val("");
			$("#sg_name").text("");
			break;
		case "search2":	 //조회
			if ($("#st_sg_id").val() == "") {
				alert("SG를 선택해 주십시요.");
				return;
			}
			current_page = -1;
			kepSearch(document.searchCondition2,  mySheet2 , "/mdcp/getMasterMdCpSgMakerManagePopKepMkList.do", pagingMode );
			break;
		case "saveRemark":	 //사유 저장
			if ($("#st_s_remark").val() == "") {
				alert("선정 사유를 입력하여 주세요.");
				return;
			}
			kepAjaxFormCall("/mdcp/saveMasterMdCpSgMakerManagePopRemark.do", "contentCondition", str);
			break;
		
		case "delSg":		//SG코드 삭제
			if (mySheet.RowCount() == 0) {
				alert("조회된 내역이 없습니다.\n확인바랍니다.");
				return;
			}
			
			if (selectedGrid.length == 0) {
				alert("삭제할 SG코드를 선택바랍니다.");
				return;
			}
			if (confirm("SG코드를 삭제 하시겠습니까?")) {
				kepSave(document.searchCondition1, mySheet, "/mdcp/deleteMasterMdCpSgMakerManagePopKepSgList.do", "SELECTED");
			}
			break;
		case "addMk":	 //제조사 추가
			kepSave(document.searchCondition2, mySheet2, "/mdcp/saveMasterMdCpSgMakerManagePopKepMkList.do", -1 );
			break;	
		case "delMk":	 //제조사 삭제
			if (mySheet2.RowCount() == 0) {
				alert("조회된 내역이 없습니다.\n확인바랍니다.");
				return;
			}

			if (selectedGrid2.length == 0) {
				alert("삭제할 제조사를 선택 바랍니다.");
				return;
			}
			
			if (confirm("제조사를 삭제 하시겠습니까?")) {
				kepSave(document.searchCondition2, mySheet2, "/mdcp/deleteMasterMdCpSgMakerManagePopKepMkList.do", "SELECTED");
			}
			break;
		case "modMk":	 //제조사 복원
			if (mySheet2.RowCount() == 0) {
				alert("조회된 내역이 없습니다.\n\n확인바랍니다.");
				return;
			}
			if (selectedGrid2.length == 0) {
				alert("복원할 제조사를 선택 바랍니다.");
				return;
			}
			
			if (confirm("제조사를 복원 하시겠습니까?")) {
				kepSave(document.searchCondition2, mySheet2, "/mdcp/updateMasterMdCpSgMakerManagePopModMkList.do", "SELECTED");
			}
			break;	
		case "confMk":	 //제조사 승인
			if (mySheet2.RowCount() == 0) {
				alert("조회된 내역이 없습니다.\n\n확인바랍니다.");
				return;
			}
		
			if (selectedGrid2.length == 0) {
				alert("승인할 제조사를 선택 바랍니다.");
				return;
			}
			
			if (confirm("제조사를 승인 하시겠습니까?")) {
				kepSave(document.searchCondition2, mySheet2, "/mdcp/updateMasterMdCpSgMakerManagePopConfMkList.do", "SELECTED");
			}
			break;		
	}
}

//팝업함수호출
function doPop(str, val1, val2) {
	popupSel = str;
	
	switch (str) {
		case "addSg":				// SG코드 선택
			openSearchPopup('/coco/getCommonCoCoTranGoodsPop.do','','600,500,no');
			break;
		case "addMk":				// 제조사 선택
			if ($("#st_sg_id").val() == "") {
				alert("SG를 선택해 주십시요.");
				return;
			}
			if ($("#st_old_s_remark").val() == "") {
				alert("S그룹 협력사 선정 사유가 없습니다.\n\n확인후 입력 바랍니다.");
				return;
			}
			openSearchPopup('/common/agentRegMakerCodePop.do', '','500,500,no');
			break;	
		case "seller":					// 협력사 M
			openSearchPopup('/common/icomcmpyPop.do','?BUSINESS_COND=S&MULTI=N','500,466,no');
			break;	
		case "sgCnt":					// 고객사 M
			openSearchPopup('/mdcp/showMasterMdCpSgMakerManagePop.do','?st_buyer_code=' + val1 + '&st_agent_code=' + val2,'1000,530,no');
			break;		
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text) {
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "addSg") {	// 다중 고객사
		for (var i=1; i <= mySheet.RowCount(); i++ ) {
			if ($.trim(mySheet.GetCellValue(i, "SG_ID")) == code) {
				alert("이미 등록되어 있는 SG 입니다.\n\n확인 바랍니다.");
				return;
			}
		}

		var rows = mySheet.DataInsert(-1);
		mySheet.SetCellValue(rows, "APPROVAL_TEXT", "품의대상<br />(신규)");
		mySheet.SetCellValue(rows, "SG_ID", code);
		mySheet.SetCellValue(rows, "SG_NAME", text);
		mySheet.SetCellValue(rows, "TNT", '0');
		
		
	} else if (popupSel == "addMk") {
		for (var i=1; i <= mySheet2.RowCount(); i++ ) {
			if ($.trim(mySheet2.GetCellValue(i, "MAKER_CODE")) == code) {
				alert("이미 등록되어 있는 제조사 입니다.\n\n확인 바랍니다.");
				return;
			}
		}

		var rows = mySheet2.DataInsert(-1);
		mySheet2.SetCellValue(rows, "APPROVAL_TEXT", "품의대상<br />(신규)");
		mySheet2.SetCellValue(rows, "MAKER_CODE", code);
		mySheet2.SetCellValue(rows, "MAKER_NAME", text);
		
		doAction("addMk");
	}
	grbRow="";	//초기화
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	var sMsg = response.msg;
	if (pMethod == "saveRemark") {
		if (sMsg == "OK") {
			$("#st_old_s_remark").val($("#st_s_remark").val());
			alert("공급사 선정 사유 입력이 성공 하였습니다." );
		} else {
			alert("공급사 선정 사유 입력이 실패 하였습니다." );
			return;
		}
	}
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	alert("오류발생하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  ");
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
	
	for (var i=1; i <= mySheet.RowCount(); i++ ) {
		if ($.trim(mySheet.GetCellValue(i, "APPROVAL_FLAG")) != "Y") {
			if ($.trim(mySheet.GetCellValue(i, "TNT")) == $.trim(mySheet.GetCellValue(i, "SIN_CON"))) {
				mySheet.SetCellValue(i, "APPROVAL_TEXT", mySheet.GetCellValue(i, "APPROVAL_TEXT") + "<br />(신규)");
			} else if ($.trim(mySheet.GetCellValue(i, "TNT")) == $.trim(mySheet.GetCellValue(i, "DEL_CON"))) {
				mySheet.SetCellValue(i, "APPROVAL_TEXT", mySheet.GetCellValue(i, "APPROVAL_TEXT") + "<br />(삭제)");
			} else {
				mySheet.SetCellValue(i, "APPROVAL_TEXT", mySheet.GetCellValue(i, "APPROVAL_TEXT") + "<br />(변경)");
			}
		}
	}
}

//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if (msg != "") {
		alert(msg);
	}
	
	if (code>0) {
		//삭제 성공시 재조회
		doAction('search1');
		mySheet2.RemoveAll();
	}
}

//조회 후처리
function mySheet2_OnSearchEnd(code, msg) {
	loader_obj("N");
	if (msg != "") {
		alert(msg);
	}

	for (var i=1; i <= mySheet2.RowCount(); i++ ) {
		if ($.trim(mySheet2.GetCellValue(i, "STATUS")) == "T") {
			mySheet2.SetCellValue(i, "APPROVAL_TEXT", mySheet2.GetCellValue(i, "APPROVAL_TEXT") + "<br />(신규)");
		} else if ($.trim(mySheet2.GetCellValue(i, "STATUS")) == "D") {
			mySheet2.SetCellValue(i, "APPROVAL_TEXT", mySheet2.GetCellValue(i, "APPROVAL_TEXT") + "<br />(삭제)");
		}
	}
}
	
// 트랜젝션(저장,삽입등) 후처리
function mySheet2_OnSaveEnd(code, msg) {
	loader_obj("N");
	if (msg != "") {
		alert(msg);
	}
	
	if (code>0) {
		var _sgId = $("#st_sg_id").val();
		var _sgName = $("#sg_name").text();
		//저장 성공시 재조회
		doAction('search1');
		$("#st_sg_id").val(_sgId);
		$("#sg_name").text(_sgName);
		doAction('search2');
	}
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mdcp/getMasterMdCpSAgntcmpyRegManageList.do?page="+current_page , pagingMode );
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'TNT') { // 요청자
		$("#st_sg_id").val(mySheet.GetCellValue(Row, "SG_ID"));
		$("#sg_name").text(mySheet.GetCellValue(Row, "SG_NAME"));
		doAction('search2');
	}
	return;
}


 //-->
</script> 
<body onload="kep_onload_view();">

	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:530px;">
    	<div id="popHeader">
        	<h1 class="title">S협력사등록관리</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
            <div class="contArea">
            	<form id="contentCondition" name="contentCondition"  method="post" >
            	<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}" />
				<input type="hidden" name="st_buyer_code" id="st_buyer_code"  value="<%=st_buyer_code%>">
				<input type="hidden" name="st_agent_code" id="st_agent_code"  value="<%=st_agent_code%>">
				<% if (_rowData != null) {  %>
				<b>[S협력사등록관리]</b>
	        	<table  class="cont_t_list06" style="width:100%;">
	                <caption>회원사 정보관리</caption>
	                <colgroup>
	                    <col width="130px" />
	                    <col width="32%" />
	                    <col width="130px" />
	                    <col width="30%" />
	                </colgroup>
	                <tbody>
						<tr>
							<th scope="row">고객사명</th>
	                        <td><%=CommonUtil.nvl(_rowData.get("BUYER_NAME"))%></td>
	                        <th scope="row">협력사명</th>
	                        <td><%=CommonUtil.nvl(_rowData.get("AGENT_NAME"))%></td>
						</tr>

						<tr>
	                        <th scope="row">사유</th>
	                      	<td colspan="3">
	                      		<input type="hidden" class="input_type_text" name="st_old_s_remark" id="st_old_s_remark" value="<%=CommonUtil.nvl(_rowData.get("TEXT1"))%>" />
	                      		<input type="text" class="input_type_text" name="st_s_remark" id="st_s_remark" style="width:90%" value="<%=CommonUtil.nvl(_rowData.get("TEXT1"))%>"  maxlength="400" onkeyup="fnCheckInputByte(this, 400);" onchange="fnCheckInputByte(this, 400);" />
								<span class="btn_gray_02" title="저장"><a href="javascript:doAction('saveRemark')">저장</a></span>
	                      	</td>
	                    </tr>
					</tbody>
				</table>
				</form>
				<% } %>
			</div>
			<div class="scrollArea" style="float:left; width:49%; height:315px; overflow:hidden;">
				<form id="searchCondition1" name="searchCondition1" method="post" >
				<input type="hidden" id="s_SAVENAME" name="s_SAVENAME" value="" />
				<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}" />
				<input type="hidden" id="st_buyer_code" name="st_buyer_code" value="<%=st_buyer_code%>" />
				<input type="hidden" id="st_agent_code" name="st_agent_code" value="<%=st_agent_code%>" />
				<input type="hidden" id="pageflag" name="pageflag" value="0" />
				<table  class="cont_t_list01" style="width:100%">
					<caption>S협력사등록관리</caption>
					<colgroup>
						<col width="*" />
						<col width="20%" />
                        <col width="10%" />
					</colgroup>
					<tbody>
						<tr> 
							<td class="right pr10">상태</td>
							<td>
								<select id="st_sg_status" name="st_sg_status">
									<option value="">전체</option>
									<option value="Y">품의완료</option>
									<option value="N">품의대상</option>						
								</select>
							</td>
							<td>
								<span class="btn_gray_02" title="검색"><a href="javascript:doAction('search1')">검색</a></span>
							</td>
						</tr>
					</tbody>
				</table>
				<div class="ib_product" style="border-top:2px solid #3c639c">
	  				<script type="text/javascript">
	  					createIBSheet("mySheet", "100%", "244px");
	  				</script>
	  			</div>
	  			</form>
	  			<!--버튼영역-->
				<div class="btnArea mt05 mr05">
	  				<span class="fr">
	  					<span class="btn_02 mr04"><a href="javascript:doPop('addSg');">추가</a></span>
	  					<span class="btn_02"><a href="javascript:doAction('delSg');">삭제</a></span>
	  				</span>
	  			 </div>
			</div>
			<div class="scrollArea" style="float:left; width:2%; height:315px; overflow:hidden;"></div> 
			<div class="scrollArea" style="width:49%; height:315px; overflow:hidden;" >
				<form id="searchCondition2" name="searchCondition2" method="post" >
				<input type="hidden" id="s_SAVENAME" name="s_SAVENAME" value="" />
				<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}" />
				<input type="hidden" id="st_buyer_code" name="st_buyer_code" value="<%=st_buyer_code%>" />
				<input type="hidden" id="st_agent_code" name="st_agent_code" value="<%=st_agent_code%>" />
				<input type="hidden" id="pageflag" name="pageflag" value="0" />
				<input type="hidden" id="st_sg_id" name="st_sg_id" value="" />
				<table  class="cont_t_list01" style="width:100%">
					<caption>S협력사등록관리</caption>
					<colgroup>
						<col width="*" />
						<col width="20%" />
						<col width="20%" />
                        <col width="10%" />
					</colgroup>
					<tbody>
						<tr> 
							<td class="left">SG명 : <lable id="sg_name"></lable></td>
							<td class="right pr10">상태</td>
							<td>
								<select id="st_mk_status" name="st_mk_status">
									<option value="">전체</option>
									<option value="Y">품의완료</option>
									<option value="N">품의대상</option>						
								</select>
							</td>
							<td>
								<span class="btn_gray_02" title="검색"><a href="javascript:doAction('search2')">검색</a></span>
							</td>
						</tr>
					</tbody>
				</table>
				<div class="ib_product" style="border-top:2px solid #3c639c">
	  				<script type="text/javascript">
	  					createIBSheet("mySheet2", "100%", "244px");
	  				</script>
	  			</div>
				</form>
				<!--버튼영역-->
				<div class="btnArea mt05 mr05">
	  				<span class="fr">
	  					<span class="btn_02 mr04"><a href="javascript:doPop('addMk');">추가</a></span>
	  					<span class="btn_02 mr04"><a href="javascript:doAction('delMk');">삭제</a></span>
	  					<span class="btn_02"><a href="javascript:doAction('modMk');">복원</a></span>
	  				</span>
	  			 </div>
			</div>
			
			<div class="btnArea mt20 mb05">
				<span class="fr">
					<% if (_userRole.equals("OK")) { %>
					<span class="btn_02 mr04"><a href="javascript:doAction('confMk');">승인</a></span>
					<% } %>						
				</span>
			 </div>
		</div>
	</div>
</body>
</html>
