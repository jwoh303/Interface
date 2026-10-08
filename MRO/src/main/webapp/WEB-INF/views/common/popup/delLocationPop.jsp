<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../../common/include/head_pop.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과  
String com_code = CommonUtil.nvl((String) request.getParameter("com_code"),"");  //  (조회조건) 
String del_code = CommonUtil.nvl((String) request.getParameter("del_code"),"");  //  (조회조건) 
String del_name = CommonUtil.nvl((String) request.getParameter("del_name"),"");  //  (조회조건) 
String open = CommonUtil.nvl((String) request.getParameter("open"),"");  //  (조회조건)
String st_delyto_field = CommonUtil.nvl((String) request.getParameter("st_delyto_field"),"");  //결과내재검색
String st_check = CommonUtil.nvl((String) request.getParameter("st_check"),"");  //결과내재검색

%>
<script type="text/javascript">
<!--
function kep_onload()
{  

	<% if ("Y".equals(open)){%>
//	setQuery(); 
  <%}%>
}


function setQuery()
{  
	//결과내 검색
	setQuerySearchInResult();
  	$('#delLocationPop').attr("action", "/common/commonDlyLocationList.do").submit();     
}


function kepEnter() {	
	if (event.keyCode == 13) { 
		setQuery();
	}
}
function setReturn(value1,value2, value3)
{ 
  opener.setPopupReturn(value1,value2, value3);
  this.close();
}

function popupOnload(){
	//kepAjaxCommonQueryIdCombo('getWareHouseList','sampleCombo','SEL');
} 

//조회조건 (결과내검색)
function setQuerySearchInResult() {
	if($("#searchInResult").is(":checked")){ // 체크를 한 경우
		$("#st_check").val("Y");
		if(!isEmpty($("#del_name").val())) {
			if($("#st_delyto_field").val()=="ALL") {
				$("#st_delyto_field").val("");
			}
			
			$("#st_delyto_field").val($("#st_delyto_field").val()+$("#del_name").val()+"/");
		}
	}else{
		$("#st_check").val("N");
		if(!isEmpty($("#del_name").val())) {
			$("#st_delyto_field").val($("#del_name").val() +"/");
		}else {
			$("#st_delyto_field").val("ALL");
		}
	
	}
}
 //-->
</script> 
<body onload="kep_onload();">
	 <form name=delLocationPop id=delLocationPop method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="delLocationPop"> 
	 <input type="hidden" name="com_code" id="com_code"  value="<%=com_code%>"> 	 
	 <input type="hidden" id="st_delyto_field" name="st_delyto_field" value="<%=st_delyto_field%>">
	 <input type="hidden" id="st_check" name="st_check" value="N">
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper" style="height:494px;">
    	<div id="popHeader">
        	<h1 class="title"><%=CommonLang.get("HTITLE732") %><!-- 도착지정보 --></h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
             <div id="searchBtnA02">
            	<span class="btn_search"><a href="javascript:setQuery();"><%=CommonLang.get("HTITLE7") %><!-- 조회 --></a></span>  
            </div>   
            <!--조회영역-->
            <div id="cont_searchA">
            	<table  class="cont_t_list01"  style="width:100%">
						<caption>도착지정보 검색 리스트</caption>
						<colgroup>
							<col width="50px" />
							<col width="10%" />
							<col width="5%" />
							<col width="120px" /> 
                            <col width="*" />
						</colgroup>						
						<tbody>
						<tr>
							<td><%=CommonLang.get("HTITLE371") %><!-- 코드 --></td>						
							<td> 
								<input type=text name="del_code" id="del_code" size=10 value="<%=del_code%>" onkeydown="kepEnter()" class="input_type_text"> 
                            </td> 
                            <td></td>
							<td><%=CommonLang.get("HTITLE488") %><!-- 도착지(명,주소) --></td>
							<td> 
								<input type=text name="del_name"  id="del_name" size=20 value="<%=del_name%>" onkeydown="kepEnter()" class="input_type_text"> 
                            </td> 
                         </tr>
					</tbody>
				</table>
            </div>            
            <%
           	if(st_check.equals("Y")){
            %>
	            <input type="checkbox" id="searchInResult" name="searchInResult" checked>&nbsp;&nbsp;<%=CommonLang.get("HTITLE906") %><!-- 결과내재검색 -->
            <%
           	}else{
            %>
            	<input type="checkbox" id="searchInResult" name="searchInResult">&nbsp;&nbsp;<%=CommonLang.get("HTITLE906") %><!-- 결과내재검색 -->
            <%
           	}
            %>
             <div class="scrollArea" style="height:330px">
            	<!--grid-->
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>직급 리스트</caption>
                    <colgroup>
                        <col width="20%" />  
                        <col width="*" />   
                    </colgroup>		   
                    <thead> 
                        <tr>
                            <th scope="col"><%=CommonLang.get("HTITLE371") %><!-- 코드 --></th> 
                            <th scope="col"><%=CommonLang.get("HTITLE489") %><!-- 도착명 --></th>   
                        </tr>
                        <tr> 
                            <th scope="col" colspan="2"><%=CommonLang.get("HTITLE373") %><!-- 도착지주소 --></th>   
                        </tr>                        
                    </thead>
                    <tbody>
<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="2" align="center" height = "250">
                        <span class="font1"><%=CommonLang.msg("MSG347") %><!-- 조회된 데이타가 없습니다. --></span>
                        </td> 
                    </tr>
<%}else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
%> 
                       
						<tr>
							<td colspan="2">
								<table style="border:0px; width:100%">
				 					<tr>
									   <td style="border:0px; width:20%;"><%=CommonUtil.nvl(rowData.get("CODE"))%></td>
										<td style="border:0px;" class="left"><a href="javascript:setReturn('<%=rowData.get("CODE")%>','<%=rowData.get("TEXT2")%>','<%=rowData.get("TEXT1")%>')"><%=CommonUtil.nvl(rowData.get("TEXT1"))%></a></td>
									</tr> 
			                        <tr> 
										<td style="border:0px;" class="left" colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:setReturn('<%=rowData.get("CODE")%>','<%=rowData.get("TEXT2")%>','<%=rowData.get("TEXT1")%>')"><%=CommonUtil.nvl(rowData.get("TEXT2"))%></a></td>
									</tr> 	
								</table>
							</td>
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
