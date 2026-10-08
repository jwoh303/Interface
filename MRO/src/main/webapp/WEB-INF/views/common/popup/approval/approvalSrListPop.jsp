<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
</head> 
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList =  (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과   

String buyer = CommonUtil.nvl((String) request.getParameter("COMPANY"),""); // 조회조건
String DOCU_NO = CommonUtil.nvl((String) request.getParameter("DOCU_NO"),""); // 조회조건
String DOC_TYPE = CommonUtil.nvl((String) request.getParameter("DOC_TYPE"),""); // 조회조건
String POP_FLAG = CommonUtil.nvl((String) request.getParameter("POP_FLAG"),""); //***상세팝업시 사이즈 세팅**/
String divHeight = "200px"; //***상세팝업시 사이즈 세팅**/
if("Y".equals(POP_FLAG))//***상세팝업시 사이즈 세팅**/
	divHeight = "600px";//***상세팝업시 사이즈 세팅**/
%>
<script type="text/javascript"> 
 

function  attach_popup(img_key){	
	
	var type = "<%=DOC_TYPE%>";
	var viewType = "R";
	openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+img_key+'&type='+type+'&viewType='+viewType,"500,430,no");// 파일첨부
}

//팝업함수호출
function doPop(str,value1, value2, value3, value4, value5) {
	
	switch (str) {
	case "attach"://파일 첨부
		popupSel = "fileUpload";
		var type="RFQ";
		var viewType="R";
		openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+value1+'&TYPE='+type+'&viewType='+viewType,'500,430,no');// 파일첨부 
		break;
	}
}

function setQuery(){
	
}

</script> 
<body onload="setQuery()">
	 <form name=approvalSamplePop id=approvalSamplePop method=post >
	 <input type="hidden" name="VIEW" id="VIEW"  value="approvalSamplePop">  
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper">
    	<%
    		if("Y".equals(POP_FLAG)){//***상세팝업시 사이즈 세팅**/ %>
        	<div id="popHeader" >
	    	<h1 class="title">결재문서 상세</h1>
	        <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
	  	</div>
    	<%}%>
        <!--팝업내용입니다-->
        <div id="popContainer">  
         
            <div class="scrollArea" style="height:<%=divHeight %>">
            	<!--grid-->
            	 <h3>결재번호 : <%=DOCU_NO %></h3>
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>업무결재 리스트</caption>
                    <colgroup>
                        <col width="20%" />                   
                        <col width="70%" />                   
                        <col width="10%" />                   
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">요청제목</th> 
                            <th scope="col">요청내역</th>
							<th scope="col">첨부</th>   
                        </tr>              
                    </thead>
                    <tbody> 
<%
if (_dataList == null || _dataList.size() == 0){
%>
                <tr bgcolor="#FFFFFF">
		            <td colspan="3" align="center" height = "50"> 
		            <span>조회된 데이타가 없습니다.</span>
		            </td> 
           		</tr>
<%
     }else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
%>     
<tr>
	      <td title="요청제목"><%=CommonUtil.nvl(rowData.get("SR_SUBJECT"))%></td>
		  <td title="요청내역" class="left"><%=CommonUtil.nvl(rowData.get("REQ_REMARK"))%></td>
		  <td title="첨부">
              <%
                  if(!CommonUtil.nvl(rowData.get("REQ_ATTKEY")).equals("")) {
              %>
                      <a class="hyperLink" href="javascript:doPop('attach', '<%=CommonUtil.nvl(rowData.get("REQ_ATTKEY"))%>')"><img name = "st_image_key_img" src="/resources/images/disk_on.gif" border="0"></a>
              <%
                  }else {
              %>
                      <img name = "st_image_key_img" id="st_image_key_img" src="/resources/images/disk_off.gif" border="0">
              <%
                  }
              %>
          </td>
</tr>

<%}

%>
<tr>
<%

}%>                      
                    </tbody>
                </table>                  
        </div>
    </div>        
</div>
</form> 
</body>
</html>
