<%--
**********************************************
* 메뉴 : 
* 화면 : 결재선 선택 팝업
* 기능 : 
* 프로그램 ID : PG_90_C_900_50
* 담당자 :  고영일( 설계 : 공통 )
* 착수일 : 2014-06-28
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
<%
@SuppressWarnings (value="unchecked")
String com_code			= "";
String department		= "";
String user_name_loc	= "";
String user_id				= CommonUtil.nvl((String) request.getParameter("st_user_id"), "");
String cur_order_no		= CommonUtil.nvl((String) request.getAttribute("cur_order_no"), "");
String reg_type					= CommonUtil.nvl((String) request.getAttribute("type"), "");
if (_sessionInfo != null){
	com_code			= _sessionInfo.getComCode();
	department			= _sessionInfo.getDepartment();
	user_name_loc		= _sessionInfo.getUserNameLoc();
	if(user_id.equals("")){
		user_id				= _sessionInfo.getUserId();	
	}
}
//p060000096 본인 결재선 지정
boolean p060000096= CommonUtil.getSpecialCheckReturn(com_code,"P06-0000096");
%>
<style type="text/css">
.approval_btn_02 { display:inline-block; background:url(/resources/images/c_btn_02.gif) 0 0 no-repeat; width:50px; height:20px; text-align:center; padding-top:2px;}
.approval_btn_02 a {display:inline-block; width:50px; height:20px; font-size:11px; color:#ffffff; font-weight:normal;}
</style>
</head>
<script type="text/javascript">
// <!--
$(document).ready(function(){
	getApprovalInfoList();
});

function FixChecked(){
	$("input:radio[name=defaultRadio]:checked").parent().parent().find("input:checkbox[name=InCheck]").attr("checked", true);
}

/**
 * 결재선 목록 조회
 */
function getApprovalInfoList(){
	var pMethod = new Object();
	var userId = "<%=user_id%>";
	var pData = { st_user_id : userId };
	pMethod.gubun = "getApprovalInfoList";
	kepAjaxCall("/coco/getCommonCoCoApprovalAppointPop.do", pData,pMethod);
}

/**
 * TABLE의 ROW 데이타 생성
 */
function addrows() {
	var trCnt = $("#tblshow tbody tr").length;
	var str_addRow = "";
	str_addRow += "<tr>";
	str_addRow += "    <td><input class=\"noLine\" type=\"checkbox\" name=\"InCheck\" id=\"InCheck\" checked=\"checked\" value=\""+ ( trCnt + 1 ) +"\"></td>";
	str_addRow += "    <td>"+ ( trCnt + 1 ) +"</td>";
	str_addRow += "    <td><input type=\"radio\" name=\"defaultRadio\" id=\"defaultRadio\" class=\"input_type_text\" onClick=\"FixChecked();\" /></td>";
	str_addRow += "    <td><span class=\"btn_gray_02\"><a href=\"javascript:;\" onclick=\"javascript:goAppDetail(this,'','','','');\">결재자</a></span></td>";
	str_addRow += "    <td class=\"left\"><input type=\"text\" class=\"input_type_text\" style=\"width: 95%\" name=\"subject\" class=\"input_type_text\" value=\"\" /></td>";
	str_addRow += "    <td>&nbsp;</td>";
	str_addRow += "    <td>";
	str_addRow += "        <a href=\"#\" id=\"row_delete\"  onclick=\"kepRowRemove(this)\">행삭제</a>";
	str_addRow += "        <input type=\"hidden\" name=\"app_path\" value=\"\" />";
	str_addRow += "        <input type=\"hidden\" name=\"status\" value=\"C\">";
	str_addRow += "        <input type=\"hidden\" name=\"to_str\" value=\"\"><!-- 결재자리스트 -->";
	str_addRow += "        <input type=\"hidden\" name=\"cc_str\" value=\"\"><!-- 참조자리스트 -->";
	str_addRow += "        <input type=\"hidden\" name=\"ag_str\" value=\"\"><!-- 합의자리스트 -->";
	str_addRow += "        <input type=\"hidden\" name=\"defaultFlag\" value=\"N\"><!--디폴트결재선유무 Y/N-->";
	str_addRow += "        <input type=\"hidden\" name=\"oldDefaultRadio\" value=\"N\">";	
	str_addRow += "    </td>";
	str_addRow += "</tr>";
	
	$("#tblshow tbody").append(str_addRow);
}

/**
 * 로우 데이터를 삭제한다.
 */
function kepRowRemove(obj){
	var status = $(obj).parent().parent().find("input[name=status]").val(); 
	var oldDefaultRadio = $(obj).parent().parent().find("input[name=oldDefaultRadio]").val();
	
	if(oldDefaultRadio == "Y"){
		alert("디폴트결재선으로 지정된 건은 삭제할 수 없습니다. \n ☞디폴트결재선을 다른결재선으로 변경하시고, 삭제를 수행할 수 있습니다.");
		return;
	}
	
	if(status == "C"){
		$(obj).parent().parent().remove();
		return;
	}
	
	if(confirm("삭제 하시겠습니까？")){
		var pMethod = new Object();
		pMethod.gubun = "delApprovalInfo";
		pMethod.selObj = obj;
		
		var app_path = $(obj).parent().parent().find("input[name=app_path]").val();
		var userId = "<%=user_id%>";
		
		var pData = { app_path : app_path, st_user_id : userId};
		kepAjaxCall("/coco/delCommonCoCoApprovalInfo.do",pData,pMethod);
	}
}

/**
 * 저장
 */
function regAppPath(){
	if($("input:checkbox[name=InCheck]:checked").length <= 0){
		alert("선택된 내역이 없습니다.");
		return;
	}
	
	if($("input:radio[name=defaultRadio]:checked").length <= 0){
		alert("디폴트결재선을 선택하여 주십시오.");
		return;
	}
	
	var subjectObjs = $("input[name=subject]");
	for(var inx = 0 ; inx < subjectObjs.length; inx++ ){
		if(isEmpty($(subjectObjs[inx]).val())){
			alert("결재선제목을 입력하여 주십시오");
			$(subjectObjs[inx]).focus();
			return;
		}
	}
	
	if(confirm("저장 하시겠습니까？")){
		// 디폴더 결재선 설정
		$("input:hidden[name=defaultFlag]").val("N");
		$("input:radio[name=defaultRadio]:checked").parent().parent().find("input:hidden[name=defaultFlag]").val("Y");
		$("input:radio[name=defaultRadio]:checked").parent().parent().find("input:checkbox[name=InCheck]").attr("checked", true);
		
		var strAppPath = "";
		var strSubject = "";
		var strDefaultFlag = "";
		var chkCnt = 0;
		
		var inCheckObjs = $("input:checkbox[name=InCheck]");
		var appPathObjs = $("input:hidden[name=app_path]");
		var subjectObjs = $("input:text[name=subject]");
		var defaultFlagObjs = $("input:hidden[name=defaultFlag]");
		
		chkCnt = 0;
		for(var i = 0 ; i < appPathObjs.length; i++){
			if($(inCheckObjs[i]).is(":checked")){
				if(chkCnt++ > 0)	strAppPath += ",";
				strAppPath += $(appPathObjs[i]).val() + " ";
			}
		}
		chkCnt = 0;
		for(var i = 0 ; i < subjectObjs.length; i++){
			if($(inCheckObjs[i]).is(":checked")){
				if(chkCnt++ > 0) strSubject += ",";
				strSubject += $(subjectObjs[i]).val() + " ";
			}
		}
		chkCnt = 0;
		for(var i = 0 ; i < defaultFlagObjs.length; i++){
			if($(inCheckObjs[i]).is(":checked")){
				if(chkCnt++ > 0) strDefaultFlag += ",";
				strDefaultFlag += $(defaultFlagObjs[i]).val() + " ";
			}
		}
		var userId = "<%=user_id%>";
		var pMethod = new Object();
		pMethod.gubun = "insertApprovalInfo";
		var pData = { app_path : strAppPath, subject : strSubject, defaultFlag : strDefaultFlag, st_user_id : userId};
		kepAjaxCall("/coco/setCommonCoCoApprovalInfo.do",pData,pMethod);
	}
	
}

/**
 * 결재자상세 지정
 */
function goAppDetail(btnObj, p_app_path,to_list,cc_list){
	if(p_app_path == ''){
		alert("결재선을 먼저 등록하여 주십시오.");
		return;
	}
	
	var pMethod = new Object();
	pMethod.gubun = "getApproverInfoList";
	pMethod.app_path = p_app_path;
	pMethod.btnObj = btnObj;
	
	var pData = { to_list : to_list, cc_list : cc_list };
	kepAjaxCall("/coco/getApproverInfoList.do",pData,pMethod);
}

/**
 * 결재/참고자 검색 조회
 */
function setApproverQuery(){
	var app_path = $("#commonCoCoApproverSearchForm input:hidden[name=app_path]").val();
	if(isEmpty(app_path)){
		alert("결재자 버튼을 먼저 선택하고 결재자를 지정 하십시오.");
		return;
	}
	
	var pMethod = new Object();
	pMethod.gubun = "getApprovalMultiPathUserList";
	
	var key = $("select[name=key]").val();
	var qstr = $("input:text[name=qstr]").val();
	var userId = "<%=user_id%>";//사용자 ID
	var pData = { key : key, qstr : qstr, st_user_id : userId };
	kepAjaxCall("/coco/getApprovalMultiPathUserList.do",pData,pMethod);
}

/**
 * 결재/참고자 검색 조건 초기화
 */
function init_searchArea(){
	$("select[name=key] option:eq(0)").attr("selected", "selected");
	$("input:text[name=qstr]").val("");
}

/**
 * 결재/참고자 목록 초기화
 */
function init_searchApproverList(){
	$("#tblSearchApprover tbody tr").remove();
	var str_addRow = "";
	str_addRow += "<tr bgcolor=\"#FFFFFF\">";
	str_addRow += "    <td colspan=\"4\" align=\"center\" height = \"195\">";
	str_addRow += "        <span class=\"font1\">조회된 데이타가 없습니다.</span>";
	str_addRow += "    </td>";
	str_addRow += "</tr>";
	$("#tblSearchApprover tbody").append(str_addRow);
}
/**
 * 결재/참고자 목록 초기화
 */
function init_approverList(){
	$("#tblApprover tbody tr").remove();
	var str_addRow = "";
	str_addRow += "<tr bgcolor=\"#FFFFFF\">";
	str_addRow += "    <td colspan=\"4\" align=\"center\" height = \"195\">";
	str_addRow += "        <span class=\"font1\">결재자를 선택해 주십시요.</span>";
	str_addRow += "    </td>";
	str_addRow += "</tr>";
	$("#tblApprover tbody").append(str_addRow);
}

/**
 * 결재/참고자 목록에 추가
 */
function addMan(objnm){
	var app_path = $("#commonCoCoApproverSearchForm input:hidden[name=app_path]").val();
	if(isEmpty(app_path)){
		alert("결재자 버튼을 먼저 선택하고 결재자를 지정 하십시오.");
		return;
	}
	
	var chkObj = $("#tblSearchApprover").find("input:checkbox[name=InCheck]:checked");
	var chkCode = "";
	var retVal = '';
	
	if(chkObj.length <= 0){
		alert("선택하신 목록이 없습니다.");
        return ;
	}
	
	for(var inx = 0 ; inx < chkObj.length ; inx++){
		chkCode = $(chkObj[inx]).val();
		retVal = checkDup(chkCode);
		
		if ( retVal == 1 ) {
			//본인 결재선 지정 가능 특수로직
			var p060000096 ="<%=p060000096%>";
			if(p060000096 != "true"){
				alert("자신의 ID는 등록할 수 없습니다");
				return ;				
			}
		}else if (retVal == 2){
			alert("해당 ID가 이미 결재자에 등록되었습니다");
			return ;
		}else if (retVal == 3){
			alert("해당 ID가 이미 참조자에 등록되었습니다");
			return ;
		}else if (retVal == 4){
			alert("해당 ID가 이미 합의자에 등록되었습니다");
			return ;
		}
	}
	
	var regApproverObj = $("#tblApprover input:hidden[name=codeResult]");
	if(regApproverObj == null || regApproverObj.length <= 0){
		$("#tblApprover tbody tr").remove();
	}
	
	var str_addRow = "";
	for(var inx = 0 ; inx < chkObj.length ; inx++){
		chkCode = $(chkObj[inx]).val();
		$(chkObj[inx]).attr("checked", false);
		retVal = chkCode.split("@");
		
		var D_ROWNUM = "";
		var D_GUBUN = objnm == "to" ? "결재" : (objnm == "ag" ? "합의" : "참조");
		var D_USER_ID = retVal[0];
		var D_USER_NAME_LOC = retVal[1];
		var D_DEPARTMENT = retVal[3];
		var D_POSITION = retVal[2];
		var D_POSITION_NAME = retVal[4];
		var D_DEPARTMENT_NAME = retVal[5];
		
		var D_CODE_RESULT = D_ROWNUM+"@"+D_GUBUN+"@"+D_USER_NAME_LOC+"@"+D_POSITION+"@"+D_DEPARTMENT+"@"+D_USER_ID;
		
		str_addRow = "";
		str_addRow += "<tr>";
		str_addRow += "    <td>" + D_GUBUN + "</td>";
		str_addRow += "    <td>" + D_USER_NAME_LOC + "</td>";
		str_addRow += "    <td>" + D_POSITION_NAME + "</td>";
		str_addRow += "    <td>" + D_DEPARTMENT_NAME + "</td>";
		str_addRow += "    <td>";
		str_addRow += "        <a id=\"row_delete\" onclick=\"removeApproverRow(this);\" href=\"javascript:;\">행삭제</a>";
		str_addRow += "        <input type=\"hidden\" id=\"codeResult\" name=\"codeResult\" value=\"" + D_CODE_RESULT + "\" />";
		str_addRow += "    <td>";
		str_addRow += "</tr>";
		
		$("#tblApprover tbody").append(str_addRow);
	}
}

/**
 * 결재선 중복 오류 체크
 */
function checkDup(addval)
{
	var param = addval.split("@");
	if(param[0]== "<%=user_id%>" ){
		return 1;
	}

	var regApproverObj = $("#tblApprover input:hidden[name=codeResult]");
	var codeResult = "";
	
	for(var inx=0 ; inx < regApproverObj.length ; inx++ ){
		codeResult = $(regApproverObj[inx]).val();
		codeResultArry = codeResult.split("@");
		if(codeResultArry[5] == param[0] ){
			if(codeResultArry[1] == "결재"){
				return 2;
			}else if(codeResultArry[1] == "합의"){
				return 4;
			}else{
				return 3;
			}
		}
	}
	
	return 0;
}

/**
 * 결재/참고자 행 삭제
 */
function removeApproverRow(obj){
<%
	// 두산인프라코어(주) 일반사무 특정부서(E1030, E1050) 의 사용자는 결재선이 정해져 있으며 결재선 수정 및 삭제를 할수 없음.
	if(com_code.equals("KRDHIM0002") && (department.equals("E1030") || department.equals("E1050"))) {
%>
	alert("두산인프라코어(주) 일반사무 의 인사총무팀은 결재선을 수정 및 삭제를 할수 없습니다.");
	return;
<%
	}

	// 두산인프라코어(주) 일반사무 특정부서(E1030, E1050) 의 사용자는 결재선이 정해져 있으며 결재선 수정 및 삭제를 할수 없음.
	if(com_code.equals("KRDHIM0003") && (user_id.equals("1975311") || user_id.equals("140012") || user_id.equals("204918") || user_id.equals("110741H"))) {
%>
	alert("두산인프라코어(주) 총무 의 <%=user_name_loc%> 님은 결재선을 수정 및 삭제를 할수 없습니다.");
	return;
<%
	}
%>

	var param = $(obj).parent().find("input:hidden[name=codeResult]").val().split("@");
	var index = param[0];
    var gubun = param[1];
    var state = param[2] + "@" + param[3] + "@" + param[4] + "@" + param[5];
    
    if( gubun =="결재"){
        index++;
        if( index < "<%=cur_order_no%>" ){
            alert("이미 결재하신 분은 삭제하실 수 없습니다");
            return ;
        }
    }
    
    $(obj).parent().parent().remove();
    
    var regApproverObj = $("#tblApprover input:hidden[name=codeResult]");
	if(regApproverObj == null || regApproverObj.length <= 0){
		init_approverList();
	}
}

/**
 * 결재/참조자 등록
 */
function SelectMan(){
<%
	// 두산인프라코어(주) 일반사무 특정부서(E1030, E1050) 의 사용자는 결재선이 정해져 있으며 결재선 수정 및 삭제를 할수 없음.
	if(com_code.equals("KRDHIM0002") && (department.equals("E1030") || department.equals("E1050"))) {
%>
	alert("두산인프라코어(주) 일반사무 의 인사총무팀은 결재선을 수정 및 삭제를 할수 없습니다.");
	return;
<%
	}

	// 두산인프라코어(주) 일반사무 특정부서(E1030, E1050) 의 사용자는 결재선이 정해져 있으며 결재선 수정 및 삭제를 할수 없음.
	if(com_code.equals("KRDHIM0003") && (user_id.equals("1975311") || user_id.equals("140012") || user_id.equals("204918") || user_id.equals("110741H"))) {
%>
	alert("두산인프라코어(주) 총무 의 <%=user_name_loc%> 님은 결재선을 수정 및 삭제를 할수 없습니다.");
	return;
<%
	}
%>

	var app_path = $("#commonCoCoApproverSearchForm input:hidden[name=app_path]").val();
	if(isEmpty(app_path)){
		alert("결재자 버튼을 먼저 선택하고 결재자를 지정 하십시오.");
		return;
	}

	var reg_type = "<%=reg_type%>";
	
	if(reg_type !="APSE"){						// 	결재선(ICOMAPSE) 등록일 경우 결재자 혹은 참조자가 없어도 확인 버튼 선택가능
		var trApproverObj = $("#tblApprover tbody tr");
		if( trApproverObj <= 0){
			alert("결재자를 선택하세요");
			return ;
		}
	}
	
	if(confirm("저장 하시겠습니까？")){
		
		var to_str_name =  "";
		var db_to_name  =  "";
		var to_name     =  "";
		var to_str_id   =  "";
		var cc_str_name =  "";
		var db_cc_name  =  "";
		var cc_name     =  "";
		var cc_str_id   =  "";
		var ag_str_name =  "";
		var db_ag_name  =  "";
		var ag_name     =  "";
		var ag_str_id   =  "";

	    var rowDataObj = $("#tblApprover input:hidden[name=codeResult]");
	    var codeResult = "";
	    var paramArry = null;

	    // D_ROWNUM+"@"+D_GUBUN+"@"+D_USER_NAME_LOC+"@"+D_POSITION+"@"+D_DEPARTMENT+"@"+D_USER_ID;
	    
	    for(var inx = 0 ; inx < rowDataObj.length ; inx ++){
	    	codeResult = $(rowDataObj[inx]).val();
	    	paramArry = codeResult.split("@");
	    	
	    	// 결재자 설정
			if(paramArry[1] == "결재" || paramArry[1] == "합의"){
				if(paramArry[1] == "합의"){ // 합의일 때 
					to_str_id += "^" + paramArry[5] + ",";
					db_to_name += paramArry[5] + "@@" + paramArry[2] + "@@" + paramArry[0] + "@@" + "H" + "^||^";
					if(to_str_name.length == 0){
		    			to_str_name += paramArry[2];
					}else{
		    			to_str_name += " >> " +paramArry[2];
					}
				}else{ // 결재일 때
					to_str_id += paramArry[5] + ",";
					db_to_name += paramArry[5] + "@@" + paramArry[2] + "@@" + paramArry[0] + "@@" + "C" + "^||^";
					if(to_str_name.length == 0){
		    			to_str_name += paramArry[2];
					}else{
		    			to_str_name += " >> " +paramArry[2];
					}
				}
			}else if(paramArry[1] == "참조"){	// 참조자 설정
				cc_str_id += paramArry[5] + ",";
				db_cc_name += paramArry[5] + "@@" + paramArry[2] + "@@" + paramArry[0] + "@@" + "R" + "^||^";
				if(cc_str_name.length == 0){
					cc_str_name += paramArry[2];
				}else{
					cc_str_name += " >> " +paramArry[2];
				}
			}
		}

		to_name = "결재 : " +  to_str_name + "\n";
		ag_name = "합의 : " +  ag_str_name + "\n";
		cc_name = "참조 : " +  cc_str_name;
	    
		var pMethod = new Object();
		pMethod.gubun = "regApproverInfoList";
		pMethod.to_str_id = to_str_id;
		pMethod.cc_str_id = cc_str_id;
		pMethod.db_to_name = db_to_name;
		pMethod.db_cc_name = db_cc_name;
		pMethod.to_name = to_name;
		pMethod.cc_name = cc_name;
		var userId = "<%=user_id%>";
		var pData = { app_path : app_path, to_str_id : to_str_id, cc_str_id : cc_str_id, st_user_id : userId};
		kepAjaxCall("/coco/regApproverInfoList.do",pData,pMethod);
	}


}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */
function kepAjaxSuccess(pMethod , response){
	var gubun = pMethod.gubun;
	
	if ( gubun == "getApprovalInfoList" ) {
		$("#commonCoCoApproverSearchForm input:hidden[name=app_path]").val("");
		$("#tblshow tbody tr").remove();
		var rowCnt = $(response.data).length;
		if(rowCnt > 0){
			var str_addRow = "";
			for(var i = 0 ; i < rowCnt; i++){
				var D_APP_PATH = $.trim(eval("response.data["+i+"].APP_PATH")); 
				var D_SUBJECT = $.trim(eval("response.data["+i+"].SUBJECT")); 
				var D_DEFAULT_FLAG = $.trim(eval("response.data["+i+"].DEFAULT_FLAG")); 
				var D_ADD_DATE = $.trim(eval("response.data["+i+"].ADD_DATE")); 
				var D_TO_LIST = $.trim(eval("response.data["+i+"].TO_LIST")); 
				var D_CC_LIST = $.trim(eval("response.data["+i+"].CC_LIST"));
				
				var D_DEFAULT_FLAG_CHECK = D_DEFAULT_FLAG == "Y" ? "checked=\"checked\"" : "";
				
				str_addRow = "";
				str_addRow += "<tr>";
				str_addRow += "    <td><input class=\"noLine\" type=\"checkbox\" name=\"InCheck\" id=\"InCheck\" value=\""+ ( i + 1 ) +"\"></td>";
				str_addRow += "    <td>"+ ( i + 1 ) +"</td>";
				str_addRow += "    <td><input type=\"radio\" name=\"defaultRadio\" id=\"defaultRadio\" class=\"input_type_text\" " + D_DEFAULT_FLAG_CHECK + " onClick=\"FixChecked();\" /></td>";
				str_addRow += "    <td><span class=\"btn_gray_02\"><a href=\"javascript:;\" onclick=\"javascript:goAppDetail(this,'" + D_APP_PATH + "','" + D_TO_LIST + "','" + D_CC_LIST + "');\">결재자</a></span></td>";
				str_addRow += "    <td class=\"left\"><input type=\"text\" class=\"input_type_text\" style=\"width: 95%\" name=\"subject\" class=\"input_type_text\" value=\"" + D_SUBJECT + "\" /></td>";
				str_addRow += "    <td>" + D_ADD_DATE + "</td>";
				str_addRow += "    <td>";
				str_addRow += "        <a href=\"#\" id=\"row_delete\"  onclick=\"kepRowRemove(this)\">행삭제</a>";
				str_addRow += "        <input type=\"hidden\" name=\"app_path\" value=\""+D_APP_PATH+"\" />";
				str_addRow += "        <input type=\"hidden\" name=\"status\" value=\"R\">";
				str_addRow += "        <input type=\"hidden\" name=\"to_str\" value=\"" + D_TO_LIST + "\"><!-- 결재자리스트 -->";
				str_addRow += "        <input type=\"hidden\" name=\"cc_str\" value=\"" + D_CC_LIST + "\"><!-- 참조자리스트 -->";
				str_addRow += "        <input type=\"hidden\" name=\"defaultFlag\" value=\"N\"><!--디폴트결재선유무 Y/N-->";
				str_addRow += "        <input type=\"hidden\" name=\"oldDefaultRadio\" value=\"" + D_DEFAULT_FLAG + "\">";
				str_addRow += "    </td>";
				str_addRow += "</tr>";
				
				$("#tblshow tbody").append(str_addRow);
			}
		}
	} else if ( gubun == "insertApprovalInfo" ) {
		var msg = response.msg.MSG;
		if(msg == "INSERT_OK"){
			alert("저장 되었습니다.");
			init_searchArea();
			init_searchApproverList();
			init_approverList();
			getApprovalInfoList();
			return;
		}
	} else if ( gubun == "delApprovalInfo" ) {
		init_searchArea();
		init_searchApproverList();
		init_approverList();
		getApprovalInfoList();
			return;
	} else if ( gubun == "getApproverInfoList" ) {
		var toRowCnt = $(response.to_data).length;
		var ccRowCnt = $(response.cc_data).length;
		var str_addRow = "";
		
		init_searchArea();
		init_searchApproverList();
		init_approverList();
		
		if(toRowCnt > 0 || ccRowCnt > 0){
			$("#tblApprover tbody tr").remove();
			if(toRowCnt > 0){
				for(var i = 0 ; i < toRowCnt; i++){
					var D_ROWNUM = $.trim(eval("response.to_data["+i+"].ROWNUM"));
					var D_GUBUN = $.trim(eval("response.to_data["+i+"].GUBUN"));
					var D_USER_ID = $.trim(eval("response.to_data["+i+"].USER_ID"));
					var D_USER_NAME_LOC = $.trim(eval("response.to_data["+i+"].USER_NAME_LOC"));
					var D_DEPARTMENT = $.trim(eval("response.to_data["+i+"].DEPARTMENT"));
					var D_POSITION = $.trim(eval("response.to_data["+i+"].POSITION"));
					
					var D_CODE_RESULT = D_ROWNUM+"@"+D_GUBUN+"@"+D_USER_NAME_LOC+"@"+D_POSITION+"@"+D_DEPARTMENT+"@"+D_USER_ID;
					
					str_addRow = "";
					str_addRow += "<tr>";
					str_addRow += "    <td>" + D_GUBUN + "</td>";
					str_addRow += "    <td>" + D_USER_NAME_LOC + "</td>";
					str_addRow += "    <td>" + D_POSITION + "</td>";
					str_addRow += "    <td>" + D_DEPARTMENT + "</td>";
					str_addRow += "    <td>";
					str_addRow += "        <a id=\"row_delete\" onclick=\"removeApproverRow(this);\" href=\"javascript:;\">행삭제</a>";
					str_addRow += "        <input type=\"hidden\" id=\"codeResult\" name=\"codeResult\" value=\"" + D_CODE_RESULT + "\" />";
					str_addRow += "    <td>";
					str_addRow += "</tr>";
					
					$("#tblApprover tbody").append(str_addRow);
				}
			}
			if(ccRowCnt > 0){
				for(var i = 0 ; i < ccRowCnt; i++){
					var D_ROWNUM = $.trim(eval("response.cc_data["+i+"].ROWNUM"));
					var D_GUBUN = $.trim(eval("response.cc_data["+i+"].GUBUN"));
					var D_USER_ID = $.trim(eval("response.cc_data["+i+"].USER_ID"));
					var D_USER_NAME_LOC = $.trim(eval("response.cc_data["+i+"].USER_NAME_LOC"));
					var D_DEPARTMENT = $.trim(eval("response.cc_data["+i+"].DEPARTMENT"));
					var D_POSITION = $.trim(eval("response.cc_data["+i+"].POSITION"));
					
					var D_CODE_RESULT = D_ROWNUM+"@"+D_GUBUN+"@"+D_USER_NAME_LOC+"@"+D_POSITION+"@"+D_DEPARTMENT+"@"+D_USER_ID;
					
					str_addRow = "";
					str_addRow += "<tr>";
					str_addRow += "    <td>" + D_GUBUN + "</td>";
					str_addRow += "    <td>" + D_USER_NAME_LOC + "</td>";
					str_addRow += "    <td>" + D_POSITION + "</td>";
					str_addRow += "    <td>" + D_DEPARTMENT + "</td>";
					str_addRow += "    <td>";
					str_addRow += "        <a id=\"row_delete\" onclick=\"removeApproverRow(this);\" href=\"javascript:;\">행삭제</a>";
					str_addRow += "        <input type=\"hidden\" id=\"codeResult\" name=\"codeResult\" value=\"" + D_CODE_RESULT + "\" />";
					str_addRow += "    <td>";
					str_addRow += "</tr>";
					
					$("#tblApprover tbody").append(str_addRow);
				}
			}
		}
		$("#commonCoCoApproverSearchForm input:hidden[name=app_path]").val(pMethod.app_path);
		$("#tblshow tbody .approval_btn_02").removeClass().addClass("btn_gray_02");
		$(pMethod.btnObj).parent().removeClass().addClass("approval_btn_02");
	}else if ( gubun == "getApprovalMultiPathUserList" ) {
		
		var rowCnt = $(response.data).length;
		
		init_searchApproverList();
		
		if(rowCnt != null && rowCnt > 0){
			var str_addRow = "";
			$("#tblSearchApprover tbody tr").remove();
			
			for(var i = 0 ; i < rowCnt; i++){
				var D_USER_NAME_LOC = $.trim(eval("response.data["+i+"].USER_NAME_LOC"));
				var D_USER_ID = $.trim(eval("response.data["+i+"].USER_ID"));
				var D_DEPARTMENT = $.trim(eval("response.data["+i+"].DEPARTMENT"));
				var D_DEPARTMENT_NAME = $.trim(eval("response.data["+i+"].DEPARTMENT_NAME"));
				var D_POSITION = $.trim(eval("response.data["+i+"].POSITION"));
				var D_POSITION_NAME = $.trim(eval("response.data["+i+"].POSITION_NAME"));
				
				str_addRow = "";
				str_addRow += "<tr>";
				str_addRow += "    <td>";
				str_addRow += "        <input type=\"checkbox\" id = \"checkbox"+i+"\" name=\"InCheck\" value=\""+D_USER_ID+"@"+D_USER_NAME_LOC+"@"+D_POSITION+"@"+D_DEPARTMENT+"@"+D_POSITION_NAME+"@"+D_DEPARTMENT_NAME+"\" />";
				str_addRow += "    </td>";
				str_addRow += "    <td>" + D_USER_NAME_LOC + "</td>";
				str_addRow += "    <td>" + D_POSITION_NAME + "</td>";
				str_addRow += "    <td class=\"left\">" + D_DEPARTMENT_NAME + "</td>";
				str_addRow += "</tr>";
				
				$("#tblSearchApprover tbody").append(str_addRow);
			}
		}
	} else if ( gubun == "regApproverInfoList" ) {
		var msg = response.msg.MSG;
		if(msg == "INSERT_OK"){
			alert("저장 되었습니다.");
			init_searchArea();
			init_searchApproverList();
			init_approverList();
			getApprovalInfoList();
			$("#commonCoCoApproverSearchForm input:hidden[name=app_path]").val("");
			setReturn(pMethod.to_str_id, pMethod.cc_str_id, pMethod.db_to_name + pMethod.db_cc_name, pMethod.to_name + pMethod.cc_name);
			return;
		}
	}
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	var gubun = pMethod.gubun;
	
	if (gubun == "getApprovalInfoList"){ 
		 alert("결제선 목록 조회에 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
	}else if (gubun == "insertApprovalInfo"){ 
		 alert("결제선 저장에 실패 하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
	}else if (gubun == "delApprovalInfo"){ 
		 alert("행 삭제에 실패 하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
	}else if (gubun == "delApprovalInfo"){ 
		 alert("행 삭제에 실패 하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
	}else if (gubun == "getApproverInfoList"){ 
		 alert("결재자/참조자 목록 조회에 실패 하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
	}else if (gubun == "getApprovalMultiPathUserList"){ 
		 alert("결재/참조자 검색 조회에 실패 하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
	}else if (gubun == "regApproverInfoList"){ 
		 alert("결재/참조자 정보 등록에 실패 하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
	}
}

function kepApproverEnter() {
	if (event.keyCode == 13) { 
		setApproverQuery();
	}
}

function setReturn(value1,value2,value3,value4,value5)
{ 
  opener.setPopupReturn(value1,value2,value3,value4,value5);
//   this.close();
}
 //-->
</script> 
<body onload="">
<form name="commonCoCoApprovalMultiForm" id="commonCoCoApprovalMultiForm" method=post >
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:304px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">결재선 선택</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<div class="fl">
        		결재선 지정: ※결재선을 등록 후, 결재자 버튼을 선택하여 결재자지정 하십시오.
        	</div>
        	<div class="fr">
            	<span class="btn_search"><a href="javascript:addrows();">행추가</a></span>  
            </div>
            <br>
           	<!--grid-->
            <div class="scrollArea mt10" style="height:168px">
                <table id="tblshow" class="cont_t_list02"  style="width:100%">
                    <caption>결재자지정 리스트</caption>
                    <colgroup>
                        <col width="5%" /> 
                        <col width="5%" /> 
                        <col width="10%" /> 
                        <col width="10%" /> 
                        <col width="" /> 
                        <col width="10%" /> 
                        <col width="10%" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">선택</th> 
                            <th scope="col">No</th> 
                            <th scope="col">디폴트결재선</th> 
                            <th scope="col">결재자지정</th> 
                            <th scope="col">결재선제목</th> 
                            <th scope="col">등록일자</th>
                            <th scope="col">&nbsp;</th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>                  
	        </div>
	    </div>
	    <!--버튼영역-->
        <div class="btnArea mr25">
			<span class="fr">
				<span class="btn_02 mr04"><a href="javascript:regAppPath();">저장</a></span>
			</span>
       </div>
	</div>
</form> 
<form name="commonCoCoApproverSearchForm" id="commonCoCoApproverSearchForm" method="post" onsubmit="return false;" >
	<input type="hidden" name="app_path"/>
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:404px;">
    	<div id="popHeader">
        	<h1 class="title">결재자 지정</h1>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<div style="height:260px;">
            	<!--왼쪽영역-->
           	    <div style="width:45%; height:260px; float:left;">
               		<div id="cont_searchA">
                        <table class="cont_t_list01" style="width:100%">
                            <caption>결재자 지정/변경 리스트</caption>
                            <colgroup>
                                <col width="15%" />
                                <col width="*" />
                                <col width="15%" />
                            </colgroup>
                            <tbody>
                                <tr>
									<td>
										<select name="key" id="key" > 								
											<option value = "cn" >이름</option>
											<option value = "uid" >ID</option>
											<option value = "dept" >부서</option>
										</select>  
									</td>						
									<td><input type="text" class="input_type_text" name="qstr" id="qstr" width="96px" value="" onkeydown="javascritp : if (event.keyCode == 13) { 	setApproverQuery(); return false; } " style="ime-mode:active"/></td>
									<td><span class="btn_search"><a href="javascript:setApproverQuery();">조회</a></span></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
					<div class="scrollArea" style="height:200px">
					<!-- 선택할 고객사 -->
					<table id="tblSearchApprover" class="cont_t_list02"  style="width:100% ">
		                    <caption>결재자 지정/변경 리스트</caption>
		                    <colgroup>
		                        <col width="10%" /> 
		                        <col width="30%" />  
		                        <col width="30%" /> 
		                        <col width="*" />  
		                    </colgroup>
		                    <thead>
		                        <tr>
		                            <th scope="col">선택</th> 
		                            <th scope="col">이름</th>  
		                            <th scope="col">직급</th>  
		                            <th scope="col">부서</th>  
		                        </tr>
		                    </thead>
		                    <tbody>
		                    </tbody>
		                </table> 
		                </div> 	
                </div>
                <!--//왼쪽영역끝-->
                <div style="width:80px; height:110px; float:left; padding:100px 0px 0 14px;">
                    <span class="btn_002 mr04"><a href="javascript:addMan('to')" >결재</a></span><br><br>
                	<span class="btn_002 mr04"><a href="javascript:addMan('cc')" >참조</a></span><br><br>
                	<span class="btn_002 mr04"><a href="javascript:addMan('ag')" >합의</a></span>
                </div>
                
                <!--오른쪽영역-->
                <div style="width:45%; height:260px; float:left;">
                	<h2 class="popTit" style="margin-bottom:34px;">[결재자/참조자]</h2>
 				        <!-- 선택 고객사 -->
						<div class="scrollArea" style="height:200px">
						<table id="tblApprover" class="cont_t_list02"  style="width:100%" >
			                    <caption>선택된 고객사</caption>
			                    <colgroup>
			                        <col width="20%" /> 
			                        <col width="20%" />  
			                        <col width="20%" />  
			                        <col width="30%" /> 
			                        <col width="*" />  
			                    </colgroup>
			                    <thead>
			                        <tr>
			                            <th scope="col">구분</th>  
			                            <th scope="col">이름</th>  
			                            <th scope="col">직급</th>  
			                            <th scope="col">부서</th>  
			                            <th scope="col">삭제</th>  
			                        </tr>
			                    </thead>
			                    <tbody>
			                    	<tr bgcolor="#FFFFFF">
				                        <td colspan="4" align="center" height = "145">
				                        <span class="font1">결재자를 선택해 주십시요.</span>
				                        </td> 
				                    </tr>
			                    </tbody>
						</table>                    
					</div>
                </div>
                <!--//오른쪽영역-->
            </div>
       		<!--버튼영역-->
			<div class="btnArea" style="margin-bottom:0">
				<span class="fr">
					<span class="btn_02 mr04"><a href="javascript:SelectMan()" >저장</a></span>
				</span>                	
          </div>            
        </div>
    </div>
</form>
</body>
</html>
