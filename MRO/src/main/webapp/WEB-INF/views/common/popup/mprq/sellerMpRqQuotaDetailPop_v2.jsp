<%--
**********************************************
* 메뉴 : 
* 화면 : 견적상세팝업
* 기능 : 견적상세팝업
* 프로그램 ID : SU0401002
* 담당자 : 최찬규
* 착수일 : 2025-09-02
**********************************************
--%>
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
<head>
<%@ include file="../../include/head_v2.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과
List<Map<String,String>> sellerAreaList = (List<Map<String,String>>) request.getAttribute("sellerArea"); // 조회된 결과
List<Map<String,String>> fileData = (List<Map<String,String>>) request.getAttribute("fileData"); // 조회된 결과


String st_buyer = CommonUtil.nvl((String) request.getParameter("st_buyer"),"");  //  (조회조건)

String st_quotation_no = CommonUtil.nvl((String) request.getParameter("st_quotation_no"),"");  //  (조회조건)  
String st_quotation_seq = CommonUtil.nvl((String) request.getParameter("st_quotation_seq"),"");  //  (조회조건)  
String st_revision = CommonUtil.nvl((String) request.getParameter("st_revision"),"");  //  (조회조건)  
String st_agent = CommonUtil.nvl((String) request.getParameter("st_agent"),"");  //  (조회조건)  
String st_agent_revision = CommonUtil.nvl((String) request.getParameter("st_agent_revision"),"");  //  (조회조건) 


	//협력사 품목코드 입력 필수
	boolean p03302303 = CommonUtil.getSpecialCheckReturn(_sessionInfo.getComCode(),"P03-3023-03");
%>

<body onload="kep_onload_view()">
<iframe name="account_work" id="account_work" style="display:none;" scrolling="no" frameborder="0" width="100%" height="100%"></iframe>
<iframe name="fileUpload" id="fileUpload" style="display:none;" scrolling="no" frameborder="0" width="100%" height="100%"></iframe>
<form name="searchCondition" id="searchCondition" method="post" modelAttribute="uploadForm" enctype="multipart/form-data">
	<input type="hidden" name="st_buyer" id="st_buyer" size=20 value="<%=st_buyer%>" >
	<input type="hidden" name="st_quotation_no" id="st_quotation_no" value="<%=st_quotation_no%>" >
	<input type="hidden" name="st_quotation_seq" id="st_quotation_seq" value="<%=st_quotation_seq%>" >
	<input type="hidden" name="st_revision" id="st_revision" value="<%=st_revision%>" >
	<input type="hidden" name="st_agent" id="st_agent" value="<%=st_agent%>" >
	<input type="hidden" name="st_agent_revision" id="st_agent_revision" value="<%=st_agent_revision%>" >
	
	<input type="hidden" name="st_giveup_yn" id="st_giveup_yn" value="" >
	<input type="hidden" id="st_user_id" name="st_user_id" value="${sessionInfo.userId}" />
	<input type="hidden" id="st_user_name" name="st_user_name" value="${sessionInfo.userNameLoc}">
	<input type="hidden" id="st_user_tel" name="st_user_tel" value="${sessionInfo.tel}">
	<input type="hidden" id="DOC_NO" name="DOC_NO" value="">
	<input type="hidden" id="TYPE" name="TYPE" value="RFQ">
	<input type="hidden" name="renewal" id="renewal" value="Y" >
	
<div class="wrapPopup" >
  <div class="PopupTit" style="flex-shrink:0;">견적상세<span><a href="javascript:parent.closePop();"><img src="/resources/imgs/Icon_close.png" /></a></span></div>
  <div class="PopupContent" style="height: 650px; overflow-y:auto;">
  <div class="PopupTitSub">기본정보</div>
  <%
  		if(_dataList != null && _dataList.size() != 0){
  			Map<String,String> rowData =  _dataList.get(0);
  			
  			String stoa_remark = CommonUtil.nvl(rowData.get("STOA_REMARK"));
	  		stoa_remark = stoa_remark.replaceAll("&lt;br&gt;","\n");
	  		rowData.put("STOA_REMARK", stoa_remark);
	  		
	  		String atos_remark = CommonUtil.nvl(rowData.get("ATOS_REMARK"));
	  		atos_remark = atos_remark.replaceAll("&lt;br&gt;","\n");
	  		rowData.put("ATOS_REMARK", atos_remark);
  			
  			String statusFlag = "";
  			if(rowData.get("AGENT_SOURCING_STATUS").equals("신규견적요청")){
  				statusFlag = "0";
  			}else if(rowData.get("AGENT_SOURCING_STATUS").equals("재견적요청")){
				statusFlag = "1";
  			}else if(rowData.get("AGENT_SOURCING_STATUS").equals("견적제출") && rowData.get("MODIFY_FLAG").equals("Y")){ //수정제출 가능
  				statusFlag = "2";
  			}else if(rowData.get("AGENT_SOURCING_STATUS").equals("견적제출") && rowData.get("MODIFY_FLAG").equals("N")){ //수정제출 불가능
  				statusFlag = "3";
  			}else{
  				statusFlag = "4";
  			}
  	%>
  	
  <input type="hidden" name="RFQ_IMG_FLAG" id="RFQ_IMG_FLAG" value="<%=CommonUtil.nvl(rowData.get("RFQ_IMG_FLAG"))%>" >
  <input type="hidden" name="IMGFILE_NAME" id="IMGFILE_NAME" value="<%=CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>" >
  <input type="hidden" name="IMGFILE_DIR" id="IMGFILE_DIR" value="<%=CommonUtil.nvl(rowData.get("IMGFILE_DIR"))%>" >
  <input type="hidden" name="SELLER_IMAGE_KEY" id="SELLER_IMAGE_KEY" value="<%=CommonUtil.nvl(rowData.get("SELLER_IMAGE_KEY"))%>" >
  <input type="hidden" name="DELI_AREA_USE_FLAG" id="DELI_AREA_USE_FLAG" value="<%=CommonUtil.nvl(rowData.get("DELI_AREA_USE_FLAG"))%>" >
  <input type="hidden" name="PROCESS_TYPE_FLAG" id="PROCESS_TYPE_FLAG" value="<%=CommonUtil.nvl(rowData.get("PROCESS_TYPE_FLAG"))%>" >
  <input type="hidden" name="SELLER_AREA" id="SELLER_AREA" value="<%=CommonUtil.nvl(rowData.get("SELLER_AREA"))%>" >
  <input type="hidden" name="LEAD_TIME" id="LEAD_TIME" value="<%=CommonUtil.nvl(rowData.get("LEAD_TIME"))%>" >
  <input type="hidden" name="MIN_ORDER_QTY" id="MIN_ORDER_QTY" value="<%=CommonUtil.formatNumber(String.valueOf(rowData.get("MIN_ORDER_QTY")),true,0,0)%>" >
  <input type="hidden" name="PUR_UNIT_QTY" id="PUR_UNIT_QTY" value="<%=CommonUtil.formatNumber(String.valueOf(rowData.get("PUR_UNIT_QTY")),true,0,0)%>" >
  <input type="hidden" name="SG_ID" id="SG_ID" value="<%=CommonUtil.nvl(rowData.get("SG_ID"))%>" >
  <input type="hidden" name="STOA_LIST_PRICE" id="STOA_LIST_PRICE" value="<%=CommonUtil.formatNumber(String.valueOf(rowData.get("STOA_LIST_PRICE")),true,0,0)%>" >
  <input type="hidden" name="ORG_STOA_LIST_PRICE" id="ORG_STOA_LIST_PRICE" value="<%=CommonUtil.formatNumber(String.valueOf(rowData.get("ORG_STOA_LIST_PRICE")),true,0,0)%>" >
  <input type="hidden" name="AGENT_SOURCING_STATUS" id="AGENT_SOURCING_STATUS" value="<%=CommonUtil.nvl(rowData.get("AGENT_SOURCING_STATUS"))%>" >
  <input type="hidden" name="PLANT" id="PLANT" value="<%=CommonUtil.nvl(rowData.get("PLANT"))%>" >
  <input type="hidden" name="VAT_FLAG" id="VAT_FLAG" value="<%=CommonUtil.nvl(rowData.get("VAT_FLAG"))%>" >
  <input type="hidden" name="GIVEUP_REMARK" id="GIVEUP_REMARK" value="" >
  <input type="hidden" name="st_buyer_item_no" id="st_buyer_item_no" value="<%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%>" >
  
  	<input type="hidden" name="BUYER" id="BUYER" size=20 value="<%=CommonUtil.nvl(rowData.get("BUYER"))%>" >
	<input type="hidden" name="QUOTATION_NO" id="QUOTATION_NO" value="<%=CommonUtil.nvl(rowData.get("QUOTATION_NO"))%>" >
	<input type="hidden" name="QUOTATION_SEQ" id="QUOTATION_SEQ" value="<%=CommonUtil.nvl(rowData.get("QUOTATION_SEQ"))%>" >
	<input type="hidden" name="REVISION" id="REVISION" value="<%=CommonUtil.formatNumber(String.valueOf(rowData.get("REVISION")),true,0,0)%>" >
	<input type="hidden" name="AGENT" id="AGENT" value="<%=CommonUtil.nvl(rowData.get("AGENT"))%>" >
	<input type="hidden" name="AGENT_REVISION" id="AGENT_REVISION" value="<%=CommonUtil.formatNumber(String.valueOf(rowData.get("AGENT_REVISION")),true,0,0)%>" >
	<input type="hidden" name="MSDS_YN" id="MSDS_YN" value="<%=CommonUtil.nvl(rowData.get("MSDS_YN"))%>" >
	<input type="hidden" name="MODIFY_FLAG" id="MODIFY_FLAG" value="<%=CommonUtil.nvl(rowData.get("MODIFY_FLAG"))%>" >
  
  <table class="PopupTableTxt">
    <colgroup>
      <col width="150px" />
      <col width="215px" />
      <col width="150px" />
      <col width="215px" />
  	</colgroup>
  	
    <tr>
      <th>견적번호</th>
      <td><%=CommonUtil.nvl(rowData.get("QUOTATION_NO"))%></td>
      <th>진행상태</th>
      <td><span class="ChipsDefault_Yellow"><%=CommonUtil.nvl(rowData.get("AGENT_SOURCING_STATUS"))%></span></td>
    </tr>
  	<tr>
      <th>견적요청일</th>
      <td><%=CommonUtil.nvl(rowData.get("ATOS_DATE"))%></td>
      <th>견적마감일시</th>
      <td><%=CommonUtil.nvl(rowData.get("ATOS_END_DATE"))%></td>
    </tr>
  	<tr>
      <th>고객사</th>
      <td style="vertical-align: top;"><%=CommonUtil.nvl(rowData.get("BUYER_NAME"))%></td>
      <th>KeP담당자</th>
      <td><%=CommonUtil.nvl(rowData.get("KEP_USER_NAME"))%>(<%=CommonUtil.nvl(rowData.get("KEP_USER_PHONE"))%>)<br/>
        <%=CommonUtil.nvl(rowData.get("KEP_USER_EMAIL"))%>
      </td>
    </tr>        
  </table>
  <div class="PopupTitSub">상품정보</div> 
  <table class="PopupTableTxt">
    <colgroup>
      <col width="150px" />
      <col width="215px" />
      <col width="150px" />
      <col width="215px" />
    </colgroup>  
  	<tr>
      <th>품목코드</th>
      <td><%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%></td>
      <th>협력사품목코드</th>
      <%if(statusFlag.equals("0") || statusFlag.equals("1") || statusFlag.equals("2")){ %>
      <td><input class="input30" style="width:90%" id="SELLER_ITEM_NO" name="SELLER_ITEM_NO" type="text" value="<%=CommonUtil.nvl(rowData.get("SELLER_ITEM_NO"))%>" /></td>
      <%}else{ %>
      <td><%=CommonUtil.nvl(rowData.get("SELLER_ITEM_NO"))%></td>
      <%} %>
    </tr>
  	<tr>
      <th>모델번호</th>
      <td colspan="3"><%=CommonUtil.nvl(rowData.get("MAKER_PART_NO"))%></td>
    </tr>
    <tr>
      <th>품목명</th>
      <td colspan="3"><%=CommonUtil.nvl(rowData.get("DESCRIPTION"))%></td>
    </tr>
    <tr>
      <th>규격</th>
      <td colspan="3"><%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%></td>
    </tr>
  	<tr>
      <th>제조사</th>
      <td><%=CommonUtil.nvl(rowData.get("MAKER_NAME"))%></td>
      <th>원산지</th>
      <td><%=CommonUtil.nvl(rowData.get("ORIGIN_NAME"))%></td>
    </tr>
    <tr>
      <th>수량</th>
      <td id="item_qty"><%=CommonUtil.formatNumber(String.valueOf(rowData.get("ITEM_QTY")),true,0,0)%></td>
      <th>단위</th>
      <td><%=CommonUtil.nvl(rowData.get("UNIT_MEASURE"))%></td>
    </tr>
    <tr>
      <th>품목구분 <span>*</span></th>
      <td>
      	<%if(statusFlag.equals("0") || statusFlag.equals("1") || statusFlag.equals("2")){ %>
      	  <select name="ITEM_MAKE_TYPE" id="ITEM_MAKE_TYPE" class="Select" style="width:100%" onchange="javascript:changeLeadTime();">
           <%= CommonUtil.getCode3ComboList("", "SEL", "M132","", "ICOMCOD1", "", "") %>
          </select>
          <input type="hidden" name="ITEM_MAKE_TYPE_HIDDEN" id="ITEM_MAKE_TYPE_HIDDEN" value="<%=CommonUtil.nvl(rowData.get("ITEM_MAKE_TYPE_CODE"))%>" >
        <%}else{ %>
        	<%=CommonUtil.nvl(rowData.get("ITEM_MAKE_TYPE"))%>
        <%} %>
      </td>
      <th>배송일수 <span>*</span></th>
      <td>
      	<%if(statusFlag.equals("0") || statusFlag.equals("1") || statusFlag.equals("2")){ %>
      	<input class="input30" style="width:90%" maxlength="4" name="st_lead_time_text" id="st_lead_time_text" type="text" value="" onblur="addComma(this,'LEAD_TIME');"/>
      	<%}else{ %>
      		<%=CommonUtil.nvl(rowData.get("LEAD_TIME"))%>
      	<%} %>
      </td>
    </tr> 
    <tr>
      <th>금액</th>
      <td colspan="3">
        <table class="PopupTableSmall">
          <colgroup>
            <col width="185px" />
            <col width="185px" />
            <col width="185px" />
          </colgroup>  
          <tr>
            <th>VAT</th>
            <th>제출단가 <span>*</span></th>
            <th>제출금액</th>
          </tr>
          <tr>
            <td>별도</td>
            <td>
            <%if(statusFlag.equals("0") || statusFlag.equals("1") || statusFlag.equals("2")){ %>
            	<input class="input30" style="width:86%; text-align:right; color:#F6495F" id="st_stoa_list_price_text" name="st_stoa_list_price_text" type="text" value="" onkeypress="return checkNum('price',event);" onblur="javascript:vatCalculate();"/>
            <%}else{ %>
            	<span class="F6495F" id="st_stoa_list_price_text"><%=CommonUtil.formatNumber(String.valueOf(rowData.get("ORG_STOA_LIST_PRICE")),true,0,0)%></span>
            	
            <%} %>
            </td>
            <td><span class="F6495F" id="st_stoa_list_price_amt">-</span></td>
          </tr>
          <tr>
            <td>포함</td>
            <td><span class="F6495F" id="st_stoa_vat_list_price">-</span></td>
            <td><span class="F6495F" id="st_stoa_vat_list_price_amt">-</span></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <th>최소주문수량 <span>*</span></th>
      <td>
      <%if(statusFlag.equals("0") || statusFlag.equals("1") || statusFlag.equals("2")){ %>
      	<input class="input30" style="width:88%" id="st_min_order_qty_text" name="st_min_order_qty_text" type="text"  onkeypress="return checkNum('qty',event);" onblur="addComma(this,'MIN_ORDER_QTY');" value=""/>
      <%}else{ %>
      	<%=CommonUtil.formatNumber(String.valueOf(rowData.get("MIN_ORDER_QTY")),true,0,0)%>
      <%} %>	
      </td>
      <th>주문배수수량 <span>*</span></th>
      <td>
      <%if(statusFlag.equals("0") || statusFlag.equals("1") || statusFlag.equals("2")){ %>
      	<input class="input30" style="width:90%" id="st_pur_unit_qty_text" name="st_pur_unit_qty_text" type="text"  onkeypress="return checkNum('qty',event);" onblur="addComma(this,'PUR_UNIT_QTY');" value=""/>
      <%}else{ %>
      	<%=CommonUtil.formatNumber(String.valueOf(rowData.get("PUR_UNIT_QTY")),true,0,0)%>
      <%} %>
      </td>
    </tr> 
    <tr>
      <th>과세구분  <span>*</span></th>
      <td colspan="3">
      	<%if(statusFlag.equals("0") || statusFlag.equals("1") || statusFlag.equals("2")){ %>
      	  <select name="TAX_TYPE" id="TAX_TYPE" class="Select" style="width:34%" onchange="javascript:vatCalculate();">
           <option value="11" selected>과세</option>
           <option value="12">면세</option>
          </select>
          <input type="hidden" name="TAX_TYPE_HIDDEN" id="TAX_TYPE_HIDDEN" value="<%=CommonUtil.nvl(rowData.get("TAX_TYPE_CODE"))%>" >
        <%}else{ %>
        	<%=CommonUtil.nvl(rowData.get("TAX_TYPE"))%>
        <%} %>
      </td>
    </tr>
    <tr>
      <th>선입고  <span>*</span></th>
      <td>
      	<%if(statusFlag.equals("0") || statusFlag.equals("1") || statusFlag.equals("2")){ %>
        	<label class="RadioSmallLabel"><input type="radio" name="QTDT_PRE_GR_FLAG" value="N" checked ><span class="RadioSmallTxt"></span>N</label>
        	<label class="RadioSmallLabel"><input type="radio" name="QTDT_PRE_GR_FLAG" value="Y"><span class="RadioSmallTxt"></span>Y</label>
        	<input type="hidden" name="PRE_GR_FLAG_HIDDEN" id="PRE_GR_FLAG_HIDDEN" value="<%=CommonUtil.nvl(rowData.get("PRE_GR_FLAG"))%>" >
        	<input type="hidden" name="PRE_GR_FLAG" id="PRE_GR_FLAG" value="<%=CommonUtil.nvl(rowData.get("PRE_GR_FLAG"))%>" >
      	<%}else{ %>
      		<%=CommonUtil.nvl(rowData.get("PRE_GR_FLAG"))%>
      	<%} %>
      
      </td>
      <th></th>
      <td></td>
      <th style="display: none;">거래유형</th>
      <td style="display: none;">
      <%if(statusFlag.equals("0") || statusFlag.equals("1") || statusFlag.equals("2")){ %>
      	<%if(CommonUtil.nvl(rowData.get("PROCESS_TYPE_FLAG")).equals("Y")){ %>
        	<label class="RadioSmallLabel"><input type="radio" name="PROCESS_TYPE" value="0" checked><span class="RadioSmallTxt"></span>직납</label>
        	<label class="RadioSmallLabel"><input type="radio" name="PROCESS_TYPE" value="2"><span class="RadioSmallTxt"></span>TR</label>
       		<input type="hidden" name="PROCESS_TYPE_HIDDEN" id="PROCESS_TYPE_HIDDEN" value="<%=CommonUtil.nvl(rowData.get("PROCESS_TYPE"))%>" >
       	<%}else{ %>
       		<input type="hidden" name="PROCESS_TYPE" id="PROCESS_TYPE" value="" >
       	<%} %>
      <%}else{ %>
      		<%=CommonUtil.nvl(rowData.get("PROCESS_NM"))%>
      <%} %>
      </td>
    </tr>
    <tr>
    	<%if(CommonUtil.nvl(rowData.get("DELI_AREA_USE_FLAG")).equals("Y")){%>
      <th>납품지역  <span>*</span></th>
      <%}else{ %>
      <th>납품지역</th>
      <%} %>
      <td colspan="3">
      <%if(statusFlag.equals("0") || statusFlag.equals("1") || statusFlag.equals("2")){ %>
      	<%if(CommonUtil.nvl(rowData.get("DELI_AREA_USE_FLAG")).equals("Y")){%>
      	<input type="hidden" name="AreaCount" id="AreaCount"  value="<%=sellerAreaList.size()%>">
      	<input type="hidden" name="SELLER_AREA" id="SELLER_AREA"  value="<%=CommonUtil.nvl(rowData.get("SELLER_AREA"))%>">
      	<label class="CheckMediumLabel"><input type="checkbox" value="" id="checkedAll" name="checkedAll" onclick="javascript:checkedAllBox();"><span class="CheckMediumCustom"></span>전체</label>
      	<%
    	  for (int i=0; i<sellerAreaList.size(); i++) {
    			Map<String,String> sellerAreaData = sellerAreaList.get(i);
        %>
        <label class="CheckMediumLabel"><input type="checkbox" value="<%=CommonUtil.nvl(sellerAreaData.get("CODE2"))%>" id="st_area_code<%=i%>" name="st_area_code"><span class="CheckMediumCustom"></span><%=CommonUtil.nvl(sellerAreaData.get("TEXT1"))%></label>
       		<%if((i > 0) && ((i+1)%6 == 0)){%>
      			<br/>
      		<%} %>
      	<%} %> 
       <%} %>
      <%}else{ %>
			<%=CommonUtil.nvl(rowData.get("SELLER_AREA_TEXT"))%>
      <%} %>
      </td>
    </tr> 
    <tr>
      <th>예상도착지</th>
      <td colspan="3"><%=CommonUtil.nvl(rowData.get("DELY_TO_LOCATION"))%></td>
    </tr>
    <%if(statusFlag.equals("0") || statusFlag.equals("1") || statusFlag.equals("2")){ %>
    <tr>
    <%if(CommonUtil.nvl(rowData.get("RFQ_IMG_FLAG")).equals("Y")){ %>
      <th>이미지 첨부 <span>*</span></th>
      <%}else{ %>
      <th>이미지 첨부</th>
      <%} %>
      <td colspan="3">
        <div class="ImgAdd">이미지는 1개 등록 가능
        <button class="ButMSmallDarkGray" onclick="javascript:imgFileUploadOpen(); return false;">파일찾기</button><input type="file" name="files1" id="imgFile" style="display: none;" onchange="imgFileUpload();">
        </div>
        <div id="UploadDiv">
	        <div class="Uploader" id="imgDrop"><p class="Title"><img src="/resources/imgs/Icon_Drop.png" /><br/>이미지를 넣으시면 등록됩니다</p></div>
        </div>
      </td>
    </tr> 
    <tr>
      <th>첨부</th>
      <td colspan="3">
        <div class="ImgAdd">최대 5개까지 가능<button class="ButMSmallDarkGray" onclick="javascript:norFileUploadOpen(); return false;">파일찾기</button><input type="file" name="files" id="norFile" style="display: none;" onchange="norFileUpload(); " multiple="multiple">
        </div>
        <div id="UploadFileDiv">
        	<div class="Uploader" id="fileDrop"><p class="Title"><img src="/resources/imgs/Icon_Drop.png" /><br/> 파일을 끌어다 넣으시거나 [파일찾기] 버튼을 통해 등록가능합니다.</p></div>
      	</div>
      </td>
    </tr>
    <%}else{ %>
    <tr>
      <th>이미지 첨부 </th>
      <td colspan="3">
      <%=CommonUtil.nvl(rowData.get("IMGFILE_NAME_CNT")) %> &nbsp; <%if(!CommonUtil.nvl(rowData.get("IMGFILE_NAME_CNT")).equals("")) {%><button class="ButDownload_Tiny" onclick="downLoadFile('<%=CommonUtil.nvl(rowData.get("IMGFILE_DIR"))%>','<%=CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>','Y'); return false;">다운로드</button><%} %></td>
    </tr> 
    <tr>
      <th>첨부</th>
      <td colspan="3"><%=CommonUtil.nvl(rowData.get("SELLER_IMAGE_KEY_CNT")) %> &nbsp; <%if(!CommonUtil.nvl(rowData.get("SELLER_IMAGE_KEY_CNT")).equals("")) {%><button class="ButDownload_Tiny" onclick="downLoadFile('<%=CommonUtil.nvl(rowData.get("SELLER_IMAGE_KEY"))%>'); return false;">다운로드</button><%} %></td>
    </tr>
    <%} %>
    <tr>
      <th>KeP 첨부</th>
      <td colspan="3"><%=CommonUtil.nvl(rowData.get("IMAGE_KEY_CNT")) %> &nbsp; <%if(!CommonUtil.nvl(rowData.get("IMAGE_KEY_CNT")).equals("")) {%><button class="ButDownload_Tiny" onclick="downLoadFile('<%=CommonUtil.nvl(rowData.get("IMAGE_KEY"))%>'); return false;">다운로드</button><%} %></td>
    </tr>
    <tr>
      <th>KeP 비고</th>
      <td colspan="3"><%=CommonUtil.nvl(rowData.get("ATOS_REMARK"),"") %></td>
    </tr>
    <tr>
      <th>협력사 > KeP</th>
      <td colspan="3">
      	<%if(statusFlag.equals("0") || statusFlag.equals("1") || statusFlag.equals("2")){ %>
        <div class="TextField" id="limitedArea">
          <input type="hidden" name="STOA_REMARK_HIDDEN" id="STOA_REMARK_HIDDEN"  value="<%=CommonUtil.nvl(rowData.get("STOA_REMARK"))%>">
          <textarea id="STOA_REMARK_TEXT" name="STOA_REMARK_TEXT" maxlength="300" placeholder="" style="height:40px; ;width:530px; "></textarea>
          <textarea id="STOA_REMARK" name="STOA_REMARK" maxlength="300" placeholder="" style="height:40px; ;width:530px; display: none; "></textarea>
          <div class="meta" aria-live="polite" style="height: 10px;"> <span id="count">0</span>/300 </div>
        </div>
        <script>
          (function () {
            const wrap = document.getElementById('limitedArea');
            const ta   = document.getElementById('STOA_REMARK_TEXT');
            const cnt  = document.getElementById('count');
            const MAX  = parseInt(ta.getAttribute('maxlength'), 10);
            function update() {
              const len = ta.value.length;
              cnt.textContent = len;
            }
            // 초기 상태 반영 및 입력 시 업데이트
            update();
            ta.addEventListener('input', update);
          })();
        </script>
        <%}else{ %>
        	<%=CommonUtil.nvl(rowData.get("STOA_REMARK"),"") %>
        <%} %>      
      </td>
    </tr>
    <tr>
      <th>안전인증서 상태</th>
      <td colspan="3"><%=CommonUtil.nvl(rowData.get("SAFETY_FLAG_TEXT"))%></td>
    </tr>            
  </table>
  <div class="h30"></div>
  <div class="PopupListBtnBox_Center">
  	<%if(statusFlag.equals("0") || statusFlag.equals("1")){ %>
  		<button class="ButQuaternary_large" onclick="javascript:doAction('cancel'); return false;">견적포기</button>
    	<button class="ButPrimary_large" onclick="javascript:doAction('agentHandout'); return false;">견적제출</button>
  	<%}else if(statusFlag.equals("2")){ %>
  		<button class="ButPrimary_large" onclick="javascript:doAction('save'); return false;">수정제출</button>
  	<%}else{ %>
  	
  	<%} %>
    
  </div>
  </div>  
</div><!-- warp 끝-->
  <%} %>
</form>
<form name="deleteFile" id="deleteFile">
	<input type="hidden" name="D_DOC_NO" id="D_DOC_NO" value="" >
	<input type="hidden" name="D_DOC_SEQ" id="D_DOC_SEQ" value="" >
	<input type="hidden" name="D_TYPE" id="D_TYPE" value="RFQ" >
	<input type="hidden" name="renewal" id="renewal" value="Y" >
</form>
</body>

<script type="text/javascript">
//사이즈고정 되는 것 처럼
// window.addEventListener("resize",function(){
// 	window.resizeTo(800,900);
// })

var dropFile = null;
var dropNorFile = null;
var uploadFileName = "";
var uploadFileExt = "";

var norFileStore = {};

var but1text = "확인";
var but1func = "javascript:closePopText2(); return false;";
var but1funcSearch= "javascript:thisPopClose(); return false;";
var but1width = "120px";

function kep_onload_view()
{  
	<%
	if (_dataList==null || _dataList.size()==0){
	%> 
		setQuery();
	<%}else{%>
		var agent_sourcing_status = $("#AGENT_SOURCING_STATUS").val();
		var modify_flag = $("#MODIFY_FLAG").val();
		
		if(agent_sourcing_status=="신규견적요청" || agent_sourcing_status=="재견적요청"){
			
		}else if((agent_sourcing_status=="견적제출" && modify_flag == "Y")){
			//기존 값으로 셋팅
			
			//납품지역
			var AreaCount = $("#AreaCount").val();
			var sellerArea = $("#SELLER_AREA").val();
			var sellerAreaCode = sellerArea.split("__");
			var CheckCount = 0;
			for(var i=0; i<AreaCount; i++){
				for(var j = 0; j<sellerAreaCode.length;j++){
					if(sellerAreaCode[j] == $("#st_area_code"+i).val()){
						$("#st_area_code"+i).prop("checked",true);
						CheckCount++;
					}
				}
			}
			if(AreaCount == CheckCount){
				$("#checkedAll").prop("checked",true);
			}
			
			//협력사 비고
			$("#STOA_REMARK_TEXT").val($("#STOA_REMARK_HIDDEN").val());
			$("#count").text($("#STOA_REMARK_TEXT").val().length);
			//선입고여부
			var PRE_GR_FLAG = document.getElementsByName("QTDT_PRE_GR_FLAG");
			for( var i = 0; i < PRE_GR_FLAG.length; i++ ) {
				if( PRE_GR_FLAG[i].value == $("#PRE_GR_FLAG_HIDDEN").val() ) {
					PRE_GR_FLAG[i].checked = true;
					break;
				}
			}
			//거래유형
			if($("#PROCESS_TYPE_FLAG").val() == "Y"){
				var PROCESS_TYPE = document.getElementsByName("PROCESS_TYPE");
				for( var i = 0; i < PROCESS_TYPE.length; i++ ) {
					if( PROCESS_TYPE[i].value == $("#PROCESS_TYPE_HIDDEN").val() ) {
						PROCESS_TYPE[i].checked = true;
						break;
					}
				}
			}
			//품목구분
			$("#ITEM_MAKE_TYPE").val($("#ITEM_MAKE_TYPE_HIDDEN").val()).prop("selected",true);
			//과세구분
			$("#TAX_TYPE").val($("#TAX_TYPE_HIDDEN").val()).prop("selected",true);
			//제출금액,배송일수,최소주문수량,주문배수수량
			$("#st_stoa_list_price_text").val(kepCommaNum($("#ORG_STOA_LIST_PRICE").val()));
			$("#st_lead_time_text").val(kepCommaNum($("#LEAD_TIME").val()));
			$("#st_min_order_qty_text").val(kepCommaNum($("#MIN_ORDER_QTY").val()));
			$("#st_pur_unit_qty_text").val(kepCommaNum($("#PUR_UNIT_QTY").val()));
			if($("#ORG_STOA_LIST_PRICE").val() != 0){ //가져온 단가가 있는 경우에만 계산
				vatCalculate();
			}
			//이미지 파일 있는 경우
			var IMGFILE_DIR = $("#IMGFILE_DIR").val();
			var IMGFILE_NAME = $("#IMGFILE_NAME").val();
			var IMGFILE_FLAG = "Y";
			
			if(IMGFILE_NAME != ""){
				var lastIndex = IMGFILE_NAME.lastIndexOf(".");
				var fileName = IMGFILE_NAME.substring(0,lastIndex);
				var fileExt = IMGFILE_NAME.substring(lastIndex+1);
				
				uploadFileName = fileName;
				uploadFileExt = fileExt;
				var newHtml = '<div class="UploaderList"><div class="UploaderListImg" ><img class="Delete" src="/resources/imgs/delete_02.png" style="cursor:pointer;" onclick="javascript:deleteImageFile();"/>'+'<img class="img" src="/resources/imgs/Add_file.png" style="cursor:pointer;" onclick="javascript:downLoadFile(\''+IMGFILE_DIR+'\',\''+IMGFILE_NAME+'\',\''+IMGFILE_FLAG+'\');" /><div class="Txt"><p>'+fileName+'</p><span>'+fileExt+'</span></div></div></div>';
			  	$("#UploadDiv").empty().append(newHtml);
			}
			//첨부파일 있는 경우
			<%if(fileData != null && fileData.size() !=0){%>
				$("#DOC_NO").val($("#SELLER_IMAGE_KEY").val());
				
				<%for(int i = 0; i<fileData.size(); i++){%>
					var fileName = '<%=fileData.get(i).get("SRC_FILE_NAME")%>';
					var fileSeq = '<%=fileData.get(i).get("DOC_SEQ")%>';
					norFileStore[fileSeq]= fileName;
				<%}%>
				makeFileList();
				
			<%}%>
		}else{
			$("#st_stoa_list_price_text").text(kepCommaNum($("#ORG_STOA_LIST_PRICE").val()));
			$("#st_lead_time_text").val(kepCommaNum($("#LEAD_TIME").val()));
			$("#st_min_order_qty_text").val(kepCommaNum($("#MIN_ORDER_QTY").val()));
			$("#st_pur_unit_qty_text").val(kepCommaNum($("#PUR_UNIT_QTY").val()));
			vatCalculate();
		}
		
	<%}%>
}

function setQuery(){
  $('#searchCondition').attr("action", "/mprq/getSellerMpRqQuotaDetailPop_v2.do").submit();    
}

function doAction(str) {

	switch (str) {
		case "agentHandout":
			$('#st_giveup_yn').val("N");
			agentHandout(str);
			break;
		case "cancel":
			$('#st_giveup_yn').val("Y");
			agentHandout(str);
			break;
		case "save":
			saveInfo();
			break;
	}
}
function validateCheck(flag){
	var RFQ_IMG_FLAG = $("#RFQ_IMG_FLAG").val();
	var IMGFILE_NAME = $("#IMGFILE_NAME").val();
	var SELLER_IMAGE_KEY = $("#SELLER_IMAGE_KEY").val();
	var LEAD_TIME = Number($("#LEAD_TIME").val());
	var ORG_STOA_LIST_PRICE = $("#ORG_STOA_LIST_PRICE").val();
	var DELI_AREA_USE_FLAG = $("#DELI_AREA_USE_FLAG").val();
	var PROCESS_TYPE_FLAG = $("#PROCESS_TYPE_FLAG").val();
	var MIN_ORDER_QTY = $("#MIN_ORDER_QTY").val();
	var PUR_UNIT_QTY = $("#PUR_UNIT_QTY").val();
	var SELLER_AREA = $("#SELLER_AREA").val();
	var PROCESS_TYPE = $("input[name='PROCESS_TYPE']:checked").val();
	var PRE_GR_FLAG = $("input[name='QTDT_PRE_GR_FLAG']:checked").val();
	var ITEM_MAKE_TYPE = $("#ITEM_MAKE_TYPE").val();
	var SELLER_ITEM_NO = $("#SELLER_ITEM_NO").val();
	var SG_ID = $("#SG_ID").val();
	var	PLANT = $("#PLANT").val();
	var STOA_REMARK = $("#STOA_REMARK_TEXT").val();
	
	$("#PRE_GR_FLAG").val(PRE_GR_FLAG);
	STOA_REMARK = STOA_REMARK.replace(/\r?\n/g, '<br>');
	$("#STOA_REMARK").val(STOA_REMARK);
	
	if(RFQ_IMG_FLAG == "Y" && kepIsValueNull(IMGFILE_NAME)){
//     	alert("해당 품목 이미지첨부가 필요합니다.");
    	var text = "해당 품목 이미지첨부가 필요합니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
    	return false;
	}	
		
	if(ITEM_MAKE_TYPE == "" || kepIsValueNull(ITEM_MAKE_TYPE) ){
// 		alert("품목구분을 선택하여 주십시요.");
		var text = "품목구분을 선택해주세요.";
		openLayerPopText2(text,but1text,but1func,but1width);
		$("#ITEM_MAKE_TYPE").focus();
		return false;
	}
	if(LEAD_TIME < 1){
// 		alert("배송일수는 0보다 큰 숫자로 입력하세요.");
		var text = "배송일수는 0보다 큰 숫자로 입력하세요.";
		openLayerPopText2(text,but1text,but1func,but1width);
		$("#st_lead_time_text").focus();
		return false;
	}
	
	if(kepIsValueNull(LEAD_TIME) || isNaN(LEAD_TIME)) {
// 		 alert("배송일수(숫자형식)를 입력하여 주십시요.");
		 var text = "배송일수(숫자형식)를 입력해주세요.";
			openLayerPopText2(text,but1text,but1func,but1width);
		 $("#st_lead_time_text").focus();
         return false;
	}
	
	if(kepIsValueNull(ORG_STOA_LIST_PRICE) || isNaN(ORG_STOA_LIST_PRICE)) {
// 		 alert("제출단가(숫자형식)를 입력하여 주십시요.");
		 var text = "제출단가(숫자형식)를 입력해주세요.";
			openLayerPopText2(text,but1text,but1func,but1width);
		 $("#st_stoa_list_price_text").focus();
         return false;
	}
	
	if(ORG_STOA_LIST_PRICE <= 1) {
// 		alert("유효하지 않는 견적단가입니다.");
		var text = "유효하지 않는 견적단가입니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		$("#st_stoa_list_price_text").focus();
		return false;
	}
		
	if(kepIsValueNull(MIN_ORDER_QTY) || MIN_ORDER_QTY < 1 || !kepIsNumChkStr(MIN_ORDER_QTY,2) || isNaN(MIN_ORDER_QTY)){
// 		alert("최소주문수량을 숫자형식으로 입력하여 주십시요.");
		var text = "최소주문수량을 숫자형식으로 입력해주세요.";
		openLayerPopText2(text,but1text,but1func,but1width);
		$("#st_min_order_qty_text").focus();
		return false;
	}
	if(kepIsValueNull(PUR_UNIT_QTY) || PUR_UNIT_QTY < 1 || !kepIsNumChkStr(PUR_UNIT_QTY,2) || isNaN(PUR_UNIT_QTY)){
// 		alert("주문배수수량을 숫자형식으로 입력하여 주십시요.");
		var text = "주문배수수량을 숫자형식으로 입력해주세요.";
		openLayerPopText2(text,but1text,but1func,but1width);
		$("#st_pur_unit_qty_text").focus();
		return false;
	}
	if( MIN_ORDER_QTY < PUR_UNIT_QTY ){
// 		alert("최소주문수량은 주문배수수량보다 작을 수 없습니다.");
		var text = "최소주문수량은 주문배수수량보다 작을 수 없습니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		$("#st_min_order_qty_text").focus();
		return false;
	}
	if(PROCESS_TYPE_FLAG == "Y"){
		if(kepIsValueNull(PROCESS_TYPE)){
// 			alert("거래유형을 선택하여 주십시요.");
			var text = "거래유형을 선택해주세요.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return false;
		}
	}
	
	if(DELI_AREA_USE_FLAG == "Y"){
		var sellerArea = $("input[name='st_area_code']:checked").map(function(){
			return this.value+"__";
		}).get().join("");
		
		if(kepIsValueNull(sellerArea)){
// 			alert("납품지역을 선택하여 주십시요.");
			var text = "납품지역을 선택해주세요.";
			openLayerPopText2(text,but1text,but1func,but1width);
			return false;
		}
		$("#SELLER_AREA").val(sellerArea);
	}
	
	if(<%=p03302303%> == true){
		if(SELLER_ITEM_NO == "" || kepIsValueNull(SELLER_ITEM_NO)){
// 			alert("협력사품목코드를 입력하여 주십시요.");
			var text = "협력사품목코드를 입력해주세요.";
			openLayerPopText2(text,but1text,but1func,but1width);
			$("#SELLER_ITEM_NO").focus();
			return;
		}
	}
	
	if(SG_ID == "SG118" || SG_ID == "SG120" || SG_ID == "SG153" || SG_ID == "SG163"){
// 		alert("냉장 / 냉동 품목은 TR(물류센터) 거래 불가능합니다.\n견적 제출 전 협력사비고란에 품목 보관조건을 꼭 기재하여 제출 부탁드립니다.");
		var text = "냉장 / 냉동 품목은 TR(물류센터) 거래 불가능합니다.</br>견적 제출 전 협력사비고란에 품목 보관조건을 꼭 기재하여 제출 부탁드립니다.";
		if(flag == "1"){ //견적제출
			var but1funcTmp = "javascript:saveSellerMpRqQuotaDetailReqListConfirm(); return false;";
			openLayerPopText2(text,but1text,but1funcTmp,but1width);
		}else{ //수정제출
			var but1funcTmp = "javascript:saveInfoConfirm(); return false;";
			openLayerPopText2(text,but1text,but1funcTmp,but1width);
		}
		
	}else{
		return true;
	}
	
}
function saveInfoConfirm(){
	closePopText2();
	var text = "수정제출 하시겠습니까?";
	var but1textC = "확인";
	var but2textC = "취소";
	var but1funcC = "javascript:saveSellerMpRqQuotaDetailProceList(); return false;";
	var but2funcC = "javascript:closePopText1(); return false;";
	var but1widthC = "120px";
	var but2widthC = "120px";
	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
}
function saveSellerMpRqQuotaDetailReqListConfirm(){
	closePopText2();
	var text = "견적을 제출하시겠습니까?";
	var but1textC = "확인";
	var but2textC = "취소";
	var but1funcC = "javascript:saveSellerMpRqQuotaReqList_v2(); return false;";
	var but2funcC = "javascript:closePopText1(); return false;";
	var but1widthC = "120px";
	var but2widthC = "120px";
	openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
}
function saveSellerMpRqQuotaReqList_v2(){
	closePopText1();
	kepAjaxFormCall("/mprq/saveSellerMpRqQuotaDetailReqList_v2.do","searchCondition","saveSellerMpRqQuotaReqList_v2");
}
function agentHandout(btnEvent){ // 견적 제출, 포기
	if(btnEvent == "agentHandout"){
		if(validateCheck("1")){ //입력값 체크
			var text = "견적을 제출하시겠습니까?";
			var but1textC = "확인";
			var but2textC = "취소";
			var but1funcC = "javascript:saveSellerMpRqQuotaReqList_v2(); return false;";
			var but2funcC = "javascript:closePopText1(); return false;";
			var but1widthC = "120px";
			var but2widthC = "120px";
			openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
// 			if(confirm("견적을 제출하시겠습니까?")){
// 				kepAjaxFormCall("/mprq/saveSellerMpRqQuotaDetailReqList_v2.do","searchCondition","saveSellerMpRqQuotaReqList_v2");
// 			}
		}else{
			return;
		}
	}else{
		var text = "견적을 포기하시겠습니까?";
		var but1textC = "확인";
		var but2textC = "취소";
		var but1funcC = "javascript:estimateAbandonmentReasonPop(); return false;";
		var but2funcC = "javascript:closePopText1(); return false;";
		var but1widthC = "120px";
		var but2widthC = "120px";
		openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
		
// 		if(confirm("견적을 포기하시겠습니까?")){
// 			var src = '/common/mprq/estimateAbandonmentReasonPop.do?popupCheck=Y';
// 			openLayerPop2(src,"560px","400px");
	        
// // 			openSearchPopup("/common/mprq/estimateAbandonmentReasonPop.do", "", "560,400,no");
// 		}
	}
}
function estimateAbandonmentReasonPop(){
	closePopText1();
	var src = '/common/mprq/estimateAbandonmentReasonPop.do?popupCheck=Y';
	openLayerPop2(src,"560px","400px");
}
function AgentGiveUp(reason) { 
	$("#GIVEUP_REMARK").val(reason);    
	
	kepAjaxFormCall("/mprq/saveSellerMpRqQuotaDetailReqList_v2.do","searchCondition","saveSellerMpRqQuotaReqList_v2");
}
function saveInfo(){
	if(validateCheck("2")){
		var text = "수정제출 하시겠습니까?";
		var but1textC = "확인";
		var but2textC = "취소";
		var but1funcC = "javascript:saveSellerMpRqQuotaDetailProceList(); return false;";
		var but2funcC = "javascript:closePopText1(); return false;";
		var but1widthC = "120px";
		var but2widthC = "120px";
		openLayerPopText(text,but1textC,but2textC,but1funcC,but2funcC,but1widthC,but2widthC);
		
// 		if(confirm("저장 하시겠습니까?")){
// 			kepAjaxFormCall("/mprq/saveSellerMpRqQuotaDetailProceList_v2.do","searchCondition","saveSellerMpRqQuotaDetailProceList_v2");
// 		}
	}else{
		return;
	}
}
function saveSellerMpRqQuotaDetailProceList(){
	closePopText1();
	kepAjaxFormCall("/mprq/saveSellerMpRqQuotaDetailProceList_v2.do","searchCondition","saveSellerMpRqQuotaDetailProceList_v2");
}
function imgFileUploadOpen(){
	$("#imgFile").click();
}
function imgFileUpload(){
	if(uploadFileName != ""){
// 		alert("기존 첨부 파일을 삭제하고 진행해주시기 바랍니다.");
		var text = "기존 첨부 파일을 삭제하고 진행해주시기 바랍니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}	
	dropFile = null;
	
	var lastIndex = $("#imgFile")[0].files[0].name.lastIndexOf(".");
	var fileName = $("#imgFile")[0].files[0].name.substring(0,lastIndex);
	var fileExt = $("#imgFile")[0].files[0].name.substring(lastIndex+1);
	var ext = $("#imgFile")[0].files[0].name.substring(lastIndex).toLowerCase();
	
	if (fileName == ""){
// 		alert("이미지를 선택하세요.");
		var text = "이미지를 선택하세요.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	if (ext != ".jpg" && ext != ".jpeg" && ext != ".gif" && ext != ".png"){
// 		alert("이미지 업로드 할 수 없는 확장자 입니다.");
		var text = "이미지 업로드 할 수 없는 확장자 입니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	uploadFileName = fileName;
	uploadFileExt = fileExt;
	
	document.forms["searchCondition"].target = "account_work";
	document.forms["searchCondition"].method = "post";
	document.forms["searchCondition"].action ="/mprq/addImgRegPop.do";
	document.forms["searchCondition"].submit();
}
function upSet(docNo){ //이미지 업로드 후처리 함수
	var mg_arr = docNo.split("^");
  	$("#IMGFILE_DIR").val(mg_arr[0]);
  	$("#IMGFILE_NAME").val(mg_arr[1]);
//   	alert("이미지가 첨부되었습니다.");
  	var text = "이미지가 첨부되었습니다.";
	openLayerPopText2(text,but1text,but1func,but1width);
  	
  	var imgFileDir = $("#IMGFILE_DIR").val();
  	var imgFileName = $("#IMGFILE_NAME").val();
  	var imgFlag = "Y";
  	var newHtml = '<div class="UploaderList" id="imgDrop"><div class="UploaderListImg" ><img class="Delete" src="/resources/imgs/delete_02.png" style="cursor:pointer;" onclick="javascript:deleteImageFile();"/>'+'<img class="img" src="/resources/imgs/Add_file.png" style="cursor:pointer;" onclick="javascript:downLoadFile(\''+imgFileDir+'\',\''+imgFileName+'\',\''+imgFlag+'\');" /><div class="Txt"><p>'+uploadFileName+'</p><span>'+uploadFileExt+'</span></div></div></div>';
  	$("#UploadDiv").empty().append(newHtml);
  	
}
function deleteImageFile(){ //서버에 업로드 된 파일은 안지우고 화면상으로만 교체
// 	alert("이미지가 삭제되었습니다.");
	var text = "이미지가 삭제되었습니다.";
	openLayerPopText2(text,but1text,but1func,but1width);
	dropFile = null;
	$("#imgFile").val("");
	$("#imgFileDrag").val("");
	$("#IMGFILE_DIR").val("");
  	$("#IMGFILE_NAME").val("");
  	uploadFileName = "";
	uploadFileExt = "";
  	
  	var newHtml = '<div class="Uploader" id="imgDrop"><p class="Title"><img src="/resources/imgs/Icon_Drop.png" /><br/>이미지를 넣으시면 등록됩니다</p></div>';
  	$("#UploadDiv").empty().append(newHtml);
  	
}
function norFileUploadOpen(){
	$("#norFile").click();
}
function norFileUpload(filesList){
	var fileLength = 0;
	var newFile;
	if(filesList == undefined){ //파일찾기로 첨부
		fileLength = Array.from($("#norFile").prop("files")).length; //첨부파일 갯수
		newFile = Array.from($("#norFile").prop("files"));
	}else{ //드래그앤드랍으로 첨부
		fileLength = Array.from(filesList).length; //첨부파일 갯수
		newFile = Array.from(filesList);
		dropNorFile = filesList;
	}
	if(fileLength + Object.keys(norFileStore).length > 5){//최대 5개까지 첨부
// 		alert("최대 5개 까지만 첨부 가능합니다.");
		var text = "최대 5개 까지만 첨부 가능합니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		dropNorFile = null;
		return;
	}
	
	var banArray = [".csv",".enc",".ncf",".txt",".gif",".png",".jpg",".jpeg",".bmp",".sit",".xls",".doc",".docx",".hwp",".ppt",".pptx",".pdf",".tif",".tiff",".xlsx",".zip",".dwg",".ai",".gul",".mht"];
	
	var fileCheck = false;
	newFile.forEach(function(f){
		//확장자 체크 
		var dot = f.name.lastIndexOf(".");
		var ext = f.name.substring(dot).toLowerCase();
		
		if(banArray.indexOf(ext) == -1){
// 			alert("첨부할 수 없는 확장자입니다.");
			var text = "첨부할 수 없는 확장자입니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			dropNorFile = null;
			return;
		}
		for(var key in norFileStore){
			var fileStoreName = norFileStore[key];
			if(fileStoreName == f.name){
// 				alert("이미 선택한 파일입니다.");
				var text = "이미 선택한 파일입니다.";
				openLayerPopText2(text,but1text,but1func,but1width);
				fileCheck = true; //중복여부
				return;
			}
		}
	})
	if(fileCheck)
		return;
	
	//드래그앤드랍
	if(filesList != undefined){
		var form = $("#searchCondition");
		form.find("#imgNorFileDrag").remove();
		var fileInput = $('<input type="file" name="files" id="imgNorFileDrag" style="display:none;">');
		form.append(fileInput);
		
		var dataTransfer = new DataTransfer();
		for(var i = 0; i<filesList.length; i++){
			dataTransfer.items.add(filesList[i]);
		}
		
		fileInput[0].files = dataTransfer.files;
	}
	
	document.forms["searchCondition"].target = "fileUpload";
	document.forms["searchCondition"].method = "post";
	document.forms["searchCondition"].action ="/common/fileUpload_v2.do";
	document.forms["searchCondition"].submit();
	
}
function upFileSet(docNo,key,result,extCheck){ //첨부파일 업로드 후처리 함수
	if(result == "E"){ // 확장자 오류
// 		alert(extCheck+" 파일은 첨부할 수 없는 파일입니다.");
		var text = extCheck+" 파일은 첨부할 수 없는 파일입니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}else if(result != "S"){ //정상 업로드
		$("#DOC_NO").val(docNo);
		$("#SELLER_IMAGE_KEY").val(docNo);
// 		alert("파일이 첨부되었습니다.");
		var text = "파일이 첨부되었습니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		//해당 파일 list에 넣고 화면 그려주기
		var keyArr = key.split(",");
		var newFile;
		if(dropNorFile != undefined && dropNorFile != null){
			newFile = Array.from(dropNorFile);
			dropNorFile = null;
			$("#imgNorFileDrag").val(""); //초기화
			
		}else{
			newFile = Array.from($("#norFile").prop("files"));
			$("#norFile").val(""); //초기화
		}
		var seq = 0;
		newFile.forEach(function(f){
			norFileStore[keyArr[seq]]= f.name;
			seq++;
		})
		makeFileList();
	}
}
function makeFileList(){
	
	var newHtml = "";
	$("#UploadFileDiv").empty();
	
	if(Object.keys(norFileStore).length == 0){ //다 삭제 된 경우
		$("#SELLER_IMAGE_KEY").val("");
		$("#DOC_NO").val("");
		
		$("#imgNorFileDrag").val("");
		newHtml = '<div class="Uploader" id="fileDrop"><p class="Title"><img src="/resources/imgs/Icon_Drop.png" /><br/>파일을 끌어다 넣으시거나 [파일찾기] 버튼을 통해 등록가능합니다.</p></div>';
		$("#UploadFileDiv").append(newHtml);
		
	}else{
		newHtml = '<div class="UploaderList" id="fileDrop">';
		for(var key in norFileStore){
			
			var lastIndex = norFileStore[key].lastIndexOf(".");
			var fileName = norFileStore[key].substring(0,lastIndex);
			var ext = norFileStore[key].substring(lastIndex+1);
			
			var docNo = $("#DOC_NO").val();
		  	
			newHtml += '<div class="UploaderListImg" ><img class="Delete" src="/resources/imgs/delete_02.png" style="cursor:pointer;" onclick="javascript:deleteNorFile(\''+key+'\');"/>'+'<img class="img" src="/resources/imgs/Add_file.png" style="cursor:pointer;" onclick="javascript:downLoadFile(\''+docNo+'\',\''+key+'\');" /><div class="Txt"><p>'+fileName+'</p><span>'+ext+'</span></div></div>';
		}
		newHtml += '</div>';
		$("#UploadFileDiv").append(newHtml);
	}
	
	
}
function deleteNorFile(key){ //서버에 업로드 된 파일은 안지우고 화면상으로만 교체
	
	$("#D_DOC_NO").val($("#DOC_NO").val());
	$("#D_DOC_SEQ").val(key);
	
	kepAjaxFormCall("/common/removeFileInfo.do","deleteFile","Delete");
	
}

function downLoadFile(value,value2,value3){
	if(value3 == "Y"){ //이미지 파일 다운로드
		location.href="/common/download_v2.do?IMGFILE_DIR="+value+"&IMGFILE_NAME="+value2+"&IMG_YN="+value3;
	}else{// 나머지 파일 다운로드
		if(value2==undefined){
			value2 = "";
		}
		location.href="/common/download_v2.do?DOC_NO="+value+"&DOC_SEQ="+value2;
	}
}
function checkNum(flag,event){
	if(flag == "price"){
		if(event.key == "-"){
			return false;
		}
		return true;
	}else{
		if(event.key == "-" || event.key == "."){
			return false;
		}
		return true;
	}
	
}
function vatCalculate(){
	
	var agent_sourcing_status = $("#AGENT_SOURCING_STATUS").val();
	var modify_flag = $("#MODIFY_FLAG").val();
	var stoa_list_price;
	if((agent_sourcing_status == "견적제출" && modify_flag=="Y") || agent_sourcing_status == "재견적요청" || agent_sourcing_status == "신규견적요청"){
		stoa_list_price = kepRemoveComma($("#st_stoa_list_price_text").val());
		stoa_list_price = stoa_list_price.replace(/\s/g,"");
		if($("#st_stoa_list_price_text").val() != "" && Number(stoa_list_price) <= 0){
// 			alert("유효하지 않는 견적단가입니다.");
			var text = "유효하지 않는 견적단가입니다.";
			openLayerPopText2(text,but1text,but1func,but1width);
			$("#st_stoa_list_price_text").val("");
			return;
		}
		if(isNaN(stoa_list_price)){
// 			alert("제출단가를 숫자형식으로 입력하여 주십시요.");
			var text = "제출단가를 숫자형식으로 입력하여 주십시요.";
			openLayerPopText2(text,but1text,but1func,but1width);
			$("#st_stoa_list_price_text").val("");
			return;
		}
	}else{
		stoa_list_price = kepRemoveComma($("#st_stoa_list_price_text").text());
	}
	
	
	
	var st_tax_type = $("#TAX_TYPE").val();
	var item_qty = $("#item_qty").text();
	
	if(st_tax_type =="12"){//면세
		$("#st_stoa_vat_list_price").text(kepCommaNum(stoa_list_price));
		$("#st_stoa_list_price_amt").text(kepCommaNum(stoa_list_price * Number(item_qty)));
		$("#st_stoa_vat_list_price_amt").text(kepCommaNum(stoa_list_price * Number(item_qty)));
	}else{//과세
		$("#st_stoa_vat_list_price").text(kepCommaNum(kepGetRound2(stoa_list_price*1.1,1)));
		$("#st_stoa_list_price_amt").text(kepCommaNum(stoa_list_price * Number(item_qty)));
		$("#st_stoa_vat_list_price_amt").text(kepCommaNum(kepGetRound2(stoa_list_price*1.1* Number(item_qty),1)));
	}
	$("#ORG_STOA_LIST_PRICE").val(stoa_list_price);
	if((agent_sourcing_status == "견적제출" && modify_flag=="Y") || agent_sourcing_status == "재견적요청" || agent_sourcing_status == "신규견적요청"){
		$("#st_stoa_list_price_text").val(kepCommaNum(Number(stoa_list_price)));
	}else{
		$("#st_stoa_list_price_text").text(kepCommaNum(Number(stoa_list_price)));
	}
	
}
function changeLeadTime(){
	var st_item_make_type = $("#ITEM_MAKE_TYPE").val();
	var st_lead_time = $("#LEAD_TIME").val();
	var new_lead_time = 0;
	
	if( st_item_make_type == "ST"){
		new_lead_time = 3;
	}else if( st_item_make_type == "MK"){
		new_lead_time = 7;
	}else if( st_item_make_type == "SI" || st_item_make_type == "MI"){
		new_lead_time = 30;
	}
	
	if(st_lead_time != ""){
// 		alert("선택하신 품목구분에 따라 기본 배송일수가 자동으로 변경되었습니다. 변경된 배송일수를 확인해 주세요.");
		var text = "선택하신 품목구분에 따라 기본 배송일수가 자동으로 변경되었습니다.</br>변경된 배송일수를 확인해 주세요.";
		openLayerPopText2(text,but1text,but1func,but1width);
	}
	
	$("#LEAD_TIME").val(new_lead_time);
	$("#st_lead_time_text").val(kepCommaNum($("#LEAD_TIME").val()));
}
function addComma(el,id){
	el.value = el.value.replace(/\s/g,"");
	if(el.value != "" && Number(el.value) <= 0){
// 		alert("0보다 큰 숫자로 입력해주시기 바랍니다.");
		var text = "0보다 큰 숫자로 입력해주시기 바랍니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		el.value = "";
		return;
	}
	if(isNaN(el.value)){
// 		alert("숫자형식으로 입력해주시기 바랍니다.");
		var text = "숫자형식으로 입력해주시기 바랍니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		el.value = "";
		return;
	}
	$("#"+id).val(el.value); //콤마 붙이기전 값은 실제 보낼 데이터에 저장
	var value = kepCommaNum(Number(el.value));
	el.value = value;
	
}

//ajax 공통 호출후 성공시 처리 함수
function kepAjaxSuccess(pMethod , response){
	var msg = response.msg;
	if(pMethod == "saveSellerMpRqQuotaReqList_v2" || pMethod == "saveSellerMpRqQuotaDetailProceList_v2"){
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1funcSearch,but1width);
	}else if(pMethod == "Delete"){ //key 받아서 해당 파일 삭제
// 		alert("첨부파일이 삭제되었습니다.");
		var text = "첨부파일이 삭제되었습니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		delete norFileStore[response.key];
		makeFileList();
	}
	return;
}

//ajax 공통 호출후 실패시 처리 함수
function kepAjaxError(pMethod , response){
	var msg = response.msg;
	
	if (!isEmpty(msg)){
// 		alert(msg);
		var text = msg;
		openLayerPopText2(text,but1text,but1func,but1width);
		
	}
	return;
}

//이미지 드래그앤드랍으로 첨부 구현
//이미지 2번 드래그앤드랍 할 경우 브라우저로 열리는 것 방지
$(document).on("dragover drop", function(e) {
  e.preventDefault();
  e.stopPropagation();
});
//드래그 오버
$(document).on('dragover',"#imgDrop", function(e) {
  e.preventDefault();
  e.stopPropagation();
  $(this).addClass('dragover');
});

// 드래그 아웃
$(document).on('dragleave',"#imgDrop", function(e) {
  e.preventDefault();
  e.stopPropagation();
  $(this).removeClass('dragover');
});

// 파일 드롭
$(document).on('drop',"#imgDrop", function(e) {
  e.preventDefault();
  e.stopPropagation();
  $(this).removeClass('dragover');
  if(uploadFileName != ""){
// 	alert("기존 첨부 파일을 삭제하고 진행해주시기 바랍니다.");
	var text = "기존 첨부 파일을 삭제하고 진행해주시기 바랍니다.";
	openLayerPopText2(text,but1text,but1func,but1width);
	return;
  }
  
  var file = e.originalEvent.dataTransfer.files[0]; //이미지는 1개 첨부라 고정
  handleImgFiles(file);
});
function handleImgFiles(file){
	
	var lastIndex = file.name.lastIndexOf(".");
	var fileName = file.name.substring(0,lastIndex);
	var fileExt = file.name.substring(lastIndex+1);
	var ext = file.name.substring(lastIndex).toLowerCase();
	
	if (fileName == ""){
// 		alert("이미지를 선택하세요.");
		var text = "이미지를 선택하세요.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	} 	
	if (ext != ".jpg" && ext != ".jpeg" && ext != ".gif" && ext != ".png"){
// 		alert("이미지 업로드 할 수 없는 확장자 입니다.");
		var text = "이미지 업로드 할 수 없는 확장자 입니다.";
		openLayerPopText2(text,but1text,but1func,but1width);
		return;
	}
	
	dropFile = file;
	
	uploadFileName = fileName;
	uploadFileExt = fileExt;
	
	var form = $("#searchCondition");
	form.find("#imgFileDrag").remove();
	var fileInput = $('<input type="file" name="files1" id="imgFileDrag" style="display:none;">');
	form.append(fileInput);
	
	var dataTransfer = new DataTransfer();
	dataTransfer.items.add(file);
	fileInput[0].files = dataTransfer.files;
	
	document.forms["searchCondition"].target = "account_work";
	document.forms["searchCondition"].method = "post";
	document.forms["searchCondition"].action ="/mprq/addImgRegPop.do";
	document.forms["searchCondition"].submit();
}

//일반 파일첨부 드래그앤드랍 구현
$(document).on("dragover drop", function(e) {
e.preventDefault();
e.stopPropagation();
});
//드래그 오버
$(document).on('dragover',"#fileDrop", function(e) {
e.preventDefault();
e.stopPropagation();
$(this).addClass('dragover');
});

//드래그 아웃
$(document).on('dragleave',"#fileDrop", function(e) {
e.preventDefault();
e.stopPropagation();
$(this).removeClass('dragover');
});

//파일 드롭
$(document).on('drop',"#fileDrop", function(e) {
e.preventDefault();
e.stopPropagation();
$(this).removeClass('dragover');

norFileUpload(e.originalEvent.dataTransfer.files);
});

function checkedAllBox(){
	var AreaCount = $("#AreaCount").val();
	var check = $("#checkedAll").is(":checked");
	for(var i=0; i<AreaCount; i++){
		$("#st_area_code"+i).prop("checked",check);
	}
}
function thisPopClose(){
	closePopText2();
	parent.doAction('search');
	parent.closePop();
}
//text타입에서 엔터 눌렀을때 브라우저 자동 submit이 되면서 파일찾기가 열리는 현상 때문에 text타입에서 엔터 막기
$(document).on('keydown', 'input[type=text]', function(e) {
  if (e.key === 'Enter') e.preventDefault();
});

</script> 
</html>
