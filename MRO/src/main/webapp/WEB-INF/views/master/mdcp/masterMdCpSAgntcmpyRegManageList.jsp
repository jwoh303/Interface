<%--
**********************************************
* 메뉴 : 회원사관리>협력사관리>S협력사등록관리
* 화면 : S협력사등록관리
* 기능 : 임시협력사 관리
* 프로그램 ID : PG_01_M_007_00
* 담당자 : 이수영 ( 설계 : 권우재 )
* 착수일 : 2014-07-25
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
					,{ Align:"Center",		Width:60,		Edit:false,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:"",						SaveName:"SELECTED"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"상태코드",			SaveName:"APPROVAL_FLAG"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"상태",				SaveName:"APPROVAL_TEXT"}
					,{ Align:"Left",		Width:260,	Edit:false,	EditLen:300,	Hidden:false,	Type:"Html",				Header:"협력사명",			SaveName:"SELLER_NAME"}
					,{ Align:"Left",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"협력사코드",		SaveName:"SELLER_CODE"}
					,{ Align:"Center",		Width:140,	Edit:false,	EditLen:120,	Hidden:false,	Type:"Text",				Header:"사업자등록번호",	SaveName:"IRS_NO"}
					,{ Align:"Left",		Width:400,	Edit:false,	EditLen:360,	Hidden:false,	Type:"Text",				Header:"주소",				SaveName:"ADDRESS"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"SG매핑건수",		SaveName:"SG_CNT"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"고객사코드",		SaveName:"BUYER_CODE"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"고객사명",			SaveName:"BUYER_NAME"}
					,{ Align:"Center",		Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"AVL상태",			SaveName:"AVL_FLAG"}

	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet, "SG_CNT");	//매핑건수
}
	
	
var st;
var mt;
// 기능함수
function doAction(str) {
	st = new Date();
	switch (str) {
		case "search":	 // 조회
			if ($("#st_buyer_code").val()  == "") {
				alert("고객사를 선택하여 주십시요.");
				return;
			}
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mdcp/getMasterMdCpSAgntcmpyRegManageList.do" , pagingMode );
			break;
		case "reload":	// 초기화
			kepReload('searchCondition');
			$("#st_buyer_code").val("");
			$("#st_seller_code").val(""); 		
				mySheet.RemoveAll();
			break;
		case "add":		// 저장
			kepAjaxFormCall("/mdcp/getMasterMdCpSAgntcmpyRegManageSAgent.do", "searchCondition", str);
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
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	} else {
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	
	for (var i=1; i <= mySheet.RowCount(); i++ ) {
		if ($.trim(mySheet.GetCellValue(i, "AVL_FLAG")) == "Y") {
			mySheet.SetCellValue(i, "SELLER_NAME", mySheet.GetCellValue(i, "SELLER_NAME") + "&nbsp;<img src='/resources/images/avl.gif' />");
		}
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
	kepSearch(document.searchCondition ,  mySheet , "/mdcp/getMasterMdCpSAgntcmpyRegManageList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str, val1, val2) {
	popupSel = str;
	
	switch (str) {
		case "buyer":			// 고객사 M
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=B&MULTI=N", "500,466,no");
			break;
		case "seller":			// 협력사
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=S&MULTI=N", "500,466,no");
			break;
		case "add":			// 협력사 추가
			if ($("#st_buyer_code").val()  == "") {
				alert("고객사를 선택하여 주십시요.");
				return;
			}
			
			for (var i=1; i <= mySheet.RowCount(); i++ ) {
				if (mySheet.GetCellValue(i, "sStatus") == "I") {
					alert("추가된 새로운 공급사가 존재 합니다\n\n먼저 SG매핑후 추가바랍니다.");
		 			return;
				}
			}
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=S&MULTI=N", "500,466,no");
			break;		
		case "sgCnt":			// SG팝업
			openSearchPopup("/mdcp/showMasterMdCpSgMakerManagePop.do", "?st_buyer_code=" + val1 + "&st_agent_code=" + val2, "1000,530,no");
			break;		
	}
}
	
// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'SG_CNT') { // 요청자
		doPop('sgCnt', mySheet.GetCellValue(Row,"BUYER_CODE"), mySheet.GetCellValue(Row,"SELLER_CODE"));
	}
	return;
}
	
//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text ) {
	
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "buyer") {					// 다중 고객사
		$("#st_buyer_code").val(code);
		$("#st_buyer_name").val(text);
	
	} else if (popupSel == "seller") {				// 다중 고객사
		$("#st_seller_code").val(code);
		$("#st_seller_name").val(text);
	
	} else if (popupSel == "add") {				// 추가
		$("#st_agent_code").val(code);
		doAction("add");
	}
	grbRow="";	//초기화
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	var sMsg = response.msg;
	if (pMethod == "add") {
		if (Number(response.CNT) > 0) {
			alert("이미 등록된 협력사 입니다.\n\n검색후 매핑 바랍니다.");
			$("#st_agent_code").val("");
		} else {	
			var rows = mySheet.DataInsert(-1);
			
			mySheet.SetCellValue(rows, "APPROVAL_TEXT", "품의대상");
			mySheet.SetCellValue(rows, "BUYER_CODE", response.B_CODE);
			mySheet.SetCellValue(rows, "SELLER_NAME", response.S_NAME);
			mySheet.SetCellValue(rows, "SELLER_CODE", response.S_CODE);
			mySheet.SetCellValue(rows, "IRS_NO", response.IRS_NO);
			mySheet.SetCellValue(rows, "ADDRESS", response.ADDRESS);
			mySheet.SetCellValue(rows, "AVL_FLAG", response.AVL_FLAG);
			mySheet.SetCellValue(rows, "SG_CNT", "0");
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
</script>
</head>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>S협력사등록관리</h3>
        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    <span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
   		</div>        	
        <!--조회영역-->
       	<form id="searchCondition" name="searchCondition" method="post" onsubmit="return false" >
			<div id="cont_searchA">
			<!--HIDDEN-->
			<!-- 공통 -->
			<input type="hidden" name="s_SAVENAME">
			<input type="hidden" id="pageflag" name="pageflag" value="1">
			<!-- 화면 내 정의 -->
			<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
			<input type="hidden" id="st_agent_code" name="st_agent_code"  value="">
			
            	<table  class="cont_t_list01" >
					<caption>S협력사등록관리</caption>
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
							<td><font color="#FF6600">*</font> 고객사</td>
							<td>
								<input type="text" class="input_type_text" name="st_buyer_name" id="st_buyer_name" style="width:71%" value="" readonly onclick="javascript:doPop('buyer');">
								<input type="hidden" name="st_buyer_code" id="st_buyer_code" style="width:80%" value="">
								<a href="javascript:doPop('buyer');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_buyer_code','st_buyer_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>
							<td>협력사</td>
							<td>
								<input type="text" class="input_type_text" name="st_seller_name" id="st_seller_name" style="width:71%" value="" readonly onclick="javascript:doPop('seller');">
								<input type="hidden" name="st_seller_code" id="st_seller_code" style="width:80%" value="">
								<a href="javascript:doPop('seller');"><img src="/resources/images/btn_search03.gif"></a>
								<a href="javascript:kepEraser('st_seller_code','st_seller_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
							</td>
							<td>상태</td>
							<td>
								<select id="st_approval_flag" name="st_approval_flag" style="width:80%;height:20px">
									<option value="">전체</option>
									<option value="Y">품의완료</option>
									<option value="N">품의대상</option>
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
  					<span class="btn_02"><a href="javascript:doPop('add');">추가</a></span>
  				</span>
  			 </div>

<!--내용 종료-->	                 

</body>
</html>
