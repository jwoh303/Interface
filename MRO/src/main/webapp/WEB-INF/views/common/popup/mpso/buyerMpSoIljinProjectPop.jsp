<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과   ;

String st_buyer=  CommonUtil.nvl((String) request.getParameter("st_buyer"), _sessionInfo.getComCode()); 
String st_gbn = CommonUtil.nvl((String) request.getParameter("st_gbn"),"");  //  (조회조건) 
String st_type = CommonUtil.nvl((String) request.getParameter("st_type"),"");  //  (조회조건)
String st_code = CommonUtil.nvl((String) request.getParameter("st_code"),"");  //  (조회조건)
String st_text = CommonUtil.nvl((String) request.getParameter("st_text"),"");  //  (조회조건)
String st_text4 = CommonUtil.nvl((String) request.getParameter("st_text4"),"");  //  (조회조건)

%>
<script type="text/javascript">
<!--

function setQuery()
{    
  $('#buyerMpsoIljinProjectPop').attr("action", "/mpso/getIljinProjectPop.do").submit();   
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		setQuery();
	}
}
function setReturn(value1,value2,value3)
{ 
  var st_type = "<%=st_type%>";
  opener.setPopupReturn(st_type,value1,value2,value3);
  this.close();
}

 //-->
</script> 
<body onload="">
	 <form name=buyerMpsoIljinProjectPop  id=buyerMpsoIljinProjectPop method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="buyerMpsoIljinProjectPop">
	 <input type="hidden" name="st_buyer" id="st_buyer"  value="<%=st_buyer%>">
	 <input type="hidden" name="st_type" id="st_type"  value="<%=st_type%>">
	 <input type="hidden" name="st_gbn" id="st_gbn"  value="<%=st_gbn%>">  
	 <input type="hidden" name="st_text4" id="st_gbn"  value="<%=st_text4%>">  
	 
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper">
    	<div id="popHeader">
        	<h1 class="title"><%=st_gbn%></h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
             <div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:setQuery();">조회</a></span>  
            </div>
            <!--조회영역-->
            <div id="cont_searchA">
            	<table  class="cont_t_list01"  style="width:100%">
						<caption> 리스트</caption>
						<colgroup>
							<col width="15%" />
							<col width="35%" />
							<col width="15%" />
                            <col width="35%" />
						</colgroup>
						<tbody>
						<tr>
							<td>코드</td>
							<td>
								<input type=text name="st_code"  id="st_code"  value="<%=st_code%>" onkeydown="kepEnter()" class="input_type_text">
                            </td>
    						<td><%=st_gbn%></td>
							<td>
								<input type=text name="st_text" id="st_text" value="<%=st_text%>" onkeydown="kepEnter()" class="input_type_text">
                            </td>
                         </tr>
					</tbody>
				</table>
            </div>
            <div class="scrollArea" style="height:338px">
            	<!--grid-->
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>검색 리스트</caption>
                    <colgroup>
						<col width="40%" />
						<col width="60%" />
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">코드</th>
                            <th scope="col"><%=st_gbn%></th>
                        </tr>
                    </thead>
                   <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="3" align="center" height = "270">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
%> 
					<tr>
						<td ><%=CommonUtil.nvl(rowData.get("CODE"))%></td>
						<td ><a href="javascript:setReturn('<%=rowData.get("CODE")%>','<%=rowData.get("TEXT1")%>','')"><%=CommonUtil.nvl(rowData.get("TEXT1"))%></a></td>
<% } %>
<%}%>
						</tr>                                   
                    </tbody>
                </table>  		 
        </div>
    </div>        
</div>
</form> 
</body>
</html>
