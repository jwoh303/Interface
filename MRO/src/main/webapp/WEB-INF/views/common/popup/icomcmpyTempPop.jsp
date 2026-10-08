<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과   
String title = "";
%>
<!doctype html>
<html>
<head>
<%@ include file="../../common/include/head_pop.jspf"  %>
<%
String session_id  = "";
String com_code=  _sessionInfo.getComCode();
if(com_code.equals("KRKORE0001")){
	session_id  = _sessionInfo.getUserId();	
}
%>
<script type="text/javascript">
<!--
function kep_onload_view(){
	<%
		if (_dataList==null || _dataList.size()==0){
	%>
	<%	
		}
	%>
}


function setQuery()
{   
	
  $('#icomcmpyTempPop').attr("action", "/common/commonList.do").submit();    
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
		var box = eval("document.forms.icomcmpyTempPop.checkbox0");
		if(box.checked == true){  
			tmpcode					=	document.forms.icomcmpyTempPop.arraycode.value+"@";   
			tmpvalue					=	document.forms.icomcmpyTempPop.arrayvalue.value+"@";   
		}
	} else{  
		for(var i = 0; i < tot_cnt; i++){   
			var box = eval("document.forms.icomcmpyTempPop.checkbox" + (i)); 
			if(box.checked == true){  
				tmpcode					=	tmpcode + document.forms.icomcmpyTempPop.arraycode[i].value + "@";   
				tmpvalue					=	tmpvalue + document.forms.icomcmpyTempPop.arrayvalue[i].value  + "@";
				
			}
		}
	}
	
	setReturn(tmpcode,tmpvalue);
	
}

function setReturn(value1,value2,value3,value4)
{ 
  opener.setPopupReturn(value1,value2,value3,value4);
  this.close();
}

 //-->
</script>
</head>

<body onload="kep_onload_view(); ">
	 <form name=icomcmpyTempPop id=icomcmpyTempPop method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="icomcmpyTempPop"> 
	 <input type=hidden id="st_session_id"  name="st_session_id" value="<%=session_id%>">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:460px; min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">발주대기 고객사 선택</h1>
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
							<th>고객사명</th>
							<td> 
								<input type=text class="input_type_text" name="st_com_name"  id="st_com_name" size=20 value="" onkeydown="kepEnter()">
                            </td>
							<th></th>
							<td></td>
                         </tr> 
					</tbody>
				</table>
            </div>       
            <div> 
            	<!--grid-->
    	
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>검색 리스트</caption>
                    <colgroup>
                        <col width="15%" /> 
                        <col width="25%" /> 
                        <col width="10%" /> 
                        <col width="*" /> 
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">고객사 코드</th> 
                            <th scope="col">고객사명</th>   
                            <th scope="col">요청건 수</th>
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
<div  class="scrollArea" style="height:220px">         
<table  class="cont_t_list02"  style="width:100%">
<caption>검색 리스트</caption>
<colgroup>
    <col width="30%" /> 
    <col width="*" /> 
</colgroup>
<thead>
<%
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
%> 
                        <tr>
							<td><a class="hyperLink" href="javascript:setReturn('<%=rowData.get("BUYER")%>','<%=rowData.get("BUYER_NAME")%>','<%=rowData.get("CNT")%>')"><%=CommonUtil.nvl(rowData.get("BUYER"))%></a></td>
							<td class="left"><a class="hyperLink"  href="javascript:setReturn('<%=rowData.get("BUYER")%>','<%=rowData.get("BUYER_NAME")%>','<%=rowData.get("CNT")%>')"><%=CommonUtil.nvl(rowData.get("BUYER_NAME"))%></a></td> 
							<td><%=CommonUtil.nvl(rowData.get("CNT"))%></td>
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
	                	<!--버튼이 2글자일때 class="btn_02",버튼이 3글자일때 class="btn_03",버튼이 4글자일때 class="btn_04" 글자수와 class숫자가 동일 최대 10글자까지 가능-->
	                	<p class="btn_02"><a href="javascript:SelectCompany()">확인</a></p>
                	<%} %>
                </div> 
        </div>
    </div>        
</div>
</form> 
</body>
</html>
