<%--
**********************************************
* 메뉴 : 
* 화면 : MSDS 메일 전송 팝업
* 기능 : MSDS 메일 전송 팝업
* 프로그램 ID : 
* 담당자 : 한승준
* 착수일 : 2019-05-07
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<% 
	String p_buyer = CommonUtil.nvl((String) request.getParameter("p_buyer"),"");  //  (st_buyer_code)
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
 
</head>

<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [
					 { Align:"Center",	Width:40,	Edit:true,					Hidden:false,	Type:"Radio",	Header:"선택",		SaveName:"SELECTED"}
					,{ Align:"Center",	Width:60,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",	Header:"순번",		SaveName:"SEQ"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사코드",		SaveName:"BUYER"}
					,{ Align:"Left",	Width:200,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",	Header:"고객사명",		SaveName:"BUYER_NAME"}
					,{ Align:"Left",	Width:100,	Edit:true,	EditLen:200,	Hidden:false,	Type:"Text",	Header:"수신자명",		SaveName:"RECV_USER_NAME"}
					,{ Align:"Left",	Width:200,	Edit:true,	EditLen:200,	Hidden:false,	Type:"Text",	Header:"수신자이메일",	SaveName:"RECV_EMAIL"}
					,{ Align:"Left",	Width:200,	Edit:true,	EditLen:200,	Hidden:false,	Type:"Text",	Header:"비고",		SaveName:"REMARK"}
	];
	
	initsheet.Cfg = {MergeSheet:msHeaderOnly,FrozenCol:0};
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	mySheet.SetCountPosition(4);
	doAction('search');
}
//기능함수
function doAction(str) {
	
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");

	// 선택된 항목 유무 체크
	if (str !="search" && selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}
	
	switch (str) {
		case "search":	 // 조회
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mdcm/getMasterMdcmMsdsMailSendPopList.do" , "" );
			break;
		case "save":	//저장하기
			var recv_user_name = "";
			var recv_email = "";
			var remark = "";
			
			for(var i=1; i<mySheet.GetTotalRows()+1; i++){
				if (mySheet.GetCellValue(i, "SELECTED") == '1'){
					recv_user_name = mySheet.GetCellValue(i, "RECV_USER_NAME");
					recv_email = mySheet.GetCellValue(i, "RECV_EMAIL");
				}
			}

			remark = $("#st_kep_note").val();
			
			opener.setPopupReturn(recv_user_name, recv_email, remark);
			this.close();
			//kepSave(document.searchCondition ,  mySheet , "/mdcm/saveMasterItemNoMapping.do" , "SELECTED"  );
			break;
	}
}

//그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	
	return DATA;
}
	
// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	
}
	
// 트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if (msg != "") {
		alert(msg);
	}
}

// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	return;
}

</script> 
<body onload="kep_onload_view()">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:594px;">
    	<div id="popHeader">
        	<h1 class="title">MSDS 메일 전송 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
             <div id="searchBtnA02">
             	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
            </div>
            
            <form name="searchCondition" id="searchCondition" method=post >
				<!--HIDDEN-->
				<!-- 공통 -->
				<input type="hidden" name="s_SAVENAME">
				<input type="hidden" id="pageflag" name="pageflag" value="1">
				<!-- 화면 내 정의 -->
				<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
				<input type="hidden" name="st_buyer_code" id="st_buyer_code" value="<%=p_buyer%>">
	            <!--조회영역-->
	            <div id="cont_searchA">
	            	<table class="cont_t_list01" style="width:100%">
						<caption>MSDS 메일 전송</caption>
						<colgroup>
							<col width="10%" />
							<col width="23%" />
							<col width="10%" />
							<col width="23%" />
							<col width="10%" />
							<col width="23%" />
						</colgroup>
					<tbody>
						<tr>
							<th>수신자명</th>
							<td>
								<input type="text" class="input_type_text" id="st_recv_user_name" name="st_recv_user_name" style="width:87%"  value="">
							</td>
							<th>비고</th>
							<td>
								<input type="text" class="input_type_text" name="st_remark" id="st_remark" style="width:87%" value="">
							</td>
							<th></th>
							<td>
							</td>
						</tr>
					</tbody>
					</table>
	            </div>
            </form>
            <br/>
            
           	<!--grid-->
            <div>
            	<div class="ib_product" style="border-top:2px solid #3c639c">
	  				<script type="text/javascript">
	  					createIBSheet("mySheet", "100%", "200px");
	  				</script>
	  			</div>
	  			<br>
	  			<table class="cont_t_list07" style="width:100%">
					<colgroup>
						<col width="15%"/>
						<col width="*" />
					</colgroup>
					<tbody>
			  			<tr>		
							<th>비고 입력</th>			
							<td >
								<input type="text" name="st_kep_note" id="st_kep_note" class="input_type_text" title="" style="width:90%;" value=""/>
							</td>
			 			</tr>
					</tbody>
				</table>
  			<!--버튼영역-->
               <div class="btnArea02" >
  	          	<span class="fr">
  					<span class="btn_04 mr02"><a href="javascript:doAction('save');">확인</a></span>
  				</span>
  			 </div>
        	</div>
    	</div>
	</div>
</body>
</html>
