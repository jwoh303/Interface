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

//팝업 함수호출
function doPop(str,value1, value2, value3, value4, value5, value6) {
	switch (str) {
	case "agent": // 협력사
		openSearchPopup("/common/agentInfoDisplayPop.do", "?st_com_code="+value1, "800,550,no");
		break;
	case "kepManagerPop": // KeP담당자
		openSearchPopup("/common/kepManagerPop.do", "?st_user_id="+value1, "430,194,no");
		break;
	case "attach"://파일 첨부
		popupSel = "fileUpload";
		var type="RFQ";
		var viewType="R";
		openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+value1+'&type='+type+'&viewType='+viewType,"500,430,no");// 파일첨부
		break;
	case "remark"://비고
		var viewType="R";
		var title = "ATOB";
		openSearchPopup('/common/remarkPop.do','?st_atob_remark='+value1+'&st_btoa_remark='+value2+'&viewType='+viewType+'&title='+title,"500,310,no");// 비고
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
                        <col width="5%" />                   
                        <col width="10%" />                   
                        <col width="10%" />                   
                        <col width="25%" />                   
                        <col width="5%" />
                        <col width="8%" /> 
                        <col width="8%" /> 
                        <col width="8%" /> 
                        <col width="7%" />    
                        <col width="7%" />                    
                        <col width="7%" />                    
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col" rowspan="2">순번</th> 
                            <th scope="col">견적번호</th> 
                            <th scope="col">견적의뢰일</th>
							<th scope="col">품목명</th>   
							<th scope="col">단위</th>   
							<th scope="col">제조사</th>   
							<th scope="col" colspan="2">협력사</th>  
							<th scope="col">요청자</th>  
							<th scope="col">KeP담당자</th>  
							<th scope="col" rowspan="2">비고</th>  
                        </tr>              
                        <tr>
                            <th scope="col">품목코드</th> 
                            <th scope="col">회신요청일</th>
							<th scope="col">규격</th>   
							<th scope="col">수량</th>   
							<th scope="col">원산지</th>   
							<th scope="col">실적단가</th>  
							<th scope="col">견적단가</th>  
							<th scope="col">요청부서</th>  
							<th scope="col">첨부</th>  
                        </tr>              
                    </thead>
                    <tbody> 
<%
if (_dataList == null || _dataList.size() == 0){
%>
                <tr bgcolor="#FFFFFF">
		            <td colspan="10" align="center" height = "50"> 
		            <span>조회된 데이타가 없습니다.</span>
		            </td> 
           		</tr>
<%
     }else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
%>     
<tr>
		<td title="순번" rowspan="2"><%=j+1 %></td>
		<td title="견적번호" class="b"><%=rowData.get("QUOTATION_NO")%></td>
		<td title="견적의뢰일"><%=rowData.get("BTOA_DATE")%></td>
		<td title="품목명" class="left"><%=rowData.get("DESCRIPTION")%></td>
		<td title="단위"><%=rowData.get("UNIT_MEASURE")%></td>
		<td title="제조사" class="left"><%=CommonUtil.nvl(rowData.get("MAKER_NAME"))%></td>
		<td title="협력사" class="td02" colspan="2" align="left">
			<a class="hyperLink" href="javascript:doPop('agent','<%=rowData.get("AGENT")%>');"><%=rowData.get("AGENT_NAME")%></a>
		</td>
		<td title="요청자"><%=CommonUtil.nvl(rowData.get("BTOA_USER_NAME"))%></td>
		<td title="KeP담당자">
			<a class="hyperLink" href="javascript:doPop('kepManagerPop','<%=CommonUtil.nvl(rowData.get("KEP_USER_ID"))%>')"><%=CommonUtil.nvl(rowData.get("KEP_USER_NAME"))%></a>
		</td>
		<td title="비고" rowspan="2">
			<%
                    if("".equals(CommonUtil.nvl(rowData.get("ATOB_REMARK")))) {
            %>
            		<img name = "st_atob_remark_img" id="st_atob_remark_img" src="/resources/images/but_icon02.gif" border="0">
            <%
                    }else {
            %>
                        <a href="javascript:doPop('remark','<%=rowData.get("ATOB_REMARK")%>','<%=rowData.get("BTOA_REMARK")%>');"><img name = "st_atob_remark_img" src="/resources/images/but_icon01.gif" border="0"></a>
            <%
                    }
            %>
      </td>
</tr>
<tr>
		<td title="품목코드" class="left"><%=rowData.get("BUYER_ITEM_NO")%></td>
		<td title="회신요청일"><%=rowData.get("BTOA_END_DATE")%></td>
		<td title="규격" class="left"><%=rowData.get("SPECIFICATION")%></td>
		<td title="수량" class="right"><%=CommonUtil.formatNumber(rowData.get("ITEM_QTY"),true,0,3)%></td>
		<td title="원산지"><%=CommonUtil.nvl(rowData.get("ORIGIN_NAME"))%></td>
		<td title="실적단가" class="right"><%=CommonUtil.formatNumber(rowData.get("BUYER_TARGET_PRICE"),true,0,3)%></td>
		<td title="견적단가" class="right"><%=CommonUtil.formatNumber(rowData.get("ATOB_UNIT_PRICE"),true,0,3)%></td>
		<td title="요청부서"><%=CommonUtil.nvl(rowData.get("BTOA_USER_DEPT"))%></td>
		<td title="첨부">
            <%
            if(!"".equals(CommonUtil.nvl(rowData.get("IMAGE_KEY"))))   {
            %>
                    <a class="hyperLink" href="javascript:doPop('attach', '<%=CommonUtil.nvl(rowData.get("IMAGE_KEY"))%>')"><img name = "st_image_key_img" src="/resources/images/disk_on.gif" border="0"></a>
            <%
                }else {
            %>
                    <img name = "st_image_key_img" id="st_image_key_img" src="/resources/images/disk_off.gif" border="0">
            <%
                }
            %>
        </td>
</tr>
<%
}
     }
%> 
                    </tbody>
                </table>                  
        </div>
    </div>        
</div>
</form> 
</body>
</html>
