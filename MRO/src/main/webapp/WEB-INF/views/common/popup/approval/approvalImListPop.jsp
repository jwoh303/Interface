<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../../../common/include/head_pop.jspf"  %>
 <script src="/resources/js/common.js"></script>
</head> 
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList =  (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과   
String total_cnt = CommonUtil.nvlObj((List<Map<String,String>>) _dataList ,"0"); // 총 조회수 (필수)
String curPage = CommonUtil.nvl((String) request.getParameter("curPage"),"1"); // 현재페이지  (필수)
String onepagerow = CommonUtil.nvl((String) request.getParameter("onepagerow"),"30"); // 정렬갯수

String buyer = CommonUtil.nvl((String) request.getParameter("COMPANY"),""); // 조회조건
String DOCU_NO = CommonUtil.nvl((String) request.getParameter("DOCU_NO"),""); // 조회조건
String DOC_TYPE = CommonUtil.nvl((String) request.getParameter("DOC_TYPE"),""); // 조회조건
String POP_FLAG = CommonUtil.nvl((String) request.getParameter("POP_FLAG"),""); //***상세팝업시 사이즈 세팅**/
String divHeight = "200px"; //***상세팝업시 사이즈 세팅**/
if("Y".equals(POP_FLAG))//***상세팝업시 사이즈 세팅**/
	divHeight = "600px";//***상세팝업시 사이즈 세팅**/
%>

<script type="text/javascript"> 

//페이징 조회
function kepSearch(curPage){
		document.forms.buyerCommonMyPagePop.curPage.value = curPage;
		param2 = document.forms.buyerCommonMyPagePop.DOCU_NO.value;	//GW_NO
		param3 = document.forms.buyerCommonMyPagePop.PASS_TP.value;	//PASS_TP
		param4 = document.forms.buyerCommonMyPagePop.FLAG.value;	//FLAG
		$('#buyerCommonMyPagePop').attr("action", "/common/approval/getBuyerCommonMyPagePop.do?COMPANY="+"<%=buyer%>"+"&DOCU_NO="+param2+"&PASS_TP="+param3+"&FLAG="+param4).submit();
}

</script> 
<body>
	 <form name=approvalImListPop id=approvalImListPop method=post >
	 <input type="hidden" name="VIEW" id="VIEW"  value="approvalImListPop">
	 <input type="hidden" name="total_cnt" id="total_cnt"  value="<%=total_cnt %>"/>
	 <input type="hidden" name="curPage" id="curPage" value="<%=curPage %>" />  
	 <input type="hidden" name="onepagerow" id="onepagerow"  value="30"/>
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
            	 &nbsp;&nbsp;<font color="#FFD8D8"><b>■</b></font> : 변경전 , <font color="#D9E5FF"><b>■</b></font> : 변경후
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>업무결재 리스트</caption>
                    <colgroup>
                    	<col width="10%"/>
                    	<col width="9%"/>
                    	<col width="7%"/>
                        <col width="10%" />                   
                        <col width="12%" />                  
                        <col width=* />                   
                        <col width="9%" />                   
                        <col width="9%" />
                        <col width="8%" />
                        <col width="10%" /> 
                    </colgroup>
                    <thead>
                        <tr>
                        	<th rowspan ="2" scope ="col">구매사명</th>
                        	<th rowspan ="2" scope ="col">계약번호</th>
                        	<th rowspan ="2" scope ="col">계약항번</th>
                            <th rowspan="2"  scope="col">품목코드</th> 
							<th scope="col" style="background-color:#FFD8D8;">품목명</th>
							<th scope="col" style="background-color:#FFD8D8;">규격</th>
							<th scope="col" style="background-color:#FFD8D8;">제조사코드</th>
							<th scope="col" style="background-color:#FFD8D8;">원산지코드</th>
							<th scope="col" style="background-color:#FFD8D8;">모델번호</th>
							<th scope="col" style="background-color:#FFD8D8;">표준카테고리</th>
                        </tr>
                        <tr> 
							<th scope="col">품목명</th>
							<th scope="col">규격</th>
							<th scope="col">제조사코드</th>
							<th scope="col">원산지코드</th>
							<th scope="col">모델번호</th>
							<th scope="col">표준카테고리</th>
                        </tr>
                    </thead>
                    <tbody> 
<%
if (_dataList == null || _dataList.size() == 0){
%>
                <tr bgcolor="#FFFFFF">
		            <td colspan="14" align="center" height = "50"> 
		            <span>조회된 데이타가 없습니다.</span>
		            </td> 
           		</tr>
<%
     }else{
for (int j=0; j<_dataList.size(); j++) {
	Map<String,String> rowData = _dataList.get(j);
%>     
<tr>
		<td height="50" align="center" title="구매사명"><%=rowData.get("BUYER_NAME")%></td>
		<td height="50" align="center" title="계약번호"><%=rowData.get("CONTRACT_NO")%></td>
		<td height="50" align="center" title="계약항번"><%=rowData.get("CONTRACT_SEQ")%></td>
		<td height="50" align="center" title="품목코드"><%=rowData.get("BUYER_ITEM_NO")%></td>
		<td title="품목명" class="left"><%=rowData.get("RE_DESCRIPTION")%><br><%=rowData.get("CH_DESCRIPTION")%></td>
		<td title="규격" class="left"><%=rowData.get("RE_SPECIFICATION")%><br><%=rowData.get("CH_SPECIFICATION")%></td>
		<td class="center" title="제조사"><%=rowData.get("RE_MAKER_NAME")%><br><%=rowData.get("CH_MAKER_NAME")%></td>
		<td class="center" title="원산지"><%=rowData.get("RE_ORIGIN_CODE")%><br><%=rowData.get("CH_ORIGIN_CODE")%></td>
		<td class="center" title="모델번호"><%=rowData.get("RE_MAKER_PART_NO")%><br><%=rowData.get("CH_MAKER_PART_NO")%></td>
		<td class="center" title="표준카테고리"><%=rowData.get("RE_CMS_CATEG_ID")%><br><%=rowData.get("CH_CMS_CATEG_ID")%></td>
<tr>
<%}
}%>                      
                    </tbody>
                </table>
    	<%	if("Y".equals(POP_FLAG)){//***상세팝업시 페이징 x**/ %>
		<% 	}else{ %>
			<!-- 페이징 -->
			<p id="paging" class="paging">
				<%=CommonUtil.getPageView("kepSearch",total_cnt, curPage ,onepagerow) %> 
				<span class="cl">[ 총 <%=total_cnt %> 건 ]</span> 
			</p>
		<% } %>                    
        </div>
    </div>        
</div>
</form> 
</body>
</html>
