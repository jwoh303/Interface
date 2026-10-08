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
  $('#catalogDetailPop').attr("action", "/common/commonList.do").submit();   
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
function popupOnload(){
	//kepAjaxCommonQueryIdCombo('getWareHouseList','sampleCombo','SEL');
}

//상품 큰이미지
function getBigImage(file_dir, file_name){
	getBigImageView("<%= CommonUtil.getURL(request) %><%=CommonUtil.realImgS3UploadPath%>", file_dir, file_name);
}
 //-->
</script> 
<body <%if ("".equals(result)) { %> onload="setQuery()"<%} %>>
	 <form name=catalogDetailPop id=catalogDetailPop method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="categoryPunchOutDetailPop">
	 <input type="hidden" name="st_com_code" id="st_com_code" value="${sessionInfo.comCode}"> 
		<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}"> 	  
	<div id="popWrapper" style="min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">카테고리 정보</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
              <!--팝업내용입니다-->
        <div id="popContainer" style="height:214px; min-height: 100px;">
        	 <div class="scrollArea" style="height:280px">	 
            <table  class="cont_t_list06" style="width:100%;">
              <caption>카테고리 정보</caption>
                <colgroup>
                    <col width="70%" />
                    <col width="30%" />
                </colgroup>
                <tbody>
                    <tr>
                      <th scope="col">표준품명 [카테고리번호]</th>
                      <th scope="col">품목건수</th>
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
									   <td class="left"><a class="hyperLink"  href="javascript:opener.setQueryCateg('<%=_tmp2.get("STD_CATEG_ID")%>');parent.window.close();"><%=CommonUtil.nvl(_tmp2.get("CATEG_NAME"))%></a>
									   	&nbsp;&nbsp; [<%=CommonUtil.nvl(_tmp2.get("STD_CATEG_ID"))%>]</td> 
									   <td class="right"><a class="hyperLink"  href="javascript:opener.setQueryCateg('<%=_tmp2.get("STD_CATEG_ID")%>');parent.window.close();"><%=CommonUtil.nvl(_tmp2.get("CNT"))%></a>&nbsp;&nbsp;&nbsp;</td> 
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
