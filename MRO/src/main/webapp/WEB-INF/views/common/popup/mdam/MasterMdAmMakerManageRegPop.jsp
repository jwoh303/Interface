<%--
**********************************************
* 메뉴 : 
* 화면 : 제조사관리 등록팝업
* 기능 : 제조사를 등록수정 위한 팝업
* 프로그램 ID : 
* 담당자 : 장민기 
* 착수일 : 2015-02-02
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" />
<link rel="stylesheet" type="text/css" media="screen"	href="/resources/libs/jquery/css/redmond/jquery-ui.min.css"/>   
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
 
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
String code = CommonUtil.nvl((String) request.getParameter("st_code"),"");  //  (조회조건)
String mode = CommonUtil.nvl((String) request.getParameter("st_mode"),"");  //  (조회조건)
// String st_buyer_code=  CommonUtil.nvl((String) request.getParameter("st_buyer_code"), "");
// String st_agent_code=  CommonUtil.nvl((String) request.getParameter("st_agent_code"), "");

String title = "";

	if(mode.equals("INS")){
		title = "자동생성";
	}else{
		title = "수정";
	}


Map<String,String> _rowData = null;
if (_dataList != null && _dataList.size() != 0) { 
	_rowData = _dataList.get(0);
}else{
	_rowData = new HashMap<String,String>();
	_rowData.put("TEXT1","");
	_rowData.put("CODE","자동등록");
	_rowData.put("ORIGIN","");
	_rowData.put("TEXT3","");
	_rowData.put("TEXT5","");
	_rowData.put("TEXT6","");
}

	
%>
<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var btnEvent = "";
var grbRow;
var diskOn = "/resources/images/disk_on.gif";
var diskOff = "/resources/images/disk_off.gif";


var st;
var mt;
//기능함수
function doAction(str) {

	switch (str) {
		case "reg": //등록
			    var reg_text1           = $("#st_reg_text1").val();
				var origin_name         =$("#st_origin_name").val();

			    if(reg_text1==""){
			        alert("코드명을 입력해 주십시요.");
			        return;
			    }

			    if(origin_name==""){
			        alert("원산지를 선택해 주십시요.");
			        return;
			    }	
				if (!confirm('제조사를 등록 하시겠습니까?'))
					return;
				kepAjaxFormCall("/mdam/regMasterMdAmMakerManageRegPop.do", "contentForm", "reg");
				
			break;
		case "update": //등록
				if (!confirm('제조사를 수정 하시겠습니까?'))
					return;
				kepAjaxFormCall("/mdam/updateMasterMdAmMakerManageRegPop.do", "contentForm", "update");
				
			break;
	}

}
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

function mySheet_OnSearchEnd(code, msg, stCode) {
	alert("aaaaa");
	loader_obj("N");
	if(!checkedSession(stCode)){return;}	

	if(mySheet.RowCount() <= 0) return;
	
	if (msg != "") {
		alert(msg);
	}

	if(current_page==-1){
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	}else{
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
	
}

//페이지 인덱스 눌렀을 경우 조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mpds/getMasterMdAmMakerManageRegPop.do?page="+current_page , pagingMode );
}


//팝업함수호출
function doPop(str) {
	popupSel = str;
	switch (str) {
		case "masterMpDsSeedKindPop": //종자구분
			var item_code = document.forms[0].st_item_code.value;
			openSearchPopup('/mpds/showMasterMpDsSeedKindPop.do','?st_item_code='+item_code,'500,330,no');
			break;
		case "Originpop": //원산지
			popupSel = "country";
			openSearchPopup("/common/countryCodePop.do", "", "500,500,no");
			break;
		case "MgMakerPop": //대표제조사
			popupSel = "MgMakerPop";
			var param = "?type=M070&codeGubun=geticomcod1Pop&title=대표제조사";
			openSearchPopup('/common/commonIcomcod1WhereList.do', param, "500,500,no");
			break;
	}	
	
}
function kepAjaxSuccess(pMethod , response){
	var closeflag = true;
	if (pMethod == "reg"){
		alert("등록이 성공적으로 이루어 졌습니다. ");		
	}else if (pMethod == "update"){
		alert("수정이 성공적으로 이루어 졌습니다. ");
	}
	
	if (closeflag == true){ 
		opener.doAction('search');
		self.close();
	}
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	if (pMethod == "1"){
		alert("등록이 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
	}else if (pMethod == "2"){
		alert("업데이트가 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
	}
} 
//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	alert("aa");
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if (msg != "") {
		alert(msg);
	}
	alert(code);
	if(code>0){
		//저장 성공시 재조회
		doAction('reload');
	}
	if(bntEvent="reg"){ // 등록후 창닫기
		kepConfirm();
	}
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(value1, value2, value3){
	
	if(popupSel == "fileUpload") {	//파일 첨부
		mySheet.SetCellValue(grbRow, 'IMAGE_KEY', value1);
		mySheet.SetCellValue(grbRow, 'IMAGE_KEY_IMG', (value2 =="on")? diskOn : diskOff);
	}
	else if (popupSel == "masterMpDsSeedKindPop") {	// 종자 구분
		document.forms[0].st_item_code.value = value1;
		document.forms[0].st_item_name.value = value2;
	}	else if (popupSel == "country") {	// 원산지
		$("#st_origin_name").val(value3);
		$("#st_origin_code").val(value1);
	}   else if (popupSel == "MgMakerPop") {	// 대표제조사
		$("#st_mg_code").val(value1);
		$("#st_mg_name").val(value2);
	}

}



//확인
function kepConfirm()
{ 
//  var value1 = mySheet.GetCellValue(grbRow, "BUYER")+"@";
//  var value2 = mySheet.GetCellValue(grbRow, "BUYER_NAME");
	var value1="";
	var value2="";
	var value3="";

 opener.setPopupReturn(value1,value2,value3);
 
 this.close();
}
</script> 
<form name = "contentForm" id = "contentForm" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
	<input type="hidden" id="code" name="usr_dept" value="<%=code%>" />
	<input type="hidden" id=mode name="mode" value="<%=mode%>" />
    
	<div id="popWrapper" style="height:554px;">
    	<div id="popHeader">
        	<h1 class="title">제조사 등록</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
            <!--조회영역-->
        	<div id="cont_searchA">
            	<table class="cont_t_list01" style="width:100%">
						<caption>조회</caption>
						<colgroup>
							<col width="15%" />
							<col width="35%" />
							<col width="15%" />
							<col width="35%" />
						</colgroup>
						
						<tbody>
					        <tr>
					          <th  height="30">대표 제조사</th>
					          <td >
								<input type="text" name="st_mg_name"  id="st_mg_name"  style="ime-mode:active;width:88%" value="<%=CommonUtil.nvl(_rowData.get("MG_TEXT")) %>"OnKeyDown="kepEnter()" Readonly >
								<a href="javascript:doPop('MgMakerPop');"><img src="/resources/images/btn_search03.gif"></a>
								<input type="hidden" name="st_mg_code" id="st_mg_code"  value="<%=CommonUtil.nvl(_rowData.get("TEXT7"))%>">
					          </td>
					        </tr>
					        <tr>
					          <th  height="30">제조사 코드</th>
					          <td >
					            <input type="text" name="st_reg_code" id="st_reg_code"  style="width:95%" value="<%=CommonUtil.nvl(_rowData.get("CODE")) %>" OnKeyDown="kepEnter()" onKeyUp="kepToUpper('st_reg_code')" Readonly>
					          </td>							 
					         </td>
					        </tr>
					        <tr>
					          <th  height="30">제조사명</th>
					          <td >
					            <input type="text" name="st_reg_text1" id="st_reg_text1"  style="width:95%" value="<%=CommonUtil.nvl(_rowData.get("TEXT1")) %>"OnKeyDown="kepEnter()" >
					          </td>
					        </tr>
					        <tr>
					          <th  height="30">원산지</th>
					          <td >
								<input type="text" name="st_origin_name"  id="st_origin_name"  style="ime-mode:active;width:88%" value="<%=CommonUtil.nvl(_rowData.get("ORIGIN")) %>"OnKeyDown="kepEnter()" Readonly >
								<a href="javascript:doPop('Originpop');"><img src="/resources/images/btn_search03.gif"></a>
								<input type="hidden" name="st_origin_code" id="st_origin_code"  value="<%=CommonUtil.nvl(_rowData.get("TEXT3"))%>">
					          </td>
					        </tr>
					        <tr>
					          <th  height="30">대표품목</th>
					          <td >
										<input type="text" name="st_items" style="width:95%" value="<%=CommonUtil.nvl(_rowData.get("TEXT5")) %>"OnKeyDown="kepEnter()">
					          </td>
					        </tr>
					        <tr>
					          <th  height="30">URL</th>
					          <td >
										<input type="text" name="st_url" style="width:95%" value="<%=CommonUtil.nvl(_rowData.get("TEXT6")) %>"OnKeyDown="kepEnter()">
					          </td>
					        </tr>
					</tbody>
				</table>
            </div>
            
            <!--grid-->
 
			<div id="pageindex" style="height: 10px"></div>
<!-- 			<div id="pageindex" ></div> -->
	        <!--버튼영역-->
	        <div class="btnArea mr25">
				<span class="fr">
<% if(mode.equals("INS")){ %>
					<span class="btn_02 mr04"><a href="javascript:doAction('reg');">등록</a></span>
<% }else{ %>
					<span class="btn_02 mr04"><a href="javascript:doAction('update');">수정</a></span>
<% } %>
				</span>
	       </div>
			
		</div>	
        
    </div>
</form> 
</body>
</html>
