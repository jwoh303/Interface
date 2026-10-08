<%--
**********************************************
* 메뉴 : 회원사관리>협력사관리>협력사승인요청
* 화면 : 협력사승인요청
* 기능 : 협력사 승인요청 대상목록 조회(제조사 조회조건 추가)
* 프로그램 ID : PG_01_M_004_00
* 담당자 : 이수영 ( 설계 : 권우재 )
* 착수일 : 2014-06-30
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../../common/include/head.jspf"  %>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
					{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"회원사코드",			SaveName:"COM_CODE"}
					,{ Align:"Left",	Width:300,	Edit:false,	EditLen:260,	Hidden:false,	Type:"Text",	Header:"협력사명",				SaveName:"COM_NAME"}
					,{ Align:"Center",	Width:160,	Edit:false,	EditLen:160,	Hidden:false,	Type:"Text",	Header:"사업자등록번호",		SaveName:"IRS_NO"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"대표자명",				SaveName:"CEO_NAME"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"Kep담당자",			SaveName:"KEP_USER_NAME"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"진행상태",			SaveName:"STATUS_TEXT"}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"등록일",					SaveName:"ADD_DATE"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"신용등급",				SaveName:"CREDIT_RATING"}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Date",	Header:"만기일",					SaveName:"CREDIT_EXPIRE_DATE"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"",							SaveName:"WIDUS"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"MDM 담당자확인",	SaveName:"MDM_CONFIRM_TEXT"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"MDM 담당자확인",	SaveName:"MDM_CONFIRM_TYPE"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"전자계약상태",		SaveName:"ECONT_STATUS"}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);

	//하이퍼링크 설정
	setLinkCol(mySheet, "COM_NAME");						//회사명
	setLinkCol(mySheet, "IRS_NO");							//사업자등록번호
	setLinkCol(mySheet, "CEO_NAME");						//대표자명
}
	
	
var st;
var mt;
// 기능함수
function doAction(str) {
	switch (str) {
		case "search":	 // 조회
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mdcp/getMasterMdCpAgntcmpyApprovalRequestList.do" , pagingMode );
			break;
		case "reload":	// 초기화
			$("#st_kep_damdang_id").val("");
			kepReload('searchCondition');
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
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	} else {
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
	if (code>0) {
		//저장 성공시 재조회
		doAction('search');
	}
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param) {
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mdcp/getMasterMdCpAgntcmpyApprovalRequestList.do?page="+current_page , pagingMode );
}

// 팝업함수호출
function doPop(str, val1, val2, val3, val4) {
	popupSel = str;
	
	switch (str) {
		case "aprroval":							// 협력사 승인반려
			if (val2 == "A") {
				alert(" 제재이력 및 중복조회 미확인 협력사입니다. \n\n 대표자명을 클릭하여 협력사 정보 확인하시기 바랍니다..!!  ");
				return;
			}
			if ((val2 == "F") || (val2 == "D")) {
				alert(" 제재이력업체이거나 중복업체로 1차 확인된  협력사입니다. \n\n 협력사 정보 재확인 바랍니다..!!  ");
				return;
			}	
		
			openSearchPopup("/mdcp/showMasterMdCpAgntcmpyInfoAlterPop.do", "?com_code=" + val1, "950,670,no");
			break;
		case "creditEvaluation":					// 신용평가 정보
			// u : 인코딩된 사용자 아이디
			// p : 인코딩된 사용자 암호
			// i : 협력업체사업자번호 - 본사사업자번호
			// k : 인코딩된 협력업체본사번호 - 본사사업자번호
			// c : 암호화방법
			//      1(암호화안함), 2(base64), 7:(128bit, 인증정보 고정, 사업자번호암호화 X)
			// m : 통합인증서 기본 섹션
			//      1(업체검색), 2(Watch메인), 3(전자인증서메인), 4(건설실적메인), 5(거래위험메인)
			// g : 고정파라미터
			var c ="7";
			var m ="3";
			var link ='http://www.esrm.co.kr/esrm/SrmplusLogin?u=' + val1 + '&p=' + val2 + '&i=' + val3 + '&k=' + val4 + '&c=' + c + '&m=' + m +'&g=2';
	        var features ='height=768, width=1024, status=no, scrollbars=auto, resizable=yes';
	        window.open(link, 'watchwin', features);
			break;
		case "newRegAgntcmpy":				// 신규등록 협력사 정보 
			openSearchPopup("/mdcp/showMasterMdCpNewRegAgntcmpyInfoPop.do", "?com_code=" + val1 + "&mdm_confirm_type=" + val2, "960,670,no");
			break;
		case "widusPool":				// 신규등록 협력사 정보 
			window.open('http://www.widuspool.com','new','resizable=yes,scrollbars=yes,width=800,height=600', 'widusPool');
			break;	
			
			
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text) {
	//팝업 조회후 해당 항목에 값을 셋팅
	if (popupSel == "aprroval" || popupSel == "newRegAgntcmpy") {
		if (code == 'OK') {
			kepSearch(document.searchCondition ,  mySheet , "/mdcp/getMasterMdCpAgntcmpyApprovalRequestList.do?page="+current_page , pagingMode );
		}
	}
	grbRow="";	//초기화
}

// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅

	if (column == 'COM_NAME') { // 요청자
		doPop("aprroval", mySheet.GetCellValue(Row,"COM_CODE"), mySheet.GetCellValue(Row,"MDM_CONFIRM_TYPE"));
	} else if (column == 'IRS_NO') { // 품목코드
		var u="2d2d424547494e204349504845522d2d313131310000000b30303030303030308adcf2427727cb3c99f88cbb5d286f9feff44841390eea46e5459dd5012f1cfd25981f4352e8405c547bb1d999ae621930302d2d454e44204349504845522d2d";
		var p="2d2d424547494e204349504845522d2d313131310000000430303030303030308c39583fe0484e0f8fdb85524415eb1d8c0a5b801b3bda99d0389636bc5e7db086062756a066c45b41e8566fdf18764530302d2d454e44204349504845522d2d";
		var i = mySheet.GetCellValue(Row,"WIDUS").replace(/-/gi,"");
		var k ="";  
		doPop("creditEvaluation", u, p, i, k);
	} else if (column == "CEO_NAME" ) { 
		doPop("newRegAgntcmpy", mySheet.GetCellValue(Row,"COM_CODE"), mySheet.GetCellValue(Row,"MDM_CONFIRM_TYPE"));
	}
	return;
}
</script>
</head>
<%
String com_code= "";
if (_sessionInfo != null) {
	String st_user_id = _sessionInfo.getUserId();
	com_code =  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
}
%>
<body onload="kep_onload_view()">
<!--내용 시작-->
		<!--버튼영역-->
       	<div id="searchBtnA"  >
			<h3>협력사승인요청</h3>
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
					<caption>협력사승인요청</caption>
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
							<td>협력사명</td>
							<td>
								<input type="text" id="st_com_name_loc" name="st_com_name_loc" class="input_type_text" style="width:71%" value=""  onkeydown="kepEnter();" />
							</td>
							<td>사업자번호</td>
							<td>
								<input type="text" id="st_irs_no" name="st_irs_no" class="input_type_text" style="width:80%;" value="" onkeydown="kepEnter()" />
							</td>
							<td>Kep담당자</td>
							<td>
								<input type="text" id="st_kep_damdang_id" name="st_kep_damdang_id" class="input_type_text" style="width:70%;" value=""  onkeydown="kepEnter();" />
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
  	          	<span class="fl">
  					<span class="btn_08 mr04"><a href="javascript:doPop('widusPool');">위더스풀(신용정보)</a></span>
  				</span>
  			 </div>
<!--내용 종료-->	                 

</body>
</html>
