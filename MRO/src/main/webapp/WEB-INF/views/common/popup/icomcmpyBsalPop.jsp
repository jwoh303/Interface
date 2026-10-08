<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과   
String MULTI = CommonUtil.nvl((String) request.getParameter("MULTI"),"");  //  (조회조건)   M 멀티 N 싱글
String BUSINESS_COND = CommonUtil.nvl((String) request.getParameter("BUSINESS_COND"),"");  //  (조회조건)  
String COM_NAME_LOC = CommonUtil.nvl((String) request.getParameter("COM_NAME_LOC"),"");  //  (조회조건)
String credit_status = CommonUtil.nvl((String) request.getParameter("credit_status"),"");
String AUTH = CommonUtil.nvl((String) request.getParameter("AUTH"),"");  //  (조회조건)

String title = "";
String session_id  = "";
if ("B".equals(BUSINESS_COND)){
	title = "고객사";
}else	if ("S".equals(BUSINESS_COND)){
		title = "협력사";
}else{
	title = "운영사";
}
%>
<!doctype html>
<html>
<head>
<%@ include file="../../common/include/head_pop.jspf"  %>
<%
String com_code=  _sessionInfo.getComCode();
if(com_code.equals("KRKORE0001") && BUSINESS_COND.equals("B")){
	session_id  = _sessionInfo.getUserId();	
}
%>
<script type="text/javascript">
<!--

function popupOnload(){
	var field = $("#COM_NAME_LOC");
	kepOnFocus(field);
}

function setQuery()
{   
	if (kepIsEmpty("COM_NAME_LOC")==true){
		alert("검색조건을 입력하세요.");
		return;
	} 
	
  $('#icomcmpyPop').attr("action", "/common/commonList.do").submit();    
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		setQuery();
	}
}

function SelectCompany(){  
	var tmpcode = "";
	var tmpvalue = "";
	var form =  document.forms[0]; 
	var tot_cnt = form.count.value;   
	
	if (tot_cnt == 1){
		var box = eval("document.forms.icomcmpyPop.checkbox0");
		if(box.checked == true){  
			tmpcode					=	document.forms.icomcmpyPop.arraycode.value+"@";   
			tmpvalue					=	document.forms.icomcmpyPop.arrayvalue.value+"@";   
		}
	} else{  
		for(var i = 0; i < tot_cnt; i++){   
			var box = eval("document.forms.icomcmpyPop.checkbox" + (i)); 
			if(box.checked == true){  
				tmpcode					=	tmpcode + document.forms.icomcmpyPop.arraycode[i].value + "@";   
				tmpvalue					=	tmpvalue + document.forms.icomcmpyPop.arrayvalue[i].value  + "@";
				
			}
		}
	}
	
	setReturn(tmpcode,tmpvalue);
	
}

function setReturn(value1,value2,value3,value4,value5)
{ 
  opener.setPopupReturn(value1,value2,value3,value4,value5);
  this.close();
}

 //-->
</script>
</head>

<body onload="popupOnload(); ">
	 <form name=icomcmpyPop id=icomcmpyPop method=post >
	 <input type="hidden" name="BUSINESS_COND" id="BUSINESS_COND"  value="<%=BUSINESS_COND%>"> 
	 <input type="hidden" name="MULTI" id="MULTI"  value="<%=MULTI%>">
	 <input type="hidden" name="AUTH" id="AUTH"  value="<%=AUTH%>"> 
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="icomcmpyBsalPop"> 
	 <input type=hidden id="credit_status"  name="credit_status" value="<%=credit_status%>">
	 <input type=hidden id="st_session_id"  name="st_session_id" value="<%=session_id%>">
	 <input type=hidden id="st_session_com_code"  name="st_session_com_code" value="<%=com_code%>">
	 
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:460px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title"><%=title %></h1>
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
						<caption>검색 리스트</caption>
						<colgroup>
							<col width="100px" />
							<col width="20%" />
							<col width="10px" /> 
                            <col width="*" />
						</colgroup>						
						<tbody>
						<tr>
							<td><%=title %>명</td>
							<td> 
								<input class="input_type_text"  type=text name=COM_NAME_LOC  id="COM_NAME_LOC" size=20 value="<%=COM_NAME_LOC%>" onkeydown="kepEnter()" style="ime-mode:active" >
								<input type=text name="tem_input_h" id="tem_input_h" style="display: none;" /> 
                            </td>
							<td></td>						
							<td>  
                            </td>
                         </tr> 
					</tbody>
				</table>
            </div>            
            <div> 
            	<!--grid-->
    	
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>검색 리스트</caption>
                    <colgroup>
                    	<% if ("Y".equals(MULTI)) { %><col width="10%" />  <%} %>
                        <col width="30%" /> 
                        <col width="*" /> 
                    </colgroup>
                    <thead>
                        <tr>
                        	<% if ("Y".equals(MULTI)) { %><th scope="col">선택</th> <%} %>
                            <th scope="col"><%=title %>코드</th> 
                            <th scope="col"><%=title %>명</th>   
                        </tr>
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="5" align="center" height = "195">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
%>
</table>
<div  class="scrollArea" style="height:240px">         
<table  class="cont_t_list02"  style="width:100%">
<caption>검색 리스트</caption>
<colgroup>
	<% if ("Y".equals(MULTI)) { %><col width="10%" />  <%} %>
    <col width="30%" /> 
    <col width="*" /> 
</colgroup>
<thead>
<%
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
%> 
                        <tr>
                        <% if ("Y".equals(MULTI)) { %>
						<td> 
						<input type="checkbox" id = "checkbox<%=j %>" name="checkbox<%=j %>"  value="">
						          	  <input type="hidden" name="arraycode" id="arraycode" value="<%=CommonUtil.nvl(rowData.get("COM_CODE"))%>">
          	  						  <input type="hidden" name="arrayvalue" id="arrayvalue" value="<%=CommonUtil.nvl(rowData.get("COM_NAME_LOC"))%>">          	
						</td>
						<td><%=CommonUtil.nvl(rowData.get("COM_CODE"))%></td>
						<td><%=CommonUtil.nvl(rowData.get("COM_NAME_LOC"))%></td> 
						<%}else{ %>
						<td><a href="javascript:setReturn('<%=rowData.get("COM_CODE")%>','<%=rowData.get("COM_NAME_LOC")%>','<%=rowData.get("COMG_CODE")%>','<%=rowData.get("SEQ")%>','<%=rowData.get("AGENT_OPEN_FLAG")%>')"><%=CommonUtil.nvl(rowData.get("COM_CODE"))%></a></td>
						<td class="left"><a href="javascript:setReturn('<%=rowData.get("COM_CODE")%>','<%=rowData.get("COM_NAME_LOC")%>','<%=rowData.get("COMG_CODE")%>','<%=rowData.get("SEQ")%>','<%=rowData.get("AGENT_OPEN_FLAG")%>')"><%=CommonUtil.nvl(rowData.get("COM_NAME_LOC"))%></a></td> 
						<% }%> 
						
                        </tr> 
<% } %>

<input type="hidden" name="count" id="count"  value="<%=_dataList.size()%>"> 
<%}%> 
</table>  	                                  
   			
</div>                
<br>
				<div class="btnArea">
					<%
					if (_dataList == null || _dataList.size() == 0){
					}else{ %>
						<% if ("Y".equals(MULTI)) { %>
	                	<!--버튼이 2글자일때 class="btn_02",버튼이 3글자일때 class="btn_03",버튼이 4글자일때 class="btn_04" 글자수와 class숫자가 동일 최대 10글자까지 가능-->
	                	<p class="btn_02"><a href="javascript:SelectCompany()">확인</a></p>
	                	<%} %>
                	<%} %>
                </div> 
        </div>
    </div>        
</div>
</form> 
</body>
</html>
