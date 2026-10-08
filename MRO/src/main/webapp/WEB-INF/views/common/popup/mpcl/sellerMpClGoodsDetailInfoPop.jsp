<%--
**********************************************
* 메뉴 : 
* 화면 : 품목상세정보 
* 기능 : 
* 프로그램 ID : PG_03_A_003_02
* 담당자 : 홍석규 ( 설계 : 권우재 )
* 착수일 : 2014-07-11
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
<!--  <link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/seller_layout.css" type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>--> 
<%@ include file="../../../common/include/head_pop.jspf"  %>
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과 

String st_byit_comorg_code     = CommonUtil.nvl((String) request.getParameter("st_byit_comorg_code"),"");
String st_item_no              = CommonUtil.nvl((String) request.getParameter("st_item_no"),"");
String st_contract_no          = CommonUtil.nvl((String) request.getParameter("contract_no"),"");
String st_contract_seq         = CommonUtil.nvl((String) request.getParameter("contract_seq"),"");
String st_com_type         = CommonUtil.nvl((String) request.getParameter("st_com_type"),"");

Map<String,String> _rowData = null;
if (_dataList != null && _dataList.size() != 0) { 
	_rowData = _dataList.get(0);
}
%>

<script type="text/javascript">
<!--
function kepSearch()
{  
  $('#sellerMpClGoodsDetailInfoPop').attr("action", "/mpcl/getSellerMpClGoodsDetailInfoPop.do").submit();    
}

//팝업함수호출
function doPop(str) {
	
	switch (str) {
		case 	"fileUpload": //파일업로드
			var viewType = "R";
			openSearchPopup("/common/fileUploadPop.do", "?DOC_NO="+$("#st_image_key").val()+"&TYPE=ITEM&viewType="+viewType, "500,430,no");
			break;
	}
}

function setImageView(img_dr,img_name){

	if(img_name == "icon_emptyimg.gif" || img_name == "noimage.gif"){
		alert("등록된 이미지가 없습니다.");
		return;		
	}else{
		window.open('<%= CommonUtil.getURL(request) %>'+img_dr+ img_name,'bigImage','status=no,resizable=yes,menubar=no,scrollbars=no,"","",width=550,height=550');	
	}
	
}
 //-->
</script> 
<body onload="">
<form name="sellerMpClGoodsDetailInfoPop" id="sellerMpClGoodsDetailInfoPop" method=post >
<input type="hidden" name="st_byit_comorg_code" id="st_byit_comorg_code"  value="<%=st_byit_comorg_code%>">
<input type=hidden name="st_item_no" id="st_item_no"  value="<%=st_item_no%>">
<input type=hidden name="st_contract_no" id="st_contract_no"  value="<%=st_contract_no%>">
<input type=hidden name="st_contract_seq" id="st_contract_seq"  value="<%=st_contract_seq%>">
<input type=hidden name="st_com_type" id="st_com_type"  value="<%=st_com_type%>">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<%
		if("B".equals(st_com_type)){
	%>
	<div id="popWrapper" style="height:332px;">
	<%}else{%>
	<div id="popWrapper" style="height:324px;min-height: 324px;">
	<%}%>
	
    	<div id="popHeader">
        	<h1 class="title">품목상세정보 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
               
         	<!--grid-->
           <div style="height:258px">
		
		<% if (_rowData != null) {  %>
               <table  style="width:100%">
                   <caption>품목상세정보</caption>
                   <colgroup>
                   	<col width="220px" />
                    <col width="*" />
				</colgroup>
				<tbody>
					<tr>
						<td width="220" vAlign="top">
							<table border="0" cellSpacing="0" cellPadding="0" width="100%">
							<tbody>
								<tr>
									<td height="230" vAlign="top" align="center">&nbsp;&nbsp; &nbsp; 
									<%
	                                 String image_dr  = _rowData.get("IMGFILE_DIR");
	                                 String image_sm = _rowData.get("IMGFILE_NAME");
	                                 if (image_sm == null || image_sm.equals("null") || image_sm.equals("") || image_sm.equals(" ")){
	                                	 //고객사는 no image가 다름.
	                                	 if("B".equals(st_com_type)){
	                                		 image_sm = "noimage.gif";
	                                	 }else{
	                                		 image_sm = "icon_emptyimg.gif";	 
	                                	 }
	                                 }
	                                 if(image_sm.equals("icon_emptyimg.gif") || image_sm.equals("noimage.gif")) {
									%>
										<img src = "/resources/images/<%=image_sm%>"  id="image1" name="image1" width="200" height="200">
									<%}else{%>
										<img src = "<%=CommonUtil.realImgS3UploadPath+"/"+image_dr+"/"+image_sm%>"   id="image1" name = "image1" width="200" height="200" border="0">
									<%}%>
									</td>
									<td width="20">&nbsp;</TD>
								</tr>
							</tbody>
							</table>
							<table align="center" border="0" cellSpacing="0" cellPadding="0">
							<tbody>
							<tr>
								<td width="25">
									<a href="javascript:setImageView('<%=CommonUtil.realImgS3UploadPath+"/"+image_dr+"/"%>','<%=image_sm%>')">
										<img src="/resources/images/btn_search03.gif">
									</a>
								</td>
								<td>
									<a href="javascript:setImageView('<%=CommonUtil.realImgS3UploadPath+"/"+image_dr+"/"%>','<%=image_sm%>')">확대보기</a>
									<input id="st_image_dir" name=st_image_dir type=hidden value="<%=_rowData.get("IMGFILE_DIR")%>" > 
									<input id="st_image_name" name=st_image_name type=hidden value="<%=_rowData.get("IMGFILE_NAME")%>" > 
								</td>
							</tr>
							</tbody>
							</table>
						</td>
						<td align="center" vAlign="top" style="padding-top:25px">
						<p style="font-weight:bold; color:#003694; font-size:18px; font-weight:bold;" align="left">&nbsp;<%=_rowData.get("DESCRIPTION")%></P>
						<table  class="cont_t_list06"  style="width:100%">
							<colgroup>
			                    <col width="120px" />
			                    <col width="32%" />
			                    <col width="120px" />
			                    <col width="32%" />
			                </colgroup>
			                <tbody>
				                <tr>
			                        <th  scope="row">카테고리명</th>
			                      	<td>
			                      		<%=CommonUtil.nvl(_rowData.get("CATEGORY_TEXT"))%>
			                      	</td>
			                        <th  scope="row">단위</th>
			                      	<td>
			                      		<%=CommonUtil.nvl(_rowData.get("UNIT_MEASURE"))%>
			                      	</td>
			                    </tr>
			                    <tr>
			                        <th  scope="row">제조사</th>
			                      	<td>
			                      		<%=CommonUtil.nvl(_rowData.get("MAKER_NAME"))%>
			                      	</td>
			                        <th  scope="row">품목코드</th>
			                      	<td>
			                      		<%=CommonUtil.nvl(_rowData.get("BUYER_ITEM_NO"))%>
			                      	</td>
			                    </tr>
			                    <tr>
			                        <th  scope="row">조달일수</th>
			                      	<td>
			                      		<%=CommonUtil.nvl(_rowData.get("DELIVERY_LT"))%> 일
			                      	</td>
			                        <th  scope="row">원산지</th>
			                      	<td>
			                      		<%=CommonUtil.nvl(_rowData.get("ORIGIN"))%>
			                      	</td>
			                    </tr>
			                    <tr>
			                        <th  scope="row">단가</th>
			                      	<td>
			                      		<% if("B".equals(st_com_type)){ %>
				                      		<%=CommonUtil.formatNumber(String.valueOf(_rowData.get("UNIT_PRICE")),true,0,3)%>&nbsp;(현상태:<%=_rowData.get("STATUS_TEXT")%>)
				                      	<% }else{ %>
				                      		<%=CommonUtil.formatNumber(String.valueOf(_rowData.get("LIST_PRICE")),true,0,3)%>
				                      	<% } %>
			                      	</td>
			                        <th  scope="row">협력사</th>
			                      	<td>
			                      		<%=CommonUtil.nvl(_rowData.get("AGENT_TEXT"))%>
			                      	</td>
			                    </tr>
			                    <tr>
			                        <th  scope="row">품목명</th>
			                      	<td>
			                      		<%=CommonUtil.nvl(_rowData.get("DESCRIPTION"))%>
			                      	</td>
			                        <th  scope="row">첨부파일</th>
			                      	<td>
			                      	<%
										if(Integer.parseInt(_rowData.get("ATTACH_CNT"))>0) {
									%>
										<a href="javascript:doPop('fileUpload');">
			                      		<img src="/resources/images/disk_on.gif" name="CmsAtchImage" border="0">
		                            	<input type="hidden" id="st_image_key"  name="st_image_key" value="<%=_rowData.get("IMAGE_KEY")%>">
		                            	</a>
			                      	<% }%>	
			                      	</td>
			                    </tr>
			                    <tr>
			                        <th  scope="row">규격</th>
			                      	<td colspan="3">
			                      		<%=CommonUtil.nvl(_rowData.get("SPECIFICATION"))%>
			                      	</td>
			                    </tr>
			                </tbody>
							</table>
						</td>
					</tr>
				</tbody>
               </table>                  
       	<% }%>
       	</div>
    </div>        
</div>
</form> 
</body>
</html>
