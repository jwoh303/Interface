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

var authInfoG = KepSheetComboQueryIdDataNoCache("getAuthInfoList", "SPACE","G");		// (G:일반권한, S:특수권한)
var authInfoS = KepSheetComboQueryIdDataNoCache("getAuthInfoList", "SPACE","S");		// (G:일반권한, S:특수권한)

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var initsheet = {};
	initsheet.Cols = [
					 {Align:"Center",	SaveName:"sStatus",				Header:"상태",		Type:"Status",		Width:60,		Edit:false,	EditLen:0,		Hidden:true}
					,{ Align:"Center",	SaveName:"SELECTED",			Header:"",			Type:"DummyCheck",	Width:60,		Edit:true,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"COM_CODE",			Header:"회사코드",		Type:"Text",		Width:150,		Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Left",	SaveName:"COM_NAME_LOC",		Header:"회사명",		Type:"Text",		Width:280,		Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"DEPT_CODE",			Header:"부서코드",		Type:"Text",		Width:100,		Edit:false,	EditLen:200,	Hidden:true}
					,{ Align:"Left",	SaveName:"DEPT_NAME",			Header:"부서명",		Type:"Text",		Width:220,		Edit:false,	EditLen:220,	Hidden:false}
					,{ Align:"Center",	SaveName:"USER_NAME_LOC",		Header:"사용자명",		Type:"Text",		Width:130,		Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"USER_NAME_LOC_MASK",	Header:"사용자명",		Type:"Text",		Width:130,		Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"USER_ID",				Header:"사용자ID",	Type:"Text",		Width:130,		Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Center",	SaveName:"USER_ID_MASK",		Header:"사용자ID",	Type:"Text",		Width:130,		Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",	SaveName:"ROLE_ID",				Header:"권한ID",		Type:"Text",		Width:100,		Edit:false,	EditLen:100,	Hidden:true}
	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet, "COM_NAME_LOC");	//회사
	setLinkCol(mySheet, "DEPT_NAME");	//고객사
	setLinkCol(mySheet, "USER_NAME_LOC_MASK");	//사용자


	var initsheet2 = {};
	initsheet2.Cols = [ 
					 { Align:"Center",	Width:40,	Edit : false,	EditLen:0,	Hidden : true,	Type:"Status",	Header:"상태",	SaveName:"sStatus"}
					,{ Align:"Center",	Width:45,	Edit : true,	EditLen:100,	Hidden : false,	Type:"DummyCheck",	Header:"",	SaveName:"SELECTED"}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:60,	Hidden:true,	Type:"Text",	Header:"사용자ID",	SaveName:"USER_ID"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Combo",	ComboText:"일반권한|특수권한", ComboCode:"G|S",	Header:"권한구분",	SaveName:"ROLE_FLAG" ,KeyField : true}
					,{ Align:"Left",	Width:150,	Edit:false,	EditLen:60,	Hidden:false,	Type:"Combo", Header:"권한명",	SaveName:"AUTH_ID", KeyField : true, ToolTip:true}
// 					,{ Align:"Left",	Width:150,	Edit:true,	EditLen:60,	Hidden:true,	Type:"Text", Header:"권한ID",	SaveName:"AUTH_ID", KeyField : true,BackColor:"${optColor}", ToolTip:true}
// 					,{ Align:"Left",	Width:150,	Edit:true,	EditLen:60,	Hidden:false,	Type:"Text", Header:"권한명",	SaveName:"AUTH_NAME", KeyField : true,BackColor:"${optColor}", ToolTip:true}
					,{ Align:"Left",	Width:170,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"설명",	SaveName:"AUTH_DC", ToolTip:true}
					,{ Align:"Center",	Width:100,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Combo",	ComboText:"Y|N", 		ComboCode:"Y|N",	Header:"사용유무",	SaveName:"USE_FLAG" ,BackColor:"${optColor}"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"등록일",	SaveName:"CREATE_DT"}
	];
	
	IBS_InitSheet2(mySheet2, initsheet2,pagingMode);

// 	setLinkCol(mySheet2, "AUTH_NAME");	//권한
	
<%-- 	kepAjaxCommonQueryIdCombo('st_dept_code','common.getMdcdBuyerCardManageDeptList','ALL', '<%=user_dept%>');							// 조회조건 : 부서 --%>
}

var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var selectedGrid2 = mySheet2.FindCheckedRow("SELECTED");

	switch (str) {
		case "search":	 // 조회
			current_page = -1;
			kepSearch(document.searchCondition, mySheet, "/mdam/getMasterMdAmUserManageList.do" , pagingMode );
			break;
		case "search2":	 // 조회(상세)
			kepSearch(document.searchCondition,  mySheet2 , "/mdam/getMasterMdAmUserManageDetailList.do" , pagingMode );
		case "insert":	 // 조회
			var rows = mySheet.DataInsert(-1);
			mySheet.SetCellEditable(rows, "COM_CODE", 1);
			mySheet.SelectCell(rows, "COM_CODE");
			break;	
		case "reload":	// 초기화
			kepReload('searchCondition');
			$('#st_com_code').val('');
			$('#st_com_name').val('');
			$("select[name='st_dept_code']").find('option').each(function() { $(this).remove(); });
			$('#st_dept_code').append('<option value="">전체</option>');
			$('#st_user_id').val('');
			$('#st_user_name').val('');
			$("select[name='st_auth_info']").find('option').each(function() { $(this).remove(); });
			$('#st_auth_info').append('<option value="">전체</option>');
			mySheet.RemoveAll();
			mySheet2.RemoveAll();
			break;
		case "detailAdd": // 추가
			 if( mySheet2.RowCount() > 0  || $("#st_user_id_detail").val() != '') {
				 	
				 	//행추가
					var rows = mySheet2.DataInsert(-1);
					//초기값설정
					mySheet2.SetCellValue(rows, "SELECTED", "1");
					mySheet2.SetCellValue(rows, "USER_ID",$("#st_user_id_detail").val());
					var info1 ={ Edit:true,	Type:"Combo", ComboText:"일반권한|특수권한", ComboCode:"G|S",BackColor:"${optColor}" };
					mySheet2.InitCellProperty(rows,"ROLE_FLAG", info1);
					var info2 = {Edit:true, Type:"Combo", ComboText:authInfoG.ComboText, ComboCode:authInfoG.ComboCode,BackColor:"${optColor}"};
					mySheet2.InitCellProperty(rows,"AUTH_ID", info2);
					mySheet2.SetCellValue(rows, "CREATE_DT", kepGetNowTimeStr('YYYYMMDD',''));

			 }else{
				 if(mySheet.RowCount() > 0) {
					 if($("#st_user_id_detail").val() == ''){
							alert("선택된 데이터가 없습니다.");
							return;
					 }				 
				 }else{
					alert("조회된 데이터가 없습니다.");
					return;
				 }
			 }	
			break;	
			
		case "detailSave": // 저장
			// 선택된 항목 유무 체크
			if (selectedGrid2.length == 0) {
				alert("선택된 항목이 없습니다.");return;
			}
			var roleDupCnt = 0;
			for( var i = 1; i <= mySheet2.RowCount(); i++ ) {
				
				var code = mySheet2.GetCellValue(i, "AUTH_ID");
				if($.trim(code) == ''){
					alert("["+i+"]번째 권한이 선택되지 않았습니다.");return;
				}
		    	if(mySheet2.GetCellValue(i, "ROLE_FLAG") == 'G'){
		    		roleDupCnt++;
		    	}
		    }
			if(roleDupCnt > 1){
				alert("일반권한은 1개이상 설정할 수 없습니다."); return;
			}
			
			if (!confirm('선택한 항목을 저장 하시겠습니까?'))
				return;
			kepSave(document.searchCondition ,  mySheet2 , "/mdam/saveMasterMdAmUserManageDetailList.do" , "SELECTED" );
			break;
			
		case "detailDel": // 삭제
			if (!confirm('선택한 항목을 삭제 하시겠습니까?'))
				return;
			kepSave(document.searchCondition ,  mySheet2 , "/mdam/delMasterMdAmUserManageDetailList.do" , "SELECTED" );
			break;
			
	}
}


// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if (msg != "") {
		alert(msg);
	}

	if(current_page==-1){
		makePageIndex2(mySheet, 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2(mySheet, current_page , document.searchCondition.onepagerow.value);	
	}
	
	var totRow = mySheet.RowCount();
	for(var i=1; i<=totRow;i++){
		mySheet.SetToolTipText(i, "USER_NAME_LOC_MASK", mySheet.GetCellValue(i, "USER_NAME_LOC"));
		mySheet.SetToolTipText(i, "USER_ID_MASK", mySheet.GetCellValue(i, "USER_ID"));
	}
	
	mySheet2.RemoveAll();

}

//조회 후처리(상세)
function mySheet2_OnSearchEnd(code, msg) {
	loader_obj("N");
   	if(mySheet2.RowCount() <= 0) return;
   	
	if (msg != "") {
		alert(msg);
	}
	for (var i = 0; i < mySheet2.RowCount(); i++ ) {
		var rowIdx = i+1;
		var roleFlag = mySheet2.GetCellValue(rowIdx, "ROLE_FLAG");
		var infoS = {Type:"Combo", ComboText:authInfoS.ComboText, 	ComboCode:authInfoS.ComboCode};
		var infoG = {Type:"Combo", ComboText:authInfoG.ComboText, 	ComboCode:authInfoG.ComboCode};
		
		mySheet2.InitCellProperty(rowIdx,"AUTH_ID", (roleFlag == 'S' )?infoS:infoG);
		
	}
	
}


// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mdam/getMasterMdAmUserManageList.do?page="+current_page , pagingMode );
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

	if (column == 'COM_NAME_LOC' || column == 'DEPT_NAME' || column == 'USER_NAME_LOC_MASK') { 
		$("#st_user_id_detail").val(mySheet.GetCellValue(Row,"USER_ID"));
		kepSearch(document.searchCondition ,  mySheet2 , "/mdam/getMasterMdAmUserManageDetailList.do" , pagingMode );
	}
	return;
}

function mySheet2_OnChange(Row, Col, Value) {
	if (mySheet2.ColSaveName(Col) == 'ROLE_FLAG') { // 권한구분
		var roleFlag = mySheet2.GetCellValue(Row, "ROLE_FLAG");
		var infoS = {Type:"Combo", ComboText:authInfoS.ComboText, 	ComboCode:authInfoS.ComboCode};
		var infoG = {Type:"Combo", ComboText:authInfoG.ComboText, 	ComboCode:authInfoG.ComboCode};
		mySheet2.InitCellProperty(Row,"AUTH_ID", (roleFlag == 'S' )?infoS:infoG);
	}
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
}

//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if ( msg != "" ) {
		alert(msg);
	}

	if ( code > 0 ) {
		//저장 성공시 처리
		doAction("search");
	}
}

//트랜젝션(저장,삽입등) 후처리
function mySheet2_OnSaveEnd(code, msg) {
	loader_obj("N");
	if (msg != "") {
		alert(msg);
	}
	
	if(code>=0){
		//저장 성공시 재조회
		doAction('search2');
	}
}

function mySheet2_OnAfterEdit(Row, Col) {
	var column = mySheet2.ColSaveName(mySheet2.GetSelectCol());
    if(column=='AUTH_ID'){
    	var dupIdx = mySheet2.ColValueDup("AUTH_ID");
    	if(dupIdx > -1){
        	alert("입력하신 권한ID는 이미 존재합니다.");
        	mySheet2.SetCellValue(Row,"AUTH_ID",'');
    	}
    }
}


//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	var sMsg = response.msg;
	if (pMethod == "corpCheck") {
		if (sMsg != "0") {
			alert("중복된 법인코드가 있습니다.");
			mySheet.ReturnCellData(Row, "CORP_CODE");
			mySheet.SelectCell(Row, "CORP_CODE");
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
function setPopupReturn(code, text) {
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "comCode") {	// 고객사
		$("#st_com_code").val(code);
		$("#st_com_name").val(text);
		if(code != ''){
			var search = code;
			kepAjaxCommonQueryIdSearchCombo('st_dept_code','common.getDeptCombo2',search,'ALL');
		}
		$("#st_user_id").val('');
		$("#st_user_name").val('');
		
	} else if (popupSel == "userPop") {	// 사용자
		$("#st_user_id").val(code);
		$("#st_user_name").val(text);
	}
	
	grbRow="";	//초기화
}

function specAuthSet(){
	var auth_type = document.searchCondition.st_auth_type.value;
	
	kepAjaxCommonQueryIdSearchCombo('st_auth_info','common.getAuthInfoList',auth_type,'ALL');
}

</script>
</head>
<body onload="kep_onload_view()">
	<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>사용자별 권한 관리</h3>
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
			<input type="hidden" id="st_user_id_detail" name="st_user_id_detail"  value="" />
			<input type="hidden" id="st_corp_code" name="st_corp_code"  value="" />
			
            	<table  class="cont_t_list01" >
					<caption>사용자별 권한 관리</caption>
					<colgroup>
						<col width="4%" />
						<col width="7%" />
						<col width="20%" />
						<col width="4%" />
						<col width="15%" />
						<col width="4%" />
						<col width="15%" />
						<col width="4%" />
						<col width="10%" />
						<col width="17%" />
					</colgroup>
						
					<tbody>
						<tr> 
							<th>회사</th>
							<td><select id="st_com_gubun" name="st_com_gubun" class="TitSelect">
									<option value="B">고객사</option>
									<option value="M">운영사</option>
									<option value="S">협력사</option>
									<option value="E">수출</option>
								</select>
							</td>
							<td style="text-align:left;">
								<input type="hidden" id="st_com_code" name="st_com_code" value="" />
								<input type="text" id="st_com_name" name="st_com_name" class="input_type_text" style="width:60%" value=""  readonly  />
								<a href="javascript:doPop('comCode');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_com_code','st_com_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th>부서</th>
							<td style="text-align:left;">
								<select id="st_dept_code" name="st_dept_code" style="width:90%">
									<option value="">전체</option>
								</select>
							</td>
							<th>사용자</th>
							<td style="text-align:left;">
								<input type="hidden" id="st_user_id" name="st_user_id" value=""  />
								<input type="text" id="st_user_name" name="st_user_name" class="input_type_text" style="width:50%" value=""  readonly  />
								<a href="javascript:doPop('userPop');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_user_id','st_user_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
							<th>권한</th>
							<td>
								<select id="st_auth_type" name="st_auth_type" onChange="specAuthSet();">
									<option value="" selected>전체</option>
									<option value="G">일반권한</option>
									<option value="S">특수권한</option>
								</select>
							</td>
							<td>
								<select id="st_auth_info" name="st_auth_info">
									<option value="">전체</option>
								</select>
							</td>
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
					<col width="55%" />
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
						<td>
							<div class="ib_product" style="border-top:2px solid #3c639c;">
								<script type="text/javascript">
				  					createIBSheet("mySheet2", "100%", "354px");
				  				</script>
			  				</div>
						</td>
					</tr>
		      		<tr>
		      			<td>
				  			<p class="paging" id="pageindex"  ></p>
		      			</td>
		      			<td>
<!-- 				  			<p class="paging" id="pageindex2" ></p> -->
		      			</td>
		      		</tr>
				</tbody>
			</table>
  		<!--버튼영역-->
               <div class="btnArea">
               <span class="fl">
               		<label style="font-size: 12px;">테이블의 사용자명을 선택하면, 현재 권한정보가 표시됩니다.</label>
               </span>
 				<span class="fr">
	           		<span class="btn_02"><a href="javascript:doAction('detailAdd');">추가</a></span>
	           		<span class="btn_02"><a href="javascript:doAction('detailSave');">저장</a></span>
	           		<span class="btn_02"><a href="javascript:doAction('detailDel');">삭제</a></span>
  				</span>
  			 </div>
		<!--내용 종료-->                 
</body>
</html>
