<%--
**********************************************
* 메뉴 : 관리자>코드관리>배송차량
* 화면 : 배송차량 팝업
* 기능 : 
* 프로그램 ID : PG_08_A_605_01
* 담당자 : 최명진 ( 설계 : 김상근 )
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
	String _carCode = "";
	String _carNumber = "";
	String _userName = "";
	String _phoneNum = "";
	
	if ( !"insert".equals(kind) ) {
		Map<String,String> _dataMap = (Map<String,String>) request.getAttribute("data"); // 조회된 결과 
		_carCode = CommonUtil.nvl(_dataMap.get("CAR_CODE"));
		_carNumber = CommonUtil.nvl(_dataMap.get("CAR_NUMBER"));
		_userName = CommonUtil.nvl(_dataMap.get("USER_NAME"));
		_phoneNum = CommonUtil.nvl(_dataMap.get("PHONE_NUM"));
		readOnly = "disabled";
	}
%>
<body onload="">
<form name="sellerMpClDlvryCarPop" id="sellerMpClDlvryCarPop" method=post >
	<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
	<input type="hidden" id=st_user_id  name="st_user_id" value="${sessionInfo.userId}">
	<input type="hidden" id=kind  name="kind" value="<%=kind%>">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:250px;">
    	<div id="popHeader">
        	<h1 class="title">[배송차량]</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
            <div id="searchBtnA02"></div>   
           	<!--grid-->
            <div class="scrollArea" style="height:140px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>[배송차량]</caption>
                    <colgroup>
                        <col width="30%" />
                        <col width="70%" />
                    </colgroup>
                    <tbody>
                        <tr>
                    		<th>코드</th>
                    		<td class="left pl20">
                    			<input type="text" id="st_car_code_text" name="st_car_code_text" size="12" maxlength=10 value="<%=_carCode%>" <%=readOnly%>>
                    			<input type="hidden" id="st_car_code" name="st_car_code" size="12" maxlength=10 value="">
                    		</td>
                        </tr>
                        <tr>
                    		<th>차량번호</th>
                    		<td class="left pl20">
                    			<input type="text" id="st_car_number" name="st_car_number" size="35" maxlength=100 value="<%=_carNumber%>">
                    		</td>
                        </tr>
                        <tr>
                    		<th>담당자</th>
                    		<td class="left pl20">
                    			<input type="text" id="st_user_name" name="st_user_name" size="35" maxlength=100 value="<%=_userName%>">
                    		</td>
                        </tr>
                        <tr>
                    		<th>전화번호</th>
                    		<td class="left pl20">
                    			<input type="text" id="st_phone_num" name="st_phone_num" size="35" maxlength=100 value="<%=_phoneNum%>">
                    		</td>
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
				if ( !confirm("배송차량을 저장하시겠습니까?") ) { 
					return;
				} 
				kepAjaxFormCall("/mpcl/insertSellerMpClDlvryCarPop.do", "sellerMpClDlvryCarPop", "<%=kind%>");
			} else if ( "update" == "<%=kind%>" ) {
				if ( !confirm("배송차량을 수정하시겠습니까?") ) { 
					return;
				} 
				kepAjaxFormCall("/mpcl/updateSellerMpClDlvryCarPop.do", "sellerMpClDlvryCarPop", "<%=kind%>");
			}
			break;
			
		case "delete": //삭제
			if ( !confirm("배송차량을 삭제하시겠습니까?") ) { 
				return;
			}
			$("#st_car_code").val( $("#st_car_code_text").val() );
			
			kepAjaxFormCall("/mpcl/delSellerMpClDlvryCarPop.do", "sellerMpClDlvryCarPop", str);
			break;
	}
}

function saveValidate() {
    if ( kepIsValueNull(kepTrimStr($("#st_car_code_text").val())) ) {
        alert("코드를 반드시 입력하세요.");
        $("#st_car_code_text").focus();
        return false;
    } else {
    	$("#st_car_code").val( $("#st_car_code_text").val() );
    }

    if ( kepIsValueNull(kepTrimStr($("#st_car_number").val())) ) {
        alert("차량번호를 반드시 입력하세요.");
        $("#st_car_number").focus();
        return false;
     }

    if ( kepIsValueNull(kepTrimStr($("#st_user_name").val())) ) {
        alert("담당자를 반드시 입력하세요.");
        $("#st_user_name").focus();
		return false;
	}

    if ( kepIsValueNull(kepTrimStr($("#st_phone_num").val())) ) {
        alert("전화번호를 반드시 입력하세요.");
        $("#st_phone_num").focus();
		return false;
	}
    
    return true;
}

// ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	var MSG = response.msg;
	
	if ( MSG == "Duplicate" ) {
		alert("배송차량이 이미 등록되어 있습니다.\n\n다시 확인하여 주십시요.");
		
	} else if ( MSG == "Fail" ) {
		if ( pMethod == "insert" ){
			alert("차량코드 추가 중 에러가 발생했습니다.");
		}
		else if ( pMethod == "update" ){
			alert("차량코드 수정 중 에러가 발생했습니다.");
		}
		else if ( pMethod == "delete" ){
			alert("차량코드 삭제 중 에러가 발생했습니다.");
		}
	} else {
		alert(MSG);
		opener.setPopupReturn();
		this.close();
	}
}

// ajax 공통 호출후 에러시 처리 함수
function kepAjaxError(pMethod , response) {
	if ( pMethod == "insert" ){
		alert("배송차량  입력이 실패 하였습니다. 다시 확인하여 주십시요");
	}
	else if ( pMethod == "update" ){
		alert("배송차량  수정이 실패 하였습니다. 다시 확인하여 주십시요");
	}
	else if ( pMethod == "delete" ){
		alert("배송차량  삭제가 실패 하였습니다. 다시 확인하여 주십시요");
	}
}
</script>
</html>
