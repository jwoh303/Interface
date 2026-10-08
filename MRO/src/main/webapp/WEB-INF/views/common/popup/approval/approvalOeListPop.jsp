<%--
**********************************************
* 메뉴 :  결재
* 화면 : 결재리스트 - 주문정보수정
* 기능 : 결재리스트
* 프로그램 ID : 
* 담당자 : CEJ  
* 착수일 : 2014-XX-XX
**********************************************
--%> 
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%> 
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


String PO_NO = "";
String HIST_RSN_CD = "";
String HIST_RSN_CD_TEXT = "";
String HIST_RSN_CD_array_deatil[] = null;
String POP_FLAG = CommonUtil.nvl((String) request.getParameter("POP_FLAG"),""); //***상세팝업시 사이즈 세팅**/
String divHeight = "200px"; //***상세팝업시 사이즈 세팅**/
if("Y".equals(POP_FLAG))//***상세팝업시 사이즈 세팅**/
	divHeight = "600px";//***상세팝업시 사이즈 세팅**/
%>
<script type="text/javascript"> 
 

function  attach_popup(img_key){	
	
	var type = "<%=DOC_TYPE%>";
	var viewType = "R";
	kepFileUploadOpenPopup(img_key,type,viewType); 
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
       
      <table  class="cont_t_list02"  style="width:100%">
                    <caption>업무결재 리스트</caption>
                    <colgroup>
                        <col width="8%" />                   
                        <col width="8%" />                   
                        <col width="8%" />                   
                        <col width="*" />
                        <col width="8%" />                   
                        <col width="8%" />                   
                        <col width="8%" />                   
                        <col width="8%" />
                        <col width="8%" /> 
                        <col width="15%" />  
                        <col width="8%" />           
                        <col width="8%" />           
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">구분</th> 
                            <th scope="col">발주번호</th> 
                            <th scope="col">품목코드</th> 
                            <th scope="col">품목명</th> 
							<th scope="col">발주수량<br>(전/후)</th>    <!-- ITEM_QTY -->
							<th scope="col">매익율<br>(전/후)</th>    <!-- ITEM_QTY -->
							<th scope="col">매출단가<br>(전/후)</th>    <!-- UNIT_PRICE -->
							<th scope="col">매입단가<br>(전/후)</th>     <!-- AGENT_PRICE -->
							<th scope="col">매출원가<br>(전/후)</th>     <!-- KEP_PRICE -->
							<th scope="col">협력사<br>(전/후)</th>     <!-- AGENT_NAME -->
							<th scope="col">거래유형<br>(전/후)</th>     <!-- PROCESS_NAME --> 
							<th scope="col">카탈로그<br>변경</th>     <!-- CA_FLAG -->
						</tr>
					</thead>
					<tbody>
					<%
if (_dataList == null || _dataList.size() == 0){
%>
                <tr bgcolor="#FFFFFF">
		            <td colspan="11" align="center" height = "50"> 
		            <span>조회된 데이타가 없습니다.</span>
		            </td> 
           		</tr>
<%
     }else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j); 	
	HIST_RSN_CD = rowData.get("HIST_RSN_CD");
	HIST_RSN_CD_array_deatil = HIST_RSN_CD.split("\\/");
	if (HIST_RSN_CD_array_deatil != null || HIST_RSN_CD_array_deatil.length == 10) {
		
		HIST_RSN_CD_TEXT = "";
		if ("Y".equals(CommonUtil.nvl(HIST_RSN_CD_array_deatil[1],""))){
			HIST_RSN_CD_TEXT = HIST_RSN_CD_TEXT + "거래유형변경 ";
		}
		if ("Y".equals(CommonUtil.nvl(HIST_RSN_CD_array_deatil[2],""))){
			HIST_RSN_CD_TEXT = HIST_RSN_CD_TEXT + "협력사변경 ";
		}
		if ("Y".equals(CommonUtil.nvl(HIST_RSN_CD_array_deatil[3],""))){
			HIST_RSN_CD_TEXT = HIST_RSN_CD_TEXT + "단가변경 ";
		}
		if ("Y".equals(CommonUtil.nvl(HIST_RSN_CD_array_deatil[4],""))){
			HIST_RSN_CD_TEXT = HIST_RSN_CD_TEXT + "수량변경";
		}		
	}
	 
	
%>     
						<tr>
							<td><%=HIST_RSN_CD_TEXT%></td>
							<td><%=rowData.get("PO_NO")%></td>
							<td><%=rowData.get("BUYER_ITEM_NO")%></td>
							<td class="left"><%=rowData.get("DESCRIPTION")%></td>
							<td class="right"><%=CommonUtil.formatNumber(rowData.get("BEFORE_ITEM_QTY"),true,0,3)%><br><%=CommonUtil.formatNumber(rowData.get("ITEM_QTY"),true,0,3)%></td>
							<td class="right"><%=rowData.get("RE_RATE")%><br><%=rowData.get("CH_RATE")%></td> 
							<td class="right"><%=CommonUtil.formatNumber(rowData.get("BEFORE_UNIT_PRICE"),true,0,3)%><br><%=CommonUtil.formatNumber(rowData.get("UNIT_PRICE"),true,0,3)%></td> 
							<td class="right"><%=CommonUtil.formatNumber(rowData.get("BEFORE_AGENT_PRICE"),true,0,3)%><br><%=CommonUtil.formatNumber(rowData.get("AGENT_PRICE"),true,0,3)%></td> 
							<td class="right"><%=CommonUtil.formatNumber(rowData.get("BEFORE_KEP_PRICE"),true,0,3)%><br><%=CommonUtil.formatNumber(rowData.get("KEP_PRICE"),true,0,3)%></td> 
							<td>
								<a class="hyperLink"  href="javascript:openSearchPopup('/mdcp/showMasterMdCpAgntcmpyInfoAlterPop.do', '?com_code=<%=rowData.get("BEFORE_AGENT")%>&simsaLevel=3', '950,670,no')"><%=rowData.get("BEFORE_AGENT_NAME")%></a>
								<br>
								<a class="hyperLink"  href="javascript:openSearchPopup('/mdcp/showMasterMdCpAgntcmpyInfoAlterPop.do', '?com_code=<%=rowData.get("AGENT")%>&simsaLevel=3', '950,670,no')"><%=rowData.get("AGENT_NAME")%></a>
							</td> 
							<td><%=rowData.get("BEFORE_PROCESS_NAME")%><br><%=rowData.get("PROCESS_NAME")%></td>  
							<td><%=rowData.get("CA_FLAG")%></td>
 						<tr>
<%} 
}%>  
					</tbody>
					</table>
					
        </div>
       
    </div>        
</div>
</form> 
</body>
</html>
