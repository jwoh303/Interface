<%--
**********************************************
* 메뉴 : 
* 화면 : 생산계획표 보기
* 기능 : 생산계획문서 다운로드 제공
* 프로그램 ID : PG_07_M_004_01
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
<head>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" /> 
<link rel="stylesheet" type="text/css" media="screen"	href="/resources/libs/jquery/css/redmond/jquery-ui.min.css"/>   
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
 
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
Map<String,String> formData = null;
if (_dataList==null || _dataList.size()==0){	
}else{
	formData = _dataList.get(0);
}

SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
String SessionUserId        = (String) _sessionInfo.getUserId();

%>

<script>

function kep_onload_view(){
	
	viewProductionPlan();
}



function reFresh(){
 
 top.document.location.reload();

}
//생산계획표 보기
function viewProductionPlan(){  
	var src ="";
	 var commUrl = "<%= CommonUtil.getURL(request) %>"; 
 if(document.forms[0].st_status[0].checked)//동부한농화학(주) 구미공장
 {
      src = commUrl+"/resources/excel/company/DONGBU/makingplan/2009_gumi_plan.xls";
 }
 else if(document.forms[0].st_status[1].checked)//동부한농화학(주) 인천공장
 {
     src = commUrl+"/resources/excel/company/DONGBU/makingplan/2009_incheon_plan.xls";
 }
 else if(document.forms[0].st_status[2].checked)//동부정밀화학(주) 전주공장
 {
     src = commUrl+"/resources/excel/company/DONGBU/makingplan/2009_jeonju_plan.jpg";
 }else {
     src = commUrl+"/resources/excel/company/DONGBU/makingplan/2009_gumi_plan.xls";
	}
 
 document.forms[0].target = "cen_f";
 document.forms[0].method = "post";
 document.forms[0].action = src;
 document.forms[0].submit();
}

function changeExcel(){
 var protocol = location.protocol;
 var host = location.host;
 var addr = protocol +"//" +host;
 
 win = window.open("/kr/buyer/common/popup/dongbu_plan_up.jsp","fileattach",'left=0,top=0, width=620, height=150,toolbar=no, menubar=no, status=no, scrollbars=no, resizable=no');
}



//확인
function kepConfirm()
{ 
 var value1 = mySheet.GetCellValue(grbRow, "BUYER")+"@";
 var value2 = mySheet.GetCellValue(grbRow, "BUYER_NAME");
 
 opener.setPopupReturn(value1,value2);
 
 this.close();
}
</script> 
<body onload="kep_onload_view();">
<form>
	<div id="popWrapper" style="height:204px;">
    	<div id="popHeader">
        	<h1 class="title">생산계획표 보기</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
            <!--조회영역-->
        	<div id="cont_searchA">
            	<table class="cont_t_list01" style="width:100%">
<!-- 						<caption>조회</caption> -->
<!-- 						<colgroup> -->
<!-- 							<col width="150" /> -->
<!-- 							<col width="150" /> -->
<!-- 							<col width="150" /> -->
							
<!-- 						</colgroup> -->
						<tbody>
						<tr>
		                    <td height=32>&nbsp;&nbsp;공장별 생산계획표</td>
		                    <td height=32>&nbsp;&nbsp;
		                        <input id="check" type="radio" name="st_status" value = ""  onClick = "viewProductionPlan();" checked >동부한농화학(주) 구미공장&nbsp;&nbsp;&nbsp;
		                        <input id="check" type="radio" name="st_status" value = ""  onClick = "viewProductionPlan();"         >동부한농화학(주) 인천공장&nbsp;&nbsp;&nbsp;
		                        <input id="check" type="radio" name="st_status" value = ""  onClick = "viewProductionPlan();"         >동부정밀화학(주) 전주공장&nbsp;&nbsp;&nbsp;
		                    </td>
							<% if(SessionUserId.equals("CC8587")) { %>
		                    <td>
		                        <a href="javascript:changeExcel()">생산계획표 변경</a>
		                    </td>
							<% } %>
                		</tr>
					</tbody>
				</table>
            </div>
		</div>	
        
    </div>
</form> 
</body>
</html>
