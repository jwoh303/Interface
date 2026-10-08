<%--
**********************************************
* 메뉴 : 
* 화면 : 표준명검색
* 기능 : 표준명검색
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
String com_code=  CommonUtil.nvl((String) request.getParameter("byca_comorg_code"), _sessionInfo.getComCode());
String text_gubun = CommonUtil.nvl((String) request.getParameter("st_text_gubun"),""); 
String s_cate_no = CommonUtil.nvl((String) request.getParameter("s_cate_no"),"");

Map<String,String> rowData = null;
if (_dataList==null || _dataList.size()==0){	
}else{
	rowData = _dataList.get(0);
} 
%>


<script type="text/javascript">


function setQuery()
{

  $('#sourcingStdPop').attr("action", "/common/commonList.do").submit();

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

     opener.setCategoryInput(std_categ_nm, std_categ_id, "NM");

	 parent.close();
}

</script> 
<body <%if ("".equals(result)) { %> onload="setQuery()"<%} %>>
	 <form name=sourcingStdPop id=sourcingStdPop method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="buyerSourcingStdDescPop">
	 <input type=hidden name="st_byca_comorg_code" id="st_byca_comorg_code"  value="<%=com_code%>">
	 <input type=hidden name="st_text_gubun" id="st_text_gubun"  value="<%=text_gubun%>">
	 <input type=hidden name="s_cate_no" id="s_cate_no"  value="<%=s_cate_no%>">

	 
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:494px;">
    	<div id="popHeader">
        	<h1 class="title">표준품목명 검색</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
             <div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:categSearch();">조회</a></span>  
            </div>   
            <!--조회영역-->
            <div id="cont_searchA">
            	<table  class="cont_t_list01"  style="width:100%">
						<caption>표준품목명 검색</caption>
						<colgroup>
							<col width="15%" />
							<col width="*" />
						</colgroup>						
						<tbody>
						<tr>
							<td >현재 표준품명</td>
							<td> <%=text_gubun%> </td>
						</tr>
						<tr>
							<td>표준품목명 재검색 </td>
						    <td><input type=text  name=st_search_text  id=st_search_text  style="width:90%" onkeydown="kepEnter()" class="input_type_text"> </td>						 
						</tr>					 
					</tbody>
				</table>
            </div>            
           	<!--grid-->
            <div class="scrollArea" style="height:348px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>현재 표준품명</caption>
                    <colgroup>
                        <col width="100%" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">카테고리 정보</th> 
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
						<td class="left">
							<a class="hyperLink"   href="javascript:nextCategory('<%=_tmp2.get("CATEG_NAME")%>','<%=_tmp2.get("STD_CATEG_ID")%>')">
							<%=_tmp2.get("CATEG_PATH")%>[<%=_tmp2.get("STD_CATEG_ID")%>]</a>
						</td>
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
