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
	divHeight = "650px";//***상세팝업시 사이즈 세팅**/
%>
<script type="text/javascript"> 
 

function  attach_popup(img_key){	
	
	var type = "<%=DOC_TYPE%>";
	var viewType = "R";
	openSearchPopup('/common/fileUploadPop.do','?DOC_NO='+img_key+'&type='+type+'&viewType='+viewType,"500,430,no");// 파일첨부
}

function unitPriceChangePop(buyer,buyer_name,quotation_no,quotation_seq,revision){ 

	popupSel = "masterMpRqQuotationUnitpriceHistoryPop";
	openSearchPopup("/mprq/showMasterMpRqQuotationUnitpriceHistoryPop.do",'?st_buyer='+buyer+'&st_buyer_name='+buyer_name+'&st_quotation_no='+quotation_no+'&st_quotation_seq='+quotation_seq+'&st_revision='+revision,"900,600,no");
}
function setImageView(img_dr,img_name){
	if(img_name == "" || img_name ==null|| img_name =="null"){
		alert("등록된 이미지가 없습니다.");
		return;		
	}else{
		//window.open('<%= CommonUtil.getURL(request) %>'+img_dr+ img_name,'catalogImage','status=no,resizable=yes,menubar=no,scrollbars=no,"","",width=550,height=550');
		window.open(img_dr+ img_name,'catalogImage','status=no,resizable=yes,menubar=no,scrollbars=no,"","",width=550,height=550');
	}
	
}

</script> 
<body onload="setQuery()">
	 <form name=approvalSamplePop id=approvalSamplePop method=post >
	 <input type="hidden" name="VIEW" id="VIEW"  value="approvalSamplePop">  
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다-->
	<div id="popWrapper"> 
        <!--팝업내용입니다-->
        <div id="popContainer">  
         
            <div class="scrollArea" id="divScrollArea" style="height:<%=divHeight %>"><%--//***상세팝업시 사이즈 세팅**/ --%>
            	<!--grid-->
            	 <h3>결재번호 : <%=DOCU_NO %></h3>
                <table  class="cont_t_list02"  style="width:100%">
                    <caption>업무결재 리스트</caption>
                    <colgroup>
                        <col width="7%" />                   
                        <col width="10%" />                   
                        <col width="7%" />                   
                        <col width="7%" />
                        <col width="5%" /> 
                        <col width="*" />
                        <col width="*" />
                        <col width="10%" />  
                        <col width="13%" />    
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col" rowspan="3">상태</th> 
                            <th scope="col">품목코드</th> 
                            <th scope="col">요청단가</th>
							<th scope="col">매출가</th>   
							<th scope="col">매익율</th>   
							<th scope="col">변경전품명</th>
							<th scope="col">변경전규격</th>  
							<th scope="col">제조사</th>  
							<th scope="col" rowspan="3">품의사유</th>  
                        </tr>              
                        <tr>
                            <th scope="col">협력사</th> 
                            <th scope="col">목표단가</th>
							<th scope="col">매입가</th>   
							<th scope="col">단위</th>   
							<th scope="col">변경후품명</th>
							<th scope="col">변경후규격</th>  
							<th scope="col">노(역)마진 사유</th>  
                        </tr>
                        <tr>
                            <th scope="col">견적의뢰일</th> 
                            <th scope="col">조달일수</th>
							<th scope="col">MOQ</th>   
							<th scope="col">발주배수</th>   
							<th scope="col">품목이미지</th>
							<th scope="col">모델번호 / 금액</th>  
							<th scope="col">수량</th>  
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
	      <td title="상태" rowspan="3"><%=rowData.get("STATUS")%></td>
		  <td title="품목코드">
		  	<a class="hyperLink" href="javascript:unitPriceChangePop('<%=rowData.get("BUYER")%>','<%=rowData.get("BUYER_NAME")%>','<%=rowData.get("QUOTATION_NO")%>','<%=CommonUtil.nvl(String.valueOf(rowData.get("QUOTATION_SEQ")))%>','<%=CommonUtil.nvl(String.valueOf(rowData.get("REVISION")))%>');"><%=rowData.get("BUYER_ITEM_NO")%></a>
		  </td>
		  <td class="right" title="요청단가"><%=CommonUtil.formatNumber(rowData.get("BUYER_TARGET_PRICE"),true,0,3)%></td>
		  <td class="right" title="매출단가"><%=CommonUtil.formatNumber(rowData.get("CH_UNIT_PRICE"),true,0,3)%></td>
		  <td class="right" title="매익율"><%=CommonUtil.formatNumber(rowData.get("CH_PRICE_RATE"),true,0,3)%></td>
		  <td title="변경전품명" class="left"><%=rowData.get("RE_DESCRIPTION")%></td>
		  <td title="변경전규격" class="left"><%=rowData.get("RE_SPECIFICATION")%></td>
		  <td title="제조사" class="left"><%=rowData.get("DE_MAKER_NAME")%></td>
          <td title="품의사유" rowspan="3" class="center"><%=rowData.get("REASON")%></td>
</tr>
<tr>
		  <td title="협력사"><a class="hyperLink"  href="javascript:openSearchPopup('/mdcp/showMasterMdCpAgntcmpyInfoAlterPop.do', '?com_code=<%=rowData.get("AGENT")%>&simsaLevel=3', '950,670,no')"><%=rowData.get("AGENT_NAME")%></a></td>
		  <td class="right" title="목표단가"><%=CommonUtil.formatNumber(rowData.get("ADMIN_TARGET_PRICE"),true,0,3)%></td>
		  <td class="right" title="매입단가"><%=CommonUtil.formatNumber(rowData.get("CH_LIST_PRICE"),true,0,3)%></td>
		  <td title="단위"><%=rowData.get("UNIT_MEASURE")%></td>
          <td title="변경전품명" class="left"><%=rowData.get("CH_DESCRIPTION")%></td>
          <td title="변경전규격" class="left"><%=rowData.get("CH_SPECIFICATION")%></td>
		  <td title="노(역)마진사유" class="left"><%=CommonUtil.nvl(rowData.get("MARGIN_RE"))%></td>
</tr>
<tr>
		  <td title="견적의뢰일"><%=CommonUtil.formatDate(CommonUtil.nvl( rowData.get("BTOA_DATE")))%></td>
		  <td class="right" title="조달일수"><%=CommonUtil.formatNumber(rowData.get("LEAD_TIME"),true,0,3)%></td>
		  <td class="right" title="MOQ"><%=CommonUtil.formatNumber(rowData.get("MIN_ORDER_QTY"),true,0,3)%></td>
		  <td class="right" title="발주배수"><%=CommonUtil.formatNumber(rowData.get("PUR_UNIT_QTY"),true,0,3)%></td>
          <td title="품목이미지" >
			            <%if("".equals(rowData.get("IMGFILE_NAME")) || null == rowData.get("IMGFILE_NAME")){%>
			            	<a class="hyperLink" href="javascript:setImageView('<%=CommonUtil.realImgS3UploadPath+"/"+rowData.get("IMGFILE_DIR")+"/" %>', '<%=rowData.get("IMGFILE_NAME")%>');">
			            		<img name="reg_select_img" id="reg_select_img" src="/resources/images/icon2.gif">
			            	</a>
			            <%}else{%>
			            	<a class="hyperLink" href="javascript:setImageView('<%=CommonUtil.realImgS3UploadPath+"/"+rowData.get("IMGFILE_DIR")+"/" %>', '<%=rowData.get("IMGFILE_NAME")%>');">
			            		<img name="reg_select_img" id="reg_select_img" src="/resources/images/icon.gif">
			            	</a>
			            <%}%>
          </td>
		  <td class="left" title="모델번호금액"><%=rowData.get("MAKER_PART_NO")%> / <%=CommonUtil.formatNumber(rowData.get("QUOTATION_SUM"),true,0,3)%></td>
		  <td class="right" title="수량"><%=CommonUtil.formatNumber(rowData.get("ITEM_QTY"),true,0,3)%></td>
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
