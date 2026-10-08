<%--
**********************************************
* 메뉴 : 
* 화면 : 반품관리 > 반품일괄종결 > TR 일괄출고방법 팝업
* 기능 : 반품관리 반품일괄종결 시 TR 일괄출고방법 선택
* 프로그램 ID : 
* 담당자 : HSJ
* 착수일 : 2016-12-30
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
    SessionInfo _sessionInfo = (SessionInfo)request.getSession().getAttribute("sessionInfo");
	String userid = "";
	
	if (_sessionInfo != null){
		userid =  CommonUtil.nvl((String)_sessionInfo.getUserId());  		
	} 
	
	List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	Map<String,String> _rowData = null;
	
	if (_dataList != null && _dataList.size() != 0) { 
		_rowData = _dataList.get(0);
	}	
%>
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

<script>
var mySheet = new ibsheetObject();
var pagingMode = "N"; 	// Y: 번호 페이징, N : 스크롤
var popupSel = "";

//확인
function kepConfirm(){
	var value1 = document.searchCondition.st_w_ivk_type.value;
	
	if(value1 == ""){
		alert("일괄 반출방법을 선택해 주세요.");
		return;
	}
	
	opener.setPopupReturn(value1);
	this.close();
}

</script> 
<body onload="">
<form name = "searchCondition"  id = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
	<input type="hidden" id="st_user_id"  name="st_user_id" value="${sessionInfo.userId}">
	<div id="popWrapper" style="height:100%;">
    	<div id="popHeader">
        	<h1 class="title">반품 물류센터 일괄 출고방법</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        
        <!--팝업내용입니다-->
        <div id="popContainer"  style="height:463px">
        	<!--버튼영역-->
            <!--조회영역-->
            <table class="cont_t_list03" style="width:100%">
				<caption>조회</caption>
				<colgroup>
					<col width="40%"/>
					<col width="*"/>
				</colgroup>
				<tbody>
					<tr>
						<td class="al">&nbsp;물류센터 출고방법</td>
						<td class="al">
						<select name="st_w_ivk_type" id= "st_w_ivk_type" style="width:90%;height:20px">
							getCodeComboQueryIdList(String queryId,String gubun,Map<String, String> search,String dataValue)
							<%=CommonUtil.getCodeComboQueryIdList("common.getTypeWM06","SEL","")%>
						</select></td>
					</tr>
				</tbody>
			</table>
				
            <!--grid-->
			<span class="fr">
				<span class="btn_02 mr04"><a href="javascript:kepConfirm()">저장</a></span>
			</span>
		</div>
    </div>
</form> 
</body>
</html>
