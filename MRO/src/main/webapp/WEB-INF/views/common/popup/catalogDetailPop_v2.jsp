<%--
**********************************************
* 메뉴 : 납품진행현황 > 품목정보 팝업
* 화면 : 품목정보
* 기능 : 품목정보를 확인할 수 있는 팝업(협력사에서)
* 프로그램 ID : SU0501005
* 담당자 : 최찬규
* 착수일 : 2025-09-18
**********************************************
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
<%@ page import="com.koreab2b.mro.util.CommonLang"%>
<%@ page import="com.koreab2b.mro.manager.login.domain.SessionInfo"%>
<!doctype html>
<html>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>코리아 e 플랫폼</title>
<head>
<%@ include file="../include/head_v2.jspf"  %>
<script src="/resources/js/common.js"></script>
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

String popupCheck = CommonUtil.nvl((String) request.getParameter("popupCheck"),"");  //layer의 layer인지 , 그냥 layer인지

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

function msdsDetailPop(msds_no){
	if(msds_no != ""){
		openSearchPopup('/coco/showCommonCoCoMsdsDetailPop_v2.do','?st_msds_no='+msds_no, '750,700,no');
	}
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
function fileDownload(img_key){
	if(img_key != ""){
		location.href="/common/download_v2.do?DOC_NO="+img_key;
	}
}
function thisClosePop(){
	var popupCheck = $("#popupCheck").val();
	if(popupCheck == "Y"){
		parent.closePop2();
	}else{
		parent.closePop();
	}
}
</script> 
<body <%if ("".equals(result)) { %> onload="setQuery()"<%} %>>
	 <form name=catalogDetailPop id=catalogDetailPop method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="catalogDetailPop_v2"> 
	 <input type="hidden" name="BUYER" id="BUYER"  value="<%=BUYER%>">
	 <input type="hidden" name="BUYER_ITEM_NO" id="BUYER_ITEM_NO"  value="<%=BUYER_ITEM_NO%>"> 
	 <input type="hidden" name="CONTRACT_NO" id="CONTRACT_NO"  value="<%=CONTRACT_NO%>"> 
	 <input type="hidden" name="CONTRACT_SEQ" id="CONTRACT_SEQ"  value="<%=CONTRACT_SEQ%>">
	 <input type="hidden" name="popupCheck" id="popupCheck"  value="<%=popupCheck%>">  
	  
<div class="wrapPopup">
  <div class="PopupTit"> <span><a href="javascript:thisClosePop();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
<%
if (_dataList==null || _dataList.size()==0){
	if (!"Y".equals(open)) {
%>
 
        <b><%=CommonLang.get("HTITLE711") %><!-- 상품정보가 없습니다. 확인 부탁드립니다. --> </b>
<%
	}
}else{ %>
  <table class="PopupPDInfor" >
    <colgroup>
      <col width="300px" />
      <col width="430px" />
  	</colgroup>    
    <tr>
    	<% if ("".equals(CommonUtil.nvl(rowData.get("IMGFILE_NAME")))){ %>
    	<td><img class="img" src="/resources/imgs/noimage.gif" /></td>
    	<%}else{ %>
      <td><img class="img" src="<%=CommonUtil.realImgS3UploadPath+"/"+CommonUtil.nvl(rowData.get("IMGFILE_DIR"))+"/"+CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>" onerror="javasrcipt:this.src='/resources/imgs/noimage.gif'"/></td>
      	<%} %>
      <td>
      	<table class="PDInfor" >
          <colgroup>
          <col width="120px" />
          <col width="300px" />
          </colgroup>
          <thead>
          <tr>
            <th colspan="2"><%=CommonUtil.nvl(rowData.get("DESCRIPTION"))%></th>
          </tr>
          </thead>
          <tbody>
          <tr>
            <th>품목코드</th>
            <td><%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%></td>
          </tr>
          <tr>
            <th>규격</th>
            <td><%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%></td>
          </tr>
          <tr>
            <th>카테고리명</th>
            <td><%=CommonUtil.nvl(rowData.get("CATEGORY_TEXT"))%></td>
          </tr>
          <tr>
            <th>제조사</th>
            <td><%=CommonUtil.nvl(rowData.get("MAKER_NAME"))%></td>
          </tr>
          <tr>
            <th>원산지</th>
            <td><%=CommonUtil.nvl(rowData.get("ORIGIN"))%></td>
          </tr>
          <tr>
            <th>단위</th>
            <td><%=CommonUtil.nvl(rowData.get("UNIT_MEASURE"))%></td>
          </tr>
          <tr>
            <th>조달일수</th>
            <td><%=CommonUtil.nvl(rowData.get("DELIVERY_LT"))%>일</td>
          </tr>
          <tr>
            <th>단가</th>
            <% 
        String comType = (String)_sessionInfo.getBusinessCond();    
		if(!"".equals(comType) &&  "M".equals(comType)){ 
			if(!com_type.equals("W")){
			%> 
              <td><%=CommonUtil.formatNumber(rowData.get("UNIT_PRICE"),true,0,3)%>원&nbsp;(현재상태 : <%=CommonUtil.bnvl(rowData.get("STATUS_TEXT"))%>)</td>
			<%}%>
        <% }else if("S".equals(comType)){   %>
            <td><%=CommonUtil.formatNumber(rowData.get("LIST_PRICE"),true,0,3)%>원</td>
        <%}else{ %>
            <td><%=CommonUtil.formatNumber(rowData.get("UNIT_PRICE"),true,0,3)%>원&nbsp;(현재상태 : <%=CommonUtil.bnvl(rowData.get("STATUS_TEXT"))%>)</b>
        <%} %>
          </tr>
        <%     
		if(!"".equals(comType) &&  "M".equals(comType)){ 
		%> 
		  <tr>
            <th>거래유형</th>
            <td><%=CommonUtil.nvl(rowData.get("PROCESS_TYPE_NAME"))%></td>
          </tr>
          <tr>
            <th>물류비</th>
            <td><a class="hyperLink" href="javascript:getLogisFeeReason('<%=CommonUtil.nvl(rowData.get("LOGIS_RATE_STATUS"))%>')"><%=CommonUtil.nvl(rowData.get("LOGISTICS_RATE"))%></a></td>
          </tr>                    
       <%} %>          
          <tr >
            <th>첨부파일</th>
            <td><%=CommonUtil.nvl(rowData.get("ATTACH_CNT"))%>개 &nbsp; <button class="ButDownload_Tiny_Outline" onclick="javascrtip:fileDownload('<%=CommonUtil.nvl(rowData.get("IMAGE_KEY"))%>'); return false;">전체다운로드</button></td>
          </tr>
          <tr>
            <th>MSDS</th>
            <td><a href="javascript:msdsDetailPop('<%=CommonUtil.nvl(rowData.get("MSDS_NO"))%>');" style="text-decoration: underline;"><%=CommonUtil.nvl(rowData.get("MSDS_NO"))%></a></td>
          </tr>          
          </tbody>
        </table>
 
      </td>
    </tr>
   
  </table>
  <%} %>
  <!--div class="PopupListBtnBox_Center"><button class="ButPrimary_large" >확인</button></div-->  
</div><!-- warp 끝-->
</form> 
</body>
</html>
