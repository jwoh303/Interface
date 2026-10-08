<%--
**********************************************
* 메뉴 : 
* 화면 : 사용자 조회
* 기능 : 사용자 조회 팝업.
* 프로그램 ID : PG_90_C_900_65
* 담당자 : CEJ( 설계 : 김지현 )
* 착수일 : 2014-08-14
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
String com_name = CommonUtil.nvl((String) request.getParameter("com_name"),"");  //  (조회조건)
String user_id = CommonUtil.nvl((String) request.getParameter("user_id"),"");  //  (조회조건)
String user_name_loc = CommonUtil.nvl((String) request.getParameter("user_name_loc"),"");  //  (조회조건)
String open = CommonUtil.nvl((String) request.getParameter("open"),"");  //  (조회조건)
String result = CommonUtil.nvl((String)request.getAttribute("result")); // 조회된결과  
%>
<script type="text/javascript">
function kep_onload_view(){ 
<%
	if(_sessionInfo == null){
%>
		$('#misUserSelectAllPop2').attr("action", "http://www.koreab2b.com").submit();
<%
	}
%>
 <% if ("Y".equals(open)){%>
	//	$('#misUserSelectAllPop').attr("action", "/common/commonList.do").submit();   
  <%}%>
	
}
function setQuery()
{  
	if (kepIsEmpty("com_name")==true && kepIsEmpty("user_id")==true && kepIsEmpty("user_name_loc")==true){
	    alert("검색조건을 입력하세요.");
		return;
	} else{	
  		$('#misUserSelectAllPop2').attr("action", "/common/commonList.do").submit();        
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
	 <form name=misUserSelectAllPop2 id=misUserSelectAllPop2 method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="misUserSelectAllPop2"> 
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:494px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">사용자검색</h1>
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
						<caption>사용자검색 리스트</caption>
						<colgroup>
							<col width="15%" />
							<col width="35%" />
							<col width="15%" />
							<col width="35%" />
						</colgroup>						
						<tbody>
						<tr>
							<td>회원사명</td>						
							<td> 
								<input type=text name="com_name" id="com_name" value="<%=com_name%>" onkeydown="kepEnter()" style="ime-mode:active; width: 95%;" class="input_type_text"> 
                            </td>
							<td></td>
							<td> 								
                            </td>
						</tr>											
						<tr>
							<td>사용자ID</td>						
							<td>  
								<input type=text name="user_id" id="user_id" value="<%=user_id%>" onkeydown="kepEnter()" style="ime-mode:active; width: 95%;" class="input_type_text">
                            </td>
							<td>사용자명</td>
							<td> 
								<input type=text name="user_name_loc" id="user_name_loc" value="<%=user_name_loc%>" style="ime-mode:active; width: 95%;" onkeydown="kepEnter()" class="input_type_text"> 
                            </td>
						</tr>					 
					</tbody>
				</table>
            </div>            
           	 <!--grid-->
           	 <div class="scrollArea" style="height:295px">
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>사용자검색 리스트</caption>
                    <colgroup>
                        <col width="30%" /> 
                        <col width="20%" />  
                        <col width="20%" />  
                        <col width="*" />  
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">회사명</th> 
                            <th scope="col">사용자명</th>  
                            <th scope="col">사용자ID</th>  
                            <th scope="col">비고</th>  
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
						<td>	<a class="hyperLink"  href="javascript:getAgentDisplayPop('<%=rowData.get("COM_CODE")%>')"'><%=rowData.get("COM_NAME_LOC")%></a><br>(<%=rowData.get("COM_CODE")%>)</td>
						<td><%=CommonUtil.nameMasking(rowData.get("USER_NAME_LOC"))%></td>
						<td>	<a class="hyperLink"  href="javascript:openSearchPopup('/common/userDisplayPop.do','?openYn=Y&user_id=<%=rowData.get("USER_ID")%>' , '800,500,no')"'><%=CommonUtil.nameMasking(rowData.get("USER_ID"))%></a></td>
						<td><%=rowData.get("COM_TYPE_TEXT")%>&nbsp;(<%=rowData.get("USER_TYPE_TEXT")%>)</td>
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
