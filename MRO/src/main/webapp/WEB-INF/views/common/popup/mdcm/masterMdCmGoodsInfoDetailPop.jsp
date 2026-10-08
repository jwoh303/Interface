<%--
**********************************************
* 메뉴 : 
* 화면 : 품목정보상세 
* 기능 : 
* 프로그램 ID : PG_03_M_003_02
* 담당자 : 홍석규 ( 설계 : 권우재 )
* 착수일 : 2014-
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
<link rel="stylesheet" href="/resources/styles/master_layout.css" type="text/css" />
<script src="/resources/libs/jquery/js/jquery.min.js" type="text/javascript"></script>
<script src="/resources/libs/jquery/js/jquery-ui.min.js" type="text/javascript"></script>
<script src="/resources/js/kep_common.js"></script>
  
</head>
<%
@SuppressWarnings (value="unchecked")
List<Map<String,String>> _dataList = (List<Map<String,String>>) request.getAttribute("data"); // 조회된 결과(부품품목)
List<Map<String,String>> _dataList2 = (List<Map<String,String>>) request.getAttribute("data2"); // 조회된 결과(속성정보)
List<Map<String,String>> _dataList3 = (List<Map<String,String>>) request.getAttribute("data3"); // 조회된 결과(매핑정보)

Map<String,String> _rowData = null;
if (_dataList != null && _dataList.size() != 0) { 
	_rowData = _dataList.get(0);
}

SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
String com_code=  CommonUtil.nvl((String) request.getParameter("com_code"), _sessionInfo.getComCode());
String st_cms_categ_id   = CommonUtil.nvl((String) request.getParameter("st_cms_categ_id"),"");
String st_cms_catlg_id   = CommonUtil.nvl((String) request.getParameter("st_cms_catlg_id"),"");
%>

<script type="text/javascript">
<!--
function kep_onload_view() {
	<% if (_dataList == null ) { %>
		kepSearch();
	<% } else if (_dataList.size() == 0) { %>
		alert("품목 상세 정보가 없습니다.\n\n관리자에게 문의 하십시요.");
		self.close();
	<% }%>
}

function kepSearch()
{  
  $('#masterMdCmGoodsInfoDetailPop').attr("action", "/mdcm/getMasterMdCmGoodsInfoDetailPop.do").submit();    
}

function kepEnter() {	
	if (event.keyCode == 13) { 
		kepSearch();
	}
}

function setReturn(value1,value2)
{ 
  opener.setPopupReturn(value1,value2);
  this.close();
}

//단가변경이력 팝업
function setSysopCqepHistory(buyer,contractNo,contractSeq,buyerItemNo,site){ 
	openSearchPopup("/mdcm/showMasterMdCmUnitpriceAlterHistoryPop.do", '?st_buyer='+buyer+'&st_contract_no='+contractNo+'&st_contract_seq='+contractSeq+'&st_buyer_item_no='+buyerItemNo+'&st_site='+site, "840,250,no");
}

//최종발주일 보기 팝업
function getLastPoDate(site, buyer, buyer_item_no, contract_no, contract_seq){
	openSearchPopup("/mdcm/showMasterMdCmFinalOrderDateViewPop.do", '?st_buyer='+buyer+'&st_contract_no='+contract_no+'&st_contract_seq='+contract_seq+'&st_buyer_item_no='+buyer_item_no+'&st_site='+site, "840,250,no");
}

//팝업함수호출
function doPop(str) {
	switch (str) {
		case 	"fileUpload": //파일업로드
			var viewType="R";
			openSearchPopup("/common/fileUploadPop.do", "?DOC_NO="+$("#st_image_key").val()+"&TYPE=CMS&viewType="+viewType, "500,430,no");
			break;
	}
}

 //-->
</script> 
<body onload="kep_onload_view()">
<form name="masterMdCmGoodsInfoDetailPop" id="masterMdCmGoodsInfoDetailPop" method=post >
<input type="hidden" name="com_code" id="com_code"  value="<%=com_code%>">
<input type="hidden" name="st_cms_categ_id" id="st_cms_categ_id"  value="<%=st_cms_categ_id%>">
<input type="hidden" name="st_cms_catlg_id" id="st_cms_catlg_id"  value="<%=st_cms_catlg_id%>">
	
	<!--최소 가로길이 400px, 최소 세로길이 400px입니다 / 500*500-->
	<div id="popWrapper" style="height:695px;width:794px">
    	<div id="popHeader">
        	<h1 class="title">품목정보상세 </h1>
            <p class="popClose"><a href="javascript:self.close()"><img src="/resources/images/m_btn_popclose.gif" alt="닫기버튼" /></a></p>
        </div>
        <!--팝업내용입니다-->
        <div id="popContainer">
        	<div id="ContArea" style="width:768px;margin-left:0;" >
            <div class="scrollArea" style="height:620px">
            	<p style="font-weight:bold;">[부품품목]</P>
            	<% if (_rowData != null) {  %>
                <table  class="cont_t_list06"  style="width:100%">
                    <caption>부품품목</caption>
                    <colgroup>
	                    <col width="130px" />
	                    <col width="32%" />
	                    <col width="130px" />
	                    <col width="30%" />
	                </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row">카테고리</th>
                            <td colspan="3">
	                      		<%=CommonUtil.nvl(_rowData.get("CATEG_PATH"))%>
	                      	</td>
                        </tr>
                        
                        <tr>
                            <th scope="row">소싱그룹</th>
                            <td>
	                      		<%=CommonUtil.nvl(_rowData.get("SG_NAME"))%>
	                      	</td>
	                      	<th scope="row">등록일자</th>
                            <td>
	                      		<%=CommonUtil.formatStrinigDate(_rowData.get("CHANGE_DATE"))%>
	                      	</td>
                        </tr>
                        
                        <tr>
                            <th scope="row">품목코드</th>
                            <td>
	                      		<b><%=CommonUtil.nvl(_rowData.get("CMS_CATLG_ID"))%></b>&nbsp;&nbsp;&nbsp;<span><a class="btn_gray_04"  title="이미지보기" href="javascript:getCmsImgPop('<%=_rowData.get("IMG_NO") %>','<%=st_cms_catlg_id%>')">이미지보기</a></span>
	                      	</td>
	                      	<th scope="row">생성담당</th>
                            <td>
	                      		<%=CommonUtil.nvl(_rowData.get("ADD_USER_NAME"))%>
	                      	</td>
                        </tr>
                        
                        <tr>
                            <th scope="row">품목명(한글)</th>
                            <td colspan="3">
	                      		<%=CommonUtil.nvl(_rowData.get("DESCRIPTION_LOC"))%>
	                      	</td>
                      	</tr>
                      	
                      	<tr>
	                      	<th scope="row">품목명(영문)</th>
                            <td colspan="3">
	                      		<%=CommonUtil.nvl(_rowData.get("DESCRIPTION_ENG"))%>
	                      	</td>
                        </tr>
                        
                        <tr>
	                      	<th scope="row">규격</th>
                            <td colspan="3">
	                      		<%=CommonUtil.nvl(_rowData.get("SPECIFICATION"))%>
	                      	</td>
                        </tr>
                        
                         <tr>
                            <th scope="row">제조사</th>
                            <td>
	                      		<%=CommonUtil.nvl(_rowData.get("MAKER_NAME"))%>
	                      	</td>
	                      	<th scope="row">원산지</th>
                            <td>
	                      		<%=CommonUtil.nvl(_rowData.get("ORIGIN_NAME"))%>
	                      	</td>
                        </tr>
                        
                        <tr>
                            <th scope="row">표준단가/ 단위</th>
                            <td>
	                      		<%=CommonUtil.formatNumber(_rowData.get("CMS_PRICE"),true, 0, 3)%> / <%=CommonUtil.nvl(_rowData.get("ORDER_MEASURE"))%>
	                      	</td>
	                      	<th scope="row">표준단가 수정일</th>
                            <td>
	                      		<%=CommonUtil.formatStrinigDate(_rowData.get("CHANGE_DATE"))%>
	                      	</td>
                        </tr>
                        
                        <tr>
	                      	<th scope="row">첨부파일</th>
                            <td colspan="3">
                            <%
								if(_rowData.get("IMAGE_KEY").equals("N")) {
							%>
								<img src="/resources/images/disk_off.gif" name="CmsAtchImage" border="0">
                            	<input type="hidden" id="st_image_key"  name="st_image_key" value="">
							<%
								}else{
							%>
								<a href="javascript:doPop('fileUpload');">
								<img src="/resources/images/disk_on.gif" name="CmsAtchImage" border="0">
                            	<input type="hidden" id="st_image_key"  name="st_image_key" value="<%=_rowData.get("IMAGE_KEY")%>">
                            	</a>
							<%
								}
							%>
	                      	</td>
                        </tr>
                        
                        <tr>
                            <th scope="row">유통시너지여부</th>
                            <td>
	                      		<%=CommonUtil.nvl(_rowData.get("KWAY_SYNERGY_FLAG"))%>
	                      	</td>
	                      	<th scope="row">유통취급여부</th>
                            <td>
	                      		<%=CommonUtil.nvl(_rowData.get("KWAY_HANDLING_FLAG"))%>
	                      	</td>
                        </tr>
                    </tbody>
                </table> 
                <% }%>
                
                <p class="pt20" style="font-weight:bold;">[속성정보]</P>
                <table  class="cont_t_list06"  style="width:100%">
                    <caption>속성정보</caption>
                    <colgroup>
	                    <col width="120px" />
	                    <col width="32%" />
	                    <col width="120px" />
	                    <col width="30%" />
	                </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row" class="center">속성정보</th>
                            <th scope="row" class="center">속성값</th>
                            <th scope="row" class="center">속성항목</th>
                            <th scope="row" class="center">속성값</th>
                        </tr>
<%
if (_dataList2 == null || _dataList2.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="4" align="center" height = "280">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
	int rec_cnt = _dataList2.size();
	for (int j=0; j<rec_cnt; j++) {
		Map<String,String> _rowData2 = _dataList2.get(j);
		
		if((j%2)==0){
			if(rec_cnt-1 == j ){
%>                         
                        <tr>
                            <th scope="row"><%=CommonUtil.nvl(_rowData2.get("CMSCATTR_ATTB_NM"))%></th>
                            <td colspan="3">
	                      		<%=CommonUtil.nvl(_rowData2.get("CMSCATLG_ATTB_NM"))%>
	                      	</td>
                        </tr>
			<%}else{%>
						<tr>
                            <th scope="row"><%=CommonUtil.nvl(_rowData2.get("CMSCATTR_ATTB_NM"))%></th>
                            <td>
	                      		<%=CommonUtil.nvl(_rowData2.get("CMSCATLG_ATTB_NM"))%>
	                      	</td>
			<%}
		}else{
			%>			
							<th scope="row"><%=CommonUtil.nvl(_rowData2.get("CMSCATTR_ATTB_NM"))%></th>
                            <td>
	                      		<%=CommonUtil.nvl(_rowData2.get("CMSCATLG_ATTB_NM"))%>
	                      	</td>
						</tr>
		<%}%>
	<%}%>
<%}%>
					</tbody>
                </table> 
				
				<p class="pt20"><b>[매핑정보]</b>&nbsp;&nbsp; &nbsp;<img src="/resources/images/icon_g.gif" border="0"> 완전매핑, <img src="/resources/images/icon_y.gif" border="0"> 참조매핑</P>
				
				<table  class="cont_t_list06"  style="width:100%">
                    <caption>매핑정보</caption>
                    <colgroup>
	                    <col width="130px" />
	                    <col width="20%" />
	                    <col width="60px" />
	                    <col width="12%" />
	                    <col width="90px" />
	                    <col width="20%" />
	                </colgroup>
                    <tbody>
<%
if (_dataList3 == null || _dataList3.size() == 0){
%>
               		<tr bgcolor="#FFFFFF">
                        <td colspan="6" align="center" height = "280">
                        <span class="font1">조회된 데이타가 없습니다.</span>
                        </td> 
                    </tr>
<%}else{
	for (int i=0; i<_dataList3.size(); i++) {
		Map<String,String> _rowData3 = _dataList3.get(i);
%>                    
                        <tr>
                            <th scope="row">고객사</th>
                            <td colspan="3">
	                      		<%=CommonUtil.nvl(_rowData3.get("BUYER_NAME"))%>
	                      	</td>
	                      	<th scope="row">담당자</th>
	                      	<td>
	                      		<%=CommonUtil.nvl(_rowData3.get("MANAGER"))%>
	                      	</td>
                        </tr> 
                        <tr>
                            <th scope="row">품목코드</th>
                            <td>
                            	<b><%=CommonUtil.nvl(_rowData3.get("BUYER_ITEM_NO"))%></b>&nbsp;&nbsp;
                            	<%if(CommonUtil.nvl(_rowData3.get("REFER_MAPPING_FLAG")).equals("N")){%>
									<img src="/resources/images/icon_g.gif" border="0">
								<%}else{%>
									<img src="/resources/images/icon_y.gif" border="0">
								<%}%>
	                      		
	                      	</td>
	                      	<th scope="row">품목명</th>
	                      	<td colspan="3">
	                      		<%=CommonUtil.nvl(_rowData3.get("DESCRIPTION_LOC"))%>
	                      	</td>
                        </tr> 
                        <tr>
	                      	<th scope="row">규격</th>
	                      	<td colspan="5">
	                      		<%=CommonUtil.nvl(_rowData3.get("SPECIFICATION"))%>
	                      	</td>
                        </tr> 
                        <tr>
	                      	<th scope="row">단위</th>
	                      	<td>
	                      		<%=CommonUtil.nvl(_rowData3.get("UNIT_MEASURE"))%>
	                      	</td>
	                      	<th scope="row">매출단가</th>
	                      	<td class="right">
	                      		<a class="hyperLink" href="javascript:setSysopCqepHistory('<%=_rowData3.get("BUYER")%>','<%=_rowData3.get("CONTRACT_NO")%>','<%=_rowData3.get("CONTRACT_SEQ")%>','<%=_rowData3.get("BUYER_ITEM_NO")%>','<%=_rowData3.get("GBN")%>')"><%=CommonUtil.formatNumber(_rowData3.get("TARGET_PRICE"),true,0,3)%></a>
	                      	</td>
	                      	<th scope="row">매입단가</th>
	                      	<td class="right">
	                      		<a class="hyperLink" href="javascript:setSysopCqepHistory('<%=_rowData3.get("BUYER")%>','<%=_rowData3.get("CONTRACT_NO")%>','<%=_rowData3.get("CONTRACT_SEQ")%>','<%=_rowData3.get("BUYER_ITEM_NO")%>','<%=_rowData3.get("GBN")%>')"><%=CommonUtil.formatNumber(_rowData3.get("LIST_PRICE"),true,0,3)%></a>
	                      	</td>
                        </tr> 
                        <tr>
	                      	<th scope="row">조달일수</th>
	                      	<td colspan="3">
	                      		<%=CommonUtil.nvl(_rowData3.get("DELIVERY_LT"))%>
	                      	</td>
	                      	<th scope="row">매입단가 수정일</th>
	                      	<td>
	                      		<%=CommonUtil.formatStrinigDate(_rowData3.get("CHANGE_DATE"))%>
	                      	</td>
                        </tr> 
                        <tr>
	                      	<th scope="row">입고완료된 최종발주일</th>
	                      	<td>
	                      		<%if(_rowData3.get("GBN").equals("KA")){%>
								<a class="hyperLink" href="javascript:getLastPoDate('<%=_rowData3.get("GBN")%>','<%=_rowData3.get("BUYER")%>','<%=_rowData3.get("BUYER_ITEM_NO")%>','<%=_rowData3.get("CONTRACT_NO")%>','<%=_rowData3.get("CONTRACT_SEQ")%>')">[최종발주일 보기]</a>
								<%}%>
	                      	</td>
	                      	<th scope="row">협력사</th>
	                      	<td>
	                      		<a class="hyperLink" href="javascript:openSearchPopup('/mdcp/showMasterMdCpCompyDetailViewPop.do', '?com_code=<%=_rowData3.get("AGENT")%>', '800,600,no');"><%=CommonUtil.nvl(_rowData3.get("AGENT_NAME"))%></a>
	                      	</td>
	                      	<th scope="row">배송가능지역</th>
	                      	<td>
	                      		<%=CommonUtil.nvl(_rowData3.get("LOCATION"))%>
	                      	</td>
                        </tr>
                        <%if(_dataList3.size()-1 != i){%>
						<tr>
							<td colspan="6" >&nbsp;</td>
						</tr>
						<%}%>
	<%}%> 
<%}%>
					</tbody>
				</table>
                
        </div>
    </div>        
</div>
</div>
</form> 
</body>
</html>
