<%--
**********************************************
* 메뉴 : 
* 화면 : 고객사 공지사항 목록
* 기능 : 
* 프로그램 ID : 
* 담당자 : 현명환
* 착수일 : 2015-12-28
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<%@ include file="../../common/include/head.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과   ;
%>

<script type="text/javascript">
function kep_onload_view(){

}

//조회
function kepSearch(curPage){

}

function setIcomboard_List_Display_Sel(btype, bid, com_code, gbn){
	if(gbn =="A"){//고객공지사항
		openSearchPopup("/none/showBuyerNoNeNoticeDetailPop.do", "?st_btype="+btype+"&st_bid="+bid+"&st_buyer="+com_code, "800,600,no");
	}else{//기본값 kep공지사항
		openSearchPopup("/none/showSellerNoNeNoticeDetailPop.do", "?st_btype="+btype+"&st_bid="+bid, "800,600,no");
	}
}
</script> 
<body onload="">
<form name="buyerNoNeNoticeListPop" id="buyerNoNeNoticeListPop" method=post >
<!--HIDDEN-->
<!-- 공통 -->
<input type="hidden" name="codeGubun" id="codeGubun"  value="buyerNoNeNoticeListPop">
<!-- 화면 내 정의 -->
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:504px;">
    	<div id="popHeader">
        	<h1 class="title"><%=CommonLang.get("HTITLE730") %><!-- 공지사항 --></h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
           	<!--grid-->
            <div class="scrollArea" style="height:370px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>공지사항 리스트</caption>
                    <colgroup>
                        <col width="10%" /> 
                        <col width="*" /> 
                        <col width="15%" /> 
                        <col width="15%" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col"><%=CommonLang.get("HTITLE140") %><!-- 순번 --></th> 
                            <th scope="col"><%=CommonLang.get("HTITLE304") %><!-- 제목 --></th> 
                            <th scope="col"><%=CommonLang.get("HTITLE498") %><!-- 작성자 --></th> 
                            <th scope="col"><%=CommonLang.get("HTITLE499") %><!-- 게시일 --></th> 
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="4" align="center" height = "280">
                        <span class="font1"><%=CommonLang.msg("MSG347") %><!-- 조회된 데이타가 없습니다. --></span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> _tmp = _dataList.get(j);
	String  tclass = (j % 2 != 0)? "#FFFFFF" : "#FAFAFA";
	
	String dis_acl = "";
	if(_tmp.get("ACL").equals("CST")){
		dis_acl = "<font color=red face=Verdana>S</font>";
	}else{
		dis_acl = "&nbsp;&nbsp;";
	}
%> 
                        <tr align="center" bgcolor="<%=tclass%>">
							<td><%=_tmp.get("NUM")%></td>
							<td class="left">
								<b><%=dis_acl%></b>
								<a class="hyperLink" href="javascript:setIcomboard_List_Display_Sel('<%=_tmp.get("BTYPE")%>','<%=_tmp.get("BID")%>','<%=_tmp.get("COMPANY")%>','<%=_tmp.get("GBN")%>'   )">&nbsp;<%=CommonUtil.nvl(_tmp.get("SUBJECT"))%></a>
						    </td>
							<td><a href="" id="board02"><%=_tmp.get("REG_USER_NAME")%></a></td>
							<td><%=CommonUtil.formatDate(_tmp.get("REG_DATE"))%></td>
                        </tr> 
<% } 
}%>                               
                    </tbody>
                </table>
        </div>
    </div>        
</div>
</form> 
</body>
</html>
