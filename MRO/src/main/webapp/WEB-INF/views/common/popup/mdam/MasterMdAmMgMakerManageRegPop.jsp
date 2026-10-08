<%--
**********************************************
* 메뉴 : 
* 화면 : 대표 제조사 등록
* 기능 : 대표 제조사 등록
* 프로그램 ID : 
* 담당자 : 현명환 
* 착수일 : 
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

<script>
//기능함수
function doAction(str) {
	switch (str) {
		case "reg": //등록
		    var reg_text1 = $("#st_reg_text1").val();
		    if(reg_text1==""){
		        alert("대표 제조사명을 입력해 주십시요.");
		        $("#st_reg_text1").focus();
		        return;
		    }
			if (!confirm('대표 제조사를 등록 하시겠습니까?'))
				return;
			kepAjaxFormCall("/mdam/regMasterMdAmMgMakerManageRegPop.do", "contentForm", "reg");
		break;

	}
}

function kepAjaxSuccess(pMethod , response){
	var closeflag = true;
	if (pMethod == "reg"){
		alert("등록이 성공적으로 이루어 졌습니다. ");
		self.close();
	}
}
/**
 * ajax 공통 호출후 에러시 처리 함수
 */
function  kepAjaxError(pMethod , response) {
	if (pMethod == "1"){
		alert("등록이 실패하였습니다.\n\n다시 한 번 시도해 주시기 바랍니다.  "); 
	}
} 


</script> 
<form name = "contentForm" id = "contentForm" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<div id="popWrapper" style="height:554px;">
    	<div id="popHeader">
        	<h1 class="title">대표 제조사 등록</h1>
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
					          <th  height="30">대표 제조사명</th>
					          <td >
					            <input type="text" name="st_reg_text1" id="st_reg_text1"  style="width:95%" value="">
					          </td>
					        </tr>
					</tbody>
				</table>
            </div>
	        <!--버튼영역-->
	        <div class="btnArea mr25">
				<span class="fr">
					<span class="btn_02 mr04"><a href="javascript:doAction('reg');">등록</a></span>
				</span>
	       </div>
		</div>	
    </div>
</form> 
</body>
</html>
