<%--
**********************************************
* 메뉴 : 
* 화면 : 협력사 커뮤니티 등록 및 상세 조회 팝업
* 기능 : 협력사 커뮤니티 등록 및 상세 조회 팝업
* 프로그램 ID : 
* 담당자 : 김영훈
* 착수일 : 2019-11-01
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<% 
	SessionInfo __sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	List<Map<String,String>> _gridList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	List<Map<String,String>> _gridList2 = (List<Map<String,String>>) request.getAttribute("data2"); // 내용 부분 조회된 결과
	String com_code = CommonUtil.nvl((String) request.getParameter("com_code"),"");  //  조회조건
	String SEQ = CommonUtil.nvl((String) request.getParameter("SEQ"),"");  //  조회조건
	String com_name = CommonUtil.nvl((String) request.getParameter("com_name"),"");
	String st_comment_flag = CommonUtil.nvl((String) request.getParameter("st_comment_flag"),"");
	String edit_flag = CommonUtil.nvl((String) request.getParameter("st_edit_yn"),"");
	String st_user_dept = __sessionInfo.getDepartment();
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" />
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
</head>

<script type="text/javascript">
// <!--
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";
var cnt = 0;

// 시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	var initsheet = {};
	initsheet.Cols = [ 
						{ Align:"Center",	Width:70,	Edit:false,	EditLen:300,	Type:"Text",	Header:"등록자",	SaveName:"COMMENT_USER_NAME"}
						,{ Align:"Center",	Width:100,	Edit:false,	EditLen:300,	Type:"Date",	Header:"등록일시",	SaveName:"COMMENT_ADD_DATM"  }
						,{ Align:"Left",	Width:390,	Edit:false,	EditLen:25,		Type:"Text",	Header:"내용",	SaveName:"CONTENTS" }
						,{ Align:"Center",	Width:70,	Edit:false,	EditLen:300,	Hidden:true,	Type:"Text",	Header:"등록자",	SaveName:"COMMENT_USER_ID"}
						,{ Align:"Center",	Width:70,	Edit:false,	EditLen:300,	Hidden:true,	Type:"Text",	Header:"등록자",	SaveName:"COMMENT_REVISION"}
						,{ Align:"Center",	Width:60,	Edit:false,	EditLen:25,	Type:"Text",	Header:"댓글수",	Hidden:true,	SaveName:"COMMENT_COUNT"}
	];
	
	initsheet.Cfg = {MergeSheet:msHeaderOnly,FrozenCol:0};
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "CONTENTS");
	
	doAction('search');
}

//기능함수
function doAction(str) {
	
	switch (str) {
		case "search":	 // 댓글 조회
			current_page = -1;
			kepSearch(document.searchCondition,  mySheet , "/mdcp/selectMasterMdCpAgentCommunityPopComment.do" , pagingMode );
			break;
		case "delete":	// 내용 삭제
			if(!confirm("내용을 삭제 하시겠습니까?")) return;
			kepAjaxFormCall("/mdcp/deleteMasterMdCpAgentCommunityPopList.do","searchCondition","CONTEXT_DELETE");
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

//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if ( msg != "" ) {
		alert(msg.msg);
	}
	if ( code > 0 ) {
		//댓글 저장 성공시 처리
		doAction('search');
	}
}

//그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	if(column == 'CONTENTS'){ // 내용
		var st_comment_user_id = mySheet.GetCellValue(Row,"COMMENT_USER_ID");
		var st_agent = TrimCommon($("#com_code").val());
		var st_seq =  TrimCommon($("#SEQ").val());
		var st_login_user_id = TrimCommon($("#st_user_id").val());
		var st_edit_yn =  "";
		var st_comment_revision = mySheet.GetCellValue(Row,"COMMENT_REVISION");
		var st_comment_count = mySheet.GetCellValue(Row,"COMMENT_COUNT");
		if(st_login_user_id == st_comment_user_id){ //본인인 경우 삭제 가능.
			st_edit_yn =  "Y";
		}else{
			st_edit_yn =  "N";
		}
		openSearchPopup("/mdcp/searchMasterMdCpAgentCommunityCommentDetail.do","?com_code="+st_agent+"&SEQ="+st_seq+"&st_comment_revision="+st_comment_revision+"&st_edit_yn="+st_edit_yn+"&st_comment_count="+st_comment_count, "600,350,no");
	}
	
	return;
}

/**
 * ajax 공통 호출후 성공시 처리 함수
 */ 
function kepAjaxSuccess(pMethod , response){
	var st_agent = TrimCommon($("#com_code").val());
	var st_seq =  TrimCommon($("#SEQ").val());
	if(pMethod == "CONTEXT_SAVE"){ 
		opener.location.href = opener.location.href;
		window.close();
    }else if(pMethod == "CONTEXT_UPDATE"){
    	opener.location.href = opener.location.href;
    	window.close();
    }else if(pMethod == "CONTEXT_DELETE"){
    	opener.location.href = opener.location.href;
    	window.close();
    }else if(pMethod == "COMMENT_SAVE"){
		location.href = "/mdcp/searchMasterMdCpAgentCommunityDetailList.do?com_code="+st_agent+"&SEQ="+st_seq+"&st_comment_flag=Y"+"&st_edit_yn=N";
		opener.location.href = opener.location.href;
    }
}

/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	if (pMethod == "CONTEXT_SAVE"){ 
    	alert("시스템 오류입니다. 관리자에게 문의하시기 바랍니다."); 
	}else if(pMethod == "CONTEXT_UPDATE"){
    	alert("시스템 오류입니다. 관리자에게 문의하시기 바랍니다.");       
    }else if(pMethod == "CONTEXT_DELETE"){
    	alert("시스템 오류입니다. 관리자에게 문의하시기 바랍니다.");
    }else if(pMethod == "COMMENT_SAVE"){
    	alert("시스템 오류입니다. 관리자에게 문의하시기 바랍니다.");
    }
	
} 

// 내용 등록
function contextSave(type){
	var flag = document.getElementsByName('st_agent_type_flag');	// 관리유형
	var chk = "";
	for(var i=0;i<flag.length;i++){
		if (flag[i].checked == true){
			chk = flag[i].value;
		}
	}

	if(chk == ""){
		alert("관리유형을 선택해주세요.");
		return;
	}
	
	if (kepIsEmpty("CONTEXT")==true){
		alert("내용을 입력해주세요.");
		$("#CONTEXT").focus();
		return;
	} 		
	
	if(!confirm("내용을 저장 하시겠습니까?")) return;
	if("S" == type){		// 등록
		kepAjaxFormCall("/mdcp/insertMasterMdCpAgentCommunityPopList.do","searchCondition","CONTEXT_SAVE");
	}else if("R" == type){	// 수정
		kepAjaxFormCall("/mdcp/updateMasterMdCpAgentCommunityPopList.do","searchCondition","CONTEXT_UPDATE");
	}
}

// 댓글 등록
function commentSave(){
	if (kepIsEmpty("COMMENT")==true){
		alert("댓글을 입력해주세요.");
		$("#COMMENT").focus();
		return;
	} 
	
	if(!confirm("댓글을 저장 하시겠습니까?")) return;
	kepAjaxFormCall("/mdcp/insertMasterMdCpAgentCommunityPopComment.do","searchCondition","COMMENT_SAVE");
}

 //-->
</script> 
<body onload="kep_onload_view()">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:530px;">
    	<div id="popHeader">
        	<h1 class="title">협력회사 커뮤니티</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
            
            <form name="searchCondition" id="searchCondition" method=post >
				<!--HIDDEN-->
				<!-- 공통 -->
				<input type="hidden" name="s_SAVENAME">
				<input type="hidden" id="pageflag" name="pageflag" value="1">
				<!-- 화면 내 정의 -->
				<input type="hidden" id="st_user_id" name="st_user_id"  value="${sessionInfo.userId}">
				<input type="hidden" id="st_user_dept" name="st_user_dept"  value="<%=st_user_dept%>">
				<input type="hidden" id="SEQ" name="SEQ"  value="<%=SEQ%>">
				<input type="hidden" id="st_edit_yn" name="st_edit_yn"  value="<%=edit_flag%>">
				<input type="hidden" id="st_comment_flag" name="st_comment_flag"  value="<%=st_comment_flag%>">
				
	            <!--조회영역-->
	            <div id="cont_searchA">
	            	<table class="cont_t_list06" style="width:100%">
						<caption>협력회사 커뮤니티</caption>
						<colgroup>
							<col width="80px" />
							<col width="23%" />
							<col width="100px" />
							<col width="20%" />
							<col width="80px" />
	                        <col width="13%" />
						</colgroup>
						<tbody>
				<%
				Map<String,String> rowData = null;
				for (int j=0; j<_gridList.size(); j++) {
					rowData = _gridList.get(j);
				%> 
							<tr> 
								<th scope="row">협력사명</th>
								<td>
									<%=CommonUtil.nvl(rowData.get("COM_NAME"))%>
									<input type="hidden" name="com_code" id="com_code" style="width:70%" value="<%=CommonUtil.nvl(rowData.get("COM_CODE"))%>">
								</td>
								<th scope="row">사업자번호</th>
								<td>
									&nbsp;<%=CommonUtil.nvl(rowData.get("IRS_NO"))%>
								</td>
								<th scope="row">대표자명</th>
								<td>
									<%=CommonUtil.nvl(rowData.get("CEO_NAME"))%>
								</td>
							</tr>
			<%	} 
				if(_gridList2 != null){	
					Map<String,String> rowData2 = null;
					String login_id = CommonUtil.nvl(__sessionInfo.getUserId());
					String reg_user_id = null;
					for (int j=0; j<_gridList2.size(); j++) {
						rowData2 = _gridList2.get(j);
		            	reg_user_id = CommonUtil.nvl(rowData2.get("USER_ID"));
			%>
							<tr> 
								<input type="hidden" id="reg_user_id" name="reg_user_id"  value="<%=CommonUtil.nvl(rowData.get("USER_ID"))%>">
								<th scope="row">관리유형</th>
			                    <td colspan="3">
									<input type="radio" id="agentType1" name="st_agent_type_flag" value="QT" <%=CommonUtil.nvl(rowData2.get("TYPE")).equals("QT") ? "checked" : "" %> <%=edit_flag.equals("Y") && login_id.equals(reg_user_id) ? "" : "disabled"%>/>&nbsp;견적&nbsp;
									<input type="radio" id="agentType2" name="st_agent_type_flag" value="DV" <%=CommonUtil.nvl(rowData2.get("TYPE")).equals("DV") ? "checked" : ""%> <%=edit_flag.equals("Y") && login_id.equals(reg_user_id) ? "" : "disabled"%>/>&nbsp;배송&nbsp;
									<input type="radio" id="agentType3" name="st_agent_type_flag" value="AP" <%=CommonUtil.nvl(rowData2.get("TYPE")).equals("AP") ? "checked" : ""%> <%=edit_flag.equals("Y") && login_id.equals(reg_user_id) ? "" : "disabled"%>/>&nbsp;마감&nbsp;
									<input type="radio" id="agentType4" name="st_agent_type_flag" value="PR" <%=CommonUtil.nvl(rowData2.get("TYPE")).equals("PR") ? "checked" : ""%> <%=edit_flag.equals("Y") && login_id.equals(reg_user_id) ? "" : "disabled"%>/>&nbsp;가격&nbsp;
									<input type="radio" id="agentType5" name="st_agent_type_flag" value="SV" <%=CommonUtil.nvl(rowData2.get("TYPE")).equals("SV") ? "checked" : ""%> <%=edit_flag.equals("Y") && login_id.equals(reg_user_id) ? "" : "disabled"%>/>&nbsp;서비스&nbsp;
									<input type="radio" id="agentType6" name="st_agent_type_flag" value="ET" <%=CommonUtil.nvl(rowData2.get("TYPE")).equals("ET") ? "checked" : ""%> <%=edit_flag.equals("Y") && login_id.equals(reg_user_id) ? "" : "disabled"%>/>&nbsp;기타&nbsp;
									<input type="hidden" id="agent_type_flag" name="agent_type_flag" value="<%=CommonUtil.nvl(rowData2.get("TYPE"))%>" />
			                    </td>
			                </tr>
						</tbody>
					</table>
	            </div>
	            <div id="searchBtnA02">
	            	<%
						if(edit_flag.equals("Y") && login_id.equals(reg_user_id)){
					%>
	            			<span class="btn_02"><a href="javascript:doAction('delete')">삭제</a></span>
				        	<span class="btn_02"><a href="javascript:contextSave('R')">저장</a></span> 
				    <%	} %>
				</div>
				<div id="cont_searchA">
				<table class="cont_t_list01" style="width:100%">
		    		<th scope="row" align="center">내용&nbsp;</th>
		    		<td colspan="4"> 
		    		<textarea name="CONTEXT" id="CONTEXT"  rows="15" cols="91" <%=edit_flag.equals("Y") && login_id.equals(reg_user_id) ? "" : "READONLY"%>><%=CommonUtil.nvl(rowData2.get("CONTENTS"))%></textarea>
		            </td>
		        </table>
		    	</div>   
		    	<%	}
				}else{ %>
			                <tr> 
								<th scope="row">관리유형</th>
			                    <td colspan="3">
									<input type="radio" id="agentType1" name="st_agent_type_flag" value="QT" />&nbsp;견적&nbsp;
									<input type="radio" id="agentType2" name="st_agent_type_flag" value="DV" />&nbsp;배송&nbsp;
									<input type="radio" id="agentType3" name="st_agent_type_flag" value="AP" />&nbsp;마감&nbsp;
									<input type="radio" id="agentType4" name="st_agent_type_flag" value="PR" />&nbsp;가격&nbsp;
									<input type="radio" id="agentType5" name="st_agent_type_flag" value="SV" />&nbsp;서비스&nbsp;
									<input type="radio" id="agentType6" name="st_agent_type_flag" value="ET" />&nbsp;기타&nbsp;
									<input type="hidden" id="agent_type_flag" name="agent_type_flag" value="" />
			                    </td>
			                </tr>
			    		</tbody>
					</table>
	            </div>
	            <div id="searchBtnA02">
				        	<span class="btn_02 mr04"><a href="javascript:contextSave('S')">저장</a></span> 
				</div>
				<div id="cont_searchA">
				<table class="cont_t_list01" style="width:100%">
		    		<tbody>
		    		<tr>
		    		<th scope="row" align="center">내용&nbsp;</th>
		    		<td colspan="4"> 
		    			<textarea name="CONTEXT" id="CONTEXT"  rows="15" cols="91"></textarea>
		            </td>
		            </tr>
		            </tbody>
		        </table>
		    	</div>   
			 <%	}
				if(st_comment_flag.equals("Y")){ %>
			<div id="cont_searchA">
				<table class="cont_t_list01" style="width:100%">
				<tbody>
				<tr>
		    		<th scope="row" align="center">댓글&nbsp;</th>
		    		<td> 
		    			<textarea name="COMMENT" id="COMMENT"  rows="2" cols="78"></textarea>
		            </td>
		            <td>
		            	<span class="btn_02"><a href="javascript:commentSave()">저장</a></span>
		            </td>
	    		</tr>
	    		</tbody>
	    		</table>
    		</div>
    		</form>
           	<!--grid-->
            <div>
            	<div class="ib_product" style="border-top:2px solid #3c639c">
	  				<script type="text/javascript">
	  					createIBSheet("mySheet", "100%", "150px");
	  				</script>
	  			</div>
	  		</div>	
	  		<% } %>
	</div>
</body>
</html>
