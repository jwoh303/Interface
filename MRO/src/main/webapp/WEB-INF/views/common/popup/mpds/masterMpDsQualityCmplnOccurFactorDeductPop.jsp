<%--
**********************************************
* 메뉴 : 
* 화면 : 품질불만 발생요인별 감점
* 기능 : 품질검사 감점기준표 팝업
* 프로그램 ID : PG_07_M_006_02
* 담당자 : 개발2 ( 설계 : 김지현 )
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
</head>

<script>
//시트 초기화 함수 (반드시 OnLoad 이벤트에서 호출)
function kep_onload_view() {
	
}

</script> 
<body onload="kep_onload_view();">
<form name = "searchCondition" method = "post" onsubmit="return false" >
	<input type="hidden" name="s_SAVENAME">
	<input type="hidden" id="pageflag"  name="pageflag" value="1">
	<input type="hidden" id="onepagerow"  name="onepagerow" value="10">
	<input type="hidden" id="USER_ID"  name="USER_ID" value="${sessionInfo.userId}">
	
	<div id="popWrapper" style="height:474px;">
    	<div id="popHeader">
        	<h1 class="title">품질불만 발생요인별 감점</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
            	<table class="cont_t_list06" style="width:100%">
						<caption>조회</caption>
						<colgroup>
							<col width="8%" />
							<col width="20%" />
							<col width="12%" />
							<col width="60%" />
							
						</colgroup>
						
						<tbody>
					        <tr >
					          <th height="25" colspan="2" ><b>항목</b></th>
					          <th height="25" ><b>감점</b></th>
					          <th height="25" ><b>정의</b></th>
					        </tr>
					        <tr>
					          <th height="155" rowspan="9" ><b>검사<br>항목</b></th>
					          <th height="25"><b>외관</b></th>
					          <th>2.0</th>
					          <td >문안,도안,인쇄상태,색상,성형상태 등을 포함한 외형상태</td>
					        </tr>
					        <tr>
					          <th height="25"><b>사이즈</b></th>
					          <th class="right">1.0</th>
					          <td >포장재료의 가로,세로 또는 높이</td>
					        </tr>
					        <tr>
					          <th height="25"><b>재질</b></th>
					          <th class="right">1.0</th>
					          <td class="font1_tab량_7">포장재료를 구성하고 있는 성분</td>
					        </tr>
					        <tr>
					          <th height="25"><b>중량</b></th>
					          <th class="right">1.0</th>
					          <td >포장재료의 무게</td>
					        </tr>
					        <tr>
					          <th height="25"><b>용량</b></th>
					          <th class="right">1.0</th>
					          <td >포장재료의 부피</td>
					        </tr>
					        <tr>
					          <th height="25"><b>두께</b></th>
					          <th class="right">1.0</th>
					          <td >게이지로 즉정되는 포장재로의 두께</td>
					        </tr>
					        <tr>
					          <th height="25"><b>압축강도</b></th>
					          <th class="right">1.0</th>
					          <td >상자를 조립한 후 상자의 윗면에서 수직방향으로 힘을<br>가할때 상자가 파손되기 시작하는 점의 하중치</td>
					        </tr>
					        <tr>
					          <th height="25"><b>파열강도</b></th>
					          <th class="right">1.0</th>
					          <td >골판지상자가 취급,수송 등의 과정에서 터짐으로부터<br>견딜수 있는 강도로 측정기 원판위에 시편을 장착후<br>고무막의 압력으로 골판지가 터질때의 강도</td>
					        </tr>
					        <tr>
					          <th height="25" ><b>수분</b></th>
					          <th class="right">1.0</th>
					          <td >게이지로 측정되는 포장재료에 포함된 수분의 량</td>
					        </tr>
					        <tr>
					          <th height="25" colspan="2"><b>합계</b></th>
					          <th class="right" ><b>10.0</b></th>
					          <td>&nbsp;</td>
					        </tr>
					</tbody>
				</table>
		</div>	
        
    </div>
</form> 
</body>
</html>
