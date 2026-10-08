<%--
**********************************************
* 메뉴 : 신규견적의뢰 > 기초데이터입력 화면
* 화면 : 견적 기초데이타 입력
* 기능 : 견적 기초데이타 입력
* 프로그램 ID : PG_04_B_003_04
* 담당자 : 김영미 ( 설계 : 권우재 )
* 착수일 : 2014-09-02
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
<link rel="stylesheet" href="/resources/styles/buyer_layout.css" type="text/css" />
<link rel="stylesheet" type="text/css" media="screen"	href="/resources/libs/jquery/css/smoothness/jquery-ui.min.css"/>   
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 
SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String remark		= CommonUtil.nvl(request.getParameter("st_remark"));  
String l_remark[]; 
String tmp []		= CommonUtil.StrToArray(remark,"@@");

if(tmp.length == 0){
	l_remark = new String [5];
}else{
	l_remark = tmp;
System.out.println(l_remark);
} 

%>

<script type="text/javascript">
function kep_onload_view(){

}
function setBuyerUserRemark() { 
	var remark =""; 
	for(var i=1; i<=5; i++){
		var tmp = eval("document.buyerMpRqUserRemarkPop.st_remark"+i).value;
		if(tmp=="") tmp = " ";
		remark += tmp + "@@"; 
	} 
	opener.setPopupReturn(remark);
	this.close(); 
}

</script> 
<body onload="kep_onload_view();">
<form name="buyerMpRqUserRemarkPop" id="buyerMpRqUserRemarkPop" method=post >
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:282px;">
    	<div id="popHeader">
        	<h1 class="title">견적 기초데이타 입력</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer" style="height:207px;">
            <!--조회영역-->
            <div id="cont_searchA">
            	<table class="cont_t_list01" style="width:100%">
						<caption>리스트</caption>
						<colgroup>
							<col width="40%" />
							<col width="60%" />
						</colgroup>						
						<tbody>
						<tr>
							<th>문서번호</th>
							<td> 
								<input type ="text" name ="st_remark1" id="st_remark1" value="<%=CommonUtil.nvl(l_remark[0])%>">
                            </td>
						</tr>					 
						<tr>
							<th>전표번호</th>
							<td> 
								<input type ="text" name ="st_remark2" id="st_remark2" value="<%=CommonUtil.nvl(l_remark[1])%>">
                            </td>
						</tr>					 
						<tr>
							<th>불출코드</th>
							<td> 
								<input type ="text" name ="st_remark3" id="st_remark3" value="<%=CommonUtil.nvl(l_remark[2])%>">
                            </td>
						</tr>					 
						<tr>
							<th>원가코드</th>
							<td> 
								<input type ="text" name ="st_remark4" id="st_remark4" value="<%=CommonUtil.nvl(l_remark[3])%>">
                            </td>
						</tr>					 
						<tr>
							<th>발생월</th>
							<td> 
								<input type ="text" name ="st_remark5" id="st_remark5" value="<%=CommonUtil.nvl(l_remark[4])%>">
                            </td>
						</tr>					 
					</tbody>
				</table>
            </div>    
            <div class="btnArea mt10">
            	<span class="btn_04"><a href="javascript:setBuyerUserRemark();">확인</a></span>	
            </div>        
    </div>        
</div>
</form> 
</body>
</html>
