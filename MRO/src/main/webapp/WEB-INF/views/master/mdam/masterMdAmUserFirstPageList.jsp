<%--
**********************************************
* 메뉴 : 관리자>메뉴관리>사용자관리
* 화면 : 사용자관리
* 기능 : 
* 프로그램 ID : PG_90_M_400_08
* 담당자 :  손상민 ( 설계 : 공통 )
* 착수일 : 2014-10-10
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%@ page import="java.text.SimpleDateFormat"%> 
<%@ page import="java.util.Date"%> 
<%@ page import="java.util.Locale"%>
<%
String com_code =  _sessionInfo.getComCode();
String user_dept =  _sessionInfo.getDepartment();
Date _currentDate = new Date();
SimpleDateFormat _formatter = new SimpleDateFormat ( "yyyy", Locale.KOREA );
int _toYear = Integer.parseInt(_formatter.format ( _currentDate ));	// 현재년도
%>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";
var searchImg="/resources/images/btn_search03.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var initsheet = {};
	initsheet.Cols = [
					 {Align:"Center",	SaveName:"sStatus",						Header:"상태",						Type:"Status",			Width:60,		Edit:false,	EditLen:0,		Hidden:true}
					,{ Align:"Center",	SaveName:"SELECTED",					Header:"",							Type:"DummyCheck",	Width:60,	Edit:true,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"SLG_ID",					Header:"특수로직ID",				Type:"Text",				Width:130,		Edit:false,	EditLen:20,	Hidden:true} 
					,{ Align:"Center",	SaveName:"COM_CODE",					Header:"회사코드",				Type:"Text",				Width:150,		Edit:false,	EditLen:20,	Hidden:false}
					,{ Align:"Left",	SaveName:"COM_NAME",					Header:"회사명",				Type:"Text",				Width:200,		Edit:false,	EditLen:20,	Hidden:false, ColMerge:1}
					,{ Align:"Center",	SaveName:"COM_NAME_IMG",					Header:"",				Type:"Image",				Width:20,		Edit:false,	EditLen:20,	Hidden:false}
					,{ Align:"Center",	SaveName:"USER_ID",					Header:"사용자ID",				Type:"Text",				Width:130,		Edit:true,	EditLen:400,	Hidden:false, BackColor:"${optColor}"}      
					,{ Align:"Center",	SaveName:"USER_NAME",		Header:"사용자명",				Type:"Text",				Width:130,		Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"USER_NAME_IMG",		Header:"사용자명",				Type:"Image",				Width:20,		Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"MENU_ID",					Header:"메뉴ID",				Type:"Text",				Width:130,		Edit:true,	EditLen:400,	Hidden:false, BackColor:"${optColor}"}      
					,{ Align:"Left",	SaveName:"MENU_NAME",					Header:"메뉴명",				Type:"Text",				Width:200,		Edit:false,	EditLen:400,	Hidden:false}      
// 					,{ Align:"Center",	SaveName:"MENU_NAME_IMG",		Header:"메뉴명",				Type:"Image",				Width:20,		Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"USER_NAME_M",		Header:"사용자명",				Type:"Text",				Width:150,		Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"USER_ID_M",					Header:"사용자ID(다중)",				Type:"Text",				Width:150,		Edit:false,	EditLen:400,	Hidden:true}      
					,{ Align:"Center",	SaveName:"COL04_DATA",					Header:"메뉴명",				Type:"Text",				Width:250,		Edit:false,	EditLen:400,	Hidden:true}      
					,{ Align:"Center",	SaveName:"COL05_DATA",					Header:"COL05",				Type:"Text",				Width:130,		Edit:false,	EditLen:400,	Hidden:true}      
					,{ Align:"Left",	SaveName:"IMP_NOTE",					Header:"비고",				Type:"Text",				Width:250,		Edit:true,	EditLen:2000,	Hidden:false, BackColor:"${optColor}"}        
					,{ Align:"Center",	SaveName:"COL06_DATA",					Header:"COL06",				Type:"Text",				Width:130,		Edit:false,	EditLen:100,	Hidden:true}       
					,{ Align:"Center",	SaveName:"COL07_DATA",					Header:"COL07",				Type:"Text",				Width:130,		Edit:false,	EditLen:100,	Hidden:true}       
					,{ Align:"Center",	SaveName:"COL08_DATA",					Header:"COL08",				Type:"Text",				Width:130,		Edit:false,	EditLen:100,	Hidden:true}       
					,{ Align:"Center",	SaveName:"COL09_DATA",					Header:"COL09",				Type:"Text",				Width:130,		Edit:false,	EditLen:100,	Hidden:true}       
					,{ Align:"Center",	SaveName:"COL10_DATA",					Header:"COL10",				Type:"Text",				Width:130,		Edit:false,	EditLen:100,	Hidden:true}      
					,{ Align:"Center",	SaveName:"OPEN_DATE",					Header:"등록일",				Type:"Text",				Width:130,		Edit:false,	EditLen:8,	Hidden:true}        
					,{ Align:"Center",	SaveName:"CLOSE_DATE",					Header:"종료일",				Type:"Text",				Width:130,		Edit:false,	EditLen:8,	Hidden:true}       
	];
	
	initsheet.Cfg = {MergeSheet:msHeaderOnly};
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	//이미지설정
	mySheet.SetImageList(1, searchImg);

	//하이퍼링크 설정
	setLinkCol(mySheet, "COM_NAME_IMG");
	setLinkCol(mySheet, "USER_NAME_IMG");
	setLinkCol(mySheet, "MENU_NAME_IMG");

}

var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	switch (str) {
		case "search":	 // 조회
			current_page = -1;
			kepSearch(document.searchCondition, mySheet, "/mdam/getMasterMdAmUserFirstPageList.do" , pagingMode );
			break;
		case "reload":	// 초기화
			kepReload('searchCondition');
			$('#st_com_code').val('');
			$('#st_com_name').val('');
			$('#st_user_id').val('');
			$('#st_user_name').val('');
			mySheet.RemoveAll();
			break;
		case "add": // 추가
		
			var rows = mySheet.DataInsert(-1);
			//초기값설정
			mySheet.SetCellValue(rows, "SELECTED", "1");
			mySheet.SetCellValue(rows, "SLG_ID","P07-0000020");
			mySheet.SetCellValue(rows, "COM_NAME_IMG", 1);
			mySheet.SetCellValue(rows, "USER_ID", "ALL");
			mySheet.SetCellValue(rows, "USER_NAME_IMG", 1);
			mySheet.SetCellValue(rows, "MENU_NAME_IMG", 1);
			
//				mySheet.SetCellValue(rows, "CREATE_DT", kepGetNowTimeStr('YYYYMMDD',''));
			break;
			
		case "save": // 저장
			// 선택된 항목 유무 체크
			if (selectedGrid.length == 0) {
				alert("선택된 항목이 없습니다.");return;
			}
			for( var i = 1; i <= mySheet.RowCount(); i++ ) {
				
				var code = mySheet.GetCellValue(i, "AUTH_ID");
				if($.trim(code) == ''){
					alert("["+i+"]번째 권한이 선택되지 않았습니다.");return;
				}
		    }
		
			if (!confirm('선택한 항목을 저장 하시겠습니까?'))
				return;
			kepSave(document.searchCondition ,  mySheet , "/mdam/saveMasterMdAmUserFirstPageList.do" , "SELECTED" );
			break;	
			
		case "del": // 삭제
			if (!confirm('선택한 항목을 삭제 하시겠습니까?'))
				return;
			kepSave(document.searchCondition ,  mySheet , "/mdam/delMasterMdAmUserFirstPageList.do" , "SELECTED" );
			break;
			
	}
}


// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");

	if (msg != "") {
		alert(msg);
	}

	if(current_page==-1){
		makePageIndex2(mySheet, 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2(mySheet, current_page , document.searchCondition.onepagerow.value);	
	}

}


// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mdam/getMasterMdAmUserFirstPageList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str, val) {
	popupSel = str;
	
	switch (str) {
		case "comCode": // 고객사 M
			var comtype = $("#st_com_gubun").val();
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND="+comtype+"&MULTI=N", "500,466,no");
			break;
		case "userPop":		// 담당자
			var comCode = $("#st_com_code").val();
			if(comCode == ''){
				alert("회사를 선택해 주십시오.");return;
			}
			openSearchPopup("/mdcp/getMasterMdCpUserChoicePop.do", "?st_buyer="+comCode, "500,500,no");
			break;	
	}
}
	
//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'COM_NAME_IMG' ) { 
		popupSel = column;
		var comtype = $("#st_com_gubun").val();
		openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND="+comtype+"&MULTI=N", "500,466,no");
		
	}else	if (column == 'USER_NAME_IMG' ) { 
			popupSel = column;
			var comCode = mySheet.GetCellValue(Row,"COM_CODE");
			if(comCode == ''){
				alert("회사를 선택해 주십시오.");return;
			}
			openSearchPopup("/mdcp/getMasterMdCpUserMutiChoicePop.do", "?st_buyer="+comCode, "500,540,no");

	}else	if (column == 'MENU_NAME_IMG' ) { 
		popupSel = column;
		var comtype = $("#st_com_gubun").val();
		openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND="+comtype+"&MULTI=N", "500,466,no");
			
	}
	return;
}

function mySheet_OnChange(Row, Col, Value) {
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
    if(column=='COM_NAME_IMG'){
    	var dupIdx = mySheet.ColValueDup("COM_CODE");
    	if(dupIdx > -1){
        	alert("선택하신 회사는 이미 존재합니다.");
        	mySheet.SetCellValue(Row,"COM_NAME",'');
        	mySheet.SetCellValue(Row,"COM_CODE",'');
        	return;
    	}
    }
	
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
}

//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if ( msg != "" ) {
		alert(msg);
	}
// alert(code);
// 	if ( code > 0 ) {
		//저장 성공시 처리
		doAction("search");
// 	}
}


//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	var sMsg = response.msg;
	if (pMethod == "corpCheck") {
		if (sMsg != "0") {
// 			alert("중복된 법인코드가 있습니다.");
// 			mySheet.ReturnCellData(Row, "CORP_CODE");
// 			mySheet.SelectCell(Row, "CORP_CODE");
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

//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text, tmp1) {
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "COM_NAME_IMG") {	// 회사조회
		mySheet.SetCellValue(grbRow, "COM_CODE", code);
		mySheet.SetCellValue(grbRow, "COM_NAME", text);
		
	} else if (popupSel == "comCode") {	// 회사
// 		alert(popupSel+"::"+code+"::"+text);
		$("#st_com_code").val(code);
		$("#st_com_name").val(text);
		
	} else if (popupSel == "USER_NAME_IMG") {	// 사용자
		var codestr = "";
		var namestr = "";
		var codes;
		var names;
		var codelen=0;
		if(code != "" ){
			if(code.indexOf("@") >-1){
				codes = code.split("@");
				names = text.split("@");
				codelen = codes.length;
				for(var i=0; i<codelen; i++){
					if(i < codelen-1){
						codestr += codes[i]+"^";
					}else{
						codestr += codes[i];
					}
				}
				namestr = names[0]+" 외"+(codelen-1).toString()+"명";
			}else{
				codestr = code;
				namestr = text;
			}
		}
// 		alert(codestr);
// 		alert(namestr);
		mySheet.SetCellValue(grbRow, "USER_ID", codestr);
		mySheet.SetCellValue(grbRow, "USER_NAME", namestr);
// 		alert(tmp1);

	} else if (popupSel == "userPop") {	// 사용자
		$("#st_user_id").val(code);
		$("#st_user_name").val(text);

	} else if (popupSel == "MENU_NAME_IMG") {	// 메뉴
		mySheet.SetCellValue(grbRow, "MENU_ID", code);
		mySheet.SetCellValue(grbRow, "MENU_NAME", text);
		
	}
	
	grbRow="";	//초기화
}

</script>
</head>
<body onload="kep_onload_view()">
	<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>로그인후 이동페이지 관리</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form id="searchCondition" name="searchCondition" method="post" onsubmit="return false;" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME" />
			<input type="hidden" id="pageflag" name="pageflag" value="1" />
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_corp_code" name="st_corp_code"  value="" />
			
            	<table  class="cont_t_list01" >
					<caption>사용자별 권한 관리</caption>
					<colgroup>
						<col width="5%" />
						<col width="7%" />
						<col width="25%" />
						<col width="7%" />
						<col width="25%" />
						<col width="7%" />
						<col width="25%" />
					</colgroup>
						
					<tbody>
						<tr> 
							<th>회사</th>
							<td><select id="st_com_gubun" name="st_com_gubun" class="TitSelect">
									<option value="B">고객사</option>
									<option value="M">운영사</option>
									<option value="S">협력사</option>
								</select>
							</td>
							<td style="text-align:left;">
								<input type="hidden" id="st_com_code" name="st_com_code" value="" />
								<input type="text" id="st_com_name" name="st_com_name" class="input_type_text" style="width:50%" value=""  readonly  />
								<a href="javascript:doPop('comCode');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_com_code','st_com_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
<!-- 							<th>사용자</th> -->
<!-- 							<td style="text-align:left;"> -->
<!-- 								<input type="hidden" id="st_user_id" name="st_user_id" value=""  /> -->
<!-- 								<input type="text" id="st_user_name" name="st_user_name" class="input_type_text" style="width:60%" value=""  readonly  /> -->
<!-- 								<a href="javascript:doPop('userPop');"><img src="/resources/images/btn_search03.gif"></a> -->
<!-- 								<a href="javascript:kepEraser('st_user_id','st_user_name');"><img src="/resources/images/btn_eraser2.gif"></a> -->
<!-- 							</td> -->
							<th></th>
							<td></td>
							<th></th>
							<td></td>
						</tr>
					</tbody>
				</table>
            </div>
            
           	<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
               	<label for="b_no02" class="hidden">정렬개수선택</label>
					<select name="onepagerow" style="width: 70px;" >
					<option value="10">10건</option>
					<option value="20" selected>20건</option>
					<option value="30">30건</option>
					<option value="40">40건</option>
					<option value="50">50건</option>
				</select>
			</span>
			<br>
		</form>
					
      	<!--grid-->
  				<table style="border-width: 0px; width: 100%;">
  					<colgroup>
					<col width="80%" />
                       <col width="*" />
				</colgroup>
				<tbody>
					<tr>
						<td>
				   			<div class="ib_product" style="border-top:2px solid #3c639c">
				  				<script type="text/javascript">
				  					createIBSheet("mySheet", "98%", "354px");
				  				</script>
				  			</div>
						</td>

					</tr>
		      		<tr>
		      			<td>
				  			<p class="paging" id="pageindex"  ></p>
		      			</td>
		      		</tr>
				</tbody>
			</table>
  		<!--버튼영역-->
               <div class="btnArea">
               <span class="fl">
	           		<span class="btn_02"><a href="javascript:doAction('add');">추가</a></span>
	           		<span class="btn_02"><a href="javascript:doAction('save');">저장</a></span>
	           		<span class="btn_02"><a href="javascript:doAction('del');">삭제</a></span>
               </span>
 				<span class="fr">
  				</span>
  			 </div>
		<!--내용 종료-->                 
</body>
</html>
