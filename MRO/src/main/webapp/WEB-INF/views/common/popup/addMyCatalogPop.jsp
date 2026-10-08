<%--
**********************************************
* 메뉴(운영사) : 회원사관리>고객업무대행>마스터코드관리>부서코드관리
* 메뉴(고객사) : 관리자>마스터코드관리>부서코드관리
* 화면 : 부서코드관리
* 기능 : 
* 프로그램 ID : PG_90_B_400_25
* 담당자 : 최명진 ( 설계 : 공통 )
* 착수일 : 2014-
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%
String st_mycateg       = CommonUtil.nvl((String) request.getParameter("st_mycateg"), "");
String st_mygroup_yn       = CommonUtil.nvl((String) request.getParameter("st_mygroup_yn"), "");
%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/buyer_layout.css" type="text/css" />
<link rel="stylesheet" type="text/css" media="screen"	href="/resources/libs/jquery/css/smoothness/jquery-ui.min.css"/>  
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.cookie.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
<script src="/resources/js/common.js"></script>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
	         		 { Align:"Center",Width:60,		Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",			Header:"상태",				SaveName:"sStatus"}
	         		,{ Align:"Center",	Width:40,		Edit:true,	EditLen:30,	Hidden:true,	Type:"Text",				Header:"순번",				SaveName:"RN"}
	         		,{ Align:"Center",	Width:40,		Edit:true,	EditLen:30,	Hidden:false,	Type:"DummyCheck",	Header:"",						SaveName:"SELECTED"}
	         		,{ Align:"Left",	Width:480,	Edit:true,	EditLen:200,	Hidden:false,	Type:"Text",				Header:"<%=CommonLang.get("HTITLE893")%>",		SaveName:"TEXT1"}	/* 분류명 */
	         		,{ Align:"Left",	Width:400,	Edit:false,	EditLen:200,	Hidden:true,	Type:"Text",				Header:"CODE1",				SaveName:"CODE1"}
	         		,{ Align:"Left",	Width:400,	Edit:false,	EditLen:200,	Hidden:true,	Type:"Text",				Header:"CODE2",				SaveName:"CODE2"}
	         		,{ Align:"Left",	Width:400,	Edit:false,	EditLen:200,	Hidden:true,	Type:"Text",				Header:"TEXT2",				SaveName:"TEXT2"}
	         		,{ Align:"Left",	Width:400,	Edit:false,	EditLen:200,	Hidden:true,	Type:"Text",				Header:"TEXT3",				SaveName:"TEXT3"}
	         		,{ Align:"Left",	Width:400,	Edit:false,	EditLen:200,	Hidden:true,	Type:"Text",				Header:"TEXT4",				SaveName:"TEXT4"}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);
}
	
var st;
var mt;

// 기능함수
function doAction(str) {
	
	st = new Date();
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if ( str != "search"  && str != "reload" && str != "add" && selectedGrid.length == 0 ) {
		alert("<%=CommonLang.msg("MSG78")%>");	//선택된 항목이 없습니다.
		return;
	}

	switch (str) {
		case "search": // 조회
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mdcm/getBuyerMdAmGoodsCategLis.do" , pagingMode );
			break;
		
		case "reload": // 초기화
			kepReload('searchCondition');
			mySheet.RemoveAll();
			break;
	
		case "add": // 추가
				var rows = mySheet.DataInsert(-1);
				mySheet.SetCellValue(rows, "SELECTED", "1");
			break;
			
		case "save": // 저장
			for ( var i =1; i < mySheet.RowCount()+1;i++) {
				if ( mySheet.GetCellValue(i, "SELECTED") == 1) {
					if(mySheet.GetCellValue(i, "TEXT1") == ""||mySheet.GetCellValue(i, "TEXT1") == null){
						alert(i+"<%=CommonLang.msg("MSG509")%>");	//번째 분류명 정보가 없습니다.
						return;
					}
				
				}
			}
			if ( !confirm('<%=CommonLang.msg("MSG292")%>') )	//선택한 항목을 저장 하시겠습니까?
				return;
			kepSave(document.searchCondition ,  mySheet , "/mdcm/saveBuyerMdAmGoodsCategLis.do" , "SELECTED" );
			break;
			
		case "del": // 삭제
			if ( !confirm('<%=CommonLang.msg("MSG293")%>') )	//선택한 항목을 삭제 하시겠습니까?
				return;
			if ( !beforeProcessDelete() )
				return;
			kepSave(document.searchCondition ,  mySheet , "/mdcm/delBuyerMdAmGoodsCategLis.do" , "SELECTED" );
			break;

		case "confirm": // 확인
			var strType = "addMyCatalogPop";
			var strText = "";
			var strCode = "";
			var cnt = 0;
			for ( var i =1; i < mySheet.RowCount()+1;i++) {
				if ( mySheet.GetCellValue(i, "SELECTED") == 1) {
					strText = mySheet.GetCellValue(i, "TEXT1");
					strCode = mySheet.GetCellValue(i, "CODE2");
					cnt++;
				}
			}
			if(cnt > 1){
				alert("<%=CommonLang.msg("MSG510")%>");	//다중 선택은 불가능 합니다.
				return;
			}
			opener.setPopupReturn(strType,strText,strCode);
			this.close();
			break;
	}
}

// 그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	return DATA;
}
	
// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	
	if (msg != "") {
		alert(msg);
	}
	if(current_page==-1){
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
	
	if(code>=0){
		//저장 성공시 재조회
		doAction('search');
		opener.kepSearch(1);
	}
}

// 페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mdcm/getBuyerMdAmGoodsCategLis.do?page="+current_page , pagingMode );
}

// 행삭제 선행 처리
function beforeProcessDelete() {
	for ( var i = mySheet.RowCount(); i >= 1; i-- ) {
		if ( mySheet.GetCellValue(i, "SELECTED") == 1 && mySheet.GetCellValue(i, "sStatus") == 'I' ) {
			mySheet.RowDelete(i, 0);
		}
	}
	
	if ( mySheet.FindCheckedRow("SELECTED").length == 0 ) {
		return false;
	}
	
	return true;
}

</script>
</head>
<body onload="kep_onload_view()">

<!--내용 시작-->
<div id="popWrapper" style="height:494px; min-height: 100px;">    
    	<div id="popHeader">
        	<h1 class="title"><%=CommonLang.get("HTITLE27")%><!-- 분류추가 --></h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
          <div id="searchBtnA02">
         	<span class="btn_search"><a href="javascript:doAction('search')"><%=CommonLang.get("HTITLE7")%><!-- 조회 --></a></span> 
         	<span class="btn_reset"><a href="javascript:doAction('reload')"><%=CommonLang.get("HTITLE8")%><!-- 초기화 --></a></span>
         </div>    	
    
	    <!--조회영역-->
		<form name = "searchCondition" method = "post">
			<div id="cont_searchA">
				<!--HIDDEN-->
				<!-- 공통 -->
				<input type="hidden" name="s_SAVENAME">
				<input type="hidden" id="pageflag" name="pageflag" value="1">
				<!-- 화면 내 정의 -->
				<input type="hidden" id="st_com_code" name="st_com_code"  value="${sessionInfo.comCode}">
				<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
				<input type="hidden" id="st_type" name="st_type"  value="ITEM">
					
				<table  class="cont_t_list01" style="width:100%;">
					<caption>분류추가</caption>
					<colgroup>
						<col width="10%" />
						<col width="*" />
					</colgroup>
								
					<tbody>
						<tr>
							<th><%=CommonLang.get("HTITLE893")%><!-- 분류명 --></th>
							<td>
								<input type="text" class="input_type_text" id="st_mycateg" name="st_mycateg" style="width:200px" value="<%=st_mycateg %>";ime-mode:active">
							</td>
						</tr>
					</tbody>
				</table>
			</div>
	            
			<span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
				<label for="b_no02" class="hidden">정렬개수선택</label>
				<select name="onepagerow" style="width: 70px;" >
					<option value="10" selected>10<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
					<option value="20">20<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
					<option value="30">30<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
					<option value="40">40<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
					<option value="50">50<%=CommonLang.get("HTITLE595")%><!-- 건 --></option>
				</select>
			</span>
			<br>
		</form>
						
		<!--grid-->
		<div class="ib_product" style="border-top:2px solid #3c639c">
			<script type="text/javascript">
				createIBSheet("mySheet", "100%", "220px");
			</script>
		</div>
		<p class="paging" id="pageindex"></p>
	  			
		<!--버튼영역-->
		<div class="btnArea">
			<span class="fl">
			</span>
	  				
			<span class="fr">
				<span class="btn_02 mr04"><a href="javascript:doAction('add');"><%=CommonLang.get("HTITLE36")%><!-- 행추가 --></a></span>
				<span class="btn_02 mr04"><a href="javascript:doAction('save');"><%=CommonLang.get("HTITLE124")%><!-- 저장 --></a></span>
				<span class="btn_02"><a href="javascript:doAction('del');"><%=CommonLang.get("HTITLE25")%><!-- 삭제 --></a></span>
				<%if(st_mygroup_yn.equals("Y")){ %>
					<span class="btn_02"><a href="javascript:doAction('confirm');"><%=CommonLang.get("HTITLE516")%><!-- 확인 --></a></span>
				<%} %>
			</span>
		</div>
<!--내용 종료-->
	</div>	                 
	</div>
</div>
</body>
</html>
