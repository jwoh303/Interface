<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<head>
<%@ include file="../../common/include/head_pop.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과   
String BUYER = CommonUtil.nvl((String) request.getParameter("BUYER"),"");  //  (조회조건) 
String BUYER_ITEM_NO = CommonUtil.nvl((String) request.getParameter("BUYER_ITEM_NO"),"");  //  (조회조건)
String CONTRACT_NO = CommonUtil.nvl((String) request.getParameter("CONTRACT_NO"),"");  //  (조회조건) 
String CONTRACT_SEQ = CommonUtil.nvl((String) request.getParameter("CONTRACT_SEQ"),"");  //  (조회조건) 
String open = CommonUtil.nvl((String) request.getParameter("open"),"");  //  (조회조건) 
String result = CommonUtil.nvl((String) request.getAttribute("result")); // 조회된결과   
String DOC_TYPE = CommonUtil.nvl((String) request.getParameter("DOC_TYPE"),"PO");  //  (조회조건)

String com_type = "";
if (_sessionInfo != null){
	com_type =  CommonUtil.nvl((String)_sessionInfo.getComType()); 	
}

 
Map<String,String> rowData = null;
if (_dataList==null || _dataList.size()==0){	
}else{
	rowData = _dataList.get(0);
} 
%>
<script type="text/javascript">
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
function  attach_popup(img_key){	
	
	var type = "<%=DOC_TYPE%>";
	var viewType = "R";
	kepFileUploadOpenPopup(img_key,type,viewType); 
}

//상품 큰이미지
function getBigImage(file_dir, file_name){
	getBigImageView("<%= CommonUtil.getURL(request) %><%=CommonUtil.realImgS3UploadPath%>", file_dir, file_name);
}

//물류비 책정 사유 팝업
function getLogisFeeReason(code){
	url = "/common/getLogisFeeReasonPop.do";
	openSearchPopup(url,"?st_reason_code=" + code, "600,180,no");
}

//MSDS팝업
function getMsdsInfoPop(msds_no){
	openSearchPopup("/coco/showCommonCoCoMsdsDetailPop.do","?st_msds_no="+msds_no+"&st_btn_yn=N",'750,580,no');
}
</script> 
<body <%if ("".equals(result)) { %> onload="setQuery()"<%} %>>
	 <form name=catalogDetailPop id=catalogDetailPop method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="catalogDetailPop"> 
	 <input type="hidden" name="BUYER" id="BUYER"  value="<%=BUYER%>">
	 <input type="hidden" name="BUYER_ITEM_NO" id="BUYER_ITEM_NO"  value="<%=BUYER_ITEM_NO%>"> 
	 <input type="hidden" name="CONTRACT_NO" id="CONTRACT_NO"  value="<%=CONTRACT_NO%>"> 
	 <input type="hidden" name="CONTRACT_SEQ" id="CONTRACT_SEQ"  value="<%=CONTRACT_SEQ%>"> 
	  
	<div id="popWrapper" style="min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title"><%=CommonLang.get("HTITLE706") %><!-- 상품정보 --></h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
              <!--팝업내용입니다-->
        <div id="popContainer" style="height:214px; min-height: 100px;">
<%
if (_dataList==null || _dataList.size()==0){
	if (!"Y".equals(open)) {
%>
 
        <b><%=CommonLang.get("HTITLE711") %><!-- 상품정보가 없습니다. 확인 부탁드립니다. --> </b>
<%
	}
}else{ %>
  
        	 <div class="scrollArea" style="height:230px">	 
            <table  class="cont_t_list06" style="width:100%;">
              <caption>상품정보 리스트</caption>
                <colgroup>
                    <col width="*" />
                    <col width="15%" />
                    <col width="25%" />
                    <col width="15%" />
                    <col width="15%" />
                </colgroup>
                <tbody>
                    <tr>
                        <td rowspan="9" scope="col" class="center">
                        	<% if ("".equals(CommonUtil.nvl(rowData.get("IMGFILE_NAME")))){ %>
							<img src="/resources/images/noimage.gif" name = "image1" width="150" height="150">
									<input type="hidden" name="st_imgfile_dir" value="">
		                            <input type="hidden" name="st_imgfile_name" value="">
							<%}else{ %>
							<img src="<%=CommonUtil.realImgS3UploadPath+"/"+CommonUtil.nvl(rowData.get("IMGFILE_DIR"))+"/"+CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>"  onerror="javasrcipt:this.src='/resources/images/noimage.gif'"  name = "image1" width="150" height="150">
									<input type="hidden" name="st_imgfile_dir"  value="<%=rowData.get("IMGFILE_DIR")%>">
                                    <input type="hidden" name="st_imgfile_name" value="<%=rowData.get("IMGFILE_NAME")%>">
							<%} %>
							<br><a href="javascript:getBigImage('<%=rowData.get("IMGFILE_DIR")%>','<%=rowData.get("IMGFILE_NAME")%>')"><img src="/resources/images/zoom.gif" width="32" height="23" border="0"></a>
                        </td>
                        <th scope="row"><%=CommonLang.get("HTITLE512") %><!-- 카테고리명 --></th>
                       	<td><%=CommonUtil.nvl(rowData.get("CATEGORY_TEXT"))%></td>
                        <th scope="row"><%=CommonLang.get("HTITLE52") %><!-- 단위 --></th>
                       	<td><%=CommonUtil.nvl(rowData.get("UNIT_MEASURE"))%></td>
                    </tr>
                    <tr>
                      <th scope="row"><%=CommonLang.get("HTITLE15") %><!-- 제조사 --></th>
                      <td scope="col"><%=CommonUtil.nvl(rowData.get("MAKER_NAME"))%></td>
                      <th scope="col"><%=CommonLang.get("HTITLE12") %><!-- 품목코드 --></th>
                      <td scope="col"><b><%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%></b></td>
                    </tr>
                    <tr>
                      <th scope="row"><%=CommonLang.get("HTITLE578") %><!-- 조달일수 --></th>
                      <td><%=CommonUtil.nvl(rowData.get("DELIVERY_LT"))%></td>
                      <th scope="row"><%=CommonLang.get("HTITLE120") %><!-- 원산지 --></th>
                      <td><%=CommonUtil.nvl(rowData.get("ORIGIN"))%></td>
                    </tr>
                    <tr>
                      <th scope="row"><%=CommonLang.get("HTITLE174") %><!-- 단가 --></th>
                      <td>
                      <% 
                      		String comType = (String)_sessionInfo.getBusinessCond();    
		if(!"".equals(comType) &&  "M".equals(comType)){ 
			if(!com_type.equals("W")){
	%> 
                      <b><%=CommonUtil.formatNumber(rowData.get("UNIT_PRICE"),true,0,3)%>&nbsp;(<%=CommonLang.get("HTITLE707") %><!-- 현재상태 --> : <%=CommonUtil.bnvl(rowData.get("STATUS_TEXT"))%>)</b>
			<%}%>
                     <% }else if("S".equals(comType)){   %>
                      <b><%=CommonUtil.formatNumber(rowData.get("LIST_PRICE"),true,0,3)%></b>
                       <%}else{ %>
                        <b><%=CommonUtil.formatNumber(rowData.get("UNIT_PRICE"),true,0,3)%>&nbsp;(<%=CommonLang.get("HTITLE707") %><!-- 현재상태 --> : <%=CommonUtil.bnvl(rowData.get("STATUS_TEXT"))%>)</b>
                      <%} %>
                      
                      </td>
                      <th scope="row"><%=CommonLang.get("HTITLE144") %><!-- 협력사 --></th>
                      <td><%=CommonUtil.nvl(rowData.get("AGENT_TEXT"))%></td>
                    </tr>
                      <%     
		if(!"".equals(comType) &&  "M".equals(comType)){ 
	%> 
                    <tr>
                      <th scope="row"><%=CommonLang.get("HTITLE708") %><!-- 거래유형 --></th>
                      <td><%=CommonUtil.nvl(rowData.get("PROCESS_TYPE_NAME"))%></td>
                      <th scope="row"><%=CommonLang.get("HTITLE709") %><!-- 물류비 -->(%)</th>
                      <td><a class="hyperLink" href="javascript:getLogisFeeReason('<%=CommonUtil.nvl(rowData.get("LOGIS_RATE_STATUS"))%>')"><%=CommonUtil.nvl(rowData.get("LOGISTICS_RATE"))%></a></td>
                    </tr>
                      <%} %>
                    <tr>
                      <th scope="row"><%=CommonLang.get("HTITLE13") %><!-- 품목명 --></th>
                      <td><b><%=CommonUtil.nvl(rowData.get("DESCRIPTION"))%></b></td>
                      <th scope="row"><%=CommonLang.get("HTITLE119") %><!-- 첨부파일 --></th>
                      <td><%
				if(Integer.parseInt(rowData.get("ATTACH_CNT"))>0) {
			%>
					<a href="javascript:attach_popup('<%=CommonUtil.nvl(rowData.get("IMAGE_KEY"))%>');"> <img src="/resources/images/disk_on.gif" name="MasterImage" width="14" height="14" border="0"> </a>
			<%
					if(!CommonUtil.nvl(rowData.get("MSDS_NO")).equals("")){
			%>
						&nbsp;&nbsp;
						<a style="color:#ee3212" href="javascript:getMsdsInfoPop('<%=rowData.get("MSDS_NO")%>')"><u>MSDS</u></a>
			<%
					}
				}else{
                	if(!CommonUtil.nvl(rowData.get("MSDS_NO")).equals("")){
			%>
						<a style="color:#ee3212" href="javascript:getMsdsInfoPop('<%=rowData.get("MSDS_NO")%>')"><u>MSDS</u></a>
			<%
					}
				}
			%>
					</td>
                    </tr>                    
      
                    <tr>
                      <th scope="row"><%=CommonLang.get("HTITLE14") %><!-- 규격 --></th>
                      <td><%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%></td>
                      <th scope="row"><%=CommonLang.get("HTITLE579") %><!-- 표준모델명 --></th>
                      <td><%=CommonUtil.nvl(rowData.get("KEP_MAKER_PART_NO"))%></td>
                    </tr>
                    <tr>
                      <th scope="row"><%=CommonLang.get("HTITLE938") %><!-- MOQ --></th>
                      <td><%=CommonUtil.nvl(rowData.get("MIN_ORDER_QTY"))%></td>
                      <th scope="row"><%=CommonLang.get("HTITLE939") %><!-- 발주배수 --></th>
                      <td><%=CommonUtil.nvl(rowData.get("PUR_UNIT_QTY"))%></td>
                    </tr>
                    <tr>
                    <th scope="row"><%=CommonLang.get("HTITLE710") %><!-- 품목상세설명 --></th>
                      <td colspan="3"><%=CommonUtil.nvl(rowData.get("ITEM_DETAIL_DESC"))%></td>
                    </tr>                    
                </tbody>
            </table>
      	</div>
        
<%} %>   
</div>           
    </div>



<!--     <div id="popContainer">  -->
<!-- 	<table class="board_write" summary="상품정보"> -->
<!-- 		<caption>상품 정보</caption> -->
<!-- 			<colgroup> -->
<!-- 				<col width="20%" /> -->
<!-- 				<col width="17%" /> -->
<!-- 				<col width="23%" /> -->
<!-- 				<col width="16%" /> -->
<!-- 				<col width="24%" /> -->
<!-- 			</colgroup> -->
<!-- 		<tbody>  -->
<!-- 	    	  <tr>  -->
<!-- 				<td rowspan="7"> -->
<%-- 				<% if ("".equals(CommonUtil.nvl(rowData.get("IMGFILE_NAME")))){ %> --%>
<!-- 				<img src="이미지 없음" name = "image1" width="150" height="150"> -->
<%-- 				<%}else{ %> --%>
<%-- 				<img src="<%="/attfiles/"+CommonUtil.nvl(rowData.get("IMGFILE_DIR"))+"/"+CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>" name = "image1" width="150" height="150"> --%>
<%-- 				<%} %> --%>
<!-- 				</td> -->
<!-- 			  </tr> -->
<!-- 			  <tr> -->
<!-- 			  	<th scope="row">카테고리명</th> -->
<%-- 				<td scope="row"><%=CommonUtil.nvl(rowData.get("CATEGORY_TEXT"))%></td> --%>
<!-- 				<th scope="row">단위</th> -->
<%-- 				<td scope="row"><%=CommonUtil.nvl(rowData.get("UNIT_MEASURE"))%></td> --%>
<!-- 			  </tr> -->
<!-- 			  <tr> -->
<!-- 			  	<th scope="row">제조사</th> -->
<%-- 				<td scope="row"><%=CommonUtil.nvl(rowData.get("MAKER_NAME"))%></td> --%>
<!-- 				<th scope="row">품목코드</th> -->
<%-- 				<td scope="row"><%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%></td> --%>
<!-- 			  </tr> -->
<!-- 			 <tr> -->
<!-- 			  	<th scope="row">조달일수</th> -->
<%-- 				<td scope="row"><%=CommonUtil.nvl(rowData.get("DELIVERY_LT"))%>일</td> --%>
<!-- 				<th scope="row">원산지</th> -->
<%-- 				<td scope="row"><%=CommonUtil.nvl(rowData.get("ORIGIN"))%></td> --%>
<!-- 			  </tr> -->
<!-- 			  <tr> -->
<!-- 			  	<th scope="row">단가</th> -->
<%-- 				<td scope="row"><%=CommonUtil.bnvl(rowData.get("UNIT_PRICE"))%>&nbsp;(<%=CommonUtil.bnvl(rowData.get("STATUS_TEXT"))%>)</td> --%>
<!-- 				<th scope="row">협력사</th> -->
<%-- 				<td scope="row"><%=CommonUtil.nvl(rowData.get("AGENT_TEXT"))%></td> --%>
<!-- 			  </tr>		   -->
<!-- 			  <tr> -->
<!-- 			  	<th scope="row">품목명</th> -->
<%-- 				<td scope="row"  colspan="3"><%=CommonUtil.nvl(rowData.get("DESCRIPTION"))%></td>  --%>
<!-- 			  </tr>		   -->
<!-- 			  <tr> -->
<!-- 			  	<th scope="row">규격</th> -->
<%-- 				<td scope="row"  colspan="3"><%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%></td>  --%>
<!-- 			  </tr>	 -->
<!-- 		  </tbody> -->
<!-- 	  </table> -->
<%-- <%} %>       --%>
<!--         </div>  -->
<!--      </div> -->
</form> 
</body>
</html>
