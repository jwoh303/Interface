<%--
**********************************************
* 메뉴 : 
* 화면 : 품목상세정보(코웨이 관리자용)
* 기능 : 
* 프로그램 ID : 
* 담당자 : HSJ
* 착수일 : 2017-06-30
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
List<Map<String,String>> _hdDataList = (List<Map<String,String>>) request.getAttribute("hdData"); // 조회된 결과 
List<Map<String,String>> _dtDataList = (List<Map<String,String>>) request.getAttribute("dtData"); // 조회된 결과

String st_byit_comorg_code     = CommonUtil.nvl((String) request.getParameter("st_byit_comorg_code"),"");
String st_item_no              = CommonUtil.nvl((String) request.getParameter("st_item_no"),"");

Map<String,String> _rowHdData = null;
if (_hdDataList != null && _hdDataList.size() != 0) { 
	_rowHdData = _hdDataList.get(0);
}
%>

<script type="text/javascript">
<!--
function kepSearch()
{  
  $('#sellerMpClGoodsDetailInfoCowayPop').attr("action", "/mpcl/getSellerMpClGoodsDetailInfoCowayPop.do").submit();    
}

//팝업함수호출
function doPop(str) {
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
<form name="sellerMpClGoodsDetailInfoCowayPop" id="sellerMpClGoodsDetailInfoCowayPop" method=post >
<input type="hidden" name="st_byit_comorg_code" id="st_byit_comorg_code"  value="<%=st_byit_comorg_code%>">
<input type=hidden name="st_item_no" id="st_item_no"  value="<%=st_item_no%>">
<input type="hidden" name="st_buyer" id="st_buyer" value="${sessionInfo.comCode}">
<input type="hidden" name="st_user_id" id="st_user_id" value="${sessionInfo.userId}">

	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:332px;">
		<div id="popHeader">
			<h1 class="title">품목상세정보 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
		</div>
        <!--팝업내용입니다-->
        <div id="popContainer">
         	<!--grid-->
			<div style="height:258px">
		
		<% if (_rowHdData != null) {  %>
				<table  style="width:100%">
					<caption>품목대표정보</caption>
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
	                                 			String image_dr  = _rowHdData.get("IMGFILE_DIR");
	                                 			String image_sm = _rowHdData.get("IMGFILE_NAME");
	                                 			if (image_sm == null || image_sm.equals("null") || image_sm.equals("") || image_sm.equals(" ")){
                                		 			image_sm = "noimage.gif";
	                                 			}
	                                 			if(image_sm.equals("icon_emptyimg.gif") || image_sm.equals("noimage.gif")) {
											%>
												<img src = "/resources/images/<%=image_sm%>"  id="image1" name="image1" width="200" height="200">
											<%}else{%>
												<img src = "<%=CommonUtil.realImgS3UploadPath+"/"+image_dr+"/"+image_sm%>"   id="image1" name = "image1" width="200" height="200" border="0">
											<%}%>
											</td>
											<td width="20">&nbsp;</td>
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
												<input id="st_image_dir" name=st_image_dir type=hidden value="<%=_rowHdData.get("IMGFILE_DIR")%>" > 
												<input id="st_image_name" name=st_image_name type=hidden value="<%=_rowHdData.get("IMGFILE_NAME")%>" > 
											</td>
										</tr>
									</tbody>
								</table>
							</td>
							
							<td align="center" vAlign="top" style="padding-top:25px">
								<p style="font-weight:bold; color:#003694; font-size:18px; font-weight:bold;" align="left">&nbsp;<%=_rowHdData.get("DESCRIPTION")%></P>
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
			                      			<td><%=CommonUtil.nvl(_rowHdData.get("CATEGORY_TEXT"))%></td>
			                        		<th  scope="row">단위</th>
			                      			<td><%=CommonUtil.nvl(_rowHdData.get("UNIT_MEASURE"))%></td>
			                    		</tr>
			                    		
			                    		<tr>
			                        		<th  scope="row">품목코드</th>
			                      			<td colspan="3"><%=CommonUtil.nvl(_rowHdData.get("BUYER_ITEM_NO"))%></td>
			                    		</tr>
			                    	
			                    		<tr>
											<th  scope="row">품목명</th>
			                      			<td colspan="3"><%=CommonUtil.nvl(_rowHdData.get("DESCRIPTION"))%></td>
			                    		</tr>
			                    		
			                    		<tr>
			                        		<th  scope="row">규격</th>
											<td colspan="3"><%=CommonUtil.nvl(_rowHdData.get("SPECIFICATION"))%></td>
			                    		</tr>
			                		</tbody>
								</table>
							</td>
						</tr>
					</tbody>
				</table>
				<br>
       	<% }%>
       	
       	<% if (_dtDataList != null) {  %>
       			<div class="scrollArea" style="height:150px">
		       		<table id="table_list" class="cont_t_list02" style="width:100%">
						<colgroup>
							<col width="*" />
							<col width="16%" />
							<col width="20%" />
							<col width="*" />
				        </colgroup>
				        <thead>
							<tr>
				                <th scope="col">사업장</th>
				                <th scope="col">단가</th>
				                <th scope="col">제조사</th>
				                <th scope="col">협력사</th>
							</tr>
						</thead>
						<tbody>
			<%
				for (int j=0; j<_dtDataList.size(); j++) {
				Map<String,String> _rowDtData = _dtDataList.get(j);
			%> 
							<tr align="center">
								<td title="사업장" class="left"><%=CommonUtil.nvl(_rowDtData.get("BUYER_NAME"))%></td>
								<td title="단가"><%=CommonUtil.formatNumber(String.valueOf(_rowDtData.get("UNIT_PRICE")),true,0,3)%></td>
								<td title="제조사"><%=CommonUtil.nvl(_rowDtData.get("MAKER_NAME"))%></td>
								<td title="협력사"><%=CommonUtil.nvl(_rowDtData.get("AGENT_NAME"))%></td>
			       			</tr>
			<%}%>
			       		</tbody>
	            	</table>
	            </div>
		<%}%>     	
       	</div>
	</div>
</div>
</form>
</body>
</html>
