<%--
**********************************************
* 메뉴 : 회원사관리>사용자관리>사용자조회
* 화면 : 사용자조회
* 기능 : 사용자 조회
* 프로그램 ID : PG_01_M_008_00
* 담당자 : 이수영 ( 설계 : 권우재 )
* 착수일 : 2014-06-12
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<%
SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String SessionUserId         = sessionInfo.getUserId();
//사용자 삭제권한 체크
boolean getRoleYn = CommonUtil.getCodeCheckReturn("M173",SessionUserId);
%>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Center",		SaveName:"sStatus",				Header:"상태",		Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}
					,{ Align:"Center",		SaveName:"SELECTED",			Header:"",			Type:"DummyCheck",	Width:60,	Edit:true,	EditLen:100,	Hidden:false}
					,{ Align:"Left",		SaveName:"USER_ID",				Header:"ID",		Type:"Text",		Width:140,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Left",		SaveName:"KEP_USER_ID_MASK",	Header:"ID",		Type:"Text",		Width:140,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",		SaveName:"USER_NAME",			Header:"이름",		Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Left",		SaveName:"COM_NAME",			Header:"회원사명",		Type:"Text",		Width:260,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",		SaveName:"BUSINESS_COND_TEXT",	Header:"회원사구분",	Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",		SaveName:"COM_CODE",			Header:"회원사코드",	Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",		SaveName:"IRS_NO",				Header:"사업자번호",	Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Left",		SaveName:"IRS_NAME",			Header:"사업자명",		Type:"Text",		Width:260,	Edit:false,	EditLen:100,	Hidden:true}
					,{ Align:"Left",		SaveName:"DEPT_TEXT",			Header:"부서명",		Type:"Text",		Width:180,	Edit:false,	EditLen:100,	Hidden:false}
					,{ Align:"Center",		SaveName:"USER_TYPE_TEXT",		Header:"사용자권한",	Type:"Text",		Width:120,	Edit:false,	EditLen:100,	Hidden:false}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet, "KEP_USER_ID_MASK");	//요청자
	setLinkCol(mySheet, "COM_NAME");	//품목코드
}
	
	
var st;
var mt;
// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if (str !="search" && str !="excelDown" && str !="reload" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}

	switch (str) {
		case "search":	 // 조회
			if(($("#st_search_com_name").val() == null||$("#st_search_com_name").val() == "")&&($("#st_search_user_id").val() == ""||$("#st_search_user_id").val() == "")
				&&($("#st_search_user_name").val() == ""||$("#st_search_user_name").val() == "")){
				alert("ID,이름,회원사 중 하나는 필수입력 항목입니다.");
				return;
			}
			var user_name_check = $("#st_search_user_name").val();
			//이름은 최소 2글자 이상 검색가능
			if(user_name_check != "" && user_name_check.length < 2){
				alert("이름은 최소 2글자 이상 입력해야 합니다.");
				return;
			}
			//이름에 _ , % 들어오면 공백처리
			$("#st_search_user_name").val(user_name_check.replace(/_/g," ").replace(/%/g," "));
			
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mdcp/getMasterMdCpUserViewList.do" , pagingMode );
			break;
		
		case "reload":	// 초기화
			kepReload('searchCondition');
			mySheet.RemoveAll();
			break;
	
		case "save": // 저장
			if (!confirm('선택한 항목을 저장 하시겠습니까?'))
				return;
			kepSave(document.searchCondition ,  mySheet , "/mdcp/saveMasterMdCpUserViewList.do" , "SELECTED" );
			break;
			
		case "del": // 취소
			if (!confirm('선택한 항목을 삭제 하시겠습니까?'))
				return;
			kepSave(document.searchCondition ,  mySheet , "/mdcp/delMasterMdCpUserViewList.do" , "SELECTED" );
			break;
	}
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
	
	if(mySheet.RowCount() <= 0){
   		return;
   	}else{
   		for(var i=1; i<=mySheet.RowCount(); i++){
   			mySheet.SetCellValue(i, "KEP_USER_ID_MASK", kepMaskingName(mySheet.GetCellValue(i, "USER_ID")));
   		}
   	}
	
	if (msg != "") {
		alert(msg);
	}

	if(current_page==-1) {
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
}
	
// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if (msg != "") {
		alert(msg);
	}
	
	if(code>0){
		//저장 성공시 재조회
		doAction('search');
	}
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mdcp/getMasterMdCpUserViewList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str,val) {
	popupSel = str;
	
	switch (str) {
		case "user_detail": // 사용자정보 상세조회
			openSearchPopup("/mdcp/showMasterMdCpUserDetailViewPop.do","?st_user_id="+val+"&callType=B","800,600,no");
			break;	
		case "compy_detail": // 사용자정보 상세조회
			openSearchPopup("/mdcp/showMasterMdCpCompyDetailViewPop.do", "?com_code="+val, "800,600,no");
			break;		
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'KEP_USER_ID_MASK') { // 요청자
		var ID = mySheet.GetCellValue(Row,"USER_ID");
		doPop('user_detail', ID);
	} else if (column == 'COM_NAME') {
		var COM_CODE = mySheet.GetCellValue(Row,"COM_CODE");
		doPop('compy_detail', COM_CODE);
	}
	return;
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2) {
	if (popupSel == "user_detail") {
		if (value1 == "OK") {
			doAction("search");
		}
	}
	grbRow="";	//초기화
}

</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>사용자조회</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form name = "searchCondition" method = "post" onsubmit="return false" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			
            	<table  class="cont_t_list01" >
					<caption>사용자조회</caption>
					<colgroup>
						<col width="8%" />
						<col width="25%" />
						<col width="8%" />
						<col width="25%" />
						<col width="8%" />
                        <col width="*" />
					</colgroup>
						
					<tbody>
						<tr>
							<td>사용자구분</td>
							<td>
								<select id="st_search_user_type" name="st_search_user_type" class="TitSelect" style="width:50%;height:20px">
									<option value="">전체사용자</option>
									<option value="A">Admin 사용자</option>
									<option value="U">일반사용자</option>
								</select>
							</td>
							<td>ID</td>
							<td>
								<input type="text" class="input_type_text" id="st_search_user_id" name="st_search_user_id" style="width:80%;" value=""  onkeyup="kepToUpper('st_search_user_id')" onkeydown="kepEnter()" />
							</td>
							<td>이름</td>
							<td>
								<input type="text" class="input_type_text" name="st_search_user_name" id="st_search_user_name" style="width:80%" onkeydown="kepEnter()" value=""  />
							</td>
						</tr>
						<tr>	
							<td>회원사</td>
							<td>
								<input type="text" class="input_type_text" id="st_search_com_name" name="st_search_com_name" style="width:80%;" value="" onkeydown="kepEnter()" />
							</td>
							<td>회원사구분</td>
							<td>
								<select id="st_business_cond" name="st_business_cond" style="width:50%;height:20px">
									<option value="">전체</option>
									<option value="B">고객사</option>
									<option value="M">운영사</option>
									<option value="S">협력사</option>
								</select>
							</td>
							<td>부서명</td>
							<td>
								<input type="text" class="input_type_text" id="st_dept_name" name="st_dept_name" style="width:80%;" value="" onkeydown="kepEnter()" />
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
				</select>
			</span>
			<br>
		</form>
					
      	<!--grid-->
   			<div class="ib_product" style="border-top:2px solid #3c639c">
  				<script type="text/javascript">
  					createIBSheet("mySheet", "100%", "354px");
  				</script>
  			</div>
  			<p class="paging" id="pageindex"></p>
  			<%if(getRoleYn== true){ %>
	  			<!--버튼영역-->
				<div class="btnArea">
					<span class="fr">
						<span class="btn_02 mr04"><a href="javascript:doAction('del');">삭제</a></span>
	  				</span>
	  			 </div>
  			 <%} %>

<!--내용 종료-->	                 

</body>
</html>
