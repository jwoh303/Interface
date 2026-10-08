<%--
**********************************************
* 메뉴 : wms>입고진행관리
* 화면 : 품목코드
* 기능 : 
* 프로그램 ID : PG_08_M_900_04
* 담당자 : 김지혜 ( 설계 : 김상근 )
* 착수일 : 2014-6-11
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
<link rel="stylesheet" href="/resources/styles/base.css" type="text/css" />
<link rel="stylesheet" href="/resources/styles/buyer_layout.css" type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script> 
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된결과   
String result = CommonUtil.nvl((String) request.getAttribute("result")); // 조회된결과   
SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
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
<!--
function getBigImage(){

    var file_dir  = document.forms[0].st_imgfile_dir.value;
    var file_name = document.forms[0].st_imgfile_name.value;

	getBigImageView("<%= CommonUtil.getURL(request) %><%=CommonUtil.realImgS3UploadPath%>", file_dir, file_name);
}

function setQuery()
{  	 
  $('#catalogDetailDongbuPopMaster').attr("action", "/wmco/getMasterWmCoGoodsCodePop.do").submit();   
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
//물류비 책정 사유 팝업
function getLogisFeeReason(code){
	url = "/common/getLogisFeeReasonPop.do";
	openSearchPopup(url,"?st_reason_code=" + code, "600,180,no");
}

 //-->
</script> 
<body <%if ("".equals(result)) { %> onload="setQuery()"<%} %>>
	 <form name="catalogDetailDongbuPopMaster" id="catalogDetailDongbuPopMaster" method="post" >
	 <input type="hidden" name="codeGubun" id="codeGubun"  value="/wmco/masterWmCoGoodsCodePop"> 
	 <input type="hidden" name="BUYER_ITEM_NO" id="BUYER_ITEM_NO"  value="<%=CommonUtil.nvl((String) request.getParameter("BUYER_ITEM_NO"),"") %>"> 
	 <input type="hidden" name="BYIT_COMORG_CODE" id="BYIT_COMORG_CODE"  value="<%=CommonUtil.nvl((String) request.getParameter("BYIT_COMORG_CODE"),"") %>"> 
	 <input type="hidden" name="CONTRACT_NO" id="CONTRACT_NO"  value="<%=CommonUtil.nvl((String) request.getParameter("CONTRACT_NO"),"") %>"> 
	 <input type="hidden" name="CONTRACT_SEQ" id="CONTRACT_SEQ"  value="<%=CommonUtil.nvl((String) request.getParameter("CONTRACT_SEQ"),"") %>"> 
	<div id="popWrapper">
    	<div id="popHeader">
        	<h1 class="title">상품정보</h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/b_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
<%
if (_dataList==null || _dataList.size()==0){
%>
<%}else{ %>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<div class="scrollArea" style="height:210px">
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
                        <td rowspan="7" scope="col" class="center">
                        	<% if ("".equals(CommonUtil.nvl(rowData.get("IMGFILE_NAME")))){ %>
							<img src="/resources/images/icon_emptyimg.gif"" name = "image1" width="150" height="150">
									<input type="hidden" name="st_imgfile_dir" value="">
		                            <input type="hidden" name="st_imgfile_name" value="">
							<%}else{ %>
							<img src="<%=CommonUtil.realImgS3UploadPath+"/"+CommonUtil.nvl(rowData.get("IMGFILE_DIR"))+"/"+CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>" name = "image1" width="150" height="150">
									<input type="hidden" name="st_imgfile_dir"  value="<%=rowData.get("IMGFILE_DIR")%>">
                                    <input type="hidden" name="st_imgfile_name" value="<%=rowData.get("IMGFILE_NAME")%>">
							<%} %>
							<br><a href='javascript:getBigImage("<%=CommonUtil.realImgS3UploadPath+"/"+CommonUtil.nvl(rowData.get("IMGFILE_DIR"))+"/"+CommonUtil.nvl(rowData.get("IMGFILE_NAME"))%>","<%=rowData.get("IMGFILE_DIR")%>" , "<%=rowData.get("IMGFILE_NAME")%>"  )'><img src="/resources/images/zoom.gif" width="32" height="23" align="absmiddle" border="0"></a>
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
<%if(!com_type.equals("W")){%>
                      <td><%=CommonUtil.formatNumber(rowData.get("UNIT_PRICE"),true,0,3)%></td>
<%}else{%>					
                      <td></td>
<%}%>
                      <th scope="row">협력사</th>
                      <td><%=CommonUtil.nvl(rowData.get("AGENT_TEXT"))%></td>
                    </tr>
                    <tr>
                      <th scope="row">거래유형</th>
                      <td><%=CommonUtil.nvl(rowData.get("PROCESS_TYPE_NAME"))%></td>
                      <th scope="row">물류비(%)</th>
                      <td><a class="hyperLink" href="javascript:getLogisFeeReason('<%=CommonUtil.nvl(rowData.get("LOGIS_RATE_STATUS"))%>')"><%=CommonUtil.nvl(rowData.get("LOGISTICS_RATE"))%></a></td>
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
            </div>
<%} %>            
        </div>
    </div>
</form> 
</body>
</html>

