<%--
**********************************************
* 메뉴 : 상품관리>표준카탈로그 관리>표준카탈로그 추천
* 화면 : 표준카탈로그 추천
* 기능 : 엑셀 업로드를 통하여 DQCAT을 이용한 표준카탈로그 추천
* 프로그램 ID : 
* 담당자 : 한승준 ( 설계 : 옥대수 )
* 착수일 : 2017-07-06
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
var maxAllowRow = 5000;	// 추천을 허용할 데이터 Row수
var AjaxCallCount = 0;	// Ajax 콜 횟수
var AjaxSuccCount = 0;	// 자동추천 시 사용할 SEQ
var AjaxFailFlag = "Y"; // Ajax 콜 후 에러 발생 시 Y로 세팅됨

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
	                  {Align:"Center",	Width:60,	Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",				Header:"상태",						SaveName:"sStatus"},
	                  {Align:"Center",	Width:30,	Edit:true,	EditLen:100,	Hidden:true,	Type:"DummyCheck",	Header:"",							SaveName:"SELECTED"},
	                  {Align:"Center",	Width:50,	Edit:true,	EditLen:100,	Hidden:true,	Type:"Text",					Header:"순번",						SaveName:"TARGET"},
	                  {Align:"Center",	Width:50,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"순번",						SaveName:"ROWNUM"},
	                  {Align:"Left",		Width:200,	Edit:true,	EditLen:300,	Hidden:false,	Type:"Text",					Header:"고객사품명",			SaveName:"DESCRIPTION",	KeyField:true},
	                  {Align:"Left",		Width:250,	Edit:true,	EditLen:300,	Hidden:false,	Type:"Text",					Header:"규격",						SaveName:"SPECIFICATION",	KeyField:true},
	                  {Align:"Left",		Width:120,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"제조사명",				SaveName:"MAKER_NAME",	KeyField:true},
	                  {Align:"Left",		Width:120,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"모델번호",				SaveName:"MODEL_PART_NO"},
	                  {Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"표준카탈로그코드",	SaveName:"CMS_CATLG_ID"},
	                  {Align:"Left",		Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"표준품명",				SaveName:"CMS_DESCRIPTION"},
	                  {Align:"Left",		Width:250,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"규격(표준)",				SaveName:"CMS_SPECIFICATION"},
	                  {Align:"Left",		Width:120,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",					Header:"제조사(표준)",			SaveName:"CMS_MAKER_CODE"},
	                  {Align:"Left",		Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"제조사(표준)",			SaveName:"CMS_MAKER_NAME"},
	                  {Align:"Left",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",					Header:"원산지(표준)",			SaveName:"CMS_ORIGIN_CODE"},
	                  {Align:"Left",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"원산지(표준)",			SaveName:"CMS_ORIGIN_NAME"},
	                  {Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"정확도",					SaveName:"ACCR_RATE"},
	                  {Align:"Left",		Width:200,	Edit:false,	EditLen:300,	Hidden:false,	Type:"Text",					Header:"비고",						SaveName:"REMARK"},
	                  {Align:"Center",	Width:50,	Edit:false,	EditLen:300,	Hidden:true,	Type:"Text",					Header:"모델번호존재여부",	SaveName:"CATLG_MODEL_FLAG"}
	];
	
	//InitHeaders의 두번째 인자
	initsheet.HeaderMode = {Sort:0,ColMove:0,ColResize:1,HeaderCheck:1};
	initsheet.Cfg = {MergeSheet:msHeaderOnly};
	
	IBS_InitSheet(mySheet, initsheet,pagingMode, 'XLS');
	
	//데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]
	mySheet.SetCountPosition(4);
}

// 기능함수
function doAction(str) {
	var maxRow  = mySheet.RowCount();
	popupSel = str;
	
	switch (str) {
		case "search":	 // 조회
			kepSearch(document.searchCondition,  mySheet , "/mdcm/getMasterMdCmCatlgRcmdList.do" , "N" );
			
			break;
		
		case "upload_search":	 // 조회
			kepSearch(document.searchCondition,  mySheet , "/mdcm/getUploadMasterMdCmCatlgRcmdList.do" , "N" );
			
			break;
			
		case "reload":	// 초기화
			mySheet.RemoveAll();
			$("#st_target_rate").val("");
			AjaxCallCount = 0;	
			AjaxSuccCount = 0;
			
			break;
	
		case "loadExcel": // 파일 업로드
			mySheet.RemoveAll();
			var params = { Mode : "NoHeader ", StartRow: "2", ColumnMapping:"||||1|2|3|4|||||||||5"};
			mySheet.LoadExcel(params);
	
			break;
			
		case "rcmd": // 추천
			for(var i=1; i<= maxRow; i++){
				mySheet.SetCellValue(i,"SELECTED","1");
				
				var model = kepTrimStr(mySheet.GetCellValue(i,"MODEL_PART_NO"));

				if(model == ""){
					mySheet.SetCellValue(i,"CATLG_MODEL_FLAG","false");
				}else{
					mySheet.SetCellValue(i,"CATLG_MODEL_FLAG","true");					
				}
			}
			
			kepSave(document.searchCondition ,  mySheet , "/mdcm/updateMasterMdCmCatlgRcmdList.do", "SELECTED");
			
			break;
	}
}

/**
* ajax 공통 호출후 성공시 처리 함수
*/ 
function kepAjaxSuccess(pMethod , response){
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
}
	
// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}
	
function mySheet_OnDownFinish(downloadType, result) {
	loader_obj("N");
}

//엑셀업로드(LoadExcel) 후처리
function mySheet_OnLoadExcel() {
	var maxRow  = mySheet.RowCount();

	if(maxRow == 0){
		alert("일괄 업로드를 실패하였습니다. 관리자에게 문의바랍니다.");
		return;
	}
	
	if(maxAllowRow < maxRow) {
		alert(maxAllowRow + "건 이하의 파일만 업로드하여 주세요.");
		mySheet.RemoveAll();
		return;
	}
	
	for(var i=1; i<= maxRow; i++){
		mySheet.SetCellValue(i,"SELECTED","1");
		mySheet.SetCellValue(i,"ROWNUM", i);
	}
	
	kepSave(document.searchCondition ,  mySheet , "/mdcm/uploadMasterMdCmCatlgRcmdList.do", "SELECTED");
}

//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}

	if(code>0){
		if(popupSel == "loadExcel"){
			//저장 성공시 재조회
			alert("일괄 업로드를 완료하였습니다.");
		}else if(popupSel == "rcmd"){
			alert("추천을 완료하였습니다.");
		}
		$("#st_target_rate").val("");
		doAction('upload_search');
		
	}else{
		if(popupSel == "loadExcel"){
			alert("일괄 업로드에 실패하였습니다.");	
		}else if(popupSel == "rcmd"){
			alert("추천을 실패하였습니다.");
		}
		
		mySheet.RemoveAll();
	}
}

//조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	var maxRow  = mySheet.RowCount();
	
	loader_obj("N");
	if(!checkedSession(stCode)){return;}

	if (msg != "") {
		alert(msg);
	}
	
	for(var i=1; i<= maxRow; i++){
		mySheet.SetCellValue(i,"SELECTED","1");
		mySheet.SetCellValue(i,"ROWNUM", i);
	}
}
</script>
</head>

<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
		<form name="searchCondition" id="searchCondition" method="post" action ="">
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" name="catlg_target_count" id="catlg_target_count" value="1">
			<input type="hidden" name="catlg_target_rate" id="catlg_target_rate" value="0">
		    <input type="hidden" name="catlg_desc" id="catlg_desc" value="">
		    <input type="hidden" name="catlg_spec" id="catlg_spec" value="">
		    <input type="hidden" name="catlg_maker" id="catlg_maker" value="">
		    <input type="hidden" name="catlg_model" id="catlg_model" value="">
		    <input type="hidden" name="catlg_desc_flag" id="catlg_desc_flag" value="true">
		    <input type="hidden" name="catlg_spec_flag" id="catlg_spec_flag" value="true">
		    <input type="hidden" name="catlg_maker_flag" id="catlg_maker_flag" value="true">
       		
       		<div id="searchBtnA"  >
				<h3>표준카탈로그 추천</h3>
				<span><b><font>정확도</font></b>
					<select name="st_target_rate" id="st_target_rate">
						<option value = ""  selected>전체</option>
						<option value = "80" >80% 이상</option>
						<option value = "70" >70% 이상</option>
						<option value = "60" >60% 이상</option>
					</select>
       			</span>
	        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span>
			    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   			</div>
					
      		<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "500px");
  				</script>
  			</div>
  			
  			<!--버튼영역-->
			<div class="btnArea">
				<span class="fl">
  					<span class="btn_05 mr04"><a href="javascript:doAction('loadExcel');">일괄 업로드</a></span>
  					<span class="btn_04"><a href="/resources/excel/work/CATALOG/masterMdCmStndCatlgRcmd.xls">등록양식</a></span>
  					&nbsp;※ <b><font color="red">업로드 시 등록양식을 다운받은 후 필수란을 확인하고 기입하여 주시기 바랍니다.</font></b>
  				</span>
  				<span class="fr">
  					<span class="btn_02"><a href="javascript:doAction('rcmd')">추천</a></span>
  				</span>
			</div>
<!--내용 종료-->
</form>
</body>
</html>
