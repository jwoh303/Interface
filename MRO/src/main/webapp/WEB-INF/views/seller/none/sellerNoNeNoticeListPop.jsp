<%--
**********************************************
* 메뉴 : 
* 화면 : 협력사 공지사항 목록
* 기능 : 
* 프로그램 ID : 
* 담당자 : 고영일 ( 설계 : 공통 )
* 착수일 : 2014-09-03
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
<%@ include file="../../common/include/head.jspf"  %>
</head>
<%
	//공통
	@SuppressWarnings (value="unchecked")
	List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
	String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _dataList ,"0"); // 총 조회수 (필수)
	int grid_cnt = (_dataList != null )? _dataList.size() : 0;
	String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
	String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"), "10");  // 정렬갯수 <-- 없을경우 무조건 임의의 갯수로 고정처리한다.
	String search_flag = CommonUtil.nvl((String) request.getParameter("search_flag"),"");
	
	String st_company = CommonUtil.nvl((String) request.getParameter("st_company"),"");  // 협력사 코드
%>

<script type="text/javascript">
<!--
function kep_onload_view(){
	<% if (!"Y".equals(search_flag)){ %>
		kepSearch("1");
	<% } %>
}

//조회
function kepSearch(curPage){
	document.forms.sellerNoNeNoticeListPop.curPage.value = curPage; 
	$('#sellerNoNeNoticeListPop').attr("action", "/none/getSellerNoNeNoticeListPop.do").submit();   
}

function setIcomboard_List_Display_Sel(btype, bid){
	openSearchPopup("/none/showSellerNoNeNoticeDetailPop.do", "?st_btype="+btype+"&st_bid="+bid, "800,600,no");
}
 //-->
</script> 
<body onload="kep_onload_view()">
<form name="sellerNoNeNoticeListPop" id="sellerNoNeNoticeListPop" method=post >
<!--HIDDEN-->
<!-- 공통 -->
<input type="hidden" id="upperId"  name="upperId" value="<c:out value="${param.upperId}"/>">    	
<input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />
<!-- 화면 내 정의 -->
<input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}">
<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
<input type="hidden" name="onepagerow" id="onepagerow" value="10">
<input type="hidden" name="search_flag" id="search_flag" value="Y">
<input type="hidden" name="st_company" id="st_company" value="<%=st_company%>">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:504px;">
    	<div id="popHeader">
        	<h1 class="title">공지사항</h1>
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
                            <th scope="col">순번</th> 
                            <th scope="col">제목</th> 
                            <th scope="col">작성자</th> 
                            <th scope="col">게시일</th> 
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="4" align="center" height = "280">
                        <span class="font1">조회된 데이타가 없습니다.</span>
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
								<a class="hyperLink" href="javascript:setIcomboard_List_Display_Sel('<%=_tmp.get("BTYPE")%>','<%=_tmp.get("BID")%>','<%=_tmp.get("COMPANY")%>','<%=_tmp.get("MAX_BID")%>','<%=_tmp.get("MIN_BID")%>','<%=_tmp.get("ACL")%>'  )">&nbsp;<%=CommonUtil.nvl(_tmp.get("SUBJECT"))%></a>
						    </td>
							<td><a href="" id="board02"><%=_tmp.get("REG_USER_NAME")%></a></td>
							<td><%=CommonUtil.formatDate(_tmp.get("REG_DATE"))%></td>
                        </tr> 
<% } 
}%>                               
                    </tbody>
                </table>
                <!-- 페이징 -->
				<p class="paging">
					<%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow) %> 
				</p>
        </div>
    </div>        
</div>
</form> 
</body>
</html>
