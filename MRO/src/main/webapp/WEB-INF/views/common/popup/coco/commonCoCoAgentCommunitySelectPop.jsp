<%--
**********************************************
* 메뉴 : 
* 화면 : 협력사 커뮤니티 조회팝업
* 기능 : 협력사 커뮤니티 조회팝업
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
	String st_from_date = CommonUtil.nvl((String) request.getParameter("st_from_date"), "");
	String st_to_date = CommonUtil.nvl((String) request.getParameter("st_to_date"), "");
	String com_code = CommonUtil.nvl((String) request.getParameter("com_code"),"");  //  조회조건
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
						{Align : "Center", SaveName :"SELECTED",     Header:"선택",	Hidden:true,			Type : "Radio",     Width : 30,      Edit : true}
						,{ Align:"Center",	Width:150,	Edit:false,	EditLen:300,	Type:"Text",	 FontColor:"#003694", Header:"협력사명",	SaveName:"AGENT_NAME"  }
						,{ Align:"Center",	Width:120,	Edit:false,	EditLen:300,	Type:"Date",	  Header:"등록일",	SaveName:"ADD_DATM"  }
						,{ Align:"Center",	Width:70,	Edit:false,	EditLen:25,	Type:"Text",	Header:"관리유형",	SaveName:"TYPE_NAME" }
						,{ Align:"Center",	Width:70,	Edit:false,	EditLen:300,	Type:"Text",	Header:"등록자",	SaveName:"USER_NAME"}
						,{ Align:"Center",	Width:40,	Edit:false,	EditLen:25,	Type:"Text",	Header:"분류",	SaveName:"REVISION_TYPE"}
						,{ Align:"Left",	Width:315,	Edit:false,	EditLen:25,	Type:"Text",	Header:"내용",	SaveName:"CONTENTS" }
						,{ Align:"Center",	Width:60,	Edit:false,	EditLen:25,	Type:"Text",	Header:"회사코드",	Hidden:true,	SaveName:"AGENT"}
						,{ Align:"Center",	Width:60,	Edit:false,	EditLen:25,	Type:"Text",	Header:"사용자아이디",	Hidden:true,	SaveName:"USER_ID"}
						,{ Align:"Center",	Width:60,	Edit:false,	EditLen:25,	Type:"Text",	Header:"차수",	Hidden:true,	SaveName:"REVISION"}
						,{ Align:"Center",	Width:60,	Edit:false,	EditLen:25,	Type:"Text",	Header:"관리유형코드",	Hidden:true,	SaveName:"TYPE"}
						,{ Align:"Center",	Width:60,	Edit:false,	EditLen:25,	Type:"Text",	Header:"순번",	Hidden:true,	SaveName:"SEQ"}
						,{ Align:"Center",	Width:60,	Edit:false,	EditLen:25,	Type:"Text",	Header:"댓글수",	Hidden:true,	SaveName:"COMMENT_COUNT"}
	];
	
	initsheet.Cfg = {MergeSheet:msHeaderOnly,FrozenCol:0};
	IBS_InitSheet(mySheet, initsheet,pagingMode);
	
	//하이퍼링크 설정
	setLinkCol(mySheet, "CONTENTS");
	
	// 조회조건 초기화
	kepSetCalender("st_from_date");
	kepSetCalender("st_to_date");

	$("#st_from_date").val( kepToDateAdd("7","M"));
	$("#st_to_date").val( kepGetNowTimeStr('YYYYMMDD','/'));
	
	kepAjaxCommonQueryIdCombo('st_gubun_code','getAgentTypeList','ALL2','');	// 관리유형 리스트
	doAction('search');
	
}

//기능함수
function doAction(str) {
	
	var st_agent_code = TrimCommon($("#com_code").val());
	
	switch (str) {
		case "search":	 // 내용 조회
			current_page = -1;
	        if(st_agent_code == "" && (document.getElementById("st_date_flag_check").checked == true || kepGetDateDiff('st_from_date','st_to_date','D') > 93))
	        {
	        	alert("조회기간을 3개월 단위로 조회가 가능합니다.");
				return;
	        }
	    	setCheckBox();
			kepSearch(document.searchCondition,  mySheet , "/mdcp/getMasterMdCpAgentCommunityPopList.do" , pagingMode );
			break;
		case "companyInfo":	// 회사정보 조회
			$('#searchCondition').attr("action", "/mdcp/getMasterMdCpAgentCommunityInfoList.do").submit();
			break;
	}
}

//팝업함수호출
function doPop(str) {
	
	var st_agent_code = TrimCommon($("#com_code").val());
	var st_agent_name = TrimCommon($("#com_name").val());
	switch (str) {
		case "seller": // 협력사
			openSearchPopup("/common/icomcmpyPop.do", "?BUSINESS_COND=S&MULTI=N", "500,466,no");
			popupSel = "seller";
			break;
		case "kepManagerPop":				// Kep담당자
			openSearchPopup("/mdcp/getMasterMdCpUserChoicePop.do", "?st_buyer=KRKORE0001", "500,500,no");
			popupSel = "kepManagerPop";
			break;
		case "reg":	// 등록
			if(st_agent_code == ""){
				alert("협력사를 선택해 주십시오.");
				return;
			}
			openSearchPopup("/mdcp/searchMasterMdCpAgentCommunityDetailList.do","?com_code="+st_agent_code+"&com_name="+st_agent_name+"&st_comment_flag=N", "600,450,no");
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
	if (current_page==-1) {
		makePageIndex2( mySheet , 1 , document.searchCondition.onepagerow.value);
	} else {
		makePageIndex2( mySheet , current_page , document.searchCondition.onepagerow.value);	
	}
}

//내용 수정 후 처리
function mySheet_OnChange(Row, Col, Value) {

	if ( Row  < 1) return;

	var column = mySheet.ColSaveName(Col);
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
}

//트랜젝션(저장,삽입등) 후처리
function mySheet_OnSaveEnd(code, msg, stCode) {
	loader_obj("N");
	if(!checkedSession(stCode)){return;}
	if ( msg != "" ) {
		alert(msg.msg);
	}
	if ( code > 0 ) {
		//내용 저장 성공시 처리
		doAction('search');
	}
}

//페이지 인덱스 클릭시 재조회
function pageSearch(param){
	//조회
	current_page = param.page;
	kepSearch(document.searchCondition ,  mySheet , "/mdcp/getMasterMdCpAgentCommunityPopList.do?page="+current_page , pagingMode );
}

// 그리드 셀클릭 이벤트
function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	if ( Row  < 1) return;
	var column = mySheet.ColSaveName(mySheet.GetSelectCol());
	grbRow = Row;		//현재 Row를 전역변수에 셋팅
	if(column == 'CONTENTS'){ // 내용
		var st_agent = mySheet.GetCellValue(Row,"AGENT");
		var st_comment_count = mySheet.GetCellValue(Row,"COMMENT_COUNT");	// 댓글 체크
		var st_seq = mySheet.GetCellValue(Row,"SEQ");
		var st_revision = mySheet.GetCellValue(Row,"REVISION");
		var st_edit_yn =  "";
		if(st_revision == 0){
			if(st_comment_count > 0){ //댓글이 있는 경우 수정 불가.
				st_edit_yn =  "N";
			}else{
				st_edit_yn =  "Y";
			}
			openSearchPopup("/mdcp/searchMasterMdCpAgentCommunityDetailList.do","?com_code="+st_agent+"&SEQ="+st_seq+"&st_comment_flag=Y"+"&st_edit_yn="+st_edit_yn, "600,630,no");
		}else{
			var st_comment_user_id = mySheet.GetCellValue(Row,"USER_ID");
			var st_login_user_id = TrimCommon($("#st_user_id").val());
			if(st_login_user_id == st_comment_user_id){ //본인인 경우 삭제 가능.
				st_edit_yn =  "Y";
			}else{
				st_edit_yn =  "N";
			}
			openSearchPopup("/mdcp/searchMasterMdCpAgentCommunityCommentDetail.do","?com_code="+st_agent+"&SEQ="+st_seq+"&st_comment_revision="+st_revision+"&st_edit_yn="+st_edit_yn+"&st_comment_count="+st_comment_count, "600,350,no");
		}
		
	}
	
	return;
}

//콜백함수(파일명은 모두 동일)
function setPopupReturn(code, text){
	
	if (popupSel == "seller") { //협력사	
		$("#com_code").val(code);
		$("#com_name").val(text);
    	doAction('companyInfo');
	}else if( popupSel == "kepManagerPop") { // 등록자
		$("#st_kep_user_id").val(code);
		$("#st_kep_user_name").val(text);
	}
}

// 기간무시
function setCheckBox(){
	if (document.getElementById("st_date_flag_check").checked == true) {
    	$("#st_date_flag").val("Y");
    }else{
    	$("#st_date_flag").val("");
    }
	
	if (document.getElementById("st_comment_flag_check").checked == true) {
    	$("#st_comment_flag").val("Y");
    }else{
    	$("#st_comment_flag").val("N");
    }
}

// 초기화 후 
function eraser(code,name){
	var _code = "#" + code;
	var _name = "#" + name;
	$(_code).val("");
	$(_name).val("");
	doAction('companyInfo');
}

 //-->
</script> 
<body onload="kep_onload_view()">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:594px;">
    	<div id="popHeader">
        	<h1 class="title">협력회사 커뮤니티 조회</h1>
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
	            <!--조회영역-->
	            <div id="cont_searchA">
	            	<table class="cont_t_list01" style="width:100%">
						<caption>협력회사 커뮤니티 조회</caption>
						<colgroup>
							<col width="90px" />
							<col width="25%" />
							<col width="110px" />
							<col width="25%" />
							<col width="95px" />
	                        <col width="20%" />
						</colgroup>
						<tbody>
						<%
							Map<String,String> rowData = null;
							for (int j=0; j<_gridList.size(); j++) {
								rowData = _gridList.get(j);
						%> 
							<tr>
								<th>협력사</th>
								<td>
			                        <input type="text" class="input_type_text" name="com_name" id="com_name" style="width:60%;" value="<%=CommonUtil.nvl(rowData.get("COM_NAME"))%>"; READONLY>
			                        <a href="javascript:doPop('seller');"><img src="/resources/images/btn_search03.gif"></a>
			                        <a href="javascript:eraser('com_code','com_name');"><img src="/resources/images/btn_eraser2.gif"></a>
	                            </td>
								<th>등록기간</th>
								<td colspan="4">
									<input type="text" name="st_from_date" id="st_from_date" readOnly style="width:15%; text-align:center;" > - 
									<input type="text" name="st_to_date" id="st_to_date" readOnly style="width:15%; text-align:center;" > 
									&nbsp;
									<input type="checkbox"  class="Noborder" name="st_date_flag_check" id="st_date_flag_check">&nbsp;기간무시
									<input type="hidden" name="st_date_flag" id="st_date_flag" style="width:70%" value="">
								</td>
							</tr>
							<tr> 
								<td>회사코드</td>
								<td>
									<%=CommonUtil.nvl(rowData.get("COM_CODE"))%>
									<input type="hidden" name="com_code" id="com_code" style="width:70%" value="<%=CommonUtil.nvl(rowData.get("COM_CODE"))%>"> 
								</td>
								<td>사업자번호</td>
								<td>
									&nbsp;<%=CommonUtil.nvl(rowData.get("IRS_NO"))%>
								</td>
								<td>대표자명</td>
								<td>
									<%=CommonUtil.nvl(rowData.get("CEO_NAME"))%>
								</td>
							</tr>
							<tr> 
								<td>회사주소</td>
								<td colspan="6">
									<%=CommonUtil.nvl(rowData.get("ADDRESS"))%>
								</td>
							</tr>
							<% } %>
							<tr> 
								<td>관리유형</td>
								<td class ="font1_table_font" >
			                    	<select id="st_gubun_code" name="st_gubun_code" style="width:90%;height:20px"></select>
			                    </td>
								<td>등록자</td>
								<td>
									<input type="text" class="input_type_text"  name="st_kep_user_name" id="st_kep_user_name" style="width:40%;" value="" READONLY>
									<input type="hidden" name="st_kep_user_id" id="st_kep_user_id" style="width:70%" value="">
									<a href="javascript:doPop('kepManagerPop',  '<%=__sessionInfo.getComCode()%>');"><img src="/resources/images/btn_search03.gif"></a>
									<a href="javascript:kepEraser('st_kep_user_id','st_kep_user_name');"><img src="/resources/images/btn_eraser2.gif"></a> 
								</td>
								<td>
									<input type="checkbox"  class="Noborder" name="st_comment_flag_check" id="st_comment_flag_check">&nbsp;덧글포함
									<input type="hidden" name="st_comment_flag" id="st_comment_flag" style="width:70%" value="">
								</td>
								<td>
									<div id="searchBtnA02">
							        	<span class="btn_search"><a href="javascript:doAction('search')">조회</a></span> 
									</div>
								</td>
							</tr>
						</tbody>
					</table>
	            </div>
	            <span class="fl"><img src="/resources/images/txt_no.gif" alt="정렬개수" style="padding-top:3px;"/>
	               	<label for="b_no02" class="hidden">정렬개수선택</label>
						<select name="onepagerow" style="width: 70px;" >
						<option value="10" selected>10건</option>
						<option value="20">20건</option>
						<option value="30">30건</option>
						<option value="40">40건</option>
						<option value="50">50건</option>
						</select>
				</span>
				</br>
            </form>
            
           	<!--grid-->
            <div>
            	<div class="ib_product" style="border-top:2px solid #3c639c">
	  				<script type="text/javascript">
	  					createIBSheet("mySheet", "100%", "354px");
	  				</script>
	  			</div>
	  			<p class="paging" id="pageindex"></p>
  				<!--버튼영역-->
               <div class="btnArea02" >
  	          	<span class="fr">
  					<span class="btn_02 mr04"><a href="javascript:doPop('reg');">등록</a></span>
  				</span>
  			 </div>
        	</div>
    	</div>
	</div>
</body>
</html>
