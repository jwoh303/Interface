<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.koreab2b.mro.util.CommonUtil"%>
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
String result = CommonUtil.nvl((String) request.getAttribute("result")); // 조회된결과   

Map<String,String> rowData = null;
if (_dataList==null || _dataList.size()==0){	
}else{
	rowData = _dataList.get(0);
}
%>
<script type="text/javascript">
<!--
function getBigImage(){

    var file_dir  = document.forms[0].st_imgfile_dir.value;
    var file_name = document.forms[0].st_imgfile_name.value;

	getBigImageView("<%= CommonUtil.getURL(request) %><%=CommonUtil.realImgS3UploadPath%>", file_dir, file_name);
}

function setQuery()
{  	 
  $('#catalogDetailDongbuPop').attr("action", "/common/commonList.do").submit();   
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
 

 //-->
</script> 
<body <%if ("".equals(result)) { %> onload="setQuery()"<%} %>>
	 <form name=catalogDetailDongbuPop id=catalogDetailDongbuPop method=post >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="catalogDetailDongbuPop"> 
	 <input type="hidden" name="BUYER" id="BUYER"  value="<%=BUYER%>">
	 <input type="hidden" name="BUYER_ITEM_NO" id="BUYER_ITEM_NO"  value="<%=BUYER_ITEM_NO%>"> 
	  
	<div id="popWrapper" style="min-height: 100px;">
    	<div id="popHeader">
        	<h1 class="title">상품정보</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/<%=_closeImgSrc %>" alt="닫기버튼" /></a></p>
        </div>
<%
if (_dataList==null || _dataList.size()==0){
%>
<%}else{ %>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	
            <table  class="cont_t_list06" style="width:100%;">
              <caption>상품정보 리스트</caption>
                <colgroup>
                    <col width="*" />
                    <col width="15%" />
                    <col width="20%" />
                    <col width="15%" />
                    <col width="20%" />
                </colgroup>
                <tbody>
                    <tr>
                        <td rowspan="6" scope="col" class="center">
                        	<% if ("".equals(CommonUtil.nvl(rowData.get("IMGFILE_NAME")))){ %>
							<img src="/resources/images/icon_emptyimg.gif"" name = "image1" width="150" height="150">
									<input type="hidden" name="st_imgfile_dir" value="">
		                            <input type="hidden" name="st_imgfile_name" value="">
							<%}else{ %>
							<img src="<%=CommonUtil.realImgS3UploadPath+"/"+CommonUtil.nvl(rowData.get("IMGFILE_DIR"))+"/"+CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>" name = "image1" width="150" height="150">
									<input type="hidden" name="st_imgfile_dir"  value="<%=rowData.get("IMGFILE_DIR")%>">
                                    <input type="hidden" name="st_imgfile_name" value="<%=rowData.get("IMGFILE_NAME")%>">
							<%} %>
							<br><a href="javascript:getBigImage()"><img src="/resources/images/zoom.gif" width="32" height="23" align="absmiddle" border="0"></a>
                        </td>
                        <th scope="row">카테고리명</th>
                       	<td><%=CommonUtil.nvl(rowData.get("CATEGORY_TEXT"))%></td>
                        <th scope="row">단위</th>
                       	<td><%=CommonUtil.nvl(rowData.get("UNIT_MEASURE"))%></td>
                    </tr>
                    <tr>
                      <th scope="row">제조사</th>
                      <td scope="col"><%=CommonUtil.nvl(rowData.get("MAKER_NAME"))%></td>
                      <th scope="col">품목코드</th>
                      <td scope="col"><%=CommonUtil.nvl(rowData.get("BUYER_ITEM_NO"))%></td>
                    </tr>
                    <tr>
                      <th scope="row">조달일수</th>
                      <td><%=CommonUtil.nvl(rowData.get("DELIVERY_LT"))%>일</td>
                      <th scope="row">원산지</th>
                      <td><%=CommonUtil.nvl(rowData.get("ORIGIN"))%></td>
                    </tr>
                    <tr>
                      <th scope="row">단가</th>
                      <td><%=CommonUtil.bnvl(rowData.get("UNIT_PRICE"))%>&nbsp;(<%=CommonUtil.bnvl(rowData.get("STATUS_TEXT"))%>)</td>
                      <th scope="row">협력사</th>
                      <td><%=CommonUtil.nvl(rowData.get("AGENT_TEXT"))%></td>
                    </tr>
                	<tr>
                        <th scope="row">품목명</th>
                        <td colspan="3"><%=CommonUtil.nvl(rowData.get("DESCRIPTION"))%></td>
                    </tr>
                    <tr>
                      <th scope="row">규격</th>
                      <td colspan="3"><%=CommonUtil.nvl(rowData.get("SPECIFICATION"))%></td>
                    </tr>
                </tbody>
            </table>
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
