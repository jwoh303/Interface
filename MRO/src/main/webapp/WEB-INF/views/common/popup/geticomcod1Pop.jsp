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
String title = CommonUtil.nvl((String) request.getParameter("title"),"ICOMCOD1 리스트");
String type = CommonUtil.nvl((String) request.getParameter("type"),"");
String st_text = CommonUtil.nvl((String) request.getParameter("st_text"),"");

%>
<script type="text/javascript">
function setQuery()
{  
	var st_text = $("#st_text").val();
   if(st_text==""){
       alert("검색어를 입력해 주십시요.");
       return;
   }
  $('#geticomcod1Pop').attr("action", "/common/getIcomcod1WhereList.do").submit();  
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		setQuery();
	}
}
function setReturn(value1,value2)
{ 
  opener.setPopupReturn(value1,value2);
  this.close();
}

</script> 
<body onload="">
	 <form name=geticomcod1Pop id=geticomcod1Pop method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun" value="geticomcod1Pop"> 
	 <input type="hidden" name="type" id="type" value="<%=type%>">
	 <input type="hidden" name="title" id="title" value="<%=title%>">

	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:494px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title"><%=title %></h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
			<!--조회영역-->
            <div id="cont_searchA">
            	<table  class="cont_t_list01"  style="width:100%">
						<caption><%=title %></caption>
						<colgroup>
							<col width="20%" />
							<col width="30%" />
							<col width="50%" />
						</colgroup>						
						<tbody>
						<tr>
							<td align="center">검색어</td>
							<td> 
								<input type=text name="st_text" id="st_text" value="<%=st_text %>" onkeydown="kepEnter()" class="input_type_text"> 
                            </td>
                            <td>
                            	<div id="searchBtnA02">
            					<span class="btn_search"><a href="javascript:setQuery();">조회</a></span>
            					</div>  
							</td>
                         </tr> 
					</tbody>
				</table>
            </div>            
            <div class="scrollArea" style="height:378px">
            	<!--grid-->
                <table  class="cont_t_list02"  style="width:100%">
                    <caption><%=title %></caption>
                    <colgroup>
                    	<col width="30%" />
                        <col width="30%" />  
                        <col width="*" />    
                    </colgroup>		   
                    <thead> 
                        <tr>     
                            <th scope="col">코드</th>   
                            <th scope="col">구분1</th>
                            <th scope="col">구분2</th>    
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="3" align="center" height = "325">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
%> 
                        <tr>
						   <td><a href="javascript:setReturn('<%=rowData.get("CODE")%>','<%=rowData.get("TEXT1")%>','')"><%=CommonUtil.nvl(rowData.get("CODE"))%></a></td> 
						   <td><a href="javascript:setReturn('<%=rowData.get("CODE")%>','<%=rowData.get("TEXT1")%>','')"><%=CommonUtil.nvl(rowData.get("TEXT1"))%></a></td> 
						   <td><a href="javascript:setReturn('<%=rowData.get("CODE")%>','<%=rowData.get("TEXT1")%>','')"><%=CommonUtil.nvl(rowData.get("TEXT2"))%></a></td>
						</tr> 
<% } %>
<%}%>                                   
                    </tbody>
                </table>  		 
        </div>
    </div>        
</div>
</form> 
</body>
</html>
