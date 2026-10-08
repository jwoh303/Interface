<%--
**********************************************
* 메뉴 : 주문관리>납품서및 입고 일괄생성
* 화면 : 납품서및 입고 일괄생성
* 기능 : 납품서및 입고 일괄생성
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
String toDate			  = CommonUtil.formatDate(new Date(),1,"/");
%>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = ""; 
var tractionSel = "";
var searchSel = "";
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Center",	Width:50,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
					,{ Align:"Center",	Width:50,	Edit : true,	EditLen:80,	Hidden : false,	Type:"DummyCheck",	Header:"선택",	SaveName:"SELECTED"}
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:80,	Hidden:false,	Type:"Text",	Header:"담당자",	SaveName:"KEP_USER_ID"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:80,	Hidden:false,	Type:"Text",	Header:"고객사코드",	SaveName:"BUYER"}
					,{ Align:"Center",	Width:140,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사명",	SaveName:"BUYER_NAME_LOC"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:80,	Hidden:false,	Type:"Text",	Header:"발주번호",	SaveName:"PO_NO"} 
					,{ Align:"Center",	Width:80,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"발주항번",	SaveName:"PO_SEQ"} 
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"거래유형",	SaveName:"PROCESS_TYPE"}
					,{ Align:"Center",	Width:90,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"납품일",	SaveName:"IV_DATE"  , Sort:0 }
					,{ Align:"Center",	Width:90,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"배송확정일",	SaveName:"DI_DATE"  , Sort:0}
					,{ Align:"Center",	Width:90,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"입고일",	SaveName:"GR_DATE"  , Sort:0}
					
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"업로딩결과 ->",	SaveName:"X"}  
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:80,	Hidden:false,	Type:"Text",	Header:"상태",	SaveName:"JOB_FLAG"} 
					,{ Align:"Center",	Width:140,	Edit:false,	EditLen:80,	Hidden:false,	Type:"Text",	Header:"에러메세지",	SaveName:"JOB_MSG"} 
					,{ Align:"Center",	Width:110,	Edit:false,	EditLen:80,	Hidden:false,	Type:"Date",	Header:"등록일시",	SaveName:"JOB_DATM"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"MSDS",	SaveName:"MSDS_NO"}
	];
	initsheet.Cfg = {MergeSheet:msHeaderOnly, FrozenCol:12};
	IBS_InitSheet(mySheet, initsheet,pagingMode); 
	mySheet.SetCountPosition(4);
	
	mySheet.SetCellFontUnderline(0, "IV_DATE", true);	
	mySheet.SetCellFontUnderline(0, "DI_DATE", true);	
	mySheet.SetCellFontUnderline(0, "GR_DATE", true);	
	
	// 조회조건 초기화 
	kepSetCalender("st_create_date");
	kepSetCalender("st_rddate_date");
	kepSetCalender("st_dsdate_date");
	kepSetCalender("st_invoice_date");
	kepSetCalender("st_delivery_date");
	kepSetCalender("st_gr_date"); 
	 
	
	$("#st_process").val("N");
	$("#st_confirm_flag").val("N");
	$("#st_process_del").val("N");
	 
}

function formReset() {      $('#searchCondition').each(function(){         this.reset();   

$("#st_buyer_code").val("");
$("#st_req_user_id").val("");
$("#st_purchaser_id").val("");
$("#st_location_code").val("");
$("#st_reason_text").val("");
$("#st_reason_attkey").val("");
$("#st_purchaser_dept").val(""); 

});  }
		
var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");
	tractionSel = "";
	
	// 선택된 항목 유무 체크
	if (str !="search1" && str !="search" && str !="excelDown" && str !="excelUpload" && str !="orderCreate"  && str !="reload"  && str !="save" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
	
	case "search1":	 // 조회
	
	

		
		$("#st_process").val("N");
		$("#st_confirm_flag").val("N");
		$("#st_process_del").val("N");
		current_page = -1;  
		kepSearch(document.searchCondition,  mySheet , "/mpso/getMasterMpSoOrderIvGrCreationListExcelResult.do" , pagingMode );  
		break;
		
	case "search":	 // 조회 
	
		var buyer = $("#st_buyer_code").val();  	 
		if(buyer == "") {
			alert("고객사를 선택해 주십시오.  ");
			return;
		}
		current_page = -1;  
		kepSearch(document.searchCondition,  mySheet , "/mpso/getMasterMpSoOrderIvGrCreationListExcelResult.do" , pagingMode );  
		break;
	
	case "reload":	// 초기화
		formReset();
		mySheet.RemoveAll();
		$("#st_process").val("N");
		$("#st_confirm_flag").val("N");
		$("#st_process_del").val("N");
		$("#st_buyer_code").val("");
		$("#st_req_user_id").val("");
		$("#st_req_user_dept").val("");
		$("#st_purchaser_id").val("");
		$("#st_location_code").val("");
		$("#st_purchaser_dept").val("");
		$("#st_reason_attkey").val("");
	   	$("#diskimg").attr("src","/resources/images/disk_off.gif");  
		break;
		
	case "excelUpload":	// 엑셀업로드
		mySheet.RemoveAll();
		var params = {
			Mode : "HeaderMatch"
		};
		mySheet.LoadExcel(params);
		/*
		
      select buyer, BUYER_ITEM_NO ,UNIT_PRICE , LIST_PRICE ,AGENT  from ICOMCQDT where STATUS      <> 'D'  and buyer = 'KRKOLO0031';
        */
		break;

	case "excelDown":	// 양식다운로드 
		location.href = "/resources/excel/work/ORDER/masterIvGr.xlsx";
		break;
		
	case "excelCheck":	// 업로드검증 사용안함
		alert("엑셀업로드 검증 준비중"); 
		break;
		
	case "save":	// 업로드검증 결과를 저장 
	

		    if (confirm("엑셀업로드 검증 진행하시겠습니까?")==false) return; 
		    $("#st_process").val("AFTER");
		    kepSaveAll(document.searchCondition ,  mySheet , "/mpso/saveMasterMpSoOrderIvGrCreationListExcelCheckResult.do" );
	
		break;
		
	case "del":	// 삭제
	
		$("#st_process_del").val("DEL");
	    if (confirm("선택된 내역을 정말로 삭제하시겠습니까?")==false) return;
		kepSave(document.searchCondition ,  mySheet , "/mpso/delMasterMpSoOrderIvGrCreationList.do" , "SELECTED" );
		break;
		
	case "saving":	// 저장
		
		$("#st_process_del").val("N");
	    if (confirm("선택된 내역을 저장하시겠습니까?")==false) return;
		kepSave(document.searchCondition ,  mySheet , "/mpso/savingMasterMpSoOrderIvGrCreationList.do" , "SELECTED" );
		break;
		
	case "orderCreate":	// 주문생성
	 
	/*
		var confirm_flag = $("#st_confirm_flag").val(); 
		if(confirm_flag != "Y"){
			 alert("Uploading 검증되지 않았습니다. \n\n 파일 업로드 후 검증해주세요..!!  ");
			 return;
		}	  
		*/
		
		var cnt = 0;
		var errCnt=0;
		var title = "";
		var maxRow = mySheet.RowCount() + 1;     
	    for(var i = 2; i<=maxRow; i++){
// 	    	if (mySheet.GetCellValue(i, "SELECTED") == "1"){
				var JOB_FLAG = mySheet.GetCellValue(i, "JOB_FLAG");
				if (JOB_FLAG == "검증오류"||JOB_FLAG == "생성오류"){
					title = title + (i-1) + "행  ["+JOB_FLAG + "] \n";
					cnt ++;
					errCnt++;
				}
				else if (JOB_FLAG == "최초등록"){
					title = title + (i-1) + "행  [검증안한상태] \n";
					cnt ++;
				}
				
				var MSDS_NO = mySheet.GetCellValue(i, "MSDS_NO");
				if(MSDS_NO == "N"){
					alert("고객사 카탈로그의 MSDS 미매핑 품목입니다. 매핑 후 진행하시기 바랍니다.");
					mySheet.SelectCell(i, "PO_SEQ");
					return;
				}
// 	    	}
	    }  
	    
		if (cnt != 0){ 
			title = title + "주문생성 대상이 아닙니다.";
			alert(title);
			return;
		}
		
		if (errCnt != 0){ 
			title = title + "검증에 실패한 건이 존재 합니다. \n데이터를 다시 한번 확인해 주십시오.";
			alert(title);
			return;
		}
			 
		
		var maxRow = mySheet.RowCount() + 1;     
	    for(var i = 2; i<=maxRow; i++){
	    	//mySheet.SetCellValue(i,"SELECTED","1");
	    }  
		$("#st_process").val("ORDERCREATE"); 
		$("#st_process_del").val("N");
// 		kepSave(document.searchCondition ,  mySheet , "/mpso/saveMasterMpSoBuyerOrderCreationList.do" , "SELECTED" );
		kepSaveAll(document.searchCondition ,  mySheet , "/mpso/saveMasterMpSoOrderIvGrCreationList.do");
		break;
		
	}
}

function mySheet_OnLoadExcel() {
 
	if (10000 < mySheet.RowCount() + 1) {
		alert("10000건이하의 파일만 업로드하여 주세요.");
		mySheet.RemoveAll();
		return;
	} 
	setSaveGridtoDB();
}


function setSaveGridtoDB(){	  
	var maxRow = mySheet.RowCount() + 1;     
	 
    for(var i = 1; i<=maxRow; i++){
    	mySheet.SetCellValue(i,"SELECTED","1");
    }  
	$("#st_confirm_flag").val("N");
	$("#st_process").val("BEFORE");
	kepSave(document.searchCondition ,  mySheet , "/mpso/saveMasterMpSoOrderIvGrCreationListExcelCheck.do" , "SELECTED" );
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

   	
	var maxRow = mySheet.RowCount() + 1;     
	if (msg != "") { 
		alert(msg);
	}
	
	if ($("#st_process_del").val() == "DEL") {    // 삭제
	}else{		
		if ($("#st_process").val() == "BEFORE"){ // 엑셀 업로드 검증 후 결과 조회 를 보고 저장실행		
		    for(var i = 2; i<=maxRow; i++){
		    	mySheet.SetCellValue(i,"SELECTED","1");
		    }  
			doAction('save');
		} else if ($("#st_process").val() == "AFTER"){ 
			/*
		    for(var i = 2; i<=maxRow; i++){
		    	mySheet.SetCellValue(i,"SELECTED","1");
		    }  
		    $("#st_process").val("ORDERCREATE");
			doAction('orderCreate');// 주문생성
			*/
		} else{ 
			$("#st_process").val("N"); 
		}		
	}  
// 	if ($("#st_process").val() == "ORDERCREATESUCCESS" || $("#st_process").val() == "ORDERCREATE") {// 주문생성
// 	}else{
// 	    for(var i = 2; i<=maxRow; i++){ 
// 	    	if (kepTrimStr(mySheet.GetCellValue(i,"TOT_FLAG_TEXT")) != ""){
// 	    		 $("#st_process").val("AFTER");
// 	    	}
// 	    }  
// 	}
	

	/*
	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	*/
	
}
	
// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	var docu_no = "";
	if ($("#st_process").val() == "ORDERCREATE"){ // 주문생성
		if (msg != "") {
			docu_no = msg;
		}
	}else{
		if (msg != "") {
		//	alert(msg);
		}
	}
	if(code == 0){
		alert(msg);
		mySheet.RemoveAll();
		return;
	}
	 
	$("#st_confirm_flag").val("N");	 
	if ($("#st_process_del").val() == "DEL") {    // 삭제
	}else{		
		if ($("#st_process").val() == "BEFORE"){ // 엑셀 업로드 검증 후 결과 조회  
			doAction("search");
			return;
		} else if ($("#st_process").val() == "AFTER"){  // 엑셀업로드 검증결과 저장 
			$("#st_confirm_flag").val("Y");
			doAction("search");
			return;
		} else if ($("#st_process").val() == "ORDERCREATE"){ // 주문생성 
			alert("처리가 되었습니다.");
			doAction("search");
		}  

	}
	if(code>0){
		//저장 성공시 재조회
		doAction('search');
	}
}

function kepApprovalReturn(flag,docu_no){
	
	$("#st_confirm_flag").val("N");	  
	$("#st_process").val("ORDERCREATESUCCESS");	  
	$("#st_process_del").val("N");
	
	doAction("search");
}

function setFileAttach_Insert() {
	var type = "OF";
	var viewType = "C";
	var img_key = $("#st_reason_attkey").val(); 	   	
	popupSel = "setFileAttach_Insert";
	kepFileUploadOpenPopup(img_key,type,viewType); 
}
 
// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	//current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mpso/getMasterMpSoBuyerOrderCreationList.do" , pagingMode );
}


	
//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	
	
	var column = mySheet.ColSaveName(Col);

	if(column=="IV_DATE" && Row == 1){
		// 선택한 목록 체크 
		var selectedGrid = mySheet.FindCheckedRow("SELECTED");
		var arrRow = selectedGrid.split("|");
		
		if(selectedGrid.length == 2){ 
			alert("선택된 목록이 없습니다.");
			return;
		}	
		// 체크된것중 첫번째 입고일 가져오기
		var invDate = "";
		for(idx=0; idx<arrRow.length+1; idx++){
			if(idx == 0){
				invDate = mySheet.GetCellValue(arrRow[idx],"IV_DATE");
			} else {
				mySheet.SetCellValue(arrRow[idx],"IV_DATE",invDate); //입력값.
			} 
		}
	}
	
	if(column=="DI_DATE" && Row == 1){
		// 선택한 목록 체크 
		var selectedGrid = mySheet.FindCheckedRow("SELECTED");
		var arrRow = selectedGrid.split("|");
		
		if(selectedGrid.length == 2){ 
			alert("선택된 목록이 없습니다.");
			return;
		}	
		// 체크된것중 첫번째 입고일 가져오기
		var diDate = "";
		for(idx=0; idx<arrRow.length+1; idx++){
			if(idx == 0){
				diDate = mySheet.GetCellValue(arrRow[idx],"DI_DATE");
			} else {
				mySheet.SetCellValue(arrRow[idx],"DI_DATE",diDate); //입력값.
			} 
		}
	}
	
	if(column=="GR_DATE" && Row == 1){
		// 선택한 목록 체크 
		var selectedGrid = mySheet.FindCheckedRow("SELECTED");
		var arrRow = selectedGrid.split("|");
		
		if(selectedGrid.length == 2){ 
			alert("선택된 목록이 없습니다.");
			return;
		}	
		// 체크된것중 첫번째 입고일 가져오기
		var grDate = "";
		for(idx=0; idx<arrRow.length+1; idx++){
			if(idx == 0){
				grDate = mySheet.GetCellValue(arrRow[idx],"GR_DATE");
			} else {
				mySheet.SetCellValue(arrRow[idx],"GR_DATE",grDate); //입력값.
			} 
		}
	}
	if ( Row  < 2) return;
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	return;
}



//그리드 셀 변경시 이벤트
function mySheet_OnChange(Row, Col, Value) {
	if ( Row  < 2) return;
	var column = mySheet.ColSaveName(Col);
	
	if(column=="IV_DATE"){  //입고일.  

		mySheet.SetCellValue(Row,"SELECTED","1");
		  
	}
	
	if(column=="DI_DATE"){  //입고일.  

		mySheet.SetCellValue(Row,"SELECTED","1");
		  
	}
	
	if(column=="GR_DATE"){  //입고일.  

		mySheet.SetCellValue(Row,"SELECTED","1");
		  
	}
}


	</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>납품서및 입고 일괄생성</h3>
        	<span class="btn_search"><a href="javascript:doAction('search1')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition" id="searchCondition" method = "post" onsubmit="return false" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_kep_user_id" name="st_kep_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" name="st_confirm_flag" id="st_confirm_flag" value="">
			<input type="hidden" name="st_process" id="st_process" value="">
			<input type="hidden" name="st_process_del" id="st_process_del" value="">
			<input type="hidden" name="onepagerow" id="onepagerow" value="10">
            	<table  class="cont_t_list01" >
					<caption>납품서 및 입고 일괄생성</caption>
					<colgroup>
						<col width="8%" />
						<col width="25%" />
						<col width="8%" />
						<col width="25%" />
						<col width="8%" />
                        <col width="25%" />
					</colgroup>
						
					<tbody>
						 <tr>
						 		<th>조회기준</th>
								<td><input type="radio" class="Noborder" id = "st_ivgr_flag"  name="st_ivgr_flag" value="Y">&nbsp;전체&nbsp;&nbsp;
								<input type="radio" class="Noborder" id = "st_ivgr_flag"  name="st_ivgr_flag" value="N">&nbsp;오류</td>
							<td>
							</td>
							<td>
							</td>
							<td>
							</td>
						</tr>
					</tbody>
				</table>
            </div>
            &nbsp;<font color="red">* 엑셀 업로드시 로그인한 사용자아이디로 엑셀 작성후 업로드 하여야 조회가 됩니다.</font>
<!--            	<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/> -->
<!--                	<label for="b_no02" class="hidden">정렬개수선택</label> -->
<!-- 					<select name="onepagerow" style="width: 70px;" > -->
<!-- 					<option value="10" selected>10건</option> -->
<!-- 					<option value="20">20건</option> -->
<!-- 					<option value="30">30건</option> -->
<!-- 					<option value="40">40건</option> -->
<!-- 					<option value="50">50건</option> -->
<!-- 				</select> -->
<!-- 			</span> -->
			<br>
		</form>
					
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "354px");
  				</script>
  			</div>  			
  			<p class="paging" id="pageindex"></p>
  			
  			<!--버튼영역-->
               <div class="btnArea">
			<table style="width:100%;">
				<tr>
					<td colspan="2" height="25" align="left">
						&nbsp;&nbsp;* <font color="red">선택(체크)여부와 상관없이 화면에 조회된 모든 데이터가 일괄검증,생성됩니다.</font>
			        </td>
				</tr>
			    <tr>
			        <td height="25" align="left">
	  					<span class="btn_05 mr04"><a href="javascript:doAction('excelUpload');">엑셀업로드</a></span>
	  					<span class="btn_05 mr04"><a href="javascript:doAction('excelDown');">양식다운로드</a></span> 
	  					<!-- <span class="btn_07 mr04"><a href="javascript:doAction('save');">업로드검증결과저장</a></span> -->
			        </td>
			        <td height="25" align = "right" valign="middle">
			   		    <span class="btn_02"><a href="javascript:doAction('saving');">저장</a></span>
	  					<span class="btn_02 mr04"><a href="javascript:doAction('del');">삭제</a></span>
	  					<span class="btn_02"><a href="javascript:doAction('save');">검증</a></span>
	  					<span class="btn_02"><a href="javascript:doAction('orderCreate');">생성</a></span>
			        </td>
			    </tr>
			</table>
	
	               
<!--   	          	<span class="fl"> -->
<!--   				</span> -->
  				
<!--   				<span class="fr"> -->
<!--   				</span> -->
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
