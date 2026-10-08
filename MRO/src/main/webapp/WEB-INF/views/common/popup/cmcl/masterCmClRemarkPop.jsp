<%--
**********************************************
* 메뉴 : 마감집계팝업
* 화면 : 비고 팝업
* 기능 : 
* 프로그램 ID : PG_10_M_006_01
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
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>비고 입력</title>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
<script src="/resources/libs/ibsheet7/js/ibsheet.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibsheetinfo.js" type="text/javascript"></script>
<script src="/resources/libs/ibsheet7/js/ibleaders.js" type="text/javascript"></script> 
</head>

<script>
// 팝업 초기화 함수
function kep_onload_view(){
	document.forms[0].st_deadline_remark.value = opener.document.forms.contentCondition.sel_remark.value;
	$("#st_deadline_remark").focus();
	$("#st_deadline_remark").select();
}

// 특수문자 필터링
function FilterString(val){

    var str= "";

    // 특수문자 아스키코드 값
    // $    ==> 36
    // '    ==> 39
    // "    ==> 34
    // ^    ==> 94

    for ( var i = 0; i < val.length; i++ ) {

    //  alert(val.charCodeAt(i));

        if ( val.charCodeAt(i) == 36 ) {

            str += val.charAt(i).replace("$", "＄");

        } else if ( val.charCodeAt(i) == 39 ) {

            str += val.charAt(i).replace("'", "′");

        } else if ( val.charCodeAt(i) == 34 ) {

            str += val.charAt(i).replace("\"", "″");

        } else if ( val.charCodeAt(i) == 94 ) {

            str += val.charAt(i).replace("^", "＾");

        } else if ( val.charCodeAt(i) == 60 ) {

            str += val.charAt(i).replace("<", "〈");

        } else if( val.charCodeAt(i) == 62 ) {

            str += val.charAt(i).replace(">", "〉");

        } else {

            str += val.charAt(i);

        }
    }

    return str;
}

function kepConfirm()
{
    var value = FilterString(document.forms[0].st_deadline_remark.value);
    opener.setPopupReturn(value);
    this.close();
}
</script> 
<body onload="kep_onload_view();">
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	
	<div id="popWrapper" style="height:250px;">
    	<div id="popHeader">
        	<h1 class="title">비고</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
            <!--grid-->
 			<div style="border:1px solid #3c639c">
				<textarea id="st_deadline_remark" name="st_deadline_remark" rows="10" cols="82" style="auto:overflow;border-width:0;"></textarea>
			</div>
		</div>	
        <!--버튼영역-->
        <div class="btnArea mr25">
			<span class="fr">
				<span class="btn_02"><a href="javascript:kepConfirm()">확인</a></span>
			</span>
       </div>
        
    </div>
</form> 
</body>
</html>
