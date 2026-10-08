<%--
**********************************************
* 메뉴 : 고객사 > 메인 > 예산조회 팝업
* 화면 : 예산조회 
* 기능 : 예산조회 팝업
* 프로그램 ID : 
* 담당자 : 최찬규
* 착수일 : 2026-08-13
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<title>코리아 e 플랫폼</title>
<head>
<%@ include file="../../include/head_v2.jspf"  %>
</head>

<%
// 공통
String SessionComCode = "";
String SessionUserId = "";
String SessionUserDept = "";
String SessionUserDeptName = "";
String SessionUserType = "";
String onepagerow = "30";
SessionInfo sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
if (sessionInfo != null){ 
	SessionComCode = CommonUtil.nvl((String)sessionInfo.getComCode());
	SessionUserId = CommonUtil.nvl((String)sessionInfo.getUserId());  
	SessionUserDept = CommonUtil.nvl((String)sessionInfo.getDepartment());
	SessionUserDeptName = CommonUtil.nvl((String)sessionInfo.getDepartmentName());
	SessionUserType = CommonUtil.nvl((String)sessionInfo.getUserType());
	onepagerow = CommonUtil.nvl((String)_sessionInfo.getRowCnt(),"30");
	String pageString = "30,50,100,200,500,1000";
	if(!Arrays.asList(pageString.split(",")).contains(onepagerow)){
		onepagerow = "30";
	}
}
boolean p060000140 = CommonUtil.getSpecialCheckReturn(SessionComCode,"P06-0000140"); // 예산 조회시 icomcod3의 전용 조건 참고여부
String stAccountFlg = "N";
if(p060000140 == true){
	stAccountFlg = "Y";
}
%>

<script type="text/javascript">
//alert layer용
var but1text = "<%=CommonLang.get("HTITLE516")%>"; //확인
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch = "javascript:thisPopClose(); return false;";
var but1funcReload = "javascript:thisPopReload(); return false;";
var but1width = "120px";

var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var grbRow = "";
var gYear = "";
//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {

	var date = new Date();
	year = date.getFullYear();
	month = date.getMonth()+1;
	for(var i=-1;i<=1;i++) {
		if(i == 0){
			gYear = year+i;
			$('#st_year').append('<option value="' + (year+i) + '" selected>' + (year+i) + '</option>');
		}else{
			$('#st_year').append('<option value="' + (year+i) + '">' + (year+i) + '</option>');
		}
	}
	
	var initsheet = {};
	initsheet.Cfg = {MergeSheet:msHeaderOnly,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet.Cols = [
			 {Align:"Center",	SaveName:"DEPT",				Header:"<%=CommonLang.get("HTITLE380")%>",		Type:"Text",	Width:70,	Edit:false,	EditLen:100,	Hidden:false}/*부서코드*/
			,{Align:"Left",		SaveName:"DEPT_NAME",			Header:"<%=CommonLang.get("HTITLE323")%>",		Type:"Text",	Width:180,	Edit:false,	EditLen:200,	Hidden:false}/*부서명*/
			,{Align:"Left",		SaveName:"BDGT_DEPT_NAME",		Header:"<%=CommonLang.get("HTITLE419")%>",		Type:"Text",	Width:180,	Edit:false,	EditLen:20,		Hidden:false}/*예산부서*/
			,{Align:"Left",		SaveName:"ACCOUNT_TYPE_TEXT",	Header:"<%=CommonLang.get("HTITLE966")%>",		Type:"Text",	Width:195,	Edit:false,	EditLen:30,		Hidden:false}/*예산계정*/
			,{Align:"Center",	SaveName:"TERM_TYPE_TEXT",		Header:"<%=CommonLang.get("HTITLE433")%>",		Type:"Text",	Width:80,	Edit:false,	EditLen:100,	Hidden:false}/*기간구분*/
			,{Align:"Left",		SaveName:"TERM_TEXT",			Header:"<%=CommonLang.get("HTITLE423")%>",		Type:"Text",	Width:110,	Edit:false,	EditLen:100,	Hidden:false}/*기간*/
			,{Align:"Right",	SaveName:"PLAN_AMT",			Header:"<%=CommonLang.get("HTITLE430")%>",		Type:"Float",	Width:100,	Edit:false,	EditLen:100,	Hidden:false}/*예산금액*/
			,{Align:"Right",	SaveName:"RESULT_AMT",			Header:"<%=CommonLang.get("HTITLE434")%>",		Type:"Float",	Width:100,	Edit:false,	EditLen:100,	Hidden:false}/*실적금액*/
			,{Align:"Right",	SaveName:"TEMP_AMT",			Header:"<%=CommonLang.get("HTITLE435")%>",	Type:"Float",	Width:85,	Edit:false,	EditLen:100,	Hidden:false}/*임시실적금액*/
			,{Align:"Right",	SaveName:"BAL_AMT",				Header:"<%=CommonLang.get("HTITLE1508")%>",		Type:"Float",	Width:100,	Edit:false,	EditLen:100,	Hidden:false}/*잔여금액*/
	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);

	mySheet.SetHighlightAfterSort(2);
	
	mySheet.SetHeaderBackColor("#f2f7ff");
	mySheet.SetTheme("DB", "DeepBlue");
	doAction("search");
}

var st;
var mt;

//기능함수
function doAction(str, flag) {
	st = new Date();
	
	switch (str) {
		case "search":
			
			var stYear = $("#st_year").val();
			if(stYear ==  "" || stYear ==  null){
				var text = "<%=CommonLang.msg("MSG717")%>"; //예산년도를 선택해주세요.
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
			var termType = $("#st_term_type").val();
			
			if(termType == "ALL"){
				$("#st_term").val("");
				$("#st_term_dt").val("");
			}else{
				if(termType == "Y"){
					$("#st_term").val(stYear);
					$("#st_term_dt").val("");
				}else if(termType == "M"){
					var stMonth = $("#M_sel").val();
					if(stMonth != "" && stMonth <= 9){
						stMonth = "0"+stMonth;
					}
					$("#st_term").val(stYear+stMonth);
					$("#st_term_dt").val($("#M_sel").val());
				}else{
					$("#st_term").val(stYear+""+$("#st_term_type").val()+""+$("#"+$("#st_term_type").val()+"_sel").val());
					$("#st_term_dt").val($("#"+$("#st_term_type").val()+"_sel").val());
				}
			}			current_page = 1;
			kepSearch_v2(document.searchForm, mySheet, "/home/getBuyerHomeDeptBudgetPopList_v2.do", pagingMode);
			break;
			
		case "reload":
			kepReload_v2('searchForm');
			$("#st_year").val(gYear);
			var termElements = document.getElementsByName('st_term_sel');
			for (var i = 0; i < termElements.length; i++) {
			    termElements[i].style.display = 'none';
			}
			mySheet.RemoveAll();
			break;
		case "excelDown": // 엑셀다운로드
			if(mySheet.RowCount() == 0){
//		 		조회된 데이터가 없습니다.
				var text = "<%=CommonLang.msg("MSG347")%>";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
			mySheet.SetWaitImageVisible(true);
			
			var downRow = "|0";
			for(var i=1; i<=mySheet.RowCount(); i++) {
				downRow += "|"+i;
			}
			
			var downCol = "";
			for(var i=0; i<=mySheet.LastCol(); i++){
				if(!mySheet.GetColHidden(i) && mySheet.ColSaveName(i) !="SELECTED" && mySheet.GetCellProperty(1, i, "Type") != "Image"){
					downCol += "|"+i;
				}
			}
			
			if(downRow == "|0"){
				downRow = "";
			}
			var nowTime = kepGetNowTimeStr("YYYYMMDDHHMI","");
			
			var fileName = "<%=CommonLang.get("HTITLE431")%>" +"_"; //예산조회_
			
			var param = {FileName:fileName+nowTime, SheetName:fileName, DownRows:downRow, DownCols:downCol, DownHeader:1, DownSum:1, Merge:0, SheetDesign:0, CheckBoxOnValue:'Y', CheckBoxOffValue:'N', DownCombo:'TEXT', OnlyHeaderMerge:1};
			mySheet.Down2Excel(param);
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
	
	makePageIndex2_v3(mySheet, current_page, document.searchForm.onepagerow.value);	
}
	

// 페이지 인덱스 클릭시 재조회
function pageSearch(param) {
	//조회
	current_page = param.page;
	kepSearch_v2(document.searchForm ,  mySheet , "/home/getBuyerHomeDeptBudgetPopList_v2.do?page="+current_page , pagingMode );
}

function termChange(){
	//select박스 display none 처리
	var termElements = document.getElementsByName('st_term_sel');
	for (var i = 0; i < termElements.length; i++) {
	    termElements[i].style.display = 'none';
	}
	$('select[name="st_term_sel"]').val("");
	
	var term = $("#st_term_type").val();
	if(term == "ALL" || term == "Y"){
	}else{
		$("#"+term+"_sel").show();
	}
}

</script> 
<body onload="kep_onload_view();">
<form name="searchForm" id="searchForm" method=post>
<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
<input type="hidden" id=st_user_id  name="st_user_id" value="${sessionInfo.userId}">
<input type="hidden" id=st_user_type  name="st_user_type" value="<%=SessionUserType%>">
<input type="hidden" id=st_user_dept  name="st_user_dept" value="<%=SessionUserDept%>">
<input type="hidden" id=st_account_flg name="st_account_flg" value="<%=stAccountFlg%>">
<input type="hidden" id="s_SAVENAME"  name="s_SAVENAME"/>
<input type="hidden" id="pageflag" name="pageflag" value="1"/>
<input type="hidden" id="st_term" name="st_term" value="">
<input type="hidden" id="st_term_dt" name="st_term_dt" value="">
<input type="hidden" name="onepagerow" id="onepagerow_2" value="<%=onepagerow%>">

	<div class="wrapPopup"  >
  <div class="PopupTit"><%=CommonLang.get("HTITLE431") %><!-- 예산조회 --><span><a href="javascript:self.close();" class="closePopup"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="Popup_GrayBox mt10">
    <div class="tit mr05" ><%=CommonLang.get("HTITLE1143") %><!-- 예산년도 --></div>
    <select name="st_year" id="st_year" class="Select40 mr20" style="width:100px;">
    </select> 
    <div class="tit mr05" ><%=CommonLang.get("HTITLE423") %><!-- 기간 --></div>
    <select name="st_term_type" id="st_term_type" class="Select40 mr20" style="width:90px;" onchange="javascript:termChange();">
      <option value="ALL"><%=CommonLang.get("HTITLE29") %><!-- 전체 --></option>
      <option value="Y"><%=CommonLang.get("HTITLE424") %><!-- 년 --></option> 
      <option value="H"><%=CommonLang.get("HTITLE425") %><!-- 반기 --></option> 
      <option value="Q"><%=CommonLang.get("HTITLE426") %><!-- 분기 --></option>
      <option value="M"><%=CommonLang.get("HTITLE427") %><!-- 월 --></option> 
    </select>
    <select name="st_term_sel" class="Select40 mr20" style="width:100px; display: none;" id="H_sel">
      <option value=""><%=CommonLang.get("HTITLE29") %><!-- 전체 --></option>
      <option value="1"><%=CommonLang.get("HTITLE1152") %><!-- 상반기 --></option>
      <option value="2"><%=CommonLang.get("HTITLE1153") %><!-- 하반기 --></option>
    </select>
    <select name="st_term_sel" class="Select40 mr20" style="width:100px; display: none;" id="Q_sel">
      <option value=""><%=CommonLang.get("HTITLE29") %><!-- 전체 --></option>
      <option value="1">1<%=CommonLang.get("HTITLE426") %><!-- 분기 --></option>
      <option value="2">2<%=CommonLang.get("HTITLE426") %><!-- 분기 --></option>
      <option value="3">3<%=CommonLang.get("HTITLE426") %><!-- 분기 --></option> 
      <option value="4">4<%=CommonLang.get("HTITLE426") %><!-- 분기 --></option> 
    </select>
    <select name="st_term_sel" class="Select40 mr20" style="width:100px; display: none;" id="M_sel">
      <option value=""><%=CommonLang.get("HTITLE29") %><!-- 전체 --></option>
      <option value="1">1<%=CommonLang.get("HTITLE427") %><!-- 월 --></option>
      <option value="2">2<%=CommonLang.get("HTITLE427") %><!-- 월 --></option>
      <option value="3">3<%=CommonLang.get("HTITLE427") %><!-- 월 --></option> 
      <option value="4">4<%=CommonLang.get("HTITLE427") %><!-- 월 --></option>
      <option value="5">5<%=CommonLang.get("HTITLE427") %><!-- 월 --></option>
      <option value="6">6<%=CommonLang.get("HTITLE427") %><!-- 월 --></option>
      <option value="7">7<%=CommonLang.get("HTITLE427") %><!-- 월 --></option> 
      <option value="8">8<%=CommonLang.get("HTITLE427") %><!-- 월 --></option>
      <option value="9">9<%=CommonLang.get("HTITLE427") %><!-- 월 --></option>
      <option value="10">10<%=CommonLang.get("HTITLE427") %><!-- 월 --></option>
      <option value="11">11<%=CommonLang.get("HTITLE427") %><!-- 월 --></option> 
      <option value="12">12<%=CommonLang.get("HTITLE427") %><!-- 월 --></option> 
    </select>
    <div class="tit mr05" ><%=CommonLang.get("HTITLE329") %><!-- 부서 --></div>
    <input class="input42 mr20" style="width:140px"  placeholder="" name="st_dept_name" id="st_dept_name" type="text" onKeyDown="kepEnter_v2();" />
    <div class="tit mr05" ><%=CommonLang.get("HTITLE966") %><!-- 예산계정 --></div>
    <input class="input42 mr20" style="width:140px"  placeholder="" name="st_account_name" id="st_account_name" type="text" onKeyDown="kepEnter_v2();" />
    <button class="ButOutline_Medium"  style=" width:100px" onclick="doAction('reload'); return false;" ><%=CommonLang.get("HTITLE8") %><!-- 초기화 --></button>   
    <button class="ButDarkGray_Medium"  style=" width:100px" onclick="doAction('search'); return false;" ><%=CommonLang.get("HTITLE7") %><!-- 조회 --></button>   
  </div>  
  <div class="ScrollBox mt20" style="height:332px">
  	<script type="text/javascript">
		createIBSheet("mySheet", "100%", "100%");
  	</script>
  </div>
  <div class="ArraySub mt10 mb10" style="width:150px;">
        <div class="buttonLeft">
          <button class="But_ExcelDown40"  onclick="javascript:doAction('excelDown'); return false;"><%=CommonLang.get("HTITLE150") %><!-- 엑셀다운로드 --></button>
        </div>
	  </div>
  <div class="PagingCenter mt10" id="pageindex"></div>
</div><!-- wrapPopup 끝--> 
</form> 
</body>
</html>
