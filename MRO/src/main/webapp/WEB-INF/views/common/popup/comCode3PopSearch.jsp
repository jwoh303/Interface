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
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과   ;

String st_buyer=  CommonUtil.nvl((String) request.getParameter("st_buyer"), _sessionInfo.getComCode()); 
String st_gbn = CommonUtil.nvl((String) request.getParameter("st_gbn"),"");  //  (조회조건) 
String st_type = CommonUtil.nvl((String) request.getParameter("st_type"),"");  //  (조회조건)
String st_code1 = CommonUtil.nvl((String) request.getParameter("st_code1"),"");  //  (조회조건)
String st_code2 = CommonUtil.nvl((String) request.getParameter("st_code2"),"");  //  (조회조건)
String st_text1 = CommonUtil.nvl((String) request.getParameter("st_text1"),"");  //  (조회조건)
String st_text2 = CommonUtil.nvl((String) request.getParameter("st_text2"),"");  //  (조회조건)

%>
<script type="text/javascript">
function setQuery()
{    
  $('#comCode3PopSearch').attr("action", "/common/commonList.do").submit();   
}

function kepEnter() {
	if (event.keyCode == 13) { 
		setQuery();
	}
}
function setReturn(value1,value2,value3,value4)
{ 
  var st_type = "<%=st_type%>";
  opener.setPopupReturn(st_type,value1,value2,value3,value4);
  this.close();
}
</script> 
<body onload="">
	 <form name=comCode3PopSearch  id=comCode3PopSearch method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="comCode3PopSearch">
	 <input type="hidden" name="st_buyer" id="st_buyer"  value="<%=st_buyer%>">
	 <input type="hidden" name="st_type" id="st_type"  value="<%=st_type%>">
	 
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
					<%if(st_type.equals("SPOT")){%>
						<tr>
                            <td>발주사</td>
							<td>
								<input type=text name="st_text1" id="st_text1" value="<%=st_text1%>" onkeydown="kepEnter()" class="input_type_text">
                            </td>
							<td>현장</td>
							<td>
								<input type=text name="st_text2" id="st_text2" value="<%=st_text2%>" onkeydown="kepEnter()" class="input_type_text">
                            </td>
                         </tr>
					<%}else{%>
						<tr>
							<td>코드1</td>
							<td>
								<input type=text name="st_code1"  id="st_code1"  value="<%=st_code1%>" onkeydown="kepEnter()" class="input_type_text">
                            </td>
							<td>코드2</td>
							<td>
								<input type=text name="st_code2"  id="st_code2"  value="<%=st_code2%>" onkeydown="kepEnter()" class="input_type_text">
                            </td>
                         </tr>
                         <tr>
                            <td>텍스트1</td>
							<td>
								<input type=text name="st_text1" id="st_text1" value="<%=st_text1%>" onkeydown="kepEnter()" class="input_type_text">
                            </td>
							<td>텍스트2</td>
							<td>
								<input type=text name="st_text2" id="st_text2" value="<%=st_text2%>" onkeydown="kepEnter()" class="input_type_text">
                            </td>
                         </tr>
					<%}%>
					</tbody>
				</table>
            </div>            
            <div class="scrollArea" style="height:338px">	 
            	<!--grid-->
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>검색 리스트</caption>
                    <colgroup>
				<%if(st_type.equals("SPOT")){%>
						<col width="20%"/>
						<col width="40%"/>
						<col width="40%"/>
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">코드</th>
                            <th scope="col">발주사명</th>
                            <th scope="col">현장명</th>
                        </tr>
                    </thead>
					<tbody>
				<%}else{%>
							<col width="20%"/>
							<col width="30%"/>
							<col width="20%"/>
							<col width="30%"/>
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">코드1</th>
                            <th scope="col">텍스트1</th>
                            <th scope="col">코드2</th>
                            <th scope="col">텍스트2</th>
                        </tr>
                    </thead>
                   <tbody>
				<%}%>

<%
if (_dataList == null || _dataList.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="3" align="center" height = "270">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
		for (int j=0; j<_dataList.size(); j++){
			Map<String,String> rowData = _dataList.get(j);
%>
					<tr>
				<%if(st_type.equals("SPOT")){%>
						<td ><%=CommonUtil.nvl(rowData.get("CODE1"))%> / <%=CommonUtil.nvl(rowData.get("CODE2"))%></td>
						<td ><a href="javascript:setReturn('<%=rowData.get("CODE1")%>','<%=rowData.get("TEXT1")%>','<%=rowData.get("CODE2")%>','<%=rowData.get("TEXT2")%>')"><%=CommonUtil.nvl(rowData.get("TEXT1"))%></a></td>
						<td ><a href="javascript:setReturn('<%=rowData.get("CODE1")%>','<%=rowData.get("TEXT1")%>','<%=rowData.get("CODE2")%>','<%=rowData.get("TEXT2")%>')"><%=CommonUtil.nvl(rowData.get("TEXT2"))%></a></td>
				<%}else{%>
						<td ><%=CommonUtil.nvl(rowData.get("CODE1"))%></td>
						<td ><a href="javascript:setReturn('<%=rowData.get("CODE1")%>','<%=rowData.get("TEXT1")%>','<%=rowData.get("CODE2")%>','<%=rowData.get("TEXT2")%>')"><%=CommonUtil.nvl(rowData.get("TEXT1"))%></a></td>
						<td ><%=CommonUtil.nvl(rowData.get("CODE2"))%></td>
						<td ><a href="javascript:setReturn('<%=rowData.get("CODE1")%>','<%=rowData.get("TEXT1")%>','<%=rowData.get("CODE2")%>','<%=rowData.get("TEXT2")%>')"><%=CommonUtil.nvl(rowData.get("TEXT2"))%></a></td>
				<%}%>
	<%}%>
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
