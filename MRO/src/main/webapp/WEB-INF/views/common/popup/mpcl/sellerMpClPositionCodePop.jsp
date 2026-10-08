<%--
**********************************************
* 메뉴 : 관리자>코드관리>직급코드
* 화면 : 직급코드 팝업
* 기능 : 
* 프로그램 ID : 
* 담당자 : 최명진 ( 설계 : 공통 )
* 착수일 : 2014-
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
<%@ include file="../../../common/include/head_pop.jspf"%>
</head>
<%
	@SuppressWarnings (value="unchecked")
	Map<String,String> _paramMap = (Map<String,String>) request.getAttribute("param"); // 전달된 파라미터
	
	String kind = _paramMap.get("kind");
	String readOnly = "";
	String _code = "";
	String _text1 = "";
	String _text2 = "";
	
	if ( !"insert".equals(kind) ) {
		Map<String,String> _dataMap = (Map<String,String>) request.getAttribute("data"); // 조회된 결과 
		readOnly = "disabled";
		_code = CommonUtil.nvl(_dataMap.get("CODE"));
		_text1 = CommonUtil.nvl(_dataMap.get("TEXT1"));
		_text2 = CommonUtil.nvl(_dataMap.get("TEXT2"));
	}
%>
<body onload="">
<form name="sellerMpClPositionCodePop" id="sellerMpClPositionCodePop" method=post >
	<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
	<input type="hidden" id="st_user_id"  name="st_user_id" value="${sessionInfo.userId}">
	<input type="hidden" id="kind"  name="kind" value="<%=kind%>">
	<input type="hidden" id="st_type"  name="st_type" value="C003">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:250px;">
    	<div id="popHeader">
        	<h1 class="title">직급코드 등록</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
            <div id="searchBtnA02"></div>   
           	<!--grid-->
            <div class="scrollArea" style="height:140px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>직급코드 등록</caption>
                    <colgroup>
                        <col width="30%" />
                        <col width="70%" />
                    </colgroup>
                    <tbody>
                        <tr>
                    		<th>코드</th>
                    		<td class="left pl20">
                    			<input type="text" id="st_code_text" name="st_code_text" size="12" maxlength=10 value="<%=_code%>" <%=readOnly%>>
                    			<input type="hidden" id="st_code" name="st_code" size="12" maxlength=10 value="<%=_code%>">
                    		</td>
                        </tr>
                        <tr>
                    		<th>직급명(국문)</th>
                    		<td class="left pl20">
                    			<input type="text" id="st_text1" name="st_text1" size="35" maxlength=200 value="<%=_text1%>">
                    		</td>
                        </tr>
                        <tr>
                    		<th>직급명(영문)</th>
                    		<td class="left pl20">
                    			<input type="text" id="st_text2" name="st_text2" size="35" maxlength=200 value="<%=_text2%>">
                    		</td>
                        </tr>
                        </tr>
                    </tbody>
                </table>                  
	        </div>
	    </div>
	   <!--버튼영역-->
        <div class="btnArea mr25">
			<span class="fr">
				<span class="btn_02"><a href="javascript:doAction('save')">저장</a></span>
<%
	if ( !"insert".equals(kind) ) {
%>
				<span class="btn_02"><a href="javascript:doAction('delete')">삭제</a></span>
<%
	}
%>
			</span>
       </div>
	</div>
</form> 
</body>

<script type="text/javascript">
// 최초 화면 함수 
function kep_onload_view(){
	// TO-DO
}

var st;

// 기능함수
function doAction(str) {
	switch (str) {
		case "search": //조회
			break;
			
		case "save": //저장
			// 조회조건 체크
			if ( !saveValidate() )
				return;
			if ( "insert" == "<%=kind%>" ) {
				if ( !confirm("직급코드를 저장하시겠습니까?") ) { 
					return;
				} 
				kepAjaxFormCall("/mpcl/insertSellerMpClPositionCodePop.do", "sellerMpClPositionCodePop", "<%=kind%>");
			} else if ( "update" == "<%=kind%>" ) {
				if ( !confirm("직급코드를 수정하시겠습니까?") ) { 
					return;
				} 
				kepAjaxFormCall("/mpcl/updateSellerMpClPositionCodePop.do", "sellerMpClPositionCodePop", "<%=kind%>");
			}
			break;
			
		case "delete": //삭제
			if ( !confirm("직급코드를 삭제하시겠습니까?") ) { 
				return;
			} 
			kepAjaxFormCall("/mpcl/delSellerMpClPositionCodePop.do", "sellerMpClPositionCodePop", str);
			break;
	}
}

function saveValidate() {
    if ( kepIsValueNull(kepTrimStr($("#st_code_text").val())) ) {
        alert("직급 코드를 반드시 입력하세요.");
        $("#st_code_text").focus();
        return false;
    } else {
    	$("#st_code").val( $("#st_code_text").val() );
    }

    if ( kepIsValueNull(kepTrimStr($("#st_text1").val())) ) {
        alert("직급 국문명을 반드시 입력하세요.");
        $("#st_text1").focus();
        return false;
     }

    return true;
}

// ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	var MSG = response.msg;
	
	if ( MSG == "Duplicate" ) {
		alert("직급코드가 이미 등록되어 있습니다.\n\n다시 확인하여 주십시요.");
		return;
		
	} else if ( MSG == "Fail" ) {
		if ( pMethod == "insert" ){
			alert("직급코드 추가 중 에러가 발생했습니다.");
		}
		else if ( pMethod == "update" ){
			alert("직급코드 수정 중 에러가 발생했습니다.");
		}
		else if ( pMethod == "delete" ){
			alert("직급코드 삭제 중 에러가 발생했습니다.");
		}
		
	} else if ( MSG == "Fail" ) {
		if ( pMethod == "insert" ){
			alert("직급코드 입력이 정상적으로 완료되었습니다.");
		}
		else if ( pMethod == "update" ){
			alert("직급코드 수정이 정상적으로 완료되었습니다.");
		}
		else if ( pMethod == "delete" ){
			alert("직급코드 삭제가 정상적으로 완료되었습니다.");
		}
		
	}
	
	alert(MSG);
	opener.setPopupReturn();
	this.close();
}

// ajax 공통 호출후 에러시 처리 함수
function kepAjaxError(pMethod , response) {
	if ( pMethod == "insert" ){
		alert("직급코드  입력이 실패 하였습니다. 다시 확인하여 주십시요");
	}
	else if ( pMethod == "update" ){
		alert("직급코드  수정이 실패 하였습니다. 다시 확인하여 주십시요");
	}
	else if ( pMethod == "delete" ){
		alert("직급코드  삭제가 실패 하였습니다. 다시 확인하여 주십시요");
	}
}
</script>
</html>
