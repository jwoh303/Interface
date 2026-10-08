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
  $('#comCode4PopSearch').attr("action", "/common/commonList.do").submit();   
}

function kepEnter() {
	if (event.keyCode == 13) { 
		setQuery();
	}
}
function setReturn(value1,value2,value3,value4,value5,value6,value7){
	opener.setPopupReturn(value1,value2,value3,value4,value5,value6,value7);
	this.close();
}
</script> 
<body onload="">
	 <form name=comCode4PopSearch  id=comCode4PopSearch method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="comCode4PopSearch">
	 <input type="hidden" name="st_buyer" id="st_buyer"  value="<%=st_buyer%>">
	 <input type="hidden" name="st_gbn" id="st_gbn"  value="<%=st_gbn%>">
	 <input type="hidden" name="st_type" id="st_type"  value="<%=st_type%>">
	 <input type="hidden" name="st_code1" id="st_code1"  value="<%=st_code1%>">
	 
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
<!-- SYS리테일 명함용 -->
<%if(st_type.equals("NCIF")){%>
	<!-- 지점용 -->
	<%if(st_code1.equals("BRAN")){%>
				
            <!--조회영역-->
            <div id="cont_searchA">
            	<table class="cont_t_list01" style="width:100%">
					<caption>리스트</caption>
					
				
					<colgroup>
						<col width="10%" />
						<col width="40%" />
						<col width="10%" />
						<col width="40%" />
					</colgroup>
					<tbody>
						<tr>
                            <td>지점명</td>
							<td>
								<input type=text name="st_text2" id="st_text2" value="<%=st_text2%>" style="width:50%" onkeydown="kepEnter()" class="input_type_text">
                            </td>
							<td></td>
							<td></td>
						</tr>
					
					</tbody>
				</table>
           	</div>
	<%}else if(st_code1.equals("HMDT")){%>
           		
           	<!--조회영역-->
            <div id="cont_searchA">
            	<table class="cont_t_list01" style="width:100%">
					<caption>리스트</caption>
					
				
					<colgroup>
						<col width="10%" />
						<col width="40%" />
						<col width="10%" />
						<col width="40%" />
					</colgroup>
					<tbody>
						<tr>
                            <td>센터명</td>
							<td>
								<input type=text name="st_text1" id="st_text1" value="<%=st_text1%>" style="width:50%" onkeydown="kepEnter()" class="input_type_text">
                            </td>
							<td></td>
							<td></td>
						</tr>
					
					</tbody>
				</table>
           	</div>	
	<!-- 한샘 명함용 -->
	<%}else if(st_code1.equals("LEVL") || st_code1.equals("ADDR") || st_code1.equals("DIVI") || st_code1.equals("TEAM") || st_code1.equals("POST") || st_code1.equals("HSBR")){%>

			<!--조회영역-->
			<div id="cont_searchA">
				<table class="cont_t_list01" style="width:100%">
					<caption>리스트</caption>
					
				
					<colgroup>
						<col width="10%" />
						<col width="40%" />
					</colgroup>
					<tbody>
						<tr>
							<td><%=st_gbn%></td>
							<td>
								<input type=text name="st_text1" id="st_text1" value="<%=st_text1%>" style="width:50%" onkeydown="kepEnter()" class="input_type_text">
							</td>
						</tr>
					
					</tbody>
				</table>
			</div>	
	<%}%>
<%}else{%>
<%}%>
            <div class="scrollArea" style="height:300px">
            	<!--grid-->
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>검색 리스트</caption>
                    
				<!-- SYS리테일 명함용 -->
				<%if(st_type.equals("NCIF")){%>
				
					<!-- 지점용 -->
					<%if(st_code1.equals("BRAN")){%>
					<colgroup>
						<col width="6%"/>
						<col width="15%"/>
						<col width="10%"/>
						<col width="10%"/>
						<col width="*"/>
						<col width="8%"/>
						<col width="12%"/>
                    </colgroup>
                    <thead>
						<tr>
							<th scope="col">지사</th>
                            <th scope="col">지점명</th>
                            <th scope="col">지점번호</th>
                            <th scope="col">팩스번호</th>
                            <th scope="col">주소</th>
                            <th scope="col">은행명</th>
                            <th scope="col">계좌번호</th>
                        </tr>
                    </thead>
					<tbody>
					
					<!-- 홈닥터 -->
					<%}else if(st_code1.equals("HMDT")){%>
					<colgroup>
						<col width="15%"/>
						<col width="15%"/>
						<col width="15%"/>
						<col width="*"/>
                    </colgroup>
                    <thead>
						<tr>
                            <th scope="col">센터명</th>
                            <th scope="col">지점번호</th>
                            <th scope="col">팩스번호</th>
                            <th scope="col">주소</th>
                        </tr>
                    </thead>
					<tbody>
					
					<!-- 한샘 명함용 -->
					<%}else if(st_code1.equals("LEVL") || st_code1.equals("ADDR") || st_code1.equals("DIVI") || st_code1.equals("TEAM") || st_code1.equals("HSBR")){%>
					<colgroup>
						<col width="*"/>
                    </colgroup>
                    <thead>
						<tr>
                            <th scope="col"><%=st_gbn%></th>
                        </tr>
                    </thead>
					<tbody>
					<%}%>
				<%}else{%>
				<%}%>

				<%
				if(_dataList == null || _dataList.size() == 0){
					if(st_type.equals("NCIF")){
				%>
               		<tr bgcolor="#FFFFFF">
               	<%	if(st_code1.equals("BRAN")){ %>
                        <td colspan="7" align="center" height="250px">
				<%	}else if(st_code1.equals("HMDT")){ %>
				        <td colspan="4" align="center" height="250px">
				<%	}else if(st_code1.equals("LEVL") || st_code1.equals("ADDR") || st_code1.equals("DIVI") || st_code1.equals("TEAM") || st_code1.equals("POST") || st_code1.equals("HSBR")){ %>
				        <td colspan="4" align="center" height="250px">
				<%	}%>
                       		<span class="font1">조회된 데이타가 없습니다.</span>
                        </td>
                    </tr>
				<%							
					}
				}else{
					for (int j=0; j<_dataList.size(); j++){
						Map<String,String> rowData = _dataList.get(j);
				%>
					<tr>
						<!-- SYS리테일 명함용 -->
						<%if(st_type.equals("NCIF")){%>
						
							<!-- 지점용 -->
							<%if(st_code1.equals("BRAN")){%>
								<td ><a href="javascript:setReturn('<%=rowData.get("TEXT2")%>','<%=rowData.get("TEXT3")%>','<%=rowData.get("TEXT4")%>','<%=rowData.get("TEXT5")%>','<%=rowData.get("TEXT6")%>','<%=rowData.get("TEXT7")%>')"><%=CommonUtil.nvl(rowData.get("TEXT1"))%></a></td>
								<td ><a href="javascript:setReturn('<%=rowData.get("TEXT2")%>','<%=rowData.get("TEXT3")%>','<%=rowData.get("TEXT4")%>','<%=rowData.get("TEXT5")%>','<%=rowData.get("TEXT6")%>','<%=rowData.get("TEXT7")%>')"><%=CommonUtil.nvl(rowData.get("TEXT2"))%></a></td>
								<td ><a href="javascript:setReturn('<%=rowData.get("TEXT2")%>','<%=rowData.get("TEXT3")%>','<%=rowData.get("TEXT4")%>','<%=rowData.get("TEXT5")%>','<%=rowData.get("TEXT6")%>','<%=rowData.get("TEXT7")%>')"><%=CommonUtil.nvl(rowData.get("TEXT3"))%></a></td>
								<td ><a href="javascript:setReturn('<%=rowData.get("TEXT2")%>','<%=rowData.get("TEXT3")%>','<%=rowData.get("TEXT4")%>','<%=rowData.get("TEXT5")%>','<%=rowData.get("TEXT6")%>','<%=rowData.get("TEXT7")%>')"><%=CommonUtil.nvl(rowData.get("TEXT4"))%></a></td>
								<td ><a href="javascript:setReturn('<%=rowData.get("TEXT2")%>','<%=rowData.get("TEXT3")%>','<%=rowData.get("TEXT4")%>','<%=rowData.get("TEXT5")%>','<%=rowData.get("TEXT6")%>','<%=rowData.get("TEXT7")%>')"><%=CommonUtil.nvl(rowData.get("TEXT5"))%></a></td>
								<td ><a href="javascript:setReturn('<%=rowData.get("TEXT2")%>','<%=rowData.get("TEXT3")%>','<%=rowData.get("TEXT4")%>','<%=rowData.get("TEXT5")%>','<%=rowData.get("TEXT6")%>','<%=rowData.get("TEXT7")%>')"><%=CommonUtil.nvl(rowData.get("TEXT6"))%></a></td>
								<td ><a href="javascript:setReturn('<%=rowData.get("TEXT2")%>','<%=rowData.get("TEXT3")%>','<%=rowData.get("TEXT4")%>','<%=rowData.get("TEXT5")%>','<%=rowData.get("TEXT6")%>','<%=rowData.get("TEXT7")%>')"><%=CommonUtil.nvl(rowData.get("TEXT7"))%></a></td>
							<%}else if(st_code1.equals("HMDT")){%>
								<td ><a href="javascript:setReturn('<%=rowData.get("TEXT1")%>','<%=rowData.get("TEXT2")%>','<%=rowData.get("TEXT3")%>','<%=rowData.get("TEXT4")%>')"><%=CommonUtil.nvl(rowData.get("TEXT1"))%></a></td>
								<td ><a href="javascript:setReturn('<%=rowData.get("TEXT1")%>','<%=rowData.get("TEXT2")%>','<%=rowData.get("TEXT3")%>','<%=rowData.get("TEXT4")%>')"><%=CommonUtil.nvl(rowData.get("TEXT2"))%></a></td>
								<td ><a href="javascript:setReturn('<%=rowData.get("TEXT1")%>','<%=rowData.get("TEXT2")%>','<%=rowData.get("TEXT3")%>','<%=rowData.get("TEXT4")%>')"><%=CommonUtil.nvl(rowData.get("TEXT3"))%></a></td>
								<td ><a href="javascript:setReturn('<%=rowData.get("TEXT1")%>','<%=rowData.get("TEXT2")%>','<%=rowData.get("TEXT3")%>','<%=rowData.get("TEXT4")%>')"><%=CommonUtil.nvl(rowData.get("TEXT4"))%></a></td>
							<%}else if(st_code1.equals("LEVL") || st_code1.equals("ADDR") || st_code1.equals("DIVI") || st_code1.equals("TEAM") || st_code1.equals("POST") || st_code1.equals("HSBR")){%>
								<td ><a href="javascript:setReturn('<%=rowData.get("TEXT1")%>','<%=rowData.get("TEXT2")%>','<%=rowData.get("TEXT3")%>','<%=rowData.get("TEXT4")%>')"><%=CommonUtil.nvl(rowData.get("TEXT1"))%></a></td>
							<%}%>
						<%}else{%>
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
