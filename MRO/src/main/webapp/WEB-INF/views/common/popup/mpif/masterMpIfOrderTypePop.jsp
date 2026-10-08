<%--
**********************************************
* 메뉴 : I/F 관리>오류현황>오류현황 발주
* 화면 : 발주유형 변경 팝업
* 기능 : 
* 프로그램 ID : PG_11_M_002_06
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
<title>코리아 e 플랫폼</title>
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
// 확인
function kepConfirm()
{
	var value1 = $('input:radio[name="st_type"]:checked').val();
	var value2 = '';
	
	if ( value1 == "N" ) {
		value2 = '일반';
	} else {
		value2 = '선입고';
	}
	
	opener.setPopupReturn(value1, value2);
	this.close();
}
</script> 
<body onload="">
	<div id="popWrapper" style="height:220px;">
    	<div id="popHeader">
        	<h1 class="title">발주유형 변경</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<!--버튼영역-->
            <div id="searchBtnA02"></div>
            
            <!--grid-->
            <div class="scrollArea" style="height:100px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>발주유형 리스트</caption>
                    <colgroup>
                        <col width="35%" /> 
                        <col width="*" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">선택</th> 
                            <th scope="col">발주유형</th> 
                        </tr>
                    </thead>
                    <tbody>
						<tr>
							<td><input id="check" type="radio" name="st_type" value="N" checked></td>
							<td class="pl10">일반</td>
	                    </tr>
						<tr>
							<td><input id="check" type="radio" name="st_type" value="S"></td>
							<td class="pl10">선입고</td>
	                    </tr>
                    </tbody>
                </table>                  
	        </div>
		</div>	
        <!--버튼영역-->
        <div class="btnArea mr25">
			<span class="fr">
				<span class="btn_02 mr04"><a href="javascript:kepConfirm();">확인</a></span>
			</span>
       </div>
        
    </div>
</body>
</html>
