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
String BUYER = CommonUtil.nvl((String) request.getParameter("st_com_code"),"");  //  (조회조건) 
String BUYER_ITEM_NO = CommonUtil.nvl((String) request.getParameter("st_buyer_item_no"),"");  //  (조회조건)
String open = CommonUtil.nvl((String) request.getParameter("open"),"");  //  (조회조건) 
String result = CommonUtil.nvl((String) request.getAttribute("result")); // 조회된결과   

 
Map<String,String> rowData = null;
if (_dataList==null || _dataList.size()==0){	
}else{
	rowData = _dataList.get(0);
} 
%>
<script type="text/javascript">
<!--
 

function setQuery()
{  	 
  $('#deptPOInfoPunchOutDetailPop').attr("action", "/common/commonList.do").submit();   
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		setQuery();
	}
}

//상품 큰이미지
function getBigImage(file_dir, file_name){
	getBigImageView("<%= CommonUtil.getURL(request) %><%=CommonUtil.realImgS3UploadPath%>", file_dir, file_name);
}
 //-->
</script> 
<body <%if ("".equals(result)) { %> onload="setQuery()"<%} %>>
	 <form name=deptPOInfoPunchOutDetailPop id=deptPOInfoPunchOutDetailPop method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="deptPOInfoPunchOutDetailPop">
	 <input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}"> 
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">
		<input type="hidden" name="st_buyer_item_no" id="st_buyer_item_no" value="<%=BUYER_ITEM_NO%>"> 	  		
	<div id="popWrapper" style="min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">정비기술부 주문 현황</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
              <!--팝업내용입니다-->
        <div id="popContainer" style="height:214px; min-height: 100px;">
        	 <div class="scrollArea" style="height:280px">	 
            <table  class="cont_t_list002" style="width:100%;">
              <caption>정비기술부 주문 현황</caption>
                <colgroup>
                    <col width="27%" />
                    <col width="15%" />
                    <col width="30%" />
                    <col width="13%" />
                    <col width="15%" />
                </colgroup>
                <tbody>
                    <tr>
                      <th scope="col">품목코드</th>
                      <th scope="col">청구자명</th>
                      <th scope="col">발주번호</th>
                      <th scope="col">발주수량</th>
                      <th scope="col">납기일</th>
                    </tr>
<%
		if (_dataList == null || _dataList.size() == 0){
%>
			<tr>
				<td colspan="15" align="center" height = "50"> 
				<span>현재 목록에 나와있는 자료가 없습니다.</span>
				</td> 
			</tr>
<%
		}else{                    
 
			for (int j=0; j<_dataList.size(); j++) {
				Map<String,String> _tmp2 = _dataList.get(j);
			%>  
			                        <tr>
									   <td class="center"><%=_tmp2.get("BUYER_ITEM_NO")%></td> 
									   <td class="center"><%=_tmp2.get("CHANGE_USER_NAME")%></td>
									   <td class="center"><%=_tmp2.get("LEGACY_PO_NO")%></td>
									   <td class="right"><%=CommonUtil.formatNumber(_tmp2.get("ITEM_QTY"),true,0,3)%></td> 
									   <td class="center"><%=CommonUtil.formatStrinigDate(_tmp2.get("RD_DATE"))%></td>  
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
