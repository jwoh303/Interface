<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>

<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/buyer_layout.css" type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과   ;
SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");

String st_buyer=  CommonUtil.nvl((String) request.getParameter("st_buyer"), _sessionInfo.getComCode());
String st_account_type=  CommonUtil.nvl((String) request.getParameter("st_account_type"), "");
String st_code = CommonUtil.nvl((String) request.getParameter("st_code"),"");  //  (조회조건)
String st_text1 = CommonUtil.nvl((String) request.getParameter("st_text1"),"");  //  (조회조건)


%>
<script type="text/javascript">



function setQuery()
{    
  $('#NexeRefNoFormSearch').attr("action", "/mpso/getBuyerMpSoRefPrNoListNexePop.do").submit();   
}

function kepEnter() {	
	if (event.keyCode == 13) {		
			setQuery();
	}		
}

function setReturn(value1,value2,value3)
{ 
  opener.setPopupReturn(value1,value2, value3);
  this.close();
}


</script> 
<body>
	 <form name=NexeRefNoFormSearch  id=NexeRefNoFormSearch method=post >		 
	 <input type="hidden" name="st_buyer" id="st_buyer"  value="<%=st_buyer%>">
	 <input type="hidden" name="st_account_type" id="st_account_type"  value="<%=st_account_type%>">
	 
	 
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper">
    	<div id="popHeader">
        	<h1 class="title">고정자산번호 검색</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
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
								<input type=text name="st_code"  id="st_code"  value="<%=st_code %>" onkeydown="kepEnter()" class="input_type_text">
                            </td>
    						<td>코드명</td>
							<td>
								<input type=text name="st_text1" id="st_text1" value="<%=st_text1 %>" onkeydown="kepEnter()" class="input_type_text">
                            </td>
                         </tr>
					</tbody>
				</table>
            </div>
            <div class="scrollArea" style="height:300px">
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
                            <th scope="col">코드명</th>
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
						   <td ><a href="javascript:setReturn('selectRefNo', '<%=CommonUtil.nvl(rowData.get("CODE"))%>','<%=CommonUtil.nvl(rowData.get("TEXT1"))%>')"><%=CommonUtil.nvl(rowData.get("CODE"))%></a></td>
							<td ><a href="javascript:setReturn('selectRefNo', '<%=CommonUtil.nvl(rowData.get("CODE"))%>','<%=CommonUtil.nvl(rowData.get("TEXT1"))%>')"><%=CommonUtil.nvl(rowData.get("TEXT1"))%></a></td>
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
