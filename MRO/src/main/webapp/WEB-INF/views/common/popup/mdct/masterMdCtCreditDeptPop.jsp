<%--
**********************************************
* 메뉴 : 회원사관리 > 여신한도관리 > 여신한도조회(사업팀) > 미마감 발주상세
* 화면 : 미마감 발주상세
* 기능 : 미마감 발주상세
* 프로그램 ID : 
* 담당자 :  한승준
* 착수일 : 2015-11-26
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ include file="../../../common/include/head_pop.jspf"  %>
<% 
//	SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	String st_irs_no = CommonUtil.nvl((String) request.getParameter("st_irs_no"),"");
	String st_kep_dept = CommonUtil.nvl((String) request.getParameter("st_kep_dept"),"");
	String st_strt_date = "";
	String st_end_date = "";
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/buyer_layout.css" type="text/css" />
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
<script src="/resources/js/common.js"></script>
 
</head>

<script type="text/javascript">
// <!--
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
						{ Align:"Center",	Width:90,	Edit:false,	EditLen:90,		Hidden:false,	Type:"Text",		Header:"사업자번호",	SaveName:"IRS_NO"}
		              	,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",		Header:"사업장코드",	SaveName:"COM_CODE"}
						,{ Align:"left",		Width:180,	Edit:false,	EditLen:180,	Hidden:false,	Type:"Text",		Header:"사업장명",		SaveName:"COM_NAME"}
						,{ Align:"Center",	Width:90,	Edit:false,	EditLen:90,		Hidden:false,	Type:"Text",		Header:"발주번호",		SaveName:"PO_NO"}
						,{ Align:"Center",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",		Header:"발주순번",		SaveName:"PO_SEQ"}
						,{ Align:"Center",	Width:120,	Edit:false,	EditLen:120,	Hidden:false,	Type:"Text",		Header:"진행상태",		SaveName:"STATUS"}
						,{ Align:"left",		Width:120,	Edit:false,	EditLen:120,	Hidden:false,	Type:"Text",		Header:"품목코드",		SaveName:"BUYER_ITEM_NO"}
						,{ Align:"left",		Width:150,	Edit:false,	EditLen:150,	Hidden:false,	Type:"Text",		Header:"품목명",			SaveName:"DESCRIPTION"}
						,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",		Header:"발주수량",		SaveName:"PO_QTY"}
						,{ Align:"right",	Width:80,	Edit:false,	EditLen:80,		Hidden:false,	Type:"Text",		Header:"입고수량",		SaveName:"GR_QTY"}
						,{ Align:"right",	Width:90,	Edit:false,	EditLen:90,		Hidden:false,	Type:"Text",		Header:"납품실적수량",	SaveName:"DO_QTY"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",		Header:"KEP부서코드",	SaveName:"DEPT_CODE"}
						,{ Align:"Center",	Width:120,	Edit:false,	EditLen:120,	Hidden:false,	Type:"Text",		Header:"KEP부서명",		SaveName:"DEPT_NAME"}
						,{ Align:"right",	Width:90,	Edit:false,	EditLen:90,		Hidden:false,	Type:"Float",	Header:"발주금액",		SaveName:"PO_AMT"}
						,{ Align:"right",	Width:90,	Edit:false,	EditLen:90,		Hidden:false,	Type:"Float",	Header:"미마감금액",	SaveName:"UN_GR_AMT"}
						,{ Align:"Center",	Width:90,	Edit:false,	EditLen:90,		Hidden:false,	Type:"Date",	Header:"생성일",			SaveName:"ADD_DATE"}
						,{ Align:"Center",	Width:90,	Edit:false,	EditLen:90,		Hidden:false,	Type:"Date",	Header:"납기요청일",	SaveName:"RD_DATE"}
						,{ Align:"Center",	Width:120,	Edit:false,	EditLen:120,	Hidden:false,	Type:"Text",		Header:"IF발주번호",		SaveName:"LEGACY_PO_NO"}
						,{ Align:"Center",	Width:90,	Edit:false,	EditLen:90,		Hidden:false,	Type:"Text",		Header:"IF발주순번",		SaveName:"LEGACY_PO_SEQ"}
						,{ Align:"left",		Width:150,	Edit:false,	EditLen:150,	Hidden:false,	Type:"Text",		Header:"발주비고",		SaveName:"PO_REMARK"}
						,{ Align:"left",		Width:150,	Edit:false,	EditLen:150,	Hidden:false,	Type:"Text",		Header:"규격",				SaveName:"SPECIFICATION"}
	];
	
	initsheet.Cfg = {MergeSheet:msHeaderOnly,FrozenCol:0};
	IBS_InitSheet(mySheet, initsheet,pagingMode, 'XLS');

	//데이터 건수 정보 표시 [0:표시하지 않음, 1:좌측상단, 2:우측상단, 3:좌측하단, 4:우측하단]
	mySheet.SetCountPosition(4);
	
	//조회조건 초기값 설정
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");
	$("#st_from_date").val( kepToMonthAdd("1","M") );
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/') );
}

//기능함수
function doAction(str) {

	// 일자 "/" 제거
	var fromDate = $("#st_from_date").val().replace(/[/]/gi,"");
	var toDate = $("#st_to_date").val().replace(/[/]/gi,"");
	
	$("#st_strt_date").val(fromDate);
	$("#st_end_date").val(toDate);
	
	switch (str) {
		case "search":	 // 조회
			current_page = -1;
			
			if (kep_dateSearchCheck($("#st_from_date").val(),$("#st_to_date").val()) == false)
				return;

			kepSearch(document.searchCondition,  mySheet , "/mdct/getMasterMdCtCreditDeptPop.do" , pagingMode );
			break;
		
		case "reload":	// 초기화
			kepReload('searchCondition');
			mySheet.RemoveAll();
			
			$("#st_from_date").val( kepToMonthAdd("1","M") );
			$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/') );
			break;
	}
}

//그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	
	return DATA;
}
	
//조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	
	if(!checkedSession(stCode)){
		return;
		}	

	if (msg != ""){
		alert(msg);
	}
}

//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	
	if(!checkedSession(stCode)){
		return;
	}
	
	if (msg != ""){
		alert(msg);
	}
	
	if(code>0){
		//저장 성공시 재조회
		doAction('search');
	}
}

function mySheet_OnDownFinish(downloadType, result){
	loader_obj("N");
}

/**
 * 시작일 종료일 검증
 */
function kep_dateSearchCheck(startdate,enddate){
	
	var s = startdate.replace(/[/]/gi,"");
	var e = enddate.replace(/[/]/gi,"");
	
	if (s > e) {
		alert("시작일이 종료일보다 전이어야 합니다. 확인 부탁드립니다.");
		return false;
	}
}

 //-->
</script> 
<body onload="kep_onload_view();doAction('search');">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:550px;">
    	<div id="popHeader">
        	<h1 class="title">미마감 발주상세</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
             <div id="searchBtnA02">
             	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
		    	<span class="btn_reset"><a href="javascript:doAction('reload')">초기화</a></span>
            </div>
            
            <form name="searchCondition" id="searchCondition" method=post >
				<!--HIDDEN-->
				<!-- 공통 -->
				<input type="hidden" name="s_SAVENAME">
				<input type="hidden" id="pageflag" name="pageflag" value="1">
				<!-- 화면 내 정의 -->
				<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
				<input type="hidden" id="st_irs_no" name="st_irs_no"  value="<%=st_irs_no%>">
				<input type="hidden" id="st_kep_dept" name="st_kep_dept"  value="<%=st_kep_dept%>">
				<input type="hidden" id="st_strt_date" name="st_strt_date"  value="<%=st_strt_date%>">
				<input type="hidden" id="st_end_date" name="st_end_date"  value="<%=st_end_date%>">
	            <!--조회영역-->
	            <div id="cont_searchA">
	            	<table class="cont_t_list01" style="width:100%">
						<caption>미마감 발주상세</caption>
						<colgroup>
							<col width="90px" />
							<col width="25%" />
							<col width="90px" />
							<col width="25%" />
							<col width="90px" />
	                        <col width="25%" />
						</colgroup>
						<tbody>
							<tr>
								<th>발주번호</th>
								<td>
									<input type="text" class="input_type_text" id="st_po_no" name="st_po_no" style="width:70%;" value="" onkeydown="kepEnter()">
								</td>
								<th>등록일</th>
								<td>
									<input type="text" name="st_from_date" id="st_from_date" readOnly style="width:70px; text-align:center;" > - 
									<input type="text" name="st_to_date" id="st_to_date" readOnly style="width:70px; text-align:center;" >
								</td>
								<th></th>
								<td></td>
							</tr>
						</tbody>
					</table>
	            </div>
	             <span class="fl">
               	※ 배송완료 : 협력사에서 납품실적을 등록한 상태. 발주잔액은 2014년 1월 1일 이후 데이터 기준.
				</span>
            </form>
            <br/>
            
           	<!--grid-->
            <div>
            	<div class="ib_product" style="border-top:2px solid #3c639c">
	  				<script type="text/javascript">
	  					createIBSheet("mySheet", "100%", "354px");
	  				</script>
	  			</div>
	  			<p class="paging" id="pageindex"></p>
        	</div>
    	</div>
	</div>
</body>
</html>
