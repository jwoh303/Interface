<%--
**********************************************
* 메뉴 : 회원사관리>계약관리>계약대상조회
* 화면 : 계약대상조회
* 기능 : 
* 프로그램 ID : PG_02_M_002_00
* 담당자 : 개발자3 ( 설계 : 권우재 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var remarkOn="/resources/images/but_icon01.gif";
var remarkOff="/resources/images/but_icon02.gif";
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
					 { Align:"Center",	Width:60,		Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",			Header:"상태",				SaveName:"sStatus"}
					,{ Align:"Center",		Width:60,		Edit:true,	EditLen:100,	Hidden:false,	Type:"Radio",				Header:"선택",				SaveName:"SELECTED"}
					,{ Align:"Center",		Width:60,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"순번",				SaveName:"RN"}
					,{ Align:"Center",		Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"구분",				SaveName:"TARGET_TYPE"}
					,{ Align:"Center",		Width:90,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"사업구분",			SaveName:"BIZ_CLSS_NM"}
					,{ Align:"Center",		Width:80,		Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"회원사유형",		SaveName:"ALANC_TYP_NM"}
					,{ Align:"Center",		Width:110,	Edit:true,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"대상회원사",		SaveName:"COMPANY_CODE"}
					,{ Align:"Left",		Width:220,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"대상회원사명",		SaveName:"COMPANY_NM"}
					,{ Align:"Center",		Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"사업자등록번호",	SaveName:"BIZMN_REGST_NO"}
					,{ Align:"Center",		Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"계약번호",			SaveName:"CONT_NO"}
					,{ Align:"Left",		Width:300,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"계약명",				SaveName:"CONT_TITLE"}
					,{ Align:"Center",		Width:160,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"계약기간",			SaveName:"CONT_TERM"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"회원사진행상태",	SaveName:"PROCE_STATE_NM"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"회원사승인일",		SaveName:"TRTMNT_DATE"}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	
	$("#st_from_date").val( kepToMonthAdd("1","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
}
	
	
var st;
var mt;
// 기능함수
function doAction(str) {
	st = new Date();
	
	switch (str) {
		case "search":	 // 조회
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false) return;
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mdct/getMasterMdCtContractObjctList.do" , pagingMode );
			break;
		
		case "reload":	// 초기화
			$("#st_com_code").val("");
			kepReload('searchCondition');
			$("#st_from_date").val( kepToMonthAdd("1","M"));
			$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
			mySheet.RemoveAll();
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
   	
	if (msg != "") {
		alert(msg);
	}

	if (current_page==-1) {
		makePageIndex2(mySheet, 1 , document.searchCondition.onepagerow.value);
	} else {
		makePageIndex2(mySheet, current_page, document.searchCondition.onepagerow.value);	
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
	kepSearch(document.searchCondition ,  mySheet , "/mdct/getMasterMdCtContractObjctList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str) {
	popupSel = str;
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	
	switch (str) {
		case "company": // 고객사 M
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=S&MULTI=N", "500,466,no");
			break;
		case "constract": // 고객사 M
			var st_com_code = "";
			var st_com_name = "";
			
			if (selectedGrid != "") {
				st_com_code = mySheet.GetCellValue(selectedGrid, "COMPANY_CODE");
				st_com_name = mySheet.GetCellValue(selectedGrid, "COMPANY_NM");
			}
			openSearchPopup("/mdct/showMasterMdCtStndrdContractPop.do", "?st_com_code=" + st_com_code + "&st_com_name=" + st_com_name, "620,510,no");
			break;
	}
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text) {
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "company") {	// 다중 고객사
		$("#st_com_code").val(code);
		$("#st_com_name").val(text);
	} else if (popupSel == "constract") {
		if (code == "OK") {
			doAction('search');
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
			<h3>계약대상조회</h3>
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
					<caption>계약대상조회</caption>
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
							<td>사업구분</td>
							<td>
								<select id="st_biz_type" name="st_biz_type" style="width:80%;height:20px" disabled>
									<option value="C001">구매대행</option>
									<option value="C002">유통</option>
								</select>
							</td>
							<td>회원사유형</td>
							<td>
								<select id="st_company_type" name="st_company_type" style="width:80%;height:20px" disabled>
									<option value="C002" selected>협력사</option>
									<option value="C001">고객사</option>
								</select>
							</td>																
							<td>회원사</td>
							<td>
								<input type="text" class="input_type_text" name="st_com_name" id="st_com_name" style="width:71%" value="" readonly onclick="javascript:doPop('company');">
								<input type="hidden" name="st_com_code" id="st_com_code" style="width:80%" value="">
								<a href="javascript:doPop('company');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_com_code','st_com_name');"><img src="/resources/images/btn_eraser2.gif"></a>
							</td>
						</tr>
						<tr> 
							<td>변경/신규</td>
							<td>
								<select id="st_use_yn" name="st_use_yn" style="width:80%;height:20px">
									<option value="">전체</option>
									<option value="1">변경</option>
									<option value="0">신규</option>
								</select>
							</td>
							<td>계약번호</td>
							<td>
								<input type="text" class="input_type_text" id="st_cont_no" name="st_cont_no" style="width:80%;" value="" onkeydown="kepEnter()">
							</td>
							<td>회원사 승인일</td>
							<td colspan="3">
								<input type="text" class="input_type_text" name="st_from_date" id="st_from_date" readOnly style="width:100px; text-align:center;" value="">
								<a href="javascript:kepCalendar('st_from_date')"></a>
								&nbsp;~&nbsp;
								<input type="text" class="input_type_text" name="st_to_date" id="st_to_date" readOnly style="width:100px; text-align:center;" value="">
								<a href="javascript:kepCalendar('st_to_date')"></a>
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
  			
  			<!--버튼영역-->
               <div class="btnArea">
  				<span class="fr">
  					<span class="btn_04"><a href="javascript:doPop('constract');">계약서작성</a></span>
  				</span>
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
