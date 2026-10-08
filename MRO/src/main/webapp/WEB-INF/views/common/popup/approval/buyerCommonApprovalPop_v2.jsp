<%--
**********************************************
* 메뉴 : 결재
* 화면 : 결재상신 팝업
* 기능 : 결재상신 팝업
* 프로그램 ID : BU0701004 
* 담당자 : 최찬규  
* 착수일 : 2026-03-26
**********************************************
--%> 
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!doctype html>
<html>
<head>
<%@ include file="../../include/head_v2.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _list = (List<Map<String,String>>) request.getAttribute("approvalLine"); // 조회된결과
List<Map<String,String>> _cateapprlist = (List<Map<String,String>>) request.getAttribute("cateapprovalLine"); // 카테고리담당자
List<Map<String,String>> _buyerapprlist = (List<Map<String,String>>) request.getAttribute("buyerapprovalLine"); // 카테고리담당자
@SuppressWarnings (value="unchecked")
Map<String, Object> ht = (Map<String, Object>) request.getAttribute("data"); // 조회된결과   
String biz_url = CommonUtil.nvl((String)ht.get("biz_url"),"");  // 공통테이블이서 가지고온 각업무별 url
String action_base = CommonUtil.nvl((String)ht.get("action_base"),"");  // 공통테이블이서 가지고온 각업무별 action url
String biz_jsp = CommonUtil.nvl((String)ht.get("biz_jsp"),""); // 공통테이블이서 가지고온 각업무별 jsp 파일명
String curDate = CommonUtil.nvl((String)ht.get("curDate"),"");

String st_cont = CommonUtil.nvl((String)request.getAttribute("st_cont"),"");
		st_cont = st_cont.replaceAll("&lt;br&gt;", "\n");
String st_title = CommonUtil.nvl((String)request.getAttribute("st_title"),"");


String usernm = "";
String COMPANY = "";
String userType = "";
String userDepartment = "";
String userId = "";
if (_sessionInfo != null){ 
	usernm =  CommonUtil.nvl((String)_sessionInfo.getUserNameLoc()); 
	COMPANY =  CommonUtil.nvl((String)_sessionInfo.getComCode()); 
	userType    = CommonUtil.nvl((String)_sessionInfo.getUserType());
	userDepartment    = CommonUtil.nvl((String)_sessionInfo.getDepartment());
	userId = CommonUtil.nvl((String)_sessionInfo.getUserId());
	
} 
//p060000059 결재지정/변경 버튼 비활성화 SLOGIC
boolean p060000059= CommonUtil.getSpecialCheckReturn(COMPANY,"P06-0000059");

String DOC_TYPE = CommonUtil.nvl((String) request.getParameter("DOC_TYPE"),"");    
String popTitle = "";
if(DOC_TYPE.equals("PX") || DOC_TYPE.equals("PR")){
	popTitle = CommonLang.get("HTITLE835"); //주문정보
}else if(DOC_TYPE.equals("NG") || DOC_TYPE.equals("NS")){
	popTitle = CommonLang.get("HTITLE1256"); //견적정보
}
String DOCU_NO = CommonUtil.nvl((String) request.getParameter("DOCU_NO"),"");    
String BIZ_DOCU_NO = CommonUtil.nvl((String) request.getParameter("BIZ_DOCU_NO"),"");    
String requesTemptYn = CommonUtil.nvl((String) request.getParameter("requesTemptYn"),"");    
//COMPANY = CommonUtil.nvl((String) request.getParameter("st_buyer"),(String)_sessionInfo.getComCode());
String PARAM1 = CommonUtil.nvl((String) request.getParameter("PARAM1"),"");    
String PARAM2 = CommonUtil.nvl((String) request.getParameter("PARAM2"),"");    
String PARAM3 = CommonUtil.nvl((String) request.getParameter("PARAM3"),"");    
String gubun = CommonUtil.nvl((String) request.getParameter("gubun"),"N");    

String tab_id = CommonUtil.nvl((String) request.getParameter("tab_id"),"");    

// 일진전기 주문시 결재창에 금액 및 결재정보 보여줌
String tot_price = CommonUtil.nvl((String) request.getParameter("nu_tot_price"),""); 
String tot_cnt = CommonUtil.nvl((String) request.getParameter("nu_tot_cnt"),"");

String category_no = CommonUtil.nvl((String) request.getParameter("st_category_no"),"");     
//KRKORE0001 운영사 결재선 체크
String apprId = CommonUtil.getCode3RoleReturn("APPR", userDepartment, COMPANY, "CODE2");
//첨부파일 필수 여부
String pass_attach_yn = CommonUtil.nvl((String) request.getParameter("pass_attach_yn"),"");
StringBuffer sb = new StringBuffer(); 
if ("NG".equals(DOC_TYPE) || "NS".equals(DOC_TYPE)){
	//NG	견적의뢰
	//NS	소상합의
/* 불필요 로직 제거.현
	sb.append("신상품 등록을 신청하고자 하오니, 결재 바랍니다.	\n");
	sb.append("1.  품목유형 : 	\n");
	sb.append("2.  품  명 : 	\n");
	sb.append("3.  규  격 : 	\n");
	sb.append("4.  제조사 : 	\n");
	sb.append("5.  신상품 등록 사유 : 	\n");
	sb.append("6.  기  타 :	\n");
*/
	
} else if ("SO".equals(DOC_TYPE) && !"nego".equals(gubun)){
//SO	신규소싱
	sb.append("① 개선방안 : 	\n");        
	sb.append("② 개선일정 : 	\n");        
	sb.append("③ 발생사유 : 	\n");        
	sb.append("④ 단기개선 가능여부 표기 : 	\n");        

}

if ("".equals(st_cont)){
	st_cont = sb.toString();
}

String cateappr_id = "";
String cateappr_name = "";
if ("".equals(category_no) || _cateapprlist == null || _cateapprlist.size() == 0){ 
}else{
	for (int j=0; j<_cateapprlist.size(); j++) {
		Map<String,String> rowData1 = _cateapprlist.get(j);
		if(j > 0){
			cateappr_id += ',';
			cateappr_name += ',';			
		}
		cateappr_id += CommonUtil.nvl(rowData1.get("CATEAPPR_ID"));
		cateappr_name += CommonUtil.nvl(rowData1.get("CATEAPPR_NAME"));
	}
}
//SLOGIC-BEGIN(P11-0000007)
String _approvalUrl = "/common/popup/approval/approvalHumanEditPop.do";	// 결재경로 팝업 원 소스
Map<String, String> p110000007_map	= CommonUtil.getSpecialCheckReturnMap(COMPANY,"P11-0000007");
if (p110000007_map != null) {
	_approvalUrl = p110000007_map.get("COL01_DATA");
}
//SLOGIC-END

//p060000135 결재선 내 필수 포함 부서 /사용자 체크 여부   
Map<String, String> p060000135_map = CommonUtil.getSpecialCheckReturnMap(COMPANY,"P06-0000135");
String _alertMsg = "";
String buyerappr_id = "";
String buyerappr_name = "";
String buyerappr_type = "";
Boolean p060000135 = false;
if (p060000135_map != null) {
	p060000135 = true;
	_alertMsg = p060000135_map.get("COL01_DATA");
	buyerappr_type = p060000135_map.get("COL02_DATA"); 
	if (_buyerapprlist != null && _buyerapprlist.size() != 0){ 
		for (int j = 0; j < _buyerapprlist.size(); j++) {
			Map<String,String> rowData1 = _buyerapprlist.get(j);
			if(j > 0){
				buyerappr_id += ',';
				buyerappr_name += ',';			
			}
			buyerappr_id += CommonUtil.nvl(rowData1.get("BUYERAPPR_ID"));
			buyerappr_name += CommonUtil.nvl(rowData1.get("BUYERAPPR_NAME"));
		}
	}
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
var pagingMode = "N";
var popupSel = "";
var apprLineValid = true;

var gDOCU_NO = "";
function kep_onload_view(){ 
 
	var initsheet = {};
	initsheet.HeaderMode={Sort:0,HeaderCheck:0};
	initsheet.Cfg = {MergeSheet:msHeaderOnly,     HeaderRowHeight: 50, DataRowHeight: 30,    Alternate : 0,UseNoDataRow:1};
	initsheet.Cols = [
			 { Align:"Center",	SaveName:"sStatus",				Header:"<%=CommonLang.get("HTITLE255")%>",				Type:"Status",		Width:60,	Edit:false,	EditLen:0,		Hidden:true}/*상태*/
			 ,{ Align:"Center",	SaveName:"SELECTED",			Header:"<%=CommonLang.get("HTITLE178")%>",					Type:"CheckBox",	Width:60,	Edit:true,	EditLen:100,	Hidden:true}/*선택*/
			 ,{ Align:"Center",	SaveName:"ORDER_SEQ",			Header:"<%=CommonLang.get("HTITLE1064")%>",				Type:"Text",		Width:60,	Edit:false,	EditLen:100,	Hidden:false} /*순서*/
			 ,{ Align:"Center",	SaveName:"GUBUN_TEXT",			Header:"<%=CommonLang.get("HTITLE314")%>",				Type:"Text",		Width:90,	Edit:false,	EditLen:100,	Hidden:false}/*구분*/
			,{ Align:"Center",	SaveName:"GUBUN",			Header:"<%=CommonLang.get("HTITLE314")%>",				Type:"Combo",		Width:90,	Edit:false,	EditLen:100,	Hidden:true, ComboText:"<%=CommonLang.get("HTITLE310")%>|<%=CommonLang.get("HTITLE792")%>|<%=CommonLang.get("HTITLE311")%>",ComboCode:"C|H|R"}/*결재|합의|참조*/ /*구분*/
			,{ Align:"Center",	SaveName:"PASS_TP",		Header:"<%=CommonLang.get("HTITLE314")%>",				Type:"Combo",		Width:90,	Edit:false,	EditLen:100,	Hidden:true, ComboText:"<%=CommonLang.get("HTITLE310")%>|<%=CommonLang.get("HTITLE792")%>|<%=CommonLang.get("HTITLE311")%>",ComboCode:"1|3|2"}/*결재|합의|참조*/ /*구분*/
			,{ Align:"Center",	SaveName:"APPR_NAME",			Header:"<%=CommonLang.get("HTITLE325")%>",				Type:"Text",		Width:190,	Edit:false,	EditLen:100,	Hidden:false} /*이름*/
			,{ Align:"Center",	SaveName:"POSITION",			Header:"<%=CommonLang.get("HTITLE476")%>",				Type:"Text",		Width:90,	Edit:false,	EditLen:100,	Hidden:false} /*직급*/
			,{ Align:"Center",	SaveName:"DEPT",				Header:"<%=CommonLang.get("HTITLE329")%>",				Type:"Text",		Width:150,	Edit:false,	EditLen:100,	Hidden:false}/*부서*/

			,{ Align:"Center",	SaveName:"PASS_KN",				Header:"PASS_KN",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"APPR_ID",				Header:"APPR_ID",				Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}
			,{ Align:"Center",	SaveName:"APPR_USER_ID",		Header:"APPR_USER_ID",			Type:"Text",		Width:80,	Edit:false,	EditLen:100,	Hidden:true}

	];
	
	IBS_InitSheet(mySheet, initsheet, pagingMode);
	mySheet.SetHighlightAfterSort(2);
	
	mySheet.SetHeaderBackColor("#f2f7ff");
	mySheet.SetTheme("DB", "DeepBlue");
	
	goAppPathChange(); // 기본결재선 바로 지정
}

function goAppPathChange(){ 	   
	kepSearch(document.buyerCommonApprovalPop, mySheet, "/common/approval/getMultiPassLine_v2.do" ,pagingMode);
// 	kepAjaxPopFormCall("/common/approval/getMultiPassLine_v2.do","buyerCommonApprovalPop","goAppPathChange","Y"); 
}

function mySheet_OnSearchEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if (msg != "") {
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
	}
	
	var to = "";
	var cc = "";
	var content = "";
	apprLineValid = true;
	for(var i = 1; i<=mySheet.RowCount(); i++){
		var position = mySheet.GetCellValue(i,"POSITION");
		var dept = mySheet.GetCellValue(i,"DEPT");
		var appr_name = mySheet.GetCellValue(i,"APPR_NAME");
		var id = mySheet.GetCellValue(i,"APPR_USER_ID");
		if(!id){
			id = mySheet.GetCellValue(i,"APPR_ID");
		}

		if(!id){
			apprLineValid = false;
			document.forms.buyerCommonApprovalPop.to.value = "";
			document.forms.buyerCommonApprovalPop.cc.value = "";
			document.forms.approvalPop.toContent.value = "";
			var text = appr_name + "<%=CommonLang.msg("MSG996")%>";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}

		if(mySheet.GetCellValue(i,"GUBUN") == "C"){
			to+=id+",";
			content += "to" + "@" + id + "@" + appr_name + "@" + position + "@" + dept + "@" + "$";
		}else if(mySheet.GetCellValue(i,"GUBUN") == "H"){
			to+="^"+id+",";
			content += "ag" + "@" + id + "@" + appr_name + "@" + position + "@" + dept + "@" + "$";
		}else{
			cc+=id+",";
			content += "cc" + "@" + id + "@" + appr_name + "@" + position + "@" + dept + "@" + "$";
		}
	}

	document.forms.buyerCommonApprovalPop.to.value = to;
	document.forms.buyerCommonApprovalPop.cc.value = cc;
	document.forms.approvalPop.toContent.value = content;
}

function approvalLine(){
	popupSel = "approvalLine";
	
	var rowList = new Array();
	var rowJson = "";
	var gridJsonList = "";
	
	for(var i = 1; i<=mySheet.RowCount(); i++){
		var param = {
				"ORDER_SEQ" : mySheet.GetCellValue(i,"ORDER_SEQ")
				,"GUBUN_TEXT" : mySheet.GetCellValue(i,"GUBUN_TEXT")
				,"GUBUN" : mySheet.GetCellValue(i,"GUBUN")
				,"PASS_TP" : mySheet.GetCellValue(i,"PASS_TP")
				,"APPR_NAME" : mySheet.GetCellValue(i,"APPR_NAME")
				,"POSITION" : mySheet.GetCellValue(i,"POSITION")
				,"DEPT" : mySheet.GetCellValue(i,"DEPT")
				,"PASS_KN" : mySheet.GetCellValue(i,"PASS_KN")
				,"APPR_ID" : mySheet.GetCellValue(i,"APPR_ID")
				,"APPR_USER_ID" : mySheet.GetCellValue(i,"APPR_USER_ID")
			};
		rowJson = JSON.stringify(param);
		rowList.push(rowJson);
	}

	gridJsonList =  "[" + rowList.toString() + "]";
	$("#info").val(gridJsonList);
	$("#APP_PATH_2").val($("#APP_PATH option:selected").val());
	$("#SUBJECT_2").val($("#APP_PATH option:selected").text());
	openSearchPopupPost('<%=_approvalUrl%>',"approvalPop","approvalPop","width=1230,height=680,resizable=no,scrollbars=no, top=0, left=0");
// 	var option = "?toContent="+ $("#toContent").val();
// 	option = option + "&PASS_LINE_FLAG=Y"; //나의 결재경로 불러오도록
// 	option = option + "&APP_PATH="+$("#APP_PATH option:selected").val(); //결재경로
// 	option = option + "&SUBJECT="+$("#APP_PATH option:selected").text(); //결재경로이름
<%-- 	openSearchPopup('<%=_approvalUrl%>',option, "1200,670,no");	// 특수로직(P11-0000007) 추가. 고객사별 결재경로 선택 팝업을 변경할 수 있다.  --%>
}
function addMyPassLine(appPath,appSubject){ //결재경로관리 팝업에서 받아온 결재라인 리스트에 추가
	var htmlStr = "";
	htmlStr += '<option value="'+appPath+'">'+appSubject+'</option>';
	$("#APP_PATH").append(htmlStr);
}

function  attach_popup(){
	popupSel = "attach";
	
	var type = "<%=DOC_TYPE%>";
	var viewType = "C";
	var img_key = $("#st_image_key").val(); 	
	
	var src = '/common/fileUploadPop_v2.do?DOC_NO='+img_key+'&viewType='+viewType+'&TYPE='+type;
	openLayerPop(src,"600px","510px");
	
	
	   	 
// 	kepFileUploadOpenPopup(img_key,type,viewType);
}

function setPopupReturn(value1,value2){
	if(popupSel == "attach"){
		$("#st_image_key").val(value1);
		if(value2 >0){
			$("#st_file_upload_but").attr("class","ButQuaternary_Small");
		    $("#st_file_upload_cnt").html(value2);
		}else{
			$("#st_file_upload_but").attr("class","ButOutline_Small");
		    $("#st_file_upload_cnt").html("");
		}
		
	}else if(popupSel = "approvalLine"){
		mySheet.RemoveAll();
		
		var arr = value1;
		mySheet.RenderSheet(0);
		for(var i = 0; i<arr.length; i++){
			
			var newIndex = 0;
			newIndex = mySheet.DataInsert(-1);
			mySheet.SetCellValue(newIndex, "ORDER_SEQ",arr[i].ORDER_SEQ);
			mySheet.SetCellValue(newIndex, "GUBUN",arr[i].GUBUN);
			mySheet.SetCellValue(newIndex, "PASS_TP",arr[i].PASS_TP);
			mySheet.SetCellValue(newIndex, "APPR_NAME",arr[i].APPR_NAME);
			mySheet.SetCellValue(newIndex, "POSITION",arr[i].POSITION);
			mySheet.SetCellValue(newIndex, "DEPT",arr[i].DEPT);
			mySheet.SetCellValue(newIndex, "PASS_KN",arr[i].PASS_KN);
			mySheet.SetCellValue(newIndex, "APPR_ID",arr[i].APPR_ID);
			mySheet.SetCellValue(newIndex, "APPR_USER_ID", arr[i].APPR_USER_ID ? arr[i].APPR_USER_ID : "");
			var gubun_text = "";
			if(arr[i].GUBUN == 'C'){
				gubun_text = "<%=CommonLang.get("HTITLE310")%>"; //결재
			}else if(arr[i].GUBUN == 'H'){
				gubun_text = "<%=CommonLang.get("HTITLE792")%>"; //합의
			}else if(arr[i].GUBUN == 'R'){
				gubun_text = "<%=CommonLang.get("HTITLE311")%>"; //참조
			}
			mySheet.SetCellValue(newIndex, "GUBUN_TEXT",gubun_text);
		}
		
		mySheet.RenderSheet(1);
		$("#APP_PATH").val("");
		
		var to = "";
		var cc = "";
		var content = "";
		apprLineValid = true;
		for(var i = 1; i<=mySheet.RowCount(); i++){
			var position = mySheet.GetCellValue(i,"POSITION");
			var dept = mySheet.GetCellValue(i,"DEPT");
			var appr_name = mySheet.GetCellValue(i,"APPR_NAME");
			var id = mySheet.GetCellValue(i,"APPR_USER_ID");
			if(!id){
				id = mySheet.GetCellValue(i,"APPR_ID");
			}

			if(!id){
				apprLineValid = false;
				document.forms.buyerCommonApprovalPop.to.value = "";
				document.forms.buyerCommonApprovalPop.cc.value = "";
				document.forms.approvalPop.toContent.value = "";
				var text = appr_name + "<%=CommonLang.msg("MSG996")%>";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}

			if(mySheet.GetCellValue(i,"GUBUN") == "C"){
				to+=id+",";
				content += "to" + "@" + id + "@" + appr_name + "@" + position + "@" + dept + "@" + "$";
			}else if(mySheet.GetCellValue(i,"GUBUN") == "H"){
				to+="^"+id+",";
				content += "ag" + "@" + id + "@" + appr_name + "@" + position + "@" + dept + "@" + "$";
			}else{
				cc+=id+",";
				content += "cc" + "@" + id + "@" + appr_name + "@" + position + "@" + dept + "@" + "$";
			}	
		}
		
		document.forms.buyerCommonApprovalPop.to.value = to;
		document.forms.buyerCommonApprovalPop.cc.value = cc;
		document.forms.approvalPop.toContent.value = content;
		
	}
   	
   	
   	//alert(	$("#st_image_key").val());
}   

function nosubmit() { 
}

function captureReturnKey(e) {   
	if(e.keyCode==13 && e.srcElement.type != 'textarea')   
	return false;   
}   

	
</script> 
<body onload="kep_onload_view()">
<%
/*
	SELECT              
		    A.*
		    , TO_CHAR(SYSDATE,'YYYY/MM/DD HH:MM')   as CURDATE
			FROM ICOMCOD1     A
			WHERE 1=1   
		 	AND A.TYPE = 'APPR'
		 	*/%>
<form name="buyerCommonApprovalPop" id="buyerCommonApprovalPop" method="post"   onkeydown="return captureReturnKey(event)">  
<input type="hidden" name="s_SAVENAME" />
<input type=hidden name="COMPANY" value="<%=COMPANY%>">
<input type=hidden name="DOC_TYPE" value="<%=DOC_TYPE%>">  <!--  상신일경우에는 수정 필요 -->
<input type=hidden name="EXTIF_TP" value="<%=DOC_TYPE%>">  <!--  상신일경우에는 수정 필요 --> 
<input type=hidden name="to" id="to" value="">
<input type=hidden name="cc" id="cc"  value="">
<input type=hidden name="ag" id="ag"  value=""> 
<input type=hidden name="st_image_key" id="st_image_key"  value=""> 
<input type=hidden name="toContent" id="toContent"  value=""> 
<input type=hidden name="DOCU_KN" value="1">  <!--  상신일경우에는 수정 필요 문서종류(1:결재문서) -->
<input type=hidden name="requesTemptYn" value="<%=requesTemptYn%>"> <!--  Y 임시테이블이용 N 임시테이블미이용 -->
<input type=hidden name="BIZ_DOCU_NO" value="<%=BIZ_DOCU_NO%>"> <!--  업무키를 사용한다 -->
<input type=hidden name="PARAM1" value="<%=PARAM1%>">
<input type=hidden name="PARAM2" value="<%=PARAM2%>">
<input type=hidden name="PARAM3" value="<%=PARAM3%>">
<input type=hidden name="st_category_no" value="<%=category_no%>">

	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div class="wrapPopup"  >
  <div class="PopupTit"><%=CommonLang.get("HTITLE702") %><!-- 결재상신 --><span><a href="javascript:self.close();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="PopupTitSub"><%=popTitle %></div>
  <table class="PopTableThL2TdL"  width="730px">
    <colgroup>
      <col width="100px" />
      <col width="240px" />
      <col width="125px" />
      <col width="265px" />
    </colgroup>
    <%if(DOC_TYPE.equals("PX") || DOC_TYPE.equals("PR")){%>
	<tr>
      <th><%=CommonLang.get("HTITLE1058") %><!-- 주문품목수 --></th>
      <td><%=CommonUtil.formatNumber(tot_cnt,true,0,3)%></td>
      <th><%=CommonLang.get("HTITLE1059") %><!-- 주문금액 --></th>
      <td><span class="font700"><%=CommonUtil.formatNumber(tot_price,true,0,3)%></span> <%=CommonLang.get("HTITLE660") %><!-- 원 --></td>
      <input type="hidden" name="nu_tot_price" value="<%=tot_price%>">
    </tr>
	<%}else if(DOC_TYPE.equals("NG") || DOC_TYPE.equals("NS")){%>
	<tr>
      <th><%=CommonLang.get("HTITLE1060") %><!-- 견적품목수 --></th>
      <td><%=CommonUtil.formatNumber(tot_cnt,true,0,3)%></td>
      <th><%=CommonLang.get("HTITLE978") %><!-- 견적금액 --></th>
      <td><span class="font700"><%=CommonUtil.formatNumber(tot_price,true,0,3)%></span> <%=CommonLang.get("HTITLE660") %><!-- 원 --></td>
      <input type="hidden" name="nu_tot_price" value="<%=tot_price%>">
    </tr>
	<%}%>
    
  </table>
  <div class="PopupTitSub"><%=CommonLang.get("HTITLE1215")%><!--결재정보--></div>
  <table class="PopTableThL1TdL" width="730px">
    <colgroup>
      <col width="100px" />
      <col width="630px" />
    </colgroup>  
    <tr>
      <th><%=CommonLang.get("HTITLE1067") %><!-- 결재경로 --></th>
      <td>
        <select name="APP_PATH" id="APP_PATH" onChange="goAppPathChange()" class="Select"  >
        <option value="">-------<%=CommonLang.get("HTITLE1216")%><!--결재선 선택-->-------</option>
          <%
if (_list == null || _list.size() == 0){ 
}else{
	for (int j=0; j<_list.size(); j++) {
		Map<String,String> rowData = _list.get(j);
%> 
<option value="<%=CommonUtil.nvl(rowData.get("APP_PATH"))%>"  <% if ("Y".equals(rowData.get("DEFAULT_FLAG"))) { %> selected <%} %>><%=CommonUtil.nvl(rowData.get("SUBJECT"))%></option> 
<% }
}%>
        </select>
        <%if(p060000059==true&&userType.equals("U")){%>
		<%}else{ %>
        <button class="ButOutlineBlue_Small" style="vertical-align:middle; float:right" onclick="javascript:approvalLine(); return false;"><%=CommonLang.get("HTITLE1062") %><!-- 결재경로 관리 --></button>
		<%} %>
		<div class="ApprovalPop mt05" style="width:605px; height:150px;">
	      	<script type="text/javascript">
	          	createIBSheet("mySheet", "", "100%");
	        </script>    
    	</div>       
      </td>
    </tr> 
  </table>
  <div class="PopupTitSub"><%=CommonLang.get("HTITLE1176")%><!--결재작성--></div>               
  <table class="PopTableThL1TdL" width="730px">
    <colgroup>
      <col width="100px" />
      <col width="265px" />
      <col width="100px" />
      <col width="265px" />
    </colgroup>
    <tr>
      <th><%=CommonLang.get("HTITLE1177")%><!--상신일시--></th>
      <td><%=curDate%></td>
      <th><%=CommonLang.get("HTITLE119")%><!-- 첨부파일 --></th>
      <td>
      <button name="st_file_upload_but" id="st_file_upload_but" class="ButOutline_Small" onclick="javascript:attach_popup(); return false;" style="width:150px;" ><%=CommonLang.get("HTITLE177") %><!-- 파일첨부 --> <span id="st_file_upload_cnt"></span></button>
      </td>
    </tr> 
    <tr>
      <th><%=CommonLang.get("HTITLE304")%><!-- 제목 --></th>
      <td colspan="3"><input class="input30" style="width:584px;" name="DOCU_TITLE" id="DOCU_TITLE" value="<%=st_title%>" placeholder="<%=CommonLang.msg("MSG765")%>" type="text" onkeydown="if(event.keyCode == 13) JavaScript:nosubmit();" /></td><!-- 결재제목을 입력해주세요. -->
    </tr>
    <tr>
      <th><%=CommonLang.get("HTITLE441")%><!-- 내용 --></th>
      <td colspan="3">
        <div class="TextField" id="limitedArea" >
         <textarea id="DOCU_CONT" name="DOCU_CONT" style="width:95%; height:20px;" maxlength="1000" value="<%=st_cont%>" placeholder="<%=CommonLang.msg("MSG766")%>" onkeyup="fnCheckInputByte(this, 1000);" onchange="fnCheckInputByte(this, 1000);"></textarea><!-- 내용을 입력해주세요. -->
          <div class="meta" aria-live="polite"> <span id="count">0</span>/1000 </div>
        </div>
		<script>
          (function () {
            const wrap = document.getElementById('limitedArea');
            const ta   = document.getElementById('DOCU_CONT');
            const cnt  = document.getElementById('count');
            const MAX  = parseInt(ta.getAttribute('maxlength'), 10);
            function update() {
              const len = ta.value.length;
              cnt.textContent = len;
            }
            // 초기 상태 반영 및 입력 시 업데이트
            update();
            ta.addEventListener('input', update);
          })();
		</script>
	  </td>
    </tr>
  </table>
  
     
    <div class="PopupListBtnBox_Center mt30">
      <button class="ButQuaternary_large" onclick="javascript:self.close(); return false;"><%=CommonLang.get("HTITLE229") %><!-- 취소 --></button>
      <button class="ButPrimary_large" onclick="javascript:approvalProcess('request'); return false;"><%=CommonLang.get("HTITLE702") %><!-- 결재상신 --></button>
    </div>   
         
 
 
</div><!-- wrapPopup 끝-->        
</form>

<form name="approvalPop" id="approvalPop" method="post">  
<input type=hidden name="info"  id="info" value=""> 
<input type=hidden name="PASS_LINE_FLAG"  id="PASS_LINE_FLAG" value="Y"> 
<input type=hidden name="APP_PATH"  id="APP_PATH_2" value=""> 
<input type=hidden name="SUBJECT"  id="SUBJECT_2" value=""> 
<input type=hidden name="toContent"  id="toContent" value="">
</form> 
</body>
<script type="text/javascript">

/**
 * FORM 을 넘기는 임시용
 * FORM 전체를 넘길는 submit 활용
 */
function approvalProcess(pMethod) {

	var to = document.forms.buyerCommonApprovalPop.to.value;
	var url = "";

	if(!apprLineValid){
		var text = "<%=CommonLang.msg("MSG996")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}

	var cateappr_id = "<%=cateappr_id%>";
	var cateappr_name = "<%=cateappr_name%>";
	var id_param = cateappr_id.split(",");
	var tmp_id_param = "";
	var name_param = cateappr_name.split(",");
	var doc_type = document.forms.buyerCommonApprovalPop.DOC_TYPE.value;
	var chk_to = to.split(",");
	//결재리스트에 카테고리결재담당자 포함하는지 체크
	for(j = 0; j < id_param.length; j++){
		tmp_id_param = id_param[j];
		if(to.indexOf(tmp_id_param) == -1){
// 			alert("결재선에 카테고리결재담당자 ["+name_param[j]+"("+id_param[j]+")"+"]를 필수로 지정해야 합니다.");
			var text = "<%=CommonLang.msg("MSG760")%>" + "["+name_param[j]+"("+id_param[j]+")"+"]";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
	}

	
	var st_company = document.forms.buyerCommonApprovalPop.COMPANY.value;
	var st_process_flag = "N";
	var apprId = "<%=apprId%>";
	var st_userId = "<%=userId%>";
	if(st_company == "KRKORE0001"){
		if(apprId ==""){
// 			alert("해당팀 체크 할 결재자정보가 없습니다.");
			var text = "<%=CommonLang.msg("MSG761")%>";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;			
		}
		if(apprId == "NO_APPR"){
			st_process_flag  = "Y";
		}else{
			for(var z=0; z<chk_to.length; z++){
				//각부장 결재선 체크
				if(chk_to[z] ==apprId){
					st_process_flag = "Y";
				}else if(st_userId == "KEP2129068"){
					if(chk_to[z] == "KEP2119072"){
						st_process_flag = "Y";	
					}
				}
			}			
		}
	
		if(st_process_flag == "N"){
			//사업팀장 예외처리.
			if(st_userId != "KEP200027"){
// 					alert("품의 상신시 각 부서 팀장님 결재가 필요합니다.");
					var text = "<%=CommonLang.msg("MSG762")%>";
					openLayerPopText2(text,but1text,but1func,but1width);
					return;				
			}
			
		}
	}
	
	if (pMethod == "request"){
		if (mySheet.RowCount() == 0){
// 			alert("결재자/참조자 입력하세요."); 
			var text = "<%=CommonLang.msg("MSG756")%>";
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		} 			
		if (kepIsEmpty("DOCU_TITLE")==true){
// 			alert("결재제목 입력하세요.");
			var text = "<%=CommonLang.msg("MSG757")%>";
			openLayerPopText2(text,but1text,but1func,but1width);
			$("#DOCU_TITLE").focus();
			return;
		} 				
		//첨부파일 필수여부 체크
		var pass_attach_yn = "<%=pass_attach_yn%>";
		if(pass_attach_yn =="Y"){
			if($("#st_image_key").val() ==""){
// 				alert("첨부파일이 필수 결재건 입니다\n파일첨부 후 결재상신 바랍니다.");
				var text = "<%=CommonLang.msg("MSG758")%>";
				openLayerPopText2(text,but1text,but1func,but1width);
				return;
			}
		}
		
		// 결재 또는 합의에 부서 또는 사용자가 필수 포함되어있는지 확인
		if(<%=p060000135%>){
			var doc_type = document.forms.buyerCommonApprovalPop.DOC_TYPE.value;
			if("<%=buyerappr_type%>" == "TYPE1"){ // 솔브레인 그룹사 (구매발주 시) 
				if(doc_type=="PX"){
					var buyerappr_id = "<%=buyerappr_id%>";
					var buyerappr_name = "<%=buyerappr_name%>";
					var id_param = buyerappr_id.split(",");
	
					var to = document.forms.buyerCommonApprovalPop.to.value;
					var cc = document.forms.buyerCommonApprovalPop.cc.value;
					var chk_to = to.split(",");
					var chk_cc = cc.split(",");
	
					var chk_flag = '0';
					for(j = 0; j < id_param.length; j++){
						if(to.indexOf(id_param[j]) >= 0 && cc.indexOf(id_param[j]) < 0){
							chk_flag= '1';
							break;
						}
					}
					
					if(chk_flag == '0'){
<%-- 						alert("<%=_alertMsg%>"); --%>
						var text = "<%=_alertMsg%>";
						openLayerPopText2(text,but1text,but1func,but1width);
						return;
					}
				}
			}
			
		}
		
		url = "<%=action_base%>Request.do";
		//결재상신 진행하시겠습니까?
		var text = "<%=CommonLang.msg("MSG763")%>";
		var but1textC = "<%=CommonLang.get("HTITLE516")%>"; //확인
		var but2textC = "<%=CommonLang.get("HTITLE229")%>"; //취소
		var but1funcC = "javascript:approvalRequest('"+url+"'); return false;";
		var but2funcC = "javascript:closePopText1(); return false;";
		var but1widthC = "100px";
		var but2widthC = "100px";
		openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
		
// 		if (confirm("결재상신 진행하시겠습니까?")==false) return; 
<%-- 		url = "<%=action_base%>Request.do"; --%>
	} 
	
	
	
}
function approvalRequest(url){
	closePopText1();
	
	kepAjaxFormCall(url,"buyerCommonApprovalPop","request"); 
}

window.onbeforeunload = function() {
	var type = "<%=DOC_TYPE%>";
	if (type == "OE"){
			opener.location.reload();	
			self.close();
	}
}; 

function popClose(){
	var type = "<%=DOC_TYPE%>";
	if (type == "OE"){
		opener.location.reload();
		self.close();
	} else {
		self.close();
	}
}

function addEvent(elem, event, fn) {
    if (elem.addEventListener) {
        elem.addEventListener(event, fn, true);
    } else {
        elem.attachEvent("on" + event, fn);
    }
}

//a click, form submet window.onbeforeunload 호출 초기화
var notUseBeforeunloadObj = document.getElementsByTagName("a");
for(var i=0; i < notUseBeforeunloadObj.length; i++){
	
	   addEvent(notUseBeforeunloadObj[i], "click", function(){window.onbeforeunload = "";});
	   addEvent(notUseBeforeunloadObj[i], "keypress", function(){window.onbeforeunload = "";});
  }
	  
  notUseBeforeunloadObj = document.getElementsByTagName("form");
  for(var i=0; i < notUseBeforeunloadObj.length; i++){
   addEvent(notUseBeforeunloadObj[i], "submit", function(){window.onbeforeunload = "";});
   
  }


function setPopupApprovalReturn(tmptmp1,tmptmp2,tmptmp3,tmptmp4,tmptmp5) {
	//alert(tmptmp1);
	//alert(tmptmp2);
	//alert(tmptmp3);
	$("#to").val(tmptmp1); // 결재
	$("#cc").val(tmptmp2); // 참조
	$("#ag").val(tmptmp5); // 합의
	$("#kto").html(tmptmp3); // 내용
	
	$("#toContent").val(tmptmp4); // 내용
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */
function kepAjaxSuccess(pMethod , response){

	if (pMethod == "request"){
// 		alert("결재상신이 성공적으로 이루어 졌습니다. ");
		var text = "<%=CommonLang.msg("MSG759")%>";
		openLayerPopText2(text,but1text,"javascript:thisPopClose('"+response.msg.DOCU_NO+"');return false;",but1width);
		
// 		var DOCU_NO = response.msg.DOCU_NO;
// 		opener.kepApprovalReturn("true",DOCU_NO);
	} 
	//opener.kepSearch("");
// 	self.close();
}
function thisPopClose(DOCU_NO){
	closePopText2();
	gDOCU_NO = DOCU_NO;
	
	for(var i = 1; i<= mySheet.RowCount(); i++){
		mySheet.SetCellValue(i,"SELECTED",true); //전체선택
	}
	
	kepSave(document.buyerCommonApprovalPop, mySheet, "/common/approval/updatePassLine_v3.do", "SELECTED");
}
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	
	if ( msg != "" ) {
		if ( code > 0 ) {
			var tab_id = "<%=tab_id%>";
			if(tab_id == ""){
				opener.kepApprovalReturn("true",gDOCU_NO);
			}else{
				opener.tabs[tab_id]["kepApprovalReturn"]("true",gDOCU_NO);
			}
			self.close();
		}else{
			var text = msg.msg;
			openLayerPopText2(text,but1text,but1func,but1width);
			return;
		}
	}
	
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {

	if (pMethod == "request"){
// 		결재상신이 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.
		var text = "<%=CommonLang.msg("MSG764")%>";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	} 
} 
</script>
</html>
