<%--
**********************************************
* 메뉴 : 
* 화면 : 산업분류명 조회
* 기능 : 산업분류명 조회 팝업.
* 프로그램 ID : 
* 담당자 : 
* 착수일 : 
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
String user_id = CommonUtil.nvl((String) request.getParameter("user_id"),"");  //  (조회조건)
String ind_name = CommonUtil.nvl((String) request.getParameter("ind_name"),"");  //  (조회조건)
String open = CommonUtil.nvl((String) request.getParameter("open"),"");  //  (조회조건)

%>
<script type="text/javascript">
function kep_onload_view(){ 
<%
	if(_sessionInfo == null){
%>
		$('#kepIndTypePop').attr("action", "http://www.koreab2b.com").submit();
<%
	}
%>
 <% if ("Y".equals(open)){%>
 		$('#kepIndTypePop').attr("action", "/common/commonList.do").submit(); 
  <%}%>
	
}
function setQuery()
{  
	if (kepIsEmpty("ind_name")==true ){
	    alert("검색조건을 입력하세요.");
		return;
	} else{	
  		$('#kepIndTypePop').attr("action", "/common/commonList.do").submit();        
	}
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		setQuery();
	}
}

function setReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9) // id,이름,부서코드,부서명,전화번호,email,fax,휴대폰
{ 
  opener.setPopupReturn(value1,value2,value3,value4,value5,value6,value7,value8,value9);
  this.close();
}

</script> 
<body onload="kep_onload_view();">
	 <form name=kepIndTypePop id=kepIndTypePop method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="kepIndTypePop"> 
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:414px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">산업분류명 검색</h1>
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
						<caption>산업분류명</caption>
						<colgroup>
							<col width="15%" />
							<col width="85%" />
							
						</colgroup>						
						<tbody>									
						<tr>
							<td>산업분류명</td>						
							<td>
								<input type=text name="ind_name" id="ind_name" size=60 value="<%=ind_name%>" onkeydown="kepEnter()" class="input_type_text">  
                            </td>							
						</tr>					 
					</tbody>
				</table>
            </div>            
           	 <!--grid-->
           	 <div class="scrollArea" style="height:295px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>산업분류명 리스트</caption>
                    <colgroup>                        
                        <col width="*" />  
                    </colgroup>
                    <thead>
                        <tr>                        
                            <th scope="col">산업분류명</th>  
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="4" align="center" height = "250">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
%> 
                        <tr>	                        
							<td><a class="hyperLink"  href="javascript:setReturn('<%=rowData.get("CODE")%>','<%=rowData.get("TEXT1")%>')"><%=rowData.get("TEXT1")%></a></td>
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
