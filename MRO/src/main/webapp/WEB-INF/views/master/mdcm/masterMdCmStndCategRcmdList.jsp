<%--
**********************************************
* 메뉴 : 상품관리>표준 카탈로그 관리>표준카테고리 추천
* 화면 : 표준카테고리 추천
* 기능 : 엑셀 업로드를 통하여 DQCAT을 이용한 표준카테고리 추천
* 프로그램 ID : 
* 담당자 : 한승준 ( 설계 : 옥대수 )
* 착수일 : 2016-06-01
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
	                  {Align:"Center",	Width:30,	Edit:true,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:"",							SaveName:"SELECTED"},
	                  {Align:"Left",		Width:220,	Edit:true,	EditLen:300,	Hidden:false,	Type:"Text",					Header:"품목명",					SaveName:"DESCRIPTION",	KeyField:true},
	                  {Align:"Left",		Width:250,	Edit:true,	EditLen:300,	Hidden:false,	Type:"Text",					Header:"규격",						SaveName:"SPECIFICATION",	KeyField:true},
	                  {Align:"Left",		Width:120,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"제조사명",				SaveName:"MAKER_NAME"},
	                  {Align:"Left",		Width:400,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"표준카테고리경로",	SaveName:"CATEG_PATH"}, 
	                  {Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"표준카테고리코드",	SaveName:"CMS_CATEG_ID"},
	                  {Align:"Left",		Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"표준카테고리명",		SaveName:"CATEG_NAME"}, 
	                  {Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"SG코드",					SaveName:"SG_ID"},
	                  {Align:"Left",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",					Header:"SG명",					SaveName:"SG_NAME"},
	                  {Align:"Left",		Width:200,	Edit:false,	EditLen:300,	Hidden:false,	Type:"Text",					Header:"비고",						SaveName:"REMARK"}
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
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	
	// 선택된 항목 유무 체크
	if (str =="deleteRows" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
	case "reload":	// 초기화
		mySheet.RemoveAll();
		AjaxCallCount = 0;	
		AjaxSuccCount = 0;
		
		break;

	case "loadExcel": // 파일 업로드
		mySheet.RemoveAll();
		var params = { Mode : "NoHeader ", StartRow: "2", ColumnMapping:"||1|2|3||||||4"};
		mySheet.LoadExcel(params);

		break;
		
	case "deleteRows": // 행삭제
		mySheet.RowDelete(selectedGrid, 1);	
		
		break;
		
	case "categ":
		var totRow = mySheet.RowCount();
		AjaxCallCount = 0;
		AjaxSuccCount = 0;
		AjaxFailFlag = "N";
		
		if( totRow<= 0){
			alert('추천할 데이터가 없습니다.');
			return;
		}
		
		if(totRow > maxAllowRow){
			alert(maxAllowRow + "건 이하만 자동추천 가능합니다.");
			return;
		}
		
		for(var i=1; i<=totRow;i++){
			var st_categ_desc = mySheet.GetCellValue(i,"DESCRIPTION"); // 품목명
			var st_categ_spec = mySheet.GetCellValue(i,"SPECIFICATION"); // 규격
			
			if(kepIsValueNull(st_categ_desc)) {
				alert('품목명은 필수 입력항목입니다. ['+i+' 번째]');
				mySheet.SelectCell(i, "DESCRIPTION", 1, "");
				return;
			}
			
			if(kepIsValueNull(st_categ_spec)) {
				alert('규격은 필수 입력항목입니다. ['+i+' 번째]');
				mySheet.SelectCell(i, "SPECIFICATION", 1, "");
				return;
			}
		}
		
		if(confirm("데이터량에 따라 최대 3분 정도 소요될 수 있습니다. \n자동추천을 실행하시겠습니까?")){
			for(var i=1; i<=totRow;i++){
				document.categForm.categ_maker_flag.value = "true";
				
				var st_categ_desc = mySheet.GetCellValue(i,"DESCRIPTION"); // 품목명
				var st_categ_spec = mySheet.GetCellValue(i,"SPECIFICATION"); // 규격
				var st_categ_maker = mySheet.GetCellValue(i,"MAKER_NAME"); // 제조사명
				
				document.categForm.categ_row_no.value = i;
				document.categForm.categ_desc.value = st_categ_desc;
				document.categForm.categ_spec.value = st_categ_spec;
				document.categForm.categ_maker.value = st_categ_maker;
				
				// 제조사명이 없으면 제조사는 추천플래그로 사용 안함(정확도에 영향이 있음)
				if(st_categ_maker == "" || st_categ_maker == null){
					document.categForm.categ_maker_flag.value = "false";
				}
				
				kepAjaxFormCall("/mprq/searchCategAutoSetting.do","categForm","DQCAT");
			}
		}
		break;
	}
}

//TABLE의 ROW 데이타 생성
function addrows() {
	mySheet.DataInsert(-1);
}

/**
* ajax 공통 호출후 성공시 처리 함수
*/ 
function kepAjaxSuccess(pMethod , response){
	if(pMethod == "DQCAT"){
		var maxRow = mySheet.RowCount();
		
		AjaxCallCount++;
		AjaxSuccCount++;
		
		loader_obj("Y");
		
		// response.categ_row_no1 = 매치율 1순위 리턴값만 사용 (ex response.categ_row_no5 = 5순위 리턴값)
		var categ_row_no = response.categ_row_no1;
		
		mySheet.SetCellValue(categ_row_no, "CATEG_PATH", response.categPath1);
		mySheet.SetCellValue(categ_row_no, "CATEG_NAME", response.categName1);
		mySheet.SetCellValue(categ_row_no, "CMS_CATEG_ID", response.cmsCategId1);
		mySheet.SetCellValue(categ_row_no, "SG_ID", response.sgId1);
		mySheet.SetCellValue(categ_row_no, "SG_NAME", response.sgName1);
		
		if(AjaxCallCount == maxRow){
			if(AjaxSuccCount == maxRow){
				loader_obj("N");
				AjaxFailFlag = "N";
				alert("추천이 성공적으로 완료되었습니다.");
			}else{
				loader_obj("N");
				alert("추천 중 오류가 발생하였습니다. 관리자에게 문의 바랍니다.");
			}
		}
    }
}

/**
* ajax 공통 호출후 에러시 처리 함수
*/
function  kepAjaxError(pMethod , response) {
	if(pMethod == "DQCAT"){
		var maxRow = mySheet.RowCount();
		AjaxCallCount++;
		
		if(AjaxCallCount == maxRow){
			if(AjaxFailFlag == "Y"){
				loader_obj("N");
				alert("추천 중 오류가 발생하였습니다. 관리자에게 문의 바랍니다.");
			}
		}
	}
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
	loader_obj("N");
	var maxRowCount = maxAllowRow + 1;
	
	if(mySheet.RowCount() == 0){
		alert("일괄 업로드를 실패하였습니다. 관리자에게 문의바랍니다.");
	}else{
		if(maxRowCount < mySheet.RowCount() + 1) {
			alert(maxAllowRow + "건 이하의 파일만 업로드하여 주세요.");
			mySheet.RemoveAll();
			return;
		}else{
			alert("일괄 업로드를 완료하였습니다.");	
		}
	}
}
</script>
</head>

<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>표준카테고리 추천</h3>
        	<span class="btn_search"><a href="javascript:doAction('categ')">추천</a></span>  
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
  					<span class="btn_04"><a href="/resources/excel/work/CATALOG/masterMdCmStndCategRcmd.xls">등록양식</a></span>
  					&nbsp;※ <b><font color="red">일괄 업로드 시 등록양식을 다운받은 후 기입하여 주시기 바랍니다.</font></b>
  				</span>
				
  	          	<span class="fr">
  					<span class="btn_04 mr04" style="display:none"><a href="javascript:doAction('excelDown');">다운로드</a></span>
  					<span class="btn_02 mr04"><a href="javascript:addrows();">행추가</a></span>
  					<span class="btn_02 mr04"><a href="javascript:doAction('deleteRows');">행삭제</a></span>
  				</span> 
  			 </div>
  			 
<!--내용 종료-->	                 
<form name="categForm" id="categForm" method="post" action ="">
	<input type="hidden" name="categ_target_rate" id="categ_target_rate" value="60">
	<input type="hidden" name="categ_target_count" id="categ_target_count" value="1">
	<input type="hidden" name="categ_row_no" id="categ_row_no" value="">
    <input type="hidden" name="categ_desc" id="categ_desc" value="">
    <input type="hidden" name="categ_spec" id="categ_spec" value="">
    <input type="hidden" name="categ_maker" id="categ_maker" value="">
    <input type="hidden" name="categ_model" id="categ_model" value="">
    <input type="hidden" name="categ_desc_flag" id="categ_desc_flag" value="true">
    <input type="hidden" name="categ_spec_flag" id="categ_spec_flag" value="true">
    <input type="hidden" name="categ_maker_flag" id="categ_maker_flag" value="true">
    <input type="hidden" name="categ_model_flag" id="categ_model_flag" value="false">
</form>
</body>
</html>
