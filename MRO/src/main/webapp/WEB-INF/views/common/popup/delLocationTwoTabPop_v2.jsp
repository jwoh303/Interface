<%--
**********************************************
* 메뉴 : 배송주소(도착지) 팝업
* 화면 : 배송주소(도착지) 팝업
* 기능 : 배송주소(도착지) 팝업
* 프로그램 ID : 
* 담당자 : 최찬규
* 착수일 : 2026-05-21
**********************************************
--%> 
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../include/head_v2.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
String com_code = CommonUtil.nvl((String) request.getParameter("com_code"),"");  //  (조회조건) 
String del_code = CommonUtil.nvl((String) request.getParameter("del_code"),"");  //  (조회조건) 
String del_name = CommonUtil.nvl((String) request.getParameter("del_name"),"");  //  (조회조건) 
String open = CommonUtil.nvl((String) request.getParameter("open"),"");  //  (조회조건)
String st_delyto_field = CommonUtil.nvl((String) request.getParameter("st_delyto_field"),"");  //결과내재검색
String st_check = CommonUtil.nvl((String) request.getParameter("st_check"),"");  //결과내재검색

SessionInfo sessionInfoPop = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String userId = "";
if (sessionInfoPop != null){ 
	userId = CommonUtil.nvl((String)sessionInfoPop.getUserId()); 
}

%>
<script type="text/javascript">
var mySheet = new ibsheetObject();
var mySheet2 = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly,CountPosition: 3,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet.HeaderMode={HeaderCheck:0}
	initsheet.Cols = [
		
		{ Align:"Center",	SaveName:"sStatus",				Header:"<%=CommonLang.get("HTITLE255")%>",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true} /*상태*/
		,{ Align:"Center",	SaveName:"SELECTED",			Header:"",		Type:"DummyCheck",	Width:80,	Edit:true,	Hidden:false}
		,{ Align:"Center",	SaveName:"CODE",		Header:"<%=CommonLang.get("HTITLE1359") %>",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:false}/*배송지코드*/
		,{ Align:"Left",	SaveName:"TEXT1",			Header:"<%=CommonLang.get("HTITLE1360") %>",				Type:"Text",		Width:200,	Edit:false,	EditLen:100,	Hidden:false}/*배송지명*/
		,{ Align:"Left",	SaveName:"TEXT2",			Header:"<%=CommonLang.get("HTITLE1361") %>",				Type:"Text",		Width:470,	Edit:false,	EditLen:100,	Hidden:false}/*배송지주소*/
	];
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	IBS_InitSheet(mySheet2, initsheet, pagingMode);

	mySheet.SetHeaderBackColor("#f2f7ff");
	mySheet.SetCountFormat(" <%=CommonLang.get("HTITLE921")%>  ROWCOUNT <%=CommonLang.get("HTITLE595")%> "); //총 ROWCOUNT 건
	
	mySheet.SetTheme("DB", "DeepBlue");
	
	mySheet2.SetHeaderBackColor("#f2f7ff");
	mySheet2.SetCountFormat(" <%=CommonLang.get("HTITLE921")%>  ROWCOUNT <%=CommonLang.get("HTITLE595")%> "); //총 ROWCOUNT 건
	
	mySheet2.SetTheme("DB", "DeepBlue");
	
	doAction('search');
}

// 기능함수
function doAction(str) {
	

	switch (str) {
		case "search":	 // 조회
			kepSearch(document.delLocationPop, mySheet, "/common/commonDlyLocationList_v2.do" , pagingMode);
			break;
		case "search2": //2번째 조회
			kepSearch(document.delLocationPop2, mySheet2, "/common/commonList_v3.do" , pagingMode);
			break;
	}
}

// 조회 후처리
function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	doAction("search2");

}
function mySheet2_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

}
// function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
// 	if ( Row  < 1) return;
// 	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	
// 	var value1 = mySheet.GetCellValue(Row,"CODE");
// 	var value2 = mySheet.GetCellValue(Row,"TEXT1");
// 	var value3 = mySheet.GetCellValue(Row,"TEXT2");
// 	if(column == "TEXT1" || column == "CODE" || column == "TEXT2"){
// 		opener.setPopupReturn(value1,value3,value2);
// 		this.close();
// 	}
// }
// function mySheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
// 	if ( Row  < 1) return;
// 	var column = mySheet2.ColSaveName(mySheet2.GetSelectCol());
	
// 	var value1 = mySheet2.GetCellValue(Row,"CODE");
// 	var value2 = mySheet2.GetCellValue(Row,"TEXT1");
// 	var value3 = mySheet2.GetCellValue(Row,"TEXT2");
// 	if(column == "TEXT1" || column == "CODE" || column == "TEXT2"){
// 		opener.setPopupReturn(value1,value3,value2);
// 		this.close();
// 	}
// }

function mySheet_OnBeforeCheck(row, col) {

	if(mySheet.GetCellValue(row,"SELECTED") == 0){ //체크전에 확인하는거라 0이면 -> 이후 체크 된다는 뜻임
		for(var i = 1; i<=mySheet.RowCount(); i++){
			if(row == i){
				continue;
			}
			mySheet.SetCellValue(i,"SELECTED",false);
		}
		for(var i = 1; i<=mySheet2.RowCount(); i++){
			mySheet2.SetCellValue(i,"SELECTED",false);
		}
	}else if(mySheet.GetCellValue(row,"SELECTED") == 1){ //체크전에 확인하는거라 1이면 -> 이후 체크 해제된다는 뜻임
	}
}
function mySheet2_OnBeforeCheck(row, col) {

	if(mySheet2.GetCellValue(row,"SELECTED") == 0){ //체크전에 확인하는거라 0이면 -> 이후 체크 된다는 뜻임
		for(var i = 1; i<=mySheet.RowCount(); i++){
			mySheet.SetCellValue(i,"SELECTED",false);
		}
		for(var i = 1; i<=mySheet2.RowCount(); i++){
			if(row == i){
				continue;
			}
			mySheet2.SetCellValue(i,"SELECTED",false);
		}
	}else if(mySheet2.GetCellValue(row,"SELECTED") == 1){ //체크전에 확인하는거라 1이면 -> 이후 체크 해제된다는 뜻임
	}
}
function setDeliveryInfo(){
	var value1 = "";
	var value2 = "";
	var value3 = "";
	
	for(var i = 1; i<=mySheet.RowCount(); i++){
		if(mySheet.GetCellValue(i,"SELECTED",true)){
			value1 = mySheet.GetCellValue(i,"CODE");
			value2 = mySheet.GetCellValue(i,"TEXT1");
			value3 = mySheet.GetCellValue(i,"TEXT2");
		}
	}
	for(var i = 1; i<=mySheet2.RowCount(); i++){
		if(mySheet2.GetCellValue(i,"SELECTED",true)){
			value1 = mySheet2.GetCellValue(i,"CODE");
			value2 = mySheet2.GetCellValue(i,"TEXT1");
			value3 = mySheet2.GetCellValue(i,"TEXT2");
		}
	}
	
	var recv_user = $("#recv_user").val();
	var recv_user_phone = $("#recv_user_phone").val();
	
	opener.setPopupReturn(value1,value3,value2,recv_user,recv_user_phone);
	this.close();
}
</script>

<body onload="kep_onload_view();">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div class="wrapPopup"  >
  <div class="PopupTit"><%=CommonLang.get("HTITLE1362")%><!--배송지관리--><span><a href="javascript:self.close();" class="closePopup"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  
  <div class="Popup_GrayBox Popup_BlueBox mt10">
    <div class="tit mr10" ><%=CommonLang.get("HTITLE827") %><!-- 인수자명 --></div>
    <input class="input42 mr50" style="width:180px" name="recv_user" id="recv_user" type="text" />
    <div class="tit mr10" ><%=CommonLang.get("HTITLE42") %><!-- 연락처 --></div>
    <input class="input42" style="width:180px" onkeyup="kepNumcheck3(this);" maxlength="20" name="recv_user_phone" id="recv_user_phone" type="text" />
  </div> 
  
  <div class="PopByerTab mt10">
   <button class="TabTit active" data-tab="Search1"><%=CommonLang.get("HTITLE1363")%><!--등록된 배송지--></button>
   <button class="TabTit" data-tab="Search2"><%=CommonLang.get("HTITLE1364")%><!--최근 배송지--></button> 
  </div>
  <div id="Search1" class="PopByerContent active">
  <form name="delLocationPop" id="delLocationPop" method=post >
	 <input type="hidden" name="s_SAVENAME" />
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="delLocationPop"> 
	 <input type="hidden" name="com_code" id="com_code"  value="<%=com_code%>"> 	 
	 <input type="hidden" id="st_delyto_field" name="st_delyto_field" value="<%=st_delyto_field%>">
	 <input type="hidden" id="st_check" name="st_check" value="N">
    <div class="Popup_GrayBox mt10" >
      <input class="input44" style="width:110px"  name="del_code" id="del_code" value="" onKeyDown="kepEnter_v2()" type="text" placeholder="<%=CommonLang.get("HTITLE1359")%>"/> <!-- 배송지코드 -->
      <div class="SearchPopupInput"  style="width:430px; display:inline-block ">
        <input type="text" name="del_name" id="del_name" value="" onKeyDown="kepEnter_v2()" style=" width:85%; " placeholder="<%=CommonLang.get("HTITLE1365")%>"><!-- 배송지명,배송지주소 -->
        <button type="button" onclick="javascript:doAction('search');return false;"></button>
      </div>
    </div> 
    <div class="ScrollBox borderTop01 mt10" style="height:227px;">
    	<script type="text/javascript">
			createIBSheet("mySheet", "100%", "100%");
		</script>
	</div>
  </form>
  </div><!--id="Search1"끝 -->  
  
  
  <div id="Search2" class="PopByerContent">
  <form name="delLocationPop2" id="delLocationPop2" method=post >
	 <input type="hidden" name="s_SAVENAME" />
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="orderDelLocationPop_v2"> 
	 <input type="hidden" name="st_user_id" id="st_user_id" value="<%=userId%>">
	 <input type="hidden" name="com_code" id="com_code"  value="<%=com_code%>"> 	 
	 <input type="hidden" id="st_delyto_field" name="st_delyto_field" value="<%=st_delyto_field%>">
	 <input type="hidden" id="st_check" name="st_check" value="N">
    <div class="Popup_GrayBox mt10" >
      <input class="input44" style="width:110px"  name="del_code" id="del_code2" value="" onKeyDown="kepEnter_v2()" type="text" placeholder="<%=CommonLang.get("HTITLE1359")%>"/> <!-- 배송지코드 -->
      <div class="SearchPopupInput"  style="width:430px; display:inline-block ">
        <input type="text" name="del_name" id="del_name2" value="" onKeyDown="kepEnter_v2()" style=" width:85%; " placeholder="<%=CommonLang.get("HTITLE1365")%>"><!-- 배송지명,배송지주소 -->
        <button type="button" onclick="javascript:doAction('search2');return false;"></button>
      </div>
    </div> 
    <div class="ScrollBox borderTop01 mt10" style="height:227px;">
    	<script type="text/javascript">
			createIBSheet("mySheet2", "100%", "100%");
		</script>
	</div>    
   </form>
  </div><!--id="Search2" 끝 -->         
  <!-- 탭 스크립트 -->     
  <script>
      const tabLinks = document.querySelectorAll(".TabTit");
      const tabContents = document.querySelectorAll(".PopByerContent");
      tabLinks.forEach(function(link){
        link.addEventListener("click", function()  {
          // 모든 탭 버튼, 컨텐츠 비활성화
          tabLinks.forEach(function(btn){btn.classList.remove("active")});
          tabContents.forEach(function(content){content.classList.remove("active")});
    
          // 클릭한 탭 활성화
          link.classList.add("active");
          document.getElementById(link.dataset.tab).classList.add("active");
        });
      });
  </script>
  
  <div class="PopupListBtnBox_Center mt30">
    <button class="ButQuaternary_large closePopup" onclick="javascript:self.close(); return false;"><%=CommonLang.get("HTITLE229") %><!-- 취소 --></button>
    <button class="ButPrimary_large" onclick="javascript:setDeliveryInfo(); return false;"><%=CommonLang.get("HTITLE516") %><!-- 확인 --></button>
  </div>   
</div><!-- wrapPopup 끝-->
</body>
</html>
