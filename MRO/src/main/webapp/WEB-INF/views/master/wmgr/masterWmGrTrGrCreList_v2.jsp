<%--
**********************************************
* 메뉴 : 입고>입고등록>TR입고
* 화면 : TR입고
* 기능 : TR 입고 예정정보 조회 및 입고확정
* 프로그램 ID : 
* 담당자 : 최찬규
* 착수일 : 2026-09-23
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%@ page import="java.util.*"%> 
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%
	String buyer = "";
	String userid = "";
	if (_sessionInfo != null){
		buyer =  CommonUtil.nvl((String)_sessionInfo.getComCode()); 	
		userid =  CommonUtil.nvl((String)_sessionInfo.getUserId());  		
	} 
	String st_warehouse_code = CommonUtil.nvl((String) request.getParameter("st_po_user_id"),""); 
	String whAdmin = _sessionInfo.getWhAdmin();
%> 
<script src="/resources/js/common.js"></script>
<script src="/resources/js/wms_tr_sheet.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var CarOn = "/resources/images/btn_search03.gif";
var LocationOn = "/resources/images/btn_search03.gif";

var unit = KepSheetComboQueryIdData("getUnitMeasureInfo","");
var grbRow = "";
// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view(){
	var initsheet = {};
	initsheet.Cols = [ 
		                 { Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
		                    ,{ Align:"Center",	Width:40,	Edit : true,	EditLen:0,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"}
							,{ Align:"Center",	Width:100,	Edit : false,	EditLen:0,	Hidden : false,	Type:"Text", Header:"상태",	SaveName:"STATUS"}
							,{ Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : false,	Type:"Text", Header:"간선출발",	SaveName:"DEPT_WAREHOUSE"}
							,{ Align:"Center",	Width:60,	Edit : false,	EditLen:0,	Hidden : false,	Type:"Text", Header:"간선도착",	SaveName:"DEST_WAREHOUSE"}
							,{ Align:"Center",	Width:50,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Text", Header:"간선여부",	SaveName:"HUB_YN"}
							,{ Align:"Center",	Width:100,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Text", Header:"간선출고여부",	SaveName:"HUB_IV_YN"}

							,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"발주번호",	SaveName:"PO_NO"}
							,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"LEGACY_NO",	SaveName:"LEGACY_PO_NO"}
							,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"입고번호",	SaveName:"INV_NO"}
							,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"묶음배송",	SaveName:"DELY_BUNDLE_FLAG"}
							,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",Format:"Ymd",	Header:"발주일",	SaveName:"PO_CREATE_DATE"}
							,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",Format:"Ymd",	Header:"납품요청일",	SaveName:"RD_DATE"}
							,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",Format:"Ymd",	Header:"입고예정일",	SaveName:"GR_DATE_RE"}
							,{ Align:"Center",	Width:90,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Date",  Format:"Ymd",	Header:"* 출고예정일",	SaveName:"SCHEDULED_DATE", BackColor:"${notnullColor}"}

							,{ Align:"Left",	Width:250,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"고객사코드",	SaveName:"BUYER"}
							,{ Align:"Left",	Width:150,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사",	SaveName:"BUYER_NAME"}
							,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"협력사",	SaveName:"AGENT_NAME"}					
							
							,{ Align:"Right",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Int", Format:"Integer", 	Header:"총 품목건수",	SaveName:"PO_CNT"}
							,{ Align:"Right",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type : "Float", Format:"Integer",  Header:"총 금액", 	SaveName:"ITEM_AMT"}

							,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"배송처",	SaveName:"DELY_TO_LOCATION_IMG"}
							,{ Align:"Left",	Width:290,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"배송처",	SaveName:"DELY_TO_LOCATION"}
							,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"요청자",	SaveName:"ADD_USER_NAME"}
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"요청자ID",	SaveName:"BTOA_USER_ID"}
							
							,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"구분",	SaveName:"DOC_TEXT"}
							,{ Align:"Right",	Width:80,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Float", Format:"Integer", 	Header:"* 박스수량",	SaveName:"BOX_QTY", BackColor:"${notnullColor}" }

							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"차량아이디",	SaveName:"CAR_ID"}
							,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"차량", 	SaveName:"CAR_NO_IMG",BackColor:"${optColor}" }
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"차량번호", 	SaveName:"CAR_NO"}
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"차량기사",	 SaveName:"CAR_PERSON_NAME"}
							,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"연락처",	SaveName:"CAR_PERSON_TEL"}
							,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"지연사유",	SaveName:"DELAY_REMARK_IMG",BackColor:"${optColor}" }
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"지연사유",	SaveName:"DELAY_REMARK"}
							,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Image",	Header:"비고",	SaveName:"PO_REMARK_IMG"}
							,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"비고",	SaveName:"PO_REMARK"}
				  		,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"SCM비고",	SaveName:"SCM_REMARK"}
							,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Image",	Header:"SCM비고",	SaveName:"SCM_REMARK_IMG"}
							,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"협력사코드",	SaveName:"AGENT"}
							,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"구매사발주번호",	SaveName:"LEGACY"}
							,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"요청자명",	SaveName:"ADD_USER_NAME_ORG"}
							,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"협력사명",	SaveName:"AGENT_NAME_ORG"}
							,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"요청자TEL",	SaveName:"ADD_USER_TEL"}
							,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"공급사TEL",	SaveName:"AGENT_TEL_NO"}
							,{ Align:"Center",	Width:90,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",Format:"Ymd",	Header:"센터예정일",	SaveName:"CENTER_SCHD_DATE"}
	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:2};
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//비고이미지설정
	mySheet.SetImageList(0, remarkOn);
	mySheet.SetImageList(1, CarOn);
	mySheet.SetImageList(2, LocationOn);
	
	//콤보데이터 셋팅		
	var serch_text = "st_user_id="+document.searchCondition.st_user_id.value+"&st_com_code="+document.searchCondition.st_com_code.value;
	
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "INV_NO"); //입고번호
	setLinkCol(mySheet, "DELY_TO_LOCATION_IMG"); 
	setLinkCol(mySheet, "CAR_NO_IMG"); 
	setLinkCol(mySheet, "DELAY_REMARK_IMG"); 
	setLinkCol(mySheet, "PO_REMARK_IMG"); 
	setLinkCol(mySheet, "PO_NO");
	setLinkCol(mySheet, "BUYER_NAME");
	setLinkCol(mySheet, "AGENT_NAME");
	setLinkCol(mySheet, "SCM_REMARK_IMG");
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	kepSetCalender("in_ivk_date");
	
	$("#st_to_date").val( kepToMonthAdd("1","P"));
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#in_ivk_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
	
}
	

var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();

	// 선택된 항목 유무 체크
	//if (str !="search" && str !="excelDown" && str !="reload" && selectedGrid.length == 0) {
	//	alert("선택된 항목이 없습니다.");
	//	return;
	//}
	
	switch (str) {
	case "search":	 // 조회
		current_page = -1;
		
				
		if(kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val())== false){
			return;			
		}
		//기간무시
	    if(document.getElementById("st_checkbox").checked == true){
	    	$("#st_all_po").val('Y');		
	    	var po_no			= $("#st_po_no").val();
	    	var iv_no			= $("#st_iv_no").val();
			if( po_no =="" && iv_no == ""){
				alert("기간을 무시하고 조회시\n\n고객사 선택후\n\n발주번호, 입고번호 중\n\n한가지 이상을 정확히(전체입력) 기입해야 합니다.");	
				return;
			}			
		}else{
			$("#st_all_po").val('N');
			if (kepGetDateDiff('st_from_date','st_to_date','D') > 93 ){
				alert("조회기간을 3개월 단위로 조회가 가능합니다.\n\n3개월 이상의 데이타는 S/R 요청 바랍니다.");
				return ;
			}			
		}
	    if(document.getElementById("st_checkbox1").checked == true){
	    	$("#st_hub_yn").val('Y');		
		}else{
			$("#st_hub_yn").val('N');
		}
		kepSearch(document.searchCondition,  mySheet , "/wmgr/getMasterWmGrTrGrCreList.do" , pagingMode );
		break;
	
	case "reload":	// 초기화
		kepReload('searchCondition');
		mySheet.RemoveAll();
		// 조회조건 초기화
		kepSetCalender("st_from_date");
		kepSetCalender("st_to_date");
		kepSetCalender("in_ivk_date");
		
		$("#st_to_date").val( kepToMonthAdd("1","P"));
		$("#st_from_date").val( kepToMonthAdd("1","M"));
		$("#in_ivk_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
		
		document.getElementById('st_ivk_flag').checked = false;
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
		
		document.getElementById("st_checkbox").checked = false;
		document.getElementById("st_checkbox1").checked = false;
		
		$("#st_buyer_code").val("");
		
		break;

	case "save": // 저장
	 	var row_num = 0;
	 	var ivk_flag = document.getElementById('st_ivk_flag').checked;
	 	
	 	//출고지시
	 	if(ivk_flag) {
			var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	 	 	var arrRow = selectedGrid.split("|");
	 	 	if(selectedGrid.length == 0)
	 	 	{
	 	        alert(" 출고지시 대상을 선택해 주십시요.");
	 	        return;
	 	 	}

	 	 	for(var i = 0 ; i <arrRow.length; i++){
	 	 		if(mySheet.GetCellValue(arrRow[i],'HUB_YN') == "Y"){
	 	 			alert("간선입고건은 출고지시가 불가합니다. 출고지시 화면에서 직접 진행해주시기 바랍니다.");
	 	 			return;
	 	 		}
	 	 		
	 	 		if(mySheet.GetCellValue(arrRow[i],'BUYER') == "KRDAEW0016"){
	 	 			
	 	 			if(mySheet.GetCellValue(arrRow[i],'CAR_NO') == ''){
	 	 					alert('차량정보를 입력 해주세요 ');
	 	 					mySheet.SelectCell(arrRow[i], 'CAR_NO_IMG', 1);
	 	 					return;
	 	 			}
	 	 			
	 	 		}
	 	 		//묶음배송
	 	 		if(mySheet.GetCellValue(arrRow[i],'DELY_BUNDLE_FLAG') == "Y"){
	 					alert('묶음배송건은 입고확정 처리만 가능 합니다. ');
 	 					return;	 	 			
	 	 		}
	 	 	}
	 	 //두산모트롤BG 창원공장) 납품요청일 익월 출고지시 불가 
	 	 //SLOGIC-BEGIN(P08-0000002-02) 
	 	 // controller에서 체크
	 	 //SLOGIC-END
			if (!confirm('선택사항을 센터 입고 및 출고를 하시겠습니까? '))
				return;
	 		
	 		var in_ivk_date = document.getElementById('in_ivk_date');
	 		document.searchCondition.st_ivk_date.value = in_ivk_date.value;
	 		document.searchCondition.st_ivk_yn.value ="Y";
	 		kepSave(document.searchCondition ,  mySheet , "/wmgr/saveMasterWmGrTrGrCreList_v2.do" , "SELECTED" );
	 	} else { // 입고확정
	 		document.searchCondition.st_ivk_yn.value ="";
	 	 	
	 	 	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	 	 	var arrRow = selectedGrid.split("|");
	 	 	
	 	 	if(selectedGrid.length == 0){
	 	        alert(" 입고확정 대상을 선택해 주십시요.");
	 	        return;
	 	 	}
			
	 	 	if (!confirm('선택사항을 센터 입고 하시겠습니까? '))
				return;
			
	 	 	kepSave(document.searchCondition ,  mySheet , "/wmgr/saveMasterWmGrTrGrCreList_v2.do" , "SELECTED"  );
	 	}
	 		
		break;
	
	//case "doosan":
		//kepSave(document.searchCondition ,  mySheet , "/wmgr/saveMasterWmGrTrGrCreDoosanIF.do" , "SELECTED"  );
		//break;


	case "excelDown": // 엑셀다운로드
		$("#pageflag").val("0");
		var param = {FileName:"TR입고.xlsx",
			DownCols:"STATUS|BUYER_NAME|PO_CREATE_DATE|RD_DATE|PO_CNT|DELY_TO_LOCATION|ADD_USER_NAME_ORG|ADD_USER_TEL|AGENT_NAME_ORG|AGENT_TEL_NO|GR_DATE_RE|PO_NO|LEGACY|INV_NO|DOC_TEXT|AGENT_CODE|AGENT|BUYER|CENTER_SCHD_DATE"};
	    kepDownExcel(document.searchCondition ,mySheet , "/wmgr/excelMasterWmGrTrGrCreList.do", param);
	    $("#pageflag").val('1');
		break;
	}
}
function mySheet_OnDownFinish(downloadType, result) {

    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거

}	
// 그리드 표시후 처리	 
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
	
	for(var i= 1 ; i<mySheet.GetTotalRows()+1; i++)
	{

			mySheet.SetCellValue(i, 'CAR_NO_IMG', remarkOn);

		
		if(mySheet.GetCellValue(i,"PO_REMARK")=="")
		{
			mySheet.SetCellValue(i, 'PO_REMARK_IMG', remarkOff);
		}
		else{
			mySheet.SetCellValue(i, 'PO_REMARK_IMG', remarkOn);
		}
		
		if(mySheet.GetCellValue(i,"DELY_TO_LOCATION")!="")
		{
			mySheet.SetCellValue(i, 'DELY_TO_LOCATION_IMG', remarkOn);
		}
		else{
			mySheet.SetCellValue(i, 'DELY_TO_LOCATION_IMG', remarkOff);
		}
		
		
		if(mySheet.GetCellValue(i,"DELAY_REMARK")==""){
			
			mySheet.SetCellValue(i, 'DELAY_REMARK_IMG', remarkOff);
		
		}else{
			
			mySheet.SetCellValue(i, 'DELAY_REMARK_IMG', remarkOn);
		
		}
		
		if(mySheet.GetCellValue(i,"STATUS") == "발주"){
			mySheet.SetCellEditable(i, "SELECTED", 0);
		}
		
		if(mySheet.GetCellValue(i,"HUB_IV_YN") == "N"){
			mySheet.SetCellEditable(i, "SELECTED", 0);
		}
		
		if(mySheet.GetCellValue(i,"SCM_REMARK")==""){
			mySheet.SetCellValue(i, 'SCM_REMARK_IMG', remarkOff);
		}else{
			mySheet.SetCellValue(i, 'SCM_REMARK_IMG', remarkOn);
		}
		
	}
	
	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}

}
	
//출고지시 출력물 리스트
function setWmsTrSheetList(ivk_list){

	var st_user_id = document.searchCondition.st_user_id.value;
	var st_warehouse_code = document.searchCondition.st_warehouse_code.value; 
	
	openSearchPopup('/wmco/showMasterWmCoTranStatementPop.do','?st_warehouse_code='+st_warehouse_code+'&st_ivk_list='+ivk_list+'&st_user_id='+st_user_id, "800,500,no"); 
}
	
// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	

	if(code==1){
		
		alert("정상적으로 센터 입고 및 출고지시가 되었습니다.");		
		var msgArr =  msg.split("$$");
		
		//저장 성공시 재조회
		if(msg.substring(0, 8) == "GR_IK_OK"){
			
			
			var st_user_id = document.searchCondition.st_user_id.value;
			var st_warehouse_code = document.searchCondition.st_warehouse_code.value; 
			
			openSearchPopup('/wmco/showMasterWmCoTranStatementPop.do','?st_warehouse_code='+st_warehouse_code+'&st_ivk_list='+msgArr[0].substring(10)+'&st_user_id='+st_user_id, "700,400,no"); 
	
		}
		
		if(""!=msgArr[1]){
			$('#st_ivk_list').val(msgArr[1]);
			document.searchCondition.value = msg[1];
			//두산 인프라  코어 IF 저장
			doAction('doosan');
		
		}
		doAction('search');
		
		
	}else if(code==0){
		if (msg != "") {
			alert(msg);
		}
	}else if(code==2){
		alert("정상적으로 센타 입고가 되었습니다.");
		 doAction('search');
	}else if(code==3){
		alert("센타 입고가 실패 하였습니다.\n\n본사 시스템운영팀으로 연락바랍니다");
	}else if(code==4){
		alert("(주)두산 모트롤BG 창원공장은 출고지시에 제약이 있으므로,\n출고 메뉴를 통해서 출고지시 하시기 바랍니다.");
	}else if(code==5){
		var msgGr =  msg.split("@@");
		alert("입고번호  "+ msgGr[1]+"는 기 등록된 입고 입니다.");
	}
	
	
}




// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/wmgr/getMasterWmGrTrGrCreList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	
	switch (str) {
		case "buyer_multi": // 고객사 M
	    var ware_house_code = document.searchCondition.st_warehouse_code.value;
	    var st_from_date = document.searchCondition.st_from_date.value;
	    var st_to_date = document.searchCondition.st_to_date.value;
	    openSearchPopup('/wmco/showMasterWmCoMbrcmpyCountPop.do','?ware_house_code='+ware_house_code+'&st_from_date='+st_from_date+'&st_to_date='+st_to_date, "500,500,no"); 
        popupSel = "buyer_multi";
        break;
		
		case "buyer_multi_b": // 고객사 M
			openSearchPopup('/common/safetyCompanyCodePop.do','?COM_TYPE=B', '880,450,no');
	        popupSel = "buyer_multi_b";
		break;
		case "agent_multi": // 협력사 M
			openSearchPopup('/coco/showCommonCoCoCompanyPop.do','?com_type=S&multi_flag=M&safety_flag=undefined&save_flag=undefined', "500,500,no"); 
			popupSel = "agent_multi";
			break;	
		case "poMulti":
			if($("#st_po_no_type").val() == "MI"){
				openSearchPopup('/common/multiSearchCondPop.do','?header_text=품목코드',"300,400,no");
				popupSel = "poMulti";
				break;	
			}
	}
}

function localDateEval(RD_DATEval)
{
	 	var yyyy = RD_DATEval.substr(0,4);
	 	var mm = eval(RD_DATEval.substr(4,2) + "- 1") ;
		var dd = RD_DATEval.substr(6,2);
    	var dt3 = new Date(yyyy, mm, eval(dd + '-' +'2'));
	   	 yyyy = dt3.getFullYear();
		 mm = (dt3.getMonth()+1)<10? "0" + (dt3.getMonth()+1) : (dt3.getMonth()+1) ;
		 dd = dt3.getDate()<10 ? "0" + dt3.getDate() : dt3.getDate();
		 return  "" + yyyy + "/" + mm + "/" + dd ;
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if(column == 'BUYER_NAME'){
		if(mySheet.GetCellValue(Row,'BUYER_NAME')!=""){
			
			 var com_code = mySheet.GetCellValue(Row,'BUYER');
			 var st_from_date = document.searchCondition.st_from_date.value;
			 var st_to_date = document.searchCondition.st_to_date.value;
			 openSearchPopup('/mdcp/showMasterMdCpCompyDetailViewPop.do','?com_code='+com_code+'&st_from_date='+st_from_date+'&st_to_date='+st_to_date, "800,600,no"); 
			popupSel = "masterMdCpCompyDetailViewPop";
		}
	}else if(column == 'PO_NO'){
		if(mySheet.GetCellValue(Row,'PO_NO')!=""){
			
		    var ware_house_code = document.searchCondition.st_warehouse_code.value;
		    

			var buyer = mySheet.GetCellValue(Row,'BUYER');
	    	var po_no = mySheet.GetCellValue(Row,'PO_NO');
	    	var inv_no = mySheet.GetCellValue(Row,'INV_NO');
	    	var BUYER_NAME  = mySheet.GetCellValue(Row,'BUYER_NAME');
	    	var PO_CREATE_DATE = mySheet.GetCellText(Row,'PO_CREATE_DATE');
	    	var RD_DATEval = mySheet.GetCellValue(Row,'RD_DATE');
	    	var DOC_TEXT = mySheet.GetCellValue(Row,'DOC_TEXT');
	    	var GR_DATE_RE = localDateEval(RD_DATEval);
	    	var ADD_USER_NAME = mySheet.GetCellValue(Row,'ADD_USER_NAME');
	    	var DELY_TO_LOCATION = mySheet.GetCellValue(Row,'DELY_TO_LOCATION');
	    	var PO_REMARK = mySheet.GetCellValue(Row,'PO_REMARK');
	    	var AGENT_NAME = mySheet.GetCellValue(Row,'AGENT_NAME');
	    	var st_STATUS = "TR";
	    	var st_LEGACY_PO_NO = mySheet.GetCellValue(Row,'LEGACY_PO_NO');
	    	var st_DELY_TO_LOCATION = mySheet.GetCellValue(Row,'DELY_TO_LOCATION');
	    	var st_RD_DATE = mySheet.GetCellText(Row,'RD_DATE');
	    	var AGENT = mySheet.GetCellValue(Row,'AGENT');
	    	var AGENT_NAME_ORG = mySheet.GetCellValue(Row,'AGENT_NAME_ORG');
	    	var AGENT_TEL_NO = mySheet.GetCellValue(Row,'AGENT_TEL_NO');
	    	openSearchPopup('/wmgr/showMasterWmGrTrOrderGrRegPop.do','?BUYER='+buyer+'&PO_NO='+po_no+'&BUYER_NAME='+BUYER_NAME+'&PO_CREATE_DATE='+PO_CREATE_DATE+'&DOC_TEXT='+DOC_TEXT+'&GR_DATE_RE='+GR_DATE_RE+'&ADD_USER_NAME='+ADD_USER_NAME+'&DELY_TO_LOCATION='+DELY_TO_LOCATION+'&PO_REMARK='+PO_REMARK+'&AGENT_NAME='+AGENT_NAME+'&ware_house_code='+ware_house_code+'&st_STATUS='+st_STATUS+'&st_LEGACY_PO_NO='
	    			+st_LEGACY_PO_NO+'&st_DELY_TO_LOCATION='+st_DELY_TO_LOCATION+'&st_RD_DATE='+st_RD_DATE+'&st_AGENT_NAME_ORG='+AGENT_NAME_ORG+'&st_AGENT_TEL_NO='+AGENT_TEL_NO+'&AGENT='+AGENT, "900,500,no"); 
			popupSel = "masterWmGrTrOrderManagerPop";
		}
	}else if(column == 'INV_NO'){
/*
		if(mySheet.GetCellValue(Row,'HUB_YN') == "Y"){
			alert("간선 입고건은 불가합니다.");
			return;
		}
*/
		if(mySheet.GetCellValue(Row,'INV_NO')!=""){
		    var ware_house_code = document.searchCondition.st_warehouse_code.value;
			var buyer = mySheet.GetCellValue(Row,'BUYER');
	    	var po_no = mySheet.GetCellValue(Row,'PO_NO');
	    	var inv_no = mySheet.GetCellValue(Row,'INV_NO');
	    	var dely_bun_flag = mySheet.GetCellValue(Row,'DELY_BUNDLE_FLAG');
	    	var hub_yn = mySheet.GetCellValue(Row,'HUB_YN');
	    	openSearchPopup('/wmco/showMasterWmCoWarehousingDetailPop_v2.do','?st_buyer='+buyer+'&st_po_no='+po_no+'&st_inv_no='+inv_no+'&ware_house_code='+ware_house_code+'&st_dely_bun_flag='+dely_bun_flag+'&st_hub_yn='+hub_yn, "900,520,no"); 
			popupSel = "masterWmCoWarehousingDetailPop";
		}
	}else if(column=="CAR_NO_IMG" ){

			var buyer = mySheet.GetCellValue(Row,'BUYER');
			openSearchPopup('/wmgr/showMasterWmGrIntervalsInfoPop.do','?BUYER='+buyer, "800,380,no"); 
			popupSel = "masterWmGrIntervalsInfoPop";
		
	}else if(column=="PO_REMARK_IMG" ){
		if(mySheet.GetCellValue(Row,'PO_REMARK')!="")
		{
			var PO_REMARK = mySheet.GetCellValue(Row,'PO_REMARK');
			openSearchPopup('/common/remarkBtoAPop.do','?st_btoa_remark='+PO_REMARK, "500,220,no"); 
			popupSel = "remarkBtoA";
		}		
	}else if(column=="DELY_TO_LOCATION_IMG" ){
		if(mySheet.GetCellValue(Row,'DELY_TO_LOCATION')!="")
		{
			var DELY_TO_LOCATION = mySheet.GetCellValue(Row,'DELY_TO_LOCATION');
			openSearchPopup('/wmco/showMasterWmCoDlvryPop.do','?DELY_TO_LOCATION='+DELY_TO_LOCATION, "500,210,no"); 
			popupSel = "masterWmCoDlvryPop";
		}
	}else if(column=="DELAY_REMARK_IMG" ){
			var st_DELAY_REMARK = mySheet.GetCellValue(Row,'DELAY_REMARK');
			var st_BUYER = mySheet.GetCellValue(Row,'BUYER');
			var st_PO_NO = mySheet.GetCellValue(Row,'PO_NO');
			openSearchPopup('/wmco/showMasterWmCoDelayPop.do','?st_DELAY_REMARK='+st_DELAY_REMARK+'&st_BUYER='+st_BUYER+'&st_PO_NO='+st_PO_NO, "500,220,no"); 
			popupSel = "masterWmCoDelayPop";

	}else if(column=="AGENT_NAME" ){
		if(mySheet.GetCellValue(Row,'AGENT_NAME')!="")
		{
			 var com_code = mySheet.GetCellValue(Row,'AGENT');
			 var st_from_date = document.searchCondition.st_from_date.value;
			 var st_to_date = document.searchCondition.st_to_date.value;
			 openSearchPopup('/mdcp/showMasterMdCpCompyDetailViewPop.do','?com_code='+com_code+'&st_from_date='+st_from_date+'&st_to_date='+st_to_date, "800,600,no"); 
			popupSel = "masterMdCpCompyDetailViewPop";
		}
	}else if(column=="SCM_REMARK_IMG" ){
		var SCM_REMARK = mySheet.GetCellValue(Row,'SCM_REMARK');
		openSearchPopup('/common/remarkBtoAPop.do','?st_btoa_remark='+SCM_REMARK, "500,220,no"); 
	}

	return;
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2){
	
	//팝업 조회후 해당 항목에 값을 셋팅

	 if (popupSel == "buyer_multi") {	// 다중 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(value2);
	
	}else if(popupSel == "buyer_multi_b") {	// 다중 고객사
		$("#st_buyer_code").val(value1);
		$("#st_buyer_name").val(kepMultiName(value2,"@"));
	
	}
	 else if (popupSel == "masterWmGrIntervalsInfoPop") {	// 배송차량팝업
		
		var valueArr1 = value1.split('@');
	    var valueArr2 = value2.split('@');
		mySheet.SetCellValue(grbRow, 'CAR_ID', valueArr1[0]);
		mySheet.SetCellValue(grbRow, 'CAR_NO', valueArr1[1]);
		mySheet.SetCellValue(grbRow, 'CAR_PERSON_NAME', valueArr2[0]);
		mySheet.SetCellValue(grbRow, 'CAR_PERSON_TEL', valueArr2[1]);
	
	}else if(popupSel == "agent_multi"){
		
		$("#st_agent_code").val(value1);
		$("#st_agent_name").val(value2);
		
	}
	else if(popupSel =='masterWmCoWarehousingDetailPop')
	{
		
		doAction('search');
	}
	else 	if(popupSel == "masterWmCoDelayPop"){
	
		mySheet.SetCellValue(grbRow, 'DELAY_REMARK', value1);
		if(value1==""||value1==null){
			mySheet.SetCellValue(grbRow, 'DELAY_REMARK_IMG', remarkOff);
		}else{
			mySheet.SetCellValue(grbRow, 'DELAY_REMARK_IMG', remarkOn);
		}
	}else if(popupSel == "poMulti"){	
		$("#st_po_no_multi").val(value1);
		$("#st_po_no").val(kepMultiName(value1,"@"));
	}
	
	grbRow="";	//초기화
}



function mySheet_OnDownFinish(downloadType, result) {

    loader_obj("N"); // 엑셀 다운로드 완료시 로딩바 제거

}


//barcode reader
function fnCheckInputBacode(obj){

	$('#st_iv_no_barcode').val($('#st_iv_no_barcode').val()+",");
}


//barcode display
function fnBarcodeDisplay(obj){

	if(obj == "hide" || obj == "parcel"){
		
		document.getElementById('hidebarcode').style.display = "block";  
		document.getElementById('showbarcode').style.display = "none";  
		$('#st_iv_no_barcode').val('');
	}
	else if(obj == "show"){
		$('#st_iv_no').val('');
		document.getElementById('hidebarcode').style.display = "none";  
		document.getElementById('showbarcode').style.display = "block";  
	}
}

function resetItem(item_type){
	 if(item_type == "SI"){
		 $("#st_po_no").val("");
		 $("#st_po_no_multi").val("");
		 $("#st_po_no").attr("readonly", false);
	 }else if(item_type == "MI"){
		 $("#st_po_no").val("");
		 $("#st_po_no_multi").val("");
		 $("#st_po_no").attr("readonly", true);
	 }
}
	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>TR입고</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition" method = "post" onsubmit="return false" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<input type="hidden" name="st_ivk_list" id="st_ivk_list">
			<input type="hidden" name="st_ivk_date" id="st_ivk_date">
			<input type="hidden" name="st_ivk_yn" id="st_ivk_yn">
			<input type="hidden" name="st_sys_type"		id="st_sys_type"	 value ="WMS_GR_IK">
			<input type="hidden" id="pageflag" name="pageflag" value="1">			
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_com_code" name="st_com_code"  value="${sessionInfo.comCode}">
			<input type="hidden" name="st_all_po"  id="st_all_po" value ="N">
			<input type="hidden" name="st_hub_yn"  id="st_hub_yn" value ="N">
            	<table  class="cont_t_list01" >
					<caption>TR입고</caption>
					<colgroup>
							<col width="8%" />
							<col width="25%" />
							<col width="12%" />
							<col width="22%" />
							<col width="11%" />
							<col width="22%" />
					</colgroup>
						
					<tbody>
						<tr>
							<th>센터예정일</th>
							<td colspan="3">
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:20%; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_from_date')"></a> - 
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:20%; text-align:center;" value="">
									<a href="javascript:kepCalendar('st_to_date')"></a>
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','1')">1개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','2')">2개월</a></span> 
								<span class="btn_month"><a href="javascript:kepMonth('st_from_date','st_to_date','3')">3개월</a></span>
								<input type="checkbox"  class="Noborder" name="st_checkbox" id="st_checkbox">&nbsp;기간무시
								<input type="checkbox"  class="Noborder" name="st_checkbox1" id="st_checkbox1">&nbsp;간선포함					
							</td>							
							<th>물류센터</th>
							<td>
								<select id="st_warehouse_code" name="st_warehouse_code" style="width:80%;height:20px" 	<%=whAdmin.equals("Y") ? "" : "disabled"%>>
								<%
						 			Map<String, String> _map = new HashMap<String, String>();
						 			_map.put("BUYER",buyer);
						 			_map.put("USERID",userid);
						 			_map.put("whAdmin",whAdmin);
								%>
								<%= CommonUtil.getCodeComboQueryIdList("common.getWareHouseIdSchList","",_map,st_warehouse_code) %>
								</select>
							</td>
							</tr>
							<tr>
							<th>고객사</th>
							<td>
							    <input type="text" class="input_type_text" id="st_buyer_name" name="st_buyer_name" style="width:70%;" value=""  readonly onclick="javascript:doPop('buyer_multi_b');">
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:80%" value="">
								<a href="javascript:doPop('buyer_multi');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>
 
							<th>
								<select name = "st_po_no_type" id="st_po_no_type" style="height:20px" class="TitSelect" onchange="resetItem(this.value)">
						      		<option value="SI" selected="selected">발주번호</option>
									<option value="MI" >다중 발주번호</option>
                           		</select>
							</th>
							<td>
								<input type="text" class="al" name="st_po_no" id="st_po_no" style="width:70%;ime-mode:disabled; " value =""  maxlength="50" onblur="kepToUpper('st_po_no')" onkeydown="if(event.keyCode == 13) JavaScript:doAction('search');" onclick="javascript:doPop('poMulti')">
								<input type="hidden" name="st_po_no_multi" id="st_po_no_multi" style="width:100px;" value ="">
								<a href="javascript:kepEraser('st_po_no','st_po_no_multi');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th>
							    <select name="barcodeFlag" class="TitSelect" onchange="fnBarcodeDisplay(this.value);" >
									<option value="hide">입고번호</option>
									<option value="show">입고번호바코드</option>
									<option value="parcel">택배송장번호</option>
								</select></th>
							<td>
								<div name="hidebarcode" id="hidebarcode"><input type="text" class="al" id="st_iv_no" name="st_iv_no" style="width:78%;" value=""   onchange="fnCheckInputByte(this, 20);" onKeyUp="kepToUpper(id)" onkeydown="if(event.keyCode == 13) JavaScript:doAction('search');" ></div>
								<div name= "showbarcode" id="showbarcode" style="display:none;"><input type="text" class="al" id="st_iv_no_barcode" name="st_iv_no_barcode" style="width:78%;" value=""   onkeydown="if(event.keyCode == 13) JavaScript:fnCheckInputBacode(this);" / ></div>
								
							</td>
							</tr>	
																			
						<tr> 
							<th>협력사</th>
							<td>
								<input type="text" class="input_type_text" id="st_agent_name" name="st_buyer_item_no" readonly style="width:70%;" value="" onclick="javascript:doPop('agent_multi');">
								<input type="hidden" name="st_agent_code" id="st_agent_code" value=""  style="width:80%" value="">
								<a href="javascript:doPop('agent_multi');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_agent_code','st_agent_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>

							<th>상태</th>
							<td>
								<select id="st_status_check" name="st_status_check" style="width:80%;height:20px">
									<option value="">전 체</option>
									<option value="발주">발주</option>
									<option value="입고예정">입고예정</option>
              						<option value="분할입고예정">분할입고예정</option>
              						<option value="간선입고예정">간선입고예정</option>
								</select>
							</td>
							<th>구분</th>
							<td>
								<select id="st_doc_type" name="st_doc_type" style="width:80%;height:20px">
									<option value="">전 체</option>
              						<option value="N">일 반</option>
             	 					<option value="S">선입고</option>
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
						<option value="200">200건</option>
					</select>
					
					<b>* 간선센터에서 출고지시가 되지 않으면 입고가 불가합니다.</b>
				</span>
		   <span class="fr">
					<select name="st_order_by" id="st_order_by" style="width: 100px;" >
        <option  value="BRD">납품요청일순</option>
        <option  value="BGR">입고예정일순</option>
        <option  value="BUY">구매사순</option>
        <option  value="AGE">공급사순</option>
        <option  value="BPO">발주번호순</option>
        <option  value="BGN">입고번호순</option>
				</select>
			</span>	
			<br>
		</form>
	            			
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "354px");
  				</script>
  			<p class="paging" id="pageindex"></p>
  			</div>
  			
  			<!--버튼영역-->
  			<br/>
               <div class="btnArea">
  	          	<span class="fl">
  	          	<!--
  					<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">엑셀다운로드</a></span>
  				-->
  				</span>
  			
  				<span class="fr" >
  				<table border="0" cellspacing="0" cellpadding="0">
  					<tr>
  						<td>
  							<input type="checkbox" name="st_ivk_flag" id="st_ivk_flag" value="Y" style="cursor:pointer;"/><label for="st_ivk_flag" >출고지시</label>
  							<input type="text" class="input_type_text" name="in_ivk_date" id="in_ivk_date" size="10" readOnly style="width:100px; text-align:center;" value=""/>
  							<a href="javascript:kepCalendar('st_ivk_date')"></a></td>
  						<td>
  							&nbsp;
  							<span class="btn_02 mr04"><a href="javascript:doAction('save');" style="text-align:center;cursor:hand">입고확정</a></span> </td>
  					</tr>
  				</table>
  				
  				</span>
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
