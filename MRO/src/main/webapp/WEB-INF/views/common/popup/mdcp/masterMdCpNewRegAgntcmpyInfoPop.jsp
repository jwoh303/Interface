<%--
**********************************************
* 메뉴 : 
* 화면 : 신규등록 협력사 정보 
* 기능 : 승인요청 대상 협력사의 중복데이터 여부와 제재이력을 조회하여 등록가능 여부를 확인
* 프로그램 ID : PG_01_M_004_01
* 담당자 : 이수영 ( 설계 : 권우재 )
* 착수일 : 2014-06-27
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
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
String st_user_id = _sessionInfo.getUserId();
String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
String mdm_confirm_type=  CommonUtil.nvl((String) request.getParameter("mdm_confirm_type"), "");
String po_dept = CommonUtil.nvl((String) request.getParameter("po_dept"),"");  //  (조회조건)
String st_req_dept_name = CommonUtil.nvl((String) request.getParameter("st_req_dept_name"),"");  //  (조회조건)

Map<String,String> _rowData = null;
if (_dataList != null && _dataList.size() != 0) { 
	_rowData = _dataList.get(0);
}

// MDM 저장 권한 ICOMCOD2.TYPE=MDM
%>

<script type="text/javascript">
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤

function kep_onload_view() {
	<% if (_dataList.size() == 0) { %>
		alert("협력사 사용자 정보가 없습니다.\n\n관리자에게 문의 하십시요.");
		self.close();
	<% } %>
	
	var initsheet = {};
	initsheet.Cols = [ 
					{ Align:"Center",	Width:40,		Edit:false,	EditLen:0,		Hidden:true,	Type:"Status",			Header:"상태",					SaveName:"sStatus"}
					,{ Align:"Center",	Width:60,		Edit:false,	EditLen:0,		Hidden:true,	Type:"Text",				Header:"구분",					SaveName:"FLAG"}
					,{ Align:"Center",	Width:40,		Edit:true,	EditLen:100,	Hidden:false,	Type:"DummyCheck",	Header:"",							SaveName:"SELECTED"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:true,	Type:"Text",				Header:"회원사코드",			SaveName:"COM_CODE"}
					,{ Align:"Left",	Width:300,	Edit:false,	EditLen:260,	Hidden:false,	Type:"Text",				Header:"협력사명",				SaveName:"COM_NAME_LOC"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:160,	Hidden:false,	Type:"Text",				Header:"사업자등록번호",		SaveName:"IRS_NO"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"대표자명",				SaveName:"CEO_NAME_LOC"}
					,{ Align:"Left",	Width:420,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"주소",					SaveName:"ADDRESS_LOC"}
					,{ Align:"Center",	Width:120,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"대표전화번호",			SaveName:"TEL_NO"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"팩스번호",				SaveName:"FAX_NO"}
					,{ Align:"Left",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"담당자명",				SaveName:"USER_NAME_LOC"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"전화번호",				SaveName:"PHONE_NUMBER"}
					,{ Align:"Left",	Width:140,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"이메일",					SaveName:"EMAIL"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"휴대전화번호",			SaveName:"MOBILE_PHONE"}
					,{ Align:"Left",	Width:280,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"홈페이지",				SaveName:"HP_ADDRESS"}
					,{ Align:"Center",	Width:100,	Edit:false,	EditLen:100,	Hidden:false,	Type:"Text",				Header:"휴폐업정보",			SaveName:"MDM_CONFIRM_TYPE"}
	];
	
	IBS_InitSheet(mySheet, initsheet,pagingMode);
}

//기능함수
function doAction(str) {
	st = new Date();

	switch (str) {
		case "search":	 // 조회
			$('#searchCondition').attr("action", "/mdcp/getMasterMdCpNewRegAgntcmpyInfoPop.do").submit();
			break;
		case "search2":	 // 조회
			kepSearch(document.searchCondition,  mySheet , "/mdcp/getMasterMdCpNewRegAgntcmpyInfoPopList.do" , pagingMode );
			break;
		case "except":		// 조회
			chk_except();
			break;
		case "reload":		// 초기화
			kepReload('searchCondition');
			mySheet.RemoveAll();
			break;
		case "save":			// 저장
			if (checkSubmit()) {
				kepAjaxFormCall("/mdcp/updateMasterMdCpNewRegAgntcmpyInfoPop.do","searchCondition", str);
			}
			break;	
		case "mdmCheck":	// MDM 담당자 확인
			kepAjaxFormCall("/mdcp/getMdmCheckMasterMdCpNewRegAgntcmpyInfoPop.do","searchCondition", str);
			break;		
	}
}

function chk_except() {
	var selectedGrid = mySheet.FindCheckedRow("SELECTED");
	var arrRow     = selectedGrid.split("|");
	var exceptArr = "";
	
	if (selectedGrid.length == 0) {
		alert("선택된 항목이 없습니다.");
		return;
	}
	
	for (var i=0; i <  arrRow.length; i++) {
		exceptArr += mySheet.GetCellValue(arrRow[i],"COM_CODE") + "@@";
	}
	
	$("#st_delete_com_code").val(exceptArr);
	doAction("search2");
}

//그리드 표시후 처리	 
function mySheet_OnLoadData(DATA) {
	mt = new Date();
	return DATA;
}

//조회 후처리
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
	$("#st_delete_com_code").val("");
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

//페이지 인덱스 클릭시 재조회
function pageSearch(param) {
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mdcp/getMasterMdCpAgntcmpyApprovalRequestList.do?page="+current_page , pagingMode );
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		kepSearch();
	}
}

function setReturn(value1,value2) { 
  opener.setPopupReturn(value1,value2);
  this.close();
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response) {
	var sMsg = response.msg;
	
	if (pMethod == "mdmCheck") {
		if (sMsg != 'YES') {
			alert(" 중복협력사 정보 체크는 MDM 담당자만 처리가능합니다..!!  ");
		 	return;
		} else {
			doAction("save");
		}
	} else 	if (pMethod == "save") {
		if (sMsg == 'OK') {
			alert("정상 처리 되었습니다");
			setReturn("OK");
		} else {
			alert("등록 중  오류가 발생 했습니다 \n\n 관리자에게 문의 하세요!");
            return;
		}
	}
}

function checkSubmit() { 

	$("#st_mdm_status").val($("input[name=mdm_status]:checked").val());
	$("#st_mdm_remark").val($("#st_mdm_note").val());
	
	if ($("#mdm_status1").is(":checked")) {
		mdm_status_text = "제재이력업체";
	} else if ($("#mdm_status2").is(":checked")) {
		mdm_status_text = "중복업체";
	} else if ($("#mdm_status3").is(":checked")) {
		mdm_status_text = "등록가능";
	} else if ($("#mdm_status1").is(":checked")) {
		mdm_status_text = "기타업체";
	}
	
	var confir = confirm(  "협력사를 " + mdm_status_text + "(으)로 등록 하시겠습니까?");
	return confir;
}

</script> 
<body onload="kep_onload_view();">
<form name="searchCondition" id="searchCondition" method="post" >
<input type="hidden" name="s_SAVENAME" />
<input type="hidden" name="com_code" id="com_code"  value="<%=com_code%>" />
<input type="hidden" name="mdm_confirm_type" id="mdm_confirm_type"  value="<%=mdm_confirm_type%>" />
<input type=hidden name="po_dept" id="po_dept"  value="<%=po_dept%>" />
<input type="hidden" name="st_user_id" id="st_user_id"  value="<%=st_user_id%>" />
<input type="hidden" id="pageflag" name="pageflag" value="1" />
<input type="hidden" id="st_delete_com_code" name="st_delete_com_code" value="" />
<input type="hidden" id="st_mdm_status" name="st_mdm_status" value="" />
<input type="hidden" id="st_mdm_remark" name="st_mdm_remark" value="" />
<input type="hidden" id="onepagerow" name="onepagerow" value="1000" />
</form>
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:664px;">
    	<div id="popHeader">
        	<h1 class="title">신규등록 협력사 정보 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
               
            <!--조회영역-->
            <div>
            	<% if (_rowData != null) {  %>
            	<table  class="cont_t_list02"  style="width:100%">
                    <caption>신규등록 협력사 정보  리스트</caption>
                    <colgroup>
                        <col width="136" /> 
                        <col width="117" /> 
                        <col width="*" />
                        <col width="129" />
                        <col width="99" />
                        <col width="132" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">협력사명</th>
							<th scope="col">대표자명</th>
							<th scope="col" rowspan="2">주소</th>
							<th scope="col">팩스번호</th>
							<th scope="col">담당자명</th>
							<th scope="col">이메일</th>
                        </tr>
                        <tr>
                        	<th scope="col">사업자번호</th>
							<th scope="col">대표자 전화번호</th>
							<th scope="col">홈페이지</th>
							<th scope="col">전화번호</th>
							<th scope="col">휴대전화</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
							<td><%=CommonUtil.nvl(_rowData.get("COM_NAME_LOC"))%></td>
							<td><%=CommonUtil.nvl(_rowData.get("CEO_NAME_LOC"))%></td>
							<td rowspan="2"><%=CommonUtil.nvl(_rowData.get("ADDRESS_LOC"))%></td>
							<td><%=CommonUtil.nvl(_rowData.get("FAX_NO"))%></td>
							<td><%=CommonUtil.nvl(_rowData.get("USER_NAME_LOC"))%></td>
							<td><%=CommonUtil.nvl(_rowData.get("EMAIL"))%></td>
                        </tr>
                        <tr>
							<td><%=CommonUtil.nvl(_rowData.get("IRS_NO"))%></td>
							<td><%=CommonUtil.nvl(_rowData.get("TEL_NO"))%></td>
							<td><%=CommonUtil.nvl(_rowData.get("HP_ADDRESS"))%></td>
							<td><%=CommonUtil.nvl(_rowData.get("PHONE_NUMBER"))%></td>
							<td><%=CommonUtil.nvl(_rowData.get("MOBILE_PHONE"))%></td>
                        </tr>  
                    </tbody>
                </table>
                <% } %>
            </div>
            <div class="btnArea mt05 mb05">
  				<span class="fr">
  					<span class="btn_02"><a href="javascript:doAction('search2');">검색</a></span>
  				</span>
  			 </div>
			<div class="text10 b mb05" >중복 데이터 협력사 정보</div>
           	<!--grid-->
            <div style="height:244px">
                <div class="ib_product" style="border-top:2px solid #3c639c">
  					<script type="text/javascript">
						createIBSheet("mySheet", "100%", "204px");
					</script>
				</div>
				<p class="paging" id="pageindex" style="height:25px;"></p>                 
			</div>
			<div class="btnArea mt05 mb05">
  				<span class="fr">
  					<span class="btn_02"><a href="javascript:doAction('except');">제외</a></span>
  				</span>
  			 </div>
			<div>
			<div>
				<table  class="cont_t_list06"  style="width:100%">
                    <caption>MDM 담당자확인</caption>
                    <colgroup>
                        <col width="132" /> 
                        <col width="*" />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="col">MDM 담당자 확인</th>
							<td>
								<input type="radio" id="mdm_status1" name="mdm_status" value="F" <%=CommonUtil.nvl(_rowData.get("MDM_CONFIRM_TYPE")).equals("F") ? "checked" : "" %>/> 제재이력업체 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					            <input type="radio" id="mdm_status2" name="mdm_status" value="D" <%=CommonUtil.nvl(_rowData.get("MDM_CONFIRM_TYPE")).equals("D") ? "checked" : "" %>/> 중복업체 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					            <input type="radio" id="mdm_status3" name="mdm_status" value="T" <%=CommonUtil.nvl(_rowData.get("MDM_CONFIRM_TYPE")).equals("T") ? "checked" : "" %>/> 등록가능 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					            <input type="radio" id="mdm_status4" name="mdm_status" value="E" <%=CommonUtil.nvl(_rowData.get("MDM_CONFIRM_TYPE")).equals("E") ? "checked" : "" %>/> 기타
							</td>
                        </tr>
                        <tr>
                        	<th scope="col">비고</th>
							<td>
								<% if (_rowData != null) { %>
								<input type="text" class="input_type_text" name="st_mdm_note" id="st_mdm_note" style="width:90%" maxlength="50" onkeyup="fnCheckInputByte(this, 50);" onchange="fnCheckInputByte(this, 50);" value="<%=CommonUtil.nvl(_rowData.get("MDM_NOTE"))%>"  />
								<% } %>
							</td>
                        </tr>
                    </tbody>
                </table>
                </div>

                <div class="btnArea mt10 mb05">
	  				<span class="fr">
	  					<span class="btn_02"><a href="javascript:doAction('mdmCheck');">저장</a></span>
	  				</span>
  			 	</div>
<%
// }
%>
			</div>
			
		</div>        
</div>
 
</body>
</html>
