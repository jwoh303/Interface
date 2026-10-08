<%--
**********************************************
* 메뉴 : 벌크소싱 품목 관리 > 품목 등록(엑셀업로드)
* 화면 : 벌크소싱 품목 별 엑셀업로드를 통한  품목 등록 등록
* 기능 : 1000px
*****************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%
	String burq_no = CommonUtil.nvl((String) request.getParameter("st_burq_no"),"");
	String project_name = CommonUtil.nvl((String) request.getParameter("st_project_name"),"");
	String unit = CommonUtil.nvl((String) request.getParameter("st_project_unit"),"");
%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script> 
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var checkFlag = "N";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	// 1. 고객사 단위
	var initsheet = {};
	initsheet.Cols = [
		{Align:"Center",	Width:30,	Edit:false,	EditLen:0,		Hidden:false,	Type:"Seq",		Header:"NO|NO",	SaveName:"SEQ"},
		{Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"*필수값|고객사 코드",	SaveName:"BUYER_CODE"},
		{Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"*필수값|고객사 품목코드",	SaveName:"BUYER_ITEM_NO"},
		{Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"*필수값|계약서번호",		SaveName:"CONTRACT_NO"},
		{Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"*필수값|계약서항번",		SaveName:"CONTRACT_SEQ"},
		{Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"*필수값|협력사 코드",	SaveName:"AGENT_CODE"},
		{Align:"Center",	Width:120,	Edit:false,	EditLen:300,	Hidden:false,	Type:"Text",	Header:"*필수값|기존단가",		SaveName:"RE_LIST_PRICE" },
		{Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"*필수값|발주횟수",		SaveName:"PO_CNT"},
		{Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"*필수값|수량",			SaveName:"QTY"},
		{Align:"Center",	Width:120,	Edit:false,	EditLen:300,	Hidden:false,	Type:"Text",	Header:"조건입력|메인사업장(납품처)",	SaveName:"MAIN_BUYER"},	
		{Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"결과|결과",			SaveName:"RESULT"}
	];
	
	//InitHeaders의 두번째 인자
	initsheet.HeaderMode = {Sort:0,ColMove:0,ColResize:1,HeaderCheck:1};
	initsheet.Cfg = {MergeSheet:msHeaderOnly};
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	mySheet.SetCountPosition(4);
	
	// 2. 그룹사 단위
	var initsheet2 = {};
	initsheet2.HeaderMode = {Sort : 0,ColMove : 1};
	initsheet2.Cfg = {MergeSheet:msHeaderOnly};
	initsheet2.Cols = [
		{Align:"Center",	Width:30,	Edit:false,	EditLen:0,		Hidden:false,	Type:"Seq",		Header:"NO",	SaveName:"SEQ"},
		{Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"그룹사 카탈로그 코드",	SaveName:"BYIT_COMORG_CODE"},
		{Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사 품목코드",	SaveName:"BUYER_ITEM_NO"},
		{Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사 코드",	SaveName:"AGENT_CODE"},
		{Align:"Center",	Width:120,	Edit:false,	EditLen:300,	Hidden:false,	Type:"Text",	Header:"기존단가",	SaveName:"RE_LIST_PRICE"},
		{Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"발주횟수",	SaveName:"PO_CNT" },
		{Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"수량",	SaveName:"QTY"},
		{Align:"Center",	Width:120,	Edit:false,	EditLen:300,	Hidden:false,	Type:"Text",	Header:"메인사업장(납품처)",	SaveName:"MAIN_BUYER"},	
		{Align:"Center",	Width:520,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"결과",	SaveName:"RESULT"}
	];
	
	IBS_InitSheet(mySheet2, initsheet2, pagingMode);
	mySheet2.SetCountPosition(4);

	if(!isEmpty("<%=burq_no%>")){
		$("#st_burq_no").val("<%=burq_no%>");
		$("#st_project_name").val("<%=project_name%>");
		
		$("input[name='project_unit']:input[value='<%=unit%>']").prop('checked',true);
		$("#st_project_unit").val("<%=unit%>");
		
		if("<%=unit%>" == "B"){
			document.getElementById("buyerSheet").style.display = "block";
			document.getElementById("groupSheet").style.display = "none";
		}else{
			document.getElementById("buyerSheet").style.display = "none";
			document.getElementById("groupSheet").style.display = "block";
		}
	}
	
}

// 기능함수
function doAction(str) {
	
	var project = $("#st_burq_no").val();
	if(isEmpty(project)){
		alert("프로젝트를 선택하시기 바랍니다.");
		return;
	}
	
	var project_unit = $("#st_project_unit").val();

	switch (str) {
		case "loadExcel": // 파일 업로드
			var params = "";
			if(project_unit == "B"){// 소싱단위가 고객사인 경우 
				mySheet.RemoveAll();
				params = { StartRow: "1", ColumnMapping:"|1|2|3|4|5|6|7|8|9||"};
				mySheet.LoadExcel(params);
			}else{ // 그룹사 단위인 경우
				mySheet2.RemoveAll();
				params = { StartRow: "1", ColumnMapping:"|1|2|3|4|5|6|7||"};
				mySheet2.LoadExcel(params);
			}
			checkFlag= "N";
			break;
		case "downForm" : // 양식 다운로드
			if(project_unit == "B"){// 소싱단위가 고객사인 경우 
				location.href = "/resources/excel/work/NEWSOURCING/masterMpRqBulkQuotationItemRegBuyerExcel.xlsx";
			}else{
				location.href = "/resources/excel/work/NEWSOURCING/masterMpRqBulkQuotationItemRegGroupExcel.xlsx";
			}
			break;
		case "downExcel": // 조회결과 다운로드
			var param = {FileName:"품목등록.xls"};
			if(project_unit == "B"){// 소싱단위가 고객사인 경우 
				mySheet.Down2Excel(param);
			}else{ // 그룹사 단위인 경우
				mySheet2.Down2Excel(param);
			}
			break;
		case "checkExcel": // 업로드 결과 확인
			current_page = -1;
			if(project_unit == "B"){// 소싱단위가 고객사인 경우 
				if(mySheet.RowCount() < 1){
					alert("업로드 된 정보가 없습니다.");
					return;
				}
				kepSearch(document.searchCondition, mySheet, "/mprq/checkMasterMpRqBulkQuotationItemRegPop.do", pagingMode);
			} else{
				if(mySheet2.RowCount() < 1){
					alert("업로드 된 정보가 없습니다.");
					return;
				}
				kepSearch(document.searchCondition, mySheet2, "/mprq/checkMasterMpRqBulkQuotationItemRegPop.do", pagingMode);
			}
			checkFlag= "Y";
			break;			
		case "save": // 등록
			if(checkFlag != "Y"){
				alert("업로드 결과 확인 후 진행하시기 바랍니다.");
				return;
			}
			if(project_unit == "B"){// 소싱단위가 고객사인 경우 
				var maxRow = mySheet.RowCount() + 1; 
			    for(var i = 3; i <= maxRow; i++){
			    	var result = mySheet.GetCellValue(i,"RESULT");
			    	if(result != "정상"){
			    		alert("결과가 정상이 아닌 정보가 있습니다. 다시 엑셀 업로드 후 하시기 바랍니다.");
			    		return;
			    	}
			    }
			    
			}else{ // 그룹사 단위인 경우
				var maxRow = mySheet2.RowCount() + 1; 
			    for(var i = 3; i <= maxRow; i++){
			    	var result = mySheet2.GetCellValue(i,"RESULT");
			    	if(result != "정상"){
			    		alert("결과가 정상이 아닌 정보가 있습니다. 다시 엑셀 업로드 후 하시기 바랍니다.");
			    		return;
			    	}
			    }
			}
			if(!confirm("입력하신 정보를 등록하시겠습니까?")){
				return;
			}
		    kepAjaxFormCall("/mprq/saveMasterMpRqBulkQuotationItemReg.do","searchCondition","save");
			break;
	}
}

/**
* ajax 공통 호출후 성공시 처리 함수
*/ 
function kepAjaxSuccess(pMethod , response){
	if(pMethod=="save"){
		alert("<%=CommonLang.msg("MSG236") %>");
		opener.setPopupReturn($("#st_burq_no").val(),$("#st_project_name").val(),$("#st_project_unit").val());
		window.close();
		return;
	}
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	var msg = response.Message;
	if (msg != "") {
		alert(msg);
	}
}

//조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
   	
	if (msg != "") {
		alert(msg);
	}
	var err_cnt= 0;
	var maxRow = mySheet.RowCount() + 1;
    for(var i = 2; i <= maxRow; i++){
    	var result = mySheet.GetCellValue(i,"RESULT");
    	if(result != "정상"){
    		mySheet.SetRowBackColor(i,"#FFD966");
    		err_cnt++;
    	}
    }
    document.getElementById("cnt2").innerHTML = maxRow - 1 - err_cnt;
    document.getElementById("cnt3").innerHTML = err_cnt;
}

//조회 후처리
function mySheet2_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
   	
	if (msg != "") {
		alert(msg);
	}
	var err_cnt= 0;
	var maxRow = mySheet2.RowCount() + 1;
    for(var i = 2; i <= maxRow; i++){
    	var result = mySheet2.GetCellValue(i,"RESULT");
    	if(result != "정상"){
    		mySheet2.SetRowBackColor(i,"#FFD966");
    		err_cnt++;
    	}
    }
    document.getElementById("cnt2").innerHTML = maxRow - 1 - err_cnt;
    document.getElementById("cnt3").innerHTML = err_cnt;
}
// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}
function mySheet2_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}
function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
}
function mySheet2_OnDownFinish(downloadType, result) {
	loader_obj("N");
}
//엑셀업로드(LoadExcel) 후처리
function mySheet_OnLoadExcel() {
	loader_obj("N");
	
	if(mySheet.RowCount() == 0){
		//일괄 업로드를 실패하였습니다. 관리자에게 문의바랍니다.
		alert("<%=CommonLang.msg("MSG467") %>");
	}else{
		document.getElementById("cnt").innerHTML = mySheet.RowCount();
		kepSaveAll(document.searchCondition,  mySheet, "/mprq/batchMasterMpRqBulkQuotationItemReg.do");	
	}
}

//엑셀업로드(LoadExcel) 후처리
function mySheet2_OnLoadExcel() {
	loader_obj("N");
	
	if(mySheet2.RowCount() == 0){
		//일괄 업로드를 실패하였습니다. 관리자에게 문의바랍니다.
		alert("<%=CommonLang.msg("MSG467") %>");
	}else{
		document.getElementById("cnt").innerHTML =mySheet2.RowCount();
		kepSaveAll(document.searchCondition,  mySheet2, "/mprq/batchMasterMpRqBulkQuotationItemReg.do");
	}
}


//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
	if (msg != "") {
		alert(msg);
	}
}
//트랜젝션(저장,삽입등) 후처리
function mySheet2_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
	if (msg != "") {
		alert(msg);
	}
}

//팝업함수호출
function doPop(str, value1) {
	popupSel=str;
	switch (str) {
		case "selProject":
			openSearchPopup('/mprq/showMasterMpRqBulkQuotationSelProjectPop.do','','630,450,no');
			break;
	}
}
//팝업리턴
function setPopupReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9){
	if (popupSel=="selProject"){
		$("#st_burq_no").val(value1);
		$("#st_project_name").val(value2);
		$("#st_project_unit").val(value3);
		$("input[name='project_unit']:input[value='"+value3+"']").prop('checked',true);
		
		if(value3 == "B"){
			document.getElementById("buyerSheet").style.display = "block";
			document.getElementById("groupSheet").style.display = "none";
		}else if(value3 =="G"){
			document.getElementById("buyerSheet").style.display = "none";
			document.getElementById("groupSheet").style.display = "block";
		}
	
	}
}
function setReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9){ 
  opener.setPopupReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9);
  this.close();
}
</script>
</head>
<body onload="kep_onload_view()">
<!-- 메뉴 S --> 
<div id="wrapper"> 

		<!--내용 시작-->
	<div id="popWrapper" >
		<div id="popHeader">
			<h1 class="title">품목 등록(엑셀업로드)</h1>
		    <p class="popClose"><a href="javascript:self.close()">
 			    <img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" />
		    </a></p>
		</div>
		<div id="popContainer" style="background-color:#f5f5f5"  >
<!-- 			<div style="background-color:#ffd2d2"> -->
<!-- 				<span> -->
<!-- 					&nbsp;▪  선택한 프로젝트의 소싱 대상 품목을 등록할 수 있는 화면입니다.<br> -->
<!-- 					&nbsp;▪  제공된 양식에 맞춰 담당자 정보를 입력한 후, <b>[엑셀 업로드]</b> 버튼을 클릭하세요.<br> -->
<!-- 					&nbsp;▪  업로드가 완료되면 <b>[업로드 결과 확인]</b> 버튼을 클릭해 처리 결과를 확인합니다.<br> -->
<!-- 					&nbsp;▪  업로드 결과가 '정상'이 아닐 경우, 등록되지 않습니다. 엑셀 내용을 수정하여 다시 업로드해주세요. -->
<!-- 				</span> -->
<!-- 			</div> -->
			<br> 
	   		<table  class="cont_t_list06 mb15" summary="품목 등록(엑셀업로드)" style="width:100%;">
				<caption>품목 등록(엑셀업로드)</caption>
				<colgroup>
					<col width="10%" />
					<col width="60%" />
					<col width="10%" />
					<col width="20%" />
				</colgroup>
				<tbody>
			   		<form name="searchCondition" id ="searchCondition" method = "post">
				   		<input type="hidden" name="s_SAVENAME">
						<input type="hidden" name="st_burq_no" id="st_burq_no" value="">
						<input type="hidden" id="st_project_unit" name="st_project_unit" value="">
					</form>
					<tr> 
						<th scope="row" class="center">프로젝트</th>
						<td>
							<input type="text" id="st_project_name" name="st_project_name"  class="input_type_text" style="width:70%;" readonly>
	                        <a href="javascript:doPop('selProject');"><img src="/resources/images/btn_search03.gif"></a>
	                        <a href="javascript:kepEraser('st_project_code','st_project_name');"><img src="/resources/images/btn_eraser2.gif"></a>
						</td>
						<th scope="row" class="center">소싱 단위</th>
						<td>
							<label><input type="radio" name="project_unit" value="B" disabled>&nbsp;고객사</label>
							<label><input type="radio" name="project_unit" value="G" disabled>&nbsp;그룹사</label>
						</td>
					</tr>
					<tr>
						<th scope="row" class="center">파일 업로드</td>
						<td colspan="3">
							<span class="btn_05 mr04"><a href="javascript:doAction('loadExcel');">엑셀 업로드</a></span>
							<span class="btn_05 mr04"><a href="javascript:doAction('downForm');">양식 다운로드</a></span>
						</td>
					</tr>
				</tbody>
			</table>
     		<!--버튼영역-->
			<div class="btnArea" style="text-align:center;">
				<span class="btn_08 mr04"><a href="javascript:doAction('checkExcel');">업로드 결과 확인</a></span>
			</div>     
			<div class="btnArea">
				<span class="fl">
    				<span class="btn_08 mr04"><a href="javascript:doAction('downExcel');">조회결과 다운로드</a></span>
    				<span style="font-size: 14px;">총 <b><span id="cnt">00</span></b>건&nbsp;&nbsp;&nbsp;(정상 <span id="cnt2" style="font-weight: bold;">00</span>건 / 오류 <span id="cnt3"  style="color:red;font-weight: bold;">00</span>건)</span>
				</span>
    			<span class="fr">
    				<span class="btn_05 mr04"><a href="javascript:doAction('save');">등록</a></span>
    			</span>
    		</div>   
				
    		<div id="buyerSheet">
	    		<!--grid-->
   				<div class="ib_product" style="border-top:2px solid #3c639c">
	  				<script type="text/javascript">
	  					createIBSheet("mySheet", "100%", "490px");
	  				</script>
  				</div>		
    		</div>
    		
			<div id="groupSheet" style="display:none">
   				<div class="ib_product" style="border-top:2px solid #3c639c">
	  				<script type="text/javascript">
	  					createIBSheet("mySheet2", "100%", "490px");
	  				</script>
  				</div>
			</div>	    		
  			<br>
<!--내용 종료-->
		</div>
	</div>

</div>

</body>
</html>