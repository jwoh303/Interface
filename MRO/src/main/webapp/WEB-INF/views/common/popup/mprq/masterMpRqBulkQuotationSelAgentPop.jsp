<%--
**********************************************
* 메뉴 : 벌크소싱 견적요청 > 협력사 선택
* 화면 : 협력사 선택 
* 기능 : 우선협력사 / 협력사 조회로 협력사 선택
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script> 
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<!doctype html>
<html>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %> 
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과  

String burq_no = CommonUtil.nvl((String) request.getParameter("st_burq_no"),"");
String item_key_id_list = CommonUtil.nvl((String) request.getParameter("st_item_key_id"),"");
%>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	
	initsheet.Cols = [
		{Align:"Center",	Width:30,	Edit:false,	EditLen:0,		Hidden:true,	Type:"Stauts",		Header:" ",	SaveName:"sStatus"},
		{Align:"Center",	Width:30,	Edit:true,	EditLen:0,		Hidden:false,	Type:"DummyCheck",		Header:" ",SaveName:"SELECTED"},
		{Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사 코드",	SaveName:"AGENT_CODE"},
		{Align:"Center",	Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사명",	SaveName:"AGENT_NAME"},
		{Align:"Center",	Width:80,	Edit:false,	EditLen:300,	Hidden:false,	Type:"Text",	Header:"발주횟수",		SaveName:"PO_CNT"},	
		{Align:"Right",		Width:120,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Float",	Header:"거래금액",			SaveName:"TOT_AMT",	Format:"${priceFormat}"}
	];
	
	//InitHeaders의 두번째 인자
	initsheet.HeaderMode = {Sort:0,ColMove:0,ColResize:1,HeaderCheck:1};
	
	initsheet.Cfg = {MergeSheet:msHeaderOnly};
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	
	initsheet.Cols = [
		{Align:"Center",	Width:30,	Edit:false,	EditLen:0,		Hidden:true,	Type:"Stauts",		Header:" ",	SaveName:"sStatus"},
		{Align:"Center",	Width:30,	Edit:true,	EditLen:0,		Hidden:false,	Type:"DummyCheck",		Header:" ",SaveName:"SELECTED"},
		{Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사 코드",	SaveName:"AGENT_CODE"},
		{Align:"Center",	Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사명",	SaveName:"AGENT_NAME"},
		{Align:"Center",	Width:80,	Edit:false,	EditLen:300,	Hidden:false,	Type:"Text",	Header:"발주횟수",		SaveName:"PO_CNT"},	
		{Align:"Right",		Width:120,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Float",	Header:"거래금액",			SaveName:"TOT_AMT",	Format:"${priceFormat}"},
		{Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"SEARCHCODE",	SaveName:"SEARCH_CODE"}
	];
	
	IBS_InitSheet(mySheet2, initsheet,pagingMode);
	
	initsheet.Cols = [
		{Align:"Center",	Width:30,	Edit:false,	EditLen:0,		Hidden:true,	Type:"Stauts",		Header:" ",	SaveName:"sStatus"},
		{Align:"Center",	Width:30,	Edit:true,	EditLen:0,		Hidden:false,	Type:"DummyCheck",		Header:" ",SaveName:"SELECTED"},
		{Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사 코드",	SaveName:"AGENT_CODE"},
		{Align:"Center",	Width:500,	Edit:false,	EditLen:500,	Hidden:false,	Type:"Text",	Header:"협력사명",	SaveName:"AGENT_NAME"},
		{Align:"Center",	Width:140,	Edit:false,	EditLen:300,	Hidden:false,	Type:"Text",	Header:"발주횟수",		SaveName:"PO_CNT"},	
		{Align:"Right",		Width:200,	Edit:true,	EditLen:200,	Hidden:false,	Type:"Float",	Header:"거래금액",			SaveName:"TOT_AMT" ,	Format:"${priceFormat}"},
		{Align:"Center",	Width:238,	Edit:true,	EditLen:200,	Hidden:false,	Type:"Text",	Header:"우선협력사",			SaveName:"SEL_AGENT"}
	];	
	
	IBS_InitSheet(mySheet3, initsheet,pagingMode);
	if(!isEmpty("<%=burq_no%>")){
		$("#st_burq_no").val("<%=burq_no%>");
		$("#st_item_key_id").val("<%=item_key_id_list%>");
	}
	var arr = "<%=item_key_id_list%>";
	var arrRow = arr.split("@@").filter(Boolean);
	document.getElementById("cnt").innerHTML = arrRow.length;
}

//기능함수
function doAction(str) {
	switch (str) {
		case "search": // 협력사 조회
			var str  = $("#st_agent_name").val();
			if(str.length < 2){
				alert("협력사명은 2글자 이상 입력하시기 바랍니다.");
				return;
			}
			kepSearch(document.searchCondition, mySheet, "/mprq/getMasterMpRqBulkQuotationSelAgentPop.do", pagingMode);
			break;
		case "search2": // 우선 협력사 조회
			kepSearch(document.searchCondition, mySheet2, "/mprq/getMasterMpRqBulkQuotationSelAgentPop2.do", pagingMode);
			break;
		case "save": // 등록

			var maxRow = mySheet3.RowCount(); 
			if(maxRow == 0){
				alert("선택된 협력사가 없습니다.");
				return;
			}
			
			if(!confirm("선택 협력사를 전부 등록하시겠습니까?")){
				return;
			}
			
			kepSaveAll(document.searchCondition,  mySheet3, "/mprq/saveMasterMpRqBulkQuotationSelAgentPopRFQ.do");
			break;
		case "addMyAgent": // 협력사에서 조회한 건 우선 협력사에 추가
			if(isEmpty($("#st_search_code").val())) {alert("우선 협력사 조회조건을 설정하시기 바랍니다."); return;}
			// 이미 추가되어 있는 경우 추가 불가
			var selectedGrid_1 = mySheet.FindCheckedRow("SELECTED");
			if(isEmpty(selectedGrid_1)){
				alert("우선협력사로 지정하실 협력사를 선택하시기 바랍니다.");
				return;
			}else{
				var arr_1 = selectedGrid_1.split("|");
				for(var i=0; i < arr_1.length; i++){
					if(mySheet2.FindText("AGENT_CODE",mySheet.GetCellValue(arr_1[i],"AGENT_CODE")) != -1){
						alert(mySheet.GetCellValue(arr_1[i],"AGENT_NAME") + "은/는 이미 우선협력사로 추가된 협력사입니다.");
						return;
					}
				}
			}
			kepSave(document.searchCondition,  mySheet, "/mprq/saveMasterMpRqBulkQuotationSelAgentPop.do", "SELECTED");
			break;
		case "delMyAgent": // 우선 협력사에서 제거
			kepSave(document.searchCondition,  mySheet2, "/mprq/delMasterMpRqBulkQuotationSelAgentPop.do", "SELECTED");
			break;
		case "addAgent": // 선택협력사에 추가
			var selectedGrid_1 = mySheet.FindCheckedRow("SELECTED");
			var selectedGrid_2 = mySheet2.FindCheckedRow("SELECTED");
			var agentList = [];
			if(!isEmpty(selectedGrid_2)){
				var arr_2 = selectedGrid_2.split("|");
				for(var i = 0; i <arr_2.length;i++){
					agentList.push(mySheet2.GetCellValue(arr_2[i],"AGENT_CODE"));
					// mySheet3에 추가, 우선협력사에 별표 추가
					var sel = mySheet3.DataInsert(-1);
					mySheet3.SetCellValue(sel, "AGENT_CODE", mySheet2.GetCellValue(arr_2[i],"AGENT_CODE"));
					mySheet3.SetCellValue(sel, "AGENT_NAME", mySheet2.GetCellValue(arr_2[i],"AGENT_NAME"));
					mySheet3.SetCellValue(sel, "PO_CNT", mySheet2.GetCellValue(arr_2[i],"PO_CNT"));
					mySheet3.SetCellValue(sel, "TOT_AMT", mySheet2.GetCellValue(arr_2[i],"TOT_AMT"));
					mySheet3.SetCellValue(sel, "SEL_AGENT", "★");
				}
			}
			if(!isEmpty(selectedGrid_1)){
				var arr_1 = selectedGrid_1.split("|");
				for(var i = 0 ; i < arr_1.length; i++){
					var curAgent = mySheet.GetCellValue(arr_1[i],"AGENT_CODE");
					if(agentList.indexOf(curAgent) == -1){
						var sel = mySheet3.DataInsert(-1);
						mySheet3.SetCellValue(sel, "AGENT_CODE", mySheet.GetCellValue(arr_1[i],"AGENT_CODE"));
						mySheet3.SetCellValue(sel, "AGENT_NAME", mySheet.GetCellValue(arr_1[i],"AGENT_NAME"));
						mySheet3.SetCellValue(sel, "PO_CNT", mySheet.GetCellValue(arr_1[i],"PO_CNT"));
						mySheet3.SetCellValue(sel, "TOT_AMT", mySheet.GetCellValue(arr_1[i],"TOT_AMT"));
						mySheet3.SetCellValue(sel, "SEL_AGENT", "");					
					}
				}
			}
			break;
			
		case "delAgent": // 선택 협력사에서 제거
			var selectedGrid = mySheet3.FindCheckedRow("SELECTED");
			mySheet3.RowDelete(selectedGrid);
			break;
	}
}


//팝업함수호출
function doPop(str, value1) {
	popupSel = str;

	switch (str) {
		case "selectSearch": //파일업로드
		var type = $("#st_type").val();
			if(type=="SGNAME"){
				openSearchPopup("/mprq/showMasterMpRqSgChoicePop.do", "", "500,500,no");
			}else{
				openSearchPopup("/common/agentRegMakerCodePop.do", "", "500,500,no");
			}
			break;
	}
}
//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text){
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "selectSearch") {
		$("#st_search_code").val(code);
		$("#st_search_name").val(text);
		doAction('search2');
	}
}


function changeSelect(){
	kepEraser('st_search_code','st_search_name');
	type = $("#st_search option:selected").val();
	$("#st_type").val(type);
}

<%-- 1: 협력사조회 --%>
//조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
   	
	if (msg != "") {
		alert(msg);
	}
}

// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
	if (msg != "") {
		alert(msg);
	}
	
	doAction('search2');
}

<%-- 2 : 우선협력사 --%>
//조회 후처리
function mySheet2_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
   	
	if (msg != "") {
		alert(msg);
	}
}

// 그리드 표시후 처리	 
function mySheet2_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}
	
function mySheet2_OnDownFinish(downloadType, result) {
	loader_obj("N");
}

//트랜젝션(저장,삽입등) 후처리
function mySheet2_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
	if (msg != "") {
		alert(msg);
	}
	
	if(code>=0){
		alert("삭제가 완료되었습니다.");
		//저장 성공시 재조회
		doAction('search2');
	} 
}

<%-- 3: 선택 협력사 --%>
//트랜젝션(저장,삽입등) 후처리
function mySheet3_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
	if (msg != "") {
		alert(msg);
	}
	
	if(code>=0){
		alert("저장이 완료되었습니다.");
		//저장 성공시 재조회
		setReturn('1');
	} 
}
function setReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9)
{ 
  opener.setPopupReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9);
  this.close();
}
</script> 
<body onLoad="kep_onload_view();">
 	<form name=searchCondition id=searchCondition method=post >
		<input type="hidden" id="s_SAVENAME" name="s_SAVENAME" value="">
	 	<input type="hidden" id="st_burq_no" name="st_burq_no">
	 	<input type="hidden" id="st_item_key_id" name="st_item_key_id">
	 	<input type="hidden" id="st_type" name="st_type" value="SGNAME">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="min-height: 100px;">
    	<div id="popHeader">
          <h1 class="title">협력사 선택</h1>
          <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
       
        <!--팝업내용입니다-->
        <div id="popContainer">
          <div style="width:97%; height:30px; line-height:30px;  font-weight:bold; color:#000;letter-spacing:-0.5px; border-radius:6px; font-size:12px; background-color:#fff"> 
          선택된 품목( <font color="red"><span id="cnt">00</span></font> )에 협력사가 일괄적용 됩니다.</div> 
		  <div style="display:flex;align-items:center">
            <div style="width:45%;"> 
              <div style="height:30px; line-height:30px;vertical-align:top; font-size:14px; color:#000; font-weight:bold; letter-spacing:-1px;">
                ▪  협력사 조회<p class="fr" style="font-size:11px; font-weight:normal; letter-spacing:-0.2px; margin-top:3px;color:#535353">발주거래현황(최근 3개월)</p></div>
              <div style=" padding:10px 15px 8px 15px; margin-bottom:5px; border-radius:6px; background-color:#f5f5f5">
                <input type=text name="st_agent_name" id="st_agent_name" value="" onKeyDown="kepEnter()" style="ime-mode:active; width:320px; height:25px" class="input_type_text">
                <p class="btn_search"><a href="javascript:doAction('search');">조회</a></p>
              </div>
              <div style="border:1px solid #f1f1f1;border-top:2px solid #3c639c;height:200px; background-color:#faf9f9">
				<script type="text/javascript">
                    createIBSheet("mySheet", "100%", "200px");
                </script>              
              </div>
            </div>          
            <div style="text-align:center;width:10%;float:left;"> 
              <span class="btn_02 mr04" style="border:1px solid #cfcfcf;border-radius:6px;background:linear-gradient(45deg, #eee -42.41%, #fff 111.92%); "><a href="javascript:doAction('addMyAgent')" style="font-size:20px;color:#000" > > </a></span> 
              <span class="btn_02 mr04" style="border:1px solid #cfcfcf;border-radius:6px;background:linear-gradient(45deg, #fff -42.41%, #eee 111.92%); "><a href="javascript:doAction('delMyAgent')" style="font-size:20px; color:#000" > < </a></span>
            </div>   
            <div style="width:45%"> 
              <div style="height:30px; line-height:30px;vertical-align:top; font-size:14px; color:#000; font-weight:bold; letter-spacing:-1px;">
               ▪  우선협력사 조회<p class="fr" style=" font-size:11px; font-weight:normal; letter-spacing:-0.2px; margin-top:3px; color:#535353">발주거래현황(최근 3개월)</p></div>
              <div style="padding:10px 15px 8px 15px; margin-bottom:5px; border-radius:6px; background-color:#f5f5f5">
                <select name="st_search" id="st_search" onChange="changeSelect()" style="height:25px">
                    <option value="SGNAME" selected> SG명</option>
                    <option value="MAKER">MAKER명</option>
                </select>
                <input type="text" class="input_type_text" name="st_search_name" id="st_search_name" style="width:180px;height:25px;background-color:#cccccc" value="" readonly>
                <input type="hidden" name="st_search_code" id="st_search_code" value="">
                <span class="btn_search"><a href="javascript:doPop('selectSearch');">조회</a></span> 
                <span class="btn_reset"><a href="javascript:kepEraser('st_search_code','st_search_name');">초기화</a></span>
              </div>
              <div style="border:1px solid #f1f1f1;border-top:2px solid #3c639c;height:200px;">
				<script type="text/javascript">
                    createIBSheet("mySheet2", "100%", "200px");
                </script>              
              </div>
            </div> 
		  </div>
		  <br>
          <div id="shift" style="position:relative; text-align:left;height:50px  ">
            <div style="float:left;height:50px;line-height:70px;font-size:14px;color:#000;font-weight:bold; letter-spacing:-1px;" > ▪  선택 협력사</div>
            <a href="javascript:doAction('addAgent');"><span style="display:inline-block; margin-left:420px; height:35px; line-height:35px; text-align:center;width:210px; border:1px solid #ff4533; border-radius:6px;background:#fff;">
            <img style=" margin-top:10px;" src="/resources/images/icn_arrowdown02.gif"></span></a>
            <a href="javascript:doAction('delAgent');"><p class="btn_reset" style=" position:absolute; right:0; top:18px; height:23px;line-height:20px; border-radius:4px; background-color:#06C; color:#fff">삭제</p></a>
          </div>
          <div style="border:1px solid #f1f1f1;border-top:2px solid #3c639c;height:200px;background-color:#faf9f9">
			<script type="text/javascript">
                createIBSheet("mySheet3", "100%", "200px");
            </script>          
          </div>
          <br>
          <div class="btnArea" style="text-align:center;"><span class="btn_05 mr04"><a href="javascript:doAction('save');">저장</a></span></div>   
		</div>                   
	</div>
</form> 
</body>
</html>