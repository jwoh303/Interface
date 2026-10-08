<%--
**********************************************
* 메뉴 : 
* 화면 : 카테고리검색
* 기능 : 카테고리검색
* 프로그램 ID : PG_02_B_000834_011
* 담당자 :  현명환
* 착수일 : 2015-03-16
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
<%@ include file="../../common/include/head_pop.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과 
String open = CommonUtil.nvl((String) request.getParameter("open"),"");  //  (조회조건) 
String result = CommonUtil.nvl((String) request.getAttribute("result")); // 조회된결과   
String byca_comorg_code=  CommonUtil.nvl((String) request.getParameter("byca_comorg_code"), "");
String com_code=  CommonUtil.nvl((String) request.getParameter("st_com_code"), _sessionInfo.getComCode());
String inventory_gubun_flag = CommonUtil.nvl((String) request.getParameter("inventory_gubun_flag"),""); 
String select_count          = CommonUtil.nvl((String) request.getParameter("select_count"),"");

Map<String,String> rowData = null;
if (_dataList==null || _dataList.size()==0){	
}else{
	rowData = _dataList.get(0);
} 
%>


<script type="text/javascript">


function setQuery()
{

  $('#sourcingCtgIdPop').attr("action", "/common/commonList.do").submit();

}
function categSearch()
{
	var searchText = $("#st_search_text").val();
    if(searchText == "" || searchText == "null" || searchText == null){
        alert(" 검색어가 입력되지 않았습니다.    ");
    }
    $("#st_text_gubun").val( searchText);
    $("#st_byca_comorg_code").val("<%=com_code%>");
	setQuery();
}
function kepEnter() {	
	if (event.keyCode == 13) { 
		categSearch();
	}
}
function nextCategory(categ_name,categ_id)
{ 
	 var std_categ_nm = categ_name;
	 var std_categ_id = categ_id;

     opener.setCategoryInput(std_categ_nm, std_categ_id, "NM","SYS_NM");

	 parent.close();
}

</script> 
<body <%if ("".equals(result)) { %> onload="setQuery()"<%} %>>
	 <form name=sourcingCtgIdPop id=sourcingCtgIdPop method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="buyerSourcingCtgIdPop">
	 <input type=hidden name="st_com_code" id="st_com_code"  value="<%=com_code%>">
	 <input type=hidden name="st_inventory_gubun_flag" id="st_inventory_gubun_flag"  value="<%=inventory_gubun_flag%>">

	 
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:530px;">
    	<div id="popHeader">
        	<h1 class="title">카테고리ID 검색</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">   
           	<!--grid-->
            <div class="scrollArea" style="height:530px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>카테고리ID 검색</caption>
                    <colgroup>
                        <col width="30%" />
                        <col width="70%" />  
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">카테고리ID</th> 
                            <th scope="col">표준품명</th>
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="3" align="center" height = "280">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> _tmp2 = _dataList.get(j);
%> 
                        <tr>
						<td>
							<a class="hyperLink"   href="javascript:opener.setCategoryInput('<%=_tmp2.get("STD_CATEG_NAME")%>','<%=_tmp2.get("STD_CATEG_ID")%>','ID',
							'STD_ID' );parent.window.close()">
							<%=_tmp2.get("STD_CATEG_ID")%></a>
						</td>
						<td class="left"><%=_tmp2.get("STD_CATEG_NAME")%></td>
						</tr>
<% } 
}%>              
						  <tr>
						    <td colspan="2"> ※ 해당 카테고리 ID 클릭하시면 적용됩니다.</td>
						  </tr>                 
                    </tbody>
                </table>                  
        </div>
    </div>        
</div>
</form> 
</body>
</html>
